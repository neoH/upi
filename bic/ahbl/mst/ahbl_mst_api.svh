`ifndef AHBL_MST_API__SVH
`define AHBL_MST_API__SVH

/****************************************************************************************************
	this is an API component derived from uvm_object. the file will be used to all AHBL BIC for
easily connecting with UPI and support compatible insertion with existed old UVCs or VIPs.

****************************************************************************************************
Macros for current class:
-- __DBG_AHBL_BIC_API__
****************************************************************************************************
APIs:
-- get_req_data
-- wait_req_data
****************************************************************************************************
Version: v1.00, Features:
-- TODO
****************************************************************************************************/

`define __DBG__ __DBG_AHBL_MST_API__

// extants the imps for ahbl_mst_api class exclusively.
`uvm_analysis_imp_decl(_ahbl_mst_api_req)
`uvm_analysis_imp_decl(_ahbl_mst_api_rsp)

class ahbl_mst_api #(AW,DW, type REQ = ahbl_req_mtrans, RSP = ahbl_rsp_mtrans) extends uvm_object;

	// two imps are declared hebic_api_re, for the version 1.00, only support maximum 2 imp named req and rsp seperately.
	uvm_analysis_imp_bic_api_req #(REQ,ahbl_mst_api) req_imp;
	uvm_analysis_imp_bic_api_rsp #(RSP,ahbl_mst_api) rsp_imp;

	// queues for storing info from BIC modules
	bit [AW-1:0] req_addr_q[$];
	bit [AW-1:0] rsp_addr_q[$];

	bit [DW-1:0] req_data_q[$];
	bit [DW-1:0] rsp_data_q[$];

	bit req_rw[$]; // read/write type queue, indicates all requests, 0 is read while 1 is write.
	bit rsp_rw[$]; // read/write type queue for response trans.

	// req_burst_q
	// rsp_burst_q
	// req_htrans_q
	// ...
	/* TODO */

	// -- req_e
	uvm_event req_e;

	// -- rsp_e
	uvm_event rsp_e;

	// constructor
	function new (string name = "ahbl_mst_api");
		super.new(name);

		req_imp = new("req_imp"); // port initial
		rsp_imp = new("rsp_imp"); // port initial

		// event initial
		req_e = new ("req_e");
		rsp_e = new ("rsp_e");

	endfunction

	/* ----- APIs ----- */

	// -- bit get_req_data
	// a nonblock func. to get request data in the data queue, if no items in the queue, then to return 0, else to return 1
	// and target data will be returned by the ref argument.
	//
	extern function bit get_req_data(ref [DW-1:0] dat_p);

	// Task: wait_req
	// a block task to wait request valid.
	//
	extern task wait_req;

	// Task: __wait_rsp__
	// a block task to wait response valid.
	//
	extern task __wait_rsp__;

	// -- wait_req_data
	// a block task to get request data in the data queue, if no items in the queue, then the task will wait until one item
	// valid.
	extern task wait_req_data(output [DW-1:0] dat);


	/* ---------------- */


	// write functions after receiving the req or rsp trans.
	extern function void write_ahbl_bic_api_req (input REQ _t);
	extern function void write_ahbl_bic_api_rsp (input RSP _t);

endclass : ahbl_mst_api


task ahbl_mst_api::wait_req_data (output [DW-1:0] dat);
	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][wait_req_data] task called to get req data.",UVM_LOW)
	`endif

	if (req_data_q.size() == 0) wait(req_data_q.size()); // if current size of queue is 0, then to wait until not 0.

	dat = req_data_q.pop_front(); // to pop one data item.

	return;

endtask : wait_req_data


function void ahbl_mst_api::write_ahbl_bic_api_req (input REQ _t);
	`ifndef `__DBG__
		`uvm_info(get_type_name(),$sformatf(" [__DBG__][write_ahbl_bic_api_req] getting one req trans from ahbl_mon port:\n%s",_t.sprint()),UVM_LOW)
	`endif

	req_rw.push_back(bit'(_t.rw)); // push and translated ahbl_rw_enum to bit type.
	if (_t.rw == AHBL_WR) req_data_q.push_back(_t.wdata);

	return;
endfunction : write_ahbl_bic_api_req

task ahbl_mst_api::wait_req;
	if (req_e.is_off()) req_e.wait_on(); // if current event is off, then need to event wait on, else return directly.
	return;
endtask : wait_req

task ahbl_mst_api::__wait_rsp__;
	if (rsp_e.is_off()) rsp_e.wait_on(); // if current event is off, then need to event wait on, else return directly.
	return;
endtask : __wait_rsp__


`undef __DBG__ // to release the DBG, which may occurred in other scopes
`endif // AHBL_BIC_API__SVH
