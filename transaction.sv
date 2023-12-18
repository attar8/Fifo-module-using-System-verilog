parameter DATA_WIDTH=8;
parameter ADDR_WIDTH=5;
parameter ADDR_BUS_WIDTH=4; 	
parameter MEM_SIZE=31;

class transaction;
  rand bit rd_en,wr_en;
  rand bit[7:0] data_in;
  logic [7:0] data_out;
  logic [7:0]data_out_monin;
  logic full,empty;
  logic full_monin,empty_monin;
  
  
 // constraint wr_rd_en {wr_en != rd_en;} ;
 
   constraint valid {
     data_in inside {[0:((2**(DATA_WIDTH+1)-1))]};
                        if(wr_en==0) rd_en!=0;
                        if(wr_en==1) rd_en!=1;
   }
  
  
  constraint wr_rd{wr_en dist {0:/30,1:/70};
                   rd_en dist {0:/70,1:/30};};
  
  
     virtual function void print (string s="Packet");
    $display("@%0t [%s] data=%0d,write=%d,read=%d\n",$time,s,data_in,wr_en,rd_en);
  endfunction
  
  
    virtual function void copy(transaction trans);
  if(trans==null)
      begin
        $display("[Transaction] Error Null object passed to copy method \n");
      end
    else
      begin
        this.data_in = trans.data_in;
        this.wr_en = trans.wr_en;
        this.rd_en = trans.rd_en;
      end
     endfunction
endclass

  //Reading one after other
class transaction_wr_rd extends transaction;
  
  int l_addr;
  bit count;
                    
  constraint valid {data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
                                    if(wr_en==0) rd_en!=0;
                                    if(wr_en==1)rd_en!=1;
  if(count==0) 
  {
  wr_en==1;
  rd_en==0;
  }
  else {
  wr_en==0;
  rd_en==1;
  }
  }
  
       
   function void post_randomize();
    if(l_addr<MEM_SIZE)
    count=count;
    else
    count=~count;
                                    
    if(l_addr<MEM_SIZE)
    l_addr=l_addr+1;
    else
    l_addr=0;
    endfunction
                    
    
   virtual function void copy(transaction trans);
   if(trans==null)
      begin
        $display("[Transaction] Error Null object passed to copy method \n");
      end
    else
      begin
        this.data_in = trans.data_in;
        this.wr_en = trans.wr_en;
        this.rd_en = trans.rd_en;
        
      end
     endfunction 
endclass
                    
   
//Writing into fifo and reading from fifo
class transaction_wr0_rd0 extends transaction;
   int al_addr;
   bit count;
   
  constraint valid {data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
                    if(wr_en==0) rd_en!=0;
                    if(wr_en==1)rd_en!=1;
  if(count==0) {
  wr_en==1;
  rd_en==0;
   }
 else {
 wr_en==0;
 rd_en==1;
 }
 }
   
  function void post_randomize();
        if(count==1) 
          if(al_addr==MEM_SIZE) al_addr=0;
	  else		       al_addr=al_addr+1;	
       else               al_addr=al_addr;
	count = ~count;
endfunction

                                    
     virtual function void copy (transaction trans);
       if(trans==null) 
	begin
      $display("[Transaction] Error Null object passed to copy method \n");
  end
	else 
	begin
		
		this.data_in=trans.data_in;
		this.wr_en=trans.wr_en;
		this.rd_en=trans.rd_en;
	end
endfunction
endclass