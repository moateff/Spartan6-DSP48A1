`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 11:47:35 PM
// Design Name: 
// Module Name: BUF
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


module BUFFER #(
    parameter DATA_WIDTH = 8 // Width of the data bus
)(
    input  [DATA_WIDTH-1:0] in,  // Input data
    output [DATA_WIDTH-1:0] out  // Buffered output
);

    // Generate buf gates for each bit of the input
    genvar i;
    generate
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : buf_gen
            buf (out[i], in[i]); 
        end
    endgenerate

endmodule

