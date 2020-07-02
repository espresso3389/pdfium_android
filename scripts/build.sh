#!/bin/bash -eu

LAST_KNOWN_GOOD_COMMIT=

scripts_dir=$(cd $(dirname $0) && pwd)
ANDROID_ABI=$1
# arm, arm64, x86, x64,...
GN_ARCH=$2
# Release or Debug
REL_OR_DBG=$3

DEPOT_DIR=$4

export PATH=$DEPOT_DIR:$PATH

# Build .so
IS_SHAREDLIB=true
# Not using clang for Android build
IS_CLANG=false

if [ $REL_OR_DBG = "Release" ]; then
    IS_DEBUG=false
    RELDBG_DIR=release
else
    IS_DEBUG=true
    RELDBG_DIR=debug
fi

if [ ! -f pdfium/.git/index ]; then
    #gclient config -vvv --unmanaged https://android.googlesource.com/platform/external/pdfium
    fetch --nohooks pdfium
    echo "target_os = [ 'android' ]" >> .gclient
    gclient sync -vvv
fi

cd pdfium
ROOTDIR=$(pwd)
BUILDDIR=$ROOTDIR/out/$RELDBG_DIR/$ANDROID_ABI

mkdir -p $BUILDDIR

if [ ! "$LAST_KNOWN_GOOD_COMMIT" = "" ]; then
  git reset --hard
  git checkout $LAST_KNOWN_GOOD_COMMIT
fi

# echo "Applying annot_render.patch..."
# git apply -v $scripts_dir/annot_render.patch

# Wow, in normal environment, it causes privilege error...
./build/install-build-deps-android.sh || true

cat <<EOF > $BUILDDIR/args.gn
is_clang = $IS_CLANG
use_custom_libcxx=false
target_os = "android"
target_cpu = "$GN_ARCH"
pdf_is_complete_lib = false
pdf_is_standalone = true
is_component_build = $IS_SHAREDLIB
is_debug = $IS_DEBUG
enable_iterator_debugging = $IS_DEBUG
pdf_enable_xfa = false
pdf_enable_v8 = false
# Reduce dependency to GLIBC
#use_glib = false
EOF

gn gen $BUILDDIR
ninja -C $BUILDDIR pdfium
