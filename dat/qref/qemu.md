# Qemu Quick Reference

## Examples:

Create image:

    # qemu-img create -f raw <image_file> <size>G

Boot install iso with drive image loaded:

    # qemu-system-x86_64 -cdrom <iso_file> -boot order=d -m 4G -drive file=<image_file>,format=raw

Boot drive image:

    # qemu-system-x86_64 -m 4G -drive file=<image_file>,format=raw

Boot usb:

    # qemu-system-x86_64 -m 4G -drive file=</dev/sdx>

## Options

`-vga virtio`
: Use Virtio VGA card. Allows display resizing.

`-enable-kvm`
: Start QEMU in KVM mode.

`-m <memory>G`
: Set machine RAM size.

`-display gtk,show-cursor=yes`
: Enable GTK display window, always show the mouse cursor.

## GUI Control

`<c-m-g>`
: release focus

`<c-m-q>`
: quit (warning: equal to pulling plug)

`<c-m-1>`
: show guest operating system

`<c-m-2>`
: show qemu monitor

`<c-m-f>`
: fullscreen

`<c-m-m>`
: toggle menubar

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

Use qemu option:

    -nic bridge,model=virtio-net-pci

### random mac
