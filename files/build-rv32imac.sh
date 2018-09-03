#! /bin/bash
#
# Script to build RISC-V ISA simulator, proxy kernel, and GNU toolchain.
# Tools will be installed to $RISCV.
#
# Modified from https://github.com/riscv/riscv-tools/blob/f64eb74330786c20d788238d51581a5cbebf74cf/build-rv32ima.sh

. build.common

echo "Starting RISC-V Toolchain build process"

build_project riscv-fesvr --prefix=$RISCV
build_project riscv-isa-sim --prefix=$RISCV --with-fesvr=$RISCV --with-isa=rv32imac
build_project riscv-gnu-toolchain --prefix=$RISCV --with-arch=rv32imac --with-abi=ilp32
CC= CXX= build_project riscv-pk --prefix=$RISCV --host=riscv32-unknown-elf
build_project riscv-openocd --prefix=$RISCV --enable-remote-bitbang --disable-werror

echo -e "\\nRISC-V Toolchain installation completed!"
