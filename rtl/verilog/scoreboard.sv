`define HADDR_SIZE 16
`define HDATA_SIZE 32

class scoreboard;

  mailbox #(transaction) mbx_ms;
  transaction tr;
  int no_transactions;
  event sco_next;

  int pass;
  int fail;
  int i;
  logic [31:0] mem_array [256];

  function new(mailbox #(transaction) mbx_ms, event sco_next);
    this.mbx_ms = mbx_ms;
    this.sco_next = sco_next;
    $readmemh( "mem_init.mem", mem_array);
  endfunction


  task main();

    forever begin

      mbx_ms.get(tr);

      if (tr.HSEL) begin
        $display("HSEL is set - slave is connected");
      
        if (tr.HREADY) begin
          $display("HREADY is set, ready to transfer the data");
          
          if (tr.HPROT) begin
            $display("Data Transfer is protected");
            
            if (tr.HTRANS == 0) begin
              $display("IDLE state, No Transfer Required");
              if (tr.HRDATA == 32'hffffffff) begin
                $display("Idle state test passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
                pass++;
              end
              else begin
                $display("Idle state test Failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
                fail++;
              end
      
              
            end
      
            else if (tr.HTRANS == 1) begin
              $display("BUSY Transfer State, Not Ready to Accept Data");
              if (tr.HRDATA == 32'hffffffff) begin
                $display("Busy State test passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
                pass++;
              end
              else begin
                $display("Busy state test Failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
                fail++;
              end
            end
      
              // if (tr.HRESP == 0) begin
              //   $display("BUSY transfer state successful");
              //   pass++;
              // end
              // else begin
              //   $display("BUSY transfer state Failed");
              //   fail++;
              // end
            
      
            else begin
              if (tr.HWRITE)  begin
                case (tr.HSIZE)
      
                  3'b000: begin
                    if (tr.HADDR[1:0] == 0) begin
                      mem_array[tr.HADDR][7:0] = tr.HWDATA[7:0];
                      if (tr.HWDATA[7:0] == mem_array[tr.HADDR][7:0]) begin
                        $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HWDATA[7:0]);
                        pass++;
                      end
                      else begin
                        $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HWDATA[7:0]);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 1) begin
                      mem_array[tr.HADDR][15:8] = tr.HWDATA[15:8];
                      if (tr.HWDATA[15:8] == mem_array[tr.HADDR][15:8]) begin
                        $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HWDATA[15:8]);
                        pass++;
                      end
                      else begin
                        $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HWDATA[15:8]);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 2) begin
                      mem_array[tr.HADDR][23:16] = tr.HWDATA[23:16];
                      if (tr.HWDATA[23:16] == mem_array[tr.HADDR][23:16]) begin
                        $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HWDATA[23:16]);
                        pass++;
                      end
                      else begin
                        $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HWDATA[23:16]);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 3) begin
                      mem_array[tr.HADDR][31:24] = tr.HWDATA[31:24];
                      if (tr.HWDATA[31:24] == mem_array[tr.HADDR][31:24]) begin
                        $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HWDATA[31:24]);
                        pass++;
                      end
                      else begin
                        $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HWDATA[31:24]);
                        fail++;
                      end
                    end
                  
                  end
      
                  3'b001: begin
                    if (tr.HADDR[1] == 0) begin
                      mem_array[tr.HADDR][15:0] = tr.HWDATA[15:0];
                      if (tr.HWDATA[15:0] == mem_array[tr.HADDR][15:0]) begin
                        $display("Write test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HWDATA[15:0]);
                        pass++;
                      end
                      else begin
                        $display("Write test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HWDATA[15:0]);
                        fail++;
                      end
                    end
                    if (tr.HADDR[1] == 1) begin
                      mem_array[tr.HADDR][31:16] = tr.HWDATA[31:16];
                      if (tr.HWDATA[31:16] == mem_array[tr.HADDR][31:16]) begin
                        $display("Write test for half word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HWDATA[31:16]);
                        pass++;
                      end
                      else begin
                        $display("Write test for half word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HWDATA[31:16]);
                        fail++;
                      end
                    end
                  end
      
                  3'b010: begin
                    mem_array[tr.HADDR][31:0] = tr.HWDATA[31:0];
                    if (tr.HWDATA[31:0] == mem_array[tr.HADDR][31:0]) begin
                      $display("Write test for word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR], tr.HWDATA);
                      pass++;
                    end
                    else begin
                      $display("Write test for word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR], tr.HWDATA);
                      fail++;
                    end
                  end
                endcase
              end
      
              else begin
                case (tr.HSIZE)
      
                  3'b000: begin
      
                    if (tr.HADDR[1:0] == 0) begin
                      if (mem_array[tr.HADDR][7:0] == tr.HRDATA[7:0]) begin
                        $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HRDATA);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 1) begin
                      if (mem_array[tr.HADDR][15:8] == tr.HRDATA[15:8]) begin
                        $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HRDATA);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 2) begin
                      if (mem_array[tr.HADDR][23:16] == tr.HRDATA[23:16]) begin
                        $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HRDATA);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[1:0] == 3) begin
                      if (mem_array[tr.HADDR][31:24] == tr.HRDATA[31:24]) begin
                        $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HRDATA);
                        fail++;
                      end
                    end
      
                    
                  end
      
                  3'b001: begin
                    if (tr.HADDR[0] == 0) begin
                      if (mem_array[tr.HADDR][15:0] == tr.HRDATA[15:0]) begin
                        $display("Read test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HRDATA);
                        fail++;
                      end
                    end
      
                    if (tr.HADDR[0] == 1) begin
                      if (mem_array[tr.HADDR][31:16] == tr.HRDATA[31:16]) begin
                        $display("Read test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HRDATA);
                        pass++;
                      end
                      else begin
                        $display("Read test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HRDATA);
                        fail++;
                      end
                    end
      
      
                  end
      
                  3'b010: begin
                    if (mem_array[tr.HADDR][31:0] == tr.HRDATA[31:0]) begin
                      $display("Read test for word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:0], tr.HRDATA[31:0]);
                      pass++;
                    end
                    else begin
                      $display("Read test for word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:0], tr.HRDATA[31:0]);
                      fail++;
                    end
                  end
                endcase
              end  // hwrite - 0
            end // htrans - 1 or 2

          end // HPROT - 1
          else begin
            $display("Data is not protected");
            pass++;
          end // HPROT - 0
        end   // HREADY - 1
        else begin
          $display("Slave is not ready yet, wait state");
          if (tr.HRDATA == 32'hffffffff) begin
            $display("Hready not test passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
            pass++;
          end
          else begin
            $display("Hready not test Failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",tr.HADDR,32'hf,tr.HRDATA);
            fail++;
          end
          
        end  // HREADY - 0
      end  // HSEL - 1
      else begin
        $display("Slave is not selected, transaction can not happen");
        pass++;
      end // HSEL - 0


      no_transactions++;
      -> sco_next;

    end  // forever begin end

    
  endtask



endclass














































// if (tr.HTRANS == 0) begin
//   $display("IDLE transfer state");
//   pass++;

//   // if (tr.HRESP == 0) begin
//   //   $display("IDLE transfer state successful");
//   //   pass++;
//   // end
//   // else begin
//   //   $display("IDLE transfer state Failed");
//   //   fail++;
//   // end
// end

// else if (tr.HTRANS == 1) begin
//   $display("BUSY transfer state");
//   pass++;
// end

//   // if (tr.HRESP == 0) begin
//   //   $display("BUSY transfer state successful");
//   //   pass++;
//   // end
//   // else begin
//   //   $display("BUSY transfer state Failed");
//   //   fail++;
//   // end


// else begin
//   if (tr.HWRITE)  begin
//     case (tr.HSIZE)

//       3'b000: begin
//         if (tr.HADDR[1:0] == 0) begin
//           mem_array[tr.HADDR][7:0] = tr.HWDATA[7:0];
//           if (tr.HWDATA[7:0] == mem_array[tr.HADDR][7:0]) begin
//             $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HWDATA[7:0]);
//             pass++;
//           end
//           else begin
//             $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HWDATA[7:0]);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 1) begin
//           mem_array[tr.HADDR][15:8] = tr.HWDATA[15:8];
//           if (tr.HWDATA[15:8] == mem_array[tr.HADDR][15:8]) begin
//             $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HWDATA[15:8]);
//             pass++;
//           end
//           else begin
//             $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HWDATA[15:8]);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 2) begin
//           mem_array[tr.HADDR][23:16] = tr.HWDATA[23:16];
//           if (tr.HWDATA[23:16] == mem_array[tr.HADDR][23:16]) begin
//             $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HWDATA[23:16]);
//             pass++;
//           end
//           else begin
//             $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HWDATA[23:16]);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 3) begin
//           mem_array[tr.HADDR][31:24] = tr.HWDATA[31:24];
//           if (tr.HWDATA[31:24] == mem_array[tr.HADDR][31:24]) begin
//             $display("Write test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HWDATA[31:24]);
//             pass++;
//           end
//           else begin
//             $display("Write test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HWDATA[31:24]);
//             fail++;
//           end
//         end
      
//       end

//       3'b001: begin
//         if (tr.HADDR[0] == 0) begin
//           mem_array[tr.HADDR][15:0] = tr.HWDATA[15:0];
//           if (tr.HWDATA[15:0] == mem_array[tr.HADDR][15:0]) begin
//             $display("Write test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HWDATA[15:0]);
//             pass++;
//           end
//           else begin
//             $display("Write test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HWDATA[15:0]);
//             fail++;
//           end
//         end
//         if (tr.HADDR[0] == 1) begin
//           mem_array[tr.HADDR][31:16] = tr.HWDATA[31:16];
//           if (tr.HWDATA[31:16] == mem_array[tr.HADDR][31:16]) begin
//             $display("Write test for half word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HWDATA[31:16]);
//             pass++;
//           end
//           else begin
//             $display("Write test for half word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HWDATA[31:16]);
//             fail++;
//           end
//         end
//       end

//       3'b010: begin
//         mem_array[tr.HADDR][31:0] = tr.HWDATA[31:0];
//         if (tr.HWDATA[31:0] == mem_array[tr.HADDR][31:0]) begin
//           $display("Write test for word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR], tr.HWDATA);
//           pass++;
//         end
//         else begin
//           $display("Write test for word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR], tr.HWDATA);
//           fail++;
//         end
//       end
//     endcase
//   end

//   else begin
//     case (tr.HSIZE)

//       3'b000: begin

//         if (tr.HADDR[1:0] == 0) begin
//           if (mem_array[tr.HADDR][7:0] == tr.HRDATA[7:0]) begin
//             $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][7:0], tr.HRDATA);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 1) begin
//           if (mem_array[tr.HADDR][15:8] == tr.HRDATA[15:8]) begin
//             $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:8], tr.HRDATA);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 2) begin
//           if (mem_array[tr.HADDR][23:16] == tr.HRDATA[23:16]) begin
//             $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][23:16], tr.HRDATA);
//             fail++;
//           end
//         end

//         if (tr.HADDR[1:0] == 3) begin
//           if (mem_array[tr.HADDR][31:24] == tr.HRDATA[31:24]) begin
//             $display("Read test for byte passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for byte failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:24], tr.HRDATA);
//             fail++;
//           end
//         end

        
//       end

//       3'b001: begin
//         if (tr.HADDR[0] == 0) begin
//           if (mem_array[tr.HADDR][15:0] == tr.HRDATA[15:0]) begin
//             $display("Read test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][15:0], tr.HRDATA);
//             fail++;
//           end
//         end

//         if (tr.HADDR[0] == 1) begin
//           if (mem_array[tr.HADDR][31:16] == tr.HRDATA[31:16]) begin
//             $display("Read test for halfword passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HRDATA);
//             pass++;
//           end
//           else begin
//             $display("Read test for halfword failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:16], tr.HRDATA);
//             fail++;
//           end
//         end


//       end

//       3'b010: begin
//         if (mem_array[tr.HADDR][31:0] == tr.HRDATA[31:0]) begin
//           $display("Read test for word passed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:0], tr.HRDATA[31:0]);
//           pass++;
//         end
//         else begin
//           $display("Read test for word failed Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h", tr.HADDR, mem_array[tr.HADDR][31:0], tr.HRDATA[31:0]);
//           fail++;
//         end
//       end
//     endcase
//   end  // hwrite - 0
// end // htrans - 1 or 2


















