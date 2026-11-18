# Pulling your phone's blobs (run on Windows, phone booted with root + USB debugging)

    adb push scripts/blob-list.txt /data/local/tmp/blob-list.txt
    adb shell su -c "cd / && tar -cf /sdcard/blobs.tar -T /data/local/tmp/blob-list.txt"
    adb pull /sdcard/blobs.tar

Then create a GitHub Release in your repo, attach `blobs.tar`, copy the asset's download URL,
and run the **Extract vendor blobs (cancunn)** workflow with that URL.
Files the phone doesn't have are reported as "missing" (the list came from a slightly different build).
