// Import UVM Packages
import uvm_pkg::*;

// Import GPIO Packages
import gpio_pkg::*;

module top();

	// Parameters
	parameter data_width = 32;
	parameter addr_width = 32;
	parameter num_pins = 32;

	// Declaration of clock signal
	bit clk;
	bit rst;
	
	// Declaration of interfaces
	axi4l_interface #(addr_width,data_width) axi4l_if (clk, rst);
	gpio_interface #(num_pins) gpio_if (clk, rst);
	
	// Declaration of Design Under Test
	gpio dut (
			.clk_i(clk),
			// AXI4 Lite Interface Connection
			.rst_i(rst),
			.cfg_awaddr_i(axi4l_if.AWADDR),
			.cfg_awvalid_i(axi4l_if.AWVALID),
			.cfg_awready_o(axi4l_if.AWREADY),
			.cfg_wdata_i(axi4l_if.WDATA),
			.cfg_wstrb_i(axi4l_if.WSTRB),
			.cfg_wvalid_i(axi4l_if.WVALID),
			.cfg_wready_o(axi4l_if.WREADY),
			.cfg_bresp_o(axi4l_if.BRESP),
			.cfg_bvalid_o(axi4l_if.BVALID),
			.cfg_bready_i(axi4l_if.BREADY),
			.cfg_araddr_i(axi4l_if.ARADDR),
			.cfg_arvalid_i(axi4l_if.ARVALID),
			.cfg_arready_o(axi4l_if.ARREADY),
			.cfg_rdata_o(axi4l_if.RDATA),
			.cfg_rresp_o(axi4l_if.RRESP),
			.cfg_rvalid_o(axi4l_if.RVALID),
			.cfg_rready_i(axi4l_if.RREADY),
			// GPIO Interface Connection
			.gpio_input_i(gpio_if.gpio_in),
			.gpio_output_o(gpio_if.gpio_out),
			.gpio_output_enable_o(gpio_if.gpio_oe),
			.intr_o(gpio_if.intr)
		 );
	
	// Reset and Clock Generation 
	initial begin
		clk = 0;
		rst = 0;
		repeat (8) begin
			#10ns clk = ~clk;
		end
		rst = 1;
		forever begin
			#10ns clk = ~clk;
		end
	end
	
	// Initial Block
	initial begin
		
		// Set the AXI4 Lite Virtual interface into Config DB
		uvm_config_db #(virtual axi4l_interface #(addr_width,data_width))::set(null,"this", "axi4l_vif", axi4l_if);
		
		// Set the GPIO interface into Config DB
		uvm_config_db #(virtual gpio_interface #(num_pins))::set(null,"this","gpio_vif",gpio_if);
		
		// Run the UVM Test
		run_test();  
	end

endmodule
