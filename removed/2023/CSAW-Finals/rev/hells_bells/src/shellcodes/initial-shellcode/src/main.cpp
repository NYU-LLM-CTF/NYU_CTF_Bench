#include <Windows.h>
#include "peb.h"
#include "util.h"
#include "key_check.h"
#include "rc4.h"


#pragma code_seg(".text")

// Functions being resolved:
//      - KERNEL32.DLL
//          - GetModuleHandleA
//          - VirtualAlloc
//          - VirtualFree
//          - GetSystemInfo
//          - ExitProcess
//          - VirtualProtect
//          - CreateEventW
//          - GetModuleFileNameW
//          - GetCurrentProcessId
//          - CreateProcessW
//          - WaitForSingleObject
//          - CloseHandle
//          - GetStdHandle
//          - WriteConsoleA


__declspec(allocate(".text"))
int kernel32_dll_name[] = {4800, 4416, 5248, 4992, 4416, 4864, 3264, 3200, 2944, 4352, 4864, 4864, 00};
__declspec(allocate(".text"))
int get_mod_handle[] = {4544, 6464, 7424, 4928, 7104, 6400, 7488, 6912, 6464, 4608, 6208, 7040, 6400, 6912, 6464, 4160, 00};
__declspec(allocate(".text"))
int virtual_alloc[] = {5504, 6720, 7296, 7424, 7488, 6208, 6912, 4160, 6912, 6912, 7104, 6336, 00};
__declspec(allocate(".text"))
int virtual_free[] = {5504, 6720, 7296, 7424, 7488, 6208, 6912, 4480, 7296, 6464, 6464, 00};
__declspec(allocate(".text"))
int get_system_info[] = {4544, 6464, 7424, 5312, 7744, 7360, 7424, 6464, 6976, 4672, 7040, 6528, 7104, 00};
__declspec(allocate(".text"))
int exit_process[] = {4416, 7680, 6720, 7424, 5120, 7296, 7104, 6336, 6464, 7360, 7360, 0x00};
__declspec(allocate(".text"))
int virtual_protect[] = {5504, 6720, 7296, 7424, 7488, 6208, 6912, 5120, 7296, 7104, 7424, 6464, 6336, 7424, 0x00};
__declspec(allocate(".text"))
int create_event[] = {4288, 7296, 6464, 6208, 7424, 6464, 4416, 7552, 6464, 7040, 7424, 5568, 0x00};
__declspec(allocate(".text"))
int get_module_filename_w[] = {4544, 6464, 7424, 4928, 7104, 6400, 7488, 6912, 6464, 4480, 6720, 6912, 6464, 4992, 6208, 6976, 6464, 5568, 0x00};
__declspec(allocate(".text"))
int get_cur_pid[] = {4544, 6464, 7424, 4288, 7488, 7296, 7296, 6464, 7040, 7424, 5120, 7296, 7104, 6336, 6464, 7360, 7360, 4672, 6400, 0x00};
__declspec(allocate(".text"))
int create_proc[] = {4288, 7296, 6464, 6208, 7424, 6464, 5120, 7296, 7104, 6336, 6464, 7360, 7360, 5568, 0x00};
__declspec(allocate(".text"))
int wait_single_obj[] = {5568, 6208, 6720, 7424, 4480, 7104, 7296, 5312, 6720, 7040, 6592, 6912, 6464, 5056, 6272, 6784, 6464, 6336, 7424, 0x00};
__declspec(allocate(".text"))
int close_handle[] = {4288, 6912, 7104, 7360, 6464, 4608, 6208, 7040, 6400, 6912, 6464, 0x00};
__declspec(allocate(".text"))
int get_std_handle[] = {4544, 6464, 7424, 5312, 7424, 6400, 4608, 6208, 7040, 6400, 6912, 6464, 0x00};
__declspec(allocate(".text"))
int write_console_a[] = {5568, 7296, 6720, 7424, 6464, 4288, 7104, 7040, 7360, 7104, 6912, 6464, 4160, 0x00};

// Encrypted flag
__declspec(allocate(".text"))
unsigned char flag[] = {0x2d,0x78,0x32,0x20,0x78,0x09,0x12,0x61,0xad,0x0d,0x73,0x1f,0x6f,0x5e,0x83,0x02,0xb1,0x74,0xed,0xf9,0xe8,0x8d,0x34,0xc8,0x15,0xa8,0xce,0x39,0x96,0x83,0xbf,0xa6,0xd6,0x84,0x34,0x0d,0xa0,0xf8,0x5e,0x29,0x9d,0x2f,0xce, 0x00};


// Key decryption function
void key_decryption(rc4_state * s, unsigned char * key, int key_len, unsigned char * data, int data_len) {
    rc4_setup(s, key, key_len);
    rc4_crypt(s, data, data_len);
}

