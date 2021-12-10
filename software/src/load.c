#include "../include/load.h"
#include "../include/utils.h"


static int IsDigit(int c);
static int IsSpace(int c);
static int GetFileLine(FILE* fp,char s[],int maxlength);

/*Function to load the weight Matrix*/
int LoadWeightMatrix(WeightM* wm, char* wm_path, int index)
{
    FILE* fpointer;
    int rows,col,pcol;
    rows=col=pcol=0;
    float number=0;
    int isnumber=0;
    int power=1;
    int init=0;
    int j=0;
    int i=0;
    int sign=1;
    int chs=1;

    char line[FILELINELEN];

    fpointer=fopen(wm_path,"r");

   

    while (GetFileLine(fpointer,line,FILELINELEN)>0){
        
        i=0;

        if (line[i++]=='%'){

            for (number=0.0; IsDigit(line[i]); i++){
                number= number*10.0 + (line[i]-'0');
            }

            if (number==index){
                break;
            }
        }
    }


    while(GetFileLine(fpointer,line,FILELINELEN)>0 && rows<MAXWROWS) {

        i=0;

        if(line[i]=='#'){
            chs++;
            continue;
        }

        else if(line[i]=='%'){
            break;
        }
        
        if (line[i]!='\n'){
            if (chs==1){
                rows++;
            }
        }
        else{
            continue;
        }




        if (init==1){
            pcol=col;
        }

        col=0;

        while (line[i]!='\0' && col <13){
            
            for (; IsSpace(line[i]); i++){ /*Descarta los espacios en blanco*/
                ;
            } 

            sign=(line[i]=='-')?-1:1; /*se toma el signo*/

            if (line[i]=='-' | line[i]=='+'){  /*aumenta en 1 el indice*/
                i++;
            }

            for (number=0.0; IsDigit(line[i]); i++){
                isnumber=1;
                number= number*10.0 + (line[i]-'0');
            }

            if (line[i]=='.'){
                i++;
            }

            for (power=1; IsDigit(line[i]); i++){
                number= number*10.0 + (line[i]-'0');
                power*=10;
            }

            if (isnumber==1){
                wm->data[j++]=(sign*number)/power;
                isnumber=0;
                ++col;
               
            }
            i++;
        }
        if (init==0){
            pcol=col;
            init=1;
        }

       else if (pcol != col){
           return 0;
        }
    }

   fclose(fpointer);

    wm->rows=rows;
    wm->col=col;
    wm->chs=chs;
    wm->size=rows*col;

    return 1;
}

static int GetFileLine(FILE* fp,char *s, int maxlength)
{
    int c;
    int i=0,lim=maxlength;

    while (--lim>=0 && (c=fgetc(fp))!=EOF && c!='\n'){
        s[i++]=c;
    }
    if (c=='\n')
    {
        s[i++]=c;
    }
    s[i]='\0';
    
    return i;
}

static int IsDigit(int c)
{
    return (c >=ASCIICERO && c<=ACIINUEVE)?1:0;
}

static int IsSpace(int c)
{
    return (c==' ')?1:0;
}


int LoadStride(int* st, char* st_path, int index)
{
    FILE* fp;
    int c;
    int isnumber=0;
    int number=0;
    int i=0;
    char line[FILELINELEN];

    fp=fopen(st_path,"r");


    for (int j = 0; j <= index; j++){
       GetFileLine(fp,line,FILELINELEN);
    }

    while(IsDigit(line[i])){
        number= number*10+ (line[i]-'0');
        i++;
    }

    fclose(fp);

    *st=number;
    
    return 0;

}

int LoadDirs(DirList* dirlist, char* path){
  
    DIR *d;
    struct dirent *dir;
    d = opendir(path);
    int i=0;
 
    if(d){
        while ((dir = readdir(d)) != NULL) {
            if (dir->d_type==DT_REG){
                strcpy(dirlist->dirs[i++],dir->d_name);
            }
        }
        dirlist->size=i;
        closedir(d);
        return 1;
    }
    
    return 0;
}


void SaveTxtFile(float* data, int datasize, char* filename, char* filepath){

    FILE* fp;
 
    char* fullpath=GetFullPath(filename,filepath);
   
    fp=fopen(fullpath,"w");

    for (int i = 0; i < datasize; i++){
        
        fprintf(fp,"%f\n",data[i]);
    }
    fclose(fp);
}


void ImgToTxt(unsigned char* data, int datasize, char* filename, char* filepath){

    FILE* fp;
 
    char* fullpath=GetFullPath(filename,filepath);
   
    fp=fopen(fullpath,"w");

    for (int i = 0; i < datasize; i++){
        
        fprintf(fp,"%u\n",data[i]);
    }
    fclose(fp);
}
