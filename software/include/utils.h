
#pragma once

#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>



#define FULLPATHLEN 50

// Error utility macro
#define ON_ERROR_EXIT(cond, message) \
do { \
    if((cond)) { \
        printf("Error in function: %s at line %d\n", __func__, __LINE__); \
        perror((message)); \
        exit(1); \
    } \
} while(0)


static inline bool str_ends(const char *str, const char *ends){
    char *pos=strrchr(str,'.');
    return !strcmp(pos,ends);
}


void ChangeNameExt(char* dest,char* source, char* ext);
char* GetFullPath(const char* iname,const char *path);
