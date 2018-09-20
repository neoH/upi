// `ifndef MEM_API__SVH
// `define MEM_API__SVH

typedef enum
{
	MEM_ZERO,
	MEM_ONE,
	MEM_X,
	MEM_5A,
	MEM_A5,
	MEM_RAND,
	MEM_MANUAL
} mem_val_enum;

class mem_api #(
	type addr_T = bit [31:0],
	type data_T = bit [31:0]
) extends uvm_object;

	localparam SIZE_BYTE = 1024 * 1024;
	localparam dval  = MEM_ZERO;

	uint32_t m_size = SIZE_BYTE;

	// the default value of memory
	// used when reading a not written space.
	mem_val_enum __default_val__ = dval;

	`uvm_object_utils(mem_api#(addr_T,data_T))


	// constructor
	//
	function new (string name = "mem_api"); super.new(name); endfunction

	// address list to combine the index and address relations between addr_lis and data_list
	//
	uint32_t addr_list[addr_T];

	//
	bit [7:0] data_list[$];

	// function to write a certain value to the memory, if address out of range, then return
	// 1, else return 0
	extern function bit write (input addr_T addr, input data_T wdata, input uint32_t len);

	// function to read, if out of the range, then return 1, else return 0.
	// before calling this function, the caller must confirm the len smaller than the data_T width
	extern function bit read (input addr_T addr, input uint32_t len, ref data_T rdata);

	// Func: set_default_val
	// the function to set default value.
	//
	function void set_default_val(input mem_val_enum _val); __default_val__ = _val; endfunction

	// Func: set_size
	// function to set the memory size.
	function void set_size (input uint32_t size); m_size = size; endfunction

	// Func: get the current max size of memory
	//
	function uint32_t get_size (); return m_size; endfunction

endclass : mem_api

function bit mem_api::read (input addr_T addr, input uint32_t len, ref data_T rdata);

	uint32_t a_byte_m = addr + len + 1; // the maximum byte of accessing request
	uint32_t data_indx = 0;
	uint32_t loop = 0;

	if (a_byte_m > (m_size+1)) return 1'b1; // if reach the maximum range, then return 'b1.

	while (loop < len) begin // {
		if (addr_list.exists(addr+loop)) begin // {
			data_indx = addr_list[addr+loop]; // get the index val of data_list
			rdata[(8*loop)+:8] = data_list[data_indx]; // get one byte of read data and storing to the corresponding position
		// }
		end else begin // {
			// current address not exists in addr_list, then use the default value
			case (__default_val__) // {
				MEM_ONE: begin // {
					rdata[(8*loop)+:8] = 8'hff;
				end // }
				MEM_X: begin // {
					rdata[(8*loop)+:8] = 8'hxx;
				end // }
				MEM_5A: begin // {
					rdata[(8*loop)+:8] = 8'h5A;
				end // }
				MEM_A5: begin // {
					rdata[(8*loop)+:8] = 8'hA5;
				end // }
				MEM_RAND: begin // {
					rdata[(8*loop)+:8] = $urandom_range(8'h0,8'hff);
				end // }
				default: begin // {
					// all other types will use the 0 value.
					rdata[(8*loop)+:8] = 8'h0;
				end // }
			endcase // }
		end // }
		loop++;
	end // }

	return 'b0; // no error occurred, return 0

endfunction : read

function bit mem_api::write (input addr_T addr, input data_T wdata, input uint32_t len);
	uint32_t a_byte_m = addr + len + 1;
	uint32_t loop = 0;
	uint32_t data_indx = 0;

	if (a_byte_m > (m_size+1)) return 'b1; // the write data has reached the out range.

	while (loop < len) begin // {
		if (addr_list.exists(addr+loop)) begin // {
			data_indx = addr_list[addr+loop];
			data_list[data_indx] = wdata[7:0];  // overwrite the current content in data_list
		// }
		end else begin // {
			// if current index of addr_list not exists
			data_indx = data_list.size(); // current size before push_back is the data_indx of the new pushed memory data.
			data_list.push_back(wdata[7:0]); // push_back the wdata to data_list
			addr_list[addr+loop] = data_indx;
		end // }
		wdata >>= 8; // right shift one byte
		loop++;
	end // }

	return 'b0;

endfunction : write

//`endif // MEM_API__SVH
