//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_read_dcache.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================


class coverage_evict_addr_proc extends base_test;

    //component macro
    `uvm_component_utils(coverage_evict_addr_proc)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", coverage_evict_addr_proc_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing coverage_evict_addr_proc test" , UVM_LOW)
    endtask: run_phase

endclass : coverage_evict_addr_proc


// Sequence for a cpu_monitor_coverage
class coverage_evict_addr_proc_seq extends base_vseq;
    //object macro
    `uvm_object_utils(coverage_evict_addr_proc_seq)

     cpu_transaction_c trans =new();
    integer address_track = 32'h0; 
    bit [1:0] proc_num =2'd0;
    //constructor
    function new (string name="coverage_evict_addr_proc_seq");
        super.new(name);
    endfunction : new

    

    virtual task body();
       
        // generating requests at cache boundaries
        //diabaling contraints : trans.cache_bdry_addr.constraint_mode(0)
       // looping 4 times to reach all processors
        proc_num =0;
        //cpu0
        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_WRITE 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            
        proc_num = proc_num +1;
        end

        //cpu0
        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_WRITE 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            
        proc_num = proc_num +1;
        end

        //cpu0
        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_WRITE 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            
        proc_num = proc_num +1;
        end

        //cpu0
        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_WRITE 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{ access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            
        proc_num = proc_num +1;
        end
        
        
    
    endtask

endclass : coverage_evict_addr_proc_seq
