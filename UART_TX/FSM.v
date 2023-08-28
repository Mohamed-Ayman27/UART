module FSM (
    input wire Data_Valid,
    input wire CLK, RST,
    input wire PAR_EN,
    input wire ser_done,
    output reg ser_en,
    output reg[1:0] mux_sel,
    output reg busy
);

// States

localparam [2:0] IDLE   = 3'b000,
                 START  = 3'b001,
                 SERIAL = 3'b011,
                 PAR    = 3'b010,
                 STOP   = 3'b110;

reg     [2:0]    Curr_State, Next_State;

// State Transition Part
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        Curr_State <= IDLE;
    end
    else begin
        Curr_State <= Next_State;
    end
end

// Output and next state calculations 
always @(*) begin

    busy    = 1;
    mux_sel = 2'd1; //Stop Ideally equal to 0
    ser_en  = 0;


    case (Curr_State)
        IDLE: begin
            busy = 0;
            if(Data_Valid) begin
                Next_State = START;
            end
            else begin
                Next_State = IDLE;
            end
        end

        START: begin
            busy = 1;
            mux_sel = 2'd0;
            ser_en = 1;
            Next_State = SERIAL;
        end

        SERIAL: begin
            if (!ser_done) begin
                busy = 1;
                mux_sel = 2'd2;
                ser_en = 1;
                Next_State = SERIAL;
            end
            else if(ser_done) begin
                busy = 1;
                mux_sel = 2'd3;
                ser_en = 0;
                if( PAR_EN ) begin
                    Next_State = PAR;
                end
                else begin
                    mux_sel = 2'd1;
                    Next_State = STOP;
                end
            end
        end

        PAR: begin
            busy = 1;
            mux_sel = 2'd1;
            Next_State = STOP;
        end

        STOP: begin
            if( Data_Valid ) begin
                Next_State = SERIAL;
                ser_en = 1;
                mux_sel = 2'd0;
                busy = 1;
            end
            else begin
                busy = 0;
                Next_State = IDLE;
                mux_sel = 2'd1;
            end
        end

        default: begin
            busy    = 1;
            mux_sel = 2'd1; //Stop Ideally equal to 0
            ser_en  = 0;
            Next_State = IDLE;
        end
    endcase
end
    
endmodule
