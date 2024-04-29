//=====================================================================
// Project: 4 core MESI cache design
// File Name: multi_thread.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class multi_thread extends base_test;

    //component macro
    `uvm_component_utils(multi_thread)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", multi_thread_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing multi_thread test" , UVM_LOW)
    endtask: run_phase

endclass : multi_thread


// Sequence for a read-miss on I-cache
class multi_thread_seq extends base_vseq;
    //object macro
    `uvm_object_utils(multi_thread_seq)

    cpu_transaction_c trans;
    int p;
    //constructor
    function new (string name="multi_thread_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(50)
        begin
        fork
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == READ_REQ;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{request_type == READ_REQ;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{request_type == READ_REQ;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{request_type == READ_REQ;})
        join
        end

        repeat(50)
        begin
        fork
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{request_type == READ_REQ;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{request_type == WRITE_REQ;address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{request_type == READ_REQ;})
        join
end
        repeat(50)
        begin
        fork
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        join
        
        end    

             repeat(50)
        begin
        p = $urandom_range(0,3);
        fork

        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[p], {request_type == WRITE_REQ; address>=32'h4000_0000;})
        join
        
        end    
   
    endtask

endclass : multi_thread_seq
