
`define HADDR_SIZE 8
`define HDATA_SIZE 32
interface ahb_intf (input logic HCLK, input logic HRESETn);
  

  //AHB Slave Interfaces (receive data from AHB Masters)
  //AHB Masters connect to these ports
  logic                       HSEL;
  logic      [`HADDR_SIZE-1:0] HADDR;
  logic      [`HDATA_SIZE-1:0] HWDATA;
  logic      [`HDATA_SIZE-1:0] HRDATA;
  logic                       HWRITE;
  logic      [           2:0] HSIZE;
  logic      [           2:0] HBURST;
  logic      [           3:0] HPROT;
  logic      [           1:0] HTRANS;
  logic                       HREADYOUT;
  logic                       HREADY;
  logic                       HRESP;
  
  
  clocking cb_driver @(posedge HCLK);
  
    default input #1 output #1;
    output HSEL;
    output HADDR;
    output HWDATA;
    output HWRITE;
    output HSIZE;
    output HBURST;
    output HPROT;
    output HTRANS;
    output HREADY;
    input  HRDATA;
    input  HREADYOUT;
    input  HRESP;
    
  endclocking
  
  
  clocking cb_monitor @(posedge HCLK);
  
    default input #1 output #1;
    
    input  HSEL;
    input  HADDR;
    input  HWDATA;
    input  HWRITE;
    input  HSIZE;
    input  HBURST;
    input  HPROT;
    input  HTRANS;
    input  HREADY;
    input  HRDATA;
    input  HREADYOUT;
    input  HRESP;
    
  endclocking
  
  modport DRIVER  (clocking cb_driver, input HCLK, input HRESETn);

  modport MONITOR (clocking cb_monitor, input HCLK, input HRESETn);
  
  
endinterface
