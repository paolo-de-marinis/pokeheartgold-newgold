// A headless libretro host, just enough to boot a DS ROM and look at it.
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

enum {
    ENV_GET_OVERSCAN = 2, ENV_GET_CAN_DUPE = 3, ENV_SET_MESSAGE = 6,
    ENV_SHUTDOWN = 7, ENV_SET_PERFORMANCE_LEVEL = 8, ENV_GET_SYSTEM_DIRECTORY = 9,
    ENV_SET_PIXEL_FORMAT = 10, ENV_SET_INPUT_DESCRIPTORS = 11,
    ENV_SET_KEYBOARD_CALLBACK = 12, ENV_SET_DISK_CONTROL_INTERFACE = 13,
    ENV_SET_HW_RENDER = 14, ENV_GET_VARIABLE = 15, ENV_SET_VARIABLES = 16,
    ENV_GET_VARIABLE_UPDATE = 17, ENV_SET_SUPPORT_NO_GAME = 18,
    ENV_GET_LIBRETRO_PATH = 19, ENV_GET_LOG_INTERFACE = 27,
    ENV_GET_PERF_INTERFACE = 28, ENV_GET_SAVE_DIRECTORY = 31,
    ENV_SET_SYSTEM_AV_INFO = 32, ENV_SET_SUBSYSTEM_INFO = 34,
    ENV_SET_CONTROLLER_INFO = 35, ENV_SET_MEMORY_MAPS = 36,
    ENV_SET_GEOMETRY = 37, ENV_GET_INPUT_BITMASKS = 51 | 0x10000,
    ENV_GET_CORE_OPTIONS_VERSION = 52, ENV_SET_CORE_OPTIONS = 53,
    ENV_SET_CORE_OPTIONS_INTL = 54, ENV_SET_CORE_OPTIONS_DISPLAY = 55,
    ENV_SET_CORE_OPTIONS_V2 = 67, ENV_SET_CORE_OPTIONS_V2_INTL = 68,
    ENV_SET_AUDIO_BUFFER_STATUS_CALLBACK = 62,
    ENV_SET_MINIMUM_AUDIO_LATENCY = 63,
};

struct game_info { const char *path; const void *data; size_t size; const char *meta; };
struct variable { const char *key; const char *value; };
struct log_callback { void (*log)(int level, const char *fmt, ...); };

static char system_dir[512], save_dir[512];
static uint32_t *frame;
static unsigned frame_w, frame_h;
static unsigned long frames_run;
static int pressed[16];
static int touching, touch_x, touch_y;
static int quiet = 1;

// The core has no clock of its own: melonDS sets the console's RTC from the
// host's time(), and the game draws its random pre-size at boot from the RTC
// among other things (sub_0201A1B4), so the same input booted differently
// from one second to the next -- and white whenever the pre-size was more
// than the main arena had room for. clock:SECONDS pins what time() answers,
// in UTC, for the whole run. The host is linked -rdynamic, so the core,
// loaded after it, calls this time() and not the C library's.
static long long pinned_clock = -1;

time_t time(time_t *out) {
    struct timespec now;
    time_t t;
    if (pinned_clock >= 0) {
        t = (time_t)pinned_clock;
    } else {
        clock_gettime(CLOCK_REALTIME, &now);
        t = now.tv_sec;
    }
    if (out) *out = t;
    return t;
}

static void logger(int level, const char *fmt, ...) {
    if (quiet && level < 2) return;
    va_list ap; va_start(ap, fmt); vfprintf(stderr, fmt, ap); va_end(ap);
}

