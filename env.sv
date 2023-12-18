`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"

class env_fifo;
  
  virtual fifo_interface.DRIVER vif_drv;
  virtual fifo_interface.IMON vif_imon;
  virtual fifo_interface.OMON vif_omon;
  
  int no_of_trans;
   
  generator gen;
  driver drv;
  monitor_in monin;
  monitor_out monout;
  scoreboard scb;
  
  
  mailbox #(transaction) gen_drv_mbox;
  mailbox #(transaction) monin_scb_mbox;
  mailbox #(transaction) monout_scb_mbox;
  
  function new(input virtual fifo_interface.DRIVER drv,
               input virtual fifo_interface.IMON imon,
               input virtual fifo_interface.OMON omon,
               input int no_of_trans);
    
    vif_drv=drv;
    vif_imon=imon;
    vif_omon=omon;
    this.no_of_trans=no_of_trans;
    
  endfunction
  
  
  task build();
    $display("[Env:build] Environment build started");
    gen_drv_mbox=new;
    monin_scb_mbox=new;
    monout_scb_mbox=new;
    gen=new(gen_drv_mbox,no_of_trans);
    drv=new(gen_drv_mbox,vif_drv);
    monin=new(monin_scb_mbox,vif_imon);
    monout=new(monout_scb_mbox,vif_omon); 
    scb=new(monin_scb_mbox,monout_scb_mbox); 
    $display("[Env:build] Environment build ended");
  endtask
  
  
  task run();
     $display("@%0t [Env:run] simulation started",$time);
    build();
    gen.run();
    fork
      drv.run();
      monin.run();
      monout.run();
      scb.run();
      wait(no_of_trans==monout.no_of_trans_recvd);
    join_any
    disable fork;
    $display("@%0t [Env:run] simulation finished",$time);
    final_result();
  endtask
      
      task final_result();
        $display("Total pkts sent to DUT      = %0d",no_of_trans);
        $display("Write pkts sent to DUT      = %0d",drv.wr_trans);
        $display("Read pkts sent to DUT       = %0d",drv.rd_trans);
        $display("No_of_times full			  = %0d",scb.match);
        $display("No_of_times empty			  = %0d",scb.mismatch);
      endtask
  
endclass