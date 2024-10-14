`include "environment.sv"
program test(ahb_intf vif);
  
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

      case (count)
        0 :  begin
          HADDR = 16'h58;
          HTRANS = 2;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 1;
        end
        1 : begin
          HADDR = 16'h5c;
          HTRANS = 3;
          HBURST = 2;
          HREADY = 0;
          HWRITE = 1;
        end
        2 : begin
          HADDR = 16'h5c;
          HTRANS = 3;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 1;
        end
        3 : begin
          HADDR = 16'h60;
          HTRANS = 3;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 1;
        end
        4 : begin
          HADDR = 16'h64;
          HTRANS = 3;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 1;
        end
        5 : begin
          HADDR = 0;
          HTRANS = 2;
          HBURST = 0;
          HREADY = 1;
          HWRITE = 1;
        end
        6 :  begin
          HADDR = 16'h58;
          HTRANS = 2;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 0;
        end
        7 : begin
          HADDR = 16'h5c;
          HTRANS = 3;
          HBURST = 2;
          HREADY = 1;
          HWRITE = 0;
        end
        
      endcase
     
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
    env.gen.repeat_count = 8;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.main();
  end
endprogram
