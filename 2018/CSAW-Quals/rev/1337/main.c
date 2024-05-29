#include <Windows.h>
#include <winnt.h>
#include <Psapi.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

#include "resource.h"
//#define BEING_DEBUGGED

#define DllExport   __declspec( dllexport )  

#define CURRENT_PROCESS ((HANDLE)(-1))

#define H1(s,i,x)   (x*65599u+(uint8_t)s[(i)<strlen(s)?strlen(s)-1-(i):strlen(s)])
#define H4(s,i,x)   H1(s,i,H1(s,i+1,H1(s,i+2,H1(s,i+3,x)))) 
#define H16(s,i,x)  H4(s,i,H4(s,i+4,H4(s,i+8,H4(s,i+12,x))))

#define H64(s,i,x)  H16(s,i,H16(s,i+16,H16(s,i+32,H16(s,i+48,x))))
#define H256(s,i,x) H64(s,i,H64(s,i+64,H64(s,i+128,H64(s,i+192,x))))

#define HASH(s)    ((uint32_t)(H256(s,0,0)^(H256(s,0,0)>>16)))
#define ResolveRVA(base,rva) (( (BYTE*)base) + rva)
#pragma optimize( "", off )
#define MZ_ZEVEL ("\x4D\x5A\x90\x00\x03\x00\x00\x00\x04\x00\x00\x00\xFF\xFF")
#define SETUP_SEH(H) __asm \
{         \
__asm mov esi, H \
__asm push esi \
__asm push dword ptr fs : [0] \
__asm mov dword ptr fs : [0], esp \
}

#define REMOVE_SEH __asm \
{         \
__asm pop dword ptr fs:[0] \
__asm add esp, 4 \
}

volatile unsigned int g_zevel = 0;
volatile unsigned int g_zevel2 = 0;
volatile unsigned int g_memcpy = 0;
volatile unsigned int g_memcmp = 0;
#define ZEVEL     __asm \
{                       \
__asm pushfd            \
__asm pushad            \
__asm mov eax, ebx      \
__asm mov g_zevel, eax  \
__asm call $+5          \
__asm pop eax           \
__asm add eax, 6        \
__asm push eax          \
__asm ret               \
__asm mov g_zevel, ecx  \
__asm popad             \
__asm popfd             \
}

#define NOPS4 __asm       \
{                         \
__asm nop                 \
__asm nop                 \
__asm nop                 \
__asm nop                 \
}

#define NOPS16 \
NOPS4          \
NOPS4          \
NOPS4          \
NOPS4          

#define NOPS64  \
NOPS16          \
NOPS16          \
NOPS16          \
NOPS16    

#define NOP_ZEVEL   __asm     \
{                             \
__asm pushfd                  \
__asm pushad                  \
__asm nop                     \
__asm mov edi, ecx            \
__asm mov ebx, 0x7d229fd8     \
__asm mov edx, eax            \
__asm mov eax, g_zevel2       \
__asm sub ecx, edi            \
__asm jne $ + 5               \
__asm sub ecx, edi            \
__asm mov eax, edx            \
}                             \
NOPS64                        \
__asm {                       \
__asm nop                     \
__asm mov eax, ecx            \
}                             \
NOPS64                        \
NOPS64                        \
NOPS64                        \
NOPS64                        \
__asm {                       \
__asm mov ebx, eax            \
__asm nop                     \
__asm popad                   \
__asm popfd                   \
}

#define MEGA_ZEVEL __asm \
{                        \
__asm pushfd             \
__asm pushad             \
}                        \
NOP_ZEVEL                \
NOP_ZEVEL                \
ZEVEL                    \
NOP_ZEVEL                \
ZEVEL                    \
NOP_ZEVEL                \
ZEVEL                    \
NOP_ZEVEL                \
__asm {                  \
__asm popad              \
__asm popfd              \
}

#pragma optimize( "", on)

#define KERNEL32DLL_CRC32 (0x6ae69f02)
#define USER32DLL_CRC32   (0x02489aab)
#define DBGHELPDLL_CRC32 (0xb88129fd)

