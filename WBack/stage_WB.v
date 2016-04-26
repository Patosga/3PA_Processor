
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2016 14:57:35
// Design Name: 
// Module Name: stage_WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "pipelinedefs.v"

`define WIDTH 32

module stage_wb(
    input clk, 
    input rst, 
    input [`WIDTH-1:0]i_wb_pc, 
    input [`WIDTH-1:0]i_wb_data_o_ma, // Output from memory
    input [`WIDTH-1:0]i_wb_alu_rslt, // result of the ALU
    input [2:0]i_wb_cntrl,// bits [1:0] slect mux, bit 2 reg_write_rf_in
    input [4:0]i_wb_rdst,// input of Rdst
    output [4:0]o_wb_rdst,// output of Rdst
    output o_wb_reg_write_rf,//output of the third input control bit
    output [`WIDTH-1:0] o_wb_mux,// Data for the input of the register file
    output [1:0]o_wb_reg_dst_s// select mux out
);

    wire [1:0]mux_sel = i_wb_cntrl[`WB_RDST_MUX];
    
  //MUX  
  assign o_wb_mux = mux_sel[1]? ( mux_sel[0]? 32'hxxxxxxxx : i_wb_pc ) : 
                                 (mux_sel[0]? i_wb_alu_rslt : i_wb_data_o_ma );
    
  //ASSIGN OF INPUT TO OUTPUTS PROPAGATION 
  assign o_wb_reg_write_rf = i_wb_cntrl[`WB_R_WE];
  assign o_wb_reg_dst_s = i_wb_cntrl[1:0];
  assign o_wb_rdst = i_wb_rdst;
  
endmodule
