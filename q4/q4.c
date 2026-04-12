

#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[10];
    int a, b;
    while (scanf("%s %d %d", op, &a, &b) == 3) {
        char libname[32] = "./lib";
        strcat(libname, op);
        strcat(libname, ".so");
        void *handle = dlopen(libname, RTLD_NOW);
        if (!handle) {
            printf("0\n");
            continue;
        }
        dlerror();
        int (*func)(int, int);
        *(void **)(&func) = dlsym(handle, op);
        if (!func) {
            printf("0\n");
            dlclose(handle);
            continue;
        }
        int result = func(a, b);
        printf("%d\n", result);
        dlclose(handle);
    }
    return 0;
}