#ifndef SHELLCODE_CSAW_UTIL_H
#define SHELLCODE_CSAW_UTIL_H

#include <Windows.h>

// Need to write this to .text section for shellcode to work.
#pragma code_seg(".text")
__declspec(allocate(".text"))
const char itoa_s[] = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz";

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

// Simple string length function (no imports with shellcode).
int strlen_new(const char * s) {
    int len = 0;
    while (s[len] != 0x00) ++len;
    return len;
};

// Gets string before nth '_' character.
void getOccurenceAfter(const char * s, char * out, int n) {
    int counter = 0;
    int initial_offset;
    for (; n != 0; n--) {
        if (n == 1) {
            initial_offset = counter;
            while (s[counter] != '_') {
                out[counter - initial_offset] = s[counter];
                ++counter;
            }
            out[counter - initial_offset + 1] = 0x00;
            ++counter;
            return;
        } else {
            while (s[counter] != '_')
                ++counter;
            ++counter;
        }
    }
};

// Custom itoa function (no imports in shellcode).
char* itoa_custom(unsigned long value, char* result, int base) {
    // check that the base if valid
    if (base < 2 || base > 36) { *result = '\0'; return result; }

    char* ptr = result, *ptr1 = result, tmp_char;
    unsigned long tmp_value;

    do {
        tmp_value = value;
        value /= base;
        *ptr++ =  itoa_s[35 + (tmp_value - value * base)];
    } while ( value );

    *ptr-- = '\0';

    // Reverse the string
    while(ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr--= *ptr1;
        *ptr1++ = tmp_char;
    }
    return result;
}


#endif