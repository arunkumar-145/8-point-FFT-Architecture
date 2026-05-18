`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 02:39:31
// Design Name: 
// Module Name: fft8_core
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
// Multiplier with Fixed Arithmetic Shift Fix
module twiddle_mult(
    input signed [15:0] xr, xi, wr, wi,
    output signed [15:0] yr, yi
);
    wire signed [31:0] m1 = xr * wr;
    wire signed [31:0] m2 = xi * wi;
    wire signed [31:0] m3 = xr * wi;
    wire signed [31:0] m4 = xi * wr;
    assign yr = $signed(m1 - m2) >>> 15; 
    assign yi = $signed(m3 + m4) >>> 15;
endmodule

module fft8_core(
    input clk, rst,
    input signed [15:0] x0r,x0i,x1r,x1i,x2r,x2i,x3r,x3i,
    input signed [15:0] x4r,x4i,x5r,x5i,x6r,x6i,x7r,x7i,
    output reg signed [15:0] y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i,
    output reg signed [15:0] y4r,y4i,y5r,y5i,y6r,y6i,y7r,y7i
);
    // Bit Reversal 
    wire signed [15:0] xr[7:0], xi[7:0];
    assign {xr[0],xi[0]}={x0r,x0i}; assign {xr[1],xi[1]}={x4r,x4i};
    assign {xr[2],xi[2]}={x2r,x2i}; assign {xr[3],xi[3]}={x6r,x6i};
    assign {xr[4],xi[4]}={x1r,x1i}; assign {xr[5],xi[5]}={x5r,x5i};
    assign {xr[6],xi[6]}={x3r,x3i}; assign {xr[7],xi[7]}={x7r,x7i};
    // Stage 1
    wire signed [15:0] s1r[7:0], s1i[7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+2) begin
            assign s1r[i] = xr[i] + xr[i+1];   assign s1i[i] = xi[i] + xi[i+1];
            assign s1r[i+1] = xr[i] - xr[i+1]; assign s1i[i+1] = xi[i] - xi[i+1];
        end
    endgenerate
    // Stage 2
    wire signed [15:0] s2r[7:0], s2i[7:0];
    wire signed [15:0] t1r,t1i, t2r,t2i;
    assign s2r[0]=s1r[0]+s1r[2]; assign s2i[0]=s1i[0]+s1i[2];
    assign s2r[2]=s1r[0]-s1r[2]; assign s2i[2]=s1i[0]-s1i[2];
    twiddle_mult TW1(s1r[3],s1i[3], 16'sd0,-16'sd32767, t1r,t1i); // W2
    assign s2r[1]=s1r[1]+t1r; assign s2i[1]=s1i[1]+t1i;
    assign s2r[3]=s1r[1]-t1r; assign s2i[3]=s1i[1]-t1i;
    assign s2r[4]=s1r[4]+s1r[6]; assign s2i[4]=s1i[4]+s1i[6];
    assign s2r[6]=s1r[4]-s1r[6]; assign s2i[6]=s1i[4]-s1i[6];
    twiddle_mult TW2(s1r[7],s1i[7], 16'sd0,-16'sd32767, t2r,t2i); // W2
    assign s2r[5]=s1r[5]+t2r; assign s2i[5]=s1i[5]+t2i;
    assign s2r[7]=s1r[5]-t2r; assign s2i[7]=s1i[5]-t2i;
    // Stage 3 
    wire signed [15:0] t3r,t3i, t4r,t4i, t5r,t5i;
    twiddle_mult TW3(s2r[5],s2i[5], 16'sd23170,-16'sd23170, t3r,t3i); // W1
    twiddle_mult TW4(s2r[6],s2i[6], 16'sd0,-16'sd32767, t4r,t4i);    // W2
    twiddle_mult TW5(s2r[7],s2i[7], -16'sd23170,-16'sd23170, t5r,t5i);// W3
    always @(posedge clk) begin
        if(rst) begin
            {y0r,y0i,y1r,y1i,y2r,y2i,y3r,y3i} <= 0;
            {y4r,y4i,y5r,y5i,y6r,y6i,y7r,y7i} <= 0;
        end else begin
            y0r <= s2r[0] + s2r[4]; y0i <= s2i[0] + s2i[4]; // W0=1
            y4r <= s2r[0] - s2r[4]; y4i <= s2i[0] - s2i[4];
            y1r <= s2r[1] + t3r;    y1i <= s2i[1] + t3i;
            y5r <= s2r[1] - t3r;    y5i <= s2i[1] - t3i;
            y2r <= s2r[2] + t4r;    y2i <= s2i[2] + t4i;
            y6r <= s2r[2] - t4r;    y6i <= s2i[2] - t4i;
            y3r <= s2r[3] + t5r;    y3i <= s2i[3] + t5i;
            y7r <= s2r[3] - t5r;    y7i <= s2i[3] - t5i;
        end
    end
endmodule