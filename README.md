# LineageOS builder for Moto G Power 5G (2024), cancunn (MT6855)

GitHub Actions pipeline with a rolling ccache so repeat builds are fast.

## Use it
1. Create a **public** repo (public = free 4 vCPU / 16 GB runners; private ones are too small) and push this folder.
2. Put `boot.img` and `dtbo.img` in `device/motorola/cancunn/prebuilts/`.
3. Actions tab -> "Build LineageOS (cancunn)" -> Run workflow.
4. First run: use `make_target = vendorbootimage` (or `bootimage`) to shake out errors quickly.
5. Edit files, push, re-run. ccache means only changed code recompiles.

## Limits you should know about
- Source (~35 GB) can't fit in GitHub's 10 GB cache, so every run re-syncs (~30-60 min).
- A cold full ROM build won't finish in 6 h on 4 cores. The build step stops itself at 220 min and
  still saves the cache; just re-run and it continues from the cache. Expect 2-3 runs for the first `bacon`.
- ccache is capped at 7 GB. GitHub deletes caches not used for 7 days.
- If `easimon/maximize-build-space@v10` can't be resolved, change it to `@master`.
