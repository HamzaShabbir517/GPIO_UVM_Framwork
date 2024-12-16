// Include Defines
`include "apb_defines.svh"

// Declaration of AXI4 Lite Monitor 
class apb_monitor #(int PADDR_SIZE = 32, int PDATA_SIZE = 32) extends uvm_monitor;
	
	// Register it with factory
	`uvm_component_param_utils(apb_monitor #(`PADDR_SIZE,`PDATA_SIZE))
	
	// APB Agent Config
	apb_agent_config apb_cfg;
	
	// Declaration of Virtual Interface
	virtual interface apb_interface #(`PADDR_SIZE,`PDATA_SIZE) vif;
	
	// Declaration of Analysis ports
	uvm_analysis_port #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)) apb_m_ap;
	
	// New Constructor
	function new(string name = "apb_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the APB agent config from database using macro
		`get_config(apb_agent_config,apb_cfg,"apb_agent_config")
		
		// Build the analysis port
		apb_m_ap = new("apb_m_ap", this);
		
	endfunction
	
	// Run Phase
	task run_phase(uvm_phase phase);
		// Wait for reset to complete
		@(negedge vif.rst);
		
        	forever begin
            		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) apb_item, apb_item_clone;
            		
            		apb_item = apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)::type_id::create("apb_item", this);
            		
            		// Wait for posedge clk
			@(posedge vif.clk);
			// Check if the transaction is initiated and completed
			if (vif.PREADY && vif.PSEL && vif.PENABLE) begin
				apb_item.addr = vif.PADDR;
				apb_item.write = vif.PWRITE;
				apb_item.wstrb = vif.PSTRB;
				apb_item.error = vif.PSLVERR;
				if (vif.PWRITE) begin
					apb_item.data = vif.PWDATA;
				end
				else begin
					apb_item.data = vif.PRDATA;
				end
				// Create a copy of the transaction object using clone()
				$cast(apb_item_clone, apb_item.clone());
				// Write transaction complete, send via analysis port
				apb_m_ap.write(apb_item_clone);
			end
        	end
    	endtask
endclass
