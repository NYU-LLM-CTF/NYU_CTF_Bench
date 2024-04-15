
import os
import platform
import cffi

# try:
from ._bplib import ffi, lib
_FFI = ffi
_C = lib
#except:
#    print("Support not loading the library to build docs without compiling.")
#    _C = None
#    _FFI = None

def test_load():
	assert _C != None
	assert _FFI != None
	x = _C.BP_GROUP_new()
