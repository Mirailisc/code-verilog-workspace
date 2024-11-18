module TrafficLightController_tb;

    reg clk;
    reg reset;
    reg [11:0] IR_sensors;
    reg [3:0] sound_sensors;
    wire [23:0] traffic_lights;

    // Instantiate DUT (Device Under Test)
    TrafficLightController uut (
        .clk(clk),
        .reset(reset),
        .IR_sensors(IR_sensors),
        .sound_sensors(sound_sensors),
        .traffic_lights(traffic_lights)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        IR_sensors = 12'b000000000000;
        sound_sensors = 4'b0000;

        // Reset the system
        #10 reset = 0;

        // Test Case 1: Low traffic, no emergency
        IR_sensors = 12'b000100100010; // Random low density
        sound_sensors = 4'b0000; // No emergency
        #100;

        // Test Case 2: High traffic density
        IR_sensors = 12'b111100000000; // High density
        #100;

        // Test Case 3: Emergency detected
        sound_sensors = 4'b0001; // Emergency vehicle at lane 1
        #100;

        // Test Case 4: Emergency detected at lane 3
        sound_sensors = 4'b0100;
        #100;

        // End simulation
        $finish;
    end
endmodule
