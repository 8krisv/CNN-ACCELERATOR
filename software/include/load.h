#pragma once

#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include "arquitecture.h"


#define ASCIICERO 48
#define ACIINUEVE 57
#define FILELINELEN 80
#define MAXDIRSIZE 200
#define MAXFILENAME 20


typedef struct{
    int rows;
    int col;
    int chs;
    size_t size;
    float data[MAXWSIZE];
}WeightM;

typedef struct{
  int size;
  char dirs[MAXDIRSIZE][MAXFILENAME];
}DirList;



int LoadWeightMatrix(WeightM* wm, char* wm_path, int index);
int LoadStride(int* st, char* st_path, int index);
int LoadDirs(DirList* dirlist, char* path);
void SaveTxtFile(float* data, int datasize, char* filename, char* filepath);
void ImgToTxt(unsigned char* data, int datasize, char* filename, char* filepath);
