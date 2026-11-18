# device/motorola/cancunn

Starter LineageOS device tree. It will NOT build cleanly yet.

1. Copy `extract-files.sh`, `setup-makefiles.sh` and `proprietary-files.txt`
   from https://github.com/pur03/android_device_motorola_cancunn into this folder.
2. `prebuilts/` already holds the kernel (`Image.gz`), `dtb.img`, `dtbo.img` and 196 modules from your dumps.
3. Resolve every `TODO(verify)` in `BoardConfig.mk` / `device.mk`.
4. Run `extract-files.sh` against a stock dump and push `vendor/motorola/cancunn`
   to its own repo (blobs are too big for this one), then enable it in `manifests/cancunn.xml`.
