`include "transaction.sv"
class generator;
  int count = 0;
  rand transaction tr;
  rand transaction trans;
  mailbox #(transaction) mbx_gd;
  event ended;
  event sco_next;
  int repeat_count;
  
  function new(mailbox #(transaction) mbx_gd, event ended, event sco_next);
    this.mbx_gd = mbx_gd;
    this.ended = ended;
    this.sco_next = sco_next;
    trans = new();
    
  endfunction
  
  task main();
    repeat (repeat_count) begin
      assert (trans.randomize()) else $error("Randomization Failed");
      tr = trans.copy();
      mbx_gd.put(tr);
      
      //mbx.put(tr);
      tr.print_trans("GEN");
      @(sco_next);
    end
    -> ended;
  endtask
  
  
endclass