typedef int (WINAPI* MessageBoxFuncPtr)(HWND, LPCTSTR, LPCTSTR, UINT);
typedef BOOL (WINAPI* TerminateProcessFuncPtr)(HANDLE, UINT);
typedef VOID(WINAPI* ExitProcessFuncPtr)(UINT);
typedef HANDLE (WINAPI* CreateThreadFuncPtr)(LPSECURITY_ATTRIBUTES, SIZE_T, LPTHREAD_START_ROUTINE, LPVOID, DWORD, LPDWORD);
typedef BOOL (WINAPI* IsDebuggerPresentFuncPtr)();
typedef DWORD (WINAPI* WaitForSingleObjectFuncPtr) (HANDLE, DWORD);
typedef HMODULE (WINAPI* LoadLibraryExFuncPtr)(LPCTSTR, HANDLE, DWORD);
typedef HMODULE (WINAPI* LoadLibraryFuncPtr)(LPCTSTR);
typedef FARPROC (WINAPI* GetProcAddressFuncPtr)(HMODULE, LPCSTR);
typedef BOOL (WINAPI* FreeLibraryFuncPtr)(HMODULE);
typedef BOOL(WINAPI* EnumProcessModulesFuncPtr)(HANDLE, HMODULE, DWORD, LPDWORD);
typedef DWORD (WINAPI* GetModuleFileNameExAFuncPtr)(HANDLE, HMODULE, LPTSTR, DWORD);
typedef LPVOID (WINAPI* OutputDebugStringAFuncPtr)(LPCTSTR);
typedef BOOL (WINAPI* EnumDesktopWindowsFuncPtr)(HDESK, WNDENUMPROC, LPARAM);
typedef INT(WINAPI* GetWindowTextFuncPtr)(HWND, LPTSTR, int);
typedef VOID(WINAPI *SleepFuncPtr) (DWORD);
typedef DWORD (WINAPI* GetCurrentProcessIdFuncPtr)(VOID);
typedef HANDLE (WINAPI* OpenProcessFuncPtr)(DWORD, BOOL, DWORD);

DWORD loadLibraryExAAddr = 0xc00ffee;
DWORD loadLibraryAddr = 0x15;
DWORD getProcAddressAddr = 0x900d;
DWORD freeLibraryAddr = 0x4;
DWORD enumProcessModulesAddr = 0xall;
DWORD getModuleFileNameExAAddr = 0xe0f;

ExitProcessFuncPtr exitProcess;
GetWindowTextFuncPtr getWindowTextA;
SleepFuncPtr sleep;
EnumDesktopWindowsFuncPtr enumDesktopWindows;

TCHAR g_stringFromRes[MAX_PATH] = { 0 };
DWORD g_LoadStringAddress = 0; 
DWORD g_GetModuleHandle = 0; 

typedef int(WINAPI *loadStringAPtr)(HINSTANCE, UINT, LPSTR, int);
typedef HMODULE (WINAPI* getModuleHandleAPtr)(LPCSTR);

inline const TCHAR* loadStringFromResWithXorKey(CHAR stringId, CHAR xorKey) {
	memset(g_stringFromRes, 0, MAX_PATH);
	loadStringAPtr loadStringA = (loadStringAPtr)(g_LoadStringAddress - 0x34);
	getModuleHandleAPtr moduleHandleA = (getModuleHandleAPtr)(g_GetModuleHandle + 0x133);
	loadStringA(moduleHandleA(NULL), stringId, g_stringFromRes, MAX_PATH / sizeof(TCHAR));
	TCHAR* resStr = _strdup(g_stringFromRes);
	for (int i = 0; i < strlen(resStr); ++i) {
		resStr[i] ^= xorKey;
	}
	return resStr;
}

inline const TCHAR* loadStringFromRes(CHAR stringId) {
	return loadStringFromResWithXorKey(stringId, stringId);
}

inline loadPwdFromResource(CHAR resId, uint64_t size) {
	TCHAR* res = (TCHAR*)loadStringFromResWithXorKey(resId, 0);
	for (int i = 0; i < size; ++i) {
		if (res[i] == '-') {
			res[i] = 0;
		}
	}
	return res;
}

// From: http://home.thep.lu.se/~bjorn/crc/
uint32_t crc32_for_byte(uint32_t r) {
	for (int j = 0; j < 8; ++j)
		r = (r & 1 ? 0 : (uint32_t)0xEDB88320L) ^ r >> 1;
	return r ^ (uint32_t)0xFF000000L;
}

uint32_t crc32(const uint8_t*data, size_t n_bytes) {
	uint32_t crc = 0;
	static uint32_t table[0x100];
	if (!*table)
		for (size_t i = 0; i < 0x100; ++i)
			table[i] = crc32_for_byte(i);
	for (size_t i = 0; i < n_bytes; ++i)
		crc = table[((uint8_t)crc) ^ ((uint8_t*)data)[i]] ^ crc >> 8;
	return crc;
}

