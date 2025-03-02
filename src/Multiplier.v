`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 05:04:12 PM
// Design Name: 
// Module Name: Multiplier
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


module Multiplier #( 
    parameter DATA_WIDTH = 18 // Width of data bus
)(
    input  [DATA_WIDTH - 1:0] x, // Operand x
    input  [DATA_WIDTH - 1:0] y, // Operand y
    
    output [2*DATA_WIDTH - 1:0] z // Output result
);

    // Continuous assignment for multiplication
    assign z = x * y;

endmodule
