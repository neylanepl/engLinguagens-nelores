#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "record.h"

void dec1(record **ss, record **s2, char **s4) {
	char *str;

	if(0 == strcmp(*s4, "string")){
		str = cat("char *", " ", (*s2)->code, "", "");
	} else if (0 == strcmp(*s4, "boolean")){
		str = cat("int", " ", (*s2)->code, "", "");
	} else {
		str = cat(*s4, " ", (*s2)->code, "", "");
	}
	*ss = createRecord(str, *s4);
	free(*s4);
	freeRecord(*s2);
	free(str);
}