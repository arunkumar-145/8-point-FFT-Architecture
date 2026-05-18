`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 02:40:43
// Design Name: 
// Module Name: fft8_implementation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module fft8_implementation(
    input clk, rst,
    input signed [15:0] in_r, in_i,
    output reg signed [15:0] out_r, out_i
);
    reg [2:0] addr;
    reg signed [15:0] xr[7:0], xi[7:0];
    wire signed [15:0] yr[7:0], yi[7:0];

    always @(posedge clk) begin
        if(rst) addr <= 0;
        else begin
            xr[addr] <= in_r; xi[addr] <= in_i;
            out_r <= yr[addr]; out_i <= yi[addr];
            addr <= addr + 1;
        end
    end

    fft8_core core_inst (
        clk, rst, 
        xr[0],xi[0],xr[1],xi[1],xr[2],xi[2],xr[3],xi[3],
        xr[4],xi[4],xr[5],xi[5],xr[6],xi[6],xr[7],xi[7],
        yr[0],yi[0],yr[1],yi[1],yr[2],yi[2],yr[3],yi[3],
        yr[4],yi[4],yr[5],yi[5],yr[6],yi[6],yr[7],yi[7]
    );
endmodule