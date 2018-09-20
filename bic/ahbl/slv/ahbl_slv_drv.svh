`ifndef AHBL_SLV_DRV__SVH
`define AHBL_SLV_DRV__SVH

/*************************************************************************************************************************
A driver component acted as ahb lite based protocol device. as for a slave, this component
can respond a user specified response or do it automatically.
responding process:
	1. wait req valid, and trigger an event
	2. call get_next_item, wait the response trans.
	3. driving the response info.
*************************************************************************************************************************/

class ahbl_slv_drv #(AW,DW,type IFC) extends uvm_driver #(ahbl_slv_treq);

	ahbl_slv_cfg #(AW,DW,IFC) m_cfg;

	ahbl_htrans ctl;

	uvm_event req_e;
	uvm_event lst_req_e;

	uvm_event rst_start;
	uvm_event rst_done;

	`uvm_component_utils(ahbl_slv_drv#(AW,DW,IFC))

	// constructor
	function new (string name = "ahbl_slv_drv", uvm_component parent = null); super.new(name,parent); endfunction


	/* phase */
	extern function void build_phase (uvm_phase phase);
	extern task reset_phase (uvm_phase phase);
	extern task main_phase (uvm_phase phase);
	/*********/

	/* actions */
	extern task drive_x();
 	extern task drive_default();
	extern task main_action();
	extern task reset_action();
	extern task reset_drv_action();
	extern task reset_mon(); // a task to monitor the reset signal level info, and translate to the events.
	/*************************************/


	// Task: req_sample
	// this is a task to sample the request htrans information when the hsel for current trans is valid and
	// the last trans is done.
	//
	extern task req_sample();

	// Task: req_process
	// this is a task to process the request from ahb master, all processing will be done according to the
	// user.
	//
	extern task req_process();


	// Task: wait_cycle
	// a task to wait a certain clock cycle.
	//
	extern task wait_cycle(input uint32_t num = 1);

	// ---------------------------------------------------------------------------------------------
	// {
	// directly signal process level methods, to process the bottom level signal interfaces.
	// PSM: Physical Signal Methods

	// Task: wait_ctl
	// A task to wait the valid hsel and hready signal,
	//
	extern task wait_ctl();

	// Task: error_resp
	// the task to process error response, first need to confirm the entering time stamp and returning time stamp
	// entering: the cycle that the request has sampled.
	// returning: the cycle time that after the hready had been pulled up one cycle
	//
	extern task error_resp(input uint32_t delay);
	extern task resp(input uint32_t delay); // rdata can be omitted

	// Task: wait_hready_high
	// task to wait the hready to high by cycle sampling way.
	//
	extern task wait_hready_high;

	extern task pull_hready(input logic val = 'b0);
	extern task pull_hresp(input logic [1:0] val = 'h0);
	extern task pull_hrdata(input logic [DW-1:0] val = 'h0);

	// direct signal process methods declaration done.
	// }
	// ---------------------------------------------------------------------------------------------

	// Func: is_protected
	// a function to check current trans is protected or not, if is protected, then return 1, for high
	// level processor in this class to responding the error resp.
	//
	extern function bit is_protected();

	// Func: is_naligned
	// a function to check current trans is aligned or not.
	extern function bit is_naligned();

endclass : ahbl_slv_drv

// ----- class ending
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

task ahbl_slv_drv::error_resp(input uint32_t delay);

	// first need to wait delay cycles, then to do the two cycle long error response.
	//
	if (delay) begin // {
		pull_hready();  // pull hready low first
		pull_hresp(uvm_bitstream_t'(AHBL_OKAY)); // pull okay first
	end // }
	// when delay is off
	pull_hresp(uvm_bitstream_t'(AHBL_ERROR)); // pull hresp to error for one cycle first
	wait_cycle(); // wait one cycle
	pull_hready('b1); // pull hready high for one cycle.
	wait_cycle(); // wait one cycle

	return; // then return for next cycle loop process

endtask : error_resp

task ahbl_slv_drv::wait_hready_high;
	while (`HREADY !== 'b1) begin // {
		wait_cycle();
	end // }
endtask : wait_hready_high

