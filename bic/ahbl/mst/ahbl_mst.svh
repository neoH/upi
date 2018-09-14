`ifndef AHBL_MST__SVH
`define AHBL_MST__SVH

/**********************************************************************************************************
Conclusive description of this class:
	The class, which named ahbl_mst, is designed as a container of all basic classes that process the bottom
signal level actions. For example, the driver to drive interface signals according to the transaction while
the monitor to sample and translating the target interface signals. All of features of this class will be
listed in the following:
-- components instantiated: ahbl_mst_drv, ahbl_mst_mon, ahbl_mst_seqr
-- ahbl_mst_cfg: this component gets from upper level by uvm_config_db, so here only to declare a container
to get the real handler from top level.
-- port definition for monitor transaction transmission.
**********************************************************************************************************/

class ahbl_mst #(
	type REQ = ahbl_mst_req,
	RSP = ahbl_mst_rsp,
	CFG = ahbl_mst_cfg
) extends bic #(CFG,ahbl_mst_drv#(REQ,RSP,CFG),ahbl_mst_mon#(REQ,RSP,CFG),ahbl_mst_seqr#(REQ,RSP));


	// ahbl_mst_cfg
	//
	//
	//


	`uvm_component_utils(ahbl_mst)


	// constructor
	function new (string name = "ahbl_mst", uvm_component parent = null); super.new(name,parent); endfunction






endclass : ahbl_mst

`endif // AHBL_MST__SVH
