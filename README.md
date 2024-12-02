# AXI4-Lite GPIO UVM Framework
This repository contains a Universal Verification Methodology (UVM) framework tailored for verifying GPIO peripherals with an AXI4-Lite interface. The framework provides a reusable, modular, and scalable testbench to ensure the functional correctness and robustness of the GPIO design under test (DUT).

# Key Features:
  1. UVM-based Verification: Comprehensive testbench leveraging UVM principles for modularity and reusability.
  2. AXI4-Lite Protocol Support: Includes transactions for read, write, and configuration operations following the AXI4-Lite protocol.
  3. Flexible Test Sequences: Predefined and customizable sequences to cover GPIO functionality, including read, write, toggle, and interrupt scenarios.
  4. Scoreboard and Coverage: Built-in mechanisms for result comparison and functional coverage tracking.
  5. Scalable Agent Design: A dedicated UVM agent for AXI4-Lite transactions, combining driver, monitor, and sequencer.

# Usage:
This framework is suitable for engineers looking to verify GPIO implementations with AXI4-Lite compatibility. It provides a robust starting point for extending to other peripherals or customizing GPIO-specific functionality. Contributions are welcome! Please feel free to open issues or submit pull requests to enhance the framework further.






