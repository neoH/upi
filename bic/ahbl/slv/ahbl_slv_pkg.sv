`ifndef AHBL_SLV_PKG__SV
`define AHBL_SLV_PKG__SV

`include "bic/ahbl/slv/ahbl_slv_ifc.sv"

package ahbl_slv_pkg;

	`include "include/type.svh"

	import uvm_pkg::*;

	`include "include/ahbl_type.svh"
	`include "include/bic_type.svh"

	`include "commons/mem_api.svh"

	`include "bic/ahbl/slv/ahbl_slv_def.svh"

	`include "bic/ahbl/slv/ahbl_slv_trans.svh"
	`include "bic/ahbl/slv/ahbl_slv_cfg.svh"
	`include "bic/ahbl/slv/ahbl_slv_drv.svh"
	`include "bic/ahbl/slv/ahbl_slv_mon.svh"

	`include "bic/ahbl/slv/ahbl_slv.svh"

	`include "bic/ahbl/slv/ahbl_slv_udef.svh"


endpackage : ahbl_slv_pkg

`endif // AHBL_SLV_PKG__SV
