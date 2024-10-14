`define MON_INTF vif.MONITOR.cb_monitor
class monitor;

    
    mailbox #(transaction) mbx_ms;
    virtual ahb_intf vif;
    event drv_done;
    
    
    function new(mailbox #(transaction) mbx_ms, virtual ahb_intf vif, event drv_done);
        this.mbx_ms = mbx_ms;
        this.vif = vif;
	    this.drv_done = drv_done;
	
    endfunction


    task main();

        forever begin
            transaction tr;
            tr = new();
            @(drv_done);
            @(posedge vif.MONITOR.HCLK);
            wait(`MON_INTF.HWRITE == 0 || `MON_INTF.HWRITE == 1);
            tr.HSEL = `MON_INTF.HSEL;
            tr.HWRITE = `MON_INTF.HWRITE;
            tr.HADDR = `MON_INTF.HADDR;
            tr.HSIZE = `MON_INTF.HSIZE;
            tr.HPROT = `MON_INTF.HPROT;
            tr.HTRANS = `MON_INTF.HTRANS;
            tr.HBURST = `MON_INTF.HBURST;
            tr.HREADY = `MON_INTF.HREADY;
            tr.HREADYOUT = `MON_INTF.HREADYOUT;
            tr.HWDATA = `MON_INTF.HWDATA;
            tr.HRESP = `MON_INTF.HRESP;
            //if (`MON_INTF.HWRITE == 0) begin
                //tr.HWRITE = `MON_INTF.HWRITE;
                //@(posedge vif.MONITOR.HCLK);
                //@(posedge vif.MONITOR.HCLK);
               
                tr.HRDATA = `MON_INTF.HRDATA;
                //tr.HWDATA = `MON_INTF.HWDATA;
            //end
           
            mbx_ms.put(tr);
            tr.print_trans("MON");
        end

    endtask


endclass






















































//     task main();
//         forever begin
//             transaction tr;
//             tr = new();
//             @(drv_done);
//             tr.HSEL = `MON_INTF.HSEL;
//             tr.HWRITE = `MON_INTF.HWRITE;
//             tr.HADDR = `MON_INTF.HADDR;
//             tr.HSIZE = `MON_INTF.HSIZE;
//             tr.HPROT = `MON_INTF.HPROT;
//             tr.HTRANS = `MON_INTF.HTRANS;
//             tr.HBURST = `MON_INTF.HBURST;
//             tr.HREADY = `MON_INTF.HREADY;
//             tr.HREADYOUT = `MON_INTF.HREADYOUT;
//             tr.HRESP = `MON_INTF.HRESP;
//             if (`MON_INTF.HWRITE) begin
//                 @(posedge vif.MONITOR.HCLK);
//                 tr.HWDATA = `MON_INTF.HWDATA;
//             end
//             if (`MON_INTF.HWRITE == 0) begin
//                 @(posedge vif.MONITOR.HCLK);
//                 tr.HRDATA = `MON_INTF.HRDATA;
//             end

//             mbx_ms.put(tr);
//             tr.print_trans("MON");
            
//         end


//     endtask
