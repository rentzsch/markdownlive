#include "config.h"

char markdown_version[] = VERSION
#if DL_TAG_EXTENSION
		" DL_TAG"
#endif
#if PANDOC_HEADER
		" HEADER"
#endif
#if 4 != 4
		" TAB=4"
#endif
#if SUPERSCRIPT
		" SUPERSCRIPT"
#endif
#if USE_AMALLOC
		" DEBUG"
#endif
#if RELAXED_EMPHASIS
		" RELAXED"
#endif
		;
