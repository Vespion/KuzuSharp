cmake_minimum_required(VERSION 3.5)

set(CMAKE_SYSTEM_NAME Windows)

# Compile a static library as the test target
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# Set the compilers for C, C++ and ASM
SET(CMAKE_C_COMPILER_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
SET(CMAKE_C_COMPILER clang-cl)
#SET(CMAKE_C_COMPILER clang)
SET(CMAKE_CXX_COMPILER_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
SET(CMAKE_CXX_COMPILER clang-cl)
#SET(CMAKE_CXX_COMPILER clang)
SET(CMAKE_ASM_COMPILER_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
SET(CMAKE_ASM_COMPILER clang)
set(CMAKE_RC_COMPILER_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
set(CMAKE_RC_COMPILER llvm-rc)
set(CMAKE_LINKER_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
set(CMAKE_LINKER lld-link)
set(CMAKE_AR_TARGET ${CMAKE_LIBRARY_ARCHITECTURE})
set(CMAKE_AR llvm-lib)

#add_compile_options("-Wno-everything")
#add_compile_options("-flto")

set(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_NO_WARNINGS ON)

#set(ARCH_FLAGS "-mcpu=cortex-a5 -mthumb -mfpu=neon-vfpv4 -mfloat-abi=hard -mno-unaligned-access")
set(CMAKE_C_FLAGS "-Wno-everything ${ARCH_FLAGS}" CACHE STRING "Common flags for C compiler")
set(CMAKE_CXX_FLAGS "-Wno-everything -flto ${ARCH_FLAGS}" CACHE STRING "Common flags for C++ compiler")
set(CMAKE_ASM_FLAGS "-Wno-everything ${ARCH_FLAGS} -x assembler-with-cpp" CACHE STRING "Common flags for assembler")
#set(CMAKE_EXE_LINKER_FLAGS "-nostartfiles -Wl,-Map,kernel.map,--gc-sections -fuse-linker-plugin -Wl,--use-blx --specs=nano.specs --specs=nosys.specs" CACHE STRING "")
#SET(LINK_OPTIONS "-fuse-ld-lld:-flto" CACHE STRING "Common Linker options")

add_link_options("-fuse-ld=lld")
add_link_options("-flto")

# Don't look for programs in the sysroot
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Only look for libraries, headers and packages in the sysroot, don't look on
# the build machine.
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)