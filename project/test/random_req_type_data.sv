//=====================================================================
// Project: 4 core MESI cache design
// File Name: random_req_type_data.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class random_req_type_data extends base_test;

    //component macro
    `uvm_component_utils(random_req_type_data)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", random_req_type_data_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing random_req_type_data test" , UVM_LOW)
    endtask: run_phase

endclass : random_req_type_data


// Sequence for a read-miss on I-cache
class random_req_type_data_seq extends base_vseq;
    //object macro
    `uvm_object_utils(random_req_type_data_seq)

    cpu_transaction_c trans;
	bit [31:0] addr;
	int p;
    //constructor
    function new (string name="random_req_type_data_seq");
        super.new(name);
    endfunction : new

    virtual task body();
	
	addr=$urandom_range(32'h40000000,32'hffffffff);
	
	repeat(50)begin
	p=$urandom_range(0,3);
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == READ_REQ;address == addr;})
	`uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == WRITE_REQ;address == addr;})	
	end
    endtask

endclass : random_req_type_data_seq
