transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/Siriy/Desktop/07.10.19/RGB(TEST)/Working_with_memory.vhd}
vcom -2008 -work work {C:/Users/Siriy/Desktop/07.10.19/RGB(TEST)/WRITE_TO_FILE.vhd}
vcom -2008 -work work {C:/Users/Siriy/Desktop/07.10.19/RGB(TEST)/IMAGE_SENSOR_SIM (2).vhd}
vcom -2008 -work work {C:/Users/Siriy/Desktop/07.10.19/RGB(TEST)/count_n_modul.vhd}

vcom -2008 -work work {C:/Users/Siriy/Desktop/07.10.19/RGB(TEST)/simulation/modelsim/IMAGE_SENSOR_SIM.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  IMAGE_SENSOR_SIM_vhd_tst

add wave *
view structure
view signals
run -all
