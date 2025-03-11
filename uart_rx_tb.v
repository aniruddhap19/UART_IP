`timescale 100ns/ 1ns

module tb_UART_rx();

reg clk_ = 0;
reg b_clk = 0;
reg rst_ = 0;
reg dat = 1;
wire [7:0] op_dat = 0;
wire done = 0;



UART_rx uut(
    .clk(clk_),
    .rst(rst_),
    .Rs232_rx(dat),
    .rx_data(op_dat),
    .done_flag(done_)
);





always begin
    #1
    clk_=~clk_;
end



initial begin
    #2083 
    rst_ = 1;
    #2083
    rst_ = 0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=1;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=1;
    #2083
    dat=1;
    /* #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=1;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=0;
    #2083
    dat=1;
    #2083
    dat=1; */
end





initial begin
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0,tb_UART_rx);
    #100000
    $display("Finished!");
    $finish;
end

endmodule