all: simulate

NPROC = $$((`nproc`-1))

#VERILATOR := verilator
VERILATOR := /tools/verilator_v5.030/bin/verilator

UVM_ROOT := /home/hshabbir/uvm_learning/uvm-verilator

SIM_DIR := learn_sim
TOP_NAME := uvm
BIN_NAME := uvm_test
UVM_TEST := gpio_test
UVM_FILES := -I$(UVM_ROOT)/src $(UVM_ROOT)/src/uvm_pkg.sv
SRC_FILES := -f compile_sv.f 
DEFINES := -DUVM_ENABLE_DEPRECATED_API -DUVM_NO_DPI
WARNINGS = -Wno-lint -Wno-TIMESCALEMOD -Wno-SYMRSVDWORD -Wno-RANDC -Wno-CONSTRAINTIGN
OTHER_FLAGS := --bbox-sys --timescale-override 1ns/1ps --assert
TEMPFILE := $(shell mktemp)

$(SIM_DIR)/$(BIN_NAME):
		$(VERILATOR) --binary $(UVM_FILES) $(SRC_FILES) $(DEFINES) $(WARNINGS) $(OTHER_FLAGS) \
		-Mdir $(SIM_DIR) --prefix $(TOP_NAME) -o $(BIN_NAME)

simulate: $(SIM_DIR)/$(BIN_NAME)
	$(SIM_DIR)/$(BIN_NAME) +UVM_TESTNAME=$(UVM_TEST) | tee $(TEMPFILE)

clean:
	rm -rf $(SIM_DIR)

.PHONY: simulate clean
