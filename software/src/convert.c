#include "../include/load.h"
#include "../include/utils.h"
#include "../include/Image.h"

#define IFPATHJPG "../files/IF/jpg"
#define IFPATHTXT "../files/IF/txt"

Image Img;

int main(int argc, char const *argv[])
{
    DirList dirlist;

    char* outname= (char*) malloc(MAXFILENAME); 


    printf("Cargando Directorio de imagenes...\n");
    LoadDirs(&dirlist,IFPATHJPG);
    printf("Total imagenes encontradas %d\n",dirlist.size);


    printf("Convirtiendo imagenes a archivo de texto plano...\n");
    for (int i = 0; i < dirlist.size; i++){

        LoadImage(&Img,dirlist.dirs[i],IFPATHJPG);
        ChangeNameExt(outname,dirlist.dirs[i],".txt");
        ImgToTxt(Img.data,Img.size,outname,IFPATHTXT);

        printf("-> Imagen %s guardada en %s ✅\n",outname,IFPATHTXT);
        
        FreeImage(&Img);
    }
    
    return 0;
}
