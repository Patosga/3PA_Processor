// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
// Date        : Tue Apr 19 11:05:17 2016
// Host        : Regd running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/rafael/Documents/VivadoProjects/soc_3pa/soc_3pa.srcs/sources_1/ip/RAM_DM/RAM_DM_stub.v
// Design      : RAM_DM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_9,Vivado 2015.4" *)
module RAM_DM(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[15:0],d[31:0],clk,we,spo[31:0]" */;
  input [15:0]a;
  input [31:0]d;
  input clk;
  input we;
  output [31:0]spo;
endmodule
