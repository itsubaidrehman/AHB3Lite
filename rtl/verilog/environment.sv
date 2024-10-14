//`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "interface.sv"

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  mailbox #(transaction) mbx_gd;
  mailbox #(transaction) mbx_ms;
  
  
  event ended;
  event drv_done;
  event mon_done;
  event sco_next;
  
  virtual ahb_intf vif;
  
  function new(virtual ahb_intf vif);
    this.vif = vif;
    
    mbx_gd = new();
    mbx_ms = new();
    gen = new(mbx_gd, ended, sco_next);
    drv = new(mbx_gd, vif,drv_done);
    mon = new(mbx_ms, vif, drv_done);
    sco = new(mbx_ms, sco_next);
    
  endfunction
  
  task pre_test();
   drv.reset();
  endtask
  
  task test();
    fork
      gen.main();
       drv.main();
       mon.main();
       sco.main();

    join_any
    
  endtask
  
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.no_transactions);
    wait(gen.repeat_count == sco.no_transactions);
    $display("No of Transactions : %0d, No of Pass : %0d, No of Fail : %0d", gen.repeat_count, sco.pass, sco.fail);
    if (gen.repeat_count == sco.pass) begin
      $display("Test Passed");
    end
    else begin
      $display("Test Failed");
    end
  endtask
  
  
  task main();
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
  
endclass
