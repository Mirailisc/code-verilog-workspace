module TrafficLightController (
    input clk,
    input reset,
    input [11:0] IR_sensors,  // 12 IR sensors for traffic density
    input [3:0] sound_sensors, // 4 sound sensors for emergency vehicles
    output reg [23:0] traffic_lights // 8 traffic lights (red, yellow, green) * 3 bits each
);

    // Traffic light stages
    typedef enum reg [1:0] {FOUR_STAGE = 2'b00, TWO_STAGE = 2'b01, EMERGENCY = 2'b10} Mode;
    Mode mode;

    reg [3:0] counter; // Timer counter
    reg [3:0] active_lane; // Indicates active lane in the current stage

    // Traffic light states (Red, Yellow, Green)
    localparam RED    = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN  = 3'b001;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            active_lane <= 4'b0000;
            mode <= FOUR_STAGE;
            traffic_lights <= 24'hFFFFFF; // All red
        end else begin
            // Determine mode
            if (|sound_sensors) // Emergency detected
                mode <= EMERGENCY;
            else if (IR_sensors > 12'b111100000000) // High traffic density
                mode <= FOUR_STAGE;
            else
                mode <= TWO_STAGE;

            // Traffic light control logic
            case (mode)
                FOUR_STAGE: begin
                    // 4-stage traffic light control
                    case (counter)
                        4'b0000: active_lane <= 4'b0001; // Lane 1
                        4'b0100: active_lane <= 4'b0010; // Lane 2
                        4'b1000: active_lane <= 4'b0100; // Lane 3
                        4'b1100: active_lane <= 4'b1000; // Lane 4
                    endcase
                    counter <= (counter + 1) % 16;
                end
                TWO_STAGE: begin
                    // 2-stage traffic light control
                    active_lane <= counter[3:2] ? 4'b0011 : 4'b1100; // Lanes 1&2 or 3&4
                    counter <= (counter + 1) % 8;
                end
                EMERGENCY: begin
                    // Emergency mode: only one lane with emergency gets green
                    active_lane <= sound_sensors;
                end
            endcase

            // Update traffic lights
            traffic_lights <= {24{RED}}; // Default all red
            traffic_lights[active_lane * 3 +: 3] <= GREEN; // Active lane green
            if (counter % 4 == 3) 
                traffic_lights[active_lane * 3 +: 3] <= YELLOW; // Yellow before switching
        end
    end
endmodule
