module main (
    input clk,
    input btn1_n,
    input btn2_n,
    input  rx,
    output tx,
    output reg led_blue_n,
    output reg led_amber_n
);

    
    wire rst;
    assign rst=~btn1_n;
    wire btn;
    wire start_btn;


reg count;
wire [7:0] data_recive;
reg start = 0;
wire tx_done_flag;
wire rx_done_flag;
reg state;


UART_tx txr(
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx_data(data_recive),
    .Rs232_tx_(tx),
    .done_flag(tx_done_flag)
);

UART_rx rxr(
    .clk(clk),
    .rst(rst),
    .Rs232_rx(rx),
    .rx_data(data_recive),
    .done_flag(rx_done_flag)
);

always @(posedge clk) begin
    if(rx_done_flag&&~tx_done_flag)begin
        start <= 1;
        led_blue_n <= ~led_blue_n;
    end
    else if(tx_done_flag)begin
        led_amber_n <= ~led_amber_n;
    end
    else begin
    start <= 0;
    end
end



endmodule