// ***********************************************************************************
// *
// *         *****                    *****        ****     ****   ****        ****
// *       *********                **********     ****    ****     ****      ****
// *     ****     ****             ****    ****    ****   ****       ****    ****
// *    ****       ****           ****      ****   ****  ****         ****  ****
// *   ****                       ****             **** ****           ********
// *   ****              *******    ****           ********              ****
// *   ****              *******       *****       **** ****             ****
// *   ****                                ****    ****  ****            ****
// *    ****       ****            ****     ****   ****   ****           ****
// *     ****      ****            ****     ****   ****    ****          ****
// *       **********               ***** *****    ****     ****         ****
// *         ******                   *******      ****      ****        ****
// *
// *
// ***********************************************************************************
// *
// *
// * C-Sky Microsystems Confidential                                                 *
// * -------------------------------                                                 *
// * This file and all its contents are properties of C-Sky Microsystems. The        *
// * information contained herein is confidential and proprieatary and is not        *
// * to be disclosed outside of C-Sky Microsystems except under a Non-Disclosure     *
// * Agreement (NDA).                                                                *
// ***********************************************************************************
// *
// * FILE NAME       :  ahbl_mst_ifc.sv
// * CREATOR         :  huangqi
// * AUTHOR          : 
// * ORIGINAL TIME   : Fri Jun  1 15:51:15 CST 2018
// * RELEASE HISTORY :
// *                   version v1.0: creation
// * DESCRIPTION     :
// *
// *
// ***********************************************************************************
`ifndef AHBL_MST_IFC__SV
`define AHBL_MST_IFC__SV

interface ahbl_mst_ifc #(parameter AHBL_ADDR_WIDTH = 32, AHBL_WDATA_WIDTH = 32, AHBL_RDATA_WIDTH = 32) (input logic hclk, input logic hresetn, input logic tb_assert_clk);

	logic hwrite;
	logic hready;
	logic hmastlock;

	logic [2:0] hsize;
	logic [1:0] htrans;
	logic [2:0] hburst;
	logic [3:0] hprot;
	logic [1:0] hresp;

	logic [AHBL_ADDR_WIDTH - 1 : 0] haddr;
	logic [AHBL_WDATA_WIDTH - 1 : 0] hwdata;
	logic [AHBL_RDATA_WIDTH - 1 : 0] hrdata;



	/* ---------- Assertion Declaration ---------- */
	/* ------------------------------------------- */

endinterface : ahbl_mst_ifc

`endif
