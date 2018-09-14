`ifndef SPDIF_MON__SVH
`define SPDIF_MON__SVH

/*******************************************************************************************************************
File:    spdif_mon.svh
Author:  JoachimH
Version: v1.00
*******************************************************************************************************************/

/*******************************************************************************************************************
*******************************************************************************************************************/

class spdif_mon (type REQ,RSP,CFG) extends bic_monitor#(REQ,RSP,CFG);

	// the period time, which used to sample the data for each sub-frame, this var will be refresh at the
	// first 3-bit of preamble for each sub-frame.
	realtime __period__;

	`uvm_component_utils(spdif_mon)

	// constructor
	function new (string name = "spdif_mon", uvm_component parent = null); super.new(name,parent); endfunction

	/* phases */
	// build
	// a build phase function to run the super.build function. all actions done in super build
	// please confirm the source code or docs.
	//
	extern function void build_phase (uvm_phase phase);
	/**********/

	/* overriding of super methods */
	// pure virtual task in super, override by this class, and mainly to check out transaction features.
	/* TODO, in version v1.00, the out feature is reserved */
	/* TODO extern task req_tr_mon(); */

	// Task: rsp_tr_mon
	// pure virtual task from super class, mainly to check input transactions.
	//
	extern task rsp_tr_mon();
	/*******************************/

	// Task: get_assemble
	//
	// task to get the whole assmeble value of current sub-frame.
	//
	extern task get_assemble(output bit [63:0] _pa);

	// Func: set_period
	// a function to calculate the __period__ according to input time
	//
	extern function void set_period(input realtime _s, input realtime _e);

	// Task: wait_period
	// a task to wait the __period__ time.
	//
	extern task wait_period();

	// Func: disassemble
	// the function to disassemble the ass code. And then return the 32-bit long dised info
	// disassemblance rule:
	// req.prea  = spdif_preamble_enum'(_ass[7:0])
	// req.aux   = translate(_ass[15:8])
	// req.audio = translate(_ass[55:16])
	// req.valid = translate(_ass[57:56])
	// req.user  = translate(_ass[59:58])
	// req.chnl  = translate(_ass[61:60])
	// req.ep    = translate(_ass[63:62])
	// this function only to do the translate feature as said above.
	// attention, the preamble should not be disassembled.
	// return format:
	// [35:8], other disassembled data
	// [7:0] , the source preamble value.
	//
	extern function bit[35:0] disassemble(input bit [63:0] _ass);


	// Func: rsp_translate
	// a function to translate the disassembled value to req transaction.
	// this function will do the assignment according to the description of function: disassemble.
	//
	extern function void rsp_translate(input bit [35:0] _dass);

	// Func: get_sample_freq
	// a function to get sample frequency according to the input start time and end time.
	// frequency calculation formula: 1.00/(((_et - _st) / 1ms) * 2.00), result is in KHz unit.
	//
	extern function spdif_sample_freq_enum get_sample_freq( input realtime _st, input realtime _et);

endclass : spdif_mon

function spdif_sample_freq_enum spdif_mon::get_sample_freq(input realtime _t, input realtime _et);
	real freq;
	real _rdnd; // the positive redundant value, results according to the configure

	freq = 1.00 / (((_et - _st) / 1ms) * 2.00);

	// select frequency according to frequency redundancy in cfg.
	//
	_rdnd = (freq * m_cfg.get_freq_rdnd()) * 0.01;

	if (freq+_rdnd >= 32 && freq-_rdnd <= 32)
		return 32K;
	else if (freq+_rdnd >= 44.1 && freq-_rdnd <= 44.1)
		return 44P1;
	else if (freq+_rdnd >= 48 && freq-_rdnd <= 48)
		return 48K;
	else if (freq+_rdnd >= 88 && freq-_rdnd <= 88)
		return 88K;
	else if (freq+_rdnd >= 96 && freq-_rdnd <= 96)
		return 96K;
	else if (freq+_rdnd >= 192 && freq-_rdnd <= 192)
		return 192K;
	else return RO;

endfunction : get_sample_freq

function void spdif_mon::build_phase (uvm_phase phase);

	`uvm_info(get_type_name()," [FLOW_TRACE] entering build_phase ... ...",UVM_HIGH)
	super.build_phase (phase);
	`uvm_info(get_type_name()," [FLOW_TRACE] leaving build_phase ... ...",UVM_HIGH)

	return;
endfunction : build_phase

// the main task for sampling and translating
//
task spdif_mon::rsp_tr_mon();
	bit [63:0] assemble;
	bit [35:0] dass;
	`uvm_info(get_type_name()," [FLOW_TRACE] entering rsp_tr_mon ... ...", UVM_HIGH)

	// task to check in dir features, procedures:
	// 1. wait the preambles
	//
	if (m_cfg.get_idle_line()) wait(`LINE == 'b0);  // if idle is 1, then to wait the value to 0
	else wait(`LINE == 'b1); // if idle is 0, then to wait the value to 1

	// 2. start to sampling and translating line value
	//
	rsp.stime = $time;

	get_assemble(assemble);
	dass = disassemble(assemble);
	if (m_cfg.get_parity_en()) parity_check(dass);
	rsp_translate(dass);

	rsp.etime = $time;

	// calculating the frequency of current sub-frame
	// frequency calculation formula: 1/(((sub-frame duration time) * 2) /1ns)
	//
	rsp.freq = get_sample_freq();


	`uvm_info(get_type_name()," [FLOW_TRACE] leaving rsp_tr_mon ... ...", UVM_HIGH)

	// after all, this rsp transaction will be sent by parent class in send task.
	return;

endtask : rsp_tr_mon

function void spdif_mon::parity_check(input bit [35:0] _dass);
	bit [31:0] bmc;
	// if parity check error, then to report an uvm_error, and the data and process will not be stopped.

	// first to decode the preamble,
	bmc[31:4] = _dass[35:8];
	if (_dass[7] == _dass[6]) bmc[3] = 1'b0; else bmc[3] = 1'b1;
	if (_dass[5] == _dass[4]) bmc[2] = 1'b0; else bmc[2] = 1'b1;
	if (_dass[3] == _dass[2]) bmc[1] = 1'b0; else bmc[1] = 1'b1;
	if (_dass[1] == _dass[0]) bmc[0] = 1'b0; else bmc[0] = 1'b1;

	// start to check the parity.
	//
	TODO

	return;
endfunction : parity_check

function void spdif_mon::rsp_translate(input bit [35:0] _dass);
	// the function to assign all translated values to rsp transaction.
	rsp.prea  = spdif_preamble_enum'(_dass[7:0]);
	rsp.aux   = _dass[11:8];
	rsp.audio = _dass[31:12];
	rsp.valid = _dass[32];
	rsp.chnl  = _dass[33];
	rsp.user  = _dass[34];
	rsp.ep    = _dass[35];

	return;

endfunction : rsp_translate

function bit[35:0] spdif_mon::disassemble(input bit [63:0] _ass);
	bit[35:0] rtn;
	bit [31:0] bmc;

	int loop;
	int pos = 0;

	for (loop = 0;loop < 64;loop+=2) begin // {
		if (loop < 8) begin // {
			// if the loop in ranges of 0~7, it means now is the preamble range, need to get the value without disassemblance.
			// however, because the increment of loop is 2, so need to assign 2-bit value to rtn once.
			//
			rtn[pos] = _ass[loop];pos++;
			rtn[pos] = _ass[loop+1];
		// }
		end else begin // {
			if (_ass[loop] == _ass[loop+1]) begin // {
				// to check if the bit of current loop and next loop is the same
				// then the decoded value is 0.
				rtn[pos] = 1'b0;
			// }
			end else begin // {
				// else if the value is different, then the decode value is 1.
				rtn[pos] = 1'b1;
			end // }
		end // }
		pos++;
	end // }

	return rtn;
endfunction : disassemble

task spdif_mon::get_assemble(output bit[63:0] _pa);
	realtime stime;  // start time for calculating the period time, by calculating the first 3 bit of preamble.
	realtime etime;  // end time for calculating the period time, by calculating the first 3 bit of preamble.
	// bit [7:0] _pa;   // assembled preamble.
	int loop;

	case (m_cfg.get_idle_line()) // {
		'b0: begin // {
			// block if the idle value is 0
			// current spdif line in this time slot is 1, the preamble will be 1110_XXXX
			stime = $time; // getting the current time for calculating the period time.
			wait(`LINE == 'b0);
			etime = $time; // getting the end time
			set_period(stime,etime);
			wait_period();
			// current time slot: the 4th sample clock posedge of the spdif line.
			//
			_pa[0:3] = 3'b1110;
			// start getting the next 60-bit value.
			//
			for (loop = 0; loop < 60; loop++) begin // {
				wait_period(); // first wait one period.
				_pa[loop+4] = `LINE;
			end // }
			// time slot now: the end time of current sub-frame.
		end // }
		'b1: begin // {
			// block if the idle value is 1
		end // }
	endcase // }

endtask : get_assemble

function void spdif_mon::set_period(input realtime _s, input realtime _e);

	if (_e > _s) begin // {
		__period__ = (_e - _s) / 3.00;
		`ifdef `__DBG__
			`uvm_info(get_type_name(),$sformatf(" [__DBG__][set_period] getting the period value: %0f",__period__),UVM_LOW)
		`endif
	// }
	end else begin // {
		// print a fatal for invalid time period
		`uvm_fatal(get_type_name()," [set_period] fatal arguments set when calling this function, the end time is larger then start time")
	end // }

	return;

endfunction : set_period

task spdif_mon::wait_period();

	#__period__;

	return;
endtask : wait_period

`endif // SPDIF_MON__SVH
