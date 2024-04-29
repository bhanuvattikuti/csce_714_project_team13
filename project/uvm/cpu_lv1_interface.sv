//=====================================================================
// Project: 4 core MESI cache design
// File Name: cpu_lv1_interface.sv
// Description: Basic CPU-LV1 interface with assertions
// Designers: Venky & Suru
//=====================================================================


interface cpu_lv1_interface(input clk);

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter DATA_WID_LV1           = `DATA_WID_LV1       ;
    parameter ADDR_WID_LV1           = `ADDR_WID_LV1       ;

    reg   [DATA_WID_LV1 - 1   : 0] data_bus_cpu_lv1_reg    ;

    wire  [DATA_WID_LV1 - 1   : 0] data_bus_cpu_lv1        ;
    logic [ADDR_WID_LV1 - 1   : 0] addr_bus_cpu_lv1        ;
    logic                          cpu_rd                  ;
    logic                          cpu_wr                  ;
    logic                          cpu_wr_done             ;
    logic                          data_in_bus_cpu_lv1     ;

    assign data_bus_cpu_lv1 = data_bus_cpu_lv1_reg ;

//Assertions
//ASSERTION1: cpu_wr and cpu_rd should not be asserted at the same clock cycle
    property prop_simult_cpu_wr_rd;
        @(posedge clk)
          not(cpu_rd && cpu_wr);
    endproperty

    assert_simult_cpu_wr_rd: assert property (prop_simult_cpu_wr_rd)
    else
        `uvm_error("cpu_lv1_interface",$sformatf("Assertion assert_simult_cpu_wr_rd Failed: cpu_wr and cpu_rd asserted simultaneously"))

//TODO: Add assertions at this interface
//  As long as cpu_rd is high, addr_bus_cpu_lv1 should hold value

    property prop_cpu_rd_addr_high;
    @(posedge clk)
    (cpu_rd||cpu_wr)|->(addr_bus_cpu_lv1[31:0]!==32'bx);
    endproperty
    assert_prop_cpu_rd_addr_high: assert property(prop_cpu_rd_addr_high)
    else
    `uvm_error("cpu_lv1_interface",$sformatf("Assertion prop_cpu_rd_addr_high Failed: cpu_rd and addr_bus_cpu_lv1 are not asserted simultaneously"))

 property cpu_rd_data_in_bus_cpu_lv1;
        @(posedge clk)
        cpu_rd |=> ##[0:$] data_in_bus_cpu_lv1 ##1 !cpu_rd ##1 !data_in_bus_cpu_lv1 ;
    endproperty

    assert_cpu_rd_data_in_bus_cpu_lv1: assert property (cpu_rd_data_in_bus_cpu_lv1)
    else
        `uvm_error("cpu_lv1_interface", "Assertion cpu_rd_data_in_bus_cpu_lv1 failed: Once cpu_rd is asserted, correct sequence of data_in_bus_cpu_lv1 is not followed")

//ASSERTION 4
  property valid_data_in_bus_rd;
        @(posedge clk)
        $rose(data_in_bus_cpu_lv1) |-> cpu_rd;
    endproperty

    assert_valid_data_in_bus_rd: assert property (valid_data_in_bus_rd)
    else
        `uvm_error("cpu_lv1_interface", "Assertion valid_data_in_bus_rd failed: cpu_rd  will not high when data_in_bus_cpu_lv1 asserted")


endinterface
