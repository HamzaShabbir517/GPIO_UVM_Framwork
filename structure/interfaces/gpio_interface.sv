// GPIO Interface Class
interface gpio_interface #(int NUM_PINS) ();

	// Port List
	logic [NUM_PINS-1:0] gpio_in;
	logic [NUM_PINS-1:0] gpio_out; 
	logic [NUM_PINS-1:0] gpio_oe;
	logic intr;
	
endinterface
