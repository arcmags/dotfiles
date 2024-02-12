---
css: ../css/main.css
---

# Bluetooth Sniffing

[Bluetooth Low Energy][ble] and [Bluetooth Classic][bc] are two independent
things. Most newer devices use Bluetooth Low Energy (BLE). This guide is BLE
sniffing for these devices.

## Requirements

Hardware:
- [nRF52840 dongle][nRF52840] or something similar (e.g. [nRF51822 dongle][nRF51822])

Software:
- [Python][python]
- [Wireshark][wireshark]
- [nRF Sniffer][sniffer]

- add user to group `wireshark` and `uucp`

## Sniffing

It appears, unfortunately, that wireshark must be run as root in order to use
the nRF plugin.

[bc]: https://en.wikipedia.org/wiki/Bluetooth
[ble]: https://en.wikipedia.org/wiki/Bluetooth_Low_Energy
[nRF51822]: https://www.adafruit.com/product/2267
[nRF52840]: https://www.nordicsemi.com/Products/Development-hardware/nRF52840-Dongle
[python]: https://www.python.org/
[sniffer]: https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_sniffer_ble%2FUG%2Fsniffer_ble%2Fintro.html
[wireshark]: https://www.wireshark.org/

<!--metadata:
author: Chris Magyar <c.magyar.ec@gmail.com>
description: Bluetooth Low Energy sniffing basic instructions.
keywords: bluetooth, BLE, sniffing, wireshark, nrf sniffer
css: ../css/main.css
-->
