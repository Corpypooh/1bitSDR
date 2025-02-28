module pwm # (
            parameter                   WIDTH = 12
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic                       data_valid,
    input   logic signed [WIDTH-1:0]    data,
    output  logic                       pwm_out
);
    localparam                          ONE = 128'h1;
    logic [WIDTH-1:0]                   counter;
    logic [WIDTH-1:0]                   data_reg;
    logic [WIDTH-1:0]                   compare_reg;
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin // reset, sets counter, data_reg, pwm_out to 0, but sets compare_reg to 1
            counter <= {WIDTH{1'b0}};
            data_reg <= {WIDTH{1'b0}};
            compare_reg <=  ONE[WIDTH-1:0] << (WIDTH-1);
            pwm_out <= 1'b0;
        end
        else begin
            if (data_valid) begin // if data_valid -1, then set data_reg to
                data_reg <= ONE[WIDTH-1:0] + data + {1'b0, {WIDTH-1{1'b1}}};
            end
                counter <= counter + ONE[WIDTH-1:0]; // adds 1 to counter
            if (&counter) begin
                compare_reg <= data_reg;
            end
            pwm_out <= (counter > compare_reg);
        end
    end

endmodule
