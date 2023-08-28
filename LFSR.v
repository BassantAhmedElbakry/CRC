module LFSR #(parameter WIDTH = 8,
              parameter COUNTER_WIDTH = 3) (
    input  wire CLK, RST,
    input  wire ACTIVE, 
    input  wire DATA,
    output reg  CRC,
    output reg  Valid
);

// Declare 8-bit register
reg [WIDTH - 1 : 0] LFSR;

// Counter
reg [COUNTER_WIDTH - 1 : 0] counter;
reg done_count;

wire FeedBack;

integer i;

localparam [WIDTH - 1 : 0] TAPS = 8'b10111011;
localparam [WIDTH - 1 : 0] SEED = 8'hD8;

assign FeedBack = LFSR[0] ^ DATA;

always @(posedge CLK or negedge RST) begin
    if(!RST) begin
        LFSR       <= SEED;
        Valid      <= 1'b0;
        CRC        <= 1'b0;
    end
    else if(ACTIVE) begin 
        for(i = 0 ; i < (WIDTH - 1) ; i = i + 1) begin
            if(TAPS[i] == 1) begin
                LFSR[i] <= LFSR[i+1];
            end
            else begin
                LFSR[i] <= LFSR[i+1] ^ FeedBack;
            end
        end
        LFSR[WIDTH - 1] <= FeedBack;
        Valid <= 1'b0;
        /*
        LFSR[0] <= LFSR[1];
        LFSR[1] <= LFSR[2];
        LFSR[2] <= LFSR[3] ^ FeedBack;
        LFSR[3] <= LFSR[4];
        LFSR[4] <= LFSR[5];  
        LFSR[5] <= LFSR[6];
        LFSR[6] <= LFSR[7] ^ FeedBack;
        LFSR[7] <= FeedBack;
        */   
    end
    else if(!done_count) begin
        Valid <= 1'b1;
        {LFSR[WIDTH - 2 : 0],CRC} <= LFSR ;
        LFSR[7] <= 1'b0;
			/*
			CRC <= LFSR[0]
			LFSR[0] <= LFSR[1]
			LFSR[1] <= LFSR[2]
			LFSR[2] <= LFSR[3]
			LFSR[3] <= LFSR[4]
			LFSR[4] <= LFSR[5]
			LFSR[5] <= LFSR[6]
			LFSR[6] <= LFSR[7]
            LFSR[7] <= 0
			*/       
    end

    else begin
        Valid <= 1'b0;
        CRC   <=  'b0;
    end
end

always @(posedge CLK) begin
    if(ACTIVE) begin
        counter    <= 3'b000;
        done_count <= 1'b0;
    end
    else if(!ACTIVE && Valid) begin
        counter <= counter + 1;
        if(counter == 3'b110) begin
            done_count <= 1'b1;
        end
    end
end
    
endmodule

