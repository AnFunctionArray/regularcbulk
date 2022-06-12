extern int printf(const char *, ...);

int f(int);
int f(float a) {
    return printf("f float int -> %f\n", a);
}
int f(int,int);

int main() {
    return f(8) + f(0,8) + f(0.,7);
}

int f(int a) {
    return printf("f int -> %d\n", a);
}

int f(int a, int b) {
    return printf("f int int -> %d\n", a + b);
}