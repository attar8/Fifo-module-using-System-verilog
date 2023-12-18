interface fifo_interface(input bit clk,rst);
  logic wr_en,rd_en,full,empty;
  logic [7:0]data_in;
  logic [3:0] rd_ptr;
  logic [3:0] wr_ptr;
  logic [7:0] data_out;
  
  clocking driver_cb@(posedge clk);
    default input #0 output #0;
    
    output wr_en,rd_en,data_in;
    input full,empty,data_out;
  endclocking
  
  clocking imon_cb@(posedge clk);
    default input #0 output #0;
    input rd_en,wr_en,data_in,rst;
  endclocking
  
  clocking omon_cb@(posedge clk);
    default input #0 output #0;
    input rd_en,full,empty, data_out;
  endclocking
  
  modport DRIVER(clocking driver_cb,input clk,rst);
  modport IMON(clocking imon_cb,input clk,rst);
  modport OMON(clocking omon_cb,input clk,rst);
    
endinterface
      
    
    
  
  
    
  
  