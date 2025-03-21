vlog DSP48A1.v 
vlog Multiplier.v 
vlog MUX2x1.v 
vlog MUX4x1.v
vlog REG_MUX.v
vlog Adder_Subtractor.v
vlog BUF.v
vlog DSP48A1_tb.sv 
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
# quit -sim