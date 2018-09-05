FROM buildpack-deps:bionic as builder
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && apt-get install -y git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

RUN git clone https://github.com/riscv/riscv-tools /root/source && cd /root/source && git submodule update --init --recursive

RUN mkdir -p /root/riscv
ENV RISCV /root/riscv

ADD files/build-rv32imac.sh /root/source/build-rv32imac.sh
RUN cd /root/source && ./build-rv32imac.sh

FROM buildpack-deps:bionic
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>
COPY --from=builder /root/riscv /riscv
RUN apt-get update && apt-get install -y device-tree-compiler && apt-get clean
ENV RISCV /riscv
ENV PATH "${PATH}:${RISCV}/bin"
CMD ["riscv32-unknown-elf-gcc", "--version"]
