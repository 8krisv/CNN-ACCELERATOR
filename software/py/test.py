
import numpy as np
import cv2
import os

OFPATHPY = "../../files/OF/pyout/txt";
OFPATHC = "../../files/OF/hcout/txt";
OFPATHSIM = "../../files/OF/simout";

def main():

    test(OFPATHPY,OFPATHC,OFPATHSIM);

def test(ofpathpy,ofpathc,ofpathsim):

    testp=0;
    filesread=0;
    COMMENT_LINES = 3;

    print("Ininiando test...");

    for filename in os.listdir(ofpathsim):

        file0 = open(os.path.join(ofpathc,filename),'r');
        file1 = open(os.path.join(ofpathpy,filename),'r');
        file2 = open(os.path.join(ofpathsim,filename),'r');

        filesread+=1;
        print("-> Comparando",os.path.join(ofpathc,filename),",",os.path.join(ofpathpy,filename),",",os.path.join(ofpathsim,filename));

        Lines0 = file0.readlines();
        Lines1 = file1.readlines();
        Lines2 = file2.readlines();
        
        if len(Lines0)!=len(Lines1) or len(Lines0)!= (len(Lines2)-COMMENT_LINES):
            print(" ->",filename,"no paso el test ✖");
            print(len(Lines0),len(Lines1),len(Lines2)-COMMENT_LINES);
        
        else:
            k=0;
            for k in range(len(Lines1)):

                if( Lines0[k]  != Lines1[k] or int(float(Lines0[k])) != get_number(Lines2[k+COMMENT_LINES],32)):        
                    break;

            if k== len(Lines1)-1:
                print(" ->", filename,"paso el test ✅");
                testp+=1;
            else:
                print(" ->",filename,"no paso el test ✖");
                print("l=",k+1);
            
            
    print("Total test hechos",filesread,",total test pasados",testp);


def get_number(line,bits):

    n= int(line,16);

    if(n& (1<<(bits-1))):
        n= n-(1<<bits);
	
    return n

if __name__ == '__main__':
    main();
