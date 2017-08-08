FROM debian:jessie

WORKDIR /workdir
ENV LINUX=/workdir/rpi-linux

# Install build dependencies
RUN apt-get update && \
  apt-get install -y bc build-essential curl git-core libncurses5-dev module-init-tools

# Install crosscompile toolchain for ARM64/aarch64
RUN mkdir -p /opt/linaro && \
  curl -sSL http://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-linux-gnueabihf/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf.tar.xz | tar xfJ - -C /opt/linaro
ENV CROSS_COMPILE=/opt/linaro/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

# Get the Linux kernel 4.9 source
RUN git clone --single-branch --branch rpi-4.9.y --depth 1 https://www.github.com/raspberrypi/linux $LINUX

COPY defconfigs/ /defconfigs/
COPY build-kernel.sh /
CMD ["/build-kernel.sh"]
