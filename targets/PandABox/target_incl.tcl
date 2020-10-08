set FPGA_PART xc7z030sbg485-1
set BOARD_PART "em.avnet.com:picozed_7030:part0:1.0"
set HDL_TOP PandABox_top

# Target specific Constriants to be read
# NB: we could just read the entire directory with 'add_files [glob $TARGET_DIR/const/*.xdc]
set CONSTRAINTS { \
                PandABox-pins_impl.xdc \
                PandABox-freq.xdc \
                PandABox-clks_impl.xdc
}

# Target specific 'hardware' blocks to be read.
# These could be added to the autogenerated 'constraints.tcl'
set TGT_SRC { \
            ttlin \
            ttlout \
            lvdsin \
            lvdsout \
            encoders \
            pcap \
            system
}

# List of IP that can be targeted to this platform.
# NB: these could built as and when required.
set TGT_IP { \
}

