// Include defines
`include "apb_defines.svh"

// Declaration of APBs Driver
class apb_driver #(int PADDR_SIZE = 32, int PDATA_SIZE = 32) extends uvm_driver #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE));

	// Register it with factory
	`uvm_component_param_utils(apb_driver #(`PADDR_SIZE,`PDATA_SIZE))
	
	// APB Agent Config
	apb_agent_config apb_cfg;
	
	// Declaration of Virtual Interface
	virtual interface apb_interface #(`PADDR_SIZE,`PDATA_SIZE) vif;
	
	// New Constructor
	function new(string name = "apb_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the config object from database using macro
		`get_config(apb_agent_config,apb_cfg,"apb_agent_config")
	endfunction
	
	// Run Task
	task run_phase(uvm_phase phase);
		// Declaration of Sequence item
		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) apb_seq;
		bit in_range;
		@(negedge vif.rst);
		forever begin
			apb_seq = apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)::type_id::create("apb_seq",this);
			// Call the Clear Signals 
			clear_sigs();
			// Get the next item
			seq_item_port.get_next_item(apb_seq);
			// Print the data
			`uvm_info("APB Driver Run Task %s",apb_seq.convert2string(),UVM_MEDIUM)
			in_range = addr_lookup(apb_seq.addr);
			if(in_range) begin
				// Drive the sequence to ports
				drive(apb_seq);
			end
			else begin
				`uvm_error("APB RUN", $sformatf("Access to addr %0h out of APB address range", apb_seq.addr))
			end
			// Item is done
			seq_item_port.item_done();
		end 
	endtask
	
	function bit addr_lookup(logic [`PADDR_SIZE-1:0] address);
		if((address >= apb_cfg.start_address) && (address <= (apb_cfg.start_address + apb_cfg.range))) begin
			return 1;
		end
		else begin
			return 0;
		end
	endfunction
	
	function clear_sigs();
		vif.PSEL <= 0;
		vif.PENABLE <= 0;
  		vif.PADDR <= 0;
  		vif.PWRITE <= 0;
	endfunction
	
	task drive(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) apb_item);
		
		int unsigned cycle_count;
		
		// Wait for posedge of clk
		@(posedge vif.clk);
		
		// check if it write transaction
		if(apb_item.write) begin
			// Assert the PSEL signal along with other signals
			vif.PSEL <= 1;
			vif.PADDR <= apb_item.addr;
			vif.PWRITE <= apb_item.write;
			vif.PSTRB <= apb_item.wstrb;
			vif.PWDATA <= apb_item.data;
			// Wait for posedge clk
			@(posedge vif.clk);
			// Assert the PENABLE signal
			vif.PENABLE <= 1;
			// Wait for PREADY with timeout
			cycle_count = 0;
    			while (!vif.PREADY && cycle_count < apb_cfg.timeout_cycles) begin
    				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == apb_cfg.timeout_cycles) begin
      				`uvm_error("APB_WRITE_TIMEOUT", "PREADY not asserted within timeout")
      				apb_item.error = 1;
      				return;
    			end
    			// Get the slave error
    			apb_item.error = vif.PSLVERR;
    			// Wait for posedge clk
			@(posedge vif.clk);
		end
		else begin
			// Assert the PSEL signal along with other signals
			vif.PSEL <= 1;
			vif.PADDR <= apb_item.addr;
			vif.PWRITE <= apb_item.write;
			vif.PSTRB <= 0;
			vif.PWDATA <= 0;
			// Wait for posedge clk
			@(posedge vif.clk);
			// Assert the PENABLE signal
			vif.PENABLE <= 1;
			// Wait for PREADY with timeout
			cycle_count = 0;
    			while (!vif.PREADY && cycle_count < apb_cfg.timeout_cycles) begin
    				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == apb_cfg.timeout_cycles) begin
      				`uvm_error("APB_WRITE_TIMEOUT", "PREADY not asserted within timeout")
      				apb_item.error = 1;
      				return;
    			end
    			// Get the data and slave error
    			apb_item.data = vif.PRDATA;
    			apb_item.error = vif.PSLVERR;
    			// Wait for posedge clk
			@(posedge vif.clk);
		end
	endtask
	
endclass
