//=====================================================================
// Project: 4 core MESI cache design
// File Name: test_lib.svh
// Description: Base test class and list of tests
// Designers: Venky & Suru
//=====================================================================
//TODO: add your testcase files in here
`include "base_test.sv"
`include "read_miss_icache.sv"      //dones
`include "write_read_dcache.sv"     //dones
`include "RAR.sv"                   //dones
`include "WAR.sv"                   //done
`include "WAW.sv"                   //dones
`include "Write_hit_read.sv"        //dones   
`include "write_read_many.sv"       //dones
//`include "write_read_icache.sv"   //dones
`include "write_tests.sv"           //dones
`include "replacement.sv"           //dones
//`include "read_misses.sv"         //dones
//`include "replacement_writes.sv"  //dones
`include "reads_cov.sv"             //dones
`include "write_cov.sv"             //dones
`include "random_write_read.sv"     //dones
`include "random_req_type_data.sv"   //done

`include "bus_req_type.sv"          //done
`include "bus_req_proc_num_cov.sv"  //done
`include "req_serv_by_cov.sv"       //done
`include "write_replacement_cov.sv" //done
`include "bus_req_snoop_cov.sv"     //done
`include "random_read_write.sv"     //dones
//`include "multi_thread.sv"

`include "read_icache.sv"       //dones

`include "cpu_monitor_coverage.sv"
`include "coverage_snoop_serv_proc.sv"
`include "coverage_snoop_req_proc.sv"
`include "coverage_evict_addr_proc.sv"





