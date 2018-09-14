`ifndef AHBL_MST_PKG__SV
`define AHBL_MST_PKG__SV

/* this package must be imported in bic_pkg, and can not be used alone */
package ahbl_mst_pkg;

	import uvm_pkg::*;
	import cmn_pkg::*;

	`include "ahbl_mst_def.svh"
	`include "ahbl_mst_type.svh"


endpackage : ahbl_mst_pkg

`endif // AHBL_MST_PKG__SV
