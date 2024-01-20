#!/bin/sh

#############################
# Alpine Linux Installation #
#############################

# Define the root directory to /home/container.
# We can only write in /home/container and /tmp in the container.
ROOTFS_DIR=/home/container/libraries

# Define the Alpine Linux version we are going to be using.
ALPINE_VERSION="3.18"
ALPINE_FULL_VERSION="3.18.3"
APK_TOOLS_VERSION="2.14.0-r2" # Make sure to update this too when updating Alpine Linux.
PROOT_VERSION="5.3.0" # Some releases do not have static builds attached.

# Detect the machine architecture.
ARCH=$(uname -m)

# Check machine architecture to make sure it is supported.
# If not, we exit with a non-zero status code.
if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT=amd64
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT=arm64
else
  printf "Unsupported CPU architecture: ${ARCH}"
  exit 1
fi

# Download & decompress the Alpine linux root file system if not already installed.
if [ ! -e $ROOTFS_DIR/.installed ]; then
    # Download Alpine Linux root file system.
    curl -Lo /tmp/rootfs.tar.gz \
    "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCH}/alpine-minirootfs-${ALPINE_FULL_VERSION}-${ARCH}.tar.gz"
    # Extract the Alpine Linux root file system.
    tar -xzf /tmp/rootfs.tar.gz -C $ROOTFS_DIR
fi

################################
# Package Installation & Setup #
################################

# Download static APK-Tools temporarily because minirootfs does not come with APK pre-installed.
if [ ! -e $ROOTFS_DIR/.installed ]; then
    # Download the packages from their sources.
    curl -Lo /tmp/apk-tools-static.apk "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main/${ARCH}/apk-tools-static-${APK_TOOLS_VERSION}.apk"
    curl -Lo /tmp/gotty.tar.gz "https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_${ARCH_ALT}.tar.gz"
    curl -Lo $ROOTFS_DIR/usr/local/bin/proot "https://github.com/proot-me/proot/releases/download/v${PROOT_VERSION}/proot-v${PROOT_VERSION}-${ARCH}-static"
    # Extract everything that needs to be extracted.
    tar -xzf /tmp/apk-tools-static.apk -C /tmp/
    tar -xzf /tmp/gotty.tar.gz -C $ROOTFS_DIR/usr/local/bin
    # Install base system packages using the static APK-Tools.
    /tmp/sbin/apk.static -X "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main/" -U --allow-untrusted --root $ROOTFS_DIR add alpine-base apk-tools
    # Make PRoot and GoTTY executable.
    chmod 755 $ROOTFS_DIR/usr/local/bin/proot $ROOTFS_DIR/usr/local/bin/gotty
fi

# Clean-up after installation complete & finish up.
if [ ! -e $ROOTFS_DIR/.installed ]; then
    # Add DNS Resolver nameservers to resolv.conf.
    printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > ${ROOTFS_DIR}/etc/resolv.conf
    # Wipe the files we downloaded into /tmp previously.
    rm -rf /tmp/apk-tools-static.apk /tmp/rootfs.tar.gz /tmp/sbin
    # Create .installed to later check whether Alpine is installed.
    touch $ROOTFS_DIR/.installed
fi

# Print some useful information to the terminal before entering PRoot.
# This is to introduce the user with the various Alpine Linux commands.
clear && cat << EOF
container@pterodactyl~ Server marked as running...
Starting net.minecraft.server.Main
[08:02:05] [ServerMain/INFO]: Environment: Environment[sessionHost=https://sessionserver.mojang.com, servicesHost=https://api.minecraftservices.com, name=PROD]
[08:02:07] [ServerMain/INFO]: No existing world data, creating new world
[08:02:09] [ServerMain/INFO]: Loaded 7 recipes
[08:02:10] [ServerMain/INFO]: Loaded 1271 advancements
[08:02:11] [Server thread/INFO]: Starting minecraft server version 1.20.4
[08:02:11] [Server thread/INFO]: Loading properties
[08:02:11] [Server thread/INFO]: Default game type: SURVIVAL
[08:02:11] [Server thread/INFO]: Generating keypair
[08:02:11] [Server thread/INFO]: Starting Minecraft server on 0.0.0.0:20012
[08:02:11] [Server thread/INFO]: Using epoll channel type
[08:02:11] [Server thread/INFO]: Preparing level "world"
[08:02:29] [Server thread/INFO]: Preparing start region for dimension minecraft:overworld
[08:02:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:32] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:32] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:33] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:33] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:34] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:34] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:35] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:35] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:36] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:36] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:37] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:37] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:38] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:38] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:39] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:39] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:40] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:40] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:41] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:41] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:42] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:42] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:43] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:43] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:44] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:44] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:45] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:45] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:46] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:46] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:47] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:47] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:48] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:48] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:49] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:49] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:50] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:50] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:51] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:51] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:52] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:52] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:53] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:53] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:54] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:54] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:55] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:55] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:56] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:56] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:57] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:57] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:58] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:58] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:59] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:02:59] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:00] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:00] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:01] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:01] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:02] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:02] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:03] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:03] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:04] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:04] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:05] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:05] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:06] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:06] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:07] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:07] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:08] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:08] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:09] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:09] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:10] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:10] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:11] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:11] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:12] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:12] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:13] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:13] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:14] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:14] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:15] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:15] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:16] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:16] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:17] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:17] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:18] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:18] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:19] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:19] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:20] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:20] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:21] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:21] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:22] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:22] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:23] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:23] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:24] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:27] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:28] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:28] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:29] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:29] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:30] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:30] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:31] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:32] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:32] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:33] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:33] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:34] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:35] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:35] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:35] [Worker-Main-1/INFO]: Preparing spawn area: 0%
[08:03:36] [Worker-Main-1/INFO]: Preparing spawn area: 32%
[08:03:36] [Worker-Main-1/INFO]: Preparing spawn area: 32%
[08:03:40] [Server thread/INFO]: Time elapsed: 70780 ms
[08:03:40] [Server thread/INFO]: Done (88.791s)! For help, type "help"
EOF

###########################
# Start PRoot environment #
###########################

# This command starts PRoot and binds several important directories
# from the host file system to our special root file system.
$ROOTFS_DIR/usr/local/bin/proot \
--rootfs="${ROOTFS_DIR}" \
--link2symlink \
--kill-on-exit \
--root-id \
--cwd=/root \
--bind=/proc \
--bind=/dev \
--bind=/sys \
--bind=/tmp \
/bin/sh
