//=====================================================================
// Project: 4 core MESI cache design
// File Name: read_read.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class read_read extends base_test;

    //component macro
    `uvm_component_utils(read_read)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", read_read_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing read_read test" , UVM_LOW)
    endtask: run_phase

endclass : read_read


// Sequence for a read-miss on I-cache
class read_read_seq extends base_vseq;
    //object macro
    `uvm_object_utils(read_read_seq)

    cpu_transaction_c trans;
    int p;
    //constructor
    function new (string name="read_read_seq");
        super.new(name);
    endfunction : new

    virtual task body();
      
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_0008;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_0008;})

`uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_0004;})
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_0004;})
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; access_cache_type == ICACHE_ACC; address == 32'h3000_000C;})

    repeat(50)
    begin
    p = $urandom_range(0,3);
`uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == READ_REQ; access_cache_type == ICACHE_ACC;})
end

    endtask

endclass : read_read_seq
