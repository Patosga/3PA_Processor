`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 19.04.2016 09:46:33
// Design Name:
// Module Name: processor
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


module processor(
       input Clk,
       input Rst
    );


    IF fetch(
        //General
         .Clk(Clk),
         .Rst(Rst),
        //Branch Unit
         .FlushPipeandPC(ID_FlushPipeandPC),
         .WriteEnable(ID_WriteEnable),
         .CB_o(ID_CB_o),
        //Stall Unit
         .PCStall(PCStall),
         .IF_ID_Stall(IF_ID_Stall),
         .IF_ID_Flush(IF_ID_Flush),
         .Imiss(Imiss),
        //From Execute
         .JmpAddr(),
         .JmpInstrAddr(),
        //To Pipeline Registers
         .IR(ID_IR),
         .PC(ID_PC),
         .InstrAddr(ID_IAddr),
         .PCSource(ID_PCSrc),
         .PPCCB(ID_PPCCB)
    );

    IDControlUnit decode(
         .Clk(Clk),
         .reset(Rst),
         /*Input pipeline registers from writeback*/
         .rf_we(WB_RWE),
         .WAddr(WB_RdsAddr),
         .WData(WB_RdsData),
        /*Input pipeline registers from fetch*/
         .iIC(ID_IAddr),
         .iPPCCB(ID_PPCCB),
         .iPC(ID_PC), 
         .iValid(ID_PCSrc),
         .iIR(ID_IR),
        /*Input to stall or flush*/
         .stall(IDEX_Stall),
         .flush(IDEX_Flush),
        /*Output pipeline registers to execute*/
            /*Fowarded from fetch*/

         .oIC(),
         .oPPCCB(),
         .oPC(),
         .oValid(),
            /*Produced outputs to execute*/
         .oRDS(),
         .oRS1(),
         .oRS2(),
         .oOP1(),
         .oOP2(),
         .oIM(),

         .oEX(),
         .oMA(),
         .oWB()
    );

    stageMA MAccesss(
        .clk(Clk),//clock
        .st(Rst),//reset
        .i_ma_WB(),//write_back control signal
        .i_ma_MA(),//memory access control signals
        .i_ma_ALU_rslt(),// resultado da ALU
        .i_ma_Rs2_val(), //valor do regiter source 2
        .i_ma_Rs2_addr(), //endere?o do registo do register source 2
        .i_ma_PC(), //program counter
        .i_ma_Rdst(), //registo de destino
        .i_ma_mux_wb(),//resultado do write back (forwarding)
        .i_OP1_MemS(), //forwrding unit signal
        .i_ma_flush(),
        .i_ma_stall(),

        .o_ma_PC(PCSrc_MA_WB), //program counter para ser colocado no pipeline register MA/WB
        .o_ma_Rds(RDS_MA_WB), //endere�o do registo de sa�da
        .o_ALU_rsl(ALU_Rslt_MA_WB), //resultado do ALU a ser colocado no pipeline register MA/WB
        .o_ma_WB(o_ma_WB), //sinais de controlo da write back a serem colocados no pipeline register MA/WB
        .o_ma_EX_MEM_Rs2(),//colocar o endere�o do source register 2 na forward unit,
        .o_ma_EX_MEM_MA(),
        .o_miss(), // falha no acesso de mem�ria
        .o_ma_mem_out(Data_Mem_MA_WB)
    );

    stage_wb WBack (

        .clk(Clk),
        .rst(Rst),
        .i_wb_pc(PCSrc_MA_WB),
        .i_wb_data_o_ma(Data_Mem_MA_WB), // Output from memory
        .i_wb_alu_rslt(ALU_Rslt_MA_WB), // result of the ALU
        .i_wb_cntrl(o_ma_WB),// bits [1:0] slect mux, bit 2 reg_write_rf_in
        .i_wb_rdst(RDS_MA_WB),// input of Rdst
        .o_wb_rdst(),// output of Rdst
        .o_wb_reg_write_rf(),//output of the third input control bit
        .o_wb_mux(),// Data for the input of the register file
        .o_wb_reg_dst_s()// select mux out
    );

    HazardUnit HazardU(
         //FORWARD UNIT
         .IDex__Need_Rs2(),
         .IDex__Need_Rs1(),
         .IDex__Rs1(),
         .IDex__Rs2(),
         .EXmem__Read_MEM(),
         .EXmem__R_WE(),
         .EXmem__Rdst(),
         .EXmem__RDst_S(),
         .MEMwb__Rdst(),
         .MEMwb__R_WE(),
         .OP1_ExS(),
         .OP2_ExS(),

         //BRANCH UNIT
         .PcMatchValid(),
         .BranchInstr(),
         .JumpInstr(),
         .PredicEqRes(),
         .CtrlIn(),
         .CtrlOut(CrtlOut),
         .FlushPipePC(FlushPipeandPC),
         .WriteEnable(WriteEnable),
         .NPC(),

          //CHECK CC
         .cc4(),            // The condition code bits
         .cond_bits(),

          //STALL UNIT
         .i_DCache_Miss(), // From Data Cache in MEM stage
         .i_ICache_Miss(Imiss), // From Instruction Cache in IF stage
         .o_PC_Stall(PCStall),   // To IF stage
         .o_IFID_Stall(IF_ID_Stall), // To IFID pipeline register
         .o_IDEX_Stall(IDEX_Stall), // To IDEX pipeline register
         .o_EXMA_Stall(), // To EXMA pipeline register
         .o_EXMA_Flush(), // To flush EXMA pipleine Register
         .o_MAWB_Flush(), // To flush MAWB pipeline register

          //Pipeline Registers
         .Flush_IF_ID(IF_ID_Flush),
         .Flush_ID_EX(IDEX_Flush)
        );



endmodule
