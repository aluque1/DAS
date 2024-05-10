// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:29:07 2024
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12096)
`pragma protect data_block
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
oW6d5BzjEeIfCv5h
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
