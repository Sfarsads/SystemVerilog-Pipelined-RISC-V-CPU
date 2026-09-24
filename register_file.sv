module register_file (
    input logic         clk,
    input logic         rst,
    input logic         reg_write,
    input logic  [4:0]  rs1,
    input logic  [4:0]  rs2,
    input logic  [4:0]  rd,
    input logic  [31:0] rd_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    // 32-bit registers 0x-31x 
    logic [31:0] regs [0:31];

    always_ff @ (posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 32'd0;
            end
        end
        else if (reg_write && !(rd == 5'd0)) begin
            regs[rd] <= rd_data;
        end
    end

    always_comb begin
        rs1_data = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
        rs2_data = (rs2 == 5'd0) ? 32'd0 : regs[rs2];
        // Forward WriteBack data
        if (reg_write && !(rs1 == 5'd0) && (rd == rs1)) begin
            rs1_data = rd_data;
        end
        if (reg_write && !(rs2 == 5'd0) && (rd == rs2)) begin
            rs2_data = rd_data;
        end
    end

endmodule