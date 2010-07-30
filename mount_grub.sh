#!/bin/sh

gksudo losetup /dev/loop0 files/grub_disk.img
mount -t /dev/loop0
