volatile unsigned int* const UART0DR = (unsigned int *)0x09040000;

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

int secure_start(){
    print("Hello Secure World\n");
}
