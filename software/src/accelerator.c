#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "../include/elements.h"
#include "../include/Image.h"
#include "../include/arquitecture.h"
#include "../include/accelerator.h"
#include "../include/utils.h"

#define MAXPATHLEN 30

static Wreg WREGs[DATAFLOWSIZE]; /*169 weight registers*/
static Pe PEs[DATAFLOWSIZE]; /*169 procesing elements*/
static Om OMs[DATAFLOWSIZE]; /*169 On-chip fifo memory */
static Oim OIM; /*onchip input memory*/
static Owm OWM; /*onchip weigh memory*/
static Omdc OMDC; /*on-chip fifo memory controller*/
static Mux Muxes[DATAFLOWSIZE-1]; /*168 muxes*/
static Rbus RcongBus;
static ChMemsBus ChMems;


static char IF_Path[MAXPATHLEN]; /*input features path*/
static char OF_Path_Jpg[MAXPATHLEN]; /*output features path*/
static char OF_Path_Txt[MAXPATHLEN]; /*output features path*/


static int LoadOWM(WeightM* wm,Owm* oim);
static int LoadOIM(char* ifname,Image* img, Oim* oim, char* if_path, WeightM* wm,int* str);
static void SetMuxesConf(Mux *muxes, Pe* pes,Om* oms,WeightM* wm);
static void LoadWregs(Owm* owm,Wreg* wregs, WeightM* wm);
static void SetRcongBusConf(Rbus* rbus, WeightM* wm);
static void setMuxesConn(Mux *muxes, Pe* pes,Om* oms);
static void SetOmdcConn(Omdc* omdc);
static void SetRcongBusConn(Rbus* rbus, Omdc* omdc);
static void VerifyRbusOmRe(Om* oms, Rbus* rbus, WeightM* wm,ChMemsBus* chmems);
static void PesSumset(Pe* pes, Wreg* wregs, Oim* oim, Mux* muxes, int wm_size, int* addr);
static void OmdcCounters(Omdc* omdc);
static void OmdcVefState(Omdc* omdc);
static void OmdcUpdateState(Omdc* omdc);
static void SetOmdcConf(Omdc* omdc, Image *img_i, Image *img_o, WeightM* wm,int *str);
static void OneDConvOe(Omdc* omdc);
static void PesRegset(Pe* pes,int wm_size);
static void PesReset(Pe* pes);
static void VerifyRbusOmSetEn(Om* oms, Rbus* rbus, Pe* pes, WeightM* wm);
static void OneDConvSetE(Omdc* omdc);
static void VerifyRbusWrptclr(Om* oms, Rbus* rbus, WeightM* wm);
static void VerifyRbusRptclr(Om* oms, Rbus* rbus, WeightM* wm);
static void StartRutine(Omdc* omdc,Oim* oim,Om* oms,Pe* pes,Wreg* wregs,Mux* muxes,WeightM* wm, int* stride, Rbus* rbus,Image* img, Image* img_o, char* of_name, ChMemsBus* chmems);
static void OneDConvResetNextrow(Omdc* omdc); 
static void ChMemsSelReset(ChMemsBus* chmems, Image* img_o);
static void ChMemsVefNewFlag(Omdc* omdc, ChMemsBus* chmems,int* stride,Owm* owm, WeightM* wm);
static void ChmemsVefCounter(ChMemsBus* chmems, WeightM* wm);
static void ChMemsAddRutine(ChMemsBus* chms,Image* img_o, char* of_name);
static void LinearNormalization(Image* img, float *data);
static void Omsreset(Om* oms);


int accelerator_set_paths(char* if_path, char* jpg_path, char* txt_path){
    
    /*Establece las conexiones dentro de la arquitectura*/
    setMuxesConn(Muxes,PEs,OMs);
    SetOmdcConn(&OMDC);
    SetRcongBusConn(&RcongBus,&OMDC);

    /*se copian las rutas de las carpetas*/
    
    strcpy(IF_Path,if_path);
    strcpy(OF_Path_Jpg,jpg_path);
    strcpy(OF_Path_Txt,txt_path);

    return 1;
}

