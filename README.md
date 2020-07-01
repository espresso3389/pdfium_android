# pdfium_android
Building pdfium for Android.

## Install build toolchains.

```
sudo apt-get install build-essential cmake python
```

## Install Android NDK

Download and unzip Android NDK from [NDK Download](https://developer.android.com/ndk/downloads).

## set ANDROID_NDK_ROOT

`ANDROID_NDK_ROOT` should point to the directory you just placed the Android NDK.

## Run cmake

```
cmake . -DPDFIUM_ARCH=arm64
```

The script may prompt you to input your password to sudo-install certain prerequisites packages (see [Install additional build dependencies - Checking out and building Chromium for Android](https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md#install-additional-build-dependencies) for more).

## References

- [CMake - Android Developers > NDK > Guides](https://developer.android.com/ndk/guides/cmake?#command-line)
- [Checking out and building Chromium for Android](https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md)
