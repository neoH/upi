`ifndef UPI_ADP_CFG__SVH
`define UPI_ADP_CFG__SVH


class upi_adp_cfg extends uvm_object;

	// __bic_t__
	//
	// the type selection of BIC, this cfg can only be set once when starting simulation in build phase in high level.
	// Once it is set, this value should be determined and following calls for setting this will report error.
	//
	local upi_adp_bic_enum __bic_t__ = SPDIF; // default is SPDIF

	/* configuration map for different BICs */
	// corresponding configure will got when calling set_bic function.
	//
	spdif_cfg m_spdif_cfg;


	extern function void set_bic (input string bic = "", input uvm_object _cfg = null);
	function upi_adp_bic_enum get_bic(); return __bic_t__; endfunction
	/********************************************************************************************************************************/




	`uvm_object_utils(upi_adp_cfg)

	// constructor
	function new (string name = "upi_adp_cfg"); super.new(name); endfunction

endclass : upi_adp_cfg

// out of range
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function void upi_adp_cfg::set_bic(input string bic = "", input uvm_object _cfg);

	static bit _setted = 'b0;

	if (!_setted) begin // {
		`ifdef `__DBG__
			`uvm_info(get_type_name(),$sformatf(" [__DBG__][set_bic] the bic will be changed to: %s",bic),UVM_LOW)
		`endif
		case (bic) // {
			"spdif","SPDIF": begin // {
				bic = SPDIF; // nomater user input in lowercase or uppercase, it will be recognized.
				if (!$cast(m_spdif_cfg,_cfg)) begin // {
					// assign all info to m_alm_cfg
					`uvm_fatal(get_type_name()," [ICAST][set_bic] invalid casting occurred when cast _cfg to m_alm_cfg")
				end // }
			end // }
			default: begin // {
				`uvm_fatal(get_type_name(),$sformatf(" [IBIC] invalid bic setting command detected: %s",bic))
			end // }
		endcase // }
		_setted = 'b1;
	// }
	end else begin // {
		`uvm_error(get_type_name()," [ICFG][set_bic] this function has been called illegal times, more than once.")
	end // }

	return;
endfunction : set_bic

`endif // UPI_ADP_CFG__SVH
