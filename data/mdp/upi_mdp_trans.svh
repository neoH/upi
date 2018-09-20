`ifndef UPI_MDP_TRANS__SVH
`define UPI_MDP_TRANS__SVH


class upi_mdp_slv_treq extends uvm_sequence_item;


	rand upi_mdp_resp_enum resp;
 	rand uint32_t len;  // if len is 0, that means current response has no response data.
	rand uvm_bitstream_t rdata; // support maximum 2049bits data
	rand uint32_t delay;

	`uvm_object_utils_begin(upi_mdp_slv_treq)
		`uvm_field_enum(upi_mdp_resp_enum,resp,UVM_ALL_ON)
		`uvm_field_int(len,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_int(delay,UVM_ALL_ON)
	`uvm_object_utils_end


	// constructor
	function new (string name = "upi_mdp_slv_treq"); super.new(name); endfunction

	//
endclass : upi_mdp_slv_treq

class upi_mdp_slv_mi extends uvm_sequence_item;

	`uvm_object_utils_begin(upi_mdp_slv_mi)
	`uvm_object_utils_end

	// constructor
	function new (string name = "upi_mdp_slv_mi"); super.new(name); endfunction

endclass : upi_mdp_slv_mi

`endif // UPI_MDP_TRANS__SVH
