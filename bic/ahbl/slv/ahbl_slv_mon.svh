`ifndef AHBL_SLV_MON__SVH
`define AHBL_SLV_MON__SVH

class ahbl_slv_mon #(AW,DW,type IFC,type REQ,type RSP) extends uvm_monitor #(REQ,RSP);

	ahbl_slv_cfg #(AW,DW,IFC) m_cfg;


	`uvm_component_utils(ahbl_slv_mon#(AW,DW,IFC,REQ,RSP))

	// constructor
	function new (string name = "ahbl_slv_mon", uvm_component parent = null); super.new(name,parent); endfunction



endclass : ahbl_slv_mon

`endif // AHBL_SLV_MON__SVH
