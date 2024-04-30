##Network Issues

Starting from the Arch Linux WiFi configuration page, firstly check the driver
status.

```
$ lspci -k

03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] (rev 34)
        Subsystem: Intel Corporation Centrino Advanced-N 6205 AGN
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
```

Then check the output of the `ip link` command.

```
$ ip link

3: wlp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DORMANT group default qlen 1000
    link/ether 4e:63:cd:3b:e0:b7 brd ff:ff:ff:ff:ff:ff permaddr a0:88:b4:02:eb:50
```

Try to bring the interface up.

```
$ sudo ip link set wlp3s0 up
```

Then check kernel messages for firmware being loaded.

```
$ sudo dmesg | grep firmware
```

This is where I hit the issue.  The message returned is:-

```
[   11.056431 ] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   11.492820 ] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 6000g2a-6.ucode op_mode iwldvm
```
If this had been successful then running `$ sudo dmesg | grep iwlwifi` should
show all the related info.

At this point it's time to hit Stack Overflow.

After all of that I went back to fundamentals and discovered running nmtui did
the trick. Jeesh

Other useful commands.

nmcli

nmcli connection show

nmcli device wifi rescan


Continuing on my quest to master the vagaries of Linuxes WiFi, I thought it
might be useful to be able to have the SSID in my i3-bar.  Here's where I'm at
so far:-

1. We need to discover the interface that is being used for WiFi.

```
find -H /sys/class/net/* -name wireless | cut -d / -f 5

# returns the wireless interface, or if fd is installed

fd wireless /sys/class/net/* | cut -d / -f 5

cat /proc/net/wireless | perl -ne '/(\w+):/ && print $1'

# This will also return the interface being used.

# The result of this can then be passed into iwconfig

iwconfig wlp3s0 | grep -oE 'ESSID:".*"' | sed 's/ESSID://g' | sed 's/"//g'

# This will return the SSID

```
