`ifndef AHBL_SLV__SVH
`define AHBL_SLV__SVH

/*******************************************************************************************************************
The BIC acted as a slave device with AHB Lite protocol.
processing flow of ahbl slv driver:
	1. get control information from signal level
	2. call get_next_item() from sequencer
	3. sending response
*******************************************************************************************************************/


class ahbl_slv #(AW = 32, DW = 32,type IFC) extends uvm_agent;

	localparam type MREQ = ahbl_req_mtrans;
	localparam type MRSP = ahbl_rsp_mtrans;

	ahbl_slv_drv #(AW,DW,IFC) m_drv;

	ahbl_slv_cfg #(AW,DW,IFC) m_cfg;

	ahbl_slv_mon #(AW,DW,IFC,MREQ,MRSP) m_mon;

	/* TODO */ // ahbl_slv_seqr m_seqr;

	`uvm_component_utils(ahbl_slv#(AW,DW,IFC))

	`include "bic/ahbl/slv/ahbl_slv_api.svh"

	// constructor
	//
	function new (string name = "ahbl_slv", uvm_component parent = null);
		super.new(name,parent);
		m_cfg = ahbl_slv_cfg#(AW,DW,IFC)::type_id::create("m_cfg"); // create the configure map first.
	endfunction


	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase (uvm_phase phase);
	/**********/

endclass : ahbl_slv

// ----- class ending
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function void ahbl_slv::build_phase (uvm_phase phase);

	super.build_phase(phase);

	if (m_cfg.get_active() == UVM_ACTIVE) begin // {
		m_drv = ahbl_slv_drv#(AW,DW,IFC)::type_id::create("m_drv",this);
		m_drv.m_cfg = m_cfg;
		/* TODO */ // m_seqr = ahbl_slv_seqr::type_id::create("m_seqr",this);
	end // }

	m_mon = ahbl_slv_mon#(AW,DW,IFC,MREQ,MRSP)::type_id::create("m_mon",this);
	m_mon.m_cfg = m_cfg;

endfunction : build_phase

function void ahbl_slv::connect_phase (uvm_phase phase);

	if (m_cfg.get_active() == UVM_ACTIVE) begin // {
		/* TODO */ // m_drv.seq_item_port.connect(m_seqr.seq_item_export);
	end // }

	if 	(m_cfg.get_bic_type() != UPI) begin // {
		/* TODO */
		// if current bic not in UPI mode, then need to connect the monitor port with current level component.
	end // }

endfunction : connect_phase

`endif // AHBL_SLV__SVH
