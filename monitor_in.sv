class monitor_in;
  int no_of_trans_recvd;
  logic [7:0] fifo_queue [$];
  transaction trans;
  virtual fifo_interface.IMON vif_imon;
  mailbox #(transaction) mbox;
  int no_of_empty,no_of_full;
  
  int wr_no_of_trans_recvd;
  int rd_no_of_trans_recvd;
  
  function new(input mailbox #(transaction) mbox_in,input virtual fifo_interface.IMON vif_in);
    mbox=mbox_in;
    vif_imon=vif_in;
    if(this.vif_imon==null)
      $display("[MONIN] Interface handle not set");
  endfunction
  
  task run();
    trans=new;
    $display("@%0t [MONIN] run started\n",$time);
    while(1)
       begin
         no_of_trans_recvd++; 
         fork
          begin
 full_empty();
          end
          
      // no_of_trans_recvd++;
      begin
        @(vif_imon.imon_cb);
        trans=new;
       
       trans.data_in   = vif_imon.imon_cb.data_in;
       trans.wr_en     = vif_imon.imon_cb.wr_en;
       trans.rd_en     = vif_imon.imon_cb.rd_en;
      
      
        if(vif_imon.imon_cb.wr_en==1 && vif_imon.imon_cb.rd_en==0)
          begin
          
            fifo_queue.push_back(vif_imon.imon_cb.data_in); 
              wr_no_of_trans_recvd++;
            $display("@%0t [MONIN WRITE] transaction no=%0d data_in=%0p\n", $time,no_of_trans_recvd,fifo_queue); 
            $display("****************");
          end
        
       else if (vif_imon.imon_cb.rd_en==1 && vif_imon.imon_cb.wr_en==0 )
          begin
            rd_no_of_trans_recvd++;
            trans.data_out_monin=fifo_queue.pop_front();
            $display("@%0t [MONIN read] transaction no=%0d data_out_monin=%0d\n", $time,no_of_trans_recvd,trans.data_out_monin);
 			$display("****************");
           
          end
       
      end
        mbox.put(trans);
		 join 
       
        end
    $display("@%0t [MONIN] run ended \n",$time);
         
  endtask
          
 task full_empty();
   if(fifo_queue.size==0)
              begin
                trans.full_monin=0;
                trans.empty_monin=1;
                no_of_empty++;
                $display("@%0t [full_emp] full=%0d empty=%0d",$time,trans.full_monin,trans.empty_monin);
              end
            else if(fifo_queue.size==6'd32)
              begin
                trans.full_monin=1;
                trans.empty_monin=0;
                no_of_full++;
                $display("@%0t [full_emp] full=%0d empty=%0d",$time,trans.full_monin,trans.empty_monin);
              end
            else
              begin
                trans.full_monin=0;
                trans.empty_monin=0;
                $display("@%0t [full_emp] full=%0d empty=%0d",$time,trans.full_monin,trans.empty_monin);
              end
endtask
endclass