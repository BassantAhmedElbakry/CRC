// Scale my time to nano second 
`timescale 1ns/1ns

module LFSR_tb ();

// Parameters
parameter CLK_PERIOD = 10;
parameter TESTS      = 10;
parameter WIDTH      = 8;

// DUT Signals
reg  CLK_tb, RST_tb;
reg  ACTIVE_tb;
reg  DATA_tb;
wire CRC_tb;
wire Valid_tb;

// DUT Instantiation
LFSR DUT (
    .CLK(CLK_tb),
    .RST(RST_tb),
    .ACTIVE(ACTIVE_tb),
    .DATA(DATA_tb),
    .CRC(CRC_tb),
    .Valid(Valid_tb)
);

// Clock Generator --> 100M Hz --> Tperiod = 10 nano seconds
always #(CLK_PERIOD/2) CLK_tb = ~CLK_tb;

integer i,test;
reg [WIDTH - 1 : 0] LFSR_tb;

// Memories
reg [WIDTH - 1 : 0] Test_DATA  [TESTS - 1 : 0];
reg [WIDTH - 1 : 0] Expect_Out [TESTS - 1 : 0];

// Initial Block
initial begin
    
    // Save Waveform
    $dumpfile("LFSR.vcd");
    $dumpvars;

    // Read Input files (Hexa files)
    $readmemh("DATA_h.txt",Test_DATA);
    $readmemh("Expec_Out_h.txt",Expect_Out);

    // Initialization
    Initialize();

    // Reset
    Reset();

    //*********************Tests*********************//
    for (test = 0 ; test < TESTS ; test = test + 1) begin
        CRC_Operation(Test_DATA[test]);
        check_CRC_OUT(Expect_Out[test],test);
    end

    #(10*CLK_PERIOD)

    $stop;
end
    
//*******************Tasks*******************//

// Initialize task
task Initialize;
    begin
        CLK_tb      = 1'b0; 
        ACTIVE_tb   = 1'b0;
        DATA_tb     = 1'b0;
    end
endtask

// Reset task
task Reset;
    begin
        RST_tb = 1'b0;
        #(CLK_PERIOD)
        RST_tb = 1'b1;
    end
endtask

// CRC_Operation Task
task CRC_Operation;
 input [WIDTH - 1 : 0] In_DATA;
 begin
    Reset();
    ACTIVE_tb = 1'b1;
        DATA_tb = In_DATA[0];

        for(i = 1 ; i < WIDTH ; i = i + 1) begin
            #(CLK_PERIOD)
            DATA_tb = In_DATA[i];
        end
        #(CLK_PERIOD)

        /*
        DATA_tb = In_DATA[0];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[1];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[2];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[3];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[4];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[5];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[6];
        #(CLK_PERIOD)
         DATA_tb = In_DATA[7];
        #(CLK_PERIOD)*/
    
    ACTIVE_tb = 1'b0;
    
 end
endtask

// check_CRC_OUT Task
task check_CRC_OUT;
 input reg [WIDTH - 1 : 0] Expect_Out;
 input integer     test_num;

 begin
    @(posedge Valid_tb)
    for(i = 0 ; i < WIDTH ; i = i + 1) begin
        #(CLK_PERIOD)
        LFSR_tb[i] = CRC_tb;
    end

    if(LFSR_tb == Expect_Out) begin
        $display("Test Case %0d is succeeded :)",test_num + 1); 
    end
    else begin
        $display("Test Case %0d is failed :(",test_num + 1);
    end  
 end
endtask

endmodule
