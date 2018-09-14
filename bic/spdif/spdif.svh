/*****************************************************************************************************************
	This is a BIC packaged based on SPDIF protocol. Which probably contains in and out features, for current version,
v1.00, we create spdif-in feature only.

******************************************************************************************************************
version: v1.00

For current version, this BIC support following features:
	-- spdif-in features, which affect the monitor feature, so current version of spdif do not support driver.
*****************************************************************************************************************/

`ifndef SPDIF__SVH
`define SPDIF__SVH

class spdif #(
	type REQ = spdif_req,
	RSP = spdif_rsp,
	CFG = spdif_cfg
) extends bic #(CFG,spdif_drv#(REQ,RSP,CFG),spdif_mon#(REQ,RSP,CFG),spdif_seqr);



	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	/**********/

	/* ----- API declarations for m_api ----- */
	// all API functions in m_api will be called by a renamed function in spdif level.
	//
	/******************************************/

endclass : spdif

// out of class
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function void spdif::build_phase (uvm_phase phase);

	`uvm_info(get_type_name()," [FLOW_TRACE] entering build_phase ... ...",UVM_HIGH)

	super.build_phase(phase);

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving build_phase ... ...",UVM_HIGH)

	return;
endfunction : build_phase


function void spdif::connect_phase (uvm_phase phase);
	`uvm_info(get_type_name()," [FLOW_TRACE] entering connect_phase ... ...",UVM_HIGH)

	super.connect_phase(phase);

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving connect_phase ... ...",UVM_HIGH)

	return;
endfunction : connect_phase



`endif // SPDIF__SVH
