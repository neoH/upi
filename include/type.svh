// -- Author: JoachimH
// -- Date  : Sep 10, 2018
// -- File  : type.svh

/* type.svh is a file for definition all types that commonly in all systemverilog based language */

typedef int unsigned uint32_t;
typedef bit [15:0]   uint16_t;
typedef bit [7:0]    uint8_t;

// the enumerate type defined to indicates all the access type,
// such as read, write etc.
//
typedef enum
{
	read,
	write
} access_type_enum;
