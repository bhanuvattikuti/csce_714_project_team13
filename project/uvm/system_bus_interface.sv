//=====================================================================
// Project: 4 core MESI cache design
// File Name: system_bus_interface.sv
// Description: Basic system bus interface including arbiter
// Designers: Venky & Suru
//=====================================================================

interface system_bus_interface(input clk);

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter DATA_WID_LV1        = `DATA_WID_LV1       ;
    parameter ADDR_WID_LV1        = `ADDR_WID_LV1       ;
    parameter NO_OF_CORE            = 4;

    wire [DATA_WID_LV1 - 1 : 0] data_bus_lv1_lv2     ;
    wire [ADDR_WID_LV1 - 1 : 0] addr_bus_lv1_lv2     ;
    wire                        bus_rd               ;
    wire                        bus_rdx              ;
    wire                        lv2_rd               ;
    wire                        lv2_wr               ;
    wire                        lv2_wr_done          ;
    wire                        cp_in_cache          ;
    wire                        data_in_bus_lv1_lv2  ;

    wire                        shared               ;
    wire                        all_invalidation_done;
    wire                        invalidate           ;

    logic [NO_OF_CORE - 1  : 0]   bus_lv1_lv2_gnt_proc ;
    logic [NO_OF_CORE - 1  : 0]   bus_lv1_lv2_req_proc ;
    logic [NO_OF_CORE - 1  : 0]   bus_lv1_lv2_gnt_snoop;
    logic [NO_OF_CORE - 1  : 0]   bus_lv1_lv2_req_snoop;
    logic                       bus_lv1_lv2_gnt_lv2  ;
    logic                       bus_lv1_lv2_req_lv2  ;

//Assertions
//property that checks that signal_1 is asserted in the previous cycle of signal_2 assertion
    property prop_sig1_before_sig2(signal_1,signal_2);
    @(posedge clk)
        signal_2 |-> $past(signal_1);
    endproperty

//ASSERTION1: lv2_wr_done should not be asserted without lv2_wr being asserted in previous cycle
    assert_lv2_wr_done: assert property (prop_sig1_before_sig2(lv2_wr,lv2_wr_done))
    else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_lv2_wr_done Failed: lv2_wr not asserted before lv2_wr_done goes high"))

//ASSERTION 2: data_in_bus_lv1_lv2 and cp_in_cache should not be asserted without lv2_rd being asserted in previous cycle
assert_lv2_rd_data : assert property (prop_sig1_before_sig2(lv2_rd, data_in_bus_lv1_lv2))
    else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_lv2_rd_data Failed: lv2_rd not asserted before data_in_bus_lv1_lv2 high"))

//ASSERTION 3:  lv2_rd should be asserted before cp_in_cache is asserted
assert_lv2_rd_cp_in_cache : assert property (prop_sig1_before_sig2(lv2_rd, cp_in_cache))
    else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_lv2_rd_cp_in_cache Failed: lv2_rd not asserted before cp_in_cache high"))

//AASERTION 4: Once bus_lv1_lv2_gnt_proc is asserted, then only bus_rd and lv2_rd is asserted.
assert_gnt_proc_bus_rd_lv2_rd : assert property (prop_sig1_before_sig2(bus_lv1_lv2_gnt_proc, bus_rd && lv2_rd))
    else 
   `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_proc_bus_rd_lv2_rd Failed :bus_lv1_lv2_gnt_proc is asserted, after which bus_rd and lv2_rd is not asserted"))

//ASSERTION 5: If bus_rdx and lv2_rd is asserted, then in the previous cycle bus_lv1_lv2_gnt_proc should be asserted
assert_gnt_proc_bus_rdx_lv2_rd : assert property (prop_sig1_before_sig2(bus_lv1_lv2_gnt_proc, bus_rdx && lv2_rd))
    else 
   `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_proc_bus_rdx_lv2_rd Failed :If bus_rdx and lv2_rd is asserted, then in the previous cycle bus_lv1_lv2_gnt_proc is not asserted"))

//ASSERTION 6: Both bus_lv1_lv2_gnt_proc and bus_lv1_lv2_gnt_snoop is one hot signal
property property_gnt_onehot(signal1); 
      @(posedge clk)
                $onehot0(signal1);
endproperty

assert_gnt_proc_onehot: assert property (property_gnt_onehot(bus_lv1_lv2_gnt_proc))
    else 
   `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_proc_onehot Failed :bus_lv1_lv2_gnt_proc is not one hot signal"))

//ASSERTION 7:
assert_gnt_snoop_onehot: assert property (property_gnt_onehot(bus_lv1_lv2_gnt_snoop))
    else 
   `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_snoop_onehot Failed :bus_lv1_lv2_gnt_snoop is not one hot signal"))

// ASSERTION 8:
//property that checks if signal_1 is asserted when signal_2 is asserted
    property prop_busrdx_lv2_rd;
    @(posedge clk)
        (bus_rd||bus_rdx)|->lv2_rd;
    endproperty

    assert_prop_busrdx_lv2_rd: assert property (prop_busrdx_lv2_rd)
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion  assert_prop_busrdx_lv2_rd Failed: bus_rd/bus_rdx asserted without a lv2_rd"))

