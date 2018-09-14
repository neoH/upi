`ifndef SPDIF_TRANS__SVH
`define SPDIF_TRANS__SVH

/*****************************************************************************************************
*****************************************************************************************************/

class spdif_req extends uvm_sequence_item;

	/*
		spdif request transaction definition, will describe the output transaction features. One transaction
		indicates one sub-frame in SPDIF protocol.
		Containing the following keys:
		-- sample frequency, taking MHz as the unit.
		-- preamble of the sub-frame
		-- aux data
		-- audio data
		-- validity flag
		-- user flag
		-- channel flag
		-- even parity flag
	*/

	rand spdif_sample_freq_enum freq;
	rand spdif_preamble_enum prea; // the preamble of spdif, valid only in B,M,W

	rand bit [3:0] aux;    // the auxility data
	rand bit [19:0] audio; // the sampled audio data
	rand bit valid;        // the validity flag data
	rand bit user;         // the user flag data
	rand bit chnl;         // the channel flag data
	rand bit ep;           // the even parity

	`uvm_object_utils_begin(spdif_req)
		`uvm_field_enum(spdif_sample_freq_enum,freq,UVM_ALL_ON)
		`uvm_field_enum(spdif_preamble_enum,prea,UVM_ALL_ON)
		`uvm_field_int(aux,UVM_ALL_ON)
		`uvm_field_int(audio,UVM_ALL_ON)
		`uvm_field_int(valid,UVM_ALL_ON)
		`uvm_field_int(user,UVM_ALL_ON)
		`uvm_field_int(chnl,UVM_ALL_ON)
		`uvm_field_int(ep,UVM_ALL_ON)
	`uvm_object_utils_end


	// constructor
	function new (string name = "spdif_req"); super.new(name); endfunction

endclass : spdif_req



class spdif_rsp extends spdif_req; // as for the response field is the same as req fields, we created the rsp trans extends from req

	`uvm_object_utils(spdif_rsp)

	// constructor
	function new (string name = "spdif_rsp"); super.new(name); endfunction

endclass : spdif_rsp

class spdif_mreq extends spdif_req;

	realtime stime;
	realtime etime;

	`uvm_object_utils_begin(spdif_mreq)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end

	// constructor
	//
	function new (string name = "spdif_mreq"); super.new(name); endfunction

endclass : spdif_mreq


class spdif_mrsp extends spdif_rsp;

	realtime stime;
	realtime etime;

	`uvm_object_utils_begin(spdif_mrsp)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end


	// constructor
	//
	function new (string name = "spdif_mrsp"); super.new(name); endfunction

endclass : spdif_mrsp


`endif // SPDIF_TRANS__SVH
