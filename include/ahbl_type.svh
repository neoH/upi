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
// * FILE NAME       :  ahbl_dtype.svh
// * CREATOR         :  huangqi
// * AUTHOR          :
// * ORIGINAL TIME   : Tue May 29 11:08:32 CST 2018
// * RELEASE HISTORY :
// *                   version v1.0: creation
// * DESCRIPTION     :
// *
// *
// ***********************************************************************************
`ifndef AHBL_TYPE__SVH
`define AHBL_TYPE__SVH

typedef enum logic [1:0]
{
	AHBL_IDLE   = 'b00,
	AHBL_BUSY   = 'b01,
	AHBL_SEQ    = 'b10,
	AHBL_NONSEQ = 'b11,
	AHBL_HTRANS_X = 'bxx
} ahbl_htrans_enum;

// T: ahbl_hburst_enum
//
// Enum of burst type, each field indicates the corresponding burst type
//
typedef enum logic [2:0]
{
	AHBL_SINGLE = 'h0,
	AHBL_INCR   = 'h1,
	AHBL_WRAP4  = 'h2,
	AHBL_INCR4  = 'h3,
	AHBL_WRAP8  = 'h4,
	AHBL_INCR8  = 'h5,
	AHBL_WRAP16 = 'h6,
	AHBL_INCR16 = 'h7,
	AHBL_HBURST_X = 'hx
} ahbl_hburst_enum;

typedef enum logic
{
	AHBL_RD = 'b0,
	AHBL_WR = 'b1,
	AHBL_RW_X = 'bx
} ahbl_rw_enum;

// T: ahbl_resp_enum
//
// Type of response, in ahbl, valid only within AHBL_OKAY, AHBL_ERR
//
typedef enum logic [1:0]
{
	AHBL_OKAY   = 'h0,
	AHBL_ERROR  = 'h1,
	AHBL_RESP_X = 'hx
} ahbl_resp_enum;

// T: ahbl_size_enum
//
// Type to define the size of each htrans
//
typedef enum logic [2:0]
{
	AHBL_BYTE  = 'h0,
	AHBL_HWORD = 'h1,
	AHBL_WORD  = 'h2,
	AHBL_DWORD = 'h3,
	AHBL_FWORD = 'h4,
	AHBL_EWORD = 'h5,
	AHBL_SWORD = 'h6,
	AHBL_TWORD = 'h7,
	AHBL_HSIZE_X = 'hx
} ahbl_hsize_enum;

// T: ahbl_switch_enum
//
// Type to define the switch enum type.
//
typedef enum
{
	AHBL_DIS,
	AHBL_EN
} ahbl_switch_enum;


typedef enum bit [2:0]
{
	AHBL_MST = 'b001,
	AHBL_SLV = 'b010,
	AHBL_MUX = 'b100
} ahbl_device_enum;


typedef enum
{
	AHBL_START,
	AHBL_END
} ahbl_trans_event_enum;

typedef enum
{
	AHBL_REQ,
	AHBL_RSP
} ahbl_trans_type_enum;


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// -- struct declarations

typedef struct
{
	ahbl_resp_enum  hresp;
	uvm_bitstream_t hrdata;
} ahbl_resp_struct;


// the struct that used to store the following formatted htrans information
// address width: 32-bit
// data width : 32-bit
//

class ahbl_htrans #(AW = 32, DW = 32) extends uvm_object;

	ahbl_htrans_enum htrans;
	ahbl_hburst_enum hburst;
	ahbl_rw_enum     hwrite;
	ahbl_hsize_enum  hsize;
	bit [AW-1:0]     haddr;
	bit [DW-1:0]     hwdata;
	bit              hmstlock;
	bit [3:0]        hprot;

	`uvm_object_utils(ahbl_htrans)

	// constructor
	function new (string name = "ahbl_htrans"); super.new(name); endfunction

endclass : ahbl_htrans

typedef class ahbl_htrans;


// operation mode, automatically or manually
//
typedef enum
{
	AHBL_AUTO,
	AHBL_MANUAL
} ahbl_oper_mode;


`endif // AHBL_MST_TYPE__SVH
