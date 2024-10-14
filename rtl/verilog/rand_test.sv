//-------------------------------------------------------------------------
`include "environment.sv"
program test(ahb_intf vif);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(vif);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 10;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.main();
  end
endprogram