int accelerator_init(Image* Img,Image* ImgO ,char *ifname, char *ofname, WeightM* Wm, int stride){   
    

    /*Carga la On-chip weigh memory*/
    if(!LoadOWM(Wm,&OWM)){

        printf("%c[1;%dmHa ocurrido un problema al cargar la matriz W!\n", 27, 31);
        return 0;
    }

  
    /*Carga la on-chip inpur memory*/
    if (!LoadOIM(ifname,Img,&OIM,IF_Path,Wm,&stride)){

        printf("%c[1;%dmHa ocurrido un problema al cargar la imagen!\n", 27, 31);
        return 0;
    }

    /*Configurando multiplexores*/
    SetMuxesConf(Muxes,PEs,OMs,Wm);

    /*Configurando Rbus*/
    SetRcongBusConf(&RcongBus,Wm);
    /*caga los datos de la on-chip weigh memory al banco de registros*/
    LoadWregs(&OWM,WREGs,Wm);
    
    /*Configura la imagen de salida*/
    CreateOutImg(Img,ImgO,&Wm->col,&Wm->rows,&stride);

    /*Establece los valores del modulo OMDC y habilita los modulos 1DCONV necesarios*/
    SetOmdcConf(&OMDC,Img,ImgO,Wm,&stride);
    
    /*Empieza la rutina*/
    StartRutine(&OMDC,&OIM,OMs,PEs,WREGs,Muxes,Wm,&stride,&RcongBus,Img,ImgO,ofname,&ChMems);

    printf("Guardando imagen...\n");
    SaveImage(ImgO,ofname,OF_Path_Jpg);
    printf("Imagen %s guardada en %s ✅\n",ofname,OF_Path_Jpg);

    return 1;
}


/*Configurar las conexiones de los multiplexores*/
static void setMuxesConn(Mux *muxes, Pe* pes,Om* oms){
   for (int i = 0; i < DATAFLOWSIZE-1; i++){
        muxes[i].pe_out= &pes[i].out_reg;
        muxes[i].fifo_out= &oms[i].out_reg;
   }
}

/*Configurar las conexiones del on-chip fifo memory controller*/
static void SetOmdcConn(Omdc* omdc){
    
    for (int i = 0; i < MAXWROWS; i++){
        omdc->conv_modules[i].row=i+1;
        omdc->conv_modules[i].eqcw=&omdc->counter_eqcw_flag;
        omdc->conv_modules[i].eqst=&omdc->counter_eqst_flag;
        omdc->conv_modules[i].cu_row=&omdc->counter_crow;
        omdc->conv_modules[i].of_col=&omdc->of_cols;
        omdc->conv_modules[i].if_row=&omdc->if_rows;
        omdc->conv_modules[i].w_rows=&omdc->w_rows;
        omdc->conv_modules[i].stride=&omdc->stride;
        omdc->conv_modules[i].start=&omdc->start;
        omdc->conv_modules[i].flag_nxtrow=&omdc->counter_eqcif_flag;
    }
}

/*configurar las conexiones entre el bus reconfigurable y la omdc*/
static void SetRcongBusConn(Rbus* rbus, Omdc* omdc){
    for (int i = 0; i < MAXWROWS; i++){
        rbus->oe_i[i]= &omdc->conv_modules[i].o_en;
        rbus->se_i[i]= &omdc->conv_modules[i].set_en;
        rbus->wrptclr_i[i]=&omdc->conv_modules[i].wptclr;
        rbus->rdprclr_i[i]=&omdc->conv_modules[i].rptclr;
    }
}

static int LoadOWM(WeightM* wm,Owm* oim){   
    
    printf("Cargando la on-chip weight memory...\n");
    for (int i = 0; i < (wm->size*wm->chs); i++){
        oim->data[i]=wm->data[i];
    }
    oim->lowlimit=0;
    printf("On-chip weight memory cargada correctamente ✅\n");

    return 1;
}

static int LoadOIM(char* ifname,Image* img, Oim* oim, char* if_path, WeightM* wm,int* str){
   
   printf("Cargando imagen...\n");
    if(LoadImage(img,ifname,if_path)){
               
        int offset_cols=img->width-wm->col;
        int offset_rows= img->height-wm->rows;
        
        if ((offset_cols%(*str)) || (offset_rows%(*str))){
            
            int of_height= (offset_rows/(*str)) + 1;
            int of_width= (offset_cols/(*str)) + 1;    
            int new_height=(of_height-1)*(*str) + wm->rows;
            int new_width=(of_width-1)*(*str) +wm->col; 
            ImgCrop(img,new_width,new_height);
          
        }
        
        int k,i;
        int chsize=(img->height)*(img->width);

    
        printf("Cargando la on-chip input memory...\n");
        for (int j = 0; j < img->channels; j++){
            
            k=chsize*j;
            i=0;
            for (unsigned char *im = &img->data[j],*om=&oim->data[k]; i < chsize; i++,im += img->channels, om += 1)
            {
                *om= *im;
            }
        }
        printf("On-chip input memory cargada correctamente ✅\n");
        
        return 1;
    } 
    return 0;
}

