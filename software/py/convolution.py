import numpy as np
import cv2
import os
from math import floor


from numpy.core.arrayprint import printoptions
from numpy.core.numeric import full
from numpy.lib.function_base import _parse_gufunc_signature
from numpy.lib.npyio import load

IFPATHJPG= "../../files/IF/jpg";
IFPATHTXT= "../../files/IF/txt";
OFPATH0= "../../files/OF/pyout/jpg";
OFPATH1= "../../files/OF/pyout/txt";
STRPATH= "../../files/IF/random/Stride";
WMPATH= "../../files/IF/random/W";


def conv_single_step(a, W):
    Z= np.multiply(a,W).sum();
    return Z


def conv3D(img,W,Stride):
     
    (f1, f2,fdeep) = W.shape;
    (rows,col,deep)=img.shape;

    vmax= floor((rows - f1)/Stride) +1;
    hmax= floor((col - f2)/Stride) +1; 
    Z=np.zeros((vmax,hmax)); 

    for k in range(vmax):
        ver_start=k*Stride;
        ver_end=ver_start+f1;
        for z in range(hmax):
            horiz_start=z*Stride;
            horiz_end=horiz_start+f2;
            Z[k,z]= conv_single_step(img[ver_start:ver_end,horiz_start:horiz_end,:], W[:,:,:]);
    
    return Z;


def is_number(n):

    try:
        n=float(n);
    except:
        return 0;

    return 1;


def LoadWeightM(filepath, index):

    file = open (filepath,'r');
    
    wm=[];
    rows=col=pcol=0;
    number=0;
    isnumber=0;
    power=1;
    init=0;
    i=0;
    sign=1;
    chs=1;
    found=0;
       
    Lines = file.readlines();

    for line in Lines:

        i=0;

        if line[i] == '%' and found == 0:
            i=i+1;

            number=0.0;

            while is_number(line[i]):
                number=number*10 + float(line[i]);
                i+=1;
            
            if number == index:
                found=1;   

            continue;
        
        elif found== 0:
            continue;


        if line[i] == '#':
            chs+=1;
            continue;

        elif line[i]== '%':
            break;

        if line[i]!='\n':
            if(chs==1):
                rows+=1;
        else:
            continue;

        if init==1:
            pcol=col;

        col=0;

        while i< len(line) and col<13:
            
            #quita los espaciso al principio de la linea
            for k in line[i]:
                if k==' ':
                    i+=1;
                else:
                    break;

            if line[i]=='-':
                sign=-1;
            else:
                sign=1;

            if line[i]=='-' or line[i]=='+':
                i+=1;

            number=0.0;
           
            while is_number(line[i]):
                isnumber=1;
                number=number*10 + float(line[i]);
                i+=1;

          
            if line[i]=='.':
                i+=1;
             
            
            power=1;

            while is_number(line[i]):
                number=number*10 + float(line[i]);
                power*=10;
                i+=1;
            
            if isnumber:
                wm.append((sign*number)/power);
                isnumber=0;
                col+=1;
            
            i+=1;
        
        if init==0:
            pcol=col;
            init=1;
        
        elif pcol!=col:
            return 0,0,0;
        
    file.close();
    
    return wm,rows,col,chs;


def MakeNumpyM(list,rows,col,deep):
    m=np.zeros((rows,col,deep));
    
    for k in range(deep):
        for i in range(rows):
            for j in range(col):
                m[i,j,k]=list[(i*col)+j + rows*col*(deep-1-k)];
    return m


def LoadStr(filepath, index):
    
    file = open (filepath,'r');
   
    Lines=file.readlines();
    
    isnumber=0;
    number=0;
    
    i=0;
    j=0;
    
    for line in Lines:

        if j < index:
            j=j+1;
            continue;
        
        while(is_number(line[i])):
            isnumber=1;
            number=number*10 + int(line[i]);
            i+=1;

        break;
    
    file.close();

    if isnumber:
        return number;
    else:
        return -1;



def LoadImagesFromFolder(path):

    images_name=[];
    images=[];
    counter=0;
    
    #print("Cargando imagenes desde",path);

    for filename in os.listdir(path):
        #print("-> Cargando",filename,"...");
        img = cv2.imread(os.path.join(path,filename))
        if img is not None:
            images.append(img)
            images_name.append(filename);
            counter+=1;

    #print("-> Total imagenes cargadas",counter);
    return images,images_name;


def LoadTxtImages(images_name,images,txtpath):

    images_nametxt=[]

    print("Cargando imagenes en formato txt desde",txtpath,"...");
    for i in range(len(images_name)):
       
        imgtxt=ChangeExt(images_name[i],".txt");
      
        images_nametxt.append(imgtxt);
          
        print("-> Cargando",imgtxt,"...");

        file = open (os.path.join(txtpath,imgtxt),'r');

        m=np.zeros((images[i].shape[0],images[i].shape[1],images[i].shape[2]));
        
        for j in range(images[i].shape[0]):
            for k in range(images[i].shape[1]):          
                for c in range(images[i].shape[2],0,-1):
                    line=file.readline();
                    images[i][j,k,c-1]= int(line);
        
        file.close();
      
    print("-> Total imagenes cargadas",len(images_nametxt));

    return images,images_nametxt;



def ChangeExt(imgname,extension):
    
    newname="";

    for c in imgname:
        if c == '.':
            break;
        else:
            newname+=c;
    
    newname=newname + extension;
    return newname;



def init_convolution(image,image_name,wm,stride):
    
    image_out = conv3D(image,wm,stride);
    print("-> ",image_name,"✅");
    return image_out;




def getOutName(img_name,opt):

    newname="";

    for c in img_name:
        
        if c== '.':
            break;
        else:
            newname+=c;
        
    if opt==0:
        newname=newname+"-out.jpg";
    else:
        newname=newname+"-out.txt";

    return newname;



def SaveTxtFile(img,fullname,txtpath):
    file=open(os.path.join(txtpath,fullname),'w');
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            file.write("%f\n" %img[i,j]);
    file.close();
        


def SaveImages(images,imges_name,jpgpath,txtpath):

    i=0;

    print("Guardando imagenes...");
    for img in images:
        
        fullname=getOutName(imges_name[i],0);
        print("-> Guardando",fullname,"en",jpgpath);
        cv2.imwrite(os.path.join(jpgpath,fullname),img);

        fullname=getOutName(imges_name[i],1);
        print("-> Guardando",fullname,"en",txtpath);
        SaveTxtFile(img,fullname,txtpath);
        
        i+=1;


def main():
   
 
    images,images_name=LoadImagesFromFolder(IFPATHJPG);
    images,images_nametxt=LoadTxtImages(images_name,images,IFPATHTXT);
    images_out=[];

    print("Iniciando proceso de convolución...");


    for i in range(len(images)):

        lw,rows,col,chs=LoadWeightM(WMPATH,i);
        wm=MakeNumpyM(lw,rows,col,chs);
        stride=LoadStr(STRPATH,i);
        image_out=init_convolution(images[i],images_nametxt[i],wm,stride);
        images_out.append(image_out);


    SaveImages(images_out,images_nametxt,OFPATH0,OFPATH1);
    print("Total imagenes procesadas",len(images_nametxt));
    


if __name__ == '__main__':
    main()
