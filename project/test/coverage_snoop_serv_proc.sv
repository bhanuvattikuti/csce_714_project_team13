//=====================================================================
// Project: 4 core MESI cache design
// File Name: write_read_dcache.sv
// Description: Test for read-miss to I-cache
// Designers: Venky & Suru
//=====================================================================


class coverage_snoop_serv_proc extends base_test;

    //component macro
    `uvm_component_utils(coverage_snoop_serv_proc)

    //Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //UVM build phase
    function void build_phase(uvm_phase phase);
        uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", coverage_snoop_serv_proc_seq::type_id::get());
        super.build_phase(phase);
    endfunction : build_phase

    //UVM run phase()
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Executing coverage_snoop_serv_proc test" , UVM_LOW)
    endtask: run_phase

endclass : coverage_snoop_serv_proc


// Sequence for a cpu_monitor_coverage
class coverage_snoop_serv_proc_seq extends base_vseq;
    //object macro
    `uvm_object_utils(coverage_snoop_serv_proc_seq)

     cpu_transaction_c trans =new();
    integer address_track_0 = 32'h0;
    integer address_track_1 = 32'h0;
    integer address_track_2 = 32'h0;
    integer address_track_3 = 32'h0; 
    bit [1:0] proc_num =2'd0;
    //constructor
    function new (string name="coverage_snoop_serv_proc_seq");
        super.new(name);
    endfunction : new

    

    virtual task body();
       
        // generating requests at cache boundaries
        //diabaling contraints : trans.cache_bdry_addr.constraint_mode(0)
       // looping 4 times to reach all processors
       
        repeat (1)
        begin
             // looping 4 times to reach all addresses. 
           
                       
            // read
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            address_track_0 = trans.address;
            //read
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            address_track_1 = trans.address;
            
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            address_track_2 = trans.address;
            
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{ access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            address_track_3 = trans.address;

            //////***cpu0****/////
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })

            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })

            // cpu1
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })

            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })

            //cpu2
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })

            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_3; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })

            //cpu3
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[3],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == READ_REQ; })

            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[0],{address == address_track_0; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[1],{address == address_track_1; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })
            `uvm_do_on_with(trans, p_sequencer.cpu_seqr[2],{address == address_track_2; access_cache_type == DCACHE_ACC; request_type == WRITE_REQ; })


           
        end
    endtask

endclass : coverage_snoop_req_proc_seq
