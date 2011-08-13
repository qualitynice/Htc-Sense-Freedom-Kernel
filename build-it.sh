#!/bin/bash
# Build the kernel without thinking.

MY_HOME=$(pwd)
AUTO_SIGN="$MY_HOME/prebuilt/auto-sign"
USE_PREBUILT="$MY_HOME/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
ANY_MODULES="$MY_HOME/any-kernel/system/lib/modules"
ANY_MODULES_SYN_NIGHTLY="$MY_HOME/any-kernel/data/Synergy-System/system.lib/modules"
ANY_KERNEL="$MY_HOME/any-kernel/kernel"
ANY_KERNEL_HOME="$MY_HOME/any-kernel"
ANY_KERNEL_UPDATER_SCRIPT="$ANY_KERNEL_HOME/META-INF/com/google/android/updater-script"
PLACEHOLDER="$ANY_MODULES/PLACEHOLDER"
DATE=$(date +%Y%m%d%H%M)

#################################################################
# Start of the functions for this script 			#
# This is written by lithid 					#
#################################################################

function move_defconfig(){
cp $MY_HOME/arch/arm/configs/$MY_CONFIG $MY_HOME/.config
if [ -f $MY_HOME/.config ]; then
	echo "[x] .config"
else
	echo "No .config file found. Can't Proceed."
	exit 98
fi
}

function check_finished_paths(){
if [ -f $CHECK_PATH ]; then
	cp $CHECK_PATH $FINAL_PATH
else
	echo "Sorry Somthing went wrong and your $CHECK_PATH isn't there: EXITING"
	exit 97
fi
}

function the_freedom_folders(){
if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
	if [ -d $HOME/Freedom/$TITLE/ ]; then
		mv $AUTO_SIGN/$THIS_ZIP-signed $HOME/Freedom/$TITLE/$THIS_ZIP_SIGNED
	else
		mkdir -p $HOME/Freedom/$TITLE/
		mv $AUTO_SIGN/$THIS_ZIP-signed $HOME/Freedom/$TITLE/$THIS_ZIP_SIGNED
	fi
else
	if [ -d $HOME/Freedom/Stock/ ]; then
		mv $AUTO_SIGN/$THIS_ZIP-signed $HOME/Freedom/Stock/$THIS_ZIP_SIGNED
	else
		mkdir -p $HOME/Freedom/Stock/
		mv $AUTO_SIGN/$THIS_ZIP-signed $HOME/Freedom/Stock/$THIS_ZIP_SIGNED
	fi
fi
}

function just_sign_the_fucking_zip(){
cd $ANY_KERNEL_HOME
zip -r $THIS_ZIP * &>> /dev/null
mv $THIS_ZIP $AUTO_SIGN/
cd $AUTO_SIGN
java -jar signapk.jar certificate.pem key.pk8 $THIS_ZIP $THIS_ZIP-signed
rm $THIS_ZIP
if [ -d $HOME/Freedom/ ]; then
	the_freedom_folders	
else
	mkdir -p $HOME/Freedom/
	the_freedom_folders
fi
cd $MY_HOME
}

function universal_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$NUM/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("FREEDOM");
ui_print("Version: _VER_");
ui_print("Type: Universal");
ui_print("Developed by: Lithid         Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
ui_print("Extracting System Files...");
mount("MTD", "system", "/system");
package_extract_dir("system", "/system");
unmount("/system"); 
show_progress(0.500000, 20);
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
show_progress(0.500000, 30);
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
show_progress(0.500000, 50);
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
show_progress(0.500000, 60);
run_program("/tmp/mkbootimg.sh");
show_progress(0.500000, 80);
write_raw_image("/tmp/newboot.img", "boot");
ui_print("Your now running Lithid's Sense Kernel!!");
show_progress(0.500000, 100);
EOF
}

function syn_nightly_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$NUM/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("FREEDOM");
ui_print("Version: _VER_");
ui_print("Type: Synergy Nightly");
ui_print("Developed by: Lithid         Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
mount("MTD", "userdata", "/data");
package_extract_dir("data", "/data");
set_perm_recursive(0, 0, 0755, 0644, "/data/Synergy-System/system.lib/modules");
unmount("/data");
mount("MTD", "system", "/system");
package_extract_dir("system", "/system");
set_perm_recursive(0, 0, 0755, 0644, "/system/lib/modules");
set_perm_recursive(0, 0, 0755, 0755, "/system/etc/init.d");
unmount("/system");
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
run_program("/tmp/mkbootimg.sh");
format("MTD", "boot");
write_raw_image("/tmp/newboot.img", "boot");ui_print("");
format ("MTD", "cache");
ui_print("Your now running Lithid's Sense Kernel for Synergy nightly!");
EOF
}

