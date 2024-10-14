`include "environment.sv"
program test(ahb_intf vif);
  
  class my_trans extends transaction;
    bit [7:0] count;
    function void pre_randomize();
      HADDR.rand_mode(0);
      HSEL.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HBURST.rand_mode(0);
      HREADY.rand_mode(0);
      HWRITE.rand_mode(0);
      HSEL = 1;
      HTRANS = 2;
      HBURST = 0;
      HREADY = 1;
      HSIZE = 2;

      if(cnt %2 == 0) begin
        HWRITE = 1;
        HADDR  = count;      
      end 
      else begin
        HWRITE = 0;
        HADDR  = count;
        count += 4;
      end
      cnt++;
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
    env.gen.repeat_count = 4;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.main();
  end
endprogram
