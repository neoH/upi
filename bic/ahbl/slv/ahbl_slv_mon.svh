`ifndef AHBL_SLV_MON__SVH
`define AHBL_SLV_MON__SVH

/*************************************************************************************************************
It is a monitor component based on ahbl slave protocol.
*************************************************************************************************************/

class ahbl_slv_mon #(AW,DW,type IFC,type REQ,type RSP) extends uvm_monitor #(REQ,RSP);

	typedef ahbl_htrans #(AW,DW) ahbl_htrans_inside;

	// req_port
	// the port transfer the ahbl request information
	//
	uvm_analysis_port #(REQ) req_port;

	// rsp_port
	// the port transfer the ahbl response information
	//
	uvm_analysis_port #(RSP) rsp_port;

	// mreq
	// request transaction used in this class.
	//
	REQ mreq;

	// mrsp
	// response transaction used in this class.
	//
	RSP mrsp;

	// Var: m_main_process
	// the main process variable in this class.
	//
	process m_main_process;

	ahbl_slv_cfg #(AW,DW,IFC) m_cfg;

	// event: rst_e
	// the reset event, if it is triggerred, or is on, that means the now is in reset mode,
	// else the reset is done or not in reset mode.
	//
	uvm_event rst_e;

	// event: req_done_e
	// the event to indicates the request sampling is done.
	// this event is triggered by the req_mon, to enable the request sampling event, while
	// it is reset by rsp_mon where the req trans need to be used.
	//
	uvm_event req_done_e;

	`uvm_component_utils(ahbl_slv_mon#(AW,DW,IFC,REQ,RSP))

	// constructor
	function new (string name = "ahbl_slv_mon", uvm_component parent = null); super.new(name,parent); endfunction


	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern task main_phase (uvm_phase phase);
	/**********/


	// Task: main_action
	//
	// The root process for this component. Which called by main_phase. However, this task should be a dead loop task
	// for signal monitoring and translating.
	//
	extern task main_action();

	// Task: reset_action
	//
	// Task to process & detect reset event. if reset event triggerred, then this task will kill the main process
	//
	extern task reset_action();

	// Task: req_mon
	// the request monitor task, to do request monitoring for ahbl slave.
	// containing information collect, translate and send.
	//
	extern task req_mon();

	// Task: rsp_mon
	// the response monitor task, to do response monitoring actions for ahbl slave.
	//
	extern task rsp_mon();

	// Task: get_req_mtrans
	// a task to collect and translate the request transaction.
	//
	extern task get_req_mtrans;

	// Task: send_req_mtrans
	// This function to send request monitor trans, if mreq is not null, and after sending, clear this
	// mreq handle
	//
	extern task send_req_mtrans;

	// Task: get_rsp_mtrans
	// a task to collect and translate the response transaction.
	//
	extern task get_rsp_mtrans;

	// Task: send_rsp_mtrans
	// a task to send the response transaction from monitor.
	extern task send_rsp_mtrans;

	// Task: wait_ctl
	//
	// This task to get control information from signal, and then translate into ahbl_htrans_struct
	// type.
	// entering time of this task is posedge of last trans sampled.
	// leaving time of this task is posedge of current trans sampled.
	//
	extern task wait_ctl(input bit lwreq_en, ref ahbl_htrans_inside _htrans);

	// Task: wait_hready_high
	// Wait HCLK until hready is high
	//
	extern task wait_hready_high;

	// Func: get_rsp
	//
	// Function to get response information, which indicates the hresp, and hrdata for read
	// So this func need an arg to specify if need to get rdata info.
	//
	extern function ahbl_resp_struct get_rsp(input ahbl_rw_enum _rw);


	// Func: get_wdata
	// Function to get wdata at current cycle
	//
	function bit [DW - 1 : 0] get_wdata(); return `HWDATA; endfunction

	// task to wait one clock cycle.
	task wait_one_cycle; @(posedge `HCLK); endtask

endclass : ahbl_slv_mon


function void ahbl_slv_mon::build_phase (uvm_phase phase);
	// enter build phase
	super.build_phase (phase);

	rst_e      = new("rst_e"); // to create the reset event.
	req_done_e = new("req_done_e");

	req_port   = new ("req_port",this);
	rsp_port   = new ("rsp_port",this);

	// leave build phase
endfunction : build_phase


task ahbl_slv_mon::main_phase (uvm_phase phase);
	`uvm_info(get_type_name()," [PHASE_TRACE] entering main_phase ... ...",UVM_HIGH)

	super.main_phase (phase);

	fork // {
		// start parallel processes:
		// 1. one block to do reset actions, which means to detect reset event and controlling
		// the main action block.
		// 2. one block to do the main actions, containing signals collection and translating.
		//
		forever reset_action(); // using forever to detect multiple resets.
		forever begin // {
			rst_e.wait_off(); // wait reset done
			m_main_process = process::self(); // get process number of current begin block, this block will only be killed if reset event occurred.
			main_action();
		end // }
	join // }

	`uvm_info(get_type_name()," [PHASE_TRACE] leaving main_phase ... ...",UVM_HIGH)

endtask : main_phase

task ahbl_slv_mon::reset_action();
	`uvm_info(get_type_name()," [FLOW_TRACE] entering reset_action ... ...",UVM_HIGH)

	rst_e.wait_on(); // wait the reset event to on status.

	if (m_main_process != null) begin // {
		// if main action is valid
		if (m_main_process.status != process::FINISHED) begin // {
			`ifdef `__DBG__
				`uvm_info(get_type_name()," [__DBG__][reset_action] reset event detected, killing main actions",UVM_LOW)
			`endif
			// if main action not finished
			m_main_process.kill(); // then to kill main action
		end // }
	end // }

	rst_e.wait_off(); // wait reset event done.

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving reset_action ... ...",UVM_HIGH)
endtask : reset_action

task ahbl_slv_mon::main_action();
	`uvm_info(get_type_name()," [FLOW_TRACE] entering main_action ... ...",UVM_HIGH)

	fork // {
		// to call sub tasks in parallel mode
		// 1. req_mon, monitor and translating the ahbl request infomation.
		// 2. rsp_mon, monitor and translating the ahbl response information.
		forever req_mon();
		forever rsp_mon();
	join // }

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving main_action ... ...",UVM_HIGH)
endtask : main_action

task ahbl_slv_mon::get_req_mtrans ;
	// this task will monitor and collect the request htrans each time when the req action happend.
	//

	// the var _htrans is a uvm_object typed class that contains all htrans information;
	//
	ahbl_htrans_inside _htrans = new ("htrans");

	// enable flag of last write request, because only write request doesn't need @(posedge `HCLK)
	// at the beginning of current task.
	//
	static bit lwreq_en = 'b0;

	`uvm_info(get_type_name()," [FLOW_TRACE] entering get_req_mtrans ... ...",UVM_HIGH)

	// call wait_ctl to get the controlling information at current time stamp.
	//
	wait_ctl(lwreq_en,_htrans);

	if (_htrans.htrans != AHBL_IDLE) begin // {
		// if current control info of htrans is not IDLE, that means current htrans is valid.
		// then to create a new transaction, collecting and sending the valid transaction.
		mreq = new("mreq"); // create a new transaction
		mreq.burst = _htrans.hburst;
		mreq.trans = _htrans.htrans;
		mreq.lock  = _htrans.hmstlock;
		mreq.addr  = _htrans.haddr;
		mreq.size  = _htrans.hsize;
		mreq.rw    = _htrans.hwrite;
		mreq.stime = $time; // get current time by calling $time directly.
		if (mreq.rw == AHBL_RD) begin // {
			// if current control is read req, then assign the end time and return, to send this transaction.
			lwreq_en = 'b0; // because is read req, so clear the lwreq_en
			mreq.etime = mreq.stime;
			req_done_e.trigger();
			return;
		// }
		end else begin // {
			// if current control is write req, then wait one cycle to get the write data.
			lwreq_en = 'b1; // first to info the next cycle that last write req is valid
			wait_one_cycle;
			mreq.wdata = get_wdata();
			mreq.etime = $time;
			req_done_e.trigger();
			return;
		end // }
	// }
	end else begin // {
		lwreq_en = 'b0;
	end // }

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving get_req_mtrans ... ...",UVM_HIGH)
endtask : get_req_mtrans

task ahbl_slv_mon::wait_ctl (input bit lwreq_en, ref ahbl_htrans_inside _htrans);
	`uvm_info(get_type_name()," [FLOW_TRACE] entering wait_ctl ... ...",UVM_HIGH)

	if (!lwreq_en) begin // {
		@(posedge `HCLK); // if last request not enabled, then wait one cycle first
		wait_hready_high; // if last request is enabled, then need to wait hready is high, or it will sample the wrong hwdata.
	end // }

	_htrans.hburst   = ahbl_hburst_enum'(`HBURST);
	_htrans.htrans   = ahbl_htrans_enum'(`HTRANS);
	_htrans.hwrite   = ahbl_rw_enum'(`HWRITE);
	_htrans.haddr    = `HADDR;
	_htrans.hprot    = `HPROT;
	_htrans.hmstlock = `HMSTLOCK;
	_htrans.hsize    = ahbl_hsize_enum'(`HSIZE);

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving wait_ctl ... ...",UVM_HIGH)

	return;
