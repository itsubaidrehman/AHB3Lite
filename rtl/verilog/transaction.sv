`define HADDR_SIZE 8 
`define HDATA_SIZE 32

class transaction;
  
  rand bit                  HSEL;
  rand bit [`HADDR_SIZE-1:0] HADDR;
  rand bit [`HDATA_SIZE-1:0] HWDATA;
  rand bit                  HWRITE;
  rand bit [           2:0] HSIZE;
  rand bit [           2:0] HBURST;
  rand bit [           3:0] HPROT;
  rand bit [           1:0] HTRANS;
  rand bit                  HREADY;
       bit [`HDATA_SIZE-1:0] HRDATA;
       bit                  HREADYOUT;
       bit                  HRESP;
  
  bit [1:0] cnt;
  function void print_trans (input string tag);
    $display("[%0s] - HSEL : %0d, HADDR : %0h, HWDATA : %0h, HWRITE : %0d, HSIZE : %0d, HBURST : %0d, HPROT : %0d, HTRANS : %0d, HREADY : %0d, HRDATA : %0h, HREADYOUT : %0d, HRESP : %0d", tag, HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY, HRDATA, HREADYOUT, HRESP); 
    
  endfunction
  
  constraint haddr {             
        if (HSIZE == 1) {     //hsize 1 means half word - addr should be multiple of 2
            HADDR % 2 == 0;
        }
        else if (HSIZE == 2) {  // hsize 2 means word - addr should be multiple of 4
            HADDR % 4 == 0;
        }
    }
  
 constraint burst { HBURST inside {3'b000, 3'b010, 3'b011}; }
  
 constraint protection { HPROT == 4'b0001; }
  
 constraint transfer { HSIZE inside {[0:2]}; }
  
  
  function transaction copy();
    //copy = new();
    transaction trans;
    trans = new();
    trans.HSEL = this.HSEL;
    trans.HADDR = this.HADDR;
    trans.HWDATA = this.HWDATA;
    trans.HWRITE = this.HWRITE;
    trans.HSIZE = this.HSIZE;
    trans.HBURST = this.HBURST;
    trans.HPROT = this.HPROT;
    trans.HTRANS = this.HTRANS;
    trans.HREADY = this.HREADY;
    trans.HRDATA = this.HRDATA;
    trans.HREADYOUT = this.HREADYOUT;
    trans.HRESP = this.HRESP;
    return trans;
  endfunction
 
    
endclass