static void LoadWregs(Owm* owm,Wreg* wregs, WeightM* wm){

    printf("Cargando datos de la on-chip weigh memory al banco de registros...\n");
    for (int i = 0,j=owm->lowlimit; i < wm->size, j< (owm->lowlimit +wm->size) ; i++,j++){

        wregs[i].value_reg=owm->data[j];
    }
    owm->lowlimit=owm->lowlimit+wm->size;
    printf("Banco de registros cargado corectamente ✅\n");
}

static void SetMuxesConf(Mux *muxes, Pe* pes,Om* oms, WeightM* wm){
    printf("Configurando multiplexores...\n");
    for (int i = 0; i < DATAFLOWSIZE-1; i++){
       
        if (i<wm->size){
           
            muxes[i].en=true;
            if ((i+1)%wm->col==0){
                muxes[i].sel=1;
            }
            else{
                muxes[i].sel=0;
            }
        }
        else{
            muxes[i].en=false;
        }
    }
    printf("Multimplexores configurados correctamente ✅\n");
}

static void SetRcongBusConf(Rbus* rbus, WeightM* wm){

    printf("Configurando RBUS...\n");
    for (int i = 0,j=0; i < DATAFLOWSIZE; i++){
        if (i<wm->size){
            if ((i+1)%wm->col==0){
                rbus->out_oe[i]=rbus->oe_i[j];
                rbus->out_se[i]=rbus->se_i[j];
                rbus->out_wrptclr[i]=rbus->wrptclr_i[j];
                rbus->out_rdptclr[i]=rbus->rdprclr_i[j];
                j++;
            }
            else{
                rbus->out_oe[i]=NULL;
                rbus->out_se[i]=NULL;
                rbus->out_wrptclr[i]=NULL;
                rbus->out_rdptclr[i]=NULL;
            }
        }
        else{
            rbus->out_oe[i]=NULL;
            rbus->out_se[i]=NULL;
            rbus->out_wrptclr[i]=NULL;
            rbus->out_rdptclr[i]=NULL;
        }
    }
    printf("RBUS configurado correctamente ✅\n");
}

static void SetOmdcConf(Omdc* omdc, Image *img_i, Image *img_o, WeightM* wm,int *str){


    omdc->if_rows=img_i->height;
    omdc->if_cols=img_i->width;
    omdc->of_cols=img_o->width;
    omdc->w_rows=wm->rows;
    omdc->w_cols=wm->col;
    omdc->stride=*str;
    omdc->start=0;
    omdc->new_channel_flag=0;
   
    printf("Habilitando banco de modulos 1DCONV...\n");
    for (int i = 0; i < MAXWROWS; i++){
        if (i<omdc->w_rows){
            omdc->conv_modules[i].enable=1;
            omdc->conv_modules[i].finalrow= img_i->height - wm->rows + omdc->conv_modules[i].row;
            omdc->conv_modules[i].nextrow = omdc->conv_modules[i].row; /*inicializa el registro nextrow con la fila asignada al modulo*/
            omdc->conv_modules[i].oe_counter=0;
            omdc->conv_modules[i].set_counter=0;
            omdc->conv_modules[i].flag_om_full=0;
            omdc->conv_modules[i].flag_out_full=0;
            omdc->conv_modules[i].flag_out_start=0;
            omdc->conv_modules[i].flag_conv_en=0;
            omdc->conv_modules[i].innerStrCounter=0;
            omdc->conv_modules[i].wptclr=0;
            omdc->conv_modules[i].rptclr=0;
            omdc->conv_modules[i].set_en=0;
            omdc->conv_modules[i].o_en=0;
        }
        else{
            omdc->conv_modules[i].enable=0;
        }
    }
    printf("Modulos 1DCONV habilitados correctamente ✅\n");
}

