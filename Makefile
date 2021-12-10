
#compiler options
CC=gcc
CFLAGS= -lm

#folders
BIN1=./software/bin/
BIN2=./bin/
SOURCE=./software/src/


build:
	$(CC) $(SOURCE)main.c $(SOURCE)elements.c $(SOURCE)load.c $(SOURCE)Image.c $(SOURCE)utils.c $(SOURCE)accelerator.c -o $(BIN1)accel $(CFLAGS)
	$(CC) $(SOURCE)load.c $(SOURCE)Image.c  $(SOURCE)utils.c $(SOURCE)convert.c -o $(BIN2)totxt $(CFLAGS)
	$(CC) $(SOURCE)load.c $(SOURCE)Image.c  $(SOURCE)utils.c $(SOURCE)verilog.c -o $(BIN2)memv $(CFLAGS)
	

