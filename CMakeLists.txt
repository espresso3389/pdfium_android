# Building pdfium
# See the following document for more info.
# https://pdfium.googlesource.com/pdfium/
cmake_minimum_required(VERSION 3.8)
cmake_policy(SET CMP0091 NEW)
project("pdfium")

set(CMAKE_SYSTEM_NAME Android)

if(ANDROID_NDK_ROOT STREQUAL "")
  message(FATAL_ERROR "Set ANDROID_NDK_ROOT.")
endif()

set(MAKE_TOOLCHAIN_FILE ${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake)

set(depot_tools_zip ${CMAKE_CURRENT_BINARY_DIR}/depot_tools.zip)
set(depot_tools_dir ${CMAKE_CURRENT_BINARY_DIR}/depot_tools)

# https://developer.android.com/ndk/guides/cmake?#usage
# https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md#figuring-out-target_cpu
if(PDFIUM_ARCH STREQUAL "arm64")
  set(ANDROID_ABI "arm64-v8a")
elseif(PDFIUM_ARCH STREQUAL "arm")
  set(ANDROID_ABI "armeabi-v7a")
elseif(PDFIUM_ARCH STREQUAL "x86")
  set(ANDROID_ABI "x86")
elseif(PDFIUM_ARCH STREQUAL "x64")
  set(ANDROID_ABI "x86_64")
else()
  message(FATAL_ERROR "PDFIUM_ARCH is not properly set: ${PDFIUM_ARCH}")
endif()

if(CMAKE_BUILD_TYPE STREQUAL "")
  set(CMAKE_BUILD_TYPE Release)
  endif()

set(pdfium_reldbg ${CMAKE_BUILD_TYPE})

if(NOT EXISTS ${depot_tools_dir})
  execute_process(
    COMMAND git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    RESULT_VARIABLE CMD_RESULT)
  if(NOT CMD_RESULT EQUAL "0")
    message(FATAL_ERROR "Cloning depot_tools failed.")
  endif()
endif()

execute_process(
  COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/build.sh ${ANDROID_ABI} ${PDFIUM_ARCH} ${pdfium_reldbg} ${depot_tools_dir}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE CMD_RESULT)
if(NOT CMD_RESULT EQUAL "0")
  message(FATAL_ERROR "Executing scripts/build.sh failed.")
endif()
