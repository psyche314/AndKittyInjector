LOCAL_PATH := $(call my-dir)

KITTYMEMORY_PATH = $(LOCAL_PATH)/../KittyMemoryEx/KittyMemoryEx
KITTYMEMORY_SRC  = $(wildcard $(KITTYMEMORY_PATH)/*.cpp)

# add -DkITTYMEMORY_DEBUG for debug outputs
# use logcat logging to get outputs in realtime
COMMON_CPPFLAGS := -std=c++20 -fexceptions -Wall -Wextra -Werror -DkNO_KEYSTONE #-DkUSE_LOGCAT -DkITTYMEMORY_DEBUG

include $(CLEAR_VARS)

LOCAL_MODULE := AndKittyInjectorCore
LOCAL_CPPFLAGS += $(COMMON_CPPFLAGS)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/src $(KITTYMEMORY_PATH)
LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)/src $(KITTYMEMORY_PATH)
LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/src/Injector/*.cpp) $(KITTYMEMORY_SRC)

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := AndKittyInjector
LOCAL_CPPFLAGS += $(COMMON_CPPFLAGS)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/src $(KITTYMEMORY_PATH)
LOCAL_SRC_FILES := $(LOCAL_PATH)/src/main.cpp $(LOCAL_PATH)/src/Utils.cpp
LOCAL_STATIC_LIBRARIES := AndKittyInjectorCore
LOCAL_LDLIBS += -llog

include $(BUILD_EXECUTABLE)
