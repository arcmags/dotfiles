# Arch Linux and Windows 11 Dual Boot

These are some notes/instructions I made while setting up (*trying to setup*)
an Arch Linux and Windows 11 dual boot machine.

For over 15 years I've ran various dual boot Linux/Windows systems with very
few problems, until Windows 11.

## Hardware

- mobo: ASUS Prime B650M-F
- cpu: AMD Ryzen 7 9700X
- memory: 32GB DDR5
- gpu: AMD Radeon RX 7700 XT
- gpu: AMD Granite Ridge (builtin)
- audio: AMD Navi 31 (builtin)
- network: Realtek RTL8111/8168/8211/8411 PCI Express (builtin)
- storage: 2TB Samsung 990 EVO Plus NVME SSD
- storage: 2TB Crucial CT2000BX500 SATA SSD

Arch Linux on the NVME SSD, Windows on the SATA SSD.

## Installation

In the past, I have always setup my dual boot machines by installing Linux
first and allowing Windows to use the EFI partition created by Linux. Sometimes
this messes up the bootloader, but it's not hard to straighten out if you know
what you're doing, and it's generally a one-time fix.

I've usually (not always) installed Linux and Windows on separate drives,
meaning that the EFI partition and the Windows partition are generally (not
always) on separate drives.

### Linux First (issues)

- install Arch Linux on NVME drive
  - create EFI partition (on NVME drive) and mount to /boot
- install Windows on SATA drive
  - Windows detects and uses existing EFI partition on NVME drive
  - disable fast startup and hibernate in Windows
- add Windows menu entry to GRUB

After successful installation, Windows periodically gets a blue screen of death
saying that it cannot find the EFI partition.

TODO: A possible solution is to create the EFI partition on the SATA drive
instead of the NVME drive so that it's on the same drive as Windows?

### Windows First (issues)

- install Windows on SATA drive
  - Windows creates 100MB EFI partition
  - disable fast startup and hibernate in Windows
- install Arch Linux on NVME drive
  - create new EFI partition (on NVME drive) and mount to /boot
- add Windows menu entry to GRUB

After successful installation, if Windows is always launched directly from it's
own bootloader, that is, it's not chainloaded (from GRUB or rEFInd), everything
works fine.

However, when the Windows is launched by chainloading it's bootloader. ,it
fails the next time it's attempted to chainload. (GRUB: *error: no such device:
<UUID>*) (rEFInd: doesn't display a Windows option because it doesn't find a
bootloader in its scan) If Windows is launched again directly from it's own
bootloader, it seems to reset this and allow chainloading again (just once).

TODO: A possible solution is to use the EFI partition created by Windows so
it's on the same drive as Windows. (unfounded theory, but worth a shot)

TODO: A possible solution is to accept that Windows 11 sucks so bad it will
never dual boot properly, and to just always use the BIOS menu for boot
selection.

### Windows First (success)

- install Windows on SATA drive
  - Windows creates 100MB EFI partition
  - disable fast startup and hibernate in Windows
- install Arch Linux on NVME drive
  - mount EFI partition (on SATA drive) created by Windows to /efi
- add Windows menu entry to GRUB

This setup appears to work without any issues.

## Notes

### Fast Startup and Hibernation

Disable Windows 11 [fast startup][fs] in *Control Panel: Power Options*.
Confirm it's disabled with the powershell command:

    (GP "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")."HiberbootEnabled"

[fs]: https://www.elevenforum.com/t/turn-on-or-off-fast-startup-in-windows-11.1212/

<!--metadata:
author: Chris Magyar
description: Dual booting Arch Linux and Windows 11.
keywords: Windows 11, Arch Linux, Linux, dual boot
-->
