`ifndef AHBL_SLV_TRANS__SVH
`define AHBL_SLV_TRANS__SVH

/*************************************************************************************************************************
*************************************************************************************************************************/

// this transaction is for mapping the response data and information for the slave device
// user of the slave device can determin how the slave will act when getting one ahbl request. For example,
// respond OKAY or ERROR, how many cycle will be delayed, and the responding data.
// Each trans indicates each htrans in AHBL protocol.
//
/* TODO , this class may not used for current version 1.00 */
class ahbl_slv_treq #(DW = 32) extends uvm_sequence_item;

	rand uint32_t delay;  // this var indicates the delay cycle when receiving the request.
	rand bit [DW-1:0] rdata;
	rand ahbl_resp_enum resp;

	`uvm_object_utils_begin(ahbl_slv_treq)
		`uvm_field_int(delay,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_enum(ahbl_resp_enum,resp,UVM_ALL_ON)
	`uvm_object_utils_end

	// constructor
	function new (string name = "ahbl_slv_treq"); super.new(name); endfunction


endclass : ahbl_slv_treq


// monitor request trans, indicates the master request information
//
class ahbl_slv_mreq extends uvm_sequence_item;

	`uvm_object_utils(ahbl_slv_mreq)

	// constructor
	function new (string name = "ahbl_slv_mreq"); super.new(name); endfunction

endclass : ahbl_slv_mreq

class ahbl_slv_mrsp extends uvm_sequence_item;

	`uvm_object_utils(ahbl_slv_mrsp)


	// constructor
	function new (string name = "ahbl_slv_mrsp"); super.new(name); endfunction

endclass : ahbl_slv_mrsp

`endif // AHBL_SLV_TRANS__SVH
