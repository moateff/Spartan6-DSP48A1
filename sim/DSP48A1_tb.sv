`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 10:45:16 PM
// Design Name: 
// Module Name: DSP48A1_tb
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


module DSP48A1_tb;
    // Parameter definitions
    integer NUM_TEST_CASES = 100;
    integer pass_count = 0;
    integer error_count = 0; 
    
    parameter OPMODE_WIDTH = 8;
    parameter D_DATA_WIDTH = 18;
    parameter B_DATA_WIDTH = 18;
    parameter A_DATA_WIDTH = 18;
    parameter C_DATA_WIDTH = 48;
    parameter P_DATA_WIDTH = 48;
    parameter M_DATA_WIDTH = 36;
    
    parameter A0REG = 0;
    parameter A1REG = 1;
    parameter B0REG = 0;
    parameter B1REG = 1;
    parameter CREG = 1;
    parameter DREG = 1;
    parameter MREG = 1;
    parameter PREG = 1;
    parameter CARRYINREG  = 1;
    parameter CARRYOUTREG = 1;
    parameter OPMODEREG   = 1;
    
    parameter CARRYINSEL = "OPMODE5";
    parameter B_INPUT    = "DIRECT";
    parameter RSTTYPE    = "SYNC";

    // Signal definitions
    reg [A_DATA_WIDTH - 1:0] A;
    reg [B_DATA_WIDTH - 1:0] B;
    reg [D_DATA_WIDTH - 1:0] D;
    reg [C_DATA_WIDTH - 1:0] C;
    
    reg CLK;
    reg CARRYIN;
    reg [OPMODE_WIDTH - 1:0] OPMODE;
    reg [B_DATA_WIDTH - 1:0] BCIN;
    
    reg RSTA; 
    reg RSTB; 
    reg RSTC; 
    reg RSTD; 
    reg RSTM;
    reg RSTP; 
    reg RSTCARRYIN; 
    reg RSTOPMODE;
    
    reg CEA;
    reg CEB;
    reg CEC; 
    reg CED; 
    reg CEP; 
    reg CEM; 
    reg CEOPMODE;
    reg CECARRYIN;
    
    reg [P_DATA_WIDTH - 1:0] PCIN;

    wire [B_DATA_WIDTH - 1:0] BCOUT;
    wire [P_DATA_WIDTH - 1:0] PCOUT;
    wire [P_DATA_WIDTH - 1:0] P;
    wire [M_DATA_WIDTH - 1:0] M;
    
    wire CARRYOUT;
    wire CARRYOUTF;
    
    reg [A_DATA_WIDTH-1:0] A_tb;
    reg [B_DATA_WIDTH-1:0] B_tb;
    reg [D_DATA_WIDTH-1:0] D_tb;
    reg [C_DATA_WIDTH-1:0] C_tb;
    
    reg CARRYIN_tb;
    
    reg [OPMODE_WIDTH-1:0] OPMODE_tb;
    reg [B_DATA_WIDTH-1:0] BCIN_tb;
    reg [P_DATA_WIDTH-1:0] PCIN_tb;
            
    reg [B_DATA_WIDTH - 1:0] expected_BCOUT;
    reg [P_DATA_WIDTH - 1:0] expected_P;
    reg [M_DATA_WIDTH - 1:0] expected_M;
    reg expected_CARRYOUT;
            
    // Instantiate DUT
    DSP48A1 #(
        .OPMODE_WIDTH(OPMODE_WIDTH),
        .D_DATA_WIDTH(D_DATA_WIDTH),
        .B_DATA_WIDTH(B_DATA_WIDTH),
        .A_DATA_WIDTH(A_DATA_WIDTH),
        .C_DATA_WIDTH(C_DATA_WIDTH),
        .P_DATA_WIDTH(P_DATA_WIDTH),
        .M_DATA_WIDTH(M_DATA_WIDTH),
        .A0REG(A0REG),
        .A1REG(A1REG),
        .B0REG(B0REG),
        .B1REG(B1REG),
        .CREG(CREG),
        .DREG(DREG),
        .MREG(MREG),
        .PREG(PREG),
        .CARRYINREG(CARRYINREG),
        .CARRYOUTREG(CARRYOUTREG),
        .OPMODEREG(OPMODEREG),
        .CARRYINSEL(CARRYINSEL),
        .B_INPUT(B_INPUT),
        .RSTTYPE(RSTTYPE)
    ) dut (
        .A(A),
        .B(B),
        .D(D),
        .C(C),
        .CLK(CLK),
        .CARRYIN(CARRYIN),
        .OPMODE(OPMODE),
        .BCIN(BCIN),
        .RSTA(RSTA),
        .RSTB(RSTB),
        .RSTC(RSTC),
        .RSTD(RSTD),
        .RSTM(RSTM),
        .RSTP(RSTP),
        .RSTCARRYIN(RSTCARRYIN),
        .RSTOPMODE(RSTOPMODE),
        .CEA(CEA),
        .CEB(CEB),
        .CEC(CEC),
        .CED(CED),
        .CEP(CEP),
        .CEM(CEM),
        .CEOPMODE(CEOPMODE),
        .CECARRYIN(CECARRYIN),
        .PCIN(PCIN),
        .BCOUT(BCOUT),
        .PCOUT(PCOUT),
        .P(P),
        .M(M),
        .CARRYOUT(CARRYOUT),
        .CARRYOUTF(CARRYOUTF)
    );
    
    always #5 CLK = ~CLK; // 10 ns clock period (100 MHz)
        
    task wait_cycles;
        input integer num_cycles;
        begin
            repeat(num_cycles) @(posedge CLK);
        end
    endtask
        
    task assert_reset;
        begin
            // Assert reset signals
            RSTA = 1;
            RSTB = 1;
            RSTC = 1;
            RSTD = 1;
            RSTM = 1;
            RSTP = 1;
            RSTCARRYIN = 1;
            RSTOPMODE = 1;
    
            // Display reset assertion message
            $display("Reset asserted");
    
            // Wait for 1 cycle
            wait_cycles(1);
    
            // Deassert reset signals
            RSTA = 0;
            RSTB = 0;
            RSTC = 0;
            RSTD = 0;
            RSTM = 0;
            RSTP = 0;
            RSTCARRYIN = 0;
            RSTOPMODE = 0;
    
            // Display reset deassertion message
            // $display("Reset deasserted\n");
        end
    endtask

    
    task drive_inputs;
        input [A_DATA_WIDTH-1:0] A_in;
        input [B_DATA_WIDTH-1:0] B_in;
        input [D_DATA_WIDTH-1:0] D_in;
        input [C_DATA_WIDTH-1:0] C_in;
        input CARRYIN_in;
        input [OPMODE_WIDTH-1:0] OPMODE_in;
        input [B_DATA_WIDTH-1:0] BCIN_in;
        input [P_DATA_WIDTH-1:0] PCIN_in;
        
        begin
            // Assign inputs
            A = A_in;
            B = B_in;
            D = D_in;
            C = C_in;
            CARRYIN = CARRYIN_in;
            OPMODE = OPMODE_in;
            BCIN = BCIN_in;
            PCIN = PCIN_in;
    
            // Enable clock signals
            CEA = 1;
            CEB = 1;
            CEC = 1;
            CED = 1;
            CECARRYIN = 1;
            CEOPMODE = 1;
            CEM = 1;
            wait_cycles(3); 
            CEP = 1;

            // Display stimulus
            $display("A = %h | B = %h | D = %h | C = %h | CARRYIN = %b | OPMODE = %b | BCIN = %h | PCIN = %h\n", 
                        A_in, B_in, D_in, C_in, CARRYIN_in, OPMODE_in, BCIN_in, PCIN_in);
    
            // Wait for 4 clock cycles
            wait_cycles(1);
    
            // Disable clock signals
            CEA = 0;
            CEB = 0;
            CEC = 0;
            CED = 0;
            CEP = 0;
            CEM = 0;
            CEOPMODE = 0;
            CECARRYIN = 0;
            
            // Display clock disable
            // $display("Time: %0t | Clock Enables Cleared", $time);
        end
    endtask

    task check_outputs;
        input [B_DATA_WIDTH - 1:0] expected_BCOUT;
        input [P_DATA_WIDTH - 1:0] expected_P;
        input [M_DATA_WIDTH - 1:0] expected_M;
        input expected_CARRYOUT;
        integer local_errors;
                
        begin    
            local_errors = 0; // Track errors in the current test case
            
            if (BCOUT !== expected_BCOUT) begin
                $display("Mismatch: BCOUT = %h, Expected = %h", BCOUT, expected_BCOUT);
                local_errors = local_errors + 1;
            end else 
                $display("Match: BCOUT = %h", BCOUT);
        
            if ((P !== expected_P) | (PCOUT !== expected_P)) begin
                $display("Mismatch: P = %h, Expected = %h", P, expected_P);
                local_errors = local_errors + 1;
            end else 
                $display("Match: P = %h", P);
        
            if (M !== expected_M) begin
                $display("Mismatch: M = %h, Expected = %h", M, expected_M);
                local_errors = local_errors + 1;
            end else 
                $display("Match: M = %h", M);
        
            if ((CARRYOUT !== expected_CARRYOUT) | (CARRYOUTF !== expected_CARRYOUT)) begin
                $display("Mismatch: CARRYOUT = %b, Expected = %b", CARRYOUT, expected_CARRYOUT);
                local_errors = local_errors + 1;
            end else 
                $display("Match: CARRYOUT = %b", CARRYOUT);
    
            // Update pass and error counters
            if (local_errors == 0) begin
                pass_count = pass_count + 1;
                $display("Test Case PASSED!\n");
            end else begin
                error_count = error_count + 1;
                $display("Test Case FAILED! Mismatch Number: %0d\n", local_errors);
            end
        end
    endtask

    function automatic void model_DSP48A1(
        input [A_DATA_WIDTH - 1:0] A_in,
        input [B_DATA_WIDTH - 1:0] B_in,
        input [D_DATA_WIDTH - 1:0] D_in,
        input [C_DATA_WIDTH - 1:0] C_in,
        input CARRYIN_in,
        input [OPMODE_WIDTH - 1:0] OPMODE_in,
        input [B_DATA_WIDTH - 1:0] BCIN_in,
        input [P_DATA_WIDTH - 1:0] PCIN_in,
        output [B_DATA_WIDTH - 1:0] BCOUT_out,
        output [P_DATA_WIDTH - 1:0] P_out,
        output [M_DATA_WIDTH - 1:0] M_out,
        output CARRYOUT_out
    );
        // Internal Registers
        reg [B_DATA_WIDTH - 1:0] B;
        reg CIN;
        reg COUT;
        reg [M_DATA_WIDTH - 1:0] mult_result;
        reg [B_DATA_WIDTH - 1:0] pre_add_result;
        reg [P_DATA_WIDTH - 1:0] post_add_result;
        reg [P_DATA_WIDTH - 1:0] MUX_X_out;
        reg [P_DATA_WIDTH - 1:0] MUX_Z_out;
        static reg [P_DATA_WIDTH - 1:0] pre_P = 0;
        
        // B Selection Logic
        B = (B_INPUT == "DIRECT") ? B_in :
            ((B_INPUT == "CASCADED") ? BCIN_in : {B_DATA_WIDTH{1'b0}});
    
        // Carry-In Selection
        CIN = (CARRYINSEL == "OPMODE5") ? OPMODE_in[5] :
              ((CARRYINSEL == "CARRYIN") ? CARRYIN_in : 1'b0); 
    
        // Pre-Adder Operation
        pre_add_result = OPMODE_in[6] ? (D_in - B) : (D_in + B);
        BCOUT_out = OPMODE_in[4] ? pre_add_result : B;
    
        // Multiplier Operation
        mult_result = A_in * BCOUT_out;
        M_out = mult_result;
    
        // MUX X Logic
        case (OPMODE_in[1:0])
            2'b00: MUX_X_out = {P_DATA_WIDTH{1'b0}}; 
            2'b01: MUX_X_out = {12'b0, M_out};        
            2'b10: MUX_X_out = pre_P;                   
            2'b11: MUX_X_out = {D_in[11:0], A_in, BCOUT_out};
        endcase
    
        // MUX Z Logic
        case (OPMODE_in[3:2])
            2'b00: MUX_Z_out = {P_DATA_WIDTH{1'b0}}; 
            2'b01: MUX_Z_out = PCIN_in;  
            2'b10: MUX_Z_out = pre_P;              
            2'b11: MUX_Z_out = C_in;        
        endcase
    
        // Final Addition or Subtraction with Carry
        {COUT, post_add_result} = OPMODE_in[7] ? 
                                  (MUX_Z_out - (MUX_X_out + CIN)) : 
                                  (MUX_Z_out + (MUX_X_out + CIN));      
    
        // Output Assignments
        pre_P = post_add_result;
        P_out = post_add_result; 
        CARRYOUT_out = COUT;
    endfunction

    task initialize_DSP48A1;
        begin
            // Initialize all signals to default values
            A = 0;
            B = 0;
            D = 0;
            C = 0;
            BCIN = 0;
            PCIN = 0;
            CARRYIN = 0;
            OPMODE = 0;
    
            // Set reset signals
            RSTA = 0;
            RSTB = 0;
            RSTC = 0;
            RSTD = 0;
            RSTM = 0;
            RSTP = 0;
            RSTCARRYIN = 0;
            RSTOPMODE = 0;
    
            // Disable clock enables
            CEA = 0;
            CEB = 0;
            CEC = 0;
            CED = 0;
            CEP = 0;
            CEM = 0;
            CEOPMODE = 0;
            CECARRYIN = 0;
    
            // Initialize clock to low
            CLK = 0;
    
            $display("DSP48A1 Module Initialized.\n");
        end
    endtask

    initial
    begin
        initialize_DSP48A1;
        wait_cycles(1);
        
        // Display test case number
        $display("Running Test Case #0");
        assert_reset;
        expected_BCOUT = {B_DATA_WIDTH{1'b0}};
        expected_P = {P_DATA_WIDTH{1'b0}};
        expected_M = {M_DATA_WIDTH{1'b0}};
        expected_CARRYOUT = 1'b0;
        check_outputs(expected_BCOUT, expected_P, expected_M, expected_CARRYOUT);
                        
        for (int i = 1; i < NUM_TEST_CASES; i++) begin
            // Generate random test inputs
            A_tb = $random;
            B_tb = $random;
            D_tb = $random;
            C_tb = $random;
            CARRYIN_tb = $random;
            OPMODE_tb = $random;
            BCIN_tb = $random;
            PCIN_tb = $random;
    
            // Display test case number
            $display("Running Test Case #%0d", i);
            
            // Drive inputs into the module
            drive_inputs(A_tb, B_tb, D_tb, C_tb, CARRYIN_tb, OPMODE_tb, BCIN_tb, PCIN_tb);
            
            // Run expected model for reference output
            model_DSP48A1(A_tb, B_tb, D_tb, C_tb, CARRYIN_tb, OPMODE_tb, BCIN_tb, PCIN_tb,
                          expected_BCOUT, expected_P, expected_M, expected_CARRYOUT);
            
            // Check if actual outputs match expected outputs
            check_outputs(expected_BCOUT, expected_P, expected_M, expected_CARRYOUT);
            
            // Wait for 1 clock cycle
            wait_cycles(1);
        end
        
        // Display completion message
        $display("Simulation Completed: %0d test cases executed.", NUM_TEST_CASES);
        $display("Test Summary: Passed = %0d, Failed = %0d", pass_count, error_count);
        $stop;
    end
endmodule
