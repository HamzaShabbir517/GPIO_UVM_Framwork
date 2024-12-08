/*
Address Offset	Register	Description
0x00	GPIO Output		Holds the output values for GPIO pins.
0x04	GPIO Output Enable	Configures the direction: 1 = output, 0 = input.
0x08	GPIO Input		Captures the current state of GPIO pins (driven by external hardware logic).
0x0C	Interrupt Enable	Enables interrupts for each pin (1 = enabled, 0 = disabled).
0x10	Interrupt Status	Indicates which pins caused an interrupt.
0x14	Interrupt Clear		Clears the specified interrupt bits.
*/
module axi_gpio (
    // AXI4-Lite Interface
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0]  awaddr,
    input  wire        awvalid,
    output wire        awready,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    input  wire        wvalid,
    output wire        wready,
    output wire [1:0]  bresp,
    output wire        bvalid,
    input  wire        bready,
    input  wire [31:0]  araddr,
    input  wire        arvalid,
    output wire        arready,
    output wire [31:0] rdata,
    output wire [1:0]  rresp,
    output wire        rvalid,
    input  wire        rready,

    // GPIO Interface
    input  wire [31:0] gpio_in,              // GPIO input values (from external hardware)
    output reg  [31:0] gpio_out,             // GPIO output values
    output reg  [31:0] gpio_output_enable,   // GPIO output enable: 1 = output, 0 = input

    // Interrupt Interface
    output wire        irq                   // Interrupt request
);

    // GPIO Register Definitions
    localparam GPIO_OUT_ADDR      = 8'h00;  // GPIO Output Register
    localparam GPIO_OUTPUT_EN_ADDR = 8'h04; // GPIO Output Enable Register
    localparam GPIO_IN_ADDR       = 8'h08;  // GPIO Input Register
    localparam GPIO_INT_EN_ADDR   = 8'h0C;  // GPIO Interrupt Enable Register
    localparam GPIO_INT_STAT_ADDR = 8'h10; // GPIO Interrupt Status Register
    localparam GPIO_INT_CLEAR_ADDR = 8'h14; // GPIO Interrupt Clear Register

    // AXI4-Lite Signals
    reg        axi_awready;
    reg        axi_wready;
    reg [1:0]  axi_bresp;
    reg        axi_bvalid;
    reg        axi_arready;
    reg [31:0] axi_rdata;
    reg [1:0]  axi_rresp;
    reg        axi_rvalid;

    // GPIO Control Registers
    reg [31:0] gpio_int_enable;  // Interrupt enable register
    reg [31:0] gpio_int_status;  // Interrupt status register
    reg [31:0] gpio_in_reg;      // Latched input register for edge detection

    // Assignments for AXI4-Lite
    assign awready = axi_awready;
    assign wready  = axi_wready;
    assign bresp   = axi_bresp;
    assign bvalid  = axi_bvalid;
    assign arready = axi_arready;
    assign rdata   = axi_rdata;
    assign rresp   = axi_rresp;
    assign rvalid  = axi_rvalid;

    // Interrupt signal
    assign irq = |gpio_int_status; // Set IRQ if any bit in the status register is high

    // AXI4-Lite Write Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_awready       <= 1'b0;
            axi_wready        <= 1'b0;
            axi_bvalid        <= 1'b0;
            axi_bresp         <= 2'b00; // OKAY response
            gpio_out          <= 32'b0;
            gpio_output_enable <= 32'b0;
            gpio_int_enable   <= 32'b0;
            gpio_int_status   <= 32'b0;
        end else begin
            // Write Address Ready
            if (awvalid && !axi_awready) begin
                axi_awready <= 1'b1;
            end else begin
                axi_awready <= 1'b0;
            end

            // Write Data Ready
            if (wvalid && !axi_wready) begin
                axi_wready <= 1'b1;
                case (awaddr[7:0])
                    GPIO_OUT_ADDR:      gpio_out <= wdata;
                    GPIO_OUTPUT_EN_ADDR: gpio_output_enable <= wdata;
                    GPIO_INT_EN_ADDR:   gpio_int_enable <= wdata;
                    GPIO_INT_CLEAR_ADDR: gpio_int_status <= gpio_int_status & ~wdata; // Clear specific interrupt bits
                    default:            ; // No operation for undefined addresses
                endcase
            end else begin
                axi_wready <= 1'b0;
            end

            // Write Response
            if (axi_awready && axi_wready && !axi_bvalid) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00; // OKAY response
            end else if (bready && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    // AXI4-Lite Read Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            axi_arready <= 1'b0;
            axi_rvalid  <= 1'b0;
            axi_rresp   <= 2'b00; // OKAY response
            axi_rdata   <= 32'b0;
        end else begin
            // Read Address Ready
            if (arvalid && !axi_arready) begin
                axi_arready <= 1'b1;
            end else begin
                axi_arready <= 1'b0;
            end

            // Read Data
            if (arvalid && !axi_rvalid) begin
                case (araddr[7:0])
                    GPIO_OUT_ADDR:      axi_rdata <= gpio_out;
                    GPIO_OUTPUT_EN_ADDR: axi_rdata <= gpio_output_enable;
                    GPIO_IN_ADDR:       axi_rdata <= gpio_in;
                    GPIO_INT_EN_ADDR:   axi_rdata <= gpio_int_enable;
                    GPIO_INT_STAT_ADDR: axi_rdata <= gpio_int_status;
                    default:            axi_rdata <= 32'b0; // Undefined address
                endcase
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00; // OKAY response
            end else if (rready && axi_rvalid) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

    // GPIO Interrupt Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_int_status <= 32'b0;
            gpio_in_reg     <= 32'b0;
        end else begin
            gpio_in_reg <= gpio_in; // Latch current input values
            gpio_int_status <= gpio_int_status |
                               ((gpio_in ^ gpio_in_reg) & gpio_int_enable); // Detect changes on enabled pins
        end
    end

endmodule

