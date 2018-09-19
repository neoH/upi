`ifndef AHBL_SLV_API__SVH
`define AHBL_SLV_API__SVH

/*************************************************************************************************************
this api is a direct included file designed for UPI creator to do control actions.
*************************************************************************************************************/


/*************************************************************************************************************
APIs for controlling:
	All the APIs for controlling will described in user guide document.
*************************************************************************************************************/

// API to set active or passive mode, in active mode, the driver will be instantiated and the interface
// connected with DUT will be driven by BIC component. The other mode the driver will not work.
//
function void set_active; m_cfg.set_active; endfunction
function void set_passive; m_cfg.set_passive; endfunction

// API to set upi or vip mode, currently only UPI mode supported.
//
function void set_upi; m_cfg.set_upi; endfunction
function void set_vip; m_cfg.set_vip; endfunction

// API to add space range
function void add_space(input bit[AW-1:0] lb, input bit [AW-1:0] ub); m_cfg.add_space(lb,ub); endfunction


// API to set default value of memory
function void set_default_val(input mem_val_enum val); m_cfg.m_mem.set_default_val(val); endfunction

// API to set hprot
function void set_prot_en(input bit [1:0] prot); m_cfg.set_prot_en(prot); endfunction

// for now, only support auto mode, so provide auto API only.
function void set_dev_auto; m_cfg.set_dev_auto; endfunction

// a function to set the max delay value for slave device
function void set_max_delay(input uint32_t val); m_cfg.set_max_delay(val); endfunction

/***********************************************************************************************************/




/*************************************************************************************************************
APIs for monitoring:
*************************************************************************************************************/


// task to wait the request valid, and then pop one request trans to caller
//
task wait_req(output MREQ req);

	if (mreq_que.size() == 0) begin // {
		wait (mreq_que.size()); // if current que is empty, then to wait not empty.
	end // }

	req = mreq_que.pop_front(); // assign the first item to the output request.

	return;

endtask : wait_req

// task to wait the response valid, and then pop one response trans to caller
//
task wait_rsp (output MRSP rsp);
	if (mrsp_que.size() == 0) begin // {
		wait (mrsp_que.size()); // if current que is empty, then to wait until not empty
	end // }
	rsp = mrsp_que.pop_front(); // assign the first item to output.
	return;
endtask : wait_rsp


/***********************************************************************************************************/

`endif // AHBL_SLV_API__SVH
