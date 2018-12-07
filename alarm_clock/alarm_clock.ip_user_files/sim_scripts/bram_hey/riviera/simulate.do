onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+bram_hey -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.bram_hey xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {bram_hey.udo}

run -all

endsim

quit -force
