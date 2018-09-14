`ifndef AHBL_SLV_IFC__SV
`define AHBL_SLV_IFC__SV

interface ahbl_slv_ifc #(
	AW = 32, /* address width */
	DW = 32  /* data width */
) (input logic hclk, input logic hresetn);

	logic [2:0]      hburst;
	logic [1:0]      htrans;
	logic [AW-1:0]   haddr;
	logic [2:0]      hsize;
	logic [1:0]      hprot;
	logic            hsel;
	logic            hwrite;
	logic            hmstlock;
	logic            hready;
	logic [1:0]      hresp;

	logic [DW-1:0]   hwdata;
	logic [DW-1:0]   hrdata;

endinterface : ahbl_slv_ifc

`endif // AHBL_SLV_IFC__SV