//ASSERTION 9: Only if proc grants are assigned, then snoop grants are assigned
property prop_snoop_gnt_after_proc_gnt;
    @(posedge clk)
        $rose((|(bus_lv1_lv2_gnt_snoop))) |-> |(bus_lv1_lv2_gnt_proc);
    endproperty

    assert_prop_snoop_gnt_after_proc_gnt: assert property (prop_snoop_gnt_after_proc_gnt)
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_prop_snoop_gnt_after_proc_gnt Failed: without a proc grant the snoop grant exists"))

// ASSERTION 10: if bus_lv1_lv2_req_snoop is asserted then cp_in_cache is also asserted

property snoop_follow_cp_in_cache;
@(posedge clk)
$rose(|bus_lv1_lv2_req_snoop)|-> cp_in_cache;
endproperty

assert_snoop_follow_cp_in_cache: assert property(snoop_follow_cp_in_cache)
else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_snoop_follow_cp_in_cache Failed: Once bus_lv1_lv2_req_proc is asserted, then cp_in_cache is not asserted"))

//ASSERTION 11:if bus_lv1_lv2_gnt_proc is asserted, if the next cycle addr_bus_lv1_lv2 is asserted and lv2_rd and lv2_wr is not asserted in the same cycle invalidate signal should get asserted
property gnt_addr_invalidate;
@(posedge clk)
($rose(|bus_lv1_lv2_gnt_proc[3:0]))##1 (addr_bus_lv1_lv2[31:0]!==32'bz && !lv2_wr && !lv2_rd && !bus_rd && !bus_rdx) |->invalidate;
endproperty

assert_gnt_addr_invalidate: assert property(gnt_addr_invalidate)
else 
    `uvm_error("assert_gnt_addr_invalidate",$sformatf("if bus_lv1_lv2_gnt_proc is asserted, if the next cycle addr_bus_lv1_lv2 is asserted and lv2_rd and lv2_wr is not asserted in the same cycle invalidate signal should get asserted"))

//ASSERTION 12: invalidate followed by all_invalidation_done
property invalidate_follow_all;
@(posedge clk)
invalidate |-> ##[0:$] all_invalidation_done;
endproperty
assert_invalidate_follow_all: assert property(invalidate_follow_all)
else 
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_invalidate_follow_all Failed: all_invalidation_done is not asserted in the next cycle after invalidate signal is asserted"))

//ASSERTION 13: After bus_lv1_lv2_gnt_snoop is asserted in a particular clock cycle, from the next clock cycle or in the later clock cycles, the signals 'shared' and 'data_in_bus_lv1_lv2' will be asserted at the same time. 
property prop_bus_snoop_shared_data;
@(posedge clk)
(|bus_lv1_lv2_gnt_snoop) |=> ##[0:$] (shared && data_in_bus_lv1_lv2);
endproperty

assert_prop_bus_snoop_shared_data : assert property (prop_bus_snoop_shared_data)
else
  `uvm_error("system_bus_interface",$sformatf("Assertion assert_prop_bus_snoop_shared_data Failed : shared and data_in_bus_lv1_lv2 is not asserted after the bus_lv1_lv2_gnt_snoop signal assertion"))



//ASSERTION 15: When signal invalidate is high, signal bus_lv1_lv2_gnt should be asserted
    property prop_invalidate_gnt_proc;
    @(posedge clk)
        invalidate |-> (|bus_lv1_lv2_gnt_proc);
    endproperty

    assert_invalidate_gnt_proc: assert property(prop_invalidate_gnt_proc)
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_invalidate_gnt_proc Failed: invalidate is asserted without any bus_lv1_lv2_gnt_proc"))

//ASSERTION 16: property for only one signal being asserted at a single time
property prop_onehot (signal1, signal2);
@(posedge clk)
       (signal1||signal2)|->((signal1 ^ signal2)==1);
endproperty

assert_prop_bus_rd_bus_rdx: assert property (prop_onehot (bus_rd, bus_rdx))
else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_prop_bus_rd_bus_rdx failed: bus_rd and bus_rdx are asserted at the same time"))
//ASSERTION 17
assert_prop_bus_rd_invalidate: assert property (prop_onehot (bus_rd, invalidate))
else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_prop_bus_rd_invalidate failed: bus_rd and invalidate are asserted at the same time"))
//ASSERTION 18
assert_prop_bus_rdx_invalidate: assert property (prop_onehot (bus_rdx, invalidate))
else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_prop_bus_rdx_invalidate failed: bus_rdx and invalidate are asserted at the same time"))

