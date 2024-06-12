#include <flecs.h>

struct vec2 {
    float x;
    float y;
    vec2() : x(0.0), y(0.0) {}
    vec2(float x, float y) : x(x), y(y) {}
};

extern "C" void lib_initialize(void* ctx) {
    assert(ctx);
    ecs_set_os_api_impl();
    ecs_os_init();

    flecs::world& world = *(flecs::world*)ctx;

    // crashes after 1 reload with segfault
    world.entity().set(vec2{400.0f, 400.0f});

    // doesn't seem to ever crash even after hundreds of thousands
    // of iterations
    world.entity().emplace<vec2>(400.0f, 400.0f);
}
