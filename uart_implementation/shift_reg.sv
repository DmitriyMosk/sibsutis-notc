module shift_reg (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire load,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0; // Сброс регистра
        end else if (load) begin
            data_out <= data_in; // Загружаем входные данные
        end else begin
            data_out <= {data_out[6:0], 1'b0}; // Сдвиг влево
        end
    end
endmodule
