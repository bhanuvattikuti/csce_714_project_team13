//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_after_read.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class write_after_read extends base_test;

    //component macro
    `uvm_component_utils(write_after_read)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", write_after_read_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing write_after_read test" , UVM_LOW)
    endtask: run_phase

endclass : write_after_read


// Sequence for a read-miss on I-cache
class write_after_read_seq extends base_vseq;
    //object macro
    `uvm_object_utils(write_after_read_seq)

    cpu_transaction_c trans;

    //constructor
    function new (string name="write_after_read_seq");
        super.new(name);
    endfunction : new

    virtual task body();
      
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})

`uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == WRITE_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008; data == 32'h0000_0000;})
// should invalidate other copies in CPU1 and CPU2

`uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
// should result in a miss and CPU3 writes data to memory and data is served by lv2, but received a hit - bug? 


    endtask

endclass : write_after_read_seq
