module ALU_tb;
    reg [2:0] ALU_Oper;
    reg [7:0] A, B;
    wire [7:0] ALU_Out;
    wire CY;
    
    ALU uut (
        .ALU_Oper(ALU_Oper),
        .A(A),
        .B(B),
        .ALU_Out(ALU_Out),
        .CY(CY)
    );
    
    initial begin
      $dumpfile("dump.vcd");
    	$dumpvars(0, ALU_tb);
        // Add: A = 8'hFF, B = 9
        ALU_Oper = 3'b000; A = 8'hFF; B = 8'd9;
       	#10;
      	// Increment: A = 1
        ALU_Oper = 3'b001; A = 8'd1; B = 8'hBB;
      	#10;
        // Subtract: A = 8'h25, B = 3
        ALU_Oper = 3'b010; A = 8'h25; B = 8'd3;
      	#10;
        // Decrement: A = 8'h13
        ALU_Oper = 3'b011; A = 8'h13; B = 8'hBB;
      	#10;
        // Shift Left (SHL): A = 8'hAA, B = 9
        ALU_Oper = 3'b100; A = 8'hAA; B = 8'd9;
      	#10;
        // Shift Right (SHR): A = 8'h55, B = 8'hBB
        ALU_Oper = 3'b101; A = 8'h55; B = 8'hBB;
      	#10;
        // NAND: A = 8'hAA, B = 8'h5A
        ALU_Oper = 3'b110; A = 8'hAA; B = 8'h5A;
      	#10;
      	// If A > B: A = 8'h13, B = 8'h12
        ALU_Oper = 3'b111; A = 8'h13; B = 8'h12;
      	#10;
        $finish;
    end
endmodule
