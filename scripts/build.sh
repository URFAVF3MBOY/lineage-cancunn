#!/usr/bin/env bash
# Usage: scripts/build.sh deps|sync|build   (also works on any Ubuntu 22.04/24.04 box)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${SRC_DIR:-$HOME/lineage/android}"
BRANCH="${LINEAGE_BRANCH:-lineage-22.2}"
TARGET="${MAKE_TARGET:-bacon}"
VARIANT="${BUILD_VARIANT:-userdebug}"
CCACHE_DIR="${CCACHE_DIR:-$HOME/.ccache}"

deps() {
  sudo apt-get update
  sudo apt-get install -y bc bison build-essential ccache curl flex g++-multilib \
    gcc-multilib git git-lfs gnupg gperf imagemagick protobuf-compiler python3 \
    python3-protobuf lib32readline-dev lib32z1-dev libdw-dev libelf-dev \
    libgnutls28-dev lz4 libssl-dev libxml2 libxml2-utils lzop pngcrush rsync \
    schedtool squashfs-tools xsltproc zip zlib1g-dev libncurses-dev unzip
  sudo curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
  sudo chmod +x /usr/local/bin/repo
  git config --global user.name  "cancunn-builder"
  git config --global user.email "builder@users.noreply.github.com"
  git config --global color.ui false
  git lfs install
}

sync_src() {
  sudo mkdir -p "$SRC_DIR" "$CCACHE_DIR"
  sudo chown -R "$(id -u):$(id -g)" "$(dirname "$SRC_DIR")" || true
  cd "$SRC_DIR"
  if [ ! -d .repo ]; then
    repo init -u https://github.com/LineageOS/android.git -b "$BRANCH" --git-lfs --depth=1
  fi
  mkdir -p .repo/local_manifests
  cp -v "$REPO_ROOT"/manifests/*.xml .repo/local_manifests/
  repo sync -c -j"$(nproc)" --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune
  df -h "$SRC_DIR" || true

  # Device/vendor trees that live in THIS repo get copied over the synced ones
  mkdir -p device/motorola/cancunn
  rsync -a --delete "$REPO_ROOT/device/motorola/cancunn/" device/motorola/cancunn/
  if [ -d "$REPO_ROOT/vendor/motorola/cancunn" ]; then
    mkdir -p vendor/motorola/cancunn
    rsync -a --delete "$REPO_ROOT/vendor/motorola/cancunn/" vendor/motorola/cancunn/
  fi
}

build() {
  cd "$SRC_DIR"
  export LC_ALL=C
  export USE_CCACHE=1
  export CCACHE_EXEC="$(command -v ccache)"
  export CCACHE_DIR
  export CCACHE_BASEDIR="$SRC_DIR"
  # Fresh syncs change file mtimes; without this ccache would miss on everything.
  export CCACHE_SLOPPINESS="include_file_ctime,include_file_mtime,time_macros"
  ccache -M 7G                     # GitHub's cache limit is 10 GB per repo
  ccache -o compression=true
  ccache -o compression_level=1
  ccache -z

  set +u
  # shellcheck disable=SC1091
  source build/envsetup.sh
  breakfast cancunn "$VARIANT"
  set -u
  mka $TARGET
}

case "${1:-}" in
  deps) deps ;;
  sync) sync_src ;;
  build) build ;;
  *) echo "usage: $0 deps|sync|build"; exit 1 ;;
esac
