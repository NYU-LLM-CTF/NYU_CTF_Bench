#include <cstdio>

void print_f(char* func_name) {
    printf("\n%s\n__declspec(allocate(\".text\"))\nint virtual_protect[] = {", func_name);
    for (int k = 0; func_name[k] != 0; k++) {
        int c1 = ROTR32(func_name[k], 0x3A);
        printf("%d, ", c1);
    }
    printf("0x00};\n\n");
}

void encrypt_names() {
    print_f("GetModuleHandleA");
    print_f("VirtualAlloc");
    print_f("VirtualFree");
    print_f("GetSystemInfo");
    print_f("ExitProcess");
    print_f("VirtualProtect");
    print_f("CreateEventW");
    print_f("GetModuleFileNameW");
    print_f("GetCurrentProcessId");
    print_f("CreateProcessW");
    print_f("WaitForSingleObject");
    print_f("CloseHandle");
    print_f("GetStdHandle");
    print_f("WriteConsoleA");
    print_f("GetModuleHandleA");
    print_f("GetEnvironmentVariableA");
}