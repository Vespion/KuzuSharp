function(generate_vfs_overlay)
	unset(include_dirs)
	file(GLOB_RECURSE entries LIST_DIRECTORIES true "${WINSDK_INCLUDE}/*")
	foreach(entry ${entries})
		if(IS_DIRECTORY "${entry}")
			list(APPEND include_dirs "${entry}")
		endif()
	endforeach()

	file(WRITE "${CMAKE_BINARY_DIR}/winsdk_vfs_overlay.yaml" "version: 0\ncase-sensitive: false\nroots:\n")
	foreach(dir ${include_dirs})
		file(GLOB headers RELATIVE "${dir}" "${dir}/*.h")
		if(NOT headers)
			continue()
		endif()

		file(APPEND "${CMAKE_BINARY_DIR}/winsdk_vfs_overlay.yaml" "  - name: \"${dir}\"\n    type: directory\n    contents:\n")
		foreach(header ${headers})
			file(APPEND "${CMAKE_BINARY_DIR}/winsdk_vfs_overlay.yaml" "      - name: \"${header}\"\n        type: file\n        external-contents: \"${dir}/${header}\"\n")
		endforeach()
	endforeach()
endfunction()

cmake_minimum_required(VERSION 3.5)

set(MSVC_BASE "/opt/msvc")
set(WINSDK_BASE "/opt/winKit")
set(WINSDK_VER "10.0.22621.0")

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

set(MSVC_INCLUDE ${MSVC_BASE}/include)
set(MSVC_LIB ${MSVC_BASE}/lib)

set(WINSDK_INCLUDE ${WINSDK_BASE}/Include/${WINSDK_VER})
set(WINSDK_LIB ${WINSDK_BASE}/Lib/${WINSDK_VER})

generate_vfs_overlay()
set(CMAKE_CLANG_VFS_OVERLAY "${CMAKE_BINARY_DIR}/winsdk_vfs_overlay.yaml")

# Specify compiler flags
set(COMPILE_FLAGS
	-flto
	-imsvc "'${MSVC_INCLUDE}'"
	-imsvc "'${WINSDK_INCLUDE}/ucrt'"
	-imsvc "'${WINSDK_INCLUDE}/shared'"
	-imsvc "'${WINSDK_INCLUDE}/um'"
	-imsvc "'${WINSDK_INCLUDE}/winrt'"
	/EHa
)

set(CMAKE_RC_FLAGS_INIT "\
    /I '${MSVC_INCLUDE}' \
	/I '${WINSDK_INCLUDE}/ucrt' \
	/I '${WINSDK_INCLUDE}/shared' \
	/I '${WINSDK_INCLUDE}/um' \
	/I '${WINSDK_INCLUDE}/winrt' \
")

string(REPLACE ";" " " COMPILE_FLAGS "${COMPILE_FLAGS}")

set(CMAKE_C_FLAGS_INIT "${COMPILE_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_INIT "${COMPILE_FLAGS}" CACHE STRING "" FORCE)

set(LINK_FLAGS
    /manifest:no
	-libpath:"${MSVC_LIB}/${ARCH}"
	-libpath:"${WINSDK_LIB}/ucrt/${ARCH}"
	-libpath:"${WINSDK_LIB}/um/${ARCH}"
)

string(REPLACE ";" " " LINK_FLAGS "${LINK_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_INIT "${LINK_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS_INIT "${LINK_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_INIT "${LINK_FLAGS}" CACHE STRING "" FORCE)

set(CMAKE_C_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)
set(CMAKE_CXX_STANDARD_LIBRARIES "" CACHE STRING "" FORCE)

set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> ${LINK_FLAGS} <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> ${LINK_FLAGS} <TARGET> <LINK_FLAGS> <OBJECTS>")

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