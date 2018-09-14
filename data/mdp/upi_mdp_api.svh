`ifndef UPI_MDP_API__SVH
`define UPI_MDP_API__SVH


// ---- API
function void set_bic (input string bic);
	`ifdef `__DBG__
		`uvm_info(get_type_name(),$sformatf(" [__DBG__][set_bic] the bic will be changed to: %s",bic),UVM_LOW)
	`endif

	case (bic) // {
		"ahbl_mst","AHBL_MST": begin // {
			// __bic__.bic_t = AHBL_MST; // nomater user input in lowercase or uppercase, it will be recognized.
		end // }
		"ahbl_slv","AHBL_SLV": begin // {
			// create the component instance
			m_cfg.__bic__.ahbl_s = ahbl_slv_pkg::ahbl_slv#(AW,DW,virtual ahbl_slv_ifc)::type_id::create("ahbl_s",this); // create the ahbl_slv BIC
			m_cfg.__bic__.bic_t  = AHBL_SLV;
			// to setting confirmed cfgs
			m_cfg.__bic__.ahbl_s.set_upi; // only upi mode supported here.
		end // }
		default: begin // {
			`uvm_fatal(get_type_name(),$sformatf(" [IBIC] invalid bic setting command detected: %s",bic))
		end // }
	endcase // }

	return;
endfunction : set_bic

// ---- API
// set interface handler to corresponding bic, each time add new bic, a new set function should be created.
function void set_ahbls_if;
	m_cfg.__bic__.ahbl_s.m_cfg.set_ifc(m_cfg.ahbls_if);
endfunction : set_ahbls_if

// ---- API
// the function to set the start full address and the total size in byte of this memory.
// this function valid only when this device act as a memory device, other circumstance to call
// this function will be ignored.
function bit set_addr_size(input bit [AW-1:0] lpa, input uint32_t size);
	bit [AW-1:0] upa = lpa + size; // the upper address

	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin // {
			m_cfg.__bic__.ahbl_s.add_space(lpa,upa);
		end // }
		default: begin // {
			`uvm_error(get_type_name(),$sformatf(" [IBIC][set_addr_size] this API called with invalid bic type: %s, nothing will be done.",m_cfg.__bic__.bic_t))
			return 'b1;
		end // }
	endcase // }

	return 'b0;
endfunction : set_addr_size

// ---- API: set_max_delay
// the api to set the max delay cycle for sending or receiving each transactions
//
function bit set_max_delay(input uint32_t val);
	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin // {
			m_cfg.__bic__.ahbl_s.set_max_delay(val);
		end // }
		default: begin // {
			`uvm_error(get_type_name(),$sformatf(" [IBIC][set_max_delay] this API called with invalid bic type: %s, nothing will be done.",m_cfg.__bic__.bic_t))
			return 'b1;
		end // }
	endcase // }

	return 'b0;
endfunction : set_max_delay

// ---- API: set_active
// set the bic to active mode.
//
function bit set_active;
	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin m_cfg.__bic__.ahbl_s.set_active; end
		default: begin // {
			`uvm_error(get_type_name(),$sformatf(" [IBIC][set_active] this API called with invalid bic type: %s, nothing will be done.",m_cfg.__bic__.bic_t))
			return 'b1;
		end // }
	endcase // }

	return 'b0;
endfunction : set_active


// ---- API: set_passive
// API to set the bic to passive mode.
//
function bit set_passive;
	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin m_cfg.__bic__.ahbl_s.set_passive; end
		default: begin // {
			`uvm_error(get_type_name(),$sformatf(" [IBIC][set_passive] this API called with invalid bic type: %s, nothing will be done.",m_cfg.__bic__.bic_t))
			return 'b1;
		end // }
	endcase // }

	return 'b0;
endfunction : set_passive


`endif // UPI_MDP_API__SVH
