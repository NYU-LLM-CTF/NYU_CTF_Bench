#!/usr/bin/env python

import os
import platform
import cffi


CURRENT_PATH = os.path.abspath(os.path.dirname(__file__))
OPENSSL_BINDINGS_PATH = os.path.join(CURRENT_PATH, '_cffi_src/openssl')
COMPAT_FILE_PATH = os.path.join(CURRENT_PATH, '_compat.py')


# Load the OpenSSL version utility.
with open(COMPAT_FILE_PATH) as compat_file:
    exec(compat_file.read())  # pylint: disable=exec-used


if platform.system() == "Windows":
    # Windows building instructions:
    # * Ensure you compile with a 64bit lib and toolchain
    #   (run vcvarsx86_amd64.bat)
    # * Ensure the OpenSSL 64 bit lib is on the path.
    #   (PATH=C:\OpenSSL-Win64\bin;%PATH%)
    libraries = ["libeay32"]
    include_dirs = [r"."]
    extra_compile_args = []

    # if "VCINSTALLDIR" not in os.environ:
    #     raise Exception(r"Cannot find the Visual Studio %VCINSTALLDIR% variable. Ensure you ran the appropriate vcvars.bat script.")

    # if "OPENSSL_CONF" not in os.environ:
    #     raise Exception(r"Cannot find the Visual Studio %OPENSSL_CONF% variable. Ensure you install OpenSSL for Windows.")

    openssl_conf = os.environ["OPENSSL_CONF"]
    openssl_bin, conf_name = os.path.split(openssl_conf)
    openssl_base, bin_name = os.path.split(openssl_bin)
    assert bin_name == "bin"
    include_dirs += [os.path.join(openssl_base, "include")]
    library_dirs = [
        openssl_base, os.path.join(
            openssl_base, "lib"), os.path.join(
            openssl_base, "bin")]
    link_args = []

else:
    # Asume we are running on a posix system
    # LINUX: libraries=["crypto"],
    # extra_compile_args=['-Wno-deprecated-declarations']
    link_args = []
    libraries = ["crypto"]
    extra_compile_args = ['-Wno-deprecated-declarations']
    if platform.system() == "Darwin":
        include_dirs = ['/usr/local/opt/openssl@1.1/include',
                        '/usr/local/opt/openssl/include',
                        '/usr/local/ssl/include']
        library_dirs = ['/usr/local/opt/openssl@1.1/lib',
                        '/usr/local/opt/openssl/lib',
                        '/usr/local/ssl/lib']

        # Ensure that our dynamic ABI-based version finding code in
        # _compat.get_openssl_version also tries to load the
        # brew-installed openssl libraries first.
        os.environ["DYLD_LIBRARY_PATH"] = str.join(":", library_dirs)
    else:
        include_dirs = []
        library_dirs = []
        # link_args = ['libcrypto.so']


def get_openssl_bindings(filename):
    src_path = os.path.join(OPENSSL_BINDINGS_PATH, filename)
    with open(src_path) as src_file:
        return src_file.read()


openssl_version_code = get_openssl_version(warn=True)  # pylint: disable=undefined-variable
openssl_bindings_defs = get_openssl_bindings(
    'openssl_v%s.h' % openssl_version_code)
openssl_bindings_src = get_openssl_bindings(
    'openssl_v%s.c' % openssl_version_code)

_FFI = cffi.FFI()
_FFI.set_source("petlib._petlib", openssl_bindings_src,
                libraries=libraries,
                extra_compile_args=extra_compile_args,
                include_dirs=include_dirs,
                library_dirs=library_dirs,
                extra_link_args=link_args)
_FFI.cdef(openssl_bindings_defs)


if __name__ == "__main__":
    print("Compiling petlib for OpenSSL version %s..." % openssl_version_code)
    _FFI.compile()
