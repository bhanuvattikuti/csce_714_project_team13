//=====================================================================
// Project: 4 core MESI cache design
// File Name: req_serv_by_cov.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class req_serv_by_cov extends base_test;

    //component macro
    `uvm_component_utils(req_serv_by_cov)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", req_serv_by_cov_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing req_serv_by_cov test" , UVM_LOW)
    endtask: run_phase

endclass : req_serv_by_cov


// Sequence for a read-miss on I-cache
class req_serv_by_cov_seq extends base_vseq;
    //object macro
    `uvm_object_utils(req_serv_by_cov_seq)

    cpu_transaction_c trans;
	int p;
    bit [31:0] addr;
    //constructor
    function new (string name="req_serv_by_cov_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(100)begin
        addr = $urandom_range(32'h4000_0000, 32'hFFFF_FFF0);

	    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == addr; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr+1; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == addr+1; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == addr+2; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == addr+2; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == addr+4; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr+4; })
        
	end
    endtask

endclass : req_serv_by_cov_seq

