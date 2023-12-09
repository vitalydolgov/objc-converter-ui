//
//  adapter.c
//  ObjcConverter
//
//  Created by Vitaly Dolgov on 11/24/23.
//

#include "adapter.h"
#include <caml/callback.h>

extern char * process(const char *str);

void x_caml_startup(void)
{
    char **dummy_argv = malloc(sizeof(char *));
    caml_startup(dummy_argv);
}

char * x_process(const char *input)
{
    return process(input);
}
