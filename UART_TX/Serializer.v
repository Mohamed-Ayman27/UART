module Serializer #(
    parameter Data_Len = 8,
    parameter CountLen = 4
) (
    input wire [ Data_Len - 1 : 0] P_DATA,
    input wire CLK, RST, ser_en,
    output reg ser_data,ser_done
);
reg [ CountLen - 1 : 0] Count;
reg [ Data_Len - 1 : 0] P_DATA_reg;
always @(posedge CLK ) begin
    if (!ser_en) begin
        P_DATA_reg <= P_DATA;
    end
    else begin
        P_DATA_reg <= P_DATA_reg;
    end
end
always @(posedge CLK or negedge RST) begin
    if( !RST ) begin
        ser_done <= 0;
        Count <= 0;
        ser_data <= 0;
    end
    else begin
        if( ser_en && Count != 8 ) begin
            ser_data <= P_DATA_reg[0];
            P_DATA_reg <= P_DATA_reg>>1;
            Count <= Count + 1;
        end
        else if ( ser_en && Count == 8) begin
            ser_done <= 1;
            Count <= 0;
        end
        else if ( !ser_en && ser_done) begin
            ser_done <= 0;
            Count <= 0;
        end
        else begin
            ser_data <= ser_data;
        end
    end
end
endmodule
