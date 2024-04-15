import cffi
import warnings


class OpenSSLVersion:
    V1_0 = "1_0"
    V1_1 = "1_1"


def get_abi_lib():
    ffi = cffi.FFI()
    ffi.cdef("unsigned long OpenSSL_version_num();")
    ffi.cdef("unsigned long SSLeay();")
    lib = ffi.dlopen("crypto")
    return lib


def get_openssl_version(lib=None, warn=False):
    """Returns the OpenSSL version that is used for bindings."""

    if lib is None:
        lib = get_abi_lib()

    try:
        full_version = lib.OpenSSL_version_num()
    except AttributeError:
        full_version = lib.SSLeay()

    version = full_version >> 20
    if version == 0x101:
        return OpenSSLVersion.V1_1
    elif version == 0x100:
        if warn:
            warnings.warn(
                "Support for the system OpenSSL version (0x%x) is pending deprecation. "
                "Please upgrade to OpenSSL v1.1" % version)
        return OpenSSLVersion.V1_0
    else:
        # If the version is not 1.0 or 1.1, assume its a later one, and optimistically
        # assume it doesn't horribly break the interface this time.
        if warn:
            warnings.warn(
                "System OpenSSL version is not supported: %d. "
                "Attempting to use in OpenSSL v1.1 mode." % version)
        return OpenSSLVersion.V1_1
