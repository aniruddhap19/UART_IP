module UART_rx (
    input clk,
    input rst,
    input Rs232_rx,
    output reg [7:0]rx_data,
    output wire done_flag
);

localparam [1:0] idle  = 2'b00,
                start = 2'b01,
                send  = 2'b10,
                stop  = 2'b11;

localparam clks_per_bit = 1250;


reg [2:0] state = idle;
reg [7:0] rx_buf=0;
reg [3:0]data_count=0;
reg [15:0]counter=0;
reg ERROR;
reg done;


always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= idle;
        done <= 0;
        counter <= 0;
        data_count <= 0;
    end
    else begin case(state)

        idle:
        begin
            counter <= 0;
            data_count <= 0;
            done <= 0;
            if(~Rs232_rx)begin
                state <= start;
            end
            else begin
                state <= idle;
            end
        end
        start:
        begin
            if(counter == clks_per_bit/2)begin
                if(~Rs232_rx)
                begin
                    state <= send;
                    counter <= 0;
                end
                else begin
                    state <= idle;
                end
            end
            else begin
                state <= start;
                counter <= counter + 1;
            end
        end
        send:
        begin
            if(counter < clks_per_bit)begin
                state <= send;
                counter <= counter + 1;
                rx_buf[data_count] <= Rs232_rx;
            end
            else begin
                if(data_count<7)begin
                    data_count <= data_count + 1;
                    counter <= 0;
                end
                else begin
                    counter <= 0;
                    state <= stop;
                end
            end

        end
        stop:
        begin
            if(counter < clks_per_bit)begin
                state <= stop;
                counter <= counter + 1;
            end
            else begin
                state <= idle;
                counter <= 0;
                done <= 1;
                rx_data <= rx_buf;
            end
        end
            default: begin
                state <= idle;
            end
        
    endcase
    end
end
assign done_flag = done;


endmodule