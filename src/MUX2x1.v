`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 05:26:06 PM
// Design Name: 
// Module Name: MUX2x1
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


module MUX2x1 #(
    parameter DATA_WIDTH = 8  // Width of the data bus
)(
    input  sel,
    input  [DATA_WIDTH - 1:0] x0,  // First input data
    input  [DATA_WIDTH - 1:0] x1,  // Second input data
    
    output [DATA_WIDTH - 1:0] y    // Output of the multiplexer
);
    
    assign y = (sel == 1'b1) ? x1 : x0;

endmodule




