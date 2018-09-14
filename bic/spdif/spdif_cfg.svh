`ifndef SPDIF_CFG__SVH
`define SPDIF_CFG__SVH


/*************************************************************************************************************
File: spdif_cfg.svh
Author: JoachimH
Version: v1.00
*************************************************************************************************************/


class spdif_cfg extends bic_cfg;


	// __idle_line__
	// flag of idle level in spdif line. Default is 0, which means if the data is invalid on spdif, the value should
	// be 0. This config can be changed during simulation for multi-times.
	//
	local bit __idle_line__ = 'b0;

	// ----- APIs
	//
	// Func: set_idle_high
	//
	function void set_idle_high(); __idle_line__ = 'b1; endfunction

	// Func: set_idle_low
	//
	function void set_idle_low(); __idle_line__ = 'b0; endfunction

	// Func: get_idle_line
	// API function to return __idle_line__
	function bit get_idle_line(); return __idle_line__; endfunction

	/***********************************************************************************************************/

	// __freq_rdnd__
	// the error redundancy of the frequency, which created to indicate the monitor to choose the value of
	// spdif_sample_freq_enum
	// the range of this value is 0~100 to represent from percentage 0 to percent 100 seperately.
	// the default value is 0.
	//
	local uint32_t __freq_rdnd__ = 0;

	// ----- APIs
	//

	// Func: set_freq_rdnd
	// a function to set frequence redundancy.
	// by calling this function during simulation is allowed, which will influent the following actions of the BIC.
	//
	function void set_freq_rdnd(input uint32_t _val); __freq_rdnd__ = _val; endfunction

	// Func: get_freq_rdnd
	// a function to return the frequency redundancy value.
	//
	function uint32_t get_freq_rdnd(); return __freq_rdnd__; endfunction
	/***********************************************************************************************************/


	// __parity_en__
	// a 1-bit flag that indicates the parity check in monitor, if this bit is enabled, then the monitor will check the
	// parity bit, in SPDIF BIC, only even parity is need.
	//
	local bit __parity_en__ = 'b0;

	// Func: set_parity_on
	// a function to set parity enabled.
	//
	function void set_parity_on(); __parity_en__ = 'b1; endfunction

	// Func: set_parity_off
	// a function to set parity disabled.
	//
	function void set_parity_off(); __parity_en__ = 'b0; endfunction

	// Func: get_parity_en
	// a function to get the __parity_en__ value.
	//
	function bit get_parity_en(); return __parity_en__; endfunction
	/***********************************************************************************************************/

	`uvm_object_utils(spdif_cfg)


	// constructor
	function new (string name = "spdif_cfg");
		super.new(name);
		req_dis();  // set req features disabled in version v1.00.
	endfunction



endclass : spdif_cfg

`endif // SPDIF_CFG__SVH