task ahbl_slv_drv::pull_hready(input logic val = 'b0);
	`HREADY <= val;
endtask : pull_hready

task ahbl_slv_drv::pull_hresp(input logic [1:0] val = 'h0);
	`HRESP <= val;
endtask : pull_hresp

task ahbl_slv_drv::pull_hrdata(input logic [DW-1:0] val = 'h0);
	`HRDATA <= val;
endtask : pull_hrdata

task ahbl_slv_drv::resp(input uint32_t delay);
	bit [DW-1:0] rdata;
	case(ctl.hwrite) // {
		AHBL_WR: begin // {
			// write response process
			// first of all, response here must not error, all error response will be sent by error_resp.
			//
			if (delay) begin // {
				pull_hready(); // if delay valid, first need to pull down the hread.
				pull_hresp(uvm_bitstream_t'(AHBL_OKAY));  // when in ready low, need to response OKAY
				wait_cycle(delay); // first to wait delay cycles
			end // }
			// pull up hread signal.
			pull_hready('b1);
			// because the response value is okay, so no need to pull_hresp again.
			// call m_cfg.m_mem.write to write the data in
			m_cfg.m_mem.write(ctl.haddr,`HWDATA,ctl.hsize);
			wait_cycle();// wait at least one cycle, and then return.
		end // }
		AHBL_RD: begin // {
			if (delay) begin // {
				pull_hready(); // pull hready low first for delay action
				pull_hresp(uvm_bitstream_t'(AHBL_OKAY)); // when in low, need to response okay first
				wait_cycle(delay); // to wait delay cycles
			end // }
			// pull up hready signal.
			pull_hready('b1);
			// call m_cfg.m_mem.read to read the data out
			m_cfg.m_mem.read(ctl.haddr,ctl.hsize,rdata);
			pull_hrdata(rdata); // the same time to pull_hrdata too
			wait_cycle(); // retain at least one cycle.
		end // }
	endcase // }
endtask : resp

function bit ahbl_slv_drv::is_naligned();

	// alignment checkking rules: the size and the address
	//
	case (ctl.hsize) // {
		AHBL_BYTE: begin // {
			return 'b0; // for byte grain, no nalignment will be occurred.
		end // }
		AHBL_HWORD: begin // {
			// for half word size, the lowest bit of address must not be 1. which means its legal offset is: 0h,2h,4h,6h,8h,ah,ch,eh
			if (ctl.haddr[0] == 'b1) return 'b1; else return 'b0;
		end // }
		AHBL_WORD: begin // {
			// for word size, the valid address offset is 0h,4h,8h,ch
			if (ctl.haddr[1:0] != 'h0) return 1; else return 'b0;
		end // }
		AHBL_DWORD: begin // {
			// for double word size, the valid address offset is 0h,8h
			if (ctl.haddr[2:0] != 'h0) return 1; else return 'b0;
		end // }
		AHBL_FWORD: begin // {
			// for 4 word size, the valid address is 0h,10h
			if (ctl.haddr[3:0] != 'h0) return 1; else return 'b0;
		end // }
		AHBL_EWORD: begin // {
			// for 8 word size, the valid address is 0h,20h
			if (ctl.haddr[4:0] != 'h0) return 1; else return 'b0;
		end // }
		AHBL_SWORD: begin // {
			// for 16 word size, the valid address is 0h,40h
			if (ctl.haddr[5:0] != 'h0) return 1; else return 'b0;
		end // }
		AHBL_TWORD: begin // {
			// for 32 word size, the valid address is 0h,80h
			if (ctl.haddr[6:0] != 'h0) return 1; else return 'b0;
		end // }
	endcase // }

endfunction : is_naligned

function bit ahbl_slv_drv::is_protected();

	// s1. to check the protect configure is opened or not
	if (!m_cfg.get_prot_st()) return 'b0; // if prot status not enabled, then return 0 to info high level processor as it not protected.

	// else if protect status is valid, then to check the protect value.
	if (m_cfg.get_prot_val() == ctl.hprot) return 'b0; // only if protect equaled, then can return 'b0.
	else return 'b1; // when the protect not equal, then to return 1.

endfunction : is_protected

task ahbl_slv_drv::drive_x();

	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][drive_x] drive all output signals to X value when in reset.",UVM_LOW)
	`endif

	pull_hresp('hx);
	pull_hready('hx);
	pull_hrdata('hx);

	return;

endtask : drive_x

task ahbl_slv_drv::drive_default();
	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][drive_default] drive all output signals to default value when after reset.",UVM_LOW)
	`endif

	pull_hresp();
	pull_hready('b1);
	pull_hrdata();

endtask : drive_default

task ahbl_slv_drv::reset_mon();

	if (`HRESETN === 'b0) begin // {
		// block that current reset is 0
		wait(`HRESETN === 'b1); // to wait hreset to 1
		rst_done.trigger(); // trigger the reset done event.
		rst_start.reset(); // reset the start event
	// }
	end else begin // {
		// block that current reset is 1,x or z.
		// to wait hresetn == 'b0
		wait(`HRESETN === 'b0);
		rst_start.trigger(); // then trigger the rst_start and reset rst_done.
		rst_done.reset();
	end // }

	return;

endtask : reset_mon

function void ahbl_slv_drv::build_phase (uvm_phase phase);

	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][build_phase] entering build_phase ... ...",UVM_LOW)
	`endif

	super.build_phase(phase);

	req_e     = new ("req_e");
	lst_req_e = new ("lst_req_e");
	rst_start = new ("rst_start");
	rst_done  = new ("rst_done");

	return;

endfunction : build_phase

task ahbl_slv_drv::reset_phase (uvm_phase phase);

	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][reset_phase] entering reset_phase ... ...",UVM_LOW)
	`endif

	super.reset_phase(phase);

	// first drive output to x
	drive_x();

	// then wait reset done, which in this class means wait reset to 'b1
	wait(`HRESETN === 'b1);

	drive_default(); // then to drive output to default

	return;

endtask : reset_phase

task ahbl_slv_drv::main_phase (uvm_phase phase);

	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][main_phase] entering main_phase ... ...",UVM_LOW)
	`endif

	super.main_phase(phase);

	fork // {
		forever reset_action();
		forever reset_mon();
		forever reset_drv_action();
		forever begin : main_action_block // {
			rst_done.wait_trigger();
			main_action();
		end : main_action_block // }
	join // }

	return;

endtask : main_phase

task ahbl_slv_drv::wait_ctl();

	// first to wait the select signal valid.
	//
	wait (`HSEL === 'b1); // wait hsel to 1

	// follwing to wait hready, only when last request is actived, then need to wait hready.
	if (lst_req_e.is_on()) begin // {
		wait_hready_high;   // this task to wait hready of last trans, slave will process until the last trans was completed.
		lst_req_e.reset(); // after hready high, that means transaction of last request was done.
	end // }

	// then get control information of current htrans
	//
	ctl.hburst = ahbl_hburst_enum'(`HBURST);
	ctl.htrans = ahbl_htrans_enum'(`HTRANS);
	ctl.hwrite = ahbl_rw_enum'(`HWRITE);
	ctl.haddr  = `HADDR;
	ctl.hwdata = `HWDATA;
	ctl.hsize  = ahbl_hsize_enum'(`HSIZE);
	ctl.hmstlock = `HMSTLOCK;
	ctl.hprot    = `HPROT;

	return;

endtask : wait_ctl

task ahbl_slv_drv::req_sample();


	// sampling the request information and set the trans_sample event to trigger type.
	// check current hburst, htrans info
	//

	// get all control information of current cycle
	//
	wait_ctl();

	/* now start to process the control information */
	// first to check the htrans type
	case (ctl.htrans) // {
		AHBL_NONSEQ,AHBL_SEQ: begin // {
			// to set the event trigger for getting a new valid htrans
			req_e.trigger(); // current request is transed.
		end // }
		AHBL_IDLE, AHBL_BUSY: begin // {
			// in this mode, the sample process will do nothing.
		end // }
	endcase // }
	/************************************************/


	wait_cycle(); // wait one clock cycle

endtask : req_sample

task ahbl_slv_drv::main_action();

	fork // {
		forever req_sample();
		forever req_process();
	join // }

	return;

endtask : main_action

task ahbl_slv_drv::wait_cycle (input uint32_t num = 1);

	if (num) repeat (num) @(posedge `HCLK); // only if cycle number not eq to 0, can this line executed
	return;

endtask : wait_cycle

task ahbl_slv_drv::req_process();

	// each time calling this task, must to wait req_e triggerred first
	req_e.wait_trigger();
	// the time current req waitted, then need to clear the req event.
	req_e.reset();       // reset current trans event
	lst_req_e.trigger(); // and then trigger the last request event, which means the processor has entering into the data phase, current processing trans is the last request.

	// request trigger waited, start to check the request information first.
	// -- according to CFG, switch the response mode: automatic or manual
	if (m_cfg.get_dev_mode == AHBL_AUTO) begin // {
		// auto operation mode, need to do operations as following.
		// -- if get_prot_st is 1, then need to check the protect is matched or not.
		// -- check alignment, if not aligned, then return error
		// -- check address range, if in range, then return
		if (is_protected()) error_resp(m_cfg.get_rand_delay());return; // if the prot information is enabled and error, then to respond the error resp. and return
		// if program executed here, then to check the address alignment.
		if (is_naligned()) error_resp(m_cfg.get_rand_delay()); return; //
		// the last step, check the address is inrange or not.
		if (!m_cfg.is_in_range(ctl.haddr,ctl.hsize)) error_resp(m_cfg.get_rand_delay()); return; // if not in range, then respond error_resp and return
		// afterwards, to process the request as normal responding
		// if is write, then to call write_resp, else call read_resp
		// call resp to process response, in auto mode, the delay is randomly generated according to the m_cfg.get_max_delay();
		// generate delay
		resp(m_cfg.get_rand_delay());
	// }
	end else begin // {
		/* TODO, manually mode, each response will be given by sequencer trans */
	end // }

	return;

endtask : req_process

task ahbl_slv_drv::reset_action();

	rst_start.wait_trigger();  // wait for reset start

	disable this.main_phase.main_action_block;

	rst_done.wait_trigger(); // wait for reset done


endtask : reset_action

task ahbl_slv_drv::reset_drv_action();
	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][reset_drv_action] waiting the reset start.",UVM_LOW)
	`endif
	rst_start.wait_trigger();
	drive_x(); // drive all the output signal to X value. this task should be rebuilt in child class.
	`ifdef `__DBG__
		`uvm_info(get_type_name()," [__DBG__][reset_drv_action] waiting the reset done.",UVM_LOW)
	`endif
	rst_done.wait_trigger();
	drive_default(); // drive all the output signal to default value. this task should be rebuilt in child class.
endtask : reset_drv_action

`endif // AHBL_SLV_DRV__SVH
