#include <Windows.h>
#include "peb.h"
#include "util.h"

#pragma code_seg(".text")

// Functions being resolved:
//      - KERNEL32.DLL
//          - GetModuleHandleA
//          - GetEnvironmentVariableA

__declspec(allocate(".text"))
int kernel32_dll_name[] = {4800, 4416, 5248, 4992, 4416, 4864, 3264, 3200, 2944, 4352, 4864, 4864, 00};
__declspec(allocate(".text"))
int get_mod_handle[] = {4544, 6464, 7424, 4928, 7104, 6400, 7488, 6912, 6464, 4608, 6208, 7040, 6400, 6912, 6464, 4160,00};
__declspec(allocate(".text"))
int get_env_variable[] = {4544, 6464, 7424, 4416, 7040, 7552, 6720, 7296, 7104, 7040, 6976, 6464, 7040, 7424, 5504, 6208,7296, 6720, 6208, 6272, 6912, 6464, 4160, 0x00};
__declspec(allocate(".text"))

// Environment variable name.
const char env_lookup[] = "UNLOCK_ME";


int weird_hash(char * e, int position) {
    if (e[position + 1] == 0) {
        return (e[position] + e[position - 1]);
    } else {
        return (e[position] + e[position + 1]);
    }
}

int check_env_var(char * e) {
    //    Required env var name - AyeCdC
    // A is known
    if (e[0] != 'A')
        return 1;
    // C == C is known
    if (weird_hash(e, 3) != weird_hash(e, 5))
        return 1;
    // y is known
    if (weird_hash(e, 0) != 0xBA)
        return 1;
    // e is known
    if (weird_hash(e, 1) - 0x65 != e[1])
        return 1;
    // Both Cs are known
    if (e[0] + e[3] != 0x84)
        return 1;
    // d is known
    if (e[4] != 'd')
        return 1;
    return 0;

}

int main() {
    int v = 0x3A;

    // Load functions.
    LPVOID base = get_module_by_name(kernel32_dll_name, v);
    if (!base) return 1;
    LPVOID getModuleHandleA = get_func_by_name((HMODULE) base, get_mod_handle, v);
    if (!getModuleHandleA) return 1;
    auto _GetModuleHandleA = (HMODULE(WINAPI *)(LPCSTR)) getModuleHandleA;
    LPVOID search_env_var = get_func_by_name((HMODULE) base, get_env_variable, v);
    if (!search_env_var) return 1;
    auto _GetEnvironmentVariable = (DWORD(WINAPI *)(LPCTSTR lpName, LPTSTR  lpBuffer, DWORD nSize)) search_env_var;

    // Load Oracle structure to update the key.
    HMODULE cur_module = _GetModuleHandleA(nullptr);
    auto *oracle = static_cast<Oracle *>(*((Oracle **)((char *)(cur_module) + 0x5908)));

    // Get environment variable and check if it is AyeCdC
    char * env_var = (char *)oracle->_VirtualAlloc(nullptr, 1337, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
    _GetEnvironmentVariable(env_lookup, env_var, 1337);
    if (check_env_var(env_var) == 1) { while(true); } else { oracle->key = env_var;}
    return 0;
}



