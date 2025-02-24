`timescale 1ns/1ps

module testbench;

    // Signal declarations
    wire [1:0] MAIN_SIG, CNTRY_SIG; // highway and country road signals
    reg CAR_ON_CNTRY_RD;            // indicates if a car is on the country road
    reg CLOCK, CLEAR;               // clock and clear signals

    // Instantiate the sig_control module
    sig_control SC (
        .hwy(MAIN_SIG),
        .cntry(CNTRY_SIG),
        .X(CAR_ON_CNTRY_RD),
        .clock(CLOCK),
        .clear(CLEAR)
    );

    // Monitor to observe the signals at each time step
    initial begin
        $monitor($time, " Clock=%b, Clear=%b, Main Sig=%b, Country Sig=%b, Car_on_cntry=%b",
                 CLOCK, CLEAR, MAIN_SIG, CNTRY_SIG, CAR_ON_CNTRY_RD);
    end

    // Clock generation (10ns period, 5ns high, 5ns low)
    initial begin
        CLOCK = 1'b0;
        forever #5 CLOCK = ~CLOCK;
    end

    // Control the clear signal to initialize the state machine
    initial begin
        CLEAR = 1'b1;               // Set clear to active (reset the state machine)
        #20 CLEAR = 1'b0;           // Deactivate clear after 20ns
    end

    // Stimulus for the CAR_ON_CNTRY_RD signal to simulate traffic on the country road
    initial begin
        CAR_ON_CNTRY_RD = 1'b0;     // Initially, no car on country road

        #200 CAR_ON_CNTRY_RD = 1'b1; // Car arrives on country road
        #100 CAR_ON_CNTRY_RD = 1'b0; // Car leaves the country road

        #200 CAR_ON_CNTRY_RD = 1'b1; // Car arrives on country road again
        #100 CAR_ON_CNTRY_RD = 1'b0; // Car leaves the country road

        #200 CAR_ON_CNTRY_RD = 1'b1; // Car arrives on country road once more
        #100 CAR_ON_CNTRY_RD = 1'b0; // Car leaves the country road

        #100 $finish;                // Stop the simulation
    end

endmodule

