LOCAL_PATH := device/motorola/cancunn

# [CONFIRMED] ro.virtual_ab.enabled=true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
# [CONFIRMED] ro.virtual_ab.compression.enabled=true
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_SHIPPING_API_LEVEL := 34   # [CONFIRMED] ro.product.first_api_level

PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Vendor blobs (created by setup-makefiles.sh after extract-files.sh)
$(call inherit-product-if-exists, vendor/motorola/cancunn/cancunn-vendor.mk)

# First-stage fstab from your stock vendor_boot (needed for first_stage_mount of the logical partitions)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6855:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6855
