#####################################################################
##
##  Fichero:
##    lab6.xdc  12/09/2023
##
##    (c) J.M. Mendias
##    Dise�o Autom�tico de Sistemas
##    Facultad de Inform�tica. Universidad Complutense de Madrid
##
##  Prop�sito:
##    Configuraci�n del laboratorio 6: Pong
##
##  Notas de dise�o:
##
#####################################################################

#
# Voltaje del interfaz de configuraci�n de la FPGA
#
set_property CFGBVS VCCO [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];

#
# Reloj del sistema: 100 MHz
#
set_property -dict { PACKAGE_PIN W5 IOSTANDARD LVCMOS33 } [get_ports clk];
create_clock -name sysClk -period 10.0 -waveform {0 5} [get_ports clk];

#
# Pines conectados a los pulsadores
#
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports rst];    # btnU

#
# Pines conectados al PMOD JB (Audio Códec ISS)
#
set_property -dict { PACKAGE_PIN A14 IOSTANDARD LVCMOS33 } [get_ports mclkAD];    # JB1
set_property -dict { PACKAGE_PIN A16 IOSTANDARD LVCMOS33 } [get_ports lrckAD];    # JB2
set_property -dict { PACKAGE_PIN B15 IOSTANDARD LVCMOS33 } [get_ports sclkAD];    # JB3
set_property -dict { PACKAGE_PIN B16 IOSTANDARD LVCMOS33 } [get_ports sdti];      # JB4
set_property -dict { PACKAGE_PIN A15 IOSTANDARD LVCMOS33 } [get_ports mclkDA];    # JB7
set_property -dict { PACKAGE_PIN A17 IOSTANDARD LVCMOS33 } [get_ports lrckDA];    # JB8
set_property -dict { PACKAGE_PIN C15 IOSTANDARD LVCMOS33 } [get_ports sclkDA];    # JB9
set_property -dict { PACKAGE_PIN C16 IOSTANDARD LVCMOS33 } [get_ports sdto];      # JB10
