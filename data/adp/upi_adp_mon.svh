`ifndef UPI_ADP_MON__SVH
`define UPI_ADP_MON__SVH

class upi_adp_mon #(type REQ,RSP) extends uvm_monitor #(REQ,RSP);

	REQ req;

	RSP rsp;

	`uvm_component_utils(upi_adp_mon)

	// constructor
	function new (string name = "upi_adp_mon", uvm_component parent = null); super.new(name,parent); endfunction


	/******************************************************************************************************/
	// key features for audio data process
	// sample frequence
	// audio data, the audio data of each frame.
	// sampling time that record the start time and end time of each BIC trans.
	//
	/******************************************************************************************************/


endclass : upi_adp_mon

`endif // upi_adp_mon__svh
