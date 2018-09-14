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
// * FILE NAME       :  ahbl_def.svh
// * CREATOR         :  huangqi
// * AUTHOR          : 
// * ORIGINAL TIME   : Thu May 31 14:36:40 CST 2018
// * RELEASE HISTORY :
// *                   version v1.0: creation
// * DESCRIPTION     :
// *
// *
// ***********************************************************************************
`ifndef AHBL_DEF__SVH
`define AHBL_DEF__SVH

`define HCLK    m_cfg.vifc.hclk
`define HRESETN m_cfg.vifc.hresetn
`define HADDR   m_cfg.vifc.haddr
`define HBURST  m_cfg.vifc.hburst
`define HTRANS  m_cfg.vifc.htrans
`define HSIZE   m_cfg.vifc.hsize
`define HPROT   m_cfg.vifc.hprot
`define HWRITE  m_cfg.vifc.hwrite
`define HMSTLOCK m_cfg.vifc.hmastlock
`define HRDATA   m_cfg.vifc.hrdata
`define HRESP    m_cfg.vifc.hresp
`define HREADY   m_cfg.vifc.hready
`define HWDATA   m_cfg.vifc.hwdata



`endif
