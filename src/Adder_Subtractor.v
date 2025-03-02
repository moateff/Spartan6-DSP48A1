`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 04:58:12 PM
// Design Name: 
// Module Name: Adder_Subtractor
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


module Adder_Subtractor #( 
    parameter DATA_WIDTH = 18, // Width of data bus
    parameter TYPE = "PRE" 
)(
    input  opmode, // opmode: 0 for addition, 1 for subtraction
    
    input  [DATA_WIDTH - 1:0] x, // Operand x
    input  [DATA_WIDTH - 1:0] y, // Operand y
    
    output [DATA_WIDTH - 1:0] z, // Output result
    
    input  cin,
    output cout
);

    generate 
        if (TYPE == "PRE") begin
            assign z = opmode ? (x - y) : (x + y);
        end else if (TYPE == "POST") begin
            assign {cout, z} = opmode ? (x - (y + cin)) : (x + (y + cin));
        end
    endgenerate 

endmodule
