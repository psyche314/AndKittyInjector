cmake_minimum_required(VERSION 3.16)

project(AndKittyInjector
    VERSION 1.0
    LANGUAGES CXX
)

# -----------------------------
# Options
# -----------------------------
option(KT_DISABLE_KEYSTONE "Disable keystone support" ON)

# -----------------------------
# C++ standard
# -----------------------------
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# -----------------------------
# KittyMemoryEx library
# -----------------------------
set(KITTYMEMORY_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../KittyMemoryEx/KittyMemoryEx")
file(GLOB KITTYMEMORY_SRC "${KITTYMEMORY_PATH}/*.cpp")
set(KEYSTONE_LIB ${KITTYMEMORY_PATH}/Deps/Keystone/libs-android/${CMAKE_ANDROID_ARCH_ABI}/libkeystone.a)

# -----------------------------
# Reusable injector core
# -----------------------------
# Keep the CLI entry point out of this target so another executable can embed
# KittyInjector directly instead of invoking the command-line tool.
add_library(AndKittyInjectorCore STATIC
    "${CMAKE_CURRENT_SOURCE_DIR}/src/Injector/KittyInjector.cpp"
    ${KITTYMEMORY_SRC}
)
add_library(AndKittyInjector::Core ALIAS AndKittyInjectorCore)

target_compile_features(AndKittyInjectorCore PUBLIC cxx_std_20)
target_include_directories(AndKittyInjectorCore
    PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${KITTYMEMORY_PATH}"
)
target_compile_definitions(AndKittyInjectorCore
    PRIVATE
        $<$<CONFIG:Debug>:DEBUG>
        $<$<CONFIG:Release>:NDEBUG>
        $<$<BOOL:${KT_DISABLE_KEYSTONE}>:kNO_KEYSTONE>
)
target_compile_options(AndKittyInjectorCore
    PRIVATE
        $<$<CONFIG:Debug>:-O0 -g>
        $<$<CONFIG:Release>:-O2>
        -Wall
        -Wextra
        -Werror
        -fexceptions
        -Wno-unused-command-line-argument
)
set_target_properties(AndKittyInjectorCore PROPERTIES
    POSITION_INDEPENDENT_CODE ON
)

# -----------------------------
# CLI executable
# -----------------------------
add_executable(AndKittyInjector
    "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/Utils.cpp"
)
target_compile_features(AndKittyInjector PRIVATE cxx_std_20)
target_include_directories(AndKittyInjector
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
        "${KITTYMEMORY_PATH}"
)
target_compile_definitions(AndKittyInjector
    PRIVATE
        $<$<CONFIG:Debug>:DEBUG>
        $<$<CONFIG:Release>:NDEBUG>
        $<$<BOOL:${KT_DISABLE_KEYSTONE}>:kNO_KEYSTONE>
)
target_compile_options(AndKittyInjector
    PRIVATE
        $<$<CONFIG:Debug>:-O0 -g>
        $<$<CONFIG:Release>:-O2>
        -Wall
        -Wextra
        -Werror
        -fexceptions
        -Wno-unused-command-line-argument
)
target_link_libraries(AndKittyInjector PRIVATE AndKittyInjector::Core)

# -----------------------------
# Platform-specific libraries
# -----------------------------
if(ANDROID)
    target_link_libraries(AndKittyInjectorCore
        PUBLIC
            log
            $<$<NOT:$<BOOL:${KT_DISABLE_KEYSTONE}>>:${KEYSTONE_LIB}>
    )
endif()