static bool environment(unsigned cmd, void *data) {
    switch (cmd) {
    case ENV_GET_CAN_DUPE: *(bool *)data = true; return true;
    case ENV_GET_OVERSCAN: *(bool *)data = false; return true;
    case ENV_SET_PIXEL_FORMAT: return *(const int *)data == 1; // XRGB8888
    case ENV_GET_SYSTEM_DIRECTORY: *(const char **)data = system_dir; return true;
    case ENV_GET_SAVE_DIRECTORY: *(const char **)data = save_dir; return true;
    case ENV_GET_LOG_INTERFACE: ((struct log_callback *)data)->log = logger; return true;
    case ENV_GET_VARIABLE: {
        struct variable *v = data;
        // Everything the core asks about takes its default; only the ones that
        // decide whether it can run at all are answered.
        if (!strcmp(v->key, "melonds_boot_directly")) v->value = "enabled";
        else if (!strcmp(v->key, "melonds_console_mode")) v->value = "DS";
        else if (!strcmp(v->key, "melonds_use_external_bios")) v->value = "disabled";
        else if (!strcmp(v->key, "melonds_opengl_renderer")) v->value = "disabled";
        else if (!strcmp(v->key, "melonds_threaded_renderer")) v->value = "disabled";
        else if (!strcmp(v->key, "melonds_jit_enable")) v->value = "disabled";
        else if (!strcmp(v->key, "melonds_screen_layout")) v->value = "Top/Bottom";
        // Without this the core ignores the pointer, and every touch this
        // harness sends goes nowhere at all.
        else if (!strcmp(v->key, "melonds_touch_mode")) v->value = "Touch";
        else v->value = NULL;
        return v->value != NULL;
    }
    case ENV_GET_VARIABLE_UPDATE: *(bool *)data = false; return true;
    case ENV_GET_CORE_OPTIONS_VERSION: *(unsigned *)data = 0; return true;
    case ENV_GET_INPUT_BITMASKS: return false;
    case ENV_SET_PERFORMANCE_LEVEL: case ENV_SET_VARIABLES:
    case ENV_SET_INPUT_DESCRIPTORS: case ENV_SET_CONTROLLER_INFO:
    case ENV_SET_SUPPORT_NO_GAME: case ENV_SET_MEMORY_MAPS:
    case ENV_SET_GEOMETRY: case ENV_SET_SYSTEM_AV_INFO:
    case ENV_SET_CORE_OPTIONS: case ENV_SET_CORE_OPTIONS_INTL:
    case ENV_SET_CORE_OPTIONS_DISPLAY: case ENV_SET_CORE_OPTIONS_V2:
    case ENV_SET_CORE_OPTIONS_V2_INTL: case ENV_SET_MESSAGE:
    case ENV_SET_AUDIO_BUFFER_STATUS_CALLBACK: case ENV_SET_MINIMUM_AUDIO_LATENCY:
        return true;
    default: return false;
    }
}

static void video(const void *data, unsigned width, unsigned height, size_t pitch) {
    if (!data) return;
    frame_w = width; frame_h = height;
    free(frame);
    frame = malloc((size_t)width * height * 4);
    for (unsigned y = 0; y < height; y++)
        memcpy((char *)frame + (size_t)y * width * 4, (const char *)data + y * pitch, (size_t)width * 4);
}

static size_t audio_batch(const int16_t *data, size_t frames) { (void)data; return frames; }
static void audio_sample(int16_t l, int16_t r) { (void)l; (void)r; }
static void input_poll(void) {}
static unsigned long polled[8];
static int16_t input_state(unsigned port, unsigned device, unsigned index, unsigned id) {
    (void)index;
    if (device < 8) polled[device]++;
    if (port) return 0;
    if (device == 6) { // pointer: the touch screen
        if (id == 0) return touch_x;
        if (id == 1) return touch_y;
        if (id == 2) return touching;
        return 0;
    }
    if (device != 1 || id >= 16) return 0;
    return pressed[id];
}

static void write_ppm(const char *path) {
    FILE *f = fopen(path, "wb");
    if (!f) return;
    fprintf(f, "P6\n%u %u\n255\n", frame_w, frame_h);
    for (unsigned i = 0; i < frame_w * frame_h; i++) {
        uint32_t p = frame[i];
        fputc((p >> 16) & 0xFF, f); fputc((p >> 8) & 0xFF, f); fputc(p & 0xFF, f);
    }
    fclose(f);
}

