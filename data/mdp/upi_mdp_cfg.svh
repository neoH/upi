`ifndef UPI_MDP_CFG__SVH
`define UPI_MDP_CFG__SVH

class upi_mdp_cfg #(AW,DW) extends uvm_object;


	// ---------------------------------------------------------------------------- //
	// ---- CFG: upi_mdp_bic
	// the bic set for mdp component.
	//
	upi_mdp_bic #(AW,DW) __bic__;


	// ---------------------------------------------------------------------------- //
	// ---- CFG: ahbls_if
	virtual ahbl_slv_ifc #(AW,DW) ahbls_if;

	// ---------------------------------------------------------------------------- //




	`uvm_object_utils(upi_mdp_cfg#(AW,DW))


	// construction
	function new (string name = "upi_mdp_cfg");
		super.new(name);

		// create __bic__ enable
		__bic__ = upi_mdp_bic#(AW,DW)::type_id::create("__bic__");

	endfunction


endclass : upi_mdp_cfg

`endif // UPI_MDP_CFG__SVH