inline DWORD __stdcall getFuncAddrByCRC32(uint32_t functionHash) {
	HMODULE hModule = (HMODULE)0x00400000; // GetModuleHandle(NULL);
	if (NULL == hModule) {
		return -1;
	}
	PIMAGE_DOS_HEADER pImgDosHeaders = (PIMAGE_DOS_HEADER)hModule;
	if (pImgDosHeaders->e_magic != IMAGE_DOS_SIGNATURE) {
		return -1;
	}
	PIMAGE_NT_HEADERS pImgNTHeaders = (PIMAGE_NT_HEADERS)((LPBYTE)pImgDosHeaders + pImgDosHeaders->e_lfanew);
	PIMAGE_IMPORT_DESCRIPTOR pImgImportDesc = (PIMAGE_IMPORT_DESCRIPTOR)((LPBYTE)pImgDosHeaders + pImgNTHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress);
	if (NULL == pImgImportDesc) {
		return -1;
	}
	for (IMAGE_IMPORT_DESCRIPTOR *iid = pImgImportDesc; iid->Name; iid++) {
		PIMAGE_THUNK_DATA pOriginalThunk = (PIMAGE_THUNK_DATA)ResolveRVA(hModule, iid->OriginalFirstThunk);
		if (!pOriginalThunk) {
			continue;
		}
		for (PIMAGE_THUNK_DATA pThunk = (PIMAGE_THUNK_DATA)ResolveRVA(hModule, iid->FirstThunk);
			0 != pOriginalThunk->u1.Function;
			pOriginalThunk++, pThunk++) {
			if (IMAGE_SNAP_BY_ORDINAL(pOriginalThunk->u1.Ordinal)) {
				continue;
			}
			PIMAGE_IMPORT_BY_NAME pImImport = (PIMAGE_IMPORT_BY_NAME)ResolveRVA(hModule, pOriginalThunk->u1.AddressOfData);
			uint32_t functionNameCRC32 = crc32(pImImport->Name, strlen(pImImport->Name));
			if (functionNameCRC32 == functionHash) {
				return pThunk->u1.Function;
			}
		}
	}
	return -1;
}

#pragma optimize( "", off )
VOID WINAPI initAllBaseFunctionsAddrs(PVOID DllHandle, DWORD Reason, PVOID Reserved) {
	static BOOL alreadyBeenInTls = 0;
	if (((DLL_PROCESS_ATTACH == Reason) || (DLL_THREAD_ATTACH == Reason)) && (!alreadyBeenInTls)) {
		alreadyBeenInTls = 1;
		loadLibraryExAAddr = getFuncAddrByCRC32(0x9b102e2d);
		loadLibraryAddr = getFuncAddrByCRC32(0x3fc1bd8d);  // hash of loadLibraryAddr
		__asm {
			rdtsc;
			test eax, eax
			jnz foo
			baz:
			sub esp, 0x559
				mov eax, ebx
				mov edx, ebx
				mov ecx, ebx
				xor edx, eax
				ror eax, 3
				xor eax, ebx
				in eax, 0x59
			mov ecx, esp
			loop baz
			foo:
		}
		getProcAddressAddr = getFuncAddrByCRC32(0xc97c1fff);
		ZEVEL
		enumProcessModulesAddr = getFuncAddrByCRC32(0x465b1b6b); // hash of K32EnumProcessModules
		MEGA_ZEVEL
		getModuleFileNameExAAddr = getFuncAddrByCRC32(0x0328745b); // hash of K32GetModuleFileNameExA
		NOP_ZEVEL
		__asm {
			call $+5;
			pop eax;
			push bar;
			ret;
		bar:
		}
		freeLibraryAddr = getFuncAddrByCRC32(0xda68238f);
	}
	g_LoadStringAddress = (DWORD)(&LoadString) + 0x34;
	g_GetModuleHandle = (DWORD)(&GetModuleHandle) - 0x133;
}

#pragma optimize( "", on ) 
#ifdef _WIN64
#pragma comment (linker, "/INCLUDE:_tls_used")
#pragma comment (linker, "/INCLUDE:tls_callback_func")
#else
#pragma comment (linker, "/INCLUDE:__tls_used") 
#pragma comment (linker, "/INCLUDE:_tls_callback_func")
#endif
#ifdef _WIN64
#pragma const_seg(".CRT$XLF")
EXTERN_C const
#else
#pragma data_seg(".CRT$XLF")
EXTERN_C
#endif
PIMAGE_TLS_CALLBACK tls_callback_func = initAllBaseFunctionsAddrs;
#ifdef _WIN64
#pragma const_seg()
#else
#pragma data_seg()
#endif //_WIN64

HMODULE hMods[1024];
BOOL getModuleNameByHash(unsigned int libNameCRC32, TCHAR* libName) {
	unsigned int i;
	unsigned int j;
	DWORD cbNeeded;
	if (((EnumProcessModulesFuncPtr)enumProcessModulesAddr)(CURRENT_PROCESS, (HMODULE)hMods, sizeof(hMods), &cbNeeded)) {
		for (i = 0; i < (cbNeeded / sizeof(HMODULE)); i++) {
			TCHAR szModName[MAX_PATH] = { 0 };
			
			if (((GetModuleFileNameExAFuncPtr)getModuleFileNameExAAddr)(CURRENT_PROCESS, hMods[i], szModName, sizeof(szModName) / sizeof(TCHAR))) {
				TCHAR* modName = szModName;
				if (strstr(modName, "\\")) {
					for (modName = modName + strlen(szModName) - 1; modName[0] != '\\'; --modName) {} // getting the nonfullpath
					++modName;
				}
				for (j = 0; j < strlen(modName); ++j) { // to lower
					if ((modName[j] < 0x61) && (modName[j] >= 0x41)) {
						modName[j] += 32;
					}
				}
				if (libNameCRC32 == crc32(modName, strlen(modName))) {
					strcpy_s(libName, MAX_PATH, modName);
					return 1;
				}
			}
		}
	} 
	return 0;
}