endtask : wait_ctl

task ahbl_slv_mon::wait_hready_high;
	while (`HREADY !== 'b1) begin // {
		// while the hready is not equal to 1, then need to wait one cycle
		// this coding style to wait the hready cycle by cycle that aligned to the HCLK.
		wait_one_cycle;
	end // }
endtask : wait_hready_high

task ahbl_slv_mon::req_mon();
	get_req_mtrans;
	send_req_mtrans;
endtask : req_mon

task ahbl_slv_mon::rsp_mon();
	get_rsp_mtrans;
	send_rsp_mtrans;
endtask : rsp_mon


task ahbl_slv_mon::send_req_mtrans;

	if (mreq != null) begin // {
		// only when mreq is not null, then need to send
		`ifdef `__DBG__
			`uvm_info(get_type_name(),$sformatf(" [__DBG__][send_req_mtrans] trans sending by monitor:\n%s",mreq.sprint()),UVM_LOW)
		`endif
		req_port.write(mreq); // call write to send to port
		// wait until the event off, this event will be reset by rsp_mon actions after it copied the req information.
		req_done_e.wait_off();
		mreq = null; // clear the handler
	end // }

	return;

endtask: send_req_mtrans

task ahbl_slv_mon::send_rsp_mtrans;

	if (mrsp != null) begin // {
		// only when mrsp is not null, then need to send
		`ifdef `__DBG__
			`uvm_info(get_type_name(),$sformatf(" [__DBG__][send_rsp_mtrans] trans sending by monitor:\n%s",mrsp.sprint()),UVM_LOW)
		`endif
		rsp_port.write(mrsp); // call write to send to port
		// wait until the event off, this event will be reset by rsp_mon actions after it copied the rsp information.
		mrsp = null; // clear the handler
	end // }

	return;

endtask: send_rsp_mtrans


task ahbl_slv_mon::get_rsp_mtrans;

	ahbl_resp_struct _resp;

	`uvm_info(get_type_name()," [FLOW_TRACE] entering get_rsp_mtrans ... ...",UVM_HIGH)

	// after the wait trigger task, if write req, then it is now at next sample cycle of current trans.
	// if read req, then it is now at current sample cycle of current trans. so here need to wait one cycle first
	// nomatter which condition, first the rsp mon need to wait hready high.
	req_done_e.wait_trigger(); // first to wait req info, then can rsp info be processed.

	mrsp = new("mrsp"); // create a new handle of the mrsp.
	// get req info before it cleared.
	mrsp.set_req_info(mreq);
	// reset the req done event to info the req block to clear the mreq
	req_done_e.reset();

	// if is read req, need to wait one cycle first. because the req getting type is the sample time at current htrans
	if (mrsp.rw == AHBL_RD) wait_one_cycle;

	wait_hready_high; // now start to wait hready high

	_resp = get_rsp(mrsp.rw); // get response information

	/* -- following block to set the _resp to mrsp transaction -- { */
	if (mrsp.rw == AHBL_RD) mrsp.rdata = _resp.hrdata[DW-1:0]; // if type is read, need to get hrdata of resp
	mrsp.resp = _resp.hresp; // get response
	/* -- block  end } */

	return; // here to return because the mrsp has been prepared.

	`uvm_info(get_type_name()," [FLOW_TRACE] leaving get_rsp_mtrans ... ...",UVM_HIGH)
endtask : get_rsp_mtrans


function ahbl_resp_struct ahbl_slv_mon::get_rsp(input ahbl_rw_enum _rw);

	ahbl_resp_struct _resp_s; // declaration of return var

	if (_rw == AHBL_RD) _resp_s.hrdata[DW-1:0] = `HRDATA; // get hrdata if type is read
	_resp_s.hresp = ahbl_resp_enum'(`HRESP); // get resp with casting

	return _resp_s; // return the var

endfunction : get_rsp




`endif // AHBL_SLV_MON__SVH
