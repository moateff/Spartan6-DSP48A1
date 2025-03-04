`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 05:11:04 PM
// Design Name: 
// Module Name: DSP48A1
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


module DSP48A1 #(
    parameter A0REG = 0,   // Register A0 or bypass
    parameter A1REG = 1,   // Register A1 or bypass
    parameter B0REG = 0,   // Register B0 or bypass
    parameter B1REG = 1,   // Register B1 or bypass
    
    parameter CREG = 1,           // Register C or bypass
    parameter DREG = 1,           // Register D or bypass
    parameter MREG = 1,           // Register M or bypass
    parameter PREG = 1,           // Register P or bypass
    parameter CARRYINREG  = 1,    // Register Carry-in or bypass
    parameter CARRYOUTREG = 1,    // Register Carry-out or bypass
    parameter OPMODEREG   = 1,    // Register OPMODE or bypass
    
    parameter CARRYINSEL = "OPMODE5",    // Carry-in selection for post addition
    parameter B_INPUT    = "DIRECT",     // Select B input source
    parameter RSTTYPE    = "SYNC"        // Reset type
) (
    input wire [17:0] A,      // Input A
    input wire [17:0] B,      // Input B
    input wire [17:0] D,      // Input D
    input wire [47:0] C,      // Input C
    
    input wire CLK,           // Clock signal
    input wire CARRYIN,       // Input Carry-in
    input wire [7:0] OPMODE,  // Input OPMODE
    input wire [17:0] BCIN,   // Input BCIN
    
    input wire RSTA,          // Reset for A
    input wire RSTB,          // Reset for B
    input wire RSTC,          // Reset for C
    input wire RSTD,          // Reset for D
    input wire RSTM,          // Reset for M
    input wire RSTP,          // Reset for P
    input wire RSTCARRYIN,    // Reset for Carry-in & Carry-out
    input wire RSTOPMODE,     // Reset for OPMODE
    
    input wire CEA,           // Clock enable for A
    input wire CEB,           // Clock enable for B
    input wire CEC,           // Clock enable for C
    input wire CED,           // Clock enable for D
    input wire CEP,           // Clock enable for P
    input wire CEM,           // Clock enable for M
    input wire CEOPMODE,      // Clock enable for OPMODE
    input wire CECARRYIN,     // Clock enable for Carry-in
    
    input wire [47:0] PCIN,   // Input PCIN
    
    output wire [17:0] BCOUT, // Output BCOUT
    output wire [47:0] PCOUT, // Output PCOUT
    output wire [47:0] P,     // Output P
    output wire [35:0] M,     // Output M

    output wire CARRYOUT,     // Output Carry-out
    output wire CARRYOUTF     // Output Carry-out final
);
    
    localparam OPMODE_WIDTH = 8;
    localparam D_DATA_WIDTH = 18;
    localparam B_DATA_WIDTH = 18;
    localparam A_DATA_WIDTH = 18;
    localparam C_DATA_WIDTH = 48;
    localparam P_DATA_WIDTH = 48;
    localparam M_DATA_WIDTH = 36;
    
    wire [OPMODE_WIDTH - 1:0] OPMODE_r;
    wire [D_DATA_WIDTH - 1:0] D_r;
    wire [B_DATA_WIDTH - 1:0] B_r;
    wire [A_DATA_WIDTH - 1:0] A_r;
    wire [C_DATA_WIDTH - 1:0] C_r;
    wire [P_DATA_WIDTH - 1:0] P_r;
    wire [M_DATA_WIDTH - 1:0] M_r;
    
    wire [B_DATA_WIDTH - 1:0] B0REG_in;
    wire [B_DATA_WIDTH - 1:0] B1REG_in;
    
    wire [B_DATA_WIDTH - 1:0] PRE_ADD_SUB_OUT;
    wire [M_DATA_WIDTH - 1:0] MUL_OUT;
    wire [P_DATA_WIDTH - 1:0] POST_ADD_SUB_OUT;
    
    wire [A_DATA_WIDTH - 1:0] A_rr;
    wire [B_DATA_WIDTH - 1:0] B_rr;
    
    wire CARRY_REG_in;
    wire CIN;
    wire COUT;
    
    wire [P_DATA_WIDTH - 1:0] MUX_X_out;
    wire [P_DATA_WIDTH - 1:0] MUX_Z_out;
    
    
    REG_MUX #(.DATA_WIDTH(OPMODE_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(OPMODEREG)) 
        OPMODE_REG_inst (.CLK(CLK), .RST(RSTOPMODE), .CE(CEOPMODE), .D(OPMODE), .Q(OPMODE_r));
    
    assign B0REG_in = (B_INPUT == "DIRECT") ? B : 
                     ((B_INPUT == "CASCADED") ? BCIN : {B_DATA_WIDTH{1'b0}});
         
    REG_MUX #(.DATA_WIDTH(D_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(DREG)) 
        DREG_inst (.CLK(CLK), .RST(RSTD), .CE(CED), .D(D), .Q(D_r));
                
    REG_MUX #(.DATA_WIDTH(B_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(B0REG)) 
        B0REG_inst (.CLK(CLK), .RST(RSTB), .CE(CEB), .D(B0REG_in), .Q(B_r));
    
    REG_MUX #(.DATA_WIDTH(A_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(A0REG))
        A0REG_inst (.CLK(CLK), .RST(RSTA), .CE(CEA), .D(A), .Q(A_r));
    
    REG_MUX #(.DATA_WIDTH(C_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(CREG)) 
        CREG_inst (.CLK(CLK), .RST(RSTC), .CE(CEC), .D(C), .Q(C_r));
   
    Adder_Subtractor #(.DATA_WIDTH(B_DATA_WIDTH), .TYPE("PRE")) 
        pre_add_sub_inst (.opmode(OPMODE_r[6]), .x(D_r), .y(B_r), .z(PRE_ADD_SUB_OUT));
 
    MUX2x1 #(.DATA_WIDTH(B_DATA_WIDTH)) 
        B1MUX_inst (.x0(B_r), .x1(PRE_ADD_SUB_OUT), .sel(OPMODE_r[4]), .y(B1REG_in));
    
    REG_MUX #(.DATA_WIDTH(B_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(B1REG)) 
        B1REG_inst (.CLK(CLK), .RST(RSTB), .CE(CEB), .D(B1REG_in), .Q(BCOUT));
    
    REG_MUX #(.DATA_WIDTH(A_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(A1REG))
        A1REG_inst (.CLK(CLK), .RST(RSTA), .CE(CEA), .D(A_r), .Q(A_rr));
        
    Multiplier #(.DATA_WIDTH(A_DATA_WIDTH)) 
        mult_inst (.x(A_rr), .y(BCOUT), .z(MUL_OUT));
    
    assign CARRY_REG_in = (CARRYINSEL == "OPMODE5") ? OPMODE_r[5] : 
                         ((CARRYINSEL == "CARRYIN") ? CARRYIN : 1'b0);
    
    REG_MUX #(.DATA_WIDTH(M_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(MREG))
        MREG_inst (.CLK(CLK), .RST(RSTM), .CE(CEM), .D(MUL_OUT), .Q(M_r));    
    
    BUF #(.DATA_WIDTH(M_DATA_WIDTH)) MBUF(.in(M_r), .out(M));
        
    REG_MUX #(.DATA_WIDTH(1'b1), .RSTTYPE(RSTTYPE), .REG_OUT(CARRYINREG))       
        CYI_inst (.CLK(CLK), .RST(RSTCARRYIN), .CE(CECARRYIN), .D(CARRY_REG_in), .Q(CIN));         
    
    MUX4x1 #(.DATA_WIDTH(P_DATA_WIDTH)) 
        MUX_X_inst (.sel(OPMODE_r[1:0]), .x0({P_DATA_WIDTH{1'b0}}), .x1({12'b0, M_r}), .x2(P), .x3({D_r[11:0], A_rr, B_rr}), .y(MUX_X_out));
        
    MUX4x1 #(.DATA_WIDTH(P_DATA_WIDTH)) 
        MUX_Z_inst (.sel(OPMODE_r[3:2]), .x0({P_DATA_WIDTH{1'b0}}), .x1(PCIN), .x2(P), .x3(C_r), .y(MUX_Z_out));
    
    Adder_Subtractor #(.DATA_WIDTH(P_DATA_WIDTH), .TYPE("POST")) 
        post_add_sub_inst (.opmode(OPMODE_r[7]), .x(MUX_Z_out), .y(MUX_X_out), .cin(CIN), .cout(COUT), .z(POST_ADD_SUB_OUT));
    
    REG_MUX #(.DATA_WIDTH(P_DATA_WIDTH), .RSTTYPE(RSTTYPE), .REG_OUT(PREG))       
        PREG_inst (.CLK(CLK), .RST(RSTP), .CE(CEP), .D(POST_ADD_SUB_OUT), .Q(P)); 
    
    REG_MUX #(.DATA_WIDTH(1'b1), .RSTTYPE(RSTTYPE), .REG_OUT(CARRYOUTREG))       
        CYO_inst (.CLK(CLK), .RST(RSTCARRYIN), .CE(CECARRYIN), .D(COUT), .Q(CARRYOUT)); 
  
    
    assign PCOUT = P; 
    assign CARRYOUTF = CARRYOUT;
                              
endmodule