static void StartRutine(Omdc* omdc,Oim* oim,Om* oms,Pe* pes,Wreg* wregs,Mux* muxes,WeightM* wm, int* stride, Rbus* rbus,Image* img, Image* img_o, char* of_name, ChMemsBus* chmems)
{
    /*Se resetea el valor almacenado en todos los pe*/
    PesReset(pes);
    /*pone en reset los valores del selector de canales*/
    ChMemsSelReset(chmems,img_o);

    /*se resetea las Oms*/
    Omsreset(oms);
    
    omdc->State_Signal=OMDC_STATE_RESET;
    OmdcUpdateState(omdc); /*Pasa a estado reset*/
    omdc->start=1;
    OmdcVefState(omdc);/*hace la transición*/
    OmdcUpdateState(omdc); /*pasa a estado w_colums*/


    printf("Comenzando rutina...\n");

    for (int addr = 0; addr < img->size; addr++){
        
        /********************* POSEDGE CLK **********************/
        //printf("iter=%d\n",addr);
       
        //printf("**posedge clk**\n");
       
        OmdcCounters(omdc);/*verifica y actualiza el estado de los contadores del modulo omdc*/
        
        ChMemsVefNewFlag(omdc,chmems,stride,&OWM,wm); /*se verifica si se activo la bandera new cahnnel para el channel controller*/
        
        OneDConvOe(omdc);/*verifica y actualiza las señales oe de los modulos OneDConv*/

        VerifyRbusWrptclr(oms,rbus,wm);/*Verifica si hay que reiniciar los puntero de escritura*/
        
        VerifyRbusOmRe(oms,rbus,wm,chmems); /*Verifica las salidas oe/re del modulo RBUS*/
        
        PesSumset(pes,wregs,oim,muxes,wm->size,&addr); /*recorre todas las pe y guarda el producto y suma de sus entradas en sus registros sum_reg*/
        
        OmdcVefState(omdc);/*verifica el estado interno del modulo OMDC*/
        
        /********************* NEGEDGE CLK **********************/
        //printf("**nededge clk**\n");

        PesRegset(pes,wm->size);/*guarda el valor del registro sum_reg en el registro de salida out_reg*/
        
        OneDConvSetE(omdc); /*Verifica si se debe activar la señal set_en de los modulos OneDConvOe*/
        
        VerifyRbusRptclr(oms,rbus,wm);/*verifica si hay que reiniciar los punteros de lectura*/
        
        VerifyRbusOmSetEn(oms,rbus,pes,wm); /*Verifica si se debe guardar algo en la Om*/
        
        ChmemsVefCounter(chmems,wm);/*actualiza el estado del selector de canales del cahnnel controller*/
        
        OmdcUpdateState(omdc); /*Actualiza el estado interno del modulo Omdc*/
    }

    for (int i = 0; i < img->width; i++){
        
        /****************** POSEDGE CLK ******************/
        //printf("**posedge clk**\n");
        OneDConvOe(omdc); /*verifica y actualiza las señales oe de los modulos OneDConv*/
        VerifyRbusWrptclr(oms,rbus,wm);/*Verifica si hay que reiniciar los puntero de escritura*/
        VerifyRbusOmRe(oms,rbus,wm,chmems); /*Verifica las salidas oe/re del modulo RBUS*/
       
        /****************** NEDEDGE CLK ******************/
        //printf("**nededge clk**\n");
        OneDConvSetE(omdc);
        VerifyRbusRptclr(oms,rbus,wm);/*verifica si hay que reiniciar los punteros de lectura*/
    }
    printf("Rutina finalizada exitosamente ✅\n");

    printf("Empezando rutina adder...\n");
    ChMemsAddRutine(chmems,img_o,of_name);
    printf("Rutina adder finalizada correctamente ✅ \n");
}

static void Omsreset(Om* oms){
    for (int i = 0; i < DATAFLOWSIZE; i++){
        oms[i].rdptr=0;
        oms[i].wrtptr=0;
        oms[i].out_reg=0;
    }
    
}

static void ChMemsAddRutine(ChMemsBus* chms,Image* img_o, char* of_name){
    
    //float* addmem= (float*) malloc((img_o->size)*sizeof(float));

    float* dataf = (float*) malloc(img_o->size*sizeof(float));

    char* filenametxt= (char*) malloc(sizeof(of_name));

    for (int i = 0; i < img_o->size; i++){       
       
        dataf[i]= chms->ChMems[0].data[i] + chms->ChMems[1].data[i] + chms->ChMems[2].data[i];

        img_o->data[i]=dataf[i]<0?0:dataf[i];
    }

    ChangeNameExt(filenametxt,of_name,".txt");
    
    SaveTxtFile(dataf,img_o->size,filenametxt,OF_Path_Txt);
    free(dataf);
    free(filenametxt);
    
    //LinearNormalization(img_o,addmem);
    //free(addmem);
}

