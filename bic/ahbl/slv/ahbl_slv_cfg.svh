`ifndef AHBL_SLV_CFG__SVH
`define AHBL_SLV_CFG__SVH

/*************************************************************************************************************************
*************************************************************************************************************************/
class ahbl_slv_cfg #(AW,DW,type IFC) extends uvm_object;

	local static string __owner__ = "JoachimH";
	rand uint32_t __rdelay__;

	virtual ahbl_slv_ifc #(AW,DW) vifc;

	// ---- API
	function void set_ifc(input IFC ifc); vifc = ifc; endfunction

	/*****************************************************************/
	// configures for active or passive mode
	// ---- CFG
	local uvm_active_passive_enum __active__ = UVM_ACTIVE;
	// ---- API
	function void set_active; __active__ = UVM_ACTIVE; endfunction
	function void set_passive; __active__ = UVM_PASSIVE; endfunction
	function uvm_active_passive_enum get_active(); return __active__; endfunction
	/*****************************************************************/
	// memory api to store and process all the slave memory spaces
	// ---- CFG
	mem_api #(bit[AW-1:0],bit[DW-1:0]) m_mem;
	function void write(input bit[AW-1:0] addr, bit[DW-1:0] data, input ahbl_size_enum size);
		uint32_t len;
		case (size) // {
			AHBL_BYTE : begin len = 1; end
			AHBL_HWORD: begin len = 2; end
			AHBL_WORD : begin len = 4; end
			AHBL_DWORD: begin len = 8; end
			AHBL_FWORD: begin len = 16; end
			AHBL_EWORD: begin len = 32; end
			AHBL_SWORD: begin len = 64; end
			AHBL_TWORD: begin len = 128; end
		endcase // }
		m_mem.write(addr,data,len);
	endfunction : write

	function void read(input bit [AW-1:0] addr, input ahbl_size_enum size, ref bit[DW-1:0] rdata);
		uint32_t len;
		case (size) // {
			AHBL_BYTE : begin len = 1; end
			AHBL_HWORD: begin len = 2; end
			AHBL_WORD : begin len = 4; end
			AHBL_DWORD: begin len = 8; end
			AHBL_FWORD: begin len = 16; end
			AHBL_EWORD: begin len = 32; end
			AHBL_SWORD: begin len = 64; end
			AHBL_TWORD: begin len = 128; end
		endcase // }
		if (m_mem.read(addr,len,rdata)) begin // {
			// report fatal because the driver has a bug
			`uvm_fatal(get_type_name(),$sformatf(" [BICF][read] the BIC occurred a fatal, please contact the owner: %s",__owner__))
		end // }
	endfunction : read
	//function void set_default_val(input mem_val_enum _val); m_mem.set_default_val(_val); endfunction
	/*****************************************************************/
	// configures for selecting the bic to UPI type or VIP type
	// ---- CFG
	local bic_type_enum __bt__ = UPI; // default is UPI mode
	// ---- API
	function void set_upi; __bt__ = UPI; endfunction
	function void set_vip; __bt__ = VIP; endfunction
	function bic_type_enum get_bic_type(); return __bt__; endfunction
	/*****************************************************************/
	// configure the hprot signal, if this value is set and the en flag is actived,
	// then only requests with corresponding hprot will be respond, or else will be
	// respond an error
	// ---- CFG
	local bit [2:0] __prot__  = 'h0;
	local bit __is_proted__   = 'b0;

	function void set_prot_en(input bit [1:0] prot); __prot__ = prot; __is_proted__ = 'b1; endfunction
	function void prot_dis; __is_proted__ = 'b0; endfunction // disable the protect feature
	function bit  get_prot_st(); return __is_proted__; endfunction  // get the protect status
	function bit[2:0] get_prot_val(); return __prot__; endfunction  // get the protect value
	/*****************************************************************/
	// configure the space map for this slave device, incontinuous space are permitted.
	// ---- CFG
	// the boundry space represented by the lb_list and ub_list, each of one specified by the same index
	// consists one space range of this slave device.
	local bit [AW-1:0] lb_list[$];    // list of lower boundry
	local bit [AW-1:0] ub_list[$];    // list of upper boundry
	local uint32_t __size__ = 0;  // the size value, used for memory

	// ---- API
	// this is a function to set the valid space value of this slave, multiple calling this function
	// will add a multiple space for this slave.
	function void add_space(input bit [AW-1:0] lb, input bit [AW-1:0] ub);
		lb_list.push_back(lb);
		ub_list.push_back(ub);
		// each time after calling add_space, need to check the lb and ub are paired.
		if (lb_list.size() != ub_list.size()) begin // {
			`uvm_fatal(get_type_name(),$sformatf(" [BICF] BIC fatal occurred, the device space is not paired, pls contact the owner:%s.",__owner__))
		end // }

		// check the maximum address
		if (__size__ != uint32_t'(get_ub_max() - get_lb_min()) begin // {
			// if the size changes, then need to resize the memory
			__size__ = uint32_t'(get_ub_max() - get_lb_min());
			m_mem.set_size(__size__);
		end // }
		return;
	endfunction : add_space

	// ---- an API to get the min value from lb_list
	function bit [AW-1:0] get_lb_min();
		bit [AW-1:0] lb_min[$] = lb_list.min; // get the min list of lb_list
		return lb_min.pop_front(); // return the first item in min list
	endfunction : get_lb_min

	// ---- ap API to get the max value from ub_list
	function bit [AW-1:0] get_ub_max();
		bit [AW-1:0] ub_max[$] = ub_list.max; // get the max list of ub_list
		return ub_max.pop_front(); // return the first item in max list
	endfunction : get_ub_max

	// function to check the enterred address is in range or not, if is, then return 1, else return 0.
	//
	function bit is_in_range(input bit [AW-1:0] targ, input ahbl_size_enum size);
		uint32_t loop = 0;
		uint32_t len;
		case (size) // {
			AHBL_BYTE : begin len = 1; end
			AHBL_HWORD: begin len = 2; end
			AHBL_WORD : begin len = 4; end
			AHBL_DWORD: begin len = 8; end
			AHBL_FWORD: begin len = 16; end
			AHBL_EWORD: begin len = 32; end
			AHBL_SWORD: begin len = 64; end
			AHBL_TWORD: begin len = 128; end
		endcase // }
		while (loop < lb_list.size()) begin // {
			if ((targ+len) >= lb_list[loop] && (targ+len) <= ub_list[loop]) return 'b1;
			loop++;
		end // }
		return 'b0; // if all range in the list not matched, then it means this targ is out of range
	endfunction : is_in_range
	/*****************************************************************/
	// configure that specify the responding mode, default is auto
	// ---- CFG
	local ahbl_oper_mode __dev_resp__ = AHBL_AUTO;
	function void set_dev_auto; __dev_resp__ = AHBL_AUTO; endfunction
	function void set_dev_manual; __dev_resp__ = AHBL_MANUAL; endfunction
	function ahbl_oper_mode get_dev_mode(); return __dev_resp__; endfunction
	/*****************************************************************/
	// configure to store the delay info, which will used in auto mode
	// ---- CFG
	local uint32_t __max_delay__ = 100; // default is 100
	function void set_max_delay(input uint32_t val); __max_delay__ = val; endfunction
	function uint32_t get_rand_delay();
		std::randomize(__rdelay__) with { __rdelay__ inside {[0:__max_delay__]};};
		return __rdelay__;
	endfunction : get_rand_delay
	/*****************************************************************/

	`uvm_object_utils(ahbl_slv_cfg#(AW,DW,IFC))


	// constructor
	function new (string name = "ahbl_slv_cfg");
		super.new(name);
		m_mem = mem_api#(bit[AW-1:0],bit[DW-1:0])::type_id::create("m_mem");
	endfunction


endclass : ahbl_slv_cfg

`endif // AHBL_SLV_CFG__SVH
