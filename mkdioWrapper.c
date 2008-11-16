//#include "mkdioWrapper.h"
#include "discount-1.3.0/mkdio.h"

#define Document void

Document* mkd_string_wrapper(char *buf, int len, int flags) {
    return mkd_string(buf, len, flags);
}

void mkd_cleanup_wrapper(Document *doc) {
    mkd_cleanup(doc);
}
