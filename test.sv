`include "env.sv"

class test_fifo;
  int no_of_trans=64;
  
  virtual fifo_interface.DRIVER vif_drv;
  virtual fifo_interface.IMON vif_imon;
  virtual fifo_interface.OMON vif_omon;
 
    env_fifo env;
  
  function new(input virtual fifo_interface.DRIVER drv,
               input virtual fifo_interface.IMON imon,
               input virtual fifo_interface.OMON omon);
    
    vif_drv=drv;
    vif_imon=imon;
    vif_omon=omon;
  endfunction
  
  virtual task run();
    $display("@%0t [Test:run] simulation started",$time);
    env=new(vif_drv,vif_imon,vif_omon,no_of_trans);
    env.build();
    env.run();
    $display("Number of transactions=%0d",no_of_trans);
    $display("@%0t [Test:run] simulation finished",$time);
  endtask
 
  
endclass

class fifo_test_wr_rd extends test_fifo;
  transaction_wr_rd trans_wr_rd;
  
  function new(input virtual fifo_interface.DRIVER drv,
               input virtual fifo_interface.IMON imon,
               input virtual fifo_interface.OMON omon);
   
	super.new(drv,imon,omon);
	endfunction


	virtual task run();
	$display("@%0t [Test-wr_rd:run] simulation started",$time);
    $display("Transactions=%d",super.no_of_trans);     
    env=new(vif_drv,vif_imon,vif_omon,super.no_of_trans);
      env.build();
	trans_wr_rd = new();
	env.gen.ref_trans = trans_wr_rd;
	env.run();
	$display("@%0t [Test-wr_rd:run] simulation finished",$time);		
	endtask

endclass


 class fifo_test_wr0_rd0 extends test_fifo;

	transaction_wr0_rd0 trans_wr0_rd0;

  function new(input virtual fifo_interface.DRIVER drv, 
							 input virtual fifo_interface.IMON imon,
							 input virtual fifo_interface.OMON omon);

	
	super.new(drv,imon,omon);
	endfunction


	virtual task run();
      
      $display("@%0t [Test-wr0_rd0:run] simulation started",$time);
    $display("Transactions=%d",super.no_of_trans);
      
    env=new(vif_drv,vif_imon,vif_omon,super.no_of_trans);
    env.build();
	trans_wr0_rd0= new();
	env.gen.ref_trans = trans_wr0_rd0;
	env.run();
      $display("@%0t [Test-wr0_rd0:run] simulation finished",$time);		
	endtask

endclass 