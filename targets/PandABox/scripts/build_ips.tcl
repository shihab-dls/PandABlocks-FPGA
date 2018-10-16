#
# Generate Xilinx IP Cores
#

# Source directory
set TARGET_DIR [lindex $argv 0]
set_param board.repoPaths $TARGET_DIR/configs

# Build directory
set BUILD_DIR [lindex $argv 1]/ip_repo

# Create Managed IP Project
create_project managed_ip_project $BUILD_DIR/managed_ip_project -part xc7z030sbg485-1 -ip

set_property target_language VHDL [current_project]
set_property target_simulator ModelSim [current_project]

#
# Create PULSE_QUEUE IP
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name pulse_queue -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Input_Data_Width {49}    \
    CONFIG.Data_Count {true}        \
    CONFIG.Output_Data_Width {49}   \
    CONFIG.Reset_Type {Synchronous_Reset} \
] [get_ips pulse_queue]

generate_target all [get_files $BUILD_DIR/pulse_queue/pulse_queue.xci]
synth_ip [get_ips pulse_queue]

#
# Create Standard 1Kx32-bit FIFO IP
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name fifo_1K32 -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.Input_Data_Width {32}    \
    CONFIG.Data_Count {true}        \
    CONFIG.Output_Data_Width {32}   \
    CONFIG.Reset_Type {Synchronous_Reset} \
] [get_ips fifo_1K32]

generate_target all [get_files $BUILD_DIR/fifo_1K32/fifo_1K32.xci]
synth_ip [get_ips fifo_1K32]

#
# Create Standard 1Kx32-bit first word fall through FIFO IP
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name fifo_1K32_ft -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Input_Data_Width {32}    \
    CONFIG.Data_Count {true}        \
    CONFIG.Output_Data_Width {32}   \
    CONFIG.Reset_Type {Synchronous_Reset} \
] [get_ips fifo_1K32_ft]

generate_target all [get_files $BUILD_DIR/fifo_1K32_ft/fifo_1K32_ft.xci]
synth_ip [get_ips fifo_1K32_ft]

#
# Create FMC GTX Aurora IP
#
create_ip -name gtwizard -vendor xilinx.com -library ip -version 3.5 \
-module_name fmcgtx -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.identical_protocol_file {aurora_8b10b_single_lane_2byte} \
    CONFIG.gt0_val {true}                                           \
    CONFIG.gt0_val_tx_refclk {REFCLK1_Q0}                           \
    CONFIG.identical_val_tx_line_rate {3.125}                       \
    CONFIG.identical_val_tx_reference_clock {156.250}               \
    CONFIG.identical_val_rx_line_rate {3.125}                       \
    CONFIG.identical_val_rx_reference_clock {156.250}               \
] [get_ips fmcgtx]

generate_target all [get_files $BUILD_DIR/fmcgtx/fmcgtx.xci]
synth_ip [get_ips fmcgtx]

#
# Create SFP GTX Aurora IP
#
create_ip -name gtwizard -vendor xilinx.com -library ip -version 3.5 \
-module_name sfpgtx -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.identical_protocol_file {aurora_8b10b_single_lane_2byte} \
    CONFIG.gt0_val_tx_refclk {REFCLK0_Q0}                           \
    CONFIG.gt0_val {true}                                           \
    CONFIG.identical_val_tx_line_rate {1}                           \
    CONFIG.identical_val_tx_reference_clock {125.000}               \
    CONFIG.identical_val_rx_line_rate {1}                           \
    CONFIG.identical_val_rx_reference_clock {125.000}               \
] [get_ips sfpgtx]

generate_target all [get_files $BUILD_DIR/sfpgtx/sfpgtx.xci]
synth_ip [get_ips sfpgtx]
#
# Create Eth Phy for sfp
#
create_ip -name gig_ethernet_pcs_pma -vendor xilinx.com -library ip -version 15.0 \
-module_name eth_phy -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.SupportLevel {Include_Shared_Logic_in_Example_Design} \
    CONFIG.Management_Interface {false} \
    CONFIG.Auto_Negotiation {false} \
    CONFIG.EMAC_IF_TEMAC {TEMAC} \
] [get_ips eth_phy]

report_compile_order -constraints

generate_target all [get_files $BUILD_DIR/eth_phy/eth_phy.xci]

report_property [get_ips eth_phy]  
get_property KNOWN_TARGETS [get_ips eth_phy] 

#To capture the XDC file names of the IP in a Tcl variable 
set eth_phy_xdc [get_files -of_objects [get_files $BUILD_DIR/eth_phy/eth_phy.xci] -filter {FILE_TYPE == XDC}] 
#To disable the XDC files
set_property is_enabled false [get_files $eth_phy_xdc]
synth_ip [get_ips eth_phy]
report_compile_order -constraints

#
# Create Eth Mac for sfp
#

create_ip -name tri_mode_ethernet_mac -vendor xilinx.com -library ip -version 9.0 \
-module_name eth_mac -dir $BUILD_DIR/