static void LinearNormalization(Image* img, float *data){

    float oldmin=data[0];
    float oldmax=data[0];
    
    for (int i = 1; i < img->size; i++){
    
        if (data[i]<oldmin){
            oldmin=data[i];
        }
        else if(data[i]>oldmax){
            oldmax=data[i];
        }    
    }
    
    for (int i = 0; i < img->size; i++){
        img->data[i]=  (uint8_t) (((data[i]-oldmin)/(oldmax-oldmin))*255);        
    }
}

static void OmdcCounters(Omdc* omdc){

    if (omdc->State_Reg==OMDC_STATE_COUNT_W_COLUMS){
        omdc->counter_eqcw=omdc->counter_eqcw+1;
        omdc->counter_eqcif=omdc->counter_eqcif+1;

        if (omdc->counter_eqcw==omdc->w_cols){
            omdc->counter_eqcw_flag=1;
            //printf("*Counter eqcw flag*\n");
        }   
        if (omdc->counter_eqcif==omdc->if_cols){
           omdc->counter_eqcif_flag=1;
           
            if (omdc->counter_crow==omdc->if_rows){
                omdc->new_channel_flag=1;
            }
        }
    }

    else if(omdc->State_Reg==OMDC_STATE_COUNT_STRIDE){
        
        omdc->counter_eqst=omdc->counter_eqst+1;
        omdc->counter_eqcif=omdc->counter_eqcif+1;


        if (omdc->counter_eqst==omdc->stride){
            omdc->counter_eqst_flag=1;
            //printf("*Counter eqst flag*\n");

        }
        if (omdc->counter_eqcif==omdc->if_cols){
            omdc->counter_eqcif_flag=1;
            //printf("*Counter eqcif flag*\n");
            if (omdc->counter_crow==omdc->if_rows){
                omdc->new_channel_flag=1;
                //printf("*Nuevo canal flag*\n");
            }
        }
    }

    else if (omdc->State_Reg==OMDC_STATE_COUNT_ROW){
        omdc->counter_eqcw=omdc->counter_eqcw+1;
        omdc->counter_eqcif=omdc->counter_eqcif+1;
    }

    else if (omdc->State_Reg==OMDC_STATE_REST_COUNT_ROW){
        omdc->counter_eqcw=omdc->counter_eqcw+1;
        omdc->counter_eqcif=omdc->counter_eqcif+1;
    }
}

static void OmdcVefState(Omdc* omdc){

    if (omdc->State_Reg==OMDC_STATE_RESET){
        if (omdc->start){
            omdc->State_Signal=OMDC_STATE_COUNT_W_COLUMS;
        }
    }
    
    if (omdc->State_Reg == OMDC_STATE_COUNT_W_COLUMS){
        if (omdc->counter_eqcw_flag){
            omdc->State_Signal=OMDC_STATE_COUNT_STRIDE;
        }
    }

    else if(omdc->State_Reg==OMDC_STATE_COUNT_STRIDE){
        if (omdc->counter_eqcif_flag==1){
            if (omdc->new_channel_flag){
                omdc->State_Signal=OMDC_STATE_REST_COUNT_ROW;
            }
            else{
                omdc->State_Signal=OMDC_STATE_COUNT_ROW;
            }
        }
    }
    else if(omdc->State_Reg==OMDC_STATE_COUNT_ROW){
        omdc->State_Signal=OMDC_STATE_COUNT_W_COLUMS;
    }

    else if(omdc->State_Reg==OMDC_STATE_REST_COUNT_ROW){
        omdc->State_Signal=OMDC_STATE_COUNT_W_COLUMS;
    }
}

