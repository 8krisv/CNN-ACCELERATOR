#pragma once

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

enum allocation_type{
    NO_ALLOCATION,SELF_ALLOCATED,STB_ALLOCATED
};

typedef struct{
    int width;
    int height;
    int channels;
    size_t size;
    unsigned char *data;
    enum allocation_type allocation;
}Image;


int LoadImage(Image* img, const char* iname, char* ifpath);
void CreateOutImg(Image* img_in,Image* img_out,int* wm_cols,int* wm_rows,int* Stride);
int SaveImage(Image* img, const char *iname, char* of_path);
void FreeImage(Image *img);
void ImageToGray(const Image *orig, Image *gray);
void ImgCrop(Image* img_in,int new_width,int new_height);