//ASSERTION 19: All bus gnt should be deasserted when their corresponding req are deasserted
    property prop_bus_gnt_deassert(req,gnt);
    @(posedge clk)
        $fell(req) |-> !gnt;
    endproperty

    for(genvar i=0;i<4;i++) begin: proc_assert
        assert_bus_gnt_deassert_proc: assert property(prop_bus_gnt_deassert(bus_lv1_lv2_req_proc[i],bus_lv1_lv2_gnt_proc[i]))
            else    
                `uvm_error("system_bus_interface",$sformatf("Assertion assert_bus_gnt_deassert_proc Failed: bus_lv1_lv2_gnt_proc not asserted when the corresponding req was deasserted for cache"))
        end :proc_assert


   /* 
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_bus_gnt_deassert_proc_c0 Failed: bus_lv1_lv2_gnt_proc not deasserted when the corresponding req was deasserted for cache 0"))

    assert_bus_gnt_deassert_proc_c1: assert property(prop_bus_gnt_deassert(bus_lv1_lv2_req_proc[1],bus_lv1_lv2_gnt_proc[1]))
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_bus_gnt_deassert_proc_c1 Failed: bus_lv1_lv2_gnt_proc not deasserted when the corresponding req was deasserted for cache 1"))

    assert_bus_gnt_deassert_proc_c2: assert property(prop_bus_gnt_deassert(bus_lv1_lv2_req_proc[2],bus_lv1_lv2_gnt_proc[2]))
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_bus_gnt_deassert_proc_c2 Failed: bus_lv1_lv2_gnt_proc not deasserted when the corresponding req was deasserted for cache 2"))

    assert_bus_gnt_deassert_proc_c3: assert property(prop_bus_gnt_deassert(bus_lv1_lv2_req_proc[3],bus_lv1_lv2_gnt_proc[3]))
    else
        `uvm_error("system_bus_interface",$sformatf("Assertion assert_bus_gnt_deassert_proc_c3 Failed: bus_lv1_lv2_gnt_proc not deasserted when the corresponding req was deasserted for cache 3"))
*/

//ASSERTION 20:addr_bus_lv1_lv2 should be valid when bus_rdx/lv2_rd request is asserted
property prop_addr_check_valid_lv2_rdx;
    @(posedge clk)
      (bus_rdx && lv2_rd) |-> !($isunknown(^addr_bus_lv1_lv2));
endproperty

assert_valid_addr_check_lv2_rdx: assert property (prop_addr_check_valid_lv2_rdx)
else
	`uvm_error("system_bus_interface",$sformatf("Assertion assert_valid_addr_check_lv2_rdx Failed: addr_bus_lv1_lv2 is not valid when bus_rdx/lv2_rd is asserted"))


//ASSERTION 21




endinterface















































/* 



//TODO: Add assertions at this interface
//There are atleast 20 such assertions. Add as many as you can!!

//ASSERTION 5
property req_follow_by_grant;
@(posedge clk)
(bus_lv1_lv2_req_proc[3:0]>0)|=>##[0:$](bus_lv1_lv2_gnt_proc[3:0]>0);
endproperty

assert_req_follow_by_grant: assert property (req_follow_by_grant)
else    
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_req_follow_by_grant Failed: After bus request is made, the grant is not asserted"))

//ASSERTION 6
//if either bus_lv1_lv2_gnt or bus_lv1_lv2_gnt_snoop is asserted, then bus_lv1_lv2_gnt_proc should be asserted

property gnt_follow_gnt_snoop;
@(posedge clk)
( bus_lv1_lv2_gnt_lv2 || (bus_lv1_lv2_gnt_snoop[3:0]>0))|->(bus_lv1_lv2_gnt_proc[3:0]>0);
endproperty

assert_gnt_follow_gnt_snoop: assert property(gnt_follow_gnt_snoop)
else    
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_follow_gnt_snoop Failed: When either bus_lv1_lv2_gnt or bus_lv1_lv2_gnt_snoop is asserted, then bus_lv1_lv2_gnt_proc is not asserted "))


//ASSERTION 7
//once bus_lv1_lv2_gnt_proc is asserted, then after one cycle the address should be available
property gnt_proc_follow_address;
@(posedge clk)
(|bus_lv1_lv2_gnt_proc)|=>(addr_bus_lv1_lv2[31:0]!==32'bz);
endproperty

assert_gnt_proc_follow_address: assert property(gnt_proc_follow_address)
else
    `uvm_error("system_bus_interface",$sformatf("Assertion assert_gnt_proc_follow_address Failed: Once bus_lv1_lv2_gnt_proc is asserted then in the next cycle addr_bus_lv1_lv2 is not asserted"))



//ASSERTION 10
// if bus_lv1_lv2_req_snoop is asserted, then lv2_rd is asserted

property snoop_follow_lv2_rd;
@(posedge clk)
(|bus_lv1_lv2_req_snoop[3:0])|->$past(lv2_rd);
endproperty

assert_snoop_follow_lv2_rd: assert property(snoop_follow_lv2_rd)
else
    `uvm_error("system_bus_interface",$sformatf("Assertion snoop_follow_lv2_rd Failed: Once bus_lv1_lv2_req_proc is asserted, then lv2_rd is not asserted in the past cycle"))
*/


