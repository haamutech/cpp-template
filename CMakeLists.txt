cmake_minimum_required(VERSION 3.13)

#set(CMAKE_SYSTEM_NAME Linux)
#set(CMAKE_SYSTEM_PROCESSOR arm)

#set(triple arm-linux-gnueabihf)

set(CMAKE_C_COMPILER clang-9)
#set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER clang++-9)
#set(CMAKE_CXX_COMPILER_TARGET ${triple})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

project("my-project" VERSION 1.0)

option(VERBOSE "Enables verbose build output" OFF)
option(COVERAGE "Builds with coverage information" ON)
option(RELEASE "Creates an optimized release build" OFF)
option(TESTS "Includes tests" ON)

if (RELEASE)
   set(COVERAGE "OFF")
   add_compile_options(-O3)
   message(STATUS "Optimized release build configured")
else()
   add_compile_options(-g)
   message(STATUS "Development build configured")
endif()

if (VERBOSE)
   set(CMAKE_VERBOSE_MAKEFILE "ON")
   message(STATUS "Verbose build output configured")
endif()

if (COVERAGE)
   add_compile_options(-fprofile-instr-generate -fcoverage-mapping)
   add_link_options(-fprofile-instr-generate)
   message(STATUS "Code coverage configured")
endif()

file(GLOB srcs src/*.cpp)
list(REMOVE_ITEM srcs src/main.cpp)

add_library(core STATIC ${srcs})
add_executable(${PROJECT_NAME} src/main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE core)

if (TESTS)
   message(STATUS "Testing included")

   file(GLOB test_srcs test/*.cpp)

   find_package(Catch2 REQUIRED)

   add_executable(testrunner ${test_srcs})

   target_include_directories(testrunner PRIVATE src)
   target_include_directories(testrunner PRIVATE lib/fakeit/include)
   target_include_directories(testrunner PRIVATE lib/fakeit/config/standalone)

   target_link_libraries(testrunner core)
   target_link_libraries(testrunner Catch2::Catch2)

   include(CTest)
   include(Catch)
   catch_discover_tests(testrunner)
endif()