#shared logic inside of core
# CONFIG.Physical_Interface {GMII} \ phy_eth is internal (no IOB or idelay in pad) CONFIG.Physical_Interface {Internal} 

set_property -dict [list \
    CONFIG.Physical_Interface {Internal} \
    CONFIG.MAC_Speed {1000_Mbps}         \
    CONFIG.Management_Interface {false}  \
    CONFIG.Management_Frequency {125.00} \
    CONFIG.Enable_Priority_Flow_Control {false} \
    CONFIG.Frame_Filter {false}          \
    CONFIG.Number_of_Table_Entries {0}   \
    CONFIG.Enable_MDIO {false}           \
    CONFIG.SupportLevel {1}              \
    CONFIG.Make_MDIO_External {false}    \
    CONFIG.Statistics_Counters {false}   \
] [get_ips eth_mac]


report_property [get_ips eth_mac]

generate_target all [get_files $BUILD_DIR/eth_mac/eth_mac.xci]

synth_ip [get_ips eth_mac]


#
# Create System FPGA Command FIFO
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name system_cmd_fifo -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Input_Data_Width {42}    \
    CONFIG.Output_Data_Width {42}   \
] [get_ips system_cmd_fifo]

generate_target all [get_files $BUILD_DIR/system_cmd_fifo/system_cmd_fifo.xci]
synth_ip [get_ips system_cmd_fifo]

#
# Create Standard Asymmetric 1K, 32-bit(WR), 256-bit(RD) FIFO IP for ACQ430 FMC
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name fmc_acq430_ch_fifo -dir $BUILD_DIR/

set_property -dict [list \
	CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
	CONFIG.Input_Data_Width {32} \
	CONFIG.Input_Depth {256} \
	CONFIG.Output_Data_Width {256} \
	CONFIG.Read_Data_Count {true} \
	CONFIG.Output_Depth {32} \
	CONFIG.Reset_Type {Asynchronous_Reset} \
	CONFIG.Full_Flags_Reset_Value {1} \
	CONFIG.Data_Count_Width {8} \
	CONFIG.Write_Data_Count_Width {8} \
	CONFIG.Read_Data_Count_Width {5} \
	CONFIG.Full_Threshold_Assert_Value {253} \
	CONFIG.Full_Threshold_Negate_Value {252}
] [get_ips fmc_acq430_ch_fifo]

generate_target all [get_files $BUILD_DIR/fmc_acq430_ch_fifo/fmc_acq430_ch_fifo.xci]
synth_ip [get_ips fmc_acq430_ch_fifo]

#
# Create low level ACQ430 FMC Sample RAM
#
create_ip -name dist_mem_gen -vendor xilinx.com -library ip -version 8.0 \
-module_name fmc_acq430_sample_ram -dir $BUILD_DIR/

set_property -dict [list \
	CONFIG.depth {32} \
	CONFIG.data_width {24} \
	CONFIG.memory_type {dual_port_ram} \
	CONFIG.output_options {registered} \
	CONFIG.common_output_clk {true}
] [get_ips fmc_acq430_sample_ram]

generate_target all [get_files $BUILD_DIR/fmc_acq430_sample_ram/fmc_acq430_sample_ram.xci]
synth_ip [get_ips fmc_acq430_sample_ram]

#
# Create Standard Asymmetric 1K, 128-bit(WR), 32-bit(RD) FIFO IP for ACQ427 DAC FMC
#
create_ip -name fifo_generator -vendor xilinx.com -library ip -version 12.0 \
-module_name fmc_acq427_dac_fifo -dir $BUILD_DIR/

set_property -dict [list \
	CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
	CONFIG.Input_Data_Width {128} \
	CONFIG.Input_Depth {16} \
	CONFIG.Output_Data_Width {32} \
	CONFIG.Write_Data_Count {true} \
	CONFIG.Read_Data_Count {true} \
	CONFIG.Output_Depth {64} \
	CONFIG.Reset_Type {Asynchronous_Reset} \
	CONFIG.Full_Flags_Reset_Value {1} \
	CONFIG.Data_Count_Width {4} \
	CONFIG.Write_Data_Count_Width {4} \
	CONFIG.Read_Data_Count_Width {6} \
	CONFIG.Full_Threshold_Assert_Value {13} \
	CONFIG.Full_Threshold_Negate_Value {12}
] [get_ips fmc_acq427_dac_fifo]

generate_target all [get_files $BUILD_DIR/fmc_acq427_dac_fifo/fmc_acq427_dac_fifo.xci]
synth_ip [get_ips fmc_acq427_dac_fifo]

#
# Create ILA IP (32-bit wide with 8K Depth)
#
create_ip -name ila -vendor xilinx.com -library ip -version 5.1 \
-module_name ila_32x8K -dir $BUILD_DIR/

set_property -dict [list \
    CONFIG.C_PROBE0_WIDTH {32}  \
    CONFIG.C_DATA_DEPTH {8192}  \
] [get_ips ila_32x8K]

generate_target all [get_files $BUILD_DIR/ila_32x8K/ila_32x8K.xci]
synth_ip [get_ips ila_32x8K]

# Close project
close_project
exit