cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)

add_executable(
    "${PROJECT_NAME}-fuzzer"
    "${CMAKE_CURRENT_LIST_DIR}/fuzz.c"
)

if (NOT CMAKE_C_COMPILER_ID STREQUAL "Clang")
    message(FATAL_ERROR "Clang is required for libFuzzer!")
endif()

target_include_directories(
    "${PROJECT_NAME}-fuzzer"
    PUBLIC
    ${PROJECT_SOURCE_DIR}
)

target_compile_options(
    "${PROJECT_NAME}-fuzzer"
    PUBLIC
    -fsanitize=fuzzer
)

target_link_options(
    "${PROJECT_NAME}-fuzzer"
    PUBLIC
    -fsanitize=fuzzer
)

target_link_libraries(
    "${PROJECT_NAME}-fuzzer"
    PRIVATE
    jsonbuilder
)
