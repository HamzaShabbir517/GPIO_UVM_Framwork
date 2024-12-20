// Import UVM Packages
import uvm_pkg::*;

// Import GPIO Packages
import gpio_pkg::*;

// Include defines
`include "axi4l_defines.svh"
`include "apb_defines.svh"
`include "gpio_defines.svh"

module top;

	// Declaration of clock signal
	bit clk;
	bit rst;
	
	// Declaration of interfaces
	axi4l_interface #(`addr_width,`data_width) axi4l_if (.clk(clk), .rst(rst));
	apb_interface #(`PADDR_SIZE, `PDATA_SIZE) apb_if (.clk(clk), .rst(~rst));
	gpio_interface #(`NUM_PINS) gpio_if (.clk(clk), .rst(rst));
	
	// Declaration of AXI4 Lite Interface Design
	axi_gpio axi_dut (
    			.clk(clk),
    			.rst(rst),
    			// AXI4-Lite Interface
    			.awaddr(axi4l_if.AWADDR),
    			.awvalid(axi4l_if.AWVALID),
    			.awready(axi4l_if.AWREADY),
    			.wdata(axi4l_if.WDATA),
    			.wstrb(axi4l_if.WSTRB),
    			.wvalid(axi4l_if.WVALID),
    			.wready(axi4l_if.WREADY),
    			.bresp(axi4l_if.BRESP),
    			.bvalid(axi4l_if.BVALID),
    			.bready(axi4l_if.BREADY),
    			.araddr(axi4l_if.ARADDR),
    			.arvalid(axi4l_if.ARVALID),
    			.arready(axi4l_if.ARREADY),
    			.rdata(axi4l_if.RDATA),
    			.rresp(axi4l_if.RRESP),
    			.rvalid(axi4l_if.RVALID),
    			.rready(axi4l_if.RREADY),
    			// GPIO Interface
    			.gpio_in(gpio_if.gpio_in),              
    			.gpio_out(gpio_if.gpio_out),             
    			.gpio_output_enable(gpio_if.gpio_oe),   
    			.irq(gpio_if.intr)              
		      );
		      
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
		rst = 1;
		repeat(8) begin
			#10ns clk = ~clk;
		end
		rst = 0;
		forever begin
			#10ns clk = ~clk;
		end
	end
	
	// Initial Block
	initial begin
		
		// Set the AXI4 Lite Virtual interface into Config DB
		uvm_config_db #(virtual axi4l_interface #(`addr_width,`data_width))::set(null,"*", "axi4l_vif", axi4l_if);
		
		// Set the APB Virtual interface into Config DB
		uvm_config_db #(virtual apb_interface #(`PADDR_SIZE,`PDATA_SIZE))::set(null,"*", "apb_vif", apb_if);
		
		// Set the GPIO interface into Config DB
		uvm_config_db #(virtual gpio_interface #(`NUM_PINS))::set(null,"*","gpio_vif",gpio_if);
		
		// Run the UVM Test
		run_test();  
	end

endmodule
