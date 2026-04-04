#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[10];
    int a, b;
    while (scanf("%s %d %d", op, &a, &b) == 3) {
        char libname[32] = "lib";
        strcat(libname, op);
        strcat(libname, ".so");
        void *handle = dlopen(libname, RTLD_NOW);
        if (!handle) return 1;

        int (*func)(int, int);
        *(void **)(&func) = dlsym(handle, op);
        if (!func) {
            dlclose(handle);
            return 1;
        }

        int result = func(a, b);
        printf("%d\n", result);

        dlclose(handle);
    }
    return 0;
}