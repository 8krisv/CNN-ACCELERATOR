
#include "../include/utils.h"


void ChangeNameExt(char* dest,char* source, char* ext){
    int i,j;
    i=j=0;
    
    while ((dest[i]=source[i])!='.'){
        i++;
    }

    while ((dest[i++]=ext[j++])!='\0'){
        ;
    }
}


char* GetFullPath(const char* iname,const char *path){
   
    int i=0;
    int j=0;
    
    char *fpath=malloc(FULLPATHLEN);

    while ((fpath[i]=path[i])!='\0'){
        i++;
    }
    fpath[i++]='/';

    while ((fpath[i]=iname[j])!='\0'){
        i++;
        j++;
    }
    return fpath;
}


