#include "semantics.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "record.h"

void dec1(record **ss, record **s2, char **s4) {
	char *str;

	if(0 == strcmp(*s4, "string")){
		str = cat("char *", " ", (*s2)->code, ";\n", "");
	} else if (0 == strcmp(*s4, "boolean")){
		str = cat("int", " ", (*s2)->code, ";\n", "");
	} else {
		str = cat(*s4, " ", (*s2)->code, ";\n", "");
	}
	*ss = createRecord(str, *s4);
	free(*s4);
	freeRecord(*s2);
	free(str);
}

void init1(record **ss, record **id, char **type, record **expr) {
    char *str;

    if (0 == strcmp(*type, "string")) {
        str = cat("char * ", (*id)->code, " = ", (*expr)->opt1, ";\n");
    } else if (0 == strcmp(*type, "boolean")) {
        str = cat("int ",  (*id)->code, " = ", (*expr)->opt1, ";\n");
    } else {
        str = cat(*type, " ", (*id)->code, " = ", (*expr)->opt1);
        str = cat(str, ";\n", "", "", "");
    }

    *ss = createRecord(str, *type);

    freeRecord(*id);
    freeRecord(*expr);
    free(*type);
    free(str);
}

//VALUE TRUE
void baseTrue(record **ss) {
    *ss = createRecord("bool", "1");
}

//VALUE FALSE
void baseFalse(record **ss) {
    *ss = createRecord("bool", "0");
}

//STRING LITERAL
void baseStringLiteral(record **ss, char **s1) {
    *ss = createRecord("string", *s1);
    free(*s1);
}
//INT NUMBER						
void baseIntNumber(record **ss, int *s1)  {
	char strNum[50];
	sprintf(strNum, "%d", *s1);

	*ss = createRecord("int",strNum);
}
//NUMBER REAL							
void baseRealNumber(record **ss, float *s1) {
	char strNum[50];
	sprintf(strNum, "%f", *s1);
	*ss = createRecord("float", strNum);
}