// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:29:08 2024
// Host        : alv-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Administrator/Desktop/uni/DAS/projects/lab11VGAgrey/lab11VGAgrey.gen/sources_1/ip/multAdd/multAdd_sim_netlist.v
// Design      : multAdd
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "multAdd,xbip_multadd_v3_0_17,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_multadd_v3_0_17,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module multAdd
   (A,
    B,
    C,
    SUBTRACT,
    P,
    PCOUT);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [8:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [9:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 c_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME c_intf, LAYERED_METADATA undef" *) input [9:0]C;
  (* x_interface_info = "xilinx.com:signal:data:1.0 subtract_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME subtract_intf, LAYERED_METADATA undef" *) input SUBTRACT;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [18:0]P;
  (* x_interface_info = "xilinx.com:signal:data:1.0 pcout_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME pcout_intf, LAYERED_METADATA undef" *) output [47:0]PCOUT;

  wire [8:0]A;
  wire [9:0]B;
  wire [9:0]C;
  wire [18:0]P;
  wire [47:0]PCOUT;
  wire SUBTRACT;

  (* C_AB_LATENCY = "0" *) 
  (* C_A_TYPE = "1" *) 
  (* C_A_WIDTH = "9" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_WIDTH = "10" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_C_LATENCY = "0" *) 
  (* C_C_TYPE = "1" *) 
  (* C_C_WIDTH = "10" *) 
  (* C_OUT_HIGH = "18" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_USE_PCIN = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  multAdd_xbip_multadd_v3_0_17 U0
       (.A(A),
        .B(B),
        .C(C),
        .CE(1'b0),
        .CLK(1'b0),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(PCOUT),
        .SCLR(1'b0),
        .SUBTRACT(SUBTRACT));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
RtCBFlgTb59HzIVFzZCj2shBVnKrn8Nl7iQxjENtVTGrNVyDsrMaEn33FCAYH+24SwbJJHwZPVY3
p3jfFFs8Moug0sB0rSNIiIBHHkCDDUhxGN5E2ZHuirXrydo+oy9ebtsHdiiPKNWGW+Ig0zqFmZHM
sbST84N2EEU/7yjG46Q=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VUggdMQ+nYiV0HaZjWeOycQgR7/UYKggutLBRLamjwod/7G1TAl1KYN8PXVouNu0Y+cOZLr1ZS+L
ZL7zqT0+cTeIy9RGgVCrza8gkxun46oZGt9iBpBQYfa5GHBF9Oz+yU9fg+Xxcwc2aKFcyRlysp57
SzjaSnTYH/TaCJz4E2exQCKEqf6ZVuNFU+zZOgFLgC02eFqRC6Sw9z2oHpsUrC8wOi/pjrV5oq/i
8pYumhBx5Z2VKBL/LkaRragW294E/H59ehNWJqw0R03Glt/r/BxvGgiuPvRGeq1cP3L5ijrAbJ6x
d6OU+MOV0QIfkY7l3OTPptCVEZ/Y+78/b+dsOg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
m031Yesyn9Y9N4s41aZhzl43hgp/3ntbCVRgso/ZfrzKq5YxbbcVzPdfJalMAXLw5fq8IpBOul2i
xjuqsoG506vRiGP55mKYjnML/o5983+5lST3bUcWL3N5WTLEDvgaWL1ngVYjmXdhgXdt3Q6j9hJD
mI79gId2VM06BWCZN9Y=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UTCnK4wvxgapnshnSRrOHEUmQ6LnvlcyzOX1dPAI6DJlA8L84izlNI3KKrQQzL977YAl3lwxFG3I
OytSnM4Sp+vHGTnPvQ4UpIHUjGTUMXGP25bS2yFhyBRVo2iJo9I+ZlIiUjre22o1vH9skvStLWPw
Hehv7zJwkBwMvOiiTacsc2WQjCDB58mgs/LQvJMU/ZjX9srQK0+CkVpH8aMvY7lsS3TcND5WJmlj
500vvizer4S4BD6u7ANnHXav0GOC2YEHZ+SbcEcudh9sG7q6MxizcMwlnDLMWtfVe8K2o3xhQ3Os
gviLWjOLggFrBNnSTB7r2mJAErBfWhjNjObgGA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hzjb7y1F5Rsbjoz+4FSDwwVNt/FY2lcVmhKcUYYcWMQ6i7DEipcYflPUnqjEhNgeIMhbhv4Tjuwg
S0gZfhj9buyheiigfMiyuN2H08Puql6C7GHTmjQdiXhS0f3nv8junrNlExbtAAxKamABT9V4gjRZ
VRiUPRx3ugT2Kd+J7fuwuR5oYp9SDQREPtkfHAzTrpS8XAbrtMss7TnC+E2ic+G5keyYCNP13XtL
oHiGxMAWIsiwWF8eUSlJTjFJMv2tc0UXbtRuvdUcyPqpqMRb1FiOKAxoNjvmlEalK6KC+KamnmhO
EHtjxoFPi+V6Zz0UrhwiOhAuxrj3UhAen9EQew==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YYasDw7mFupdpQCe83cCXWKaDS9nTwMe/Y6uWWLO13x1AOeXtZO4im6ZZ5BtxNw+XXlE9FqCN4ct
4hqW3Vhvh5zZa56HvizsoCt0+LXPVRFTWTxnFg9HeiKVZaOcc0fYxv3Z6laRIuvhx3xWp9vfglZZ
NF5dPyigpScmBbLu4p1C5sABMPoKR6UQCYiIkmwueygSRfoUGvzJt0xmDaX74YIrvsTLmtDks47K
f+suT+ZeCXMylyZKdQf/k2EH4xwEsaCa1rnV1cH0MamcZGCUC0mIaFfdtqISgGSLIAj3rmHGQJKg
h5v55fa7tpKmkIlWcFFUx4mJPM67Z6ybPpfj+g==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GiefBvqSLz8a+wQ8Lsajxh3CF3T5EpaldJuVhSjRwlhwYhjdKyQE1yQ1Fh1Jie7crG1le1GSphuZ
Lnln4AhEbNUFgkyDCsXcLPj0o1iXcty1NCPw5SXpOms2bOHnROUdG4Md3rX8p12q2Ci2g9tPgkAt
ajVCYhg69GNefRT7Wvy/FmjZ+k5AGZth/4pm6usrNb5dV+rXW2uBnGmJZRGRUSWdk+1Hoa6QPgVL
zDS0CUfLhnp8Ui76kt9iRMPzpFAvY4lxKJkTkErIXHWvPdbY3NCnpxW27v533kZDGsqw/0Xg4DmZ
jin4PsNYVWzGeT5S5Sw8JVNyM80GDAjbb4iX2A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
Jhcn+PdO4EkcOIRLUyswRzUutPrLsufHiGSTi0rH4DRxf52zaOqYGi88C9TYFbTvXsdYnqaSAvIo
9I9LirUrjQKOJ1r0CgkJd2jIHzNpfhs6vHlJPvyRSFNSzxqqjkaQB/S5bxBBkePsru8G/tpmCUnG
DRT5b+lgO5K4hPbtREo6ZsxxkXE8KrcEalhSsYPNrP4uQooRbYjuPoBTjiy+Kqf7T6pd0WlR6U0D
O/JvN3mrTb3+wtUMebr97Kcma7MfSS04ysjzinXo3OhgDNWawgOfCpKTltZg5+yElcWXItDOf8yh
MhzV9pHhrE7+lWG24D6ZnkK3rpkegOvTaivJXrCxnHJJ3AH30tIE8uRkO+ih1yMc49lWEGXJcV8d
XzCsHOS7HEHzEP8kCfYJNkKiAewsQRu54DRjNKkERZ5aMP5psupER5Bl5x8AyhOswDqEj4fQkog+
vL2y4FGM2IGkhLhUHEVED2WmMsIWKwbSsITHNEJrWDHXUEniBOn46EoG

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
pljzNGh2zWpW8bdd+D938BJNYUihPXN8welciRv2sUyu7AYqhoWRB1ZxK31wmMCzWG5RPdhs4SCa
+1M2QPB1NK22OrtDeavupl/qhnP1XzPPhxIOeO8jQnBhsJSNczwhv7IM7r2aYIR4uTRjqDECRESI
9AdBRwYO4FfuxSmQ41PrHfrnqvCRgsKDNaNv5d803drr+jwqNZJlPkvKJUBYIRPTusUGRjhNo6ta
fKEictniW4qOkTLLoC6GxZ3QmloZoOfafuEU77AhU7m9AHxBng+cS13sw60jiyqaGpytvqi3OpXo
tLLLlqPr9pHwwQALf7WSoB5PPPV+YAyTKRCqwg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
pxXzsbUzff30QOyW+XHRfMqELeWfVClBA7H4ofbwGLIurn6jC7TCIMfuAFSjVY0i6CtsIXC7SgXO
4LLG54dYeFPcnq5+P68BhIGAl65D7/MJK3lheU6NsmCSP3QJHJAC7QwWA+Z0St2TOl+u6lvyT6Df
6BqL61uY1rU627dzL2267+VaT2/XN79Q27Iy7Q8/vkwFj5f2RTTyxOq3CNqD0P6wQNvBxQQ8mTnd
nc865UJD+QR2QGDFIUcWXzngQDEZhrI/WylaDeeTPkQDce6u7LA9i2wCqHfGdbRkBnSozn1fwtBR
kwDUCbSzO9WDpyaKBKwmtabDDbQcQXQMhmemrQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Xmu8uu9xaMyWom/85N9elYBmDptMyB95Kgz7DhpdfRWREsa4X32/M13E7qzAdHDgRJp56fQ1yvQu
pPfixFnOcPPC3vbVOaa+DBMGqspbFIie67xOYMWa7BUJ+yDHjI1ZjQWr2AdWS8qrO1Ilz1jPakis
q8p+gD10EyptsiTBSTIFQTx2QICBzuyhN7/FS0TG1Ov6X55psFOpUno2ntK0NGz7qfhq3tpl93nQ
9297q4qgnVqbqHijOwCX3a3luiK4JEx6+3gPtXuNv6H07bH3cnQZIqqoFNLCAV+DbqyS7IjrotJT
1Fg9aOK+fFpFbHDVWCo4lIkg2npWXBqY4Vdhgw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12000)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
