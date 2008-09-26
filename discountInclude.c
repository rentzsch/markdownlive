#include <stdio.h>
#include "discountInclude.h"

// Work-around QuickDraw's declaration of Line.
#define Line discountLine
    #include "discount-1.2.10/mkdio.c"
    #include "discount-1.2.10/markdown.c"
    #include "discount-1.2.10/resource.c"
#undef Line
