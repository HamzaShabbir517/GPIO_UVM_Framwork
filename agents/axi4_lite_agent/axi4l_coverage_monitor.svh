// Include Defines
`include "axi4l_defines.svh"

// Declaration of Coverage Monitor Class
class axi4l_coverage_monitor extends uvm_subscriber #(axi4l_sequence_item #(`data_width,`addr_width));

	// Register is with factory
	`uvm_component_utils(axi4l_coverage_monitor)
	
	// Declaration of Covergroups
	covergroup axi4l_cov;
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
		
		Response: coverpoint trans.resp {
			bins ok = {2'b00};
			bins err = {2'b01, 2'b10, 2'b11};
		}
		
		cross Write, Response;
		cross Read,  Response;
	endgroup
	
	// Declaration of seq Item
	axi4l_sequence_item #(`data_width,`addr_width) trans;
	
	// New Constructor
	function new(string name = "axi4l_coverage_monitor", uvm_component parent = null);
		super.new(name,parent);
		
		// Create the cover group as well
		axi4l_cov = new();
	endfunction
	
	// Write Function
	function void write(axi4l_sequence_item #(`data_width,`addr_width) t);
		trans = t;
		axi4l_cov.sample();
	endfunction
	
	
endclass
