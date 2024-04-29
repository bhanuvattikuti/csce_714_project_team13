//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_read_dcache.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================


class coverage_req_type_proc_bdry_addr extends base_test;

    //component macro
    `uvm_component_utils(coverage_req_type_proc_bdry_addr)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", coverage_req_type_proc_bdry_addr_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing coverage_req_type_proc_bdry_addr test" , UVM_LOW)
    endtask: run_phase

endclass : coverage_req_type_proc_bdry_addr


// Sequence for a cpu_monitor_coverage
class coverage_req_type_proc_bdry_addr_seq extends base_vseq;
    //object macro
    `uvm_object_utils(coverage_req_type_proc_bdry_addr_seq)

     cpu_transaction_c trans =new();
    integer address_track = 32'h0; 
    bit [1:0] proc_num =2'd0;
    //constructor
    function new (string name="coverage_req_type_proc_bdry_addr_seq");
        super.new(name);
    endfunction : new

    

    virtual task body();
       
        // generating requests at cache boundaries
        //diabaling contraints : trans.cache_bdry_addr.constraint_mode(0)
       // looping 4 times to reach all processors
       
        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_RD 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                // wirte to same cache blk to invalidate
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            repeat (4)
            begin
                //ICACHE_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == ICACHE_ACC; request_type == READ_REQ; })
            end
            repeat(4)
            begin
                //BUS_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address != address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })            
                address_track = trans.address;
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                //`uvm_info(get_type_name(), $psprintf("proc_num= %d",proc_num), UVM_LOW);
            end 

        proc_num = proc_num +1;
        end

        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_RD 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                // wirte to same cache blk to invalidate
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            repeat (4)
            begin
                //ICACHE_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == ICACHE_ACC; request_type == READ_REQ; })
            end
            repeat(4)
            begin
                //BUS_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address != address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })            
                address_track = trans.address;
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                //`uvm_info(get_type_name(), $psprintf("proc_num= %d",proc_num), UVM_LOW);
            end 

        proc_num = proc_num +1;
        end

        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_RD 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                // wirte to same cache blk to invalidate
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            repeat (4)
            begin
                //ICACHE_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == ICACHE_ACC; request_type == READ_REQ; })
            end
            repeat(4)
            begin
                //BUS_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num+1],{ address != address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })            
                address_track = trans.address;
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                //`uvm_info(get_type_name(), $psprintf("proc_num= %d",proc_num), UVM_LOW);
            end 

        proc_num = proc_num +1;
        end

        begin
             // looping 4 times to reach all addresses. 
            repeat(4)
            begin
            // BUS_RD 
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                address_track = trans.address;
                //move the cache blk to shared state
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
                // wirte to same cache blk to invalidate
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            end 
            repeat (4)
            begin
                //ICACHE_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ access_cache_type == ICACHE_ACC; request_type == READ_REQ; })
            end
            repeat(4)
            begin
                //BUS_RD
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{ address != address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })            
                address_track = trans.address;
                `uvm_do_on_with(trans, p_sequencer.cpu_seqr[proc_num],{ address == address_track; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
                //`uvm_info(get_type_name(), $psprintf("proc_num= %d",proc_num), UVM_LOW);
            end 

        proc_num = proc_num +1;
        end

        
        
    
    
    endtask

endclass : coverage_req_type_proc_bdry_addr_seq
