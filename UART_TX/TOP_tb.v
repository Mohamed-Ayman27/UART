`timescale 1ns/1ps
module tb;

parameter Data_Len = 8;
parameter CLK_Prd = 5;
parameter Frame_Len = 11;
parameter FullFrame = 22;

reg [ Data_Len - 1 : 0 ] P_DATA_tb;
reg Data_Valid_tb;
reg PAR_EN_tb, PAR_TYP_tb;
reg CLK_tb, RST_tb;
reg [ Frame_Len - 2 : 0] Data_Sent_NoParity;
reg [ Frame_Len - 1 : 0] Data_Sent_Parity;
reg [FullFrame - 1 : 0] Data_Sent_Concat;
wire busy_tb, TX_OUT_tb;
integer i;




initial begin
    init();
    reset();
    #CLK_Prd
    UART_Test_withoutParity();
    #CLK_Prd
    UART_Test2_withoutParity();
    #CLK_Prd
    UART_Test3_withParity();
    #CLK_Prd
    UART_Test4_withParity();

    $stop;
end





task init;
    begin
        P_DATA_tb = 8'hF8;
        CLK_tb = 0;
        Data_Valid_tb = 0;
        PAR_EN_tb = 0;
        PAR_TYP_tb = 0;
    end
endtask

task reset;
    begin
        RST_tb = 1;
        #CLK_Prd
        RST_tb = 0;
        #CLK_Prd 
        RST_tb = 1;
    end
endtask

task UART_Test_withoutParity;
    begin
        Data_Valid_tb = 1;
        PAR_EN_tb = 0;
        #CLK_Prd
        Data_Valid_tb = 0;
        #(CLK_Prd/2.0)
        Data_Sent_NoParity [ Frame_Len - 2 ] = TX_OUT_tb;
        for (i = 1; i != 9 ; i = i+1)
        begin
            #CLK_Prd
            Data_Sent_NoParity [ Frame_Len - 2 - i ] = TX_OUT_tb;
        end
        #CLK_Prd
        Data_Sent_NoParity [ 0 ] = TX_OUT_tb;
        #(CLK_Prd * 2)
        if( Data_Sent_NoParity == 10'b0000111111 && busy_tb == 0) begin
            $display("Test1 Has Passed Succesfully");
        end
        else begin
            $display("Test1 Failed");
        end
    end
endtask

task UART_Test2_withoutParity;
    begin
        Data_Valid_tb = 1;
        P_DATA_tb = 8'h5D;
        PAR_EN_tb = 0;
        #CLK_Prd
        Data_Valid_tb = 0;
        #(CLK_Prd/2.0)
        Data_Sent_NoParity [ Frame_Len - 2 ] = TX_OUT_tb;
        for (i = 1; i != 9 ; i = i+1)
        begin
            #CLK_Prd
            Data_Sent_NoParity [ Frame_Len - 2 - i ] = TX_OUT_tb;
        end
        #CLK_Prd
        Data_Sent_NoParity [ 0 ] = TX_OUT_tb; //Stop Bit
        #(CLK_Prd * 2)
        if( Data_Sent_NoParity == 10'b0101110101 && busy_tb == 0) begin 
            $display("Test2 Has Passed Succesfully");
        end
        else begin
            $display("Test2 Failed");
        end
    end
endtask


task UART_Test3_withParity;
    begin
        Data_Valid_tb = 1;
        P_DATA_tb = 8'h6F;
        PAR_EN_tb = 1;
        PAR_TYP_tb = 0;
        #CLK_Prd
        Data_Valid_tb = 0;
        #(CLK_Prd/2.0)
        Data_Sent_Parity [ Frame_Len - 1 ] = TX_OUT_tb;
        for (i = 1; i != 10 ; i = i+1)
        begin
            #CLK_Prd
            Data_Sent_Parity [ Frame_Len - 1 - i ] = TX_OUT_tb;
        end
        #CLK_Prd
        Data_Sent_Parity [ 1 ] = TX_OUT_tb;
        #CLK_Prd
        Data_Sent_Parity [ 0 ] = TX_OUT_tb;
        #(CLK_Prd * 2)
        if( Data_Sent_Parity == 11'b01111011011 && busy_tb == 0) begin //Check on the Data Sent
            $display("Test3 Has Passed Succesfully");
        end
        else begin
            $display("Test3 Failed");
        end
    end
endtask



task UART_Test4_withParity;
    begin
        Data_Valid_tb = 1;
        P_DATA_tb = 8'h6F;
        PAR_EN_tb = 1;
        PAR_TYP_tb = 0;
        #CLK_Prd
        Data_Valid_tb = 0;
        #(CLK_Prd/2.0)


        Data_Sent_Concat [ FullFrame - 1 ] = TX_OUT_tb;
        for (i = 1; i != 10 ; i = i+1)
        begin
            #CLK_Prd
            Data_Sent_Concat [ FullFrame - 1 - i ] = TX_OUT_tb;
        end
        //Changing Data and Setting the Valid for one clock

        #CLK_Prd
        P_DATA_tb = 8'h78;
        Data_Sent_Concat [ FullFrame - 11 ] = TX_OUT_tb;
        #(CLK_Prd/2.0)
        Data_Valid_tb = 1;
        #(CLK_Prd/2.0)
        Data_Sent_Concat [ FullFrame - 12 ] = TX_OUT_tb;
        #(CLK_Prd/2.0)
        Data_Valid_tb = 0;
        #(CLK_Prd/2.0)

        Data_Sent_Concat [ FullFrame - 13 ] = TX_OUT_tb;
        for (i = 13; i != 22 ; i = i+1)
        begin
            #CLK_Prd
            Data_Sent_Concat [ FullFrame - 1 - i ] = TX_OUT_tb;
        end

        #CLK_Prd
        Data_Sent_Concat [ 1 ] = TX_OUT_tb;
        #CLK_Prd
        Data_Sent_Concat [ 0 ] = TX_OUT_tb;

        if( Data_Sent_Concat == 22'h1ED87B && busy_tb == 0) begin
            $display("Test4 Has Passed Succesfully");
        end
        else begin
            $display("Test4 Failed");
        end
    end
endtask




always #(5/2.0) CLK_tb = ~CLK_tb;

TOP DUT(
    .P_DATA_TOP(P_DATA_tb),
    .Data_Valid_TOP(Data_Valid_tb),
    .PAR_EN_TOP(PAR_EN_tb),
    .PAR_TYP_TOP(PAR_TYP_tb),
    .CLK_TOP(CLK_tb),
    .RST_TOP(RST_tb),
    .TX_OUT_TOP(TX_OUT_tb),
    .busy_TOP(busy_tb)
);

endmodule
