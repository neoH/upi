`ifndef AHBL_SLV_API__SVH
`define AHBL_SLV_API__SVH

/*************************************************************************************************************
this api is a direct included file designed for UPI creator to do control actions.
*************************************************************************************************************/


/**************************************************************************************************
APIs for controlling:
**************************************************************************************************/

// API to set active or passive mode
function void set_active; m_cfg.set_active; endfunction
function void set_passive; m_cfg.set_passive; endfunction

// API to set upi or vip mode
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

`endif // AHBL_SLV_API__SVH
