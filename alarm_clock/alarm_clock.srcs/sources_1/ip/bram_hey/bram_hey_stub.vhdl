-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2.1 (win64) Build 2288692 Thu Jul 26 18:24:02 MDT 2018
-- Date        : Fri Dec  7 13:52:48 2018
-- Host        : Milliken running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               w:/win/ELEC3500/lab/lab_9/fpga_alarm_clock/alarm_clock/alarm_clock.srcs/sources_1/ip/bram_hey/bram_hey_stub.vhdl
-- Design      : bram_hey
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bram_hey is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 19 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end bram_hey;

architecture stub of bram_hey is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[19:0],douta[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_1,Vivado 2018.2.1";
begin
end;