int main(int argc, char **argv) {
    if (argc < 5) {
        fprintf(stderr, "usage: boot_check CORE ROM SYSDIR FRAMES [shot:FRAME:PATH | press:FRAME:LEN:BUTTON]...\n");
        return 2;
    }
    const char *core_path = argv[1], *rom_path = argv[2];
    snprintf(system_dir, sizeof system_dir, "%s", argv[3]);
    snprintf(save_dir, sizeof save_dir, "%s", argv[3]);
    unsigned long frames = strtoul(argv[4], NULL, 10);
    for (int i = 5; i < argc; i++) {
        if (sscanf(argv[i], "clock:%lld", &pinned_clock) == 1) {
            setenv("TZ", "UTC0", 1);
            tzset();
        }
    }

    void *core = dlopen(core_path, RTLD_NOW);
    if (!core) { fprintf(stderr, "dlopen: %s\n", dlerror()); return 1; }
    #define SYM(n) dlsym(core, n)
    void (*set_environment)(bool (*)(unsigned, void *)) = SYM("retro_set_environment");
    void (*set_video)(void (*)(const void *, unsigned, unsigned, size_t)) = SYM("retro_set_video_refresh");
    void (*set_audio_batch)(size_t (*)(const int16_t *, size_t)) = SYM("retro_set_audio_sample_batch");
    void (*set_audio)(void (*)(int16_t, int16_t)) = SYM("retro_set_audio_sample");
    void (*set_input_poll)(void (*)(void)) = SYM("retro_set_input_poll");
    void (*set_input_state)(int16_t (*)(unsigned, unsigned, unsigned, unsigned)) = SYM("retro_set_input_state");
    void (*core_init)(void) = SYM("retro_init");
    bool (*load_game)(const struct game_info *) = SYM("retro_load_game");
    void (*run)(void) = SYM("retro_run");
    void *(*memory_data)(unsigned) = SYM("retro_get_memory_data");
    size_t (*memory_size)(unsigned) = SYM("retro_get_memory_size");
    void (*unload)(void) = SYM("retro_unload_game");
    size_t (*serialize_size)(void) = SYM("retro_serialize_size");
    bool (*serialize)(void *, size_t) = SYM("retro_serialize");
    bool (*unserialize)(const void *, size_t) = SYM("retro_unserialize");
    void (*deinit)(void) = SYM("retro_deinit");
    if (!set_environment || !core_init || !load_game || !run) {
        fprintf(stderr, "the core is missing the libretro entry points\n");
        return 1;
    }

    set_environment(environment);
    core_init();
    set_video(video); set_audio_batch(audio_batch); set_audio(audio_sample);
    set_input_poll(input_poll); set_input_state(input_state);

    FILE *rom = fopen(rom_path, "rb");
    if (!rom) { perror(rom_path); return 1; }
    fseek(rom, 0, SEEK_END); long size = ftell(rom); fseek(rom, 0, SEEK_SET);
    void *data = malloc((size_t)size);
    if (fread(data, 1, (size_t)size, rom) != (size_t)size) { perror("read"); return 1; }
    fclose(rom);

    struct game_info info = { rom_path, data, (size_t)size, NULL };
    // A save file goes in before anything runs, so the title screen offers
    // Continue. This core keeps no battery memory to write into: it reads
    // and writes <save directory>/<rom name>.sav itself, so the file is put
    // there under the name it will look for, before the ROM is loaded.
    for (int i = 5; i < argc; i++) {
        char path[256];
        if (sscanf(argv[i], "sram:%255s", path) != 1) continue;
        FILE *from = fopen(path, "rb");
        if (!from) { perror(path); return 1; }
        const char *name = strrchr(rom_path, '/');
        name = name ? name + 1 : rom_path;
        char target[512];
        snprintf(target, sizeof target, "%s/%.*s.sav", save_dir,
                 (int)(strrchr(name, '.') ? (size_t)(strrchr(name, '.') - name) : strlen(name)), name);
        FILE *to = fopen(target, "wb");
        if (!to) { perror(target); return 1; }
        char chunk[1 << 16];
        size_t got, wrote = 0;
        while ((got = fread(chunk, 1, sizeof chunk, from)) > 0) { wrote += fwrite(chunk, 1, got, to); }
        fclose(from); fclose(to);
        fprintf(stderr, "put %zu bytes of save into %s\n", wrote, target);
    }

    if (!load_game(&info)) { fprintf(stderr, "the core would not load the ROM\n"); return 1; }

    // Starting from a state costs one frame instead of twenty thousand, which
    // is what makes checking anything past the opening practical at all. The
    // core wants a frame of its own before it will take one.
    for (int i = 5; i < argc; i++) {
        char probe[256];
        if (sscanf(argv[i], "load:%255s", probe) == 1) { run(); break; }
    }
    for (int i = 5; i < argc; i++) {
        char path[256];
        if (sscanf(argv[i], "load:%255s", path) != 1) continue;
        FILE *f = fopen(path, "rb");
        if (!f) { perror(path); return 1; }
        fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET);
        void *state = malloc((size_t)n);
        if (fread(state, 1, (size_t)n, f) != (size_t)n) { perror("read"); return 1; }
        fclose(f);
        if (!unserialize || !unserialize(state, (size_t)n)) {
            fprintf(stderr, "the core would not take the state in %s\n", path);
            return 1;
        }
        free(state);
    }

    for (frames_run = 0; frames_run < frames; frames_run++) {
        memset(pressed, 0, sizeof pressed);
        touching = 0;
        for (int i = 5; i < argc; i++) {
            unsigned long at, len; int button; int px, py;
            if (sscanf(argv[i], "press:%lu:%lu:%d", &at, &len, &button) == 3
                && frames_run >= at && frames_run < at + len)
                pressed[button] = 1;
            unsigned long until, period;
            // Held down every so often between two frames, for getting through
            // a long stretch of text without writing out every press.
            if (sscanf(argv[i], "mash:%lu:%lu:%lu:%lu:%d", &at, &until, &period, &len, &button) == 5
                && frames_run >= at && frames_run < until
                && (frames_run - at) % period < len)
                pressed[button] = 1;
            // The pointer spans both screens, so a touch is given in the
            // bottom screen's own pixels and moved down into it here. The
            // core also ignores the pointer entirely unless its touch mode
            // says otherwise, which is answered in the environment above.
            if (sscanf(argv[i], "tap:%lu:%lu:%lu:%lu:%d:%d", &at, &until, &period, &len, &px, &py) == 6
                && frames_run >= at && frames_run < until
                && (frames_run - at) % period < len) {
                touching = 1;
                touch_x = (int)((((double)px / 256.0) * 2.0 - 1.0) * 0x7FFF);
                touch_y = (int)((((double)(py + 192) / 384.0) * 2.0 - 1.0) * 0x7FFF);
            }
            // Raw pointer coordinates, already in libretro's -0x7FFF..0x7FFF
            // space, for working out what the core expects.
            {
                int rx, ry;
                if (sscanf(argv[i], "rawtouch:%lu:%lu:%d:%d", &at, &len, &rx, &ry) == 4
                    && frames_run >= at && frames_run < at + len) {
                    touching = 1; touch_x = rx; touch_y = ry;
                }
            }
            if (sscanf(argv[i], "touch:%lu:%lu:%d:%d", &at, &len, &px, &py) == 4
                && frames_run >= at && frames_run < at + len) {
                touching = 1;
                touch_x = (int)((((double)px / 256.0) * 2.0 - 1.0) * 0x7FFF);
                touch_y = (int)((((double)(py + 192) / 384.0) * 2.0 - 1.0) * 0x7FFF);
            }
        }
        run();
        for (int i = 5; i < argc; i++) {
            unsigned long at; char path[256];
            if (sscanf(argv[i], "shot:%lu:%255s", &at, path) == 2 && frames_run == at)
                write_ppm(path);
            // The console's own memory, for finding where the game keeps
            // something rather than guessing it from the screen.
            // The mirror of ram:. The player's tile is a field of a struct
            // this repository declares, reached from a symbol in the ROM, so
            // moving them inside the map they are already on is a write --
            // where.py works out the address, this puts a value there. It
            // cannot change map: the game has to load one.
            {
                unsigned long address, len; int width; long value;
                // poke:FRAME:ADDR:WIDTH:VALUE writes once;
                // hold:FRAME:LEN:ADDR:WIDTH:VALUE writes every frame of a
                // stretch, which is how a value the game keeps changing --
                // the random seed, say -- can be held where it is wanted.
                int once = sscanf(argv[i], "poke:%lu:%lx:%d:%ld", &at, &address, &width, &value) == 4
                           && frames_run == at;
                int held = sscanf(argv[i], "hold:%lu:%lu:%lx:%d:%ld", &at, &len, &address, &width, &value) == 5
                           && frames_run >= at && frames_run < at + len;
                if (once || held) {
                    void *ram = memory_data ? memory_data(2) : NULL;
                    size_t size = memory_size ? memory_size(2) : 0;
                    unsigned long offset = address - 0x02000000;
                    if (ram && offset + (unsigned)width <= size) {
                        for (int b = 0; b < width; b++)
                            ((unsigned char *)ram)[offset + b] = (unsigned char)(value >> (8 * b));
                    } else {
                        fprintf(stderr, "poke: %#lx is outside the console's memory\n", address);
                    }
                }
            }
            if (sscanf(argv[i], "ram:%lu:%255s", &at, path) == 2 && frames_run == at) {
                size_t n = memory_size ? memory_size(2) : 0;  // SYSTEM_RAM
                void *ram = memory_data ? memory_data(2) : NULL;
                if (!ram || !n) { fprintf(stderr, "the core hands out no RAM\n"); return 1; }
                FILE *f = fopen(path, "wb");
                if (!f) { perror(path); return 1; }
                fwrite(ram, 1, n, f);
                fclose(f);
                printf("ram at frame %lu: %zu bytes in %s\n", at, n, path);
            }
            // A small window of RAM, sampled every so many frames into one file:
            // a four-byte frame number, then the bytes. It is how a battle is
            // followed as text -- the diagnostics' own block is a few
            // kilobytes, where a whole dump is four megabytes a sample.
            unsigned long every, address, length;
            if (sscanf(argv[i], "mem:%lu:%lu:%lx:%lu:%255s", &at, &every, &address, &length, path) == 5
                && frames_run >= at && every && (frames_run - at) % every == 0) {
                unsigned char *ram = memory_data ? memory_data(2) : NULL;
                size_t n = memory_size ? memory_size(2) : 0;
                if (ram && address >= 0x02000000 && address - 0x02000000 + length <= n) {
                    FILE *f = fopen(path, "ab");
                    if (!f) { perror(path); return 1; }
                    unsigned int frame = (unsigned int)frames_run;
                    fwrite(&frame, 4, 1, f);
                    fwrite(ram + (address - 0x02000000), 1, length, f);
                    fclose(f);
                }
            }
            if (sscanf(argv[i], "save:%lu:%255s", &at, path) == 2 && frames_run == at) {
                size_t n = serialize_size ? serialize_size() : 0;
                void *state = n ? malloc(n) : NULL;
                if (!state || !serialize(state, n)) {
                    fprintf(stderr, "the core would not give up its state\n");
                    return 1;
                }
                FILE *f = fopen(path, "wb");
                if (!f) { perror(path); return 1; }
                fwrite(state, 1, n, f);
                fclose(f);
                free(state);
                printf("state at frame %lu: %zu bytes in %s\n", at, n, path);
            }
        }
    }

    printf("ran %lu frames, last frame %ux%u\n", frames_run, frame_w, frame_h);
    printf("input polls:");
    for (unsigned d = 0; d < 8; d++) if (polled[d]) printf(" device%u=%lu", d, polled[d]);
    printf("\n");
    if (unload) unload();
    if (deinit) deinit();
    return 0;
}
