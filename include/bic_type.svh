`ifndef BIC_TYPE__SVH
`define BIC_TYPE__SVH


// a enum type for defining the bic mode, which will influent the connection
// with other components
//
typedef enum
{
	UPI,   // with an UPI in high level
	VIP    // normal VIP mode, which used as uvc
} bic_type_enum;


`endif // BIC_TYPE__SVH
