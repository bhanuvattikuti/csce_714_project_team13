//=====================================================================
// Project: 4 core MESI cache design
// File Name: bus_req_proc_num_cov.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class bus_req_proc_num_cov extends base_test;

    //component macro
    `uvm_component_utils(bus_req_proc_num_cov)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", bus_req_proc_num_cov_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing bus_req_proc_num_cov test" , UVM_LOW)
    endtask: run_phase

endclass : bus_req_proc_num_cov


// Sequence for a read-miss on I-cache
class bus_req_proc_num_cov_seq extends base_vseq;
    //object macro
    `uvm_object_utils(bus_req_proc_num_cov_seq)

    cpu_transaction_c trans;
	int p;
    bit [31:0] addr;
    //constructor
    function new (string name="bus_req_proc_num_cov_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(10)
        begin

        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], { request_type==READ_REQ; address == 32'h4000_FFFF;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], { request_type==WRITE_REQ;address == 32'h4000_FFFA;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], { request_type==READ_REQ; address ==  32'h4000_FFFB;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], { request_type==WRITE_REQ; address ==  32'h4000_FFFC;})

	end
    endtask

endclass : bus_req_proc_num_cov_seq

