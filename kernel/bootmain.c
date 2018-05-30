// Boot loader.
// 
// Part of the boot block, along with bootasm.S, which calls bootmain().
// bootasm.S has put the processor into protected 32-bit mode.
// bootmain() loads a multiboot kernel image from the disk starting at
// sector 1 and then jumps to the kernel entry routine.

#include "types.h"
#include "x86.h"
#include "memlayout.h"

#define SECTSIZE  512

struct mbheader {
  uint32 magic;
  uint32 flags;
  uint32 checksum;
  uint32 header_addr;
  uint32 load_addr;
  uint32 load_end_addr;
  uint32 bss_end_addr;
  uint32 entry_addr;
};

//static void readseg(uchar*, uint, uint);
static void memcpy(void *to,void *from,uint n)
{
		int d0, d1, d2;
		asm volatile("rep ; movsl\n\t"
		     "movl %4,%%ecx\n\t"
		     "andl $3,%%ecx\n\t"
		     "jz 1f\n\t"
		     "rep ; movsb\n\t"
		     "1:"
		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
		     : "0" (n / 4), "g" (n), "1" ((long)to), "2" ((long)from)
		     : "memory");
}


void
bootmain(void)
{
  struct mbheader *hdr;
  void (*entry)(void);
  uint32 *x;
  uint n;
	int i;
	char* base = (char *)0xb8000;
  x = (uint32*) 0x10000; // scratch space

	  
// multiboot header must be in the first 8192 bytes
//  readseg((uchar*)x, 8192, 0);


	for(i = 0; i < 10;i+=2)
	{
	
		*(base + i)  = 'a';
 	}

  for (n = 0; n < 8192/4; n++)
    if (x[n] == 0x1BADB002)
      if ((x[n] + x[n+1] + x[n+2]) == 0)
        goto found_it;

  // failure
  return;

found_it:

  hdr = (struct mbheader *) (x + n);

  if (!(hdr->flags & 0x10000))
    return; // does not have load_* fields, cannot proceed
  if (hdr->load_addr > hdr->header_addr)
    return; // invalid;
  if (hdr->load_end_addr < hdr->load_addr)
    return; // no idea how much to load

  //readseg((uchar*) hdr->load_addr,
   // (hdr->load_end_addr - hdr->load_addr),
   // (n * 4) - (hdr->header_addr - hdr->load_addr));

	memcpy(hdr->load_addr,0x10000+(n * 4) - (hdr->header_addr - hdr->load_addr),(hdr->load_end_addr - hdr->load_addr));
  // If too much RAM was allocated, then zero redundant RAM;
  if (hdr->bss_end_addr > hdr->load_end_addr)
    stosb((void*) hdr->load_end_addr, 0,
      hdr->bss_end_addr - hdr->load_end_addr);

  // Call the entry point from the multiboot header.
  // Does not return!

#if 0	
	for(; i < 140;i+=2)
	{
		*(base + i)  = 'b';
	}	*(base+i)= (unsigned int)hdr->load_addr;
	i+=2;
	*(base+i) = 22;
#endif
	//while(1); 
 entry = (void(*)(void))(hdr->entry_addr);
  entry();
}
#if 0
static void
waitdisk(void)
{
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    ;
}

// Read a single sector at offset into dst.
static void
readsect(void *dst, uint offset)
{
  // Issue command.
  waitdisk();
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
  insl(0x1F0, dst, SECTSIZE/4);
}

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
static void
readseg(uchar* pa, uint count, uint offset)
{
  uchar* epa;

  epa = pa + count;

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    readsect(pa, offset);
}

#endif