static void OmdcUpdateState(Omdc* omdc){

    omdc->State_Reg=omdc->State_Signal;

    switch (omdc->State_Reg)
    {
        case OMDC_STATE_RESET:
            omdc->counter_eqcif=0;
            omdc->counter_eqcw=0;
            omdc->counter_eqst=0;
            omdc->counter_eqcif_flag=0;
            omdc->counter_eqcw_flag=0;
            omdc->counter_eqst_flag=0;
            omdc->new_channel_flag=0;
            omdc->counter_crow=1;
            break;
        case OMDC_STATE_COUNT_W_COLUMS:
            omdc->counter_eqst=0;
            break;
        case OMDC_STATE_COUNT_STRIDE:
            omdc->counter_eqcw=0;
            omdc->counter_eqcw_flag=0;
            if (omdc->counter_eqst_flag){
                omdc->counter_eqst=0;
                omdc->counter_eqst_flag=0;
            }
            break;
        case OMDC_STATE_COUNT_ROW:
            omdc->counter_eqst=0;
            omdc->counter_eqst_flag=0;
            omdc->counter_eqcif=0;
            omdc->counter_eqcif_flag=0;
            omdc->counter_crow=omdc->counter_crow+1;
            omdc->new_channel_flag=0;
            break;

        case OMDC_STATE_REST_COUNT_ROW:
            omdc->counter_eqst=0;
            omdc->counter_eqst_flag=0;
            omdc->counter_eqcif=0;
            omdc->counter_eqcif_flag=0;
            OneDConvResetNextrow(omdc);
            omdc->counter_crow=1;
            omdc->new_channel_flag=0;
            break;

        default:
            break;
    }
}

static void OneDConvOe(Omdc* omdc){

    for (int i = 0; i < omdc->w_rows; i++){
    
        /*Verifica si la on-chip fifo memory esta completamente llena*/
        if (omdc->conv_modules[i].flag_om_full){
        
            omdc->conv_modules[i].set_counter=0;
            omdc->conv_modules[i].flag_om_full=0;
            omdc->conv_modules[i].o_en=1;
            omdc->conv_modules[i].oe_counter=1;
            omdc->conv_modules[i].wptclr=1;     
            omdc->conv_modules[i].flag_out_start=1;
            continue;
        }
        else{    
            omdc->conv_modules[i].wptclr=0;
        }
                
        if (omdc->conv_modules[i].flag_out_start){
            omdc->conv_modules[i].innerStrCounter+=1;
            
            if (omdc->conv_modules[i].innerStrCounter==*omdc->conv_modules[i].stride){
                omdc->conv_modules[i].o_en=1;
                omdc->conv_modules[i].innerStrCounter=0;
                omdc->conv_modules[i].oe_counter+=1;
            }
            else{
                omdc->conv_modules[i].o_en=0;
            }
            if (omdc->conv_modules[i].oe_counter==*omdc->conv_modules[i].of_col){
                omdc->conv_modules[i].flag_out_full=1;
                //printf("*Modulo conv %d out flag*\n",i);
            }
        }
    }
}

static void OneDConvSetE(Omdc* omdc){
    for (int i = 0; i < omdc->w_rows ; i++){
        if (omdc->counter_crow >= omdc->conv_modules[i].row && omdc->counter_crow <= omdc->conv_modules[i].finalrow){
            
            if (*omdc->conv_modules[i].cu_row==omdc->conv_modules[i].nextrow){
                
                if (*omdc->conv_modules[i].eqcw || *omdc->conv_modules[i].eqst){
                    omdc->conv_modules[i].set_en=1;
                    omdc->conv_modules[i].set_counter+=1;
                }
                else{
                    omdc->conv_modules[i].set_en=0;
                }

                if (omdc->conv_modules[i].set_counter==*omdc->conv_modules[i].of_col){
                    
                    omdc->conv_modules[i].flag_om_full=1;
                    //printf("*Modulo conv %d flag om full*\n",i);
                }

                if (*omdc->conv_modules[i].flag_nxtrow){
                    omdc->conv_modules[i].nextrow=omdc->conv_modules[i].nextrow + *omdc->conv_modules[i].stride; /*Actualiza el registro nextrow*/
                }
            }
            else{
                omdc->conv_modules[i].set_en=0;
            }
        }
        else{
            omdc->conv_modules[i].set_en=0;
        }

        if (omdc->conv_modules[i].flag_out_full==1){
            omdc->conv_modules[i].oe_counter=0;
            omdc->conv_modules[i].flag_out_start=0;
            omdc->conv_modules[i].flag_out_full=0;
            omdc->conv_modules[i].o_en=0;
            omdc->conv_modules[i].rptclr=1;
        }
        else{
            omdc->conv_modules[i].rptclr=0;
        }   
    }
}

