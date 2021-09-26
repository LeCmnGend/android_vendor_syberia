# Add variables that we wish to make available to soong here.
PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE))

EXPORT_TO_SOONG := \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += syberiaVarsPlugin

SOONG_CONFIG_syberiaVarsPlugin :=

define addVar
  SOONG_CONFIG_syberiaVarsPlugin += $(1)
  SOONG_CONFIG_syberiaVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += syberiaGlobalVars
SOONG_CONFIG_syberiaGlobalVars += \
    inline_kernel_building \
    display_use_smooth_motion

SOONG_CONFIG_NAMESPACES += syberiaNvidiaVars
SOONG_CONFIG_syberiaNvidiaVars += \
    uses_nvidia_enhancements

SOONG_CONFIG_NAMESPACES += syberiaQcomVars
SOONG_CONFIG_syberiaQcomVars +=

# Soong bool variables
SOONG_CONFIG_syberiaNvidiaVars_uses_nvidia_enhancements := $(NV_ANDROID_FRAMEWORK_ENHANCEMENTS)
SOONG_CONFIG_syberiaGlobalVars_inline_kernel_building := $(INLINE_KERNEL_BUILDING)
SOONG_CONFIG_syberiaGlobalVars_display_use_smooth_motion := $(TARGET_DISPLAY_USE_SMOOTH_MOTION)

ifneq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += packages/apps/Bluetooth
endif #TARGET_USE_QTI_BT_STACK
