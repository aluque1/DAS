// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:29:07 2024
// Host        : alv-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top multAdd -prefix
//               multAdd_ multAdd_sim_netlist.v
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
gzh4EeUxRhkkoeFeMFrvJnZjOAj6x4JB/9UQcQkPvz+Deq0+Eu6LBabWEveyRiPQn09AFxlULNIo
K4gJZEtYtnUKjk1oE5PreEIlCaBsiczZYTm/VhEYVhSsFVw+I1E+e1URWKfXyN0vQgnR/XIP4WgL
Gs3ifIVqDuC1dNUFqqcXscbhsDWf6AB7zxU/QQjdq1K3kFWbtuEFjLY/JjKNV/8jn1gcQ/2TbTkV
5LM23XURE3/pxIgoy49pLb+Hjgs7x/Wry8y9DgB7G6IemA5HNveY+xiiCv/u7GPhrhTGOLSwFpLS
8qKB8Wl+e/eriWaPQ7rPM35y6M9smP7dbTMMHQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IBJxcyywF38TsIbC0wStVd4htSWo+ecQZr6NpXM9B/5dPSTtBQcNO0mha3BBZ7SIbdy2WBPVjQDp
u7t8qkx1YiR5dFc9SreNc/dAqckVh4B2TsoeQwEhBzcFcU9SHsLpqhL9sF0K8+EyKZF5x5B+4Qbo
MV69oCwi6ZKCqZ30AidcsCKXhFiTAEwC82sK5MdBmaAxTE3/VjFWUtEz1lCUxNM/WQ4tDO4yI1Ps
Ag39FZPejAoN33YRztazVYoPIokeMeU04HEB2+SuwwrsdT7aoUBPQQdjaJvEu4b1vvvPAbgb6pWK
2QZodW4MmlQG4oc1M0A9tJpSWfwGJ3VElri7gA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11712)
`pragma protect data_block
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
al7FhVwdtCpigJ+aLo2oK+hzumVYZqUSx6rH
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
