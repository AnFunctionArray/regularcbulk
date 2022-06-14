extern int printf(const char *, ...);

union test {
    float a;
    double b;
    struct {
        union {
            struct {
                unsigned int c, d;
            }d;
            double e;
        };
    };
};

int main() {
    union test b;
    b.d.c = 0xE147AE14UL;
    b.d.d = 0x401F147AUL;
    
    return printf("%f\n", b.e);
}