static void VerifyRbusOmRe(Om* oms, Rbus* rbus, WeightM* wm, ChMemsBus* chmems){
    
    for (int i = 0; i < wm->size; i++){
        
        if (rbus->out_oe[i]!=NULL){

            if (*rbus->out_oe[i]==true){

                OmRe(&oms[i]);
                //printf("*Leyendo dato de memora OM %i*\n",i);

               if (i==((wm->size)-1)){ /*verifica si la ultima Om va a expulsar un dato*/

                    ChmWe(&chmems->ChMems[chmems->select],&oms[i].out_reg);
                }
            }
            else{
                oms[i].out_reg=0;
            }
        }
    }
}

static void VerifyRbusOmSetEn(Om* oms, Rbus* rbus, Pe* pes, WeightM* wm){
    for (int i = 0; i < wm->size; i++){
        if (rbus->out_se[i]!=NULL){
            if (*rbus->out_se[i]==true){
                OmWe(&oms[i],&pes[i].out_reg);
                //printf("*Escribiendo dato en memora OM %i*\n",i);
            }
        }
    }
}

static void VerifyRbusWrptclr(Om* oms, Rbus* rbus, WeightM* wm){
        
    for (int i = 0; i < wm->size; i++){
        
        if (rbus->out_wrptclr[i]!=NULL){

            if (*rbus->out_wrptclr[i]==true){
                OmWrptClr(&oms[i]);
               // printf("*Reseteando wrptclr en memoria OM %d*\n",i);
            }
        }
    }
}

static void VerifyRbusRptclr(Om* oms, Rbus* rbus, WeightM* wm){
    for (int i = 0; i < wm->size; i++){
        
        if (rbus->out_rdptclr[i]!=NULL){

            if (*rbus->out_rdptclr[i]==true){
                OmRptClr(&oms[i]);
                //printf("*Reseteando rdptclr en memoria OM %d*\n",i);
            }
        }
    }
}

static void OneDConvResetNextrow(Omdc* omdc){
    for (int i = 0; i < omdc->w_rows; i++){
        omdc->conv_modules[i].nextrow=omdc->conv_modules[i].row;
    }
}

static void PesSumset(Pe* pes, Wreg* wregs, Oim* oim, Mux* muxes, int wm_size, int* addr){

    PeSumSet(&pes[0],wregs[0].value_reg,oim->data[*addr],0);
    for (int i = 1; i < wm_size ; i++){
        PeSumSet(&pes[i],wregs[i].value_reg,oim->data[*addr],MuxOut(&muxes[i-1]));
    }
}

static void PesRegset(Pe* pes, int wm_size){
    for (int i = 0; i < wm_size ; i++){
        PeRegSet(&pes[i]);
    }
}

static void PesReset(Pe* pes){
    for (int i = 0; i < DATAFLOWSIZE ; i++){
        PeReset(&pes[i]);
    }
}

static void ChMemsSelReset(ChMemsBus* chmems, Image* img_o){
    chmems->select=0;
    chmems->wait=0;
    chmems->counter=0;
    chmems->strcounter=0;
    chmems->start_rutine=0;
    chmems->of_colums=img_o->width;
    
    for (int i = 0; i < 3; i++){
        chmems->ChMems[i].rdptr=0;
        chmems->ChMems[i].wrtptr=0;
    }   
}


static void ChMemsVefNewFlag(Omdc* omdc, ChMemsBus* chmems,int* stride,Owm* owm, WeightM* wm){
   
    if (chmems->start_rutine){
        chmems->wait=0;
        chmems->strcounter+=1;
       if (chmems->strcounter==*stride){
           chmems->counter+=1;
           chmems->strcounter=0;
       }
    }

    if (chmems->wait){
        chmems->counter+=1;
        chmems->start_rutine=1;

        if (chmems->select < (wm->chs-1)){
            LoadWregs(owm,WREGs,wm);
        }
        
    }
   
    if (omdc->new_channel_flag){

        chmems->wait=1;
    }
}

static void ChmemsVefCounter(ChMemsBus* chmems, WeightM* wm){
    if (chmems->counter==(chmems->of_colums)){
        chmems->wait=0;
        chmems->counter=0;
        chmems->start_rutine=0;
        chmems->strcounter=0;
        chmems->select+=1;

        
       // LoadWregs(&OWM,WREGs,wm);
       
    }
}
