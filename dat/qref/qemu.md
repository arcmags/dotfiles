# Qemu Quick Reference

## Examples:

Create image:

    # qemu-img create -f raw <IMAGE_FILE> <SIZE>G

Boot image and install iso:

    # qemu-system-x86_64 -cdrom <ISO_FILE> -boot order=d -m 4G -drive file=<IMAGE_FILE>,format=raw

Boot image:

    # qemu-system-x86_64 -m 4G -drive file=<IMAGE_FILE>,format=raw

## Options

    -vga virtio

        Use Virtio VGA card.  Allows display resizing.
        2023-12-30: broken, see https://gitlab.com/qemu-project/qemu/-/issues/2051

    -enable-kvm

        Start QEMU in KVM mode.

    -m <MEMORY>G

        Set machine RAM size.

    -display gtk,show-cursor=yes

        GTK display window, always show the mouse cursor.

## GUI Control

    C-M-g   release focus
    C-M-q   quit (WARNING: equal to pulling plug, be careful mashing hotkeys!)
    C-M-1   show guest operating system
    C-M-2   show qemu monitor
    C-M-f   fullscreen
    C-M-m   toggle menubar

## networking

User networking is the default mode. With this networking mode:
- performance is limited
- ping may not work on the guest without root privileges
- the guest is not accessible from the external network (without port forwarding)

Forward a port to redirect incoming host traffic to the guest:

    -device e1000,netdev=mynet0 -netdev user,id=mynet0,hostfwd=tcp::22222-:22

### bridged

Bridged networking is faster and allows the virtual machine to have its own IP
address accessible from other machines on the network.

Properly setup a network bridge (via ip commands manually or by configuring
network manager). Then add the bridge to */etc/qemu/bridge.conf*:

    allow br0

Use qemu option with root privileges:

    -nic bridge,model=virtio-net-pci

### random mac
