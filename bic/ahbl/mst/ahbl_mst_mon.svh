`ifndef AHBL_MST_MON__SVH
`define AHBL_MST_MON__SVH

/*****************************************************************************************************************
	all transaction information sampled by monitor component will be trans out of this class for further usage.
there may two main usage:
-- connected to API component.
-- output for higher usage.
*****************************************************************************************************************/
class ahbl_mst_mon #(type REQ = ahbl_mst_req_mtrans, RSP = ahbl_mst_rsp_mtrans) extends bic_monitor #(REQ,RSP,ahbl_mst_cfg);


	`uvm_component_utils(ahbl_mst_mon)

	// constructor
	function new (string name = "ahbl_mst_mon", uvm_component parent = null); super.new(name,parent); endfunction

	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern task main_phase (uvm_phase phase);
	/**********/


	// reset_mon
	// a derived task from parent class, to detect the reset event.
	extern task reset_mon();

	// req_tr_mon
	// a task derived from the parent class, to sample and translate the request info.
	//
	extern task req_tr_mon();

	// rsp_tr_mon
	// a task similiar with req_tr_mon, to sample and translate the response info.
	//
	extern task rsp_tr_mon();

endclass : ahbl_mst_mon


task ahbl_mst_mon::reset_mon();

	if (`HRESETN === 'b0) begin // {
		// if current reset value is 0, then need to wait reset done and trigger the event.
		wait(`HRESETN === 'b1); // wait reset signal eq to 1, then it means reset done.
		rst_done.trigger();    // so to trigger the rst_done, and reset rst_start at the same time.
		rst_start.reset();       // reset rst_start
	// }
	end else if (`HRESETN === 'b1) begin // {
		// else the reset is 'b1, then need to wait reset to 0
		wait(`HRESETN === 'b0); // wait reset signal eq to 0, then it means reset start.
		rst_start.trigger();    // so to trigger the rst_start, and reset rst_done at the same time.
		rst_done.reset();       // reset rst_done
	// }
	end else begin // {
		// if the reset is 'bx or 'bz in main phase, then need to print the UVM_ERROR
		// in this case, a uvm error is need
		`uvm_error(get_type_name()," [IVRST] invalid reset detected, please confirm if the reset signal is connected correctly.")
	end // }

	return;

endtask : reset_mon

function void ahbl_mst_mon::build_phase (uvm_phase phase);
	`uvm_info(get_type_name()," [PHASE_TRACE] entering build_phase ... ...",UVM_HIGH)

	tou_port = new("tou_port",this);
	tiu_port = new("tiu_port",this);
	m_req_done_e = new("m_req_done_e");

	`uvm_info(get_type_name()," [PHASE_TRACE] leaving build_phase ... ...",UVM_HIGH)
endfunction : build_phase

task ahbl_mst_mon::main_phase (uvm_phase phase);
	//`uvm_info(get_type_name()," [PHASE_TRACE] entering main_phase ... ...",UVM_HIGH)
	super.main_phase (phase);
	//`uvm_info(get_type_name()," [PHASE_TRACE] leaving main_phase ... ...",UVM_HIGH)
endtask : main_phase


task ahbl_mst_mon::req_tr_mon();


endtask : req_tr_mon


`endif // AHBL_MST_MON__SVH
