#!/bin/sh

#############################
# Alpine Linux Installation #
#############################

# Define the root directory to /home/container.
# We can only write in /home/container and /tmp in the container.
ROOTFS_DIR=/home/container/tmp

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
[Pterodactyl Daemon]: Checking server disk space usage, this could take a few seconds...
[Pterodactyl Daemon]: Updating process configuration files...
[Pterodactyl Daemon]: Ensuring file permissions are set correctly, this could take a few seconds...
container@pterodactyl~ Server marked as starting...
[Pterodactyl Daemon]: Pulling Docker container image, this could take a few minutes to complete...
[Pterodactyl Daemon]: Finished pulling Docker container image
container@pterodactyl~ java -version
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment Temurin-17.0.9+9 (build 17.0.9+9)
OpenJDK 64-Bit Server VM Temurin-17.0.9+9 (build 17.0.9+9, mixed mode, sharing)
container@pterodactyl~ java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar server.jar
Starting org.bukkit.craftbukkit.Main
System Info: Java 17 (OpenJDK 64-Bit Server VM 17.0.9+9) Host: Linux 5.15.0-91-generic (amd64)
Loading libraries, please wait...
[08:37:08 INFO]: You need to agree to the EULA in order to run the server. Go to eula.txt for more info.
container@pterodactyl~ Server marked as offline...
[Pterodactyl Daemon]: ---------- Detected server process in a crashed state! ----------
[Pterodactyl Daemon]: Exit code: 0
[Pterodactyl Daemon]: Out of memory: false
[Pterodactyl Daemon]: Checking server disk space usage, this could take a few seconds...
[Pterodactyl Daemon]: Updating process configuration files...
[Pterodactyl Daemon]: Ensuring file permissions are set correctly, this could take a few seconds...
container@pterodactyl~ Server marked as starting...
[Pterodactyl Daemon]: Pulling Docker container image, this could take a few minutes to complete...
[Pterodactyl Daemon]: Finished pulling Docker container image
container@pterodactyl~ java -version
openjdk version "17.0.9" 2023-10-17
OpenJDK Runtime Environment Temurin-17.0.9+9 (build 17.0.9+9)
OpenJDK 64-Bit Server VM Temurin-17.0.9+9 (build 17.0.9+9, mixed mode, sharing)
container@pterodactyl~ java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar server.jar
Starting org.bukkit.craftbukkit.Main
System Info: Java 17 (OpenJDK 64-Bit Server VM 17.0.9+9) Host: Linux 5.15.0-91-generic (amd64)
Loading libraries, please wait...
[08:37:36 INFO]: Environment: Environment[sessionHost=https://sessionserver.mojang.com, servicesHost=https://api.minecraftservices.com, name=PROD]
[08:37:37 INFO]: Found new data pack file/bukkit, loading it automatically
[08:37:40 INFO]: No existing world data, creating new world
[08:37:43 INFO]: Loaded 1174 recipes
[08:37:43 INFO]: Loaded 1271 advancements
[08:37:44 INFO]: Starting minecraft server version 1.20.4
[08:37:44 INFO]: Loading properties
[08:37:44 INFO]: This server is running Paper version git-Paper-390 (MC: 1.20.4) (Implementing API version 1.20.4-R0.1-SNAPSHOT) (Git: f61ebdc)
[08:37:47 INFO]: Server Ping Player Sample Count: 12
[08:37:47 INFO]: Using 4 threads for Netty based IO
[08:37:48 INFO]: [ChunkTaskScheduler] Chunk system is using 1 I/O threads, 1 worker threads, and gen parallelism of 1 threads
[08:37:48 WARN]: [!] The timings profiler has been enabled but has been scheduled for removal from Paper in the future.
    We recommend installing the spark profiler as a replacement: https://spark.lucko.me/
    For more information please visit: https://github.com/PaperMC/Paper/issues/8948
[08:37:50 INFO]: Default game type: SURVIVAL
[08:37:50 INFO]: Generating keypair
[08:37:50 INFO]: Starting Minecraft server on 0.0.0.0:9042
[08:37:50 INFO]: Using epoll channel type
[08:37:50 INFO]: Paper: Using libdeflate (Linux x86_64) compression from Velocity.
[08:37:51 INFO]: Paper: Using OpenSSL 3.0.x (Linux x86_64) cipher from Velocity.
[08:37:51 INFO]: Preparing level "world"
[08:38:24 INFO]: Preparing start region for dimension minecraft:overworld
[08:38:25 INFO]: Time elapsed: 657 ms
[08:38:25 INFO]: Preparing start region for dimension minecraft:the_nether
[08:38:26 INFO]: Time elapsed: 403 ms
[08:38:26 INFO]: Preparing start region for dimension minecraft:the_end
[08:38:26 INFO]: Time elapsed: 229 ms
[08:38:26 INFO]: Running delayed init tasks
[08:38:26 INFO]: Done (41.970s)! For help, type "help"
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
/bin/sh -c "apk add tmux & tmux new-session -d -s gotty_session 'gotty -p 20012 -w ash'"
