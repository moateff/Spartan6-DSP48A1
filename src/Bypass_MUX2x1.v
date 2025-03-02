`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 10:39:08 PM
// Design Name: 
// Module Name: Bypass_MUX2x1
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


module Bypass_MUX2x1 #(
    parameter DATA_WIDTH = 8,  // Width of the data bus
    parameter SEL = "CARRYIN"
)(
    input  [DATA_WIDTH - 1:0] x0,  // First input data
    input  [DATA_WIDTH - 1:0] x1,  // Second input data
    
    output [DATA_WIDTH - 1:0] y    // Output of the multiplexer
);
    
    assign y = ((SEL == "OPMODE5") | (SEL == "DIRECT"))  ? x0 :
               ((SEL == "CARRYIN") | (SEL == "CASCADE")) ? x1 :
               {DATA_WIDTH{1'b0}};   

endmodule
