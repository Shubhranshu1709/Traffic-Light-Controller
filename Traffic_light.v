`timescale 1ns / 1ps

module sig_control(
    output reg [1:0] hwy, cntry,  // 2-bit output for 3 states of signal (GREEN, YELLOW, RED)
    input X,                      // if TRUE, indicates that there is a car on the country road, otherwise FALSE
    input clock, clear            // clock and clear inputs
);

// Parameters for signal states
parameter TRUE = 1'b1;
parameter FALSE = 1'b0;

parameter RED = 2'b00;
parameter YELLOW = 2'b01;
parameter GREEN = 2'b10;

// Parameters for state definitions
parameter S0 = 3'b000;  // HWY GREEN, CNTRY RED
parameter S1 = 3'b001;  // HWY YELLOW, CNTRY RED
parameter S2 = 3'b010;  // HWY RED, CNTRY RED
parameter S3 = 3'b011;  // HWY RED, CNTRY GREEN
parameter S4 = 3'b100;  // HWY RED, CNTRY YELLOW

// Delay parameters
parameter Y2RDELAY = 3; // Yellow to red delay
parameter R2GDELAY = 2; // Red to green delay

// Internal state variables
reg [2:0] state, next_state;
integer count;

// Sequential logic: State transition
always @(posedge clock or posedge clear) begin
    if (clear) begin
        state <= S0;
        count <= 0;
    end else begin
        if (count == 0) begin
            state <= next_state;
            if (next_state == S1 || next_state == S4)
                count <= Y2RDELAY - 1;
            else if (next_state == S2)
                count <= R2GDELAY - 1;
        end else begin
            count <= count - 1;
        end
    end
end

// Compute values of main signal and country signal based on current state
always @(*) begin
    case (state)
        S0: begin
            hwy = GREEN;
            cntry = RED;
            next_state = (X ? S1 : S0);
        end
        S1: begin
            hwy = YELLOW;
            cntry = RED;
            next_state = S2;
        end
        S2: begin
            hwy = RED;
            cntry = RED;
            next_state = S3;
        end
        S3: begin
            hwy = RED;
            cntry = GREEN;
            next_state = (X ? S3 : S4);
        end
        S4: begin
            hwy = RED;
            cntry = YELLOW;
            next_state = S0;
        end
        default: begin
            hwy = GREEN;
            cntry = RED;
            next_state = S0;
        end
    endcase
end

endmodule
