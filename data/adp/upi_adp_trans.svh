`ifndef UPI_ADP_TRANS__SVH
`define UPI_ADP_TRANS__SVH

class upi_adp_req extends uvm_sequence_item;


endclass : upi_adp_req


class upi_adp_rsp extends uvm_sequence_item;


endclass : upi_adp_rsp


class upi_adp_mreq extends upi_ad_req;


endclass : upi_adp_mreq

class upi_adp_mrsp extends upi_adp_rsp;

	realtime stime;
	realtime etime;

endclass : upi_adp_mrsp

`endif // UPI_ADP_TRANS__SVH
