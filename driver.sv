class driver;
  
  transaction trans;
  mailbox #(transaction) mbox;
  virtual fifo_interface.DRIVER vif_drv;
  
  int no_of_trans_recvd;
  int wr_trans,rd_trans;
  
  function new(input mailbox #(transaction) mbox_in,
               input virtual fifo_interface.DRIVER vif_in);
    mbox=mbox_in;
    vif_drv = vif_in;
    if(vif_drv==null)
      $display("[DRIVER] FATAL interafce handle not set");
  endfunction
  
  virtual task run;
    $display("@%0t [DRIVER] run started \n",$time);
    wait(!fifo_top.rst);
    while(1)
      begin
         mbox.get(trans);
         no_of_trans_recvd++;
        $display("@%0t Driver run inside\n",$time);
           
      drive_to_design();
         
      end
  endtask
  
  task drive_to_design();
    @(vif_drv.driver_cb);
    vif_drv.driver_cb.wr_en   <= trans.wr_en;
    vif_drv.driver_cb.rd_en   <= trans.rd_en;
    vif_drv.driver_cb.data_in <= trans.data_in;
    
    if(trans.wr_en==1 && trans.rd_en==0)
      begin
        $display("@%0t [DRIVER] write operation trans no=%0d data_in=%0d,write=%d,Read=%d\n",$time,no_of_trans_recvd,trans.data_in,trans.wr_en,trans.rd_en);  
        wr_trans=wr_trans+1;
      end
    else if(trans.wr_en==0 && trans.rd_en==1)
      begin       
        $display("@%0t [DRIVER] Read operation trans no=%0d data_in=%0d,write=%d,Read=%d\n",$time,no_of_trans_recvd,trans.data_in,trans.wr_en,trans.rd_en);
        rd_trans=rd_trans+1;
      end
  endtask
endclass