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

void init1(record **ss, record **id, char **type, record **expr) {
    char *str;

    if (0 == strcmp(*type, "string")) {
        str = cat("char *", " ", (*id)->code, " = ", (*expr)->code);
    } else if (0 == strcmp(*type, "boolean")) {
        str = cat("int", " ", (*id)->code, " = ", (*expr)->code);
    } else {
        str = cat(*type, " ", (*id)->code, " = ", (*expr)->code);
    }

    *ss = createRecord(str, *type);

    freeRecord(*id);
    freeRecord(*expr);
    free(*type);
    free(str);
}

void baseTrue(record **ss) {
    *ss = createRecord("bool", "true");
}

void baseFalse(record **ss) {
    *ss = createRecord("bool", "false");
}