int main() {
    int v = 0xAA;

    // Resolve kernel32 image base
    LPVOID base = get_module_by_name(kernel32_dll_name, v);
    if (!base) return 1;

    // Get function addresses
    LPVOID getModuleHandleA = get_func_by_name((HMODULE) base, get_mod_handle, v);
    if (!getModuleHandleA) return 1;
    auto _GetModuleHandleA = (HMODULE(WINAPI *)(LPCSTR)) getModuleHandleA;

    LPVOID valloc = get_func_by_name((HMODULE) base, virtual_alloc, v);
    if (!valloc) return 1;
    auto _VirtualAlloc = (LPVOID(WINAPI *)(LPVOID, SIZE_T, DWORD, DWORD)) valloc;

    LPVOID vprotect = get_func_by_name((HMODULE) base, virtual_protect, v);
    if (!vprotect) return 1;
    auto _VirtualProtect = (BOOL(WINAPI *)(LPVOID, SIZE_T, DWORD, PDWORD)) vprotect;

    LPVOID vfree = get_func_by_name((HMODULE) base, virtual_free, v);
    if (!vfree) return 1;
    auto _VirtualFree = (BOOL(WINAPI *)(LPVOID, SIZE_T, DWORD)) vfree;

    LPVOID sys_info = get_func_by_name((HMODULE) base, get_system_info, v);
    if (!sys_info) return 1;
    auto _GetSystemInfo = (void (WINAPI *)(LPSYSTEM_INFO)) sys_info;

    SYSTEM_INFO sSysInfo;
    _GetSystemInfo(&sSysInfo);

    LPVOID exit_proc = get_func_by_name((HMODULE) base, exit_process, v);
    if (!exit_proc) return 1;
    auto _ExitProcess = (void (WINAPI *)(UINT uExitCode)) exit_proc;

    LPVOID create_e = get_func_by_name((HMODULE) base, create_event, v);
    if (!create_e) return 1;
    auto _CreateEventW = (HANDLE(WINAPI *)(LPSECURITY_ATTRIBUTES, BOOL, BOOL, LPCWSTR)) create_e;

    LPVOID get_mod = get_func_by_name((HMODULE) base, get_module_filename_w, v);
    if (!get_mod) return 1;
    auto _GetModuleFileNameW = (DWORD(WINAPI *)(HMODULE, LPWSTR, DWORD)) get_mod;

    LPVOID get_pid = get_func_by_name((HMODULE) base, get_cur_pid, v);
    if (!get_pid) return 1;
    auto _GetCurrentProcessId = (DWORD(WINAPI *)()) get_pid;

    LPVOID create_process = get_func_by_name((HMODULE) base, create_proc, v);
    if (!create_process) return 1;
    auto _CreateProcessW = (BOOL(WINAPI *)(LPCWSTR, LPWSTR, LPSECURITY_ATTRIBUTES, LPSECURITY_ATTRIBUTES, BOOL, DWORD, LPVOID, LPCWSTR, LPSTARTUPINFOW, LPPROCESS_INFORMATION lpProcessInformation)) create_process;

    LPVOID w_single_obj = get_func_by_name((HMODULE) base, wait_single_obj, v);
    if (!w_single_obj) return 1;
    auto _WaitForSingleObject = (DWORD (WINAPI *)(HANDLE, DWORD)) w_single_obj;

    LPVOID c_handle = get_func_by_name((HMODULE) base, close_handle, v);
    if (!c_handle) return 1;
    auto _CloseHandle = (BOOL (WINAPI *)(HANDLE)) c_handle;

    LPVOID g_std_h = get_func_by_name((HMODULE) base, get_std_handle, v);
    if (!g_std_h) return 1;
    auto _GetStdHandle = (HANDLE (WINAPI *)(DWORD nStdHandle)) g_std_h;

    LPVOID wca = get_func_by_name((HMODULE) base, write_console_a, v);
    if (!wca) return 1;
    auto _WriteConsoleA = (BOOL (WINAPI *)(HANDLE  hConsoleOutput, VOID *lpBuffer, DWORD   nNumberOfCharsToWrite, LPDWORD lpNumberOfCharsWritten,LPVOID  lpReserved)) wca;


    auto *rust_call_space = _VirtualAlloc(nullptr, 1337, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);

    // Update shared memory location
    HMODULE cur_module = _GetModuleHandleA(nullptr);
    auto *oracle = static_cast<Oracle *>(*((Oracle **)((char *)(cur_module) + 0x5908)));

    oracle->_GetModHandleA = _GetModuleHandleA;
    oracle->_VirtualAlloc = _VirtualAlloc;
    oracle->_VirtualFree = _VirtualFree;
    oracle->_VirtualProtect = _VirtualProtect;
    oracle->_ExitProcess = _ExitProcess;
    oracle->_CreateEventW = _CreateEventW;
    oracle->_GetModuleFileNameW = _GetModuleFileNameW;
    oracle->_GetCurrentProcessId = _GetCurrentProcessId;
    oracle->_CreateProcessW = _CreateProcessW;
    oracle->_WaitForSingleObject = _WaitForSingleObject;
    oracle->_CloseHandle = _CloseHandle;
    oracle->CurrentMod = cur_module;
    oracle->sSysInfo = sSysInfo;

    // Generate arguments for spawning the new process.
    WCHAR wszFilePath[MAX_PATH], wszCmdLine[MAX_PATH];
    STARTUPINFO si = { sizeof(si) };
    PROCESS_INFORMATION pi;
    HANDLE hDbgEvent;

    if (!oracle->_GetModuleFileNameW(nullptr, wszFilePath, _countof(wszFilePath)))
        oracle->_ExitProcess(0);

    // Generate arguments for spawning the new process.
    wchar_t * module_filename = static_cast<wchar_t *>(oracle->_VirtualAlloc(nullptr, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));

    int i = 0;
    while(wszFilePath[i] != 0x00){ module_filename[i] = wszFilePath[i]; i++; }
    module_filename[i] = 0x20;
    i++;

    int self_debugging[] = {0xd3,0xe5,0xec,0xe6,0xc4,0xe5,0xe2,0xf5,0xe7,0xe7,0xe9,0xee,0xe7,0x00};
    char * new_self_debugging = static_cast<char *>(oracle->_VirtualAlloc(nullptr, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));

    int w = 0;
    while(self_debugging[w] != 0x00){
        char tmp_c = (char)((char)self_debugging[w] ^ 0x80);
        module_filename[i + w] = tmp_c;
        new_self_debugging[w] = tmp_c;
        w++;
    }
    module_filename[i + w] = 0x20;
    new_self_debugging[w] = 0;
    i++;

    // Get process PID and convert int to string
    unsigned long cur_proc = oracle->_GetCurrentProcessId();
    char * proc_id_str = static_cast<char *>(oracle->_VirtualAlloc(nullptr, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE));
    itoa_custom(cur_proc, proc_id_str, 10);

    int z = 0;
    while(proc_id_str[z] != 0) { module_filename[i + w + z] = proc_id_str[z]; z++;}
    module_filename[i + w + z] = 0;

    // Spawn process and wait for it to exit. Was going to add anti-debug here but scrapped it and left some API calls for complexity.
    hDbgEvent = oracle->_CreateEventW(nullptr, FALSE, FALSE, (LPCWSTR)new_self_debugging);
    if (!hDbgEvent)
        oracle->_ExitProcess(0);

    if (oracle->_CreateProcessW(nullptr, module_filename, nullptr, nullptr, FALSE, 0, nullptr, nullptr, reinterpret_cast<LPSTARTUPINFOW>(&si), &pi))
    {
        oracle->_WaitForSingleObject(pi.hProcess, INFINITE);
        oracle->_CloseHandle(pi.hProcess);
        oracle->_CloseHandle(pi.hThread);
    }

    // Some more anti-debug that was supposed to work but didn't.
    DWORD dwOldProtect = 0;
    PVOID pPage = oracle->_VirtualAlloc(NULL, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if (nullptr == pPage)
        oracle->_ExitProcess(0);

    auto pMem = (PBYTE)pPage;
    *pMem = 0xC3;

    if (!oracle->_VirtualProtect(pPage, oracle->sSysInfo.dwPageSize, PAGE_EXECUTE_READWRITE | PAGE_GUARD, &dwOldProtect))
        oracle->_ExitProcess(0);

    // Check part of the decryption key.
    auto * partial_input_key = (unsigned char *)check_key(rust_call_space, oracle);

    // Decrypt flag.
    auto * key = (unsigned char *)oracle->_VirtualAlloc(NULL, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    auto * flag_data = (unsigned char *)oracle->_VirtualAlloc(NULL, oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);

    int fc = 0;
    while (flag[fc] != 0x00) { flag_data[fc] = flag[fc]; fc += 1;}

    int kc = 0;
    while (partial_input_key[kc] != 0) {
        unsigned char backprop = 'A';
        int sub_c = 0;
        while(oracle->key[sub_c] != 0) {
            key[kc + sub_c] = (partial_input_key[kc + sub_c] + oracle->key[sub_c]) ^ backprop;
            backprop = oracle->key[sub_c] ^ key[kc + sub_c];
            sub_c += 1;
        }
        kc += 4;
    }
    kc = 0;
    while (key[kc] != 0x7e) {
        kc += 1;
    }
    kc += 1;
    key[kc] = 0;
    struct rc4_state *s;
    s = (struct rc4_state *) oracle->_VirtualAlloc(nullptr, 2 * oracle->sSysInfo.dwPageSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    key_decryption(s, key, kc, flag_data, fc);

    // Write flag to console.
    HANDLE stdOut = _GetStdHandle(STD_OUTPUT_HANDLE);
    if (stdOut != nullptr && stdOut != INVALID_HANDLE_VALUE)
    {
        DWORD written = 0;
        _WriteConsoleA(stdOut, flag_data, fc, &written, nullptr);
    }
    return 0;
}



