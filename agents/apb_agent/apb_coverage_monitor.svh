// Include Defines
`include "apb_defines.svh"

// Declaration of Coverage Monitor Class
class apb_coverage_monitor extends uvm_subscriber #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE));
	
	// Declaration of Covergroups
	covergroup apb_cov;
		// Declaration of Read Write Coverpoint
		Write: coverpoint trans.write {
			bins write = {1};
		}
		
		Read: coverpoint trans.write {
			bins read = {0};
		}
	
		// Declaration of Address Coverpoint
		Address: coverpoint trans.addr {
			bins addr_range[] = {[0:255]};
		}
		
		cross Write, Address;
		cross Read,  Address;
		
		Write_strb: coverpoint trans.wstrb {
			bins full_strobes[] = {4'b0001, 4'b0011, 4'b1111};
		}
		
		cross Write, Write_strb;
		
		Response: coverpoint trans.error {
			bins ok = {1'b0};
			bins err = {1'b1};
		}
		
		cross Write, Response;
		cross Read,  Response;
	endgroup
	
	// Declaration of seq Item
	apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) trans;
	
	// New Constructor
	function new(string name = "apb_coverage_monitor", uvm_component parent = null);
		super.new(name,parent);
		
		// Create the cover group as well
		apb_cov = new();
	endfunction
	
	// Write Function
	function void write(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) t);
		trans = t;
		apb_cov.sample();
	endfunction
	
endclass