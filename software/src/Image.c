#include <math.h>
#include "../include/Image.h"
#include "../include/utils.h"

#define STB_IMAGE_IMPLEMENTATION
#include "../libs/stb_image/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../libs/stb_image/stb_image_write.h"


static void CreateImage(Image* img, int width,int height,int channels, bool zeros);



int LoadImage(Image* img, const char* iname, char* ifpath){

    char* fullpath=GetFullPath(iname,ifpath);

    if ((img->data= stbi_load(fullpath,&img->width,&img->height,&img->channels,0))!=NULL){
        img->size=img->width*img->height*img->channels;
        img->allocation=STB_ALLOCATED;
        
        return 1;
    }
    else{
        return 0;
    }
}

static void CreateImage(Image* img, int width,int height,int channels, bool zeros){
    size_t size= width*height*channels;

    if (zeros){
        img->data=calloc(size,1); /*devuelve puntero a la memoria de ceros asignada*/
    }
    else{
        img->data=malloc(size);
    }
    
    if (img->data!=NULL){
        img->height=height;
        img->width=width;
        img->channels=channels;
        img->size=size;
        img->allocation=SELF_ALLOCATED;
    }
}

int SaveImage(Image* img, const char *iname, char* of_path){

    char *fullpath= GetFullPath(iname,of_path);

    if (str_ends(fullpath,".jpg") || str_ends(iname,".JPG") || str_ends(iname,"jpeg") || str_ends(iname,"JPEG"))
    {
        stbi_write_jpg(fullpath,img->width,img->height,img->channels,img->data,100);
    }
    else if(str_ends(fullpath,".png")|| str_ends(iname,".jpg")){
        stbi_write_png(fullpath,img->width,img->height,img->channels,img->data,img-> width*img->channels);
    }
    else{
        return 0;
    }

    return 1;
}


void FreeImage(Image *img)
{
    if (img->allocation!=NO_ALLOCATION && img->data!=NULL){
        
        if (img->allocation==STB_ALLOCATED)
        {
            stbi_image_free(img->data);
        }
        else
        {
            free(img->data);
        }
        img->data=NULL;
        img->channels=0;
        img->width=0;
        img->height=0;
        img->size=0;
        img->allocation=NO_ALLOCATION;
    }
}

void CreateOutImg(Image* img_in,Image* img_out,int* wm_cols,int* wm_rows,int* str){
   
    int height= ((img_in->height-*wm_rows)/(*str)) + 1;
    int width= ((img_in->width-*wm_cols)/(*str)) + 1;
    int channels=1;
    CreateImage(img_out,width,height,channels,0);
}



void ImgCrop(Image* img_in,int new_width,int new_height){

    unsigned char* imgdata = (unsigned char*) malloc(new_width*new_height*img_in->channels);
    
    int channels=img_in->channels;

    int old_width_deep=img_in->width*channels;
    
    int new_width_deep=new_width*channels;
    
    int new_image_size=new_width_deep*new_height;


    if (img_in->height>=new_height && img_in->width>=new_width){

        int row,row2,col,col2,ch,ch2;

       for (row= 0, row2=0; row < new_image_size; row+=new_width_deep,row2+=old_width_deep){
        
            for ( col = row, col2=row2; col < (row+new_width_deep);col+=channels,col2+=channels){
            
                for (ch = col,ch2=col2; ch < (col+channels); ch++,ch2++){
                    
                    imgdata[ch]=img_in->data[ch2];
                } 
            }
        }

        FreeImage(img_in);
        CreateImage(img_in,new_width,new_height,channels,0);
        for (int i = 0; i < new_image_size; i++){
            img_in->data[i]=imgdata[i];
        }
    }
    free(imgdata);
}


void ImageToGray(const Image *orig, Image *gray) {
    ON_ERROR_EXIT(!(orig->allocation != NO_ALLOCATION && orig->channels >= 3), "The input image must have at least 3 channels.");
    
    int channels = orig->channels == 4 ? 2 : 1;
    
    CreateImage(gray, orig->width, orig->height, channels, false);
    
    ON_ERROR_EXIT(gray->data == NULL, "Error in creating the image");

    for(unsigned char *p = orig->data, *pg = gray->data; p != orig->data + orig->size; p += orig->channels, pg += gray->channels) {
        *pg = (uint8_t)((*p + *(p + 1) + *(p + 2))/3.0);
        if(orig->channels == 4) {
            *(pg + 1) = *(p + 3);
        }
    }
}



