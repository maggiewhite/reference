## Cscope and ctags
Initialize using:
```
alias refresh='find  .                                               \
	-path "arch/arm*" ! -path "$LNX/arch/arm64*" -prune -o           \
	-path "tmp*" -prune -o                                           \
	-path "Documentation*" -prune -o                                 \
	-path "scripts*" -prune -o                                       \
        -name "*.[chxsS]" -print > cscope.files &&                   \
        cscope -Rbk -f cscope.out -i cscope.files &&                 \
        export CSCOPE_DB=cscope.out &&                               \
        ctags -L cscope.files'
```

Resources:
 - http://cscope.sourceforge.net/cscope_vim_tutorial.html

## Where are the source code files?
- `arch/arm64/boot/dts` : device tree files
- `arch/arm64/configs` : target defconfigs (compile parameters)
- `AndroidKernel.mk` : qcom kernel build file
- `build/build.sh` : pixel/google kernel build file
- `drivers/power/supply` : charger and power regulator drivers
- `drivers/pinctrl` : pin control drivers
- `drivers/thermal` : kernel level thermal mitigation (hwmon, thermal core)

### Pixel kernel
All Pixel kernel source can be viewed via web browser:
https://android.googlesource.com/kernel/msm/+refs

Instructions to download the souce code are here:
https://source.android.com/setup/build/building-kernels#downloading

### Qualcomm Android OS + kernel
Qualcomm Android OS releases (including kernels) can be found here:
https://wiki.codeaurora.org/xwiki/bin/QAEP/release

Check them out via:
```
repo init -q -u git://codeaurora.org/platform/manifest.git -b release -m <version>.xml --depth=1
# repo init -q -u git://codeaurora.org/platform/manifest.git -b release -m LA.UM.7.5.r1-05300-8x96.0.xml --depth=1
repo sync -q -c -j 4 --no-tags --no-clone-bundle
```

## Build commands
- `make defconfig` or `make savedefconfig`
  - compile or save target defconfig
- `BUILD_CONFIG=build.config.no-cfi SKIP_MRPROPER=1 build/build.sh`
  - build pixel kernel with no-cfi and skip clean (mrproper) to save compile time
- `make`
  - build qualcomm kernel

Note: You'll probably need to run the following from an Android OS source to set env variables:
```
source build/envsetup.sh && lunch $DEVICE-userdebug
```

If that isn't available, try the following for Pixel devices:
```
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-android-
```

## Flashing commands
To boot into the bootloader:
```
adb reboot bootloader
```

To quick boot into the specified image, but not install it:
```
fastboot boot Image.lz4-dtb
```

To install the image:
```
fastboot flash boot Image.lz4-dtb
```

TODO: add commands for dynamically loading kernel modules

## Good resources
- Good intro to Linux Kernel from a Bucharest university: https://linux-kernel-labs.github.io/
- Arpaci-Dusseau Operating Systems book: https://pages.cs.wisc.edu/~remzi/OSTEP/
