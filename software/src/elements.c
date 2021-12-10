#include "../include/elements.h"


/*Weight register set enable*/
void WregSet(Wreg* reg, float value)
{
    reg->value_reg=value;
}

/*Weight register output enable*/
float WregOe(Wreg* reg)
{
    return reg->value_reg;
}

/*Basis procesing element sum set*/
void PeSumSet(Pe* pe, float w, int i_feature, float is)
{
    pe->sum_reg= (w*i_feature) + is;
}

/*Basis procesing element reg set*/
void PeRegSet(Pe* pe)
{
    pe->out_reg= pe->sum_reg;
}

/*Basis procesing element reset*/
void PeReset(Pe* pe)
{
    pe->sum_reg=0;
    pe->out_reg=0;
}

/*On-chip fifo memory write enable*/
void OmWe(Om* om, float* value)
{
    om->values[om->wrtptr]=*value;
    om->wrtptr=om->wrtptr+1;
}

/*On-chip fifo memory read enable*/
void OmRe(Om* om)
{ 
    om->out_reg=om->values[om->rdptr];
    om->rdptr=om->rdptr+1;
}

/*On-chip fifo memory write pointer clear*/
void OmWrptClr(Om* om)
{
    om->wrtptr=0;
}

/*On-chip fifo memory read pointer clear*/
void OmRptClr(Om* om)
{
    om->rdptr=0;
}

/*On-chip input memory write enable*/
void OimWe(Oim* oim,int addr, unsigned char value){
    oim->data[addr]=value;
}

/*On-chip input memory read enable*/
unsigned char OimRe(Oim* oim,int addr){
    return oim->data[addr];
}

/*On-chip weight memory write enable*/
void OwmWe(Owm* owm,int addr, float value){
    owm->data[addr]=value;
}

/*On-chip weigh memory read enable*/
float OwmRe(Owm* owm,int addr){
    return owm->data[addr];
}


void ChmWe(ChMem* chmem, float* data){
    chmem->data[chmem->wrtptr]= *data;
    chmem->wrtptr+=1;
}

float ChmRe(ChMem* chmem){
    int rptr=chmem->rdptr;
    chmem->rdptr+=1;
    return chmem->data[rptr];
}


float MuxOut(Mux* mux){

    if(mux->en){
        if (mux->sel==0){
            return *mux->pe_out;
        }
        else{
            return *mux->fifo_out;
        }
    }
    else{
        return 0.0;
    }
}

