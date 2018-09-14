`ifndef UPI_MDP_TYPE__SVH
`define UPI_MDP_TYPE__SVH


typedef enum
{
	AHBL_SLV
} upi_mdp_bic_enum;

// the class object contains all support BIC type name and corresponding configure map.
//
class upi_mdp_bic #(AW = 32, DW = 32) extends uvm_object;

	upi_mdp_bic_enum  bic_t;

	`uvm_object_utils(upi_mdp_bic#(AW,DW))

	/* add supported bic: ahbl_slv */
	ahbl_slv_pkg::ahbl_slv    #(AW,DW,virtual ahbl_slv_ifc) ahbl_s;
	/*******************************/

	// constructor
	function new (string name = "upi_mdp_bic"); super.new(name); endfunction

	//

endclass : upi_mdp_bic

//////////////////////////////////////////////////////////////////////////////////////////////


`endif // UPI_MDP_TYPE__SVH
