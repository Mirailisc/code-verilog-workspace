module TrafficLightController_tb;

    reg clk;
    reg reset;
    reg [11:0] IR_sensors;
    reg [3:0] sound_sensors;
    wire [23:0] traffic_lights;

    // Instantiate the module
    TrafficLightController uut (
        .clk(clk),
        .reset(reset),
        .IR_sensors(IR_sensors),
        .sound_sensors(sound_sensors),
        .traffic_lights(traffic_lights)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        IR_sensors = 12'b000000000000;
        sound_sensors = 4'b0000;

        // Dump VCD file
        $dumpfile("TrafficLightController.vcd");
        $dumpvars(0, TrafficLightController_tb);

        // Reset system
        #10 reset = 0;

        // Test Case 1: 4-stage traffic light
        IR_sensors = 12'b111111111111; // High density
        #100;

        // Test Case 2: 2-stage traffic light
        IR_sensors = 12'b000011110000; // Medium density
        #100;

        // Test Case 3: Emergency mode
        sound_sensors = 4'b1000; // Emergency at Snd_A
        #100;

        // Test Case 4: Emergency at Snd_D
        sound_sensors = 4'b0001; // Emergency at Snd_D
        #100;

        $finish;
    end
endmodule
