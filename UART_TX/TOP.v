module TOP#(
    parameter Data_Len = 8
) (
    input wire [ Data_Len - 1 : 0 ]  P_DATA_TOP,
    input wire Data_Valid_TOP,
    input wire CLK_TOP,RST_TOP,
    input wire PAR_EN_TOP,PAR_TYP_TOP,
    output wire TX_OUT_TOP,busy_TOP
);
wire ser_done_TOP,ser_en_TOP,ser_data_TOP;
wire par_bit_TOP;
wire[1:0] mux_sel_TOP;

FSM FSM_TOP (
    .Data_Valid(Data_Valid_TOP),
    .CLK(CLK_TOP), 
    .RST(RST_TOP),
    .PAR_EN(PAR_EN_TOP),
    .ser_done(ser_done_TOP),
    .ser_en(ser_en_TOP),
    .mux_sel(mux_sel_TOP),
    .busy(busy_TOP)
);

MUX MUX_TOP(
    .mux_sel(mux_sel_TOP),
    .start_bit(1'b0),
    .stop_bit(1'b1),
    .ser_data(ser_data_TOP),
    .par_bit(par_bit_TOP),
    .TX_OUT(TX_OUT_TOP)
);

Par_Calc Par_Calc_TOP(
    .Data_Valid(Data_Valid_TOP),
    .CLK(CLK_TOP),
    .P_DATA(P_DATA_TOP),
    .PAR_TYP(PAR_TYP_TOP),
    .par_bit(par_bit_TOP)  
);

Serializer Serializer_TOP(
    .P_DATA(P_DATA_TOP),
    .CLK(CLK_TOP),
    .RST(RST_TOP), 
    .ser_en(ser_en_TOP),
    .ser_data(ser_data_TOP),
    .ser_done(ser_done_TOP)
);

    
endmodule
