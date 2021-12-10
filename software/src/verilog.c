#include "../include/load.h"
#include "../include/utils.h"
#include "../include/Image.h"

#include "math.h"

#define WMPATH "../files/IF/random/W"
#define STRPATH "../files/IF/random/Stride"
#define IFVERILOG "../files/IF/memv"
#define IFPATHJPG "../files/IF/jpg"

Image Img;
WeightM Wm;
int Stride;

static void CopyData(int16_t* data, WeightM* wm, Image* img);
static void SaveVif(int16_t* data, int datasize, char* filename, int* of_colums, int* of_rows, char* filepath);

int main(int argc, char const *argv[])
{
    DirList dirlist;

    int offset_cols,offset_rows,of_height,of_width;

    char* outname= (char*) malloc(MAXFILENAME); 
    int16_t* data;
    
  

    printf("Cargando Directorio de imagenes...\n");
    LoadDirs(&dirlist,IFPATHJPG);
    printf("Total imagenes encontradas %d\n",dirlist.size);

    printf("Generando verilog input files...\n");

    for (int i = 0; i < dirlist.size; i++){

        LoadWeightMatrix(&Wm,WMPATH,i);
        LoadStride(&Stride,STRPATH,i);

        LoadImage(&Img,dirlist.dirs[i],IFPATHJPG);

        offset_cols= Img.width - Wm.col;
        offset_rows= Img.height - Wm.rows;
        of_height= (offset_rows/Stride) + 1;
        of_width= (offset_cols/Stride) + 1; 

        if ((offset_cols%Stride) || (offset_rows%Stride)){
        
            int new_height=(of_height-1)*Stride + Wm.rows;
            int new_width=(of_width-1)*Stride +Wm.col;     
            ImgCrop(&Img,new_width,new_height);
          
        }

        data = (int16_t*) malloc(((Wm.size*Wm.chs)+Img.size)*sizeof(int16_t));

        CopyData(data,&Wm,&Img);

        ChangeNameExt(outname,dirlist.dirs[i],"-vin.txt");

        SaveVif(data,(Wm.size*Wm.chs)+Img.size,outname, &of_width,&of_height,IFVERILOG);

        printf("Verilog input file %s guardado en %s ✅\n",outname,IFVERILOG);

        free(data);
        FreeImage(&Img);
    }

    free(outname);
    return 0;
}


static void CopyData(int16_t* data, WeightM* wm, Image* img){
    
    int i,j,ch;

    for (i = 0,ch=0; ch<wm->chs; ch++)
    {    
        for (j = 0; j < wm->size; j++,i++){

            data[i]= (int16_t) wm->data[j+ch*wm->size];
         }
    }
    
    for (int ch = 0; ch < wm->chs; ch++){
        
        for (j=ch; j< img->size; j+=img->channels,i++) {
            data[i]= (int16_t) img->data[j];
        }
    }    
}


static void SaveVif(int16_t* data, int datasize, char* filename, int* of_colums, int* of_rows, char* filepath){

    FILE* fp;
    
    char* fullpath=GetFullPath(filename,filepath);
    
    fp=fopen(fullpath,"w");

    fprintf(fp,"%hx\n",Img.height);
    fprintf(fp,"%hx\n",Img.width);
    fprintf(fp,"%hx\n",Wm.chs);
    fprintf(fp,"%hx\n",Wm.rows);
    fprintf(fp,"%hx\n",Wm.col);
    fprintf(fp,"%hx\n",Wm.chs);
    fprintf(fp,"%hx\n",*of_rows);
    fprintf(fp,"%hx\n",*of_colums);
    fprintf(fp,"%hx\n",Stride);

    for (int i = 0; i < datasize; i++){
        fprintf(fp,"%hx\n",data[i]);
    }
    fclose(fp);
}
