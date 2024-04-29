//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_hit_read.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class write_hit_read extends base_test;

    //component macro
    `uvm_component_utils(write_hit_read)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", write_hit_read_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing write_hit_read test" , UVM_LOW)
    endtask: run_phase

endclass : write_hit_read


// Sequence for a read-miss on I-cache
class write_hit_read_seq extends base_vseq;
    //object macro
    `uvm_object_utils(write_hit_read_seq)

    cpu_transaction_c trans;

    //constructor
    function new (string name="write_hit_read_seq");
        super.new(name);
    endfunction : new

    virtual task body();
      
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})

`uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == WRITE_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008; data == 32'h0000_0000;})

`uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})


    endtask

endclass : write_hit_read_seq
