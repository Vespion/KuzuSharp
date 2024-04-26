include("${CMAKE_CURRENT_LIST_DIR}/zig-toolchain-common.cmake")

set(ZIG_LIBC "gnu")
set(ZIG_OS "windows")
set(ZIG_ARCH "aarch64")
set(ZIG_TARGET "${ZIG_ARCH}-${ZIG_OS}-${ZIG_LIBC}")

set(CMAKE_SYSTEM_NAME "Windows")
set(CMAKE_SYSTEM_PROCESSOR "${ZIG_ARCH}")

#DOES NOT WORK!
#/src/kuzu/third_party/fast_float/include/fast_float.h:247:19: error: use of undeclared identifier '__umulh'
# This file uses __umulh which is not available on in MingW or what ever it is that zig uses
# Needs either an updated version of fast_float, zig to support msvc or a different compiler