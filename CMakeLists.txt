
cmake_minimum_required (VERSION 2.6)
project (json-builder)

option(BUILD_FUZZER "Build the json-builder fuzzer" OFF)

set (CMAKE_C_FLAGS "-std=c89 -ansi -pedantic -Wall ${CMAKE_C_FLAGS}")

set (SOURCES ${SOURCES} json-builder.c)

add_library (jsonbuilder ${SOURCES})

target_include_directories(jsonbuilder PUBLIC ../json-parser)
set_target_properties (jsonbuilder PROPERTIES VERSION 0.1.0
                                              SOVERSION 0.1)

if(BUILD_FUZZER)
    target_compile_options(jsonbuilder PUBLIC -fsanitize=fuzzer-no-link)
    target_link_options(jsonbuilder PUBLIC -fsanitize=fuzzer-no-link)
endif()

target_link_libraries (jsonbuilder ${LIBS})

install (TARGETS jsonbuilder DESTINATION lib)
install (FILES json-builder.h DESTINATION include)

if(BUILD_FUZZER)
    add_subdirectory(fuzz)
endif()
