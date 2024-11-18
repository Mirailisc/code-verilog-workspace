module TrafficLightController (
    input clk,
    input reset,
    input [11:0] IR_sensors,  // 12 IR sensors for traffic density
    input [3:0] sound_sensors, // 4 sound sensors for emergency vehicles
    output reg [23:0] traffic_lights // 8 traffic light sets (Red, Yellow, Green)
);

    typedef enum reg [1:0] {FOUR_STAGE = 2'b00, TWO_STAGE = 2'b01, EMERGENCY = 2'b10} Mode;
    Mode mode;

    reg [3:0] counter;          // Timer counter for each stage
    reg [7:0] active_lights;    // Bitmask for active lights in the current stage

    // Traffic light states
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            mode <= FOUR_STAGE;
            active_lights <= 8'b00000000;
            traffic_lights <= {8{RED}}; // All RED
        end else begin
            // Determine mode
            if (|sound_sensors) begin
                mode <= EMERGENCY;
            end else if (IR_sensors > 12'b111100000000) begin
                mode <= FOUR_STAGE;
            end else begin
                mode <= TWO_STAGE;
            end

            // Control logic for modes
            case (mode)
                FOUR_STAGE: begin
                    // Stage-based switching
                    case (counter)
                        4'd0: active_lights <= 8'b00000001; // Light 8
                        4'd1: active_lights <= 8'b00000010; // Light 7
                        4'd2: active_lights <= 8'b00000100; // Light 6
                        4'd3: active_lights <= 8'b00010000; // Light 1
                    endcase
                    counter <= (counter + 1) % 4;
                end

                TWO_STAGE: begin
                    // Group-based switching
                    case (counter)
                        4'd0: active_lights <= 8'b10100000; // Lights 6, 8
                        4'd1: active_lights <= 8'b00001001; // Lights 1, 3
                        4'd2: active_lights <= 8'b01010000; // Lights 5, 7
                        4'd3: active_lights <= 8'b00000110; // Lights 2, 4
                    endcase
                    counter <= (counter + 1) % 4;
                end

                EMERGENCY: begin
                    // Emergency prioritization based on sound sensors
                    casez (sound_sensors)
                        4'b1???: active_lights <= 8'b00000001; // Priority Light 8
                        4'b01??: active_lights <= 8'b00000010; // Priority Light 7
                        4'b001?: active_lights <= 8'b00000100; // Priority Light 6
                        4'b0001: active_lights <= 8'b00010000; // Priority Light 1
                    endcase
                end
            endcase

            // Update traffic lights
            traffic_lights <= {8{RED}}; // Default all RED

            // Set active lights to GREEN or YELLOW
            for (int i = 0; i < 8; i = i + 1) begin
                if (active_lights[i]) begin
                    if (counter == 3) // Yellow during the transition stage
                        traffic_lights[i * 3 +: 3] <= YELLOW;
                    else
                        traffic_lights[i * 3 +: 3] <= GREEN;
                end
            end
        end
    end
endmodule
