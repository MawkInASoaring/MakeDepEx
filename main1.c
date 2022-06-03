#include <stdio.h>
#include "func1.h"
#include "func2.h"

int main(int argc, char* argv[]) {
	printf("main 1 using func 1 and func 2\n");
	func1();
	func2();
	return 0;
}

