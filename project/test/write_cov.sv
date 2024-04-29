//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_cov.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class write_cov extends base_test;

    //component macro
    `uvm_component_utils(write_cov)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", write_cov_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing write_cov test" , UVM_LOW)
    endtask: run_phase

endclass : write_cov


// Sequence for a read-miss on I-cache
class write_cov_seq extends base_vseq;
    //object macro
    `uvm_object_utils(write_cov_seq)

    cpu_transaction_c trans;

    //constructor
    function new (string name="write_cov_seq");
        super.new(name);
    endfunction : new

//    constraint read_acc{ trans.request_type == WRITE_REQ; trans.address >= 32'h4000_0000; }

    virtual task body();
        repeat(100)
        begin
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == WRITE_REQ; address >= 32'h4000_0000; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == WRITE_REQ; address >= 32'h4000_0000; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == WRITE_REQ; address >= 32'h4000_0000; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == WRITE_REQ; address >= 32'h4000_0000; })
        end

    endtask

endclass : write_cov_seq
