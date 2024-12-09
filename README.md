# GPIO Peripheral with AXI4-Lite Interface Verification Framework

# Overview
This repository provides a detailed, reusable, and modular UVM-based verification framework aimed at validating the functionality of GPIO (General Purpose Input/Output) peripherals that interact with an AXI4-Lite interface. This verification framework is built using the Universal Verification Methodology (UVM), a widely adopted standard for functional verification in hardware design. It provides an extensive simulation environment that validates GPIO port operations, AXI4-Lite interface transactions, and register accesses through the Register Abstraction Layer (RAL). By simulating these components in a System-on-Chip (SoC) design, this framework ensures that the interactions between the GPIO and AXI4-Lite interfaces are correct and reliable.

This framework is modular, so it can be easily extended to accommodate more complex scenarios, DUT (Design Under Test) configurations, or additional peripherals beyond the GPIO and AXI4-Lite interfaces. The verification environment is designed for robustness, ensuring comprehensive testing under various real-world conditions.

# Key Features
1. Modular Testbench: The framework is highly modular and easy to extend to support additional agents or test scenarios for other peripherals, making it adaptable to different designs and configurations.

2. Concurrent Testing: Virtual sequences allow the concurrent execution of multiple test sequences for different components. This is useful for simulating real-world use cases where multiple peripherals operate simultaneously, such as GPIO and AXI4-Lite interactions.

3. Comprehensive Coverage: The framework includes test sequences to ensure thorough coverage of GPIO operations, AXI4-Lite transactions, and RAL register access, providing confidence that the DUT behaves correctly under a variety of conditions.

4. Flexible Configuration: All testbench configuration parameters are stored in the UVM Configuration Database, making it easy to change test settings dynamically without modifying the code.

# Framework Components

1. Base Test(gpio_base_test):

	The gpio_base_test class is responsible for initializing and configuring the test environment for the GPIO module. It includes:

	1. Setup of the GPIO and AXI4-Lite agents.
	2. Integration with the DUT using virtual interfaces.
	3. Use of the UVM Configuration Database (config_db) to retrieve configuration settings.
	4. A flexible environment that allows easy addition of extra GPIO agents or other peripherals if necessary.

2. Virtual Sequences(virtual_seq):
	
	Virtual sequences allow the concurrent execution of multiple test sequences. This extension is useful for testing interactions between GPIO operations and AXI4-Lite transactions, where both components operate together. This class:

	1. Simultaneously runs the gpio_sequence and axi4l_sequence, ensuring that both interfaces can operate without conflict in a synchronized manner.
	2. Enhances realism by simulating the environment of an actual system where both interfaces are in continuous operation.
	
3. Test Sequences:
	
	The framework includes predefined test sequences to simulate various operational scenarios. These sequences include:

	1. GPIO Sequence: Tests the functionality of the GPIO module by generating random inputs and checking both read and write operations.
	2. AXI4-Lite Sequence: Simulates memory-mapped transactions via AXI4-Lite, exercising read and write operations.
	3. RAL Sequences: Verifies correct register access using the Register Abstraction Layer (RAL), ensuring accurate register reads and writes.
	
	Key Test Sequences:
		1. RAL Read Sequence: Ensures the correctness of register read operations by comparing the expected value with the actual register value.
		2. RAL Write Sequence: Verifies that the write functionality works as expected by randomizing input values and ensuring proper register writes.
		
# Usage
1. Prerequisites
	To run the framework, the following tools and components are required:

	1. UVM Library: The UVM methodology is used to create a flexible and scalable test environment.
	2. SystemVerilog Simulator: A compatible simulatoris required for compiling and running the UVM-based testbenches.
	3. Interface Definitions: Ensure that AXI4-Lite and GPIO interface files (axi4l_defines.svh, gpio_defines.svh) are defined and available for use in the testbench.
	
# Extending the Framework
To extend this framework for additional functionalities or peripherals:

1. Add New Sequences: Define new sequences to test other functionalities of the DUT.
2. Add New Agents: Integrate additional interfaces or peripherals by defining new agents and updating the testbench environment configuration.
3. Modify Virtual Sequences: Extend the virtual sequences to include more complex interactions or test scenarios where multiple components are active at once.

# Conclusion

This GPIO and AXI4-Lite Verification Framework serves as a solid foundation for verifying GPIO peripherals and their integration with AXI4-Lite interfaces in SoC designs. The use of UVM methodology and virtual sequences enables comprehensive coverage of different operational scenarios, ensuring robust verification and validation. This framework is designed to be easily extendable, customizable, and adaptable to various DUT configurations, making it suitable for complex verification tasks in modern chip designs.

By leveraging this framework, you can confidently ensure that your SoC components, particularly the GPIO peripherals and AXI4-Lite interfaces, are thoroughly tested and function as expected in real-world applications.
