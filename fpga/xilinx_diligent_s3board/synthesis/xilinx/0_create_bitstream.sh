#!/bin/tcsh
######################################################
#                                                    #
# Xilinx Synthesis, Place & Route script for LINUX   #
#                                                    #
######################################################

# Cleanup
rm -rf ./WORK
mkdir WORK
cd ./WORK

# Create links for RAM & ROM ngc files
ln -s ../../../rtl/verilog/coregen/ram_8x512_hi.ngc .
ln -s ../../../rtl/verilog/coregen/ram_8x512_lo.ngc .
ln -s ../../../rtl/verilog/coregen/rom_8x2k_hi.ngc  .
ln -s ../../../rtl/verilog/coregen/rom_8x2k_lo.ngc  .

# Create link to the Xilinx constraints file
ln -s ../scripts/openMSP430_fpga.ucf                .

# Create link to the TimerA include file
ln -s ../../../rtl/verilog/openmsp430/periph/omsp_timerA_defines.v    .
ln -s ../../../rtl/verilog/openmsp430/periph/omsp_timerA_undefines.v  .


# XFLOW
#---------------
xflow -p 3S200FT256-4 -implement high_effort.opt            \
                      -config    bitgen.opt                 \
                      -synth     ../scripts/xst_verilog.opt \
                      ../scripts/openMSP430_fpga.prj

# MANUAL FLOW
#---------------

#xst      -intstyle xflow    -ifn ../openMSP430_fpga.xst

#ngdbuild -p xc3s200-4-ft256 -uc  ../openMSP430_fpga.ucf openMSP430_fpga

#map -k 6 -detail -pr b openMSP430_fpga

#par -ol med -w openMSP430_fpga.ncd openMSP430_fpga

#trce -e -o openMSP430_fpga_err.twr openMSP430_fpga
#trce -v -o openMSP430_fpga_ver.twr openMSP430_fpga

#bitgen -w -g UserID:5555000 -g DonePipe:yes -g UnusedPin:Pullup openMSP430_fpga


cd ..

cp -f ./WORK/openMSP430_fpga.bit ./bitstreams/.
