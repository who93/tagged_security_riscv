// A hello world program

#include <stdio.h>
#include "uart.h"
#include "tag.h"

 long a[10];

int main() {
 a[0] = 0x01;
 a[1] = 0x02;
 a[2] = 0x03;
 a[3] = 0x04;
 long i = 0;
  int test = 0;
 // for(i=0; i<10; i++) {
    int temp = 0;
int tag_in = 0x01;
 asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"(a));
temp = 0;
  asm volatile ("stag %0, 0(%1)"
                :
                :"r"(tag_in), "r"(a)
 );
    asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"(a));
    i += temp;
 if(a[0] == 0x66)
   return 0;
else
   return -1;

    //store_tag(a, temp);
   // test = load_tag(a);
  //  return i;
 // }
  //uart_init();
  //printf("Hello World!\n");


}

