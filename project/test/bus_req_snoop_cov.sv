//=====================================================================
// Project: 4 core MESI cache design
// File Name: bus_req_snoop_cov.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class bus_req_snoop_cov extends base_test;

    //component macro
    `uvm_component_utils(bus_req_snoop_cov)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", bus_req_snoop_cov_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing bus_req_snoop_cov test" , UVM_LOW)
    endtask: run_phase

endclass : bus_req_snoop_cov


// Sequence for a read-miss on I-cache
class bus_req_snoop_cov_seq extends base_vseq;
    //object macro
    `uvm_object_utils(bus_req_snoop_cov_seq)

    cpu_transaction_c trans;
	int p;
    bit [31:0] addr;
    //constructor
    function new (string name="bus_req_snoop_cov_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(50)begin
        addr = $urandom_range(32'h4000_0000, 32'hFFFE_FFF0);

	    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == addr; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr+1; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == addr+1; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == addr+2; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == addr+2; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == addr+4; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == addr+4; })
        
	    end


for(int i=0;i<4;i++)
begin
    //covers 0101
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == 32'hEEEE_0001; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == 32'hEEEE_0001; })
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0001; })

    //covers 1001
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == 32'hEEEE_0002; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0002; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0002; })

    //covers 1010
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == 32'hEEEE_0003; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0003; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0003; })

    //covers 1011
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == 32'hEEEE_0004; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0004; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == 32'hEEEE_0004; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0004; })

    //covers 1101
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == 32'hEEEE_0005; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0005; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == 32'hEEEE_0005; })
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0005; })
  
    //covers 1110
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0006; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == 32'hEEEE_0006; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == 32'hEEEE_0006; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0006; } )
  
//covers 1010
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0007; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == READ_REQ; address == 32'hEEEE_0007; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == 32'hEEEE_0007; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0007; } )
  
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == READ_REQ; address == 32'hEEEE_0008; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ; address == 32'hEEEE_0008; } )
  `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == READ_REQ; address == 32'hEEEE_0008; } )
    `uvm_do_on_with(trans, p_sequencer.cpu_seqr[i], {request_type == READ_REQ; address == 32'hEEEE_0008; } )
  end

    endtask

endclass : bus_req_snoop_cov_seq

