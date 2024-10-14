`include "environment.sv"
program test(ahb3_intf vif);
  
  class my_trans extends transaction;
    bit [3:0] count;
    function void pre_randomize();
      HADDR.rand_mode(0);
      HSEL.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HBURST.rand_mode(0);
      HREADY.rand_mode(0);
      HWRITE.rand_mode(0);
      HSEL = 1;
      HSIZE = 2;
      HTRANS = 2;
      HBURST = 0;
      HREADY = 1;

      if (count % 2 == 0) begin
        HADDR = count*2;
        HWRITE = 1;
      end
      else begin
        HWRITE = 0;
      end
      count++;
    endfunction
  endclass

  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(vif);
    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 20;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.main();
  end
endprogram