function synergy_godmode_updater_script(){
rm $ANY_KERNEL_UPDATER_SCRIPT
(cat << EOF) | sed s/_VER_/$NUM/g > $ANY_KERNEL_UPDATER_SCRIPT
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("FREEDOM");
ui_print("Version: _VER_");
ui_print("Type: GodMode");
ui_print("Developed by: Lithid         Device: HTC Evo 4g");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("     Using: AnyKernel Updater by Koush.");
ui_print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
ui_print("");
set_progress(1.000000); 
ui_print("Extracting System Files...");
run_program("/sbin/busybox", "mkdir", "/system0");
run_program("/sbin/busybox", "mount", "-t", "auto", "/dev/block/mtdblock4", "/system0");
run_program("/sbin/busybox", "mount", "-t", "ext2", "-o", "loop", "/system0/system.img", "/system");
package_extract_dir("system", "/system");
unmount("/system");
unmount("/system0");;
show_progress(0.500000, 20);
ui_print("Extracting Kernel files...");
package_extract_dir("kernel", "/tmp");
ui_print("Installing kernel...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
show_progress(0.500000, 30);
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
show_progress(0.500000, 50);
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
show_progress(0.500000, 60);
run_program("/tmp/mkbootimg.sh");
show_progress(0.500000, 80);
write_raw_image("/tmp/newboot.img", "boot");
ui_print("Freedom Kernel for Synergy Godmode Complete!");
show_progress(0.500000, 100);
EOF
}

function remove_syn_nightly_fix(){
if [ -d $ANY_MODULES_SYN_NIGHTLY ]; then
	rm -r $ANY_KERNEL_HOME/data &>> /dev/null
fi

if [ -d $ANY_MODULES ]; then
	echo "$ANY_MODULES is here" &>> /dev/null
else
	mkdir -p $ANY_MODULES &>> /dev/null
fi
}

function universal_modules_kernel_migration(){
remove_syn_nightly_fix

# For flash_image
mkdir -p $ANY_KERNEL_HOME/system/bin/
cp $MY_HOME/prebuilt/tools/flash_image $ANY_KERNEL_HOME/system/bin/ &>> /dev/null

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

if [ "$TYPE" == "SYNERGY_GODMODE" ]; then
	synergy_godmode_updater_script
	if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
		sed "s/FREEDOM/$TITLE-FREEDOM/g" $ANY_KERNEL_UPDATER_SCRIPT > tmp
		mv tmp $ANY_KERNEL_UPDATER_SCRIPT
	fi
elif [ "$TYPE" == "UNIVERSAL" ]; then
	universal_updater_script
	if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
		sed "s/FREEDOM/$TITLE-FREEDOM/g" $ANY_KERNEL_UPDATER_SCRIPT > tmp
		mv tmp $ANY_KERNEL_UPDATER_SCRIPT
	fi
else
	echo "You are trying to use an updater that isn't correct"
	exit 93
fi
}

function syn_nightly_modules_kernel_migration(){
if [ -d $ANY_MODULES ]; then
	rm -r $ANY_KERNEL_HOME/system &>> /dev/null
fi

if [ -d $ANY_MODULES_SYN_NIGHTLY  ]; then
	echo "Using Path: $ANY_MODULES_SYN_NIGHTLY "
else
	mkdir -p $ANY_MODULES_SYN_NIGHTLY 
fi


# For flash_image
mkdir -p $ANY_KERNEL_HOME/system/bin/
cp $MY_HOME/prebuilt/tools/flash_image $ANY_KERNEL_HOME/system/bin/

# For the modules
CHECK_PATH="$MY_HOME/drivers/net/wimax/SQN/sequans_sdio.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxdbg/wimaxdbg.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wimax/wimaxuart/wimaxuart.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths
CHECK_PATH="$MY_HOME/drivers/net/wireless/bcm4329_204/bcm4329.ko"
FINAL_PATH="$ANY_MODULES_SYN_NIGHTLY/"
check_finished_paths

# For the kernel
CHECK_PATH="$MY_HOME/arch/arm/boot/zImage"
FINAL_PATH="$ANY_KERNEL/"
check_finished_paths

if [ "$TYPE" == "SYN_NIGHTLY" ]; then
	syn_nightly_updater_script
	if [ "$TITLE" == "Less" ] || [ "$TITLE" == "More" ] || [ "$TITLE" == "Aggressive" ]; then
		sed "s/FREEDOM/$TITLE-FREEDOM/g" $ANY_KERNEL_UPDATER_SCRIPT > tmp
		mv tmp $ANY_KERNEL_UPDATER_SCRIPT
	fi
		
	
else
	echo "Something went wrong. Sorry"
	exit 95
fi

}

function clean_up_build(){
echo "Cleaning things up a bit"
make distclean
remove_syn_nightly_fix
rm $ANY_MODULES/*.ko &>> /dev/null
rm $ANY_KERNEL/zImage &>> /dev/null
rm $AUTO_SIGN/*.zip &>> /dev/null
rm -rf $ANY_KERNEL_HOME/system/bin/
universal_updater_script
touch $MY_HOME/any-kernel/system/lib/modules/PLACEHOLDER
}

function build_the_blessed_kernel(){
if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
	sed "s/CONFIG_LOCALVERSION=".*"/CONFIG_LOCALVERSION="\"-$TITLE-Freedom-$NUM\""/g" .config > tmp
else
	sed "s/CONFIG_LOCALVERSION=".*"/CONFIG_LOCALVERSION="\"-Freedom-$NUM\""/g" .config > tmp
fi

mv tmp .config

export COMPILER=$USE_PREBUILT

make -j$(grep -ic ^processor /proc/cpuinfo) ARCH=arm CROSS_COMPILE=$COMPILER &>> $HOME/FREEDOM-$DATE.log

TYPE="UNIVERSAL"
universal_modules_kernel_migration
if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
	THIS_ZIP="$TITLE-Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="$TITLE-Freedom-$NUM-$TYPE-signed.zip"
else
	THIS_ZIP="Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="Freedom-$NUM-$TYPE-signed.zip"
fi
just_sign_the_fucking_zip

TYPE="SYN_NIGHTLY"
syn_nightly_modules_kernel_migration
if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
	THIS_ZIP="$TITLE-Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="$TITLE-Freedom-$NUM-$TYPE-signed.zip"
else
	THIS_ZIP="Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="Freedom-$NUM-$TYPE-signed.zip"
fi
just_sign_the_fucking_zip

TYPE="SYNERGY_GODMODE"
universal_modules_kernel_migration
if [ "$TITLE" = "Less" ] || [ "$TITLE" = "More" ] || [ "$TITLE" = "Aggressive" ]; then
	THIS_ZIP="$TITLE-Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="$TITLE-Freedom-$NUM-$TYPE-signed.zip"
else
	THIS_ZIP="Freedom-$NUM-$TYPE.zip"
	THIS_ZIP_SIGNED="Freedom-$NUM-$TYPE-signed.zip"
fi
just_sign_the_fucking_zip
}

function progress(){
echo -n "Building $CURRENT Please wait..."
while true
do
     echo -n "."
     sleep 5
done
}

function progress_do(){
move_defconfig
CURRENT=$(grep 'FREEDOM_VERSION=y' .config |cut -d "=" -f1)
progress &
MYSELF=$!
build_the_blessed_kernel
kill $MYSELF &>> /dev/null
echo -n "...done."
echo ""
clean_up_build
}

function the_basics(){
if [ -f $PLACEHOLDER ]; then
	rm $PLACEHOLDER
fi

echo -n "What is this version number? > "
read NUM
}

#################################################################
# Start of the script 						#
# This is written by lithid 					#
#################################################################

if [ "$1" = "--ALL" ]; then

	the_basics
	MY_CONFIG="freedom_supersonic_defconfig"
	TITLE=""
	progress_do
	MY_CONFIG="freedom-less_supersonic_defconfig"
	TITLE="Less"
	progress_do
	MY_CONFIG="freedom-more_supersonic_defconfig"
	TITLE="More"
	progress_do
	MY_CONFIG="freedom-aggressive_supersonic_defconfig"
	TITLE="Aggressive"
	progress_do

elif [ "$1" = "-F" ]; then

	the_basics
	MY_CONFIG="freedom_supersonic_defconfig"
	TITLE=""
	progress_do

elif [ "$1" = "-L" ]; then

	the_basics
	MY_CONFIG="freedom-less_supersonic_defconfig"
	TITLE="Less"
	progress_do

elif [ "$1" = "-M" ]; then

	the_basics
	MY_CONFIG="freedom-more_supersonic_defconfig"
	TITLE="More"
	progress_do

elif [ "$1" = "-A" ]; then

	the_basics
	MY_CONFIG="freedom-aggressive_supersonic_defconfig"
	TITLE="Aggressive"
	progress_do

elif [ $1 == "--help" ]; then
	echo "Usage: build-it.sh [OPTION]"
	echo "Here is a list of available options:"
	echo "-F	| Build Stock Freedom"
	echo "-L	| Build Less Freedom -50mv"
	echo "-M	| Build More Freedom -100mv"
	echo "-A	| Build Aggresive Freedom -150mv"
	echo "-ALL	| Build all versions"
	exit 0
else
	echo "Written by Lithid"
        echo "[Error]: Expected 1 parameter, got $#."
	echo "Please type --help for help using this script"
        exit 0
fi

THIS_ZIP_SIGNED="*Freedom-*signed.zip"
FINAL_LOG=$(find $HOME -iname FREEDOM-*.log |grep -v .local)
FINAL_INSTALL_ZIP=$(find $HOME -iname $THIS_ZIP_SIGNED |grep -v .local)
echo ""
echo ""
echo "Your files are located:"
echo "$FINAL_INSTALL_ZIP"
echo ""
echo "Your log file is located >> $FINAL_LOG"

exit
