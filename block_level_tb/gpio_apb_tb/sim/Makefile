all: work uvm rtl build tb opt sim

QUESTA_HOME := /home/hshabbir/Questa/questasim
BLOCK_TB  ?= ../../../block_level_tb
RTL       ?= ../../../rtl
AGENTS    ?= ../../../agents
UTILS     ?= ../../../utils
INCLUDES  ?= ../../../includes
TEST      ?= gpio_base_test
UVM_HOME  := $(QUESTA_HOME)/verilog_src/uvm-1.2

work:
	vlib work
	
uvm:
	vlog +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv -ccflags -DQUESTA \
		-ccflags -Wno-maybe-uninitialized \
		-ccflags -Wno-missing-declarations \
		-ccflags -Wno-return-type \
		${UVM_HOME}/src/dpi/uvm_dpi.cc \
		
rtl:
	vlog +incdir+$(RTL) $(RTL)/*.v
	vlog +incdir+$(RTL) $(RTL)/*.sv
	
build:
	vlog +incdir+$(UVM_HOME)/src +incdir+$(AGENTS)/gpio_agent +incdir+$(UTILS) +incdir+$(INCLUDES) $(AGENTS)/gpio_agent/gpio_agent_pkg.sv -suppress 2263
	vlog +incdir+$(UVM_HOME)/src +incdir+$(AGENTS)/apb_agent +incdir+$(UTILS) +incdir+$(INCLUDES) $(AGENTS)/apb_agent/apb_agent_pkg.sv -suppress 2263
	vlog +incdir+$(UVM_HOME)/src $(AGENTS)/gpio_agent/gpio_interface.sv -suppress 2263
	vlog +incdir+$(UVM_HOME)/src $(AGENTS)/apb_agent/apb_interface.sv -suppress 2263
	vlog +incdir+$(UVM_HOME)/src +incdir+$(BLOCK_TB)/gpio_apb_tb/register_model $(BLOCK_TB)/gpio_apb_tb/register_model/gpio_apb_reg_pkg.sv
	vlog +incdir+$(UVM_HOME)/src +incdir+$(BLOCK_TB)/gpio_apb_tb/environment +incdir+$(INCLUDES) $(BLOCK_TB)/gpio_apb_tb/environment/gpio_apb_env_pkg.sv -suppress 2263
	vlog +incdir+$(UVM_HOME)/src +incdir+$(BLOCK_TB)/gpio_apb_tb/sequences +incdir+$(INCLUDES) $(BLOCK_TB)/gpio_apb_tb/sequences/gpio_bus_sequence_lib_pkg.sv
	vlog +incdir+$(UVM_HOME)/src +incdir+$(BLOCK_TB)/gpio_apb_tb/sequences +incdir+$(INCLUDES) $(BLOCK_TB)/gpio_apb_tb/sequences/gpio_virtual_sequence_lib_pkg.sv
	vlog +incdir+$(UVM_HOME)/src +incdir+$(BLOCK_TB)/gpio_apb_tb/test +incdir+$(INCLUDES) $(BLOCK_TB)/gpio_apb_tb/test/gpio_test_lib_pkg.sv -suppress 2263
	
tb:
	vlog +incdir+$(INCLUDES) ../tb/hvl_top.sv
	vlog +incdir+$(INCLUDES) ../tb/hdl_top.sv
	
opt:
	vopt hdl_top hvl_top -o opt -debug -designfile design.bin
	
sim:
	vsim -gui opt -do "run -all; coverage save -onexit coverage.dat;" +UVM_TESTNAME="$(TEST)"
	
clean:
	@rm -rf work transcript
	
	

