module DataMemory ( A, WD, WE , clk ,RD);
    input  [31:0] A, WD;
    input WE , clk;
    output [31:0] RD;
    reg [7:0] dataMem [0:65535];

    wire [31:0] adr;
    assign adr = {A[31:2], 2'b00}; 

    initial $readmemh("data.mem", dataMem);
    always @(posedge clk) begin
        if (WE)
            {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]} = WD;
    end

    assign RD = {dataMem[adr + 3], dataMem[adr + 2], dataMem[adr + 1], dataMem[adr]};
    
endmodule

