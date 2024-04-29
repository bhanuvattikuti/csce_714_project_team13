//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_read_dcache.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================

class cpu_monitor_coverage extends base_test;

    //component macro
    `uvm_component_utils(cpu_monitor_coverage)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", cpu_monitor_coverage_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing cpu_monitor_coverage test" , UVM_LOW)
    endtask: run_phase

endclass : cpu_monitor_coverage


// Sequence for a cpu_monitor_coverage
class cpu_monitor_coverage_seq extends base_vseq;
    //object macro
    `uvm_object_utils(cpu_monitor_coverage_seq)

     cpu_transaction_c trans =new();
    integer address_track = 32'h0; 
    //constructor
    function new (string name="cpu_monitor_coverage_seq");
        super.new(name);
    endfunction : new

    //constraint cpu_cosntraint {
        //trans.access_cache_type == (ICACHE_ACC || DCACHE_ACC);
    //    ( trans.access_cache_type == ICACHE_ACC) -> trans.request_type == READ_REQ;
    //    !(trans.address % 64 );
    //}

    virtual task body();
        // int ok = trans.randomize();
        // generating requests at cache boundaries
        //diabaling contraints : trans.cache_bdry_addr.constraint_mode(0)
        repeat(10)
        begin
        //`uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{access_cache_type dist {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; solve access_cache_type before request_type;})
        
        `uvm_do_on(trans, p_sequencer.cpu_seqr[0]) //, {!(address % 64) ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
        address_track = trans.address; // access the same address to induce hit
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0], {address== address_track;}) // ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
 
        `uvm_do_on(trans, p_sequencer.cpu_seqr[1]) //, {!(address % 64) ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
        address_track = trans.address; // access the same address to induce hit
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1], {address== address_track;}) // ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })

        
        `uvm_do_on(trans, p_sequencer.cpu_seqr[2]) //, {!(address % 64) ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
        address_track = trans.address; // access the same address to induce hit
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2], {address== address_track;}) // ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })

        `uvm_do_on(trans, p_sequencer.cpu_seqr[3]) //, {!(address % 64) ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
        address_track = trans.address; // access the same address to induce hit
        `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {address== address_track;}) // ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })

        
        //`uvm_do_on_with(trans, p_sequencer.cpu_seqr[3], {!(address % 64) ; access_cache_type inside {ICACHE_ACC, DCACHE_ACC};( access_cache_type == ICACHE_ACC) -> request_type == READ_REQ; })
        end
        
    
    endtask

endclass : cpu_monitor_coverage_seq
