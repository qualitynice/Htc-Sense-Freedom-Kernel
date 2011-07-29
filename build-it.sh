#!/bin/bash
# Build the kernel without thinking.

if [ $# -ne 1 ]; then
	echo "Written by Lithid"
        echo "[Error]: Expected 1 parameter, got $#."
        echo "Usage: sh build-it.sh v# [BUILD VERSION]"
        exit 99
else
	echo "[x] $1"
fi

MY_HOME=$(pwd)
AUTO_SIGN="$MY_HOME/prebuilt/auto-sign"
USE_PREBUILT="$MY_HOME/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
ANY_MODULES="$MY_HOME/any-kernel/system/lib/modules"
ANY_KERNEL="$MY_HOME/any-kernel/kernel"
ANY_KERNEL_HOME="$MY_HOME/any-kernel"
DATE=$(date +%m%d%Y)

if [ -f $MY_HOME/.config ]; then
	echo "[x] .config"
else
	echo "No .config file found. Can't Proceed."
	exit 98
fi

function check_finished_paths(){
if [ -f $CHECK_PATH ]; then
	echo "Moving $CHECK_PATH to any-kernel-updater"
	cp $CHECK_PATH $FINAL_PATH
else
	echo "Sorry Somthing went wrong and your $CHECK_PATH isn't there: EXITING"
	exit 97
fi
}

echo "Cleaning the build"
make clean |grep -v "arm-eabi-gcc:"
echo "Cleaning the any-kernel modules"
rm $ANY_MODULES/*.ko &>> /dev/null
echo "Cleaning the any-kernel zimage"
rm $ANY_KERNEL/zImage &>> /dev/null
echo "Cleaning the auto-sign folder"
rm $AUTO_SIGN/*.zip &>> /dev/null

sed "s/CONFIG_LOCALVERSION=".*"/CONFIG_LOCALVERSION="\"$1\""/g" .config > tmp
mv tmp .config

echo "Using pre-built tool: $USE_PREBUILT"
export COMPILER=$USE_PREBUILT

make -j2 ARCH=arm CROSS_COMPILE=$COMPILER

# For the modules
CHECK_PATH="$MY_HOME/drivers/net/wimax/SQN/sequans_sdio.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxdbg/wimaxdbg.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxuart/wimaxuart.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wireless/bcm4329_204/bcm4329.ko"
FINAL_PATH="$ANY_MODULES/"
check_finished_paths

# For the kernel
CHECK_PATH="$MY_HOME/arch/arm/boot/zImage"
FINAL_PATH="$ANY_KERNEL/"
check_finished_paths

THIS_ZIP="Lithid-Kernel-$1.zip"
THIS_ZIP_SIGNED="Lithid-Kernel-$1-signed.zip"
cd $ANY_KERNEL_HOME
zip -r $THIS_ZIP *
mv $THIS_ZIP $AUTO_SIGN/
cd $AUTO_SIGN
echo "Signing $THIS_ZIP"
java -jar signapk.jar certificate.pem key.pk8 $THIS_ZIP $THIS_ZIP-signed
rm $THIS_ZIP
mv $THIS_ZIP-signed $HOME/$THIS_ZIP_SIGNED
cd $MY_HOME

FINAL_INSTALL_ZIP=$(find $HOME -iname $THIS_ZIP_SIGNED)
echo ""
echo "Your file is located: $FINAL_INSTALL_ZIP"

exit
