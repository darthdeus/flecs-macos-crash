#include <dlfcn.h>
#include <flecs.h>

int main() {
    flecs::world world;

    int reload_count = 0;

    while (true) {
        void* lib_handle = dlopen("bin/liblibrary.so", RTLD_NOW | RTLD_LOCAL);
        if (!lib_handle) {
            printf("dlopen error: %s\n", dlerror());
            exit(1);
        }

        printf("RELOADING %d\n", reload_count++);

        typedef void (*lib_interop_func)(void*);
        lib_interop_func lib_initialize =
            (lib_interop_func)dlsym(lib_handle, "lib_initialize");

        if (!lib_initialize) {
            printf("error: %s\n", dlerror());
            exit(1);
        }

        lib_initialize(&world);

        int res = dlclose(lib_handle);
        if (res) {
            printf("dlclose error: %s\n", dlerror());
            exit(1);
        }
    }
}
