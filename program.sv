`include "test.sv"

program program_fifo(fifo_interface vif);
  
  test_fifo test;
  fifo_test_wr_rd  test_wr_rd;
  fifo_test_wr0_rd0 test_wr0_rd0;
  
  initial
    begin
      $display("@%0t [Prg] simulation started",$time);
      test=new(vif.DRIVER,vif.IMON,vif.OMON);
      test.run();
      $display("@%0t [Prg] simulation finished",$time);
      
      
   	 $display("@%0t [Prg_wr_rd] simulation started",$time);
     test_wr_rd=new(vif.DRIVER,vif.IMON,vif.OMON);
     test_wr_rd.run();
	 $display("@%0t [Prg_wr_rd] simulation finished",$time);
      
      $display("@%0t [Prg_wr0_rd0] simulation started",$time);
      test_wr0_rd0=new(vif.DRIVER,vif.IMON,vif.OMON);
	  test_wr0_rd0.run();
      $display("@%0t [Prg_wr0_rd0] simulation finished",$time);
      $finish;
      
    end
endprogram
          