`ifndef UPI_MDP__SVH
`define UPI_MDP__SVH


class upi_mdp #(AW = 32, DW = 32) extends uvm_component;


	upi_mdp_cfg #(AW,DW) m_cfg;

	`uvm_component_utils(upi_mdp#(AW,DW))


	`include "data/mdp/upi_mdp_api.svh"

	// constructor
	//
	function new (string name = "upi_mdp", uvm_component parent = null);
		super.new(name,parent);
		// create m_cfg component
		m_cfg = upi_mdp_cfg#(AW,DW)::type_id::create("m_cfg");
	endfunction


	/* phases */
	extern function void build_phase (uvm_phase phase);
	extern task main_phase (uvm_phase phase);
	/**********/

	// extern task do_slv_action(); // task to do MDP_SLV typed actions, which called in main phase.

endclass : upi_mdp

function void upi_mdp::build_phase (uvm_phase phase);

	case (m_cfg.__bic__.bic_t) // {
		AHBL_SLV: begin // {
			uvm_config_db #(virtual ahbl_slv_ifc)::get(this,"","ahbl_slv_ifc",m_cfg.ahbls_if);
		end // }
	endcase // }

	return;

endfunction : build_phase

// Task: main_phase
// this phase here will do the main actions.
// there'are two alternative types for user to set: MDP_MST or MDP_SLV.
//
//
task upi_mdp::main_phase (uvm_phase phase);

//	// switch the current mdp_t
//	case (__bic__.mdp_t) // {
//		MDP_MST: begin // {
//			// master MDP device UPI
//		end // }
//		MDP_SLV: begin // {
//			// slave MDP device UPI
//			// this component will control the BIC and UPI level actions.
//			do_slv_action();
//		end // }
//	endcase // }

endtask : main_phase

// task upi_mdp::do_slv_action();
// 	case (__bic__.bic_t) // {
// 		AHBL_SLV: begin // {
// 			forever __drive_ahbl_slv__();
// 		end // }
// 	endcase // }
//
// endtask : do_slv_action

`endif // UPI_MDP__SVH
