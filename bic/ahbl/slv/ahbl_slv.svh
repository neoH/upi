`ifndef AHBL_SLV__SVH
`define AHBL_SLV__SVH

/*******************************************************************************************************************
The BIC acted as a slave device with AHB Lite protocol.
processing flow of ahbl slv driver:
	1. get control information from signal level
	2. call get_next_item() from sequencer
	3. sending response
*******************************************************************************************************************/


`uvm_analysis_imp_decl(_mreq)
`uvm_analysis_imp_decl(_mrsp)

class ahbl_slv #(AW = 32, DW = 32,type IFC) extends uvm_agent;

	localparam type MREQ = ahbl_req_mtrans;
	localparam type MRSP = ahbl_rsp_mtrans;

	// mreq_imp, declared for upi mode to collecting the request transaction
	//
	uvm_analysis_imp_mreq #(MREQ,ahbl_slv#(AW,DW,IFC)) mreq_imp;

	// mrsp_imp, declared for upi mode to collecting the response transactions
	//
	uvm_analysis_imp_mrsp #(MRSP,ahbl_slv#(AW,DW,IFC)) mrsp_imp;

	// mreq_que,mrsp_que, the que to store the request/response trans for high level usage.
	//
	MREQ mreq_que[$];
	MRSP mrsp_que[$];

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

	/* imps' functions */
	extern function void write_mreq (input MREQ _t);
	extern function void write_mrsp (input MRSP _t);

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

	// creating the monitor imp for UPI mode.
	mreq_imp = new ("mreq_imp",this);
	mrsp_imp = new ("mrsp_imp",this);

endfunction : build_phase

function void ahbl_slv::write_mreq (input MREQ _t);
	`ifdef `__DBG__
		`uvm_info(get_type_name(),$sformatf("[__DBG__][write_mreq] get one req trans from monitor:\n%s",_t.sprint()),UVM_LOW)
	`endif
	mreq_que.push_back(_t);
	return;
endfunction : write_mreq

function void ahbl_slv::write_mrsp (input MRSP _t);
	`ifdef `__DBG__
		`uvm_info(get_type_name(),$sformatf("[__DBG__][write_mreq] get one rsp trans from monitor:\n%s",_t.sprint()),UVM_LOW)
	`endif
	mrsp_que.push_back(_t);
	return;
endfunction : write_mrsp

function void ahbl_slv::connect_phase (uvm_phase phase);

	if (m_cfg.get_active() == UVM_ACTIVE) begin // {
		/* TODO */ // m_drv.seq_item_port.connect(m_seqr.seq_item_export);
	end // }

	if 	(m_cfg.get_bic_type() != UPI) begin // {
		/* TODO */
		// if current bic not in UPI mode, then need to connect the monitor port with current level component.
	// }
	end else begin // {
		// block to declare that bic is in UPI mode.
		m_mon.req_port.connect(mreq_imp);
		m_mon.rsp_port.connect(mrsp_imp);
	end // }

endfunction : connect_phase

`endif // AHBL_SLV__SVH
