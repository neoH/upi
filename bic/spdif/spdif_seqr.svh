`ifndef SPDIF_SEQR__SVH
`define SPDIF_SEQR__SVH

class spdif_seqr extends bic_seqr;


	`uvm_component_utils(spdif_seqr)

	// constructor
	function new (string name = "spdif_seqr", uvm_component parent = null); super.new(name,parent); endfunction

endclass : spdif_seqr

`endif // SPDIF_SEQR__SVH
