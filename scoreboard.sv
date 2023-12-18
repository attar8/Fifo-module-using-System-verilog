class scoreboard;

int total_trans_recvd;
transaction  imon_trans;
transaction  omon_trans;
mailbox #(transaction) mbox_in; //will be connected to input monitor
mailbox #(transaction) mbox_out;//will be connected to output monitorbit
bit [15:0] match;
bit [15:0] mismatch;
bit [15:0] missed;
bit [15:0] black_hole;
int wr_no_of_trans_recvd;
int rd_no_of_trans_recvd;
int i;

function new (input mailbox #(transaction) mbox_in,
              input mailbox #(transaction) mbox_out);
this.mbox_in  = mbox_in;
this.mbox_out = mbox_out;
endfunction


task run;
	$display("@%0t [SCB] run started \n",$time);
	imon_trans=new();
	omon_trans=new();	
	fork
	begin 
		while(1) 
		begin
          	mbox_out.get(omon_trans);
			rd_no_of_trans_recvd++;
			$display("@%0t [SCB_out] monout_data:%0d",$time, omon_trans.data_out);	
			
	     end 
	end 

	begin  
		while(1) 
		begin 	
			wr_no_of_trans_recvd++;
			mbox_in.get(imon_trans);
				
			$display("@%0t [SCB_in] monin_data:%0d",$time,imon_trans.data_out_monin);
			if(imon_trans.data_out_monin==omon_trans.data_out)
			begin
		  		$display("@%0t [SCB] Pass TB_data:%0d\t DUT_data:%0d",$time,imon_trans.data_out_monin,omon_trans.data_out);
		   		match=match+1;
				
		     end
			else if(imon_trans.data_out_monin!=omon_trans.data_out)
			begin
              $display("@%0t [SCB] Fail TB_data:%0d\t DUT_data:%0d",$time,imon_trans.data_out_monin,omon_trans.data_out);
		  		mismatch=mismatch+1;
			end
          else if(imon_trans.full_monin ==omon_trans.full)
            $display(" FIFO Full");
          else if (imon_trans.empty_monin == omon_trans.empty)
             $display( " FIFO Empty");
          
			
      	end 
	end 
	join
	
endtask

endclass
			
