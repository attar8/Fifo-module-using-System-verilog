class generator;
  
  int no_of_trans;
  transaction trans,ref_trans;
  
  mailbox #(transaction) mbox;
  
  function new (mailbox #(transaction) mbox_in,int gen_trans_no=1);
    no_of_trans=gen_trans_no;
    mbox      = mbox_in;
    ref_trans=new();
  endfunction
  
   task run();
    int trans_count;
    $display("@%0t [GENERATOR] Run started \n",$time);
     repeat(no_of_trans)
      begin
        assert(ref_trans.randomize());
        trans=new();
        trans.copy(ref_trans);
        mbox.put(trans);
        trans_count=trans_count+1;
        $display("@%0t [GENERATOR] Sent Transaction %0d to driver \n",$time,trans_count);
        trans.print("GENERATOR");
        end
     $display("@%0t [GENERATOR] Run ended size of mbox=%0d \n",$time,mbox.num());
  endtask
  
endclass
    