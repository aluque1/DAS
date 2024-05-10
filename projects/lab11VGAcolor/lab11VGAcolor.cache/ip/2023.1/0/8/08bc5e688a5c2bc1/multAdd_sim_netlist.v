// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:10:02 2024
// Host        : alv-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ multAdd_sim_netlist.v
// Design      : multAdd
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "multAdd,xbip_multadd_v3_0_17,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_multadd_v3_0_17,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xbip_multadd_v3_0_17 U0
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
PjxHtGxWzXtojOSAgLnWs0YFE2gVZIPGZLsEFXtmdT8VC0E5axhfMwgihsFlbQ2GLujF4M80BSoo
sjZlJUb7TxOG8EsIESK2qoNV4uYvQOUfBEUbtJWHQ8aKgdRE8FJ1u4V+pR8B0ua9HQEfaLv8yxR7
WAH1dDcTSD5W7SKkjDbVmxb75zOGIMQc8u3L/S+RBgxeIrDLEhUukBOh/F4KU90Bydzcw3ujN51L
7ayeHN7NOFjpQbbFoeKaTZQNg/jCJhB4Moggqfn0ui9tgLhAzXDpm3YhGlLjNW1H4/XNJe2k4Wt5
FCWSSfoiiVWSnD8OwDtPPsaGKxy4p8/LRu1Sdw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oat7liv0vOMRneA/5OL7afk4zHxbOAgUT77HYvzyxcW/5QDklX0J7OZfo/uL3kmHzUgCue9yQh3+
GBYqV2R2wTnM6TocINf9BtuoO4rhk0ewyEtKpw5onWLct5HACGNPTfngaHLfy63Hr5xAbdebkjjk
7BpZgLdRNZSQXWorv3BkvMpDiW9wZ4nhse8lV4NA0uPosb/C8vsBS6KC4w62xCkLt50r3llnynbG
JbhiIity4DqeKOPwS/cP0GVurw4SSrHX0Ghy2TSTIqEM2tvTWnmGIK3Cz3tmlPET5NAXu5zDL9nO
oCUKaZiozLbdYCpWWC2nGfS9MJTMFGIXsmfW2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12096)
`pragma protect data_block
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
vxjfUKATMR8ENGDa
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
