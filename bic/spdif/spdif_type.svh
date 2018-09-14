`ifndef SPDIF_TYPE__SVH
`define SPDIF_TYPE__SVH

/*
*/


// define the enum type of all supported SPDIF sample frequency
//
typedef enum
{
	32K,
	44P1K,
	48K,
	88K,
	96K,
	192K,
	RO   // the frequency is out of range, and not detected in current spec.
} spdif_sample_freq_enum;

//
typedef enum bit[7:0]
{
	B  = 8'b1110_1000,
	W  = 8'b1110_0010,
	M  = 8'b1110_0100,
	RB = 8'b0001_0111,  // reversed B
	RW = 8'b0001_1101,  // reversed W
	RM = 8'b0001_1011,  // reversed M
	ILL // the illegal preamble type
} spdif_preamble_enum;


`endif // SPDIF_TYPE__SVH
