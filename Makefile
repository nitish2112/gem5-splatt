CLOCK=--sys-clock='2GHz'
MEM_TYPE=--mem-type=HBM_1000_4H_1x128 --mem-channels=8 --mem-size='64GB'

build-gem5:
	scons build/X86/gem5.opt -j64 2>&1 | tee build.log

run-splatt-mttkrp:
	time ./build/X86/gem5.opt --verbose ./configs/example/se.py -c splatt/mttkrp/mttkrp.x86 $(MEM_TYPE) --cpu-type=DerivO3CPU --caches --l2cache $(CLOCK) 2>&1 | tee trace.log
	grep -r "system.cpu.numCycles" m5out/stats.txt 2>&1 | tee -a trace.log
