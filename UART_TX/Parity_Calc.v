module Par_Calc #(
    parameter Data_Len = 8
) (
    input wire Data_Valid, CLK,
    input wire [ Data_Len - 1 : 0 ]P_DATA,
    input wire PAR_TYP,
    output reg par_bit    
);
reg P_Data_Parity;
always @(posedge CLK) begin
    P_Data_Parity =^P_DATA; //odd = 1
    if (Data_Valid) begin
        if( PAR_TYP )begin // 1 i want Odd and if 0 i want even
            par_bit = P_Data_Parity; // odd parity
        end
        else begin
            par_bit = ~P_Data_Parity; //even parity
        end
    end
end
endmodule
