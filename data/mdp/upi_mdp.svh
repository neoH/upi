`ifndef UPI_MDP__SVH
`define UPI_MDP__SVH


class upi_mdp #(AW = 32, DW = 32) extends uvm_component;

	localparam type MI = upi_mdp_mi;
	localparam type MO = upi_mdp_mo;

	// mi_port, a monitor transaction port, containing monitor input port.
	uvm_analysis_port #(MI) mi_port;
	// mo_port, a monitor transaction port, containing monitor output port.
	uvm_analysis_port #(MO) mo_port;

	upi_mdp_cfg #(AW,DW) m_cfg;

	`uvm_component_utils(upi_mdp#(AW,DW))


	`include "data/mdp/upi_mdp_api.svh"

	// constructor
	//
	function new (string name = "upi_mdp", uvm_component parent = null);
		super.new(name,parent);
		// create m_cfg component
		m_cfg = upi_mdp_cfg#(AW,DW)::type_id::create("m_cfg");
	endfunction


	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern task main_phase (uvm_phase phase);
	/**********/

	// these two tasks to process the ahbl slv monitors when bic type is ahbl slv.
	extern task ahbl_slv_mi;
	extern task ahbl_slv_mo;

endclass : upi_mdp

function void upi_mdp::build_phase (uvm_phase phase);

	mi_port = new ("mi_port",this);
	mo_port = new ("mo_port",this);

	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin // {
			uvm_config_db #(virtual ahbl_slv_ifc)::get(this,"","ahbl_slv_ifc",m_cfg.ahbls_if);
		end // }
	endcase // }

	return;
endfunction : build_phase

// Task: main_phase
// this phase here will do the main actions.
// there'are two alternative types for user to set: MDP_MST or MDP_SLV.
//
//
task upi_mdp::main_phase (uvm_phase phase);

	// this main phase will be used to get one trans from bic and translated to mdp type.
	case (m_cfg.__bic__.bic_t) // {
		// select the bic type.
		AHBL_SLV: begin // {
			fork // {
				forever ahbl_slv_mi;
				forever ahbl_slv_mo;
			join // }
		end // }
	endcase // }

endtask : main_phase

task upi_mdp::ahbl_slv_mi;
	ahbl_slv_pkg::ahbl_req_mtrans mreq;
	MI #(AW,DW) mi = new("mi"); // create the new mi trans.
	// task to do monitor actions for ahbl_slv BIC.
	m_cfg.__bic__.ahbl_s.wait_req(mreq); // get ahbl slv request info.

	/* step 2. start to translate ahbl slv trans type to mdp mi type */
	mi.addr  = mreq.addr; // copy address first.
	mi.stime = mreq.stime;
	mi.etime = mreq.etime;
	case (mreq.rw) // {
		// determin the read/write type according to mreq.rw
		AHBL_WR: begin mi.rw = write; end
		AHBL_RD: begin mi.rw = read; end
	endcase // }
	if (mi.rw == write) mi.dat  = mreq.wdata; // if is write, then to record the write data
	// start to calculate the valid length.
	case (mreq.hsize) // {
		AHBL_BYTE: begin // {
			mi.len = 1;
		end // }
		AHBL_HWORD: begin // {
			mi.len = 2;
		end // }
		AHBL_WORD: begin // {
			mi.len = 4;
		end // }
		AHBL_DWORD: begin // {
			mi.len = 8;
		end // }
		AHBL_FWORD: begin // {
			mi.len = 16;
		end // }
		AHBL_EWORD: begin // {
			mi.len = 32;
		end // }
		AHBL_SWORD: begin // {
			mi.len = 64;
		end // }
		AHBL_TWORD: begin // {
			mi.len = 128;
		end // }
	endcase // }
	/*****************************************************************/

	mi_port.write(mi); // sending mi trans, and delete the current mi handle, then return this task.
	mi = null;
	return;
endtask : ahbl_slv_mi

task upi_mdp::ahbl_slv_mo;
	ahbl_slv_pkg::ahbl_rsp_mtrans mrsp;
	// for out port, in memory data in package, it is a response trans
	upi_mdp_mo #(AW,DW) mo = new ("mo");

	m_cfg.__bic__.ahbl_s.wait_rsp(mrsp); // get ahbl slv request info.

	/* step 2. start to translate ahbl slv trans type to mdp mi type */
	mo.addr  = mrsp.addr; // copy address first.
	mo.stime = mrsp.stime;
	mo.etime = mrsp.etime;
	case (mrsp.rw) // {
		// determin the read/write type according to mrsp.rw
		AHBL_WR: begin mo.rw = write; end
		AHBL_RD: begin mo.rw = read; end
	endcase // }
	if (mo.rw == write) mo.dat  = mrsp.rdata; // if is write, then to record the write data
	// start to calculate the valid length.
	case (mrsp.hsize) // {
		AHBL_BYTE: begin // {
			mo.len = 1;
		end // }
		AHBL_HWORD: begin // {
			mo.len = 2;
		end // }
		AHBL_WORD: begin // {
			mo.len = 4;
		end // }
		AHBL_DWORD: begin // {
			mo.len = 8;
		end // }
		AHBL_FWORD: begin // {
			mo.len = 16;
		end // }
		AHBL_EWORD: begin // {
			mo.len = 32;
		end // }
		AHBL_SWORD: begin // {
			mo.len = 64;
		end // }
		AHBL_TWORD: begin // {
			mo.len = 128;
		end // }
	endcase // }
	/*****************************************************************/

	mo_port.write(mo);

	mo = null;
	return;
endtask : ahbl_slv_mo

`endif // UPI_MDP__SVH
