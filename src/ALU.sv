module ALU (
    input [2:0] ALU_Oper,     // 3-bit operation selector
    input [7:0] A, B,         // 8-bit input operands
    output reg [7:0] ALU_Out, // 8-bit output
    output reg CY             // Carry output
);

    always @(*) begin
        case (ALU_Oper)
            3'b000: {CY, ALU_Out} = {1'b0, A + B};                 // Add
            3'b001: {CY, ALU_Out} = {1'b0, A + 8'd1};              // Increment
            3'b010: {CY, ALU_Out} = {A < B, A - B};                // Subtract (CY is borrow)
            3'b011: {CY, ALU_Out} = {1'b0, A - 8'd1};              // Decrement
            3'b100: {CY, ALU_Out} = {A[7], A << 1};                // Shift left (CY is MSB of A)
            3'b101: {CY, ALU_Out} = {A[0], A >> 1};                // Shift right (CY is LSB of A)
            3'b110: {CY, ALU_Out} = {1'b0, ~(A & B)};              // NAND
            3'b111: {CY, ALU_Out} = {1'b0, (A > B) ? 8'd1 : 8'd0}; // If Greater Than
            default: {CY, ALU_Out} = {1'b0, 8'd0};                 // Default case: 0
        endcase
    end
endmodule
