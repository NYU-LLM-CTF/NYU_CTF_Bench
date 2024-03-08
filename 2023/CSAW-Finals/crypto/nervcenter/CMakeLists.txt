cmake_minimum_required(VERSION 3.20)

# Default compiler
if(NOT CMAKE_C_COMPILER)
  set(CMAKE_C_COMPILER clang)
endif()
if(NOT CMAKE_CXX_COMPILER)
  set(CMAKE_CXX_COMPILER clang++)
endif()

project(nervcenter_project LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_CXX_OUTPUT_EXTENSION_REPLACE ON)

# This file provides a custom build type, `CMAKE_BUILD_TYPE_ASAN`
set(CMAKE_C_FLAGS_ASAN "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=address -fno-omit-frame-pointer -fno-common" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_ASAN "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=address -fno-omit-frame-pointer -fno-common" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_ASAN "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=address" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_ASAN "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=address" CACHE STRING "" FORCE)

# This file provides a custom build type, `CMAKE_BUILD_TYPE_UBSAN`
set(CMAKE_C_FLAGS_UBSAN "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=undefined -fno-omit-frame-pointer -fno-common" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_UBSAN "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=undefined -fno-omit-frame-pointer -fno-common" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_UBSAN "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=undefined" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_UBSAN "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=undefined" CACHE STRING "" FORCE)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_C_COMPILER_ID MATCHES "Clang")
    set(CMAKE_C_FLAGS_COVERAGE "${CMAKE_C_FLAGS} -fprofile-instr-generate -fcoverage-mapping")
    set(CMAKE_CXX_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS} -fprofile-instr-generate -fcoverage-mapping")
    set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld -fprofile-instr-generate -fcoverage-mapping")
endif()

set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo" "ASan" "UBSan")

# Get the current list of build types
get_property(current_build_types CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS)

# Conditionally append "Coverage" if the compiler is Clang
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND CMAKE_C_COMPILER_ID MATCHES "Clang")
    list(APPEND current_build_types "Coverage")
endif()

# Set the modified list back
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${current_build_types})

# Use it to populate the configuration types
set(CMAKE_CONFIGURATION_TYPES "${current_build_types}" CACHE STRING "" FORCE)

# Set the C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

# Common Compiler Flags
add_compile_options(-pthread -D_GNU_SOURCE -Wall)

# OpenSSL
find_package(OpenSSL REQUIRED)

# zlib
find_package(ZLIB REQUIRED)

# libgmp for brent
find_package(GMP REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# Generate the paths for the generated files in the build directory
set(GENERATED_DIR ${CMAKE_CURRENT_BINARY_DIR}/generated)
set(IMGRESOURCE_C ${GENERATED_DIR}/imgresource.c)
set(IMGRESOURCE_H ${GENERATED_DIR}/imgresource.h)
set(MAGI_UI_C ${GENERATED_DIR}/magi_ui.c)
set(MAGI_UI_H ${GENERATED_DIR}/magi_ui.h)
set(XTERM_COLORS_H ${GENERATED_DIR}/xterm_colors.h)

# nervcenter executable
add_executable(nervcenter src/nervcenter.c src/rsautil.c src/base64.c src/parsers.c src/resources.c src/image.c src/ui.c src/utils.c ${MAGI_UI_C} ${IMGRESOURCE_C})
target_include_directories(nervcenter PRIVATE ${ZLIB_INCLUDE_DIRS} ${OPENSSL_INCLUDE_DIR} ${GENERATED_DIR})
target_link_libraries(nervcenter PRIVATE OpenSSL::Crypto pthread gcc_s ${ZLIB_LIBRARIES})

if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-DCHALDEBUG)
endif()

# helper function for fuzzer executables
function(add_fuzzer_target target_name)
    # All source files are taken after the target name
    set(sources ${ARGN})
    add_executable(${target_name} ${sources})
    target_compile_options(${target_name} PRIVATE -fsanitize=fuzzer,address)
    target_link_options(${target_name} PRIVATE -fsanitize=fuzzer,address)
    set_target_properties(${target_name} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/fuzzers"
    )
endfunction()

if(CMAKE_C_COMPILER_ID MATCHES "Clang")
    add_fuzzer_target(sensor_fuzzer fuzzers/sensor_fuzzer.c src/parsers.c)
    add_fuzzer_target(validate_challenge_fuzzer fuzzers/validate_challenge_fuzzer.cc src/rsautil.c src/base64.c)
    target_link_libraries(validate_challenge_fuzzer PRIVATE OpenSSL::Crypto)
    add_fuzzer_target(dump_pubkey_ssh_fuzzer fuzzers/dump_pubkey_ssh_fuzzer.cc src/rsautil.c src/base64.c)
    target_link_libraries(dump_pubkey_ssh_fuzzer PRIVATE OpenSSL::Crypto)
    add_fuzzer_target(encrypt_message_fuzzer fuzzers/encrypt_message_fuzzer.cc src/rsautil.c src/base64.c)
    target_link_libraries(encrypt_message_fuzzer PRIVATE OpenSSL::Crypto)
    add_fuzzer_target(decrypt_message_fuzzer fuzzers/encrypt_message_fuzzer.cc src/rsautil.c src/base64.c)
    target_link_libraries(decrypt_message_fuzzer PRIVATE OpenSSL::Crypto)
