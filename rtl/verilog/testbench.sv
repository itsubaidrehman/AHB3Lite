// Code your testbench here
// or browse Examples
//`include "environment.sv"
//`include "rand_test.sv"
//`include "test_byte.sv"
//`include "test_byte_diff.sv"
//`include "test_hw_diff.sv"
//`include "test_hw.sv"
//`include "test_w.sv"
//`include "test_rd_wr_same_addr.sv"
//`include "test_wr_rd_diff_addr.sv"
//`include "test_hprot.sv"
//`include "test_hsel.sv"
//`include "test_hready.sv"
//`include "test_idle.sv"
//`include "test_busy.sv"
//`include "test_burstinc.sv"
//`include "test_default_rd.sv"
`include "test_wr_rd_seq.sv"
//`include "test_wr_rd_nonseq.sv"
module tb;
  parameter MEM_SIZE          = 0;   //Memory in Bytes
  parameter MEM_DEPTH         = 256; //Memory depth
  parameter HADDR_SIZE        = 32;
  parameter HDATA_SIZE        = 32;
  
  bit HRESETn;
  bit HCLK;
  ahb_intf vif(HCLK, HRESETn);
  

  always begin
    //$display("HCLK : %0d", HCLK);
    #5 HCLK = ~HCLK;
             
    
  end

  //reset generation
  initial begin
    HRESETn = 0;
    #3;
    HRESETn = 1;
  end
  
  
  test t1(vif);
  
  
  ahb3lite_sram1rw #(.MEM_SIZE(MEM_SIZE), .MEM_DEPTH(MEM_DEPTH), .HADDR_SIZE(HADDR_SIZE), .HDATA_SIZE(HDATA_SIZE))
  dut (
    .HCLK(vif.HCLK),
    .HRESETn(vif.HRESETn),
    .HSEL(vif.HSEL),
    .HADDR(vif.HADDR),
    .HWDATA(vif.HWDATA),
    .HRDATA(vif.HRDATA),
    .HWRITE(vif.HWRITE),
    .HSIZE(vif.HSIZE),
    .HBURST(vif.HBURST),
    .HPROT(vif.HPROT),
    .HTRANS(vif.HTRANS),
    .HREADYOUT(vif.HREADYOUT),
    .HREADY(vif.HREADY),
    .HRESP(vif.HRESP)
  );
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
//   environment env;
//   initial begin
//     env = new(vif);
//     env.main();
//   end
  
  
  
endmodule
