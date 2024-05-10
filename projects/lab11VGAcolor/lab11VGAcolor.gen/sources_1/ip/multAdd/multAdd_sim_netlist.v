// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Fri May 10 05:10:03 2024
// Host        : alv-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Administrator/Desktop/uni/DAS/projects/lab11VGAcolor/lab11VGAcolor.gen/sources_1/ip/multAdd/multAdd_sim_netlist.v
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
owrIRR3AE0j/qKYv5zG/BXKqxz4ETj8CPsexccbSvFSjLfzZvf8KG9L/OJj0PillcoqWC/ZHmRzy
GuuvalsY726YhDsiLcx8Zzk76c/gBf9Pqzs0yBhW2305e7lrnqXE835cq2iseRWomNsloczhoDWI
SIwSCnQkddNd1cR0RZxkyM0f0W747+zr3o+EKSnYiTVRZDc7TnvhdxXWZLT2N65DI09fkK6+ypC9
9Fhp2QvbyOsuqJMu8UXEaiJs/brIihgmD19koDWdzmnkFPGXvxUghnS1a/s6G2nDJOa0OoQ2Ewms
8AEYBrVEhN9m5wPxPtKaydgnjjlyRkzO/UmVuw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fMcmHBknXZz5xBuqBe1n/ybsfE0kgRfeyejGK9PM+GgWd5McjXZf5UyH58AengwoYU5Em5wHUED+
jQO+YHDLhsaAVfIMHvWl2TxzzILw6co8Ripe7fA2KxDtbz2WK6uRlraJaZbl20ywLZh3OIwm5bFd
WOn4PNFuctobOOLFi7iJuTPBj5z7IHuwSc7Zmdbo4q1zCC3Zd7r/McouRUHK6LUUlHM06tHt9SeL
Mda3mOyoyPApCozlV9wIQOkGv6DPic1LxOOCqNIHZPpuZHl5qj+wX2kY2McZk/DM7Dt8qwB8GTvF
P78GcNXBMarD15VFNuXqO4K0tmnyABfqG13mTw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12000)
`pragma protect data_block
0XjON5Gb1RbCK14Am2WEvkaXreaz272DdK8HL7kyObP9bIvQA3cJ1rNPe+GCkPfAKS8jtOtgPzib
4iDp/lgL7rXbxW88EIt0/EzDIAoriT7vaOmSVVTH+pf57ssKMKMKIY5nWjYWRWbh0i1m+ciL6o1g
HYMabcSLPJ0LSvtEvEOUD923rvGTNVyYdHCk9S28/glMwEAi6yHQ+ZBBpsaB83TWP/nPopH1J3NQ
uxwthQ+U6zqxSMl9QxWDHwZWxIHfK9G+YTrcdXw7w6Dx2lCZspEzpyzvU/l1u4uCxIZSykj9OFjQ
orevjI6+XOWyhvZ02X0eqzr/r6ILkUC7Z3nLzfBy3bg3wKE482y50wVMe5QkvPt5qvKDh83E/uzv
615MUGVMfr2oH9099IjX4ts/5HO7xjTnXkVm3CBXgJDtPB8v8uzghTrTf/OIv5BUAAxAxi+SBc8k
JfozcG0gIGCu7QgpAbV3vJeSAuqui+sLYw3CEDr1GULhzhGEkjcgi6uLD3EKp0Ektjqcvfob9bCz
PYqXZU75NwYJpW2Pq5RQM5LZXxhbf7hKtqZw+KSPXmkEzg1svB2WRcnPTri6Pz8IIREqy8c6/gKz
vwtzJKvGWWm+5x16LQpKmbUcipyUvn4bEyVGURx3hvKwD/UPvkPG/ywmw5vLO4SvYDIJN9wHEciJ
Uxt24w4kwBN/3Ykp/yXJKVL358ggiKZhNf1F8PUESZmipb6a3GJ+ApSMXl7sQoQElWLi2LtZz5wy
Ek966F+1TilGcOnIqvE5Q3LIixTNa0Ri42/BRWdGZ7736fB7NdQO0odeSYZ6wcf/ty2HWKDpj2Gl
gkT0Mzg5lHjlQQUAx3v+dGrIwyaolZKBQPFBRE3bYMxBmTDeOJIbh+rlZb7xJ8stna3n3p2J0Ztn
u3SN3sDjjND5Ys0TwYOJZWaf7tn9KMUkcMDbzZbXENwZL0o7++qHMoUfVkB2UPnQNhzYW37okZC0
+HioFJ+pjBE2t8RQJacLqG0W6n4UN7CgsklZBXhHTtvN8a3v68KzPttCRX2FYyyVdtlH23U2x+y2
cUqceQiNZVPS3Dg3CWHJlDvOLrEXOGqhL11jwIVEvHw/3rPecMDQyauKwC7sqBoyDSY73FaUjbfU
MXuLN4Bh+9KocNTnRpy1YkGK+XdMSvWcquIoRrETjtOqs0JCqVPhB9qct0WspsF10wG5wBaJgVvk
0dbmNFQE4o8DemA+IrEEGS7FNCTYdQrmOR6zNr4t6683dvBCTSd48yG0DkeCyKbn+CGV3M0za+E7
OjosHFTjpeIID0C3imH5HA4lWkkPzGXlSGGVSM/Con+xZR3+br/8CCkzQkpm/IyrhIxOkRSyPnrl
7soRrW0u8ew5mj8f9Cl1ackbjsotteHgd3OTT5EaF5DR4ai/IDoNn3hN+N5pp2mi88M0XRc0Soqm
KLiYmw8BqExZSMrgBZV1HJyxfIb4qVQZEiH8vGlATN+v1/TeRKPw0UeT3aMonHAInN1fviAqIMZh
81iSnXSdRPeH5/2Dajz9/8dyRSYOVgE96cnSKZd3iow1qMf1U2EsY+Q+w39rgCfrUxf4c8FqgquZ
5Snw0H5Yqg8Zm6WJfIB77Y3UO/0L9UXo2VPVN4CN7ZdWinMiM6Rdl0n9MF5eBLMsZO1tl8usqJkJ
KS5qywxGwIjQ3lyVDCtezf4dQp2fkx3qQ8+JElptwlK43PqrRQpbwiVTsU4jmUV88261yANqEQUW
rPLU8TUwNKioyZ7qDy/nDXA0R+ntOHFglJLKzUJpIpTblY6QzIsmAiLD9iPdlM0Wu87zNwMAjo2s
bsk3h5mgBKbtDPOeD0Aq31VFAP13F28lQY6zOo38ipjr2DVeZHfEu3mJjTGqA7e8DanPYxhUBm2h
xzM9AOJh8Soqb470QRh6oFhNoHlqw4V4OGIMgjSIY/35kw3pO03bQgWNL9cBxbj7sKJg6+9mWA3t
mSFCoS8emxWFZnsEtzzO+Pwk3n3hpNgcm/VMLzXVOF8X2146PC4U6eylcT3mMZRLVkMzjaqdOhzL
nDj0zD/RAiiynrIRhPn2hiSPNUoXvj9zKUIYyAlVMQQ7GXwlhZPMmEhpFjkZiXhTBMezUqTzzfUf
1IG/0ZDAdPJhSK/QHLZAiDwdsGH/RQi06siKR4j8tsZsxwenNMlBLQBGLogw9+G+bOhcKEmeNNi0
venvmCHhKRGUg0mg+jfxN70lqr1REAKhDrhp43tJ99HCK+OegE4j70sSD3EYIt74JVvrm8Ot7EpJ
ossbo1q+ozU1QvSRQ5kS5BcTcpnejbfJ2GXDS9bKvEmJW64xpjoXo8ME9olZ3vaUA0fsCiuge8lU
mppLSk/X7eW8EcHOfdWG8ooGaDCkBA8fLLwBFe2OEDr47lN19EvhKz2ZE6g0qU/9R5JGFjpaBvOL
SyqW7q8hm57Wr72KUnXmwDPt7q/MCgl0U9Y8R2ENGCvu04W6ZwE+oRpEYVot9bPmO4OPClTmkZKw
ss48Z6XBzw3RWiG2JiIGzHGyNTYD5swnxlhyU9juKTqxayEBB946/mBPTYFCvCxaT3FwNacrw6WM
MUVqMRk/47QoPrvAxmD+hXF4pLyqYZlDkpMWrtF29lm6jkDiXYj0fji2eLsqc2325ILM7DIuNAnO
E0XGcjSneOmAFlPcu+3Wru/xsdkN66Q1H+a7t+mm3vANLQ+yomfew7GBEn0UDLMJoDL5PhOjdxDe
wfxrBK4JaWNtoYflvzpVcygJeXbbEGIUYk85JO8PCIUuiZSv1ylyvoIPAjwY17gk83JOhNSrWYTk
zX9JBeHcG+NdddT+V/Etb9JjJN6hdOvS+dp/2FYmybSGWLFlAprmU9iAO/4A2irHK1EOxw8JiSr9
2/CyB6b0sQZMG0NIdHDptzEWqm3q7AbA8nu3fPhcvAG37X4U1iguf5GF5QR7gAhw9SbjcHFNiCRg
knsUb+7HUXQKX4axiuwAgce2lJWgs6hFHycsjje/mt6cBsqDWrMMVIPwN7i/0rndZA+ZZxy2xqJj
xeFCwqbfL0gm4gQcnT1WPCM0J6nyoiBtL4dpo+dcbuUzdedZXpTHyt201kbsoINtLxG/CAIQ/N2i
2joEIS95vihgv/5gSHfB7O08JTaXWwqfhRhwdJ2BcnaNAMNwr3ym8e7A9zFff9gsP0gEwpagBzjP
sLPDJ/je+HCzcJyyH2kcXnHFuCXkzUQzkNxGtDLu61DeOym+TWy7CJP09p44sFgQv5R6/uMKdlxZ
lhv4tYCLfiP7H+CpvCq9cJIE6QrMv16PBcSXkUCiiAAj8gIwtnVHyYA9m8EBn5OsFA9xfOUEK7dW
cALTbEvGJnAsfSin5psMSfWvOsq/VQJYDxzI/5drjGjVcFNzOyp3bTxw/szl0aHb3EcXm9mBo6p8
nz1WC11QKlEQkggCSl5b9zjmlIaE4cuglIPxFl2KLn/fAKiC4TTEffyiEe0i2AzLzL+iM1qXYu4L
GUaF9s3AmF7LlwKxiXNBxt1lmvUCY4N7PuHnpn2Olxe3up8armK9eN7mw5+bEBI9jeRjVzcI4BNm
jKI5/Woc9Ut4MtcWwHmbbkGAbq+P7BOFuDqgRjgPsAdxbmFnrwQxdFdKtz7QSRzDG9zRMB2K8e2/
ixDg1/YNzd47yuknmV6/kzIawwvi8G+cyO840k9aYmsvT+pNAhurs+KAeYXvFamGauqJhUYP8to1
bhD9jqN4c9Vs+mGcG3YRVtbptUixv0eh1DcC+Qb5Xeqn6eSQIxfE/sSkccBsACKKs/2p2QL8cG5s
ifMO4hRYBKkkC4S8vnDeqbFlHiE1Dd8E83PoUNonAPUXBvI5eZeYGEidRkaI+oI+OnQzbl7UX7xk
16/PVpM1PImwQkMT7mSIDrXIcTKHMA0LagPsH+/mClAwWK/qcNfJOEm/DruWXv/U+YER0Uxpl+YR
PjSEuB8NOqQksFuNVscqVHw5DuqilZNIvbVW+md/xoxHm+3aGrrxYD4BN9akwkaItm8u0JPSgCuM
s3SI6f7oF0/Vjg3KgszoX+xcge1LGUEx7OqudA3NIKEVwW7QkzLVrIxQMVYR0xmoa/AoR9motVic
929tTRgm0cZPpGj5uVMLO/jv5NHyMiPUQyYv4DTFMTZ11A/kCp292sYUxH7UL0CWfFd3j9e3vkwM
v1iE5zeIpbNxvValRR0fOiFs0rJw60Kqp+5MNa+mmJJdMjtiru+Tz26bDRP/23iKThVbl0PzbI+X
U2H/Kk9AI3iTo9jC0XJirTCryhDyt75Rmas8SEbaeIdgCbN4FV5QZIg7KXeWeAQSbZYa3Ya+qidd
8kRxNONY0T5W6UETWMyYZl5OoZ6ndBtXCByOHkRyXqZuc/co+ycArncDQEa2l0cxuqMs4c8eQ/iK
trtOqM2C5VQfrHvqmSJIQ0CouZHIMyGhDTuBPP/XQGXQi804VS4wPtZesxCIoXTUs2eKuxYRkfj0
42CBIhAiGLXpECBe563MPqo9Gaku2+YnCE7JlH2PtwyYvWnp1u6XP1rHTWWSG5yMACj05xX7nfXM
E32nNr85wPotI6/pXRsrZqAFNqzBjMMzpXY5Wf+1hNuhLjSFTFK9qKY8me8fonWgz3NtS9kfbDNP
443Kyx0kxvnr9DRb31Obuk30ivc0YhcINQQy2lj99H8jXITppfwcxYyXuXHbohYsEk6kWLlsEGsH
32nu49tbG+7iE2WB+sqzgVncVLmwmSfysB5UFNaP3RjUmI7WtvhblIEkB1PgjFLV3hGzUENEYWiD
Q4CbF7zLcj7B+lAU2ibGxg9RtmteqIZX3V0z8d/d9EDw1LtB/kyW/6QpHbX2FPBgEMjjB/6USXn4
JhV0lieS201NMU2Hx7oV0JTkQrs2cyRmmk+89jOYvO5uaIfmu3xFQ60UC9dlIgmjgZZqSDKcH5WR
oxXKiKwNZjfzvMYyrMQ3AFBXIWAl7YDfPI9kpUo97gKyBel9pL0mxuNhvCmGUCVh4jAPapAdKSaA
UgZVx1K1dIKILuz1gG0h1ntOsmXtzhi2IRc/xWEjIabaUBPsJP+boC/PDw4+xaagT4UXvjddLBnl
Slc4JkyZ9FqqVLnnd08NnSRnN5xozATGf92724vrWcnZRNYDtdAC2Q8xjIZ8OtZK8Hc0/2eT05Rh
/KRivOICv0+HzHD0Jx6PPJdi1NJYPAjCUC3PDDxdkpt4RnPYAXxFhoxH7iIG6edXLRTNMls/WG7J
NUM+/UFalzwslE6B3f8Vv0byl+Pe7mykXLA2Wo0Za99NATSDCA8Z0DUh88bo/rD/RsX573eK3/Gm
iVmctWk1BIdm1GcHUxSxCCK/GB7O7qpHWXD8ArqpbwjYwJBuSNd+qLgS4SbpYPOgQDGA7Dp9jcgz
swpk+ncnRc3+J8J65fXWtaVdIbu8296FrRmj0pI7rw299FmSjHneBwnhTxo1TCdJJBAFIr4Rc9gL
dGftAf4tKju9ArHRsbydKqT+yOofiM7Q+WZM5CqmFgeodoqzUZ7BmhqaCwUvZ+rNlLm+jM/8HSvi
TuzmT1zQ0qehNW4+pycOqjkH/T6mQYi3pKbgu3L3NBh6ySNLYt7JzolZ1DL7bPKi/0cqESVnsw6s
3ap5fR7LXj6haSPjyEHVJZKC4GqTlT+AT286y3FAjJJywDmeOwUnz2vHmnPHDZueHgv/iKkVsJiC
BlOOchB+xihQGnxHCh5fZee4Fid7I7odt/sdMMbvFDFxCqCul8A3dk75aiJ65/Li5HSlJTHG90XV
GZaJWHFTiPXc8c7BN/g4BBLEgOp1/YMT+gSLjxX8v2iYL6SC8l8a1+X/uful2N0FbYQ62QBrh9it
Tj6P8BzBlJKaxvKBEpDzwxQ0jPhIpH7Nl2Xb9yVXKbh3k3q4q4mrrVcH0hXty6UpMkmN80j1nVHE
1EQ5I/hGS+8/SSmWmYKE369KibUDky6H2ED5mPoK5iQUFrXwpYg/dXtGFMhe56vDjYLA/Mk6Mmxj
wkjfg784jOAuhDQEqqbUJJ4JmwgxtiUCEe5ueFmgt36BDrQ765/crpG+eedJCI9Y2NZEg760Aiyg
1WdJul8RFRKVG9MzwrIY8sjQ+r558VeCJqzIrVrA7vgeL4hWA0C5fVRT3pdNwwXOPRHj4HrMASm6
Q7/DOA0oJ3Mq1AtJRpAlXOxYyDO6nNOxI7qv+yABqoxj35Ae8QS0UtjAuF2tkeQ6EAATTo00eXm3
y47ARO0Q2W8PaT2GDxypQQMeWxZADeGO412/gGyo4nwkIDtdYcdHjGyleeqUcz4F94QIU/JUDnFA
RrCuIppc8QRWbuR1Lb3hpTGIgSRVAM/s6cOsReojBgaiiCO6a0/F/8Uith+IAogFFFh5As/piwAr
iMDsMeof05ZJtSWFOGkn2B7bRv4R2i+GG+d8JZl9mpZzRfNQOHo0USzHeZ7VApdSiGLMSXbthF68
W5wdaAA8EzpHtYUq/ff68DdSAxSwuOt61QTTvOZhzfmB+EYIQl+50xb526T5Ai8Dzjvyv2yM5yy/
gFZljFUjIsX0dIv1qBEbNoMAZBWRvDdA6pRVBCaKrV6gWwUbrTfAWP6S6YIML6WZ25hwaldt0tND
iIa9u4HUB77c61Su+CA8X+aB4XDxaJM5/w8Tkwm+boWO8qfEMhxIsVrue7d+MFYQui/zqpY/Corn
wkcEVtsVzKjQLSV5vfrrlkYnoNYhIdObFSDwbaW2LiZYI3bsst+52KO3Iom8HzEWHL8cJQGGxW8p
r2UcZ+xg4bGnMl180VO+e4Ro/vEzcMON7ainKh3FLibV7/T1duwTfECSyMiBLWacok0IA9gjLDUz
ptNrEYTeOrhGntZRjEr9/4UnB1EidzQ2sEWDYdOx4LXAjgCyXe8E3hqkKl2kgYaOKs5Og/RnbUYf
pw35VRUi5WkOZCreiJkn/YtSAlgJ2BukhzkJbUch2jmwm+q8utQiKE8dYNx8+kpTypcbRkD6Vct+
DVR9V6GkGx79NkdP4zpy7vRt/TExQtP7ZrQIb6cPZsbmmfAEP9lukrgjzVCjswOs/mQi9s9Mdmho
P2rVGGUiyIar7agHMxmTOhhv+EaWEmvG1g/sSFK7M6Uk9hbBB8wZ6M1b0yhavGH6tm04wrUMWJfi
WFxCxtftdef1Ahevc3dQpeuumSTwqm+P6Ha3xs//LUhbYYX51Cbhbp7JK+2YB4nojkVsxzU/WlxC
XVLsX08Z584R1iK2YUQh6S0GGW7Dfz/Mdku69aBJXD8U82CrhGpTpOdhkg+2hVktQ450czefRvWH
BtSDmqWXT0U9GLtKyMOwt+atL2d9/w10SAgj1uKmB/5CIfqCA3UZOvrTffVmy4a5EntqlX0vRm+m
y2q1Iz7mmFLy1C7UaDNpQQZssjY86HTagK02AYuGVwn2614Rvl9IAtPcolJRN2SJH1+PYyJoOXEj
LAyAqZecTafWm7PS6zpqXoPm5MTexisES/8D5Qd5tFnTaF+D5IisjxhSz3G1TvrfQXPu+HYzyGjd
SfmnD4q8fs5GaKBoWjI9ygIyHl7kwOndPpPnYgjwcqrpY6vrmOHQG1S3eMCxaWvSg9ucYtbIduUW
jTTDzud73pfURVZTN4pNhi/3UcJfpEx8pU699tNqXwaVEwqBGkjtHYbXzejigU+bw/7cwMMu6uW1
L50ebxDTQlbdqLuy43aG1io2+xJmfY/c7BaQyO/Lnwja1OMcS/0FOVtr104+/O9Po7r2ObBBENPK
AyV81EE8N/BYR/IwAmiBzIZLokFgWOYop0NP7XQS+t5Ae1FCPfBTxuT37qUgfUKgngbQfpxqeIVX
FqIkbfmqgrFFOI4JON2KnSlAJVGxxifYx081GbHQn0moaZ9hoRIJf5JVPcyl01yQ13o5b8Gyp4Ph
NIbQbjfD05W3zKIK9gEzqtFFXRYN4OJrziUT8k3wADysYQP1Ar1dUH6pJl/HAeZSfEx716KNSC4P
EgLnah+naZp5bU6tkTsX/mJEGky2LJJsCMG5UAgczB2LdrG2FbkvRbX47vKGrgKvMuGzX68tSibj
Dg7hoGq82ZjQnuundT7vvO9Q8/wCBeySPtxhJRiVCKXDgsF1p0Rdegywc7eK0JXp6Mbcd5GEFjoa
J8BqXGydVEL7+wcahjdXemAFS3RTCwBqShIvljzlD+iBPPQ1h4L1VmDTopU4CzwG2WcI9ae1gKBj
+vU/QDOCkbVD/HvdddzuH82BmJ8bLfbOtApPCw2U9IHWh5HTEnLM/HVC5unhfMCD4nSOCPvuFCya
IxlWhOb6frtYnGIs7tDUmVsyj5q4HHCLviLv/iJqmB34cS8UUcHKaSmuAHxp7xlV82XBWs9gOyrB
/Cg0EU3BiFKdthuLxLX7eua79LGKV/+qGPF6Dk21mO7HbjMAYEnLhbpg/qMVC0n/4Jki7HZNE2w5
WYHghWpOOeFir8vLRd3+AboyJnces5bezqqK+347Vj+wGOI4pxyFk6pzzoSm39mHKDA2TWwgYZuA
RrIb0d1ggJzsXOwnmhiu++yOfotKA/+AWpCYK5Cy32J5VsVexUNkiTGoFcfQuuJA0dxMmMf3ejXT
vQF8dLo3A905P2zXxP1VOiNhlUvEDPSajeHRWNXtNukj7U/dR+Tkq85ODp8wLMIMrFKPJg7fyqPS
i3pa/7Y30UmfWKq32+TnzvOZP4WEhDnQLIAR13Lrr522lCrS7Re/bqcTDcFTSo8zHlpsnYS6Itkd
2YhTinc21tUE/JcN5cdUaxzkculP9daOhe+uOwua7tI9ZoRy6gvU+Bz0jTshor4Cv+/LHF/DnOAp
Y+zQNI5CubzGDxcaHDZVInEDEtHHY/E1blUQlTo+1KfUyZU9OiBFLtxaCKaLIBzNrTA8hC66+mmd
G7XDDOnF2V1SmzX6q4041E2Nbnj4YEICzRExV51GRUgYt2JZzAb9JMb6BH2rBO5/eW+tTcLF166u
Fak3C0tW6+1kBhFTzwrxDSUZuiT8BDz821s1iH6vUihrgiqq96iF9QMKmW3aSruXDaCCyJqjXsL9
Yi9VU3AzHC1xS6E6V991gl/KOf1eXX5Bl/HZ9C+G5Rttu0nFNVomEMMYzh3LD3RCdr+d/mBV2g5B
cx1nEMlidZUhs3VOvvkR6tJljrux48kDFJbNO4nEJIPLwEsz+z9T53DzxvcspGulWLH8E3697v+y
gcEC4UWjYmaDsXMfx+xXO0bH/9DjrpMY2UmRUds45CVuDdE8htCN7Wpg75uxinEqECtD69OXb0cu
GBtVDaj0VennfMYGLb0JDlz5nQ1j1vkHX94bmdveRXjKEoIj2FyG6t2pt4bd7u/Kkm5dE3akyYDG
RldhmVgbeUbcCsJlIGW9wR6laamXmF8sxSAVNJ6IrkJri5gSi/1FN3y2gYg2Dt07/1FKNfDE3UQt
CsgbNs5tuy7AIeQ64jr9KGV4G88ONTW6UGENV+lMO2188eNhvXG2mahBo0jXeUpQ8QGGtrUjn2O5
Mm/wS0tZ+OtbHObvfrNl2nENyBwQGV0H1II9I2wD1kwDQG7FPxk4gZ50tUZ0FcvdkkvvN1XINGzT
WHJI1Kmp+T9CsQ2ev7Pd6YPSNzZdGHwKe9Jb/IJBOlfuHy9jwYg/G5HCkgh9YHs2/YIWnIcK8lx2
L5Dc3FoDApRPbqpLivThxlafi0OjiD3B+KI9Jz4Wbuk6pZMxSagDzXK+47H7Kjmmr0fB5rSQoRGB
yVCYFa1Q986mDD0+Nn3hYpsM+I4cNTMCjhyUyJOnL7BfzKCxSpHlMYaot6jF/XLZCoFzcBT+D8U7
5WyRF+k4Lp4yIInH0GrsiYmOGPTS0zpNk1J5IeGOu2fsbzHwTH0M6Y90cTB01r3gmTZEvk1dSA2N
TQysXIGz6r8YppDZLUgPD0ECEt8Ii8oz+M2OSYYOYU/cHO4gAbWLhi/p9Us3J1YadUKPdDKH5g8M
FYIWkAuGg2X9Co3yTmwwxCEFGEWmWS1eNr0wlHNwviO8KeImCZsb5ErD7F0N+gvOrc058PrIr4Ct
jQRs1YLoBqv5TbnZq+n9byVlslZu6vPbtuAj4X1P+5zEoMsG9FDZBFxVWe6OOYvl+yvulST0QFXN
0jZbu3XWfzvqxE5IrGVPshzPS80IPSyo6cStBsgd22fgc7cg9pKjgM1ADVI4yJvwQtM0zFyjJB3W
4BTqEsDXUbEp8Q2kr1jOktyf9cUHxvSuEjmXWbD7DK+ViFHgkyzy3Ek28GBcJD+xeQRrilFPcJ1T
xwszpXvtRcS9yumJYJqvAmng+9y9LAvoi1zda0nuEbDyznFc+wBzcCX79noj3oqiBnbYck2k5SKW
4/t7kLN4Kix5DCK1T6phuFqupEdHR3on6xM9CtGVQiTqEXx4B9zuGz6ZrUDj0UB0sDoe0u2kjLv8
dkN4kPo7JR8p1TfnPALoWCAIi7BMaZTFNdUTaccPuoaBuiYVk9+YGtRvPXI5kqf30qy0BfYVNG/V
c46TvG7dq5Rh4aJ73Yp6wAQ83odImiOfc7pu4mEd2f2EqFkPpdDrpRwU6X7Dnq9ycq4vOS1n6QN2
orh0tOS/d/iSllqTDqB6DWFaAhgFjUuX2FEy8DoN/HoDr/2HhedYxw+wUlwVI71s0sKV2kCY+++E
AJABQ+UMPztE1S5l49jalWpuQ7iD13OcqToy4XONLMeUBaR1H5+ef9wz/FuRUemwqUl4b4H5DWbb
3UcW4zQ4Siv+zo+Oj7YIs32Um5Tpco5cXUulVXdXD6wXIyvwmEyR/bkNy1zuZhAzKEeWJdJ6Wy00
LCXxaOACgR5X9CRf0EzL0B9XlR1l+ex+TerQ/TUyyVfWxQhpUXCAU37h1rxLpX51WhUYZyhVTzQ3
So8BzlQBlAqU2G+blLtp+qBQPE5B1oOuN1BnPWxbU/I73G49c4fgS4NQ+T9XaWXumpmpiJbzwdZy
vrGrDQt7tKrRRmD+fQgycYWL48Pug/mQzzDk0fgpvNZzSbnushXvA3HbRla86FVoeauxpM3o3tfL
dqvtp2EwfinRBUl6Wl70Te8myYVSXAshDpY+7XYu0CUsUULNjoQfDM4JftDJZuEQNmva6/6Yeb6z
bsspmLE2FCNfOlKPaK2+gX669E85mV7R7eBltWdxszUcf2eDM5Gt4p+ncK7Gzcj24kIWWEN7RqC6
bGeotA9BWYiHt2ZHoaY1FVeyCMxJ6hW6gS205Jx2Gnc8IUhOsuXqZoSaqoTycDqsNrsVuk6WtXsE
ijTXTFCHlmwNoxGMQS2gP4oS2wiL18iv97SPuhaHyGO1RqQsz1JgMJcxgVGhmp9xsufCV3OfH0+T
POMQ9tkuAZrXTymoV9jxz52EyEXYInMMKNaMuHAoGhgfqKG+Vjq+iUpKWIagd6ms64d9sQMsAYzg
p9ByPCw2DEEHR4p8E5aB1Bcj9igh2Q4WZjgJozFPPhEFokQwqHuG1U6wRaWG+HpTT9FwOFQlrt3s
JR2NnvvKlryr+VtKCAqAtqyFZkMU4BkvL95T2CyhJmVBu3Ueg7nNxKDJwC4saw2G20A+CnmXJBtK
yKNKiwT+YUnM7ogp48jSg7EPwuvCwrng0HfN6BTRjlzxWIz/u8JvyS45AoJS8kXW9P3jU3i5NreK
PtvYxFrz/Uj5fL1H35kQHXcVQsjS/Gi440gNP3E+ShF5WgW39Vuji3FW94arzJwR70xPfm4KTUNd
QVmgnVZB+EX0UeTRDMOjg8kcJLKNQf27D9AP1CDAW14aABwowJp06oRA+ULTWqLxUPs/RIp7KeF3
Bv0jzISZruWnlkFGyZ4iL0oOAzc7N0MvF62QCtSU7NdFvYYQ6VU93wkUugvVyKZziqHijAJ16wA0
hEmlLuuEtzcCB54AbDwdsHp3a/titHRU4brmD5HpTSsh1fp7Ov5S4rIBtYZBXyEbVvReDZJiDnIe
t5QU0uym6KRK24DlBRlJmiFuI5tyZJ8/KY9pbXGLVDM9tcQwwdRHqWHxl6HQotYRXHX6xVr/XiCO
dvg4IGmVphNWsOpTHPnRupmDpSIZGSrdiFiX+7rLKIWlo7unIRd8FDdrGM60Xq7coXQhdUSg4MIr
pYQz0d/FCyF1UyU1Y2Ss8wVx0EniclW0DO2Brb5BG/Vj/HgaTBWL2QqI35RfKtcj/swwL0X1hCNc
Lck3OqvZWYwiSflzQtlHmimZj2wghdJCD0Y6Ib4ozr/FfjaAXyZljo255Enwx8fSmFPEQKeXD30y
m2tzutcKBc9GLGOjtiuKT5Wnus6/XBXUkNxLmFIPUx5+91w1jeVfiPfEjDH8IWl7tCLjSD0VI0fM
TOra+I7KdWeulNwH4bOYbC6xYGDz/OU09/ojRBtBbG2snYVjQgprMBrSMBUGhbf5leyseKEgWL3g
38yIkkOqel+JnMc+2VfAk5rWStx3Nbjxli/lmNlVwjxCeDEs1s5wkpM98o2NaEMzY7oZIMLlaDLp
PEwRQc4D+k6lVO8rfdUrhABSlLp19IQsG35v6CwCJLGjmuZDIljiqfA0ru9038o4ljbl9ou1wd6W
D5fggzBiDXsAreqerpwLudJ+EaLTuiSUCkCLNzrAifan5peqJH511IxnCBXVHItNYDR82aTmqxgp
vgZehCGo9v4zEx/Jx+6RhO18mchtHcK72qT6Cwt8s9K4yKS4E05m4h+dxATJZJswJ/lyOmHGHzRA
vJCVJIBSX/VICezmq4Hx1/dxJ1MudPjATqfxgWPAXz9HiaiQapYUUK01wFoGvGz74YVJTG8ASkcQ
+Ljed+qns+jC213oniACaQfOIwxiGyJSWCZPvTy/1dX7hQm/Hi/VUBjRjQNvxefR+5xv08ru/m0j
QS/ub8vYACRjD2Ab0bVXIbgp7ubLpvITTDQjDhU2mmIhZUH54bWa8LolFEthL3RUaHAkVUic2RV+
KBgEFyBx9gX22+qe2SoHc8sDo04pWz2mlyhHrPCOgL5AFNs+S15LaYHFCvYP83Lzb+w8SYNOzAWr
AEeM0KhqZoJ8z/YEVZwozU7WocCydb8zBZuLaVLzONK2n1/kluqH3aq65osnGuCAZAh4t6R1pWV0
AsFIsQwoSeK0BOMkzMRrTLwK3yu+x16nW8ZyyV3LWF7vz5UwyajiGjCarkM5awtdjxeA98DzO3Dr
qC9RKRiB5rf5CjDk9H3ehAgM/ujcdp9eD3dfo5btPFwScDpL7mj2rTFlu2ISoj6ommtIXFfe8SE6
QDqQWpz5bid0XppxDZC40pb1J7mEIul4DOEmToyKC4erR6glLMAr25Zc599XKfaw6eMQNSB1ANV1
RvFCmMHeNqy6XvNQMpmAGX2WXzvllgM925TnJzlHGVcREzV0o+m2YGCTf0jWTROuwdVkoLsXdsb0
L0Aw678JQhLAFM6dzcLLq+qAhpK57p4Z0vAWg0diAdgerzCuIxHi7A62s67c0BvuPmonWB5bAVVu
ae47j+PsSjnzeBPbpynw5dw410O61hICBjLpeOc0j/lgvouLOppAsTJ4M4wvSQ7gcr8xb1NKfek9
3TAYRnw77nvbw9ABQ7Cq2J/iuVrrzNrpiGF72zGaUe1u5scPXSAlkfi8sp2GzBZL7vlq8RfglCBX
2bCnVq3ipyvuIqcD66wFNCoNAt4YUH2ry0YIJxXT5cGShjvZe6z2kkmWZSJ0XJYJpmgm8bm1Xa5O
xSqmc2StDr7YxJu7c6euvSZGNuiioTdnvdEcJLcnY6ITMQcX9dNCDtRSbwSYK6b88e0aPvNDuMeM
vlD5TREAOWGdFwQ82kynRoKAe9co2niDnWPl+TveyXgIu6qARJaogKwDhbpaDzFOLXHKyuhmBUp2
ueh068iYLInaxoz6aW4aB6HCsgGD2Wk4u/7gbscw8H29h0h4lf3ymGS9wkOWbOqTJ6zcftQ29eCW
XTX6kBKWSCkglHQL3bKPmDVCu07K94CK4H9e8F/mQWf+O4ALjsjW6OvvYD45hsgr2PZS1ePgvPxf
hObNEhDXJe0ZxVrUmNx1jIXSGcebtIIH7sFzXkQSpOjwTiMmUI86N1EUZawaqzhsRUpl4F/Uxgc2
QBCUnsIQlDXFWVl1wVrnI6oG3XDtRSrHmBh+enA2AQqiQq/ijk2Ax62lyaTZFoBByYoUGeBl71wT
CjaqO4tKsDPWz7Z5OdCQzTl5CQOQXC3mlpnWK50RkIJJZcivOmbw4XkdETbYFHas6PvHKajkbdbl
7POOhXNqZ8Yg7YRoLwDtPRGz3a6b8+nQ4oeaJfN4MzN20PYHfDyD+5zEUfnYobdcxeARZQPKaDJZ
EtOklfGgxBzAebD5ISNLiYPKxRqvemWQAQo//HHPbWJBWDRPrhR+Uew0EKVzO5QXzg2r+8O2Bbyq
IExYkN5kB+/RVXLUzPbqg72omXLoNkXqg5EedScV5QdZPY4mVsm1GoMgS9eqUqJLtSE3GaknqwUe
n+wXi/K0zOQsGPU5WhBlToxyJEqeDdI9m4w0SAJCzujIeYe09Oj7p7OteXSTCWtZC2J5/cGl9k9t
eUXvnhHtWAbvguM/PmXi07nLZAwSzRJPtSaErvp/vbm66onSVbHCVowf+YdtW+6FmouUhZLurpzI
yfd8CiZ/1qkflhWbm4XaobUISm4E2sdjHPtQAQKRTYNtB8yPhLt2cYjeCJBLWJtpZ5wXVrRNWW0N
mRnN745OCHSIeVchdwI7xnYd2GORX9qq2ChoLuqKK3aOU3RunPPD+1pY6fEv0E0DgKUR5tsH1FMK
jk/fYR1Lv81W6GN3MM3ibuJX3S7xj16wnsIk/R+rgyO/UICC5UiXat3Y7Y/toJDsnHYHhF0aLFpw
fP3Jylp5mOSNN/hzEUycUTF0ZQP16P4WrxkbJRBkprkED26i4XTb2tXyfUCNdsVFSBsIBpph8sfn
ttz8qEwXqAMapoaEUha1aLRBR/C+k4tLD8dMOEQp2rTZWZAMTd0lxo4huNcnVMNRANVahbXTdTAC
2tHIxD4/yDt3+LMiVlUMM5lVEFQ65bSe1YKj1BQaeAQlC82md+314FxtETTjsYC+otRG+UbVk/i1
wJwvcGxX4QcI1UawmAfVTXlBIFw5aoHYj1HX0+qLeL8AbjJ7WgWmIC5bUCUaNnjQfdbC5sMp2lNq
R3Kt0Miqrc1+qVJZmVUeaTjsPXGUjNQDTi708lwaf6vjEekZCzoboRF4m2uThNpHWPKUgbEp+RJI
7ZZI+r1TpFu+N0FwIDwH2cUHxVdGTDVa99IuXlS7jJSNV9bewA44NGOM7VgnwufW31316b7iFEro
j0+XkfEpE0mycfis+6pO+i1m3HuNU9XO4rzo1HCyR8tUMtzkJqpVlGi5GjfWj1WrA6nhmwMkfmHS
P3sXbSIrO9QuzDQTurV/O/dHodzC3b53RQY2i66mcy235qyTkClsaDCIBR64qSJ5mkebCTlMmSpr
PAkD3izDEKzwvWpIcq9690P+5zxMkX/ekoZ9kPmhiN1uW6QaEvgvxz4sAr8A5d6OFkDsV33A4jf0
FhnP+j3kIz0Ety3eUmkmtnJOjwWaJm7JYoyX3/x7gq74m3a1N3+kK8FGQR2Qms0vwoPUNA72vWJa
eiKVgKaQmM+Cva9AFyAZqpiVjiKgWi/oZy3uvwGK7s+gkgWSU1Uuz5H9Mvwl0i26X0C1hk6OTGlF
TZJKruWiqUTd9XI4reUw+nQjGeZAH9hK2pB1Rgrqzid6QGuc3BCt/D+0axRkwfZDtSkuCvo0QLsR
5i7SNrqpxxaiLHJIEghFIxWHKcHpnBxP6c2YQwdP9dRJ3Icw372ftEEhP2lngVXbGoaLG2fN+/21
sd6mBPpj42of4UkYQ3H7NjVTh9LssCF1qWnwMFhx5emzmjUqJSx22UOqGCnYnnvzX9MC1khnRDJH
ws4iE/H5JEEPyv+iS2sOAVA2ZkkQ3F4VQK2apXBmp2Z5JFVGILkPezxCCFCKwmwtvcDZg8DqhGqg
3bzjeW510o+aVpwz1Wg+D4kR0fGXjOKrLCQiv9/6
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
