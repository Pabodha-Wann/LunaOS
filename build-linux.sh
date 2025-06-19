#!/bin/sh

# This script automates the build process for LunaOS.

# --- Configuration ---
OS_NAME="lunaos"
IMAGE_DIR="disk_images"
FLOPPY_IMG="$IMAGE_DIR/$OS_NAME.flp"
ISO_IMG="$IMAGE_DIR/$OS_NAME.iso"
BOOTLOADER_SRC="bootload/bootload.asm"
BOOTLOADER_BIN="bootload/bootload.bin"
KERNEL_SRC="kernel.asm"
KERNEL_BIN="KERNEL.BIN" 

# --- Create directories if they don't exist ---
mkdir -p $IMAGE_DIR

# --- Create a new floppy image if it doesn't exist ---
if [ ! -e $FLOPPY_IMG ]; then
	echo ">>> Creating new $OS_NAME floppy image..."
	mkdosfs -C $FLOPPY_IMG 1440 || exit
fi

echo ">>> Assembling bootloader..."
nasm -f bin -o $BOOTLOADER_BIN $BOOTLOADER_SRC || exit

echo ">>> Assembling kernel..."
nasm -f bin -o $KERNEL_BIN $KERNEL_SRC || exit

echo ">>> Writing bootloader to floppy image..."
dd status=noxfer conv=notrunc if=$BOOTLOADER_BIN of=$FLOPPY_IMG || exit

echo ">>> Copying kernel to floppy image..."
mcopy -i $FLOPPY_IMG $KERNEL_BIN ::/ || exit

echo ">>> Creating CD-ROM ISO image..."
rm -f $ISO_IMG
mkisofs -quiet -V 'LunaOS' -input-charset iso8859-1 -o $ISO_IMG -b $(basename $FLOPPY_IMG) $IMAGE_DIR/ || exit

echo '>>> Done!'