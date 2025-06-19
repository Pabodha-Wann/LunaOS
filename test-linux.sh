#!/bin/sh

qemu-system-i386 -drive format=raw,file=disk_images/lunaos.flp,index=0,if=floppy
