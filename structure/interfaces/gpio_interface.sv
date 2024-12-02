// GPIO Interface Class
interface gpio_interface #(int GPIO_PINS) ();

	// Port List
	logic [GPIO_PINS-1:0] gpio_in;
	logic [GPIO_PINS-1:0] gpio_out; 
	logic [GPIO_PINS-1:0] gpio_oe;
	logic intr;
	
endinterface