LPVOID getProcAddrByHash(unsigned int libNameCRC32, unsigned int funcHash) {
	unsigned int i;
	TCHAR libName[MAX_PATH] = { 0 };
	if (!getModuleNameByHash(libNameCRC32, libName)) {
		return 0;
	}
	HMODULE lib = ((LoadLibraryExFuncPtr)loadLibraryExAAddr)(libName, NULL, LOAD_LIBRARY_AS_DATAFILE);
	if (!lib) {
		return 0;
	}
	if (((PIMAGE_DOS_HEADER)lib)->e_magic != IMAGE_DOS_SIGNATURE) {
		return 0;
	}
	PIMAGE_NT_HEADERS header = (PIMAGE_NT_HEADERS)((BYTE *)lib + ((PIMAGE_DOS_HEADER)lib)->e_lfanew);
	if (header->Signature != IMAGE_NT_SIGNATURE) {
		return 0;
	}
	if (header->OptionalHeader.NumberOfRvaAndSizes <= 0) {
		return 0;
	}
	PIMAGE_EXPORT_DIRECTORY exports = (PIMAGE_EXPORT_DIRECTORY)((BYTE *)lib + header->
		OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
	if (exports->AddressOfNames == 0) {
		return 0;
	}
	BYTE** names = (BYTE**)((int)lib + exports->AddressOfNames);
	for (i = 0; i < exports->NumberOfNames; i++) {
		char* funcName = (CHAR*)((BYTE *)lib + (int)names[i]);
		if (funcHash == HASH(funcName)) {
			((FreeLibraryFuncPtr)freeLibraryAddr)(lib);
			lib = ((LoadLibraryFuncPtr)loadLibraryAddr)(libName);
			return ((GetProcAddressFuncPtr)getProcAddressAddr)(lib, funcName);
		}
	}
	return 0;
}

#pragma optimize( "", off )
int *nullpointer = 0;
EXCEPTION_DISPOSITION __cdecl exceptionHandlerForEnumWindowThread(
	EXCEPTION_RECORD *ExcRecord,
	void * EstablisherFrame,
	CONTEXT *ContextRecord,
	void * DispatcherContext) {
	exitProcess(0);
	return 1;
}
#pragma optimize( "", on)

BOOL CALLBACK enumWindowsProc(
	__in  HWND hWnd,
	__in  LPARAM lParam) {
	return 1;
	SETUP_SEH(exceptionHandlerForEnumWindowThread);
	TCHAR buffer[MAX_PATH] = { 0 };
	int res_getWindowTextA = getWindowTextA(hWnd, buffer, MAX_PATH);
	if (0 == res_getWindowTextA) {
		goto cleanup;
	}
	unsigned int i;
	for (i = 0; i < strlen(buffer); ++i) { // to lower
		if ((buffer[i] < 0x61) && (buffer[i] >= 0x41)) {
			buffer[i] += 32;
		}
	}
	BYTE ollydbg[] = { 'o', 0x90, 'l', 0x22, 'l', 0x42, 'y', 0x13, 'd', 0x37, 'b' };
	BYTE windbg[] = { 'w', 0x22, 'i', 0x32, 'n', 0x56, 'd', 0x91, 'b', 0x11, 'g'};
	BYTE debugger[] = { 'd', 0x22, 'e', 0x32, 'b', 0x56, 'u', 0x91, 'g', 0x99, 'g', 0x98, 'e', 0x33, 'r' };
	BYTE immunity[] = { 'i', 0x22, 'm', 0x32, 'm', 0x56, 'u', 0x91, 'n', 0x11, 'i', 0x44, 't', 0x99, 'y' };
	int j;
	for (i = 0; i < strlen(buffer); ++i) {
		// ollydbg
		for (j = 0; i + (j >> 1) < strlen(buffer) && (j < sizeof(ollydbg)); j+=2) {
			if (buffer[i+(j >> 1)] != ollydbg[j]) {
				break;
			}
		}
		if (j-1 == sizeof(ollydbg)) {
			*nullpointer = 0;
		}

		// windbg
		for (j = 0; i + (j >> 1) < strlen(buffer) && (j < sizeof(windbg)); j += 2) {
			if (buffer[i + (j >> 1)] != windbg[j]) {
				break;
			}
		}
		if (j - 1 == sizeof(windbg)) {
			*nullpointer = 1;
		}

		// debugger
		for (j = 0; i + (j >> 1) < strlen(buffer) && (j < sizeof(debugger)); j += 2) {
			if (buffer[i + (j >> 1)] != debugger[j]) {
				break;
			}
		}
		if (j - 1 == sizeof(debugger)) {
			*nullpointer = 2;
		}
		
		// immunity
		for (j = 0; i + (j >> 1) < strlen(buffer) && (j < sizeof(immunity)); j += 2) {
			if (buffer[i + (j >> 1)] != immunity[j]) {
				break;
			}
		}
		if (j - 1 == sizeof(immunity)) {
			*nullpointer = 3;
		}
	}
	cleanup:
	REMOVE_SEH
	return 1;
}

unsigned int cond = 0x7db654;

#pragma optimize( "", off )
DWORD WINAPI antiDebuggingThread_FindWindow(LPVOID lpParam) {
#ifndef BEING_DEBUGGED
	while (cond) {
		enumDesktopWindows(NULL, (WNDENUMPROC)enumWindowsProc, (LPARAM)NULL);
		ZEVEL
		sleep(1000);
	}
#endif // BEING_DEBUGGED
	return 1;
}

DWORD WINAPI antiDebuggingThread_FindClose(LPVOID lpParam) {
#ifndef BEING_DEBUGGED
	while (8) {
		WIN32_FIND_DATA ffd = { 0 };
		LARGE_INTEGER filesize = { 0 };
		TCHAR szDir[MAX_PATH] = { 0 };
		size_t length_of_arg = -1;
		HANDLE hFind = INVALID_HANDLE_VALUE;
		DWORD dwError = 0;
		hFind = FindFirstFile(lpParam, &ffd);
		do
		{
			if (!(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
				if (0x3141592 == crc32(ffd.cFileName, strlen(ffd.cFileName))) {
					g_zevel = getModuleNameByHash(0x3141592, szDir);
				} else {
					HASH(ffd.cFileName);
					__asm {
						lea eax, hFind
						test eax, eax
						setne ebx
						inc ebx
						mov g_zevel2, ebx
						jnz label333
					}
					if ((!g_zevel2) || (hFind == (DWORD)-1)) {
						g_zevel2 = getModuleNameByHash(lpParam, HASH("\x4a\x75\x7c\x7c\x69"));
					} else {
						++g_zevel2;
					}
					__asm {
						label333:
						xor ebx, ebx
						mov [eax], ebx
						mov eax, g_zevel2
						sbb eax, 5
					}
				}
			}
		} while (hFind && FindNextFile(hFind, &ffd) != 0);
		FindClose(hFind);
		Sleep(500);
	}
#endif // BEING_DEBUGGED
}
#pragma optimize( "", on )

DWORD WINAPI antiDebuggingThread(LPVOID lpParam) {
	TCHAR* outputDebugStringInput = loadStringFromRes(IDS_CRSH_OLLY);
	unsigned int continueRunning = 0b00101000;
	DWORD getModuleFileNameExAAddress = ((DWORD)&GetModuleFileNameExA) - 0x37;
	__asm {
		call foo;
		jmp bar;
	foo:
		pop eax;
		push eax;
		ret
			bar :
	}

	TCHAR* terminateProcessStr = loadStringFromRes(IDS_TERMINATEPROCESS);
	TerminateProcessFuncPtr terminateProcess = (TerminateProcessFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(terminateProcessStr));
	TCHAR* outputDebugStringAStr = loadStringFromRes(IDS_OUTPUTDEBUGSTRINGA);
	OutputDebugStringAFuncPtr outputDebugStringA = (OutputDebugStringAFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(outputDebugStringAStr));
	TCHAR* getCurrentProcessIdStr = loadStringFromRes(IDS_GETCURRENTPROCESSID);
	GetCurrentProcessIdFuncPtr getCurrentProcessId = (GetCurrentProcessIdFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(getCurrentProcessIdStr));
	TCHAR* openProcessStr = loadStringFromRes(IDS_OPENPROCESS);
	OpenProcessFuncPtr openProcess = (OpenProcessFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(openProcessStr));

	DWORD pid = getCurrentProcessId();
	HANDLE hnd = openProcess(SYNCHRONIZE | PROCESS_TERMINATE, TRUE, pid);
	IsDebuggerPresentFuncPtr isDebuggerPresent = (IsDebuggerPresentFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(loadStringFromRes(IDS_ISDEBUGGERPRESENT)));

	__asm {
		rdtsc
		or eax, edx
		test eax, eax
		jnz foobar
		mov eax, getModuleFileNameExAAddress
		add eax, 0x37
		foobar:
	}
#ifndef BEING_DEBUGGED
	while (continueRunning) {
		TCHAR dummy[MAX_PATH] = { 0 };
		(NULL, NULL, dummy, MAX_PATH);
		if (isDebuggerPresent()) {
			TCHAR nopeStr[5] = { 0 };
			nopeStr[3] = 'e';
			nopeStr[1] = 'o';
			MessageBoxFuncPtr messageBoxA = (MessageBoxFuncPtr)getProcAddrByHash(USER32DLL_CRC32, HASH(loadStringFromRes(IDS_MESSAGEBOXA)));
			NOP_ZEVEL
			__asm {
				rdtsc
				or eax, edx
				test eax, eax
				jnz foobar2
				call CreateThread;
				foobar2:
			}
			ZEVEL
			nopeStr[0] = 'N';
			nopeStr[2] = 'p';
			messageBoxA(NULL, nopeStr, nopeStr, MB_OK);
			terminateProcess(hnd, 0);
		}
		__asm {
			rdtsc
			mov ecx, eax
			mov edx, eax
			myloop:
				or edx, ecx
				shr ecx, 1
				loop myloop
			mov continueRunning, edx
		}
		__asm {
			push outputDebugStringInput
			call outputDebugStringA
			mov ebx, eax
			cmp outputDebugStringInput, ebx
			jnz ok
			push 0
			call exit
			ok:
		}
		if (getModuleNameByHash(DBGHELPDLL_CRC32, dummy)) { // dbghelp.dll
			exitProcess(0);
		}
	}
#endif // BEING_DEBUGGED
}

EXCEPTION_DISPOSITION __cdecl exceptionHandler(
	EXCEPTION_RECORD *ExcRecord,
	void * EstablisherFrame,
	CONTEXT *ContextRecord,
	void * DispatcherContext) {
	BOOL cond = 1;
	__asm {
		xor eax, eax
		cmp esp, 0x1000
		jb foo
		mov cond, eax // eax = 0
		jmp bar
		foo:
		add eax, 1
		mov cond, eax
		bar:
	}
	printf(loadStringFromRes(IDS_ENTER_PWD));
	TCHAR buffer[MAX_PATH] = { 0 };
	scanf_s("%12s", buffer, (unsigned)_countof(buffer));
	
	if (0x2477c != crc32(buffer, strlen(buffer)) && cond) {
		__asm {
			rdtsc
			mov ecx, eax
			foo123123 :
			loop foo123123
		}
	} else {
		printf(loadStringFromRes(IDS_FLAG), buffer);
	}
	_getch();
	exit(0);
}

//#pragma section("UPX0",execute, read, write)
//#pragma comment(linker,"/SECTION:UPX0,ERW")
#pragma code_seg("UPX0")
#pragma optimize( "", off )
void addFunctionsToImportTable() {
	__asm {
		push ebx
		push edx
		push LOAD_LIBRARY_AS_DATAFILE
		call LoadLibraryExA
		pop edx
		push eax
		push eax
		push ecx
		push ebp
		call EnumProcessModules
		pop esp
	}
}
#pragma optimize( "", on)
inline uint64_t encrypt(uint64_t a) {
	uint64_t b = a >> 62;
	uint64_t res = 1;
	uint64_t tmp = 5;
	a = (a << 2) >> 2;
	HASH("nagaram");
	while (a) {
		if (a & 1) {
			res *= tmp;
		}
		ZEVEL
		a >>= 1;
		tmp *= tmp;
	}
	return res - 1 + b;
}
inline uint64_t encrypt2(uint64_t a) {
	__asm {
		rdtsc
		test eax, eax
		jne foobar4567
		push addFunctionsToImportTable;
		call LoadLibraryA;
		foobar4567:
	}
	
	uint64_t res = encrypt(a);
	
	__asm {
		test eax, eax
		jnz foobar333
		mov eax, SwitchDesktop
		call eax
		foobar333:
	}
	return res;
}

//uint64_t decrypt(uint64_t r) {
//	uint64_t a = r << 62;
//	while (encrypt(a) != r) {
//		a ^= (encrypt(a) ^ r) >> 2;
//	}
//	return a;
//}

#define INPUT_STR_SIZE (24)

#pragma code_seg("UPX1")
#pragma optimize( "", off )
EXCEPTION_DISPOSITION __cdecl queryPasswordExceptionHandler(
	EXCEPTION_RECORD *ExcRecord,
	void * EstablisherFrame,
	CONTEXT *ContextRecord,
	void * DispatcherContext) {
	printf(loadStringFromRes(IDS_ENTER_PWD)); // password: 4.\/3ry.1337.|>45$vV0r|)
	TCHAR buffer[INPUT_STR_SIZE + 1] = { 0 };
	scanf_s("%24s", buffer, (unsigned)_countof(buffer));
	if ((((double)strlen(buffer)) / 3) < 2.6666666666667) {
		__asm call foo;
	}
	HASH(loadStringFromRes(IDS_SUSPENDTHREAD));
	__asm {
		cmp eax, 0x7d33933f
		jnz foo12355
		call LoadLibraryA
		foo12355:
	}
	unsigned int i;
	TCHAR encryptedBuffer[MAX_PATH] = { 0 };
	DWORD encryptedBufferAddress = (DWORD)&encryptedBuffer;
	TCHAR encryptedPassword[INPUT_STR_SIZE + 1] = { 0 };
	DWORD encryptedPasswordAddress = (DWORD)&encryptedPassword;
	for (i = 0; i < strlen(buffer) - 7; i += 8) {
		uint64_t a = 0;
		a = buffer[i];
		a |= buffer[i + 1] << 8;
		MEGA_ZEVEL
		a |= buffer[i + 2] << 16;
		g_zevel = HASH(loadStringFromRes(IDS_WRITEPROCESSMEMORY));
		a |= buffer[i + 3] << 24;
		a |= (uint64_t)buffer[i + 4] << 32;
		NOPS64
		a |= (uint64_t)buffer[i + 5] << 40;
		a |= (uint64_t)buffer[i + 6] << 48;
		HASH(MZ_ZEVEL);
		a |= (uint64_t)buffer[i + 7] << 56;
		uint64_t encryptedA = (i % 2) ? encrypt(a) : encrypt2(a);
		for (int k = 0; k < (a >> 58); ++k) {
			MEGA_ZEVEL
		}
		TCHAR tempBuffer[9] = { 0 };
		memcpy(tempBuffer, (TCHAR*)&encryptedA, sizeof(uint64_t));
		MEGA_ZEVEL
		switch (i % 7) {
			case 0:
				memcpy(encryptedPassword, loadPwdFromResource(IDS_MZ_XMM0, INPUT_STR_SIZE), INPUT_STR_SIZE);
				break;
			case 1:
				memcpy(encryptedPassword, loadPwdFromResource(IDS_MZ_XMM1, INPUT_STR_SIZE), INPUT_STR_SIZE);
				break;
			case 2: // MAX value of i is 16. 16 % 7 == 2. So we should get here and eventually execute 'case 3'
				memcpy(encryptedPassword, loadPwdFromResource(IDS_MZ_XMM2, INPUT_STR_SIZE), INPUT_STR_SIZE);
				// no break on purpose!
			case 3:
				memcpy(encryptedPassword, loadPwdFromResource(IDS_MZ_XMM3, INPUT_STR_SIZE), INPUT_STR_SIZE);
				break;
			default:
				memcpy(encryptedPassword, loadPwdFromResource(IDS_MZ_XMM2, INPUT_STR_SIZE), INPUT_STR_SIZE);
		}

		DWORD tempBufferAddress = (DWORD)&tempBuffer;
		__asm {
			push 8
			mov ebx, encryptedBufferAddress
			add ebx, i
			mov eax, g_memcpy
			push tempBufferAddress
			add eax, 0xf
			push ebx
			call eax
			pop ecx
			pop ecx
			pop ecx
		}
	}
	__asm {
		cmp esp, 0x1000
		ja ok
		call SwitchDesktop
		ok :
	}
	ZEVEL
	unsigned int passwordIsOk = &SwitchDesktop;
	for (i = 0; i < INPUT_STR_SIZE; ++i) {
		if (0 == (i % INPUT_STR_SIZE)) {
			__asm { // zero out passwordIsOk
				mov eax, passwordIsOk
				test eax, eax
				shr eax, 24
				setne eax
				dec eax
				mov passwordIsOk, eax
			}
			NOP_ZEVEL
		}
		TCHAR a = ((TCHAR*)encryptedPassword)[i];
		TCHAR b = ((TCHAR*)encryptedBuffer)[i];
		MEGA_ZEVEL
		DWORD charAAddr = &a;
		DWORD charBAddr = &b;
		__asm {
			mov eax, g_memcmp
			add eax, 0x13
			push 1
			push charAAddr
			push charBAddr
			call eax
			test eax, eax
			shl eax, 3
			sete eax
			mov ebx, passwordIsOk
			mov edx, i
			inc edx
			imul eax, edx
			add ebx, eax
			mov passwordIsOk, ebx
			pop ecx
			pop eax
		}
	}
	g_zevel = HASH(loadStringFromRes(IDS_WRITEPROCESSMEMORY));

	__asm {
		// sum of arithmetic series
		mov eax, INPUT_STR_SIZE
		inc eax
		mov ebx, INPUT_STR_SIZE
		shr ebx, 1 // div 2
		imul eax, ebx
		mov ecx, passwordIsOk
		cmp eax, ecx
		jnz foo
	}

	printf(loadStringFromRes(IDS_FLAG), buffer);
	__asm {
		foo:
	}
	exit(0);
	return 1;
}
#pragma optimize( "", on)

#pragma optimize( "", off)
int __cdecl main(int argc, char* argv[]) {
	DWORD memcpyAddress = &memcpy;
	TCHAR* pleaseEnterPassword = loadStringFromRes(IDS_ENTER_PWD);
	HASH(pleaseEnterPassword);
	SETUP_SEH(exceptionHandler);

	__asm {
		mov eax, memcpyAddress;
		sub eax, 0xf;
		mov g_memcpy, eax;
	}
	DWORD memcmpAddress = (DWORD)memcmp;
	TCHAR* waitForSingleObjectFuncStr = loadStringFromRes(IDS_WAITFORSINGLEOBJECT);
	DWORD waitForSingleObjectFuncHash = HASH(waitForSingleObjectFuncStr);
	WaitForSingleObjectFuncPtr waitForSingleObjectFunc = (WaitForSingleObjectFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, waitForSingleObjectFuncHash);
	TCHAR* createThreadStr = loadStringFromRes(IDS_CREATETHREAD);
	DWORD createThreadHash = HASH(createThreadStr);
	CreateThreadFuncPtr createThread = (CreateThreadFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, createThreadHash);
	TCHAR* sleepStr = loadStringFromRes(IDS_SLEEP);
	sleep = (SleepFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, HASH(sleepStr));
	TCHAR* exitProcessStr = loadStringFromRes(IDS_EXITPROCESS);
	NOP_ZEVEL
	HMODULE hThreadCheckDebuggerFindClose = createThread(NULL, 0x1000, antiDebuggingThread_FindClose, &exitProcessStr, 0, NULL);
	exitProcess = (ExitProcessFuncPtr)getProcAddrByHash(KERNEL32DLL_CRC32, exitProcessStr);
	TCHAR* user32DLLStr = loadStringFromRes(IDS_USER32DLL);
	HMODULE hUser32 = ((LoadLibraryFuncPtr)loadLibraryAddr)(user32DLLStr);
	TCHAR* toUnicodeExStr = loadStringFromRes(IDS_TOUNICODEEX);
	volatile register zevel1230 = (DWORD)GetProcAddress(hUser32, toUnicodeExStr);
	TCHAR* translateMessageStr = loadStringFromRes(IDS_TRANSLATEMESSAGE);
	GetProcAddress(hUser32, translateMessageStr);
	ZEVEL
	TCHAR* dispatchMessageStr = loadStringFromRes(IDS_DISPATCHMESSAGE);
	g_zevel2 = (DWORD)GetProcAddress(hUser32, dispatchMessageStr);
	TCHAR* enumDesktopWindowsStr = loadStringFromRes(IDS_ENUMDESKTOPWINDOWS);
	DWORD enumDesktopWindowsHash = HASH(enumDesktopWindowsStr);
	enumDesktopWindows = (EnumDesktopWindowsFuncPtr)getProcAddrByHash(USER32DLL_CRC32, enumDesktopWindowsHash);
	MEGA_ZEVEL
	TCHAR* getWindowTextAStr = loadStringFromRes(IDS_GETWINDOWTEXTA);
	DWORD getWindowTextHash = HASH(getWindowTextAStr);
	getWindowTextA = (GetWindowTextFuncPtr)getProcAddrByHash(USER32DLL_CRC32, getWindowTextHash);
	HANDLE hThreadCheckDebugger = createThread(NULL, 0, antiDebuggingThread, NULL, 0, NULL);
	ZEVEL
	HANDLE hThreadFindWindow = createThread(NULL, 0, antiDebuggingThread_FindWindow, NULL, 0, NULL);

	__asm {
		mov eax, memcmpAddress;
		sub eax, 0x13;
		mov g_memcmp, eax;
	}

	__asm {
		rdtsc
		cmp esp, 0x1000
		ja baz
		call EnumDesktopWindows
		baz:
		and eax, 0xff
	}

	REMOVE_SEH
	SETUP_SEH(queryPasswordExceptionHandler);
	ZEVEL
	__asm {
		push 0
		push FILE_FLAG_OVERLAPPED
		push OPEN_EXISTING
		push 0
		push 0
		push GENERIC_READ | GENERIC_WRITE
		push eax
		call CreateFileA
	}

	waitForSingleObjectFunc(hThreadCheckDebugger, INFINITE);
	MEGA_ZEVEL
	waitForSingleObjectFunc(hThreadFindWindow, INFINITE);
	
	addFunctionsToImportTable();
	REMOVE_SEH
	waitForSingleObjectFunc(hThreadCheckDebuggerFindClose, INFINITE);
	return 0;
}
#pragma optimize( "", on)