---
css: css/main.css
---

# Bluetooth Sniffing

[Bluetooth Classic][bc] and [Bluetooth Low Energy][ble] are two independent
things. It seems most information out there is Bluetooth Low Energy (BLE).
That's what I'll be dealing with in this document.


## Requirements

You need a card/dongle capable of sniffing. Apparently this company called
[Nordic Semiconductor][nordicsemi] is the main player. This [nRF52840
dongle][nRF52840] seems to be the go-to device for sniffing. I have a [nRF51822
dongle][nRF51822] that works as well. You need [Wireshark][wireshark],
[Python][python], and [nRF Sniffer][sniffer].

## Sniffing

[bc]: https://en.wikipedia.org/wiki/Bluetooth
[ble]: https://en.wikipedia.org/wiki/Bluetooth_Low_Energy
[nRF51822]: https://www.adafruit.com/product/2267
[nRF52840]: https://www.nordicsemi.com/Products/Development-hardware/nRF52840-Dongle
[nordicsemi]: https://www.nordicsemi.com
[python]: https://www.python.org/
[sniffer]: https://infocenter.nordicsemi.com/index.jsp?topic=%2Fug_sniffer_ble%2FUG%2Fsniffer_ble%2Fintro.html
[wireshark]: https://www.wireshark.org/

<!--metadata:
author: Chris Magyar <c.magyar.ec@gmail.com>
description: Bluetooth Low Energy sniffing basic instructions.
keywords: bluetooth, BLE, sniffing, wireshark, nrf sniffer
css: css/main.css
-->
