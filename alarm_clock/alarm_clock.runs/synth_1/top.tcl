# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param synth.incrementalSynthesisCache W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/.Xil/Vivado-5996-Guillaume/incrSyn
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.cache/wt [current_project]
set_property parent.project_path W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo w:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/alarm_on.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/clock_counter.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/imports/modules/count_to.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/debounce.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/diplay_mux.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/hours_to_bcd_encoder.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/increment_driver.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/master_controller.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/mins_to_bcd_encoder.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/pwm_driver.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/read_audio.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/scan_square_wave_gen.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/seg_driver.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/sequential_enable.v
  W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/new/top.v
}
read_ip -quiet W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all w:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all w:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all w:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/constrs_1/imports/lab9_3_3/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files W:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/constrs_1/imports/lab9_3_3/Nexys4DDR_Master.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top top -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
