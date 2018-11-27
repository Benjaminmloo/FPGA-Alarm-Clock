set_property SRC_FILE_INFO {cfile:u:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc rfile:../alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc id:1 order:EARLY scoped_inst:clk_wiz/inst} [current_design]
set_property SRC_FILE_INFO {cfile:U:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/constrs_1/imports/lab9_3_3/Nexys4DDR_Master.xdc rfile:../alarm_clock.srcs/constrs_1/imports/lab9_3_3/Nexys4DDR_Master.xdc id:2} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
set_property src_info {type:XDC file:2 line:46 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { audio_out[13] }]; #IO_L22N_T3_A04_D20_14 Sch=led[13]
