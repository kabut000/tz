volatile unsigned int* const UART0DR = (unsigned int *)0x09000000;

void print(const char *s){
    while(*s != '\0'){
        *UART0DR = (unsigned int)(*s);
        s++;
    }
}

void *memcpy(void *dst, const void *src, long len){
    char *d = dst;
    const char *s = src;
    for(; len>0; len--)
        *(d++) = *(s++);
    return dst;
}

void *monitor_start(){
    void *secure_base = (void *)0x0e100000;
    void *normal_base = (void *)0x60000000;
    void *simage_base = (void *)0x20000;
    void *nimage_base = (void *)0x40000;

    memcpy(secure_base, simage_base, 0x20000);
    memcpy(normal_base, nimage_base, 0x200000);
    print("Hello\n");

    return secure_base;
}
