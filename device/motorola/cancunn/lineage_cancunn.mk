$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

$(call inherit-product, device/motorola/cancunn/device.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_cancunn
PRODUCT_DEVICE := cancunn
PRODUCT_MANUFACTURER := motorola
PRODUCT_BRAND := motorola
PRODUCT_MODEL := moto g power 5G - 2024
PRODUCT_GMS_CLIENTID_BASE := android-motorola

# From `getprop ro.build.fingerprint` on the stock firmware
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="cancunn_g_sys-user 15 V1UDS35H.26-14-2-14-12-3 378a9d-b47e6 release-keys" \
    BuildFingerprint=motorola/cancunn_g_sys/cancunn:15/V1UDS35H.26-14-2-14-12-3/378a9d-b47e6:user/release-keys
