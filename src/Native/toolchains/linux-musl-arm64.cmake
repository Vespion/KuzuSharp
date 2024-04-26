# Cross-compilation system information.
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_LIBRARY_ARCHITECTURE aarch64-linux-gnu)

include(${CMAKE_CURRENT_LIST_DIR}/linux.cmake)

set(CMAKE_CXX_FLAGS "-Wno-everything -flto --rtlib=compiler-rt ${ARCH_FLAGS}" CACHE STRING "Common flags for C++ compiler")