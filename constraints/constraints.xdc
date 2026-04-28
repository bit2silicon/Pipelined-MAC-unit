#create_clock -period 5 [get_ports clk]

set_property PACKAGE_PIN H9 [get_ports clk_p]
set_property PACKAGE_PIN G9 [get_ports clk_n]
set_property IOSTANDARD LVDS [get_ports {clk_p, clk_n}]


#set_property IOSTANDARD LVCMOS15 [get_ports clk_n]

create_clock -name sysclk -period 5.0 [get_ports clk_p]

set_property PACKAGE_PIN AK25 [get_ports valid_in]   
set_property PACKAGE_PIN K15 [get_ports clear]
set_property PACKAGE_PIN R27 [get_ports rst_n]
set_property IOSTANDARD LVCMOS25 [get_ports valid_in]
set_property IOSTANDARD LVCMOS15 [get_ports clear]
set_property IOSTANDARD LVCMOS25 [get_ports rst_n]