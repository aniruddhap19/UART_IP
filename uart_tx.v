module UART_tx (
    input clk,
    input rst,
    input [7:0]tx_data,
    input start,
    output wire Rs232_tx_,
    output wire done_flag
);

localparam clks_per_bit = 1250;

localparam [1:0] idle  = 2'b00,
                strt = 2'b01,
                data  = 2'b10,
                stop  = 2'b11;


reg [15:0]counter;
reg [1:0] state = idle;
reg[9:0] data_buf = 0;
reg[3:0]data_count = 0;
reg done = 0;
reg Rs232_tx = 1;




always@(posedge clk or posedge rst)begin
    if(rst)begin
        state <= idle;
        done <= 0;
    end
    else begin
    case(state)
        idle:begin
            data_count<=0;
            done <= 0;
            counter <= 0;
            Rs232_tx <= 1;
            if(start)begin
                state<=strt;
            end
        end
        strt:begin
                data_buf[0] <= 0;
                data_buf[1] <= tx_data[0];
                data_buf[2] <= tx_data[1];
                data_buf[3] <= tx_data[2];
                data_buf[4] <= tx_data[3];
                data_buf[5] <= tx_data[4];
                data_buf[6] <= tx_data[5];
                data_buf[7] <= tx_data[6];
                data_buf[8] <= tx_data[7];
                data_buf[9] <= 1;
                state<=data;
                data_count<=0;
        end
        data:begin
            if(counter<clks_per_bit)begin
                counter <= counter + 1;
                Rs232_tx <= data_buf[data_count];
                state <= data;
            end
            else begin
                if(data_count<9)begin
                    data_count <= data_count + 1;
                    counter <= 0;
                end
                else begin
                    counter <= 0;
                    Rs232_tx <= 1;
                    state <= stop;
                end
            end
        end
        stop:begin
            state <= idle;
            done <= 1;
        end
        default: begin
            Rs232_tx <= 1;
            done <= 0;
            state <= idle;
        end
    endcase
end
end

assign done_flag = done;
assign Rs232_tx_ = Rs232_tx;



endmodule





