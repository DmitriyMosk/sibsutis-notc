module uart_tx (
    input wire clk, // Тактовый сигнал
    input wire rst, // Сброс
    input wire start, // Начало передачи данных
    input wire [7:0] data_in, // Данные для передачи
    output reg tx, // Выход UART
    output reg busy // Флаг занятости
);
    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 50000000; // 50 МГц
    localparam integer BAUD_TICKS = CLK_FREQ / BAUD_RATE;

    reg [15:0] tick_count = 0;
    reg [3:0] bit_count = 0;
    reg [9:0] shift_reg = 10'b1111111111;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tick_count <= 0;
            bit_count <= 0;
            shift_reg <= 10'b1111111111;
            busy <= 0;
            tx <= 1;
        end else if (start && !busy) begin
            busy <= 1;
            shift_reg <= {1'b1, data_in, 1'b0}; // Стоп-бит, данные, старт-бит
            bit_count <= 0;
        end else if (busy) begin
            tick_count <= tick_count + 1;
            if (tick_count == BAUD_TICKS) begin
                tick_count <= 0;
                tx <= shift_reg[0]; // Выходной бит - младший бит сдвигового регистра
                shift_reg <= {1'b1, shift_reg[9:1]}; // Сдвиг на один бит вправо
                bit_count <= bit_count + 1;
                if (bit_count == 10) begin
                    busy <= 0; // Завершить передачу
                end
            end
        end
    end
endmodule