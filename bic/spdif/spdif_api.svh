`ifndef SPDIF_API__SVH
`define SPDIF_API__SVH


/*************************************************************************************************************************
the api file providing all valid information to UPI package that will be used.
*************************************************************************************************************************/

class spdif_api extends bic_api;


	`uvm_object_utils(spdif_api)

	// constructor
	function new (string name = "spdif_api"); super.new(name); endfunction

	// Func:
	//

endclass : spdif_api

`endif // SPDIF_API__SVH
