`ifndef BIC_PKG__SV
`define BIC_PKG__SV

// to include all sub package files

// ahbl_slv_pkg
`include "bic/ahbl/slv/ahbl_slv_pkg.sv"

package bic_pkg;

	import uvm_pkg::*;

	import ahbl_slv_pkg::*;


endpackage : bic_pkg

`endif // BIC_PKG__SV
