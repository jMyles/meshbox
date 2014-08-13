meshbox
=======

This is the OpenWrt package feed for the [meshbox][meshbox] project.

Use it to turn a OpenWrt device into a mesh networking device using cjdns.  
It provides UCI and LuCI integration for [cjdns][cjdns].

Tested with OpenWrt Chaos Calmer (r42153).

[meshbox]: http://fund.meshwith.me
[cjdns]: https://github.com/cjdelisle/cjdns

###(Before we begin)

If you are using Debian / Ubuntu, you may want to ensure that these packages are installed:

    libncurses5-dev gawk subversion git mercurial tftp

---

#Integrating the package with OpenWrt

## Clone OpenWrt


    $ git clone git://git.openwrt.org/openwrt.git
    $ cd openwrt
    $ cp feeds.conf.default feeds.conf

## Add meshbox to the buildroot

####Option 1: Add the meshbox git repository to the OpenWrt feeds list.

    $ echo 'src-git meshbox git://github.com/seattlemeshnet/meshbox.git' >> feeds.conf

####Option 2: Clone the meshbox repo and use your local copy.

    $ echo 'src-link meshbox /path/to/meshbox' >> feeds.conf

## Update the feeds and install the package

Whichever option you've chosen, you'll need to update your feeds:

    $ ./scripts/feeds update
    $ ./scripts/feeds install luci-cjdns


#Building

You'll need to know the chipset of the device for which you intend to build your OpenWrt with meshbox.

You're going to use menuconfig to set a few settings for the build.

    (not as root!)
    $ make menuconfig

Once menuconfig is open, you have two primary goals:

####1. Apply your typical OpenWrt build settings, such as target system and profile.

For help on this part, see the "Image Configuration" section of this document: http://wiki.openwrt.org/doc/howto/build

####2. Enable the luci-dns module

    (using the menus in menuconfig)
    LuCI -> Collections -> [*] luci
    LuCI -> Collections -> [*] luci-ssl (if you want ssl)
    LuCI -> Project Meshnet -> [*] luci-cjdns
    Network -> Routing and Redirection ---> -*- cjdns

    (for your local language)
    LuCI -> Tranlations ---> luci-i18n-<your language>

(You'll need to hit space twice to make these `[*]` rather than `[M]`.)


##Almost there - final steps

Save and close the configuration menu, and allow OpenWrt to resolve dependencies:

    $ make defconfig

Then build:

    $ make

If you have a multicore processor, you can build faster using `-j`, however the OpenWrt build process is not highly parallelized so your milage may vary.  In any case, it takes a good minute to compile, so you might want to cuddle up with the CJDNS whitepaper: https://github.com/cjdelisle/cjdns/blob/master/doc/Whitepaper.md

    $ make -j4 V=s 1>output.log 2>error.log
    (Use four cores, log stdout and stderror to separate files)

# Flashing

##Use a compiled binary to flash with OpenWrt

If the build is successful you will have compiled firmware binaries in the following directory:

    bin/<name of target system>/<chipset binary>

  ie: `openwrt/bin/ar7xx/openwrt-ar71xx-generic-tl-wdr3500-v1-squashfs-factory.bin`

On some AP's, you can use the OpenWrt firmware upgrade tool to flash the binary from a web interface (LuCi)
`http://192.168.1.1`

(Tested on: TP-Link WDR-3500 v1)

# Advanced Topics (only tested on Barrier Breaker)

## Flash using the flash.sh script:

you can use the flash.sh script to flash your device via tftp.

The script is located in `/scripts/flashing/flash.sh`

    Usage: ./flash.sh firmware vendor

## Using a local copy of CJDNS to compile:


If you want to use a local clone of cjdns itself, edit `<meshbox>/cjdns/Makefile`:

    PKG_SOURCE_URL:=file:///path/to/cjdns
    PKG_SOURCE_PROTO:=git
    PKG_SOURCE_VERSION:=master

  *Make sure to commit your changes to cjdns before building the
   package. The OpenWrt buildroot will clone the local cjdns into
   the build directory, omitting uncommitted changes.*

        $ cd <path to cjdns>
        $ git add <name of .config file> && git commit -a -m "<commit message>"

Then continue with the "Building" section above.

## Building an .ipkg for opkg install:

Alternativly to flashing via tftp, you can integrate meshbox and cjdns into an
existing OpenWrt installation.

Build a fresh package from the compiled firmware to copy and install via ssh.

    $ cd <path to OpenWrt>

####You'll need to delete the last clone everytime you compile the .ipkg.

    $ rm dl/cjdns-*

####Now, make the .ipkg.

    make package/cjdns/{clean,compile} V=s

This will write a number of chipset specific binaries to `<openWrt>/bin/<name of target system>`

####Then, scp the package to your device.

    scp bin/<name of target system>/packages/cjdns*.ipkg root@<ip>:/tmp/cjdns.ipkg

####Finally, remotely install the .ipkg from the device.

    ssh root@<ip> 'opkg install /tmp/cjdns.ipkg'




TODO
----

- [ ] Strip down the binary size and keep everything under 4MB
- [ ] Figure out NAT6 configuration
- [ ] Improve UI wording
- [ ] Introduce proper package versions
- [ ] Extend list of active peers
  - [ ] should show the used interface, and the password name
  - [ ] show data rx/tx since connected, other peerinfo data
- [ ] Visualize traffic in graphs
- [ ] Fill in useful default values for new UDP/ETHInterfaces
- [ ] Autogenerate passwords in the Peers UI
- [ ] Generate addpass.py-like password JSON
- [ ] Make paste-friendly textbox containing "yourip:port":{pass,key,name,info}
