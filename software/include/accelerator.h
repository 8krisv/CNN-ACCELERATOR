#pragma once

#include <stdio.h>
#include <stdbool.h>
#include "../include/Image.h"
#include "../include/load.h"

int accelerator_set_paths(char* if_path, char* jpg_path, char* txt_path);
int accelerator_init(Image* Img,Image* ImgO ,char *ifname, char *ofname,  WeightM* Wm, int stride);
