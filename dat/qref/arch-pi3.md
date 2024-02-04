---
title: Arch Linux ARM USB
author: Chris Magyar
description: Instructions for installing Arch Linux ARM on a USB
keywords: linux, archlinux, ARM, raspberry pi
toc: True
css: Null
---

This page explains how to  install Arch Linux ARM on a USB flash drive intended
to boot on a Raspberry Pi 3 or 4.

# USB

Determine the target USB device name:

    # lsblk

For the remainder of this page, the device name will be referred to as */dev/sdX*.

## wipe (optional)

Use dd to write the USB with all zeros, permanently erasing all data:

    # dd if=/dev/zero of=/dev/sdX status=progress && sync
