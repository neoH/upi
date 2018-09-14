`ifndef AHBL_MST_TRANS__SVH
`define AHBL_MST_TRANS__SVH

/*************************************************************************************************************************
*************************************************************************************************************************/

class ahbl_mst_req extends uvm_sequence_item;

	`uvm_object_utils(ahbl_mst_req)

	// constructor
	function new (string name = "ahbl_mst_req"); super.new(name); endfunction


endclass : ahbl_mst_req


class ahbl_mst_rsp extends uvm_sequence_item;

	`uvm_object_utils(ahbl_mst_rsp)


	// constructor
	function new (string name = "ahbl_mst_rsp"); super.new(name); endfunction

endclass : ahbl_mst_rsp

`endif // AHBL_MST_TRANS__SVH
