# Cross-compilation system information.
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_LIBRARY_ARCHITECTURE arm-linux-gnueabi)

include(${CMAKE_CURRENT_LIST_DIR}/linux.cmake)

set(CMAKE_CXX_FLAGS "-Wno-everything -flto --rtlib=compiler-rt ${ARCH_FLAGS}" CACHE STRING "Common flags for C++ compiler")