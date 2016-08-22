# ---------------------------------------------------------------
# the setpath shell function in envsetup.sh uses this to figure out
# what to add to the path given the config we have chosen.
ifeq ($(CALLED_FROM_SETUP),true)

ifneq ($(filter /%,$(HOST_OUT_EXECUTABLES)),)
ABP:=$(HOST_OUT_EXECUTABLES)
else
ABP:=$(PWD)/$(HOST_OUT_EXECUTABLES)
endif

ANDROID_BUILD_PATHS := $(ABP)
ANDROID_PREBUILTS := prebuilt/$(HOST_PREBUILT_TAG)
ANDROID_GCC_PREBUILTS := prebuilts/gcc/$(HOST_PREBUILT_TAG)

# The "dumpvar" stuff lets you say something like
#
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-TARGET_OUT
# or
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-abs-HOST_OUT_EXECUTABLES
#
# The plain (non-abs) version just dumps the value of the named variable.
# The "abs" version will treat the variable as a path, and dumps an
# absolute path to it.
#
dumpvar_goals := \
	$(strip $(patsubst dumpvar-%,%,$(filter dumpvar-%,$(MAKECMDGOALS))))
ifdef dumpvar_goals

  ifneq ($(words $(dumpvar_goals)),1)
    $(error Only one "dumpvar-" goal allowed. Saw "$(MAKECMDGOALS)")
  endif

  # If the goal is of the form "dumpvar-abs-VARNAME", then
  # treat VARNAME as a path and return the absolute path to it.
  absolute_dumpvar := $(strip $(filter abs-%,$(dumpvar_goals)))
  ifdef absolute_dumpvar
    dumpvar_goals := $(patsubst abs-%,%,$(dumpvar_goals))
    ifneq ($(filter /%,$($(dumpvar_goals))),)
      DUMPVAR_VALUE := $($(dumpvar_goals))
    else
      DUMPVAR_VALUE := $(PWD)/$($(dumpvar_goals))
    endif
    dumpvar_target := dumpvar-abs-$(dumpvar_goals)
  else
    DUMPVAR_VALUE := $($(dumpvar_goals))
    dumpvar_target := dumpvar-$(dumpvar_goals)
  endif

.PHONY: $(dumpvar_target)
$(dumpvar_target):
	@echo $(DUMPVAR_VALUE)

endif # dumpvar_goals

ifneq ($(dumpvar_goals),report_config)
PRINT_BUILD_CONFIG:=
endif

endif # CALLED_FROM_SETUP

ifneq ($(BUILD_WITH_COLORS),0)
    include $(TOP_DIR)build/core/colors.mk
endif


ifneq ($(PRINT_BUILD_CONFIG),)
HOST_OS_EXTRA:=$(shell python -c "import platform; print(platform.platform())")
$(info ${CLR_CYN} =============================================)
$(info ${CLR_CYN} =================CandyRom===================)
$(info ${CLR_CYN} =============================================)
$(info ${CLR_GRN}     CANDY_VERSION=$(CANDY_VERSION))
$(info ${CLR_CYN} ============================================)
$(info ${CLR_YLW}   PLATFORM_VERSION_CODENAME=$(PLATFORM_VERSION_CODENAME))
$(info ${CLR_YLW}   PLATFORM_VERSION=$(PLATFORM_VERSION))
$(info ${CLR_YLW}   TARGET_BUILD_TYPE=$(TARGET_BUILD_TYPE))
$(info ${CLR_YLW}   TARGET_ARCH=$(TARGET_ARCH))
$(info ${CLR_YLW}   TARGET_ARCH_VARIANT=$(TARGET_ARCH_VARIANT))
$(info ${CLR_YLW}   TARGET_BUILD_APPS=$(TARGET_BUILD_APPS))
$(info ${CLR_YLW}   TARGET_CPU_VARIANT=$(TARGET_CPU_VARIANT))
$(info ${CLR_YLW}   TARGET_2ND_CPU_VARIANT=$(TARGET_2ND_CPU_VARIANT))
$(info ${CLR_CYN} ============================================)
ifeq ($(TARGET_DRAGONTC_VERSION),)
else
$(info ${CLR_YLW}   CLANG_VERSION=$(DTC_VER))
endif
$(info ${CLR_YLW}   TARGET_GCC_VERSION=$(TARGET_GCC_VERSION))
$(info ${CLR_YLW}   TARGET_NDK_GCC_VERSION=$(TARGET_NDK_GCC_VERSION))
ifdef TARGET_GCC_VERSION_ARM
$(info ${CLR_YLW}   TARGET_KERNEL_TOOLCHAIN=$(TARGET_GCC_VERSION_ARM))
else
$(info ${CLR_YLW}   TARGET_KERNEL_TOOLCHAIN=$(TARGET_GCC_VERSION))
endif
$(info ${CLR_CYN} ============================================)
$(info ${CLR_YLW}   HOST_ARCH=$(HOST_ARCH))
$(info ${CLR_YLW}   HOST_OS=$(HOST_OS))
$(info ${CLR_YLW}   HOST_OS_EXTRA=$(HOST_OS_EXTRA))
$(info ${CLR_YLW}   HOST_BUILD_TYPE=$(HOST_BUILD_TYPE))
$(info ${CLR_YLW}   BUILD_ID=$(BUILD_ID))
$(info ${CLR_YLW}   OUT_DIR=$(OUT_DIR))
$(info ${CLR_CYN} ============================================${CLR_RST})
endif
