# The petlib version
VERSION = '0.0.45'


__all__ = ["bindings", "bn", "cipher", "compile", "ecdsa", "ec", "hmac", "pack"]

def run_tests():
    # These are only needed in case we test
    import pytest
    import os.path
    import glob

    # List all petlib files in the directory
    petlib_dir = os.path.dirname(os.path.realpath(__file__))
    pyfiles = glob.glob(os.path.join(petlib_dir, '*.py'))

    # Run the test suite
    print("Directory: %s" % pyfiles)
    res = pytest.main(["-v", "-x"] + pyfiles)
    print("Result: %s" % res)

    # Return exit result
    return res
