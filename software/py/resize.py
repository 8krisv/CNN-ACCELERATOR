from PIL import Image
import os


IFPATHJPG = "../../files/IF/jpg";
IFPATHJPG2 = "../../files/IF/jpg_raw";


def main():
    resize(IFPATHJPG2,IFPATHJPG);


def resize(ifpath,ofpath):

    i=0;

    for filename in os.listdir(ifpath):

        im = Image.open(os.path.join(ifpath,filename));

        if i >= 0 and i <= 9:

            print("-> Redimensionando", os.path.join(ifpath,filename), "a 32x32 pixeles..." );
            im_resized = im.resize((32,32));
        
        elif i > 9 and i <= 29:

            print("-> Redimensionando", os.path.join(ifpath,filename), "a 64x64 pixeles..." );
            im_resized = im.resize((64,64));

        elif i > 29 and i<= 49:

            print("-> Redimensionando", os.path.join(ifpath,filename), "a 128x128 pixeles..." );
            im_resized = im.resize((128,128));

        
        elif i > 49 and i<= 69:

            print("-> Redimensionando", os.path.join(ifpath,filename), "a 256x256 pixeles..." );
            im_resized = im.resize((256,256));


        elif i > 69 and i<= 89:
            print("-> Redimensionando", os.path.join(ifpath,filename), "a 256x128 pixeles..." );
            im_resized = im.resize((256,128));


        else:
            print("-> Redimensionando", os.path.join(ifpath,filename), "a 128x256 pixeles..." );
            im_resized = im.resize((128,256));

            
        im_resized.save(os.path.join(ofpath,filename));

        i=i+1;

    print("-> Total imagenes encontradas:", i);


        

if __name__ == '__main__':
    main();
