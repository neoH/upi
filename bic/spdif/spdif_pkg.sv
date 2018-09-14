`ifndef SPDIF_PKG__SV
`define SPDIF_PKG__SV

`include "spdif_ifc.sv"

package spdif_pkg;

	import uvm_pkg::*;
	import bic_cmn_pkg::*;

	`include "types.svh"

	`include "spdif_def.svh"
	`include "spdif_type.svh"

	`include "spdif_trans.svh"
	`include "spdif_cfg.svh"
	`include "spdif_drv.svh"
	`include "spdif_mon.svh"
	`include "spdif_seqr.svh"
	`include "spdif.svh"

	`include "spdif_udef.svh"

endpackage : spdif_pkg

`endif // SPDIF_PKG__SV
