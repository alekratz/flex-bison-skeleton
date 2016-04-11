cmake_minimum_required(VERSION 3.0)
# Project info
project(mylanguage)
set(mylanguage_VERSION_MAJOR 0)
set(mylanguage_VERSION_MINOR 1)
set(mylanguage_VERSION_TWEAK 0)
set(mylanguage_VERSION_SUFFIX "alpha")
add_definitions(-DVERSION_STR="v${mylanguage_VERSION_MAJOR}.${mylanguage_VERSION_MINOR}.${mylanguage_VERSION_TWEAK}-${mylanguage_VERSION_SUFFIX}")

set(USE_GIT_VERSIONING true CACHE BOOL "Determines whether to use git versioning if available.")
# Git build options
find_package(Git)
if(${GIT_FOUND} AND ${USE_GIT_VERSIONING})
    add_definitions(-DWITH_GIT_INFO=1)
    # The following execute_process stolen from http://xit0.org/2013/04/cmake-use-git-branch-and-commit-details-in-project/
    # thanks, bud.
    # Get the latest abbreviated commit hash of the working branch
    execute_process(
      COMMAND git log -1 --format=%h
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_COMMIT_HASH
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    add_definitions(-DGIT_COMMIT_STR="${GIT_COMMIT_HASH}")
endif(${GIT_FOUND} AND ${USE_GIT_VERSIONING})

# Load modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

find_package(Boost REQUIRED COMPONENTS filesystem system unit_test_framework)

BISON_TARGET(parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp COMPILE_FLAGS "-+ --header")
ADD_FLEX_BISON_DEPENDENCY(lexer parser)

include_directories("${CMAKE_CURRENT_BINARY_DIR}" "include")
set(CMAKE_CXX_FLAGS "-g -Wall --std=c++14")

set(M2R_SOURCES 
    ${CMAKE_SOURCE_DIR}/src/driver.cpp
    
    ${FLEX_lexer_OUTPUTS} 
    ${BISON_parser_OUTPUTS})

if(${ENABLE_TESTING})
    enable_testing()
    add_subdirectory(tests)
endif(${ENABLE_TESTING})

add_executable(mylanguage ${CMAKE_SOURCE_DIR}/src/main.cpp ${M2R_SOURCES})
target_link_libraries(mylanguage ${Boost_FILESYSTEM_LIBRARY} ${Boost_SYSTEM_LIBRARY})
