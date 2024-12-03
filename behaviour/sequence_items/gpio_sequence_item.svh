// Declaration of GPIO Sequence Item
class gpio_sequence_item #(int NUM_PINS = 8) extends uvm_sequence_item;
		
	// Register it with factory
	`uvm_object_param_utils(gpio_sequence_item)
	
	// Declare request Variables
	rand logic [NUM_PINS-1:0] data_in;
	rand bit is_read; // If 0 so it will write if 1 it will read
	
	// Declare response varibales
	logic [NUM_PINS-1:0] data_out
	
	// New Constructor
	function new(string name = "gpio_sequence_item");
		super.new(name);
	endfunction
	
	// Convert2string Function
	virtual function string convert2string();
		return $sformatf("GPIO : data_in=0x%8h \t read_or_write=%1b \t data_out=0x%8h",data_in, is_read, data_out);
	endfunction
	
	// Do copy function
	function void do_copy(uvm_object rhs);
		// Handle of sequence item
		gpio_sequence_item #(NUM_PINS) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return;
		end
		
		// Call super do copy function
		super.do_copy(rhs);
		data_in = RHS.data_in;
		is_read = RHS.is_read;
		data_out = RHS.data_out;
	endfunction
	
	// Do compare function
	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		// Handle of sequence item
		gpio_sequence_item #(NUM_PINS) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return 0;
		end
		
		// Call the super do_compare and also compare the other variables
		return ((super.do_compare(rhs,comparer)) && (data_in  == RHS.data_in) 
							 && (is_read  == RHS.is_read)
							 && (data_out == RHS.data_out));
	endfunction
endclass
