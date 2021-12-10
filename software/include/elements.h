#pragma once

#include <stdbool.h>
#include "arquitecture.h"


/*Register to storage a value from the weight matrix*/
typedef struct{
    float value_reg;
} Wreg;


/*Basic Procesing element*/
typedef struct
{
    float sum_reg;
    float out_reg;
} Pe; 

/*On-Chip Fifo Memory*/
typedef struct 
{   
    int wrtptr; /*Write pointer*/
    int rdptr; /*Read pointer*/
    float out_reg; /*Registro de salida*/
    float values[MAXFIFOSIZE]; /*memory*/
}Om;



/*On-chip input memory*/
typedef struct
{
   unsigned char data[MAXOIMLEN]; 
}Oim;

/*On-chip weight memory*/
typedef struct 
{
    int lowlimit;
    float data[MAXOWMLEN];
}Owm;


/*Multiplexor 2 a 1*/
typedef struct{
    float* pe_out;
    float* fifo_out;
    bool en;
    bool sel;
}Mux;

/*1D convolution module*/
typedef struct{
    
    /*Entradas*/
    int row; /*row assigned*/
    bool* eqcw;/*flag counter equals to weight matrix columns*/
    bool* eqst;/*flag counter equals to stride*/
    int* cu_row; /*current row*/
    int* of_col; /*output features columns*/
    int* if_row; /*input features rows*/
    int* w_rows; /*weight matrix rows*/
    int* stride; /*stride*/
   
    bool enable; /*modulo enable signal*/
    bool* start; /*modulo start signal*/
    bool* flag_nxtrow; /*next row flag counter*/
    
    /*Registros internos*/
    int nextrow;
    int finalrow;
    
    /*Contadores internos*/
    int set_counter;
    int oe_counter;
    int innerStrCounter;

    /*Señales internas*/
    bool flag_conv_en;
    bool flag_om_full;
    bool flag_out_full;
    bool flag_out_start;

    /*salidas*/
    bool set_en;
    bool o_en;
    bool wptclr;
    bool rptclr;

}OnedConv;


/*Estados internos del on-chip dataflow controller*/
typedef enum Omdc_states{
    OMDC_STATE_COUNT_W_COLUMS,
    OMDC_STATE_COUNT_STRIDE,
    OMDC_STATE_COUNT_ROW,
    OMDC_STATE_WAIT,
    OMDC_STATE_REST_COUNT_ROW,
    OMDC_STATE_RESET

}Omdc_states;

/*On-chip memory dataflow controller*/
typedef struct 
{   
    /****CONTADORES***/
    int counter_eqcw;
    int counter_eqst;
    int counter_crow;
    int counter_eqcif;

    /***ENTRADAS**/
    int of_cols;
    int if_rows;
    int if_cols;
    int w_cols;
    int w_rows;
    int stride;

   /****SEÑALES INTERNAS ***/
    bool counter_eqcw_flag;
    bool counter_eqst_flag;
    bool counter_eqcif_flag;
    bool start;
   
    bool new_channel_flag;

    Omdc_states State_Signal;
    Omdc_states State_Reg;
   
    OnedConv conv_modules[MAXWROWS];
    /* data */
}Omdc;


/*Reconfigurable bus*/
typedef struct {
    bool* oe_i[MAXWROWS];
    bool* se_i[MAXWROWS];
    bool* wrptclr_i[MAXWROWS];
    bool* rdprclr_i[MAXWROWS];

    bool* out_oe[DATAFLOWSIZE];
    bool* out_se[DATAFLOWSIZE];
    bool* out_wrptclr[DATAFLOWSIZE];
    bool* out_rdptclr[DATAFLOWSIZE];
}Rbus;


/*Channel memory*/

typedef struct{
    int wrtptr; /*Write pointer*/
    int rdptr; /*Read pointer*/
    float data[MAXCHSIZE];
}ChMem;


typedef struct{
    int of_colums;
    int counter;
    int strcounter;
    int select;
    bool wait;
    bool start_rutine;
    ChMem ChMems[MAXCHS];
}ChMemsBus;



/*Prototipos*/
void WregSet(Wreg* reg, float value);
float WregOe(Wreg* reg);
void PeSumSet(Pe* pe, float w, int i_feature, float is);
void PeRegSet(Pe* pe);
void PeReset(Pe* pe);
void OmWe(Om* om, float *value);
void OmRe(Om* om);
void OmWrptClr(Om* om);
void OmRptClr(Om* om);
void OimWe(Oim* oim,int addr, unsigned char value);
unsigned char OimRe(Oim* oim,int addr);
float MuxOut(Mux* mux);
void ChmWe(ChMem* chmem, float* data);
float ChmRe(ChMem* chmem);
