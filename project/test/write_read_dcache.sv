//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_read_dcache.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class write_read_dcache extends base_test;

    //component macro
    `uvm_component_utils(write_read_dcache)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", write_read_dcache_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing write_read_dcache test" , UVM_LOW)
    endtask: run_phase

endclass : write_read_dcache


// Sequence for a read-miss on I-cache
class write_read_dcache_seq extends base_vseq;
    //object macro
    `uvm_object_utils(write_read_dcache_seq)

    cpu_transaction_c trans;

    //constructor
    function new (string name="write_read_dcache_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == WRITE_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008; data == 32'hFFFF_FFFF;})
 `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == DCACHE_ACC; address == 32'h4000_0008;})

    endtask

endclass : write_read_dcache_seq
