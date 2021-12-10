#include <stdio.h>
#include "../include/load.h"
#include "../include/paths.h"
#include "../include/utils.h"



WeightM Wm;
int Stride;

int main(void)
{

    LoadWeightMatrix(&Wm,WMPATH,index);

    printf("Filas:%d\n",Wm.rows);
    printf("Columnas:%d\n",Wm.col);
    printf("Canales:%d\n",Wm.chs);

    printf("Datos:\n");

    for (int i = 0; i < Wm.size*Wm.chs; i++)
    {
        printf("%f\n",Wm.data[i]);
    }
   
    
    return 0;
}


