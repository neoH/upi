`ifndef AHBL_SLV_TRANS__SVH
`define AHBL_SLV_TRANS__SVH

/*************************************************************************************************************************
*************************************************************************************************************************/

// this transaction is for mapping the response data and information for the slave device
// user of the slave device can determin how the slave will act when getting one ahbl request. For example,
// respond OKAY or ERROR, how many cycle will be delayed, and the responding data.
// Each trans indicates each htrans in AHBL protocol.
//
/* TODO , this class may not used for current version 1.00 */
class ahbl_slv_treq #(DW = 32) extends uvm_sequence_item;

	rand uint32_t delay;  // this var indicates the delay cycle when receiving the request.
	rand bit [DW-1:0] rdata;
	rand ahbl_resp_enum resp;

	`uvm_object_utils_begin(ahbl_slv_treq)
		`uvm_field_int(delay,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_enum(ahbl_resp_enum,resp,UVM_ALL_ON)
	`uvm_object_utils_end

	// constructor
	function new (string name = "ahbl_slv_treq"); super.new(name); endfunction


endclass : ahbl_slv_treq

// -----------------------------------------------------------------------------------------------------------------
// Class: ahbl_req_mtrans
//
// This class is a uvm_object used to be a monitor transaction. Each transaction indicates one htrans information.
//
// -----------------------------------------------------------------------------------------------------------------

class ahbl_req_mtrans #(AW = 32, DW = 32) extends uvm_sequence_item;

	// Var: prot
	//
	// indicates hprot
	//
	rand bit [3:0] prot;

	// Var: trans
	//
	// indicates htrans.
	//
	rand ahbl_htrans_enum trans;

	// Var: addr
	//
	// Indicates address of current htrans
	//
	rand bit [AW - 1 : 0] addr;

	// Var: wdata
	rand bit [DW - 1 : 0] wdata;

	// Var: size
	//
	rand ahbl_hsize_enum size;

	// Var: burst
	//
	rand ahbl_hburst_enum burst;

	// Var: rw
	//
	rand ahbl_rw_enum rw;

	// Var: lock
	//
	rand bit lock;

	// Var: stime
	//
	// trans start time
	//
	time stime;

	// Var: etime
	//
	// trans end time
	//
	time etime;

	`uvm_object_utils_begin(ahbl_req_mtrans)
		`uvm_field_enum(ahbl_htrans_enum,trans,UVM_ALL_ON)
		`uvm_field_enum(ahbl_hsize_enum,size,UVM_ALL_ON)
		`uvm_field_enum(ahbl_rw_enum,rw,UVM_ALL_ON)
		`uvm_field_enum(ahbl_hburst_enum,burst,UVM_ALL_ON)
		`uvm_field_int(lock,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(wdata,UVM_ALL_ON)
		`uvm_field_int(prot,UVM_ALL_ON)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end


	function new (string name = "ahbl_req_mtrans"); super.new(name); endfunction

endclass : ahbl_req_mtrans

// -----------------------------------------------------------------------------------------------------------------
// Class: ahbl_rsp_mtrans
//
// This class is a uvm_object used to be a monitor transaction. Each transaction indicates one htrans information.
//
// -----------------------------------------------------------------------------------------------------------------
class ahbl_rsp_mtrans #(AW = 32, DW = 32) extends uvm_sequence_item;

	// Var: prot
	//
	// indicates hprot
	//
	rand bit [3:0] prot;

	// Var: trans
	//
	// indicates htrans.
	//
	rand ahbl_htrans_enum trans;

	// Var: addr
	//
	// Indicates address of current htrans
	//
	rand bit [AW - 1 : 0] addr;

	// Var: rdata
	rand bit [DW - 1 : 0] rdata;

	// Var: size
	//
	rand ahbl_hsize_enum size;

	// Var: burst
	//
	rand ahbl_hburst_enum burst;

	// Var: rw
	//
	rand ahbl_rw_enum rw;

	// Var: lock
	//
	rand bit lock;

	// Var: stime
	//
	// trans start time
	//
	time stime;

	// Var: etime
	//
	// trans end time
	//
	time etime;

	ahbl_resp_enum resp;

	`uvm_object_utils_begin(ahbl_rsp_mtrans)
		`uvm_field_enum(ahbl_htrans_enum,trans,UVM_ALL_ON)
		`uvm_field_enum(ahbl_hsize_enum,size,UVM_ALL_ON)
		`uvm_field_enum(ahbl_rw_enum,rw,UVM_ALL_ON)
		`uvm_field_enum(ahbl_hburst_enum,burst,UVM_ALL_ON)
		`uvm_field_enum(ahbl_resp_enum,resp,UVM_ALL_ON)
		`uvm_field_int(lock,UVM_ALL_ON)
		`uvm_field_int(addr,UVM_ALL_ON)
		`uvm_field_int(rdata,UVM_ALL_ON)
		`uvm_field_int(prot,UVM_ALL_ON)
		`uvm_field_real(stime,UVM_ALL_ON|UVM_NOCOMPARE)
		`uvm_field_real(etime,UVM_ALL_ON|UVM_NOCOMPARE)
	`uvm_object_utils_end

	// Constructor
	function new (string name = "ahbl_rsp_mtrans"); super.new(name); endfunction

	function void set_req_info(input ahbl_req_mtrans mreq);
		prot  = mreq.prot;
		trans = mreq.trans;
		addr  = mreq.addr;
		size  = mreq.size;
		burst = mreq.burst;
		rw    = mreq.rw;
		lock  = mreq.lock;
	endfunction : set_req_info

endclass : ahbl_rsp_mtrans

// -----------------------------------------------------------------------------------------------------------------



`endif // AHBL_SLV_TRANS__SVH