endif()

# brent executable
add_executable(brent solver/brent.c)
target_include_directories(brent PRIVATE ${GMP_INCLUDES})
target_link_libraries(brent PRIVATE ${GMP_LIBRARIES})
set_target_properties(brent PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/solver"
)

# signmessage executable
add_executable(signmessage solver/signmessage.c)
target_link_libraries(signmessage PRIVATE OpenSSL::Crypto)
set_target_properties(signmessage PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/solver"
)

add_executable(decryptmessage solver/decryptmessage.c)
target_link_libraries(decryptmessage PRIVATE OpenSSL::Crypto)
set_target_properties(decryptmessage PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/solver"
)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/img/credits/frame_00000001.txt
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND tar -xf img/credits.tar.xz
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/img/credits.tar.xz
)

add_custom_command(
    OUTPUT ${IMGRESOURCE_C} ${IMGRESOURCE_H}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/util/pack_images img ${GENERATED_DIR}/imgresource image_blob
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/util/pack_images ${CMAKE_CURRENT_SOURCE_DIR}/img/credits/frame_00000001.txt
)

add_custom_command(
    OUTPUT ${MAGI_UI_C} ${MAGI_UI_H} ${XTERM_COLORS_H}
    COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/util/add_ansi_colors.py --mode=markup2structs ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui.txt ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui_redbox.txt ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui_yellowbox.txt -n magi_ui -n magi_ui_red_box -n magi_ui_yellow_box -o ${GENERATED_DIR}/magi_ui
    COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/util/add_ansi_colors.py --mode=dumpcolors -o ${XTERM_COLORS_H}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui_redbox.txt ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui.txt  ${CMAKE_CURRENT_SOURCE_DIR}/ui_template/magi_ui_yellowbox.txt ${CMAKE_CURRENT_SOURCE_DIR}/util/add_ansi_colors.py
)

# This ensures the files are always generated
add_custom_target(generate_files ALL
    DEPENDS ${IMGRESOURCE_C} ${IMGRESOURCE_H} ${MAGI_UI_C} ${MAGI_UI_H} ${XTERM_COLORS_H}
)

# Enable testing
enable_testing()

# Add the tests subdirectory
add_subdirectory(tests)

foreach(testprog ${TEST_PROGRAMS})
    message (STATUS "Adding generate_files as dependency for test program ${testprog}")
    add_dependencies(${testprog} generate_files)
endforeach(testprog ${TEST_PROGRAMS})

# Make sure the directory exists before generating files into it.
file(MAKE_DIRECTORY ${GENERATED_DIR})

# Add the util subdirectory
add_subdirectory(util)

if (CMAKE_BUILD_TYPE MATCHES "Coverage")

add_custom_target(run_tests_coverage
    COMMAND ${CMAKE_COMMAND} -E env LLVM_PROFILE_FILE="${CMAKE_BINARY_DIR}/testsuite.%p.profraw" ctest
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running tests with coverage..."
)

foreach(testprog ${TEST_PROGRAMS})
    message(STATUS "Adding run_tests_coverage as dependency for test program ${testprog}")
    add_dependencies(run_tests_coverage ${testprog})
endforeach(testprog ${TEST_PROGRAMS})

# Merge .profraw files
add_custom_target(merge_coverage_data
    COMMAND llvm-profdata merge -sparse *.profraw -o merged.profdata
    DEPENDS run_tests_coverage
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Merging coverage data..."
)

# Generate the HTML report
add_custom_target(coverage_report
    COMMAND llvm-cov show $<TARGET_FILE:nervcenter> -instr-profile=merged.profdata --format=html -output-dir=coverage_report
    DEPENDS merge_coverage_data
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating coverage report..."
)

endif()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Configuration types: ${CMAKE_CONFIGURATION_TYPES}")

add_custom_command(TARGET nervcenter POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} --only-keep-debug $<TARGET_FILE:nervcenter> $<TARGET_FILE_DIR:nervcenter>/$<TARGET_FILE_NAME:nervcenter>.debug
    COMMAND ${CMAKE_OBJCOPY} --strip-debug --strip-unneeded $<TARGET_FILE:nervcenter>
    COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=$<TARGET_FILE_DIR:nervcenter>/$<TARGET_FILE_NAME:nervcenter>.debug $<TARGET_FILE:nervcenter>
    COMMENT "Creating detached debug symbols for $<TARGET_FILE:nervcenter>"
)
