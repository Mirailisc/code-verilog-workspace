module ALU (
    input [2:0] ALU_Oper,
    input [7:0] A, B,
    output [7:0] ALU_Out,
    output CY
);

assign {CY, ALU_Out} = ALU_Oper[2] ? 
                        (ALU_Oper[1] ? 
                            (ALU_Oper[0] ? 
                                ((A > B) ? ({1'b0, 8'b1}) : ({1'b0, 8'b0})) : // If A > B
                                ({1'b0, ~(A & B)})) : // NAND
                            (ALU_Oper[0] ? 
                                ({1'b0, A >> 1}) :  // SHR
                                ({1'b0, A << 1}))) :  // SHL
                        (ALU_Oper[1] ? 
                            (ALU_Oper[0] ? 
                                ({1'b0, A} - 1) : // Decrement
                                ({1'b0, A} - {1'b0, B})) :  // Subtract
                            (ALU_Oper[0] ? 
                                ({1'b0, A} + 1) : // Increment
                                ({1'b0, A} + {1'b0, B}))); // Add
endmodule
