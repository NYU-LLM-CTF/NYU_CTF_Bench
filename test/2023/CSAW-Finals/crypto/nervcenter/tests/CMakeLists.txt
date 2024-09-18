# Create a list of all test programs with parent scope
macro(add_test_program TESTNAME TESTSRCS_LIST TESTINCS_LIST TESTLIBS_LIST)
    message(STATUS "Adding test program ${TESTNAME}")
    message(STATUS "  Sources: ${TESTSRCS_LIST}")
    message(STATUS "  Includes: ${TESTINCS_LIST}")
    message(STATUS "  Libraries: ${TESTLIBS_LIST}")
    add_executable(${TESTNAME} ${TESTNAME}.c ${TESTSRCS_LIST})
    target_link_libraries(${TESTNAME} ${TESTLIBS_LIST})
    target_include_directories(${TESTNAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/.. ${TESTINCS_LIST})
    list(APPEND TEST_PROGRAMS ${TESTNAME})
    set(TEST_PROGRAMS ${TEST_PROGRAMS} PARENT_SCOPE)
    add_test(${TESTNAME} ${TESTNAME})
endmacro(add_test_program)

add_test_program(test_pack "../src/resources.c;${IMGRESOURCE_C}" "${ZLIB_INCLUDE_DIRS}" "${ZLIB_LIBRARIES}")
add_test_program(test_rsa_sig "../src/rsautil.c;../src/base64.c" "${OPENSSL_INCLUDE_DIR}" OpenSSL::Crypto)
add_test_program(test_rsa_enc "../src/rsautil.c;../src/base64.c" "${OPENSSL_INCLUDE_DIR}" OpenSSL::Crypto)
add_test_program(test_rsa_setup "../src/rsautil.c;../src/base64.c" "${OPENSSL_INCLUDE_DIR}" OpenSSL::Crypto)
add_test_program(test_rsa_validate_key "../src/rsautil.c;../src/base64.c" "${OPENSSL_INCLUDE_DIR}" OpenSSL::Crypto)
add_test_program(test_ui "../src/ui.c;${MAGI_UI_C}" "${GENERATED_DIR}" "")
add_test_program(test_base64 "../src/base64.c" "" "")
add_test_program(test_sendimgvid "../src/utils.c;../src/image.c;../src/resources.c;${IMGRESOURCE_C}" "${GENERATED_DIR};${ZLIB_INCLUDE_DIRS}" "${ZLIB_LIBRARIES}")

add_test(NAME test_server_basics
    COMMAND python3 ${CMAKE_CURRENT_SOURCE_DIR}/test_server_basics.py ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
