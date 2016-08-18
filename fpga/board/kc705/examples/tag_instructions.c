// A hello world program

#include <stdio.h>
#include "uart.h"
#include "tag.h"


#define SYS_soft_reset 617
#define SYS_set_iobase 0x12200
#define SYS_set_membase 0x2100
extern long syscall(long num, long arg0, long arg1, long arg2);


 long a[10];

int dummy2(int bla)
{
  bla += 2;

  return bla;
}


int dummyfunc()
{

  int tester = 0;
  tester = dummy2(2);

  return tester;


}

#define write_csr(reg, val) \
  asm volatile ("csrw " #reg ", %0" :: "r"(val))

int main() {

 write_csr(0x800, 0xF); // Activate al checks + dummy trap check
 int dummy_var = 5;

  dummy_var = dummyfunc();

 a[0] = 0xDDDDDDFEFEEFFFFF;
 a[1] = 0x02;
 a[2] = 0x03;
 a[3] = 0x04;
 long i = 0;
  int test = 0;
 // for(i=0; i<10; i++) {
    int temp = 0;
int tag_in = 0x08;
 //asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"(a));
//temp = 0;

//Do some other stuff to flush the registers
long bla = 0x00000aaaa;

a[0] = 0xBBBBBBFEFEEFFFFF;
asm volatile ("stag %0, 0(%1)" ::"r"(tag_in), "r"(a));
asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"(a));
a[1] = a[0] - 0xF;
if(a[0] != 0xBBBBBBFEFEEFFFFF)
{
  return -1;
}
if(a[1] != 0xBBBBBBFEFEEFFFF0)
{
  return -1;
}
asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"((a + 1)));
if(temp != 0x8)
  return -1;

asm volatile ("ltag %0, 0(%1)":"=r"(temp):"r"(a));
if(a[0] != 0xBBBBBBFEFEEFFFFF)
{
  return -1;
}

 if(temp == 0x08)
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

