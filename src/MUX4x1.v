`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 04:37:00 PM
// Design Name: 
// Module Name: MUX4x1
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


module MUX4x1 #(
    parameter DATA_WIDTH = 8 // Width of data bus
)(
    input  [1:0] sel,        // 2-bit selector
    
    input  [DATA_WIDTH - 1:0] x0, x1, x2, x3, // Inputs data
    output [DATA_WIDTH - 1:0] y               // Output of the multiplexer
);

    // Continuous assignment for 4-to-1 MUX
    assign y = (sel == 2'b00) ? x0 :
               (sel == 2'b01) ? x1 :
               (sel == 2'b10) ? x2 :
               (sel == 2'b11) ? x3 : {DATA_WIDTH{1'b0}};

endmodule
