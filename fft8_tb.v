`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 02:41:44
// Design Name: 
// Module Name: fft8_tb
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
module fft8_tb;
    reg clk=0, rst;
    reg signed [15:0] x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i,x4r,x4i,x5r,x5i,x6r,x6i,x7r,x7i;
    wire signed [15:0] y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i,y4r,y4i,y5r,y5i,y6r,y6i,y7r,y7i;

    fft8_core dut (clk, rst, x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i,x4r,x4i,x5r,x5i,x6r,x6i,x7r,x7i,
                   y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i,y4r,y4i,y5r,y5i,y6r,y6i,y7r,y7i);

    always #5 clk = ~clk;

    initial begin
        rst = 1;
        x0r=1; x1r=3; x2r=2; x3r=2; x4r=1; x5r=3; x6r=2; x7r=2;
        {x0i,x1i,x2i,x3i,x4i,x5i,x6i,x7i} = 0;
        #20 rst = 0; 
        #100 $finish;
    end
endmodule