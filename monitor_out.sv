class monitor_out ;
  
int no_of_trans_recvd;
transaction trans;

virtual fifo_interface.OMON vif_omon;
mailbox #(transaction) mbox;

function new (input mailbox #(transaction) mbox_in,
              input virtual fifo_interface.OMON vif_in);
  mbox = mbox_in;
  vif_omon = vif_in;
endfunction

task run();
$display("@%0t [MONOUT] run started\n",$time); 
  @(vif_omon.omon_cb);
	trans=new;
  while(1)
    begin
      @(vif_omon.omon_cb);
	  trans.data_out  = vif_omon.omon_cb.data_out;
      trans.full      = vif_omon.omon_cb.full;
      trans.empty      = vif_omon.omon_cb.empty;
      
      no_of_trans_recvd++;
      $display("@%0t [MONOUT] Transaction no=%0d to scb with data_out=%0d rd_en=%0d",$time,no_of_trans_recvd,vif_omon.omon_cb.data_out,vif_omon.omon_cb.rd_en);
      mbox.put(trans);
	end

  $display("@%0t [MONOUT] run ended \n",$time);
endtask

endclass
