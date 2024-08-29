#ifndef SHELLCODE2_CSAW_UTIL_H
#define SHELLCODE2_CSAW_UTIL_H

#include <Windows.h>

struct Oracle {
    HMODULE(WINAPI* _GetModHandleA)(LPCSTR);
    LPVOID(WINAPI* _VirtualAlloc)(LPVOID lpAddress, SIZE_T dwSize, DWORD  flAllocationType, DWORD  flProtect);
    BOOL(WINAPI* _VirtualFree)(LPVOID lpAddress, SIZE_T dwSize, DWORD  dwFreeType);
    BOOL(WINAPI* _VirtualProtect)(LPVOID, SIZE_T, DWORD, PDWORD);
    void(WINAPI* _ExitProcess)(UINT uExitCode);
    HANDLE(WINAPI* _CreateEventW)(LPSECURITY_ATTRIBUTES, BOOL, BOOL, LPCWSTR);
    DWORD(WINAPI* _GetModuleFileNameW)(HMODULE, LPWSTR, DWORD);
    DWORD(WINAPI* _GetCurrentProcessId)();
    BOOL(WINAPI* _CreateProcessW)(LPCWSTR, LPWSTR, LPSECURITY_ATTRIBUTES, LPSECURITY_ATTRIBUTES, BOOL, DWORD, LPVOID, LPCWSTR, LPSTARTUPINFOW, LPPROCESS_INFORMATION lpProcessInformation);
    DWORD (WINAPI* _WaitForSingleObject)(HANDLE, DWORD);
    BOOL (WINAPI* _CloseHandle)(HANDLE);
    HMODULE CurrentMod;
    SYSTEM_INFO sSysInfo;
    char * key;
};

#endif