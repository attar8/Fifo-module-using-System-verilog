// Code your testbench here
// or browse Examples

module fifo_top;
  
`include "fifo_interface.sv"
`include "program.sv"


 bit clk,rst;
 
 initial
   begin
     clk=0;
     forever #10 clk=~clk;
   end
   
  initial
    begin
      
      $display("****************************RESETTING FIFO***********************************");
      rst<=1;
               @(posedge clk)
               rst<=0;
               @(posedge clk)
               rst<=0;
               end
               
               fifo_interface fifoif(clk,rst);
               
  fifo duv(.clk(clk),.rst(rst),.rd_en(fifoif. rd_en),.wr_en(fifoif.wr_en),.data_in(fifoif.data_in),.full(fifoif.full),.empty(fifoif.empty),.data_out(fifoif.data_out));
               
  program_fifo pgb(fifoif);
  
 endmodule