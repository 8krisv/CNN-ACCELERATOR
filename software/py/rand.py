import numpy as np
import os


MAX_ROWS = 6;
MAX_COLUMS = 6;
MIN_ROWS = 2;
MIN_COLUMS =2;
MAX_STRIDE = 16;

STRPATH = "../../files/IF/random/Stride";
WPATH = "../../files/IF/random/W";
IFPATHJPG= "../../files/IF/jpg";


def main():
    random();

def random():

    file_stride = open(STRPATH,'w');
    file_w = open(WPATH,'w');

    file_w.write("%0");
    file_w.write('\n');

    print("Generando valores aleatorios...");
    
    for i in range(len(os.listdir(IFPATHJPG))):

        m = np.random.randint(2,6);
        n = np.random.randint(2,6);
        w =np.random.randint(3, size=(m, n, 3));
    
        for k in range (3):
            for x in range(m):
                for y in range(n):
                    file_w.write(str(w[x,y,k]));
                    file_w.write(" ");
                file_w.write('\n');

            if k<2:    
                file_w.write("#\n");
        
        if i < (len(os.listdir(IFPATHJPG))-1):
         file_w.write("%");
         file_w.write(str(i+1));
         file_w.write('\n');
       
        file_stride.write(str(np.random.randint(1, MAX_STRIDE))); 
        file_stride.write('\n');

    

    print("Total valores generados:",i+1);



if __name__ == '__main__':
    main();