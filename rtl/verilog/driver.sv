`define DRIV_INTF vif.DRIVER.cb_driver
//`include "interface.sv"
class driver;
  
  int no_transactions;
  
  mailbox #(transaction) mbx_gd;
  virtual ahb_intf vif;
  event drv_done;
  
  
  function new(mailbox #(transaction) mbx_gd, virtual ahb_intf vif,event drv_done);
    this.mbx_gd = mbx_gd;
    this.vif = vif;
    this.drv_done = drv_done;
    
  endfunction
  
  task reset();
    
    
    wait(!vif.HRESETn);
    $display("Reset Started : %0t", $time);
    `DRIV_INTF.HSEL <= 0;
    `DRIV_INTF.HADDR <= 0;
    `DRIV_INTF.HWDATA <= 0;
    `DRIV_INTF.HWRITE <= 0;
    `DRIV_INTF.HSIZE <= 0;
    `DRIV_INTF.HBURST <= 0;
    `DRIV_INTF.HPROT <= 0;
    `DRIV_INTF.HTRANS <= 0;
    `DRIV_INTF.HREADY <= 0;
    wait(vif.HRESETn);
    $display("Reset Done : %0t", $time);
    
  endtask
  

  task drive();
      transaction tr;
      tr = new();
      mbx_gd.get(tr);
      `DRIV_INTF.HSEL   <= tr.HSEL;
      `DRIV_INTF.HWRITE <= tr.HWRITE;
      `DRIV_INTF.HSIZE  <= tr.HSIZE;
      `DRIV_INTF.HBURST <= tr.HBURST;
      `DRIV_INTF.HPROT  <= tr.HPROT;
      `DRIV_INTF.HTRANS <= tr.HTRANS;
      `DRIV_INTF.HREADY <= tr.HREADY;

      //@(posedge vif.DRIVER.HCLK);
      `DRIV_INTF.HADDR <= tr.HADDR;
      if(tr.HWRITE) begin
        `DRIV_INTF.HWRITE <= tr.HWRITE;
        @(posedge vif.DRIVER.HCLK);
        `DRIV_INTF.HWDATA <= tr.HWDATA;
        $display("\tHADDR = %0h \tHWDATA = %0h", tr.HADDR, tr.HWDATA);
        //@(posedge vif.DRIVER.HCLK);
      end
      else begin
        `DRIV_INTF.HWRITE <= tr.HWRITE;
        // @(posedge vif.DRIVER.HCLK);
        // `DRIV_INTF.HWRITE <= 0;
        @(posedge vif.DRIVER.HCLK);
        tr.HRDATA <= `DRIV_INTF.HRDATA;
        $display("\tHADDR = %0h \tHRDATA = %0h", tr.HADDR, `DRIV_INTF.HRDATA);
      end

      tr.print_trans("DRV");
      no_transactions++;
      $display("%0d", no_transactions);
      -> drv_done;
  endtask

  
  task main;
    forever begin
      fork
        begin
          wait(vif.HRESETn);
        end
        begin
          forever
            drive();
        end
      join
      disable fork;
    end
  endtask
        
  
  
endclass

















































 // task drive();
  //     transaction tr;
  //     tr = new();
      
  //     mbx_gd.get(tr);

  //      //@(mon_done);
  //     `DRIV_INTF.HSEL   <= tr.HSEL;
  //     `DRIV_INTF.HWRITE <= tr.HWRITE;
  //     `DRIV_INTF.HSIZE  <= tr.HSIZE;
  //     `DRIV_INTF.HBURST <= tr.HBURST;
  //     `DRIV_INTF.HPROT  <= tr.HPROT;
  //     `DRIV_INTF.HTRANS <= tr.HTRANS;
  //     `DRIV_INTF.HREADY <= tr.HREADY;
  //     `DRIV_INTF.HADDR  <= tr.HADDR;
  //      @(posedge vif.DRIVER.HCLK);
  //     `DRIV_INTF.HWDATA <= tr.HWDATA;

  //      //$display("Transaction received in driver from Generator");
  //      tr.print_trans("DRV");
  //      $display("\tADDR = %0d \tWDATA = %d",tr.HADDR,tr.HWDATA);
  //      no_transactions++;
       
       
  //      //$display("%0d", no_transactions);
  //      -> drv_done;
       
  // endtask
