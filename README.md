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


## Troubleshooting

If you're on WSL2, you may encounter snapd issues. The following project provides a workaround for the issue:

https://github.com/DamionGans/ubuntu-wsl2-systemd-script

## References

- [CMake - Android Developers > NDK > Guides](https://developer.android.com/ndk/guides/cmake?#command-line)
- [Checking out and building Chromium for Android](https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md)
