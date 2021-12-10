/*

32 bits Registers for convolution configuration 

1) Reg_Addr_Offset
2) Reg_If_Rows
3) Reg_If_Colums
4) Reg_If_Channels
5) Reg_W_Rows
6) Reg_W_Colums
7) Reg_W_Channels
8) Reg_Of_Rows
9) Reg_Of_Colums
10) Reg_Stride

The first register Reg_Addr_Offset starts at base adress  CNN_ACCEL_AVALON_SLAVE_BASE
and the second Register Reg_If_Rows starts at CNN_ACCEL_AVALON_SLAVE_BASE + 4 bytes and 
so on with the rest registers 

*/

#define CNN_ACCEL_AVALON_SLAVE_BASE 0x00004040
#define ON_CHIP_RAM_BASE 0x00000000

#define ADDR_OFFSET 0
#define IF_ROWS 8
#define IF_COLUMS 8
#define IF_CHANNELS 3
#define W_ROWS 2 
#define W_COLUMS 4
#define W_CHANNELS 3
#define STRIDE 1

int main(void)
{

    int of_rows,of_colums,offset_rows,offset_colums;
    
    int* addr_offset = (int*) CNN_ACCEL_AVALON_SLAVE_BASE;

    offset_rows= IF_ROWS-W_ROWS;
    offset_colums = IF_COLUMS-W_COLUMS;

    of_rows = (offset_rows/STRIDE) + 1;
    of_colums = (offset_colums/STRIDE) + 1;

    *addr_offset= (ON_CHIP_RAM_BASE + ADDR_OFFSET);
    *(addr_offset+1)=IF_ROWS;
    *(addr_offset+2)=IF_COLUMS;
    *(addr_offset+3)=IF_CHANNELS;
    *(addr_offset+4)=W_ROWS;
    *(addr_offset+5)=W_COLUMS;
    *(addr_offset+6)=W_CHANNELS;
    *(addr_offset+7)=of_rows;
    *(addr_offset+8)=of_colums;
    *(addr_offset+9)=STRIDE;
    
    return 0;
}
