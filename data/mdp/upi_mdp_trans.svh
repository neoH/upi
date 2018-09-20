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

class upi_mdp_mi #(type AW,DW) extends uvm_sequence_item;

	// the start address of this transaction.
	rand bit [AW-1:0] addr;

	// dat, the data information of current trans
	rand bit [DW-1:0] dat;

	// valid data length of this transaction, as byte unit.
	rand uint32_t len;

	// read or write type of this transaction.
	rand access_type_enum rw;

	// the start and end time from BIC recording
	time stime;
	time etime;

	`uvm_object_utils_begin(upi_mdp_mi#(AW,DW))
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(dat,UVM_ALL_ON)
		`uvm_field_int(len,UVM_ALL_ON)
		`uvm_field_enum(access_type_enum,rw,UVM_ALL_ON)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end

	// constructor
	function new (string name = "upi_mdp_mi"); super.new(name); endfunction

endclass : upi_mdp_mi

// for MDP, the mo trans equals to the mi trans.
class upi_mdp_mo #(type AW,DW) extends upi_mdp_mi #(AW,DW);

	`uvm_object_utils_begin(upi_mdp_mo#(AW,DW))
	`uvm_object_utils_end

	// constructor
	function new (string name = "upi_mdp_mo"); super.new(name); endfunction

endclass : upi_mdp_mo

`endif // UPI_MDP_TRANS__SVH
