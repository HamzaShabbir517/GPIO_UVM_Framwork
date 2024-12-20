module hdl_top;

	// Include defines
	`include "apb_defines.svh"
	`include "gpio_defines.svh"

	// Declaration of clock signal
	bit clk;
	bit rst;
	
	// Declaration of interfaces
	apb_interface #(`PADDR_SIZE, `PDATA_SIZE) apb_if (.clk(clk), .rst(~rst));
	gpio_interface #(`NUM_PINS) gpio_if (.clk(clk), .rst(rst));
	
	// Declaration of APB Interface Design 
	apb_gpio apb_dut (
    			.PCLK(clk),
    			.PRESETn(~rst),
    			// APB Interface
    			.PSEL(apb_if.PSEL),
    			.PENABLE(apb_if.PENABLE),
    			.PADDR(apb_if.PADDR),
    			.PWRITE(apb_if.PWRITE),
    			.PSTRB(apb_if.PSTRB),
    			.PWDATA(apb_if.PWDATA),
    			.PRDATA(apb_if.PRDATA),
    			.PREADY(apb_if.PREADY),
    			.PSLVERR(apb_if.PSLVERR),
    			// GPIO Interface
    			.gpio_i(gpio_if.gpio_in),              
    			.gpio_o(gpio_if.gpio_out),             
    			.gpio_oe(gpio_if.gpio_oe),   
    			.irq_o(gpio_if.intr)              
		      );
		      
	// Reset and Clock Generation 
	initial begin
		clk = 0;
		forever #10ns clk = ~clk;
	end
	
	initial begin 
		rst = 1;
		repeat(10) @(posedge clk);
		rst = 0;
	end
	
	// Initial Block
	initial begin
		import uvm_pkg::uvm_config_db;
		
		// Set the APB Virtual interface into Config DB
		uvm_config_db #(virtual apb_interface #(`PADDR_SIZE,`PDATA_SIZE))::set(null,"uvm_test_top", "apb_vif", apb_if);
		
		// Set the GPIO interface into Config DB
		uvm_config_db #(virtual gpio_interface #(`NUM_PINS))::set(null,"uvm_test_top","gpio_vif",gpio_if);
		 
	end

endmodule
