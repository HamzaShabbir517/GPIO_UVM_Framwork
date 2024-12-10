// Declare RAL Mix Sequence
class ral_mix_sequence extends ral_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(ral_mix_sequence)
	
	// Declaration of Reference Data
	uvm_reg_data_t ref_data;
	
	// New Constructor
	function new(string name = "ral_mix_sequence");
		super.new(name);
	endfunction
	
	// Body Task
	task body();
		super.body();
		
		// First Sequence
		// Set the output enable half as input and half as output
		gpio_ral_model.gpio_output_en_reg.set(32'h0000_FFFF);
		// Update the Register
	gpio_ral_model.gpio_output_en_reg.update(status,.path(UVM_FRONTDOOR),.parent(this));
		// Get the data
		data = gpio_ral_model.gpio_output_en_reg.get();
		
		// Second Sequence
		// Read the reset value and compare it
		ref_data = gpio_ral_model.gpio_interrupt_en_reg.get_reset();
		// Read the actual value
		gpio_ral_model.gpio_interrupt_en_reg.read(status,data,.parent(this));
		// Compare them
		if(ref_data != data) begin
			`uvm_error("RAL MIX SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", gpio_ral_model.gpio_interrupt_en_reg.get_name(), ref_data, data))
		end
		// Third Sequence
		// Use backdoor access
		gpio_ral_model.gpio_input_reg.poke(status, 32'hFFFF_EEEE, .parent(this));
		// Get the Desire value
		ref_data = gpio_ral_model.gpio_input_reg.get();
		// Read the actual value
		gpio_ral_model.gpio_input_reg.peek(status, data, .parent(this));
		// Compare them
		if(ref_data[31:0] != data[31:0]) begin
			`uvm_error("RAL MIX SEQ:", $sformatf("poke/peek: Read error for %s: Expected: %0h Actual: %0h", gpio_ral_model.gpio_input_reg.get_name(), ref_data, data))
		end

	endtask
endclass
