`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2025 04:04:52 PM
// Design Name: 
// Module Name: REG_MUX
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


module REG_MUX #( 
    parameter DATA_WIDTH = 18,   // Width of the data bus
    parameter RSTTYPE = "SYNC",  // Reset type: "SYNC" for synchronous, "ASYNC" for asynchronous
    parameter REG_OUT = 1            // Selector determines whether to use registered or direct data
)(
    input CLK, // Clock signal
    input RST, // Reset signal
    input CE,  // Clock enable signal
    
    input  [DATA_WIDTH - 1:0] D, // Data input
    output [DATA_WIDTH - 1:0] Q  // Data output
);

    reg [DATA_WIDTH - 1:0] D_reg; // Register to store data
    
    // Output assignment: If REG selector is 1, output registered data; otherwise, pass input directly
    assign Q = (REG_OUT == 1) ? D_reg : D;
        
    generate 
        if (RSTTYPE == "SYNC") begin
            always @(posedge CLK) begin
                if (RST) begin 
                    D_reg <= 0; 
                end else if (CE) begin
                    D_reg <= D; 
                end
            end
        end else if (RSTTYPE == "ASYNC") begin
            always @(negedge CLK or posedge RST) begin
                if (RST) begin
                    D_reg <= 0; 
                end else if (CE) begin
                    D_reg <= D; 
                end
            end
        end
    endgenerate

endmodule


