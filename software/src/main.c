#include "../include/accelerator.h"
#include "../include/paths.h"
#include "../include/utils.h"

Image ImgI; /*Imagen de entrada*/
Image ImgO; /*Imagen de salida*/
int Stride;
WeightM Wm;


void ChangeNameExt(char* dest,char* source, char* ext);

int main(void){

    DirList dirlist;

    printf("Cargando Directorio de imagenes...\n");

    LoadDirs(&dirlist,IFPATHJPG);
    accelerator_set_paths(IFPATHJPG,OFPATHJPG,OFPATHTXT);

    printf("Total imagenes encontradas %d\n",dirlist.size);

    char* outname=(char*) malloc(MAXFILENAME);

   

    printf("Iniciando procesamiendo de imagenes...\n\n");
    for (int i = 0; i < dirlist.size; i++){

        LoadStride(&Stride,STRPATH,i);
        LoadWeightMatrix(&Wm,WMPATH,i);

        printf("-> Procesando Imagen %s\n\n",dirlist.dirs[i]);

        ChangeNameExt(outname,dirlist.dirs[i],"-out.jpg");
        
        accelerator_init(&ImgI,&ImgO,dirlist.dirs[i],outname,&Wm,Stride);

        FreeImage(&ImgI);
        FreeImage(&ImgO);
        printf("\n\n");

    }

    printf("Total imagenes procesadas %d\n\n",dirlist.size);
    free(outname);
    return 0;
}


