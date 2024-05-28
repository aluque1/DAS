#####################################################################
##
##  Fichero:
##    lab4.xdc  12/09/2023
##
##    (c) J.M. Mendias
##    Diseño Automático de Sistemas
##    Facultad de Informática. Universidad Complutense de Madrid
##
##  Propósito:
##    Configuración del laboratorio 4
##
##  Notas de diseño:
##
#####################################################################

#
# Voltaje del interfaz de configuración de la FPGA
#
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#
# Reloj del sistema: 100 MHz
#
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sysClk -waveform {0.000 5.000} [get_ports clk]

#
# Pines conectados a los pulsadores
#
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports rst]

#
# Pines conectados al USB HID (PS/2)
#
set_property PACKAGE_PIN C17 [get_ports ps2Clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2Clk]
set_property PULLUP true [get_ports ps2Clk]
set_property PACKAGE_PIN B17 [get_ports ps2Data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2Data]
set_property PULLUP true [get_ports ps2Data]

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

#
# Pines conectados al display 7 segmentos
#
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {segs_n[6]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {segs_n[5]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {segs_n[4]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {segs_n[3]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {segs_n[2]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {segs_n[1]}]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {segs_n[0]}]
set_property -dict {PACKAGE_PIN V7 IOSTANDARD LVCMOS33} [get_ports {segs_n[7]}]

set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {an_n[0]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {an_n[1]}]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {an_n[2]}]
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {an_n[3]}]