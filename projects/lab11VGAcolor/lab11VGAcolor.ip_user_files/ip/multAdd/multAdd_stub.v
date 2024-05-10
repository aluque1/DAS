// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:10:03 2024
// Host        : alv-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Administrator/Desktop/uni/DAS/projects/lab11VGAcolor/lab11VGAcolor.gen/sources_1/ip/multAdd/multAdd_stub.v
// Design      : multAdd
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "xbip_multadd_v3_0_17,Vivado 2023.1" *)
module multAdd(A, B, C, SUBTRACT, P, PCOUT)
/* synthesis syn_black_box black_box_pad_pin="A[8:0],B[9:0],C[9:0],SUBTRACT,P[18:0],PCOUT[47:0]" */;
  input [8:0]A;
  input [9:0]B;
  input [9:0]C;
  input SUBTRACT;
  output [18:0]P;
  output [47:0]PCOUT;
endmodule
