set FPGA_PART xc7z020clg484-1
set BOARD_PART "em.avnet.com:zed:part0:1.3"
set HDL_TOP ZedBoard_top

# Target specific Constriants to be read
# NB: we could just read the entire directory with 'add_files [glob $TARGET_DIR/const/*.xdc]
set CONSTRAINTS { \
            ZedBoard-pins_impl.xdc
}
            
# Target specific 'hardware' blocks to be read.
# These could be added to the autogenerated 'constraints.tcl'
set TGT_SRC { \
            pcap \
            zedboard_demo
}

# List of IP that can be targeted to this platform.
# NB: these could built as and when required.
set TGT_IP { \
}

