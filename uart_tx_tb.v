`timescale 1ms/ 10ns

module tb_UART_tx();

reg clk_ = 0;
reg rst_ = 0;
reg start_ = 0;
reg [7:0]data_ = 8'd41;
wire rs232_tx;
wire done_;

UART_tx uut(
    .clk(clk_),
    .rst(rst_),
    .tx_data(data_),
    .start(start_),
    .Rs232_tx_(rs232_tx),
    .done_flag(done_)
);

always begin
    #0.00010416666
    clk_=~clk_;
end

initial begin
    #10 
    rst_ = 1;
    #5
    rst_ = 0;
    #1
    start_ = 1;
    #2
    start_ = 0;
    #10
    start_ = 1;
    #0.000208333
    start_= 0;
    #0.000208333
    start_ = 1;
    #0.000208333
    start_= 0;
end

initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0,tb_UART_tx);
    #100
    $display("Finished!");
    $finish;
end

endmodule