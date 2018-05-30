
out/kernel.elf:     file format elf64-x86-64


Disassembly of section .text:

ffffffff80100000 <begin>:
ffffffff80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%rax),%dh
ffffffff80100006:	01 00                	add    %eax,(%rax)
ffffffff80100008:	fe 4f 51             	decb   0x51(%rdi)
ffffffff8010000b:	e4 00                	in     $0x0,%al
ffffffff8010000d:	00 10                	add    %dl,(%rax)
ffffffff8010000f:	00 00                	add    %al,(%rax)
ffffffff80100011:	00 10                	add    %dl,(%rax)
ffffffff80100013:	00 00                	add    %al,(%rax)
ffffffff80100015:	c0 10 00             	rclb   $0x0,(%rax)
ffffffff80100018:	00 80 11 00 20 00    	add    %al,0x200011(%rax)
ffffffff8010001e:	10 00                	adc    %al,(%rax)

ffffffff80100020 <mboot_entry>:
  .long mboot_entry_addr

mboot_entry:

# zero 4 pages for our bootstrap page tables
  xor %eax, %eax
ffffffff80100020:	31 c0                	xor    %eax,%eax
  mov $0x1000, %edi
ffffffff80100022:	bf 00 10 00 00       	mov    $0x1000,%edi
  mov $0x5000, %ecx
ffffffff80100027:	b9 00 50 00 00       	mov    $0x5000,%ecx
  rep stosb
ffffffff8010002c:	f3 aa                	rep stos %al,%es:(%rdi)

# P4ML[0] -> 0x2000 (PDPT-A)
  mov $(0x2000 | 3), %eax
ffffffff8010002e:	b8 03 20 00 00       	mov    $0x2003,%eax
  mov %eax, 0x1000
ffffffff80100033:	a3 00 10 00 00 b8 03 	movabs %eax,0x3003b800001000
ffffffff8010003a:	30 00 

# P4ML[511] -> 0x3000 (PDPT-B)
  mov $(0x3000 | 3), %eax
ffffffff8010003c:	00 a3 f8 1f 00 00    	add    %ah,0x1ff8(%rbx)
  mov %eax, 0x1FF8

# PDPT-A[0] -> 0x4000 (PD)
  mov $(0x4000 | 3), %eax
ffffffff80100042:	b8 03 40 00 00       	mov    $0x4003,%eax
  mov %eax, 0x2000
ffffffff80100047:	a3 00 20 00 00 b8 03 	movabs %eax,0x4003b800002000
ffffffff8010004e:	40 00 

# PDPT-B[510] -> 0x4000 (PD)
  mov $(0x4000 | 3), %eax
ffffffff80100050:	00 a3 f0 3f 00 00    	add    %ah,0x3ff0(%rbx)
  mov %eax, 0x3FF0

# PD[0..511] -> 0..1022MB
  mov $0x83, %eax
ffffffff80100056:	b8 83 00 00 00       	mov    $0x83,%eax
  mov $0x4000, %ebx
ffffffff8010005b:	bb 00 40 00 00       	mov    $0x4000,%ebx
  mov $512, %ecx
ffffffff80100060:	b9 00 02 00 00       	mov    $0x200,%ecx

ffffffff80100065 <ptbl_loop>:
ptbl_loop:
  mov %eax, (%ebx)
ffffffff80100065:	89 03                	mov    %eax,(%rbx)
  add $0x200000, %eax
ffffffff80100067:	05 00 00 20 00       	add    $0x200000,%eax
  add $0x8, %ebx
ffffffff8010006c:	83 c3 08             	add    $0x8,%ebx
  dec %ecx
ffffffff8010006f:	49 75 f3             	rex.WB jne ffffffff80100065 <ptbl_loop>

# Clear ebx for initial processor boot.
# When secondary processors boot, they'll call through
# entry32mp (from entryother), but with a nonzero ebx.
# We'll reuse these bootstrap pagetables and GDT.
  xor %ebx, %ebx
ffffffff80100072:	31 db                	xor    %ebx,%ebx

ffffffff80100074 <entry32mp>:

.global entry32mp
entry32mp:
# CR3 -> 0x1000 (P4ML)
  mov $0x1000, %eax
ffffffff80100074:	b8 00 10 00 00       	mov    $0x1000,%eax
  mov %eax, %cr3
ffffffff80100079:	0f 22 d8             	mov    %rax,%cr3

  lgdt (gdtr64 - mboot_header + mboot_load_addr)
ffffffff8010007c:	0f 01 15 b0 00 10 00 	lgdt   0x1000b0(%rip)        # ffffffff80200133 <end+0xe8133>

# Enable PAE - CR4.PAE=1
  mov %cr4, %eax
ffffffff80100083:	0f 20 e0             	mov    %cr4,%rax
  bts $5, %eax
ffffffff80100086:	0f ba e8 05          	bts    $0x5,%eax
  mov %eax, %cr4
ffffffff8010008a:	0f 22 e0             	mov    %rax,%cr4

# enable long mode - EFER.LME=1
  mov $0xc0000080, %ecx
ffffffff8010008d:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  rdmsr
ffffffff80100092:	0f 32                	rdmsr  
  bts $8, %eax
ffffffff80100094:	0f ba e8 08          	bts    $0x8,%eax
  wrmsr
ffffffff80100098:	0f 30                	wrmsr  

# enable paging
  mov %cr0, %eax
ffffffff8010009a:	0f 20 c0             	mov    %cr0,%rax
  bts $31, %eax
ffffffff8010009d:	0f ba e8 1f          	bts    $0x1f,%eax
  mov %eax, %cr0
ffffffff801000a1:	0f 22 c0             	mov    %rax,%cr0

# shift to 64bit segment
  ljmp $8,$(entry64low - mboot_header + mboot_load_addr)
ffffffff801000a4:	ea                   	(bad)  
ffffffff801000a5:	e0 00                	loopne ffffffff801000a7 <entry32mp+0x33>
ffffffff801000a7:	10 00                	adc    %al,(%rax)
ffffffff801000a9:	08 00                	or     %al,(%rax)
ffffffff801000ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

ffffffff801000b0 <gdtr64>:
ffffffff801000b0:	17                   	(bad)  
ffffffff801000b1:	00 c0                	add    %al,%al
ffffffff801000b3:	00 10                	add    %dl,(%rax)
ffffffff801000b5:	00 00                	add    %al,(%rax)
ffffffff801000b7:	00 00                	add    %al,(%rax)
ffffffff801000b9:	00 66 0f             	add    %ah,0xf(%rsi)
ffffffff801000bc:	1f                   	(bad)  
ffffffff801000bd:	44 00 00             	add    %r8b,(%rax)

ffffffff801000c0 <gdt64_begin>:
	...
ffffffff801000cc:	00 98 20 00 00 00    	add    %bl,0x20(%rax)
ffffffff801000d2:	00 00                	add    %al,(%rax)
ffffffff801000d4:	00                   	.byte 0x0
ffffffff801000d5:	90                   	nop
	...

ffffffff801000d8 <gdt64_end>:
ffffffff801000d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
ffffffff801000df:	00 

ffffffff801000e0 <entry64low>:
gdt64_end:

.align 16
.code64
entry64low:
  movq $entry64high, %rax
ffffffff801000e0:	48 c7 c0 e9 00 10 80 	mov    $0xffffffff801000e9,%rax
  jmp *%rax
ffffffff801000e7:	ff e0                	jmpq   *%rax

ffffffff801000e9 <_start>:
.global _start
_start:
entry64high:

# ensure data segment registers are sane
  xor %rax, %rax
ffffffff801000e9:	48 31 c0             	xor    %rax,%rax
  mov %ax, %ss
ffffffff801000ec:	8e d0                	mov    %eax,%ss
  mov %ax, %ds
ffffffff801000ee:	8e d8                	mov    %eax,%ds
  mov %ax, %es
ffffffff801000f0:	8e c0                	mov    %eax,%es
  mov %ax, %fs
ffffffff801000f2:	8e e0                	mov    %eax,%fs
  mov %ax, %gs
ffffffff801000f4:	8e e8                	mov    %eax,%gs

# check to see if we're booting a secondary core
  test %ebx, %ebx
ffffffff801000f6:	85 db                	test   %ebx,%ebx
  jnz entry64mp
ffffffff801000f8:	75 11                	jne    ffffffff8010010b <entry64mp>

# setup initial stack
  mov $0xFFFFFFFF80010000, %rax
ffffffff801000fa:	48 c7 c0 00 00 01 80 	mov    $0xffffffff80010000,%rax
  mov %rax, %rsp
ffffffff80100101:	48 89 c4             	mov    %rax,%rsp

# enter main()
  jmp main
ffffffff80100104:	e9 11 49 00 00       	jmpq   ffffffff80104a1a <main>

ffffffff80100109 <__deadloop>:

.global __deadloop
__deadloop:
# we should never return here...
  jmp .
ffffffff80100109:	eb fe                	jmp    ffffffff80100109 <__deadloop>

ffffffff8010010b <entry64mp>:

entry64mp:
# obtain kstack from data block before entryother
  mov $0x7000, %rax
ffffffff8010010b:	48 c7 c0 00 70 00 00 	mov    $0x7000,%rax
  mov -16(%rax), %rsp
ffffffff80100112:	48 8b 60 f0          	mov    -0x10(%rax),%rsp
  jmp mpenter
ffffffff80100116:	e9 bb 49 00 00       	jmpq   ffffffff80104ad6 <mpenter>

ffffffff8010011b <wrmsr>:

.global wrmsr
wrmsr:
  mov %rdi, %rcx     # arg0 -> msrnum
ffffffff8010011b:	48 89 f9             	mov    %rdi,%rcx
  mov %rsi, %rax     # val.low -> eax
ffffffff8010011e:	48 89 f0             	mov    %rsi,%rax
  shr $32, %rsi
ffffffff80100121:	48 c1 ee 20          	shr    $0x20,%rsi
  mov %rsi, %rdx     # val.high -> edx
ffffffff80100125:	48 89 f2             	mov    %rsi,%rdx
  wrmsr
ffffffff80100128:	0f 30                	wrmsr  
  retq
ffffffff8010012a:	c3                   	retq   

ffffffff8010012b <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
ffffffff8010012b:	55                   	push   %rbp
ffffffff8010012c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010012f:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
ffffffff80100133:	48 c7 c6 f0 a4 10 80 	mov    $0xffffffff8010a4f0,%rsi
ffffffff8010013a:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff80100141:	e8 28 68 00 00       	callq  ffffffff8010696e <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
ffffffff80100146:	48 c7 05 d7 ff 00 00 	movq   $0xffffffff80110118,0xffd7(%rip)        # ffffffff80110128 <bcache+0x4128>
ffffffff8010014d:	18 01 11 80 
  bcache.head.next = &bcache.head;
ffffffff80100151:	48 c7 05 d4 ff 00 00 	movq   $0xffffffff80110118,0xffd4(%rip)        # ffffffff80110130 <bcache+0x4130>
ffffffff80100158:	18 01 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffffffff8010015c:	48 c7 45 f8 68 c0 10 	movq   $0xffffffff8010c068,-0x8(%rbp)
ffffffff80100163:	80 
ffffffff80100164:	eb 48                	jmp    ffffffff801001ae <binit+0x83>
    b->next = bcache.head.next;
ffffffff80100166:	48 8b 15 c3 ff 00 00 	mov    0xffc3(%rip),%rdx        # ffffffff80110130 <bcache+0x4130>
ffffffff8010016d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100171:	48 89 50 18          	mov    %rdx,0x18(%rax)
    b->prev = &bcache.head;
ffffffff80100175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100179:	48 c7 40 10 18 01 11 	movq   $0xffffffff80110118,0x10(%rax)
ffffffff80100180:	80 
    b->dev = -1;
ffffffff80100181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100185:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%rax)
    bcache.head.next->prev = b;
ffffffff8010018c:	48 8b 05 9d ff 00 00 	mov    0xff9d(%rip),%rax        # ffffffff80110130 <bcache+0x4130>
ffffffff80100193:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80100197:	48 89 50 10          	mov    %rdx,0x10(%rax)
    bcache.head.next = b;
ffffffff8010019b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010019f:	48 89 05 8a ff 00 00 	mov    %rax,0xff8a(%rip)        # ffffffff80110130 <bcache+0x4130>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
ffffffff801001a6:	48 81 45 f8 28 02 00 	addq   $0x228,-0x8(%rbp)
ffffffff801001ad:	00 
ffffffff801001ae:	48 c7 c0 18 01 11 80 	mov    $0xffffffff80110118,%rax
ffffffff801001b5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffffffff801001b9:	72 ab                	jb     ffffffff80100166 <binit+0x3b>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
ffffffff801001bb:	90                   	nop
ffffffff801001bc:	c9                   	leaveq 
ffffffff801001bd:	c3                   	retq   

ffffffff801001be <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
ffffffff801001be:	55                   	push   %rbp
ffffffff801001bf:	48 89 e5             	mov    %rsp,%rbp
ffffffff801001c2:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801001c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff801001c9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  acquire(&bcache.lock);
ffffffff801001cc:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff801001d3:	e8 cb 67 00 00       	callq  ffffffff801069a3 <acquire>

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffffffff801001d8:	48 8b 05 51 ff 00 00 	mov    0xff51(%rip),%rax        # ffffffff80110130 <bcache+0x4130>
ffffffff801001df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff801001e3:	eb 6c                	jmp    ffffffff80100251 <bget+0x93>
    if(b->dev == dev && b->blockno == blockno){
ffffffff801001e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801001e9:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff801001ec:	3b 45 ec             	cmp    -0x14(%rbp),%eax
ffffffff801001ef:	75 54                	jne    ffffffff80100245 <bget+0x87>
ffffffff801001f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801001f5:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff801001f8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
ffffffff801001fb:	75 48                	jne    ffffffff80100245 <bget+0x87>
      if(!(b->flags & B_BUSY)){
ffffffff801001fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100201:	8b 00                	mov    (%rax),%eax
ffffffff80100203:	83 e0 01             	and    $0x1,%eax
ffffffff80100206:	85 c0                	test   %eax,%eax
ffffffff80100208:	75 26                	jne    ffffffff80100230 <bget+0x72>
        b->flags |= B_BUSY;
ffffffff8010020a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010020e:	8b 00                	mov    (%rax),%eax
ffffffff80100210:	83 c8 01             	or     $0x1,%eax
ffffffff80100213:	89 c2                	mov    %eax,%edx
ffffffff80100215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100219:	89 10                	mov    %edx,(%rax)
        release(&bcache.lock);
ffffffff8010021b:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff80100222:	e8 53 68 00 00       	callq  ffffffff80106a7a <release>
        return b;
ffffffff80100227:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010022b:	e9 a4 00 00 00       	jmpq   ffffffff801002d4 <bget+0x116>
      }
      sleep(b, &bcache.lock);
ffffffff80100230:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100234:	48 c7 c6 00 c0 10 80 	mov    $0xffffffff8010c000,%rsi
ffffffff8010023b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010023e:	e8 e3 63 00 00       	callq  ffffffff80106626 <sleep>
      goto loop;
ffffffff80100243:	eb 93                	jmp    ffffffff801001d8 <bget+0x1a>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
ffffffff80100245:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100249:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff8010024d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80100251:	48 81 7d f8 18 01 11 	cmpq   $0xffffffff80110118,-0x8(%rbp)
ffffffff80100258:	80 
ffffffff80100259:	75 8a                	jne    ffffffff801001e5 <bget+0x27>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffffffff8010025b:	48 8b 05 c6 fe 00 00 	mov    0xfec6(%rip),%rax        # ffffffff80110128 <bcache+0x4128>
ffffffff80100262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80100266:	eb 56                	jmp    ffffffff801002be <bget+0x100>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
ffffffff80100268:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010026c:	8b 00                	mov    (%rax),%eax
ffffffff8010026e:	83 e0 01             	and    $0x1,%eax
ffffffff80100271:	85 c0                	test   %eax,%eax
ffffffff80100273:	75 3d                	jne    ffffffff801002b2 <bget+0xf4>
ffffffff80100275:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100279:	8b 00                	mov    (%rax),%eax
ffffffff8010027b:	83 e0 04             	and    $0x4,%eax
ffffffff8010027e:	85 c0                	test   %eax,%eax
ffffffff80100280:	75 30                	jne    ffffffff801002b2 <bget+0xf4>
      b->dev = dev;
ffffffff80100282:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100286:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80100289:	89 50 04             	mov    %edx,0x4(%rax)
      b->blockno = blockno;
ffffffff8010028c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100290:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff80100293:	89 50 08             	mov    %edx,0x8(%rax)
      b->flags = B_BUSY;
ffffffff80100296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010029a:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
      release(&bcache.lock);
ffffffff801002a0:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff801002a7:	e8 ce 67 00 00       	callq  ffffffff80106a7a <release>
      return b;
ffffffff801002ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801002b0:	eb 22                	jmp    ffffffff801002d4 <bget+0x116>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
ffffffff801002b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801002b6:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff801002ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff801002be:	48 81 7d f8 18 01 11 	cmpq   $0xffffffff80110118,-0x8(%rbp)
ffffffff801002c5:	80 
ffffffff801002c6:	75 a0                	jne    ffffffff80100268 <bget+0xaa>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
ffffffff801002c8:	48 c7 c7 f7 a4 10 80 	mov    $0xffffffff8010a4f7,%rdi
ffffffff801002cf:	e8 2b 06 00 00       	callq  ffffffff801008ff <panic>
}
ffffffff801002d4:	c9                   	leaveq 
ffffffff801002d5:	c3                   	retq   

ffffffff801002d6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
ffffffff801002d6:	55                   	push   %rbp
ffffffff801002d7:	48 89 e5             	mov    %rsp,%rbp
ffffffff801002da:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801002de:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff801002e1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *b;

  b = bget(dev, blockno);
ffffffff801002e4:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801002e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801002ea:	89 d6                	mov    %edx,%esi
ffffffff801002ec:	89 c7                	mov    %eax,%edi
ffffffff801002ee:	e8 cb fe ff ff       	callq  ffffffff801001be <bget>
ffffffff801002f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(!(b->flags & B_VALID)) {
ffffffff801002f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801002fb:	8b 00                	mov    (%rax),%eax
ffffffff801002fd:	83 e0 02             	and    $0x2,%eax
ffffffff80100300:	85 c0                	test   %eax,%eax
ffffffff80100302:	75 0c                	jne    ffffffff80100310 <bread+0x3a>
    iderw(b);
ffffffff80100304:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100308:	48 89 c7             	mov    %rax,%rdi
ffffffff8010030b:	e8 3a 36 00 00       	callq  ffffffff8010394a <iderw>
  }
  return b;
ffffffff80100310:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80100314:	c9                   	leaveq 
ffffffff80100315:	c3                   	retq   

ffffffff80100316 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
ffffffff80100316:	55                   	push   %rbp
ffffffff80100317:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010031a:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff8010031e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if((b->flags & B_BUSY) == 0)
ffffffff80100322:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100326:	8b 00                	mov    (%rax),%eax
ffffffff80100328:	83 e0 01             	and    $0x1,%eax
ffffffff8010032b:	85 c0                	test   %eax,%eax
ffffffff8010032d:	75 0c                	jne    ffffffff8010033b <bwrite+0x25>
    panic("bwrite");
ffffffff8010032f:	48 c7 c7 08 a5 10 80 	mov    $0xffffffff8010a508,%rdi
ffffffff80100336:	e8 c4 05 00 00       	callq  ffffffff801008ff <panic>
  b->flags |= B_DIRTY;
ffffffff8010033b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010033f:	8b 00                	mov    (%rax),%eax
ffffffff80100341:	83 c8 04             	or     $0x4,%eax
ffffffff80100344:	89 c2                	mov    %eax,%edx
ffffffff80100346:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010034a:	89 10                	mov    %edx,(%rax)
  iderw(b);
ffffffff8010034c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100350:	48 89 c7             	mov    %rax,%rdi
ffffffff80100353:	e8 f2 35 00 00       	callq  ffffffff8010394a <iderw>
}
ffffffff80100358:	90                   	nop
ffffffff80100359:	c9                   	leaveq 
ffffffff8010035a:	c3                   	retq   

ffffffff8010035b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
ffffffff8010035b:	55                   	push   %rbp
ffffffff8010035c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010035f:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80100363:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if((b->flags & B_BUSY) == 0)
ffffffff80100367:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010036b:	8b 00                	mov    (%rax),%eax
ffffffff8010036d:	83 e0 01             	and    $0x1,%eax
ffffffff80100370:	85 c0                	test   %eax,%eax
ffffffff80100372:	75 0c                	jne    ffffffff80100380 <brelse+0x25>
    panic("brelse");
ffffffff80100374:	48 c7 c7 0f a5 10 80 	mov    $0xffffffff8010a50f,%rdi
ffffffff8010037b:	e8 7f 05 00 00       	callq  ffffffff801008ff <panic>

  acquire(&bcache.lock);
ffffffff80100380:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff80100387:	e8 17 66 00 00       	callq  ffffffff801069a3 <acquire>

  b->next->prev = b->prev;
ffffffff8010038c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80100390:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff80100394:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80100398:	48 8b 52 10          	mov    0x10(%rdx),%rdx
ffffffff8010039c:	48 89 50 10          	mov    %rdx,0x10(%rax)
  b->prev->next = b->next;
ffffffff801003a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003a4:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff801003a8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801003ac:	48 8b 52 18          	mov    0x18(%rdx),%rdx
ffffffff801003b0:	48 89 50 18          	mov    %rdx,0x18(%rax)
  b->next = bcache.head.next;
ffffffff801003b4:	48 8b 15 75 fd 00 00 	mov    0xfd75(%rip),%rdx        # ffffffff80110130 <bcache+0x4130>
ffffffff801003bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003bf:	48 89 50 18          	mov    %rdx,0x18(%rax)
  b->prev = &bcache.head;
ffffffff801003c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003c7:	48 c7 40 10 18 01 11 	movq   $0xffffffff80110118,0x10(%rax)
ffffffff801003ce:	80 
  bcache.head.next->prev = b;
ffffffff801003cf:	48 8b 05 5a fd 00 00 	mov    0xfd5a(%rip),%rax        # ffffffff80110130 <bcache+0x4130>
ffffffff801003d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801003da:	48 89 50 10          	mov    %rdx,0x10(%rax)
  bcache.head.next = b;
ffffffff801003de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003e2:	48 89 05 47 fd 00 00 	mov    %rax,0xfd47(%rip)        # ffffffff80110130 <bcache+0x4130>

  b->flags &= ~B_BUSY;
ffffffff801003e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003ed:	8b 00                	mov    (%rax),%eax
ffffffff801003ef:	83 e0 fe             	and    $0xfffffffe,%eax
ffffffff801003f2:	89 c2                	mov    %eax,%edx
ffffffff801003f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003f8:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffffffff801003fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801003fe:	48 89 c7             	mov    %rax,%rdi
ffffffff80100401:	e8 33 63 00 00       	callq  ffffffff80106739 <wakeup>

  release(&bcache.lock);
ffffffff80100406:	48 c7 c7 00 c0 10 80 	mov    $0xffffffff8010c000,%rdi
ffffffff8010040d:	e8 68 66 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80100412:	90                   	nop
ffffffff80100413:	c9                   	leaveq 
ffffffff80100414:	c3                   	retq   

ffffffff80100415 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff80100415:	55                   	push   %rbp
ffffffff80100416:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100419:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff8010041d:	89 f8                	mov    %edi,%eax
ffffffff8010041f:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff80100423:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff80100427:	89 c2                	mov    %eax,%edx
ffffffff80100429:	ec                   	in     (%dx),%al
ffffffff8010042a:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff8010042d:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff80100431:	c9                   	leaveq 
ffffffff80100432:	c3                   	retq   

ffffffff80100433 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff80100433:	55                   	push   %rbp
ffffffff80100434:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100437:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff8010043b:	89 fa                	mov    %edi,%edx
ffffffff8010043d:	89 f0                	mov    %esi,%eax
ffffffff8010043f:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff80100443:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff80100446:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff8010044a:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff8010044e:	ee                   	out    %al,(%dx)
}
ffffffff8010044f:	90                   	nop
ffffffff80100450:	c9                   	leaveq 
ffffffff80100451:	c3                   	retq   

ffffffff80100452 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffffffff80100452:	55                   	push   %rbp
ffffffff80100453:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100456:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010045a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff8010045e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  volatile ushort pd[5];

  pd[0] = size-1;
ffffffff80100461:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80100464:	83 e8 01             	sub    $0x1,%eax
ffffffff80100467:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[1] = (uintp)p;
ffffffff8010046b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010046f:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[2] = (uintp)p >> 16;
ffffffff80100473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100477:	48 c1 e8 10          	shr    $0x10,%rax
ffffffff8010047b:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
#if X64
  pd[3] = (uintp)p >> 32;
ffffffff8010047f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100483:	48 c1 e8 20          	shr    $0x20,%rax
ffffffff80100487:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  pd[4] = (uintp)p >> 48;
ffffffff8010048b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010048f:	48 c1 e8 30          	shr    $0x30,%rax
ffffffff80100493:	66 89 45 f8          	mov    %ax,-0x8(%rbp)
#endif
  asm volatile("lidt (%0)" : : "r" (pd));
ffffffff80100497:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff8010049b:	0f 01 18             	lidt   (%rax)
}
ffffffff8010049e:	90                   	nop
ffffffff8010049f:	c9                   	leaveq 
ffffffff801004a0:	c3                   	retq   

ffffffff801004a1 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
ffffffff801004a1:	55                   	push   %rbp
ffffffff801004a2:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffffffff801004a5:	fa                   	cli    
}
ffffffff801004a6:	90                   	nop
ffffffff801004a7:	5d                   	pop    %rbp
ffffffff801004a8:	c3                   	retq   

ffffffff801004a9 <printptr>:
} cons;

static char digits[] = "0123456789abcdef";

static void
printptr(uintp x) {
ffffffff801004a9:	55                   	push   %rbp
ffffffff801004aa:	48 89 e5             	mov    %rsp,%rbp
ffffffff801004ad:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801004b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uintp) * 2); i++, x <<= 4)
ffffffff801004b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801004bc:	eb 22                	jmp    ffffffff801004e0 <printptr+0x37>
    consputc(digits[x >> (sizeof(uintp) * 8 - 4)]);
ffffffff801004be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801004c2:	48 c1 e8 3c          	shr    $0x3c,%rax
ffffffff801004c6:	0f b6 80 00 b0 10 80 	movzbl -0x7fef5000(%rax),%eax
ffffffff801004cd:	0f be c0             	movsbl %al,%eax
ffffffff801004d0:	89 c7                	mov    %eax,%edi
ffffffff801004d2:	e8 53 06 00 00       	callq  ffffffff80100b2a <consputc>
static char digits[] = "0123456789abcdef";

static void
printptr(uintp x) {
  int i;
  for (i = 0; i < (sizeof(uintp) * 2); i++, x <<= 4)
ffffffff801004d7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff801004db:	48 c1 65 e8 04       	shlq   $0x4,-0x18(%rbp)
ffffffff801004e0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801004e3:	83 f8 0f             	cmp    $0xf,%eax
ffffffff801004e6:	76 d6                	jbe    ffffffff801004be <printptr+0x15>
    consputc(digits[x >> (sizeof(uintp) * 8 - 4)]);
}
ffffffff801004e8:	90                   	nop
ffffffff801004e9:	c9                   	leaveq 
ffffffff801004ea:	c3                   	retq   

ffffffff801004eb <printint>:

static void
printint(int xx, int base, int sign)
{
ffffffff801004eb:	55                   	push   %rbp
ffffffff801004ec:	48 89 e5             	mov    %rsp,%rbp
ffffffff801004ef:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff801004f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffffffff801004f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
ffffffff801004f9:	89 55 d4             	mov    %edx,-0x2c(%rbp)
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
ffffffff801004fc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
ffffffff80100500:	74 1c                	je     ffffffff8010051e <printint+0x33>
ffffffff80100502:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100505:	c1 e8 1f             	shr    $0x1f,%eax
ffffffff80100508:	0f b6 c0             	movzbl %al,%eax
ffffffff8010050b:	89 45 d4             	mov    %eax,-0x2c(%rbp)
ffffffff8010050e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
ffffffff80100512:	74 0a                	je     ffffffff8010051e <printint+0x33>
    x = -xx;
ffffffff80100514:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100517:	f7 d8                	neg    %eax
ffffffff80100519:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffffffff8010051c:	eb 06                	jmp    ffffffff80100524 <printint+0x39>
  else
    x = xx;
ffffffff8010051e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100521:	89 45 f8             	mov    %eax,-0x8(%rbp)

  i = 0;
ffffffff80100524:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  do{
    buf[i++] = digits[x % base];
ffffffff8010052b:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffffffff8010052e:	8d 41 01             	lea    0x1(%rcx),%eax
ffffffff80100531:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80100534:	8b 75 d8             	mov    -0x28(%rbp),%esi
ffffffff80100537:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff8010053a:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff8010053f:	f7 f6                	div    %esi
ffffffff80100541:	89 d0                	mov    %edx,%eax
ffffffff80100543:	89 c0                	mov    %eax,%eax
ffffffff80100545:	0f b6 90 00 b0 10 80 	movzbl -0x7fef5000(%rax),%edx
ffffffff8010054c:	48 63 c1             	movslq %ecx,%rax
ffffffff8010054f:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
  }while((x /= base) != 0);
ffffffff80100553:	8b 7d d8             	mov    -0x28(%rbp),%edi
ffffffff80100556:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80100559:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff8010055e:	f7 f7                	div    %edi
ffffffff80100560:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffffffff80100563:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffffffff80100567:	75 c2                	jne    ffffffff8010052b <printint+0x40>

  if(sign)
ffffffff80100569:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
ffffffff8010056d:	74 26                	je     ffffffff80100595 <printint+0xaa>
    buf[i++] = '-';
ffffffff8010056f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100572:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80100575:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffffffff80100578:	48 98                	cltq   
ffffffff8010057a:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while(--i >= 0)
ffffffff8010057f:	eb 14                	jmp    ffffffff80100595 <printint+0xaa>
    consputc(buf[i]);
ffffffff80100581:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100584:	48 98                	cltq   
ffffffff80100586:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
ffffffff8010058b:	0f be c0             	movsbl %al,%eax
ffffffff8010058e:	89 c7                	mov    %eax,%edi
ffffffff80100590:	e8 95 05 00 00       	callq  ffffffff80100b2a <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
ffffffff80100595:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffffffff80100599:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff8010059d:	79 e2                	jns    ffffffff80100581 <printint+0x96>
    consputc(buf[i]);
}
ffffffff8010059f:	90                   	nop
ffffffff801005a0:	c9                   	leaveq 
ffffffff801005a1:	c3                   	retq   

ffffffff801005a2 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
ffffffff801005a2:	55                   	push   %rbp
ffffffff801005a3:	48 89 e5             	mov    %rsp,%rbp
ffffffff801005a6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
ffffffff801005ad:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
ffffffff801005b4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
ffffffff801005bb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
ffffffff801005c2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
ffffffff801005c9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
ffffffff801005d0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
ffffffff801005d7:	84 c0                	test   %al,%al
ffffffff801005d9:	74 20                	je     ffffffff801005fb <cprintf+0x59>
ffffffff801005db:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
ffffffff801005df:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
ffffffff801005e3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
ffffffff801005e7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
ffffffff801005eb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
ffffffff801005ef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
ffffffff801005f3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
ffffffff801005f7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c, locking;
  char *s;

  va_start(ap, fmt);
ffffffff801005fb:	c7 85 20 ff ff ff 08 	movl   $0x8,-0xe0(%rbp)
ffffffff80100602:	00 00 00 
ffffffff80100605:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
ffffffff8010060c:	00 00 00 
ffffffff8010060f:	48 8d 45 10          	lea    0x10(%rbp),%rax
ffffffff80100613:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
ffffffff8010061a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
ffffffff80100621:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)

  locking = cons.locking;
ffffffff80100628:	8b 05 7a fe 00 00    	mov    0xfe7a(%rip),%eax        # ffffffff801104a8 <cons+0x68>
ffffffff8010062e:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
  if(locking)
ffffffff80100634:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffffffff8010063b:	74 0c                	je     ffffffff80100649 <cprintf+0xa7>
    acquire(&cons.lock);
ffffffff8010063d:	48 c7 c7 40 04 11 80 	mov    $0xffffffff80110440,%rdi
ffffffff80100644:	e8 5a 63 00 00       	callq  ffffffff801069a3 <acquire>

  if (fmt == 0)
ffffffff80100649:	48 83 bd 18 ff ff ff 	cmpq   $0x0,-0xe8(%rbp)
ffffffff80100650:	00 
ffffffff80100651:	75 0c                	jne    ffffffff8010065f <cprintf+0xbd>
    panic("null fmt");
ffffffff80100653:	48 c7 c7 16 a5 10 80 	mov    $0xffffffff8010a516,%rdi
ffffffff8010065a:	e8 a0 02 00 00       	callq  ffffffff801008ff <panic>

  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
ffffffff8010065f:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
ffffffff80100666:	00 00 00 
ffffffff80100669:	e9 45 02 00 00       	jmpq   ffffffff801008b3 <cprintf+0x311>
    if(c != '%'){
ffffffff8010066e:	83 bd 38 ff ff ff 25 	cmpl   $0x25,-0xc8(%rbp)
ffffffff80100675:	74 12                	je     ffffffff80100689 <cprintf+0xe7>
      consputc(c);
ffffffff80100677:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffffffff8010067d:	89 c7                	mov    %eax,%edi
ffffffff8010067f:	e8 a6 04 00 00       	callq  ffffffff80100b2a <consputc>
      continue;
ffffffff80100684:	e9 23 02 00 00       	jmpq   ffffffff801008ac <cprintf+0x30a>
    }
    c = fmt[++i] & 0xff;
ffffffff80100689:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffffffff80100690:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffffffff80100696:	48 63 d0             	movslq %eax,%rdx
ffffffff80100699:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffffffff801006a0:	48 01 d0             	add    %rdx,%rax
ffffffff801006a3:	0f b6 00             	movzbl (%rax),%eax
ffffffff801006a6:	0f be c0             	movsbl %al,%eax
ffffffff801006a9:	25 ff 00 00 00       	and    $0xff,%eax
ffffffff801006ae:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
    if(c == 0)
ffffffff801006b4:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffffffff801006bb:	0f 84 25 02 00 00    	je     ffffffff801008e6 <cprintf+0x344>
      break;
    switch(c){
ffffffff801006c1:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffffffff801006c7:	83 f8 70             	cmp    $0x70,%eax
ffffffff801006ca:	0f 84 db 00 00 00    	je     ffffffff801007ab <cprintf+0x209>
ffffffff801006d0:	83 f8 70             	cmp    $0x70,%eax
ffffffff801006d3:	7f 13                	jg     ffffffff801006e8 <cprintf+0x146>
ffffffff801006d5:	83 f8 25             	cmp    $0x25,%eax
ffffffff801006d8:	0f 84 aa 01 00 00    	je     ffffffff80100888 <cprintf+0x2e6>
ffffffff801006de:	83 f8 64             	cmp    $0x64,%eax
ffffffff801006e1:	74 18                	je     ffffffff801006fb <cprintf+0x159>
ffffffff801006e3:	e9 ac 01 00 00       	jmpq   ffffffff80100894 <cprintf+0x2f2>
ffffffff801006e8:	83 f8 73             	cmp    $0x73,%eax
ffffffff801006eb:	0f 84 0a 01 00 00    	je     ffffffff801007fb <cprintf+0x259>
ffffffff801006f1:	83 f8 78             	cmp    $0x78,%eax
ffffffff801006f4:	74 5d                	je     ffffffff80100753 <cprintf+0x1b1>
ffffffff801006f6:	e9 99 01 00 00       	jmpq   ffffffff80100894 <cprintf+0x2f2>
    case 'd':
      printint(va_arg(ap, int), 10, 1);
ffffffff801006fb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffffffff80100701:	83 f8 30             	cmp    $0x30,%eax
ffffffff80100704:	73 23                	jae    ffffffff80100729 <cprintf+0x187>
ffffffff80100706:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffffffff8010070d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff80100713:	89 d2                	mov    %edx,%edx
ffffffff80100715:	48 01 d0             	add    %rdx,%rax
ffffffff80100718:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff8010071e:	83 c2 08             	add    $0x8,%edx
ffffffff80100721:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffffffff80100727:	eb 12                	jmp    ffffffff8010073b <cprintf+0x199>
ffffffff80100729:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffffffff80100730:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff80100734:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffffffff8010073b:	8b 00                	mov    (%rax),%eax
ffffffff8010073d:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff80100742:	be 0a 00 00 00       	mov    $0xa,%esi
ffffffff80100747:	89 c7                	mov    %eax,%edi
ffffffff80100749:	e8 9d fd ff ff       	callq  ffffffff801004eb <printint>
      break;
ffffffff8010074e:	e9 59 01 00 00       	jmpq   ffffffff801008ac <cprintf+0x30a>
    case 'x':
      printint(va_arg(ap, int), 16, 0);
ffffffff80100753:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffffffff80100759:	83 f8 30             	cmp    $0x30,%eax
ffffffff8010075c:	73 23                	jae    ffffffff80100781 <cprintf+0x1df>
ffffffff8010075e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffffffff80100765:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff8010076b:	89 d2                	mov    %edx,%edx
ffffffff8010076d:	48 01 d0             	add    %rdx,%rax
ffffffff80100770:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff80100776:	83 c2 08             	add    $0x8,%edx
ffffffff80100779:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffffffff8010077f:	eb 12                	jmp    ffffffff80100793 <cprintf+0x1f1>
ffffffff80100781:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffffffff80100788:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff8010078c:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffffffff80100793:	8b 00                	mov    (%rax),%eax
ffffffff80100795:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff8010079a:	be 10 00 00 00       	mov    $0x10,%esi
ffffffff8010079f:	89 c7                	mov    %eax,%edi
ffffffff801007a1:	e8 45 fd ff ff       	callq  ffffffff801004eb <printint>
      break;
ffffffff801007a6:	e9 01 01 00 00       	jmpq   ffffffff801008ac <cprintf+0x30a>
    case 'p':
      printptr(va_arg(ap, uintp));
ffffffff801007ab:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffffffff801007b1:	83 f8 30             	cmp    $0x30,%eax
ffffffff801007b4:	73 23                	jae    ffffffff801007d9 <cprintf+0x237>
ffffffff801007b6:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffffffff801007bd:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff801007c3:	89 d2                	mov    %edx,%edx
ffffffff801007c5:	48 01 d0             	add    %rdx,%rax
ffffffff801007c8:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff801007ce:	83 c2 08             	add    $0x8,%edx
ffffffff801007d1:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffffffff801007d7:	eb 12                	jmp    ffffffff801007eb <cprintf+0x249>
ffffffff801007d9:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffffffff801007e0:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff801007e4:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffffffff801007eb:	48 8b 00             	mov    (%rax),%rax
ffffffff801007ee:	48 89 c7             	mov    %rax,%rdi
ffffffff801007f1:	e8 b3 fc ff ff       	callq  ffffffff801004a9 <printptr>
      break;
ffffffff801007f6:	e9 b1 00 00 00       	jmpq   ffffffff801008ac <cprintf+0x30a>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
ffffffff801007fb:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
ffffffff80100801:	83 f8 30             	cmp    $0x30,%eax
ffffffff80100804:	73 23                	jae    ffffffff80100829 <cprintf+0x287>
ffffffff80100806:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
ffffffff8010080d:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff80100813:	89 d2                	mov    %edx,%edx
ffffffff80100815:	48 01 d0             	add    %rdx,%rax
ffffffff80100818:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
ffffffff8010081e:	83 c2 08             	add    $0x8,%edx
ffffffff80100821:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
ffffffff80100827:	eb 12                	jmp    ffffffff8010083b <cprintf+0x299>
ffffffff80100829:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
ffffffff80100830:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff80100834:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
ffffffff8010083b:	48 8b 00             	mov    (%rax),%rax
ffffffff8010083e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
ffffffff80100845:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
ffffffff8010084c:	00 
ffffffff8010084d:	75 29                	jne    ffffffff80100878 <cprintf+0x2d6>
        s = "(null)";
ffffffff8010084f:	48 c7 85 40 ff ff ff 	movq   $0xffffffff8010a51f,-0xc0(%rbp)
ffffffff80100856:	1f a5 10 80 
      for(; *s; s++)
ffffffff8010085a:	eb 1c                	jmp    ffffffff80100878 <cprintf+0x2d6>
        consputc(*s);
ffffffff8010085c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffffffff80100863:	0f b6 00             	movzbl (%rax),%eax
ffffffff80100866:	0f be c0             	movsbl %al,%eax
ffffffff80100869:	89 c7                	mov    %eax,%edi
ffffffff8010086b:	e8 ba 02 00 00       	callq  ffffffff80100b2a <consputc>
      printptr(va_arg(ap, uintp));
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
ffffffff80100870:	48 83 85 40 ff ff ff 	addq   $0x1,-0xc0(%rbp)
ffffffff80100877:	01 
ffffffff80100878:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
ffffffff8010087f:	0f b6 00             	movzbl (%rax),%eax
ffffffff80100882:	84 c0                	test   %al,%al
ffffffff80100884:	75 d6                	jne    ffffffff8010085c <cprintf+0x2ba>
        consputc(*s);
      break;
ffffffff80100886:	eb 24                	jmp    ffffffff801008ac <cprintf+0x30a>
    case '%':
      consputc('%');
ffffffff80100888:	bf 25 00 00 00       	mov    $0x25,%edi
ffffffff8010088d:	e8 98 02 00 00       	callq  ffffffff80100b2a <consputc>
      break;
ffffffff80100892:	eb 18                	jmp    ffffffff801008ac <cprintf+0x30a>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
ffffffff80100894:	bf 25 00 00 00       	mov    $0x25,%edi
ffffffff80100899:	e8 8c 02 00 00       	callq  ffffffff80100b2a <consputc>
      consputc(c);
ffffffff8010089e:	8b 85 38 ff ff ff    	mov    -0xc8(%rbp),%eax
ffffffff801008a4:	89 c7                	mov    %eax,%edi
ffffffff801008a6:	e8 7f 02 00 00       	callq  ffffffff80100b2a <consputc>
      break;
ffffffff801008ab:	90                   	nop
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
ffffffff801008ac:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
ffffffff801008b3:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
ffffffff801008b9:	48 63 d0             	movslq %eax,%rdx
ffffffff801008bc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
ffffffff801008c3:	48 01 d0             	add    %rdx,%rax
ffffffff801008c6:	0f b6 00             	movzbl (%rax),%eax
ffffffff801008c9:	0f be c0             	movsbl %al,%eax
ffffffff801008cc:	25 ff 00 00 00       	and    $0xff,%eax
ffffffff801008d1:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%rbp)
ffffffff801008d7:	83 bd 38 ff ff ff 00 	cmpl   $0x0,-0xc8(%rbp)
ffffffff801008de:	0f 85 8a fd ff ff    	jne    ffffffff8010066e <cprintf+0xcc>
ffffffff801008e4:	eb 01                	jmp    ffffffff801008e7 <cprintf+0x345>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
ffffffff801008e6:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
ffffffff801008e7:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
ffffffff801008ee:	74 0c                	je     ffffffff801008fc <cprintf+0x35a>
    release(&cons.lock);
ffffffff801008f0:	48 c7 c7 40 04 11 80 	mov    $0xffffffff80110440,%rdi
ffffffff801008f7:	e8 7e 61 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff801008fc:	90                   	nop
ffffffff801008fd:	c9                   	leaveq 
ffffffff801008fe:	c3                   	retq   

ffffffff801008ff <panic>:

void
panic(char *s)
{
ffffffff801008ff:	55                   	push   %rbp
ffffffff80100900:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100903:	48 83 ec 70          	sub    $0x70,%rsp
ffffffff80100907:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
  int i;
  uintp pcs[10];
  
  cli();
ffffffff8010090b:	e8 91 fb ff ff       	callq  ffffffff801004a1 <cli>
  cons.locking = 0;
ffffffff80100910:	c7 05 8e fb 00 00 00 	movl   $0x0,0xfb8e(%rip)        # ffffffff801104a8 <cons+0x68>
ffffffff80100917:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
ffffffff8010091a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80100921:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80100925:	0f b6 00             	movzbl (%rax),%eax
ffffffff80100928:	0f b6 c0             	movzbl %al,%eax
ffffffff8010092b:	89 c6                	mov    %eax,%esi
ffffffff8010092d:	48 c7 c7 26 a5 10 80 	mov    $0xffffffff8010a526,%rdi
ffffffff80100934:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100939:	e8 64 fc ff ff       	callq  ffffffff801005a2 <cprintf>
  cprintf(s);
ffffffff8010093e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
ffffffff80100942:	48 89 c7             	mov    %rax,%rdi
ffffffff80100945:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010094a:	e8 53 fc ff ff       	callq  ffffffff801005a2 <cprintf>
  cprintf("\n");
ffffffff8010094f:	48 c7 c7 35 a5 10 80 	mov    $0xffffffff8010a535,%rdi
ffffffff80100956:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010095b:	e8 42 fc ff ff       	callq  ffffffff801005a2 <cprintf>
  getcallerpcs(&s, pcs);
ffffffff80100960:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
ffffffff80100964:	48 8d 45 98          	lea    -0x68(%rbp),%rax
ffffffff80100968:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010096b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010096e:	e8 60 61 00 00       	callq  ffffffff80106ad3 <getcallerpcs>
  for(i=0; i<10; i++)
ffffffff80100973:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff8010097a:	eb 22                	jmp    ffffffff8010099e <panic+0x9f>
    cprintf(" %p", pcs[i]);
ffffffff8010097c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010097f:	48 98                	cltq   
ffffffff80100981:	48 8b 44 c5 a0       	mov    -0x60(%rbp,%rax,8),%rax
ffffffff80100986:	48 89 c6             	mov    %rax,%rsi
ffffffff80100989:	48 c7 c7 37 a5 10 80 	mov    $0xffffffff8010a537,%rdi
ffffffff80100990:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100995:	e8 08 fc ff ff       	callq  ffffffff801005a2 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
ffffffff8010099a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010099e:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff801009a2:	7e d8                	jle    ffffffff8010097c <panic+0x7d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
ffffffff801009a4:	c7 05 8a fa 00 00 01 	movl   $0x1,0xfa8a(%rip)        # ffffffff80110438 <panicked>
ffffffff801009ab:	00 00 00 
  for(;;)
    ;
ffffffff801009ae:	eb fe                	jmp    ffffffff801009ae <panic+0xaf>

ffffffff801009b0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
ffffffff801009b0:	55                   	push   %rbp
ffffffff801009b1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801009b4:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801009b8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
ffffffff801009bb:	be 0e 00 00 00       	mov    $0xe,%esi
ffffffff801009c0:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffffffff801009c5:	e8 69 fa ff ff       	callq  ffffffff80100433 <outb>
  pos = inb(CRTPORT+1) << 8;
ffffffff801009ca:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffffffff801009cf:	e8 41 fa ff ff       	callq  ffffffff80100415 <inb>
ffffffff801009d4:	0f b6 c0             	movzbl %al,%eax
ffffffff801009d7:	c1 e0 08             	shl    $0x8,%eax
ffffffff801009da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  outb(CRTPORT, 15);
ffffffff801009dd:	be 0f 00 00 00       	mov    $0xf,%esi
ffffffff801009e2:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffffffff801009e7:	e8 47 fa ff ff       	callq  ffffffff80100433 <outb>
  pos |= inb(CRTPORT+1);
ffffffff801009ec:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffffffff801009f1:	e8 1f fa ff ff       	callq  ffffffff80100415 <inb>
ffffffff801009f6:	0f b6 c0             	movzbl %al,%eax
ffffffff801009f9:	09 45 fc             	or     %eax,-0x4(%rbp)

  if(c == '\n')
ffffffff801009fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%rbp)
ffffffff80100a00:	75 30                	jne    ffffffff80100a32 <cgaputc+0x82>
    pos += 80 - pos%80;
ffffffff80100a02:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffffffff80100a05:	ba 67 66 66 66       	mov    $0x66666667,%edx
ffffffff80100a0a:	89 c8                	mov    %ecx,%eax
ffffffff80100a0c:	f7 ea                	imul   %edx
ffffffff80100a0e:	c1 fa 05             	sar    $0x5,%edx
ffffffff80100a11:	89 c8                	mov    %ecx,%eax
ffffffff80100a13:	c1 f8 1f             	sar    $0x1f,%eax
ffffffff80100a16:	29 c2                	sub    %eax,%edx
ffffffff80100a18:	89 d0                	mov    %edx,%eax
ffffffff80100a1a:	c1 e0 02             	shl    $0x2,%eax
ffffffff80100a1d:	01 d0                	add    %edx,%eax
ffffffff80100a1f:	c1 e0 04             	shl    $0x4,%eax
ffffffff80100a22:	29 c1                	sub    %eax,%ecx
ffffffff80100a24:	89 ca                	mov    %ecx,%edx
ffffffff80100a26:	b8 50 00 00 00       	mov    $0x50,%eax
ffffffff80100a2b:	29 d0                	sub    %edx,%eax
ffffffff80100a2d:	01 45 fc             	add    %eax,-0x4(%rbp)
ffffffff80100a30:	eb 39                	jmp    ffffffff80100a6b <cgaputc+0xbb>
  else if(c == BACKSPACE){
ffffffff80100a32:	81 7d ec 00 01 00 00 	cmpl   $0x100,-0x14(%rbp)
ffffffff80100a39:	75 0c                	jne    ffffffff80100a47 <cgaputc+0x97>
    if(pos > 0) --pos;
ffffffff80100a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80100a3f:	7e 2a                	jle    ffffffff80100a6b <cgaputc+0xbb>
ffffffff80100a41:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
ffffffff80100a45:	eb 24                	jmp    ffffffff80100a6b <cgaputc+0xbb>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
ffffffff80100a47:	48 8b 0d ca a5 00 00 	mov    0xa5ca(%rip),%rcx        # ffffffff8010b018 <crt>
ffffffff80100a4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100a51:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80100a54:	89 55 fc             	mov    %edx,-0x4(%rbp)
ffffffff80100a57:	48 98                	cltq   
ffffffff80100a59:	48 01 c0             	add    %rax,%rax
ffffffff80100a5c:	48 01 c8             	add    %rcx,%rax
ffffffff80100a5f:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80100a62:	0f b6 d2             	movzbl %dl,%edx
ffffffff80100a65:	80 ce 07             	or     $0x7,%dh
ffffffff80100a68:	66 89 10             	mov    %dx,(%rax)
  
  if((pos/80) >= 24){  // Scroll up.
ffffffff80100a6b:	81 7d fc 7f 07 00 00 	cmpl   $0x77f,-0x4(%rbp)
ffffffff80100a72:	7e 56                	jle    ffffffff80100aca <cgaputc+0x11a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
ffffffff80100a74:	48 8b 05 9d a5 00 00 	mov    0xa59d(%rip),%rax        # ffffffff8010b018 <crt>
ffffffff80100a7b:	48 8d 88 a0 00 00 00 	lea    0xa0(%rax),%rcx
ffffffff80100a82:	48 8b 05 8f a5 00 00 	mov    0xa58f(%rip),%rax        # ffffffff8010b018 <crt>
ffffffff80100a89:	ba 60 0e 00 00       	mov    $0xe60,%edx
ffffffff80100a8e:	48 89 ce             	mov    %rcx,%rsi
ffffffff80100a91:	48 89 c7             	mov    %rax,%rdi
ffffffff80100a94:	e8 68 63 00 00       	callq  ffffffff80106e01 <memmove>
    pos -= 80;
ffffffff80100a99:	83 6d fc 50          	subl   $0x50,-0x4(%rbp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
ffffffff80100a9d:	b8 80 07 00 00       	mov    $0x780,%eax
ffffffff80100aa2:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffffffff80100aa5:	48 98                	cltq   
ffffffff80100aa7:	8d 14 00             	lea    (%rax,%rax,1),%edx
ffffffff80100aaa:	48 8b 05 67 a5 00 00 	mov    0xa567(%rip),%rax        # ffffffff8010b018 <crt>
ffffffff80100ab1:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffffffff80100ab4:	48 63 c9             	movslq %ecx,%rcx
ffffffff80100ab7:	48 01 c9             	add    %rcx,%rcx
ffffffff80100aba:	48 01 c8             	add    %rcx,%rax
ffffffff80100abd:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80100ac2:	48 89 c7             	mov    %rax,%rdi
ffffffff80100ac5:	e8 48 62 00 00       	callq  ffffffff80106d12 <memset>
  }
  
  outb(CRTPORT, 14);
ffffffff80100aca:	be 0e 00 00 00       	mov    $0xe,%esi
ffffffff80100acf:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffffffff80100ad4:	e8 5a f9 ff ff       	callq  ffffffff80100433 <outb>
  outb(CRTPORT+1, pos>>8);
ffffffff80100ad9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100adc:	c1 f8 08             	sar    $0x8,%eax
ffffffff80100adf:	0f b6 c0             	movzbl %al,%eax
ffffffff80100ae2:	89 c6                	mov    %eax,%esi
ffffffff80100ae4:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffffffff80100ae9:	e8 45 f9 ff ff       	callq  ffffffff80100433 <outb>
  outb(CRTPORT, 15);
ffffffff80100aee:	be 0f 00 00 00       	mov    $0xf,%esi
ffffffff80100af3:	bf d4 03 00 00       	mov    $0x3d4,%edi
ffffffff80100af8:	e8 36 f9 ff ff       	callq  ffffffff80100433 <outb>
  outb(CRTPORT+1, pos);
ffffffff80100afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100b00:	0f b6 c0             	movzbl %al,%eax
ffffffff80100b03:	89 c6                	mov    %eax,%esi
ffffffff80100b05:	bf d5 03 00 00       	mov    $0x3d5,%edi
ffffffff80100b0a:	e8 24 f9 ff ff       	callq  ffffffff80100433 <outb>
  crt[pos] = ' ' | 0x0700;
ffffffff80100b0f:	48 8b 05 02 a5 00 00 	mov    0xa502(%rip),%rax        # ffffffff8010b018 <crt>
ffffffff80100b16:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80100b19:	48 63 d2             	movslq %edx,%rdx
ffffffff80100b1c:	48 01 d2             	add    %rdx,%rdx
ffffffff80100b1f:	48 01 d0             	add    %rdx,%rax
ffffffff80100b22:	66 c7 00 20 07       	movw   $0x720,(%rax)
}
ffffffff80100b27:	90                   	nop
ffffffff80100b28:	c9                   	leaveq 
ffffffff80100b29:	c3                   	retq   

ffffffff80100b2a <consputc>:

void
consputc(int c)
{
ffffffff80100b2a:	55                   	push   %rbp
ffffffff80100b2b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100b2e:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80100b32:	89 7d fc             	mov    %edi,-0x4(%rbp)
  if(panicked){
ffffffff80100b35:	8b 05 fd f8 00 00    	mov    0xf8fd(%rip),%eax        # ffffffff80110438 <panicked>
ffffffff80100b3b:	85 c0                	test   %eax,%eax
ffffffff80100b3d:	74 07                	je     ffffffff80100b46 <consputc+0x1c>
    cli();
ffffffff80100b3f:	e8 5d f9 ff ff       	callq  ffffffff801004a1 <cli>
    for(;;)
      ;
ffffffff80100b44:	eb fe                	jmp    ffffffff80100b44 <consputc+0x1a>
  }

  if(c == BACKSPACE){
ffffffff80100b46:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
ffffffff80100b4d:	75 20                	jne    ffffffff80100b6f <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
ffffffff80100b4f:	bf 08 00 00 00       	mov    $0x8,%edi
ffffffff80100b54:	e8 46 7e 00 00       	callq  ffffffff8010899f <uartputc>
ffffffff80100b59:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff80100b5e:	e8 3c 7e 00 00       	callq  ffffffff8010899f <uartputc>
ffffffff80100b63:	bf 08 00 00 00       	mov    $0x8,%edi
ffffffff80100b68:	e8 32 7e 00 00       	callq  ffffffff8010899f <uartputc>
ffffffff80100b6d:	eb 0a                	jmp    ffffffff80100b79 <consputc+0x4f>
  } else
    uartputc(c);
ffffffff80100b6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100b72:	89 c7                	mov    %eax,%edi
ffffffff80100b74:	e8 26 7e 00 00       	callq  ffffffff8010899f <uartputc>
  cgaputc(c);
ffffffff80100b79:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100b7c:	89 c7                	mov    %eax,%edi
ffffffff80100b7e:	e8 2d fe ff ff       	callq  ffffffff801009b0 <cgaputc>
}
ffffffff80100b83:	90                   	nop
ffffffff80100b84:	c9                   	leaveq 
ffffffff80100b85:	c3                   	retq   

ffffffff80100b86 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
ffffffff80100b86:	55                   	push   %rbp
ffffffff80100b87:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100b8a:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80100b8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int c;

  acquire(&input.lock);
ffffffff80100b92:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100b99:	e8 05 5e 00 00       	callq  ffffffff801069a3 <acquire>
  while((c = getc()) >= 0){
ffffffff80100b9e:	e9 5f 01 00 00       	jmpq   ffffffff80100d02 <consoleintr+0x17c>
    switch(c){
ffffffff80100ba3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100ba6:	83 f8 15             	cmp    $0x15,%eax
ffffffff80100ba9:	74 5e                	je     ffffffff80100c09 <consoleintr+0x83>
ffffffff80100bab:	83 f8 15             	cmp    $0x15,%eax
ffffffff80100bae:	7f 13                	jg     ffffffff80100bc3 <consoleintr+0x3d>
ffffffff80100bb0:	83 f8 08             	cmp    $0x8,%eax
ffffffff80100bb3:	0f 84 82 00 00 00    	je     ffffffff80100c3b <consoleintr+0xb5>
ffffffff80100bb9:	83 f8 10             	cmp    $0x10,%eax
ffffffff80100bbc:	74 28                	je     ffffffff80100be6 <consoleintr+0x60>
ffffffff80100bbe:	e9 aa 00 00 00       	jmpq   ffffffff80100c6d <consoleintr+0xe7>
ffffffff80100bc3:	83 f8 1a             	cmp    $0x1a,%eax
ffffffff80100bc6:	74 0a                	je     ffffffff80100bd2 <consoleintr+0x4c>
ffffffff80100bc8:	83 f8 7f             	cmp    $0x7f,%eax
ffffffff80100bcb:	74 6e                	je     ffffffff80100c3b <consoleintr+0xb5>
ffffffff80100bcd:	e9 9b 00 00 00       	jmpq   ffffffff80100c6d <consoleintr+0xe7>
    case C('Z'): // reboot
      lidt(0,0);
ffffffff80100bd2:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80100bd7:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80100bdc:	e8 71 f8 ff ff       	callq  ffffffff80100452 <lidt>
      break;
ffffffff80100be1:	e9 1c 01 00 00       	jmpq   ffffffff80100d02 <consoleintr+0x17c>
    case C('P'):  // Process listing.
      procdump();
ffffffff80100be6:	e8 08 5c 00 00       	callq  ffffffff801067f3 <procdump>
      break;
ffffffff80100beb:	e9 12 01 00 00       	jmpq   ffffffff80100d02 <consoleintr+0x17c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
ffffffff80100bf0:	8b 05 3a f8 00 00    	mov    0xf83a(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100bf6:	83 e8 01             	sub    $0x1,%eax
ffffffff80100bf9:	89 05 31 f8 00 00    	mov    %eax,0xf831(%rip)        # ffffffff80110430 <input+0xf0>
        consputc(BACKSPACE);
ffffffff80100bff:	bf 00 01 00 00       	mov    $0x100,%edi
ffffffff80100c04:	e8 21 ff ff ff       	callq  ffffffff80100b2a <consputc>
      break;
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
ffffffff80100c09:	8b 15 21 f8 00 00    	mov    0xf821(%rip),%edx        # ffffffff80110430 <input+0xf0>
ffffffff80100c0f:	8b 05 17 f8 00 00    	mov    0xf817(%rip),%eax        # ffffffff8011042c <input+0xec>
ffffffff80100c15:	39 c2                	cmp    %eax,%edx
ffffffff80100c17:	0f 84 e5 00 00 00    	je     ffffffff80100d02 <consoleintr+0x17c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
ffffffff80100c1d:	8b 05 0d f8 00 00    	mov    0xf80d(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100c23:	83 e8 01             	sub    $0x1,%eax
ffffffff80100c26:	83 e0 7f             	and    $0x7f,%eax
ffffffff80100c29:	89 c0                	mov    %eax,%eax
ffffffff80100c2b:	0f b6 80 a8 03 11 80 	movzbl -0x7feefc58(%rax),%eax
      break;
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
ffffffff80100c32:	3c 0a                	cmp    $0xa,%al
ffffffff80100c34:	75 ba                	jne    ffffffff80100bf0 <consoleintr+0x6a>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
ffffffff80100c36:	e9 c7 00 00 00       	jmpq   ffffffff80100d02 <consoleintr+0x17c>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
ffffffff80100c3b:	8b 15 ef f7 00 00    	mov    0xf7ef(%rip),%edx        # ffffffff80110430 <input+0xf0>
ffffffff80100c41:	8b 05 e5 f7 00 00    	mov    0xf7e5(%rip),%eax        # ffffffff8011042c <input+0xec>
ffffffff80100c47:	39 c2                	cmp    %eax,%edx
ffffffff80100c49:	0f 84 b3 00 00 00    	je     ffffffff80100d02 <consoleintr+0x17c>
        input.e--;
ffffffff80100c4f:	8b 05 db f7 00 00    	mov    0xf7db(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100c55:	83 e8 01             	sub    $0x1,%eax
ffffffff80100c58:	89 05 d2 f7 00 00    	mov    %eax,0xf7d2(%rip)        # ffffffff80110430 <input+0xf0>
        consputc(BACKSPACE);
ffffffff80100c5e:	bf 00 01 00 00       	mov    $0x100,%edi
ffffffff80100c63:	e8 c2 fe ff ff       	callq  ffffffff80100b2a <consputc>
      }
      break;
ffffffff80100c68:	e9 95 00 00 00       	jmpq   ffffffff80100d02 <consoleintr+0x17c>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
ffffffff80100c6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80100c71:	0f 84 8a 00 00 00    	je     ffffffff80100d01 <consoleintr+0x17b>
ffffffff80100c77:	8b 15 b3 f7 00 00    	mov    0xf7b3(%rip),%edx        # ffffffff80110430 <input+0xf0>
ffffffff80100c7d:	8b 05 a5 f7 00 00    	mov    0xf7a5(%rip),%eax        # ffffffff80110428 <input+0xe8>
ffffffff80100c83:	29 c2                	sub    %eax,%edx
ffffffff80100c85:	89 d0                	mov    %edx,%eax
ffffffff80100c87:	83 f8 7f             	cmp    $0x7f,%eax
ffffffff80100c8a:	77 75                	ja     ffffffff80100d01 <consoleintr+0x17b>
        c = (c == '\r') ? '\n' : c;
ffffffff80100c8c:	83 7d fc 0d          	cmpl   $0xd,-0x4(%rbp)
ffffffff80100c90:	74 05                	je     ffffffff80100c97 <consoleintr+0x111>
ffffffff80100c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100c95:	eb 05                	jmp    ffffffff80100c9c <consoleintr+0x116>
ffffffff80100c97:	b8 0a 00 00 00       	mov    $0xa,%eax
ffffffff80100c9c:	89 45 fc             	mov    %eax,-0x4(%rbp)
        input.buf[input.e++ % INPUT_BUF] = c;
ffffffff80100c9f:	8b 05 8b f7 00 00    	mov    0xf78b(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100ca5:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80100ca8:	89 15 82 f7 00 00    	mov    %edx,0xf782(%rip)        # ffffffff80110430 <input+0xf0>
ffffffff80100cae:	83 e0 7f             	and    $0x7f,%eax
ffffffff80100cb1:	89 c1                	mov    %eax,%ecx
ffffffff80100cb3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100cb6:	89 c2                	mov    %eax,%edx
ffffffff80100cb8:	89 c8                	mov    %ecx,%eax
ffffffff80100cba:	88 90 a8 03 11 80    	mov    %dl,-0x7feefc58(%rax)
        consputc(c);
ffffffff80100cc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100cc3:	89 c7                	mov    %eax,%edi
ffffffff80100cc5:	e8 60 fe ff ff       	callq  ffffffff80100b2a <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
ffffffff80100cca:	83 7d fc 0a          	cmpl   $0xa,-0x4(%rbp)
ffffffff80100cce:	74 19                	je     ffffffff80100ce9 <consoleintr+0x163>
ffffffff80100cd0:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
ffffffff80100cd4:	74 13                	je     ffffffff80100ce9 <consoleintr+0x163>
ffffffff80100cd6:	8b 05 54 f7 00 00    	mov    0xf754(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100cdc:	8b 15 46 f7 00 00    	mov    0xf746(%rip),%edx        # ffffffff80110428 <input+0xe8>
ffffffff80100ce2:	83 ea 80             	sub    $0xffffff80,%edx
ffffffff80100ce5:	39 d0                	cmp    %edx,%eax
ffffffff80100ce7:	75 18                	jne    ffffffff80100d01 <consoleintr+0x17b>
          input.w = input.e;
ffffffff80100ce9:	8b 05 41 f7 00 00    	mov    0xf741(%rip),%eax        # ffffffff80110430 <input+0xf0>
ffffffff80100cef:	89 05 37 f7 00 00    	mov    %eax,0xf737(%rip)        # ffffffff8011042c <input+0xec>
          wakeup(&input.r);
ffffffff80100cf5:	48 c7 c7 28 04 11 80 	mov    $0xffffffff80110428,%rdi
ffffffff80100cfc:	e8 38 5a 00 00       	callq  ffffffff80106739 <wakeup>
        }
      }
      break;
ffffffff80100d01:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
ffffffff80100d02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100d06:	ff d0                	callq  *%rax
ffffffff80100d08:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80100d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80100d0f:	0f 89 8e fe ff ff    	jns    ffffffff80100ba3 <consoleintr+0x1d>
        }
      }
      break;
    }
  }
  release(&input.lock);
ffffffff80100d15:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100d1c:	e8 59 5d 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80100d21:	90                   	nop
ffffffff80100d22:	c9                   	leaveq 
ffffffff80100d23:	c3                   	retq   

ffffffff80100d24 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
ffffffff80100d24:	55                   	push   %rbp
ffffffff80100d25:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100d28:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80100d2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80100d30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80100d34:	89 55 dc             	mov    %edx,-0x24(%rbp)
  uint target;
  int c;

  iunlock(ip);
ffffffff80100d37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100d3b:	48 89 c7             	mov    %rax,%rdi
ffffffff80100d3e:	e8 a0 1c 00 00       	callq  ffffffff801029e3 <iunlock>
  target = n;
ffffffff80100d43:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100d46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  acquire(&input.lock);
ffffffff80100d49:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100d50:	e8 4e 5c 00 00       	callq  ffffffff801069a3 <acquire>
  while(n > 0){
ffffffff80100d55:	e9 b2 00 00 00       	jmpq   ffffffff80100e0c <consoleread+0xe8>
    while(input.r == input.w){
      if(proc->killed){
ffffffff80100d5a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80100d61:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80100d65:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80100d68:	85 c0                	test   %eax,%eax
ffffffff80100d6a:	74 22                	je     ffffffff80100d8e <consoleread+0x6a>
        release(&input.lock);
ffffffff80100d6c:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100d73:	e8 02 5d 00 00       	callq  ffffffff80106a7a <release>
        ilock(ip);
ffffffff80100d78:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100d7c:	48 89 c7             	mov    %rax,%rdi
ffffffff80100d7f:	e8 c0 1a 00 00       	callq  ffffffff80102844 <ilock>
        return -1;
ffffffff80100d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80100d89:	e9 ac 00 00 00       	jmpq   ffffffff80100e3a <consoleread+0x116>
      }
      sleep(&input.r, &input.lock);
ffffffff80100d8e:	48 c7 c6 40 03 11 80 	mov    $0xffffffff80110340,%rsi
ffffffff80100d95:	48 c7 c7 28 04 11 80 	mov    $0xffffffff80110428,%rdi
ffffffff80100d9c:	e8 85 58 00 00       	callq  ffffffff80106626 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
ffffffff80100da1:	8b 15 81 f6 00 00    	mov    0xf681(%rip),%edx        # ffffffff80110428 <input+0xe8>
ffffffff80100da7:	8b 05 7f f6 00 00    	mov    0xf67f(%rip),%eax        # ffffffff8011042c <input+0xec>
ffffffff80100dad:	39 c2                	cmp    %eax,%edx
ffffffff80100daf:	74 a9                	je     ffffffff80100d5a <consoleread+0x36>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
ffffffff80100db1:	8b 05 71 f6 00 00    	mov    0xf671(%rip),%eax        # ffffffff80110428 <input+0xe8>
ffffffff80100db7:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80100dba:	89 15 68 f6 00 00    	mov    %edx,0xf668(%rip)        # ffffffff80110428 <input+0xe8>
ffffffff80100dc0:	83 e0 7f             	and    $0x7f,%eax
ffffffff80100dc3:	89 c0                	mov    %eax,%eax
ffffffff80100dc5:	0f b6 80 a8 03 11 80 	movzbl -0x7feefc58(%rax),%eax
ffffffff80100dcc:	0f be c0             	movsbl %al,%eax
ffffffff80100dcf:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(c == C('D')){  // EOF
ffffffff80100dd2:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
ffffffff80100dd6:	75 19                	jne    ffffffff80100df1 <consoleread+0xcd>
      if(n < target){
ffffffff80100dd8:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100ddb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff80100dde:	73 34                	jae    ffffffff80100e14 <consoleread+0xf0>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
ffffffff80100de0:	8b 05 42 f6 00 00    	mov    0xf642(%rip),%eax        # ffffffff80110428 <input+0xe8>
ffffffff80100de6:	83 e8 01             	sub    $0x1,%eax
ffffffff80100de9:	89 05 39 f6 00 00    	mov    %eax,0xf639(%rip)        # ffffffff80110428 <input+0xe8>
      }
      break;
ffffffff80100def:	eb 23                	jmp    ffffffff80100e14 <consoleread+0xf0>
    }
    *dst++ = c;
ffffffff80100df1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80100df5:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffffffff80100df9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
ffffffff80100dfd:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffffffff80100e00:	88 10                	mov    %dl,(%rax)
    --n;
ffffffff80100e02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
    if(c == '\n')
ffffffff80100e06:	83 7d f8 0a          	cmpl   $0xa,-0x8(%rbp)
ffffffff80100e0a:	74 0b                	je     ffffffff80100e17 <consoleread+0xf3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
ffffffff80100e0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffffffff80100e10:	7f 8f                	jg     ffffffff80100da1 <consoleread+0x7d>
ffffffff80100e12:	eb 04                	jmp    ffffffff80100e18 <consoleread+0xf4>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
ffffffff80100e14:	90                   	nop
ffffffff80100e15:	eb 01                	jmp    ffffffff80100e18 <consoleread+0xf4>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
ffffffff80100e17:	90                   	nop
  }
  release(&input.lock);
ffffffff80100e18:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100e1f:	e8 56 5c 00 00       	callq  ffffffff80106a7a <release>
  ilock(ip);
ffffffff80100e24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100e28:	48 89 c7             	mov    %rax,%rdi
ffffffff80100e2b:	e8 14 1a 00 00       	callq  ffffffff80102844 <ilock>

  return target - n;
ffffffff80100e30:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80100e33:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80100e36:	29 c2                	sub    %eax,%edx
ffffffff80100e38:	89 d0                	mov    %edx,%eax
}
ffffffff80100e3a:	c9                   	leaveq 
ffffffff80100e3b:	c3                   	retq   

ffffffff80100e3c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
ffffffff80100e3c:	55                   	push   %rbp
ffffffff80100e3d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100e40:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80100e44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80100e48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80100e4c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  iunlock(ip);
ffffffff80100e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100e53:	48 89 c7             	mov    %rax,%rdi
ffffffff80100e56:	e8 88 1b 00 00       	callq  ffffffff801029e3 <iunlock>
  acquire(&cons.lock);
ffffffff80100e5b:	48 c7 c7 40 04 11 80 	mov    $0xffffffff80110440,%rdi
ffffffff80100e62:	e8 3c 5b 00 00       	callq  ffffffff801069a3 <acquire>
  for(i = 0; i < n; i++)
ffffffff80100e67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80100e6e:	eb 21                	jmp    ffffffff80100e91 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
ffffffff80100e70:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100e73:	48 63 d0             	movslq %eax,%rdx
ffffffff80100e76:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80100e7a:	48 01 d0             	add    %rdx,%rax
ffffffff80100e7d:	0f b6 00             	movzbl (%rax),%eax
ffffffff80100e80:	0f be c0             	movsbl %al,%eax
ffffffff80100e83:	0f b6 c0             	movzbl %al,%eax
ffffffff80100e86:	89 c7                	mov    %eax,%edi
ffffffff80100e88:	e8 9d fc ff ff       	callq  ffffffff80100b2a <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
ffffffff80100e8d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80100e91:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80100e94:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80100e97:	7c d7                	jl     ffffffff80100e70 <consolewrite+0x34>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
ffffffff80100e99:	48 c7 c7 40 04 11 80 	mov    $0xffffffff80110440,%rdi
ffffffff80100ea0:	e8 d5 5b 00 00       	callq  ffffffff80106a7a <release>
  ilock(ip);
ffffffff80100ea5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80100ea9:	48 89 c7             	mov    %rax,%rdi
ffffffff80100eac:	e8 93 19 00 00       	callq  ffffffff80102844 <ilock>

  return n;
ffffffff80100eb1:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffffffff80100eb4:	c9                   	leaveq 
ffffffff80100eb5:	c3                   	retq   

ffffffff80100eb6 <consoleinit>:

void
consoleinit(void)
{
ffffffff80100eb6:	55                   	push   %rbp
ffffffff80100eb7:	48 89 e5             	mov    %rsp,%rbp
  initlock(&cons.lock, "console");
ffffffff80100eba:	48 c7 c6 3b a5 10 80 	mov    $0xffffffff8010a53b,%rsi
ffffffff80100ec1:	48 c7 c7 40 04 11 80 	mov    $0xffffffff80110440,%rdi
ffffffff80100ec8:	e8 a1 5a 00 00       	callq  ffffffff8010696e <initlock>
  initlock(&input.lock, "input");
ffffffff80100ecd:	48 c7 c6 43 a5 10 80 	mov    $0xffffffff8010a543,%rsi
ffffffff80100ed4:	48 c7 c7 40 03 11 80 	mov    $0xffffffff80110340,%rdi
ffffffff80100edb:	e8 8e 5a 00 00       	callq  ffffffff8010696e <initlock>

  devsw[CONSOLE].write = consolewrite;
ffffffff80100ee0:	48 c7 05 0d f6 00 00 	movq   $0xffffffff80100e3c,0xf60d(%rip)        # ffffffff801104f8 <devsw+0x18>
ffffffff80100ee7:	3c 0e 10 80 
  devsw[CONSOLE].read = consoleread;
ffffffff80100eeb:	48 c7 05 fa f5 00 00 	movq   $0xffffffff80100d24,0xf5fa(%rip)        # ffffffff801104f0 <devsw+0x10>
ffffffff80100ef2:	24 0d 10 80 
  cons.locking = 1;
ffffffff80100ef6:	c7 05 a8 f5 00 00 01 	movl   $0x1,0xf5a8(%rip)        # ffffffff801104a8 <cons+0x68>
ffffffff80100efd:	00 00 00 

  picenable(IRQ_KBD);
ffffffff80100f00:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80100f05:	e8 96 47 00 00       	callq  ffffffff801056a0 <picenable>
  ioapicenable(IRQ_KBD, 0);
ffffffff80100f0a:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80100f0f:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80100f14:	e8 2c 2c 00 00       	callq  ffffffff80103b45 <ioapicenable>
}
ffffffff80100f19:	90                   	nop
ffffffff80100f1a:	5d                   	pop    %rbp
ffffffff80100f1b:	c3                   	retq   

ffffffff80100f1c <cpu_printfeatures>:
// leaf = 7
uint sef_flags;

static void
cpu_printfeatures(void)
{
ffffffff80100f1c:	55                   	push   %rbp
ffffffff80100f1d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80100f20:	48 83 ec 10          	sub    $0x10,%rsp
  uchar vendorStr[13];
  *(uint*)(&vendorStr[0]) = vendor[0];
ffffffff80100f24:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80100f28:	8b 15 8a f5 00 00    	mov    0xf58a(%rip),%edx        # ffffffff801104b8 <vendor>
ffffffff80100f2e:	89 10                	mov    %edx,(%rax)
  *(uint*)(&vendorStr[4]) = vendor[1];
ffffffff80100f30:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80100f34:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffffffff80100f38:	8b 05 7e f5 00 00    	mov    0xf57e(%rip),%eax        # ffffffff801104bc <vendor+0x4>
ffffffff80100f3e:	89 02                	mov    %eax,(%rdx)
  *(uint*)(&vendorStr[8]) = vendor[2];
ffffffff80100f40:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80100f44:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff80100f48:	8b 05 72 f5 00 00    	mov    0xf572(%rip),%eax        # ffffffff801104c0 <vendor+0x8>
ffffffff80100f4e:	89 02                	mov    %eax,(%rdx)
  vendorStr[12] = 0;
ffffffff80100f50:	c6 45 fc 00          	movb   $0x0,-0x4(%rbp)

  cprintf("CPU vendor: %s\n", vendorStr);
ffffffff80100f54:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80100f58:	48 89 c6             	mov    %rax,%rsi
ffffffff80100f5b:	48 c7 c7 50 a5 10 80 	mov    $0xffffffff8010a550,%rdi
ffffffff80100f62:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100f67:	e8 36 f6 ff ff       	callq  ffffffff801005a2 <cprintf>
  cprintf("Max leaf: 0x%x\n", maxleaf);
ffffffff80100f6c:	8b 05 3e f5 00 00    	mov    0xf53e(%rip),%eax        # ffffffff801104b0 <maxleaf>
ffffffff80100f72:	89 c6                	mov    %eax,%esi
ffffffff80100f74:	48 c7 c7 60 a5 10 80 	mov    $0xffffffff8010a560,%rdi
ffffffff80100f7b:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100f80:	e8 1d f6 ff ff       	callq  ffffffff801005a2 <cprintf>
  if (maxleaf >= 1) {
ffffffff80100f85:	8b 05 25 f5 00 00    	mov    0xf525(%rip),%eax        # ffffffff801104b0 <maxleaf>
ffffffff80100f8b:	85 c0                	test   %eax,%eax
ffffffff80100f8d:	0f 84 52 07 00 00    	je     ffffffff801016e5 <cpu_printfeatures+0x7c9>
    cprintf("Features: ");
ffffffff80100f93:	48 c7 c7 70 a5 10 80 	mov    $0xffffffff8010a570,%rdi
ffffffff80100f9a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100f9f:	e8 fe f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, FPU);
ffffffff80100fa4:	8b 05 26 f5 00 00    	mov    0xf526(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80100faa:	83 e0 01             	and    $0x1,%eax
ffffffff80100fad:	85 c0                	test   %eax,%eax
ffffffff80100faf:	74 11                	je     ffffffff80100fc2 <cpu_printfeatures+0xa6>
ffffffff80100fb1:	48 c7 c7 7b a5 10 80 	mov    $0xffffffff8010a57b,%rdi
ffffffff80100fb8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100fbd:	e8 e0 f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, VME);
ffffffff80100fc2:	8b 05 08 f5 00 00    	mov    0xf508(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80100fc8:	83 e0 02             	and    $0x2,%eax
ffffffff80100fcb:	85 c0                	test   %eax,%eax
ffffffff80100fcd:	74 11                	je     ffffffff80100fe0 <cpu_printfeatures+0xc4>
ffffffff80100fcf:	48 c7 c7 80 a5 10 80 	mov    $0xffffffff8010a580,%rdi
ffffffff80100fd6:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100fdb:	e8 c2 f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, DE);
ffffffff80100fe0:	8b 05 ea f4 00 00    	mov    0xf4ea(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80100fe6:	83 e0 04             	and    $0x4,%eax
ffffffff80100fe9:	85 c0                	test   %eax,%eax
ffffffff80100feb:	74 11                	je     ffffffff80100ffe <cpu_printfeatures+0xe2>
ffffffff80100fed:	48 c7 c7 85 a5 10 80 	mov    $0xffffffff8010a585,%rdi
ffffffff80100ff4:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80100ff9:	e8 a4 f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PSE);
ffffffff80100ffe:	8b 05 cc f4 00 00    	mov    0xf4cc(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80101004:	83 e0 08             	and    $0x8,%eax
ffffffff80101007:	85 c0                	test   %eax,%eax
ffffffff80101009:	74 11                	je     ffffffff8010101c <cpu_printfeatures+0x100>
ffffffff8010100b:	48 c7 c7 89 a5 10 80 	mov    $0xffffffff8010a589,%rdi
ffffffff80101012:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101017:	e8 86 f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, TSC);
ffffffff8010101c:	8b 05 ae f4 00 00    	mov    0xf4ae(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80101022:	83 e0 10             	and    $0x10,%eax
ffffffff80101025:	85 c0                	test   %eax,%eax
ffffffff80101027:	74 11                	je     ffffffff8010103a <cpu_printfeatures+0x11e>
ffffffff80101029:	48 c7 c7 8e a5 10 80 	mov    $0xffffffff8010a58e,%rdi
ffffffff80101030:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101035:	e8 68 f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, MSR);
ffffffff8010103a:	8b 05 90 f4 00 00    	mov    0xf490(%rip),%eax        # ffffffff801104d0 <features>
ffffffff80101040:	83 e0 20             	and    $0x20,%eax
ffffffff80101043:	85 c0                	test   %eax,%eax
ffffffff80101045:	74 11                	je     ffffffff80101058 <cpu_printfeatures+0x13c>
ffffffff80101047:	48 c7 c7 93 a5 10 80 	mov    $0xffffffff8010a593,%rdi
ffffffff8010104e:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101053:	e8 4a f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PAE);
ffffffff80101058:	8b 05 72 f4 00 00    	mov    0xf472(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010105e:	83 e0 40             	and    $0x40,%eax
ffffffff80101061:	85 c0                	test   %eax,%eax
ffffffff80101063:	74 11                	je     ffffffff80101076 <cpu_printfeatures+0x15a>
ffffffff80101065:	48 c7 c7 98 a5 10 80 	mov    $0xffffffff8010a598,%rdi
ffffffff8010106c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101071:	e8 2c f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, MCE);
ffffffff80101076:	8b 05 54 f4 00 00    	mov    0xf454(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010107c:	25 80 00 00 00       	and    $0x80,%eax
ffffffff80101081:	85 c0                	test   %eax,%eax
ffffffff80101083:	74 11                	je     ffffffff80101096 <cpu_printfeatures+0x17a>
ffffffff80101085:	48 c7 c7 9d a5 10 80 	mov    $0xffffffff8010a59d,%rdi
ffffffff8010108c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101091:	e8 0c f5 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, CX8);
ffffffff80101096:	8b 05 34 f4 00 00    	mov    0xf434(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010109c:	25 00 01 00 00       	and    $0x100,%eax
ffffffff801010a1:	85 c0                	test   %eax,%eax
ffffffff801010a3:	74 11                	je     ffffffff801010b6 <cpu_printfeatures+0x19a>
ffffffff801010a5:	48 c7 c7 a2 a5 10 80 	mov    $0xffffffff8010a5a2,%rdi
ffffffff801010ac:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801010b1:	e8 ec f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, APIC);
ffffffff801010b6:	8b 05 14 f4 00 00    	mov    0xf414(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801010bc:	25 00 02 00 00       	and    $0x200,%eax
ffffffff801010c1:	85 c0                	test   %eax,%eax
ffffffff801010c3:	74 11                	je     ffffffff801010d6 <cpu_printfeatures+0x1ba>
ffffffff801010c5:	48 c7 c7 a7 a5 10 80 	mov    $0xffffffff8010a5a7,%rdi
ffffffff801010cc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801010d1:	e8 cc f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, SEP);
ffffffff801010d6:	8b 05 f4 f3 00 00    	mov    0xf3f4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801010dc:	25 00 08 00 00       	and    $0x800,%eax
ffffffff801010e1:	85 c0                	test   %eax,%eax
ffffffff801010e3:	74 11                	je     ffffffff801010f6 <cpu_printfeatures+0x1da>
ffffffff801010e5:	48 c7 c7 ad a5 10 80 	mov    $0xffffffff8010a5ad,%rdi
ffffffff801010ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801010f1:	e8 ac f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, MTRR);
ffffffff801010f6:	8b 05 d4 f3 00 00    	mov    0xf3d4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801010fc:	25 00 10 00 00       	and    $0x1000,%eax
ffffffff80101101:	85 c0                	test   %eax,%eax
ffffffff80101103:	74 11                	je     ffffffff80101116 <cpu_printfeatures+0x1fa>
ffffffff80101105:	48 c7 c7 b2 a5 10 80 	mov    $0xffffffff8010a5b2,%rdi
ffffffff8010110c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101111:	e8 8c f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PGE);
ffffffff80101116:	8b 05 b4 f3 00 00    	mov    0xf3b4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010111c:	25 00 20 00 00       	and    $0x2000,%eax
ffffffff80101121:	85 c0                	test   %eax,%eax
ffffffff80101123:	74 11                	je     ffffffff80101136 <cpu_printfeatures+0x21a>
ffffffff80101125:	48 c7 c7 b8 a5 10 80 	mov    $0xffffffff8010a5b8,%rdi
ffffffff8010112c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101131:	e8 6c f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, MCA);
ffffffff80101136:	8b 05 94 f3 00 00    	mov    0xf394(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010113c:	25 00 40 00 00       	and    $0x4000,%eax
ffffffff80101141:	85 c0                	test   %eax,%eax
ffffffff80101143:	74 11                	je     ffffffff80101156 <cpu_printfeatures+0x23a>
ffffffff80101145:	48 c7 c7 bd a5 10 80 	mov    $0xffffffff8010a5bd,%rdi
ffffffff8010114c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101151:	e8 4c f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, CMOV);
ffffffff80101156:	8b 05 74 f3 00 00    	mov    0xf374(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010115c:	25 00 80 00 00       	and    $0x8000,%eax
ffffffff80101161:	85 c0                	test   %eax,%eax
ffffffff80101163:	74 11                	je     ffffffff80101176 <cpu_printfeatures+0x25a>
ffffffff80101165:	48 c7 c7 c2 a5 10 80 	mov    $0xffffffff8010a5c2,%rdi
ffffffff8010116c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101171:	e8 2c f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PAT);
ffffffff80101176:	8b 05 54 f3 00 00    	mov    0xf354(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010117c:	25 00 00 01 00       	and    $0x10000,%eax
ffffffff80101181:	85 c0                	test   %eax,%eax
ffffffff80101183:	74 11                	je     ffffffff80101196 <cpu_printfeatures+0x27a>
ffffffff80101185:	48 c7 c7 c8 a5 10 80 	mov    $0xffffffff8010a5c8,%rdi
ffffffff8010118c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101191:	e8 0c f4 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PSE36);
ffffffff80101196:	8b 05 34 f3 00 00    	mov    0xf334(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010119c:	25 00 00 02 00       	and    $0x20000,%eax
ffffffff801011a1:	85 c0                	test   %eax,%eax
ffffffff801011a3:	74 11                	je     ffffffff801011b6 <cpu_printfeatures+0x29a>
ffffffff801011a5:	48 c7 c7 cd a5 10 80 	mov    $0xffffffff8010a5cd,%rdi
ffffffff801011ac:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801011b1:	e8 ec f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PSN);
ffffffff801011b6:	8b 05 14 f3 00 00    	mov    0xf314(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801011bc:	25 00 00 04 00       	and    $0x40000,%eax
ffffffff801011c1:	85 c0                	test   %eax,%eax
ffffffff801011c3:	74 11                	je     ffffffff801011d6 <cpu_printfeatures+0x2ba>
ffffffff801011c5:	48 c7 c7 d4 a5 10 80 	mov    $0xffffffff8010a5d4,%rdi
ffffffff801011cc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801011d1:	e8 cc f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, CLFSH);
ffffffff801011d6:	8b 05 f4 f2 00 00    	mov    0xf2f4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801011dc:	25 00 00 08 00       	and    $0x80000,%eax
ffffffff801011e1:	85 c0                	test   %eax,%eax
ffffffff801011e3:	74 11                	je     ffffffff801011f6 <cpu_printfeatures+0x2da>
ffffffff801011e5:	48 c7 c7 d9 a5 10 80 	mov    $0xffffffff8010a5d9,%rdi
ffffffff801011ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801011f1:	e8 ac f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, DS);
ffffffff801011f6:	8b 05 d4 f2 00 00    	mov    0xf2d4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801011fc:	25 00 00 20 00       	and    $0x200000,%eax
ffffffff80101201:	85 c0                	test   %eax,%eax
ffffffff80101203:	74 11                	je     ffffffff80101216 <cpu_printfeatures+0x2fa>
ffffffff80101205:	48 c7 c7 e0 a5 10 80 	mov    $0xffffffff8010a5e0,%rdi
ffffffff8010120c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101211:	e8 8c f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, ACPI);
ffffffff80101216:	8b 05 b4 f2 00 00    	mov    0xf2b4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010121c:	25 00 00 40 00       	and    $0x400000,%eax
ffffffff80101221:	85 c0                	test   %eax,%eax
ffffffff80101223:	74 11                	je     ffffffff80101236 <cpu_printfeatures+0x31a>
ffffffff80101225:	48 c7 c7 e4 a5 10 80 	mov    $0xffffffff8010a5e4,%rdi
ffffffff8010122c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101231:	e8 6c f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, MMX);
ffffffff80101236:	8b 05 94 f2 00 00    	mov    0xf294(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010123c:	25 00 00 80 00       	and    $0x800000,%eax
ffffffff80101241:	85 c0                	test   %eax,%eax
ffffffff80101243:	74 11                	je     ffffffff80101256 <cpu_printfeatures+0x33a>
ffffffff80101245:	48 c7 c7 ea a5 10 80 	mov    $0xffffffff8010a5ea,%rdi
ffffffff8010124c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101251:	e8 4c f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, FXSR);
ffffffff80101256:	8b 05 74 f2 00 00    	mov    0xf274(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010125c:	25 00 00 00 01       	and    $0x1000000,%eax
ffffffff80101261:	85 c0                	test   %eax,%eax
ffffffff80101263:	74 11                	je     ffffffff80101276 <cpu_printfeatures+0x35a>
ffffffff80101265:	48 c7 c7 ef a5 10 80 	mov    $0xffffffff8010a5ef,%rdi
ffffffff8010126c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101271:	e8 2c f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, SSE);
ffffffff80101276:	8b 05 54 f2 00 00    	mov    0xf254(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010127c:	25 00 00 00 02       	and    $0x2000000,%eax
ffffffff80101281:	85 c0                	test   %eax,%eax
ffffffff80101283:	74 11                	je     ffffffff80101296 <cpu_printfeatures+0x37a>
ffffffff80101285:	48 c7 c7 f5 a5 10 80 	mov    $0xffffffff8010a5f5,%rdi
ffffffff8010128c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101291:	e8 0c f3 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, SSE2);
ffffffff80101296:	8b 05 34 f2 00 00    	mov    0xf234(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010129c:	25 00 00 00 04       	and    $0x4000000,%eax
ffffffff801012a1:	85 c0                	test   %eax,%eax
ffffffff801012a3:	74 11                	je     ffffffff801012b6 <cpu_printfeatures+0x39a>
ffffffff801012a5:	48 c7 c7 fa a5 10 80 	mov    $0xffffffff8010a5fa,%rdi
ffffffff801012ac:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801012b1:	e8 ec f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, SS);
ffffffff801012b6:	8b 05 14 f2 00 00    	mov    0xf214(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801012bc:	25 00 00 00 08       	and    $0x8000000,%eax
ffffffff801012c1:	85 c0                	test   %eax,%eax
ffffffff801012c3:	74 11                	je     ffffffff801012d6 <cpu_printfeatures+0x3ba>
ffffffff801012c5:	48 c7 c7 00 a6 10 80 	mov    $0xffffffff8010a600,%rdi
ffffffff801012cc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801012d1:	e8 cc f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, HTT);
ffffffff801012d6:	8b 05 f4 f1 00 00    	mov    0xf1f4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801012dc:	25 00 00 00 10       	and    $0x10000000,%eax
ffffffff801012e1:	85 c0                	test   %eax,%eax
ffffffff801012e3:	74 11                	je     ffffffff801012f6 <cpu_printfeatures+0x3da>
ffffffff801012e5:	48 c7 c7 04 a6 10 80 	mov    $0xffffffff8010a604,%rdi
ffffffff801012ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801012f1:	e8 ac f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, TM);
ffffffff801012f6:	8b 05 d4 f1 00 00    	mov    0xf1d4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff801012fc:	25 00 00 00 20       	and    $0x20000000,%eax
ffffffff80101301:	85 c0                	test   %eax,%eax
ffffffff80101303:	74 11                	je     ffffffff80101316 <cpu_printfeatures+0x3fa>
ffffffff80101305:	48 c7 c7 09 a6 10 80 	mov    $0xffffffff8010a609,%rdi
ffffffff8010130c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101311:	e8 8c f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(features, PBE);
ffffffff80101316:	8b 05 b4 f1 00 00    	mov    0xf1b4(%rip),%eax        # ffffffff801104d0 <features>
ffffffff8010131c:	85 c0                	test   %eax,%eax
ffffffff8010131e:	79 11                	jns    ffffffff80101331 <cpu_printfeatures+0x415>
ffffffff80101320:	48 c7 c7 0d a6 10 80 	mov    $0xffffffff8010a60d,%rdi
ffffffff80101327:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010132c:	e8 71 f2 ff ff       	callq  ffffffff801005a2 <cprintf>

    cprintf("\nExt Features: ");
ffffffff80101331:	48 c7 c7 12 a6 10 80 	mov    $0xffffffff8010a612,%rdi
ffffffff80101338:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010133d:	e8 60 f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, SSE3);
ffffffff80101342:	8b 05 84 f1 00 00    	mov    0xf184(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff80101348:	83 e0 01             	and    $0x1,%eax
ffffffff8010134b:	85 c0                	test   %eax,%eax
ffffffff8010134d:	74 11                	je     ffffffff80101360 <cpu_printfeatures+0x444>
ffffffff8010134f:	48 c7 c7 22 a6 10 80 	mov    $0xffffffff8010a622,%rdi
ffffffff80101356:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010135b:	e8 42 f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, PCLMULQDQ);
ffffffff80101360:	8b 05 66 f1 00 00    	mov    0xf166(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff80101366:	83 e0 02             	and    $0x2,%eax
ffffffff80101369:	85 c0                	test   %eax,%eax
ffffffff8010136b:	74 11                	je     ffffffff8010137e <cpu_printfeatures+0x462>
ffffffff8010136d:	48 c7 c7 28 a6 10 80 	mov    $0xffffffff8010a628,%rdi
ffffffff80101374:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101379:	e8 24 f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, DTES64);
ffffffff8010137e:	8b 05 48 f1 00 00    	mov    0xf148(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff80101384:	83 e0 04             	and    $0x4,%eax
ffffffff80101387:	85 c0                	test   %eax,%eax
ffffffff80101389:	74 11                	je     ffffffff8010139c <cpu_printfeatures+0x480>
ffffffff8010138b:	48 c7 c7 33 a6 10 80 	mov    $0xffffffff8010a633,%rdi
ffffffff80101392:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101397:	e8 06 f2 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, MONITOR);
ffffffff8010139c:	8b 05 2a f1 00 00    	mov    0xf12a(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801013a2:	83 e0 08             	and    $0x8,%eax
ffffffff801013a5:	85 c0                	test   %eax,%eax
ffffffff801013a7:	74 11                	je     ffffffff801013ba <cpu_printfeatures+0x49e>
ffffffff801013a9:	48 c7 c7 3b a6 10 80 	mov    $0xffffffff8010a63b,%rdi
ffffffff801013b0:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801013b5:	e8 e8 f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, DS_CPL);
ffffffff801013ba:	8b 05 0c f1 00 00    	mov    0xf10c(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801013c0:	83 e0 10             	and    $0x10,%eax
ffffffff801013c3:	85 c0                	test   %eax,%eax
ffffffff801013c5:	74 11                	je     ffffffff801013d8 <cpu_printfeatures+0x4bc>
ffffffff801013c7:	48 c7 c7 44 a6 10 80 	mov    $0xffffffff8010a644,%rdi
ffffffff801013ce:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801013d3:	e8 ca f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, VMX);
ffffffff801013d8:	8b 05 ee f0 00 00    	mov    0xf0ee(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801013de:	83 e0 20             	and    $0x20,%eax
ffffffff801013e1:	85 c0                	test   %eax,%eax
ffffffff801013e3:	74 11                	je     ffffffff801013f6 <cpu_printfeatures+0x4da>
ffffffff801013e5:	48 c7 c7 4c a6 10 80 	mov    $0xffffffff8010a64c,%rdi
ffffffff801013ec:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801013f1:	e8 ac f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, SMX);
ffffffff801013f6:	8b 05 d0 f0 00 00    	mov    0xf0d0(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801013fc:	83 e0 40             	and    $0x40,%eax
ffffffff801013ff:	85 c0                	test   %eax,%eax
ffffffff80101401:	74 11                	je     ffffffff80101414 <cpu_printfeatures+0x4f8>
ffffffff80101403:	48 c7 c7 51 a6 10 80 	mov    $0xffffffff8010a651,%rdi
ffffffff8010140a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010140f:	e8 8e f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, EIST);
ffffffff80101414:	8b 05 b2 f0 00 00    	mov    0xf0b2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010141a:	25 80 00 00 00       	and    $0x80,%eax
ffffffff8010141f:	85 c0                	test   %eax,%eax
ffffffff80101421:	74 11                	je     ffffffff80101434 <cpu_printfeatures+0x518>
ffffffff80101423:	48 c7 c7 56 a6 10 80 	mov    $0xffffffff8010a656,%rdi
ffffffff8010142a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010142f:	e8 6e f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, TM2);
ffffffff80101434:	8b 05 92 f0 00 00    	mov    0xf092(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010143a:	25 00 01 00 00       	and    $0x100,%eax
ffffffff8010143f:	85 c0                	test   %eax,%eax
ffffffff80101441:	74 11                	je     ffffffff80101454 <cpu_printfeatures+0x538>
ffffffff80101443:	48 c7 c7 5c a6 10 80 	mov    $0xffffffff8010a65c,%rdi
ffffffff8010144a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010144f:	e8 4e f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, SSSE3);
ffffffff80101454:	8b 05 72 f0 00 00    	mov    0xf072(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010145a:	25 00 02 00 00       	and    $0x200,%eax
ffffffff8010145f:	85 c0                	test   %eax,%eax
ffffffff80101461:	74 11                	je     ffffffff80101474 <cpu_printfeatures+0x558>
ffffffff80101463:	48 c7 c7 61 a6 10 80 	mov    $0xffffffff8010a661,%rdi
ffffffff8010146a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010146f:	e8 2e f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, CNXT_ID);
ffffffff80101474:	8b 05 52 f0 00 00    	mov    0xf052(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010147a:	25 00 04 00 00       	and    $0x400,%eax
ffffffff8010147f:	85 c0                	test   %eax,%eax
ffffffff80101481:	74 11                	je     ffffffff80101494 <cpu_printfeatures+0x578>
ffffffff80101483:	48 c7 c7 68 a6 10 80 	mov    $0xffffffff8010a668,%rdi
ffffffff8010148a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010148f:	e8 0e f1 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, FMA);
ffffffff80101494:	8b 05 32 f0 00 00    	mov    0xf032(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010149a:	25 00 10 00 00       	and    $0x1000,%eax
ffffffff8010149f:	85 c0                	test   %eax,%eax
ffffffff801014a1:	74 11                	je     ffffffff801014b4 <cpu_printfeatures+0x598>
ffffffff801014a3:	48 c7 c7 71 a6 10 80 	mov    $0xffffffff8010a671,%rdi
ffffffff801014aa:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801014af:	e8 ee f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, CMPXCHG16B);
ffffffff801014b4:	8b 05 12 f0 00 00    	mov    0xf012(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801014ba:	25 00 20 00 00       	and    $0x2000,%eax
ffffffff801014bf:	85 c0                	test   %eax,%eax
ffffffff801014c1:	74 11                	je     ffffffff801014d4 <cpu_printfeatures+0x5b8>
ffffffff801014c3:	48 c7 c7 76 a6 10 80 	mov    $0xffffffff8010a676,%rdi
ffffffff801014ca:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801014cf:	e8 ce f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, xTPR);
ffffffff801014d4:	8b 05 f2 ef 00 00    	mov    0xeff2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801014da:	25 00 40 00 00       	and    $0x4000,%eax
ffffffff801014df:	85 c0                	test   %eax,%eax
ffffffff801014e1:	74 11                	je     ffffffff801014f4 <cpu_printfeatures+0x5d8>
ffffffff801014e3:	48 c7 c7 82 a6 10 80 	mov    $0xffffffff8010a682,%rdi
ffffffff801014ea:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801014ef:	e8 ae f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, PDCM);
ffffffff801014f4:	8b 05 d2 ef 00 00    	mov    0xefd2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801014fa:	25 00 80 00 00       	and    $0x8000,%eax
ffffffff801014ff:	85 c0                	test   %eax,%eax
ffffffff80101501:	74 11                	je     ffffffff80101514 <cpu_printfeatures+0x5f8>
ffffffff80101503:	48 c7 c7 88 a6 10 80 	mov    $0xffffffff8010a688,%rdi
ffffffff8010150a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010150f:	e8 8e f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, PCID);
ffffffff80101514:	8b 05 b2 ef 00 00    	mov    0xefb2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010151a:	25 00 00 02 00       	and    $0x20000,%eax
ffffffff8010151f:	85 c0                	test   %eax,%eax
ffffffff80101521:	74 11                	je     ffffffff80101534 <cpu_printfeatures+0x618>
ffffffff80101523:	48 c7 c7 8e a6 10 80 	mov    $0xffffffff8010a68e,%rdi
ffffffff8010152a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010152f:	e8 6e f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, DCA);
ffffffff80101534:	8b 05 92 ef 00 00    	mov    0xef92(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010153a:	25 00 00 04 00       	and    $0x40000,%eax
ffffffff8010153f:	85 c0                	test   %eax,%eax
ffffffff80101541:	74 11                	je     ffffffff80101554 <cpu_printfeatures+0x638>
ffffffff80101543:	48 c7 c7 94 a6 10 80 	mov    $0xffffffff8010a694,%rdi
ffffffff8010154a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010154f:	e8 4e f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, SSE4_1);
ffffffff80101554:	8b 05 72 ef 00 00    	mov    0xef72(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010155a:	25 00 00 08 00       	and    $0x80000,%eax
ffffffff8010155f:	85 c0                	test   %eax,%eax
ffffffff80101561:	74 11                	je     ffffffff80101574 <cpu_printfeatures+0x658>
ffffffff80101563:	48 c7 c7 99 a6 10 80 	mov    $0xffffffff8010a699,%rdi
ffffffff8010156a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010156f:	e8 2e f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, SSE4_2);
ffffffff80101574:	8b 05 52 ef 00 00    	mov    0xef52(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010157a:	25 00 00 10 00       	and    $0x100000,%eax
ffffffff8010157f:	85 c0                	test   %eax,%eax
ffffffff80101581:	74 11                	je     ffffffff80101594 <cpu_printfeatures+0x678>
ffffffff80101583:	48 c7 c7 a1 a6 10 80 	mov    $0xffffffff8010a6a1,%rdi
ffffffff8010158a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010158f:	e8 0e f0 ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, x2APIC);
ffffffff80101594:	8b 05 32 ef 00 00    	mov    0xef32(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010159a:	25 00 00 20 00       	and    $0x200000,%eax
ffffffff8010159f:	85 c0                	test   %eax,%eax
ffffffff801015a1:	74 11                	je     ffffffff801015b4 <cpu_printfeatures+0x698>
ffffffff801015a3:	48 c7 c7 a9 a6 10 80 	mov    $0xffffffff8010a6a9,%rdi
ffffffff801015aa:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801015af:	e8 ee ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, MOVBE);
ffffffff801015b4:	8b 05 12 ef 00 00    	mov    0xef12(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801015ba:	25 00 00 40 00       	and    $0x400000,%eax
ffffffff801015bf:	85 c0                	test   %eax,%eax
ffffffff801015c1:	74 11                	je     ffffffff801015d4 <cpu_printfeatures+0x6b8>
ffffffff801015c3:	48 c7 c7 b1 a6 10 80 	mov    $0xffffffff8010a6b1,%rdi
ffffffff801015ca:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801015cf:	e8 ce ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, POPCNT);
ffffffff801015d4:	8b 05 f2 ee 00 00    	mov    0xeef2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801015da:	25 00 00 80 00       	and    $0x800000,%eax
ffffffff801015df:	85 c0                	test   %eax,%eax
ffffffff801015e1:	74 11                	je     ffffffff801015f4 <cpu_printfeatures+0x6d8>
ffffffff801015e3:	48 c7 c7 b8 a6 10 80 	mov    $0xffffffff8010a6b8,%rdi
ffffffff801015ea:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801015ef:	e8 ae ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, TSCD);
ffffffff801015f4:	8b 05 d2 ee 00 00    	mov    0xeed2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801015fa:	25 00 00 00 01       	and    $0x1000000,%eax
ffffffff801015ff:	85 c0                	test   %eax,%eax
ffffffff80101601:	74 11                	je     ffffffff80101614 <cpu_printfeatures+0x6f8>
ffffffff80101603:	48 c7 c7 c0 a6 10 80 	mov    $0xffffffff8010a6c0,%rdi
ffffffff8010160a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010160f:	e8 8e ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, AESNI);
ffffffff80101614:	8b 05 b2 ee 00 00    	mov    0xeeb2(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010161a:	25 00 00 00 02       	and    $0x2000000,%eax
ffffffff8010161f:	85 c0                	test   %eax,%eax
ffffffff80101621:	74 11                	je     ffffffff80101634 <cpu_printfeatures+0x718>
ffffffff80101623:	48 c7 c7 c6 a6 10 80 	mov    $0xffffffff8010a6c6,%rdi
ffffffff8010162a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010162f:	e8 6e ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, XSAVE);
ffffffff80101634:	8b 05 92 ee 00 00    	mov    0xee92(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010163a:	25 00 00 00 04       	and    $0x4000000,%eax
ffffffff8010163f:	85 c0                	test   %eax,%eax
ffffffff80101641:	74 11                	je     ffffffff80101654 <cpu_printfeatures+0x738>
ffffffff80101643:	48 c7 c7 cd a6 10 80 	mov    $0xffffffff8010a6cd,%rdi
ffffffff8010164a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010164f:	e8 4e ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, OSXSAVE);
ffffffff80101654:	8b 05 72 ee 00 00    	mov    0xee72(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010165a:	25 00 00 00 08       	and    $0x8000000,%eax
ffffffff8010165f:	85 c0                	test   %eax,%eax
ffffffff80101661:	74 11                	je     ffffffff80101674 <cpu_printfeatures+0x758>
ffffffff80101663:	48 c7 c7 d4 a6 10 80 	mov    $0xffffffff8010a6d4,%rdi
ffffffff8010166a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010166f:	e8 2e ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, AVX);
ffffffff80101674:	8b 05 52 ee 00 00    	mov    0xee52(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010167a:	25 00 00 00 10       	and    $0x10000000,%eax
ffffffff8010167f:	85 c0                	test   %eax,%eax
ffffffff80101681:	74 11                	je     ffffffff80101694 <cpu_printfeatures+0x778>
ffffffff80101683:	48 c7 c7 dd a6 10 80 	mov    $0xffffffff8010a6dd,%rdi
ffffffff8010168a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010168f:	e8 0e ef ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, F16C);
ffffffff80101694:	8b 05 32 ee 00 00    	mov    0xee32(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff8010169a:	25 00 00 00 20       	and    $0x20000000,%eax
ffffffff8010169f:	85 c0                	test   %eax,%eax
ffffffff801016a1:	74 11                	je     ffffffff801016b4 <cpu_printfeatures+0x798>
ffffffff801016a3:	48 c7 c7 e2 a6 10 80 	mov    $0xffffffff8010a6e2,%rdi
ffffffff801016aa:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801016af:	e8 ee ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_FEATURE(featuresExt, RDRAND);
ffffffff801016b4:	8b 05 12 ee 00 00    	mov    0xee12(%rip),%eax        # ffffffff801104cc <featuresExt>
ffffffff801016ba:	25 00 00 00 40       	and    $0x40000000,%eax
ffffffff801016bf:	85 c0                	test   %eax,%eax
ffffffff801016c1:	74 11                	je     ffffffff801016d4 <cpu_printfeatures+0x7b8>
ffffffff801016c3:	48 c7 c7 e8 a6 10 80 	mov    $0xffffffff8010a6e8,%rdi
ffffffff801016ca:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801016cf:	e8 ce ee ff ff       	callq  ffffffff801005a2 <cprintf>
    cprintf("\n");
ffffffff801016d4:	48 c7 c7 f0 a6 10 80 	mov    $0xffffffff8010a6f0,%rdi
ffffffff801016db:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801016e0:	e8 bd ee ff ff       	callq  ffffffff801005a2 <cprintf>
  }

  if (maxleaf >= 7) {
ffffffff801016e5:	8b 05 c5 ed 00 00    	mov    0xedc5(%rip),%eax        # ffffffff801104b0 <maxleaf>
ffffffff801016eb:	83 f8 06             	cmp    $0x6,%eax
ffffffff801016ee:	0f 86 fc 00 00 00    	jbe    ffffffff801017f0 <cpu_printfeatures+0x8d4>
    cprintf("Structured Extended Features: ");
ffffffff801016f4:	48 c7 c7 f8 a6 10 80 	mov    $0xffffffff8010a6f8,%rdi
ffffffff801016fb:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101700:	e8 9d ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, FSGSBASE);
ffffffff80101705:	8b 05 c9 ed 00 00    	mov    0xedc9(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff8010170b:	83 e0 01             	and    $0x1,%eax
ffffffff8010170e:	85 c0                	test   %eax,%eax
ffffffff80101710:	74 11                	je     ffffffff80101723 <cpu_printfeatures+0x807>
ffffffff80101712:	48 c7 c7 17 a7 10 80 	mov    $0xffffffff8010a717,%rdi
ffffffff80101719:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010171e:	e8 7f ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, TAM);
ffffffff80101723:	8b 05 ab ed 00 00    	mov    0xedab(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff80101729:	83 e0 02             	and    $0x2,%eax
ffffffff8010172c:	85 c0                	test   %eax,%eax
ffffffff8010172e:	74 11                	je     ffffffff80101741 <cpu_printfeatures+0x825>
ffffffff80101730:	48 c7 c7 21 a7 10 80 	mov    $0xffffffff8010a721,%rdi
ffffffff80101737:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010173c:	e8 61 ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, SMEP);
ffffffff80101741:	8b 05 8d ed 00 00    	mov    0xed8d(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff80101747:	25 80 00 00 00       	and    $0x80,%eax
ffffffff8010174c:	85 c0                	test   %eax,%eax
ffffffff8010174e:	74 11                	je     ffffffff80101761 <cpu_printfeatures+0x845>
ffffffff80101750:	48 c7 c7 26 a7 10 80 	mov    $0xffffffff8010a726,%rdi
ffffffff80101757:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010175c:	e8 41 ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, EREP);
ffffffff80101761:	8b 05 6d ed 00 00    	mov    0xed6d(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff80101767:	25 00 02 00 00       	and    $0x200,%eax
ffffffff8010176c:	85 c0                	test   %eax,%eax
ffffffff8010176e:	74 11                	je     ffffffff80101781 <cpu_printfeatures+0x865>
ffffffff80101770:	48 c7 c7 2c a7 10 80 	mov    $0xffffffff8010a72c,%rdi
ffffffff80101777:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010177c:	e8 21 ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, INVPCID);
ffffffff80101781:	8b 05 4d ed 00 00    	mov    0xed4d(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff80101787:	25 00 04 00 00       	and    $0x400,%eax
ffffffff8010178c:	85 c0                	test   %eax,%eax
ffffffff8010178e:	74 11                	je     ffffffff801017a1 <cpu_printfeatures+0x885>
ffffffff80101790:	48 c7 c7 32 a7 10 80 	mov    $0xffffffff8010a732,%rdi
ffffffff80101797:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010179c:	e8 01 ee ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, QM);
ffffffff801017a1:	8b 05 2d ed 00 00    	mov    0xed2d(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff801017a7:	83 e0 01             	and    $0x1,%eax
ffffffff801017aa:	85 c0                	test   %eax,%eax
ffffffff801017ac:	74 11                	je     ffffffff801017bf <cpu_printfeatures+0x8a3>
ffffffff801017ae:	48 c7 c7 3b a7 10 80 	mov    $0xffffffff8010a73b,%rdi
ffffffff801017b5:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801017ba:	e8 e3 ed ff ff       	callq  ffffffff801005a2 <cprintf>
    PRINT_SEFEATURE(sef_flags, FPUCS);
ffffffff801017bf:	8b 05 0f ed 00 00    	mov    0xed0f(%rip),%eax        # ffffffff801104d4 <sef_flags>
ffffffff801017c5:	25 00 20 00 00       	and    $0x2000,%eax
ffffffff801017ca:	85 c0                	test   %eax,%eax
ffffffff801017cc:	74 11                	je     ffffffff801017df <cpu_printfeatures+0x8c3>
ffffffff801017ce:	48 c7 c7 3f a7 10 80 	mov    $0xffffffff8010a73f,%rdi
ffffffff801017d5:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801017da:	e8 c3 ed ff ff       	callq  ffffffff801005a2 <cprintf>
    cprintf("\n");
ffffffff801017df:	48 c7 c7 f0 a6 10 80 	mov    $0xffffffff8010a6f0,%rdi
ffffffff801017e6:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801017eb:	e8 b2 ed ff ff       	callq  ffffffff801005a2 <cprintf>
  }
}
ffffffff801017f0:	90                   	nop
ffffffff801017f1:	c9                   	leaveq 
ffffffff801017f2:	c3                   	retq   

ffffffff801017f3 <cpuinfo>:

static void
cpuinfo(void)
{
ffffffff801017f3:	55                   	push   %rbp
ffffffff801017f4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801017f7:	53                   	push   %rbx
ffffffff801017f8:	48 83 ec 10          	sub    $0x10,%rsp
  // check for CPUID support by setting and clearing ID (bit 21) in EFLAGS

  // When EAX=0, the processor returns the highest value (maxleaf) recognized for processor information
  asm("cpuid" : "=a"(maxleaf), "=b"(vendor[0]), "=c"(vendor[2]), "=d"(vendor[1]) : "a" (0) :);
ffffffff801017fc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101801:	0f a2                	cpuid  
ffffffff80101803:	89 de                	mov    %ebx,%esi
ffffffff80101805:	89 05 a5 ec 00 00    	mov    %eax,0xeca5(%rip)        # ffffffff801104b0 <maxleaf>
ffffffff8010180b:	89 35 a7 ec 00 00    	mov    %esi,0xeca7(%rip)        # ffffffff801104b8 <vendor>
ffffffff80101811:	89 0d a9 ec 00 00    	mov    %ecx,0xeca9(%rip)        # ffffffff801104c0 <vendor+0x8>
ffffffff80101817:	89 15 9f ec 00 00    	mov    %edx,0xec9f(%rip)        # ffffffff801104bc <vendor+0x4>


  if (maxleaf >= 1) {
ffffffff8010181d:	8b 05 8d ec 00 00    	mov    0xec8d(%rip),%eax        # ffffffff801104b0 <maxleaf>
ffffffff80101823:	85 c0                	test   %eax,%eax
ffffffff80101825:	74 21                	je     ffffffff80101848 <cpuinfo+0x55>
    // get model, family, stepping info
    asm("cpuid" : "=a"(version), "=b"(processor), "=c"(featuresExt), "=d"(features) : "a" (1) :);
ffffffff80101827:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff8010182c:	0f a2                	cpuid  
ffffffff8010182e:	89 de                	mov    %ebx,%esi
ffffffff80101830:	89 05 8e ec 00 00    	mov    %eax,0xec8e(%rip)        # ffffffff801104c4 <version>
ffffffff80101836:	89 35 8c ec 00 00    	mov    %esi,0xec8c(%rip)        # ffffffff801104c8 <processor>
ffffffff8010183c:	89 0d 8a ec 00 00    	mov    %ecx,0xec8a(%rip)        # ffffffff801104cc <featuresExt>
ffffffff80101842:	89 15 88 ec 00 00    	mov    %edx,0xec88(%rip)        # ffffffff801104d0 <features>

  if (maxleaf >= 6) {
    // thermal and power management
  }

  if (maxleaf >= 7) {
ffffffff80101848:	8b 05 62 ec 00 00    	mov    0xec62(%rip),%eax        # ffffffff801104b0 <maxleaf>
ffffffff8010184e:	83 f8 06             	cmp    $0x6,%eax
ffffffff80101851:	76 19                	jbe    ffffffff8010186c <cpuinfo+0x79>
    // structured extended feature flags (ECX=0)
    uint maxsubleaf;
    asm("cpuid" : "=a"(maxsubleaf), "=b"(sef_flags) : "a" (7), "c" (0) :);
ffffffff80101853:	b8 07 00 00 00       	mov    $0x7,%eax
ffffffff80101858:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff8010185d:	89 d1                	mov    %edx,%ecx
ffffffff8010185f:	0f a2                	cpuid  
ffffffff80101861:	89 da                	mov    %ebx,%edx
ffffffff80101863:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffffffff80101866:	89 15 68 ec 00 00    	mov    %edx,0xec68(%rip)        # ffffffff801104d4 <sef_flags>
  }

  /* ... and many more ... */
}
ffffffff8010186c:	90                   	nop
ffffffff8010186d:	48 83 c4 10          	add    $0x10,%rsp
ffffffff80101871:	5b                   	pop    %rbx
ffffffff80101872:	5d                   	pop    %rbp
ffffffff80101873:	c3                   	retq   

ffffffff80101874 <cpuid_read>:

static int cpuid_read(struct inode* i, char* buf, int count)
{
ffffffff80101874:	55                   	push   %rbp
ffffffff80101875:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101878:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010187c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80101880:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff80101884:	89 55 ec             	mov    %edx,-0x14(%rbp)
   cpu_printfeatures();
ffffffff80101887:	e8 90 f6 ff ff       	callq  ffffffff80100f1c <cpu_printfeatures>

   return 0;
ffffffff8010188c:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80101891:	c9                   	leaveq 
ffffffff80101892:	c3                   	retq   

ffffffff80101893 <cpuid_write>:

static int cpuid_write(struct inode* i, char* buf, int count)
{
ffffffff80101893:	55                   	push   %rbp
ffffffff80101894:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101897:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010189b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff8010189f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff801018a3:	89 55 ec             	mov    %edx,-0x14(%rbp)
   cprintf("cpuid_write\n");
ffffffff801018a6:	48 c7 c7 46 a7 10 80 	mov    $0xffffffff8010a746,%rdi
ffffffff801018ad:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801018b2:	e8 eb ec ff ff       	callq  ffffffff801005a2 <cprintf>
   return 0;
ffffffff801018b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801018bc:	c9                   	leaveq 
ffffffff801018bd:	c3                   	retq   

ffffffff801018be <cpuidinit>:

void
cpuidinit(void)
{
ffffffff801018be:	55                   	push   %rbp
ffffffff801018bf:	48 89 e5             	mov    %rsp,%rbp
  devsw[CPUID].write = cpuid_write;
ffffffff801018c2:	48 c7 05 3b ec 00 00 	movq   $0xffffffff80101893,0xec3b(%rip)        # ffffffff80110508 <devsw+0x28>
ffffffff801018c9:	93 18 10 80 
  devsw[CPUID].read = cpuid_read;
ffffffff801018cd:	48 c7 05 28 ec 00 00 	movq   $0xffffffff80101874,0xec28(%rip)        # ffffffff80110500 <devsw+0x20>
ffffffff801018d4:	74 18 10 80 

  cpuinfo();
ffffffff801018d8:	e8 16 ff ff ff       	callq  ffffffff801017f3 <cpuinfo>
}
ffffffff801018dd:	90                   	nop
ffffffff801018de:	5d                   	pop    %rbp
ffffffff801018df:	c3                   	retq   

ffffffff801018e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
ffffffff801018e0:	55                   	push   %rbp
ffffffff801018e1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801018e4:	48 81 ec 00 02 00 00 	sub    $0x200,%rsp
ffffffff801018eb:	48 89 bd 08 fe ff ff 	mov    %rdi,-0x1f8(%rbp)
ffffffff801018f2:	48 89 b5 00 fe ff ff 	mov    %rsi,-0x200(%rbp)
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
ffffffff801018f9:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801018fe:	e8 be 2d 00 00       	callq  ffffffff801046c1 <begin_op>
  if((ip = namei(path)) == 0){
ffffffff80101903:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffffffff8010190a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010190d:	e8 5e 1c 00 00       	callq  ffffffff80103570 <namei>
ffffffff80101912:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
ffffffff80101916:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffffffff8010191b:	75 14                	jne    ffffffff80101931 <exec+0x51>
    end_op();
ffffffff8010191d:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101922:	e8 1c 2e 00 00       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80101927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010192c:	e9 d6 04 00 00       	jmpq   ffffffff80101e07 <exec+0x527>
  }
  ilock(ip);
ffffffff80101931:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101935:	48 89 c7             	mov    %rax,%rdi
ffffffff80101938:	e8 07 0f 00 00       	callq  ffffffff80102844 <ilock>
  pgdir = 0;
ffffffff8010193d:	48 c7 45 c0 00 00 00 	movq   $0x0,-0x40(%rbp)
ffffffff80101944:	00 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
ffffffff80101945:	48 8d b5 50 fe ff ff 	lea    -0x1b0(%rbp),%rsi
ffffffff8010194c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101950:	b9 40 00 00 00       	mov    $0x40,%ecx
ffffffff80101955:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff8010195a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010195d:	e8 ed 14 00 00       	callq  ffffffff80102e4f <readi>
ffffffff80101962:	83 f8 3f             	cmp    $0x3f,%eax
ffffffff80101965:	0f 86 48 04 00 00    	jbe    ffffffff80101db3 <exec+0x4d3>
    goto bad;
  if(elf.magic != ELF_MAGIC)
ffffffff8010196b:	8b 85 50 fe ff ff    	mov    -0x1b0(%rbp),%eax
ffffffff80101971:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
ffffffff80101976:	0f 85 3a 04 00 00    	jne    ffffffff80101db6 <exec+0x4d6>
    goto bad;

  if((pgdir = setupkvm()) == 0)
ffffffff8010197c:	e8 f6 87 00 00       	callq  ffffffff8010a177 <setupkvm>
ffffffff80101981:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffffffff80101985:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffffffff8010198a:	0f 84 29 04 00 00    	je     ffffffff80101db9 <exec+0x4d9>
    goto bad;

  // Load program into memory.
  sz = 0;
ffffffff80101990:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
ffffffff80101997:	00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffffffff80101998:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffffffff8010199f:	48 8b 85 70 fe ff ff 	mov    -0x190(%rbp),%rax
ffffffff801019a6:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffffffff801019a9:	e9 c8 00 00 00       	jmpq   ffffffff80101a76 <exec+0x196>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
ffffffff801019ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801019b1:	48 8d b5 10 fe ff ff 	lea    -0x1f0(%rbp),%rsi
ffffffff801019b8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801019bc:	b9 38 00 00 00       	mov    $0x38,%ecx
ffffffff801019c1:	48 89 c7             	mov    %rax,%rdi
ffffffff801019c4:	e8 86 14 00 00       	callq  ffffffff80102e4f <readi>
ffffffff801019c9:	83 f8 38             	cmp    $0x38,%eax
ffffffff801019cc:	0f 85 ea 03 00 00    	jne    ffffffff80101dbc <exec+0x4dc>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
ffffffff801019d2:	8b 85 10 fe ff ff    	mov    -0x1f0(%rbp),%eax
ffffffff801019d8:	83 f8 01             	cmp    $0x1,%eax
ffffffff801019db:	0f 85 87 00 00 00    	jne    ffffffff80101a68 <exec+0x188>
      continue;
    if(ph.memsz < ph.filesz)
ffffffff801019e1:	48 8b 95 38 fe ff ff 	mov    -0x1c8(%rbp),%rdx
ffffffff801019e8:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffffffff801019ef:	48 39 c2             	cmp    %rax,%rdx
ffffffff801019f2:	0f 82 c7 03 00 00    	jb     ffffffff80101dbf <exec+0x4df>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
ffffffff801019f8:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffffffff801019ff:	89 c2                	mov    %eax,%edx
ffffffff80101a01:	48 8b 85 38 fe ff ff 	mov    -0x1c8(%rbp),%rax
ffffffff80101a08:	01 c2                	add    %eax,%edx
ffffffff80101a0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101a0e:	89 c1                	mov    %eax,%ecx
ffffffff80101a10:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101a14:	89 ce                	mov    %ecx,%esi
ffffffff80101a16:	48 89 c7             	mov    %rax,%rdi
ffffffff80101a19:	e8 e8 7d 00 00       	callq  ffffffff80109806 <allocuvm>
ffffffff80101a1e:	48 98                	cltq   
ffffffff80101a20:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffffffff80101a24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffffffff80101a29:	0f 84 93 03 00 00    	je     ffffffff80101dc2 <exec+0x4e2>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
ffffffff80101a2f:	48 8b 85 30 fe ff ff 	mov    -0x1d0(%rbp),%rax
ffffffff80101a36:	89 c7                	mov    %eax,%edi
ffffffff80101a38:	48 8b 85 18 fe ff ff 	mov    -0x1e8(%rbp),%rax
ffffffff80101a3f:	89 c1                	mov    %eax,%ecx
ffffffff80101a41:	48 8b 85 20 fe ff ff 	mov    -0x1e0(%rbp),%rax
ffffffff80101a48:	48 89 c6             	mov    %rax,%rsi
ffffffff80101a4b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffffffff80101a4f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101a53:	41 89 f8             	mov    %edi,%r8d
ffffffff80101a56:	48 89 c7             	mov    %rax,%rdi
ffffffff80101a59:	e8 ad 7c 00 00       	callq  ffffffff8010970b <loaduvm>
ffffffff80101a5e:	85 c0                	test   %eax,%eax
ffffffff80101a60:	0f 88 5f 03 00 00    	js     ffffffff80101dc5 <exec+0x4e5>
ffffffff80101a66:	eb 01                	jmp    ffffffff80101a69 <exec+0x189>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
ffffffff80101a68:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
ffffffff80101a69:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffffffff80101a6d:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff80101a70:	83 c0 38             	add    $0x38,%eax
ffffffff80101a73:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffffffff80101a76:	0f b7 85 88 fe ff ff 	movzwl -0x178(%rbp),%eax
ffffffff80101a7d:	0f b7 c0             	movzwl %ax,%eax
ffffffff80101a80:	3b 45 ec             	cmp    -0x14(%rbp),%eax
ffffffff80101a83:	0f 8f 25 ff ff ff    	jg     ffffffff801019ae <exec+0xce>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
ffffffff80101a89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101a8d:	48 89 c7             	mov    %rax,%rdi
ffffffff80101a90:	e8 a5 10 00 00       	callq  ffffffff80102b3a <iunlockput>
  end_op();
ffffffff80101a95:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101a9a:	e8 a4 2c 00 00       	callq  ffffffff80104743 <end_op>
  ip = 0;
ffffffff80101a9f:	48 c7 45 c8 00 00 00 	movq   $0x0,-0x38(%rbp)
ffffffff80101aa6:	00 

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  // The first page is used as a guarded page to limit the stack's memory to one page
  // As the first page isn't used and thus accessing it would cause an exception.
  sz = PGROUNDUP(sz);
ffffffff80101aa7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101aab:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff80101ab1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80101ab7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
ffffffff80101abb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101abf:	8d 90 00 20 00 00    	lea    0x2000(%rax),%edx
ffffffff80101ac5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101ac9:	89 c1                	mov    %eax,%ecx
ffffffff80101acb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101acf:	89 ce                	mov    %ecx,%esi
ffffffff80101ad1:	48 89 c7             	mov    %rax,%rdi
ffffffff80101ad4:	e8 2d 7d 00 00       	callq  ffffffff80109806 <allocuvm>
ffffffff80101ad9:	48 98                	cltq   
ffffffff80101adb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffffffff80101adf:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffffffff80101ae4:	0f 84 de 02 00 00    	je     ffffffff80101dc8 <exec+0x4e8>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
ffffffff80101aea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101aee:	48 2d 00 20 00 00    	sub    $0x2000,%rax
ffffffff80101af4:	48 89 c2             	mov    %rax,%rdx
ffffffff80101af7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101afb:	48 89 d6             	mov    %rdx,%rsi
ffffffff80101afe:	48 89 c7             	mov    %rax,%rdi
ffffffff80101b01:	e8 61 7f 00 00       	callq  ffffffff80109a67 <clearpteu>
  sp = sz;
ffffffff80101b06:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80101b0a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffffffff80101b0e:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
ffffffff80101b15:	00 
ffffffff80101b16:	e9 b5 00 00 00       	jmpq   ffffffff80101bd0 <exec+0x2f0>
    if(argc >= MAXARG)
ffffffff80101b1b:	48 83 7d e0 1f       	cmpq   $0x1f,-0x20(%rbp)
ffffffff80101b20:	0f 87 a5 02 00 00    	ja     ffffffff80101dcb <exec+0x4eb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(uintp)-1);
ffffffff80101b26:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101b2a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80101b31:	00 
ffffffff80101b32:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffffffff80101b39:	48 01 d0             	add    %rdx,%rax
ffffffff80101b3c:	48 8b 00             	mov    (%rax),%rax
ffffffff80101b3f:	48 89 c7             	mov    %rax,%rdi
ffffffff80101b42:	e8 c8 54 00 00       	callq  ffffffff8010700f <strlen>
ffffffff80101b47:	83 c0 01             	add    $0x1,%eax
ffffffff80101b4a:	48 98                	cltq   
ffffffff80101b4c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffffffff80101b50:	48 29 c2             	sub    %rax,%rdx
ffffffff80101b53:	48 89 d0             	mov    %rdx,%rax
ffffffff80101b56:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
ffffffff80101b5a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
ffffffff80101b5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101b62:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80101b69:	00 
ffffffff80101b6a:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffffffff80101b71:	48 01 d0             	add    %rdx,%rax
ffffffff80101b74:	48 8b 00             	mov    (%rax),%rax
ffffffff80101b77:	48 89 c7             	mov    %rax,%rdi
ffffffff80101b7a:	e8 90 54 00 00       	callq  ffffffff8010700f <strlen>
ffffffff80101b7f:	83 c0 01             	add    $0x1,%eax
ffffffff80101b82:	89 c1                	mov    %eax,%ecx
ffffffff80101b84:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101b88:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80101b8f:	00 
ffffffff80101b90:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffffffff80101b97:	48 01 d0             	add    %rdx,%rax
ffffffff80101b9a:	48 8b 10             	mov    (%rax),%rdx
ffffffff80101b9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80101ba1:	89 c6                	mov    %eax,%esi
ffffffff80101ba3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101ba7:	48 89 c7             	mov    %rax,%rdi
ffffffff80101baa:	e8 be 80 00 00       	callq  ffffffff80109c6d <copyout>
ffffffff80101baf:	85 c0                	test   %eax,%eax
ffffffff80101bb1:	0f 88 17 02 00 00    	js     ffffffff80101dce <exec+0x4ee>
      goto bad;
    ustack[3+argc] = sp;
ffffffff80101bb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101bbb:	48 8d 50 03          	lea    0x3(%rax),%rdx
ffffffff80101bbf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80101bc3:	48 89 84 d5 90 fe ff 	mov    %rax,-0x170(%rbp,%rdx,8)
ffffffff80101bca:	ff 
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
ffffffff80101bcb:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
ffffffff80101bd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101bd4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80101bdb:	00 
ffffffff80101bdc:	48 8b 85 00 fe ff ff 	mov    -0x200(%rbp),%rax
ffffffff80101be3:	48 01 d0             	add    %rdx,%rax
ffffffff80101be6:	48 8b 00             	mov    (%rax),%rax
ffffffff80101be9:	48 85 c0             	test   %rax,%rax
ffffffff80101bec:	0f 85 29 ff ff ff    	jne    ffffffff80101b1b <exec+0x23b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(uintp)-1);
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
ffffffff80101bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101bf6:	48 83 c0 03          	add    $0x3,%rax
ffffffff80101bfa:	48 c7 84 c5 90 fe ff 	movq   $0x0,-0x170(%rbp,%rax,8)
ffffffff80101c01:	ff 00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
ffffffff80101c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80101c0b:	48 89 85 90 fe ff ff 	mov    %rax,-0x170(%rbp)
  ustack[1] = argc;
ffffffff80101c12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101c16:	48 89 85 98 fe ff ff 	mov    %rax,-0x168(%rbp)
  ustack[2] = sp - (argc+1)*sizeof(uintp);  // argv pointer
ffffffff80101c1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101c21:	48 83 c0 01          	add    $0x1,%rax
ffffffff80101c25:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80101c2c:	00 
ffffffff80101c2d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80101c31:	48 29 d0             	sub    %rdx,%rax
ffffffff80101c34:	48 89 85 a0 fe ff ff 	mov    %rax,-0x160(%rbp)

#if X64
  proc->tf->rdi = argc;
ffffffff80101c3b:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101c42:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101c46:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80101c4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff80101c4e:	48 89 50 30          	mov    %rdx,0x30(%rax)
  proc->tf->rsi = sp - (argc+1)*sizeof(uintp);
ffffffff80101c52:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101c59:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101c5d:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80101c61:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff80101c65:	48 83 c2 01          	add    $0x1,%rdx
ffffffff80101c69:	48 8d 0c d5 00 00 00 	lea    0x0(,%rdx,8),%rcx
ffffffff80101c70:	00 
ffffffff80101c71:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffffffff80101c75:	48 29 ca             	sub    %rcx,%rdx
ffffffff80101c78:	48 89 50 28          	mov    %rdx,0x28(%rax)
#endif

  sp -= (3+argc+1) * sizeof(uintp);
ffffffff80101c7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101c80:	48 83 c0 04          	add    $0x4,%rax
ffffffff80101c84:	48 c1 e0 03          	shl    $0x3,%rax
ffffffff80101c88:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(uintp)) < 0)
ffffffff80101c8c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101c90:	48 83 c0 04          	add    $0x4,%rax
ffffffff80101c94:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
ffffffff80101c9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80101c9f:	89 c6                	mov    %eax,%esi
ffffffff80101ca1:	48 8d 95 90 fe ff ff 	lea    -0x170(%rbp),%rdx
ffffffff80101ca8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101cac:	48 89 c7             	mov    %rax,%rdi
ffffffff80101caf:	e8 b9 7f 00 00       	callq  ffffffff80109c6d <copyout>
ffffffff80101cb4:	85 c0                	test   %eax,%eax
ffffffff80101cb6:	0f 88 15 01 00 00    	js     ffffffff80101dd1 <exec+0x4f1>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffffffff80101cbc:	48 8b 85 08 fe ff ff 	mov    -0x1f8(%rbp),%rax
ffffffff80101cc3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80101cc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101ccb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80101ccf:	eb 1c                	jmp    ffffffff80101ced <exec+0x40d>
    if(*s == '/')
ffffffff80101cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101cd5:	0f b6 00             	movzbl (%rax),%eax
ffffffff80101cd8:	3c 2f                	cmp    $0x2f,%al
ffffffff80101cda:	75 0c                	jne    ffffffff80101ce8 <exec+0x408>
      last = s+1;
ffffffff80101cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101ce0:	48 83 c0 01          	add    $0x1,%rax
ffffffff80101ce4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  sp -= (3+argc+1) * sizeof(uintp);
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(uintp)) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
ffffffff80101ce8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffffffff80101ced:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101cf1:	0f b6 00             	movzbl (%rax),%eax
ffffffff80101cf4:	84 c0                	test   %al,%al
ffffffff80101cf6:	75 d9                	jne    ffffffff80101cd1 <exec+0x3f1>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
ffffffff80101cf8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101cff:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d03:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffffffff80101d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80101d0e:	ba 10 00 00 00       	mov    $0x10,%edx
ffffffff80101d13:	48 89 c6             	mov    %rax,%rsi
ffffffff80101d16:	48 89 cf             	mov    %rcx,%rdi
ffffffff80101d19:	e8 8f 52 00 00       	callq  ffffffff80106fad <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
ffffffff80101d1e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d25:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d29:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80101d2d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  proc->pgdir = pgdir;
ffffffff80101d31:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d38:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d3c:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
ffffffff80101d40:	48 89 50 08          	mov    %rdx,0x8(%rax)
  proc->sz = sz;
ffffffff80101d44:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d4b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80101d53:	48 89 10             	mov    %rdx,(%rax)
  proc->tf->eip = elf.entry;  // main
ffffffff80101d56:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d5d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d61:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80101d65:	48 8b 95 68 fe ff ff 	mov    -0x198(%rbp),%rdx
ffffffff80101d6c:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
  proc->tf->esp = sp;
ffffffff80101d73:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d7a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d7e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80101d82:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffffffff80101d86:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
  switchuvm(proc);
ffffffff80101d8d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80101d94:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80101d98:	48 89 c7             	mov    %rax,%rdi
ffffffff80101d9b:	e8 aa 86 00 00       	callq  ffffffff8010a44a <switchuvm>
  freevm(oldpgdir);
ffffffff80101da0:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80101da4:	48 89 c7             	mov    %rax,%rdi
ffffffff80101da7:	e8 11 7c 00 00       	callq  ffffffff801099bd <freevm>
  return 0;
ffffffff80101dac:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101db1:	eb 54                	jmp    ffffffff80101e07 <exec+0x527>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
ffffffff80101db3:	90                   	nop
ffffffff80101db4:	eb 1c                	jmp    ffffffff80101dd2 <exec+0x4f2>
  if(elf.magic != ELF_MAGIC)
    goto bad;
ffffffff80101db6:	90                   	nop
ffffffff80101db7:	eb 19                	jmp    ffffffff80101dd2 <exec+0x4f2>

  if((pgdir = setupkvm()) == 0)
    goto bad;
ffffffff80101db9:	90                   	nop
ffffffff80101dba:	eb 16                	jmp    ffffffff80101dd2 <exec+0x4f2>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
ffffffff80101dbc:	90                   	nop
ffffffff80101dbd:	eb 13                	jmp    ffffffff80101dd2 <exec+0x4f2>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
ffffffff80101dbf:	90                   	nop
ffffffff80101dc0:	eb 10                	jmp    ffffffff80101dd2 <exec+0x4f2>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
ffffffff80101dc2:	90                   	nop
ffffffff80101dc3:	eb 0d                	jmp    ffffffff80101dd2 <exec+0x4f2>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
ffffffff80101dc5:	90                   	nop
ffffffff80101dc6:	eb 0a                	jmp    ffffffff80101dd2 <exec+0x4f2>
  // Make the first inaccessible.  Use the second as the user stack.
  // The first page is used as a guarded page to limit the stack's memory to one page
  // As the first page isn't used and thus accessing it would cause an exception.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
ffffffff80101dc8:	90                   	nop
ffffffff80101dc9:	eb 07                	jmp    ffffffff80101dd2 <exec+0x4f2>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
ffffffff80101dcb:	90                   	nop
ffffffff80101dcc:	eb 04                	jmp    ffffffff80101dd2 <exec+0x4f2>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~(sizeof(uintp)-1);
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
ffffffff80101dce:	90                   	nop
ffffffff80101dcf:	eb 01                	jmp    ffffffff80101dd2 <exec+0x4f2>
  proc->tf->rsi = sp - (argc+1)*sizeof(uintp);
#endif

  sp -= (3+argc+1) * sizeof(uintp);
  if(copyout(pgdir, sp, ustack, (3+argc+1)*sizeof(uintp)) < 0)
    goto bad;
ffffffff80101dd1:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
ffffffff80101dd2:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffffffff80101dd7:	74 0c                	je     ffffffff80101de5 <exec+0x505>
    freevm(pgdir);
ffffffff80101dd9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80101ddd:	48 89 c7             	mov    %rax,%rdi
ffffffff80101de0:	e8 d8 7b 00 00       	callq  ffffffff801099bd <freevm>
  if(ip){
ffffffff80101de5:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffffffff80101dea:	74 16                	je     ffffffff80101e02 <exec+0x522>
    iunlockput(ip);
ffffffff80101dec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101df0:	48 89 c7             	mov    %rax,%rdi
ffffffff80101df3:	e8 42 0d 00 00       	callq  ffffffff80102b3a <iunlockput>
    end_op();
ffffffff80101df8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101dfd:	e8 41 29 00 00       	callq  ffffffff80104743 <end_op>
  }
  return -1;
ffffffff80101e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff80101e07:	c9                   	leaveq 
ffffffff80101e08:	c3                   	retq   

ffffffff80101e09 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
ffffffff80101e09:	55                   	push   %rbp
ffffffff80101e0a:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ftable.lock, "ftable");
ffffffff80101e0d:	48 c7 c6 53 a7 10 80 	mov    $0xffffffff8010a753,%rsi
ffffffff80101e14:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101e1b:	e8 4e 4b 00 00       	callq  ffffffff8010696e <initlock>
}
ffffffff80101e20:	90                   	nop
ffffffff80101e21:	5d                   	pop    %rbp
ffffffff80101e22:	c3                   	retq   

ffffffff80101e23 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
ffffffff80101e23:	55                   	push   %rbp
ffffffff80101e24:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101e27:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;

  acquire(&ftable.lock);
ffffffff80101e2b:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101e32:	e8 6c 4b 00 00       	callq  ffffffff801069a3 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffffffff80101e37:	48 c7 45 f8 e8 05 11 	movq   $0xffffffff801105e8,-0x8(%rbp)
ffffffff80101e3e:	80 
ffffffff80101e3f:	eb 2d                	jmp    ffffffff80101e6e <filealloc+0x4b>
    if(f->ref == 0){
ffffffff80101e41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101e45:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101e48:	85 c0                	test   %eax,%eax
ffffffff80101e4a:	75 1d                	jne    ffffffff80101e69 <filealloc+0x46>
      f->ref = 1;
ffffffff80101e4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101e50:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%rax)
      release(&ftable.lock);
ffffffff80101e57:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101e5e:	e8 17 4c 00 00       	callq  ffffffff80106a7a <release>
      return f;
ffffffff80101e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101e67:	eb 23                	jmp    ffffffff80101e8c <filealloc+0x69>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
ffffffff80101e69:	48 83 45 f8 28       	addq   $0x28,-0x8(%rbp)
ffffffff80101e6e:	48 c7 c0 88 15 11 80 	mov    $0xffffffff80111588,%rax
ffffffff80101e75:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
ffffffff80101e79:	72 c6                	jb     ffffffff80101e41 <filealloc+0x1e>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
ffffffff80101e7b:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101e82:	e8 f3 4b 00 00       	callq  ffffffff80106a7a <release>
  return 0;
ffffffff80101e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80101e8c:	c9                   	leaveq 
ffffffff80101e8d:	c3                   	retq   

ffffffff80101e8e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
ffffffff80101e8e:	55                   	push   %rbp
ffffffff80101e8f:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101e92:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80101e96:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ftable.lock);
ffffffff80101e9a:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101ea1:	e8 fd 4a 00 00       	callq  ffffffff801069a3 <acquire>
  if(f->ref < 1)
ffffffff80101ea6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101eaa:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101ead:	85 c0                	test   %eax,%eax
ffffffff80101eaf:	7f 0c                	jg     ffffffff80101ebd <filedup+0x2f>
    panic("filedup");
ffffffff80101eb1:	48 c7 c7 5a a7 10 80 	mov    $0xffffffff8010a75a,%rdi
ffffffff80101eb8:	e8 42 ea ff ff       	callq  ffffffff801008ff <panic>
  f->ref++;
ffffffff80101ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101ec1:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101ec4:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80101ec7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101ecb:	89 50 04             	mov    %edx,0x4(%rax)
  release(&ftable.lock);
ffffffff80101ece:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101ed5:	e8 a0 4b 00 00       	callq  ffffffff80106a7a <release>
  return f;
ffffffff80101eda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80101ede:	c9                   	leaveq 
ffffffff80101edf:	c3                   	retq   

ffffffff80101ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
ffffffff80101ee0:	55                   	push   %rbp
ffffffff80101ee1:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101ee4:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff80101ee8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  struct file ff;

  acquire(&ftable.lock);
ffffffff80101eec:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101ef3:	e8 ab 4a 00 00       	callq  ffffffff801069a3 <acquire>
  if(f->ref < 1)
ffffffff80101ef8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101efc:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101eff:	85 c0                	test   %eax,%eax
ffffffff80101f01:	7f 0c                	jg     ffffffff80101f0f <fileclose+0x2f>
    panic("fileclose");
ffffffff80101f03:	48 c7 c7 62 a7 10 80 	mov    $0xffffffff8010a762,%rdi
ffffffff80101f0a:	e8 f0 e9 ff ff       	callq  ffffffff801008ff <panic>
  if(--f->ref > 0){
ffffffff80101f0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f13:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101f16:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80101f19:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f1d:	89 50 04             	mov    %edx,0x4(%rax)
ffffffff80101f20:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f24:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80101f27:	85 c0                	test   %eax,%eax
ffffffff80101f29:	7e 11                	jle    ffffffff80101f3c <fileclose+0x5c>
    release(&ftable.lock);
ffffffff80101f2b:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101f32:	e8 43 4b 00 00       	callq  ffffffff80106a7a <release>
ffffffff80101f37:	e9 93 00 00 00       	jmpq   ffffffff80101fcf <fileclose+0xef>
    return;
  }
  ff = *f;
ffffffff80101f3c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f40:	48 8b 10             	mov    (%rax),%rdx
ffffffff80101f43:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
ffffffff80101f47:	48 8b 50 08          	mov    0x8(%rax),%rdx
ffffffff80101f4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffffffff80101f4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffffffff80101f53:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
ffffffff80101f57:	48 8b 50 18          	mov    0x18(%rax),%rdx
ffffffff80101f5b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffffffff80101f5f:	48 8b 40 20          	mov    0x20(%rax),%rax
ffffffff80101f63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  f->ref = 0;
ffffffff80101f67:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
  f->type = FD_NONE;
ffffffff80101f72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80101f76:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  release(&ftable.lock);
ffffffff80101f7c:	48 c7 c7 80 05 11 80 	mov    $0xffffffff80110580,%rdi
ffffffff80101f83:	e8 f2 4a 00 00       	callq  ffffffff80106a7a <release>
  
  if(ff.type == FD_PIPE)
ffffffff80101f88:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffffffff80101f8b:	83 f8 01             	cmp    $0x1,%eax
ffffffff80101f8e:	75 17                	jne    ffffffff80101fa7 <fileclose+0xc7>
    pipeclose(ff.pipe, ff.writable);
ffffffff80101f90:	0f b6 45 d9          	movzbl -0x27(%rbp),%eax
ffffffff80101f94:	0f be d0             	movsbl %al,%edx
ffffffff80101f97:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80101f9b:	89 d6                	mov    %edx,%esi
ffffffff80101f9d:	48 89 c7             	mov    %rax,%rdi
ffffffff80101fa0:	e8 af 39 00 00       	callq  ffffffff80105954 <pipeclose>
ffffffff80101fa5:	eb 28                	jmp    ffffffff80101fcf <fileclose+0xef>
  else if(ff.type == FD_INODE){
ffffffff80101fa7:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffffffff80101faa:	83 f8 02             	cmp    $0x2,%eax
ffffffff80101fad:	75 20                	jne    ffffffff80101fcf <fileclose+0xef>
    begin_op();
ffffffff80101faf:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101fb4:	e8 08 27 00 00       	callq  ffffffff801046c1 <begin_op>
    iput(ff.ip);
ffffffff80101fb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80101fbd:	48 89 c7             	mov    %rax,%rdi
ffffffff80101fc0:	e8 90 0a 00 00       	callq  ffffffff80102a55 <iput>
    end_op();
ffffffff80101fc5:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80101fca:	e8 74 27 00 00       	callq  ffffffff80104743 <end_op>
  }
}
ffffffff80101fcf:	c9                   	leaveq 
ffffffff80101fd0:	c3                   	retq   

ffffffff80101fd1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
ffffffff80101fd1:	55                   	push   %rbp
ffffffff80101fd2:	48 89 e5             	mov    %rsp,%rbp
ffffffff80101fd5:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80101fd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80101fdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(f->type == FD_INODE){
ffffffff80101fe1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101fe5:	8b 00                	mov    (%rax),%eax
ffffffff80101fe7:	83 f8 02             	cmp    $0x2,%eax
ffffffff80101fea:	75 3e                	jne    ffffffff8010202a <filestat+0x59>
    ilock(f->ip);
ffffffff80101fec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80101ff0:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff80101ff4:	48 89 c7             	mov    %rax,%rdi
ffffffff80101ff7:	e8 48 08 00 00       	callq  ffffffff80102844 <ilock>
    stati(f->ip, st);
ffffffff80101ffc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102000:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff80102004:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80102008:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010200b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010200e:	e8 b1 0d 00 00       	callq  ffffffff80102dc4 <stati>
    iunlock(f->ip);
ffffffff80102013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102017:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff8010201b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010201e:	e8 c0 09 00 00       	callq  ffffffff801029e3 <iunlock>
    return 0;
ffffffff80102023:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80102028:	eb 05                	jmp    ffffffff8010202f <filestat+0x5e>
  }
  return -1;
ffffffff8010202a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff8010202f:	c9                   	leaveq 
ffffffff80102030:	c3                   	retq   

ffffffff80102031 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
ffffffff80102031:	55                   	push   %rbp
ffffffff80102032:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102035:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80102039:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff8010203d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80102041:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->readable == 0)
ffffffff80102044:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102048:	0f b6 40 08          	movzbl 0x8(%rax),%eax
ffffffff8010204c:	84 c0                	test   %al,%al
ffffffff8010204e:	75 0a                	jne    ffffffff8010205a <fileread+0x29>
    return -1;
ffffffff80102050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80102055:	e9 9d 00 00 00       	jmpq   ffffffff801020f7 <fileread+0xc6>
  if(f->type == FD_PIPE)
ffffffff8010205a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010205e:	8b 00                	mov    (%rax),%eax
ffffffff80102060:	83 f8 01             	cmp    $0x1,%eax
ffffffff80102063:	75 1c                	jne    ffffffff80102081 <fileread+0x50>
    return piperead(f->pipe, addr, n);
ffffffff80102065:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102069:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8010206d:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffffffff80102070:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffffffff80102074:	48 89 ce             	mov    %rcx,%rsi
ffffffff80102077:	48 89 c7             	mov    %rax,%rdi
ffffffff8010207a:	e8 8e 3a 00 00       	callq  ffffffff80105b0d <piperead>
ffffffff8010207f:	eb 76                	jmp    ffffffff801020f7 <fileread+0xc6>
  if(f->type == FD_INODE){
ffffffff80102081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102085:	8b 00                	mov    (%rax),%eax
ffffffff80102087:	83 f8 02             	cmp    $0x2,%eax
ffffffff8010208a:	75 5f                	jne    ffffffff801020eb <fileread+0xba>
    ilock(f->ip);
ffffffff8010208c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102090:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff80102094:	48 89 c7             	mov    %rax,%rdi
ffffffff80102097:	e8 a8 07 00 00       	callq  ffffffff80102844 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
ffffffff8010209c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
ffffffff8010209f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801020a3:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff801020a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801020aa:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff801020ae:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
ffffffff801020b2:	48 89 c7             	mov    %rax,%rdi
ffffffff801020b5:	e8 95 0d 00 00       	callq  ffffffff80102e4f <readi>
ffffffff801020ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff801020bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff801020c1:	7e 13                	jle    ffffffff801020d6 <fileread+0xa5>
      f->off += r;
ffffffff801020c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801020c7:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff801020ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801020cd:	01 c2                	add    %eax,%edx
ffffffff801020cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801020d3:	89 50 20             	mov    %edx,0x20(%rax)
    iunlock(f->ip);
ffffffff801020d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801020da:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff801020de:	48 89 c7             	mov    %rax,%rdi
ffffffff801020e1:	e8 fd 08 00 00       	callq  ffffffff801029e3 <iunlock>
    return r;
ffffffff801020e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801020e9:	eb 0c                	jmp    ffffffff801020f7 <fileread+0xc6>
  }
  panic("fileread");
ffffffff801020eb:	48 c7 c7 6c a7 10 80 	mov    $0xffffffff8010a76c,%rdi
ffffffff801020f2:	e8 08 e8 ff ff       	callq  ffffffff801008ff <panic>
}
ffffffff801020f7:	c9                   	leaveq 
ffffffff801020f8:	c3                   	retq   

ffffffff801020f9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
ffffffff801020f9:	55                   	push   %rbp
ffffffff801020fa:	48 89 e5             	mov    %rsp,%rbp
ffffffff801020fd:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80102101:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80102105:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80102109:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int r;

  if(f->writable == 0)
ffffffff8010210c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102110:	0f b6 40 09          	movzbl 0x9(%rax),%eax
ffffffff80102114:	84 c0                	test   %al,%al
ffffffff80102116:	75 0a                	jne    ffffffff80102122 <filewrite+0x29>
    return -1;
ffffffff80102118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010211d:	e9 29 01 00 00       	jmpq   ffffffff8010224b <filewrite+0x152>
  if(f->type == FD_PIPE)
ffffffff80102122:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102126:	8b 00                	mov    (%rax),%eax
ffffffff80102128:	83 f8 01             	cmp    $0x1,%eax
ffffffff8010212b:	75 1f                	jne    ffffffff8010214c <filewrite+0x53>
    return pipewrite(f->pipe, addr, n);
ffffffff8010212d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102131:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff80102135:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffffffff80102138:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffffffff8010213c:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010213f:	48 89 c7             	mov    %rax,%rdi
ffffffff80102142:	e8 b5 38 00 00       	callq  ffffffff801059fc <pipewrite>
ffffffff80102147:	e9 ff 00 00 00       	jmpq   ffffffff8010224b <filewrite+0x152>
  if(f->type == FD_INODE){
ffffffff8010214c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102150:	8b 00                	mov    (%rax),%eax
ffffffff80102152:	83 f8 02             	cmp    $0x2,%eax
ffffffff80102155:	0f 85 e4 00 00 00    	jne    ffffffff8010223f <filewrite+0x146>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
ffffffff8010215b:	c7 45 f4 00 1a 00 00 	movl   $0x1a00,-0xc(%rbp)
    int i = 0;
ffffffff80102162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    while(i < n){
ffffffff80102169:	e9 ae 00 00 00       	jmpq   ffffffff8010221c <filewrite+0x123>
      int n1 = n - i;
ffffffff8010216e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80102171:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffffffff80102174:	89 45 f8             	mov    %eax,-0x8(%rbp)
      if(n1 > max)
ffffffff80102177:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff8010217a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffffffff8010217d:	7e 06                	jle    ffffffff80102185 <filewrite+0x8c>
        n1 = max;
ffffffff8010217f:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80102182:	89 45 f8             	mov    %eax,-0x8(%rbp)

      begin_op();
ffffffff80102185:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010218a:	e8 32 25 00 00       	callq  ffffffff801046c1 <begin_op>
      ilock(f->ip);
ffffffff8010218f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102193:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff80102197:	48 89 c7             	mov    %rax,%rdi
ffffffff8010219a:	e8 a5 06 00 00       	callq  ffffffff80102844 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
ffffffff8010219f:	8b 4d f8             	mov    -0x8(%rbp),%ecx
ffffffff801021a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801021a6:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff801021a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801021ac:	48 63 f0             	movslq %eax,%rsi
ffffffff801021af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801021b3:	48 01 c6             	add    %rax,%rsi
ffffffff801021b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801021ba:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff801021be:	48 89 c7             	mov    %rax,%rdi
ffffffff801021c1:	e8 09 0e 00 00       	callq  ffffffff80102fcf <writei>
ffffffff801021c6:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffffffff801021c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffffffff801021cd:	7e 13                	jle    ffffffff801021e2 <filewrite+0xe9>
        f->off += r;
ffffffff801021cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801021d3:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff801021d6:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff801021d9:	01 c2                	add    %eax,%edx
ffffffff801021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801021df:	89 50 20             	mov    %edx,0x20(%rax)
      iunlock(f->ip);
ffffffff801021e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801021e6:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff801021ea:	48 89 c7             	mov    %rax,%rdi
ffffffff801021ed:	e8 f1 07 00 00       	callq  ffffffff801029e3 <iunlock>
      end_op();
ffffffff801021f2:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801021f7:	e8 47 25 00 00       	callq  ffffffff80104743 <end_op>

      if(r < 0)
ffffffff801021fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
ffffffff80102200:	78 28                	js     ffffffff8010222a <filewrite+0x131>
        break;
      if(r != n1)
ffffffff80102202:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff80102205:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffffffff80102208:	74 0c                	je     ffffffff80102216 <filewrite+0x11d>
        panic("short filewrite");
ffffffff8010220a:	48 c7 c7 75 a7 10 80 	mov    $0xffffffff8010a775,%rdi
ffffffff80102211:	e8 e9 e6 ff ff       	callq  ffffffff801008ff <panic>
      i += r;
ffffffff80102216:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff80102219:	01 45 fc             	add    %eax,-0x4(%rbp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
ffffffff8010221c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010221f:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80102222:	0f 8c 46 ff ff ff    	jl     ffffffff8010216e <filewrite+0x75>
ffffffff80102228:	eb 01                	jmp    ffffffff8010222b <filewrite+0x132>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
ffffffff8010222a:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
ffffffff8010222b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010222e:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80102231:	75 05                	jne    ffffffff80102238 <filewrite+0x13f>
ffffffff80102233:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80102236:	eb 13                	jmp    ffffffff8010224b <filewrite+0x152>
ffffffff80102238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010223d:	eb 0c                	jmp    ffffffff8010224b <filewrite+0x152>
  }
  panic("filewrite");
ffffffff8010223f:	48 c7 c7 85 a7 10 80 	mov    $0xffffffff8010a785,%rdi
ffffffff80102246:	e8 b4 e6 ff ff       	callq  ffffffff801008ff <panic>
}
ffffffff8010224b:	c9                   	leaveq 
ffffffff8010224c:	c3                   	retq   

ffffffff8010224d <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
ffffffff8010224d:	55                   	push   %rbp
ffffffff8010224e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102251:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80102255:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff80102258:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct buf *bp;
  
  bp = bread(dev, 1);
ffffffff8010225c:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010225f:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80102264:	89 c7                	mov    %eax,%edi
ffffffff80102266:	e8 6b e0 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff8010226b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memmove(sb, bp->data, sizeof(*sb));
ffffffff8010226f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102273:	48 8d 48 28          	lea    0x28(%rax),%rcx
ffffffff80102277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010227b:	ba 10 00 00 00       	mov    $0x10,%edx
ffffffff80102280:	48 89 ce             	mov    %rcx,%rsi
ffffffff80102283:	48 89 c7             	mov    %rax,%rdi
ffffffff80102286:	e8 76 4b 00 00       	callq  ffffffff80106e01 <memmove>
  brelse(bp);
ffffffff8010228b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010228f:	48 89 c7             	mov    %rax,%rdi
ffffffff80102292:	e8 c4 e0 ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff80102297:	90                   	nop
ffffffff80102298:	c9                   	leaveq 
ffffffff80102299:	c3                   	retq   

ffffffff8010229a <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
ffffffff8010229a:	55                   	push   %rbp
ffffffff8010229b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010229e:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801022a2:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff801022a5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct buf *bp;
  
  bp = bread(dev, bno);
ffffffff801022a8:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801022ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801022ae:	89 d6                	mov    %edx,%esi
ffffffff801022b0:	89 c7                	mov    %eax,%edi
ffffffff801022b2:	e8 1f e0 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff801022b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(bp->data, 0, BSIZE);
ffffffff801022bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801022bf:	48 83 c0 28          	add    $0x28,%rax
ffffffff801022c3:	ba 00 02 00 00       	mov    $0x200,%edx
ffffffff801022c8:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801022cd:	48 89 c7             	mov    %rax,%rdi
ffffffff801022d0:	e8 3d 4a 00 00       	callq  ffffffff80106d12 <memset>
  log_write(bp);
ffffffff801022d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801022d9:	48 89 c7             	mov    %rax,%rdi
ffffffff801022dc:	e8 fd 25 00 00       	callq  ffffffff801048de <log_write>
  brelse(bp);
ffffffff801022e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801022e5:	48 89 c7             	mov    %rax,%rdi
ffffffff801022e8:	e8 6e e0 ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff801022ed:	90                   	nop
ffffffff801022ee:	c9                   	leaveq 
ffffffff801022ef:	c3                   	retq   

ffffffff801022f0 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
ffffffff801022f0:	55                   	push   %rbp
ffffffff801022f1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801022f4:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff801022f8:	89 7d cc             	mov    %edi,-0x34(%rbp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
ffffffff801022fb:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffffffff80102302:	00 
  readsb(dev, &sb);
ffffffff80102303:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102306:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
ffffffff8010230a:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010230d:	89 c7                	mov    %eax,%edi
ffffffff8010230f:	e8 39 ff ff ff       	callq  ffffffff8010224d <readsb>
  for(b = 0; b < sb.size; b += BPB){
ffffffff80102314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff8010231b:	e9 15 01 00 00       	jmpq   ffffffff80102435 <balloc+0x145>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
ffffffff80102320:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80102323:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
ffffffff80102329:	85 c0                	test   %eax,%eax
ffffffff8010232b:	0f 48 c2             	cmovs  %edx,%eax
ffffffff8010232e:	c1 f8 0c             	sar    $0xc,%eax
ffffffff80102331:	89 c2                	mov    %eax,%edx
ffffffff80102333:	8b 45 d8             	mov    -0x28(%rbp),%eax
ffffffff80102336:	c1 e8 03             	shr    $0x3,%eax
ffffffff80102339:	01 d0                	add    %edx,%eax
ffffffff8010233b:	8d 50 03             	lea    0x3(%rax),%edx
ffffffff8010233e:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102341:	89 d6                	mov    %edx,%esi
ffffffff80102343:	89 c7                	mov    %eax,%edi
ffffffff80102345:	e8 8c df ff ff       	callq  ffffffff801002d6 <bread>
ffffffff8010234a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffffffff8010234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffffffff80102355:	e9 aa 00 00 00       	jmpq   ffffffff80102404 <balloc+0x114>
      m = 1 << (bi % 8);
ffffffff8010235a:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff8010235d:	99                   	cltd   
ffffffff8010235e:	c1 ea 1d             	shr    $0x1d,%edx
ffffffff80102361:	01 d0                	add    %edx,%eax
ffffffff80102363:	83 e0 07             	and    $0x7,%eax
ffffffff80102366:	29 d0                	sub    %edx,%eax
ffffffff80102368:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff8010236d:	89 c1                	mov    %eax,%ecx
ffffffff8010236f:	d3 e2                	shl    %cl,%edx
ffffffff80102371:	89 d0                	mov    %edx,%eax
ffffffff80102373:	89 45 ec             	mov    %eax,-0x14(%rbp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
ffffffff80102376:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80102379:	8d 50 07             	lea    0x7(%rax),%edx
ffffffff8010237c:	85 c0                	test   %eax,%eax
ffffffff8010237e:	0f 48 c2             	cmovs  %edx,%eax
ffffffff80102381:	c1 f8 03             	sar    $0x3,%eax
ffffffff80102384:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80102388:	48 98                	cltq   
ffffffff8010238a:	0f b6 44 02 28       	movzbl 0x28(%rdx,%rax,1),%eax
ffffffff8010238f:	0f b6 c0             	movzbl %al,%eax
ffffffff80102392:	23 45 ec             	and    -0x14(%rbp),%eax
ffffffff80102395:	85 c0                	test   %eax,%eax
ffffffff80102397:	75 67                	jne    ffffffff80102400 <balloc+0x110>
        bp->data[bi/8] |= m;  // Mark block in use.
ffffffff80102399:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff8010239c:	8d 50 07             	lea    0x7(%rax),%edx
ffffffff8010239f:	85 c0                	test   %eax,%eax
ffffffff801023a1:	0f 48 c2             	cmovs  %edx,%eax
ffffffff801023a4:	c1 f8 03             	sar    $0x3,%eax
ffffffff801023a7:	89 c1                	mov    %eax,%ecx
ffffffff801023a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff801023ad:	48 63 c1             	movslq %ecx,%rax
ffffffff801023b0:	0f b6 44 02 28       	movzbl 0x28(%rdx,%rax,1),%eax
ffffffff801023b5:	89 c2                	mov    %eax,%edx
ffffffff801023b7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801023ba:	09 d0                	or     %edx,%eax
ffffffff801023bc:	89 c6                	mov    %eax,%esi
ffffffff801023be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff801023c2:	48 63 c1             	movslq %ecx,%rax
ffffffff801023c5:	40 88 74 02 28       	mov    %sil,0x28(%rdx,%rax,1)
        log_write(bp);
ffffffff801023ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801023ce:	48 89 c7             	mov    %rax,%rdi
ffffffff801023d1:	e8 08 25 00 00       	callq  ffffffff801048de <log_write>
        brelse(bp);
ffffffff801023d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801023da:	48 89 c7             	mov    %rax,%rdi
ffffffff801023dd:	e8 79 df ff ff       	callq  ffffffff8010035b <brelse>
        bzero(dev, b + bi);
ffffffff801023e2:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801023e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801023e8:	01 c2                	add    %eax,%edx
ffffffff801023ea:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff801023ed:	89 d6                	mov    %edx,%esi
ffffffff801023ef:	89 c7                	mov    %eax,%edi
ffffffff801023f1:	e8 a4 fe ff ff       	callq  ffffffff8010229a <bzero>
        return b + bi;
ffffffff801023f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801023f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801023fc:	01 d0                	add    %edx,%eax
ffffffff801023fe:	eb 4f                	jmp    ffffffff8010244f <balloc+0x15f>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
ffffffff80102400:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffffffff80102404:	81 7d f8 ff 0f 00 00 	cmpl   $0xfff,-0x8(%rbp)
ffffffff8010240b:	7f 15                	jg     ffffffff80102422 <balloc+0x132>
ffffffff8010240d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80102410:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80102413:	01 d0                	add    %edx,%eax
ffffffff80102415:	89 c2                	mov    %eax,%edx
ffffffff80102417:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffffffff8010241a:	39 c2                	cmp    %eax,%edx
ffffffff8010241c:	0f 82 38 ff ff ff    	jb     ffffffff8010235a <balloc+0x6a>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
ffffffff80102422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102426:	48 89 c7             	mov    %rax,%rdi
ffffffff80102429:	e8 2d df ff ff       	callq  ffffffff8010035b <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
ffffffff8010242e:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
ffffffff80102435:	8b 55 d0             	mov    -0x30(%rbp),%edx
ffffffff80102438:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010243b:	39 c2                	cmp    %eax,%edx
ffffffff8010243d:	0f 87 dd fe ff ff    	ja     ffffffff80102320 <balloc+0x30>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
ffffffff80102443:	48 c7 c7 8f a7 10 80 	mov    $0xffffffff8010a78f,%rdi
ffffffff8010244a:	e8 b0 e4 ff ff       	callq  ffffffff801008ff <panic>
}
ffffffff8010244f:	c9                   	leaveq 
ffffffff80102450:	c3                   	retq   

ffffffff80102451 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
ffffffff80102451:	55                   	push   %rbp
ffffffff80102452:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102455:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80102459:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffffffff8010245c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
ffffffff8010245f:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffffffff80102463:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80102466:	48 89 d6             	mov    %rdx,%rsi
ffffffff80102469:	89 c7                	mov    %eax,%edi
ffffffff8010246b:	e8 dd fd ff ff       	callq  ffffffff8010224d <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
ffffffff80102470:	8b 45 d8             	mov    -0x28(%rbp),%eax
ffffffff80102473:	c1 e8 0c             	shr    $0xc,%eax
ffffffff80102476:	89 c2                	mov    %eax,%edx
ffffffff80102478:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff8010247b:	c1 e8 03             	shr    $0x3,%eax
ffffffff8010247e:	01 d0                	add    %edx,%eax
ffffffff80102480:	8d 50 03             	lea    0x3(%rax),%edx
ffffffff80102483:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80102486:	89 d6                	mov    %edx,%esi
ffffffff80102488:	89 c7                	mov    %eax,%edi
ffffffff8010248a:	e8 47 de ff ff       	callq  ffffffff801002d6 <bread>
ffffffff8010248f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  bi = b % BPB;
ffffffff80102493:	8b 45 d8             	mov    -0x28(%rbp),%eax
ffffffff80102496:	25 ff 0f 00 00       	and    $0xfff,%eax
ffffffff8010249b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  m = 1 << (bi % 8);
ffffffff8010249e:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff801024a1:	99                   	cltd   
ffffffff801024a2:	c1 ea 1d             	shr    $0x1d,%edx
ffffffff801024a5:	01 d0                	add    %edx,%eax
ffffffff801024a7:	83 e0 07             	and    $0x7,%eax
ffffffff801024aa:	29 d0                	sub    %edx,%eax
ffffffff801024ac:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff801024b1:	89 c1                	mov    %eax,%ecx
ffffffff801024b3:	d3 e2                	shl    %cl,%edx
ffffffff801024b5:	89 d0                	mov    %edx,%eax
ffffffff801024b7:	89 45 f0             	mov    %eax,-0x10(%rbp)
  if((bp->data[bi/8] & m) == 0)
ffffffff801024ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff801024bd:	8d 50 07             	lea    0x7(%rax),%edx
ffffffff801024c0:	85 c0                	test   %eax,%eax
ffffffff801024c2:	0f 48 c2             	cmovs  %edx,%eax
ffffffff801024c5:	c1 f8 03             	sar    $0x3,%eax
ffffffff801024c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801024cc:	48 98                	cltq   
ffffffff801024ce:	0f b6 44 02 28       	movzbl 0x28(%rdx,%rax,1),%eax
ffffffff801024d3:	0f b6 c0             	movzbl %al,%eax
ffffffff801024d6:	23 45 f0             	and    -0x10(%rbp),%eax
ffffffff801024d9:	85 c0                	test   %eax,%eax
ffffffff801024db:	75 0c                	jne    ffffffff801024e9 <bfree+0x98>
    panic("freeing free block");
ffffffff801024dd:	48 c7 c7 a5 a7 10 80 	mov    $0xffffffff8010a7a5,%rdi
ffffffff801024e4:	e8 16 e4 ff ff       	callq  ffffffff801008ff <panic>
  bp->data[bi/8] &= ~m;
ffffffff801024e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff801024ec:	8d 50 07             	lea    0x7(%rax),%edx
ffffffff801024ef:	85 c0                	test   %eax,%eax
ffffffff801024f1:	0f 48 c2             	cmovs  %edx,%eax
ffffffff801024f4:	c1 f8 03             	sar    $0x3,%eax
ffffffff801024f7:	89 c1                	mov    %eax,%ecx
ffffffff801024f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801024fd:	48 63 c1             	movslq %ecx,%rax
ffffffff80102500:	0f b6 44 02 28       	movzbl 0x28(%rdx,%rax,1),%eax
ffffffff80102505:	89 c2                	mov    %eax,%edx
ffffffff80102507:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff8010250a:	f7 d0                	not    %eax
ffffffff8010250c:	21 d0                	and    %edx,%eax
ffffffff8010250e:	89 c6                	mov    %eax,%esi
ffffffff80102510:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80102514:	48 63 c1             	movslq %ecx,%rax
ffffffff80102517:	40 88 74 02 28       	mov    %sil,0x28(%rdx,%rax,1)
  log_write(bp);
ffffffff8010251c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102520:	48 89 c7             	mov    %rax,%rdi
ffffffff80102523:	e8 b6 23 00 00       	callq  ffffffff801048de <log_write>
  brelse(bp);
ffffffff80102528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010252c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010252f:	e8 27 de ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff80102534:	90                   	nop
ffffffff80102535:	c9                   	leaveq 
ffffffff80102536:	c3                   	retq   

ffffffff80102537 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
ffffffff80102537:	55                   	push   %rbp
ffffffff80102538:	48 89 e5             	mov    %rsp,%rbp
  initlock(&icache.lock, "icache");
ffffffff8010253b:	48 c7 c6 b8 a7 10 80 	mov    $0xffffffff8010a7b8,%rsi
ffffffff80102542:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102549:	e8 20 44 00 00       	callq  ffffffff8010696e <initlock>
}
ffffffff8010254e:	90                   	nop
ffffffff8010254f:	5d                   	pop    %rbp
ffffffff80102550:	c3                   	retq   

ffffffff80102551 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
ffffffff80102551:	55                   	push   %rbp
ffffffff80102552:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102555:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff80102559:	89 7d cc             	mov    %edi,-0x34(%rbp)
ffffffff8010255c:	89 f0                	mov    %esi,%eax
ffffffff8010255e:	66 89 45 c8          	mov    %ax,-0x38(%rbp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
ffffffff80102562:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102565:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
ffffffff80102569:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010256c:	89 c7                	mov    %eax,%edi
ffffffff8010256e:	e8 da fc ff ff       	callq  ffffffff8010224d <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
ffffffff80102573:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
ffffffff8010257a:	e9 9d 00 00 00       	jmpq   ffffffff8010261c <ialloc+0xcb>
    bp = bread(dev, IBLOCK(inum));
ffffffff8010257f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80102582:	48 98                	cltq   
ffffffff80102584:	48 c1 e8 03          	shr    $0x3,%rax
ffffffff80102588:	8d 50 02             	lea    0x2(%rax),%edx
ffffffff8010258b:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff8010258e:	89 d6                	mov    %edx,%esi
ffffffff80102590:	89 c7                	mov    %eax,%edi
ffffffff80102592:	e8 3f dd ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80102597:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    dip = (struct dinode*)bp->data + inum%IPB;
ffffffff8010259b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010259f:	48 8d 50 28          	lea    0x28(%rax),%rdx
ffffffff801025a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801025a6:	48 98                	cltq   
ffffffff801025a8:	83 e0 07             	and    $0x7,%eax
ffffffff801025ab:	48 c1 e0 06          	shl    $0x6,%rax
ffffffff801025af:	48 01 d0             	add    %rdx,%rax
ffffffff801025b2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if(dip->type == 0){  // a free inode
ffffffff801025b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801025ba:	0f b7 00             	movzwl (%rax),%eax
ffffffff801025bd:	66 85 c0             	test   %ax,%ax
ffffffff801025c0:	75 4a                	jne    ffffffff8010260c <ialloc+0xbb>
      memset(dip, 0, sizeof(*dip));
ffffffff801025c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801025c6:	ba 40 00 00 00       	mov    $0x40,%edx
ffffffff801025cb:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801025d0:	48 89 c7             	mov    %rax,%rdi
ffffffff801025d3:	e8 3a 47 00 00       	callq  ffffffff80106d12 <memset>
      dip->type = type;
ffffffff801025d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801025dc:	0f b7 55 c8          	movzwl -0x38(%rbp),%edx
ffffffff801025e0:	66 89 10             	mov    %dx,(%rax)
      log_write(bp);   // mark it allocated on the disk
ffffffff801025e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801025e7:	48 89 c7             	mov    %rax,%rdi
ffffffff801025ea:	e8 ef 22 00 00       	callq  ffffffff801048de <log_write>
      brelse(bp);
ffffffff801025ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801025f3:	48 89 c7             	mov    %rax,%rdi
ffffffff801025f6:	e8 60 dd ff ff       	callq  ffffffff8010035b <brelse>
      return iget(dev, inum);
ffffffff801025fb:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801025fe:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102601:	89 d6                	mov    %edx,%esi
ffffffff80102603:	89 c7                	mov    %eax,%edi
ffffffff80102605:	e8 0f 01 00 00       	callq  ffffffff80102719 <iget>
ffffffff8010260a:	eb 2a                	jmp    ffffffff80102636 <ialloc+0xe5>
    }
    brelse(bp);
ffffffff8010260c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102610:	48 89 c7             	mov    %rax,%rdi
ffffffff80102613:	e8 43 dd ff ff       	callq  ffffffff8010035b <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
ffffffff80102618:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010261c:	8b 55 d8             	mov    -0x28(%rbp),%edx
ffffffff8010261f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80102622:	39 c2                	cmp    %eax,%edx
ffffffff80102624:	0f 87 55 ff ff ff    	ja     ffffffff8010257f <ialloc+0x2e>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
ffffffff8010262a:	48 c7 c7 bf a7 10 80 	mov    $0xffffffff8010a7bf,%rdi
ffffffff80102631:	e8 c9 e2 ff ff       	callq  ffffffff801008ff <panic>
}
ffffffff80102636:	c9                   	leaveq 
ffffffff80102637:	c3                   	retq   

ffffffff80102638 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
ffffffff80102638:	55                   	push   %rbp
ffffffff80102639:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010263c:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80102640:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
ffffffff80102644:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102648:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff8010264b:	c1 e8 03             	shr    $0x3,%eax
ffffffff8010264e:	8d 50 02             	lea    0x2(%rax),%edx
ffffffff80102651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102655:	8b 00                	mov    (%rax),%eax
ffffffff80102657:	89 d6                	mov    %edx,%esi
ffffffff80102659:	89 c7                	mov    %eax,%edi
ffffffff8010265b:	e8 76 dc ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80102660:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
ffffffff80102664:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102668:	48 8d 50 28          	lea    0x28(%rax),%rdx
ffffffff8010266c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102670:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80102673:	89 c0                	mov    %eax,%eax
ffffffff80102675:	83 e0 07             	and    $0x7,%eax
ffffffff80102678:	48 c1 e0 06          	shl    $0x6,%rax
ffffffff8010267c:	48 01 d0             	add    %rdx,%rax
ffffffff8010267f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  dip->type = ip->type;
ffffffff80102683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102687:	0f b7 50 10          	movzwl 0x10(%rax),%edx
ffffffff8010268b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010268f:	66 89 10             	mov    %dx,(%rax)
  dip->major = ip->major;
ffffffff80102692:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102696:	0f b7 50 12          	movzwl 0x12(%rax),%edx
ffffffff8010269a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010269e:	66 89 50 02          	mov    %dx,0x2(%rax)
  dip->minor = ip->minor;
ffffffff801026a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801026a6:	0f b7 50 14          	movzwl 0x14(%rax),%edx
ffffffff801026aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801026ae:	66 89 50 04          	mov    %dx,0x4(%rax)
  dip->nlink = ip->nlink;
ffffffff801026b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801026b6:	0f b7 50 16          	movzwl 0x16(%rax),%edx
ffffffff801026ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801026be:	66 89 50 06          	mov    %dx,0x6(%rax)
  dip->size = ip->size;
ffffffff801026c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801026c6:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff801026c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801026cd:	89 50 10             	mov    %edx,0x10(%rax)
  dip->mode = ip->mode;
ffffffff801026d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801026d4:	8b 50 1c             	mov    0x1c(%rax),%edx
ffffffff801026d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801026db:	89 50 0c             	mov    %edx,0xc(%rax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
ffffffff801026de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801026e2:	48 8d 48 24          	lea    0x24(%rax),%rcx
ffffffff801026e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801026ea:	48 83 c0 14          	add    $0x14,%rax
ffffffff801026ee:	ba 2c 00 00 00       	mov    $0x2c,%edx
ffffffff801026f3:	48 89 ce             	mov    %rcx,%rsi
ffffffff801026f6:	48 89 c7             	mov    %rax,%rdi
ffffffff801026f9:	e8 03 47 00 00       	callq  ffffffff80106e01 <memmove>
  log_write(bp);
ffffffff801026fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102702:	48 89 c7             	mov    %rax,%rdi
ffffffff80102705:	e8 d4 21 00 00       	callq  ffffffff801048de <log_write>
  brelse(bp);
ffffffff8010270a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010270e:	48 89 c7             	mov    %rax,%rdi
ffffffff80102711:	e8 45 dc ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff80102716:	90                   	nop
ffffffff80102717:	c9                   	leaveq 
ffffffff80102718:	c3                   	retq   

ffffffff80102719 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
ffffffff80102719:	55                   	push   %rbp
ffffffff8010271a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010271d:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80102721:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff80102724:	89 75 e8             	mov    %esi,-0x18(%rbp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
ffffffff80102727:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff8010272e:	e8 70 42 00 00       	callq  ffffffff801069a3 <acquire>

  // Is the inode already cached?
  empty = 0;
ffffffff80102733:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffffffff8010273a:	00 
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffffffff8010273b:	48 c7 45 f8 08 16 11 	movq   $0xffffffff80111608,-0x8(%rbp)
ffffffff80102742:	80 
ffffffff80102743:	eb 64                	jmp    ffffffff801027a9 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
ffffffff80102745:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102749:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff8010274c:	85 c0                	test   %eax,%eax
ffffffff8010274e:	7e 3a                	jle    ffffffff8010278a <iget+0x71>
ffffffff80102750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102754:	8b 00                	mov    (%rax),%eax
ffffffff80102756:	3b 45 ec             	cmp    -0x14(%rbp),%eax
ffffffff80102759:	75 2f                	jne    ffffffff8010278a <iget+0x71>
ffffffff8010275b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010275f:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80102762:	3b 45 e8             	cmp    -0x18(%rbp),%eax
ffffffff80102765:	75 23                	jne    ffffffff8010278a <iget+0x71>
      ip->ref++;
ffffffff80102767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010276b:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff8010276e:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80102771:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102775:	89 50 08             	mov    %edx,0x8(%rax)
      release(&icache.lock);
ffffffff80102778:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff8010277f:	e8 f6 42 00 00       	callq  ffffffff80106a7a <release>
      return ip;
ffffffff80102784:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102788:	eb 7d                	jmp    ffffffff80102807 <iget+0xee>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
ffffffff8010278a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff8010278f:	75 13                	jne    ffffffff801027a4 <iget+0x8b>
ffffffff80102791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102795:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80102798:	85 c0                	test   %eax,%eax
ffffffff8010279a:	75 08                	jne    ffffffff801027a4 <iget+0x8b>
      empty = ip;
ffffffff8010279c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801027a0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
ffffffff801027a4:	48 83 45 f8 50       	addq   $0x50,-0x8(%rbp)
ffffffff801027a9:	48 81 7d f8 a8 25 11 	cmpq   $0xffffffff801125a8,-0x8(%rbp)
ffffffff801027b0:	80 
ffffffff801027b1:	72 92                	jb     ffffffff80102745 <iget+0x2c>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
ffffffff801027b3:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff801027b8:	75 0c                	jne    ffffffff801027c6 <iget+0xad>
    panic("iget: no inodes");
ffffffff801027ba:	48 c7 c7 d1 a7 10 80 	mov    $0xffffffff8010a7d1,%rdi
ffffffff801027c1:	e8 39 e1 ff ff       	callq  ffffffff801008ff <panic>

  ip = empty;
ffffffff801027c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801027ca:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ip->dev = dev;
ffffffff801027ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801027d2:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff801027d5:	89 10                	mov    %edx,(%rax)
  ip->inum = inum;
ffffffff801027d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801027db:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801027de:	89 50 04             	mov    %edx,0x4(%rax)
  ip->ref = 1;
ffffffff801027e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801027e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)
  ip->flags = 0;
ffffffff801027ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801027f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%rax)
  release(&icache.lock);
ffffffff801027f7:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff801027fe:	e8 77 42 00 00       	callq  ffffffff80106a7a <release>

  return ip;
ffffffff80102803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80102807:	c9                   	leaveq 
ffffffff80102808:	c3                   	retq   

ffffffff80102809 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
ffffffff80102809:	55                   	push   %rbp
ffffffff8010280a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010280d:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80102811:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffffffff80102815:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff8010281c:	e8 82 41 00 00       	callq  ffffffff801069a3 <acquire>
  ip->ref++;
ffffffff80102821:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102825:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80102828:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff8010282b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010282f:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffffffff80102832:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102839:	e8 3c 42 00 00       	callq  ffffffff80106a7a <release>
  return ip;
ffffffff8010283e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80102842:	c9                   	leaveq 
ffffffff80102843:	c3                   	retq   

ffffffff80102844 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
ffffffff80102844:	55                   	push   %rbp
ffffffff80102845:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102848:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010284c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
ffffffff80102850:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff80102855:	74 0b                	je     ffffffff80102862 <ilock+0x1e>
ffffffff80102857:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010285b:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff8010285e:	85 c0                	test   %eax,%eax
ffffffff80102860:	7f 0c                	jg     ffffffff8010286e <ilock+0x2a>
    panic("ilock");
ffffffff80102862:	48 c7 c7 e1 a7 10 80 	mov    $0xffffffff8010a7e1,%rdi
ffffffff80102869:	e8 91 e0 ff ff       	callq  ffffffff801008ff <panic>

  acquire(&icache.lock);
ffffffff8010286e:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102875:	e8 29 41 00 00       	callq  ffffffff801069a3 <acquire>
  while(ip->flags & I_BUSY)
ffffffff8010287a:	eb 13                	jmp    ffffffff8010288f <ilock+0x4b>
    sleep(ip, &icache.lock);
ffffffff8010287c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102880:	48 c7 c6 a0 15 11 80 	mov    $0xffffffff801115a0,%rsi
ffffffff80102887:	48 89 c7             	mov    %rax,%rdi
ffffffff8010288a:	e8 97 3d 00 00       	callq  ffffffff80106626 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
ffffffff8010288f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102893:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80102896:	83 e0 01             	and    $0x1,%eax
ffffffff80102899:	85 c0                	test   %eax,%eax
ffffffff8010289b:	75 df                	jne    ffffffff8010287c <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
ffffffff8010289d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028a1:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff801028a4:	83 c8 01             	or     $0x1,%eax
ffffffff801028a7:	89 c2                	mov    %eax,%edx
ffffffff801028a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028ad:	89 50 0c             	mov    %edx,0xc(%rax)
  release(&icache.lock);
ffffffff801028b0:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff801028b7:	e8 be 41 00 00       	callq  ffffffff80106a7a <release>

  if(!(ip->flags & I_VALID)){
ffffffff801028bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028c0:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff801028c3:	83 e0 02             	and    $0x2,%eax
ffffffff801028c6:	85 c0                	test   %eax,%eax
ffffffff801028c8:	0f 85 12 01 00 00    	jne    ffffffff801029e0 <ilock+0x19c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
ffffffff801028ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028d2:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff801028d5:	c1 e8 03             	shr    $0x3,%eax
ffffffff801028d8:	8d 50 02             	lea    0x2(%rax),%edx
ffffffff801028db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028df:	8b 00                	mov    (%rax),%eax
ffffffff801028e1:	89 d6                	mov    %edx,%esi
ffffffff801028e3:	89 c7                	mov    %eax,%edi
ffffffff801028e5:	e8 ec d9 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff801028ea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
ffffffff801028ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801028f2:	48 8d 50 28          	lea    0x28(%rax),%rdx
ffffffff801028f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801028fa:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff801028fd:	89 c0                	mov    %eax,%eax
ffffffff801028ff:	83 e0 07             	and    $0x7,%eax
ffffffff80102902:	48 c1 e0 06          	shl    $0x6,%rax
ffffffff80102906:	48 01 d0             	add    %rdx,%rax
ffffffff80102909:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    ip->type = dip->type;
ffffffff8010290d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102911:	0f b7 10             	movzwl (%rax),%edx
ffffffff80102914:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102918:	66 89 50 10          	mov    %dx,0x10(%rax)
    ip->major = dip->major;
ffffffff8010291c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102920:	0f b7 50 02          	movzwl 0x2(%rax),%edx
ffffffff80102924:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102928:	66 89 50 12          	mov    %dx,0x12(%rax)
    ip->minor = dip->minor;
ffffffff8010292c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102930:	0f b7 50 04          	movzwl 0x4(%rax),%edx
ffffffff80102934:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102938:	66 89 50 14          	mov    %dx,0x14(%rax)
    ip->nlink = dip->nlink;
ffffffff8010293c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102940:	0f b7 50 06          	movzwl 0x6(%rax),%edx
ffffffff80102944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102948:	66 89 50 16          	mov    %dx,0x16(%rax)
    ip->size = dip->size;
ffffffff8010294c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102950:	8b 50 10             	mov    0x10(%rax),%edx
ffffffff80102953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102957:	89 50 20             	mov    %edx,0x20(%rax)
    ip->ownerid = dip->ownerid;
ffffffff8010295a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010295e:	0f b7 50 08          	movzwl 0x8(%rax),%edx
ffffffff80102962:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102966:	66 89 50 18          	mov    %dx,0x18(%rax)
    ip->groupid = dip->groupid;
ffffffff8010296a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010296e:	0f b7 50 0a          	movzwl 0xa(%rax),%edx
ffffffff80102972:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102976:	66 89 50 1a          	mov    %dx,0x1a(%rax)
    ip->mode = dip->mode;
ffffffff8010297a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010297e:	8b 50 0c             	mov    0xc(%rax),%edx
ffffffff80102981:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102985:	89 50 1c             	mov    %edx,0x1c(%rax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
ffffffff80102988:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010298c:	48 8d 48 14          	lea    0x14(%rax),%rcx
ffffffff80102990:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102994:	48 83 c0 24          	add    $0x24,%rax
ffffffff80102998:	ba 2c 00 00 00       	mov    $0x2c,%edx
ffffffff8010299d:	48 89 ce             	mov    %rcx,%rsi
ffffffff801029a0:	48 89 c7             	mov    %rax,%rdi
ffffffff801029a3:	e8 59 44 00 00       	callq  ffffffff80106e01 <memmove>
    brelse(bp);
ffffffff801029a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801029ac:	48 89 c7             	mov    %rax,%rdi
ffffffff801029af:	e8 a7 d9 ff ff       	callq  ffffffff8010035b <brelse>
    ip->flags |= I_VALID;
ffffffff801029b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801029b8:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff801029bb:	83 c8 02             	or     $0x2,%eax
ffffffff801029be:	89 c2                	mov    %eax,%edx
ffffffff801029c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801029c4:	89 50 0c             	mov    %edx,0xc(%rax)
    if(ip->type == 0)
ffffffff801029c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801029cb:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff801029cf:	66 85 c0             	test   %ax,%ax
ffffffff801029d2:	75 0c                	jne    ffffffff801029e0 <ilock+0x19c>
      panic("ilock: no type");
ffffffff801029d4:	48 c7 c7 e7 a7 10 80 	mov    $0xffffffff8010a7e7,%rdi
ffffffff801029db:	e8 1f df ff ff       	callq  ffffffff801008ff <panic>
  }
}
ffffffff801029e0:	90                   	nop
ffffffff801029e1:	c9                   	leaveq 
ffffffff801029e2:	c3                   	retq   

ffffffff801029e3 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
ffffffff801029e3:	55                   	push   %rbp
ffffffff801029e4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801029e7:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff801029eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
ffffffff801029ef:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff801029f4:	74 19                	je     ffffffff80102a0f <iunlock+0x2c>
ffffffff801029f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801029fa:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff801029fd:	83 e0 01             	and    $0x1,%eax
ffffffff80102a00:	85 c0                	test   %eax,%eax
ffffffff80102a02:	74 0b                	je     ffffffff80102a0f <iunlock+0x2c>
ffffffff80102a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a08:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80102a0b:	85 c0                	test   %eax,%eax
ffffffff80102a0d:	7f 0c                	jg     ffffffff80102a1b <iunlock+0x38>
    panic("iunlock");
ffffffff80102a0f:	48 c7 c7 f6 a7 10 80 	mov    $0xffffffff8010a7f6,%rdi
ffffffff80102a16:	e8 e4 de ff ff       	callq  ffffffff801008ff <panic>

  acquire(&icache.lock);
ffffffff80102a1b:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102a22:	e8 7c 3f 00 00       	callq  ffffffff801069a3 <acquire>
  ip->flags &= ~I_BUSY;
ffffffff80102a27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a2b:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80102a2e:	83 e0 fe             	and    $0xfffffffe,%eax
ffffffff80102a31:	89 c2                	mov    %eax,%edx
ffffffff80102a33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a37:	89 50 0c             	mov    %edx,0xc(%rax)
  wakeup(ip);
ffffffff80102a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a3e:	48 89 c7             	mov    %rax,%rdi
ffffffff80102a41:	e8 f3 3c 00 00       	callq  ffffffff80106739 <wakeup>
  release(&icache.lock);
ffffffff80102a46:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102a4d:	e8 28 40 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80102a52:	90                   	nop
ffffffff80102a53:	c9                   	leaveq 
ffffffff80102a54:	c3                   	retq   

ffffffff80102a55 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
ffffffff80102a55:	55                   	push   %rbp
ffffffff80102a56:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102a59:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80102a5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&icache.lock);
ffffffff80102a61:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102a68:	e8 36 3f 00 00       	callq  ffffffff801069a3 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
ffffffff80102a6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a71:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80102a74:	83 f8 01             	cmp    $0x1,%eax
ffffffff80102a77:	0f 85 9d 00 00 00    	jne    ffffffff80102b1a <iput+0xc5>
ffffffff80102a7d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a81:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80102a84:	83 e0 02             	and    $0x2,%eax
ffffffff80102a87:	85 c0                	test   %eax,%eax
ffffffff80102a89:	0f 84 8b 00 00 00    	je     ffffffff80102b1a <iput+0xc5>
ffffffff80102a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102a93:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff80102a97:	66 85 c0             	test   %ax,%ax
ffffffff80102a9a:	75 7e                	jne    ffffffff80102b1a <iput+0xc5>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
ffffffff80102a9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102aa0:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80102aa3:	83 e0 01             	and    $0x1,%eax
ffffffff80102aa6:	85 c0                	test   %eax,%eax
ffffffff80102aa8:	74 0c                	je     ffffffff80102ab6 <iput+0x61>
      panic("iput busy");
ffffffff80102aaa:	48 c7 c7 fe a7 10 80 	mov    $0xffffffff8010a7fe,%rdi
ffffffff80102ab1:	e8 49 de ff ff       	callq  ffffffff801008ff <panic>
    ip->flags |= I_BUSY;
ffffffff80102ab6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102aba:	8b 40 0c             	mov    0xc(%rax),%eax
ffffffff80102abd:	83 c8 01             	or     $0x1,%eax
ffffffff80102ac0:	89 c2                	mov    %eax,%edx
ffffffff80102ac2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102ac6:	89 50 0c             	mov    %edx,0xc(%rax)
    release(&icache.lock);
ffffffff80102ac9:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102ad0:	e8 a5 3f 00 00       	callq  ffffffff80106a7a <release>
    itrunc(ip);
ffffffff80102ad5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102ad9:	48 89 c7             	mov    %rax,%rdi
ffffffff80102adc:	e8 a7 01 00 00       	callq  ffffffff80102c88 <itrunc>
    ip->type = 0;
ffffffff80102ae1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102ae5:	66 c7 40 10 00 00    	movw   $0x0,0x10(%rax)
    iupdate(ip);
ffffffff80102aeb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102aef:	48 89 c7             	mov    %rax,%rdi
ffffffff80102af2:	e8 41 fb ff ff       	callq  ffffffff80102638 <iupdate>
    acquire(&icache.lock);
ffffffff80102af7:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102afe:	e8 a0 3e 00 00       	callq  ffffffff801069a3 <acquire>
    ip->flags = 0;
ffffffff80102b03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%rax)
    wakeup(ip);
ffffffff80102b0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b12:	48 89 c7             	mov    %rax,%rdi
ffffffff80102b15:	e8 1f 3c 00 00       	callq  ffffffff80106739 <wakeup>
  }
  ip->ref--;
ffffffff80102b1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b1e:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80102b21:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80102b24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b28:	89 50 08             	mov    %edx,0x8(%rax)
  release(&icache.lock);
ffffffff80102b2b:	48 c7 c7 a0 15 11 80 	mov    $0xffffffff801115a0,%rdi
ffffffff80102b32:	e8 43 3f 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80102b37:	90                   	nop
ffffffff80102b38:	c9                   	leaveq 
ffffffff80102b39:	c3                   	retq   

ffffffff80102b3a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
ffffffff80102b3a:	55                   	push   %rbp
ffffffff80102b3b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102b3e:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80102b42:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  iunlock(ip);
ffffffff80102b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b4a:	48 89 c7             	mov    %rax,%rdi
ffffffff80102b4d:	e8 91 fe ff ff       	callq  ffffffff801029e3 <iunlock>
  iput(ip);
ffffffff80102b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102b56:	48 89 c7             	mov    %rax,%rdi
ffffffff80102b59:	e8 f7 fe ff ff       	callq  ffffffff80102a55 <iput>
}
ffffffff80102b5e:	90                   	nop
ffffffff80102b5f:	c9                   	leaveq 
ffffffff80102b60:	c3                   	retq   

ffffffff80102b61 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
ffffffff80102b61:	55                   	push   %rbp
ffffffff80102b62:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102b65:	53                   	push   %rbx
ffffffff80102b66:	48 83 ec 38          	sub    $0x38,%rsp
ffffffff80102b6a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffffffff80102b6e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
ffffffff80102b71:	83 7d c4 09          	cmpl   $0x9,-0x3c(%rbp)
ffffffff80102b75:	77 42                	ja     ffffffff80102bb9 <bmap+0x58>
    if((addr = ip->addrs[bn]) == 0)
ffffffff80102b77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102b7b:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffffffff80102b7e:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80102b82:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff80102b86:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102b89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80102b8d:	75 22                	jne    ffffffff80102bb1 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
ffffffff80102b8f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102b93:	8b 00                	mov    (%rax),%eax
ffffffff80102b95:	89 c7                	mov    %eax,%edi
ffffffff80102b97:	e8 54 f7 ff ff       	callq  ffffffff801022f0 <balloc>
ffffffff80102b9c:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102b9f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102ba3:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffffffff80102ba6:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffffffff80102baa:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80102bad:	89 54 88 04          	mov    %edx,0x4(%rax,%rcx,4)
    return addr;
ffffffff80102bb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102bb4:	e9 c8 00 00 00       	jmpq   ffffffff80102c81 <bmap+0x120>
  }
  bn -= NDIRECT;
ffffffff80102bb9:	83 6d c4 0a          	subl   $0xa,-0x3c(%rbp)

  if(bn < NINDIRECT){
ffffffff80102bbd:	83 7d c4 7f          	cmpl   $0x7f,-0x3c(%rbp)
ffffffff80102bc1:	0f 87 ae 00 00 00    	ja     ffffffff80102c75 <bmap+0x114>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
ffffffff80102bc7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102bcb:	8b 40 4c             	mov    0x4c(%rax),%eax
ffffffff80102bce:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102bd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80102bd5:	75 1a                	jne    ffffffff80102bf1 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
ffffffff80102bd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102bdb:	8b 00                	mov    (%rax),%eax
ffffffff80102bdd:	89 c7                	mov    %eax,%edi
ffffffff80102bdf:	e8 0c f7 ff ff       	callq  ffffffff801022f0 <balloc>
ffffffff80102be4:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102be7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102beb:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80102bee:	89 50 4c             	mov    %edx,0x4c(%rax)
    bp = bread(ip->dev, addr);
ffffffff80102bf1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102bf5:	8b 00                	mov    (%rax),%eax
ffffffff80102bf7:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80102bfa:	89 d6                	mov    %edx,%esi
ffffffff80102bfc:	89 c7                	mov    %eax,%edi
ffffffff80102bfe:	e8 d3 d6 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80102c03:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    a = (uint*)bp->data;
ffffffff80102c07:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80102c0b:	48 83 c0 28          	add    $0x28,%rax
ffffffff80102c0f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    if((addr = a[bn]) == 0){
ffffffff80102c13:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffffffff80102c16:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80102c1d:	00 
ffffffff80102c1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102c22:	48 01 d0             	add    %rdx,%rax
ffffffff80102c25:	8b 00                	mov    (%rax),%eax
ffffffff80102c27:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102c2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80102c2e:	75 34                	jne    ffffffff80102c64 <bmap+0x103>
      a[bn] = addr = balloc(ip->dev);
ffffffff80102c30:	8b 45 c4             	mov    -0x3c(%rbp),%eax
ffffffff80102c33:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80102c3a:	00 
ffffffff80102c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102c3f:	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
ffffffff80102c43:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80102c47:	8b 00                	mov    (%rax),%eax
ffffffff80102c49:	89 c7                	mov    %eax,%edi
ffffffff80102c4b:	e8 a0 f6 ff ff       	callq  ffffffff801022f0 <balloc>
ffffffff80102c50:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80102c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102c56:	89 03                	mov    %eax,(%rbx)
      log_write(bp);
ffffffff80102c58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80102c5c:	48 89 c7             	mov    %rax,%rdi
ffffffff80102c5f:	e8 7a 1c 00 00       	callq  ffffffff801048de <log_write>
    }
    brelse(bp);
ffffffff80102c64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80102c68:	48 89 c7             	mov    %rax,%rdi
ffffffff80102c6b:	e8 eb d6 ff ff       	callq  ffffffff8010035b <brelse>
    return addr;
ffffffff80102c70:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102c73:	eb 0c                	jmp    ffffffff80102c81 <bmap+0x120>
  }

  panic("bmap: out of range");
ffffffff80102c75:	48 c7 c7 08 a8 10 80 	mov    $0xffffffff8010a808,%rdi
ffffffff80102c7c:	e8 7e dc ff ff       	callq  ffffffff801008ff <panic>
}
ffffffff80102c81:	48 83 c4 38          	add    $0x38,%rsp
ffffffff80102c85:	5b                   	pop    %rbx
ffffffff80102c86:	5d                   	pop    %rbp
ffffffff80102c87:	c3                   	retq   

ffffffff80102c88 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
ffffffff80102c88:	55                   	push   %rbp
ffffffff80102c89:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102c8c:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80102c90:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffffffff80102c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80102c9b:	eb 51                	jmp    ffffffff80102cee <itrunc+0x66>
    if(ip->addrs[i]){
ffffffff80102c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102ca1:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80102ca4:	48 63 d2             	movslq %edx,%rdx
ffffffff80102ca7:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80102cab:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff80102caf:	85 c0                	test   %eax,%eax
ffffffff80102cb1:	74 37                	je     ffffffff80102cea <itrunc+0x62>
      bfree(ip->dev, ip->addrs[i]);
ffffffff80102cb3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102cb7:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80102cba:	48 63 d2             	movslq %edx,%rdx
ffffffff80102cbd:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80102cc1:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff80102cc5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80102cc9:	8b 12                	mov    (%rdx),%edx
ffffffff80102ccb:	89 c6                	mov    %eax,%esi
ffffffff80102ccd:	89 d7                	mov    %edx,%edi
ffffffff80102ccf:	e8 7d f7 ff ff       	callq  ffffffff80102451 <bfree>
      ip->addrs[i] = 0;
ffffffff80102cd4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102cd8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80102cdb:	48 63 d2             	movslq %edx,%rdx
ffffffff80102cde:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80102ce2:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%rax,%rdx,4)
ffffffff80102ce9:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
ffffffff80102cea:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80102cee:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff80102cf2:	7e a9                	jle    ffffffff80102c9d <itrunc+0x15>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
ffffffff80102cf4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102cf8:	8b 40 4c             	mov    0x4c(%rax),%eax
ffffffff80102cfb:	85 c0                	test   %eax,%eax
ffffffff80102cfd:	0f 84 a7 00 00 00    	je     ffffffff80102daa <itrunc+0x122>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
ffffffff80102d03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102d07:	8b 50 4c             	mov    0x4c(%rax),%edx
ffffffff80102d0a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102d0e:	8b 00                	mov    (%rax),%eax
ffffffff80102d10:	89 d6                	mov    %edx,%esi
ffffffff80102d12:	89 c7                	mov    %eax,%edi
ffffffff80102d14:	e8 bd d5 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80102d19:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    a = (uint*)bp->data;
ffffffff80102d1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102d21:	48 83 c0 28          	add    $0x28,%rax
ffffffff80102d25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for(j = 0; j < NINDIRECT; j++){
ffffffff80102d29:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
ffffffff80102d30:	eb 43                	jmp    ffffffff80102d75 <itrunc+0xed>
      if(a[j])
ffffffff80102d32:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80102d35:	48 98                	cltq   
ffffffff80102d37:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80102d3e:	00 
ffffffff80102d3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102d43:	48 01 d0             	add    %rdx,%rax
ffffffff80102d46:	8b 00                	mov    (%rax),%eax
ffffffff80102d48:	85 c0                	test   %eax,%eax
ffffffff80102d4a:	74 25                	je     ffffffff80102d71 <itrunc+0xe9>
        bfree(ip->dev, a[j]);
ffffffff80102d4c:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80102d4f:	48 98                	cltq   
ffffffff80102d51:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80102d58:	00 
ffffffff80102d59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80102d5d:	48 01 d0             	add    %rdx,%rax
ffffffff80102d60:	8b 00                	mov    (%rax),%eax
ffffffff80102d62:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80102d66:	8b 12                	mov    (%rdx),%edx
ffffffff80102d68:	89 c6                	mov    %eax,%esi
ffffffff80102d6a:	89 d7                	mov    %edx,%edi
ffffffff80102d6c:	e8 e0 f6 ff ff       	callq  ffffffff80102451 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
ffffffff80102d71:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
ffffffff80102d75:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80102d78:	83 f8 7f             	cmp    $0x7f,%eax
ffffffff80102d7b:	76 b5                	jbe    ffffffff80102d32 <itrunc+0xaa>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
ffffffff80102d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102d81:	48 89 c7             	mov    %rax,%rdi
ffffffff80102d84:	e8 d2 d5 ff ff       	callq  ffffffff8010035b <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
ffffffff80102d89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102d8d:	8b 40 4c             	mov    0x4c(%rax),%eax
ffffffff80102d90:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80102d94:	8b 12                	mov    (%rdx),%edx
ffffffff80102d96:	89 c6                	mov    %eax,%esi
ffffffff80102d98:	89 d7                	mov    %edx,%edi
ffffffff80102d9a:	e8 b2 f6 ff ff       	callq  ffffffff80102451 <bfree>
    ip->addrs[NDIRECT] = 0;
ffffffff80102d9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102da3:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%rax)
  }

  ip->size = 0;
ffffffff80102daa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102dae:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  iupdate(ip);
ffffffff80102db5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102db9:	48 89 c7             	mov    %rax,%rdi
ffffffff80102dbc:	e8 77 f8 ff ff       	callq  ffffffff80102638 <iupdate>
}
ffffffff80102dc1:	90                   	nop
ffffffff80102dc2:	c9                   	leaveq 
ffffffff80102dc3:	c3                   	retq   

ffffffff80102dc4 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
ffffffff80102dc4:	55                   	push   %rbp
ffffffff80102dc5:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102dc8:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80102dcc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80102dd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  st->dev = ip->dev;
ffffffff80102dd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102dd8:	8b 00                	mov    (%rax),%eax
ffffffff80102dda:	89 c2                	mov    %eax,%edx
ffffffff80102ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102de0:	89 50 04             	mov    %edx,0x4(%rax)
  st->ino = ip->inum;
ffffffff80102de3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102de7:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff80102dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102dee:	89 50 08             	mov    %edx,0x8(%rax)
  st->type = ip->type;
ffffffff80102df1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102df5:	0f b7 50 10          	movzwl 0x10(%rax),%edx
ffffffff80102df9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102dfd:	66 89 10             	mov    %dx,(%rax)
  st->nlink = ip->nlink;
ffffffff80102e00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102e04:	0f b7 50 16          	movzwl 0x16(%rax),%edx
ffffffff80102e08:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102e0c:	66 89 50 0c          	mov    %dx,0xc(%rax)
  st->size = ip->size;
ffffffff80102e10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102e14:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff80102e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102e1b:	89 50 18             	mov    %edx,0x18(%rax)
  st->ownerid = ip->ownerid;
ffffffff80102e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102e22:	0f b7 50 18          	movzwl 0x18(%rax),%edx
ffffffff80102e26:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102e2a:	66 89 50 0e          	mov    %dx,0xe(%rax)
  st->groupid = ip->groupid;
ffffffff80102e2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102e32:	0f b7 50 1a          	movzwl 0x1a(%rax),%edx
ffffffff80102e36:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102e3a:	66 89 50 10          	mov    %dx,0x10(%rax)
  st->mode = ip->mode;
ffffffff80102e3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80102e42:	8b 50 1c             	mov    0x1c(%rax),%edx
ffffffff80102e45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102e49:	89 50 14             	mov    %edx,0x14(%rax)
}
ffffffff80102e4c:	90                   	nop
ffffffff80102e4d:	c9                   	leaveq 
ffffffff80102e4e:	c3                   	retq   

ffffffff80102e4f <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
ffffffff80102e4f:	55                   	push   %rbp
ffffffff80102e50:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102e53:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff80102e57:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff80102e5b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff80102e5f:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffffffff80102e62:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffffffff80102e65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102e69:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80102e6d:	66 83 f8 03          	cmp    $0x3,%ax
ffffffff80102e71:	75 6f                	jne    ffffffff80102ee2 <readi+0x93>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
ffffffff80102e73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102e77:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80102e7b:	66 85 c0             	test   %ax,%ax
ffffffff80102e7e:	78 2b                	js     ffffffff80102eab <readi+0x5c>
ffffffff80102e80:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102e84:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80102e88:	66 83 f8 09          	cmp    $0x9,%ax
ffffffff80102e8c:	7f 1d                	jg     ffffffff80102eab <readi+0x5c>
ffffffff80102e8e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102e92:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80102e96:	98                   	cwtl   
ffffffff80102e97:	48 98                	cltq   
ffffffff80102e99:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80102e9d:	48 05 e0 04 11 80    	add    $0xffffffff801104e0,%rax
ffffffff80102ea3:	48 8b 00             	mov    (%rax),%rax
ffffffff80102ea6:	48 85 c0             	test   %rax,%rax
ffffffff80102ea9:	75 0a                	jne    ffffffff80102eb5 <readi+0x66>
      return -1;
ffffffff80102eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80102eb0:	e9 18 01 00 00       	jmpq   ffffffff80102fcd <readi+0x17e>
    return devsw[ip->major].read(ip, dst, n);
ffffffff80102eb5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102eb9:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80102ebd:	98                   	cwtl   
ffffffff80102ebe:	48 98                	cltq   
ffffffff80102ec0:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80102ec4:	48 05 e0 04 11 80    	add    $0xffffffff801104e0,%rax
ffffffff80102eca:	48 8b 00             	mov    (%rax),%rax
ffffffff80102ecd:	8b 55 c8             	mov    -0x38(%rbp),%edx
ffffffff80102ed0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffffffff80102ed4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffffffff80102ed8:	48 89 cf             	mov    %rcx,%rdi
ffffffff80102edb:	ff d0                	callq  *%rax
ffffffff80102edd:	e9 eb 00 00 00       	jmpq   ffffffff80102fcd <readi+0x17e>
  }

  if(off > ip->size || off + n < off)
ffffffff80102ee2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102ee6:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff80102ee9:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffffffff80102eec:	72 0d                	jb     ffffffff80102efb <readi+0xac>
ffffffff80102eee:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffffffff80102ef1:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff80102ef4:	01 d0                	add    %edx,%eax
ffffffff80102ef6:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffffffff80102ef9:	73 0a                	jae    ffffffff80102f05 <readi+0xb6>
    return -1;
ffffffff80102efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80102f00:	e9 c8 00 00 00       	jmpq   ffffffff80102fcd <readi+0x17e>
  if(off + n > ip->size)
ffffffff80102f05:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffffffff80102f08:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff80102f0b:	01 c2                	add    %eax,%edx
ffffffff80102f0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102f11:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff80102f14:	39 c2                	cmp    %eax,%edx
ffffffff80102f16:	76 0d                	jbe    ffffffff80102f25 <readi+0xd6>
    n = ip->size - off;
ffffffff80102f18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102f1c:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff80102f1f:	2b 45 cc             	sub    -0x34(%rbp),%eax
ffffffff80102f22:	89 45 c8             	mov    %eax,-0x38(%rbp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffffffff80102f25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80102f2c:	e9 8d 00 00 00       	jmpq   ffffffff80102fbe <readi+0x16f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffffffff80102f31:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102f34:	c1 e8 09             	shr    $0x9,%eax
ffffffff80102f37:	89 c2                	mov    %eax,%edx
ffffffff80102f39:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102f3d:	89 d6                	mov    %edx,%esi
ffffffff80102f3f:	48 89 c7             	mov    %rax,%rdi
ffffffff80102f42:	e8 1a fc ff ff       	callq  ffffffff80102b61 <bmap>
ffffffff80102f47:	89 c2                	mov    %eax,%edx
ffffffff80102f49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102f4d:	8b 00                	mov    (%rax),%eax
ffffffff80102f4f:	89 d6                	mov    %edx,%esi
ffffffff80102f51:	89 c7                	mov    %eax,%edi
ffffffff80102f53:	e8 7e d3 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80102f58:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffffffff80102f5c:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102f5f:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80102f64:	ba 00 02 00 00       	mov    $0x200,%edx
ffffffff80102f69:	29 c2                	sub    %eax,%edx
ffffffff80102f6b:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff80102f6e:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffffffff80102f71:	39 c2                	cmp    %eax,%edx
ffffffff80102f73:	0f 46 c2             	cmovbe %edx,%eax
ffffffff80102f76:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(dst, bp->data + off%BSIZE, m);
ffffffff80102f79:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102f7d:	48 8d 50 28          	lea    0x28(%rax),%rdx
ffffffff80102f81:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80102f84:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80102f89:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffffffff80102f8d:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80102f90:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80102f94:	48 89 ce             	mov    %rcx,%rsi
ffffffff80102f97:	48 89 c7             	mov    %rax,%rdi
ffffffff80102f9a:	e8 62 3e 00 00       	callq  ffffffff80106e01 <memmove>
    brelse(bp);
ffffffff80102f9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80102fa3:	48 89 c7             	mov    %rax,%rdi
ffffffff80102fa6:	e8 b0 d3 ff ff       	callq  ffffffff8010035b <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
ffffffff80102fab:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102fae:	01 45 fc             	add    %eax,-0x4(%rbp)
ffffffff80102fb1:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102fb4:	01 45 cc             	add    %eax,-0x34(%rbp)
ffffffff80102fb7:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80102fba:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffffffff80102fbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80102fc1:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffffffff80102fc4:	0f 82 67 ff ff ff    	jb     ffffffff80102f31 <readi+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
ffffffff80102fca:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffffffff80102fcd:	c9                   	leaveq 
ffffffff80102fce:	c3                   	retq   

ffffffff80102fcf <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
ffffffff80102fcf:	55                   	push   %rbp
ffffffff80102fd0:	48 89 e5             	mov    %rsp,%rbp
ffffffff80102fd3:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff80102fd7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff80102fdb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff80102fdf:	89 55 cc             	mov    %edx,-0x34(%rbp)
ffffffff80102fe2:	89 4d c8             	mov    %ecx,-0x38(%rbp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
ffffffff80102fe5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102fe9:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80102fed:	66 83 f8 03          	cmp    $0x3,%ax
ffffffff80102ff1:	75 6f                	jne    ffffffff80103062 <writei+0x93>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
ffffffff80102ff3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80102ff7:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80102ffb:	66 85 c0             	test   %ax,%ax
ffffffff80102ffe:	78 2b                	js     ffffffff8010302b <writei+0x5c>
ffffffff80103000:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103004:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80103008:	66 83 f8 09          	cmp    $0x9,%ax
ffffffff8010300c:	7f 1d                	jg     ffffffff8010302b <writei+0x5c>
ffffffff8010300e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103012:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff80103016:	98                   	cwtl   
ffffffff80103017:	48 98                	cltq   
ffffffff80103019:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8010301d:	48 05 e8 04 11 80    	add    $0xffffffff801104e8,%rax
ffffffff80103023:	48 8b 00             	mov    (%rax),%rax
ffffffff80103026:	48 85 c0             	test   %rax,%rax
ffffffff80103029:	75 0a                	jne    ffffffff80103035 <writei+0x66>
      return -1;
ffffffff8010302b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80103030:	e9 45 01 00 00       	jmpq   ffffffff8010317a <writei+0x1ab>
    return devsw[ip->major].write(ip, src, n);
ffffffff80103035:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103039:	0f b7 40 12          	movzwl 0x12(%rax),%eax
ffffffff8010303d:	98                   	cwtl   
ffffffff8010303e:	48 98                	cltq   
ffffffff80103040:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80103044:	48 05 e8 04 11 80    	add    $0xffffffff801104e8,%rax
ffffffff8010304a:	48 8b 00             	mov    (%rax),%rax
ffffffff8010304d:	8b 55 c8             	mov    -0x38(%rbp),%edx
ffffffff80103050:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
ffffffff80103054:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffffffff80103058:	48 89 cf             	mov    %rcx,%rdi
ffffffff8010305b:	ff d0                	callq  *%rax
ffffffff8010305d:	e9 18 01 00 00       	jmpq   ffffffff8010317a <writei+0x1ab>
  }

  if(off > ip->size || off + n < off)
ffffffff80103062:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103066:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff80103069:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffffffff8010306c:	72 0d                	jb     ffffffff8010307b <writei+0xac>
ffffffff8010306e:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffffffff80103071:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff80103074:	01 d0                	add    %edx,%eax
ffffffff80103076:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffffffff80103079:	73 0a                	jae    ffffffff80103085 <writei+0xb6>
    return -1;
ffffffff8010307b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80103080:	e9 f5 00 00 00       	jmpq   ffffffff8010317a <writei+0x1ab>
  if(off + n > MAXFILE*BSIZE)
ffffffff80103085:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffffffff80103088:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff8010308b:	01 d0                	add    %edx,%eax
ffffffff8010308d:	3d 00 14 01 00       	cmp    $0x11400,%eax
ffffffff80103092:	76 0a                	jbe    ffffffff8010309e <writei+0xcf>
    return -1;
ffffffff80103094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80103099:	e9 dc 00 00 00       	jmpq   ffffffff8010317a <writei+0x1ab>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffffffff8010309e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801030a5:	e9 99 00 00 00       	jmpq   ffffffff80103143 <writei+0x174>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
ffffffff801030aa:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff801030ad:	c1 e8 09             	shr    $0x9,%eax
ffffffff801030b0:	89 c2                	mov    %eax,%edx
ffffffff801030b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801030b6:	89 d6                	mov    %edx,%esi
ffffffff801030b8:	48 89 c7             	mov    %rax,%rdi
ffffffff801030bb:	e8 a1 fa ff ff       	callq  ffffffff80102b61 <bmap>
ffffffff801030c0:	89 c2                	mov    %eax,%edx
ffffffff801030c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801030c6:	8b 00                	mov    (%rax),%eax
ffffffff801030c8:	89 d6                	mov    %edx,%esi
ffffffff801030ca:	89 c7                	mov    %eax,%edi
ffffffff801030cc:	e8 05 d2 ff ff       	callq  ffffffff801002d6 <bread>
ffffffff801030d1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    m = min(n - tot, BSIZE - off%BSIZE);
ffffffff801030d5:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff801030d8:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff801030dd:	ba 00 02 00 00       	mov    $0x200,%edx
ffffffff801030e2:	29 c2                	sub    %eax,%edx
ffffffff801030e4:	8b 45 c8             	mov    -0x38(%rbp),%eax
ffffffff801030e7:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffffffff801030ea:	39 c2                	cmp    %eax,%edx
ffffffff801030ec:	0f 46 c2             	cmovbe %edx,%eax
ffffffff801030ef:	89 45 ec             	mov    %eax,-0x14(%rbp)
    memmove(bp->data + off%BSIZE, src, m);
ffffffff801030f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801030f6:	48 8d 50 28          	lea    0x28(%rax),%rdx
ffffffff801030fa:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff801030fd:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80103102:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffffffff80103106:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80103109:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010310d:	48 89 c6             	mov    %rax,%rsi
ffffffff80103110:	48 89 cf             	mov    %rcx,%rdi
ffffffff80103113:	e8 e9 3c 00 00       	callq  ffffffff80106e01 <memmove>
    log_write(bp);
ffffffff80103118:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010311c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010311f:	e8 ba 17 00 00       	callq  ffffffff801048de <log_write>
    brelse(bp);
ffffffff80103124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80103128:	48 89 c7             	mov    %rax,%rdi
ffffffff8010312b:	e8 2b d2 ff ff       	callq  ffffffff8010035b <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
ffffffff80103130:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80103133:	01 45 fc             	add    %eax,-0x4(%rbp)
ffffffff80103136:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80103139:	01 45 cc             	add    %eax,-0x34(%rbp)
ffffffff8010313c:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010313f:	48 01 45 d0          	add    %rax,-0x30(%rbp)
ffffffff80103143:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103146:	3b 45 c8             	cmp    -0x38(%rbp),%eax
ffffffff80103149:	0f 82 5b ff ff ff    	jb     ffffffff801030aa <writei+0xdb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
ffffffff8010314f:	83 7d c8 00          	cmpl   $0x0,-0x38(%rbp)
ffffffff80103153:	74 22                	je     ffffffff80103177 <writei+0x1a8>
ffffffff80103155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103159:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff8010315c:	3b 45 cc             	cmp    -0x34(%rbp),%eax
ffffffff8010315f:	73 16                	jae    ffffffff80103177 <writei+0x1a8>
    ip->size = off;
ffffffff80103161:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103165:	8b 55 cc             	mov    -0x34(%rbp),%edx
ffffffff80103168:	89 50 20             	mov    %edx,0x20(%rax)
    iupdate(ip);
ffffffff8010316b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010316f:	48 89 c7             	mov    %rax,%rdi
ffffffff80103172:	e8 c1 f4 ff ff       	callq  ffffffff80102638 <iupdate>
  }
  return n;
ffffffff80103177:	8b 45 c8             	mov    -0x38(%rbp),%eax
}
ffffffff8010317a:	c9                   	leaveq 
ffffffff8010317b:	c3                   	retq   

ffffffff8010317c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
ffffffff8010317c:	55                   	push   %rbp
ffffffff8010317d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103180:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80103184:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80103188:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return strncmp(s, t, DIRSIZ);
ffffffff8010318c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffffffff80103190:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103194:	ba 0e 00 00 00       	mov    $0xe,%edx
ffffffff80103199:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010319c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010319f:	e8 2b 3d 00 00       	callq  ffffffff80106ecf <strncmp>
}
ffffffff801031a4:	c9                   	leaveq 
ffffffff801031a5:	c3                   	retq   

ffffffff801031a6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
ffffffff801031a6:	55                   	push   %rbp
ffffffff801031a7:	48 89 e5             	mov    %rsp,%rbp
ffffffff801031aa:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff801031ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff801031b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff801031b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
ffffffff801031ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801031be:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff801031c2:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff801031c6:	74 0c                	je     ffffffff801031d4 <dirlookup+0x2e>
    panic("dirlookup not DIR");
ffffffff801031c8:	48 c7 c7 1b a8 10 80 	mov    $0xffffffff8010a81b,%rdi
ffffffff801031cf:	e8 2b d7 ff ff       	callq  ffffffff801008ff <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
ffffffff801031d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801031db:	e9 80 00 00 00       	jmpq   ffffffff80103260 <dirlookup+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffffffff801031e0:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801031e3:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffffffff801031e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801031eb:	b9 10 00 00 00       	mov    $0x10,%ecx
ffffffff801031f0:	48 89 c7             	mov    %rax,%rdi
ffffffff801031f3:	e8 57 fc ff ff       	callq  ffffffff80102e4f <readi>
ffffffff801031f8:	83 f8 10             	cmp    $0x10,%eax
ffffffff801031fb:	74 0c                	je     ffffffff80103209 <dirlookup+0x63>
      panic("dirlink read");
ffffffff801031fd:	48 c7 c7 2d a8 10 80 	mov    $0xffffffff8010a82d,%rdi
ffffffff80103204:	e8 f6 d6 ff ff       	callq  ffffffff801008ff <panic>
    if(de.inum == 0)
ffffffff80103209:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffffffff8010320d:	66 85 c0             	test   %ax,%ax
ffffffff80103210:	74 49                	je     ffffffff8010325b <dirlookup+0xb5>
      continue;
    if(namecmp(name, de.name) == 0){
ffffffff80103212:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff80103216:	48 8d 50 02          	lea    0x2(%rax),%rdx
ffffffff8010321a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010321e:	48 89 d6             	mov    %rdx,%rsi
ffffffff80103221:	48 89 c7             	mov    %rax,%rdi
ffffffff80103224:	e8 53 ff ff ff       	callq  ffffffff8010317c <namecmp>
ffffffff80103229:	85 c0                	test   %eax,%eax
ffffffff8010322b:	75 2f                	jne    ffffffff8010325c <dirlookup+0xb6>
      // entry matches path element
      if(poff)
ffffffff8010322d:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
ffffffff80103232:	74 09                	je     ffffffff8010323d <dirlookup+0x97>
        *poff = off;
ffffffff80103234:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80103238:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff8010323b:	89 10                	mov    %edx,(%rax)
      inum = de.inum;
ffffffff8010323d:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffffffff80103241:	0f b7 c0             	movzwl %ax,%eax
ffffffff80103244:	89 45 f8             	mov    %eax,-0x8(%rbp)
      return iget(dp->dev, inum);
ffffffff80103247:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010324b:	8b 00                	mov    (%rax),%eax
ffffffff8010324d:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffffffff80103250:	89 d6                	mov    %edx,%esi
ffffffff80103252:	89 c7                	mov    %eax,%edi
ffffffff80103254:	e8 c0 f4 ff ff       	callq  ffffffff80102719 <iget>
ffffffff80103259:	eb 1a                	jmp    ffffffff80103275 <dirlookup+0xcf>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
ffffffff8010325b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
ffffffff8010325c:	83 45 fc 10          	addl   $0x10,-0x4(%rbp)
ffffffff80103260:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103264:	8b 40 20             	mov    0x20(%rax),%eax
ffffffff80103267:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff8010326a:	0f 87 70 ff ff ff    	ja     ffffffff801031e0 <dirlookup+0x3a>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
ffffffff80103270:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80103275:	c9                   	leaveq 
ffffffff80103276:	c3                   	retq   

ffffffff80103277 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
ffffffff80103277:	55                   	push   %rbp
ffffffff80103278:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010327b:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff8010327f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff80103283:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff80103287:	89 55 cc             	mov    %edx,-0x34(%rbp)
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
ffffffff8010328a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffffffff8010328e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103292:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80103297:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010329a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010329d:	e8 04 ff ff ff       	callq  ffffffff801031a6 <dirlookup>
ffffffff801032a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff801032a6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff801032ab:	74 16                	je     ffffffff801032c3 <dirlink+0x4c>
    iput(ip);
ffffffff801032ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801032b1:	48 89 c7             	mov    %rax,%rdi
ffffffff801032b4:	e8 9c f7 ff ff       	callq  ffffffff80102a55 <iput>
    return -1;
ffffffff801032b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801032be:	e9 a6 00 00 00       	jmpq   ffffffff80103369 <dirlink+0xf2>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffffffff801032c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801032ca:	eb 3b                	jmp    ffffffff80103307 <dirlink+0x90>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffffffff801032cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801032cf:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffffffff801032d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801032d7:	b9 10 00 00 00       	mov    $0x10,%ecx
ffffffff801032dc:	48 89 c7             	mov    %rax,%rdi
ffffffff801032df:	e8 6b fb ff ff       	callq  ffffffff80102e4f <readi>
ffffffff801032e4:	83 f8 10             	cmp    $0x10,%eax
ffffffff801032e7:	74 0c                	je     ffffffff801032f5 <dirlink+0x7e>
      panic("dirlink read");
ffffffff801032e9:	48 c7 c7 2d a8 10 80 	mov    $0xffffffff8010a82d,%rdi
ffffffff801032f0:	e8 0a d6 ff ff       	callq  ffffffff801008ff <panic>
    if(de.inum == 0)
ffffffff801032f5:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffffffff801032f9:	66 85 c0             	test   %ax,%ax
ffffffff801032fc:	74 19                	je     ffffffff80103317 <dirlink+0xa0>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
ffffffff801032fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103301:	83 c0 10             	add    $0x10,%eax
ffffffff80103304:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80103307:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010330b:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff8010330e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103311:	39 c2                	cmp    %eax,%edx
ffffffff80103313:	77 b7                	ja     ffffffff801032cc <dirlink+0x55>
ffffffff80103315:	eb 01                	jmp    ffffffff80103318 <dirlink+0xa1>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
ffffffff80103317:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
ffffffff80103318:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010331c:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffffffff80103320:	48 8d 4a 02          	lea    0x2(%rdx),%rcx
ffffffff80103324:	ba 0e 00 00 00       	mov    $0xe,%edx
ffffffff80103329:	48 89 c6             	mov    %rax,%rsi
ffffffff8010332c:	48 89 cf             	mov    %rcx,%rdi
ffffffff8010332f:	e8 08 3c 00 00       	callq  ffffffff80106f3c <strncpy>
  de.inum = inum;
ffffffff80103334:	8b 45 cc             	mov    -0x34(%rbp),%eax
ffffffff80103337:	66 89 45 e0          	mov    %ax,-0x20(%rbp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffffffff8010333b:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff8010333e:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffffffff80103342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80103346:	b9 10 00 00 00       	mov    $0x10,%ecx
ffffffff8010334b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010334e:	e8 7c fc ff ff       	callq  ffffffff80102fcf <writei>
ffffffff80103353:	83 f8 10             	cmp    $0x10,%eax
ffffffff80103356:	74 0c                	je     ffffffff80103364 <dirlink+0xed>
    panic("dirlink");
ffffffff80103358:	48 c7 c7 3a a8 10 80 	mov    $0xffffffff8010a83a,%rdi
ffffffff8010335f:	e8 9b d5 ff ff       	callq  ffffffff801008ff <panic>
  
  return 0;
ffffffff80103364:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80103369:	c9                   	leaveq 
ffffffff8010336a:	c3                   	retq   

ffffffff8010336b <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
ffffffff8010336b:	55                   	push   %rbp
ffffffff8010336c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010336f:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103373:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80103377:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s;
  int len;

  while(*path == '/')
ffffffff8010337b:	eb 05                	jmp    ffffffff80103382 <skipelem+0x17>
    path++;
ffffffff8010337d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
ffffffff80103382:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103386:	0f b6 00             	movzbl (%rax),%eax
ffffffff80103389:	3c 2f                	cmp    $0x2f,%al
ffffffff8010338b:	74 f0                	je     ffffffff8010337d <skipelem+0x12>
    path++;
  if(*path == 0)
ffffffff8010338d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103391:	0f b6 00             	movzbl (%rax),%eax
ffffffff80103394:	84 c0                	test   %al,%al
ffffffff80103396:	75 0a                	jne    ffffffff801033a2 <skipelem+0x37>
    return 0;
ffffffff80103398:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010339d:	e9 92 00 00 00       	jmpq   ffffffff80103434 <skipelem+0xc9>
  s = path;
ffffffff801033a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801033a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(*path != '/' && *path != 0)
ffffffff801033aa:	eb 05                	jmp    ffffffff801033b1 <skipelem+0x46>
    path++;
ffffffff801033ac:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
ffffffff801033b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801033b5:	0f b6 00             	movzbl (%rax),%eax
ffffffff801033b8:	3c 2f                	cmp    $0x2f,%al
ffffffff801033ba:	74 0b                	je     ffffffff801033c7 <skipelem+0x5c>
ffffffff801033bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801033c0:	0f b6 00             	movzbl (%rax),%eax
ffffffff801033c3:	84 c0                	test   %al,%al
ffffffff801033c5:	75 e5                	jne    ffffffff801033ac <skipelem+0x41>
    path++;
  len = path - s;
ffffffff801033c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff801033cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801033cf:	48 29 c2             	sub    %rax,%rdx
ffffffff801033d2:	48 89 d0             	mov    %rdx,%rax
ffffffff801033d5:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(len >= DIRSIZ)
ffffffff801033d8:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
ffffffff801033dc:	7e 1a                	jle    ffffffff801033f8 <skipelem+0x8d>
    memmove(name, s, DIRSIZ);
ffffffff801033de:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff801033e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801033e6:	ba 0e 00 00 00       	mov    $0xe,%edx
ffffffff801033eb:	48 89 ce             	mov    %rcx,%rsi
ffffffff801033ee:	48 89 c7             	mov    %rax,%rdi
ffffffff801033f1:	e8 0b 3a 00 00       	callq  ffffffff80106e01 <memmove>
ffffffff801033f6:	eb 2d                	jmp    ffffffff80103425 <skipelem+0xba>
  else {
    memmove(name, s, len);
ffffffff801033f8:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff801033fb:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff801033ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80103403:	48 89 ce             	mov    %rcx,%rsi
ffffffff80103406:	48 89 c7             	mov    %rax,%rdi
ffffffff80103409:	e8 f3 39 00 00       	callq  ffffffff80106e01 <memmove>
    name[len] = 0;
ffffffff8010340e:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80103411:	48 63 d0             	movslq %eax,%rdx
ffffffff80103414:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80103418:	48 01 d0             	add    %rdx,%rax
ffffffff8010341b:	c6 00 00             	movb   $0x0,(%rax)
  }
  while(*path == '/')
ffffffff8010341e:	eb 05                	jmp    ffffffff80103425 <skipelem+0xba>
    path++;
ffffffff80103420:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
ffffffff80103425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103429:	0f b6 00             	movzbl (%rax),%eax
ffffffff8010342c:	3c 2f                	cmp    $0x2f,%al
ffffffff8010342e:	74 f0                	je     ffffffff80103420 <skipelem+0xb5>
    path++;
  return path;
ffffffff80103430:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffffffff80103434:	c9                   	leaveq 
ffffffff80103435:	c3                   	retq   

ffffffff80103436 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
ffffffff80103436:	55                   	push   %rbp
ffffffff80103437:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010343a:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff8010343e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80103442:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffffffff80103445:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  struct inode *ip, *next;

  if(*path == '/')
ffffffff80103449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010344d:	0f b6 00             	movzbl (%rax),%eax
ffffffff80103450:	3c 2f                	cmp    $0x2f,%al
ffffffff80103452:	75 18                	jne    ffffffff8010346c <namex+0x36>
    ip = iget(ROOTDEV, ROOTINO);
ffffffff80103454:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80103459:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff8010345e:	e8 b6 f2 ff ff       	callq  ffffffff80102719 <iget>
ffffffff80103463:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80103467:	e9 c3 00 00 00       	jmpq   ffffffff8010352f <namex+0xf9>
  else
    ip = idup(proc->cwd);
ffffffff8010346c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80103473:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80103477:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffffffff8010347e:	48 89 c7             	mov    %rax,%rdi
ffffffff80103481:	e8 83 f3 ff ff       	callq  ffffffff80102809 <idup>
ffffffff80103486:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  while((path = skipelem(path, name)) != 0){
ffffffff8010348a:	e9 a0 00 00 00       	jmpq   ffffffff8010352f <namex+0xf9>
    ilock(ip);
ffffffff8010348f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103493:	48 89 c7             	mov    %rax,%rdi
ffffffff80103496:	e8 a9 f3 ff ff       	callq  ffffffff80102844 <ilock>
    if(ip->type != T_DIR){
ffffffff8010349b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010349f:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff801034a3:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff801034a7:	74 16                	je     ffffffff801034bf <namex+0x89>
      iunlockput(ip);
ffffffff801034a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801034ad:	48 89 c7             	mov    %rax,%rdi
ffffffff801034b0:	e8 85 f6 ff ff       	callq  ffffffff80102b3a <iunlockput>
      return 0;
ffffffff801034b5:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801034ba:	e9 af 00 00 00       	jmpq   ffffffff8010356e <namex+0x138>
    }
    if(nameiparent && *path == '\0'){
ffffffff801034bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffffffff801034c3:	74 20                	je     ffffffff801034e5 <namex+0xaf>
ffffffff801034c5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801034c9:	0f b6 00             	movzbl (%rax),%eax
ffffffff801034cc:	84 c0                	test   %al,%al
ffffffff801034ce:	75 15                	jne    ffffffff801034e5 <namex+0xaf>
      // Stop one level early.
      iunlock(ip);
ffffffff801034d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801034d4:	48 89 c7             	mov    %rax,%rdi
ffffffff801034d7:	e8 07 f5 ff ff       	callq  ffffffff801029e3 <iunlock>
      return ip;
ffffffff801034dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801034e0:	e9 89 00 00 00       	jmpq   ffffffff8010356e <namex+0x138>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
ffffffff801034e5:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
ffffffff801034e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801034ed:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff801034f2:	48 89 ce             	mov    %rcx,%rsi
ffffffff801034f5:	48 89 c7             	mov    %rax,%rdi
ffffffff801034f8:	e8 a9 fc ff ff       	callq  ffffffff801031a6 <dirlookup>
ffffffff801034fd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80103501:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80103506:	75 13                	jne    ffffffff8010351b <namex+0xe5>
      iunlockput(ip);
ffffffff80103508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010350c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010350f:	e8 26 f6 ff ff       	callq  ffffffff80102b3a <iunlockput>
      return 0;
ffffffff80103514:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80103519:	eb 53                	jmp    ffffffff8010356e <namex+0x138>
    }
    iunlockput(ip);
ffffffff8010351b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010351f:	48 89 c7             	mov    %rax,%rdi
ffffffff80103522:	e8 13 f6 ff ff       	callq  ffffffff80102b3a <iunlockput>
    ip = next;
ffffffff80103527:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010352b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
ffffffff8010352f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80103533:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103537:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010353a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010353d:	e8 29 fe ff ff       	callq  ffffffff8010336b <skipelem>
ffffffff80103542:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80103546:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff8010354b:	0f 85 3e ff ff ff    	jne    ffffffff8010348f <namex+0x59>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
ffffffff80103551:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
ffffffff80103555:	74 13                	je     ffffffff8010356a <namex+0x134>
    iput(ip);
ffffffff80103557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010355b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010355e:	e8 f2 f4 ff ff       	callq  ffffffff80102a55 <iput>
    return 0;
ffffffff80103563:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80103568:	eb 04                	jmp    ffffffff8010356e <namex+0x138>
  }
  return ip;
ffffffff8010356a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff8010356e:	c9                   	leaveq 
ffffffff8010356f:	c3                   	retq   

ffffffff80103570 <namei>:

struct inode*
namei(char *path)
{
ffffffff80103570:	55                   	push   %rbp
ffffffff80103571:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103574:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103578:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char name[DIRSIZ];
  return namex(path, 0, name);
ffffffff8010357c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffffffff80103580:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103584:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80103589:	48 89 c7             	mov    %rax,%rdi
ffffffff8010358c:	e8 a5 fe ff ff       	callq  ffffffff80103436 <namex>
}
ffffffff80103591:	c9                   	leaveq 
ffffffff80103592:	c3                   	retq   

ffffffff80103593 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
ffffffff80103593:	55                   	push   %rbp
ffffffff80103594:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103597:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff8010359b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff8010359f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  return namex(path, 1, name);
ffffffff801035a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff801035a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801035ab:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff801035b0:	48 89 c7             	mov    %rax,%rdi
ffffffff801035b3:	e8 7e fe ff ff       	callq  ffffffff80103436 <namex>
}
ffffffff801035b8:	c9                   	leaveq 
ffffffff801035b9:	c3                   	retq   

ffffffff801035ba <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff801035ba:	55                   	push   %rbp
ffffffff801035bb:	48 89 e5             	mov    %rsp,%rbp
ffffffff801035be:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff801035c2:	89 f8                	mov    %edi,%eax
ffffffff801035c4:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff801035c8:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff801035cc:	89 c2                	mov    %eax,%edx
ffffffff801035ce:	ec                   	in     (%dx),%al
ffffffff801035cf:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff801035d2:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff801035d6:	c9                   	leaveq 
ffffffff801035d7:	c3                   	retq   

ffffffff801035d8 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
ffffffff801035d8:	55                   	push   %rbp
ffffffff801035d9:	48 89 e5             	mov    %rsp,%rbp
ffffffff801035dc:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff801035e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff801035e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff801035e7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep insl" :
ffffffff801035ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801035ed:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffffffff801035f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801035f4:	48 89 ce             	mov    %rcx,%rsi
ffffffff801035f7:	48 89 f7             	mov    %rsi,%rdi
ffffffff801035fa:	89 c1                	mov    %eax,%ecx
ffffffff801035fc:	fc                   	cld    
ffffffff801035fd:	f3 6d                	rep insl (%dx),%es:(%rdi)
ffffffff801035ff:	89 c8                	mov    %ecx,%eax
ffffffff80103601:	48 89 fe             	mov    %rdi,%rsi
ffffffff80103604:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff80103608:	89 45 f8             	mov    %eax,-0x8(%rbp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
ffffffff8010360b:	90                   	nop
ffffffff8010360c:	c9                   	leaveq 
ffffffff8010360d:	c3                   	retq   

ffffffff8010360e <outb>:

static inline void
outb(ushort port, uchar data)
{
ffffffff8010360e:	55                   	push   %rbp
ffffffff8010360f:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103612:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103616:	89 fa                	mov    %edi,%edx
ffffffff80103618:	89 f0                	mov    %esi,%eax
ffffffff8010361a:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff8010361e:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff80103621:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff80103625:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff80103629:	ee                   	out    %al,(%dx)
}
ffffffff8010362a:	90                   	nop
ffffffff8010362b:	c9                   	leaveq 
ffffffff8010362c:	c3                   	retq   

ffffffff8010362d <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
ffffffff8010362d:	55                   	push   %rbp
ffffffff8010362e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103631:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80103635:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff80103638:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff8010363c:	89 55 f8             	mov    %edx,-0x8(%rbp)
  asm volatile("cld; rep outsl" :
ffffffff8010363f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80103642:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffffffff80103646:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80103649:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010364c:	89 c1                	mov    %eax,%ecx
ffffffff8010364e:	fc                   	cld    
ffffffff8010364f:	f3 6f                	rep outsl %ds:(%rsi),(%dx)
ffffffff80103651:	89 c8                	mov    %ecx,%eax
ffffffff80103653:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff80103657:	89 45 f8             	mov    %eax,-0x8(%rbp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
ffffffff8010365a:	90                   	nop
ffffffff8010365b:	c9                   	leaveq 
ffffffff8010365c:	c3                   	retq   

ffffffff8010365d <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
ffffffff8010365d:	55                   	push   %rbp
ffffffff8010365e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103661:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80103665:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
ffffffff80103668:	90                   	nop
ffffffff80103669:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffffffff8010366e:	e8 47 ff ff ff       	callq  ffffffff801035ba <inb>
ffffffff80103673:	0f b6 c0             	movzbl %al,%eax
ffffffff80103676:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80103679:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010367c:	25 c0 00 00 00       	and    $0xc0,%eax
ffffffff80103681:	83 f8 40             	cmp    $0x40,%eax
ffffffff80103684:	75 e3                	jne    ffffffff80103669 <idewait+0xc>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
ffffffff80103686:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff8010368a:	74 11                	je     ffffffff8010369d <idewait+0x40>
ffffffff8010368c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010368f:	83 e0 21             	and    $0x21,%eax
ffffffff80103692:	85 c0                	test   %eax,%eax
ffffffff80103694:	74 07                	je     ffffffff8010369d <idewait+0x40>
    return -1;
ffffffff80103696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010369b:	eb 05                	jmp    ffffffff801036a2 <idewait+0x45>
  return 0;
ffffffff8010369d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801036a2:	c9                   	leaveq 
ffffffff801036a3:	c3                   	retq   

ffffffff801036a4 <ideinit>:

void
ideinit(void)
{
ffffffff801036a4:	55                   	push   %rbp
ffffffff801036a5:	48 89 e5             	mov    %rsp,%rbp
ffffffff801036a8:	48 83 ec 10          	sub    $0x10,%rsp
  int i;
  
  initlock(&idelock, "ide");
ffffffff801036ac:	48 c7 c6 42 a8 10 80 	mov    $0xffffffff8010a842,%rsi
ffffffff801036b3:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff801036ba:	e8 af 32 00 00       	callq  ffffffff8010696e <initlock>
  picenable(IRQ_IDE);
ffffffff801036bf:	bf 0e 00 00 00       	mov    $0xe,%edi
ffffffff801036c4:	e8 d7 1f 00 00       	callq  ffffffff801056a0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
ffffffff801036c9:	8b 05 95 f8 00 00    	mov    0xf895(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff801036cf:	83 e8 01             	sub    $0x1,%eax
ffffffff801036d2:	89 c6                	mov    %eax,%esi
ffffffff801036d4:	bf 0e 00 00 00       	mov    $0xe,%edi
ffffffff801036d9:	e8 67 04 00 00       	callq  ffffffff80103b45 <ioapicenable>
  idewait(0);
ffffffff801036de:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801036e3:	e8 75 ff ff ff       	callq  ffffffff8010365d <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
ffffffff801036e8:	be f0 00 00 00       	mov    $0xf0,%esi
ffffffff801036ed:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffffffff801036f2:	e8 17 ff ff ff       	callq  ffffffff8010360e <outb>
  for(i=0; i<1000; i++){
ffffffff801036f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801036fe:	eb 1e                	jmp    ffffffff8010371e <ideinit+0x7a>
    if(inb(0x1f7) != 0){
ffffffff80103700:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffffffff80103705:	e8 b0 fe ff ff       	callq  ffffffff801035ba <inb>
ffffffff8010370a:	84 c0                	test   %al,%al
ffffffff8010370c:	74 0c                	je     ffffffff8010371a <ideinit+0x76>
      havedisk1 = 1;
ffffffff8010370e:	c7 05 18 ef 00 00 01 	movl   $0x1,0xef18(%rip)        # ffffffff80112630 <havedisk1>
ffffffff80103715:	00 00 00 
      break;
ffffffff80103718:	eb 0d                	jmp    ffffffff80103727 <ideinit+0x83>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
ffffffff8010371a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010371e:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
ffffffff80103725:	7e d9                	jle    ffffffff80103700 <ideinit+0x5c>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
ffffffff80103727:	be e0 00 00 00       	mov    $0xe0,%esi
ffffffff8010372c:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffffffff80103731:	e8 d8 fe ff ff       	callq  ffffffff8010360e <outb>
}
ffffffff80103736:	90                   	nop
ffffffff80103737:	c9                   	leaveq 
ffffffff80103738:	c3                   	retq   

ffffffff80103739 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
ffffffff80103739:	55                   	push   %rbp
ffffffff8010373a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010373d:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103741:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  if(b == 0)
ffffffff80103745:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff8010374a:	75 0c                	jne    ffffffff80103758 <idestart+0x1f>
    panic("idestart");
ffffffff8010374c:	48 c7 c7 46 a8 10 80 	mov    $0xffffffff8010a846,%rdi
ffffffff80103753:	e8 a7 d1 ff ff       	callq  ffffffff801008ff <panic>
  if(b->blockno >= FSSIZE)
ffffffff80103758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010375c:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff8010375f:	3d e7 03 00 00       	cmp    $0x3e7,%eax
ffffffff80103764:	76 0c                	jbe    ffffffff80103772 <idestart+0x39>
    panic("incorrect blockno");
ffffffff80103766:	48 c7 c7 4f a8 10 80 	mov    $0xffffffff8010a84f,%rdi
ffffffff8010376d:	e8 8d d1 ff ff       	callq  ffffffff801008ff <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
ffffffff80103772:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  int sector = b->blockno * sector_per_block;
ffffffff80103779:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010377d:	8b 50 08             	mov    0x8(%rax),%edx
ffffffff80103780:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103783:	0f af c2             	imul   %edx,%eax
ffffffff80103786:	89 45 f8             	mov    %eax,-0x8(%rbp)

  if (sector_per_block > 7) panic("idestart");
ffffffff80103789:	83 7d fc 07          	cmpl   $0x7,-0x4(%rbp)
ffffffff8010378d:	7e 0c                	jle    ffffffff8010379b <idestart+0x62>
ffffffff8010378f:	48 c7 c7 46 a8 10 80 	mov    $0xffffffff8010a846,%rdi
ffffffff80103796:	e8 64 d1 ff ff       	callq  ffffffff801008ff <panic>
  
  idewait(0);
ffffffff8010379b:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801037a0:	e8 b8 fe ff ff       	callq  ffffffff8010365d <idewait>
  outb(0x3f6, 0);  // generate interrupt
ffffffff801037a5:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801037aa:	bf f6 03 00 00       	mov    $0x3f6,%edi
ffffffff801037af:	e8 5a fe ff ff       	callq  ffffffff8010360e <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
ffffffff801037b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801037b7:	0f b6 c0             	movzbl %al,%eax
ffffffff801037ba:	89 c6                	mov    %eax,%esi
ffffffff801037bc:	bf f2 01 00 00       	mov    $0x1f2,%edi
ffffffff801037c1:	e8 48 fe ff ff       	callq  ffffffff8010360e <outb>
  outb(0x1f3, sector & 0xff);
ffffffff801037c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801037c9:	0f b6 c0             	movzbl %al,%eax
ffffffff801037cc:	89 c6                	mov    %eax,%esi
ffffffff801037ce:	bf f3 01 00 00       	mov    $0x1f3,%edi
ffffffff801037d3:	e8 36 fe ff ff       	callq  ffffffff8010360e <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
ffffffff801037d8:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801037db:	c1 f8 08             	sar    $0x8,%eax
ffffffff801037de:	0f b6 c0             	movzbl %al,%eax
ffffffff801037e1:	89 c6                	mov    %eax,%esi
ffffffff801037e3:	bf f4 01 00 00       	mov    $0x1f4,%edi
ffffffff801037e8:	e8 21 fe ff ff       	callq  ffffffff8010360e <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
ffffffff801037ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff801037f0:	c1 f8 10             	sar    $0x10,%eax
ffffffff801037f3:	0f b6 c0             	movzbl %al,%eax
ffffffff801037f6:	89 c6                	mov    %eax,%esi
ffffffff801037f8:	bf f5 01 00 00       	mov    $0x1f5,%edi
ffffffff801037fd:	e8 0c fe ff ff       	callq  ffffffff8010360e <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
ffffffff80103802:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103806:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80103809:	83 e0 01             	and    $0x1,%eax
ffffffff8010380c:	c1 e0 04             	shl    $0x4,%eax
ffffffff8010380f:	89 c2                	mov    %eax,%edx
ffffffff80103811:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80103814:	c1 f8 18             	sar    $0x18,%eax
ffffffff80103817:	83 e0 0f             	and    $0xf,%eax
ffffffff8010381a:	09 d0                	or     %edx,%eax
ffffffff8010381c:	83 c8 e0             	or     $0xffffffe0,%eax
ffffffff8010381f:	0f b6 c0             	movzbl %al,%eax
ffffffff80103822:	89 c6                	mov    %eax,%esi
ffffffff80103824:	bf f6 01 00 00       	mov    $0x1f6,%edi
ffffffff80103829:	e8 e0 fd ff ff       	callq  ffffffff8010360e <outb>
  if(b->flags & B_DIRTY){
ffffffff8010382e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103832:	8b 00                	mov    (%rax),%eax
ffffffff80103834:	83 e0 04             	and    $0x4,%eax
ffffffff80103837:	85 c0                	test   %eax,%eax
ffffffff80103839:	74 2b                	je     ffffffff80103866 <idestart+0x12d>
    outb(0x1f7, IDE_CMD_WRITE);
ffffffff8010383b:	be 30 00 00 00       	mov    $0x30,%esi
ffffffff80103840:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffffffff80103845:	e8 c4 fd ff ff       	callq  ffffffff8010360e <outb>
    outsl(0x1f0, b->data, BSIZE/4);
ffffffff8010384a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010384e:	48 83 c0 28          	add    $0x28,%rax
ffffffff80103852:	ba 80 00 00 00       	mov    $0x80,%edx
ffffffff80103857:	48 89 c6             	mov    %rax,%rsi
ffffffff8010385a:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffffffff8010385f:	e8 c9 fd ff ff       	callq  ffffffff8010362d <outsl>
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
ffffffff80103864:	eb 0f                	jmp    ffffffff80103875 <idestart+0x13c>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
ffffffff80103866:	be 20 00 00 00       	mov    $0x20,%esi
ffffffff8010386b:	bf f7 01 00 00       	mov    $0x1f7,%edi
ffffffff80103870:	e8 99 fd ff ff       	callq  ffffffff8010360e <outb>
  }
}
ffffffff80103875:	90                   	nop
ffffffff80103876:	c9                   	leaveq 
ffffffff80103877:	c3                   	retq   

ffffffff80103878 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
ffffffff80103878:	55                   	push   %rbp
ffffffff80103879:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010387c:	48 83 ec 10          	sub    $0x10,%rsp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
ffffffff80103880:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff80103887:	e8 17 31 00 00       	callq  ffffffff801069a3 <acquire>
  if((b = idequeue) == 0){
ffffffff8010388c:	48 8b 05 95 ed 00 00 	mov    0xed95(%rip),%rax        # ffffffff80112628 <idequeue>
ffffffff80103893:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80103897:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff8010389c:	75 11                	jne    ffffffff801038af <ideintr+0x37>
    release(&idelock);
ffffffff8010389e:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff801038a5:	e8 d0 31 00 00       	callq  ffffffff80106a7a <release>
    // cprintf("spurious IDE interrupt\n");
    return;
ffffffff801038aa:	e9 99 00 00 00       	jmpq   ffffffff80103948 <ideintr+0xd0>
  }
  idequeue = b->qnext;
ffffffff801038af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801038b3:	48 8b 40 20          	mov    0x20(%rax),%rax
ffffffff801038b7:	48 89 05 6a ed 00 00 	mov    %rax,0xed6a(%rip)        # ffffffff80112628 <idequeue>

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
ffffffff801038be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801038c2:	8b 00                	mov    (%rax),%eax
ffffffff801038c4:	83 e0 04             	and    $0x4,%eax
ffffffff801038c7:	85 c0                	test   %eax,%eax
ffffffff801038c9:	75 28                	jne    ffffffff801038f3 <ideintr+0x7b>
ffffffff801038cb:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801038d0:	e8 88 fd ff ff       	callq  ffffffff8010365d <idewait>
ffffffff801038d5:	85 c0                	test   %eax,%eax
ffffffff801038d7:	78 1a                	js     ffffffff801038f3 <ideintr+0x7b>
    insl(0x1f0, b->data, BSIZE/4);
ffffffff801038d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801038dd:	48 83 c0 28          	add    $0x28,%rax
ffffffff801038e1:	ba 80 00 00 00       	mov    $0x80,%edx
ffffffff801038e6:	48 89 c6             	mov    %rax,%rsi
ffffffff801038e9:	bf f0 01 00 00       	mov    $0x1f0,%edi
ffffffff801038ee:	e8 e5 fc ff ff       	callq  ffffffff801035d8 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
ffffffff801038f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801038f7:	8b 00                	mov    (%rax),%eax
ffffffff801038f9:	83 c8 02             	or     $0x2,%eax
ffffffff801038fc:	89 c2                	mov    %eax,%edx
ffffffff801038fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103902:	89 10                	mov    %edx,(%rax)
  b->flags &= ~B_DIRTY;
ffffffff80103904:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103908:	8b 00                	mov    (%rax),%eax
ffffffff8010390a:	83 e0 fb             	and    $0xfffffffb,%eax
ffffffff8010390d:	89 c2                	mov    %eax,%edx
ffffffff8010390f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103913:	89 10                	mov    %edx,(%rax)
  wakeup(b);
ffffffff80103915:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103919:	48 89 c7             	mov    %rax,%rdi
ffffffff8010391c:	e8 18 2e 00 00       	callq  ffffffff80106739 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
ffffffff80103921:	48 8b 05 00 ed 00 00 	mov    0xed00(%rip),%rax        # ffffffff80112628 <idequeue>
ffffffff80103928:	48 85 c0             	test   %rax,%rax
ffffffff8010392b:	74 0f                	je     ffffffff8010393c <ideintr+0xc4>
    idestart(idequeue);
ffffffff8010392d:	48 8b 05 f4 ec 00 00 	mov    0xecf4(%rip),%rax        # ffffffff80112628 <idequeue>
ffffffff80103934:	48 89 c7             	mov    %rax,%rdi
ffffffff80103937:	e8 fd fd ff ff       	callq  ffffffff80103739 <idestart>

  release(&idelock);
ffffffff8010393c:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff80103943:	e8 32 31 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80103948:	c9                   	leaveq 
ffffffff80103949:	c3                   	retq   

ffffffff8010394a <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
ffffffff8010394a:	55                   	push   %rbp
ffffffff8010394b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010394e:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103952:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct buf **pp;

  if(!(b->flags & B_BUSY))
ffffffff80103956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010395a:	8b 00                	mov    (%rax),%eax
ffffffff8010395c:	83 e0 01             	and    $0x1,%eax
ffffffff8010395f:	85 c0                	test   %eax,%eax
ffffffff80103961:	75 0c                	jne    ffffffff8010396f <iderw+0x25>
    panic("iderw: buf not busy");
ffffffff80103963:	48 c7 c7 61 a8 10 80 	mov    $0xffffffff8010a861,%rdi
ffffffff8010396a:	e8 90 cf ff ff       	callq  ffffffff801008ff <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
ffffffff8010396f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103973:	8b 00                	mov    (%rax),%eax
ffffffff80103975:	83 e0 06             	and    $0x6,%eax
ffffffff80103978:	83 f8 02             	cmp    $0x2,%eax
ffffffff8010397b:	75 0c                	jne    ffffffff80103989 <iderw+0x3f>
    panic("iderw: nothing to do");
ffffffff8010397d:	48 c7 c7 75 a8 10 80 	mov    $0xffffffff8010a875,%rdi
ffffffff80103984:	e8 76 cf ff ff       	callq  ffffffff801008ff <panic>
  if(b->dev != 0 && !havedisk1)
ffffffff80103989:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010398d:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80103990:	85 c0                	test   %eax,%eax
ffffffff80103992:	74 16                	je     ffffffff801039aa <iderw+0x60>
ffffffff80103994:	8b 05 96 ec 00 00    	mov    0xec96(%rip),%eax        # ffffffff80112630 <havedisk1>
ffffffff8010399a:	85 c0                	test   %eax,%eax
ffffffff8010399c:	75 0c                	jne    ffffffff801039aa <iderw+0x60>
    panic("iderw: ide disk 1 not present");
ffffffff8010399e:	48 c7 c7 8a a8 10 80 	mov    $0xffffffff8010a88a,%rdi
ffffffff801039a5:	e8 55 cf ff ff       	callq  ffffffff801008ff <panic>

  acquire(&idelock);  //DOC:acquire-lock
ffffffff801039aa:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff801039b1:	e8 ed 2f 00 00       	callq  ffffffff801069a3 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
ffffffff801039b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801039ba:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffffffff801039c1:	00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
ffffffff801039c2:	48 c7 45 f8 28 26 11 	movq   $0xffffffff80112628,-0x8(%rbp)
ffffffff801039c9:	80 
ffffffff801039ca:	eb 0f                	jmp    ffffffff801039db <iderw+0x91>
ffffffff801039cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801039d0:	48 8b 00             	mov    (%rax),%rax
ffffffff801039d3:	48 83 c0 20          	add    $0x20,%rax
ffffffff801039d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff801039db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801039df:	48 8b 00             	mov    (%rax),%rax
ffffffff801039e2:	48 85 c0             	test   %rax,%rax
ffffffff801039e5:	75 e5                	jne    ffffffff801039cc <iderw+0x82>
    ;
  *pp = b;
ffffffff801039e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801039eb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff801039ef:	48 89 10             	mov    %rdx,(%rax)
  
  // Start disk if necessary.
  if(idequeue == b)
ffffffff801039f2:	48 8b 05 2f ec 00 00 	mov    0xec2f(%rip),%rax        # ffffffff80112628 <idequeue>
ffffffff801039f9:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff801039fd:	75 21                	jne    ffffffff80103a20 <iderw+0xd6>
    idestart(b);
ffffffff801039ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103a03:	48 89 c7             	mov    %rax,%rdi
ffffffff80103a06:	e8 2e fd ff ff       	callq  ffffffff80103739 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffffffff80103a0b:	eb 13                	jmp    ffffffff80103a20 <iderw+0xd6>
    sleep(b, &idelock);
ffffffff80103a0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103a11:	48 c7 c6 c0 25 11 80 	mov    $0xffffffff801125c0,%rsi
ffffffff80103a18:	48 89 c7             	mov    %rax,%rdi
ffffffff80103a1b:	e8 06 2c 00 00       	callq  ffffffff80106626 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
ffffffff80103a20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103a24:	8b 00                	mov    (%rax),%eax
ffffffff80103a26:	83 e0 06             	and    $0x6,%eax
ffffffff80103a29:	83 f8 02             	cmp    $0x2,%eax
ffffffff80103a2c:	75 df                	jne    ffffffff80103a0d <iderw+0xc3>
    sleep(b, &idelock);
  }

  release(&idelock);
ffffffff80103a2e:	48 c7 c7 c0 25 11 80 	mov    $0xffffffff801125c0,%rdi
ffffffff80103a35:	e8 40 30 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80103a3a:	90                   	nop
ffffffff80103a3b:	c9                   	leaveq 
ffffffff80103a3c:	c3                   	retq   

ffffffff80103a3d <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
ffffffff80103a3d:	55                   	push   %rbp
ffffffff80103a3e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103a41:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103a45:	89 7d fc             	mov    %edi,-0x4(%rbp)
  ioapic->reg = reg;
ffffffff80103a48:	48 8b 05 e9 eb 00 00 	mov    0xebe9(%rip),%rax        # ffffffff80112638 <ioapic>
ffffffff80103a4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80103a52:	89 10                	mov    %edx,(%rax)
  return ioapic->data;
ffffffff80103a54:	48 8b 05 dd eb 00 00 	mov    0xebdd(%rip),%rax        # ffffffff80112638 <ioapic>
ffffffff80103a5b:	8b 40 10             	mov    0x10(%rax),%eax
}
ffffffff80103a5e:	c9                   	leaveq 
ffffffff80103a5f:	c3                   	retq   

ffffffff80103a60 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
ffffffff80103a60:	55                   	push   %rbp
ffffffff80103a61:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103a64:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103a68:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff80103a6b:	89 75 f8             	mov    %esi,-0x8(%rbp)
  ioapic->reg = reg;
ffffffff80103a6e:	48 8b 05 c3 eb 00 00 	mov    0xebc3(%rip),%rax        # ffffffff80112638 <ioapic>
ffffffff80103a75:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80103a78:	89 10                	mov    %edx,(%rax)
  ioapic->data = data;
ffffffff80103a7a:	48 8b 05 b7 eb 00 00 	mov    0xebb7(%rip),%rax        # ffffffff80112638 <ioapic>
ffffffff80103a81:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffffffff80103a84:	89 50 10             	mov    %edx,0x10(%rax)
}
ffffffff80103a87:	90                   	nop
ffffffff80103a88:	c9                   	leaveq 
ffffffff80103a89:	c3                   	retq   

ffffffff80103a8a <ioapicinit>:

void
ioapicinit(void)
{
ffffffff80103a8a:	55                   	push   %rbp
ffffffff80103a8b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103a8e:	48 83 ec 10          	sub    $0x10,%rsp
  int i, id, maxintr;

  if(!ismp)
ffffffff80103a92:	8b 05 c8 f4 00 00    	mov    0xf4c8(%rip),%eax        # ffffffff80112f60 <ismp>
ffffffff80103a98:	85 c0                	test   %eax,%eax
ffffffff80103a9a:	0f 84 a2 00 00 00    	je     ffffffff80103b42 <ioapicinit+0xb8>
    return;

  ioapic = (volatile struct ioapic*) IO2V(IOAPIC);
ffffffff80103aa0:	48 b8 00 00 c0 40 ff 	movabs $0xffffffff40c00000,%rax
ffffffff80103aa7:	ff ff ff 
ffffffff80103aaa:	48 89 05 87 eb 00 00 	mov    %rax,0xeb87(%rip)        # ffffffff80112638 <ioapic>
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
ffffffff80103ab1:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80103ab6:	e8 82 ff ff ff       	callq  ffffffff80103a3d <ioapicread>
ffffffff80103abb:	c1 e8 10             	shr    $0x10,%eax
ffffffff80103abe:	25 ff 00 00 00       	and    $0xff,%eax
ffffffff80103ac3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  id = ioapicread(REG_ID) >> 24;
ffffffff80103ac6:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80103acb:	e8 6d ff ff ff       	callq  ffffffff80103a3d <ioapicread>
ffffffff80103ad0:	c1 e8 18             	shr    $0x18,%eax
ffffffff80103ad3:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if(id != ioapicid)
ffffffff80103ad6:	0f b6 05 8b f4 00 00 	movzbl 0xf48b(%rip),%eax        # ffffffff80112f68 <ioapicid>
ffffffff80103add:	0f b6 c0             	movzbl %al,%eax
ffffffff80103ae0:	3b 45 f4             	cmp    -0xc(%rbp),%eax
ffffffff80103ae3:	74 11                	je     ffffffff80103af6 <ioapicinit+0x6c>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
ffffffff80103ae5:	48 c7 c7 a8 a8 10 80 	mov    $0xffffffff8010a8a8,%rdi
ffffffff80103aec:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80103af1:	e8 ac ca ff ff       	callq  ffffffff801005a2 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffffffff80103af6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80103afd:	eb 39                	jmp    ffffffff80103b38 <ioapicinit+0xae>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
ffffffff80103aff:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b02:	83 c0 20             	add    $0x20,%eax
ffffffff80103b05:	0d 00 00 01 00       	or     $0x10000,%eax
ffffffff80103b0a:	89 c2                	mov    %eax,%edx
ffffffff80103b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b0f:	83 c0 08             	add    $0x8,%eax
ffffffff80103b12:	01 c0                	add    %eax,%eax
ffffffff80103b14:	89 d6                	mov    %edx,%esi
ffffffff80103b16:	89 c7                	mov    %eax,%edi
ffffffff80103b18:	e8 43 ff ff ff       	callq  ffffffff80103a60 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
ffffffff80103b1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b20:	83 c0 08             	add    $0x8,%eax
ffffffff80103b23:	01 c0                	add    %eax,%eax
ffffffff80103b25:	83 c0 01             	add    $0x1,%eax
ffffffff80103b28:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80103b2d:	89 c7                	mov    %eax,%edi
ffffffff80103b2f:	e8 2c ff ff ff       	callq  ffffffff80103a60 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
ffffffff80103b34:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80103b38:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b3b:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffffffff80103b3e:	7e bf                	jle    ffffffff80103aff <ioapicinit+0x75>
ffffffff80103b40:	eb 01                	jmp    ffffffff80103b43 <ioapicinit+0xb9>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
ffffffff80103b42:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
ffffffff80103b43:	c9                   	leaveq 
ffffffff80103b44:	c3                   	retq   

ffffffff80103b45 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
ffffffff80103b45:	55                   	push   %rbp
ffffffff80103b46:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103b49:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103b4d:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff80103b50:	89 75 f8             	mov    %esi,-0x8(%rbp)
  if(!ismp)
ffffffff80103b53:	8b 05 07 f4 00 00    	mov    0xf407(%rip),%eax        # ffffffff80112f60 <ismp>
ffffffff80103b59:	85 c0                	test   %eax,%eax
ffffffff80103b5b:	74 37                	je     ffffffff80103b94 <ioapicenable+0x4f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
ffffffff80103b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b60:	83 c0 20             	add    $0x20,%eax
ffffffff80103b63:	89 c2                	mov    %eax,%edx
ffffffff80103b65:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b68:	83 c0 08             	add    $0x8,%eax
ffffffff80103b6b:	01 c0                	add    %eax,%eax
ffffffff80103b6d:	89 d6                	mov    %edx,%esi
ffffffff80103b6f:	89 c7                	mov    %eax,%edi
ffffffff80103b71:	e8 ea fe ff ff       	callq  ffffffff80103a60 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
ffffffff80103b76:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80103b79:	c1 e0 18             	shl    $0x18,%eax
ffffffff80103b7c:	89 c2                	mov    %eax,%edx
ffffffff80103b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103b81:	83 c0 08             	add    $0x8,%eax
ffffffff80103b84:	01 c0                	add    %eax,%eax
ffffffff80103b86:	83 c0 01             	add    $0x1,%eax
ffffffff80103b89:	89 d6                	mov    %edx,%esi
ffffffff80103b8b:	89 c7                	mov    %eax,%edi
ffffffff80103b8d:	e8 ce fe ff ff       	callq  ffffffff80103a60 <ioapicwrite>
ffffffff80103b92:	eb 01                	jmp    ffffffff80103b95 <ioapicenable+0x50>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
ffffffff80103b94:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
ffffffff80103b95:	c9                   	leaveq 
ffffffff80103b96:	c3                   	retq   

ffffffff80103b97 <v2p>:
#endif
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uintp v2p(void *a) { return ((uintp) (a)) - ((uintp)KERNBASE); }
ffffffff80103b97:	55                   	push   %rbp
ffffffff80103b98:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103b9b:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103b9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80103ba3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80103ba7:	b8 00 00 00 80       	mov    $0x80000000,%eax
ffffffff80103bac:	48 01 d0             	add    %rdx,%rax
ffffffff80103baf:	c9                   	leaveq 
ffffffff80103bb0:	c3                   	retq   

ffffffff80103bb1 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
ffffffff80103bb1:	55                   	push   %rbp
ffffffff80103bb2:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103bb5:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80103bb9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80103bbd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  initlock(&kmem.lock, "kmem");
ffffffff80103bc1:	48 c7 c6 da a8 10 80 	mov    $0xffffffff8010a8da,%rsi
ffffffff80103bc8:	48 c7 c7 40 26 11 80 	mov    $0xffffffff80112640,%rdi
ffffffff80103bcf:	e8 9a 2d 00 00       	callq  ffffffff8010696e <initlock>
  kmem.use_lock = 0;
ffffffff80103bd4:	c7 05 ca ea 00 00 00 	movl   $0x0,0xeaca(%rip)        # ffffffff801126a8 <kmem+0x68>
ffffffff80103bdb:	00 00 00 
  freerange(vstart, vend);
ffffffff80103bde:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80103be2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103be6:	48 89 d6             	mov    %rdx,%rsi
ffffffff80103be9:	48 89 c7             	mov    %rax,%rdi
ffffffff80103bec:	e8 33 00 00 00       	callq  ffffffff80103c24 <freerange>
}
ffffffff80103bf1:	90                   	nop
ffffffff80103bf2:	c9                   	leaveq 
ffffffff80103bf3:	c3                   	retq   

ffffffff80103bf4 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
ffffffff80103bf4:	55                   	push   %rbp
ffffffff80103bf5:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103bf8:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80103bfc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80103c00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  freerange(vstart, vend);
ffffffff80103c04:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80103c08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103c0c:	48 89 d6             	mov    %rdx,%rsi
ffffffff80103c0f:	48 89 c7             	mov    %rax,%rdi
ffffffff80103c12:	e8 0d 00 00 00       	callq  ffffffff80103c24 <freerange>
  kmem.use_lock = 1;
ffffffff80103c17:	c7 05 87 ea 00 00 01 	movl   $0x1,0xea87(%rip)        # ffffffff801126a8 <kmem+0x68>
ffffffff80103c1e:	00 00 00 
}
ffffffff80103c21:	90                   	nop
ffffffff80103c22:	c9                   	leaveq 
ffffffff80103c23:	c3                   	retq   

ffffffff80103c24 <freerange>:

void
freerange(void *vstart, void *vend)
{
ffffffff80103c24:	55                   	push   %rbp
ffffffff80103c25:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103c28:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103c2c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80103c30:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *p;
  p = (char*)PGROUNDUP((uintp)vstart);
ffffffff80103c34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103c38:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff80103c3e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80103c44:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffffffff80103c48:	eb 14                	jmp    ffffffff80103c5e <freerange+0x3a>
    kfree(p);
ffffffff80103c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103c4e:	48 89 c7             	mov    %rax,%rdi
ffffffff80103c51:	e8 1b 00 00 00       	callq  ffffffff80103c71 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uintp)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
ffffffff80103c56:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffffffff80103c5d:	00 
ffffffff80103c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103c62:	48 05 00 10 00 00    	add    $0x1000,%rax
ffffffff80103c68:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffffffff80103c6c:	76 dc                	jbe    ffffffff80103c4a <freerange+0x26>
    kfree(p);
}
ffffffff80103c6e:	90                   	nop
ffffffff80103c6f:	c9                   	leaveq 
ffffffff80103c70:	c3                   	retq   

ffffffff80103c71 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
ffffffff80103c71:	55                   	push   %rbp
ffffffff80103c72:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103c75:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80103c79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct run *r;

  if((uintp)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
ffffffff80103c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103c81:	25 ff 0f 00 00       	and    $0xfff,%eax
ffffffff80103c86:	48 85 c0             	test   %rax,%rax
ffffffff80103c89:	75 1e                	jne    ffffffff80103ca9 <kfree+0x38>
ffffffff80103c8b:	48 81 7d e8 00 80 11 	cmpq   $0xffffffff80118000,-0x18(%rbp)
ffffffff80103c92:	80 
ffffffff80103c93:	72 14                	jb     ffffffff80103ca9 <kfree+0x38>
ffffffff80103c95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103c99:	48 89 c7             	mov    %rax,%rdi
ffffffff80103c9c:	e8 f6 fe ff ff       	callq  ffffffff80103b97 <v2p>
ffffffff80103ca1:	48 3d ff ff ff 0d    	cmp    $0xdffffff,%rax
ffffffff80103ca7:	76 0c                	jbe    ffffffff80103cb5 <kfree+0x44>
    panic("kfree");
ffffffff80103ca9:	48 c7 c7 df a8 10 80 	mov    $0xffffffff8010a8df,%rdi
ffffffff80103cb0:	e8 4a cc ff ff       	callq  ffffffff801008ff <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
ffffffff80103cb5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103cb9:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80103cbe:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80103cc3:	48 89 c7             	mov    %rax,%rdi
ffffffff80103cc6:	e8 47 30 00 00       	callq  ffffffff80106d12 <memset>

  if(kmem.use_lock)
ffffffff80103ccb:	8b 05 d7 e9 00 00    	mov    0xe9d7(%rip),%eax        # ffffffff801126a8 <kmem+0x68>
ffffffff80103cd1:	85 c0                	test   %eax,%eax
ffffffff80103cd3:	74 0c                	je     ffffffff80103ce1 <kfree+0x70>
    acquire(&kmem.lock);
ffffffff80103cd5:	48 c7 c7 40 26 11 80 	mov    $0xffffffff80112640,%rdi
ffffffff80103cdc:	e8 c2 2c 00 00       	callq  ffffffff801069a3 <acquire>
  r = (struct run*)v;
ffffffff80103ce1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80103ce5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  r->next = kmem.freelist;
ffffffff80103ce9:	48 8b 15 c0 e9 00 00 	mov    0xe9c0(%rip),%rdx        # ffffffff801126b0 <kmem+0x70>
ffffffff80103cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103cf4:	48 89 10             	mov    %rdx,(%rax)
  kmem.freelist = r;
ffffffff80103cf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103cfb:	48 89 05 ae e9 00 00 	mov    %rax,0xe9ae(%rip)        # ffffffff801126b0 <kmem+0x70>
  if(kmem.use_lock)
ffffffff80103d02:	8b 05 a0 e9 00 00    	mov    0xe9a0(%rip),%eax        # ffffffff801126a8 <kmem+0x68>
ffffffff80103d08:	85 c0                	test   %eax,%eax
ffffffff80103d0a:	74 0c                	je     ffffffff80103d18 <kfree+0xa7>
    release(&kmem.lock);
ffffffff80103d0c:	48 c7 c7 40 26 11 80 	mov    $0xffffffff80112640,%rdi
ffffffff80103d13:	e8 62 2d 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80103d18:	90                   	nop
ffffffff80103d19:	c9                   	leaveq 
ffffffff80103d1a:	c3                   	retq   

ffffffff80103d1b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
ffffffff80103d1b:	55                   	push   %rbp
ffffffff80103d1c:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103d1f:	48 83 ec 10          	sub    $0x10,%rsp
  struct run *r;

  if(kmem.use_lock)
ffffffff80103d23:	8b 05 7f e9 00 00    	mov    0xe97f(%rip),%eax        # ffffffff801126a8 <kmem+0x68>
ffffffff80103d29:	85 c0                	test   %eax,%eax
ffffffff80103d2b:	74 0c                	je     ffffffff80103d39 <kalloc+0x1e>
    acquire(&kmem.lock);
ffffffff80103d2d:	48 c7 c7 40 26 11 80 	mov    $0xffffffff80112640,%rdi
ffffffff80103d34:	e8 6a 2c 00 00       	callq  ffffffff801069a3 <acquire>
  r = kmem.freelist;
ffffffff80103d39:	48 8b 05 70 e9 00 00 	mov    0xe970(%rip),%rax        # ffffffff801126b0 <kmem+0x70>
ffffffff80103d40:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(r)
ffffffff80103d44:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80103d49:	74 0e                	je     ffffffff80103d59 <kalloc+0x3e>
    kmem.freelist = r->next;
ffffffff80103d4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80103d4f:	48 8b 00             	mov    (%rax),%rax
ffffffff80103d52:	48 89 05 57 e9 00 00 	mov    %rax,0xe957(%rip)        # ffffffff801126b0 <kmem+0x70>
  if(kmem.use_lock)
ffffffff80103d59:	8b 05 49 e9 00 00    	mov    0xe949(%rip),%eax        # ffffffff801126a8 <kmem+0x68>
ffffffff80103d5f:	85 c0                	test   %eax,%eax
ffffffff80103d61:	74 0c                	je     ffffffff80103d6f <kalloc+0x54>
    release(&kmem.lock);
ffffffff80103d63:	48 c7 c7 40 26 11 80 	mov    $0xffffffff80112640,%rdi
ffffffff80103d6a:	e8 0b 2d 00 00       	callq  ffffffff80106a7a <release>
  return (char*)r;
ffffffff80103d6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80103d73:	c9                   	leaveq 
ffffffff80103d74:	c3                   	retq   

ffffffff80103d75 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff80103d75:	55                   	push   %rbp
ffffffff80103d76:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103d79:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80103d7d:	89 f8                	mov    %edi,%eax
ffffffff80103d7f:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff80103d83:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff80103d87:	89 c2                	mov    %eax,%edx
ffffffff80103d89:	ec                   	in     (%dx),%al
ffffffff80103d8a:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff80103d8d:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff80103d91:	c9                   	leaveq 
ffffffff80103d92:	c3                   	retq   

ffffffff80103d93 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
ffffffff80103d93:	55                   	push   %rbp
ffffffff80103d94:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103d97:	48 83 ec 10          	sub    $0x10,%rsp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
ffffffff80103d9b:	bf 64 00 00 00       	mov    $0x64,%edi
ffffffff80103da0:	e8 d0 ff ff ff       	callq  ffffffff80103d75 <inb>
ffffffff80103da5:	0f b6 c0             	movzbl %al,%eax
ffffffff80103da8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  if((st & KBS_DIB) == 0)
ffffffff80103dab:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80103dae:	83 e0 01             	and    $0x1,%eax
ffffffff80103db1:	85 c0                	test   %eax,%eax
ffffffff80103db3:	75 0a                	jne    ffffffff80103dbf <kbdgetc+0x2c>
    return -1;
ffffffff80103db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80103dba:	e9 32 01 00 00       	jmpq   ffffffff80103ef1 <kbdgetc+0x15e>
  data = inb(KBDATAP);
ffffffff80103dbf:	bf 60 00 00 00       	mov    $0x60,%edi
ffffffff80103dc4:	e8 ac ff ff ff       	callq  ffffffff80103d75 <inb>
ffffffff80103dc9:	0f b6 c0             	movzbl %al,%eax
ffffffff80103dcc:	89 45 fc             	mov    %eax,-0x4(%rbp)

  if(data == 0xE0){
ffffffff80103dcf:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%rbp)
ffffffff80103dd6:	75 19                	jne    ffffffff80103df1 <kbdgetc+0x5e>
    shift |= E0ESC;
ffffffff80103dd8:	8b 05 da e8 00 00    	mov    0xe8da(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103dde:	83 c8 40             	or     $0x40,%eax
ffffffff80103de1:	89 05 d1 e8 00 00    	mov    %eax,0xe8d1(%rip)        # ffffffff801126b8 <shift.1797>
    return 0;
ffffffff80103de7:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80103dec:	e9 00 01 00 00       	jmpq   ffffffff80103ef1 <kbdgetc+0x15e>
  } else if(data & 0x80){
ffffffff80103df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103df4:	25 80 00 00 00       	and    $0x80,%eax
ffffffff80103df9:	85 c0                	test   %eax,%eax
ffffffff80103dfb:	74 47                	je     ffffffff80103e44 <kbdgetc+0xb1>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
ffffffff80103dfd:	8b 05 b5 e8 00 00    	mov    0xe8b5(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e03:	83 e0 40             	and    $0x40,%eax
ffffffff80103e06:	85 c0                	test   %eax,%eax
ffffffff80103e08:	75 08                	jne    ffffffff80103e12 <kbdgetc+0x7f>
ffffffff80103e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103e0d:	83 e0 7f             	and    $0x7f,%eax
ffffffff80103e10:	eb 03                	jmp    ffffffff80103e15 <kbdgetc+0x82>
ffffffff80103e12:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103e15:	89 45 fc             	mov    %eax,-0x4(%rbp)
    shift &= ~(shiftcode[data] | E0ESC);
ffffffff80103e18:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103e1b:	0f b6 80 20 b0 10 80 	movzbl -0x7fef4fe0(%rax),%eax
ffffffff80103e22:	83 c8 40             	or     $0x40,%eax
ffffffff80103e25:	0f b6 c0             	movzbl %al,%eax
ffffffff80103e28:	f7 d0                	not    %eax
ffffffff80103e2a:	89 c2                	mov    %eax,%edx
ffffffff80103e2c:	8b 05 86 e8 00 00    	mov    0xe886(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e32:	21 d0                	and    %edx,%eax
ffffffff80103e34:	89 05 7e e8 00 00    	mov    %eax,0xe87e(%rip)        # ffffffff801126b8 <shift.1797>
    return 0;
ffffffff80103e3a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80103e3f:	e9 ad 00 00 00       	jmpq   ffffffff80103ef1 <kbdgetc+0x15e>
  } else if(shift & E0ESC){
ffffffff80103e44:	8b 05 6e e8 00 00    	mov    0xe86e(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e4a:	83 e0 40             	and    $0x40,%eax
ffffffff80103e4d:	85 c0                	test   %eax,%eax
ffffffff80103e4f:	74 16                	je     ffffffff80103e67 <kbdgetc+0xd4>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
ffffffff80103e51:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%rbp)
    shift &= ~E0ESC;
ffffffff80103e58:	8b 05 5a e8 00 00    	mov    0xe85a(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e5e:	83 e0 bf             	and    $0xffffffbf,%eax
ffffffff80103e61:	89 05 51 e8 00 00    	mov    %eax,0xe851(%rip)        # ffffffff801126b8 <shift.1797>
  }

  shift |= shiftcode[data];
ffffffff80103e67:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103e6a:	0f b6 80 20 b0 10 80 	movzbl -0x7fef4fe0(%rax),%eax
ffffffff80103e71:	0f b6 d0             	movzbl %al,%edx
ffffffff80103e74:	8b 05 3e e8 00 00    	mov    0xe83e(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e7a:	09 d0                	or     %edx,%eax
ffffffff80103e7c:	89 05 36 e8 00 00    	mov    %eax,0xe836(%rip)        # ffffffff801126b8 <shift.1797>
  shift ^= togglecode[data];
ffffffff80103e82:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103e85:	0f b6 80 20 b1 10 80 	movzbl -0x7fef4ee0(%rax),%eax
ffffffff80103e8c:	0f b6 d0             	movzbl %al,%edx
ffffffff80103e8f:	8b 05 23 e8 00 00    	mov    0xe823(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103e95:	31 d0                	xor    %edx,%eax
ffffffff80103e97:	89 05 1b e8 00 00    	mov    %eax,0xe81b(%rip)        # ffffffff801126b8 <shift.1797>
  c = charcode[shift & (CTL | SHIFT)][data];
ffffffff80103e9d:	8b 05 15 e8 00 00    	mov    0xe815(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103ea3:	83 e0 03             	and    $0x3,%eax
ffffffff80103ea6:	89 c0                	mov    %eax,%eax
ffffffff80103ea8:	48 8b 14 c5 20 b5 10 	mov    -0x7fef4ae0(,%rax,8),%rdx
ffffffff80103eaf:	80 
ffffffff80103eb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80103eb3:	48 01 d0             	add    %rdx,%rax
ffffffff80103eb6:	0f b6 00             	movzbl (%rax),%eax
ffffffff80103eb9:	0f b6 c0             	movzbl %al,%eax
ffffffff80103ebc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  if(shift & CAPSLOCK){
ffffffff80103ebf:	8b 05 f3 e7 00 00    	mov    0xe7f3(%rip),%eax        # ffffffff801126b8 <shift.1797>
ffffffff80103ec5:	83 e0 08             	and    $0x8,%eax
ffffffff80103ec8:	85 c0                	test   %eax,%eax
ffffffff80103eca:	74 22                	je     ffffffff80103eee <kbdgetc+0x15b>
    if('a' <= c && c <= 'z')
ffffffff80103ecc:	83 7d f8 60          	cmpl   $0x60,-0x8(%rbp)
ffffffff80103ed0:	76 0c                	jbe    ffffffff80103ede <kbdgetc+0x14b>
ffffffff80103ed2:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%rbp)
ffffffff80103ed6:	77 06                	ja     ffffffff80103ede <kbdgetc+0x14b>
      c += 'A' - 'a';
ffffffff80103ed8:	83 6d f8 20          	subl   $0x20,-0x8(%rbp)
ffffffff80103edc:	eb 10                	jmp    ffffffff80103eee <kbdgetc+0x15b>
    else if('A' <= c && c <= 'Z')
ffffffff80103ede:	83 7d f8 40          	cmpl   $0x40,-0x8(%rbp)
ffffffff80103ee2:	76 0a                	jbe    ffffffff80103eee <kbdgetc+0x15b>
ffffffff80103ee4:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%rbp)
ffffffff80103ee8:	77 04                	ja     ffffffff80103eee <kbdgetc+0x15b>
      c += 'a' - 'A';
ffffffff80103eea:	83 45 f8 20          	addl   $0x20,-0x8(%rbp)
  }
  return c;
ffffffff80103eee:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffffffff80103ef1:	c9                   	leaveq 
ffffffff80103ef2:	c3                   	retq   

ffffffff80103ef3 <kbdintr>:

void
kbdintr(void)
{
ffffffff80103ef3:	55                   	push   %rbp
ffffffff80103ef4:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(kbdgetc);
ffffffff80103ef7:	48 c7 c7 93 3d 10 80 	mov    $0xffffffff80103d93,%rdi
ffffffff80103efe:	e8 83 cc ff ff       	callq  ffffffff80100b86 <consoleintr>
}
ffffffff80103f03:	90                   	nop
ffffffff80103f04:	5d                   	pop    %rbp
ffffffff80103f05:	c3                   	retq   

ffffffff80103f06 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff80103f06:	55                   	push   %rbp
ffffffff80103f07:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103f0a:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80103f0e:	89 f8                	mov    %edi,%eax
ffffffff80103f10:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff80103f14:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff80103f18:	89 c2                	mov    %eax,%edx
ffffffff80103f1a:	ec                   	in     (%dx),%al
ffffffff80103f1b:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff80103f1e:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff80103f22:	c9                   	leaveq 
ffffffff80103f23:	c3                   	retq   

ffffffff80103f24 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff80103f24:	55                   	push   %rbp
ffffffff80103f25:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103f28:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103f2c:	89 fa                	mov    %edi,%edx
ffffffff80103f2e:	89 f0                	mov    %esi,%eax
ffffffff80103f30:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff80103f34:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff80103f37:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff80103f3b:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff80103f3f:	ee                   	out    %al,(%dx)
}
ffffffff80103f40:	90                   	nop
ffffffff80103f41:	c9                   	leaveq 
ffffffff80103f42:	c3                   	retq   

ffffffff80103f43 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uintp
readeflags(void)
{
ffffffff80103f43:	55                   	push   %rbp
ffffffff80103f44:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103f47:	48 83 ec 10          	sub    $0x10,%rsp
  uintp eflags;
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffffffff80103f4b:	9c                   	pushfq 
ffffffff80103f4c:	58                   	pop    %rax
ffffffff80103f4d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffffffff80103f51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80103f55:	c9                   	leaveq 
ffffffff80103f56:	c3                   	retq   

ffffffff80103f57 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
ffffffff80103f57:	55                   	push   %rbp
ffffffff80103f58:	48 89 e5             	mov    %rsp,%rbp
ffffffff80103f5b:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80103f5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff80103f62:	89 75 f8             	mov    %esi,-0x8(%rbp)
  lapic[index] = value;
ffffffff80103f65:	48 8b 05 54 e7 00 00 	mov    0xe754(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80103f6c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80103f6f:	48 63 d2             	movslq %edx,%rdx
ffffffff80103f72:	48 c1 e2 02          	shl    $0x2,%rdx
ffffffff80103f76:	48 01 c2             	add    %rax,%rdx
ffffffff80103f79:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80103f7c:	89 02                	mov    %eax,(%rdx)
  lapic[ID];  // wait for write to finish, by reading
ffffffff80103f7e:	48 8b 05 3b e7 00 00 	mov    0xe73b(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80103f85:	48 83 c0 20          	add    $0x20,%rax
ffffffff80103f89:	8b 00                	mov    (%rax),%eax
}
ffffffff80103f8b:	90                   	nop
ffffffff80103f8c:	c9                   	leaveq 
ffffffff80103f8d:	c3                   	retq   

ffffffff80103f8e <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
ffffffff80103f8e:	55                   	push   %rbp
ffffffff80103f8f:	48 89 e5             	mov    %rsp,%rbp
  if(!lapic) 
ffffffff80103f92:	48 8b 05 27 e7 00 00 	mov    0xe727(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80103f99:	48 85 c0             	test   %rax,%rax
ffffffff80103f9c:	0f 84 05 01 00 00    	je     ffffffff801040a7 <lapicinit+0x119>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
ffffffff80103fa2:	be 3f 01 00 00       	mov    $0x13f,%esi
ffffffff80103fa7:	bf 3c 00 00 00       	mov    $0x3c,%edi
ffffffff80103fac:	e8 a6 ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
ffffffff80103fb1:	be 0b 00 00 00       	mov    $0xb,%esi
ffffffff80103fb6:	bf f8 00 00 00       	mov    $0xf8,%edi
ffffffff80103fbb:	e8 97 ff ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
ffffffff80103fc0:	be 20 00 02 00       	mov    $0x20020,%esi
ffffffff80103fc5:	bf c8 00 00 00       	mov    $0xc8,%edi
ffffffff80103fca:	e8 88 ff ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(TICR, 10000000); 
ffffffff80103fcf:	be 80 96 98 00       	mov    $0x989680,%esi
ffffffff80103fd4:	bf e0 00 00 00       	mov    $0xe0,%edi
ffffffff80103fd9:	e8 79 ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
ffffffff80103fde:	be 00 00 01 00       	mov    $0x10000,%esi
ffffffff80103fe3:	bf d4 00 00 00       	mov    $0xd4,%edi
ffffffff80103fe8:	e8 6a ff ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(LINT1, MASKED);
ffffffff80103fed:	be 00 00 01 00       	mov    $0x10000,%esi
ffffffff80103ff2:	bf d8 00 00 00       	mov    $0xd8,%edi
ffffffff80103ff7:	e8 5b ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
ffffffff80103ffc:	48 8b 05 bd e6 00 00 	mov    0xe6bd(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80104003:	48 83 c0 30          	add    $0x30,%rax
ffffffff80104007:	8b 00                	mov    (%rax),%eax
ffffffff80104009:	c1 e8 10             	shr    $0x10,%eax
ffffffff8010400c:	0f b6 c0             	movzbl %al,%eax
ffffffff8010400f:	83 f8 03             	cmp    $0x3,%eax
ffffffff80104012:	76 0f                	jbe    ffffffff80104023 <lapicinit+0x95>
    lapicw(PCINT, MASKED);
ffffffff80104014:	be 00 00 01 00       	mov    $0x10000,%esi
ffffffff80104019:	bf d0 00 00 00       	mov    $0xd0,%edi
ffffffff8010401e:	e8 34 ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
ffffffff80104023:	be 33 00 00 00       	mov    $0x33,%esi
ffffffff80104028:	bf dc 00 00 00       	mov    $0xdc,%edi
ffffffff8010402d:	e8 25 ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
ffffffff80104032:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80104037:	bf a0 00 00 00       	mov    $0xa0,%edi
ffffffff8010403c:	e8 16 ff ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(ESR, 0);
ffffffff80104041:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80104046:	bf a0 00 00 00       	mov    $0xa0,%edi
ffffffff8010404b:	e8 07 ff ff ff       	callq  ffffffff80103f57 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
ffffffff80104050:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80104055:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffffffff8010405a:	e8 f8 fe ff ff       	callq  ffffffff80103f57 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
ffffffff8010405f:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80104064:	bf c4 00 00 00       	mov    $0xc4,%edi
ffffffff80104069:	e8 e9 fe ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
ffffffff8010406e:	be 00 85 08 00       	mov    $0x88500,%esi
ffffffff80104073:	bf c0 00 00 00       	mov    $0xc0,%edi
ffffffff80104078:	e8 da fe ff ff       	callq  ffffffff80103f57 <lapicw>
  while(lapic[ICRLO] & DELIVS)
ffffffff8010407d:	90                   	nop
ffffffff8010407e:	48 8b 05 3b e6 00 00 	mov    0xe63b(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80104085:	48 05 00 03 00 00    	add    $0x300,%rax
ffffffff8010408b:	8b 00                	mov    (%rax),%eax
ffffffff8010408d:	25 00 10 00 00       	and    $0x1000,%eax
ffffffff80104092:	85 c0                	test   %eax,%eax
ffffffff80104094:	75 e8                	jne    ffffffff8010407e <lapicinit+0xf0>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
ffffffff80104096:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010409b:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff801040a0:	e8 b2 fe ff ff       	callq  ffffffff80103f57 <lapicw>
ffffffff801040a5:	eb 01                	jmp    ffffffff801040a8 <lapicinit+0x11a>

void
lapicinit(void)
{
  if(!lapic) 
    return;
ffffffff801040a7:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
ffffffff801040a8:	5d                   	pop    %rbp
ffffffff801040a9:	c3                   	retq   

ffffffff801040aa <cpunum>:
// This is only used during secondary processor startup.
// cpu->id is the fast way to get the cpu number, once the
// processor is fully started.
int
cpunum(void)
{
ffffffff801040aa:	55                   	push   %rbp
ffffffff801040ab:	48 89 e5             	mov    %rsp,%rbp
ffffffff801040ae:	48 83 ec 10          	sub    $0x10,%rsp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
ffffffff801040b2:	e8 8c fe ff ff       	callq  ffffffff80103f43 <readeflags>
ffffffff801040b7:	25 00 02 00 00       	and    $0x200,%eax
ffffffff801040bc:	48 85 c0             	test   %rax,%rax
ffffffff801040bf:	74 2b                	je     ffffffff801040ec <cpunum+0x42>
    static int n;
    if(n++ == 0)
ffffffff801040c1:	8b 05 01 e6 00 00    	mov    0xe601(%rip),%eax        # ffffffff801126c8 <n.1922>
ffffffff801040c7:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff801040ca:	89 15 f8 e5 00 00    	mov    %edx,0xe5f8(%rip)        # ffffffff801126c8 <n.1922>
ffffffff801040d0:	85 c0                	test   %eax,%eax
ffffffff801040d2:	75 18                	jne    ffffffff801040ec <cpunum+0x42>
      cprintf("cpu called from %x with interrupts enabled\n",
ffffffff801040d4:	48 8b 45 08          	mov    0x8(%rbp),%rax
ffffffff801040d8:	48 89 c6             	mov    %rax,%rsi
ffffffff801040db:	48 c7 c7 e8 a8 10 80 	mov    $0xffffffff8010a8e8,%rdi
ffffffff801040e2:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801040e7:	e8 b6 c4 ff ff       	callq  ffffffff801005a2 <cprintf>
        __builtin_return_address(0));
  }

  if(!lapic)
ffffffff801040ec:	48 8b 05 cd e5 00 00 	mov    0xe5cd(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff801040f3:	48 85 c0             	test   %rax,%rax
ffffffff801040f6:	75 07                	jne    ffffffff801040ff <cpunum+0x55>
    return 0;
ffffffff801040f8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801040fd:	eb 5c                	jmp    ffffffff8010415b <cpunum+0xb1>

  id = lapic[ID]>>24;
ffffffff801040ff:	48 8b 05 ba e5 00 00 	mov    0xe5ba(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80104106:	48 83 c0 20          	add    $0x20,%rax
ffffffff8010410a:	8b 00                	mov    (%rax),%eax
ffffffff8010410c:	c1 e8 18             	shr    $0x18,%eax
ffffffff8010410f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (n = 0; n < ncpu; n++)
ffffffff80104112:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80104119:	eb 30                	jmp    ffffffff8010414b <cpunum+0xa1>
    if (id == cpus[n].apicid)
ffffffff8010411b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010411e:	48 98                	cltq   
ffffffff80104120:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80104124:	48 89 c2             	mov    %rax,%rdx
ffffffff80104127:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff8010412b:	48 29 c2             	sub    %rax,%rdx
ffffffff8010412e:	48 89 d0             	mov    %rdx,%rax
ffffffff80104131:	48 05 e1 27 11 80    	add    $0xffffffff801127e1,%rax
ffffffff80104137:	0f b6 00             	movzbl (%rax),%eax
ffffffff8010413a:	0f b6 c0             	movzbl %al,%eax
ffffffff8010413d:	3b 45 f8             	cmp    -0x8(%rbp),%eax
ffffffff80104140:	75 05                	jne    ffffffff80104147 <cpunum+0x9d>
      return n;
ffffffff80104142:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104145:	eb 14                	jmp    ffffffff8010415b <cpunum+0xb1>

  if(!lapic)
    return 0;

  id = lapic[ID]>>24;
  for (n = 0; n < ncpu; n++)
ffffffff80104147:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010414b:	8b 05 13 ee 00 00    	mov    0xee13(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80104151:	39 45 fc             	cmp    %eax,-0x4(%rbp)
ffffffff80104154:	7c c5                	jl     ffffffff8010411b <cpunum+0x71>
    if (id == cpus[n].apicid)
      return n;

  return 0;
ffffffff80104156:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff8010415b:	c9                   	leaveq 
ffffffff8010415c:	c3                   	retq   

ffffffff8010415d <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
ffffffff8010415d:	55                   	push   %rbp
ffffffff8010415e:	48 89 e5             	mov    %rsp,%rbp
  if(lapic)
ffffffff80104161:	48 8b 05 58 e5 00 00 	mov    0xe558(%rip),%rax        # ffffffff801126c0 <lapic>
ffffffff80104168:	48 85 c0             	test   %rax,%rax
ffffffff8010416b:	74 0f                	je     ffffffff8010417c <lapiceoi+0x1f>
    lapicw(EOI, 0);
ffffffff8010416d:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80104172:	bf 2c 00 00 00       	mov    $0x2c,%edi
ffffffff80104177:	e8 db fd ff ff       	callq  ffffffff80103f57 <lapicw>
}
ffffffff8010417c:	90                   	nop
ffffffff8010417d:	5d                   	pop    %rbp
ffffffff8010417e:	c3                   	retq   

ffffffff8010417f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
ffffffff8010417f:	55                   	push   %rbp
ffffffff80104180:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104183:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80104187:	89 7d fc             	mov    %edi,-0x4(%rbp)
}
ffffffff8010418a:	90                   	nop
ffffffff8010418b:	c9                   	leaveq 
ffffffff8010418c:	c3                   	retq   

ffffffff8010418d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
ffffffff8010418d:	55                   	push   %rbp
ffffffff8010418e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104191:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80104195:	89 f8                	mov    %edi,%eax
ffffffff80104197:	89 75 e8             	mov    %esi,-0x18(%rbp)
ffffffff8010419a:	88 45 ec             	mov    %al,-0x14(%rbp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
ffffffff8010419d:	be 0f 00 00 00       	mov    $0xf,%esi
ffffffff801041a2:	bf 70 00 00 00       	mov    $0x70,%edi
ffffffff801041a7:	e8 78 fd ff ff       	callq  ffffffff80103f24 <outb>
  outb(CMOS_PORT+1, 0x0A);
ffffffff801041ac:	be 0a 00 00 00       	mov    $0xa,%esi
ffffffff801041b1:	bf 71 00 00 00       	mov    $0x71,%edi
ffffffff801041b6:	e8 69 fd ff ff       	callq  ffffffff80103f24 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
ffffffff801041bb:	48 c7 45 f0 67 04 00 	movq   $0xffffffff80000467,-0x10(%rbp)
ffffffff801041c2:	80 
  wrv[0] = 0;
ffffffff801041c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801041c7:	66 c7 00 00 00       	movw   $0x0,(%rax)
  wrv[1] = addr >> 4;
ffffffff801041cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801041d0:	48 83 c0 02          	add    $0x2,%rax
ffffffff801041d4:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801041d7:	c1 ea 04             	shr    $0x4,%edx
ffffffff801041da:	66 89 10             	mov    %dx,(%rax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
ffffffff801041dd:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffffffff801041e1:	c1 e0 18             	shl    $0x18,%eax
ffffffff801041e4:	89 c6                	mov    %eax,%esi
ffffffff801041e6:	bf c4 00 00 00       	mov    $0xc4,%edi
ffffffff801041eb:	e8 67 fd ff ff       	callq  ffffffff80103f57 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
ffffffff801041f0:	be 00 c5 00 00       	mov    $0xc500,%esi
ffffffff801041f5:	bf c0 00 00 00       	mov    $0xc0,%edi
ffffffff801041fa:	e8 58 fd ff ff       	callq  ffffffff80103f57 <lapicw>
  microdelay(200);
ffffffff801041ff:	bf c8 00 00 00       	mov    $0xc8,%edi
ffffffff80104204:	e8 76 ff ff ff       	callq  ffffffff8010417f <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
ffffffff80104209:	be 00 85 00 00       	mov    $0x8500,%esi
ffffffff8010420e:	bf c0 00 00 00       	mov    $0xc0,%edi
ffffffff80104213:	e8 3f fd ff ff       	callq  ffffffff80103f57 <lapicw>
  microdelay(10000);
ffffffff80104218:	bf 10 27 00 00       	mov    $0x2710,%edi
ffffffff8010421d:	e8 5d ff ff ff       	callq  ffffffff8010417f <microdelay>
  
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  for(i = 0; i < 2; i++){
ffffffff80104222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80104229:	eb 36                	jmp    ffffffff80104261 <lapicstartap+0xd4>
    lapicw(ICRHI, apicid<<24);
ffffffff8010422b:	0f b6 45 ec          	movzbl -0x14(%rbp),%eax
ffffffff8010422f:	c1 e0 18             	shl    $0x18,%eax
ffffffff80104232:	89 c6                	mov    %eax,%esi
ffffffff80104234:	bf c4 00 00 00       	mov    $0xc4,%edi
ffffffff80104239:	e8 19 fd ff ff       	callq  ffffffff80103f57 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
ffffffff8010423e:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff80104241:	c1 e8 0c             	shr    $0xc,%eax
ffffffff80104244:	80 cc 06             	or     $0x6,%ah
ffffffff80104247:	89 c6                	mov    %eax,%esi
ffffffff80104249:	bf c0 00 00 00       	mov    $0xc0,%edi
ffffffff8010424e:	e8 04 fd ff ff       	callq  ffffffff80103f57 <lapicw>
    microdelay(200);
ffffffff80104253:	bf c8 00 00 00       	mov    $0xc8,%edi
ffffffff80104258:	e8 22 ff ff ff       	callq  ffffffff8010417f <microdelay>
  
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  for(i = 0; i < 2; i++){
ffffffff8010425d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80104261:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
ffffffff80104265:	7e c4                	jle    ffffffff8010422b <lapicstartap+0x9e>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
ffffffff80104267:	90                   	nop
ffffffff80104268:	c9                   	leaveq 
ffffffff80104269:	c3                   	retq   

ffffffff8010426a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
ffffffff8010426a:	55                   	push   %rbp
ffffffff8010426b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010426e:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80104272:	89 7d fc             	mov    %edi,-0x4(%rbp)
  outb(CMOS_PORT,  reg);
ffffffff80104275:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104278:	0f b6 c0             	movzbl %al,%eax
ffffffff8010427b:	89 c6                	mov    %eax,%esi
ffffffff8010427d:	bf 70 00 00 00       	mov    $0x70,%edi
ffffffff80104282:	e8 9d fc ff ff       	callq  ffffffff80103f24 <outb>
  microdelay(200);
ffffffff80104287:	bf c8 00 00 00       	mov    $0xc8,%edi
ffffffff8010428c:	e8 ee fe ff ff       	callq  ffffffff8010417f <microdelay>

  return inb(CMOS_RETURN);
ffffffff80104291:	bf 71 00 00 00       	mov    $0x71,%edi
ffffffff80104296:	e8 6b fc ff ff       	callq  ffffffff80103f06 <inb>
ffffffff8010429b:	0f b6 c0             	movzbl %al,%eax
}
ffffffff8010429e:	c9                   	leaveq 
ffffffff8010429f:	c3                   	retq   

ffffffff801042a0 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
ffffffff801042a0:	55                   	push   %rbp
ffffffff801042a1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801042a4:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801042a8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  r->second = cmos_read(SECS);
ffffffff801042ac:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801042b1:	e8 b4 ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff801042b6:	89 c2                	mov    %eax,%edx
ffffffff801042b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801042bc:	89 10                	mov    %edx,(%rax)
  r->minute = cmos_read(MINS);
ffffffff801042be:	bf 02 00 00 00       	mov    $0x2,%edi
ffffffff801042c3:	e8 a2 ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff801042c8:	89 c2                	mov    %eax,%edx
ffffffff801042ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801042ce:	89 50 04             	mov    %edx,0x4(%rax)
  r->hour   = cmos_read(HOURS);
ffffffff801042d1:	bf 04 00 00 00       	mov    $0x4,%edi
ffffffff801042d6:	e8 8f ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff801042db:	89 c2                	mov    %eax,%edx
ffffffff801042dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801042e1:	89 50 08             	mov    %edx,0x8(%rax)
  r->day    = cmos_read(DAY);
ffffffff801042e4:	bf 07 00 00 00       	mov    $0x7,%edi
ffffffff801042e9:	e8 7c ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff801042ee:	89 c2                	mov    %eax,%edx
ffffffff801042f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801042f4:	89 50 0c             	mov    %edx,0xc(%rax)
  r->month  = cmos_read(MONTH);
ffffffff801042f7:	bf 08 00 00 00       	mov    $0x8,%edi
ffffffff801042fc:	e8 69 ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff80104301:	89 c2                	mov    %eax,%edx
ffffffff80104303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104307:	89 50 10             	mov    %edx,0x10(%rax)
  r->year   = cmos_read(YEAR);
ffffffff8010430a:	bf 09 00 00 00       	mov    $0x9,%edi
ffffffff8010430f:	e8 56 ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff80104314:	89 c2                	mov    %eax,%edx
ffffffff80104316:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010431a:	89 50 14             	mov    %edx,0x14(%rax)
}
ffffffff8010431d:	90                   	nop
ffffffff8010431e:	c9                   	leaveq 
ffffffff8010431f:	c3                   	retq   

ffffffff80104320 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
ffffffff80104320:	55                   	push   %rbp
ffffffff80104321:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104324:	48 83 ec 50          	sub    $0x50,%rsp
ffffffff80104328:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
ffffffff8010432c:	bf 0b 00 00 00       	mov    $0xb,%edi
ffffffff80104331:	e8 34 ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff80104336:	89 45 fc             	mov    %eax,-0x4(%rbp)

  bcd = (sb & (1 << 2)) == 0;
ffffffff80104339:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010433c:	83 e0 04             	and    $0x4,%eax
ffffffff8010433f:	85 c0                	test   %eax,%eax
ffffffff80104341:	0f 94 c0             	sete   %al
ffffffff80104344:	0f b6 c0             	movzbl %al,%eax
ffffffff80104347:	89 45 f8             	mov    %eax,-0x8(%rbp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
ffffffff8010434a:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff8010434e:	48 89 c7             	mov    %rax,%rdi
ffffffff80104351:	e8 4a ff ff ff       	callq  ffffffff801042a0 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
ffffffff80104356:	bf 0a 00 00 00       	mov    $0xa,%edi
ffffffff8010435b:	e8 0a ff ff ff       	callq  ffffffff8010426a <cmos_read>
ffffffff80104360:	25 80 00 00 00       	and    $0x80,%eax
ffffffff80104365:	85 c0                	test   %eax,%eax
ffffffff80104367:	75 2a                	jne    ffffffff80104393 <cmostime+0x73>
        continue;
    fill_rtcdate(&t2);
ffffffff80104369:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffffffff8010436d:	48 89 c7             	mov    %rax,%rdi
ffffffff80104370:	e8 2b ff ff ff       	callq  ffffffff801042a0 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
ffffffff80104375:	48 8d 4d c0          	lea    -0x40(%rbp),%rcx
ffffffff80104379:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff8010437d:	ba 18 00 00 00       	mov    $0x18,%edx
ffffffff80104382:	48 89 ce             	mov    %rcx,%rsi
ffffffff80104385:	48 89 c7             	mov    %rax,%rdi
ffffffff80104388:	e8 05 2a 00 00       	callq  ffffffff80106d92 <memcmp>
ffffffff8010438d:	85 c0                	test   %eax,%eax
ffffffff8010438f:	74 05                	je     ffffffff80104396 <cmostime+0x76>
ffffffff80104391:	eb b7                	jmp    ffffffff8010434a <cmostime+0x2a>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
ffffffff80104393:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
ffffffff80104394:	eb b4                	jmp    ffffffff8010434a <cmostime+0x2a>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
ffffffff80104396:	90                   	nop
  }

  // convert
  if (bcd) {
ffffffff80104397:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffffffff8010439b:	0f 84 b4 00 00 00    	je     ffffffff80104455 <cmostime+0x135>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
ffffffff801043a1:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffffffff801043a4:	c1 e8 04             	shr    $0x4,%eax
ffffffff801043a7:	89 c2                	mov    %eax,%edx
ffffffff801043a9:	89 d0                	mov    %edx,%eax
ffffffff801043ab:	c1 e0 02             	shl    $0x2,%eax
ffffffff801043ae:	01 d0                	add    %edx,%eax
ffffffff801043b0:	01 c0                	add    %eax,%eax
ffffffff801043b2:	89 c2                	mov    %eax,%edx
ffffffff801043b4:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffffffff801043b7:	83 e0 0f             	and    $0xf,%eax
ffffffff801043ba:	01 d0                	add    %edx,%eax
ffffffff801043bc:	89 45 e0             	mov    %eax,-0x20(%rbp)
    CONV(minute);
ffffffff801043bf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff801043c2:	c1 e8 04             	shr    $0x4,%eax
ffffffff801043c5:	89 c2                	mov    %eax,%edx
ffffffff801043c7:	89 d0                	mov    %edx,%eax
ffffffff801043c9:	c1 e0 02             	shl    $0x2,%eax
ffffffff801043cc:	01 d0                	add    %edx,%eax
ffffffff801043ce:	01 c0                	add    %eax,%eax
ffffffff801043d0:	89 c2                	mov    %eax,%edx
ffffffff801043d2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff801043d5:	83 e0 0f             	and    $0xf,%eax
ffffffff801043d8:	01 d0                	add    %edx,%eax
ffffffff801043da:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    CONV(hour  );
ffffffff801043dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff801043e0:	c1 e8 04             	shr    $0x4,%eax
ffffffff801043e3:	89 c2                	mov    %eax,%edx
ffffffff801043e5:	89 d0                	mov    %edx,%eax
ffffffff801043e7:	c1 e0 02             	shl    $0x2,%eax
ffffffff801043ea:	01 d0                	add    %edx,%eax
ffffffff801043ec:	01 c0                	add    %eax,%eax
ffffffff801043ee:	89 c2                	mov    %eax,%edx
ffffffff801043f0:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff801043f3:	83 e0 0f             	and    $0xf,%eax
ffffffff801043f6:	01 d0                	add    %edx,%eax
ffffffff801043f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
    CONV(day   );
ffffffff801043fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801043fe:	c1 e8 04             	shr    $0x4,%eax
ffffffff80104401:	89 c2                	mov    %eax,%edx
ffffffff80104403:	89 d0                	mov    %edx,%eax
ffffffff80104405:	c1 e0 02             	shl    $0x2,%eax
ffffffff80104408:	01 d0                	add    %edx,%eax
ffffffff8010440a:	01 c0                	add    %eax,%eax
ffffffff8010440c:	89 c2                	mov    %eax,%edx
ffffffff8010440e:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80104411:	83 e0 0f             	and    $0xf,%eax
ffffffff80104414:	01 d0                	add    %edx,%eax
ffffffff80104416:	89 45 ec             	mov    %eax,-0x14(%rbp)
    CONV(month );
ffffffff80104419:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff8010441c:	c1 e8 04             	shr    $0x4,%eax
ffffffff8010441f:	89 c2                	mov    %eax,%edx
ffffffff80104421:	89 d0                	mov    %edx,%eax
ffffffff80104423:	c1 e0 02             	shl    $0x2,%eax
ffffffff80104426:	01 d0                	add    %edx,%eax
ffffffff80104428:	01 c0                	add    %eax,%eax
ffffffff8010442a:	89 c2                	mov    %eax,%edx
ffffffff8010442c:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff8010442f:	83 e0 0f             	and    $0xf,%eax
ffffffff80104432:	01 d0                	add    %edx,%eax
ffffffff80104434:	89 45 f0             	mov    %eax,-0x10(%rbp)
    CONV(year  );
ffffffff80104437:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff8010443a:	c1 e8 04             	shr    $0x4,%eax
ffffffff8010443d:	89 c2                	mov    %eax,%edx
ffffffff8010443f:	89 d0                	mov    %edx,%eax
ffffffff80104441:	c1 e0 02             	shl    $0x2,%eax
ffffffff80104444:	01 d0                	add    %edx,%eax
ffffffff80104446:	01 c0                	add    %eax,%eax
ffffffff80104448:	89 c2                	mov    %eax,%edx
ffffffff8010444a:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff8010444d:	83 e0 0f             	and    $0xf,%eax
ffffffff80104450:	01 d0                	add    %edx,%eax
ffffffff80104452:	89 45 f4             	mov    %eax,-0xc(%rbp)
#undef     CONV
  }

  *r = t1;
ffffffff80104455:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80104459:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff8010445d:	48 89 10             	mov    %rdx,(%rax)
ffffffff80104460:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80104464:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffffffff80104468:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff8010446c:	48 89 50 10          	mov    %rdx,0x10(%rax)
  r->year += 2000;
ffffffff80104470:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80104474:	8b 40 14             	mov    0x14(%rax),%eax
ffffffff80104477:	8d 90 d0 07 00 00    	lea    0x7d0(%rax),%edx
ffffffff8010447d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80104481:	89 50 14             	mov    %edx,0x14(%rax)
}
ffffffff80104484:	90                   	nop
ffffffff80104485:	c9                   	leaveq 
ffffffff80104486:	c3                   	retq   

ffffffff80104487 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
ffffffff80104487:	55                   	push   %rbp
ffffffff80104488:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010448b:	48 83 ec 10          	sub    $0x10,%rsp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
ffffffff8010448f:	48 c7 c6 14 a9 10 80 	mov    $0xffffffff8010a914,%rsi
ffffffff80104496:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff8010449d:	e8 cc 24 00 00       	callq  ffffffff8010696e <initlock>
  readsb(ROOTDEV, &sb);
ffffffff801044a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff801044a6:	48 89 c6             	mov    %rax,%rsi
ffffffff801044a9:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801044ae:	e8 9a dd ff ff       	callq  ffffffff8010224d <readsb>
  log.start = sb.size - sb.nlog;
ffffffff801044b3:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffffffff801044b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801044b9:	29 c2                	sub    %eax,%edx
ffffffff801044bb:	89 d0                	mov    %edx,%eax
ffffffff801044bd:	89 05 85 e2 00 00    	mov    %eax,0xe285(%rip)        # ffffffff80112748 <log+0x68>
  log.size = sb.nlog;
ffffffff801044c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801044c6:	89 05 80 e2 00 00    	mov    %eax,0xe280(%rip)        # ffffffff8011274c <log+0x6c>
  log.dev = ROOTDEV;
ffffffff801044cc:	c7 05 82 e2 00 00 01 	movl   $0x1,0xe282(%rip)        # ffffffff80112758 <log+0x78>
ffffffff801044d3:	00 00 00 
  recover_from_log();
ffffffff801044d6:	e8 c6 01 00 00       	callq  ffffffff801046a1 <recover_from_log>
}
ffffffff801044db:	90                   	nop
ffffffff801044dc:	c9                   	leaveq 
ffffffff801044dd:	c3                   	retq   

ffffffff801044de <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
ffffffff801044de:	55                   	push   %rbp
ffffffff801044df:	48 89 e5             	mov    %rsp,%rbp
ffffffff801044e2:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffffffff801044e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801044ed:	e9 90 00 00 00       	jmpq   ffffffff80104582 <install_trans+0xa4>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
ffffffff801044f2:	8b 15 50 e2 00 00    	mov    0xe250(%rip),%edx        # ffffffff80112748 <log+0x68>
ffffffff801044f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801044fb:	01 d0                	add    %edx,%eax
ffffffff801044fd:	83 c0 01             	add    $0x1,%eax
ffffffff80104500:	89 c2                	mov    %eax,%edx
ffffffff80104502:	8b 05 50 e2 00 00    	mov    0xe250(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff80104508:	89 d6                	mov    %edx,%esi
ffffffff8010450a:	89 c7                	mov    %eax,%edi
ffffffff8010450c:	e8 c5 bd ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80104511:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
ffffffff80104515:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104518:	48 98                	cltq   
ffffffff8010451a:	48 83 c0 1c          	add    $0x1c,%rax
ffffffff8010451e:	8b 04 85 f0 26 11 80 	mov    -0x7feed910(,%rax,4),%eax
ffffffff80104525:	89 c2                	mov    %eax,%edx
ffffffff80104527:	8b 05 2b e2 00 00    	mov    0xe22b(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff8010452d:	89 d6                	mov    %edx,%esi
ffffffff8010452f:	89 c7                	mov    %eax,%edi
ffffffff80104531:	e8 a0 bd ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80104536:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
ffffffff8010453a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010453e:	48 8d 48 28          	lea    0x28(%rax),%rcx
ffffffff80104542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104546:	48 83 c0 28          	add    $0x28,%rax
ffffffff8010454a:	ba 00 02 00 00       	mov    $0x200,%edx
ffffffff8010454f:	48 89 ce             	mov    %rcx,%rsi
ffffffff80104552:	48 89 c7             	mov    %rax,%rdi
ffffffff80104555:	e8 a7 28 00 00       	callq  ffffffff80106e01 <memmove>
    bwrite(dbuf);  // write dst to disk
ffffffff8010455a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010455e:	48 89 c7             	mov    %rax,%rdi
ffffffff80104561:	e8 b0 bd ff ff       	callq  ffffffff80100316 <bwrite>
    brelse(lbuf); 
ffffffff80104566:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010456a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010456d:	e8 e9 bd ff ff       	callq  ffffffff8010035b <brelse>
    brelse(dbuf);
ffffffff80104572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104576:	48 89 c7             	mov    %rax,%rdi
ffffffff80104579:	e8 dd bd ff ff       	callq  ffffffff8010035b <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffffffff8010457e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80104582:	8b 05 d4 e1 00 00    	mov    0xe1d4(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff80104588:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff8010458b:	0f 8f 61 ff ff ff    	jg     ffffffff801044f2 <install_trans+0x14>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
ffffffff80104591:	90                   	nop
ffffffff80104592:	c9                   	leaveq 
ffffffff80104593:	c3                   	retq   

ffffffff80104594 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
ffffffff80104594:	55                   	push   %rbp
ffffffff80104595:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104598:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffffffff8010459c:	8b 05 a6 e1 00 00    	mov    0xe1a6(%rip),%eax        # ffffffff80112748 <log+0x68>
ffffffff801045a2:	89 c2                	mov    %eax,%edx
ffffffff801045a4:	8b 05 ae e1 00 00    	mov    0xe1ae(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff801045aa:	89 d6                	mov    %edx,%esi
ffffffff801045ac:	89 c7                	mov    %eax,%edi
ffffffff801045ae:	e8 23 bd ff ff       	callq  ffffffff801002d6 <bread>
ffffffff801045b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *lh = (struct logheader *) (buf->data);
ffffffff801045b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801045bb:	48 83 c0 28          	add    $0x28,%rax
ffffffff801045bf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  log.lh.n = lh->n;
ffffffff801045c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801045c7:	8b 00                	mov    (%rax),%eax
ffffffff801045c9:	89 05 8d e1 00 00    	mov    %eax,0xe18d(%rip)        # ffffffff8011275c <log+0x7c>
  for (i = 0; i < log.lh.n; i++) {
ffffffff801045cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801045d6:	eb 23                	jmp    ffffffff801045fb <read_head+0x67>
    log.lh.block[i] = lh->block[i];
ffffffff801045d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801045dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801045df:	48 63 d2             	movslq %edx,%rdx
ffffffff801045e2:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff801045e6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801045e9:	48 63 d2             	movslq %edx,%rdx
ffffffff801045ec:	48 83 c2 1c          	add    $0x1c,%rdx
ffffffff801045f0:	89 04 95 f0 26 11 80 	mov    %eax,-0x7feed910(,%rdx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
ffffffff801045f7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff801045fb:	8b 05 5b e1 00 00    	mov    0xe15b(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff80104601:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff80104604:	7f d2                	jg     ffffffff801045d8 <read_head+0x44>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
ffffffff80104606:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010460a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010460d:	e8 49 bd ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff80104612:	90                   	nop
ffffffff80104613:	c9                   	leaveq 
ffffffff80104614:	c3                   	retq   

ffffffff80104615 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
ffffffff80104615:	55                   	push   %rbp
ffffffff80104616:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104619:	48 83 ec 20          	sub    $0x20,%rsp
  struct buf *buf = bread(log.dev, log.start);
ffffffff8010461d:	8b 05 25 e1 00 00    	mov    0xe125(%rip),%eax        # ffffffff80112748 <log+0x68>
ffffffff80104623:	89 c2                	mov    %eax,%edx
ffffffff80104625:	8b 05 2d e1 00 00    	mov    0xe12d(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff8010462b:	89 d6                	mov    %edx,%esi
ffffffff8010462d:	89 c7                	mov    %eax,%edi
ffffffff8010462f:	e8 a2 bc ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80104634:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  struct logheader *hb = (struct logheader *) (buf->data);
ffffffff80104638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010463c:	48 83 c0 28          	add    $0x28,%rax
ffffffff80104640:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  int i;
  hb->n = log.lh.n;
ffffffff80104644:	8b 15 12 e1 00 00    	mov    0xe112(%rip),%edx        # ffffffff8011275c <log+0x7c>
ffffffff8010464a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010464e:	89 10                	mov    %edx,(%rax)
  for (i = 0; i < log.lh.n; i++) {
ffffffff80104650:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80104657:	eb 22                	jmp    ffffffff8010467b <write_head+0x66>
    hb->block[i] = log.lh.block[i];
ffffffff80104659:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010465c:	48 98                	cltq   
ffffffff8010465e:	48 83 c0 1c          	add    $0x1c,%rax
ffffffff80104662:	8b 0c 85 f0 26 11 80 	mov    -0x7feed910(,%rax,4),%ecx
ffffffff80104669:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010466d:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80104670:	48 63 d2             	movslq %edx,%rdx
ffffffff80104673:	89 4c 90 04          	mov    %ecx,0x4(%rax,%rdx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
ffffffff80104677:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010467b:	8b 05 db e0 00 00    	mov    0xe0db(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff80104681:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff80104684:	7f d3                	jg     ffffffff80104659 <write_head+0x44>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
ffffffff80104686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010468a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010468d:	e8 84 bc ff ff       	callq  ffffffff80100316 <bwrite>
  brelse(buf);
ffffffff80104692:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104696:	48 89 c7             	mov    %rax,%rdi
ffffffff80104699:	e8 bd bc ff ff       	callq  ffffffff8010035b <brelse>
}
ffffffff8010469e:	90                   	nop
ffffffff8010469f:	c9                   	leaveq 
ffffffff801046a0:	c3                   	retq   

ffffffff801046a1 <recover_from_log>:

static void
recover_from_log(void)
{
ffffffff801046a1:	55                   	push   %rbp
ffffffff801046a2:	48 89 e5             	mov    %rsp,%rbp
  read_head();      
ffffffff801046a5:	e8 ea fe ff ff       	callq  ffffffff80104594 <read_head>
  install_trans(); // if committed, copy from log to disk
ffffffff801046aa:	e8 2f fe ff ff       	callq  ffffffff801044de <install_trans>
  log.lh.n = 0;
ffffffff801046af:	c7 05 a3 e0 00 00 00 	movl   $0x0,0xe0a3(%rip)        # ffffffff8011275c <log+0x7c>
ffffffff801046b6:	00 00 00 
  write_head(); // clear the log
ffffffff801046b9:	e8 57 ff ff ff       	callq  ffffffff80104615 <write_head>
}
ffffffff801046be:	90                   	nop
ffffffff801046bf:	5d                   	pop    %rbp
ffffffff801046c0:	c3                   	retq   

ffffffff801046c1 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
ffffffff801046c1:	55                   	push   %rbp
ffffffff801046c2:	48 89 e5             	mov    %rsp,%rbp
  acquire(&log.lock);
ffffffff801046c5:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801046cc:	e8 d2 22 00 00       	callq  ffffffff801069a3 <acquire>
  while(1){
    if(log.committing){
ffffffff801046d1:	8b 05 7d e0 00 00    	mov    0xe07d(%rip),%eax        # ffffffff80112754 <log+0x74>
ffffffff801046d7:	85 c0                	test   %eax,%eax
ffffffff801046d9:	74 15                	je     ffffffff801046f0 <begin_op+0x2f>
      sleep(&log, &log.lock);
ffffffff801046db:	48 c7 c6 e0 26 11 80 	mov    $0xffffffff801126e0,%rsi
ffffffff801046e2:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801046e9:	e8 38 1f 00 00       	callq  ffffffff80106626 <sleep>
ffffffff801046ee:	eb e1                	jmp    ffffffff801046d1 <begin_op+0x10>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
ffffffff801046f0:	8b 0d 66 e0 00 00    	mov    0xe066(%rip),%ecx        # ffffffff8011275c <log+0x7c>
ffffffff801046f6:	8b 05 54 e0 00 00    	mov    0xe054(%rip),%eax        # ffffffff80112750 <log+0x70>
ffffffff801046fc:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff801046ff:	89 d0                	mov    %edx,%eax
ffffffff80104701:	c1 e0 02             	shl    $0x2,%eax
ffffffff80104704:	01 d0                	add    %edx,%eax
ffffffff80104706:	01 c0                	add    %eax,%eax
ffffffff80104708:	01 c8                	add    %ecx,%eax
ffffffff8010470a:	83 f8 1e             	cmp    $0x1e,%eax
ffffffff8010470d:	7e 15                	jle    ffffffff80104724 <begin_op+0x63>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
ffffffff8010470f:	48 c7 c6 e0 26 11 80 	mov    $0xffffffff801126e0,%rsi
ffffffff80104716:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff8010471d:	e8 04 1f 00 00       	callq  ffffffff80106626 <sleep>
ffffffff80104722:	eb ad                	jmp    ffffffff801046d1 <begin_op+0x10>
    } else {
      log.outstanding += 1;
ffffffff80104724:	8b 05 26 e0 00 00    	mov    0xe026(%rip),%eax        # ffffffff80112750 <log+0x70>
ffffffff8010472a:	83 c0 01             	add    $0x1,%eax
ffffffff8010472d:	89 05 1d e0 00 00    	mov    %eax,0xe01d(%rip)        # ffffffff80112750 <log+0x70>
      release(&log.lock);
ffffffff80104733:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff8010473a:	e8 3b 23 00 00       	callq  ffffffff80106a7a <release>
      break;
ffffffff8010473f:	90                   	nop
    }
  }
}
ffffffff80104740:	90                   	nop
ffffffff80104741:	5d                   	pop    %rbp
ffffffff80104742:	c3                   	retq   

ffffffff80104743 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
ffffffff80104743:	55                   	push   %rbp
ffffffff80104744:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104747:	48 83 ec 10          	sub    $0x10,%rsp
  int do_commit = 0;
ffffffff8010474b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

  acquire(&log.lock);
ffffffff80104752:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff80104759:	e8 45 22 00 00       	callq  ffffffff801069a3 <acquire>
  log.outstanding -= 1;
ffffffff8010475e:	8b 05 ec df 00 00    	mov    0xdfec(%rip),%eax        # ffffffff80112750 <log+0x70>
ffffffff80104764:	83 e8 01             	sub    $0x1,%eax
ffffffff80104767:	89 05 e3 df 00 00    	mov    %eax,0xdfe3(%rip)        # ffffffff80112750 <log+0x70>
  if(log.committing)
ffffffff8010476d:	8b 05 e1 df 00 00    	mov    0xdfe1(%rip),%eax        # ffffffff80112754 <log+0x74>
ffffffff80104773:	85 c0                	test   %eax,%eax
ffffffff80104775:	74 0c                	je     ffffffff80104783 <end_op+0x40>
    panic("log.committing");
ffffffff80104777:	48 c7 c7 18 a9 10 80 	mov    $0xffffffff8010a918,%rdi
ffffffff8010477e:	e8 7c c1 ff ff       	callq  ffffffff801008ff <panic>
  if(log.outstanding == 0){
ffffffff80104783:	8b 05 c7 df 00 00    	mov    0xdfc7(%rip),%eax        # ffffffff80112750 <log+0x70>
ffffffff80104789:	85 c0                	test   %eax,%eax
ffffffff8010478b:	75 13                	jne    ffffffff801047a0 <end_op+0x5d>
    do_commit = 1;
ffffffff8010478d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    log.committing = 1;
ffffffff80104794:	c7 05 b6 df 00 00 01 	movl   $0x1,0xdfb6(%rip)        # ffffffff80112754 <log+0x74>
ffffffff8010479b:	00 00 00 
ffffffff8010479e:	eb 0c                	jmp    ffffffff801047ac <end_op+0x69>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
ffffffff801047a0:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801047a7:	e8 8d 1f 00 00       	callq  ffffffff80106739 <wakeup>
  }
  release(&log.lock);
ffffffff801047ac:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801047b3:	e8 c2 22 00 00       	callq  ffffffff80106a7a <release>

  if(do_commit){
ffffffff801047b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff801047bc:	74 38                	je     ffffffff801047f6 <end_op+0xb3>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
ffffffff801047be:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801047c3:	e8 e7 00 00 00       	callq  ffffffff801048af <commit>
    acquire(&log.lock);
ffffffff801047c8:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801047cf:	e8 cf 21 00 00       	callq  ffffffff801069a3 <acquire>
    log.committing = 0;
ffffffff801047d4:	c7 05 76 df 00 00 00 	movl   $0x0,0xdf76(%rip)        # ffffffff80112754 <log+0x74>
ffffffff801047db:	00 00 00 
    wakeup(&log);
ffffffff801047de:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801047e5:	e8 4f 1f 00 00       	callq  ffffffff80106739 <wakeup>
    release(&log.lock);
ffffffff801047ea:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801047f1:	e8 84 22 00 00       	callq  ffffffff80106a7a <release>
  }
}
ffffffff801047f6:	90                   	nop
ffffffff801047f7:	c9                   	leaveq 
ffffffff801047f8:	c3                   	retq   

ffffffff801047f9 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
ffffffff801047f9:	55                   	push   %rbp
ffffffff801047fa:	48 89 e5             	mov    %rsp,%rbp
ffffffff801047fd:	48 83 ec 20          	sub    $0x20,%rsp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffffffff80104801:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80104808:	e9 90 00 00 00       	jmpq   ffffffff8010489d <write_log+0xa4>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
ffffffff8010480d:	8b 15 35 df 00 00    	mov    0xdf35(%rip),%edx        # ffffffff80112748 <log+0x68>
ffffffff80104813:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104816:	01 d0                	add    %edx,%eax
ffffffff80104818:	83 c0 01             	add    $0x1,%eax
ffffffff8010481b:	89 c2                	mov    %eax,%edx
ffffffff8010481d:	8b 05 35 df 00 00    	mov    0xdf35(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff80104823:	89 d6                	mov    %edx,%esi
ffffffff80104825:	89 c7                	mov    %eax,%edi
ffffffff80104827:	e8 aa ba ff ff       	callq  ffffffff801002d6 <bread>
ffffffff8010482c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
ffffffff80104830:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104833:	48 98                	cltq   
ffffffff80104835:	48 83 c0 1c          	add    $0x1c,%rax
ffffffff80104839:	8b 04 85 f0 26 11 80 	mov    -0x7feed910(,%rax,4),%eax
ffffffff80104840:	89 c2                	mov    %eax,%edx
ffffffff80104842:	8b 05 10 df 00 00    	mov    0xdf10(%rip),%eax        # ffffffff80112758 <log+0x78>
ffffffff80104848:	89 d6                	mov    %edx,%esi
ffffffff8010484a:	89 c7                	mov    %eax,%edi
ffffffff8010484c:	e8 85 ba ff ff       	callq  ffffffff801002d6 <bread>
ffffffff80104851:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    memmove(to->data, from->data, BSIZE);
ffffffff80104855:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104859:	48 8d 48 28          	lea    0x28(%rax),%rcx
ffffffff8010485d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104861:	48 83 c0 28          	add    $0x28,%rax
ffffffff80104865:	ba 00 02 00 00       	mov    $0x200,%edx
ffffffff8010486a:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010486d:	48 89 c7             	mov    %rax,%rdi
ffffffff80104870:	e8 8c 25 00 00       	callq  ffffffff80106e01 <memmove>
    bwrite(to);  // write the log
ffffffff80104875:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104879:	48 89 c7             	mov    %rax,%rdi
ffffffff8010487c:	e8 95 ba ff ff       	callq  ffffffff80100316 <bwrite>
    brelse(from); 
ffffffff80104881:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104885:	48 89 c7             	mov    %rax,%rdi
ffffffff80104888:	e8 ce ba ff ff       	callq  ffffffff8010035b <brelse>
    brelse(to);
ffffffff8010488d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104891:	48 89 c7             	mov    %rax,%rdi
ffffffff80104894:	e8 c2 ba ff ff       	callq  ffffffff8010035b <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
ffffffff80104899:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff8010489d:	8b 05 b9 de 00 00    	mov    0xdeb9(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff801048a3:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff801048a6:	0f 8f 61 ff ff ff    	jg     ffffffff8010480d <write_log+0x14>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
ffffffff801048ac:	90                   	nop
ffffffff801048ad:	c9                   	leaveq 
ffffffff801048ae:	c3                   	retq   

ffffffff801048af <commit>:

static void
commit()
{
ffffffff801048af:	55                   	push   %rbp
ffffffff801048b0:	48 89 e5             	mov    %rsp,%rbp
  if (log.lh.n > 0) {
ffffffff801048b3:	8b 05 a3 de 00 00    	mov    0xdea3(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff801048b9:	85 c0                	test   %eax,%eax
ffffffff801048bb:	7e 1e                	jle    ffffffff801048db <commit+0x2c>
    write_log();     // Write modified blocks from cache to log
ffffffff801048bd:	e8 37 ff ff ff       	callq  ffffffff801047f9 <write_log>
    write_head();    // Write header to disk -- the real commit
ffffffff801048c2:	e8 4e fd ff ff       	callq  ffffffff80104615 <write_head>
    install_trans(); // Now install writes to home locations
ffffffff801048c7:	e8 12 fc ff ff       	callq  ffffffff801044de <install_trans>
    log.lh.n = 0; 
ffffffff801048cc:	c7 05 86 de 00 00 00 	movl   $0x0,0xde86(%rip)        # ffffffff8011275c <log+0x7c>
ffffffff801048d3:	00 00 00 
    write_head();    // Erase the transaction from the log
ffffffff801048d6:	e8 3a fd ff ff       	callq  ffffffff80104615 <write_head>
  }
}
ffffffff801048db:	90                   	nop
ffffffff801048dc:	5d                   	pop    %rbp
ffffffff801048dd:	c3                   	retq   

ffffffff801048de <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
ffffffff801048de:	55                   	push   %rbp
ffffffff801048df:	48 89 e5             	mov    %rsp,%rbp
ffffffff801048e2:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801048e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
ffffffff801048ea:	8b 05 6c de 00 00    	mov    0xde6c(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff801048f0:	83 f8 1d             	cmp    $0x1d,%eax
ffffffff801048f3:	7f 13                	jg     ffffffff80104908 <log_write+0x2a>
ffffffff801048f5:	8b 05 61 de 00 00    	mov    0xde61(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff801048fb:	8b 15 4b de 00 00    	mov    0xde4b(%rip),%edx        # ffffffff8011274c <log+0x6c>
ffffffff80104901:	83 ea 01             	sub    $0x1,%edx
ffffffff80104904:	39 d0                	cmp    %edx,%eax
ffffffff80104906:	7c 0c                	jl     ffffffff80104914 <log_write+0x36>
    panic("too big a transaction");
ffffffff80104908:	48 c7 c7 27 a9 10 80 	mov    $0xffffffff8010a927,%rdi
ffffffff8010490f:	e8 eb bf ff ff       	callq  ffffffff801008ff <panic>
  if (log.outstanding < 1)
ffffffff80104914:	8b 05 36 de 00 00    	mov    0xde36(%rip),%eax        # ffffffff80112750 <log+0x70>
ffffffff8010491a:	85 c0                	test   %eax,%eax
ffffffff8010491c:	7f 0c                	jg     ffffffff8010492a <log_write+0x4c>
    panic("log_write outside of trans");
ffffffff8010491e:	48 c7 c7 3d a9 10 80 	mov    $0xffffffff8010a93d,%rdi
ffffffff80104925:	e8 d5 bf ff ff       	callq  ffffffff801008ff <panic>

  acquire(&log.lock);
ffffffff8010492a:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff80104931:	e8 6d 20 00 00       	callq  ffffffff801069a3 <acquire>
  for (i = 0; i < log.lh.n; i++) {
ffffffff80104936:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff8010493d:	eb 21                	jmp    ffffffff80104960 <log_write+0x82>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
ffffffff8010493f:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104942:	48 98                	cltq   
ffffffff80104944:	48 83 c0 1c          	add    $0x1c,%rax
ffffffff80104948:	8b 04 85 f0 26 11 80 	mov    -0x7feed910(,%rax,4),%eax
ffffffff8010494f:	89 c2                	mov    %eax,%edx
ffffffff80104951:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104955:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80104958:	39 c2                	cmp    %eax,%edx
ffffffff8010495a:	74 11                	je     ffffffff8010496d <log_write+0x8f>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
ffffffff8010495c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80104960:	8b 05 f6 dd 00 00    	mov    0xddf6(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff80104966:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff80104969:	7f d4                	jg     ffffffff8010493f <log_write+0x61>
ffffffff8010496b:	eb 01                	jmp    ffffffff8010496e <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
ffffffff8010496d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
ffffffff8010496e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104972:	8b 40 08             	mov    0x8(%rax),%eax
ffffffff80104975:	89 c2                	mov    %eax,%edx
ffffffff80104977:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010497a:	48 98                	cltq   
ffffffff8010497c:	48 83 c0 1c          	add    $0x1c,%rax
ffffffff80104980:	89 14 85 f0 26 11 80 	mov    %edx,-0x7feed910(,%rax,4)
  if (i == log.lh.n)
ffffffff80104987:	8b 05 cf dd 00 00    	mov    0xddcf(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff8010498d:	3b 45 fc             	cmp    -0x4(%rbp),%eax
ffffffff80104990:	75 0f                	jne    ffffffff801049a1 <log_write+0xc3>
    log.lh.n++;
ffffffff80104992:	8b 05 c4 dd 00 00    	mov    0xddc4(%rip),%eax        # ffffffff8011275c <log+0x7c>
ffffffff80104998:	83 c0 01             	add    $0x1,%eax
ffffffff8010499b:	89 05 bb dd 00 00    	mov    %eax,0xddbb(%rip)        # ffffffff8011275c <log+0x7c>
  b->flags |= B_DIRTY; // prevent eviction
ffffffff801049a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801049a5:	8b 00                	mov    (%rax),%eax
ffffffff801049a7:	83 c8 04             	or     $0x4,%eax
ffffffff801049aa:	89 c2                	mov    %eax,%edx
ffffffff801049ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801049b0:	89 10                	mov    %edx,(%rax)
  release(&log.lock);
ffffffff801049b2:	48 c7 c7 e0 26 11 80 	mov    $0xffffffff801126e0,%rdi
ffffffff801049b9:	e8 bc 20 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff801049be:	90                   	nop
ffffffff801049bf:	c9                   	leaveq 
ffffffff801049c0:	c3                   	retq   

ffffffff801049c1 <v2p>:
ffffffff801049c1:	55                   	push   %rbp
ffffffff801049c2:	48 89 e5             	mov    %rsp,%rbp
ffffffff801049c5:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801049c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff801049cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801049d1:	b8 00 00 00 80       	mov    $0x80000000,%eax
ffffffff801049d6:	48 01 d0             	add    %rdx,%rax
ffffffff801049d9:	c9                   	leaveq 
ffffffff801049da:	c3                   	retq   

ffffffff801049db <p2v>:
static inline void *p2v(uintp a) { return (void *) ((a) + ((uintp)KERNBASE)); }
ffffffff801049db:	55                   	push   %rbp
ffffffff801049dc:	48 89 e5             	mov    %rsp,%rbp
ffffffff801049df:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801049e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff801049e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801049eb:	48 05 00 00 00 80    	add    $0xffffffff80000000,%rax
ffffffff801049f1:	c9                   	leaveq 
ffffffff801049f2:	c3                   	retq   

ffffffff801049f3 <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uintp newval)
{
ffffffff801049f3:	55                   	push   %rbp
ffffffff801049f4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801049f7:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801049fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff801049ff:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
               "1" ((uint)newval) :
ffffffff80104a03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
xchg(volatile uint *addr, uintp newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffffffff80104a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80104a0b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffffffff80104a0f:	f0 87 02             	lock xchg %eax,(%rdx)
ffffffff80104a12:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" ((uint)newval) :
               "cc");
  return result;
ffffffff80104a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff80104a18:	c9                   	leaveq 
ffffffff80104a19:	c3                   	retq   

ffffffff80104a1a <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
ffffffff80104a1a:	55                   	push   %rbp
ffffffff80104a1b:	48 89 e5             	mov    %rsp,%rbp
  uartearlyinit();
ffffffff80104a1e:	e8 83 3e 00 00       	callq  ffffffff801088a6 <uartearlyinit>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
ffffffff80104a23:	48 c7 c6 00 00 40 80 	mov    $0xffffffff80400000,%rsi
ffffffff80104a2a:	48 c7 c7 00 80 11 80 	mov    $0xffffffff80118000,%rdi
ffffffff80104a31:	e8 7b f1 ff ff       	callq  ffffffff80103bb1 <kinit1>
  kvmalloc();      // kernel page table
ffffffff80104a36:	e8 2c 58 00 00       	callq  ffffffff8010a267 <kvmalloc>
  //if (acpiinit()) // try to use acpi for machine info
    mpinit();      // otherwise use bios MP tables
ffffffff80104a3b:	e8 df 04 00 00       	callq  ffffffff80104f1f <mpinit>
  lapicinit();
ffffffff80104a40:	e8 49 f5 ff ff       	callq  ffffffff80103f8e <lapicinit>
  seginit();       // set up segments
ffffffff80104a45:	e8 0b 55 00 00       	callq  ffffffff80109f55 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
ffffffff80104a4a:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80104a51:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80104a55:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104a58:	0f b6 c0             	movzbl %al,%eax
ffffffff80104a5b:	89 c6                	mov    %eax,%esi
ffffffff80104a5d:	48 c7 c7 58 a9 10 80 	mov    $0xffffffff8010a958,%rdi
ffffffff80104a64:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104a69:	e8 34 bb ff ff       	callq  ffffffff801005a2 <cprintf>
  picinit();       // interrupt controller
ffffffff80104a6e:	e8 60 0c 00 00       	callq  ffffffff801056d3 <picinit>
  ioapicinit();    // another interrupt controller
ffffffff80104a73:	e8 12 f0 ff ff       	callq  ffffffff80103a8a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
ffffffff80104a78:	e8 39 c4 ff ff       	callq  ffffffff80100eb6 <consoleinit>
  uartinit();      // serial port
ffffffff80104a7d:	e8 dd 3e 00 00       	callq  ffffffff8010895f <uartinit>
  pinit();         // process table
ffffffff80104a82:	e8 bf 11 00 00       	callq  ffffffff80105c46 <pinit>
  tvinit();        // trap vectors
ffffffff80104a87:	e8 97 53 00 00       	callq  ffffffff80109e23 <tvinit>
  binit();         // buffer cache
ffffffff80104a8c:	e8 9a b6 ff ff       	callq  ffffffff8010012b <binit>
  fileinit();      // file table
ffffffff80104a91:	e8 73 d3 ff ff       	callq  ffffffff80101e09 <fileinit>
  iinit();         // inode cache
ffffffff80104a96:	e8 9c da ff ff       	callq  ffffffff80102537 <iinit>
  ideinit();       // disk
ffffffff80104a9b:	e8 04 ec ff ff       	callq  ffffffff801036a4 <ideinit>
  if(!ismp)
ffffffff80104aa0:	8b 05 ba e4 00 00    	mov    0xe4ba(%rip),%eax        # ffffffff80112f60 <ismp>
ffffffff80104aa6:	85 c0                	test   %eax,%eax
ffffffff80104aa8:	75 05                	jne    ffffffff80104aaf <main+0x95>
    timerinit();   // uniprocessor timer
ffffffff80104aaa:	e8 2f 3a 00 00       	callq  ffffffff801084de <timerinit>
  startothers();   // start other processors
ffffffff80104aaf:	e8 8a 00 00 00       	callq  ffffffff80104b3e <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
ffffffff80104ab4:	48 c7 c6 00 00 00 8e 	mov    $0xffffffff8e000000,%rsi
ffffffff80104abb:	48 c7 c7 00 00 40 80 	mov    $0xffffffff80400000,%rdi
ffffffff80104ac2:	e8 2d f1 ff ff       	callq  ffffffff80103bf4 <kinit2>
  userinit();      // first user process
ffffffff80104ac7:	e8 bf 12 00 00       	callq  ffffffff80105d8b <userinit>
  cpuidinit();
ffffffff80104acc:	e8 ed cd ff ff       	callq  ffffffff801018be <cpuidinit>
  // Finish setting up this processor in mpmain.
  mpmain();
ffffffff80104ad1:	e8 18 00 00 00       	callq  ffffffff80104aee <mpmain>

ffffffff80104ad6 <mpenter>:
}

// Other CPUs jump here from entryother.S.
void
mpenter(void)
{
ffffffff80104ad6:	55                   	push   %rbp
ffffffff80104ad7:	48 89 e5             	mov    %rsp,%rbp
  switchkvm(); 
ffffffff80104ada:	e8 4d 59 00 00       	callq  ffffffff8010a42c <switchkvm>
  seginit();
ffffffff80104adf:	e8 71 54 00 00       	callq  ffffffff80109f55 <seginit>
  lapicinit();
ffffffff80104ae4:	e8 a5 f4 ff ff       	callq  ffffffff80103f8e <lapicinit>
  mpmain();
ffffffff80104ae9:	e8 00 00 00 00       	callq  ffffffff80104aee <mpmain>

ffffffff80104aee <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
ffffffff80104aee:	55                   	push   %rbp
ffffffff80104aef:	48 89 e5             	mov    %rsp,%rbp
  cprintf("cpu%d: starting\n", cpu->id);
ffffffff80104af2:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80104af9:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80104afd:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104b00:	0f b6 c0             	movzbl %al,%eax
ffffffff80104b03:	89 c6                	mov    %eax,%esi
ffffffff80104b05:	48 c7 c7 6f a9 10 80 	mov    $0xffffffff8010a96f,%rdi
ffffffff80104b0c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104b11:	e8 8c ba ff ff       	callq  ffffffff801005a2 <cprintf>
  idtinit();       // load idt register
ffffffff80104b16:	e8 0f 53 00 00       	callq  ffffffff80109e2a <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
ffffffff80104b1b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80104b22:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80104b26:	48 05 d8 00 00 00    	add    $0xd8,%rax
ffffffff80104b2c:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80104b31:	48 89 c7             	mov    %rax,%rdi
ffffffff80104b34:	e8 ba fe ff ff       	callq  ffffffff801049f3 <xchg>
  scheduler();     // start running processes
ffffffff80104b39:	e8 df 18 00 00       	callq  ffffffff8010641d <scheduler>

ffffffff80104b3e <startothers>:
#endif /* X64 */

// Start the non-boot (AP) processors.
static void
startothers(void)
{
ffffffff80104b3e:	55                   	push   %rbp
ffffffff80104b3f:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104b42:	53                   	push   %rbx
ffffffff80104b43:	48 83 ec 28          	sub    $0x28,%rsp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
ffffffff80104b47:	bf 00 70 00 00       	mov    $0x7000,%edi
ffffffff80104b4c:	e8 8a fe ff ff       	callq  ffffffff801049db <p2v>
ffffffff80104b51:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  memmove(code, _binary_out_entryother_start, (uintp)_binary_out_entryother_size);
ffffffff80104b55:	48 c7 c0 72 00 00 00 	mov    $0x72,%rax
ffffffff80104b5c:	89 c2                	mov    %eax,%edx
ffffffff80104b5e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104b62:	48 c7 c6 b4 be 10 80 	mov    $0xffffffff8010beb4,%rsi
ffffffff80104b69:	48 89 c7             	mov    %rax,%rdi
ffffffff80104b6c:	e8 90 22 00 00       	callq  ffffffff80106e01 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
ffffffff80104b71:	48 c7 45 e8 e0 27 11 	movq   $0xffffffff801127e0,-0x18(%rbp)
ffffffff80104b78:	80 
ffffffff80104b79:	e9 a3 00 00 00       	jmpq   ffffffff80104c21 <startothers+0xe3>
    if(c == cpus+cpunum())  // We've started already.
ffffffff80104b7e:	e8 27 f5 ff ff       	callq  ffffffff801040aa <cpunum>
ffffffff80104b83:	48 98                	cltq   
ffffffff80104b85:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80104b89:	48 89 c2             	mov    %rax,%rdx
ffffffff80104b8c:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff80104b90:	48 29 c2             	sub    %rax,%rdx
ffffffff80104b93:	48 89 d0             	mov    %rdx,%rax
ffffffff80104b96:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff80104b9c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80104ba0:	74 76                	je     ffffffff80104c18 <startothers+0xda>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
ffffffff80104ba2:	e8 74 f1 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80104ba7:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
#if X64
    *(uint32*)(code-4) = 0x8000; // just enough stack to get us to entry64mp
ffffffff80104bab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104baf:	48 83 e8 04          	sub    $0x4,%rax
ffffffff80104bb3:	c7 00 00 80 00 00    	movl   $0x8000,(%rax)
    *(uint32*)(code-8) = v2p(entry32mp);
ffffffff80104bb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104bbd:	48 8d 58 f8          	lea    -0x8(%rax),%rbx
ffffffff80104bc1:	48 c7 c7 74 00 10 80 	mov    $0xffffffff80100074,%rdi
ffffffff80104bc8:	e8 f4 fd ff ff       	callq  ffffffff801049c1 <v2p>
ffffffff80104bcd:	89 03                	mov    %eax,(%rbx)
    *(uint64*)(code-16) = (uint64) (stack + KSTACKSIZE);
ffffffff80104bcf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104bd3:	48 83 e8 10          	sub    $0x10,%rax
ffffffff80104bd7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
ffffffff80104bdb:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
ffffffff80104be2:	48 89 10             	mov    %rdx,(%rax)
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) v2p(entrypgdir);
#endif

    lapicstartap(c->apicid, v2p(code));
ffffffff80104be5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104be9:	48 89 c7             	mov    %rax,%rdi
ffffffff80104bec:	e8 d0 fd ff ff       	callq  ffffffff801049c1 <v2p>
ffffffff80104bf1:	89 c2                	mov    %eax,%edx
ffffffff80104bf3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104bf7:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffffffff80104bfb:	0f b6 c0             	movzbl %al,%eax
ffffffff80104bfe:	89 d6                	mov    %edx,%esi
ffffffff80104c00:	89 c7                	mov    %eax,%edi
ffffffff80104c02:	e8 86 f5 ff ff       	callq  ffffffff8010418d <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
ffffffff80104c07:	90                   	nop
ffffffff80104c08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104c0c:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
ffffffff80104c12:	85 c0                	test   %eax,%eax
ffffffff80104c14:	74 f2                	je     ffffffff80104c08 <startothers+0xca>
ffffffff80104c16:	eb 01                	jmp    ffffffff80104c19 <startothers+0xdb>
  code = p2v(0x7000);
  memmove(code, _binary_out_entryother_start, (uintp)_binary_out_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
ffffffff80104c18:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_out_entryother_start, (uintp)_binary_out_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
ffffffff80104c19:	48 81 45 e8 f0 00 00 	addq   $0xf0,-0x18(%rbp)
ffffffff80104c20:	00 
ffffffff80104c21:	8b 05 3d e3 00 00    	mov    0xe33d(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80104c27:	48 98                	cltq   
ffffffff80104c29:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80104c2d:	48 89 c2             	mov    %rax,%rdx
ffffffff80104c30:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff80104c34:	48 29 c2             	sub    %rax,%rdx
ffffffff80104c37:	48 89 d0             	mov    %rdx,%rax
ffffffff80104c3a:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff80104c40:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80104c44:	0f 87 34 ff ff ff    	ja     ffffffff80104b7e <startothers+0x40>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
ffffffff80104c4a:	90                   	nop
ffffffff80104c4b:	48 83 c4 28          	add    $0x28,%rsp
ffffffff80104c4f:	5b                   	pop    %rbx
ffffffff80104c50:	5d                   	pop    %rbp
ffffffff80104c51:	c3                   	retq   

ffffffff80104c52 <p2v>:
ffffffff80104c52:	55                   	push   %rbp
ffffffff80104c53:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104c56:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80104c5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80104c5e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104c62:	48 05 00 00 00 80    	add    $0xffffffff80000000,%rax
ffffffff80104c68:	c9                   	leaveq 
ffffffff80104c69:	c3                   	retq   

ffffffff80104c6a <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff80104c6a:	55                   	push   %rbp
ffffffff80104c6b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104c6e:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80104c72:	89 f8                	mov    %edi,%eax
ffffffff80104c74:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff80104c78:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff80104c7c:	89 c2                	mov    %eax,%edx
ffffffff80104c7e:	ec                   	in     (%dx),%al
ffffffff80104c7f:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff80104c82:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff80104c86:	c9                   	leaveq 
ffffffff80104c87:	c3                   	retq   

ffffffff80104c88 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff80104c88:	55                   	push   %rbp
ffffffff80104c89:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104c8c:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80104c90:	89 fa                	mov    %edi,%edx
ffffffff80104c92:	89 f0                	mov    %esi,%eax
ffffffff80104c94:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff80104c98:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff80104c9b:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff80104c9f:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff80104ca3:	ee                   	out    %al,(%dx)
}
ffffffff80104ca4:	90                   	nop
ffffffff80104ca5:	c9                   	leaveq 
ffffffff80104ca6:	c3                   	retq   

ffffffff80104ca7 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
ffffffff80104ca7:	55                   	push   %rbp
ffffffff80104ca8:	48 89 e5             	mov    %rsp,%rbp
  return bcpu-cpus;
ffffffff80104cab:	48 8b 05 be e2 00 00 	mov    0xe2be(%rip),%rax        # ffffffff80112f70 <bcpu>
ffffffff80104cb2:	48 89 c2             	mov    %rax,%rdx
ffffffff80104cb5:	48 c7 c0 e0 27 11 80 	mov    $0xffffffff801127e0,%rax
ffffffff80104cbc:	48 29 c2             	sub    %rax,%rdx
ffffffff80104cbf:	48 89 d0             	mov    %rdx,%rax
ffffffff80104cc2:	48 c1 f8 04          	sar    $0x4,%rax
ffffffff80104cc6:	48 89 c2             	mov    %rax,%rdx
ffffffff80104cc9:	48 b8 ef ee ee ee ee 	movabs $0xeeeeeeeeeeeeeeef,%rax
ffffffff80104cd0:	ee ee ee 
ffffffff80104cd3:	48 0f af c2          	imul   %rdx,%rax
}
ffffffff80104cd7:	5d                   	pop    %rbp
ffffffff80104cd8:	c3                   	retq   

ffffffff80104cd9 <sum>:

static uchar
sum(uchar *addr, int len)
{
ffffffff80104cd9:	55                   	push   %rbp
ffffffff80104cda:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104cdd:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80104ce1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80104ce5:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, sum;
  
  sum = 0;
ffffffff80104ce8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  for(i=0; i<len; i++)
ffffffff80104cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80104cf6:	eb 1a                	jmp    ffffffff80104d12 <sum+0x39>
    sum += addr[i];
ffffffff80104cf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104cfb:	48 63 d0             	movslq %eax,%rdx
ffffffff80104cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104d02:	48 01 d0             	add    %rdx,%rax
ffffffff80104d05:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104d08:	0f b6 c0             	movzbl %al,%eax
ffffffff80104d0b:	01 45 f8             	add    %eax,-0x8(%rbp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
ffffffff80104d0e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80104d12:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80104d15:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffffffff80104d18:	7c de                	jl     ffffffff80104cf8 <sum+0x1f>
    sum += addr[i];
  return sum;
ffffffff80104d1a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
ffffffff80104d1d:	c9                   	leaveq 
ffffffff80104d1e:	c3                   	retq   

ffffffff80104d1f <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
ffffffff80104d1f:	55                   	push   %rbp
ffffffff80104d20:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104d23:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80104d27:	89 7d dc             	mov    %edi,-0x24(%rbp)
ffffffff80104d2a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  uchar *e, *p, *addr;

  addr = p2v(a);
ffffffff80104d2d:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80104d30:	48 89 c7             	mov    %rax,%rdi
ffffffff80104d33:	e8 1a ff ff ff       	callq  ffffffff80104c52 <p2v>
ffffffff80104d38:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = addr+len;
ffffffff80104d3c:	8b 45 d8             	mov    -0x28(%rbp),%eax
ffffffff80104d3f:	48 63 d0             	movslq %eax,%rdx
ffffffff80104d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104d46:	48 01 d0             	add    %rdx,%rax
ffffffff80104d49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  for(p = addr; p < e; p += sizeof(struct mp))
ffffffff80104d4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104d51:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80104d55:	eb 3c                	jmp    ffffffff80104d93 <mpsearch1+0x74>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
ffffffff80104d57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104d5b:	ba 04 00 00 00       	mov    $0x4,%edx
ffffffff80104d60:	48 c7 c6 80 a9 10 80 	mov    $0xffffffff8010a980,%rsi
ffffffff80104d67:	48 89 c7             	mov    %rax,%rdi
ffffffff80104d6a:	e8 23 20 00 00       	callq  ffffffff80106d92 <memcmp>
ffffffff80104d6f:	85 c0                	test   %eax,%eax
ffffffff80104d71:	75 1b                	jne    ffffffff80104d8e <mpsearch1+0x6f>
ffffffff80104d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104d77:	be 10 00 00 00       	mov    $0x10,%esi
ffffffff80104d7c:	48 89 c7             	mov    %rax,%rdi
ffffffff80104d7f:	e8 55 ff ff ff       	callq  ffffffff80104cd9 <sum>
ffffffff80104d84:	84 c0                	test   %al,%al
ffffffff80104d86:	75 06                	jne    ffffffff80104d8e <mpsearch1+0x6f>
      return (struct mp*)p;
ffffffff80104d88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104d8c:	eb 14                	jmp    ffffffff80104da2 <mpsearch1+0x83>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
ffffffff80104d8e:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
ffffffff80104d93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104d97:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80104d9b:	72 ba                	jb     ffffffff80104d57 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
ffffffff80104d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80104da2:	c9                   	leaveq 
ffffffff80104da3:	c3                   	retq   

ffffffff80104da4 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM address space between 0F0000h and 0FFFFFh.
static struct mp*
mpsearch(void)
{
ffffffff80104da4:	55                   	push   %rbp
ffffffff80104da5:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104da8:	48 83 ec 20          	sub    $0x20,%rsp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
ffffffff80104dac:	48 c7 45 f8 00 04 00 	movq   $0xffffffff80000400,-0x8(%rbp)
ffffffff80104db3:	80 
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
ffffffff80104db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104db8:	48 83 c0 0f          	add    $0xf,%rax
ffffffff80104dbc:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104dbf:	0f b6 c0             	movzbl %al,%eax
ffffffff80104dc2:	c1 e0 08             	shl    $0x8,%eax
ffffffff80104dc5:	89 c2                	mov    %eax,%edx
ffffffff80104dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104dcb:	48 83 c0 0e          	add    $0xe,%rax
ffffffff80104dcf:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104dd2:	0f b6 c0             	movzbl %al,%eax
ffffffff80104dd5:	09 d0                	or     %edx,%eax
ffffffff80104dd7:	c1 e0 04             	shl    $0x4,%eax
ffffffff80104dda:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffffffff80104ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffffffff80104de1:	74 20                	je     ffffffff80104e03 <mpsearch+0x5f>
    if((mp = mpsearch1(p, 1024)))
ffffffff80104de3:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80104de6:	be 00 04 00 00       	mov    $0x400,%esi
ffffffff80104deb:	89 c7                	mov    %eax,%edi
ffffffff80104ded:	e8 2d ff ff ff       	callq  ffffffff80104d1f <mpsearch1>
ffffffff80104df2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80104df6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff80104dfb:	74 54                	je     ffffffff80104e51 <mpsearch+0xad>
      return mp;
ffffffff80104dfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104e01:	eb 5d                	jmp    ffffffff80104e60 <mpsearch+0xbc>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
ffffffff80104e03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104e07:	48 83 c0 14          	add    $0x14,%rax
ffffffff80104e0b:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104e0e:	0f b6 c0             	movzbl %al,%eax
ffffffff80104e11:	c1 e0 08             	shl    $0x8,%eax
ffffffff80104e14:	89 c2                	mov    %eax,%edx
ffffffff80104e16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104e1a:	48 83 c0 13          	add    $0x13,%rax
ffffffff80104e1e:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104e21:	0f b6 c0             	movzbl %al,%eax
ffffffff80104e24:	09 d0                	or     %edx,%eax
ffffffff80104e26:	c1 e0 0a             	shl    $0xa,%eax
ffffffff80104e29:	89 45 f4             	mov    %eax,-0xc(%rbp)
    if((mp = mpsearch1(p-1024, 1024)))
ffffffff80104e2c:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80104e2f:	2d 00 04 00 00       	sub    $0x400,%eax
ffffffff80104e34:	be 00 04 00 00       	mov    $0x400,%esi
ffffffff80104e39:	89 c7                	mov    %eax,%edi
ffffffff80104e3b:	e8 df fe ff ff       	callq  ffffffff80104d1f <mpsearch1>
ffffffff80104e40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80104e44:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff80104e49:	74 06                	je     ffffffff80104e51 <mpsearch+0xad>
      return mp;
ffffffff80104e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104e4f:	eb 0f                	jmp    ffffffff80104e60 <mpsearch+0xbc>
  }
  return mpsearch1(0xF0000, 0x10000);
ffffffff80104e51:	be 00 00 01 00       	mov    $0x10000,%esi
ffffffff80104e56:	bf 00 00 0f 00       	mov    $0xf0000,%edi
ffffffff80104e5b:	e8 bf fe ff ff       	callq  ffffffff80104d1f <mpsearch1>
}
ffffffff80104e60:	c9                   	leaveq 
ffffffff80104e61:	c3                   	retq   

ffffffff80104e62 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
ffffffff80104e62:	55                   	push   %rbp
ffffffff80104e63:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104e66:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80104e6a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
ffffffff80104e6e:	e8 31 ff ff ff       	callq  ffffffff80104da4 <mpsearch>
ffffffff80104e73:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80104e77:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80104e7c:	74 0b                	je     ffffffff80104e89 <mpconfig+0x27>
ffffffff80104e7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104e82:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80104e85:	85 c0                	test   %eax,%eax
ffffffff80104e87:	75 0a                	jne    ffffffff80104e93 <mpconfig+0x31>
    return 0;
ffffffff80104e89:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104e8e:	e9 8a 00 00 00       	jmpq   ffffffff80104f1d <mpconfig+0xbb>
  conf = (struct mpconf*) p2v((uintp) mp->physaddr);
ffffffff80104e93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104e97:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80104e9a:	89 c0                	mov    %eax,%eax
ffffffff80104e9c:	48 89 c7             	mov    %rax,%rdi
ffffffff80104e9f:	e8 ae fd ff ff       	callq  ffffffff80104c52 <p2v>
ffffffff80104ea4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(memcmp(conf, "PCMP", 4) != 0)
ffffffff80104ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104eac:	ba 04 00 00 00       	mov    $0x4,%edx
ffffffff80104eb1:	48 c7 c6 85 a9 10 80 	mov    $0xffffffff8010a985,%rsi
ffffffff80104eb8:	48 89 c7             	mov    %rax,%rdi
ffffffff80104ebb:	e8 d2 1e 00 00       	callq  ffffffff80106d92 <memcmp>
ffffffff80104ec0:	85 c0                	test   %eax,%eax
ffffffff80104ec2:	74 07                	je     ffffffff80104ecb <mpconfig+0x69>
    return 0;
ffffffff80104ec4:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104ec9:	eb 52                	jmp    ffffffff80104f1d <mpconfig+0xbb>
  if(conf->version != 1 && conf->version != 4)
ffffffff80104ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104ecf:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffffffff80104ed3:	3c 01                	cmp    $0x1,%al
ffffffff80104ed5:	74 13                	je     ffffffff80104eea <mpconfig+0x88>
ffffffff80104ed7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104edb:	0f b6 40 06          	movzbl 0x6(%rax),%eax
ffffffff80104edf:	3c 04                	cmp    $0x4,%al
ffffffff80104ee1:	74 07                	je     ffffffff80104eea <mpconfig+0x88>
    return 0;
ffffffff80104ee3:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104ee8:	eb 33                	jmp    ffffffff80104f1d <mpconfig+0xbb>
  if(sum((uchar*)conf, conf->length) != 0)
ffffffff80104eea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104eee:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffffffff80104ef2:	0f b7 d0             	movzwl %ax,%edx
ffffffff80104ef5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104ef9:	89 d6                	mov    %edx,%esi
ffffffff80104efb:	48 89 c7             	mov    %rax,%rdi
ffffffff80104efe:	e8 d6 fd ff ff       	callq  ffffffff80104cd9 <sum>
ffffffff80104f03:	84 c0                	test   %al,%al
ffffffff80104f05:	74 07                	je     ffffffff80104f0e <mpconfig+0xac>
    return 0;
ffffffff80104f07:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104f0c:	eb 0f                	jmp    ffffffff80104f1d <mpconfig+0xbb>
  *pmp = mp;
ffffffff80104f0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80104f12:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80104f16:	48 89 10             	mov    %rdx,(%rax)
  return conf;
ffffffff80104f19:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffffffff80104f1d:	c9                   	leaveq 
ffffffff80104f1e:	c3                   	retq   

ffffffff80104f1f <mpinit>:

void
mpinit(void)
{
ffffffff80104f1f:	55                   	push   %rbp
ffffffff80104f20:	48 89 e5             	mov    %rsp,%rbp
ffffffff80104f23:	48 83 ec 30          	sub    $0x30,%rsp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
ffffffff80104f27:	48 c7 05 3e e0 00 00 	movq   $0xffffffff801127e0,0xe03e(%rip)        # ffffffff80112f70 <bcpu>
ffffffff80104f2e:	e0 27 11 80 
  if((conf = mpconfig(&mp)) == 0)
ffffffff80104f32:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffffffff80104f36:	48 89 c7             	mov    %rax,%rdi
ffffffff80104f39:	e8 24 ff ff ff       	callq  ffffffff80104e62 <mpconfig>
ffffffff80104f3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80104f42:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80104f47:	0f 84 fa 01 00 00    	je     ffffffff80105147 <mpinit+0x228>
    return;
  ismp = 1;
ffffffff80104f4d:	c7 05 09 e0 00 00 01 	movl   $0x1,0xe009(%rip)        # ffffffff80112f60 <ismp>
ffffffff80104f54:	00 00 00 
  lapic = IO2V((uintp)conf->lapicaddr);
ffffffff80104f57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104f5b:	8b 40 24             	mov    0x24(%rax),%eax
ffffffff80104f5e:	89 c2                	mov    %eax,%edx
ffffffff80104f60:	48 b8 00 00 00 42 fe 	movabs $0xfffffffe42000000,%rax
ffffffff80104f67:	ff ff ff 
ffffffff80104f6a:	48 01 d0             	add    %rdx,%rax
ffffffff80104f6d:	48 89 05 4c d7 00 00 	mov    %rax,0xd74c(%rip)        # ffffffff801126c0 <lapic>
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffffffff80104f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104f78:	48 83 c0 2c          	add    $0x2c,%rax
ffffffff80104f7c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80104f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104f84:	0f b7 40 04          	movzwl 0x4(%rax),%eax
ffffffff80104f88:	0f b7 d0             	movzwl %ax,%edx
ffffffff80104f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80104f8f:	48 01 d0             	add    %rdx,%rax
ffffffff80104f92:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80104f96:	e9 3d 01 00 00       	jmpq   ffffffff801050d8 <mpinit+0x1b9>
    switch(*p){
ffffffff80104f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104f9f:	0f b6 00             	movzbl (%rax),%eax
ffffffff80104fa2:	0f b6 c0             	movzbl %al,%eax
ffffffff80104fa5:	83 f8 04             	cmp    $0x4,%eax
ffffffff80104fa8:	0f 87 03 01 00 00    	ja     ffffffff801050b1 <mpinit+0x192>
ffffffff80104fae:	89 c0                	mov    %eax,%eax
ffffffff80104fb0:	48 8b 04 c5 c8 a9 10 	mov    -0x7fef5638(,%rax,8),%rax
ffffffff80104fb7:	80 
ffffffff80104fb8:	ff e0                	jmpq   *%rax
    case MPPROC:
      proc = (struct mpproc*)p;
ffffffff80104fba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80104fbe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      cprintf("mpinit ncpu=%d apicid=%d\n", ncpu, proc->apicid);
ffffffff80104fc2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104fc6:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffffffff80104fca:	0f b6 d0             	movzbl %al,%edx
ffffffff80104fcd:	8b 05 91 df 00 00    	mov    0xdf91(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80104fd3:	89 c6                	mov    %eax,%esi
ffffffff80104fd5:	48 c7 c7 8a a9 10 80 	mov    $0xffffffff8010a98a,%rdi
ffffffff80104fdc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80104fe1:	e8 bc b5 ff ff       	callq  ffffffff801005a2 <cprintf>
      if(proc->flags & MPBOOT)
ffffffff80104fe6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80104fea:	0f b6 40 03          	movzbl 0x3(%rax),%eax
ffffffff80104fee:	0f b6 c0             	movzbl %al,%eax
ffffffff80104ff1:	83 e0 02             	and    $0x2,%eax
ffffffff80104ff4:	85 c0                	test   %eax,%eax
ffffffff80104ff6:	74 2c                	je     ffffffff80105024 <mpinit+0x105>
        bcpu = &cpus[ncpu];
ffffffff80104ff8:	8b 05 66 df 00 00    	mov    0xdf66(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80104ffe:	48 98                	cltq   
ffffffff80105000:	48 89 c2             	mov    %rax,%rdx
ffffffff80105003:	48 89 d0             	mov    %rdx,%rax
ffffffff80105006:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8010500a:	48 89 c2             	mov    %rax,%rdx
ffffffff8010500d:	48 89 d0             	mov    %rdx,%rax
ffffffff80105010:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80105014:	48 29 d0             	sub    %rdx,%rax
ffffffff80105017:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff8010501d:	48 89 05 4c df 00 00 	mov    %rax,0xdf4c(%rip)        # ffffffff80112f70 <bcpu>
      cpus[ncpu].id = ncpu;
ffffffff80105024:	8b 05 3a df 00 00    	mov    0xdf3a(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff8010502a:	8b 15 34 df 00 00    	mov    0xdf34(%rip),%edx        # ffffffff80112f64 <ncpu>
ffffffff80105030:	89 d1                	mov    %edx,%ecx
ffffffff80105032:	48 98                	cltq   
ffffffff80105034:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80105038:	48 89 c2             	mov    %rax,%rdx
ffffffff8010503b:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff8010503f:	48 29 c2             	sub    %rax,%rdx
ffffffff80105042:	48 89 d0             	mov    %rdx,%rax
ffffffff80105045:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff8010504b:	88 08                	mov    %cl,(%rax)
      cpus[ncpu].apicid = proc->apicid;
ffffffff8010504d:	8b 0d 11 df 00 00    	mov    0xdf11(%rip),%ecx        # ffffffff80112f64 <ncpu>
ffffffff80105053:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105057:	0f b6 50 01          	movzbl 0x1(%rax),%edx
ffffffff8010505b:	48 63 c1             	movslq %ecx,%rax
ffffffff8010505e:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80105062:	48 89 c1             	mov    %rax,%rcx
ffffffff80105065:	48 c1 e1 04          	shl    $0x4,%rcx
ffffffff80105069:	48 29 c1             	sub    %rax,%rcx
ffffffff8010506c:	48 89 c8             	mov    %rcx,%rax
ffffffff8010506f:	48 05 e1 27 11 80    	add    $0xffffffff801127e1,%rax
ffffffff80105075:	88 10                	mov    %dl,(%rax)
      ncpu++;
ffffffff80105077:	8b 05 e7 de 00 00    	mov    0xdee7(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff8010507d:	83 c0 01             	add    $0x1,%eax
ffffffff80105080:	89 05 de de 00 00    	mov    %eax,0xdede(%rip)        # ffffffff80112f64 <ncpu>
      p += sizeof(struct mpproc);
ffffffff80105086:	48 83 45 f8 14       	addq   $0x14,-0x8(%rbp)
      continue;
ffffffff8010508b:	eb 4b                	jmp    ffffffff801050d8 <mpinit+0x1b9>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
ffffffff8010508d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105091:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
      ioapicid = ioapic->apicno;
ffffffff80105095:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80105099:	0f b6 40 01          	movzbl 0x1(%rax),%eax
ffffffff8010509d:	88 05 c5 de 00 00    	mov    %al,0xdec5(%rip)        # ffffffff80112f68 <ioapicid>
      p += sizeof(struct mpioapic);
ffffffff801050a3:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffffffff801050a8:	eb 2e                	jmp    ffffffff801050d8 <mpinit+0x1b9>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
ffffffff801050aa:	48 83 45 f8 08       	addq   $0x8,-0x8(%rbp)
      continue;
ffffffff801050af:	eb 27                	jmp    ffffffff801050d8 <mpinit+0x1b9>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
ffffffff801050b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801050b5:	0f b6 00             	movzbl (%rax),%eax
ffffffff801050b8:	0f b6 c0             	movzbl %al,%eax
ffffffff801050bb:	89 c6                	mov    %eax,%esi
ffffffff801050bd:	48 c7 c7 a8 a9 10 80 	mov    $0xffffffff8010a9a8,%rdi
ffffffff801050c4:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801050c9:	e8 d4 b4 ff ff       	callq  ffffffff801005a2 <cprintf>
      ismp = 0;
ffffffff801050ce:	c7 05 88 de 00 00 00 	movl   $0x0,0xde88(%rip)        # ffffffff80112f60 <ismp>
ffffffff801050d5:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = IO2V((uintp)conf->lapicaddr);
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
ffffffff801050d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801050dc:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff801050e0:	0f 82 b5 fe ff ff    	jb     ffffffff80104f9b <mpinit+0x7c>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
ffffffff801050e6:	8b 05 74 de 00 00    	mov    0xde74(%rip),%eax        # ffffffff80112f60 <ismp>
ffffffff801050ec:	85 c0                	test   %eax,%eax
ffffffff801050ee:	75 1e                	jne    ffffffff8010510e <mpinit+0x1ef>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
ffffffff801050f0:	c7 05 6a de 00 00 01 	movl   $0x1,0xde6a(%rip)        # ffffffff80112f64 <ncpu>
ffffffff801050f7:	00 00 00 
    lapic = 0;
ffffffff801050fa:	48 c7 05 bb d5 00 00 	movq   $0x0,0xd5bb(%rip)        # ffffffff801126c0 <lapic>
ffffffff80105101:	00 00 00 00 
    ioapicid = 0;
ffffffff80105105:	c6 05 5c de 00 00 00 	movb   $0x0,0xde5c(%rip)        # ffffffff80112f68 <ioapicid>
    return;
ffffffff8010510c:	eb 3a                	jmp    ffffffff80105148 <mpinit+0x229>
  }

  if(mp->imcrp){
ffffffff8010510e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80105112:	0f b6 40 0c          	movzbl 0xc(%rax),%eax
ffffffff80105116:	84 c0                	test   %al,%al
ffffffff80105118:	74 2e                	je     ffffffff80105148 <mpinit+0x229>
    // it would run on real hardware.
    outb(0x22, 0x70);   // Select IMCR
ffffffff8010511a:	be 70 00 00 00       	mov    $0x70,%esi
ffffffff8010511f:	bf 22 00 00 00       	mov    $0x22,%edi
ffffffff80105124:	e8 5f fb ff ff       	callq  ffffffff80104c88 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
ffffffff80105129:	bf 23 00 00 00       	mov    $0x23,%edi
ffffffff8010512e:	e8 37 fb ff ff       	callq  ffffffff80104c6a <inb>
ffffffff80105133:	83 c8 01             	or     $0x1,%eax
ffffffff80105136:	0f b6 c0             	movzbl %al,%eax
ffffffff80105139:	89 c6                	mov    %eax,%esi
ffffffff8010513b:	bf 23 00 00 00       	mov    $0x23,%edi
ffffffff80105140:	e8 43 fb ff ff       	callq  ffffffff80104c88 <outb>
ffffffff80105145:	eb 01                	jmp    ffffffff80105148 <mpinit+0x229>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
ffffffff80105147:	90                   	nop
  if(mp->imcrp){
    // it would run on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
ffffffff80105148:	c9                   	leaveq 
ffffffff80105149:	c3                   	retq   

ffffffff8010514a <p2v>:
ffffffff8010514a:	55                   	push   %rbp
ffffffff8010514b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010514e:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80105152:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80105156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010515a:	48 05 00 00 00 80    	add    $0xffffffff80000000,%rax
ffffffff80105160:	c9                   	leaveq 
ffffffff80105161:	c3                   	retq   

ffffffff80105162 <scan_rdsp>:
extern struct cpu cpus[NCPU];
extern int ismp;
extern int ncpu;
extern uchar ioapicid;

static struct acpi_rdsp *scan_rdsp(uint base, uint len) {
ffffffff80105162:	55                   	push   %rbp
ffffffff80105163:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105166:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010516a:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff8010516d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  uchar *p;
  for (p = p2v(base); len >= sizeof(struct acpi_rdsp); len -= 4, p += 4) {
ffffffff80105170:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80105173:	48 89 c7             	mov    %rax,%rdi
ffffffff80105176:	e8 cf ff ff ff       	callq  ffffffff8010514a <p2v>
ffffffff8010517b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff8010517f:	eb 62                	jmp    ffffffff801051e3 <scan_rdsp+0x81>
    if (memcmp(p, SIG_RDSP, 8) == 0) {
ffffffff80105181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105185:	ba 08 00 00 00       	mov    $0x8,%edx
ffffffff8010518a:	48 c7 c6 f0 a9 10 80 	mov    $0xffffffff8010a9f0,%rsi
ffffffff80105191:	48 89 c7             	mov    %rax,%rdi
ffffffff80105194:	e8 f9 1b 00 00       	callq  ffffffff80106d92 <memcmp>
ffffffff80105199:	85 c0                	test   %eax,%eax
ffffffff8010519b:	75 3d                	jne    ffffffff801051da <scan_rdsp+0x78>
      uint sum, n;
      for (sum = 0, n = 0; n < 20; n++)
ffffffff8010519d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffffffff801051a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
ffffffff801051ab:	eb 17                	jmp    ffffffff801051c4 <scan_rdsp+0x62>
        sum += p[n];
ffffffff801051ad:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffffffff801051b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801051b4:	48 01 d0             	add    %rdx,%rax
ffffffff801051b7:	0f b6 00             	movzbl (%rax),%eax
ffffffff801051ba:	0f b6 c0             	movzbl %al,%eax
ffffffff801051bd:	01 45 f4             	add    %eax,-0xc(%rbp)
static struct acpi_rdsp *scan_rdsp(uint base, uint len) {
  uchar *p;
  for (p = p2v(base); len >= sizeof(struct acpi_rdsp); len -= 4, p += 4) {
    if (memcmp(p, SIG_RDSP, 8) == 0) {
      uint sum, n;
      for (sum = 0, n = 0; n < 20; n++)
ffffffff801051c0:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
ffffffff801051c4:	83 7d f0 13          	cmpl   $0x13,-0x10(%rbp)
ffffffff801051c8:	76 e3                	jbe    ffffffff801051ad <scan_rdsp+0x4b>
        sum += p[n];
      if ((sum & 0xff) == 0)
ffffffff801051ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff801051cd:	0f b6 c0             	movzbl %al,%eax
ffffffff801051d0:	85 c0                	test   %eax,%eax
ffffffff801051d2:	75 06                	jne    ffffffff801051da <scan_rdsp+0x78>
        return (struct acpi_rdsp *) p;
ffffffff801051d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801051d8:	eb 14                	jmp    ffffffff801051ee <scan_rdsp+0x8c>
extern int ncpu;
extern uchar ioapicid;

static struct acpi_rdsp *scan_rdsp(uint base, uint len) {
  uchar *p;
  for (p = p2v(base); len >= sizeof(struct acpi_rdsp); len -= 4, p += 4) {
ffffffff801051da:	83 6d e8 04          	subl   $0x4,-0x18(%rbp)
ffffffff801051de:	48 83 45 f8 04       	addq   $0x4,-0x8(%rbp)
ffffffff801051e3:	83 7d e8 23          	cmpl   $0x23,-0x18(%rbp)
ffffffff801051e7:	77 98                	ja     ffffffff80105181 <scan_rdsp+0x1f>
        sum += p[n];
      if ((sum & 0xff) == 0)
        return (struct acpi_rdsp *) p;
    }
  }
  return (struct acpi_rdsp *) 0;  
ffffffff801051e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801051ee:	c9                   	leaveq 
ffffffff801051ef:	c3                   	retq   

ffffffff801051f0 <find_rdsp>:

static struct acpi_rdsp *find_rdsp(void) {
ffffffff801051f0:	55                   	push   %rbp
ffffffff801051f1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801051f4:	48 83 ec 10          	sub    $0x10,%rsp
  struct acpi_rdsp *rdsp;
  uintp pa;
  pa = *((ushort*) P2V(0x40E)) << 4; // EBDA
ffffffff801051f8:	48 c7 c0 0e 04 00 80 	mov    $0xffffffff8000040e,%rax
ffffffff801051ff:	0f b7 00             	movzwl (%rax),%eax
ffffffff80105202:	0f b7 c0             	movzwl %ax,%eax
ffffffff80105205:	c1 e0 04             	shl    $0x4,%eax
ffffffff80105208:	48 98                	cltq   
ffffffff8010520a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if (pa && (rdsp = scan_rdsp(pa, 1024)))
ffffffff8010520e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80105213:	74 21                	je     ffffffff80105236 <find_rdsp+0x46>
ffffffff80105215:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105219:	be 00 04 00 00       	mov    $0x400,%esi
ffffffff8010521e:	89 c7                	mov    %eax,%edi
ffffffff80105220:	e8 3d ff ff ff       	callq  ffffffff80105162 <scan_rdsp>
ffffffff80105225:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80105229:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff8010522e:	74 06                	je     ffffffff80105236 <find_rdsp+0x46>
    return rdsp;
ffffffff80105230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105234:	eb 0f                	jmp    ffffffff80105245 <find_rdsp+0x55>
  return scan_rdsp(0xE0000, 0x20000);
ffffffff80105236:	be 00 00 02 00       	mov    $0x20000,%esi
ffffffff8010523b:	bf 00 00 0e 00       	mov    $0xe0000,%edi
ffffffff80105240:	e8 1d ff ff ff       	callq  ffffffff80105162 <scan_rdsp>
} 
ffffffff80105245:	c9                   	leaveq 
ffffffff80105246:	c3                   	retq   

ffffffff80105247 <acpi_config_smp>:

static int acpi_config_smp(struct acpi_madt *madt) {
ffffffff80105247:	55                   	push   %rbp
ffffffff80105248:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010524b:	48 83 ec 50          	sub    $0x50,%rsp
ffffffff8010524f:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  uint32 lapic_addr;
  uint nioapic = 0;
ffffffff80105253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  uchar *p, *e;

  if (!madt)
ffffffff8010525a:	48 83 7d b8 00       	cmpq   $0x0,-0x48(%rbp)
ffffffff8010525f:	75 0a                	jne    ffffffff8010526b <acpi_config_smp+0x24>
    return -1;
ffffffff80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105266:	e9 17 02 00 00       	jmpq   ffffffff80105482 <acpi_config_smp+0x23b>
  if (madt->header.length < sizeof(struct acpi_madt))
ffffffff8010526b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff8010526f:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80105272:	83 f8 2b             	cmp    $0x2b,%eax
ffffffff80105275:	77 0a                	ja     ffffffff80105281 <acpi_config_smp+0x3a>
    return -1;
ffffffff80105277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010527c:	e9 01 02 00 00       	jmpq   ffffffff80105482 <acpi_config_smp+0x23b>

  lapic_addr = madt->lapic_addr_phys;
ffffffff80105281:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80105285:	8b 40 24             	mov    0x24(%rax),%eax
ffffffff80105288:	89 45 ec             	mov    %eax,-0x14(%rbp)

  p = madt->table;
ffffffff8010528b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff8010528f:	48 83 c0 2c          	add    $0x2c,%rax
ffffffff80105293:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  e = p + madt->header.length - sizeof(struct acpi_madt);
ffffffff80105297:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff8010529b:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff8010529e:	89 c0                	mov    %eax,%eax
ffffffff801052a0:	48 8d 50 d4          	lea    -0x2c(%rax),%rdx
ffffffff801052a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801052a8:	48 01 d0             	add    %rdx,%rax
ffffffff801052ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

  while (p < e) {
ffffffff801052af:	e9 83 01 00 00       	jmpq   ffffffff80105437 <acpi_config_smp+0x1f0>
    uint len;
    if ((e - p) < 2)
ffffffff801052b4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff801052b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801052bc:	48 29 c2             	sub    %rax,%rdx
ffffffff801052bf:	48 89 d0             	mov    %rdx,%rax
ffffffff801052c2:	48 83 f8 01          	cmp    $0x1,%rax
ffffffff801052c6:	0f 8e 7b 01 00 00    	jle    ffffffff80105447 <acpi_config_smp+0x200>
      break;
    len = p[1];
ffffffff801052cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801052d0:	48 83 c0 01          	add    $0x1,%rax
ffffffff801052d4:	0f b6 00             	movzbl (%rax),%eax
ffffffff801052d7:	0f b6 c0             	movzbl %al,%eax
ffffffff801052da:	89 45 dc             	mov    %eax,-0x24(%rbp)
    if ((e - p) < len)
ffffffff801052dd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff801052e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801052e5:	48 29 c2             	sub    %rax,%rdx
ffffffff801052e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff801052eb:	48 39 c2             	cmp    %rax,%rdx
ffffffff801052ee:	0f 8c 56 01 00 00    	jl     ffffffff8010544a <acpi_config_smp+0x203>
      break;
    switch (p[0]) {
ffffffff801052f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801052f8:	0f b6 00             	movzbl (%rax),%eax
ffffffff801052fb:	0f b6 c0             	movzbl %al,%eax
ffffffff801052fe:	85 c0                	test   %eax,%eax
ffffffff80105300:	74 0e                	je     ffffffff80105310 <acpi_config_smp+0xc9>
ffffffff80105302:	83 f8 01             	cmp    $0x1,%eax
ffffffff80105305:	0f 84 b1 00 00 00    	je     ffffffff801053bc <acpi_config_smp+0x175>
ffffffff8010530b:	e9 20 01 00 00       	jmpq   ffffffff80105430 <acpi_config_smp+0x1e9>
    case TYPE_LAPIC: {
      struct madt_lapic *lapic = (void*) p;
ffffffff80105310:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105314:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
      if (len < sizeof(*lapic))
ffffffff80105318:	83 7d dc 07          	cmpl   $0x7,-0x24(%rbp)
ffffffff8010531c:	0f 86 07 01 00 00    	jbe    ffffffff80105429 <acpi_config_smp+0x1e2>
        break;
      if (!(lapic->flags & APIC_LAPIC_ENABLED))
ffffffff80105322:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80105326:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff80105329:	83 e0 01             	and    $0x1,%eax
ffffffff8010532c:	85 c0                	test   %eax,%eax
ffffffff8010532e:	0f 84 f8 00 00 00    	je     ffffffff8010542c <acpi_config_smp+0x1e5>
        break;
      cprintf("acpi: cpu#%d apicid %d\n", ncpu, lapic->apic_id);
ffffffff80105334:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80105338:	0f b6 40 03          	movzbl 0x3(%rax),%eax
ffffffff8010533c:	0f b6 d0             	movzbl %al,%edx
ffffffff8010533f:	8b 05 1f dc 00 00    	mov    0xdc1f(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80105345:	89 c6                	mov    %eax,%esi
ffffffff80105347:	48 c7 c7 f9 a9 10 80 	mov    $0xffffffff8010a9f9,%rdi
ffffffff8010534e:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80105353:	e8 4a b2 ff ff       	callq  ffffffff801005a2 <cprintf>
      cpus[ncpu].id = ncpu;
ffffffff80105358:	8b 05 06 dc 00 00    	mov    0xdc06(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff8010535e:	8b 15 00 dc 00 00    	mov    0xdc00(%rip),%edx        # ffffffff80112f64 <ncpu>
ffffffff80105364:	89 d1                	mov    %edx,%ecx
ffffffff80105366:	48 98                	cltq   
ffffffff80105368:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8010536c:	48 89 c2             	mov    %rax,%rdx
ffffffff8010536f:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff80105373:	48 29 c2             	sub    %rax,%rdx
ffffffff80105376:	48 89 d0             	mov    %rdx,%rax
ffffffff80105379:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff8010537f:	88 08                	mov    %cl,(%rax)
      cpus[ncpu].apicid = lapic->apic_id;
ffffffff80105381:	8b 0d dd db 00 00    	mov    0xdbdd(%rip),%ecx        # ffffffff80112f64 <ncpu>
ffffffff80105387:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010538b:	0f b6 50 03          	movzbl 0x3(%rax),%edx
ffffffff8010538f:	48 63 c1             	movslq %ecx,%rax
ffffffff80105392:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff80105396:	48 89 c1             	mov    %rax,%rcx
ffffffff80105399:	48 c1 e1 04          	shl    $0x4,%rcx
ffffffff8010539d:	48 29 c1             	sub    %rax,%rcx
ffffffff801053a0:	48 89 c8             	mov    %rcx,%rax
ffffffff801053a3:	48 05 e1 27 11 80    	add    $0xffffffff801127e1,%rax
ffffffff801053a9:	88 10                	mov    %dl,(%rax)
      ncpu++;
ffffffff801053ab:	8b 05 b3 db 00 00    	mov    0xdbb3(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff801053b1:	83 c0 01             	add    $0x1,%eax
ffffffff801053b4:	89 05 aa db 00 00    	mov    %eax,0xdbaa(%rip)        # ffffffff80112f64 <ncpu>
      break;
ffffffff801053ba:	eb 74                	jmp    ffffffff80105430 <acpi_config_smp+0x1e9>
    }
    case TYPE_IOAPIC: {
      struct madt_ioapic *ioapic = (void*) p;
ffffffff801053bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801053c0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
      if (len < sizeof(*ioapic))
ffffffff801053c4:	83 7d dc 0b          	cmpl   $0xb,-0x24(%rbp)
ffffffff801053c8:	76 65                	jbe    ffffffff8010542f <acpi_config_smp+0x1e8>
        break;
      cprintf("acpi: ioapic#%d @%x id=%d base=%d\n",
ffffffff801053ca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801053ce:	8b 70 08             	mov    0x8(%rax),%esi
        nioapic, ioapic->addr, ioapic->id, ioapic->interrupt_base);
ffffffff801053d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801053d5:	0f b6 40 02          	movzbl 0x2(%rax),%eax
    }
    case TYPE_IOAPIC: {
      struct madt_ioapic *ioapic = (void*) p;
      if (len < sizeof(*ioapic))
        break;
      cprintf("acpi: ioapic#%d @%x id=%d base=%d\n",
ffffffff801053d9:	0f b6 c8             	movzbl %al,%ecx
ffffffff801053dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801053e0:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff801053e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801053e6:	41 89 f0             	mov    %esi,%r8d
ffffffff801053e9:	89 c6                	mov    %eax,%esi
ffffffff801053eb:	48 c7 c7 18 aa 10 80 	mov    $0xffffffff8010aa18,%rdi
ffffffff801053f2:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801053f7:	e8 a6 b1 ff ff       	callq  ffffffff801005a2 <cprintf>
        nioapic, ioapic->addr, ioapic->id, ioapic->interrupt_base);
      if (nioapic) {
ffffffff801053fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80105400:	74 13                	je     ffffffff80105415 <acpi_config_smp+0x1ce>
        cprintf("warning: multiple ioapics are not supported");
ffffffff80105402:	48 c7 c7 40 aa 10 80 	mov    $0xffffffff8010aa40,%rdi
ffffffff80105409:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010540e:	e8 8f b1 ff ff       	callq  ffffffff801005a2 <cprintf>
ffffffff80105413:	eb 0e                	jmp    ffffffff80105423 <acpi_config_smp+0x1dc>
      } else {
        ioapicid = ioapic->id;
ffffffff80105415:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80105419:	0f b6 40 02          	movzbl 0x2(%rax),%eax
ffffffff8010541d:	88 05 45 db 00 00    	mov    %al,0xdb45(%rip)        # ffffffff80112f68 <ioapicid>
      }
      nioapic++;
ffffffff80105423:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
      break;
ffffffff80105427:	eb 07                	jmp    ffffffff80105430 <acpi_config_smp+0x1e9>
      break;
    switch (p[0]) {
    case TYPE_LAPIC: {
      struct madt_lapic *lapic = (void*) p;
      if (len < sizeof(*lapic))
        break;
ffffffff80105429:	90                   	nop
ffffffff8010542a:	eb 04                	jmp    ffffffff80105430 <acpi_config_smp+0x1e9>
      if (!(lapic->flags & APIC_LAPIC_ENABLED))
        break;
ffffffff8010542c:	90                   	nop
ffffffff8010542d:	eb 01                	jmp    ffffffff80105430 <acpi_config_smp+0x1e9>
      break;
    }
    case TYPE_IOAPIC: {
      struct madt_ioapic *ioapic = (void*) p;
      if (len < sizeof(*ioapic))
        break;
ffffffff8010542f:	90                   	nop
      }
      nioapic++;
      break;
    }
    }
    p += len;
ffffffff80105430:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80105433:	48 01 45 f0          	add    %rax,-0x10(%rbp)
  lapic_addr = madt->lapic_addr_phys;

  p = madt->table;
  e = p + madt->header.length - sizeof(struct acpi_madt);

  while (p < e) {
ffffffff80105437:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010543b:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
ffffffff8010543f:	0f 82 6f fe ff ff    	jb     ffffffff801052b4 <acpi_config_smp+0x6d>
ffffffff80105445:	eb 04                	jmp    ffffffff8010544b <acpi_config_smp+0x204>
    uint len;
    if ((e - p) < 2)
      break;
ffffffff80105447:	90                   	nop
ffffffff80105448:	eb 01                	jmp    ffffffff8010544b <acpi_config_smp+0x204>
    len = p[1];
    if ((e - p) < len)
      break;
ffffffff8010544a:	90                   	nop
    }
    }
    p += len;
  }

  if (ncpu) {
ffffffff8010544b:	8b 05 13 db 00 00    	mov    0xdb13(%rip),%eax        # ffffffff80112f64 <ncpu>
ffffffff80105451:	85 c0                	test   %eax,%eax
ffffffff80105453:	74 28                	je     ffffffff8010547d <acpi_config_smp+0x236>
    ismp = 1;
ffffffff80105455:	c7 05 01 db 00 00 01 	movl   $0x1,0xdb01(%rip)        # ffffffff80112f60 <ismp>
ffffffff8010545c:	00 00 00 
    lapic = IO2V(((uintp)lapic_addr));
ffffffff8010545f:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80105462:	48 b8 00 00 00 42 fe 	movabs $0xfffffffe42000000,%rax
ffffffff80105469:	ff ff ff 
ffffffff8010546c:	48 01 d0             	add    %rdx,%rax
ffffffff8010546f:	48 89 05 4a d2 00 00 	mov    %rax,0xd24a(%rip)        # ffffffff801126c0 <lapic>
    return 0;
ffffffff80105476:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010547b:	eb 05                	jmp    ffffffff80105482 <acpi_config_smp+0x23b>
  }

  return -1;
ffffffff8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff80105482:	c9                   	leaveq 
ffffffff80105483:	c3                   	retq   

ffffffff80105484 <acpiinit>:
#define PHYSLIMIT 0x80000000
#else
#define PHYSLIMIT 0x0E000000
#endif

int acpiinit(void) {
ffffffff80105484:	55                   	push   %rbp
ffffffff80105485:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105488:	48 83 ec 70          	sub    $0x70,%rsp
  unsigned n, count;
  struct acpi_rdsp *rdsp;
  struct acpi_rsdt *rsdt;
  struct acpi_madt *madt = 0;
ffffffff8010548c:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
ffffffff80105493:	00 

  rdsp = find_rdsp();
ffffffff80105494:	e8 57 fd ff ff       	callq  ffffffff801051f0 <find_rdsp>
ffffffff80105499:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  if (rdsp->rsdt_addr_phys > PHYSLIMIT)
ffffffff8010549d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801054a1:	8b 40 10             	mov    0x10(%rax),%eax
ffffffff801054a4:	3d 00 00 00 80       	cmp    $0x80000000,%eax
ffffffff801054a9:	0f 87 6b 01 00 00    	ja     ffffffff8010561a <acpiinit+0x196>
    goto notmapped;
  rsdt = p2v(rdsp->rsdt_addr_phys);
ffffffff801054af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801054b3:	8b 40 10             	mov    0x10(%rax),%eax
ffffffff801054b6:	89 c0                	mov    %eax,%eax
ffffffff801054b8:	48 89 c7             	mov    %rax,%rdi
ffffffff801054bb:	e8 8a fc ff ff       	callq  ffffffff8010514a <p2v>
ffffffff801054c0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  count = (rsdt->header.length - sizeof(*rsdt)) / 4;
ffffffff801054c4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801054c8:	8b 40 04             	mov    0x4(%rax),%eax
ffffffff801054cb:	89 c0                	mov    %eax,%eax
ffffffff801054cd:	48 83 e8 24          	sub    $0x24,%rax
ffffffff801054d1:	48 c1 e8 02          	shr    $0x2,%rax
ffffffff801054d5:	89 45 dc             	mov    %eax,-0x24(%rbp)
  for (n = 0; n < count; n++) {
ffffffff801054d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801054df:	e9 1c 01 00 00       	jmpq   ffffffff80105600 <acpiinit+0x17c>
    struct acpi_desc_header *hdr = p2v(rsdt->entry[n]);
ffffffff801054e4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801054e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801054eb:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801054ef:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff801054f3:	89 c0                	mov    %eax,%eax
ffffffff801054f5:	48 89 c7             	mov    %rax,%rdi
ffffffff801054f8:	e8 4d fc ff ff       	callq  ffffffff8010514a <p2v>
ffffffff801054fd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    if (rsdt->entry[n] > PHYSLIMIT)
ffffffff80105501:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105505:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80105508:	48 83 c2 08          	add    $0x8,%rdx
ffffffff8010550c:	8b 44 90 04          	mov    0x4(%rax,%rdx,4),%eax
ffffffff80105510:	3d 00 00 00 80       	cmp    $0x80000000,%eax
ffffffff80105515:	0f 87 02 01 00 00    	ja     ffffffff8010561d <acpiinit+0x199>
      goto notmapped;
//#if DEBUG
#if 1
    uchar sig[5], id[7], tableid[9], creator[5];
    memmove(sig, hdr->signature, 4); sig[4] = 0;
ffffffff8010551b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
ffffffff8010551f:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffffffff80105523:	ba 04 00 00 00       	mov    $0x4,%edx
ffffffff80105528:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010552b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010552e:	e8 ce 18 00 00       	callq  ffffffff80106e01 <memmove>
ffffffff80105533:	c6 45 c4 00          	movb   $0x0,-0x3c(%rbp)
    memmove(id, hdr->oem_id, 6); id[6] = 0;
ffffffff80105537:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010553b:	48 8d 48 0a          	lea    0xa(%rax),%rcx
ffffffff8010553f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
ffffffff80105543:	ba 06 00 00 00       	mov    $0x6,%edx
ffffffff80105548:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010554b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010554e:	e8 ae 18 00 00       	callq  ffffffff80106e01 <memmove>
ffffffff80105553:	c6 45 b6 00          	movb   $0x0,-0x4a(%rbp)
    memmove(tableid, hdr->oem_tableid, 8); tableid[8] = 0;
ffffffff80105557:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010555b:	48 8d 48 10          	lea    0x10(%rax),%rcx
ffffffff8010555f:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
ffffffff80105563:	ba 08 00 00 00       	mov    $0x8,%edx
ffffffff80105568:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010556b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010556e:	e8 8e 18 00 00       	callq  ffffffff80106e01 <memmove>
ffffffff80105573:	c6 45 a8 00          	movb   $0x0,-0x58(%rbp)
    memmove(creator, hdr->creator_id, 4); creator[4] = 0;
ffffffff80105577:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010557b:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
ffffffff8010557f:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffffffff80105583:	ba 04 00 00 00       	mov    $0x4,%edx
ffffffff80105588:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010558b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010558e:	e8 6e 18 00 00       	callq  ffffffff80106e01 <memmove>
ffffffff80105593:	c6 45 94 00          	movb   $0x0,-0x6c(%rbp)
    cprintf("acpi: %s %s %s %x %s %x\n",
ffffffff80105597:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010559b:	8b 70 20             	mov    0x20(%rax),%esi
ffffffff8010559e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff801055a2:	8b 78 18             	mov    0x18(%rax),%edi
ffffffff801055a5:	4c 8d 45 90          	lea    -0x70(%rbp),%r8
ffffffff801055a9:	48 8d 4d a0          	lea    -0x60(%rbp),%rcx
ffffffff801055ad:	48 8d 55 b0          	lea    -0x50(%rbp),%rdx
ffffffff801055b1:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
ffffffff801055b5:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801055b9:	56                   	push   %rsi
ffffffff801055ba:	4d 89 c1             	mov    %r8,%r9
ffffffff801055bd:	41 89 f8             	mov    %edi,%r8d
ffffffff801055c0:	48 89 c6             	mov    %rax,%rsi
ffffffff801055c3:	48 c7 c7 6c aa 10 80 	mov    $0xffffffff8010aa6c,%rdi
ffffffff801055ca:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801055cf:	e8 ce af ff ff       	callq  ffffffff801005a2 <cprintf>
ffffffff801055d4:	48 83 c4 10          	add    $0x10,%rsp
      sig, id, tableid, hdr->oem_revision,
      creator, hdr->creator_revision);
#endif
    if (!memcmp(hdr->signature, SIG_MADT, 4))
ffffffff801055d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff801055dc:	ba 04 00 00 00       	mov    $0x4,%edx
ffffffff801055e1:	48 c7 c6 85 aa 10 80 	mov    $0xffffffff8010aa85,%rsi
ffffffff801055e8:	48 89 c7             	mov    %rax,%rdi
ffffffff801055eb:	e8 a2 17 00 00       	callq  ffffffff80106d92 <memcmp>
ffffffff801055f0:	85 c0                	test   %eax,%eax
ffffffff801055f2:	75 08                	jne    ffffffff801055fc <acpiinit+0x178>
      madt = (void*) hdr;
ffffffff801055f4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff801055f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  rdsp = find_rdsp();
  if (rdsp->rsdt_addr_phys > PHYSLIMIT)
    goto notmapped;
  rsdt = p2v(rdsp->rsdt_addr_phys);
  count = (rsdt->header.length - sizeof(*rsdt)) / 4;
  for (n = 0; n < count; n++) {
ffffffff801055fc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80105600:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105603:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80105606:	0f 82 d8 fe ff ff    	jb     ffffffff801054e4 <acpiinit+0x60>
#endif
    if (!memcmp(hdr->signature, SIG_MADT, 4))
      madt = (void*) hdr;
  }

  return acpi_config_smp(madt);
ffffffff8010560c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105610:	48 89 c7             	mov    %rax,%rdi
ffffffff80105613:	e8 2f fc ff ff       	callq  ffffffff80105247 <acpi_config_smp>
ffffffff80105618:	eb 1f                	jmp    ffffffff80105639 <acpiinit+0x1b5>
  struct acpi_rsdt *rsdt;
  struct acpi_madt *madt = 0;

  rdsp = find_rdsp();
  if (rdsp->rsdt_addr_phys > PHYSLIMIT)
    goto notmapped;
ffffffff8010561a:	90                   	nop
ffffffff8010561b:	eb 01                	jmp    ffffffff8010561e <acpiinit+0x19a>
  rsdt = p2v(rdsp->rsdt_addr_phys);
  count = (rsdt->header.length - sizeof(*rsdt)) / 4;
  for (n = 0; n < count; n++) {
    struct acpi_desc_header *hdr = p2v(rsdt->entry[n]);
    if (rsdt->entry[n] > PHYSLIMIT)
      goto notmapped;
ffffffff8010561d:	90                   	nop
  }

  return acpi_config_smp(madt);

notmapped:
  cprintf("acpi: tables above 0x%x not mapped.\n", PHYSLIMIT);
ffffffff8010561e:	be 00 00 00 80       	mov    $0x80000000,%esi
ffffffff80105623:	48 c7 c7 90 aa 10 80 	mov    $0xffffffff8010aa90,%rdi
ffffffff8010562a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010562f:	e8 6e af ff ff       	callq  ffffffff801005a2 <cprintf>
  return -1;
ffffffff80105634:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff80105639:	c9                   	leaveq 
ffffffff8010563a:	c3                   	retq   

ffffffff8010563b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff8010563b:	55                   	push   %rbp
ffffffff8010563c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010563f:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80105643:	89 fa                	mov    %edi,%edx
ffffffff80105645:	89 f0                	mov    %esi,%eax
ffffffff80105647:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff8010564b:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff8010564e:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff80105652:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff80105656:	ee                   	out    %al,(%dx)
}
ffffffff80105657:	90                   	nop
ffffffff80105658:	c9                   	leaveq 
ffffffff80105659:	c3                   	retq   

ffffffff8010565a <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
ffffffff8010565a:	55                   	push   %rbp
ffffffff8010565b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010565e:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80105662:	89 f8                	mov    %edi,%eax
ffffffff80105664:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  irqmask = mask;
ffffffff80105668:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffffffff8010566c:	66 89 05 cd 5e 00 00 	mov    %ax,0x5ecd(%rip)        # ffffffff8010b540 <irqmask>
  outb(IO_PIC1+1, mask);
ffffffff80105673:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffffffff80105677:	0f b6 c0             	movzbl %al,%eax
ffffffff8010567a:	89 c6                	mov    %eax,%esi
ffffffff8010567c:	bf 21 00 00 00       	mov    $0x21,%edi
ffffffff80105681:	e8 b5 ff ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC2+1, mask >> 8);
ffffffff80105686:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffffffff8010568a:	66 c1 e8 08          	shr    $0x8,%ax
ffffffff8010568e:	0f b6 c0             	movzbl %al,%eax
ffffffff80105691:	89 c6                	mov    %eax,%esi
ffffffff80105693:	bf a1 00 00 00       	mov    $0xa1,%edi
ffffffff80105698:	e8 9e ff ff ff       	callq  ffffffff8010563b <outb>
}
ffffffff8010569d:	90                   	nop
ffffffff8010569e:	c9                   	leaveq 
ffffffff8010569f:	c3                   	retq   

ffffffff801056a0 <picenable>:

void
picenable(int irq)
{
ffffffff801056a0:	55                   	push   %rbp
ffffffff801056a1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801056a4:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801056a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  picsetmask(irqmask & ~(1<<irq));
ffffffff801056ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801056ae:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff801056b3:	89 c1                	mov    %eax,%ecx
ffffffff801056b5:	d3 e2                	shl    %cl,%edx
ffffffff801056b7:	89 d0                	mov    %edx,%eax
ffffffff801056b9:	f7 d0                	not    %eax
ffffffff801056bb:	89 c2                	mov    %eax,%edx
ffffffff801056bd:	0f b7 05 7c 5e 00 00 	movzwl 0x5e7c(%rip),%eax        # ffffffff8010b540 <irqmask>
ffffffff801056c4:	21 d0                	and    %edx,%eax
ffffffff801056c6:	0f b7 c0             	movzwl %ax,%eax
ffffffff801056c9:	89 c7                	mov    %eax,%edi
ffffffff801056cb:	e8 8a ff ff ff       	callq  ffffffff8010565a <picsetmask>
}
ffffffff801056d0:	90                   	nop
ffffffff801056d1:	c9                   	leaveq 
ffffffff801056d2:	c3                   	retq   

ffffffff801056d3 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
ffffffff801056d3:	55                   	push   %rbp
ffffffff801056d4:	48 89 e5             	mov    %rsp,%rbp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
ffffffff801056d7:	be ff 00 00 00       	mov    $0xff,%esi
ffffffff801056dc:	bf 21 00 00 00       	mov    $0x21,%edi
ffffffff801056e1:	e8 55 ff ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC2+1, 0xFF);
ffffffff801056e6:	be ff 00 00 00       	mov    $0xff,%esi
ffffffff801056eb:	bf a1 00 00 00       	mov    $0xa1,%edi
ffffffff801056f0:	e8 46 ff ff ff       	callq  ffffffff8010563b <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
ffffffff801056f5:	be 11 00 00 00       	mov    $0x11,%esi
ffffffff801056fa:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff801056ff:	e8 37 ff ff ff       	callq  ffffffff8010563b <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
ffffffff80105704:	be 20 00 00 00       	mov    $0x20,%esi
ffffffff80105709:	bf 21 00 00 00       	mov    $0x21,%edi
ffffffff8010570e:	e8 28 ff ff ff       	callq  ffffffff8010563b <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
ffffffff80105713:	be 04 00 00 00       	mov    $0x4,%esi
ffffffff80105718:	bf 21 00 00 00       	mov    $0x21,%edi
ffffffff8010571d:	e8 19 ff ff ff       	callq  ffffffff8010563b <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
ffffffff80105722:	be 03 00 00 00       	mov    $0x3,%esi
ffffffff80105727:	bf 21 00 00 00       	mov    $0x21,%edi
ffffffff8010572c:	e8 0a ff ff ff       	callq  ffffffff8010563b <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
ffffffff80105731:	be 11 00 00 00       	mov    $0x11,%esi
ffffffff80105736:	bf a0 00 00 00       	mov    $0xa0,%edi
ffffffff8010573b:	e8 fb fe ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
ffffffff80105740:	be 28 00 00 00       	mov    $0x28,%esi
ffffffff80105745:	bf a1 00 00 00       	mov    $0xa1,%edi
ffffffff8010574a:	e8 ec fe ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
ffffffff8010574f:	be 02 00 00 00       	mov    $0x2,%esi
ffffffff80105754:	bf a1 00 00 00       	mov    $0xa1,%edi
ffffffff80105759:	e8 dd fe ff ff       	callq  ffffffff8010563b <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
ffffffff8010575e:	be 03 00 00 00       	mov    $0x3,%esi
ffffffff80105763:	bf a1 00 00 00       	mov    $0xa1,%edi
ffffffff80105768:	e8 ce fe ff ff       	callq  ffffffff8010563b <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
ffffffff8010576d:	be 68 00 00 00       	mov    $0x68,%esi
ffffffff80105772:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff80105777:	e8 bf fe ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
ffffffff8010577c:	be 0a 00 00 00       	mov    $0xa,%esi
ffffffff80105781:	bf 20 00 00 00       	mov    $0x20,%edi
ffffffff80105786:	e8 b0 fe ff ff       	callq  ffffffff8010563b <outb>

  outb(IO_PIC2, 0x68);             // OCW3
ffffffff8010578b:	be 68 00 00 00       	mov    $0x68,%esi
ffffffff80105790:	bf a0 00 00 00       	mov    $0xa0,%edi
ffffffff80105795:	e8 a1 fe ff ff       	callq  ffffffff8010563b <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
ffffffff8010579a:	be 0a 00 00 00       	mov    $0xa,%esi
ffffffff8010579f:	bf a0 00 00 00       	mov    $0xa0,%edi
ffffffff801057a4:	e8 92 fe ff ff       	callq  ffffffff8010563b <outb>

  if(irqmask != 0xFFFF)
ffffffff801057a9:	0f b7 05 90 5d 00 00 	movzwl 0x5d90(%rip),%eax        # ffffffff8010b540 <irqmask>
ffffffff801057b0:	66 83 f8 ff          	cmp    $0xffff,%ax
ffffffff801057b4:	74 11                	je     ffffffff801057c7 <picinit+0xf4>
    picsetmask(irqmask);
ffffffff801057b6:	0f b7 05 83 5d 00 00 	movzwl 0x5d83(%rip),%eax        # ffffffff8010b540 <irqmask>
ffffffff801057bd:	0f b7 c0             	movzwl %ax,%eax
ffffffff801057c0:	89 c7                	mov    %eax,%edi
ffffffff801057c2:	e8 93 fe ff ff       	callq  ffffffff8010565a <picsetmask>
}
ffffffff801057c7:	90                   	nop
ffffffff801057c8:	5d                   	pop    %rbp
ffffffff801057c9:	c3                   	retq   

ffffffff801057ca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
ffffffff801057ca:	55                   	push   %rbp
ffffffff801057cb:	48 89 e5             	mov    %rsp,%rbp
ffffffff801057ce:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801057d2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff801057d6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  struct pipe *p;

  p = 0;
ffffffff801057da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffffffff801057e1:	00 
  *f0 = *f1 = 0;
ffffffff801057e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801057e6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
ffffffff801057ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801057f1:	48 8b 10             	mov    (%rax),%rdx
ffffffff801057f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801057f8:	48 89 10             	mov    %rdx,(%rax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
ffffffff801057fb:	e8 23 c6 ff ff       	callq  ffffffff80101e23 <filealloc>
ffffffff80105800:	48 89 c2             	mov    %rax,%rdx
ffffffff80105803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105807:	48 89 10             	mov    %rdx,(%rax)
ffffffff8010580a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010580e:	48 8b 00             	mov    (%rax),%rax
ffffffff80105811:	48 85 c0             	test   %rax,%rax
ffffffff80105814:	0f 84 ea 00 00 00    	je     ffffffff80105904 <pipealloc+0x13a>
ffffffff8010581a:	e8 04 c6 ff ff       	callq  ffffffff80101e23 <filealloc>
ffffffff8010581f:	48 89 c2             	mov    %rax,%rdx
ffffffff80105822:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105826:	48 89 10             	mov    %rdx,(%rax)
ffffffff80105829:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010582d:	48 8b 00             	mov    (%rax),%rax
ffffffff80105830:	48 85 c0             	test   %rax,%rax
ffffffff80105833:	0f 84 cb 00 00 00    	je     ffffffff80105904 <pipealloc+0x13a>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
ffffffff80105839:	e8 dd e4 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010583e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80105842:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80105847:	0f 84 b6 00 00 00    	je     ffffffff80105903 <pipealloc+0x139>
    goto bad;
  p->readopen = 1;
ffffffff8010584d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105851:	c7 80 70 02 00 00 01 	movl   $0x1,0x270(%rax)
ffffffff80105858:	00 00 00 
  p->writeopen = 1;
ffffffff8010585b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010585f:	c7 80 74 02 00 00 01 	movl   $0x1,0x274(%rax)
ffffffff80105866:	00 00 00 
  p->nwrite = 0;
ffffffff80105869:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010586d:	c7 80 6c 02 00 00 00 	movl   $0x0,0x26c(%rax)
ffffffff80105874:	00 00 00 
  p->nread = 0;
ffffffff80105877:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010587b:	c7 80 68 02 00 00 00 	movl   $0x0,0x268(%rax)
ffffffff80105882:	00 00 00 
  initlock(&p->lock, "pipe");
ffffffff80105885:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105889:	48 c7 c6 b5 aa 10 80 	mov    $0xffffffff8010aab5,%rsi
ffffffff80105890:	48 89 c7             	mov    %rax,%rdi
ffffffff80105893:	e8 d6 10 00 00       	callq  ffffffff8010696e <initlock>
  (*f0)->type = FD_PIPE;
ffffffff80105898:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010589c:	48 8b 00             	mov    (%rax),%rax
ffffffff8010589f:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f0)->readable = 1;
ffffffff801058a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801058a9:	48 8b 00             	mov    (%rax),%rax
ffffffff801058ac:	c6 40 08 01          	movb   $0x1,0x8(%rax)
  (*f0)->writable = 0;
ffffffff801058b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801058b4:	48 8b 00             	mov    (%rax),%rax
ffffffff801058b7:	c6 40 09 00          	movb   $0x0,0x9(%rax)
  (*f0)->pipe = p;
ffffffff801058bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801058bf:	48 8b 00             	mov    (%rax),%rax
ffffffff801058c2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801058c6:	48 89 50 10          	mov    %rdx,0x10(%rax)
  (*f1)->type = FD_PIPE;
ffffffff801058ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801058ce:	48 8b 00             	mov    (%rax),%rax
ffffffff801058d1:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  (*f1)->readable = 0;
ffffffff801058d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801058db:	48 8b 00             	mov    (%rax),%rax
ffffffff801058de:	c6 40 08 00          	movb   $0x0,0x8(%rax)
  (*f1)->writable = 1;
ffffffff801058e2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801058e6:	48 8b 00             	mov    (%rax),%rax
ffffffff801058e9:	c6 40 09 01          	movb   $0x1,0x9(%rax)
  (*f1)->pipe = p;
ffffffff801058ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801058f1:	48 8b 00             	mov    (%rax),%rax
ffffffff801058f4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801058f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
  return 0;
ffffffff801058fc:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80105901:	eb 4f                	jmp    ffffffff80105952 <pipealloc+0x188>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
ffffffff80105903:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
ffffffff80105904:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80105909:	74 0c                	je     ffffffff80105917 <pipealloc+0x14d>
    kfree((char*)p);
ffffffff8010590b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010590f:	48 89 c7             	mov    %rax,%rdi
ffffffff80105912:	e8 5a e3 ff ff       	callq  ffffffff80103c71 <kfree>
  if(*f0)
ffffffff80105917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010591b:	48 8b 00             	mov    (%rax),%rax
ffffffff8010591e:	48 85 c0             	test   %rax,%rax
ffffffff80105921:	74 0f                	je     ffffffff80105932 <pipealloc+0x168>
    fileclose(*f0);
ffffffff80105923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105927:	48 8b 00             	mov    (%rax),%rax
ffffffff8010592a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010592d:	e8 ae c5 ff ff       	callq  ffffffff80101ee0 <fileclose>
  if(*f1)
ffffffff80105932:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105936:	48 8b 00             	mov    (%rax),%rax
ffffffff80105939:	48 85 c0             	test   %rax,%rax
ffffffff8010593c:	74 0f                	je     ffffffff8010594d <pipealloc+0x183>
    fileclose(*f1);
ffffffff8010593e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105942:	48 8b 00             	mov    (%rax),%rax
ffffffff80105945:	48 89 c7             	mov    %rax,%rdi
ffffffff80105948:	e8 93 c5 ff ff       	callq  ffffffff80101ee0 <fileclose>
  return -1;
ffffffff8010594d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff80105952:	c9                   	leaveq 
ffffffff80105953:	c3                   	retq   

ffffffff80105954 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
ffffffff80105954:	55                   	push   %rbp
ffffffff80105955:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105958:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff8010595c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80105960:	89 75 f4             	mov    %esi,-0xc(%rbp)
  acquire(&p->lock);
ffffffff80105963:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105967:	48 89 c7             	mov    %rax,%rdi
ffffffff8010596a:	e8 34 10 00 00       	callq  ffffffff801069a3 <acquire>
  if(writable){
ffffffff8010596f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffffffff80105973:	74 22                	je     ffffffff80105997 <pipeclose+0x43>
    p->writeopen = 0;
ffffffff80105975:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105979:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%rax)
ffffffff80105980:	00 00 00 
    wakeup(&p->nread);
ffffffff80105983:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105987:	48 05 68 02 00 00    	add    $0x268,%rax
ffffffff8010598d:	48 89 c7             	mov    %rax,%rdi
ffffffff80105990:	e8 a4 0d 00 00       	callq  ffffffff80106739 <wakeup>
ffffffff80105995:	eb 20                	jmp    ffffffff801059b7 <pipeclose+0x63>
  } else {
    p->readopen = 0;
ffffffff80105997:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010599b:	c7 80 70 02 00 00 00 	movl   $0x0,0x270(%rax)
ffffffff801059a2:	00 00 00 
    wakeup(&p->nwrite);
ffffffff801059a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059a9:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffffffff801059af:	48 89 c7             	mov    %rax,%rdi
ffffffff801059b2:	e8 82 0d 00 00       	callq  ffffffff80106739 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
ffffffff801059b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059bb:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffffffff801059c1:	85 c0                	test   %eax,%eax
ffffffff801059c3:	75 28                	jne    ffffffff801059ed <pipeclose+0x99>
ffffffff801059c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059c9:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffffffff801059cf:	85 c0                	test   %eax,%eax
ffffffff801059d1:	75 1a                	jne    ffffffff801059ed <pipeclose+0x99>
    release(&p->lock);
ffffffff801059d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059d7:	48 89 c7             	mov    %rax,%rdi
ffffffff801059da:	e8 9b 10 00 00       	callq  ffffffff80106a7a <release>
    kfree((char*)p);
ffffffff801059df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059e3:	48 89 c7             	mov    %rax,%rdi
ffffffff801059e6:	e8 86 e2 ff ff       	callq  ffffffff80103c71 <kfree>
ffffffff801059eb:	eb 0c                	jmp    ffffffff801059f9 <pipeclose+0xa5>
  } else
    release(&p->lock);
ffffffff801059ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801059f1:	48 89 c7             	mov    %rax,%rdi
ffffffff801059f4:	e8 81 10 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff801059f9:	90                   	nop
ffffffff801059fa:	c9                   	leaveq 
ffffffff801059fb:	c3                   	retq   

ffffffff801059fc <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
ffffffff801059fc:	55                   	push   %rbp
ffffffff801059fd:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105a00:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80105a04:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80105a08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80105a0c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffffffff80105a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a13:	48 89 c7             	mov    %rax,%rdi
ffffffff80105a16:	e8 88 0f 00 00       	callq  ffffffff801069a3 <acquire>
  for(i = 0; i < n; i++){
ffffffff80105a1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80105a22:	e9 bb 00 00 00       	jmpq   ffffffff80105ae2 <pipewrite+0xe6>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
ffffffff80105a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a2b:	8b 80 70 02 00 00    	mov    0x270(%rax),%eax
ffffffff80105a31:	85 c0                	test   %eax,%eax
ffffffff80105a33:	74 12                	je     ffffffff80105a47 <pipewrite+0x4b>
ffffffff80105a35:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105a3c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105a40:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80105a43:	85 c0                	test   %eax,%eax
ffffffff80105a45:	74 16                	je     ffffffff80105a5d <pipewrite+0x61>
        release(&p->lock);
ffffffff80105a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a4b:	48 89 c7             	mov    %rax,%rdi
ffffffff80105a4e:	e8 27 10 00 00       	callq  ffffffff80106a7a <release>
        return -1;
ffffffff80105a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105a58:	e9 ae 00 00 00       	jmpq   ffffffff80105b0b <pipewrite+0x10f>
      }
      wakeup(&p->nread);
ffffffff80105a5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a61:	48 05 68 02 00 00    	add    $0x268,%rax
ffffffff80105a67:	48 89 c7             	mov    %rax,%rdi
ffffffff80105a6a:	e8 ca 0c 00 00       	callq  ffffffff80106739 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
ffffffff80105a6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a73:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80105a77:	48 81 c2 6c 02 00 00 	add    $0x26c,%rdx
ffffffff80105a7e:	48 89 c6             	mov    %rax,%rsi
ffffffff80105a81:	48 89 d7             	mov    %rdx,%rdi
ffffffff80105a84:	e8 9d 0b 00 00       	callq  ffffffff80106626 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
ffffffff80105a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a8d:	8b 90 6c 02 00 00    	mov    0x26c(%rax),%edx
ffffffff80105a93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105a97:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffffffff80105a9d:	05 00 02 00 00       	add    $0x200,%eax
ffffffff80105aa2:	39 c2                	cmp    %eax,%edx
ffffffff80105aa4:	74 81                	je     ffffffff80105a27 <pipewrite+0x2b>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
ffffffff80105aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105aaa:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffffffff80105ab0:	8d 48 01             	lea    0x1(%rax),%ecx
ffffffff80105ab3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80105ab7:	89 8a 6c 02 00 00    	mov    %ecx,0x26c(%rdx)
ffffffff80105abd:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80105ac2:	89 c1                	mov    %eax,%ecx
ffffffff80105ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105ac7:	48 63 d0             	movslq %eax,%rdx
ffffffff80105aca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105ace:	48 01 d0             	add    %rdx,%rax
ffffffff80105ad1:	0f b6 10             	movzbl (%rax),%edx
ffffffff80105ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105ad8:	89 c9                	mov    %ecx,%ecx
ffffffff80105ada:	88 54 08 68          	mov    %dl,0x68(%rax,%rcx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
ffffffff80105ade:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80105ae2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105ae5:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80105ae8:	7c 9f                	jl     ffffffff80105a89 <pipewrite+0x8d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
ffffffff80105aea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105aee:	48 05 68 02 00 00    	add    $0x268,%rax
ffffffff80105af4:	48 89 c7             	mov    %rax,%rdi
ffffffff80105af7:	e8 3d 0c 00 00       	callq  ffffffff80106739 <wakeup>
  release(&p->lock);
ffffffff80105afc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b00:	48 89 c7             	mov    %rax,%rdi
ffffffff80105b03:	e8 72 0f 00 00       	callq  ffffffff80106a7a <release>
  return n;
ffffffff80105b08:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
ffffffff80105b0b:	c9                   	leaveq 
ffffffff80105b0c:	c3                   	retq   

ffffffff80105b0d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
ffffffff80105b0d:	55                   	push   %rbp
ffffffff80105b0e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105b11:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80105b15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80105b19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80105b1d:	89 55 dc             	mov    %edx,-0x24(%rbp)
  int i;

  acquire(&p->lock);
ffffffff80105b20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b24:	48 89 c7             	mov    %rax,%rdi
ffffffff80105b27:	e8 77 0e 00 00       	callq  ffffffff801069a3 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffffffff80105b2c:	eb 42                	jmp    ffffffff80105b70 <piperead+0x63>
    if(proc->killed){
ffffffff80105b2e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105b35:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105b39:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80105b3c:	85 c0                	test   %eax,%eax
ffffffff80105b3e:	74 16                	je     ffffffff80105b56 <piperead+0x49>
      release(&p->lock);
ffffffff80105b40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b44:	48 89 c7             	mov    %rax,%rdi
ffffffff80105b47:	e8 2e 0f 00 00       	callq  ffffffff80106a7a <release>
      return -1;
ffffffff80105b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105b51:	e9 ca 00 00 00       	jmpq   ffffffff80105c20 <piperead+0x113>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
ffffffff80105b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80105b5e:	48 81 c2 68 02 00 00 	add    $0x268,%rdx
ffffffff80105b65:	48 89 c6             	mov    %rax,%rsi
ffffffff80105b68:	48 89 d7             	mov    %rdx,%rdi
ffffffff80105b6b:	e8 b6 0a 00 00       	callq  ffffffff80106626 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
ffffffff80105b70:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b74:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffffffff80105b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b7e:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffffffff80105b84:	39 c2                	cmp    %eax,%edx
ffffffff80105b86:	75 0e                	jne    ffffffff80105b96 <piperead+0x89>
ffffffff80105b88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105b8c:	8b 80 74 02 00 00    	mov    0x274(%rax),%eax
ffffffff80105b92:	85 c0                	test   %eax,%eax
ffffffff80105b94:	75 98                	jne    ffffffff80105b2e <piperead+0x21>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffffffff80105b96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80105b9d:	eb 55                	jmp    ffffffff80105bf4 <piperead+0xe7>
    if(p->nread == p->nwrite)
ffffffff80105b9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105ba3:	8b 90 68 02 00 00    	mov    0x268(%rax),%edx
ffffffff80105ba9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105bad:	8b 80 6c 02 00 00    	mov    0x26c(%rax),%eax
ffffffff80105bb3:	39 c2                	cmp    %eax,%edx
ffffffff80105bb5:	74 47                	je     ffffffff80105bfe <piperead+0xf1>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
ffffffff80105bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105bba:	48 63 d0             	movslq %eax,%rdx
ffffffff80105bbd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80105bc1:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
ffffffff80105bc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105bc9:	8b 80 68 02 00 00    	mov    0x268(%rax),%eax
ffffffff80105bcf:	8d 48 01             	lea    0x1(%rax),%ecx
ffffffff80105bd2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80105bd6:	89 8a 68 02 00 00    	mov    %ecx,0x268(%rdx)
ffffffff80105bdc:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80105be1:	89 c2                	mov    %eax,%edx
ffffffff80105be3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105be7:	89 d2                	mov    %edx,%edx
ffffffff80105be9:	0f b6 44 10 68       	movzbl 0x68(%rax,%rdx,1),%eax
ffffffff80105bee:	88 06                	mov    %al,(%rsi)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
ffffffff80105bf0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80105bf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105bf7:	3b 45 dc             	cmp    -0x24(%rbp),%eax
ffffffff80105bfa:	7c a3                	jl     ffffffff80105b9f <piperead+0x92>
ffffffff80105bfc:	eb 01                	jmp    ffffffff80105bff <piperead+0xf2>
    if(p->nread == p->nwrite)
      break;
ffffffff80105bfe:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
ffffffff80105bff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105c03:	48 05 6c 02 00 00    	add    $0x26c,%rax
ffffffff80105c09:	48 89 c7             	mov    %rax,%rdi
ffffffff80105c0c:	e8 28 0b 00 00       	callq  ffffffff80106739 <wakeup>
  release(&p->lock);
ffffffff80105c11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80105c15:	48 89 c7             	mov    %rax,%rdi
ffffffff80105c18:	e8 5d 0e 00 00       	callq  ffffffff80106a7a <release>
  return i;
ffffffff80105c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff80105c20:	c9                   	leaveq 
ffffffff80105c21:	c3                   	retq   

ffffffff80105c22 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uintp
readeflags(void)
{
ffffffff80105c22:	55                   	push   %rbp
ffffffff80105c23:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105c26:	48 83 ec 10          	sub    $0x10,%rsp
  uintp eflags;
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffffffff80105c2a:	9c                   	pushfq 
ffffffff80105c2b:	58                   	pop    %rax
ffffffff80105c2c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffffffff80105c30:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80105c34:	c9                   	leaveq 
ffffffff80105c35:	c3                   	retq   

ffffffff80105c36 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
ffffffff80105c36:	55                   	push   %rbp
ffffffff80105c37:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffffffff80105c3a:	fb                   	sti    
}
ffffffff80105c3b:	90                   	nop
ffffffff80105c3c:	5d                   	pop    %rbp
ffffffff80105c3d:	c3                   	retq   

ffffffff80105c3e <hlt>:

static inline void
hlt(void)
{
ffffffff80105c3e:	55                   	push   %rbp
ffffffff80105c3f:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("hlt");
ffffffff80105c42:	f4                   	hlt    
}
ffffffff80105c43:	90                   	nop
ffffffff80105c44:	5d                   	pop    %rbp
ffffffff80105c45:	c3                   	retq   

ffffffff80105c46 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
ffffffff80105c46:	55                   	push   %rbp
ffffffff80105c47:	48 89 e5             	mov    %rsp,%rbp
  initlock(&ptable.lock, "ptable");
ffffffff80105c4a:	48 c7 c6 ba aa 10 80 	mov    $0xffffffff8010aaba,%rsi
ffffffff80105c51:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80105c58:	e8 11 0d 00 00       	callq  ffffffff8010696e <initlock>
}
ffffffff80105c5d:	90                   	nop
ffffffff80105c5e:	5d                   	pop    %rbp
ffffffff80105c5f:	c3                   	retq   

ffffffff80105c60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
ffffffff80105c60:	55                   	push   %rbp
ffffffff80105c61:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105c64:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
ffffffff80105c68:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80105c6f:	e8 2f 0d 00 00       	callq  ffffffff801069a3 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffffffff80105c74:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff80105c7b:	80 
ffffffff80105c7c:	eb 13                	jmp    ffffffff80105c91 <allocproc+0x31>
    if(p->state == UNUSED)
ffffffff80105c7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105c82:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80105c85:	85 c0                	test   %eax,%eax
ffffffff80105c87:	74 28                	je     ffffffff80105cb1 <allocproc+0x51>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffffffff80105c89:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff80105c90:	00 
ffffffff80105c91:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff80105c98:	80 
ffffffff80105c99:	72 e3                	jb     ffffffff80105c7e <allocproc+0x1e>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
ffffffff80105c9b:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80105ca2:	e8 d3 0d 00 00       	callq  ffffffff80106a7a <release>
  return 0;
ffffffff80105ca7:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80105cac:	e9 d8 00 00 00       	jmpq   ffffffff80105d89 <allocproc+0x129>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
ffffffff80105cb1:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
ffffffff80105cb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105cb6:	c7 40 18 01 00 00 00 	movl   $0x1,0x18(%rax)
  p->pid = nextpid++;
ffffffff80105cbd:	8b 05 9d 58 00 00    	mov    0x589d(%rip),%eax        # ffffffff8010b560 <nextpid>
ffffffff80105cc3:	8d 50 01             	lea    0x1(%rax),%edx
ffffffff80105cc6:	89 15 94 58 00 00    	mov    %edx,0x5894(%rip)        # ffffffff8010b560 <nextpid>
ffffffff80105ccc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80105cd0:	89 42 1c             	mov    %eax,0x1c(%rdx)
  release(&ptable.lock);
ffffffff80105cd3:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80105cda:	e8 9b 0d 00 00       	callq  ffffffff80106a7a <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
ffffffff80105cdf:	e8 37 e0 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80105ce4:	48 89 c2             	mov    %rax,%rdx
ffffffff80105ce7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105ceb:	48 89 50 10          	mov    %rdx,0x10(%rax)
ffffffff80105cef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105cf3:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff80105cf7:	48 85 c0             	test   %rax,%rax
ffffffff80105cfa:	75 12                	jne    ffffffff80105d0e <allocproc+0xae>
    p->state = UNUSED;
ffffffff80105cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d00:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return 0;
ffffffff80105d07:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80105d0c:	eb 7b                	jmp    ffffffff80105d89 <allocproc+0x129>
  }
  sp = p->kstack + KSTACKSIZE;
ffffffff80105d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d12:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff80105d16:	48 05 00 10 00 00    	add    $0x1000,%rax
ffffffff80105d1c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
ffffffff80105d20:	48 81 6d f0 b0 00 00 	subq   $0xb0,-0x10(%rbp)
ffffffff80105d27:	00 
  p->tf = (struct trapframe*)sp;
ffffffff80105d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80105d30:	48 89 50 28          	mov    %rdx,0x28(%rax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= sizeof(uintp);
ffffffff80105d34:	48 83 6d f0 08       	subq   $0x8,-0x10(%rbp)
  *(uintp*)sp = (uintp)trapret;
ffffffff80105d39:	48 c7 c2 3b 85 10 80 	mov    $0xffffffff8010853b,%rdx
ffffffff80105d40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105d44:	48 89 10             	mov    %rdx,(%rax)

  sp -= sizeof *p->context;
ffffffff80105d47:	48 83 6d f0 40       	subq   $0x40,-0x10(%rbp)
  p->context = (struct context*)sp;
ffffffff80105d4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80105d54:	48 89 50 30          	mov    %rdx,0x30(%rax)
  memset(p->context, 0, sizeof *p->context);
ffffffff80105d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d5c:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff80105d60:	ba 40 00 00 00       	mov    $0x40,%edx
ffffffff80105d65:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80105d6a:	48 89 c7             	mov    %rax,%rdi
ffffffff80105d6d:	e8 a0 0f 00 00       	callq  ffffffff80106d12 <memset>
  p->context->eip = (uintp)forkret;
ffffffff80105d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105d76:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff80105d7a:	48 c7 c2 fa 65 10 80 	mov    $0xffffffff801065fa,%rdx
ffffffff80105d81:	48 89 50 38          	mov    %rdx,0x38(%rax)

  return p;
ffffffff80105d85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80105d89:	c9                   	leaveq 
ffffffff80105d8a:	c3                   	retq   

ffffffff80105d8b <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
ffffffff80105d8b:	55                   	push   %rbp
ffffffff80105d8c:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105d8f:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  extern char _binary_out_initcode_start[], _binary_out_initcode_size[];
  
  p = allocproc();
ffffffff80105d93:	e8 c8 fe ff ff       	callq  ffffffff80105c60 <allocproc>
ffffffff80105d98:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  initproc = p;
ffffffff80105d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105da0:	48 89 05 41 0a 01 00 	mov    %rax,0x10a41(%rip)        # ffffffff801167e8 <initproc>
  if((p->pgdir = setupkvm()) == 0)
ffffffff80105da7:	e8 cb 43 00 00       	callq  ffffffff8010a177 <setupkvm>
ffffffff80105dac:	48 89 c2             	mov    %rax,%rdx
ffffffff80105daf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105db3:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffffffff80105db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105dbb:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105dbf:	48 85 c0             	test   %rax,%rax
ffffffff80105dc2:	75 0c                	jne    ffffffff80105dd0 <userinit+0x45>
    panic("userinit: out of memory?");
ffffffff80105dc4:	48 c7 c7 c1 aa 10 80 	mov    $0xffffffff8010aac1,%rdi
ffffffff80105dcb:	e8 2f ab ff ff       	callq  ffffffff801008ff <panic>
  inituvm(p->pgdir, _binary_out_initcode_start, (uintp)_binary_out_initcode_size);
ffffffff80105dd0:	48 c7 c0 3c 00 00 00 	mov    $0x3c,%rax
ffffffff80105dd7:	89 c2                	mov    %eax,%edx
ffffffff80105dd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105ddd:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105de1:	48 c7 c6 78 be 10 80 	mov    $0xffffffff8010be78,%rsi
ffffffff80105de8:	48 89 c7             	mov    %rax,%rdi
ffffffff80105deb:	e8 8d 38 00 00       	callq  ffffffff8010967d <inituvm>
  p->sz = PGSIZE;
ffffffff80105df0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105df4:	48 c7 00 00 10 00 00 	movq   $0x1000,(%rax)
  memset(p->tf, 0, sizeof(*p->tf));
ffffffff80105dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105dff:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e03:	ba b0 00 00 00       	mov    $0xb0,%edx
ffffffff80105e08:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80105e0d:	48 89 c7             	mov    %rax,%rdi
ffffffff80105e10:	e8 fd 0e 00 00       	callq  ffffffff80106d12 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
ffffffff80105e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e19:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e1d:	48 c7 80 90 00 00 00 	movq   $0x23,0x90(%rax)
ffffffff80105e24:	23 00 00 00 
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
ffffffff80105e28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e2c:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e30:	48 c7 80 a8 00 00 00 	movq   $0x2b,0xa8(%rax)
ffffffff80105e37:	2b 00 00 00 
#ifndef X64
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
#endif
  p->tf->eflags = FL_IF;
ffffffff80105e3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e3f:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e43:	48 c7 80 98 00 00 00 	movq   $0x200,0x98(%rax)
ffffffff80105e4a:	00 02 00 00 
  p->tf->esp = PGSIZE;
ffffffff80105e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e52:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e56:	48 c7 80 a0 00 00 00 	movq   $0x1000,0xa0(%rax)
ffffffff80105e5d:	00 10 00 00 
  p->tf->eip = 0;  // beginning of initcode.S
ffffffff80105e61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e65:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80105e69:	48 c7 80 88 00 00 00 	movq   $0x0,0x88(%rax)
ffffffff80105e70:	00 00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
ffffffff80105e74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105e78:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffffffff80105e7e:	ba 10 00 00 00       	mov    $0x10,%edx
ffffffff80105e83:	48 c7 c6 da aa 10 80 	mov    $0xffffffff8010aada,%rsi
ffffffff80105e8a:	48 89 c7             	mov    %rax,%rdi
ffffffff80105e8d:	e8 1b 11 00 00       	callq  ffffffff80106fad <safestrcpy>
  p->cwd = namei("/");
ffffffff80105e92:	48 c7 c7 e3 aa 10 80 	mov    $0xffffffff8010aae3,%rdi
ffffffff80105e99:	e8 d2 d6 ff ff       	callq  ffffffff80103570 <namei>
ffffffff80105e9e:	48 89 c2             	mov    %rax,%rdx
ffffffff80105ea1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105ea5:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)

  p->state = RUNNABLE;
ffffffff80105eac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80105eb0:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
}
ffffffff80105eb7:	90                   	nop
ffffffff80105eb8:	c9                   	leaveq 
ffffffff80105eb9:	c3                   	retq   

ffffffff80105eba <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
ffffffff80105eba:	55                   	push   %rbp
ffffffff80105ebb:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105ebe:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80105ec2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  uint sz;
  
  sz = proc->sz;
ffffffff80105ec5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105ecc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105ed0:	48 8b 00             	mov    (%rax),%rax
ffffffff80105ed3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(n > 0){
ffffffff80105ed6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80105eda:	7e 34                	jle    ffffffff80105f10 <growproc+0x56>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
ffffffff80105edc:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80105edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105ee2:	01 c2                	add    %eax,%edx
ffffffff80105ee4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105eeb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105eef:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105ef3:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffffffff80105ef6:	89 ce                	mov    %ecx,%esi
ffffffff80105ef8:	48 89 c7             	mov    %rax,%rdi
ffffffff80105efb:	e8 06 39 00 00       	callq  ffffffff80109806 <allocuvm>
ffffffff80105f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80105f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80105f07:	75 44                	jne    ffffffff80105f4d <growproc+0x93>
      return -1;
ffffffff80105f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105f0e:	eb 66                	jmp    ffffffff80105f76 <growproc+0xbc>
  } else if(n < 0){
ffffffff80105f10:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80105f14:	79 37                	jns    ffffffff80105f4d <growproc+0x93>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
ffffffff80105f16:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80105f19:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80105f1c:	01 d0                	add    %edx,%eax
ffffffff80105f1e:	89 c2                	mov    %eax,%edx
ffffffff80105f20:	8b 4d fc             	mov    -0x4(%rbp),%ecx
ffffffff80105f23:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105f2a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105f2e:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105f32:	48 89 ce             	mov    %rcx,%rsi
ffffffff80105f35:	48 89 c7             	mov    %rax,%rdi
ffffffff80105f38:	e8 9d 39 00 00       	callq  ffffffff801098da <deallocuvm>
ffffffff80105f3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80105f40:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80105f44:	75 07                	jne    ffffffff80105f4d <growproc+0x93>
      return -1;
ffffffff80105f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105f4b:	eb 29                	jmp    ffffffff80105f76 <growproc+0xbc>
  }
  proc->sz = sz;
ffffffff80105f4d:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105f54:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105f58:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80105f5b:	48 89 10             	mov    %rdx,(%rax)
  switchuvm(proc);
ffffffff80105f5e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105f65:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105f69:	48 89 c7             	mov    %rax,%rdi
ffffffff80105f6c:	e8 d9 44 00 00       	callq  ffffffff8010a44a <switchuvm>
  return 0;
ffffffff80105f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80105f76:	c9                   	leaveq 
ffffffff80105f77:	c3                   	retq   

ffffffff80105f78 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
ffffffff80105f78:	55                   	push   %rbp
ffffffff80105f79:	48 89 e5             	mov    %rsp,%rbp
ffffffff80105f7c:	48 83 ec 20          	sub    $0x20,%rsp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
ffffffff80105f80:	e8 db fc ff ff       	callq  ffffffff80105c60 <allocproc>
ffffffff80105f85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80105f89:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80105f8e:	75 0a                	jne    ffffffff80105f9a <fork+0x22>
    return -1;
ffffffff80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80105f95:	e9 bf 01 00 00       	jmpq   ffffffff80106159 <fork+0x1e1>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
ffffffff80105f9a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105fa1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105fa5:	48 8b 00             	mov    (%rax),%rax
ffffffff80105fa8:	89 c2                	mov    %eax,%edx
ffffffff80105faa:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80105fb1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80105fb5:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105fb9:	89 d6                	mov    %edx,%esi
ffffffff80105fbb:	48 89 c7             	mov    %rax,%rdi
ffffffff80105fbe:	e8 fb 3a 00 00       	callq  ffffffff80109abe <copyuvm>
ffffffff80105fc3:	48 89 c2             	mov    %rax,%rdx
ffffffff80105fc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105fca:	48 89 50 08          	mov    %rdx,0x8(%rax)
ffffffff80105fce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105fd2:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80105fd6:	48 85 c0             	test   %rax,%rax
ffffffff80105fd9:	75 31                	jne    ffffffff8010600c <fork+0x94>
    kfree(np->kstack);
ffffffff80105fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105fdf:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff80105fe3:	48 89 c7             	mov    %rax,%rdi
ffffffff80105fe6:	e8 86 dc ff ff       	callq  ffffffff80103c71 <kfree>
    np->kstack = 0;
ffffffff80105feb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105fef:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffffffff80105ff6:	00 
    np->state = UNUSED;
ffffffff80105ff7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80105ffb:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
    return -1;
ffffffff80106002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80106007:	e9 4d 01 00 00       	jmpq   ffffffff80106159 <fork+0x1e1>
  }
  np->sz = proc->sz;
ffffffff8010600c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106013:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106017:	48 8b 10             	mov    (%rax),%rdx
ffffffff8010601a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010601e:	48 89 10             	mov    %rdx,(%rax)
  np->parent = proc;
ffffffff80106021:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106028:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffffffff8010602c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106030:	48 89 50 20          	mov    %rdx,0x20(%rax)
  *np->tf = *proc->tf;
ffffffff80106034:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106038:	48 8b 50 28          	mov    0x28(%rax),%rdx
ffffffff8010603c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106043:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106047:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff8010604b:	48 89 c6             	mov    %rax,%rsi
ffffffff8010604e:	b8 16 00 00 00       	mov    $0x16,%eax
ffffffff80106053:	48 89 d7             	mov    %rdx,%rdi
ffffffff80106056:	48 89 c1             	mov    %rax,%rcx
ffffffff80106059:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
ffffffff8010605c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106060:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80106064:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  for(i = 0; i < NOFILE; i++)
ffffffff8010606b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80106072:	eb 5b                	jmp    ffffffff801060cf <fork+0x157>
    if(proc->ofile[i])
ffffffff80106074:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010607b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010607f:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80106082:	48 63 d2             	movslq %edx,%rdx
ffffffff80106085:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80106089:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff8010608e:	48 85 c0             	test   %rax,%rax
ffffffff80106091:	74 38                	je     ffffffff801060cb <fork+0x153>
      np->ofile[i] = filedup(proc->ofile[i]);
ffffffff80106093:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010609a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010609e:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801060a1:	48 63 d2             	movslq %edx,%rdx
ffffffff801060a4:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801060a8:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff801060ad:	48 89 c7             	mov    %rax,%rdi
ffffffff801060b0:	e8 d9 bd ff ff       	callq  ffffffff80101e8e <filedup>
ffffffff801060b5:	48 89 c1             	mov    %rax,%rcx
ffffffff801060b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801060bc:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801060bf:	48 63 d2             	movslq %edx,%rdx
ffffffff801060c2:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801060c6:	48 89 4c d0 08       	mov    %rcx,0x8(%rax,%rdx,8)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
ffffffff801060cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff801060cf:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffffffff801060d3:	7e 9f                	jle    ffffffff80106074 <fork+0xfc>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
ffffffff801060d5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801060dc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801060e0:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffffffff801060e7:	48 89 c7             	mov    %rax,%rdi
ffffffff801060ea:	e8 1a c7 ff ff       	callq  ffffffff80102809 <idup>
ffffffff801060ef:	48 89 c2             	mov    %rax,%rdx
ffffffff801060f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801060f6:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
ffffffff801060fd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106104:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106108:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffffffff8010610f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106113:	48 05 d0 00 00 00    	add    $0xd0,%rax
ffffffff80106119:	ba 10 00 00 00       	mov    $0x10,%edx
ffffffff8010611e:	48 89 ce             	mov    %rcx,%rsi
ffffffff80106121:	48 89 c7             	mov    %rax,%rdi
ffffffff80106124:	e8 84 0e 00 00       	callq  ffffffff80106fad <safestrcpy>
 
  pid = np->pid;
ffffffff80106129:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010612d:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff80106130:	89 45 ec             	mov    %eax,-0x14(%rbp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
ffffffff80106133:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff8010613a:	e8 64 08 00 00       	callq  ffffffff801069a3 <acquire>
  np->state = RUNNABLE;
ffffffff8010613f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106143:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  release(&ptable.lock);
ffffffff8010614a:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106151:	e8 24 09 00 00       	callq  ffffffff80106a7a <release>
  
  return pid;
ffffffff80106156:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffffffff80106159:	c9                   	leaveq 
ffffffff8010615a:	c3                   	retq   

ffffffff8010615b <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
ffffffff8010615b:	55                   	push   %rbp
ffffffff8010615c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010615f:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int fd;

  if(proc == initproc)
ffffffff80106163:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010616a:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffffffff8010616e:	48 8b 05 73 06 01 00 	mov    0x10673(%rip),%rax        # ffffffff801167e8 <initproc>
ffffffff80106175:	48 39 c2             	cmp    %rax,%rdx
ffffffff80106178:	75 0c                	jne    ffffffff80106186 <exit+0x2b>
    panic("init exiting");
ffffffff8010617a:	48 c7 c7 e5 aa 10 80 	mov    $0xffffffff8010aae5,%rdi
ffffffff80106181:	e8 79 a7 ff ff       	callq  ffffffff801008ff <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffffffff80106186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
ffffffff8010618d:	eb 63                	jmp    ffffffff801061f2 <exit+0x97>
    if(proc->ofile[fd]){
ffffffff8010618f:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106196:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010619a:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff8010619d:	48 63 d2             	movslq %edx,%rdx
ffffffff801061a0:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801061a4:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff801061a9:	48 85 c0             	test   %rax,%rax
ffffffff801061ac:	74 40                	je     ffffffff801061ee <exit+0x93>
      fileclose(proc->ofile[fd]);
ffffffff801061ae:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801061b5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801061b9:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff801061bc:	48 63 d2             	movslq %edx,%rdx
ffffffff801061bf:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801061c3:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff801061c8:	48 89 c7             	mov    %rax,%rdi
ffffffff801061cb:	e8 10 bd ff ff       	callq  ffffffff80101ee0 <fileclose>
      proc->ofile[fd] = 0;
ffffffff801061d0:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801061d7:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801061db:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff801061de:	48 63 d2             	movslq %edx,%rdx
ffffffff801061e1:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801061e5:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffffffff801061ec:	00 00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
ffffffff801061ee:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
ffffffff801061f2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
ffffffff801061f6:	7e 97                	jle    ffffffff8010618f <exit+0x34>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
ffffffff801061f8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801061fd:	e8 bf e4 ff ff       	callq  ffffffff801046c1 <begin_op>
  iput(proc->cwd);
ffffffff80106202:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106209:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010620d:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffffffff80106214:	48 89 c7             	mov    %rax,%rdi
ffffffff80106217:	e8 39 c8 ff ff       	callq  ffffffff80102a55 <iput>
  end_op();
ffffffff8010621c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106221:	e8 1d e5 ff ff       	callq  ffffffff80104743 <end_op>
  proc->cwd = 0;
ffffffff80106226:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010622d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106231:	48 c7 80 c8 00 00 00 	movq   $0x0,0xc8(%rax)
ffffffff80106238:	00 00 00 00 

  acquire(&ptable.lock);
ffffffff8010623c:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106243:	e8 5b 07 00 00       	callq  ffffffff801069a3 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
ffffffff80106248:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010624f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106253:	48 8b 40 20          	mov    0x20(%rax),%rax
ffffffff80106257:	48 89 c7             	mov    %rax,%rdi
ffffffff8010625a:	e8 8a 04 00 00       	callq  ffffffff801066e9 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff8010625f:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff80106266:	80 
ffffffff80106267:	eb 4a                	jmp    ffffffff801062b3 <exit+0x158>
    if(p->parent == proc){
ffffffff80106269:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010626d:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffffffff80106271:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106278:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010627c:	48 39 c2             	cmp    %rax,%rdx
ffffffff8010627f:	75 2a                	jne    ffffffff801062ab <exit+0x150>
      p->parent = initproc;
ffffffff80106281:	48 8b 15 60 05 01 00 	mov    0x10560(%rip),%rdx        # ffffffff801167e8 <initproc>
ffffffff80106288:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010628c:	48 89 50 20          	mov    %rdx,0x20(%rax)
      if(p->state == ZOMBIE)
ffffffff80106290:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106294:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106297:	83 f8 05             	cmp    $0x5,%eax
ffffffff8010629a:	75 0f                	jne    ffffffff801062ab <exit+0x150>
        wakeup1(initproc);
ffffffff8010629c:	48 8b 05 45 05 01 00 	mov    0x10545(%rip),%rax        # ffffffff801167e8 <initproc>
ffffffff801062a3:	48 89 c7             	mov    %rax,%rdi
ffffffff801062a6:	e8 3e 04 00 00       	callq  ffffffff801066e9 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801062ab:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff801062b2:	00 
ffffffff801062b3:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff801062ba:	80 
ffffffff801062bb:	72 ac                	jb     ffffffff80106269 <exit+0x10e>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
ffffffff801062bd:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801062c4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801062c8:	c7 40 18 05 00 00 00 	movl   $0x5,0x18(%rax)
  sched();
ffffffff801062cf:	e8 1c 02 00 00       	callq  ffffffff801064f0 <sched>
  panic("zombie exit");
ffffffff801062d4:	48 c7 c7 f2 aa 10 80 	mov    $0xffffffff8010aaf2,%rdi
ffffffff801062db:	e8 1f a6 ff ff       	callq  ffffffff801008ff <panic>

ffffffff801062e0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
ffffffff801062e0:	55                   	push   %rbp
ffffffff801062e1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801062e4:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
ffffffff801062e8:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801062ef:	e8 af 06 00 00       	callq  ffffffff801069a3 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
ffffffff801062f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801062fb:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff80106302:	80 
ffffffff80106303:	e9 bb 00 00 00       	jmpq   ffffffff801063c3 <wait+0xe3>
      if(p->parent != proc)
ffffffff80106308:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010630c:	48 8b 50 20          	mov    0x20(%rax),%rdx
ffffffff80106310:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106317:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010631b:	48 39 c2             	cmp    %rax,%rdx
ffffffff8010631e:	0f 85 96 00 00 00    	jne    ffffffff801063ba <wait+0xda>
        continue;
      havekids = 1;
ffffffff80106324:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
      if(p->state == ZOMBIE){
ffffffff8010632b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010632f:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106332:	83 f8 05             	cmp    $0x5,%eax
ffffffff80106335:	0f 85 80 00 00 00    	jne    ffffffff801063bb <wait+0xdb>
        // Found one.
        pid = p->pid;
ffffffff8010633b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010633f:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff80106342:	89 45 f0             	mov    %eax,-0x10(%rbp)
        kfree(p->kstack);
ffffffff80106345:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106349:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8010634d:	48 89 c7             	mov    %rax,%rdi
ffffffff80106350:	e8 1c d9 ff ff       	callq  ffffffff80103c71 <kfree>
        p->kstack = 0;
ffffffff80106355:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106359:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffffffff80106360:	00 
        freevm(p->pgdir);
ffffffff80106361:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106365:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80106369:	48 89 c7             	mov    %rax,%rdi
ffffffff8010636c:	e8 4c 36 00 00       	callq  ffffffff801099bd <freevm>
        p->state = UNUSED;
ffffffff80106371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106375:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%rax)
        p->pid = 0;
ffffffff8010637c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106380:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
        p->parent = 0;
ffffffff80106387:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010638b:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
ffffffff80106392:	00 
        p->name[0] = 0;
ffffffff80106393:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106397:	c6 80 d0 00 00 00 00 	movb   $0x0,0xd0(%rax)
        p->killed = 0;
ffffffff8010639e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801063a2:	c7 40 40 00 00 00 00 	movl   $0x0,0x40(%rax)
        release(&ptable.lock);
ffffffff801063a9:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801063b0:	e8 c5 06 00 00       	callq  ffffffff80106a7a <release>
        return pid;
ffffffff801063b5:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff801063b8:	eb 61                	jmp    ffffffff8010641b <wait+0x13b>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
ffffffff801063ba:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801063bb:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff801063c2:	00 
ffffffff801063c3:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff801063ca:	80 
ffffffff801063cb:	0f 82 37 ff ff ff    	jb     ffffffff80106308 <wait+0x28>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
ffffffff801063d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
ffffffff801063d5:	74 12                	je     ffffffff801063e9 <wait+0x109>
ffffffff801063d7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801063de:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801063e2:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff801063e5:	85 c0                	test   %eax,%eax
ffffffff801063e7:	74 13                	je     ffffffff801063fc <wait+0x11c>
      release(&ptable.lock);
ffffffff801063e9:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801063f0:	e8 85 06 00 00       	callq  ffffffff80106a7a <release>
      return -1;
ffffffff801063f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801063fa:	eb 1f                	jmp    ffffffff8010641b <wait+0x13b>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
ffffffff801063fc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106403:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106407:	48 c7 c6 80 2f 11 80 	mov    $0xffffffff80112f80,%rsi
ffffffff8010640e:	48 89 c7             	mov    %rax,%rdi
ffffffff80106411:	e8 10 02 00 00       	callq  ffffffff80106626 <sleep>
  }
ffffffff80106416:	e9 d9 fe ff ff       	jmpq   ffffffff801062f4 <wait+0x14>
}
ffffffff8010641b:	c9                   	leaveq 
ffffffff8010641c:	c3                   	retq   

ffffffff8010641d <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
ffffffff8010641d:	55                   	push   %rbp
ffffffff8010641e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106421:	48 83 ec 10          	sub    $0x10,%rsp
  struct proc *p = 0;
ffffffff80106425:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
ffffffff8010642c:	00 

  for(;;){
    // Enable interrupts on this processor.
    sti();
ffffffff8010642d:	e8 04 f8 ff ff       	callq  ffffffff80105c36 <sti>

    // no runnable processes? (did we hit the end of the table last time?)
    // if so, wait for irq before trying again.
    if (p == &ptable.proc[NPROC])
ffffffff80106432:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff80106439:	80 
ffffffff8010643a:	75 05                	jne    ffffffff80106441 <scheduler+0x24>
      hlt();
ffffffff8010643c:	e8 fd f7 ff ff       	callq  ffffffff80105c3e <hlt>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
ffffffff80106441:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106448:	e8 56 05 00 00       	callq  ffffffff801069a3 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff8010644d:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff80106454:	80 
ffffffff80106455:	eb 7a                	jmp    ffffffff801064d1 <scheduler+0xb4>
      if(p->state != RUNNABLE)
ffffffff80106457:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010645b:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff8010645e:	83 f8 03             	cmp    $0x3,%eax
ffffffff80106461:	75 65                	jne    ffffffff801064c8 <scheduler+0xab>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
ffffffff80106463:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010646a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff8010646e:	64 48 89 10          	mov    %rdx,%fs:(%rax)
      switchuvm(p);
ffffffff80106472:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106476:	48 89 c7             	mov    %rax,%rdi
ffffffff80106479:	e8 cc 3f 00 00       	callq  ffffffff8010a44a <switchuvm>
      p->state = RUNNING;
ffffffff8010647e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106482:	c7 40 18 04 00 00 00 	movl   $0x4,0x18(%rax)
      swtch(&cpu->scheduler, proc->context);
ffffffff80106489:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80106490:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106494:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff80106498:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffffffff8010649f:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffffffff801064a3:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801064a7:	48 89 c6             	mov    %rax,%rsi
ffffffff801064aa:	48 89 d7             	mov    %rdx,%rdi
ffffffff801064ad:	e8 8f 0b 00 00       	callq  ffffffff80107041 <swtch>
      switchkvm();
ffffffff801064b2:	e8 75 3f 00 00       	callq  ffffffff8010a42c <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
ffffffff801064b7:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801064be:	64 48 c7 00 00 00 00 	movq   $0x0,%fs:(%rax)
ffffffff801064c5:	00 
ffffffff801064c6:	eb 01                	jmp    ffffffff801064c9 <scheduler+0xac>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
ffffffff801064c8:	90                   	nop
    if (p == &ptable.proc[NPROC])
      hlt();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801064c9:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff801064d0:	00 
ffffffff801064d1:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff801064d8:	80 
ffffffff801064d9:	0f 82 78 ff ff ff    	jb     ffffffff80106457 <scheduler+0x3a>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
ffffffff801064df:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801064e6:	e8 8f 05 00 00       	callq  ffffffff80106a7a <release>

  }
ffffffff801064eb:	e9 3d ff ff ff       	jmpq   ffffffff8010642d <scheduler+0x10>

ffffffff801064f0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
ffffffff801064f0:	55                   	push   %rbp
ffffffff801064f1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801064f4:	48 83 ec 10          	sub    $0x10,%rsp
  int intena;

  if(!holding(&ptable.lock))
ffffffff801064f8:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801064ff:	e8 95 06 00 00       	callq  ffffffff80106b99 <holding>
ffffffff80106504:	85 c0                	test   %eax,%eax
ffffffff80106506:	75 0c                	jne    ffffffff80106514 <sched+0x24>
    panic("sched ptable.lock");
ffffffff80106508:	48 c7 c7 fe aa 10 80 	mov    $0xffffffff8010aafe,%rdi
ffffffff8010650f:	e8 eb a3 ff ff       	callq  ffffffff801008ff <panic>
  if(cpu->ncli != 1)
ffffffff80106514:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff8010651b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010651f:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
ffffffff80106525:	83 f8 01             	cmp    $0x1,%eax
ffffffff80106528:	74 0c                	je     ffffffff80106536 <sched+0x46>
    panic("sched locks");
ffffffff8010652a:	48 c7 c7 10 ab 10 80 	mov    $0xffffffff8010ab10,%rdi
ffffffff80106531:	e8 c9 a3 ff ff       	callq  ffffffff801008ff <panic>
  if(proc->state == RUNNING)
ffffffff80106536:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010653d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106541:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106544:	83 f8 04             	cmp    $0x4,%eax
ffffffff80106547:	75 0c                	jne    ffffffff80106555 <sched+0x65>
    panic("sched running");
ffffffff80106549:	48 c7 c7 1c ab 10 80 	mov    $0xffffffff8010ab1c,%rdi
ffffffff80106550:	e8 aa a3 ff ff       	callq  ffffffff801008ff <panic>
  if(readeflags()&FL_IF)
ffffffff80106555:	e8 c8 f6 ff ff       	callq  ffffffff80105c22 <readeflags>
ffffffff8010655a:	25 00 02 00 00       	and    $0x200,%eax
ffffffff8010655f:	48 85 c0             	test   %rax,%rax
ffffffff80106562:	74 0c                	je     ffffffff80106570 <sched+0x80>
    panic("sched interruptible");
ffffffff80106564:	48 c7 c7 2a ab 10 80 	mov    $0xffffffff8010ab2a,%rdi
ffffffff8010656b:	e8 8f a3 ff ff       	callq  ffffffff801008ff <panic>
  intena = cpu->intena;
ffffffff80106570:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106577:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010657b:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffffffff80106581:	89 45 fc             	mov    %eax,-0x4(%rbp)
  swtch(&proc->context, cpu->scheduler);
ffffffff80106584:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff8010658b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010658f:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80106593:	48 c7 c2 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rdx
ffffffff8010659a:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffffffff8010659e:	48 83 c2 30          	add    $0x30,%rdx
ffffffff801065a2:	48 89 c6             	mov    %rax,%rsi
ffffffff801065a5:	48 89 d7             	mov    %rdx,%rdi
ffffffff801065a8:	e8 94 0a 00 00       	callq  ffffffff80107041 <swtch>
  cpu->intena = intena;
ffffffff801065ad:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff801065b4:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801065b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801065bb:	89 90 e0 00 00 00    	mov    %edx,0xe0(%rax)
}
ffffffff801065c1:	90                   	nop
ffffffff801065c2:	c9                   	leaveq 
ffffffff801065c3:	c3                   	retq   

ffffffff801065c4 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
ffffffff801065c4:	55                   	push   %rbp
ffffffff801065c5:	48 89 e5             	mov    %rsp,%rbp
  acquire(&ptable.lock);  //DOC: yieldlock
ffffffff801065c8:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801065cf:	e8 cf 03 00 00       	callq  ffffffff801069a3 <acquire>
  proc->state = RUNNABLE;
ffffffff801065d4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801065db:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801065df:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
  sched();
ffffffff801065e6:	e8 05 ff ff ff       	callq  ffffffff801064f0 <sched>
  release(&ptable.lock);
ffffffff801065eb:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801065f2:	e8 83 04 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff801065f7:	90                   	nop
ffffffff801065f8:	5d                   	pop    %rbp
ffffffff801065f9:	c3                   	retq   

ffffffff801065fa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
ffffffff801065fa:	55                   	push   %rbp
ffffffff801065fb:	48 89 e5             	mov    %rsp,%rbp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
ffffffff801065fe:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106605:	e8 70 04 00 00       	callq  ffffffff80106a7a <release>

  if (first) {
ffffffff8010660a:	8b 05 54 4f 00 00    	mov    0x4f54(%rip),%eax        # ffffffff8010b564 <first.1990>
ffffffff80106610:	85 c0                	test   %eax,%eax
ffffffff80106612:	74 0f                	je     ffffffff80106623 <forkret+0x29>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
ffffffff80106614:	c7 05 46 4f 00 00 00 	movl   $0x0,0x4f46(%rip)        # ffffffff8010b564 <first.1990>
ffffffff8010661b:	00 00 00 
    initlog();
ffffffff8010661e:	e8 64 de ff ff       	callq  ffffffff80104487 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
ffffffff80106623:	90                   	nop
ffffffff80106624:	5d                   	pop    %rbp
ffffffff80106625:	c3                   	retq   

ffffffff80106626 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
ffffffff80106626:	55                   	push   %rbp
ffffffff80106627:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010662a:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff8010662e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106632:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(proc == 0)
ffffffff80106636:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010663d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106641:	48 85 c0             	test   %rax,%rax
ffffffff80106644:	75 0c                	jne    ffffffff80106652 <sleep+0x2c>
    panic("sleep");
ffffffff80106646:	48 c7 c7 3e ab 10 80 	mov    $0xffffffff8010ab3e,%rdi
ffffffff8010664d:	e8 ad a2 ff ff       	callq  ffffffff801008ff <panic>

  if(lk == 0)
ffffffff80106652:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80106657:	75 0c                	jne    ffffffff80106665 <sleep+0x3f>
    panic("sleep without lk");
ffffffff80106659:	48 c7 c7 44 ab 10 80 	mov    $0xffffffff8010ab44,%rdi
ffffffff80106660:	e8 9a a2 ff ff       	callq  ffffffff801008ff <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
ffffffff80106665:	48 81 7d f0 80 2f 11 	cmpq   $0xffffffff80112f80,-0x10(%rbp)
ffffffff8010666c:	80 
ffffffff8010666d:	74 18                	je     ffffffff80106687 <sleep+0x61>
    acquire(&ptable.lock);  //DOC: sleeplock1
ffffffff8010666f:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106676:	e8 28 03 00 00       	callq  ffffffff801069a3 <acquire>
    release(lk);
ffffffff8010667b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010667f:	48 89 c7             	mov    %rax,%rdi
ffffffff80106682:	e8 f3 03 00 00       	callq  ffffffff80106a7a <release>
  }

  // Go to sleep.
  proc->chan = chan;
ffffffff80106687:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010668e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106692:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80106696:	48 89 50 38          	mov    %rdx,0x38(%rax)
  proc->state = SLEEPING;
ffffffff8010669a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801066a1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801066a5:	c7 40 18 02 00 00 00 	movl   $0x2,0x18(%rax)
  sched();
ffffffff801066ac:	e8 3f fe ff ff       	callq  ffffffff801064f0 <sched>

  // Tidy up.
  proc->chan = 0;
ffffffff801066b1:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801066b8:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801066bc:	48 c7 40 38 00 00 00 	movq   $0x0,0x38(%rax)
ffffffff801066c3:	00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
ffffffff801066c4:	48 81 7d f0 80 2f 11 	cmpq   $0xffffffff80112f80,-0x10(%rbp)
ffffffff801066cb:	80 
ffffffff801066cc:	74 18                	je     ffffffff801066e6 <sleep+0xc0>
    release(&ptable.lock);
ffffffff801066ce:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801066d5:	e8 a0 03 00 00       	callq  ffffffff80106a7a <release>
    acquire(lk);
ffffffff801066da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801066de:	48 89 c7             	mov    %rax,%rdi
ffffffff801066e1:	e8 bd 02 00 00       	callq  ffffffff801069a3 <acquire>
  }
}
ffffffff801066e6:	90                   	nop
ffffffff801066e7:	c9                   	leaveq 
ffffffff801066e8:	c3                   	retq   

ffffffff801066e9 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
ffffffff801066e9:	55                   	push   %rbp
ffffffff801066ea:	48 89 e5             	mov    %rsp,%rbp
ffffffff801066ed:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff801066f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffffffff801066f5:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff801066fc:	80 
ffffffff801066fd:	eb 2d                	jmp    ffffffff8010672c <wakeup1+0x43>
    if(p->state == SLEEPING && p->chan == chan)
ffffffff801066ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106703:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106706:	83 f8 02             	cmp    $0x2,%eax
ffffffff80106709:	75 19                	jne    ffffffff80106724 <wakeup1+0x3b>
ffffffff8010670b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010670f:	48 8b 40 38          	mov    0x38(%rax),%rax
ffffffff80106713:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80106717:	75 0b                	jne    ffffffff80106724 <wakeup1+0x3b>
      p->state = RUNNABLE;
ffffffff80106719:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010671d:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
ffffffff80106724:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff8010672b:	00 
ffffffff8010672c:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff80106733:	80 
ffffffff80106734:	72 c9                	jb     ffffffff801066ff <wakeup1+0x16>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
ffffffff80106736:	90                   	nop
ffffffff80106737:	c9                   	leaveq 
ffffffff80106738:	c3                   	retq   

ffffffff80106739 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
ffffffff80106739:	55                   	push   %rbp
ffffffff8010673a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010673d:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106741:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  acquire(&ptable.lock);
ffffffff80106745:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff8010674c:	e8 52 02 00 00       	callq  ffffffff801069a3 <acquire>
  wakeup1(chan);
ffffffff80106751:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106755:	48 89 c7             	mov    %rax,%rdi
ffffffff80106758:	e8 8c ff ff ff       	callq  ffffffff801066e9 <wakeup1>
  release(&ptable.lock);
ffffffff8010675d:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff80106764:	e8 11 03 00 00       	callq  ffffffff80106a7a <release>
}
ffffffff80106769:	90                   	nop
ffffffff8010676a:	c9                   	leaveq 
ffffffff8010676b:	c3                   	retq   

ffffffff8010676c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
ffffffff8010676c:	55                   	push   %rbp
ffffffff8010676d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106770:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80106774:	89 7d ec             	mov    %edi,-0x14(%rbp)
  struct proc *p;

  acquire(&ptable.lock);
ffffffff80106777:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff8010677e:	e8 20 02 00 00       	callq  ffffffff801069a3 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff80106783:	48 c7 45 f8 e8 2f 11 	movq   $0xffffffff80112fe8,-0x8(%rbp)
ffffffff8010678a:	80 
ffffffff8010678b:	eb 49                	jmp    ffffffff801067d6 <kill+0x6a>
    if(p->pid == pid){
ffffffff8010678d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106791:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff80106794:	3b 45 ec             	cmp    -0x14(%rbp),%eax
ffffffff80106797:	75 35                	jne    ffffffff801067ce <kill+0x62>
      p->killed = 1;
ffffffff80106799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010679d:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
ffffffff801067a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801067a8:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff801067ab:	83 f8 02             	cmp    $0x2,%eax
ffffffff801067ae:	75 0b                	jne    ffffffff801067bb <kill+0x4f>
        p->state = RUNNABLE;
ffffffff801067b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801067b4:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%rax)
      release(&ptable.lock);
ffffffff801067bb:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801067c2:	e8 b3 02 00 00       	callq  ffffffff80106a7a <release>
      return 0;
ffffffff801067c7:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801067cc:	eb 23                	jmp    ffffffff801067f1 <kill+0x85>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801067ce:	48 81 45 f8 e0 00 00 	addq   $0xe0,-0x8(%rbp)
ffffffff801067d5:	00 
ffffffff801067d6:	48 81 7d f8 e8 67 11 	cmpq   $0xffffffff801167e8,-0x8(%rbp)
ffffffff801067dd:	80 
ffffffff801067de:	72 ad                	jb     ffffffff8010678d <kill+0x21>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
ffffffff801067e0:	48 c7 c7 80 2f 11 80 	mov    $0xffffffff80112f80,%rdi
ffffffff801067e7:	e8 8e 02 00 00       	callq  ffffffff80106a7a <release>
  return -1;
ffffffff801067ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff801067f1:	c9                   	leaveq 
ffffffff801067f2:	c3                   	retq   

ffffffff801067f3 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
ffffffff801067f3:	55                   	push   %rbp
ffffffff801067f4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801067f7:	48 83 ec 70          	sub    $0x70,%rsp
  int i;
  struct proc *p;
  char *state;
  uintp pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff801067fb:	48 c7 45 f0 e8 2f 11 	movq   $0xffffffff80112fe8,-0x10(%rbp)
ffffffff80106802:	80 
ffffffff80106803:	e9 0a 01 00 00       	jmpq   ffffffff80106912 <procdump+0x11f>
    if(p->state == UNUSED)
ffffffff80106808:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010680c:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff8010680f:	85 c0                	test   %eax,%eax
ffffffff80106811:	0f 84 f2 00 00 00    	je     ffffffff80106909 <procdump+0x116>
      continue;
    if(p->state && p->state < NELEM(states) && states[p->state])
ffffffff80106817:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010681b:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff8010681e:	85 c0                	test   %eax,%eax
ffffffff80106820:	74 39                	je     ffffffff8010685b <procdump+0x68>
ffffffff80106822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106826:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106829:	83 f8 05             	cmp    $0x5,%eax
ffffffff8010682c:	77 2d                	ja     ffffffff8010685b <procdump+0x68>
ffffffff8010682e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106832:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106835:	89 c0                	mov    %eax,%eax
ffffffff80106837:	48 8b 04 c5 80 b5 10 	mov    -0x7fef4a80(,%rax,8),%rax
ffffffff8010683e:	80 
ffffffff8010683f:	48 85 c0             	test   %rax,%rax
ffffffff80106842:	74 17                	je     ffffffff8010685b <procdump+0x68>
      state = states[p->state];
ffffffff80106844:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106848:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff8010684b:	89 c0                	mov    %eax,%eax
ffffffff8010684d:	48 8b 04 c5 80 b5 10 	mov    -0x7fef4a80(,%rax,8),%rax
ffffffff80106854:	80 
ffffffff80106855:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80106859:	eb 08                	jmp    ffffffff80106863 <procdump+0x70>
    else
      state = "???";
ffffffff8010685b:	48 c7 45 e8 55 ab 10 	movq   $0xffffffff8010ab55,-0x18(%rbp)
ffffffff80106862:	80 
    cprintf("%d %s %s", p->pid, state, p->name);
ffffffff80106863:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106867:	48 8d 88 d0 00 00 00 	lea    0xd0(%rax),%rcx
ffffffff8010686e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106872:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff80106875:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80106879:	89 c6                	mov    %eax,%esi
ffffffff8010687b:	48 c7 c7 59 ab 10 80 	mov    $0xffffffff8010ab59,%rdi
ffffffff80106882:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106887:	e8 16 9d ff ff       	callq  ffffffff801005a2 <cprintf>
    if(p->state == SLEEPING){
ffffffff8010688c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106890:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80106893:	83 f8 02             	cmp    $0x2,%eax
ffffffff80106896:	75 5e                	jne    ffffffff801068f6 <procdump+0x103>
      getstackpcs((uintp*)p->context->ebp, pc);
ffffffff80106898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010689c:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff801068a0:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff801068a4:	48 89 c2             	mov    %rax,%rdx
ffffffff801068a7:	48 8d 45 90          	lea    -0x70(%rbp),%rax
ffffffff801068ab:	48 89 c6             	mov    %rax,%rsi
ffffffff801068ae:	48 89 d7             	mov    %rdx,%rdi
ffffffff801068b1:	e8 4a 02 00 00       	callq  ffffffff80106b00 <getstackpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
ffffffff801068b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801068bd:	eb 22                	jmp    ffffffff801068e1 <procdump+0xee>
        cprintf(" %p", pc[i]);
ffffffff801068bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801068c2:	48 98                	cltq   
ffffffff801068c4:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffffffff801068c9:	48 89 c6             	mov    %rax,%rsi
ffffffff801068cc:	48 c7 c7 62 ab 10 80 	mov    $0xffffffff8010ab62,%rdi
ffffffff801068d3:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801068d8:	e8 c5 9c ff ff       	callq  ffffffff801005a2 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getstackpcs((uintp*)p->context->ebp, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
ffffffff801068dd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff801068e1:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff801068e5:	7f 0f                	jg     ffffffff801068f6 <procdump+0x103>
ffffffff801068e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801068ea:	48 98                	cltq   
ffffffff801068ec:	48 8b 44 c5 90       	mov    -0x70(%rbp,%rax,8),%rax
ffffffff801068f1:	48 85 c0             	test   %rax,%rax
ffffffff801068f4:	75 c9                	jne    ffffffff801068bf <procdump+0xcc>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
ffffffff801068f6:	48 c7 c7 66 ab 10 80 	mov    $0xffffffff8010ab66,%rdi
ffffffff801068fd:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106902:	e8 9b 9c ff ff       	callq  ffffffff801005a2 <cprintf>
ffffffff80106907:	eb 01                	jmp    ffffffff8010690a <procdump+0x117>
  char *state;
  uintp pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
ffffffff80106909:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uintp pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
ffffffff8010690a:	48 81 45 f0 e0 00 00 	addq   $0xe0,-0x10(%rbp)
ffffffff80106911:	00 
ffffffff80106912:	48 81 7d f0 e8 67 11 	cmpq   $0xffffffff801167e8,-0x10(%rbp)
ffffffff80106919:	80 
ffffffff8010691a:	0f 82 e8 fe ff ff    	jb     ffffffff80106808 <procdump+0x15>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
ffffffff80106920:	90                   	nop
ffffffff80106921:	c9                   	leaveq 
ffffffff80106922:	c3                   	retq   

ffffffff80106923 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uintp
readeflags(void)
{
ffffffff80106923:	55                   	push   %rbp
ffffffff80106924:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106927:	48 83 ec 10          	sub    $0x10,%rsp
  uintp eflags;
  asm volatile("pushf; pop %0" : "=r" (eflags));
ffffffff8010692b:	9c                   	pushfq 
ffffffff8010692c:	58                   	pop    %rax
ffffffff8010692d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return eflags;
ffffffff80106931:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80106935:	c9                   	leaveq 
ffffffff80106936:	c3                   	retq   

ffffffff80106937 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
ffffffff80106937:	55                   	push   %rbp
ffffffff80106938:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("cli");
ffffffff8010693b:	fa                   	cli    
}
ffffffff8010693c:	90                   	nop
ffffffff8010693d:	5d                   	pop    %rbp
ffffffff8010693e:	c3                   	retq   

ffffffff8010693f <sti>:

static inline void
sti(void)
{
ffffffff8010693f:	55                   	push   %rbp
ffffffff80106940:	48 89 e5             	mov    %rsp,%rbp
  asm volatile("sti");
ffffffff80106943:	fb                   	sti    
}
ffffffff80106944:	90                   	nop
ffffffff80106945:	5d                   	pop    %rbp
ffffffff80106946:	c3                   	retq   

ffffffff80106947 <xchg>:
  asm volatile("hlt");
}

static inline uint
xchg(volatile uint *addr, uintp newval)
{
ffffffff80106947:	55                   	push   %rbp
ffffffff80106948:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010694b:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010694f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106953:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
               "1" ((uint)newval) :
ffffffff80106957:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
xchg(volatile uint *addr, uintp newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
ffffffff8010695b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff8010695f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffffffff80106963:	f0 87 02             	lock xchg %eax,(%rdx)
ffffffff80106966:	89 45 fc             	mov    %eax,-0x4(%rbp)
               "+m" (*addr), "=a" (result) :
               "1" ((uint)newval) :
               "cc");
  return result;
ffffffff80106969:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff8010696c:	c9                   	leaveq 
ffffffff8010696d:	c3                   	retq   

ffffffff8010696e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
ffffffff8010696e:	55                   	push   %rbp
ffffffff8010696f:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106972:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106976:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff8010697a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  lk->name = name;
ffffffff8010697e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106982:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff80106986:	48 89 50 08          	mov    %rdx,0x8(%rax)
  lk->locked = 0;
ffffffff8010698a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010698e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
  lk->cpu = 0;
ffffffff80106994:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106998:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffffffff8010699f:	00 
}
ffffffff801069a0:	90                   	nop
ffffffff801069a1:	c9                   	leaveq 
ffffffff801069a2:	c3                   	retq   

ffffffff801069a3 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
ffffffff801069a3:	55                   	push   %rbp
ffffffff801069a4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801069a7:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801069ab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  pushcli(); // disable interrupts to avoid deadlock.
ffffffff801069af:	e8 21 02 00 00       	callq  ffffffff80106bd5 <pushcli>
  if(holding(lk)) {
ffffffff801069b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801069b8:	48 89 c7             	mov    %rax,%rdi
ffffffff801069bb:	e8 d9 01 00 00       	callq  ffffffff80106b99 <holding>
ffffffff801069c0:	85 c0                	test   %eax,%eax
ffffffff801069c2:	74 73                	je     ffffffff80106a37 <acquire+0x94>
    int i;
    cprintf("lock '%s':\n", lk->name);
ffffffff801069c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801069c8:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff801069cc:	48 89 c6             	mov    %rax,%rsi
ffffffff801069cf:	48 c7 c7 92 ab 10 80 	mov    $0xffffffff8010ab92,%rdi
ffffffff801069d6:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801069db:	e8 c2 9b ff ff       	callq  ffffffff801005a2 <cprintf>
    for (i = 0; i < 10; i++)
ffffffff801069e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801069e7:	eb 2b                	jmp    ffffffff80106a14 <acquire+0x71>
      cprintf(" %p", lk->pcs[i]);
ffffffff801069e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801069ed:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801069f0:	48 63 d2             	movslq %edx,%rdx
ffffffff801069f3:	48 83 c2 02          	add    $0x2,%rdx
ffffffff801069f7:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff801069fc:	48 89 c6             	mov    %rax,%rsi
ffffffff801069ff:	48 c7 c7 9e ab 10 80 	mov    $0xffffffff8010ab9e,%rdi
ffffffff80106a06:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106a0b:	e8 92 9b ff ff       	callq  ffffffff801005a2 <cprintf>
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)) {
    int i;
    cprintf("lock '%s':\n", lk->name);
    for (i = 0; i < 10; i++)
ffffffff80106a10:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80106a14:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff80106a18:	7e cf                	jle    ffffffff801069e9 <acquire+0x46>
      cprintf(" %p", lk->pcs[i]);
    cprintf("\n");
ffffffff80106a1a:	48 c7 c7 a2 ab 10 80 	mov    $0xffffffff8010aba2,%rdi
ffffffff80106a21:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106a26:	e8 77 9b ff ff       	callq  ffffffff801005a2 <cprintf>
    panic("acquire");
ffffffff80106a2b:	48 c7 c7 a4 ab 10 80 	mov    $0xffffffff8010aba4,%rdi
ffffffff80106a32:	e8 c8 9e ff ff       	callq  ffffffff801008ff <panic>
  }

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
ffffffff80106a37:	90                   	nop
ffffffff80106a38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106a3c:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80106a41:	48 89 c7             	mov    %rax,%rdi
ffffffff80106a44:	e8 fe fe ff ff       	callq  ffffffff80106947 <xchg>
ffffffff80106a49:	85 c0                	test   %eax,%eax
ffffffff80106a4b:	75 eb                	jne    ffffffff80106a38 <acquire+0x95>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
ffffffff80106a4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106a51:	48 c7 c2 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rdx
ffffffff80106a58:	64 48 8b 12          	mov    %fs:(%rdx),%rdx
ffffffff80106a5c:	48 89 50 10          	mov    %rdx,0x10(%rax)
  getcallerpcs(&lk, lk->pcs);
ffffffff80106a60:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106a64:	48 8d 50 18          	lea    0x18(%rax),%rdx
ffffffff80106a68:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffffffff80106a6c:	48 89 d6             	mov    %rdx,%rsi
ffffffff80106a6f:	48 89 c7             	mov    %rax,%rdi
ffffffff80106a72:	e8 5c 00 00 00       	callq  ffffffff80106ad3 <getcallerpcs>
}
ffffffff80106a77:	90                   	nop
ffffffff80106a78:	c9                   	leaveq 
ffffffff80106a79:	c3                   	retq   

ffffffff80106a7a <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
ffffffff80106a7a:	55                   	push   %rbp
ffffffff80106a7b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106a7e:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106a82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(!holding(lk))
ffffffff80106a86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106a8a:	48 89 c7             	mov    %rax,%rdi
ffffffff80106a8d:	e8 07 01 00 00       	callq  ffffffff80106b99 <holding>
ffffffff80106a92:	85 c0                	test   %eax,%eax
ffffffff80106a94:	75 0c                	jne    ffffffff80106aa2 <release+0x28>
    panic("release");
ffffffff80106a96:	48 c7 c7 ac ab 10 80 	mov    $0xffffffff8010abac,%rdi
ffffffff80106a9d:	e8 5d 9e ff ff       	callq  ffffffff801008ff <panic>

  lk->pcs[0] = 0;
ffffffff80106aa2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106aa6:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
ffffffff80106aad:	00 
  lk->cpu = 0;
ffffffff80106aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106ab2:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
ffffffff80106ab9:	00 
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
ffffffff80106aba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106abe:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80106ac3:	48 89 c7             	mov    %rax,%rdi
ffffffff80106ac6:	e8 7c fe ff ff       	callq  ffffffff80106947 <xchg>

  popcli();
ffffffff80106acb:	e8 55 01 00 00       	callq  ffffffff80106c25 <popcli>
}
ffffffff80106ad0:	90                   	nop
ffffffff80106ad1:	c9                   	leaveq 
ffffffff80106ad2:	c3                   	retq   

ffffffff80106ad3 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uintp pcs[])
{
ffffffff80106ad3:	55                   	push   %rbp
ffffffff80106ad4:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106ad7:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80106adb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106adf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uintp *ebp;
#if X64
  asm volatile("mov %%rbp, %0" : "=r" (ebp));  
ffffffff80106ae3:	48 89 e8             	mov    %rbp,%rax
ffffffff80106ae6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
#else
  ebp = (uintp*)v - 2;
#endif
  getstackpcs(ebp, pcs);
ffffffff80106aea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff80106aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106af2:	48 89 d6             	mov    %rdx,%rsi
ffffffff80106af5:	48 89 c7             	mov    %rax,%rdi
ffffffff80106af8:	e8 03 00 00 00       	callq  ffffffff80106b00 <getstackpcs>
}
ffffffff80106afd:	90                   	nop
ffffffff80106afe:	c9                   	leaveq 
ffffffff80106aff:	c3                   	retq   

ffffffff80106b00 <getstackpcs>:

void
getstackpcs(uintp *ebp, uintp pcs[])
{
ffffffff80106b00:	55                   	push   %rbp
ffffffff80106b01:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106b04:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80106b08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106b0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  
  for(i = 0; i < 10; i++){
ffffffff80106b10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80106b17:	eb 50                	jmp    ffffffff80106b69 <getstackpcs+0x69>
    if(ebp == 0 || ebp < (uintp*)KERNBASE || ebp == (uintp*)0xffffffff)
ffffffff80106b19:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff80106b1e:	74 70                	je     ffffffff80106b90 <getstackpcs+0x90>
ffffffff80106b20:	48 b8 ff ff ff 7f ff 	movabs $0xffffffff7fffffff,%rax
ffffffff80106b27:	ff ff ff 
ffffffff80106b2a:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffffffff80106b2e:	76 60                	jbe    ffffffff80106b90 <getstackpcs+0x90>
ffffffff80106b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80106b35:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
ffffffff80106b39:	74 55                	je     ffffffff80106b90 <getstackpcs+0x90>
      break;
    pcs[i] = ebp[1];     // saved %eip
ffffffff80106b3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80106b3e:	48 98                	cltq   
ffffffff80106b40:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80106b47:	00 
ffffffff80106b48:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80106b4c:	48 01 c2             	add    %rax,%rdx
ffffffff80106b4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106b53:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff80106b57:	48 89 02             	mov    %rax,(%rdx)
    ebp = (uintp*)ebp[0]; // saved %ebp
ffffffff80106b5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106b5e:	48 8b 00             	mov    (%rax),%rax
ffffffff80106b61:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
void
getstackpcs(uintp *ebp, uintp pcs[])
{
  int i;
  
  for(i = 0; i < 10; i++){
ffffffff80106b65:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80106b69:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff80106b6d:	7e aa                	jle    ffffffff80106b19 <getstackpcs+0x19>
    if(ebp == 0 || ebp < (uintp*)KERNBASE || ebp == (uintp*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uintp*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
ffffffff80106b6f:	eb 1f                	jmp    ffffffff80106b90 <getstackpcs+0x90>
    pcs[i] = 0;
ffffffff80106b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80106b74:	48 98                	cltq   
ffffffff80106b76:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80106b7d:	00 
ffffffff80106b7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80106b82:	48 01 d0             	add    %rdx,%rax
ffffffff80106b85:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
    if(ebp == 0 || ebp < (uintp*)KERNBASE || ebp == (uintp*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uintp*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
ffffffff80106b8c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80106b90:	83 7d fc 09          	cmpl   $0x9,-0x4(%rbp)
ffffffff80106b94:	7e db                	jle    ffffffff80106b71 <getstackpcs+0x71>
    pcs[i] = 0;
}
ffffffff80106b96:	90                   	nop
ffffffff80106b97:	c9                   	leaveq 
ffffffff80106b98:	c3                   	retq   

ffffffff80106b99 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
ffffffff80106b99:	55                   	push   %rbp
ffffffff80106b9a:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106b9d:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80106ba1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  return lock->locked && lock->cpu == cpu;
ffffffff80106ba5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106ba9:	8b 00                	mov    (%rax),%eax
ffffffff80106bab:	85 c0                	test   %eax,%eax
ffffffff80106bad:	74 1f                	je     ffffffff80106bce <holding+0x35>
ffffffff80106baf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106bb3:	48 8b 50 10          	mov    0x10(%rax),%rdx
ffffffff80106bb7:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106bbe:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106bc2:	48 39 c2             	cmp    %rax,%rdx
ffffffff80106bc5:	75 07                	jne    ffffffff80106bce <holding+0x35>
ffffffff80106bc7:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff80106bcc:	eb 05                	jmp    ffffffff80106bd3 <holding+0x3a>
ffffffff80106bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80106bd3:	c9                   	leaveq 
ffffffff80106bd4:	c3                   	retq   

ffffffff80106bd5 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
ffffffff80106bd5:	55                   	push   %rbp
ffffffff80106bd6:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106bd9:	48 83 ec 10          	sub    $0x10,%rsp
  int eflags;
  
  eflags = readeflags();
ffffffff80106bdd:	e8 41 fd ff ff       	callq  ffffffff80106923 <readeflags>
ffffffff80106be2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  cli();
ffffffff80106be5:	e8 4d fd ff ff       	callq  ffffffff80106937 <cli>
  if(cpu->ncli++ == 0)
ffffffff80106bea:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106bf1:	64 48 8b 10          	mov    %fs:(%rax),%rdx
ffffffff80106bf5:	8b 82 dc 00 00 00    	mov    0xdc(%rdx),%eax
ffffffff80106bfb:	8d 48 01             	lea    0x1(%rax),%ecx
ffffffff80106bfe:	89 8a dc 00 00 00    	mov    %ecx,0xdc(%rdx)
ffffffff80106c04:	85 c0                	test   %eax,%eax
ffffffff80106c06:	75 1a                	jne    ffffffff80106c22 <pushcli+0x4d>
    cpu->intena = eflags & FL_IF;
ffffffff80106c08:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106c0f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106c13:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80106c16:	81 e2 00 02 00 00    	and    $0x200,%edx
ffffffff80106c1c:	89 90 e0 00 00 00    	mov    %edx,0xe0(%rax)
}
ffffffff80106c22:	90                   	nop
ffffffff80106c23:	c9                   	leaveq 
ffffffff80106c24:	c3                   	retq   

ffffffff80106c25 <popcli>:

void
popcli(void)
{
ffffffff80106c25:	55                   	push   %rbp
ffffffff80106c26:	48 89 e5             	mov    %rsp,%rbp
  if(readeflags()&FL_IF)
ffffffff80106c29:	e8 f5 fc ff ff       	callq  ffffffff80106923 <readeflags>
ffffffff80106c2e:	25 00 02 00 00       	and    $0x200,%eax
ffffffff80106c33:	48 85 c0             	test   %rax,%rax
ffffffff80106c36:	74 0c                	je     ffffffff80106c44 <popcli+0x1f>
    panic("popcli - interruptible");
ffffffff80106c38:	48 c7 c7 b4 ab 10 80 	mov    $0xffffffff8010abb4,%rdi
ffffffff80106c3f:	e8 bb 9c ff ff       	callq  ffffffff801008ff <panic>
  if(--cpu->ncli < 0)
ffffffff80106c44:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106c4b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106c4f:	8b 90 dc 00 00 00    	mov    0xdc(%rax),%edx
ffffffff80106c55:	83 ea 01             	sub    $0x1,%edx
ffffffff80106c58:	89 90 dc 00 00 00    	mov    %edx,0xdc(%rax)
ffffffff80106c5e:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
ffffffff80106c64:	85 c0                	test   %eax,%eax
ffffffff80106c66:	79 0c                	jns    ffffffff80106c74 <popcli+0x4f>
    panic("popcli");
ffffffff80106c68:	48 c7 c7 cb ab 10 80 	mov    $0xffffffff8010abcb,%rdi
ffffffff80106c6f:	e8 8b 9c ff ff       	callq  ffffffff801008ff <panic>
  if(cpu->ncli == 0 && cpu->intena)
ffffffff80106c74:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106c7b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106c7f:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
ffffffff80106c85:	85 c0                	test   %eax,%eax
ffffffff80106c87:	75 1a                	jne    ffffffff80106ca3 <popcli+0x7e>
ffffffff80106c89:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80106c90:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80106c94:	8b 80 e0 00 00 00    	mov    0xe0(%rax),%eax
ffffffff80106c9a:	85 c0                	test   %eax,%eax
ffffffff80106c9c:	74 05                	je     ffffffff80106ca3 <popcli+0x7e>
    sti();
ffffffff80106c9e:	e8 9c fc ff ff       	callq  ffffffff8010693f <sti>
}
ffffffff80106ca3:	90                   	nop
ffffffff80106ca4:	5d                   	pop    %rbp
ffffffff80106ca5:	c3                   	retq   

ffffffff80106ca6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
ffffffff80106ca6:	55                   	push   %rbp
ffffffff80106ca7:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106caa:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106cae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106cb2:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffffffff80106cb5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
ffffffff80106cb8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff80106cbc:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffffffff80106cbf:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80106cc2:	48 89 ce             	mov    %rcx,%rsi
ffffffff80106cc5:	48 89 f7             	mov    %rsi,%rdi
ffffffff80106cc8:	89 d1                	mov    %edx,%ecx
ffffffff80106cca:	fc                   	cld    
ffffffff80106ccb:	f3 aa                	rep stos %al,%es:(%rdi)
ffffffff80106ccd:	89 ca                	mov    %ecx,%edx
ffffffff80106ccf:	48 89 fe             	mov    %rdi,%rsi
ffffffff80106cd2:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffffffff80106cd6:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
ffffffff80106cd9:	90                   	nop
ffffffff80106cda:	c9                   	leaveq 
ffffffff80106cdb:	c3                   	retq   

ffffffff80106cdc <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
ffffffff80106cdc:	55                   	push   %rbp
ffffffff80106cdd:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106ce0:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106ce4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106ce8:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffffffff80106ceb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosl" :
ffffffff80106cee:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff80106cf2:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffffffff80106cf5:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80106cf8:	48 89 ce             	mov    %rcx,%rsi
ffffffff80106cfb:	48 89 f7             	mov    %rsi,%rdi
ffffffff80106cfe:	89 d1                	mov    %edx,%ecx
ffffffff80106d00:	fc                   	cld    
ffffffff80106d01:	f3 ab                	rep stos %eax,%es:(%rdi)
ffffffff80106d03:	89 ca                	mov    %ecx,%edx
ffffffff80106d05:	48 89 fe             	mov    %rdi,%rsi
ffffffff80106d08:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
ffffffff80106d0c:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
ffffffff80106d0f:	90                   	nop
ffffffff80106d10:	c9                   	leaveq 
ffffffff80106d11:	c3                   	retq   

ffffffff80106d12 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
ffffffff80106d12:	55                   	push   %rbp
ffffffff80106d13:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106d16:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80106d1a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106d1e:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffffffff80106d21:	89 55 f0             	mov    %edx,-0x10(%rbp)
  if ((uintp)dst%4 == 0 && n%4 == 0){
ffffffff80106d24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106d28:	83 e0 03             	and    $0x3,%eax
ffffffff80106d2b:	48 85 c0             	test   %rax,%rax
ffffffff80106d2e:	75 48                	jne    ffffffff80106d78 <memset+0x66>
ffffffff80106d30:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff80106d33:	83 e0 03             	and    $0x3,%eax
ffffffff80106d36:	85 c0                	test   %eax,%eax
ffffffff80106d38:	75 3e                	jne    ffffffff80106d78 <memset+0x66>
    c &= 0xFF;
ffffffff80106d3a:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
ffffffff80106d41:	8b 45 f0             	mov    -0x10(%rbp),%eax
ffffffff80106d44:	c1 e8 02             	shr    $0x2,%eax
ffffffff80106d47:	89 c6                	mov    %eax,%esi
ffffffff80106d49:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80106d4c:	c1 e0 18             	shl    $0x18,%eax
ffffffff80106d4f:	89 c2                	mov    %eax,%edx
ffffffff80106d51:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80106d54:	c1 e0 10             	shl    $0x10,%eax
ffffffff80106d57:	09 c2                	or     %eax,%edx
ffffffff80106d59:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80106d5c:	c1 e0 08             	shl    $0x8,%eax
ffffffff80106d5f:	09 d0                	or     %edx,%eax
ffffffff80106d61:	0b 45 f4             	or     -0xc(%rbp),%eax
ffffffff80106d64:	89 c1                	mov    %eax,%ecx
ffffffff80106d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106d6a:	89 f2                	mov    %esi,%edx
ffffffff80106d6c:	89 ce                	mov    %ecx,%esi
ffffffff80106d6e:	48 89 c7             	mov    %rax,%rdi
ffffffff80106d71:	e8 66 ff ff ff       	callq  ffffffff80106cdc <stosl>
ffffffff80106d76:	eb 14                	jmp    ffffffff80106d8c <memset+0x7a>
  } else
    stosb(dst, c, n);
ffffffff80106d78:	8b 55 f0             	mov    -0x10(%rbp),%edx
ffffffff80106d7b:	8b 4d f4             	mov    -0xc(%rbp),%ecx
ffffffff80106d7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106d82:	89 ce                	mov    %ecx,%esi
ffffffff80106d84:	48 89 c7             	mov    %rax,%rdi
ffffffff80106d87:	e8 1a ff ff ff       	callq  ffffffff80106ca6 <stosb>
  return dst;
ffffffff80106d8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80106d90:	c9                   	leaveq 
ffffffff80106d91:	c3                   	retq   

ffffffff80106d92 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
ffffffff80106d92:	55                   	push   %rbp
ffffffff80106d93:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106d96:	48 83 ec 28          	sub    $0x28,%rsp
ffffffff80106d9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106d9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80106da2:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const uchar *s1, *s2;
  
  s1 = v1;
ffffffff80106da5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106da9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  s2 = v2;
ffffffff80106dad:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80106db1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0){
ffffffff80106db5:	eb 36                	jmp    ffffffff80106ded <memcmp+0x5b>
    if(*s1 != *s2)
ffffffff80106db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106dbb:	0f b6 10             	movzbl (%rax),%edx
ffffffff80106dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106dc2:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106dc5:	38 c2                	cmp    %al,%dl
ffffffff80106dc7:	74 1a                	je     ffffffff80106de3 <memcmp+0x51>
      return *s1 - *s2;
ffffffff80106dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106dcd:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106dd0:	0f b6 d0             	movzbl %al,%edx
ffffffff80106dd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106dd7:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106dda:	0f b6 c0             	movzbl %al,%eax
ffffffff80106ddd:	29 c2                	sub    %eax,%edx
ffffffff80106ddf:	89 d0                	mov    %edx,%eax
ffffffff80106de1:	eb 1c                	jmp    ffffffff80106dff <memcmp+0x6d>
    s1++, s2++;
ffffffff80106de3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffffffff80106de8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
ffffffff80106ded:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106df0:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80106df3:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffffffff80106df6:	85 c0                	test   %eax,%eax
ffffffff80106df8:	75 bd                	jne    ffffffff80106db7 <memcmp+0x25>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
ffffffff80106dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80106dff:	c9                   	leaveq 
ffffffff80106e00:	c3                   	retq   

ffffffff80106e01 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
ffffffff80106e01:	55                   	push   %rbp
ffffffff80106e02:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106e05:	48 83 ec 28          	sub    $0x28,%rsp
ffffffff80106e09:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106e0d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80106e11:	89 55 dc             	mov    %edx,-0x24(%rbp)
  const char *s;
  char *d;

  s = src;
ffffffff80106e14:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80106e18:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  d = dst;
ffffffff80106e1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106e20:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(s < d && s + n > d){
ffffffff80106e24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106e28:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffffffff80106e2c:	73 63                	jae    ffffffff80106e91 <memmove+0x90>
ffffffff80106e2e:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffffffff80106e31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106e35:	48 01 d0             	add    %rdx,%rax
ffffffff80106e38:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffffffff80106e3c:	76 53                	jbe    ffffffff80106e91 <memmove+0x90>
    s += n;
ffffffff80106e3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106e41:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    d += n;
ffffffff80106e45:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106e48:	48 01 45 f0          	add    %rax,-0x10(%rbp)
    while(n-- > 0)
ffffffff80106e4c:	eb 17                	jmp    ffffffff80106e65 <memmove+0x64>
      *--d = *--s;
ffffffff80106e4e:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
ffffffff80106e53:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
ffffffff80106e58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106e5c:	0f b6 10             	movzbl (%rax),%edx
ffffffff80106e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106e63:	88 10                	mov    %dl,(%rax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
ffffffff80106e65:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106e68:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80106e6b:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffffffff80106e6e:	85 c0                	test   %eax,%eax
ffffffff80106e70:	75 dc                	jne    ffffffff80106e4e <memmove+0x4d>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
ffffffff80106e72:	eb 2a                	jmp    ffffffff80106e9e <memmove+0x9d>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
ffffffff80106e74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106e78:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffffffff80106e7c:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
ffffffff80106e80:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80106e84:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
ffffffff80106e88:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
ffffffff80106e8c:	0f b6 12             	movzbl (%rdx),%edx
ffffffff80106e8f:	88 10                	mov    %dl,(%rax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
ffffffff80106e91:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106e94:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80106e97:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffffffff80106e9a:	85 c0                	test   %eax,%eax
ffffffff80106e9c:	75 d6                	jne    ffffffff80106e74 <memmove+0x73>
      *d++ = *s++;

  return dst;
ffffffff80106e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
ffffffff80106ea2:	c9                   	leaveq 
ffffffff80106ea3:	c3                   	retq   

ffffffff80106ea4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
ffffffff80106ea4:	55                   	push   %rbp
ffffffff80106ea5:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106ea8:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80106eac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106eb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff80106eb4:	89 55 ec             	mov    %edx,-0x14(%rbp)
  return memmove(dst, src, n);
ffffffff80106eb7:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80106eba:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
ffffffff80106ebe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106ec2:	48 89 ce             	mov    %rcx,%rsi
ffffffff80106ec5:	48 89 c7             	mov    %rax,%rdi
ffffffff80106ec8:	e8 34 ff ff ff       	callq  ffffffff80106e01 <memmove>
}
ffffffff80106ecd:	c9                   	leaveq 
ffffffff80106ece:	c3                   	retq   

ffffffff80106ecf <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
ffffffff80106ecf:	55                   	push   %rbp
ffffffff80106ed0:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106ed3:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80106ed7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80106edb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
ffffffff80106edf:	89 55 ec             	mov    %edx,-0x14(%rbp)
  while(n > 0 && *p && *p == *q)
ffffffff80106ee2:	eb 0e                	jmp    ffffffff80106ef2 <strncmp+0x23>
    n--, p++, q++;
ffffffff80106ee4:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
ffffffff80106ee8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffffffff80106eed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
ffffffff80106ef2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80106ef6:	74 1d                	je     ffffffff80106f15 <strncmp+0x46>
ffffffff80106ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106efc:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106eff:	84 c0                	test   %al,%al
ffffffff80106f01:	74 12                	je     ffffffff80106f15 <strncmp+0x46>
ffffffff80106f03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106f07:	0f b6 10             	movzbl (%rax),%edx
ffffffff80106f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106f0e:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106f11:	38 c2                	cmp    %al,%dl
ffffffff80106f13:	74 cf                	je     ffffffff80106ee4 <strncmp+0x15>
    n--, p++, q++;
  if(n == 0)
ffffffff80106f15:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80106f19:	75 07                	jne    ffffffff80106f22 <strncmp+0x53>
    return 0;
ffffffff80106f1b:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80106f20:	eb 18                	jmp    ffffffff80106f3a <strncmp+0x6b>
  return (uchar)*p - (uchar)*q;
ffffffff80106f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106f26:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106f29:	0f b6 d0             	movzbl %al,%edx
ffffffff80106f2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80106f30:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106f33:	0f b6 c0             	movzbl %al,%eax
ffffffff80106f36:	29 c2                	sub    %eax,%edx
ffffffff80106f38:	89 d0                	mov    %edx,%eax
}
ffffffff80106f3a:	c9                   	leaveq 
ffffffff80106f3b:	c3                   	retq   

ffffffff80106f3c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
ffffffff80106f3c:	55                   	push   %rbp
ffffffff80106f3d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106f40:	48 83 ec 28          	sub    $0x28,%rsp
ffffffff80106f44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106f48:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80106f4c:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os;
  
  os = s;
ffffffff80106f4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106f53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(n-- > 0 && (*s++ = *t++) != 0)
ffffffff80106f57:	90                   	nop
ffffffff80106f58:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106f5b:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80106f5e:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffffffff80106f61:	85 c0                	test   %eax,%eax
ffffffff80106f63:	7e 35                	jle    ffffffff80106f9a <strncpy+0x5e>
ffffffff80106f65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106f69:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffffffff80106f6d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffffffff80106f71:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff80106f75:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
ffffffff80106f79:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
ffffffff80106f7d:	0f b6 12             	movzbl (%rdx),%edx
ffffffff80106f80:	88 10                	mov    %dl,(%rax)
ffffffff80106f82:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106f85:	84 c0                	test   %al,%al
ffffffff80106f87:	75 cf                	jne    ffffffff80106f58 <strncpy+0x1c>
    ;
  while(n-- > 0)
ffffffff80106f89:	eb 0f                	jmp    ffffffff80106f9a <strncpy+0x5e>
    *s++ = 0;
ffffffff80106f8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106f8f:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffffffff80106f93:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffffffff80106f97:	c6 00 00             	movb   $0x0,(%rax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
ffffffff80106f9a:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80106f9d:	8d 50 ff             	lea    -0x1(%rax),%edx
ffffffff80106fa0:	89 55 dc             	mov    %edx,-0x24(%rbp)
ffffffff80106fa3:	85 c0                	test   %eax,%eax
ffffffff80106fa5:	7f e4                	jg     ffffffff80106f8b <strncpy+0x4f>
    *s++ = 0;
  return os;
ffffffff80106fa7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff80106fab:	c9                   	leaveq 
ffffffff80106fac:	c3                   	retq   

ffffffff80106fad <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
ffffffff80106fad:	55                   	push   %rbp
ffffffff80106fae:	48 89 e5             	mov    %rsp,%rbp
ffffffff80106fb1:	48 83 ec 28          	sub    $0x28,%rsp
ffffffff80106fb5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80106fb9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80106fbd:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *os;
  
  os = s;
ffffffff80106fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106fc4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(n <= 0)
ffffffff80106fc8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffffffff80106fcc:	7f 06                	jg     ffffffff80106fd4 <safestrcpy+0x27>
    return os;
ffffffff80106fce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80106fd2:	eb 39                	jmp    ffffffff8010700d <safestrcpy+0x60>
  while(--n > 0 && (*s++ = *t++) != 0)
ffffffff80106fd4:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
ffffffff80106fd8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffffffff80106fdc:	7e 24                	jle    ffffffff80107002 <safestrcpy+0x55>
ffffffff80106fde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80106fe2:	48 8d 50 01          	lea    0x1(%rax),%rdx
ffffffff80106fe6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
ffffffff80106fea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff80106fee:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
ffffffff80106ff2:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
ffffffff80106ff6:	0f b6 12             	movzbl (%rdx),%edx
ffffffff80106ff9:	88 10                	mov    %dl,(%rax)
ffffffff80106ffb:	0f b6 00             	movzbl (%rax),%eax
ffffffff80106ffe:	84 c0                	test   %al,%al
ffffffff80107000:	75 d2                	jne    ffffffff80106fd4 <safestrcpy+0x27>
    ;
  *s = 0;
ffffffff80107002:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80107006:	c6 00 00             	movb   $0x0,(%rax)
  return os;
ffffffff80107009:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff8010700d:	c9                   	leaveq 
ffffffff8010700e:	c3                   	retq   

ffffffff8010700f <strlen>:

int
strlen(const char *s)
{
ffffffff8010700f:	55                   	push   %rbp
ffffffff80107010:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107013:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80107017:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
ffffffff8010701b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80107022:	eb 04                	jmp    ffffffff80107028 <strlen+0x19>
ffffffff80107024:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80107028:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010702b:	48 63 d0             	movslq %eax,%rdx
ffffffff8010702e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80107032:	48 01 d0             	add    %rdx,%rax
ffffffff80107035:	0f b6 00             	movzbl (%rax),%eax
ffffffff80107038:	84 c0                	test   %al,%al
ffffffff8010703a:	75 e8                	jne    ffffffff80107024 <strlen+0x15>
    ;
  return n;
ffffffff8010703c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff8010703f:	c9                   	leaveq 
ffffffff80107040:	c3                   	retq   

ffffffff80107041 <swtch>:
# and then load register context from new.

.globl swtch
swtch:
  # Save old callee-save registers
  push %rbp
ffffffff80107041:	55                   	push   %rbp
  push %rbx
ffffffff80107042:	53                   	push   %rbx
  push %r11
ffffffff80107043:	41 53                	push   %r11
  push %r12
ffffffff80107045:	41 54                	push   %r12
  push %r13
ffffffff80107047:	41 55                	push   %r13
  push %r14
ffffffff80107049:	41 56                	push   %r14
  push %r15
ffffffff8010704b:	41 57                	push   %r15

  # Switch stacks
  mov %rsp, (%rdi)
ffffffff8010704d:	48 89 27             	mov    %rsp,(%rdi)
  mov %rsi, %rsp
ffffffff80107050:	48 89 f4             	mov    %rsi,%rsp

  # Load new callee-save registers
  pop %r15
ffffffff80107053:	41 5f                	pop    %r15
  pop %r14
ffffffff80107055:	41 5e                	pop    %r14
  pop %r13
ffffffff80107057:	41 5d                	pop    %r13
  pop %r12
ffffffff80107059:	41 5c                	pop    %r12
  pop %r11
ffffffff8010705b:	41 5b                	pop    %r11
  pop %rbx
ffffffff8010705d:	5b                   	pop    %rbx
  pop %rbp
ffffffff8010705e:	5d                   	pop    %rbp

  ret #??
ffffffff8010705f:	c3                   	retq   

ffffffff80107060 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uintp addr, int *ip)
{
ffffffff80107060:	55                   	push   %rbp
ffffffff80107061:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107064:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80107068:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff8010706c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(int) > proc->sz)
ffffffff80107070:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107077:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010707b:	48 8b 00             	mov    (%rax),%rax
ffffffff8010707e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
ffffffff80107082:	76 1b                	jbe    ffffffff8010709f <fetchint+0x3f>
ffffffff80107084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107088:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffffffff8010708c:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107093:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107097:	48 8b 00             	mov    (%rax),%rax
ffffffff8010709a:	48 39 c2             	cmp    %rax,%rdx
ffffffff8010709d:	76 07                	jbe    ffffffff801070a6 <fetchint+0x46>
    return -1;
ffffffff8010709f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801070a4:	eb 11                	jmp    ffffffff801070b7 <fetchint+0x57>
  *ip = *(int*)(addr);
ffffffff801070a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801070aa:	8b 10                	mov    (%rax),%edx
ffffffff801070ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801070b0:	89 10                	mov    %edx,(%rax)
  return 0;
ffffffff801070b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801070b7:	c9                   	leaveq 
ffffffff801070b8:	c3                   	retq   

ffffffff801070b9 <fetchuintp>:

int
fetchuintp(uintp addr, uintp *ip)
{
ffffffff801070b9:	55                   	push   %rbp
ffffffff801070ba:	48 89 e5             	mov    %rsp,%rbp
ffffffff801070bd:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff801070c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff801070c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  if(addr >= proc->sz || addr+sizeof(uintp) > proc->sz)
ffffffff801070c9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801070d0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801070d4:	48 8b 00             	mov    (%rax),%rax
ffffffff801070d7:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
ffffffff801070db:	76 1b                	jbe    ffffffff801070f8 <fetchuintp+0x3f>
ffffffff801070dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801070e1:	48 8d 50 08          	lea    0x8(%rax),%rdx
ffffffff801070e5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801070ec:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801070f0:	48 8b 00             	mov    (%rax),%rax
ffffffff801070f3:	48 39 c2             	cmp    %rax,%rdx
ffffffff801070f6:	76 07                	jbe    ffffffff801070ff <fetchuintp+0x46>
    return -1;
ffffffff801070f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801070fd:	eb 13                	jmp    ffffffff80107112 <fetchuintp+0x59>
  *ip = *(uintp*)(addr);
ffffffff801070ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107103:	48 8b 10             	mov    (%rax),%rdx
ffffffff80107106:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010710a:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffffffff8010710d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107112:	c9                   	leaveq 
ffffffff80107113:	c3                   	retq   

ffffffff80107114 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uintp addr, char **pp)
{
ffffffff80107114:	55                   	push   %rbp
ffffffff80107115:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107118:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010711c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80107120:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *s, *ep;

  if(addr >= proc->sz)
ffffffff80107124:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010712b:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010712f:	48 8b 00             	mov    (%rax),%rax
ffffffff80107132:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80107136:	77 07                	ja     ffffffff8010713f <fetchstr+0x2b>
    return -1;
ffffffff80107138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010713d:	eb 5c                	jmp    ffffffff8010719b <fetchstr+0x87>
  *pp = (char*)addr;
ffffffff8010713f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80107143:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80107147:	48 89 10             	mov    %rdx,(%rax)
  ep = (char*)proc->sz;
ffffffff8010714a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107151:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107155:	48 8b 00             	mov    (%rax),%rax
ffffffff80107158:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(s = *pp; s < ep; s++)
ffffffff8010715c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80107160:	48 8b 00             	mov    (%rax),%rax
ffffffff80107163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107167:	eb 23                	jmp    ffffffff8010718c <fetchstr+0x78>
    if(*s == 0)
ffffffff80107169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010716d:	0f b6 00             	movzbl (%rax),%eax
ffffffff80107170:	84 c0                	test   %al,%al
ffffffff80107172:	75 13                	jne    ffffffff80107187 <fetchstr+0x73>
      return s - *pp;
ffffffff80107174:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80107178:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010717c:	48 8b 00             	mov    (%rax),%rax
ffffffff8010717f:	48 29 c2             	sub    %rax,%rdx
ffffffff80107182:	48 89 d0             	mov    %rdx,%rax
ffffffff80107185:	eb 14                	jmp    ffffffff8010719b <fetchstr+0x87>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
ffffffff80107187:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffffffff8010718c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107190:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffffffff80107194:	72 d3                	jb     ffffffff80107169 <fetchstr+0x55>
    if(*s == 0)
      return s - *pp;
  return -1;
ffffffff80107196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff8010719b:	c9                   	leaveq 
ffffffff8010719c:	c3                   	retq   

ffffffff8010719d <fetcharg>:

#if X64
// arguments passed in registers on x64
static uintp
fetcharg(int n)
{
ffffffff8010719d:	55                   	push   %rbp
ffffffff8010719e:	48 89 e5             	mov    %rsp,%rbp
ffffffff801071a1:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801071a5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  switch (n) {
ffffffff801071a8:	83 7d fc 05          	cmpl   $0x5,-0x4(%rbp)
ffffffff801071ac:	0f 87 8b 00 00 00    	ja     ffffffff8010723d <fetcharg+0xa0>
ffffffff801071b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801071b5:	48 8b 04 c5 d8 ab 10 	mov    -0x7fef5428(,%rax,8),%rax
ffffffff801071bc:	80 
ffffffff801071bd:	ff e0                	jmpq   *%rax
  case 0: return proc->tf->rdi;
ffffffff801071bf:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801071c6:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801071ca:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff801071ce:	48 8b 40 30          	mov    0x30(%rax),%rax
ffffffff801071d2:	eb 6e                	jmp    ffffffff80107242 <fetcharg+0xa5>
  case 1: return proc->tf->rsi;
ffffffff801071d4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801071db:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801071df:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff801071e3:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff801071e7:	eb 59                	jmp    ffffffff80107242 <fetcharg+0xa5>
  case 2: return proc->tf->rdx;
ffffffff801071e9:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801071f0:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801071f4:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff801071f8:	48 8b 40 18          	mov    0x18(%rax),%rax
ffffffff801071fc:	eb 44                	jmp    ffffffff80107242 <fetcharg+0xa5>
  case 3: return proc->tf->rcx;
ffffffff801071fe:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107205:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107209:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff8010720d:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff80107211:	eb 2f                	jmp    ffffffff80107242 <fetcharg+0xa5>
  case 4: return proc->tf->r8;
ffffffff80107213:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010721a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010721e:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80107222:	48 8b 40 38          	mov    0x38(%rax),%rax
ffffffff80107226:	eb 1a                	jmp    ffffffff80107242 <fetcharg+0xa5>
  case 5: return proc->tf->r9;
ffffffff80107228:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010722f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107233:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80107237:	48 8b 40 40          	mov    0x40(%rax),%rax
ffffffff8010723b:	eb 05                	jmp    ffffffff80107242 <fetcharg+0xa5>
  }
  /* FIXME: should not reach here */
  return 0;
ffffffff8010723d:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107242:	c9                   	leaveq 
ffffffff80107243:	c3                   	retq   

ffffffff80107244 <argint>:

int
argint(int n, int *ip)
{
ffffffff80107244:	55                   	push   %rbp
ffffffff80107245:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107248:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff8010724c:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff8010724f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffffffff80107253:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80107256:	89 c7                	mov    %eax,%edi
ffffffff80107258:	e8 40 ff ff ff       	callq  ffffffff8010719d <fetcharg>
ffffffff8010725d:	89 c2                	mov    %eax,%edx
ffffffff8010725f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107263:	89 10                	mov    %edx,(%rax)
  return 0;
ffffffff80107265:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff8010726a:	c9                   	leaveq 
ffffffff8010726b:	c3                   	retq   

ffffffff8010726c <arguintp>:

int
arguintp(int n, uintp *ip)
{
ffffffff8010726c:	55                   	push   %rbp
ffffffff8010726d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107270:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80107274:	89 7d fc             	mov    %edi,-0x4(%rbp)
ffffffff80107277:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  *ip = fetcharg(n);
ffffffff8010727b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010727e:	89 c7                	mov    %eax,%edi
ffffffff80107280:	e8 18 ff ff ff       	callq  ffffffff8010719d <fetcharg>
ffffffff80107285:	48 89 c2             	mov    %rax,%rdx
ffffffff80107288:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010728c:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffffffff8010728f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107294:	c9                   	leaveq 
ffffffff80107295:	c3                   	retq   

ffffffff80107296 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
ffffffff80107296:	55                   	push   %rbp
ffffffff80107297:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010729a:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010729e:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff801072a1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff801072a5:	89 55 e8             	mov    %edx,-0x18(%rbp)
  uintp i;

  if(arguintp(n, &i) < 0)
ffffffff801072a8:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffffffff801072ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801072af:	48 89 d6             	mov    %rdx,%rsi
ffffffff801072b2:	89 c7                	mov    %eax,%edi
ffffffff801072b4:	e8 b3 ff ff ff       	callq  ffffffff8010726c <arguintp>
ffffffff801072b9:	85 c0                	test   %eax,%eax
ffffffff801072bb:	79 07                	jns    ffffffff801072c4 <argptr+0x2e>
    return -1;
ffffffff801072bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801072c2:	eb 51                	jmp    ffffffff80107315 <argptr+0x7f>
  if(i >= proc->sz || i+size > proc->sz)
ffffffff801072c4:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801072cb:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801072cf:	48 8b 10             	mov    (%rax),%rdx
ffffffff801072d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801072d6:	48 39 c2             	cmp    %rax,%rdx
ffffffff801072d9:	76 20                	jbe    ffffffff801072fb <argptr+0x65>
ffffffff801072db:	8b 45 e8             	mov    -0x18(%rbp),%eax
ffffffff801072de:	48 63 d0             	movslq %eax,%rdx
ffffffff801072e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801072e5:	48 01 c2             	add    %rax,%rdx
ffffffff801072e8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801072ef:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801072f3:	48 8b 00             	mov    (%rax),%rax
ffffffff801072f6:	48 39 c2             	cmp    %rax,%rdx
ffffffff801072f9:	76 07                	jbe    ffffffff80107302 <argptr+0x6c>
    return -1;
ffffffff801072fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107300:	eb 13                	jmp    ffffffff80107315 <argptr+0x7f>
  *pp = (char*)i;
ffffffff80107302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107306:	48 89 c2             	mov    %rax,%rdx
ffffffff80107309:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010730d:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffffffff80107310:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107315:	c9                   	leaveq 
ffffffff80107316:	c3                   	retq   

ffffffff80107317 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
ffffffff80107317:	55                   	push   %rbp
ffffffff80107318:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010731b:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010731f:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff80107322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  uintp addr;
  if(arguintp(n, &addr) < 0)
ffffffff80107326:	48 8d 55 f8          	lea    -0x8(%rbp),%rdx
ffffffff8010732a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010732d:	48 89 d6             	mov    %rdx,%rsi
ffffffff80107330:	89 c7                	mov    %eax,%edi
ffffffff80107332:	e8 35 ff ff ff       	callq  ffffffff8010726c <arguintp>
ffffffff80107337:	85 c0                	test   %eax,%eax
ffffffff80107339:	79 07                	jns    ffffffff80107342 <argstr+0x2b>
    return -1;
ffffffff8010733b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107340:	eb 13                	jmp    ffffffff80107355 <argstr+0x3e>
  return fetchstr(addr, pp);
ffffffff80107342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107346:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff8010734a:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010734d:	48 89 c7             	mov    %rax,%rdi
ffffffff80107350:	e8 bf fd ff ff       	callq  ffffffff80107114 <fetchstr>
}
ffffffff80107355:	c9                   	leaveq 
ffffffff80107356:	c3                   	retq   

ffffffff80107357 <syscall>:
[SYS_chmod]   = sys_chmod,
};

void
syscall(void)
{
ffffffff80107357:	55                   	push   %rbp
ffffffff80107358:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010735b:	53                   	push   %rbx
ffffffff8010735c:	48 83 ec 18          	sub    $0x18,%rsp
  int num;

  num = proc->tf->eax;
ffffffff80107360:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107367:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010736b:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff8010736f:	48 8b 00             	mov    (%rax),%rax
ffffffff80107372:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
ffffffff80107375:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80107379:	7e 3f                	jle    ffffffff801073ba <syscall+0x63>
ffffffff8010737b:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010737e:	83 f8 16             	cmp    $0x16,%eax
ffffffff80107381:	77 37                	ja     ffffffff801073ba <syscall+0x63>
ffffffff80107383:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80107386:	48 98                	cltq   
ffffffff80107388:	48 8b 04 c5 c0 b5 10 	mov    -0x7fef4a40(,%rax,8),%rax
ffffffff8010738f:	80 
ffffffff80107390:	48 85 c0             	test   %rax,%rax
ffffffff80107393:	74 25                	je     ffffffff801073ba <syscall+0x63>
    proc->tf->eax = syscalls[num]();
ffffffff80107395:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010739c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801073a0:	48 8b 58 28          	mov    0x28(%rax),%rbx
ffffffff801073a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801073a7:	48 98                	cltq   
ffffffff801073a9:	48 8b 04 c5 c0 b5 10 	mov    -0x7fef4a40(,%rax,8),%rax
ffffffff801073b0:	80 
ffffffff801073b1:	ff d0                	callq  *%rax
ffffffff801073b3:	48 98                	cltq   
ffffffff801073b5:	48 89 03             	mov    %rax,(%rbx)
ffffffff801073b8:	eb 51                	jmp    ffffffff8010740b <syscall+0xb4>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
ffffffff801073ba:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801073c1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801073c5:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffffffff801073cc:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801073d3:	64 48 8b 00          	mov    %fs:(%rax),%rax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
ffffffff801073d7:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff801073da:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff801073dd:	89 d1                	mov    %edx,%ecx
ffffffff801073df:	48 89 f2             	mov    %rsi,%rdx
ffffffff801073e2:	89 c6                	mov    %eax,%esi
ffffffff801073e4:	48 c7 c7 08 ac 10 80 	mov    $0xffffffff8010ac08,%rdi
ffffffff801073eb:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801073f0:	e8 ad 91 ff ff       	callq  ffffffff801005a2 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
ffffffff801073f5:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801073fc:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107400:	48 8b 40 28          	mov    0x28(%rax),%rax
ffffffff80107404:	48 c7 00 ff ff ff ff 	movq   $0xffffffffffffffff,(%rax)
  }
}
ffffffff8010740b:	90                   	nop
ffffffff8010740c:	48 83 c4 18          	add    $0x18,%rsp
ffffffff80107410:	5b                   	pop    %rbx
ffffffff80107411:	5d                   	pop    %rbp
ffffffff80107412:	c3                   	retq   

ffffffff80107413 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
ffffffff80107413:	55                   	push   %rbp
ffffffff80107414:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107417:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff8010741b:	89 7d ec             	mov    %edi,-0x14(%rbp)
ffffffff8010741e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80107422:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
ffffffff80107426:	48 8d 55 f4          	lea    -0xc(%rbp),%rdx
ffffffff8010742a:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010742d:	48 89 d6             	mov    %rdx,%rsi
ffffffff80107430:	89 c7                	mov    %eax,%edi
ffffffff80107432:	e8 0d fe ff ff       	callq  ffffffff80107244 <argint>
ffffffff80107437:	85 c0                	test   %eax,%eax
ffffffff80107439:	79 07                	jns    ffffffff80107442 <argfd+0x2f>
    return -1;
ffffffff8010743b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107440:	eb 62                	jmp    ffffffff801074a4 <argfd+0x91>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
ffffffff80107442:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80107445:	85 c0                	test   %eax,%eax
ffffffff80107447:	78 2d                	js     ffffffff80107476 <argfd+0x63>
ffffffff80107449:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff8010744c:	83 f8 0f             	cmp    $0xf,%eax
ffffffff8010744f:	7f 25                	jg     ffffffff80107476 <argfd+0x63>
ffffffff80107451:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80107458:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010745c:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff8010745f:	48 63 d2             	movslq %edx,%rdx
ffffffff80107462:	48 83 c2 08          	add    $0x8,%rdx
ffffffff80107466:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff8010746b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff8010746f:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107474:	75 07                	jne    ffffffff8010747d <argfd+0x6a>
    return -1;
ffffffff80107476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010747b:	eb 27                	jmp    ffffffff801074a4 <argfd+0x91>
  if(pfd)
ffffffff8010747d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffffffff80107482:	74 09                	je     ffffffff8010748d <argfd+0x7a>
    *pfd = fd;
ffffffff80107484:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff80107487:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010748b:	89 10                	mov    %edx,(%rax)
  if(pf)
ffffffff8010748d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffffffff80107492:	74 0b                	je     ffffffff8010749f <argfd+0x8c>
    *pf = f;
ffffffff80107494:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80107498:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff8010749c:	48 89 10             	mov    %rdx,(%rax)
  return 0;
ffffffff8010749f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801074a4:	c9                   	leaveq 
ffffffff801074a5:	c3                   	retq   

ffffffff801074a6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
ffffffff801074a6:	55                   	push   %rbp
ffffffff801074a7:	48 89 e5             	mov    %rsp,%rbp
ffffffff801074aa:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff801074ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffffffff801074b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801074b9:	eb 46                	jmp    ffffffff80107501 <fdalloc+0x5b>
    if(proc->ofile[fd] == 0){
ffffffff801074bb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801074c2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801074c6:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801074c9:	48 63 d2             	movslq %edx,%rdx
ffffffff801074cc:	48 83 c2 08          	add    $0x8,%rdx
ffffffff801074d0:	48 8b 44 d0 08       	mov    0x8(%rax,%rdx,8),%rax
ffffffff801074d5:	48 85 c0             	test   %rax,%rax
ffffffff801074d8:	75 23                	jne    ffffffff801074fd <fdalloc+0x57>
      proc->ofile[fd] = f;
ffffffff801074da:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801074e1:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801074e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801074e8:	48 63 d2             	movslq %edx,%rdx
ffffffff801074eb:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
ffffffff801074ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff801074f3:	48 89 54 c8 08       	mov    %rdx,0x8(%rax,%rcx,8)
      return fd;
ffffffff801074f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801074fb:	eb 0f                	jmp    ffffffff8010750c <fdalloc+0x66>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
ffffffff801074fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80107501:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
ffffffff80107505:	7e b4                	jle    ffffffff801074bb <fdalloc+0x15>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
ffffffff80107507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff8010750c:	c9                   	leaveq 
ffffffff8010750d:	c3                   	retq   

ffffffff8010750e <sys_dup>:

int
sys_dup(void)
{
ffffffff8010750e:	55                   	push   %rbp
ffffffff8010750f:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107512:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
ffffffff80107516:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff8010751a:	48 89 c2             	mov    %rax,%rdx
ffffffff8010751d:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80107522:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107527:	e8 e7 fe ff ff       	callq  ffffffff80107413 <argfd>
ffffffff8010752c:	85 c0                	test   %eax,%eax
ffffffff8010752e:	79 07                	jns    ffffffff80107537 <sys_dup+0x29>
    return -1;
ffffffff80107530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107535:	eb 2b                	jmp    ffffffff80107562 <sys_dup+0x54>
  if((fd=fdalloc(f)) < 0)
ffffffff80107537:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010753b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010753e:	e8 63 ff ff ff       	callq  ffffffff801074a6 <fdalloc>
ffffffff80107543:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80107546:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff8010754a:	79 07                	jns    ffffffff80107553 <sys_dup+0x45>
    return -1;
ffffffff8010754c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107551:	eb 0f                	jmp    ffffffff80107562 <sys_dup+0x54>
  filedup(f);
ffffffff80107553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107557:	48 89 c7             	mov    %rax,%rdi
ffffffff8010755a:	e8 2f a9 ff ff       	callq  ffffffff80101e8e <filedup>
  return fd;
ffffffff8010755f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff80107562:	c9                   	leaveq 
ffffffff80107563:	c3                   	retq   

ffffffff80107564 <sys_read>:

int
sys_read(void)
{
ffffffff80107564:	55                   	push   %rbp
ffffffff80107565:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107568:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffffffff8010756c:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffffffff80107570:	48 89 c2             	mov    %rax,%rdx
ffffffff80107573:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80107578:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff8010757d:	e8 91 fe ff ff       	callq  ffffffff80107413 <argfd>
ffffffff80107582:	85 c0                	test   %eax,%eax
ffffffff80107584:	78 2d                	js     ffffffff801075b3 <sys_read+0x4f>
ffffffff80107586:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffffffff8010758a:	48 89 c6             	mov    %rax,%rsi
ffffffff8010758d:	bf 02 00 00 00       	mov    $0x2,%edi
ffffffff80107592:	e8 ad fc ff ff       	callq  ffffffff80107244 <argint>
ffffffff80107597:	85 c0                	test   %eax,%eax
ffffffff80107599:	78 18                	js     ffffffff801075b3 <sys_read+0x4f>
ffffffff8010759b:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff8010759e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffffffff801075a2:	48 89 c6             	mov    %rax,%rsi
ffffffff801075a5:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801075aa:	e8 e7 fc ff ff       	callq  ffffffff80107296 <argptr>
ffffffff801075af:	85 c0                	test   %eax,%eax
ffffffff801075b1:	79 07                	jns    ffffffff801075ba <sys_read+0x56>
    return -1;
ffffffff801075b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801075b8:	eb 16                	jmp    ffffffff801075d0 <sys_read+0x6c>
  return fileread(f, p, n);
ffffffff801075ba:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff801075bd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffffffff801075c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801075c5:	48 89 ce             	mov    %rcx,%rsi
ffffffff801075c8:	48 89 c7             	mov    %rax,%rdi
ffffffff801075cb:	e8 61 aa ff ff       	callq  ffffffff80102031 <fileread>
}
ffffffff801075d0:	c9                   	leaveq 
ffffffff801075d1:	c3                   	retq   

ffffffff801075d2 <sys_write>:

int
sys_write(void)
{
ffffffff801075d2:	55                   	push   %rbp
ffffffff801075d3:	48 89 e5             	mov    %rsp,%rbp
ffffffff801075d6:	48 83 ec 20          	sub    $0x20,%rsp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
ffffffff801075da:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffffffff801075de:	48 89 c2             	mov    %rax,%rdx
ffffffff801075e1:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801075e6:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801075eb:	e8 23 fe ff ff       	callq  ffffffff80107413 <argfd>
ffffffff801075f0:	85 c0                	test   %eax,%eax
ffffffff801075f2:	78 2d                	js     ffffffff80107621 <sys_write+0x4f>
ffffffff801075f4:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
ffffffff801075f8:	48 89 c6             	mov    %rax,%rsi
ffffffff801075fb:	bf 02 00 00 00       	mov    $0x2,%edi
ffffffff80107600:	e8 3f fc ff ff       	callq  ffffffff80107244 <argint>
ffffffff80107605:	85 c0                	test   %eax,%eax
ffffffff80107607:	78 18                	js     ffffffff80107621 <sys_write+0x4f>
ffffffff80107609:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff8010760c:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffffffff80107610:	48 89 c6             	mov    %rax,%rsi
ffffffff80107613:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80107618:	e8 79 fc ff ff       	callq  ffffffff80107296 <argptr>
ffffffff8010761d:	85 c0                	test   %eax,%eax
ffffffff8010761f:	79 07                	jns    ffffffff80107628 <sys_write+0x56>
    return -1;
ffffffff80107621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107626:	eb 16                	jmp    ffffffff8010763e <sys_write+0x6c>
  return filewrite(f, p, n);
ffffffff80107628:	8b 55 f4             	mov    -0xc(%rbp),%edx
ffffffff8010762b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffffffff8010762f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107633:	48 89 ce             	mov    %rcx,%rsi
ffffffff80107636:	48 89 c7             	mov    %rax,%rdi
ffffffff80107639:	e8 bb aa ff ff       	callq  ffffffff801020f9 <filewrite>
}
ffffffff8010763e:	c9                   	leaveq 
ffffffff8010763f:	c3                   	retq   

ffffffff80107640 <sys_close>:

int
sys_close(void)
{
ffffffff80107640:	55                   	push   %rbp
ffffffff80107641:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107644:	48 83 ec 10          	sub    $0x10,%rsp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
ffffffff80107648:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
ffffffff8010764c:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffffffff80107650:	48 89 c6             	mov    %rax,%rsi
ffffffff80107653:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107658:	e8 b6 fd ff ff       	callq  ffffffff80107413 <argfd>
ffffffff8010765d:	85 c0                	test   %eax,%eax
ffffffff8010765f:	79 07                	jns    ffffffff80107668 <sys_close+0x28>
    return -1;
ffffffff80107661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107666:	eb 2f                	jmp    ffffffff80107697 <sys_close+0x57>
  proc->ofile[fd] = 0;
ffffffff80107668:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010766f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80107673:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80107676:	48 63 d2             	movslq %edx,%rdx
ffffffff80107679:	48 83 c2 08          	add    $0x8,%rdx
ffffffff8010767d:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffffffff80107684:	00 00 
  fileclose(f);
ffffffff80107686:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010768a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010768d:	e8 4e a8 ff ff       	callq  ffffffff80101ee0 <fileclose>
  return 0;
ffffffff80107692:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107697:	c9                   	leaveq 
ffffffff80107698:	c3                   	retq   

ffffffff80107699 <sys_fstat>:

int
sys_fstat(void)
{
ffffffff80107699:	55                   	push   %rbp
ffffffff8010769a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010769d:	48 83 ec 10          	sub    $0x10,%rsp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
ffffffff801076a1:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffffffff801076a5:	48 89 c2             	mov    %rax,%rdx
ffffffff801076a8:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801076ad:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801076b2:	e8 5c fd ff ff       	callq  ffffffff80107413 <argfd>
ffffffff801076b7:	85 c0                	test   %eax,%eax
ffffffff801076b9:	78 1a                	js     ffffffff801076d5 <sys_fstat+0x3c>
ffffffff801076bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff801076bf:	ba 1c 00 00 00       	mov    $0x1c,%edx
ffffffff801076c4:	48 89 c6             	mov    %rax,%rsi
ffffffff801076c7:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801076cc:	e8 c5 fb ff ff       	callq  ffffffff80107296 <argptr>
ffffffff801076d1:	85 c0                	test   %eax,%eax
ffffffff801076d3:	79 07                	jns    ffffffff801076dc <sys_fstat+0x43>
    return -1;
ffffffff801076d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801076da:	eb 13                	jmp    ffffffff801076ef <sys_fstat+0x56>
  return filestat(f, st);
ffffffff801076dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
ffffffff801076e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801076e4:	48 89 d6             	mov    %rdx,%rsi
ffffffff801076e7:	48 89 c7             	mov    %rax,%rdi
ffffffff801076ea:	e8 e2 a8 ff ff       	callq  ffffffff80101fd1 <filestat>
}
ffffffff801076ef:	c9                   	leaveq 
ffffffff801076f0:	c3                   	retq   

ffffffff801076f1 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
ffffffff801076f1:	55                   	push   %rbp
ffffffff801076f2:	48 89 e5             	mov    %rsp,%rbp
ffffffff801076f5:	48 83 ec 30          	sub    $0x30,%rsp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
ffffffff801076f9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffffffff801076fd:	48 89 c6             	mov    %rax,%rsi
ffffffff80107700:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107705:	e8 0d fc ff ff       	callq  ffffffff80107317 <argstr>
ffffffff8010770a:	85 c0                	test   %eax,%eax
ffffffff8010770c:	78 15                	js     ffffffff80107723 <sys_link+0x32>
ffffffff8010770e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
ffffffff80107712:	48 89 c6             	mov    %rax,%rsi
ffffffff80107715:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff8010771a:	e8 f8 fb ff ff       	callq  ffffffff80107317 <argstr>
ffffffff8010771f:	85 c0                	test   %eax,%eax
ffffffff80107721:	79 0a                	jns    ffffffff8010772d <sys_link+0x3c>
    return -1;
ffffffff80107723:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107728:	e9 74 01 00 00       	jmpq   ffffffff801078a1 <sys_link+0x1b0>

  begin_op();
ffffffff8010772d:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107732:	e8 8a cf ff ff       	callq  ffffffff801046c1 <begin_op>
  if((ip = namei(old)) == 0){
ffffffff80107737:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010773b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010773e:	e8 2d be ff ff       	callq  ffffffff80103570 <namei>
ffffffff80107743:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107747:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff8010774c:	75 14                	jne    ffffffff80107762 <sys_link+0x71>
    end_op();
ffffffff8010774e:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107753:	e8 eb cf ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010775d:	e9 3f 01 00 00       	jmpq   ffffffff801078a1 <sys_link+0x1b0>
  }

  ilock(ip);
ffffffff80107762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107766:	48 89 c7             	mov    %rax,%rdi
ffffffff80107769:	e8 d6 b0 ff ff       	callq  ffffffff80102844 <ilock>
  if(ip->type == T_DIR){
ffffffff8010776e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107772:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80107776:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff8010777a:	75 20                	jne    ffffffff8010779c <sys_link+0xab>
    iunlockput(ip);
ffffffff8010777c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107780:	48 89 c7             	mov    %rax,%rdi
ffffffff80107783:	e8 b2 b3 ff ff       	callq  ffffffff80102b3a <iunlockput>
    end_op();
ffffffff80107788:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010778d:	e8 b1 cf ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107792:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107797:	e9 05 01 00 00       	jmpq   ffffffff801078a1 <sys_link+0x1b0>
  }

  ip->nlink++;
ffffffff8010779c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801077a0:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff801077a4:	83 c0 01             	add    $0x1,%eax
ffffffff801077a7:	89 c2                	mov    %eax,%edx
ffffffff801077a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801077ad:	66 89 50 16          	mov    %dx,0x16(%rax)
  iupdate(ip);
ffffffff801077b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801077b5:	48 89 c7             	mov    %rax,%rdi
ffffffff801077b8:	e8 7b ae ff ff       	callq  ffffffff80102638 <iupdate>
  iunlock(ip);
ffffffff801077bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801077c1:	48 89 c7             	mov    %rax,%rdi
ffffffff801077c4:	e8 1a b2 ff ff       	callq  ffffffff801029e3 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
ffffffff801077c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801077cd:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffffffff801077d1:	48 89 d6             	mov    %rdx,%rsi
ffffffff801077d4:	48 89 c7             	mov    %rax,%rdi
ffffffff801077d7:	e8 b7 bd ff ff       	callq  ffffffff80103593 <nameiparent>
ffffffff801077dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff801077e0:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff801077e5:	74 71                	je     ffffffff80107858 <sys_link+0x167>
    goto bad;
  ilock(dp);
ffffffff801077e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801077eb:	48 89 c7             	mov    %rax,%rdi
ffffffff801077ee:	e8 51 b0 ff ff       	callq  ffffffff80102844 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
ffffffff801077f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801077f7:	8b 10                	mov    (%rax),%edx
ffffffff801077f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801077fd:	8b 00                	mov    (%rax),%eax
ffffffff801077ff:	39 c2                	cmp    %eax,%edx
ffffffff80107801:	75 1e                	jne    ffffffff80107821 <sys_link+0x130>
ffffffff80107803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107807:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff8010780a:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
ffffffff8010780e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107812:	48 89 ce             	mov    %rcx,%rsi
ffffffff80107815:	48 89 c7             	mov    %rax,%rdi
ffffffff80107818:	e8 5a ba ff ff       	callq  ffffffff80103277 <dirlink>
ffffffff8010781d:	85 c0                	test   %eax,%eax
ffffffff8010781f:	79 0e                	jns    ffffffff8010782f <sys_link+0x13e>
    iunlockput(dp);
ffffffff80107821:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107825:	48 89 c7             	mov    %rax,%rdi
ffffffff80107828:	e8 0d b3 ff ff       	callq  ffffffff80102b3a <iunlockput>
    goto bad;
ffffffff8010782d:	eb 2a                	jmp    ffffffff80107859 <sys_link+0x168>
  }
  iunlockput(dp);
ffffffff8010782f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107833:	48 89 c7             	mov    %rax,%rdi
ffffffff80107836:	e8 ff b2 ff ff       	callq  ffffffff80102b3a <iunlockput>
  iput(ip);
ffffffff8010783b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010783f:	48 89 c7             	mov    %rax,%rdi
ffffffff80107842:	e8 0e b2 ff ff       	callq  ffffffff80102a55 <iput>

  end_op();
ffffffff80107847:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010784c:	e8 f2 ce ff ff       	callq  ffffffff80104743 <end_op>

  return 0;
ffffffff80107851:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107856:	eb 49                	jmp    ffffffff801078a1 <sys_link+0x1b0>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
ffffffff80107858:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
ffffffff80107859:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010785d:	48 89 c7             	mov    %rax,%rdi
ffffffff80107860:	e8 df af ff ff       	callq  ffffffff80102844 <ilock>
  ip->nlink--;
ffffffff80107865:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107869:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff8010786d:	83 e8 01             	sub    $0x1,%eax
ffffffff80107870:	89 c2                	mov    %eax,%edx
ffffffff80107872:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107876:	66 89 50 16          	mov    %dx,0x16(%rax)
  iupdate(ip);
ffffffff8010787a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010787e:	48 89 c7             	mov    %rax,%rdi
ffffffff80107881:	e8 b2 ad ff ff       	callq  ffffffff80102638 <iupdate>
  iunlockput(ip);
ffffffff80107886:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010788a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010788d:	e8 a8 b2 ff ff       	callq  ffffffff80102b3a <iunlockput>
  end_op();
ffffffff80107892:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107897:	e8 a7 ce ff ff       	callq  ffffffff80104743 <end_op>
  return -1;
ffffffff8010789c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff801078a1:	c9                   	leaveq 
ffffffff801078a2:	c3                   	retq   

ffffffff801078a3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
ffffffff801078a3:	55                   	push   %rbp
ffffffff801078a4:	48 89 e5             	mov    %rsp,%rbp
ffffffff801078a7:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff801078ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffffffff801078af:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%rbp)
ffffffff801078b6:	eb 42                	jmp    ffffffff801078fa <isdirempty+0x57>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffffffff801078b8:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff801078bb:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffffffff801078bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801078c3:	b9 10 00 00 00       	mov    $0x10,%ecx
ffffffff801078c8:	48 89 c7             	mov    %rax,%rdi
ffffffff801078cb:	e8 7f b5 ff ff       	callq  ffffffff80102e4f <readi>
ffffffff801078d0:	83 f8 10             	cmp    $0x10,%eax
ffffffff801078d3:	74 0c                	je     ffffffff801078e1 <isdirempty+0x3e>
      panic("isdirempty: readi");
ffffffff801078d5:	48 c7 c7 24 ac 10 80 	mov    $0xffffffff8010ac24,%rdi
ffffffff801078dc:	e8 1e 90 ff ff       	callq  ffffffff801008ff <panic>
    if(de.inum != 0)
ffffffff801078e1:	0f b7 45 e0          	movzwl -0x20(%rbp),%eax
ffffffff801078e5:	66 85 c0             	test   %ax,%ax
ffffffff801078e8:	74 07                	je     ffffffff801078f1 <isdirempty+0x4e>
      return 0;
ffffffff801078ea:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801078ef:	eb 1c                	jmp    ffffffff8010790d <isdirempty+0x6a>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
ffffffff801078f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801078f4:	83 c0 10             	add    $0x10,%eax
ffffffff801078f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff801078fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff801078fe:	8b 50 20             	mov    0x20(%rax),%edx
ffffffff80107901:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80107904:	39 c2                	cmp    %eax,%edx
ffffffff80107906:	77 b0                	ja     ffffffff801078b8 <isdirempty+0x15>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
ffffffff80107908:	b8 01 00 00 00       	mov    $0x1,%eax
}
ffffffff8010790d:	c9                   	leaveq 
ffffffff8010790e:	c3                   	retq   

ffffffff8010790f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
ffffffff8010790f:	55                   	push   %rbp
ffffffff80107910:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107913:	48 83 ec 40          	sub    $0x40,%rsp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
ffffffff80107917:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
ffffffff8010791b:	48 89 c6             	mov    %rax,%rsi
ffffffff8010791e:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107923:	e8 ef f9 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff80107928:	85 c0                	test   %eax,%eax
ffffffff8010792a:	79 0a                	jns    ffffffff80107936 <sys_unlink+0x27>
    return -1;
ffffffff8010792c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107931:	e9 cc 01 00 00       	jmpq   ffffffff80107b02 <sys_unlink+0x1f3>

  begin_op();
ffffffff80107936:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010793b:	e8 81 cd ff ff       	callq  ffffffff801046c1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
ffffffff80107940:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80107944:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
ffffffff80107948:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010794b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010794e:	e8 40 bc ff ff       	callq  ffffffff80103593 <nameiparent>
ffffffff80107953:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107957:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff8010795c:	75 14                	jne    ffffffff80107972 <sys_unlink+0x63>
    end_op();
ffffffff8010795e:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107963:	e8 db cd ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010796d:	e9 90 01 00 00       	jmpq   ffffffff80107b02 <sys_unlink+0x1f3>
  }

  ilock(dp);
ffffffff80107972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107976:	48 89 c7             	mov    %rax,%rdi
ffffffff80107979:	e8 c6 ae ff ff       	callq  ffffffff80102844 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
ffffffff8010797e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffffffff80107982:	48 c7 c6 36 ac 10 80 	mov    $0xffffffff8010ac36,%rsi
ffffffff80107989:	48 89 c7             	mov    %rax,%rdi
ffffffff8010798c:	e8 eb b7 ff ff       	callq  ffffffff8010317c <namecmp>
ffffffff80107991:	85 c0                	test   %eax,%eax
ffffffff80107993:	0f 84 4e 01 00 00    	je     ffffffff80107ae7 <sys_unlink+0x1d8>
ffffffff80107999:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
ffffffff8010799d:	48 c7 c6 38 ac 10 80 	mov    $0xffffffff8010ac38,%rsi
ffffffff801079a4:	48 89 c7             	mov    %rax,%rdi
ffffffff801079a7:	e8 d0 b7 ff ff       	callq  ffffffff8010317c <namecmp>
ffffffff801079ac:	85 c0                	test   %eax,%eax
ffffffff801079ae:	0f 84 33 01 00 00    	je     ffffffff80107ae7 <sys_unlink+0x1d8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
ffffffff801079b4:	48 8d 55 c4          	lea    -0x3c(%rbp),%rdx
ffffffff801079b8:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
ffffffff801079bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801079c0:	48 89 ce             	mov    %rcx,%rsi
ffffffff801079c3:	48 89 c7             	mov    %rax,%rdi
ffffffff801079c6:	e8 db b7 ff ff       	callq  ffffffff801031a6 <dirlookup>
ffffffff801079cb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff801079cf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff801079d4:	0f 84 0c 01 00 00    	je     ffffffff80107ae6 <sys_unlink+0x1d7>
    goto bad;
  ilock(ip);
ffffffff801079da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801079de:	48 89 c7             	mov    %rax,%rdi
ffffffff801079e1:	e8 5e ae ff ff       	callq  ffffffff80102844 <ilock>

  if(ip->nlink < 1)
ffffffff801079e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801079ea:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff801079ee:	66 85 c0             	test   %ax,%ax
ffffffff801079f1:	7f 0c                	jg     ffffffff801079ff <sys_unlink+0xf0>
    panic("unlink: nlink < 1");
ffffffff801079f3:	48 c7 c7 3b ac 10 80 	mov    $0xffffffff8010ac3b,%rdi
ffffffff801079fa:	e8 00 8f ff ff       	callq  ffffffff801008ff <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
ffffffff801079ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107a03:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80107a07:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff80107a0b:	75 21                	jne    ffffffff80107a2e <sys_unlink+0x11f>
ffffffff80107a0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107a11:	48 89 c7             	mov    %rax,%rdi
ffffffff80107a14:	e8 8a fe ff ff       	callq  ffffffff801078a3 <isdirempty>
ffffffff80107a19:	85 c0                	test   %eax,%eax
ffffffff80107a1b:	75 11                	jne    ffffffff80107a2e <sys_unlink+0x11f>
    iunlockput(ip);
ffffffff80107a1d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107a21:	48 89 c7             	mov    %rax,%rdi
ffffffff80107a24:	e8 11 b1 ff ff       	callq  ffffffff80102b3a <iunlockput>
    goto bad;
ffffffff80107a29:	e9 b9 00 00 00       	jmpq   ffffffff80107ae7 <sys_unlink+0x1d8>
  }

  memset(&de, 0, sizeof(de));
ffffffff80107a2e:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff80107a32:	ba 10 00 00 00       	mov    $0x10,%edx
ffffffff80107a37:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80107a3c:	48 89 c7             	mov    %rax,%rdi
ffffffff80107a3f:	e8 ce f2 ff ff       	callq  ffffffff80106d12 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
ffffffff80107a44:	8b 55 c4             	mov    -0x3c(%rbp),%edx
ffffffff80107a47:	48 8d 75 e0          	lea    -0x20(%rbp),%rsi
ffffffff80107a4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107a4f:	b9 10 00 00 00       	mov    $0x10,%ecx
ffffffff80107a54:	48 89 c7             	mov    %rax,%rdi
ffffffff80107a57:	e8 73 b5 ff ff       	callq  ffffffff80102fcf <writei>
ffffffff80107a5c:	83 f8 10             	cmp    $0x10,%eax
ffffffff80107a5f:	74 0c                	je     ffffffff80107a6d <sys_unlink+0x15e>
    panic("unlink: writei");
ffffffff80107a61:	48 c7 c7 4d ac 10 80 	mov    $0xffffffff8010ac4d,%rdi
ffffffff80107a68:	e8 92 8e ff ff       	callq  ffffffff801008ff <panic>
  if(ip->type == T_DIR){
ffffffff80107a6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107a71:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80107a75:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff80107a79:	75 21                	jne    ffffffff80107a9c <sys_unlink+0x18d>
    dp->nlink--;
ffffffff80107a7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107a7f:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff80107a83:	83 e8 01             	sub    $0x1,%eax
ffffffff80107a86:	89 c2                	mov    %eax,%edx
ffffffff80107a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107a8c:	66 89 50 16          	mov    %dx,0x16(%rax)
    iupdate(dp);
ffffffff80107a90:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107a94:	48 89 c7             	mov    %rax,%rdi
ffffffff80107a97:	e8 9c ab ff ff       	callq  ffffffff80102638 <iupdate>
  }
  iunlockput(dp);
ffffffff80107a9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107aa0:	48 89 c7             	mov    %rax,%rdi
ffffffff80107aa3:	e8 92 b0 ff ff       	callq  ffffffff80102b3a <iunlockput>

  ip->nlink--;
ffffffff80107aa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107aac:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff80107ab0:	83 e8 01             	sub    $0x1,%eax
ffffffff80107ab3:	89 c2                	mov    %eax,%edx
ffffffff80107ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107ab9:	66 89 50 16          	mov    %dx,0x16(%rax)
  iupdate(ip);
ffffffff80107abd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107ac1:	48 89 c7             	mov    %rax,%rdi
ffffffff80107ac4:	e8 6f ab ff ff       	callq  ffffffff80102638 <iupdate>
  iunlockput(ip);
ffffffff80107ac9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107acd:	48 89 c7             	mov    %rax,%rdi
ffffffff80107ad0:	e8 65 b0 ff ff       	callq  ffffffff80102b3a <iunlockput>

  end_op();
ffffffff80107ad5:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107ada:	e8 64 cc ff ff       	callq  ffffffff80104743 <end_op>

  return 0;
ffffffff80107adf:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107ae4:	eb 1c                	jmp    ffffffff80107b02 <sys_unlink+0x1f3>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
ffffffff80107ae6:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
ffffffff80107ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107aeb:	48 89 c7             	mov    %rax,%rdi
ffffffff80107aee:	e8 47 b0 ff ff       	callq  ffffffff80102b3a <iunlockput>
  end_op();
ffffffff80107af3:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107af8:	e8 46 cc ff ff       	callq  ffffffff80104743 <end_op>
  return -1;
ffffffff80107afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
ffffffff80107b02:	c9                   	leaveq 
ffffffff80107b03:	c3                   	retq   

ffffffff80107b04 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
ffffffff80107b04:	55                   	push   %rbp
ffffffff80107b05:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107b08:	48 83 ec 50          	sub    $0x50,%rsp
ffffffff80107b0c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffffffff80107b10:	89 c8                	mov    %ecx,%eax
ffffffff80107b12:	66 89 75 c4          	mov    %si,-0x3c(%rbp)
ffffffff80107b16:	66 89 55 c0          	mov    %dx,-0x40(%rbp)
ffffffff80107b1a:	66 89 45 bc          	mov    %ax,-0x44(%rbp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
ffffffff80107b1e:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
ffffffff80107b22:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80107b26:	48 89 d6             	mov    %rdx,%rsi
ffffffff80107b29:	48 89 c7             	mov    %rax,%rdi
ffffffff80107b2c:	e8 62 ba ff ff       	callq  ffffffff80103593 <nameiparent>
ffffffff80107b31:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107b35:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107b3a:	75 0a                	jne    ffffffff80107b46 <create+0x42>
    return 0;
ffffffff80107b3c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107b41:	e9 88 01 00 00       	jmpq   ffffffff80107cce <create+0x1ca>
  ilock(dp);
ffffffff80107b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107b4a:	48 89 c7             	mov    %rax,%rdi
ffffffff80107b4d:	e8 f2 ac ff ff       	callq  ffffffff80102844 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
ffffffff80107b52:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
ffffffff80107b56:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
ffffffff80107b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107b5e:	48 89 ce             	mov    %rcx,%rsi
ffffffff80107b61:	48 89 c7             	mov    %rax,%rdi
ffffffff80107b64:	e8 3d b6 ff ff       	callq  ffffffff801031a6 <dirlookup>
ffffffff80107b69:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80107b6d:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80107b72:	74 4c                	je     ffffffff80107bc0 <create+0xbc>
    iunlockput(dp);
ffffffff80107b74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107b78:	48 89 c7             	mov    %rax,%rdi
ffffffff80107b7b:	e8 ba af ff ff       	callq  ffffffff80102b3a <iunlockput>
    ilock(ip);
ffffffff80107b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107b84:	48 89 c7             	mov    %rax,%rdi
ffffffff80107b87:	e8 b8 ac ff ff       	callq  ffffffff80102844 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
ffffffff80107b8c:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%rbp)
ffffffff80107b91:	75 17                	jne    ffffffff80107baa <create+0xa6>
ffffffff80107b93:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107b97:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80107b9b:	66 83 f8 02          	cmp    $0x2,%ax
ffffffff80107b9f:	75 09                	jne    ffffffff80107baa <create+0xa6>
      return ip;
ffffffff80107ba1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107ba5:	e9 24 01 00 00       	jmpq   ffffffff80107cce <create+0x1ca>
    iunlockput(ip);
ffffffff80107baa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107bae:	48 89 c7             	mov    %rax,%rdi
ffffffff80107bb1:	e8 84 af ff ff       	callq  ffffffff80102b3a <iunlockput>
    return 0;
ffffffff80107bb6:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107bbb:	e9 0e 01 00 00       	jmpq   ffffffff80107cce <create+0x1ca>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
ffffffff80107bc0:	0f bf 55 c4          	movswl -0x3c(%rbp),%edx
ffffffff80107bc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107bc8:	8b 00                	mov    (%rax),%eax
ffffffff80107bca:	89 d6                	mov    %edx,%esi
ffffffff80107bcc:	89 c7                	mov    %eax,%edi
ffffffff80107bce:	e8 7e a9 ff ff       	callq  ffffffff80102551 <ialloc>
ffffffff80107bd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80107bd7:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80107bdc:	75 0c                	jne    ffffffff80107bea <create+0xe6>
    panic("create: ialloc");
ffffffff80107bde:	48 c7 c7 5c ac 10 80 	mov    $0xffffffff8010ac5c,%rdi
ffffffff80107be5:	e8 15 8d ff ff       	callq  ffffffff801008ff <panic>

  ilock(ip);
ffffffff80107bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107bee:	48 89 c7             	mov    %rax,%rdi
ffffffff80107bf1:	e8 4e ac ff ff       	callq  ffffffff80102844 <ilock>
  ip->major = major;
ffffffff80107bf6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107bfa:	0f b7 55 c0          	movzwl -0x40(%rbp),%edx
ffffffff80107bfe:	66 89 50 12          	mov    %dx,0x12(%rax)
  ip->minor = minor;
ffffffff80107c02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c06:	0f b7 55 bc          	movzwl -0x44(%rbp),%edx
ffffffff80107c0a:	66 89 50 14          	mov    %dx,0x14(%rax)
  ip->nlink = 1;
ffffffff80107c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c12:	66 c7 40 16 01 00    	movw   $0x1,0x16(%rax)
  iupdate(ip);
ffffffff80107c18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c1c:	48 89 c7             	mov    %rax,%rdi
ffffffff80107c1f:	e8 14 aa ff ff       	callq  ffffffff80102638 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
ffffffff80107c24:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%rbp)
ffffffff80107c29:	75 69                	jne    ffffffff80107c94 <create+0x190>
    dp->nlink++;  // for ".."
ffffffff80107c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107c2f:	0f b7 40 16          	movzwl 0x16(%rax),%eax
ffffffff80107c33:	83 c0 01             	add    $0x1,%eax
ffffffff80107c36:	89 c2                	mov    %eax,%edx
ffffffff80107c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107c3c:	66 89 50 16          	mov    %dx,0x16(%rax)
    iupdate(dp);
ffffffff80107c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107c44:	48 89 c7             	mov    %rax,%rdi
ffffffff80107c47:	e8 ec a9 ff ff       	callq  ffffffff80102638 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
ffffffff80107c4c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c50:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff80107c53:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c57:	48 c7 c6 36 ac 10 80 	mov    $0xffffffff8010ac36,%rsi
ffffffff80107c5e:	48 89 c7             	mov    %rax,%rdi
ffffffff80107c61:	e8 11 b6 ff ff       	callq  ffffffff80103277 <dirlink>
ffffffff80107c66:	85 c0                	test   %eax,%eax
ffffffff80107c68:	78 1e                	js     ffffffff80107c88 <create+0x184>
ffffffff80107c6a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107c6e:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff80107c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c75:	48 c7 c6 38 ac 10 80 	mov    $0xffffffff8010ac38,%rsi
ffffffff80107c7c:	48 89 c7             	mov    %rax,%rdi
ffffffff80107c7f:	e8 f3 b5 ff ff       	callq  ffffffff80103277 <dirlink>
ffffffff80107c84:	85 c0                	test   %eax,%eax
ffffffff80107c86:	79 0c                	jns    ffffffff80107c94 <create+0x190>
      panic("create dots");
ffffffff80107c88:	48 c7 c7 6b ac 10 80 	mov    $0xffffffff8010ac6b,%rdi
ffffffff80107c8f:	e8 6b 8c ff ff       	callq  ffffffff801008ff <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
ffffffff80107c94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107c98:	8b 50 04             	mov    0x4(%rax),%edx
ffffffff80107c9b:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
ffffffff80107c9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107ca3:	48 89 ce             	mov    %rcx,%rsi
ffffffff80107ca6:	48 89 c7             	mov    %rax,%rdi
ffffffff80107ca9:	e8 c9 b5 ff ff       	callq  ffffffff80103277 <dirlink>
ffffffff80107cae:	85 c0                	test   %eax,%eax
ffffffff80107cb0:	79 0c                	jns    ffffffff80107cbe <create+0x1ba>
    panic("create: dirlink");
ffffffff80107cb2:	48 c7 c7 77 ac 10 80 	mov    $0xffffffff8010ac77,%rdi
ffffffff80107cb9:	e8 41 8c ff ff       	callq  ffffffff801008ff <panic>

  iunlockput(dp);
ffffffff80107cbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107cc2:	48 89 c7             	mov    %rax,%rdi
ffffffff80107cc5:	e8 70 ae ff ff       	callq  ffffffff80102b3a <iunlockput>

  return ip;
ffffffff80107cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
ffffffff80107cce:	c9                   	leaveq 
ffffffff80107ccf:	c3                   	retq   

ffffffff80107cd0 <sys_open>:

int
sys_open(void)
{
ffffffff80107cd0:	55                   	push   %rbp
ffffffff80107cd1:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107cd4:	48 83 ec 30          	sub    $0x30,%rsp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
ffffffff80107cd8:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff80107cdc:	48 89 c6             	mov    %rax,%rsi
ffffffff80107cdf:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107ce4:	e8 2e f6 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff80107ce9:	85 c0                	test   %eax,%eax
ffffffff80107ceb:	78 15                	js     ffffffff80107d02 <sys_open+0x32>
ffffffff80107ced:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
ffffffff80107cf1:	48 89 c6             	mov    %rax,%rsi
ffffffff80107cf4:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80107cf9:	e8 46 f5 ff ff       	callq  ffffffff80107244 <argint>
ffffffff80107cfe:	85 c0                	test   %eax,%eax
ffffffff80107d00:	79 0a                	jns    ffffffff80107d0c <sys_open+0x3c>
    return -1;
ffffffff80107d02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107d07:	e9 8c 01 00 00       	jmpq   ffffffff80107e98 <sys_open+0x1c8>

  begin_op();
ffffffff80107d0c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107d11:	e8 ab c9 ff ff       	callq  ffffffff801046c1 <begin_op>

  if(omode & O_CREATE){
ffffffff80107d16:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80107d19:	25 00 02 00 00       	and    $0x200,%eax
ffffffff80107d1e:	85 c0                	test   %eax,%eax
ffffffff80107d20:	74 3e                	je     ffffffff80107d60 <sys_open+0x90>
    ip = create(path, T_FILE, 0, 0);
ffffffff80107d22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80107d26:	b9 00 00 00 00       	mov    $0x0,%ecx
ffffffff80107d2b:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80107d30:	be 02 00 00 00       	mov    $0x2,%esi
ffffffff80107d35:	48 89 c7             	mov    %rax,%rdi
ffffffff80107d38:	e8 c7 fd ff ff       	callq  ffffffff80107b04 <create>
ffffffff80107d3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(ip == 0){
ffffffff80107d41:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107d46:	0f 85 80 00 00 00    	jne    ffffffff80107dcc <sys_open+0xfc>
      end_op();
ffffffff80107d4c:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107d51:	e8 ed c9 ff ff       	callq  ffffffff80104743 <end_op>
      return -1;
ffffffff80107d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107d5b:	e9 38 01 00 00       	jmpq   ffffffff80107e98 <sys_open+0x1c8>
    }
  } else {
    if((ip = namei(path)) == 0){
ffffffff80107d60:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80107d64:	48 89 c7             	mov    %rax,%rdi
ffffffff80107d67:	e8 04 b8 ff ff       	callq  ffffffff80103570 <namei>
ffffffff80107d6c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107d70:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107d75:	75 14                	jne    ffffffff80107d8b <sys_open+0xbb>
      end_op();
ffffffff80107d77:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107d7c:	e8 c2 c9 ff ff       	callq  ffffffff80104743 <end_op>
      return -1;
ffffffff80107d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107d86:	e9 0d 01 00 00       	jmpq   ffffffff80107e98 <sys_open+0x1c8>
    }
    ilock(ip);
ffffffff80107d8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107d8f:	48 89 c7             	mov    %rax,%rdi
ffffffff80107d92:	e8 ad aa ff ff       	callq  ffffffff80102844 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
ffffffff80107d97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107d9b:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80107d9f:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff80107da3:	75 27                	jne    ffffffff80107dcc <sys_open+0xfc>
ffffffff80107da5:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80107da8:	85 c0                	test   %eax,%eax
ffffffff80107daa:	74 20                	je     ffffffff80107dcc <sys_open+0xfc>
      iunlockput(ip);
ffffffff80107dac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107db0:	48 89 c7             	mov    %rax,%rdi
ffffffff80107db3:	e8 82 ad ff ff       	callq  ffffffff80102b3a <iunlockput>
      end_op();
ffffffff80107db8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107dbd:	e8 81 c9 ff ff       	callq  ffffffff80104743 <end_op>
      return -1;
ffffffff80107dc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107dc7:	e9 cc 00 00 00       	jmpq   ffffffff80107e98 <sys_open+0x1c8>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
ffffffff80107dcc:	e8 52 a0 ff ff       	callq  ffffffff80101e23 <filealloc>
ffffffff80107dd1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80107dd5:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80107dda:	74 15                	je     ffffffff80107df1 <sys_open+0x121>
ffffffff80107ddc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107de0:	48 89 c7             	mov    %rax,%rdi
ffffffff80107de3:	e8 be f6 ff ff       	callq  ffffffff801074a6 <fdalloc>
ffffffff80107de8:	89 45 ec             	mov    %eax,-0x14(%rbp)
ffffffff80107deb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
ffffffff80107def:	79 30                	jns    ffffffff80107e21 <sys_open+0x151>
    if(f)
ffffffff80107df1:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80107df6:	74 0c                	je     ffffffff80107e04 <sys_open+0x134>
      fileclose(f);
ffffffff80107df8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107dfc:	48 89 c7             	mov    %rax,%rdi
ffffffff80107dff:	e8 dc a0 ff ff       	callq  ffffffff80101ee0 <fileclose>
    iunlockput(ip);
ffffffff80107e04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107e08:	48 89 c7             	mov    %rax,%rdi
ffffffff80107e0b:	e8 2a ad ff ff       	callq  ffffffff80102b3a <iunlockput>
    end_op();
ffffffff80107e10:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107e15:	e8 29 c9 ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107e1f:	eb 77                	jmp    ffffffff80107e98 <sys_open+0x1c8>
  }
  iunlock(ip);
ffffffff80107e21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107e25:	48 89 c7             	mov    %rax,%rdi
ffffffff80107e28:	e8 b6 ab ff ff       	callq  ffffffff801029e3 <iunlock>
  end_op();
ffffffff80107e2d:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107e32:	e8 0c c9 ff ff       	callq  ffffffff80104743 <end_op>

  f->type = FD_INODE;
ffffffff80107e37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107e3b:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
  f->ip = ip;
ffffffff80107e41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107e45:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80107e49:	48 89 50 18          	mov    %rdx,0x18(%rax)
  f->off = 0;
ffffffff80107e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107e51:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%rax)
  f->readable = !(omode & O_WRONLY);
ffffffff80107e58:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80107e5b:	83 e0 01             	and    $0x1,%eax
ffffffff80107e5e:	85 c0                	test   %eax,%eax
ffffffff80107e60:	0f 94 c0             	sete   %al
ffffffff80107e63:	89 c2                	mov    %eax,%edx
ffffffff80107e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107e69:	88 50 08             	mov    %dl,0x8(%rax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
ffffffff80107e6c:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80107e6f:	83 e0 01             	and    $0x1,%eax
ffffffff80107e72:	85 c0                	test   %eax,%eax
ffffffff80107e74:	75 0a                	jne    ffffffff80107e80 <sys_open+0x1b0>
ffffffff80107e76:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff80107e79:	83 e0 02             	and    $0x2,%eax
ffffffff80107e7c:	85 c0                	test   %eax,%eax
ffffffff80107e7e:	74 07                	je     ffffffff80107e87 <sys_open+0x1b7>
ffffffff80107e80:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff80107e85:	eb 05                	jmp    ffffffff80107e8c <sys_open+0x1bc>
ffffffff80107e87:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107e8c:	89 c2                	mov    %eax,%edx
ffffffff80107e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107e92:	88 50 09             	mov    %dl,0x9(%rax)
  return fd;
ffffffff80107e95:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
ffffffff80107e98:	c9                   	leaveq 
ffffffff80107e99:	c3                   	retq   

ffffffff80107e9a <sys_mkdir>:

int
sys_mkdir(void)
{
ffffffff80107e9a:	55                   	push   %rbp
ffffffff80107e9b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107e9e:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffffffff80107ea2:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107ea7:	e8 15 c8 ff ff       	callq  ffffffff801046c1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
ffffffff80107eac:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80107eb0:	48 89 c6             	mov    %rax,%rsi
ffffffff80107eb3:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107eb8:	e8 5a f4 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff80107ebd:	85 c0                	test   %eax,%eax
ffffffff80107ebf:	78 26                	js     ffffffff80107ee7 <sys_mkdir+0x4d>
ffffffff80107ec1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107ec5:	b9 00 00 00 00       	mov    $0x0,%ecx
ffffffff80107eca:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80107ecf:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff80107ed4:	48 89 c7             	mov    %rax,%rdi
ffffffff80107ed7:	e8 28 fc ff ff       	callq  ffffffff80107b04 <create>
ffffffff80107edc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107ee0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107ee5:	75 11                	jne    ffffffff80107ef8 <sys_mkdir+0x5e>
    end_op();
ffffffff80107ee7:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107eec:	e8 52 c8 ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107ef6:	eb 1b                	jmp    ffffffff80107f13 <sys_mkdir+0x79>
  }
  iunlockput(ip);
ffffffff80107ef8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80107efc:	48 89 c7             	mov    %rax,%rdi
ffffffff80107eff:	e8 36 ac ff ff       	callq  ffffffff80102b3a <iunlockput>
  end_op();
ffffffff80107f04:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107f09:	e8 35 c8 ff ff       	callq  ffffffff80104743 <end_op>
  return 0;
ffffffff80107f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107f13:	c9                   	leaveq 
ffffffff80107f14:	c3                   	retq   

ffffffff80107f15 <sys_mknod>:

int
sys_mknod(void)
{
ffffffff80107f15:	55                   	push   %rbp
ffffffff80107f16:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107f19:	48 83 ec 20          	sub    $0x20,%rsp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
ffffffff80107f1d:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107f22:	e8 9a c7 ff ff       	callq  ffffffff801046c1 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
ffffffff80107f27:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffffffff80107f2b:	48 89 c6             	mov    %rax,%rsi
ffffffff80107f2e:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107f33:	e8 df f3 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff80107f38:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80107f3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80107f3f:	78 52                	js     ffffffff80107f93 <sys_mknod+0x7e>
     argint(1, &major) < 0 ||
ffffffff80107f41:	48 8d 45 e4          	lea    -0x1c(%rbp),%rax
ffffffff80107f45:	48 89 c6             	mov    %rax,%rsi
ffffffff80107f48:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff80107f4d:	e8 f2 f2 ff ff       	callq  ffffffff80107244 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
ffffffff80107f52:	85 c0                	test   %eax,%eax
ffffffff80107f54:	78 3d                	js     ffffffff80107f93 <sys_mknod+0x7e>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
ffffffff80107f56:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
ffffffff80107f5a:	48 89 c6             	mov    %rax,%rsi
ffffffff80107f5d:	bf 02 00 00 00       	mov    $0x2,%edi
ffffffff80107f62:	e8 dd f2 ff ff       	callq  ffffffff80107244 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
ffffffff80107f67:	85 c0                	test   %eax,%eax
ffffffff80107f69:	78 28                	js     ffffffff80107f93 <sys_mknod+0x7e>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
ffffffff80107f6b:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffffffff80107f6e:	0f bf c8             	movswl %ax,%ecx
ffffffff80107f71:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80107f74:	0f bf d0             	movswl %ax,%edx
ffffffff80107f77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
ffffffff80107f7b:	be 03 00 00 00       	mov    $0x3,%esi
ffffffff80107f80:	48 89 c7             	mov    %rax,%rdi
ffffffff80107f83:	e8 7c fb ff ff       	callq  ffffffff80107b04 <create>
ffffffff80107f88:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
ffffffff80107f8c:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff80107f91:	75 11                	jne    ffffffff80107fa4 <sys_mknod+0x8f>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
ffffffff80107f93:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107f98:	e8 a6 c7 ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80107f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80107fa2:	eb 1b                	jmp    ffffffff80107fbf <sys_mknod+0xaa>
  }
  iunlockput(ip);
ffffffff80107fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107fa8:	48 89 c7             	mov    %rax,%rdi
ffffffff80107fab:	e8 8a ab ff ff       	callq  ffffffff80102b3a <iunlockput>
  end_op();
ffffffff80107fb0:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107fb5:	e8 89 c7 ff ff       	callq  ffffffff80104743 <end_op>
  return 0;
ffffffff80107fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80107fbf:	c9                   	leaveq 
ffffffff80107fc0:	c3                   	retq   

ffffffff80107fc1 <sys_chdir>:

int
sys_chdir(void)
{
ffffffff80107fc1:	55                   	push   %rbp
ffffffff80107fc2:	48 89 e5             	mov    %rsp,%rbp
ffffffff80107fc5:	48 83 ec 10          	sub    $0x10,%rsp
  char *path;
  struct inode *ip;

  begin_op();
ffffffff80107fc9:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80107fce:	e8 ee c6 ff ff       	callq  ffffffff801046c1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
ffffffff80107fd3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80107fd7:	48 89 c6             	mov    %rax,%rsi
ffffffff80107fda:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80107fdf:	e8 33 f3 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff80107fe4:	85 c0                	test   %eax,%eax
ffffffff80107fe6:	78 17                	js     ffffffff80107fff <sys_chdir+0x3e>
ffffffff80107fe8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80107fec:	48 89 c7             	mov    %rax,%rdi
ffffffff80107fef:	e8 7c b5 ff ff       	callq  ffffffff80103570 <namei>
ffffffff80107ff4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff80107ff8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80107ffd:	75 14                	jne    ffffffff80108013 <sys_chdir+0x52>
    end_op();
ffffffff80107fff:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80108004:	e8 3a c7 ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80108009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010800e:	e9 82 00 00 00       	jmpq   ffffffff80108095 <sys_chdir+0xd4>
  }
  ilock(ip);
ffffffff80108013:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108017:	48 89 c7             	mov    %rax,%rdi
ffffffff8010801a:	e8 25 a8 ff ff       	callq  ffffffff80102844 <ilock>
  if(ip->type != T_DIR){
ffffffff8010801f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108023:	0f b7 40 10          	movzwl 0x10(%rax),%eax
ffffffff80108027:	66 83 f8 01          	cmp    $0x1,%ax
ffffffff8010802b:	74 1d                	je     ffffffff8010804a <sys_chdir+0x89>
    iunlockput(ip);
ffffffff8010802d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108031:	48 89 c7             	mov    %rax,%rdi
ffffffff80108034:	e8 01 ab ff ff       	callq  ffffffff80102b3a <iunlockput>
    end_op();
ffffffff80108039:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010803e:	e8 00 c7 ff ff       	callq  ffffffff80104743 <end_op>
    return -1;
ffffffff80108043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108048:	eb 4b                	jmp    ffffffff80108095 <sys_chdir+0xd4>
  }
  iunlock(ip);
ffffffff8010804a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010804e:	48 89 c7             	mov    %rax,%rdi
ffffffff80108051:	e8 8d a9 ff ff       	callq  ffffffff801029e3 <iunlock>
  iput(proc->cwd);
ffffffff80108056:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010805d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108061:	48 8b 80 c8 00 00 00 	mov    0xc8(%rax),%rax
ffffffff80108068:	48 89 c7             	mov    %rax,%rdi
ffffffff8010806b:	e8 e5 a9 ff ff       	callq  ffffffff80102a55 <iput>
  end_op();
ffffffff80108070:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80108075:	e8 c9 c6 ff ff       	callq  ffffffff80104743 <end_op>
  proc->cwd = ip;
ffffffff8010807a:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80108081:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108085:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80108089:	48 89 90 c8 00 00 00 	mov    %rdx,0xc8(%rax)
  return 0;
ffffffff80108090:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80108095:	c9                   	leaveq 
ffffffff80108096:	c3                   	retq   

ffffffff80108097 <sys_exec>:

int
sys_exec(void)
{
ffffffff80108097:	55                   	push   %rbp
ffffffff80108098:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010809b:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  char *path, *argv[MAXARG];
  int i;
  uintp uargv, uarg;

  if(argstr(0, &path) < 0 || arguintp(1, &uargv) < 0){
ffffffff801080a2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff801080a6:	48 89 c6             	mov    %rax,%rsi
ffffffff801080a9:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801080ae:	e8 64 f2 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff801080b3:	85 c0                	test   %eax,%eax
ffffffff801080b5:	78 18                	js     ffffffff801080cf <sys_exec+0x38>
ffffffff801080b7:	48 8d 85 e8 fe ff ff 	lea    -0x118(%rbp),%rax
ffffffff801080be:	48 89 c6             	mov    %rax,%rsi
ffffffff801080c1:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801080c6:	e8 a1 f1 ff ff       	callq  ffffffff8010726c <arguintp>
ffffffff801080cb:	85 c0                	test   %eax,%eax
ffffffff801080cd:	79 0a                	jns    ffffffff801080d9 <sys_exec+0x42>
    return -1;
ffffffff801080cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801080d4:	e9 d6 00 00 00       	jmpq   ffffffff801081af <sys_exec+0x118>
  }
  memset(argv, 0, sizeof(argv));
ffffffff801080d9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffffffff801080e0:	ba 00 01 00 00       	mov    $0x100,%edx
ffffffff801080e5:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801080ea:	48 89 c7             	mov    %rax,%rdi
ffffffff801080ed:	e8 20 ec ff ff       	callq  ffffffff80106d12 <memset>
  for(i=0;; i++){
ffffffff801080f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    if(i >= NELEM(argv))
ffffffff801080f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801080fc:	83 f8 1f             	cmp    $0x1f,%eax
ffffffff801080ff:	76 0a                	jbe    ffffffff8010810b <sys_exec+0x74>
      return -1;
ffffffff80108101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108106:	e9 a4 00 00 00       	jmpq   ffffffff801081af <sys_exec+0x118>
    if(fetchuintp(uargv+sizeof(uintp)*i, &uarg) < 0)
ffffffff8010810b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010810e:	48 98                	cltq   
ffffffff80108110:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80108117:	00 
ffffffff80108118:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
ffffffff8010811f:	48 01 c2             	add    %rax,%rdx
ffffffff80108122:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
ffffffff80108129:	48 89 c6             	mov    %rax,%rsi
ffffffff8010812c:	48 89 d7             	mov    %rdx,%rdi
ffffffff8010812f:	e8 85 ef ff ff       	callq  ffffffff801070b9 <fetchuintp>
ffffffff80108134:	85 c0                	test   %eax,%eax
ffffffff80108136:	79 07                	jns    ffffffff8010813f <sys_exec+0xa8>
      return -1;
ffffffff80108138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010813d:	eb 70                	jmp    ffffffff801081af <sys_exec+0x118>
    if(uarg == 0){
ffffffff8010813f:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffffffff80108146:	48 85 c0             	test   %rax,%rax
ffffffff80108149:	75 2a                	jne    ffffffff80108175 <sys_exec+0xde>
      argv[i] = 0;
ffffffff8010814b:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff8010814e:	48 98                	cltq   
ffffffff80108150:	48 c7 84 c5 f0 fe ff 	movq   $0x0,-0x110(%rbp,%rax,8)
ffffffff80108157:	ff 00 00 00 00 
      break;
ffffffff8010815c:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
ffffffff8010815d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80108161:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
ffffffff80108168:	48 89 d6             	mov    %rdx,%rsi
ffffffff8010816b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010816e:	e8 6d 97 ff ff       	callq  ffffffff801018e0 <exec>
ffffffff80108173:	eb 3a                	jmp    ffffffff801081af <sys_exec+0x118>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
ffffffff80108175:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
ffffffff8010817c:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff8010817f:	48 63 d2             	movslq %edx,%rdx
ffffffff80108182:	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff80108186:	48 01 c2             	add    %rax,%rdx
ffffffff80108189:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
ffffffff80108190:	48 89 d6             	mov    %rdx,%rsi
ffffffff80108193:	48 89 c7             	mov    %rax,%rdi
ffffffff80108196:	e8 79 ef ff ff       	callq  ffffffff80107114 <fetchstr>
ffffffff8010819b:	85 c0                	test   %eax,%eax
ffffffff8010819d:	79 07                	jns    ffffffff801081a6 <sys_exec+0x10f>
      return -1;
ffffffff8010819f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801081a4:	eb 09                	jmp    ffffffff801081af <sys_exec+0x118>

  if(argstr(0, &path) < 0 || arguintp(1, &uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
ffffffff801081a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
ffffffff801081aa:	e9 4a ff ff ff       	jmpq   ffffffff801080f9 <sys_exec+0x62>
  return exec(path, argv);
}
ffffffff801081af:	c9                   	leaveq 
ffffffff801081b0:	c3                   	retq   

ffffffff801081b1 <sys_pipe>:

int
sys_pipe(void)
{
ffffffff801081b1:	55                   	push   %rbp
ffffffff801081b2:	48 89 e5             	mov    %rsp,%rbp
ffffffff801081b5:	48 83 ec 20          	sub    $0x20,%rsp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
ffffffff801081b9:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff801081bd:	ba 08 00 00 00       	mov    $0x8,%edx
ffffffff801081c2:	48 89 c6             	mov    %rax,%rsi
ffffffff801081c5:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801081ca:	e8 c7 f0 ff ff       	callq  ffffffff80107296 <argptr>
ffffffff801081cf:	85 c0                	test   %eax,%eax
ffffffff801081d1:	79 0a                	jns    ffffffff801081dd <sys_pipe+0x2c>
    return -1;
ffffffff801081d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801081d8:	e9 b0 00 00 00       	jmpq   ffffffff8010828d <sys_pipe+0xdc>
  if(pipealloc(&rf, &wf) < 0)
ffffffff801081dd:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
ffffffff801081e1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
ffffffff801081e5:	48 89 d6             	mov    %rdx,%rsi
ffffffff801081e8:	48 89 c7             	mov    %rax,%rdi
ffffffff801081eb:	e8 da d5 ff ff       	callq  ffffffff801057ca <pipealloc>
ffffffff801081f0:	85 c0                	test   %eax,%eax
ffffffff801081f2:	79 0a                	jns    ffffffff801081fe <sys_pipe+0x4d>
    return -1;
ffffffff801081f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801081f9:	e9 8f 00 00 00       	jmpq   ffffffff8010828d <sys_pipe+0xdc>
  fd0 = -1;
ffffffff801081fe:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
ffffffff80108205:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80108209:	48 89 c7             	mov    %rax,%rdi
ffffffff8010820c:	e8 95 f2 ff ff       	callq  ffffffff801074a6 <fdalloc>
ffffffff80108211:	89 45 fc             	mov    %eax,-0x4(%rbp)
ffffffff80108214:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80108218:	78 15                	js     ffffffff8010822f <sys_pipe+0x7e>
ffffffff8010821a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010821e:	48 89 c7             	mov    %rax,%rdi
ffffffff80108221:	e8 80 f2 ff ff       	callq  ffffffff801074a6 <fdalloc>
ffffffff80108226:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffffffff80108229:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
ffffffff8010822d:	79 43                	jns    ffffffff80108272 <sys_pipe+0xc1>
    if(fd0 >= 0)
ffffffff8010822f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
ffffffff80108233:	78 1e                	js     ffffffff80108253 <sys_pipe+0xa2>
      proc->ofile[fd0] = 0;
ffffffff80108235:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010823c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108240:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80108243:	48 63 d2             	movslq %edx,%rdx
ffffffff80108246:	48 83 c2 08          	add    $0x8,%rdx
ffffffff8010824a:	48 c7 44 d0 08 00 00 	movq   $0x0,0x8(%rax,%rdx,8)
ffffffff80108251:	00 00 
    fileclose(rf);
ffffffff80108253:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80108257:	48 89 c7             	mov    %rax,%rdi
ffffffff8010825a:	e8 81 9c ff ff       	callq  ffffffff80101ee0 <fileclose>
    fileclose(wf);
ffffffff8010825f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80108263:	48 89 c7             	mov    %rax,%rdi
ffffffff80108266:	e8 75 9c ff ff       	callq  ffffffff80101ee0 <fileclose>
    return -1;
ffffffff8010826b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108270:	eb 1b                	jmp    ffffffff8010828d <sys_pipe+0xdc>
  }
  fd[0] = fd0;
ffffffff80108272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80108276:	8b 55 fc             	mov    -0x4(%rbp),%edx
ffffffff80108279:	89 10                	mov    %edx,(%rax)
  fd[1] = fd1;
ffffffff8010827b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010827f:	48 8d 50 04          	lea    0x4(%rax),%rdx
ffffffff80108283:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffff80108286:	89 02                	mov    %eax,(%rdx)
  return 0;
ffffffff80108288:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff8010828d:	c9                   	leaveq 
ffffffff8010828e:	c3                   	retq   

ffffffff8010828f <sys_chmod>:

int
sys_chmod(void)
{
ffffffff8010828f:	55                   	push   %rbp
ffffffff80108290:	48 89 e5             	mov    %rsp,%rbp
ffffffff80108293:	48 83 ec 20          	sub    $0x20,%rsp
    char *path;
    int mode;
    struct inode *ip;
    if(argstr(0, &path) < 0 || argint(1, &mode) < 0)
ffffffff80108297:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff8010829b:	48 89 c6             	mov    %rax,%rsi
ffffffff8010829e:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801082a3:	e8 6f f0 ff ff       	callq  ffffffff80107317 <argstr>
ffffffff801082a8:	85 c0                	test   %eax,%eax
ffffffff801082aa:	78 15                	js     ffffffff801082c1 <sys_chmod+0x32>
ffffffff801082ac:	48 8d 45 ec          	lea    -0x14(%rbp),%rax
ffffffff801082b0:	48 89 c6             	mov    %rax,%rsi
ffffffff801082b3:	bf 01 00 00 00       	mov    $0x1,%edi
ffffffff801082b8:	e8 87 ef ff ff       	callq  ffffffff80107244 <argint>
ffffffff801082bd:	85 c0                	test   %eax,%eax
ffffffff801082bf:	79 07                	jns    ffffffff801082c8 <sys_chmod+0x39>
        return -1;
ffffffff801082c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801082c6:	eb 71                	jmp    ffffffff80108339 <sys_chmod+0xaa>
    begin_op();
ffffffff801082c8:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801082cd:	e8 ef c3 ff ff       	callq  ffffffff801046c1 <begin_op>
    if((ip = namei(path)) == 0) {
ffffffff801082d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801082d6:	48 89 c7             	mov    %rax,%rdi
ffffffff801082d9:	e8 92 b2 ff ff       	callq  ffffffff80103570 <namei>
ffffffff801082de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff801082e2:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff801082e7:	75 11                	jne    ffffffff801082fa <sys_chmod+0x6b>
        end_op();
ffffffff801082e9:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801082ee:	e8 50 c4 ff ff       	callq  ffffffff80104743 <end_op>
        return -1;
ffffffff801082f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801082f8:	eb 3f                	jmp    ffffffff80108339 <sys_chmod+0xaa>
    }
    ilock(ip);
ffffffff801082fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801082fe:	48 89 c7             	mov    %rax,%rdi
ffffffff80108301:	e8 3e a5 ff ff       	callq  ffffffff80102844 <ilock>
    ip->mode = mode;
ffffffff80108306:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff80108309:	89 c2                	mov    %eax,%edx
ffffffff8010830b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010830f:	89 50 1c             	mov    %edx,0x1c(%rax)
    iupdate(ip); // Copy to disk
ffffffff80108312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108316:	48 89 c7             	mov    %rax,%rdi
ffffffff80108319:	e8 1a a3 ff ff       	callq  ffffffff80102638 <iupdate>
    iunlockput(ip);
ffffffff8010831e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108322:	48 89 c7             	mov    %rax,%rdi
ffffffff80108325:	e8 10 a8 ff ff       	callq  ffffffff80102b3a <iunlockput>
    end_op();
ffffffff8010832a:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010832f:	e8 0f c4 ff ff       	callq  ffffffff80104743 <end_op>
    return 0;
ffffffff80108334:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80108339:	c9                   	leaveq 
ffffffff8010833a:	c3                   	retq   

ffffffff8010833b <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
ffffffff8010833b:	55                   	push   %rbp
ffffffff8010833c:	48 89 e5             	mov    %rsp,%rbp
  return fork();
ffffffff8010833f:	e8 34 dc ff ff       	callq  ffffffff80105f78 <fork>
}
ffffffff80108344:	5d                   	pop    %rbp
ffffffff80108345:	c3                   	retq   

ffffffff80108346 <sys_exit>:

int
sys_exit(void)
{
ffffffff80108346:	55                   	push   %rbp
ffffffff80108347:	48 89 e5             	mov    %rsp,%rbp
  exit();
ffffffff8010834a:	e8 0c de ff ff       	callq  ffffffff8010615b <exit>
  return 0;  // not reached
ffffffff8010834f:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80108354:	5d                   	pop    %rbp
ffffffff80108355:	c3                   	retq   

ffffffff80108356 <sys_wait>:

int
sys_wait(void)
{
ffffffff80108356:	55                   	push   %rbp
ffffffff80108357:	48 89 e5             	mov    %rsp,%rbp
  return wait();
ffffffff8010835a:	e8 81 df ff ff       	callq  ffffffff801062e0 <wait>
}
ffffffff8010835f:	5d                   	pop    %rbp
ffffffff80108360:	c3                   	retq   

ffffffff80108361 <sys_kill>:

int
sys_kill(void)
{
ffffffff80108361:	55                   	push   %rbp
ffffffff80108362:	48 89 e5             	mov    %rsp,%rbp
ffffffff80108365:	48 83 ec 10          	sub    $0x10,%rsp
  int pid;

  if(argint(0, &pid) < 0)
ffffffff80108369:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
ffffffff8010836d:	48 89 c6             	mov    %rax,%rsi
ffffffff80108370:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80108375:	e8 ca ee ff ff       	callq  ffffffff80107244 <argint>
ffffffff8010837a:	85 c0                	test   %eax,%eax
ffffffff8010837c:	79 07                	jns    ffffffff80108385 <sys_kill+0x24>
    return -1;
ffffffff8010837e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108383:	eb 0a                	jmp    ffffffff8010838f <sys_kill+0x2e>
  return kill(pid);
ffffffff80108385:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80108388:	89 c7                	mov    %eax,%edi
ffffffff8010838a:	e8 dd e3 ff ff       	callq  ffffffff8010676c <kill>
}
ffffffff8010838f:	c9                   	leaveq 
ffffffff80108390:	c3                   	retq   

ffffffff80108391 <sys_getpid>:

int
sys_getpid(void)
{
ffffffff80108391:	55                   	push   %rbp
ffffffff80108392:	48 89 e5             	mov    %rsp,%rbp
  return proc->pid;
ffffffff80108395:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010839c:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801083a0:	8b 40 1c             	mov    0x1c(%rax),%eax
}
ffffffff801083a3:	5d                   	pop    %rbp
ffffffff801083a4:	c3                   	retq   

ffffffff801083a5 <sys_sbrk>:

uintp
sys_sbrk(void)
{
ffffffff801083a5:	55                   	push   %rbp
ffffffff801083a6:	48 89 e5             	mov    %rsp,%rbp
ffffffff801083a9:	48 83 ec 10          	sub    $0x10,%rsp
  uintp addr;
  uintp n;

  if(arguintp(0, &n) < 0)
ffffffff801083ad:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff801083b1:	48 89 c6             	mov    %rax,%rsi
ffffffff801083b4:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff801083b9:	e8 ae ee ff ff       	callq  ffffffff8010726c <arguintp>
ffffffff801083be:	85 c0                	test   %eax,%eax
ffffffff801083c0:	79 09                	jns    ffffffff801083cb <sys_sbrk+0x26>
    return -1;
ffffffff801083c2:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffffffff801083c9:	eb 2e                	jmp    ffffffff801083f9 <sys_sbrk+0x54>
  addr = proc->sz;
ffffffff801083cb:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801083d2:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801083d6:	48 8b 00             	mov    (%rax),%rax
ffffffff801083d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(growproc(n) < 0)
ffffffff801083dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff801083e1:	89 c7                	mov    %eax,%edi
ffffffff801083e3:	e8 d2 da ff ff       	callq  ffffffff80105eba <growproc>
ffffffff801083e8:	85 c0                	test   %eax,%eax
ffffffff801083ea:	79 09                	jns    ffffffff801083f5 <sys_sbrk+0x50>
    return -1;
ffffffff801083ec:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
ffffffff801083f3:	eb 04                	jmp    ffffffff801083f9 <sys_sbrk+0x54>
  return addr;
ffffffff801083f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff801083f9:	c9                   	leaveq 
ffffffff801083fa:	c3                   	retq   

ffffffff801083fb <sys_sleep>:

int
sys_sleep(void)
{
ffffffff801083fb:	55                   	push   %rbp
ffffffff801083fc:	48 89 e5             	mov    %rsp,%rbp
ffffffff801083ff:	48 83 ec 10          	sub    $0x10,%rsp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
ffffffff80108403:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
ffffffff80108407:	48 89 c6             	mov    %rax,%rsi
ffffffff8010840a:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff8010840f:	e8 30 ee ff ff       	callq  ffffffff80107244 <argint>
ffffffff80108414:	85 c0                	test   %eax,%eax
ffffffff80108416:	79 07                	jns    ffffffff8010841f <sys_sleep+0x24>
    return -1;
ffffffff80108418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff8010841d:	eb 70                	jmp    ffffffff8010848f <sys_sleep+0x94>
  acquire(&tickslock);
ffffffff8010841f:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff80108426:	e8 78 e5 ff ff       	callq  ffffffff801069a3 <acquire>
  ticks0 = ticks;
ffffffff8010842b:	8b 05 37 ec 00 00    	mov    0xec37(%rip),%eax        # ffffffff80117068 <ticks>
ffffffff80108431:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while(ticks - ticks0 < n){
ffffffff80108434:	eb 38                	jmp    ffffffff8010846e <sys_sleep+0x73>
    if(proc->killed){
ffffffff80108436:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010843d:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108441:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80108444:	85 c0                	test   %eax,%eax
ffffffff80108446:	74 13                	je     ffffffff8010845b <sys_sleep+0x60>
      release(&tickslock);
ffffffff80108448:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff8010844f:	e8 26 e6 ff ff       	callq  ffffffff80106a7a <release>
      return -1;
ffffffff80108454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108459:	eb 34                	jmp    ffffffff8010848f <sys_sleep+0x94>
    }
    sleep(&ticks, &tickslock);
ffffffff8010845b:	48 c7 c6 00 70 11 80 	mov    $0xffffffff80117000,%rsi
ffffffff80108462:	48 c7 c7 68 70 11 80 	mov    $0xffffffff80117068,%rdi
ffffffff80108469:	e8 b8 e1 ff ff       	callq  ffffffff80106626 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
ffffffff8010846e:	8b 05 f4 eb 00 00    	mov    0xebf4(%rip),%eax        # ffffffff80117068 <ticks>
ffffffff80108474:	2b 45 fc             	sub    -0x4(%rbp),%eax
ffffffff80108477:	8b 55 f8             	mov    -0x8(%rbp),%edx
ffffffff8010847a:	39 d0                	cmp    %edx,%eax
ffffffff8010847c:	72 b8                	jb     ffffffff80108436 <sys_sleep+0x3b>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
ffffffff8010847e:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff80108485:	e8 f0 e5 ff ff       	callq  ffffffff80106a7a <release>
  return 0;
ffffffff8010848a:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff8010848f:	c9                   	leaveq 
ffffffff80108490:	c3                   	retq   

ffffffff80108491 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
ffffffff80108491:	55                   	push   %rbp
ffffffff80108492:	48 89 e5             	mov    %rsp,%rbp
ffffffff80108495:	48 83 ec 10          	sub    $0x10,%rsp
  uint xticks;
  
  acquire(&tickslock);
ffffffff80108499:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff801084a0:	e8 fe e4 ff ff       	callq  ffffffff801069a3 <acquire>
  xticks = ticks;
ffffffff801084a5:	8b 05 bd eb 00 00    	mov    0xebbd(%rip),%eax        # ffffffff80117068 <ticks>
ffffffff801084ab:	89 45 fc             	mov    %eax,-0x4(%rbp)
  release(&tickslock);
ffffffff801084ae:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff801084b5:	e8 c0 e5 ff ff       	callq  ffffffff80106a7a <release>
  return xticks;
ffffffff801084ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
ffffffff801084bd:	c9                   	leaveq 
ffffffff801084be:	c3                   	retq   

ffffffff801084bf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff801084bf:	55                   	push   %rbp
ffffffff801084c0:	48 89 e5             	mov    %rsp,%rbp
ffffffff801084c3:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801084c7:	89 fa                	mov    %edi,%edx
ffffffff801084c9:	89 f0                	mov    %esi,%eax
ffffffff801084cb:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff801084cf:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff801084d2:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff801084d6:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff801084da:	ee                   	out    %al,(%dx)
}
ffffffff801084db:	90                   	nop
ffffffff801084dc:	c9                   	leaveq 
ffffffff801084dd:	c3                   	retq   

ffffffff801084de <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
ffffffff801084de:	55                   	push   %rbp
ffffffff801084df:	48 89 e5             	mov    %rsp,%rbp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
ffffffff801084e2:	be 34 00 00 00       	mov    $0x34,%esi
ffffffff801084e7:	bf 43 00 00 00       	mov    $0x43,%edi
ffffffff801084ec:	e8 ce ff ff ff       	callq  ffffffff801084bf <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
ffffffff801084f1:	be 9c 00 00 00       	mov    $0x9c,%esi
ffffffff801084f6:	bf 40 00 00 00       	mov    $0x40,%edi
ffffffff801084fb:	e8 bf ff ff ff       	callq  ffffffff801084bf <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
ffffffff80108500:	be 2e 00 00 00       	mov    $0x2e,%esi
ffffffff80108505:	bf 40 00 00 00       	mov    $0x40,%edi
ffffffff8010850a:	e8 b0 ff ff ff       	callq  ffffffff801084bf <outb>
  picenable(IRQ_TIMER);
ffffffff8010850f:	bf 00 00 00 00       	mov    $0x0,%edi
ffffffff80108514:	e8 87 d1 ff ff       	callq  ffffffff801056a0 <picenable>
}
ffffffff80108519:	90                   	nop
ffffffff8010851a:	5d                   	pop    %rbp
ffffffff8010851b:	c3                   	retq   

ffffffff8010851c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  push %r15
ffffffff8010851c:	41 57                	push   %r15
  push %r14
ffffffff8010851e:	41 56                	push   %r14
  push %r13
ffffffff80108520:	41 55                	push   %r13
  push %r12
ffffffff80108522:	41 54                	push   %r12
  push %r11
ffffffff80108524:	41 53                	push   %r11
  push %r10
ffffffff80108526:	41 52                	push   %r10
  push %r9
ffffffff80108528:	41 51                	push   %r9
  push %r8
ffffffff8010852a:	41 50                	push   %r8
  push %rdi
ffffffff8010852c:	57                   	push   %rdi
  push %rsi
ffffffff8010852d:	56                   	push   %rsi
  push %rbp
ffffffff8010852e:	55                   	push   %rbp
  push %rdx
ffffffff8010852f:	52                   	push   %rdx
  push %rcx
ffffffff80108530:	51                   	push   %rcx
  push %rbx
ffffffff80108531:	53                   	push   %rbx
  push %rax
ffffffff80108532:	50                   	push   %rax

  mov  %rsp, %rdi  # frame in arg1
ffffffff80108533:	48 89 e7             	mov    %rsp,%rdi
  call trap
ffffffff80108536:	e8 32 00 00 00       	callq  ffffffff8010856d <trap>

ffffffff8010853b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  pop %rax
ffffffff8010853b:	58                   	pop    %rax
  pop %rbx
ffffffff8010853c:	5b                   	pop    %rbx
  pop %rcx
ffffffff8010853d:	59                   	pop    %rcx
  pop %rdx
ffffffff8010853e:	5a                   	pop    %rdx
  pop %rbp
ffffffff8010853f:	5d                   	pop    %rbp
  pop %rsi
ffffffff80108540:	5e                   	pop    %rsi
  pop %rdi
ffffffff80108541:	5f                   	pop    %rdi
  pop %r8
ffffffff80108542:	41 58                	pop    %r8
  pop %r9
ffffffff80108544:	41 59                	pop    %r9
  pop %r10
ffffffff80108546:	41 5a                	pop    %r10
  pop %r11
ffffffff80108548:	41 5b                	pop    %r11
  pop %r12
ffffffff8010854a:	41 5c                	pop    %r12
  pop %r13
ffffffff8010854c:	41 5d                	pop    %r13
  pop %r14
ffffffff8010854e:	41 5e                	pop    %r14
  pop %r15
ffffffff80108550:	41 5f                	pop    %r15

  # discard trapnum and errorcode
  add $16, %rsp
ffffffff80108552:	48 83 c4 10          	add    $0x10,%rsp
  iretq
ffffffff80108556:	48 cf                	iretq  

ffffffff80108558 <rcr2>:
  return result;
}

static inline uintp
rcr2(void)
{
ffffffff80108558:	55                   	push   %rbp
ffffffff80108559:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010855c:	48 83 ec 10          	sub    $0x10,%rsp
  uintp val;
  asm volatile("mov %%cr2,%0" : "=r" (val));
ffffffff80108560:	0f 20 d0             	mov    %cr2,%rax
ffffffff80108563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  return val;
ffffffff80108567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
ffffffff8010856b:	c9                   	leaveq 
ffffffff8010856c:	c3                   	retq   

ffffffff8010856d <trap>:
#endif

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
ffffffff8010856d:	55                   	push   %rbp
ffffffff8010856e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80108571:	48 83 ec 10          	sub    $0x10,%rsp
ffffffff80108575:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  if(tf->trapno == T_SYSCALL){
ffffffff80108579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010857d:	48 8b 40 78          	mov    0x78(%rax),%rax
ffffffff80108581:	48 83 f8 40          	cmp    $0x40,%rax
ffffffff80108585:	75 4f                	jne    ffffffff801085d6 <trap+0x69>
    if(proc->killed)
ffffffff80108587:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010858e:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108592:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80108595:	85 c0                	test   %eax,%eax
ffffffff80108597:	74 05                	je     ffffffff8010859e <trap+0x31>
      exit();
ffffffff80108599:	e8 bd db ff ff       	callq  ffffffff8010615b <exit>
    proc->tf = tf;
ffffffff8010859e:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801085a5:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801085a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801085ad:	48 89 50 28          	mov    %rdx,0x28(%rax)
    syscall();
ffffffff801085b1:	e8 a1 ed ff ff       	callq  ffffffff80107357 <syscall>
    if(proc->killed)
ffffffff801085b6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801085bd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801085c1:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff801085c4:	85 c0                	test   %eax,%eax
ffffffff801085c6:	0f 84 9a 02 00 00    	je     ffffffff80108866 <trap+0x2f9>
      exit();
ffffffff801085cc:	e8 8a db ff ff       	callq  ffffffff8010615b <exit>
    return;
ffffffff801085d1:	e9 90 02 00 00       	jmpq   ffffffff80108866 <trap+0x2f9>
  }

  switch(tf->trapno){
ffffffff801085d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801085da:	48 8b 40 78          	mov    0x78(%rax),%rax
ffffffff801085de:	48 83 e8 20          	sub    $0x20,%rax
ffffffff801085e2:	48 83 f8 1f          	cmp    $0x1f,%rax
ffffffff801085e6:	0f 87 ca 00 00 00    	ja     ffffffff801086b6 <trap+0x149>
ffffffff801085ec:	48 8b 04 c5 30 ad 10 	mov    -0x7fef52d0(,%rax,8),%rax
ffffffff801085f3:	80 
ffffffff801085f4:	ff e0                	jmpq   *%rax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
ffffffff801085f6:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff801085fd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108601:	0f b6 00             	movzbl (%rax),%eax
ffffffff80108604:	84 c0                	test   %al,%al
ffffffff80108606:	75 33                	jne    ffffffff8010863b <trap+0xce>
      acquire(&tickslock);
ffffffff80108608:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff8010860f:	e8 8f e3 ff ff       	callq  ffffffff801069a3 <acquire>
      ticks++;
ffffffff80108614:	8b 05 4e ea 00 00    	mov    0xea4e(%rip),%eax        # ffffffff80117068 <ticks>
ffffffff8010861a:	83 c0 01             	add    $0x1,%eax
ffffffff8010861d:	89 05 45 ea 00 00    	mov    %eax,0xea45(%rip)        # ffffffff80117068 <ticks>
      wakeup(&ticks);
ffffffff80108623:	48 c7 c7 68 70 11 80 	mov    $0xffffffff80117068,%rdi
ffffffff8010862a:	e8 0a e1 ff ff       	callq  ffffffff80106739 <wakeup>
      release(&tickslock);
ffffffff8010862f:	48 c7 c7 00 70 11 80 	mov    $0xffffffff80117000,%rdi
ffffffff80108636:	e8 3f e4 ff ff       	callq  ffffffff80106a7a <release>
    }
    lapiceoi();
ffffffff8010863b:	e8 1d bb ff ff       	callq  ffffffff8010415d <lapiceoi>
    break;
ffffffff80108640:	e9 73 01 00 00       	jmpq   ffffffff801087b8 <trap+0x24b>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
ffffffff80108645:	e8 2e b2 ff ff       	callq  ffffffff80103878 <ideintr>
    lapiceoi();
ffffffff8010864a:	e8 0e bb ff ff       	callq  ffffffff8010415d <lapiceoi>
    break;
ffffffff8010864f:	e9 64 01 00 00       	jmpq   ffffffff801087b8 <trap+0x24b>
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
ffffffff80108654:	e8 9a b8 ff ff       	callq  ffffffff80103ef3 <kbdintr>
    lapiceoi();
ffffffff80108659:	e8 ff ba ff ff       	callq  ffffffff8010415d <lapiceoi>
    break;
ffffffff8010865e:	e9 55 01 00 00       	jmpq   ffffffff801087b8 <trap+0x24b>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
ffffffff80108663:	e8 d3 03 00 00       	callq  ffffffff80108a3b <uartintr>
    lapiceoi();
ffffffff80108668:	e8 f0 ba ff ff       	callq  ffffffff8010415d <lapiceoi>
    break;
ffffffff8010866d:	e9 46 01 00 00       	jmpq   ffffffff801087b8 <trap+0x24b>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
ffffffff80108672:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108676:	48 8b 88 88 00 00 00 	mov    0x88(%rax),%rcx
ffffffff8010867d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108681:	48 8b 90 90 00 00 00 	mov    0x90(%rax),%rdx
            cpu->id, tf->cs, tf->eip);
ffffffff80108688:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff8010868f:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108693:	0f b6 00             	movzbl (%rax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
ffffffff80108696:	0f b6 c0             	movzbl %al,%eax
ffffffff80108699:	89 c6                	mov    %eax,%esi
ffffffff8010869b:	48 c7 c7 88 ac 10 80 	mov    $0xffffffff8010ac88,%rdi
ffffffff801086a2:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff801086a7:	e8 f6 7e ff ff       	callq  ffffffff801005a2 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
ffffffff801086ac:	e8 ac ba ff ff       	callq  ffffffff8010415d <lapiceoi>
    break;
ffffffff801086b1:	e9 02 01 00 00       	jmpq   ffffffff801087b8 <trap+0x24b>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
ffffffff801086b6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801086bd:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801086c1:	48 85 c0             	test   %rax,%rax
ffffffff801086c4:	74 13                	je     ffffffff801086d9 <trap+0x16c>
ffffffff801086c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801086ca:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffffffff801086d1:	83 e0 03             	and    $0x3,%eax
ffffffff801086d4:	48 85 c0             	test   %rax,%rax
ffffffff801086d7:	75 4f                	jne    ffffffff80108728 <trap+0x1bb>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
ffffffff801086d9:	e8 7a fe ff ff       	callq  ffffffff80108558 <rcr2>
ffffffff801086de:	48 89 c6             	mov    %rax,%rsi
ffffffff801086e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801086e5:	48 8b 88 88 00 00 00 	mov    0x88(%rax),%rcx
              tf->trapno, cpu->id, tf->eip, rcr2());
ffffffff801086ec:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff801086f3:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801086f7:	0f b6 00             	movzbl (%rax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
ffffffff801086fa:	0f b6 d0             	movzbl %al,%edx
ffffffff801086fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108701:	48 8b 40 78          	mov    0x78(%rax),%rax
ffffffff80108705:	49 89 f0             	mov    %rsi,%r8
ffffffff80108708:	48 89 c6             	mov    %rax,%rsi
ffffffff8010870b:	48 c7 c7 b0 ac 10 80 	mov    $0xffffffff8010acb0,%rdi
ffffffff80108712:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80108717:	e8 86 7e ff ff       	callq  ffffffff801005a2 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
ffffffff8010871c:	48 c7 c7 e2 ac 10 80 	mov    $0xffffffff8010ace2,%rdi
ffffffff80108723:	e8 d7 81 ff ff       	callq  ffffffff801008ff <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffffffff80108728:	e8 2b fe ff ff       	callq  ffffffff80108558 <rcr2>
ffffffff8010872d:	49 89 c1             	mov    %rax,%r9
ffffffff80108730:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108734:	48 8b 88 88 00 00 00 	mov    0x88(%rax),%rcx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
ffffffff8010873b:	48 c7 c0 f0 ff ff ff 	mov    $0xfffffffffffffff0,%rax
ffffffff80108742:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108746:	0f b6 00             	movzbl (%rax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffffffff80108749:	44 0f b6 c0          	movzbl %al,%r8d
ffffffff8010874d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108751:	48 8b b8 80 00 00 00 	mov    0x80(%rax),%rdi
ffffffff80108758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010875c:	48 8b 50 78          	mov    0x78(%rax),%rdx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
ffffffff80108760:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80108767:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010876b:	48 8d b0 d0 00 00 00 	lea    0xd0(%rax),%rsi
ffffffff80108772:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80108779:	64 48 8b 00          	mov    %fs:(%rax),%rax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
ffffffff8010877d:	8b 40 1c             	mov    0x1c(%rax),%eax
ffffffff80108780:	41 51                	push   %r9
ffffffff80108782:	51                   	push   %rcx
ffffffff80108783:	45 89 c1             	mov    %r8d,%r9d
ffffffff80108786:	49 89 f8             	mov    %rdi,%r8
ffffffff80108789:	48 89 d1             	mov    %rdx,%rcx
ffffffff8010878c:	48 89 f2             	mov    %rsi,%rdx
ffffffff8010878f:	89 c6                	mov    %eax,%esi
ffffffff80108791:	48 c7 c7 e8 ac 10 80 	mov    $0xffffffff8010ace8,%rdi
ffffffff80108798:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010879d:	e8 00 7e ff ff       	callq  ffffffff801005a2 <cprintf>
ffffffff801087a2:	48 83 c4 10          	add    $0x10,%rsp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
ffffffff801087a6:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801087ad:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801087b1:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffffffff801087b8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801087bf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801087c3:	48 85 c0             	test   %rax,%rax
ffffffff801087c6:	74 2b                	je     ffffffff801087f3 <trap+0x286>
ffffffff801087c8:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801087cf:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801087d3:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff801087d6:	85 c0                	test   %eax,%eax
ffffffff801087d8:	74 19                	je     ffffffff801087f3 <trap+0x286>
ffffffff801087da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801087de:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffffffff801087e5:	83 e0 03             	and    $0x3,%eax
ffffffff801087e8:	48 83 f8 03          	cmp    $0x3,%rax
ffffffff801087ec:	75 05                	jne    ffffffff801087f3 <trap+0x286>
    exit();
ffffffff801087ee:	e8 68 d9 ff ff       	callq  ffffffff8010615b <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
ffffffff801087f3:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff801087fa:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff801087fe:	48 85 c0             	test   %rax,%rax
ffffffff80108801:	74 26                	je     ffffffff80108829 <trap+0x2bc>
ffffffff80108803:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff8010880a:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff8010880e:	8b 40 18             	mov    0x18(%rax),%eax
ffffffff80108811:	83 f8 04             	cmp    $0x4,%eax
ffffffff80108814:	75 13                	jne    ffffffff80108829 <trap+0x2bc>
ffffffff80108816:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010881a:	48 8b 40 78          	mov    0x78(%rax),%rax
ffffffff8010881e:	48 83 f8 20          	cmp    $0x20,%rax
ffffffff80108822:	75 05                	jne    ffffffff80108829 <trap+0x2bc>
    yield();
ffffffff80108824:	e8 9b dd ff ff       	callq  ffffffff801065c4 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
ffffffff80108829:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80108830:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108834:	48 85 c0             	test   %rax,%rax
ffffffff80108837:	74 2e                	je     ffffffff80108867 <trap+0x2fa>
ffffffff80108839:	48 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%rax
ffffffff80108840:	64 48 8b 00          	mov    %fs:(%rax),%rax
ffffffff80108844:	8b 40 40             	mov    0x40(%rax),%eax
ffffffff80108847:	85 c0                	test   %eax,%eax
ffffffff80108849:	74 1c                	je     ffffffff80108867 <trap+0x2fa>
ffffffff8010884b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010884f:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
ffffffff80108856:	83 e0 03             	and    $0x3,%eax
ffffffff80108859:	48 83 f8 03          	cmp    $0x3,%rax
ffffffff8010885d:	75 08                	jne    ffffffff80108867 <trap+0x2fa>
    exit();
ffffffff8010885f:	e8 f7 d8 ff ff       	callq  ffffffff8010615b <exit>
ffffffff80108864:	eb 01                	jmp    ffffffff80108867 <trap+0x2fa>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
ffffffff80108866:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
ffffffff80108867:	c9                   	leaveq 
ffffffff80108868:	c3                   	retq   

ffffffff80108869 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
ffffffff80108869:	55                   	push   %rbp
ffffffff8010886a:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010886d:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80108871:	89 f8                	mov    %edi,%eax
ffffffff80108873:	66 89 45 ec          	mov    %ax,-0x14(%rbp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
ffffffff80108877:	0f b7 45 ec          	movzwl -0x14(%rbp),%eax
ffffffff8010887b:	89 c2                	mov    %eax,%edx
ffffffff8010887d:	ec                   	in     (%dx),%al
ffffffff8010887e:	88 45 ff             	mov    %al,-0x1(%rbp)
  return data;
ffffffff80108881:	0f b6 45 ff          	movzbl -0x1(%rbp),%eax
}
ffffffff80108885:	c9                   	leaveq 
ffffffff80108886:	c3                   	retq   

ffffffff80108887 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
ffffffff80108887:	55                   	push   %rbp
ffffffff80108888:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010888b:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff8010888f:	89 fa                	mov    %edi,%edx
ffffffff80108891:	89 f0                	mov    %esi,%eax
ffffffff80108893:	66 89 55 fc          	mov    %dx,-0x4(%rbp)
ffffffff80108897:	88 45 f8             	mov    %al,-0x8(%rbp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
ffffffff8010889a:	0f b6 45 f8          	movzbl -0x8(%rbp),%eax
ffffffff8010889e:	0f b7 55 fc          	movzwl -0x4(%rbp),%edx
ffffffff801088a2:	ee                   	out    %al,(%dx)
}
ffffffff801088a3:	90                   	nop
ffffffff801088a4:	c9                   	leaveq 
ffffffff801088a5:	c3                   	retq   

ffffffff801088a6 <uartearlyinit>:

static int uart;    // is there a uart?

void
uartearlyinit(void)
{
ffffffff801088a6:	55                   	push   %rbp
ffffffff801088a7:	48 89 e5             	mov    %rsp,%rbp
ffffffff801088aa:	48 83 ec 10          	sub    $0x10,%rsp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
ffffffff801088ae:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801088b3:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffffffff801088b8:	e8 ca ff ff ff       	callq  ffffffff80108887 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
ffffffff801088bd:	be 80 00 00 00       	mov    $0x80,%esi
ffffffff801088c2:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffffffff801088c7:	e8 bb ff ff ff       	callq  ffffffff80108887 <outb>
  outb(COM1+0, 115200/9600);
ffffffff801088cc:	be 0c 00 00 00       	mov    $0xc,%esi
ffffffff801088d1:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffffffff801088d6:	e8 ac ff ff ff       	callq  ffffffff80108887 <outb>
  outb(COM1+1, 0);
ffffffff801088db:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801088e0:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffffffff801088e5:	e8 9d ff ff ff       	callq  ffffffff80108887 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
ffffffff801088ea:	be 03 00 00 00       	mov    $0x3,%esi
ffffffff801088ef:	bf fb 03 00 00       	mov    $0x3fb,%edi
ffffffff801088f4:	e8 8e ff ff ff       	callq  ffffffff80108887 <outb>
  outb(COM1+4, 0);
ffffffff801088f9:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801088fe:	bf fc 03 00 00       	mov    $0x3fc,%edi
ffffffff80108903:	e8 7f ff ff ff       	callq  ffffffff80108887 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
ffffffff80108908:	be 01 00 00 00       	mov    $0x1,%esi
ffffffff8010890d:	bf f9 03 00 00       	mov    $0x3f9,%edi
ffffffff80108912:	e8 70 ff ff ff       	callq  ffffffff80108887 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
ffffffff80108917:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffffffff8010891c:	e8 48 ff ff ff       	callq  ffffffff80108869 <inb>
ffffffff80108921:	3c ff                	cmp    $0xff,%al
ffffffff80108923:	74 37                	je     ffffffff8010895c <uartearlyinit+0xb6>
    return;
  uart = 1;
ffffffff80108925:	c7 05 3d e7 00 00 01 	movl   $0x1,0xe73d(%rip)        # ffffffff8011706c <uart>
ffffffff8010892c:	00 00 00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffffffff8010892f:	48 c7 45 f8 30 ae 10 	movq   $0xffffffff8010ae30,-0x8(%rbp)
ffffffff80108936:	80 
ffffffff80108937:	eb 16                	jmp    ffffffff8010894f <uartearlyinit+0xa9>
    uartputc(*p);
ffffffff80108939:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010893d:	0f b6 00             	movzbl (%rax),%eax
ffffffff80108940:	0f be c0             	movsbl %al,%eax
ffffffff80108943:	89 c7                	mov    %eax,%edi
ffffffff80108945:	e8 55 00 00 00       	callq  ffffffff8010899f <uartputc>
  if(inb(COM1+5) == 0xFF)
    return;
  uart = 1;

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
ffffffff8010894a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
ffffffff8010894f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80108953:	0f b6 00             	movzbl (%rax),%eax
ffffffff80108956:	84 c0                	test   %al,%al
ffffffff80108958:	75 df                	jne    ffffffff80108939 <uartearlyinit+0x93>
ffffffff8010895a:	eb 01                	jmp    ffffffff8010895d <uartearlyinit+0xb7>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
ffffffff8010895c:	90                   	nop
  uart = 1;

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
ffffffff8010895d:	c9                   	leaveq 
ffffffff8010895e:	c3                   	retq   

ffffffff8010895f <uartinit>:

void
uartinit(void)
{
ffffffff8010895f:	55                   	push   %rbp
ffffffff80108960:	48 89 e5             	mov    %rsp,%rbp
  if (!uart)
ffffffff80108963:	8b 05 03 e7 00 00    	mov    0xe703(%rip),%eax        # ffffffff8011706c <uart>
ffffffff80108969:	85 c0                	test   %eax,%eax
ffffffff8010896b:	74 2f                	je     ffffffff8010899c <uartinit+0x3d>
    return;

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
ffffffff8010896d:	bf fa 03 00 00       	mov    $0x3fa,%edi
ffffffff80108972:	e8 f2 fe ff ff       	callq  ffffffff80108869 <inb>
  inb(COM1+0);
ffffffff80108977:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffffffff8010897c:	e8 e8 fe ff ff       	callq  ffffffff80108869 <inb>
  picenable(IRQ_COM1);
ffffffff80108981:	bf 04 00 00 00       	mov    $0x4,%edi
ffffffff80108986:	e8 15 cd ff ff       	callq  ffffffff801056a0 <picenable>
  ioapicenable(IRQ_COM1, 0);
ffffffff8010898b:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80108990:	bf 04 00 00 00       	mov    $0x4,%edi
ffffffff80108995:	e8 ab b1 ff ff       	callq  ffffffff80103b45 <ioapicenable>
ffffffff8010899a:	eb 01                	jmp    ffffffff8010899d <uartinit+0x3e>

void
uartinit(void)
{
  if (!uart)
    return;
ffffffff8010899c:	90                   	nop
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
}
ffffffff8010899d:	5d                   	pop    %rbp
ffffffff8010899e:	c3                   	retq   

ffffffff8010899f <uartputc>:

void
uartputc(int c)
{
ffffffff8010899f:	55                   	push   %rbp
ffffffff801089a0:	48 89 e5             	mov    %rsp,%rbp
ffffffff801089a3:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801089a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  int i;

  if(!uart)
ffffffff801089aa:	8b 05 bc e6 00 00    	mov    0xe6bc(%rip),%eax        # ffffffff8011706c <uart>
ffffffff801089b0:	85 c0                	test   %eax,%eax
ffffffff801089b2:	74 45                	je     ffffffff801089f9 <uartputc+0x5a>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffffffff801089b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801089bb:	eb 0e                	jmp    ffffffff801089cb <uartputc+0x2c>
    microdelay(10);
ffffffff801089bd:	bf 0a 00 00 00       	mov    $0xa,%edi
ffffffff801089c2:	e8 b8 b7 ff ff       	callq  ffffffff8010417f <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
ffffffff801089c7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff801089cb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
ffffffff801089cf:	7f 14                	jg     ffffffff801089e5 <uartputc+0x46>
ffffffff801089d1:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffffffff801089d6:	e8 8e fe ff ff       	callq  ffffffff80108869 <inb>
ffffffff801089db:	0f b6 c0             	movzbl %al,%eax
ffffffff801089de:	83 e0 20             	and    $0x20,%eax
ffffffff801089e1:	85 c0                	test   %eax,%eax
ffffffff801089e3:	74 d8                	je     ffffffff801089bd <uartputc+0x1e>
    microdelay(10);
  outb(COM1+0, c);
ffffffff801089e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801089e8:	0f b6 c0             	movzbl %al,%eax
ffffffff801089eb:	89 c6                	mov    %eax,%esi
ffffffff801089ed:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffffffff801089f2:	e8 90 fe ff ff       	callq  ffffffff80108887 <outb>
ffffffff801089f7:	eb 01                	jmp    ffffffff801089fa <uartputc+0x5b>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
ffffffff801089f9:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
ffffffff801089fa:	c9                   	leaveq 
ffffffff801089fb:	c3                   	retq   

ffffffff801089fc <uartgetc>:

static int
uartgetc(void)
{
ffffffff801089fc:	55                   	push   %rbp
ffffffff801089fd:	48 89 e5             	mov    %rsp,%rbp
  if(!uart)
ffffffff80108a00:	8b 05 66 e6 00 00    	mov    0xe666(%rip),%eax        # ffffffff8011706c <uart>
ffffffff80108a06:	85 c0                	test   %eax,%eax
ffffffff80108a08:	75 07                	jne    ffffffff80108a11 <uartgetc+0x15>
    return -1;
ffffffff80108a0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108a0f:	eb 28                	jmp    ffffffff80108a39 <uartgetc+0x3d>
  if(!(inb(COM1+5) & 0x01))
ffffffff80108a11:	bf fd 03 00 00       	mov    $0x3fd,%edi
ffffffff80108a16:	e8 4e fe ff ff       	callq  ffffffff80108869 <inb>
ffffffff80108a1b:	0f b6 c0             	movzbl %al,%eax
ffffffff80108a1e:	83 e0 01             	and    $0x1,%eax
ffffffff80108a21:	85 c0                	test   %eax,%eax
ffffffff80108a23:	75 07                	jne    ffffffff80108a2c <uartgetc+0x30>
    return -1;
ffffffff80108a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80108a2a:	eb 0d                	jmp    ffffffff80108a39 <uartgetc+0x3d>
  return inb(COM1+0);
ffffffff80108a2c:	bf f8 03 00 00       	mov    $0x3f8,%edi
ffffffff80108a31:	e8 33 fe ff ff       	callq  ffffffff80108869 <inb>
ffffffff80108a36:	0f b6 c0             	movzbl %al,%eax
}
ffffffff80108a39:	5d                   	pop    %rbp
ffffffff80108a3a:	c3                   	retq   

ffffffff80108a3b <uartintr>:

void
uartintr(void)
{
ffffffff80108a3b:	55                   	push   %rbp
ffffffff80108a3c:	48 89 e5             	mov    %rsp,%rbp
  consoleintr(uartgetc);
ffffffff80108a3f:	48 c7 c7 fc 89 10 80 	mov    $0xffffffff801089fc,%rdi
ffffffff80108a46:	e8 3b 81 ff ff       	callq  ffffffff80100b86 <consoleintr>
}
ffffffff80108a4b:	90                   	nop
ffffffff80108a4c:	5d                   	pop    %rbp
ffffffff80108a4d:	c3                   	retq   

ffffffff80108a4e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  push $0
ffffffff80108a4e:	6a 00                	pushq  $0x0
  push $0
ffffffff80108a50:	6a 00                	pushq  $0x0
  jmp alltraps
ffffffff80108a52:	e9 c5 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a57 <vector1>:
.globl vector1
vector1:
  push $0
ffffffff80108a57:	6a 00                	pushq  $0x0
  push $1
ffffffff80108a59:	6a 01                	pushq  $0x1
  jmp alltraps
ffffffff80108a5b:	e9 bc fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a60 <vector2>:
.globl vector2
vector2:
  push $0
ffffffff80108a60:	6a 00                	pushq  $0x0
  push $2
ffffffff80108a62:	6a 02                	pushq  $0x2
  jmp alltraps
ffffffff80108a64:	e9 b3 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a69 <vector3>:
.globl vector3
vector3:
  push $0
ffffffff80108a69:	6a 00                	pushq  $0x0
  push $3
ffffffff80108a6b:	6a 03                	pushq  $0x3
  jmp alltraps
ffffffff80108a6d:	e9 aa fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a72 <vector4>:
.globl vector4
vector4:
  push $0
ffffffff80108a72:	6a 00                	pushq  $0x0
  push $4
ffffffff80108a74:	6a 04                	pushq  $0x4
  jmp alltraps
ffffffff80108a76:	e9 a1 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a7b <vector5>:
.globl vector5
vector5:
  push $0
ffffffff80108a7b:	6a 00                	pushq  $0x0
  push $5
ffffffff80108a7d:	6a 05                	pushq  $0x5
  jmp alltraps
ffffffff80108a7f:	e9 98 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a84 <vector6>:
.globl vector6
vector6:
  push $0
ffffffff80108a84:	6a 00                	pushq  $0x0
  push $6
ffffffff80108a86:	6a 06                	pushq  $0x6
  jmp alltraps
ffffffff80108a88:	e9 8f fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a8d <vector7>:
.globl vector7
vector7:
  push $0
ffffffff80108a8d:	6a 00                	pushq  $0x0
  push $7
ffffffff80108a8f:	6a 07                	pushq  $0x7
  jmp alltraps
ffffffff80108a91:	e9 86 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a96 <vector8>:
.globl vector8
vector8:
  push $8
ffffffff80108a96:	6a 08                	pushq  $0x8
  jmp alltraps
ffffffff80108a98:	e9 7f fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108a9d <vector9>:
.globl vector9
vector9:
  push $0
ffffffff80108a9d:	6a 00                	pushq  $0x0
  push $9
ffffffff80108a9f:	6a 09                	pushq  $0x9
  jmp alltraps
ffffffff80108aa1:	e9 76 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108aa6 <vector10>:
.globl vector10
vector10:
  push $10
ffffffff80108aa6:	6a 0a                	pushq  $0xa
  jmp alltraps
ffffffff80108aa8:	e9 6f fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108aad <vector11>:
.globl vector11
vector11:
  push $11
ffffffff80108aad:	6a 0b                	pushq  $0xb
  jmp alltraps
ffffffff80108aaf:	e9 68 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ab4 <vector12>:
.globl vector12
vector12:
  push $12
ffffffff80108ab4:	6a 0c                	pushq  $0xc
  jmp alltraps
ffffffff80108ab6:	e9 61 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108abb <vector13>:
.globl vector13
vector13:
  push $13
ffffffff80108abb:	6a 0d                	pushq  $0xd
  jmp alltraps
ffffffff80108abd:	e9 5a fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ac2 <vector14>:
.globl vector14
vector14:
  push $14
ffffffff80108ac2:	6a 0e                	pushq  $0xe
  jmp alltraps
ffffffff80108ac4:	e9 53 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ac9 <vector15>:
.globl vector15
vector15:
  push $0
ffffffff80108ac9:	6a 00                	pushq  $0x0
  push $15
ffffffff80108acb:	6a 0f                	pushq  $0xf
  jmp alltraps
ffffffff80108acd:	e9 4a fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ad2 <vector16>:
.globl vector16
vector16:
  push $0
ffffffff80108ad2:	6a 00                	pushq  $0x0
  push $16
ffffffff80108ad4:	6a 10                	pushq  $0x10
  jmp alltraps
ffffffff80108ad6:	e9 41 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108adb <vector17>:
.globl vector17
vector17:
  push $17
ffffffff80108adb:	6a 11                	pushq  $0x11
  jmp alltraps
ffffffff80108add:	e9 3a fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ae2 <vector18>:
.globl vector18
vector18:
  push $0
ffffffff80108ae2:	6a 00                	pushq  $0x0
  push $18
ffffffff80108ae4:	6a 12                	pushq  $0x12
  jmp alltraps
ffffffff80108ae6:	e9 31 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108aeb <vector19>:
.globl vector19
vector19:
  push $0
ffffffff80108aeb:	6a 00                	pushq  $0x0
  push $19
ffffffff80108aed:	6a 13                	pushq  $0x13
  jmp alltraps
ffffffff80108aef:	e9 28 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108af4 <vector20>:
.globl vector20
vector20:
  push $0
ffffffff80108af4:	6a 00                	pushq  $0x0
  push $20
ffffffff80108af6:	6a 14                	pushq  $0x14
  jmp alltraps
ffffffff80108af8:	e9 1f fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108afd <vector21>:
.globl vector21
vector21:
  push $0
ffffffff80108afd:	6a 00                	pushq  $0x0
  push $21
ffffffff80108aff:	6a 15                	pushq  $0x15
  jmp alltraps
ffffffff80108b01:	e9 16 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b06 <vector22>:
.globl vector22
vector22:
  push $0
ffffffff80108b06:	6a 00                	pushq  $0x0
  push $22
ffffffff80108b08:	6a 16                	pushq  $0x16
  jmp alltraps
ffffffff80108b0a:	e9 0d fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b0f <vector23>:
.globl vector23
vector23:
  push $0
ffffffff80108b0f:	6a 00                	pushq  $0x0
  push $23
ffffffff80108b11:	6a 17                	pushq  $0x17
  jmp alltraps
ffffffff80108b13:	e9 04 fa ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b18 <vector24>:
.globl vector24
vector24:
  push $0
ffffffff80108b18:	6a 00                	pushq  $0x0
  push $24
ffffffff80108b1a:	6a 18                	pushq  $0x18
  jmp alltraps
ffffffff80108b1c:	e9 fb f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b21 <vector25>:
.globl vector25
vector25:
  push $0
ffffffff80108b21:	6a 00                	pushq  $0x0
  push $25
ffffffff80108b23:	6a 19                	pushq  $0x19
  jmp alltraps
ffffffff80108b25:	e9 f2 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b2a <vector26>:
.globl vector26
vector26:
  push $0
ffffffff80108b2a:	6a 00                	pushq  $0x0
  push $26
ffffffff80108b2c:	6a 1a                	pushq  $0x1a
  jmp alltraps
ffffffff80108b2e:	e9 e9 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b33 <vector27>:
.globl vector27
vector27:
  push $0
ffffffff80108b33:	6a 00                	pushq  $0x0
  push $27
ffffffff80108b35:	6a 1b                	pushq  $0x1b
  jmp alltraps
ffffffff80108b37:	e9 e0 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b3c <vector28>:
.globl vector28
vector28:
  push $0
ffffffff80108b3c:	6a 00                	pushq  $0x0
  push $28
ffffffff80108b3e:	6a 1c                	pushq  $0x1c
  jmp alltraps
ffffffff80108b40:	e9 d7 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b45 <vector29>:
.globl vector29
vector29:
  push $0
ffffffff80108b45:	6a 00                	pushq  $0x0
  push $29
ffffffff80108b47:	6a 1d                	pushq  $0x1d
  jmp alltraps
ffffffff80108b49:	e9 ce f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b4e <vector30>:
.globl vector30
vector30:
  push $0
ffffffff80108b4e:	6a 00                	pushq  $0x0
  push $30
ffffffff80108b50:	6a 1e                	pushq  $0x1e
  jmp alltraps
ffffffff80108b52:	e9 c5 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b57 <vector31>:
.globl vector31
vector31:
  push $0
ffffffff80108b57:	6a 00                	pushq  $0x0
  push $31
ffffffff80108b59:	6a 1f                	pushq  $0x1f
  jmp alltraps
ffffffff80108b5b:	e9 bc f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b60 <vector32>:
.globl vector32
vector32:
  push $0
ffffffff80108b60:	6a 00                	pushq  $0x0
  push $32
ffffffff80108b62:	6a 20                	pushq  $0x20
  jmp alltraps
ffffffff80108b64:	e9 b3 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b69 <vector33>:
.globl vector33
vector33:
  push $0
ffffffff80108b69:	6a 00                	pushq  $0x0
  push $33
ffffffff80108b6b:	6a 21                	pushq  $0x21
  jmp alltraps
ffffffff80108b6d:	e9 aa f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b72 <vector34>:
.globl vector34
vector34:
  push $0
ffffffff80108b72:	6a 00                	pushq  $0x0
  push $34
ffffffff80108b74:	6a 22                	pushq  $0x22
  jmp alltraps
ffffffff80108b76:	e9 a1 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b7b <vector35>:
.globl vector35
vector35:
  push $0
ffffffff80108b7b:	6a 00                	pushq  $0x0
  push $35
ffffffff80108b7d:	6a 23                	pushq  $0x23
  jmp alltraps
ffffffff80108b7f:	e9 98 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b84 <vector36>:
.globl vector36
vector36:
  push $0
ffffffff80108b84:	6a 00                	pushq  $0x0
  push $36
ffffffff80108b86:	6a 24                	pushq  $0x24
  jmp alltraps
ffffffff80108b88:	e9 8f f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b8d <vector37>:
.globl vector37
vector37:
  push $0
ffffffff80108b8d:	6a 00                	pushq  $0x0
  push $37
ffffffff80108b8f:	6a 25                	pushq  $0x25
  jmp alltraps
ffffffff80108b91:	e9 86 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b96 <vector38>:
.globl vector38
vector38:
  push $0
ffffffff80108b96:	6a 00                	pushq  $0x0
  push $38
ffffffff80108b98:	6a 26                	pushq  $0x26
  jmp alltraps
ffffffff80108b9a:	e9 7d f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108b9f <vector39>:
.globl vector39
vector39:
  push $0
ffffffff80108b9f:	6a 00                	pushq  $0x0
  push $39
ffffffff80108ba1:	6a 27                	pushq  $0x27
  jmp alltraps
ffffffff80108ba3:	e9 74 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ba8 <vector40>:
.globl vector40
vector40:
  push $0
ffffffff80108ba8:	6a 00                	pushq  $0x0
  push $40
ffffffff80108baa:	6a 28                	pushq  $0x28
  jmp alltraps
ffffffff80108bac:	e9 6b f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bb1 <vector41>:
.globl vector41
vector41:
  push $0
ffffffff80108bb1:	6a 00                	pushq  $0x0
  push $41
ffffffff80108bb3:	6a 29                	pushq  $0x29
  jmp alltraps
ffffffff80108bb5:	e9 62 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bba <vector42>:
.globl vector42
vector42:
  push $0
ffffffff80108bba:	6a 00                	pushq  $0x0
  push $42
ffffffff80108bbc:	6a 2a                	pushq  $0x2a
  jmp alltraps
ffffffff80108bbe:	e9 59 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bc3 <vector43>:
.globl vector43
vector43:
  push $0
ffffffff80108bc3:	6a 00                	pushq  $0x0
  push $43
ffffffff80108bc5:	6a 2b                	pushq  $0x2b
  jmp alltraps
ffffffff80108bc7:	e9 50 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bcc <vector44>:
.globl vector44
vector44:
  push $0
ffffffff80108bcc:	6a 00                	pushq  $0x0
  push $44
ffffffff80108bce:	6a 2c                	pushq  $0x2c
  jmp alltraps
ffffffff80108bd0:	e9 47 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bd5 <vector45>:
.globl vector45
vector45:
  push $0
ffffffff80108bd5:	6a 00                	pushq  $0x0
  push $45
ffffffff80108bd7:	6a 2d                	pushq  $0x2d
  jmp alltraps
ffffffff80108bd9:	e9 3e f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bde <vector46>:
.globl vector46
vector46:
  push $0
ffffffff80108bde:	6a 00                	pushq  $0x0
  push $46
ffffffff80108be0:	6a 2e                	pushq  $0x2e
  jmp alltraps
ffffffff80108be2:	e9 35 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108be7 <vector47>:
.globl vector47
vector47:
  push $0
ffffffff80108be7:	6a 00                	pushq  $0x0
  push $47
ffffffff80108be9:	6a 2f                	pushq  $0x2f
  jmp alltraps
ffffffff80108beb:	e9 2c f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bf0 <vector48>:
.globl vector48
vector48:
  push $0
ffffffff80108bf0:	6a 00                	pushq  $0x0
  push $48
ffffffff80108bf2:	6a 30                	pushq  $0x30
  jmp alltraps
ffffffff80108bf4:	e9 23 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108bf9 <vector49>:
.globl vector49
vector49:
  push $0
ffffffff80108bf9:	6a 00                	pushq  $0x0
  push $49
ffffffff80108bfb:	6a 31                	pushq  $0x31
  jmp alltraps
ffffffff80108bfd:	e9 1a f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c02 <vector50>:
.globl vector50
vector50:
  push $0
ffffffff80108c02:	6a 00                	pushq  $0x0
  push $50
ffffffff80108c04:	6a 32                	pushq  $0x32
  jmp alltraps
ffffffff80108c06:	e9 11 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c0b <vector51>:
.globl vector51
vector51:
  push $0
ffffffff80108c0b:	6a 00                	pushq  $0x0
  push $51
ffffffff80108c0d:	6a 33                	pushq  $0x33
  jmp alltraps
ffffffff80108c0f:	e9 08 f9 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c14 <vector52>:
.globl vector52
vector52:
  push $0
ffffffff80108c14:	6a 00                	pushq  $0x0
  push $52
ffffffff80108c16:	6a 34                	pushq  $0x34
  jmp alltraps
ffffffff80108c18:	e9 ff f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c1d <vector53>:
.globl vector53
vector53:
  push $0
ffffffff80108c1d:	6a 00                	pushq  $0x0
  push $53
ffffffff80108c1f:	6a 35                	pushq  $0x35
  jmp alltraps
ffffffff80108c21:	e9 f6 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c26 <vector54>:
.globl vector54
vector54:
  push $0
ffffffff80108c26:	6a 00                	pushq  $0x0
  push $54
ffffffff80108c28:	6a 36                	pushq  $0x36
  jmp alltraps
ffffffff80108c2a:	e9 ed f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c2f <vector55>:
.globl vector55
vector55:
  push $0
ffffffff80108c2f:	6a 00                	pushq  $0x0
  push $55
ffffffff80108c31:	6a 37                	pushq  $0x37
  jmp alltraps
ffffffff80108c33:	e9 e4 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c38 <vector56>:
.globl vector56
vector56:
  push $0
ffffffff80108c38:	6a 00                	pushq  $0x0
  push $56
ffffffff80108c3a:	6a 38                	pushq  $0x38
  jmp alltraps
ffffffff80108c3c:	e9 db f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c41 <vector57>:
.globl vector57
vector57:
  push $0
ffffffff80108c41:	6a 00                	pushq  $0x0
  push $57
ffffffff80108c43:	6a 39                	pushq  $0x39
  jmp alltraps
ffffffff80108c45:	e9 d2 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c4a <vector58>:
.globl vector58
vector58:
  push $0
ffffffff80108c4a:	6a 00                	pushq  $0x0
  push $58
ffffffff80108c4c:	6a 3a                	pushq  $0x3a
  jmp alltraps
ffffffff80108c4e:	e9 c9 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c53 <vector59>:
.globl vector59
vector59:
  push $0
ffffffff80108c53:	6a 00                	pushq  $0x0
  push $59
ffffffff80108c55:	6a 3b                	pushq  $0x3b
  jmp alltraps
ffffffff80108c57:	e9 c0 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c5c <vector60>:
.globl vector60
vector60:
  push $0
ffffffff80108c5c:	6a 00                	pushq  $0x0
  push $60
ffffffff80108c5e:	6a 3c                	pushq  $0x3c
  jmp alltraps
ffffffff80108c60:	e9 b7 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c65 <vector61>:
.globl vector61
vector61:
  push $0
ffffffff80108c65:	6a 00                	pushq  $0x0
  push $61
ffffffff80108c67:	6a 3d                	pushq  $0x3d
  jmp alltraps
ffffffff80108c69:	e9 ae f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c6e <vector62>:
.globl vector62
vector62:
  push $0
ffffffff80108c6e:	6a 00                	pushq  $0x0
  push $62
ffffffff80108c70:	6a 3e                	pushq  $0x3e
  jmp alltraps
ffffffff80108c72:	e9 a5 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c77 <vector63>:
.globl vector63
vector63:
  push $0
ffffffff80108c77:	6a 00                	pushq  $0x0
  push $63
ffffffff80108c79:	6a 3f                	pushq  $0x3f
  jmp alltraps
ffffffff80108c7b:	e9 9c f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c80 <vector64>:
.globl vector64
vector64:
  push $0
ffffffff80108c80:	6a 00                	pushq  $0x0
  push $64
ffffffff80108c82:	6a 40                	pushq  $0x40
  jmp alltraps
ffffffff80108c84:	e9 93 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c89 <vector65>:
.globl vector65
vector65:
  push $0
ffffffff80108c89:	6a 00                	pushq  $0x0
  push $65
ffffffff80108c8b:	6a 41                	pushq  $0x41
  jmp alltraps
ffffffff80108c8d:	e9 8a f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c92 <vector66>:
.globl vector66
vector66:
  push $0
ffffffff80108c92:	6a 00                	pushq  $0x0
  push $66
ffffffff80108c94:	6a 42                	pushq  $0x42
  jmp alltraps
ffffffff80108c96:	e9 81 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108c9b <vector67>:
.globl vector67
vector67:
  push $0
ffffffff80108c9b:	6a 00                	pushq  $0x0
  push $67
ffffffff80108c9d:	6a 43                	pushq  $0x43
  jmp alltraps
ffffffff80108c9f:	e9 78 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ca4 <vector68>:
.globl vector68
vector68:
  push $0
ffffffff80108ca4:	6a 00                	pushq  $0x0
  push $68
ffffffff80108ca6:	6a 44                	pushq  $0x44
  jmp alltraps
ffffffff80108ca8:	e9 6f f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cad <vector69>:
.globl vector69
vector69:
  push $0
ffffffff80108cad:	6a 00                	pushq  $0x0
  push $69
ffffffff80108caf:	6a 45                	pushq  $0x45
  jmp alltraps
ffffffff80108cb1:	e9 66 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cb6 <vector70>:
.globl vector70
vector70:
  push $0
ffffffff80108cb6:	6a 00                	pushq  $0x0
  push $70
ffffffff80108cb8:	6a 46                	pushq  $0x46
  jmp alltraps
ffffffff80108cba:	e9 5d f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cbf <vector71>:
.globl vector71
vector71:
  push $0
ffffffff80108cbf:	6a 00                	pushq  $0x0
  push $71
ffffffff80108cc1:	6a 47                	pushq  $0x47
  jmp alltraps
ffffffff80108cc3:	e9 54 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cc8 <vector72>:
.globl vector72
vector72:
  push $0
ffffffff80108cc8:	6a 00                	pushq  $0x0
  push $72
ffffffff80108cca:	6a 48                	pushq  $0x48
  jmp alltraps
ffffffff80108ccc:	e9 4b f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cd1 <vector73>:
.globl vector73
vector73:
  push $0
ffffffff80108cd1:	6a 00                	pushq  $0x0
  push $73
ffffffff80108cd3:	6a 49                	pushq  $0x49
  jmp alltraps
ffffffff80108cd5:	e9 42 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cda <vector74>:
.globl vector74
vector74:
  push $0
ffffffff80108cda:	6a 00                	pushq  $0x0
  push $74
ffffffff80108cdc:	6a 4a                	pushq  $0x4a
  jmp alltraps
ffffffff80108cde:	e9 39 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ce3 <vector75>:
.globl vector75
vector75:
  push $0
ffffffff80108ce3:	6a 00                	pushq  $0x0
  push $75
ffffffff80108ce5:	6a 4b                	pushq  $0x4b
  jmp alltraps
ffffffff80108ce7:	e9 30 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cec <vector76>:
.globl vector76
vector76:
  push $0
ffffffff80108cec:	6a 00                	pushq  $0x0
  push $76
ffffffff80108cee:	6a 4c                	pushq  $0x4c
  jmp alltraps
ffffffff80108cf0:	e9 27 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cf5 <vector77>:
.globl vector77
vector77:
  push $0
ffffffff80108cf5:	6a 00                	pushq  $0x0
  push $77
ffffffff80108cf7:	6a 4d                	pushq  $0x4d
  jmp alltraps
ffffffff80108cf9:	e9 1e f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108cfe <vector78>:
.globl vector78
vector78:
  push $0
ffffffff80108cfe:	6a 00                	pushq  $0x0
  push $78
ffffffff80108d00:	6a 4e                	pushq  $0x4e
  jmp alltraps
ffffffff80108d02:	e9 15 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d07 <vector79>:
.globl vector79
vector79:
  push $0
ffffffff80108d07:	6a 00                	pushq  $0x0
  push $79
ffffffff80108d09:	6a 4f                	pushq  $0x4f
  jmp alltraps
ffffffff80108d0b:	e9 0c f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d10 <vector80>:
.globl vector80
vector80:
  push $0
ffffffff80108d10:	6a 00                	pushq  $0x0
  push $80
ffffffff80108d12:	6a 50                	pushq  $0x50
  jmp alltraps
ffffffff80108d14:	e9 03 f8 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d19 <vector81>:
.globl vector81
vector81:
  push $0
ffffffff80108d19:	6a 00                	pushq  $0x0
  push $81
ffffffff80108d1b:	6a 51                	pushq  $0x51
  jmp alltraps
ffffffff80108d1d:	e9 fa f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d22 <vector82>:
.globl vector82
vector82:
  push $0
ffffffff80108d22:	6a 00                	pushq  $0x0
  push $82
ffffffff80108d24:	6a 52                	pushq  $0x52
  jmp alltraps
ffffffff80108d26:	e9 f1 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d2b <vector83>:
.globl vector83
vector83:
  push $0
ffffffff80108d2b:	6a 00                	pushq  $0x0
  push $83
ffffffff80108d2d:	6a 53                	pushq  $0x53
  jmp alltraps
ffffffff80108d2f:	e9 e8 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d34 <vector84>:
.globl vector84
vector84:
  push $0
ffffffff80108d34:	6a 00                	pushq  $0x0
  push $84
ffffffff80108d36:	6a 54                	pushq  $0x54
  jmp alltraps
ffffffff80108d38:	e9 df f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d3d <vector85>:
.globl vector85
vector85:
  push $0
ffffffff80108d3d:	6a 00                	pushq  $0x0
  push $85
ffffffff80108d3f:	6a 55                	pushq  $0x55
  jmp alltraps
ffffffff80108d41:	e9 d6 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d46 <vector86>:
.globl vector86
vector86:
  push $0
ffffffff80108d46:	6a 00                	pushq  $0x0
  push $86
ffffffff80108d48:	6a 56                	pushq  $0x56
  jmp alltraps
ffffffff80108d4a:	e9 cd f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d4f <vector87>:
.globl vector87
vector87:
  push $0
ffffffff80108d4f:	6a 00                	pushq  $0x0
  push $87
ffffffff80108d51:	6a 57                	pushq  $0x57
  jmp alltraps
ffffffff80108d53:	e9 c4 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d58 <vector88>:
.globl vector88
vector88:
  push $0
ffffffff80108d58:	6a 00                	pushq  $0x0
  push $88
ffffffff80108d5a:	6a 58                	pushq  $0x58
  jmp alltraps
ffffffff80108d5c:	e9 bb f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d61 <vector89>:
.globl vector89
vector89:
  push $0
ffffffff80108d61:	6a 00                	pushq  $0x0
  push $89
ffffffff80108d63:	6a 59                	pushq  $0x59
  jmp alltraps
ffffffff80108d65:	e9 b2 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d6a <vector90>:
.globl vector90
vector90:
  push $0
ffffffff80108d6a:	6a 00                	pushq  $0x0
  push $90
ffffffff80108d6c:	6a 5a                	pushq  $0x5a
  jmp alltraps
ffffffff80108d6e:	e9 a9 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d73 <vector91>:
.globl vector91
vector91:
  push $0
ffffffff80108d73:	6a 00                	pushq  $0x0
  push $91
ffffffff80108d75:	6a 5b                	pushq  $0x5b
  jmp alltraps
ffffffff80108d77:	e9 a0 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d7c <vector92>:
.globl vector92
vector92:
  push $0
ffffffff80108d7c:	6a 00                	pushq  $0x0
  push $92
ffffffff80108d7e:	6a 5c                	pushq  $0x5c
  jmp alltraps
ffffffff80108d80:	e9 97 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d85 <vector93>:
.globl vector93
vector93:
  push $0
ffffffff80108d85:	6a 00                	pushq  $0x0
  push $93
ffffffff80108d87:	6a 5d                	pushq  $0x5d
  jmp alltraps
ffffffff80108d89:	e9 8e f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d8e <vector94>:
.globl vector94
vector94:
  push $0
ffffffff80108d8e:	6a 00                	pushq  $0x0
  push $94
ffffffff80108d90:	6a 5e                	pushq  $0x5e
  jmp alltraps
ffffffff80108d92:	e9 85 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108d97 <vector95>:
.globl vector95
vector95:
  push $0
ffffffff80108d97:	6a 00                	pushq  $0x0
  push $95
ffffffff80108d99:	6a 5f                	pushq  $0x5f
  jmp alltraps
ffffffff80108d9b:	e9 7c f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108da0 <vector96>:
.globl vector96
vector96:
  push $0
ffffffff80108da0:	6a 00                	pushq  $0x0
  push $96
ffffffff80108da2:	6a 60                	pushq  $0x60
  jmp alltraps
ffffffff80108da4:	e9 73 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108da9 <vector97>:
.globl vector97
vector97:
  push $0
ffffffff80108da9:	6a 00                	pushq  $0x0
  push $97
ffffffff80108dab:	6a 61                	pushq  $0x61
  jmp alltraps
ffffffff80108dad:	e9 6a f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108db2 <vector98>:
.globl vector98
vector98:
  push $0
ffffffff80108db2:	6a 00                	pushq  $0x0
  push $98
ffffffff80108db4:	6a 62                	pushq  $0x62
  jmp alltraps
ffffffff80108db6:	e9 61 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108dbb <vector99>:
.globl vector99
vector99:
  push $0
ffffffff80108dbb:	6a 00                	pushq  $0x0
  push $99
ffffffff80108dbd:	6a 63                	pushq  $0x63
  jmp alltraps
ffffffff80108dbf:	e9 58 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108dc4 <vector100>:
.globl vector100
vector100:
  push $0
ffffffff80108dc4:	6a 00                	pushq  $0x0
  push $100
ffffffff80108dc6:	6a 64                	pushq  $0x64
  jmp alltraps
ffffffff80108dc8:	e9 4f f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108dcd <vector101>:
.globl vector101
vector101:
  push $0
ffffffff80108dcd:	6a 00                	pushq  $0x0
  push $101
ffffffff80108dcf:	6a 65                	pushq  $0x65
  jmp alltraps
ffffffff80108dd1:	e9 46 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108dd6 <vector102>:
.globl vector102
vector102:
  push $0
ffffffff80108dd6:	6a 00                	pushq  $0x0
  push $102
ffffffff80108dd8:	6a 66                	pushq  $0x66
  jmp alltraps
ffffffff80108dda:	e9 3d f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ddf <vector103>:
.globl vector103
vector103:
  push $0
ffffffff80108ddf:	6a 00                	pushq  $0x0
  push $103
ffffffff80108de1:	6a 67                	pushq  $0x67
  jmp alltraps
ffffffff80108de3:	e9 34 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108de8 <vector104>:
.globl vector104
vector104:
  push $0
ffffffff80108de8:	6a 00                	pushq  $0x0
  push $104
ffffffff80108dea:	6a 68                	pushq  $0x68
  jmp alltraps
ffffffff80108dec:	e9 2b f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108df1 <vector105>:
.globl vector105
vector105:
  push $0
ffffffff80108df1:	6a 00                	pushq  $0x0
  push $105
ffffffff80108df3:	6a 69                	pushq  $0x69
  jmp alltraps
ffffffff80108df5:	e9 22 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108dfa <vector106>:
.globl vector106
vector106:
  push $0
ffffffff80108dfa:	6a 00                	pushq  $0x0
  push $106
ffffffff80108dfc:	6a 6a                	pushq  $0x6a
  jmp alltraps
ffffffff80108dfe:	e9 19 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e03 <vector107>:
.globl vector107
vector107:
  push $0
ffffffff80108e03:	6a 00                	pushq  $0x0
  push $107
ffffffff80108e05:	6a 6b                	pushq  $0x6b
  jmp alltraps
ffffffff80108e07:	e9 10 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e0c <vector108>:
.globl vector108
vector108:
  push $0
ffffffff80108e0c:	6a 00                	pushq  $0x0
  push $108
ffffffff80108e0e:	6a 6c                	pushq  $0x6c
  jmp alltraps
ffffffff80108e10:	e9 07 f7 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e15 <vector109>:
.globl vector109
vector109:
  push $0
ffffffff80108e15:	6a 00                	pushq  $0x0
  push $109
ffffffff80108e17:	6a 6d                	pushq  $0x6d
  jmp alltraps
ffffffff80108e19:	e9 fe f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e1e <vector110>:
.globl vector110
vector110:
  push $0
ffffffff80108e1e:	6a 00                	pushq  $0x0
  push $110
ffffffff80108e20:	6a 6e                	pushq  $0x6e
  jmp alltraps
ffffffff80108e22:	e9 f5 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e27 <vector111>:
.globl vector111
vector111:
  push $0
ffffffff80108e27:	6a 00                	pushq  $0x0
  push $111
ffffffff80108e29:	6a 6f                	pushq  $0x6f
  jmp alltraps
ffffffff80108e2b:	e9 ec f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e30 <vector112>:
.globl vector112
vector112:
  push $0
ffffffff80108e30:	6a 00                	pushq  $0x0
  push $112
ffffffff80108e32:	6a 70                	pushq  $0x70
  jmp alltraps
ffffffff80108e34:	e9 e3 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e39 <vector113>:
.globl vector113
vector113:
  push $0
ffffffff80108e39:	6a 00                	pushq  $0x0
  push $113
ffffffff80108e3b:	6a 71                	pushq  $0x71
  jmp alltraps
ffffffff80108e3d:	e9 da f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e42 <vector114>:
.globl vector114
vector114:
  push $0
ffffffff80108e42:	6a 00                	pushq  $0x0
  push $114
ffffffff80108e44:	6a 72                	pushq  $0x72
  jmp alltraps
ffffffff80108e46:	e9 d1 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e4b <vector115>:
.globl vector115
vector115:
  push $0
ffffffff80108e4b:	6a 00                	pushq  $0x0
  push $115
ffffffff80108e4d:	6a 73                	pushq  $0x73
  jmp alltraps
ffffffff80108e4f:	e9 c8 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e54 <vector116>:
.globl vector116
vector116:
  push $0
ffffffff80108e54:	6a 00                	pushq  $0x0
  push $116
ffffffff80108e56:	6a 74                	pushq  $0x74
  jmp alltraps
ffffffff80108e58:	e9 bf f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e5d <vector117>:
.globl vector117
vector117:
  push $0
ffffffff80108e5d:	6a 00                	pushq  $0x0
  push $117
ffffffff80108e5f:	6a 75                	pushq  $0x75
  jmp alltraps
ffffffff80108e61:	e9 b6 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e66 <vector118>:
.globl vector118
vector118:
  push $0
ffffffff80108e66:	6a 00                	pushq  $0x0
  push $118
ffffffff80108e68:	6a 76                	pushq  $0x76
  jmp alltraps
ffffffff80108e6a:	e9 ad f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e6f <vector119>:
.globl vector119
vector119:
  push $0
ffffffff80108e6f:	6a 00                	pushq  $0x0
  push $119
ffffffff80108e71:	6a 77                	pushq  $0x77
  jmp alltraps
ffffffff80108e73:	e9 a4 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e78 <vector120>:
.globl vector120
vector120:
  push $0
ffffffff80108e78:	6a 00                	pushq  $0x0
  push $120
ffffffff80108e7a:	6a 78                	pushq  $0x78
  jmp alltraps
ffffffff80108e7c:	e9 9b f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e81 <vector121>:
.globl vector121
vector121:
  push $0
ffffffff80108e81:	6a 00                	pushq  $0x0
  push $121
ffffffff80108e83:	6a 79                	pushq  $0x79
  jmp alltraps
ffffffff80108e85:	e9 92 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e8a <vector122>:
.globl vector122
vector122:
  push $0
ffffffff80108e8a:	6a 00                	pushq  $0x0
  push $122
ffffffff80108e8c:	6a 7a                	pushq  $0x7a
  jmp alltraps
ffffffff80108e8e:	e9 89 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e93 <vector123>:
.globl vector123
vector123:
  push $0
ffffffff80108e93:	6a 00                	pushq  $0x0
  push $123
ffffffff80108e95:	6a 7b                	pushq  $0x7b
  jmp alltraps
ffffffff80108e97:	e9 80 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108e9c <vector124>:
.globl vector124
vector124:
  push $0
ffffffff80108e9c:	6a 00                	pushq  $0x0
  push $124
ffffffff80108e9e:	6a 7c                	pushq  $0x7c
  jmp alltraps
ffffffff80108ea0:	e9 77 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ea5 <vector125>:
.globl vector125
vector125:
  push $0
ffffffff80108ea5:	6a 00                	pushq  $0x0
  push $125
ffffffff80108ea7:	6a 7d                	pushq  $0x7d
  jmp alltraps
ffffffff80108ea9:	e9 6e f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108eae <vector126>:
.globl vector126
vector126:
  push $0
ffffffff80108eae:	6a 00                	pushq  $0x0
  push $126
ffffffff80108eb0:	6a 7e                	pushq  $0x7e
  jmp alltraps
ffffffff80108eb2:	e9 65 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108eb7 <vector127>:
.globl vector127
vector127:
  push $0
ffffffff80108eb7:	6a 00                	pushq  $0x0
  push $127
ffffffff80108eb9:	6a 7f                	pushq  $0x7f
  jmp alltraps
ffffffff80108ebb:	e9 5c f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ec0 <vector128>:
.globl vector128
vector128:
  push $0
ffffffff80108ec0:	6a 00                	pushq  $0x0
  push $128
ffffffff80108ec2:	68 80 00 00 00       	pushq  $0x80
  jmp alltraps
ffffffff80108ec7:	e9 50 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ecc <vector129>:
.globl vector129
vector129:
  push $0
ffffffff80108ecc:	6a 00                	pushq  $0x0
  push $129
ffffffff80108ece:	68 81 00 00 00       	pushq  $0x81
  jmp alltraps
ffffffff80108ed3:	e9 44 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ed8 <vector130>:
.globl vector130
vector130:
  push $0
ffffffff80108ed8:	6a 00                	pushq  $0x0
  push $130
ffffffff80108eda:	68 82 00 00 00       	pushq  $0x82
  jmp alltraps
ffffffff80108edf:	e9 38 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ee4 <vector131>:
.globl vector131
vector131:
  push $0
ffffffff80108ee4:	6a 00                	pushq  $0x0
  push $131
ffffffff80108ee6:	68 83 00 00 00       	pushq  $0x83
  jmp alltraps
ffffffff80108eeb:	e9 2c f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ef0 <vector132>:
.globl vector132
vector132:
  push $0
ffffffff80108ef0:	6a 00                	pushq  $0x0
  push $132
ffffffff80108ef2:	68 84 00 00 00       	pushq  $0x84
  jmp alltraps
ffffffff80108ef7:	e9 20 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108efc <vector133>:
.globl vector133
vector133:
  push $0
ffffffff80108efc:	6a 00                	pushq  $0x0
  push $133
ffffffff80108efe:	68 85 00 00 00       	pushq  $0x85
  jmp alltraps
ffffffff80108f03:	e9 14 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f08 <vector134>:
.globl vector134
vector134:
  push $0
ffffffff80108f08:	6a 00                	pushq  $0x0
  push $134
ffffffff80108f0a:	68 86 00 00 00       	pushq  $0x86
  jmp alltraps
ffffffff80108f0f:	e9 08 f6 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f14 <vector135>:
.globl vector135
vector135:
  push $0
ffffffff80108f14:	6a 00                	pushq  $0x0
  push $135
ffffffff80108f16:	68 87 00 00 00       	pushq  $0x87
  jmp alltraps
ffffffff80108f1b:	e9 fc f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f20 <vector136>:
.globl vector136
vector136:
  push $0
ffffffff80108f20:	6a 00                	pushq  $0x0
  push $136
ffffffff80108f22:	68 88 00 00 00       	pushq  $0x88
  jmp alltraps
ffffffff80108f27:	e9 f0 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f2c <vector137>:
.globl vector137
vector137:
  push $0
ffffffff80108f2c:	6a 00                	pushq  $0x0
  push $137
ffffffff80108f2e:	68 89 00 00 00       	pushq  $0x89
  jmp alltraps
ffffffff80108f33:	e9 e4 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f38 <vector138>:
.globl vector138
vector138:
  push $0
ffffffff80108f38:	6a 00                	pushq  $0x0
  push $138
ffffffff80108f3a:	68 8a 00 00 00       	pushq  $0x8a
  jmp alltraps
ffffffff80108f3f:	e9 d8 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f44 <vector139>:
.globl vector139
vector139:
  push $0
ffffffff80108f44:	6a 00                	pushq  $0x0
  push $139
ffffffff80108f46:	68 8b 00 00 00       	pushq  $0x8b
  jmp alltraps
ffffffff80108f4b:	e9 cc f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f50 <vector140>:
.globl vector140
vector140:
  push $0
ffffffff80108f50:	6a 00                	pushq  $0x0
  push $140
ffffffff80108f52:	68 8c 00 00 00       	pushq  $0x8c
  jmp alltraps
ffffffff80108f57:	e9 c0 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f5c <vector141>:
.globl vector141
vector141:
  push $0
ffffffff80108f5c:	6a 00                	pushq  $0x0
  push $141
ffffffff80108f5e:	68 8d 00 00 00       	pushq  $0x8d
  jmp alltraps
ffffffff80108f63:	e9 b4 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f68 <vector142>:
.globl vector142
vector142:
  push $0
ffffffff80108f68:	6a 00                	pushq  $0x0
  push $142
ffffffff80108f6a:	68 8e 00 00 00       	pushq  $0x8e
  jmp alltraps
ffffffff80108f6f:	e9 a8 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f74 <vector143>:
.globl vector143
vector143:
  push $0
ffffffff80108f74:	6a 00                	pushq  $0x0
  push $143
ffffffff80108f76:	68 8f 00 00 00       	pushq  $0x8f
  jmp alltraps
ffffffff80108f7b:	e9 9c f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f80 <vector144>:
.globl vector144
vector144:
  push $0
ffffffff80108f80:	6a 00                	pushq  $0x0
  push $144
ffffffff80108f82:	68 90 00 00 00       	pushq  $0x90
  jmp alltraps
ffffffff80108f87:	e9 90 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f8c <vector145>:
.globl vector145
vector145:
  push $0
ffffffff80108f8c:	6a 00                	pushq  $0x0
  push $145
ffffffff80108f8e:	68 91 00 00 00       	pushq  $0x91
  jmp alltraps
ffffffff80108f93:	e9 84 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108f98 <vector146>:
.globl vector146
vector146:
  push $0
ffffffff80108f98:	6a 00                	pushq  $0x0
  push $146
ffffffff80108f9a:	68 92 00 00 00       	pushq  $0x92
  jmp alltraps
ffffffff80108f9f:	e9 78 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fa4 <vector147>:
.globl vector147
vector147:
  push $0
ffffffff80108fa4:	6a 00                	pushq  $0x0
  push $147
ffffffff80108fa6:	68 93 00 00 00       	pushq  $0x93
  jmp alltraps
ffffffff80108fab:	e9 6c f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fb0 <vector148>:
.globl vector148
vector148:
  push $0
ffffffff80108fb0:	6a 00                	pushq  $0x0
  push $148
ffffffff80108fb2:	68 94 00 00 00       	pushq  $0x94
  jmp alltraps
ffffffff80108fb7:	e9 60 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fbc <vector149>:
.globl vector149
vector149:
  push $0
ffffffff80108fbc:	6a 00                	pushq  $0x0
  push $149
ffffffff80108fbe:	68 95 00 00 00       	pushq  $0x95
  jmp alltraps
ffffffff80108fc3:	e9 54 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fc8 <vector150>:
.globl vector150
vector150:
  push $0
ffffffff80108fc8:	6a 00                	pushq  $0x0
  push $150
ffffffff80108fca:	68 96 00 00 00       	pushq  $0x96
  jmp alltraps
ffffffff80108fcf:	e9 48 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fd4 <vector151>:
.globl vector151
vector151:
  push $0
ffffffff80108fd4:	6a 00                	pushq  $0x0
  push $151
ffffffff80108fd6:	68 97 00 00 00       	pushq  $0x97
  jmp alltraps
ffffffff80108fdb:	e9 3c f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fe0 <vector152>:
.globl vector152
vector152:
  push $0
ffffffff80108fe0:	6a 00                	pushq  $0x0
  push $152
ffffffff80108fe2:	68 98 00 00 00       	pushq  $0x98
  jmp alltraps
ffffffff80108fe7:	e9 30 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108fec <vector153>:
.globl vector153
vector153:
  push $0
ffffffff80108fec:	6a 00                	pushq  $0x0
  push $153
ffffffff80108fee:	68 99 00 00 00       	pushq  $0x99
  jmp alltraps
ffffffff80108ff3:	e9 24 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80108ff8 <vector154>:
.globl vector154
vector154:
  push $0
ffffffff80108ff8:	6a 00                	pushq  $0x0
  push $154
ffffffff80108ffa:	68 9a 00 00 00       	pushq  $0x9a
  jmp alltraps
ffffffff80108fff:	e9 18 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109004 <vector155>:
.globl vector155
vector155:
  push $0
ffffffff80109004:	6a 00                	pushq  $0x0
  push $155
ffffffff80109006:	68 9b 00 00 00       	pushq  $0x9b
  jmp alltraps
ffffffff8010900b:	e9 0c f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109010 <vector156>:
.globl vector156
vector156:
  push $0
ffffffff80109010:	6a 00                	pushq  $0x0
  push $156
ffffffff80109012:	68 9c 00 00 00       	pushq  $0x9c
  jmp alltraps
ffffffff80109017:	e9 00 f5 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010901c <vector157>:
.globl vector157
vector157:
  push $0
ffffffff8010901c:	6a 00                	pushq  $0x0
  push $157
ffffffff8010901e:	68 9d 00 00 00       	pushq  $0x9d
  jmp alltraps
ffffffff80109023:	e9 f4 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109028 <vector158>:
.globl vector158
vector158:
  push $0
ffffffff80109028:	6a 00                	pushq  $0x0
  push $158
ffffffff8010902a:	68 9e 00 00 00       	pushq  $0x9e
  jmp alltraps
ffffffff8010902f:	e9 e8 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109034 <vector159>:
.globl vector159
vector159:
  push $0
ffffffff80109034:	6a 00                	pushq  $0x0
  push $159
ffffffff80109036:	68 9f 00 00 00       	pushq  $0x9f
  jmp alltraps
ffffffff8010903b:	e9 dc f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109040 <vector160>:
.globl vector160
vector160:
  push $0
ffffffff80109040:	6a 00                	pushq  $0x0
  push $160
ffffffff80109042:	68 a0 00 00 00       	pushq  $0xa0
  jmp alltraps
ffffffff80109047:	e9 d0 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010904c <vector161>:
.globl vector161
vector161:
  push $0
ffffffff8010904c:	6a 00                	pushq  $0x0
  push $161
ffffffff8010904e:	68 a1 00 00 00       	pushq  $0xa1
  jmp alltraps
ffffffff80109053:	e9 c4 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109058 <vector162>:
.globl vector162
vector162:
  push $0
ffffffff80109058:	6a 00                	pushq  $0x0
  push $162
ffffffff8010905a:	68 a2 00 00 00       	pushq  $0xa2
  jmp alltraps
ffffffff8010905f:	e9 b8 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109064 <vector163>:
.globl vector163
vector163:
  push $0
ffffffff80109064:	6a 00                	pushq  $0x0
  push $163
ffffffff80109066:	68 a3 00 00 00       	pushq  $0xa3
  jmp alltraps
ffffffff8010906b:	e9 ac f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109070 <vector164>:
.globl vector164
vector164:
  push $0
ffffffff80109070:	6a 00                	pushq  $0x0
  push $164
ffffffff80109072:	68 a4 00 00 00       	pushq  $0xa4
  jmp alltraps
ffffffff80109077:	e9 a0 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010907c <vector165>:
.globl vector165
vector165:
  push $0
ffffffff8010907c:	6a 00                	pushq  $0x0
  push $165
ffffffff8010907e:	68 a5 00 00 00       	pushq  $0xa5
  jmp alltraps
ffffffff80109083:	e9 94 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109088 <vector166>:
.globl vector166
vector166:
  push $0
ffffffff80109088:	6a 00                	pushq  $0x0
  push $166
ffffffff8010908a:	68 a6 00 00 00       	pushq  $0xa6
  jmp alltraps
ffffffff8010908f:	e9 88 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109094 <vector167>:
.globl vector167
vector167:
  push $0
ffffffff80109094:	6a 00                	pushq  $0x0
  push $167
ffffffff80109096:	68 a7 00 00 00       	pushq  $0xa7
  jmp alltraps
ffffffff8010909b:	e9 7c f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090a0 <vector168>:
.globl vector168
vector168:
  push $0
ffffffff801090a0:	6a 00                	pushq  $0x0
  push $168
ffffffff801090a2:	68 a8 00 00 00       	pushq  $0xa8
  jmp alltraps
ffffffff801090a7:	e9 70 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090ac <vector169>:
.globl vector169
vector169:
  push $0
ffffffff801090ac:	6a 00                	pushq  $0x0
  push $169
ffffffff801090ae:	68 a9 00 00 00       	pushq  $0xa9
  jmp alltraps
ffffffff801090b3:	e9 64 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090b8 <vector170>:
.globl vector170
vector170:
  push $0
ffffffff801090b8:	6a 00                	pushq  $0x0
  push $170
ffffffff801090ba:	68 aa 00 00 00       	pushq  $0xaa
  jmp alltraps
ffffffff801090bf:	e9 58 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090c4 <vector171>:
.globl vector171
vector171:
  push $0
ffffffff801090c4:	6a 00                	pushq  $0x0
  push $171
ffffffff801090c6:	68 ab 00 00 00       	pushq  $0xab
  jmp alltraps
ffffffff801090cb:	e9 4c f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090d0 <vector172>:
.globl vector172
vector172:
  push $0
ffffffff801090d0:	6a 00                	pushq  $0x0
  push $172
ffffffff801090d2:	68 ac 00 00 00       	pushq  $0xac
  jmp alltraps
ffffffff801090d7:	e9 40 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090dc <vector173>:
.globl vector173
vector173:
  push $0
ffffffff801090dc:	6a 00                	pushq  $0x0
  push $173
ffffffff801090de:	68 ad 00 00 00       	pushq  $0xad
  jmp alltraps
ffffffff801090e3:	e9 34 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090e8 <vector174>:
.globl vector174
vector174:
  push $0
ffffffff801090e8:	6a 00                	pushq  $0x0
  push $174
ffffffff801090ea:	68 ae 00 00 00       	pushq  $0xae
  jmp alltraps
ffffffff801090ef:	e9 28 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801090f4 <vector175>:
.globl vector175
vector175:
  push $0
ffffffff801090f4:	6a 00                	pushq  $0x0
  push $175
ffffffff801090f6:	68 af 00 00 00       	pushq  $0xaf
  jmp alltraps
ffffffff801090fb:	e9 1c f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109100 <vector176>:
.globl vector176
vector176:
  push $0
ffffffff80109100:	6a 00                	pushq  $0x0
  push $176
ffffffff80109102:	68 b0 00 00 00       	pushq  $0xb0
  jmp alltraps
ffffffff80109107:	e9 10 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010910c <vector177>:
.globl vector177
vector177:
  push $0
ffffffff8010910c:	6a 00                	pushq  $0x0
  push $177
ffffffff8010910e:	68 b1 00 00 00       	pushq  $0xb1
  jmp alltraps
ffffffff80109113:	e9 04 f4 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109118 <vector178>:
.globl vector178
vector178:
  push $0
ffffffff80109118:	6a 00                	pushq  $0x0
  push $178
ffffffff8010911a:	68 b2 00 00 00       	pushq  $0xb2
  jmp alltraps
ffffffff8010911f:	e9 f8 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109124 <vector179>:
.globl vector179
vector179:
  push $0
ffffffff80109124:	6a 00                	pushq  $0x0
  push $179
ffffffff80109126:	68 b3 00 00 00       	pushq  $0xb3
  jmp alltraps
ffffffff8010912b:	e9 ec f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109130 <vector180>:
.globl vector180
vector180:
  push $0
ffffffff80109130:	6a 00                	pushq  $0x0
  push $180
ffffffff80109132:	68 b4 00 00 00       	pushq  $0xb4
  jmp alltraps
ffffffff80109137:	e9 e0 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010913c <vector181>:
.globl vector181
vector181:
  push $0
ffffffff8010913c:	6a 00                	pushq  $0x0
  push $181
ffffffff8010913e:	68 b5 00 00 00       	pushq  $0xb5
  jmp alltraps
ffffffff80109143:	e9 d4 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109148 <vector182>:
.globl vector182
vector182:
  push $0
ffffffff80109148:	6a 00                	pushq  $0x0
  push $182
ffffffff8010914a:	68 b6 00 00 00       	pushq  $0xb6
  jmp alltraps
ffffffff8010914f:	e9 c8 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109154 <vector183>:
.globl vector183
vector183:
  push $0
ffffffff80109154:	6a 00                	pushq  $0x0
  push $183
ffffffff80109156:	68 b7 00 00 00       	pushq  $0xb7
  jmp alltraps
ffffffff8010915b:	e9 bc f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109160 <vector184>:
.globl vector184
vector184:
  push $0
ffffffff80109160:	6a 00                	pushq  $0x0
  push $184
ffffffff80109162:	68 b8 00 00 00       	pushq  $0xb8
  jmp alltraps
ffffffff80109167:	e9 b0 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010916c <vector185>:
.globl vector185
vector185:
  push $0
ffffffff8010916c:	6a 00                	pushq  $0x0
  push $185
ffffffff8010916e:	68 b9 00 00 00       	pushq  $0xb9
  jmp alltraps
ffffffff80109173:	e9 a4 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109178 <vector186>:
.globl vector186
vector186:
  push $0
ffffffff80109178:	6a 00                	pushq  $0x0
  push $186
ffffffff8010917a:	68 ba 00 00 00       	pushq  $0xba
  jmp alltraps
ffffffff8010917f:	e9 98 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109184 <vector187>:
.globl vector187
vector187:
  push $0
ffffffff80109184:	6a 00                	pushq  $0x0
  push $187
ffffffff80109186:	68 bb 00 00 00       	pushq  $0xbb
  jmp alltraps
ffffffff8010918b:	e9 8c f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109190 <vector188>:
.globl vector188
vector188:
  push $0
ffffffff80109190:	6a 00                	pushq  $0x0
  push $188
ffffffff80109192:	68 bc 00 00 00       	pushq  $0xbc
  jmp alltraps
ffffffff80109197:	e9 80 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010919c <vector189>:
.globl vector189
vector189:
  push $0
ffffffff8010919c:	6a 00                	pushq  $0x0
  push $189
ffffffff8010919e:	68 bd 00 00 00       	pushq  $0xbd
  jmp alltraps
ffffffff801091a3:	e9 74 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091a8 <vector190>:
.globl vector190
vector190:
  push $0
ffffffff801091a8:	6a 00                	pushq  $0x0
  push $190
ffffffff801091aa:	68 be 00 00 00       	pushq  $0xbe
  jmp alltraps
ffffffff801091af:	e9 68 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091b4 <vector191>:
.globl vector191
vector191:
  push $0
ffffffff801091b4:	6a 00                	pushq  $0x0
  push $191
ffffffff801091b6:	68 bf 00 00 00       	pushq  $0xbf
  jmp alltraps
ffffffff801091bb:	e9 5c f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091c0 <vector192>:
.globl vector192
vector192:
  push $0
ffffffff801091c0:	6a 00                	pushq  $0x0
  push $192
ffffffff801091c2:	68 c0 00 00 00       	pushq  $0xc0
  jmp alltraps
ffffffff801091c7:	e9 50 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091cc <vector193>:
.globl vector193
vector193:
  push $0
ffffffff801091cc:	6a 00                	pushq  $0x0
  push $193
ffffffff801091ce:	68 c1 00 00 00       	pushq  $0xc1
  jmp alltraps
ffffffff801091d3:	e9 44 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091d8 <vector194>:
.globl vector194
vector194:
  push $0
ffffffff801091d8:	6a 00                	pushq  $0x0
  push $194
ffffffff801091da:	68 c2 00 00 00       	pushq  $0xc2
  jmp alltraps
ffffffff801091df:	e9 38 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091e4 <vector195>:
.globl vector195
vector195:
  push $0
ffffffff801091e4:	6a 00                	pushq  $0x0
  push $195
ffffffff801091e6:	68 c3 00 00 00       	pushq  $0xc3
  jmp alltraps
ffffffff801091eb:	e9 2c f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091f0 <vector196>:
.globl vector196
vector196:
  push $0
ffffffff801091f0:	6a 00                	pushq  $0x0
  push $196
ffffffff801091f2:	68 c4 00 00 00       	pushq  $0xc4
  jmp alltraps
ffffffff801091f7:	e9 20 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801091fc <vector197>:
.globl vector197
vector197:
  push $0
ffffffff801091fc:	6a 00                	pushq  $0x0
  push $197
ffffffff801091fe:	68 c5 00 00 00       	pushq  $0xc5
  jmp alltraps
ffffffff80109203:	e9 14 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109208 <vector198>:
.globl vector198
vector198:
  push $0
ffffffff80109208:	6a 00                	pushq  $0x0
  push $198
ffffffff8010920a:	68 c6 00 00 00       	pushq  $0xc6
  jmp alltraps
ffffffff8010920f:	e9 08 f3 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109214 <vector199>:
.globl vector199
vector199:
  push $0
ffffffff80109214:	6a 00                	pushq  $0x0
  push $199
ffffffff80109216:	68 c7 00 00 00       	pushq  $0xc7
  jmp alltraps
ffffffff8010921b:	e9 fc f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109220 <vector200>:
.globl vector200
vector200:
  push $0
ffffffff80109220:	6a 00                	pushq  $0x0
  push $200
ffffffff80109222:	68 c8 00 00 00       	pushq  $0xc8
  jmp alltraps
ffffffff80109227:	e9 f0 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010922c <vector201>:
.globl vector201
vector201:
  push $0
ffffffff8010922c:	6a 00                	pushq  $0x0
  push $201
ffffffff8010922e:	68 c9 00 00 00       	pushq  $0xc9
  jmp alltraps
ffffffff80109233:	e9 e4 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109238 <vector202>:
.globl vector202
vector202:
  push $0
ffffffff80109238:	6a 00                	pushq  $0x0
  push $202
ffffffff8010923a:	68 ca 00 00 00       	pushq  $0xca
  jmp alltraps
ffffffff8010923f:	e9 d8 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109244 <vector203>:
.globl vector203
vector203:
  push $0
ffffffff80109244:	6a 00                	pushq  $0x0
  push $203
ffffffff80109246:	68 cb 00 00 00       	pushq  $0xcb
  jmp alltraps
ffffffff8010924b:	e9 cc f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109250 <vector204>:
.globl vector204
vector204:
  push $0
ffffffff80109250:	6a 00                	pushq  $0x0
  push $204
ffffffff80109252:	68 cc 00 00 00       	pushq  $0xcc
  jmp alltraps
ffffffff80109257:	e9 c0 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010925c <vector205>:
.globl vector205
vector205:
  push $0
ffffffff8010925c:	6a 00                	pushq  $0x0
  push $205
ffffffff8010925e:	68 cd 00 00 00       	pushq  $0xcd
  jmp alltraps
ffffffff80109263:	e9 b4 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109268 <vector206>:
.globl vector206
vector206:
  push $0
ffffffff80109268:	6a 00                	pushq  $0x0
  push $206
ffffffff8010926a:	68 ce 00 00 00       	pushq  $0xce
  jmp alltraps
ffffffff8010926f:	e9 a8 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109274 <vector207>:
.globl vector207
vector207:
  push $0
ffffffff80109274:	6a 00                	pushq  $0x0
  push $207
ffffffff80109276:	68 cf 00 00 00       	pushq  $0xcf
  jmp alltraps
ffffffff8010927b:	e9 9c f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109280 <vector208>:
.globl vector208
vector208:
  push $0
ffffffff80109280:	6a 00                	pushq  $0x0
  push $208
ffffffff80109282:	68 d0 00 00 00       	pushq  $0xd0
  jmp alltraps
ffffffff80109287:	e9 90 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010928c <vector209>:
.globl vector209
vector209:
  push $0
ffffffff8010928c:	6a 00                	pushq  $0x0
  push $209
ffffffff8010928e:	68 d1 00 00 00       	pushq  $0xd1
  jmp alltraps
ffffffff80109293:	e9 84 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109298 <vector210>:
.globl vector210
vector210:
  push $0
ffffffff80109298:	6a 00                	pushq  $0x0
  push $210
ffffffff8010929a:	68 d2 00 00 00       	pushq  $0xd2
  jmp alltraps
ffffffff8010929f:	e9 78 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092a4 <vector211>:
.globl vector211
vector211:
  push $0
ffffffff801092a4:	6a 00                	pushq  $0x0
  push $211
ffffffff801092a6:	68 d3 00 00 00       	pushq  $0xd3
  jmp alltraps
ffffffff801092ab:	e9 6c f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092b0 <vector212>:
.globl vector212
vector212:
  push $0
ffffffff801092b0:	6a 00                	pushq  $0x0
  push $212
ffffffff801092b2:	68 d4 00 00 00       	pushq  $0xd4
  jmp alltraps
ffffffff801092b7:	e9 60 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092bc <vector213>:
.globl vector213
vector213:
  push $0
ffffffff801092bc:	6a 00                	pushq  $0x0
  push $213
ffffffff801092be:	68 d5 00 00 00       	pushq  $0xd5
  jmp alltraps
ffffffff801092c3:	e9 54 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092c8 <vector214>:
.globl vector214
vector214:
  push $0
ffffffff801092c8:	6a 00                	pushq  $0x0
  push $214
ffffffff801092ca:	68 d6 00 00 00       	pushq  $0xd6
  jmp alltraps
ffffffff801092cf:	e9 48 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092d4 <vector215>:
.globl vector215
vector215:
  push $0
ffffffff801092d4:	6a 00                	pushq  $0x0
  push $215
ffffffff801092d6:	68 d7 00 00 00       	pushq  $0xd7
  jmp alltraps
ffffffff801092db:	e9 3c f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092e0 <vector216>:
.globl vector216
vector216:
  push $0
ffffffff801092e0:	6a 00                	pushq  $0x0
  push $216
ffffffff801092e2:	68 d8 00 00 00       	pushq  $0xd8
  jmp alltraps
ffffffff801092e7:	e9 30 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092ec <vector217>:
.globl vector217
vector217:
  push $0
ffffffff801092ec:	6a 00                	pushq  $0x0
  push $217
ffffffff801092ee:	68 d9 00 00 00       	pushq  $0xd9
  jmp alltraps
ffffffff801092f3:	e9 24 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801092f8 <vector218>:
.globl vector218
vector218:
  push $0
ffffffff801092f8:	6a 00                	pushq  $0x0
  push $218
ffffffff801092fa:	68 da 00 00 00       	pushq  $0xda
  jmp alltraps
ffffffff801092ff:	e9 18 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109304 <vector219>:
.globl vector219
vector219:
  push $0
ffffffff80109304:	6a 00                	pushq  $0x0
  push $219
ffffffff80109306:	68 db 00 00 00       	pushq  $0xdb
  jmp alltraps
ffffffff8010930b:	e9 0c f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109310 <vector220>:
.globl vector220
vector220:
  push $0
ffffffff80109310:	6a 00                	pushq  $0x0
  push $220
ffffffff80109312:	68 dc 00 00 00       	pushq  $0xdc
  jmp alltraps
ffffffff80109317:	e9 00 f2 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010931c <vector221>:
.globl vector221
vector221:
  push $0
ffffffff8010931c:	6a 00                	pushq  $0x0
  push $221
ffffffff8010931e:	68 dd 00 00 00       	pushq  $0xdd
  jmp alltraps
ffffffff80109323:	e9 f4 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109328 <vector222>:
.globl vector222
vector222:
  push $0
ffffffff80109328:	6a 00                	pushq  $0x0
  push $222
ffffffff8010932a:	68 de 00 00 00       	pushq  $0xde
  jmp alltraps
ffffffff8010932f:	e9 e8 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109334 <vector223>:
.globl vector223
vector223:
  push $0
ffffffff80109334:	6a 00                	pushq  $0x0
  push $223
ffffffff80109336:	68 df 00 00 00       	pushq  $0xdf
  jmp alltraps
ffffffff8010933b:	e9 dc f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109340 <vector224>:
.globl vector224
vector224:
  push $0
ffffffff80109340:	6a 00                	pushq  $0x0
  push $224
ffffffff80109342:	68 e0 00 00 00       	pushq  $0xe0
  jmp alltraps
ffffffff80109347:	e9 d0 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010934c <vector225>:
.globl vector225
vector225:
  push $0
ffffffff8010934c:	6a 00                	pushq  $0x0
  push $225
ffffffff8010934e:	68 e1 00 00 00       	pushq  $0xe1
  jmp alltraps
ffffffff80109353:	e9 c4 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109358 <vector226>:
.globl vector226
vector226:
  push $0
ffffffff80109358:	6a 00                	pushq  $0x0
  push $226
ffffffff8010935a:	68 e2 00 00 00       	pushq  $0xe2
  jmp alltraps
ffffffff8010935f:	e9 b8 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109364 <vector227>:
.globl vector227
vector227:
  push $0
ffffffff80109364:	6a 00                	pushq  $0x0
  push $227
ffffffff80109366:	68 e3 00 00 00       	pushq  $0xe3
  jmp alltraps
ffffffff8010936b:	e9 ac f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109370 <vector228>:
.globl vector228
vector228:
  push $0
ffffffff80109370:	6a 00                	pushq  $0x0
  push $228
ffffffff80109372:	68 e4 00 00 00       	pushq  $0xe4
  jmp alltraps
ffffffff80109377:	e9 a0 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010937c <vector229>:
.globl vector229
vector229:
  push $0
ffffffff8010937c:	6a 00                	pushq  $0x0
  push $229
ffffffff8010937e:	68 e5 00 00 00       	pushq  $0xe5
  jmp alltraps
ffffffff80109383:	e9 94 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109388 <vector230>:
.globl vector230
vector230:
  push $0
ffffffff80109388:	6a 00                	pushq  $0x0
  push $230
ffffffff8010938a:	68 e6 00 00 00       	pushq  $0xe6
  jmp alltraps
ffffffff8010938f:	e9 88 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109394 <vector231>:
.globl vector231
vector231:
  push $0
ffffffff80109394:	6a 00                	pushq  $0x0
  push $231
ffffffff80109396:	68 e7 00 00 00       	pushq  $0xe7
  jmp alltraps
ffffffff8010939b:	e9 7c f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093a0 <vector232>:
.globl vector232
vector232:
  push $0
ffffffff801093a0:	6a 00                	pushq  $0x0
  push $232
ffffffff801093a2:	68 e8 00 00 00       	pushq  $0xe8
  jmp alltraps
ffffffff801093a7:	e9 70 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093ac <vector233>:
.globl vector233
vector233:
  push $0
ffffffff801093ac:	6a 00                	pushq  $0x0
  push $233
ffffffff801093ae:	68 e9 00 00 00       	pushq  $0xe9
  jmp alltraps
ffffffff801093b3:	e9 64 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093b8 <vector234>:
.globl vector234
vector234:
  push $0
ffffffff801093b8:	6a 00                	pushq  $0x0
  push $234
ffffffff801093ba:	68 ea 00 00 00       	pushq  $0xea
  jmp alltraps
ffffffff801093bf:	e9 58 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093c4 <vector235>:
.globl vector235
vector235:
  push $0
ffffffff801093c4:	6a 00                	pushq  $0x0
  push $235
ffffffff801093c6:	68 eb 00 00 00       	pushq  $0xeb
  jmp alltraps
ffffffff801093cb:	e9 4c f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093d0 <vector236>:
.globl vector236
vector236:
  push $0
ffffffff801093d0:	6a 00                	pushq  $0x0
  push $236
ffffffff801093d2:	68 ec 00 00 00       	pushq  $0xec
  jmp alltraps
ffffffff801093d7:	e9 40 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093dc <vector237>:
.globl vector237
vector237:
  push $0
ffffffff801093dc:	6a 00                	pushq  $0x0
  push $237
ffffffff801093de:	68 ed 00 00 00       	pushq  $0xed
  jmp alltraps
ffffffff801093e3:	e9 34 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093e8 <vector238>:
.globl vector238
vector238:
  push $0
ffffffff801093e8:	6a 00                	pushq  $0x0
  push $238
ffffffff801093ea:	68 ee 00 00 00       	pushq  $0xee
  jmp alltraps
ffffffff801093ef:	e9 28 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801093f4 <vector239>:
.globl vector239
vector239:
  push $0
ffffffff801093f4:	6a 00                	pushq  $0x0
  push $239
ffffffff801093f6:	68 ef 00 00 00       	pushq  $0xef
  jmp alltraps
ffffffff801093fb:	e9 1c f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109400 <vector240>:
.globl vector240
vector240:
  push $0
ffffffff80109400:	6a 00                	pushq  $0x0
  push $240
ffffffff80109402:	68 f0 00 00 00       	pushq  $0xf0
  jmp alltraps
ffffffff80109407:	e9 10 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010940c <vector241>:
.globl vector241
vector241:
  push $0
ffffffff8010940c:	6a 00                	pushq  $0x0
  push $241
ffffffff8010940e:	68 f1 00 00 00       	pushq  $0xf1
  jmp alltraps
ffffffff80109413:	e9 04 f1 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109418 <vector242>:
.globl vector242
vector242:
  push $0
ffffffff80109418:	6a 00                	pushq  $0x0
  push $242
ffffffff8010941a:	68 f2 00 00 00       	pushq  $0xf2
  jmp alltraps
ffffffff8010941f:	e9 f8 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109424 <vector243>:
.globl vector243
vector243:
  push $0
ffffffff80109424:	6a 00                	pushq  $0x0
  push $243
ffffffff80109426:	68 f3 00 00 00       	pushq  $0xf3
  jmp alltraps
ffffffff8010942b:	e9 ec f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109430 <vector244>:
.globl vector244
vector244:
  push $0
ffffffff80109430:	6a 00                	pushq  $0x0
  push $244
ffffffff80109432:	68 f4 00 00 00       	pushq  $0xf4
  jmp alltraps
ffffffff80109437:	e9 e0 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010943c <vector245>:
.globl vector245
vector245:
  push $0
ffffffff8010943c:	6a 00                	pushq  $0x0
  push $245
ffffffff8010943e:	68 f5 00 00 00       	pushq  $0xf5
  jmp alltraps
ffffffff80109443:	e9 d4 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109448 <vector246>:
.globl vector246
vector246:
  push $0
ffffffff80109448:	6a 00                	pushq  $0x0
  push $246
ffffffff8010944a:	68 f6 00 00 00       	pushq  $0xf6
  jmp alltraps
ffffffff8010944f:	e9 c8 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109454 <vector247>:
.globl vector247
vector247:
  push $0
ffffffff80109454:	6a 00                	pushq  $0x0
  push $247
ffffffff80109456:	68 f7 00 00 00       	pushq  $0xf7
  jmp alltraps
ffffffff8010945b:	e9 bc f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109460 <vector248>:
.globl vector248
vector248:
  push $0
ffffffff80109460:	6a 00                	pushq  $0x0
  push $248
ffffffff80109462:	68 f8 00 00 00       	pushq  $0xf8
  jmp alltraps
ffffffff80109467:	e9 b0 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010946c <vector249>:
.globl vector249
vector249:
  push $0
ffffffff8010946c:	6a 00                	pushq  $0x0
  push $249
ffffffff8010946e:	68 f9 00 00 00       	pushq  $0xf9
  jmp alltraps
ffffffff80109473:	e9 a4 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109478 <vector250>:
.globl vector250
vector250:
  push $0
ffffffff80109478:	6a 00                	pushq  $0x0
  push $250
ffffffff8010947a:	68 fa 00 00 00       	pushq  $0xfa
  jmp alltraps
ffffffff8010947f:	e9 98 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109484 <vector251>:
.globl vector251
vector251:
  push $0
ffffffff80109484:	6a 00                	pushq  $0x0
  push $251
ffffffff80109486:	68 fb 00 00 00       	pushq  $0xfb
  jmp alltraps
ffffffff8010948b:	e9 8c f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff80109490 <vector252>:
.globl vector252
vector252:
  push $0
ffffffff80109490:	6a 00                	pushq  $0x0
  push $252
ffffffff80109492:	68 fc 00 00 00       	pushq  $0xfc
  jmp alltraps
ffffffff80109497:	e9 80 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff8010949c <vector253>:
.globl vector253
vector253:
  push $0
ffffffff8010949c:	6a 00                	pushq  $0x0
  push $253
ffffffff8010949e:	68 fd 00 00 00       	pushq  $0xfd
  jmp alltraps
ffffffff801094a3:	e9 74 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801094a8 <vector254>:
.globl vector254
vector254:
  push $0
ffffffff801094a8:	6a 00                	pushq  $0x0
  push $254
ffffffff801094aa:	68 fe 00 00 00       	pushq  $0xfe
  jmp alltraps
ffffffff801094af:	e9 68 f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801094b4 <vector255>:
.globl vector255
vector255:
  push $0
ffffffff801094b4:	6a 00                	pushq  $0x0
  push $255
ffffffff801094b6:	68 ff 00 00 00       	pushq  $0xff
  jmp alltraps
ffffffff801094bb:	e9 5c f0 ff ff       	jmpq   ffffffff8010851c <alltraps>

ffffffff801094c0 <v2p>:
#endif
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uintp v2p(void *a) { return ((uintp) (a)) - ((uintp)KERNBASE); }
ffffffff801094c0:	55                   	push   %rbp
ffffffff801094c1:	48 89 e5             	mov    %rsp,%rbp
ffffffff801094c4:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801094c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff801094cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff801094d0:	b8 00 00 00 80       	mov    $0x80000000,%eax
ffffffff801094d5:	48 01 d0             	add    %rdx,%rax
ffffffff801094d8:	c9                   	leaveq 
ffffffff801094d9:	c3                   	retq   

ffffffff801094da <p2v>:
static inline void *p2v(uintp a) { return (void *) ((a) + ((uintp)KERNBASE)); }
ffffffff801094da:	55                   	push   %rbp
ffffffff801094db:	48 89 e5             	mov    %rsp,%rbp
ffffffff801094de:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff801094e2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff801094e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801094ea:	48 05 00 00 00 80    	add    $0xffffffff80000000,%rax
ffffffff801094f0:	c9                   	leaveq 
ffffffff801094f1:	c3                   	retq   

ffffffff801094f2 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
ffffffff801094f2:	55                   	push   %rbp
ffffffff801094f3:	48 89 e5             	mov    %rsp,%rbp
ffffffff801094f6:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff801094fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff801094fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff80109502:	89 55 dc             	mov    %edx,-0x24(%rbp)
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
ffffffff80109505:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109509:	48 c1 e8 15          	shr    $0x15,%rax
ffffffff8010950d:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80109512:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80109519:	00 
ffffffff8010951a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010951e:	48 01 d0             	add    %rdx,%rax
ffffffff80109521:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  if(*pde & PTE_P){
ffffffff80109525:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109529:	48 8b 00             	mov    (%rax),%rax
ffffffff8010952c:	83 e0 01             	and    $0x1,%eax
ffffffff8010952f:	48 85 c0             	test   %rax,%rax
ffffffff80109532:	74 1b                	je     ffffffff8010954f <walkpgdir+0x5d>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
ffffffff80109534:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109538:	48 8b 00             	mov    (%rax),%rax
ffffffff8010953b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109541:	48 89 c7             	mov    %rax,%rdi
ffffffff80109544:	e8 91 ff ff ff       	callq  ffffffff801094da <p2v>
ffffffff80109549:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff8010954d:	eb 4d                	jmp    ffffffff8010959c <walkpgdir+0xaa>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
ffffffff8010954f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
ffffffff80109553:	74 10                	je     ffffffff80109565 <walkpgdir+0x73>
ffffffff80109555:	e8 c1 a7 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010955a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
ffffffff8010955e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80109563:	75 07                	jne    ffffffff8010956c <walkpgdir+0x7a>
      return 0;
ffffffff80109565:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010956a:	eb 4c                	jmp    ffffffff801095b8 <walkpgdir+0xc6>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
ffffffff8010956c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109570:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109575:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010957a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010957d:	e8 90 d7 ff ff       	callq  ffffffff80106d12 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
ffffffff80109582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109586:	48 89 c7             	mov    %rax,%rdi
ffffffff80109589:	e8 32 ff ff ff       	callq  ffffffff801094c0 <v2p>
ffffffff8010958e:	48 83 c8 07          	or     $0x7,%rax
ffffffff80109592:	48 89 c2             	mov    %rax,%rdx
ffffffff80109595:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109599:	48 89 10             	mov    %rdx,(%rax)
  }
  return &pgtab[PTX(va)];
ffffffff8010959c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff801095a0:	48 c1 e8 0c          	shr    $0xc,%rax
ffffffff801095a4:	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff801095a9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff801095b0:	00 
ffffffff801095b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801095b5:	48 01 d0             	add    %rdx,%rax
}
ffffffff801095b8:	c9                   	leaveq 
ffffffff801095b9:	c3                   	retq   

ffffffff801095ba <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uintp size, uintp pa, int perm)
{
ffffffff801095ba:	55                   	push   %rbp
ffffffff801095bb:	48 89 e5             	mov    %rsp,%rbp
ffffffff801095be:	48 83 ec 50          	sub    $0x50,%rsp
ffffffff801095c2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff801095c6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff801095ca:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffffffff801095ce:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
ffffffff801095d2:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uintp)va);
ffffffff801095d6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff801095da:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff801095e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  last = (char*)PGROUNDDOWN(((uintp)va) + size - 1);
ffffffff801095e4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
ffffffff801095e8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801095ec:	48 01 d0             	add    %rdx,%rax
ffffffff801095ef:	48 83 e8 01          	sub    $0x1,%rax
ffffffff801095f3:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff801095f9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
ffffffff801095fd:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff80109601:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109605:	ba 01 00 00 00       	mov    $0x1,%edx
ffffffff8010960a:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010960d:	48 89 c7             	mov    %rax,%rdi
ffffffff80109610:	e8 dd fe ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff80109615:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
ffffffff80109619:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff8010961e:	75 07                	jne    ffffffff80109627 <mappages+0x6d>
      return -1;
ffffffff80109620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80109625:	eb 54                	jmp    ffffffff8010967b <mappages+0xc1>
    if(*pte & PTE_P)
ffffffff80109627:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010962b:	48 8b 00             	mov    (%rax),%rax
ffffffff8010962e:	83 e0 01             	and    $0x1,%eax
ffffffff80109631:	48 85 c0             	test   %rax,%rax
ffffffff80109634:	74 0c                	je     ffffffff80109642 <mappages+0x88>
      panic("remap");
ffffffff80109636:	48 c7 c7 38 ae 10 80 	mov    $0xffffffff8010ae38,%rdi
ffffffff8010963d:	e8 bd 72 ff ff       	callq  ffffffff801008ff <panic>
    *pte = pa | perm | PTE_P;
ffffffff80109642:	8b 45 bc             	mov    -0x44(%rbp),%eax
ffffffff80109645:	48 98                	cltq   
ffffffff80109647:	48 0b 45 c0          	or     -0x40(%rbp),%rax
ffffffff8010964b:	48 83 c8 01          	or     $0x1,%rax
ffffffff8010964f:	48 89 c2             	mov    %rax,%rdx
ffffffff80109652:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109656:	48 89 10             	mov    %rdx,(%rax)
    if(a == last)
ffffffff80109659:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010965d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffffffff80109661:	74 12                	je     ffffffff80109675 <mappages+0xbb>
      break;
    a += PGSIZE;
ffffffff80109663:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffffffff8010966a:	00 
    pa += PGSIZE;
ffffffff8010966b:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
ffffffff80109672:	00 
  }
ffffffff80109673:	eb 88                	jmp    ffffffff801095fd <mappages+0x43>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
ffffffff80109675:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
ffffffff80109676:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff8010967b:	c9                   	leaveq 
ffffffff8010967c:	c3                   	retq   

ffffffff8010967d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
ffffffff8010967d:	55                   	push   %rbp
ffffffff8010967e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109681:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80109685:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109689:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
ffffffff8010968d:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *mem;
  
  if(sz >= PGSIZE)
ffffffff80109690:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%rbp)
ffffffff80109697:	76 0c                	jbe    ffffffff801096a5 <inituvm+0x28>
    panic("inituvm: more than a page");
ffffffff80109699:	48 c7 c7 3e ae 10 80 	mov    $0xffffffff8010ae3e,%rdi
ffffffff801096a0:	e8 5a 72 ff ff       	callq  ffffffff801008ff <panic>
  mem = kalloc();
ffffffff801096a5:	e8 71 a6 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff801096aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  memset(mem, 0, PGSIZE);
ffffffff801096ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801096b2:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff801096b7:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801096bc:	48 89 c7             	mov    %rax,%rdi
ffffffff801096bf:	e8 4e d6 ff ff       	callq  ffffffff80106d12 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
ffffffff801096c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801096c8:	48 89 c7             	mov    %rax,%rdi
ffffffff801096cb:	e8 f0 fd ff ff       	callq  ffffffff801094c0 <v2p>
ffffffff801096d0:	48 89 c2             	mov    %rax,%rdx
ffffffff801096d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801096d7:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffffffff801096dd:	48 89 d1             	mov    %rdx,%rcx
ffffffff801096e0:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff801096e5:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff801096ea:	48 89 c7             	mov    %rax,%rdi
ffffffff801096ed:	e8 c8 fe ff ff       	callq  ffffffff801095ba <mappages>
  memmove(mem, init, sz);
ffffffff801096f2:	8b 55 dc             	mov    -0x24(%rbp),%edx
ffffffff801096f5:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffffffff801096f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801096fd:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109700:	48 89 c7             	mov    %rax,%rdi
ffffffff80109703:	e8 f9 d6 ff ff       	callq  ffffffff80106e01 <memmove>
}
ffffffff80109708:	90                   	nop
ffffffff80109709:	c9                   	leaveq 
ffffffff8010970a:	c3                   	retq   

ffffffff8010970b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
ffffffff8010970b:	55                   	push   %rbp
ffffffff8010970c:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010970f:	53                   	push   %rbx
ffffffff80109710:	48 83 ec 48          	sub    $0x48,%rsp
ffffffff80109714:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
ffffffff80109718:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
ffffffff8010971c:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
ffffffff80109720:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
ffffffff80109723:	44 89 45 b0          	mov    %r8d,-0x50(%rbp)
  uint i, pa, n;
  pte_t *pte;

  if((uintp) addr % PGSIZE != 0)
ffffffff80109727:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff8010972b:	25 ff 0f 00 00       	and    $0xfff,%eax
ffffffff80109730:	48 85 c0             	test   %rax,%rax
ffffffff80109733:	74 0c                	je     ffffffff80109741 <loaduvm+0x36>
    panic("loaduvm: addr must be page aligned");
ffffffff80109735:	48 c7 c7 58 ae 10 80 	mov    $0xffffffff8010ae58,%rdi
ffffffff8010973c:	e8 be 71 ff ff       	callq  ffffffff801008ff <panic>
  for(i = 0; i < sz; i += PGSIZE){
ffffffff80109741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffffffff80109748:	e9 a1 00 00 00       	jmpq   ffffffff801097ee <loaduvm+0xe3>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
ffffffff8010974d:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff80109750:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80109754:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffffffff80109758:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff8010975c:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80109761:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109764:	48 89 c7             	mov    %rax,%rdi
ffffffff80109767:	e8 86 fd ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff8010976c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffffffff80109770:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffffffff80109775:	75 0c                	jne    ffffffff80109783 <loaduvm+0x78>
      panic("loaduvm: address should exist");
ffffffff80109777:	48 c7 c7 7b ae 10 80 	mov    $0xffffffff8010ae7b,%rdi
ffffffff8010977e:	e8 7c 71 ff ff       	callq  ffffffff801008ff <panic>
    pa = PTE_ADDR(*pte);
ffffffff80109783:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109787:	48 8b 00             	mov    (%rax),%rax
ffffffff8010978a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
ffffffff8010978f:	89 45 dc             	mov    %eax,-0x24(%rbp)
    if(sz - i < PGSIZE)
ffffffff80109792:	8b 45 b0             	mov    -0x50(%rbp),%eax
ffffffff80109795:	2b 45 ec             	sub    -0x14(%rbp),%eax
ffffffff80109798:	3d ff 0f 00 00       	cmp    $0xfff,%eax
ffffffff8010979d:	77 0b                	ja     ffffffff801097aa <loaduvm+0x9f>
      n = sz - i;
ffffffff8010979f:	8b 45 b0             	mov    -0x50(%rbp),%eax
ffffffff801097a2:	2b 45 ec             	sub    -0x14(%rbp),%eax
ffffffff801097a5:	89 45 e8             	mov    %eax,-0x18(%rbp)
ffffffff801097a8:	eb 07                	jmp    ffffffff801097b1 <loaduvm+0xa6>
    else
      n = PGSIZE;
ffffffff801097aa:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%rbp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
ffffffff801097b1:	8b 55 b4             	mov    -0x4c(%rbp),%edx
ffffffff801097b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801097b7:	8d 1c 02             	lea    (%rdx,%rax,1),%ebx
ffffffff801097ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
ffffffff801097bd:	48 89 c7             	mov    %rax,%rdi
ffffffff801097c0:	e8 15 fd ff ff       	callq  ffffffff801094da <p2v>
ffffffff801097c5:	48 89 c6             	mov    %rax,%rsi
ffffffff801097c8:	8b 55 e8             	mov    -0x18(%rbp),%edx
ffffffff801097cb:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff801097cf:	89 d1                	mov    %edx,%ecx
ffffffff801097d1:	89 da                	mov    %ebx,%edx
ffffffff801097d3:	48 89 c7             	mov    %rax,%rdi
ffffffff801097d6:	e8 74 96 ff ff       	callq  ffffffff80102e4f <readi>
ffffffff801097db:	3b 45 e8             	cmp    -0x18(%rbp),%eax
ffffffff801097de:	74 07                	je     ffffffff801097e7 <loaduvm+0xdc>
      return -1;
ffffffff801097e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff801097e5:	eb 18                	jmp    ffffffff801097ff <loaduvm+0xf4>
  uint i, pa, n;
  pte_t *pte;

  if((uintp) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
ffffffff801097e7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%rbp)
ffffffff801097ee:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff801097f1:	3b 45 b0             	cmp    -0x50(%rbp),%eax
ffffffff801097f4:	0f 82 53 ff ff ff    	jb     ffffffff8010974d <loaduvm+0x42>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
ffffffff801097fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff801097ff:	48 83 c4 48          	add    $0x48,%rsp
ffffffff80109803:	5b                   	pop    %rbx
ffffffff80109804:	5d                   	pop    %rbp
ffffffff80109805:	c3                   	retq   

ffffffff80109806 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
ffffffff80109806:	55                   	push   %rbp
ffffffff80109807:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010980a:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010980e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109812:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffffffff80109815:	89 55 e0             	mov    %edx,-0x20(%rbp)

#if !defined(X64)
  if(newsz >= KERNBASE)
    return 0;
#endif
  if(newsz < oldsz)
ffffffff80109818:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffffffff8010981b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
ffffffff8010981e:	73 08                	jae    ffffffff80109828 <allocuvm+0x22>
    return oldsz;
ffffffff80109820:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109823:	e9 b0 00 00 00       	jmpq   ffffffff801098d8 <allocuvm+0xd2>

  a = PGROUNDUP(oldsz);
ffffffff80109828:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff8010982b:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff80109831:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109837:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a < newsz; a += PGSIZE){
ffffffff8010983b:	e9 88 00 00 00       	jmpq   ffffffff801098c8 <allocuvm+0xc2>
    mem = kalloc();
ffffffff80109840:	e8 d6 a4 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80109845:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(mem == 0){
ffffffff80109849:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff8010984e:	75 2d                	jne    ffffffff8010987d <allocuvm+0x77>
      cprintf("allocuvm out of memory\n");
ffffffff80109850:	48 c7 c7 99 ae 10 80 	mov    $0xffffffff8010ae99,%rdi
ffffffff80109857:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010985c:	e8 41 6d ff ff       	callq  ffffffff801005a2 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
ffffffff80109861:	8b 55 e4             	mov    -0x1c(%rbp),%edx
ffffffff80109864:	8b 4d e0             	mov    -0x20(%rbp),%ecx
ffffffff80109867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010986b:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010986e:	48 89 c7             	mov    %rax,%rdi
ffffffff80109871:	e8 64 00 00 00       	callq  ffffffff801098da <deallocuvm>
      return 0;
ffffffff80109876:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff8010987b:	eb 5b                	jmp    ffffffff801098d8 <allocuvm+0xd2>
    }
    memset(mem, 0, PGSIZE);
ffffffff8010987d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109881:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109886:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010988b:	48 89 c7             	mov    %rax,%rdi
ffffffff8010988e:	e8 7f d4 ff ff       	callq  ffffffff80106d12 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
ffffffff80109893:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109897:	48 89 c7             	mov    %rax,%rdi
ffffffff8010989a:	e8 21 fc ff ff       	callq  ffffffff801094c0 <v2p>
ffffffff8010989f:	48 89 c2             	mov    %rax,%rdx
ffffffff801098a2:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
ffffffff801098a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801098aa:	41 b8 06 00 00 00    	mov    $0x6,%r8d
ffffffff801098b0:	48 89 d1             	mov    %rdx,%rcx
ffffffff801098b3:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff801098b8:	48 89 c7             	mov    %rax,%rdi
ffffffff801098bb:	e8 fa fc ff ff       	callq  ffffffff801095ba <mappages>
#endif
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
ffffffff801098c0:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffffffff801098c7:	00 
ffffffff801098c8:	8b 45 e0             	mov    -0x20(%rbp),%eax
ffffffff801098cb:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
ffffffff801098cf:	0f 87 6b ff ff ff    	ja     ffffffff80109840 <allocuvm+0x3a>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
ffffffff801098d5:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
ffffffff801098d8:	c9                   	leaveq 
ffffffff801098d9:	c3                   	retq   

ffffffff801098da <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uintp oldsz, uintp newsz)
{
ffffffff801098da:	55                   	push   %rbp
ffffffff801098db:	48 89 e5             	mov    %rsp,%rbp
ffffffff801098de:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff801098e2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff801098e6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
ffffffff801098ea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  pte_t *pte;
  uintp a, pa;

  if(newsz >= oldsz)
ffffffff801098ee:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff801098f2:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffffffff801098f6:	72 09                	jb     ffffffff80109901 <deallocuvm+0x27>
    return oldsz;
ffffffff801098f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff801098fc:	e9 ba 00 00 00       	jmpq   ffffffff801099bb <deallocuvm+0xe1>

  a = PGROUNDUP(newsz);
ffffffff80109901:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80109905:	48 05 ff 0f 00 00    	add    $0xfff,%rax
ffffffff8010990b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109911:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  for(; a  < oldsz; a += PGSIZE){
ffffffff80109915:	e9 8f 00 00 00       	jmpq   ffffffff801099a9 <deallocuvm+0xcf>
    pte = walkpgdir(pgdir, (char*)a, 0);
ffffffff8010991a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
ffffffff8010991e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109922:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80109927:	48 89 ce             	mov    %rcx,%rsi
ffffffff8010992a:	48 89 c7             	mov    %rax,%rdi
ffffffff8010992d:	e8 c0 fb ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff80109932:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(!pte)
ffffffff80109936:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
ffffffff8010993b:	75 0a                	jne    ffffffff80109947 <deallocuvm+0x6d>
      a += (NPTENTRIES - 1) * PGSIZE;
ffffffff8010993d:	48 81 45 f8 00 f0 1f 	addq   $0x1ff000,-0x8(%rbp)
ffffffff80109944:	00 
ffffffff80109945:	eb 5a                	jmp    ffffffff801099a1 <deallocuvm+0xc7>
    else if((*pte & PTE_P) != 0){
ffffffff80109947:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010994b:	48 8b 00             	mov    (%rax),%rax
ffffffff8010994e:	83 e0 01             	and    $0x1,%eax
ffffffff80109951:	48 85 c0             	test   %rax,%rax
ffffffff80109954:	74 4b                	je     ffffffff801099a1 <deallocuvm+0xc7>
      pa = PTE_ADDR(*pte);
ffffffff80109956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010995a:	48 8b 00             	mov    (%rax),%rax
ffffffff8010995d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109963:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
      if(pa == 0)
ffffffff80109967:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff8010996c:	75 0c                	jne    ffffffff8010997a <deallocuvm+0xa0>
        panic("kfree");
ffffffff8010996e:	48 c7 c7 b1 ae 10 80 	mov    $0xffffffff8010aeb1,%rdi
ffffffff80109975:	e8 85 6f ff ff       	callq  ffffffff801008ff <panic>
      char *v = p2v(pa);
ffffffff8010997a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010997e:	48 89 c7             	mov    %rax,%rdi
ffffffff80109981:	e8 54 fb ff ff       	callq  ffffffff801094da <p2v>
ffffffff80109986:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
      kfree(v);
ffffffff8010998a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010998e:	48 89 c7             	mov    %rax,%rdi
ffffffff80109991:	e8 db a2 ff ff       	callq  ffffffff80103c71 <kfree>
      *pte = 0;
ffffffff80109996:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010999a:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
ffffffff801099a1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
ffffffff801099a8:	00 
ffffffff801099a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff801099ad:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
ffffffff801099b1:	0f 82 63 ff ff ff    	jb     ffffffff8010991a <deallocuvm+0x40>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
ffffffff801099b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
ffffffff801099bb:	c9                   	leaveq 
ffffffff801099bc:	c3                   	retq   

ffffffff801099bd <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
ffffffff801099bd:	55                   	push   %rbp
ffffffff801099be:	48 89 e5             	mov    %rsp,%rbp
ffffffff801099c1:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff801099c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  uint i;
  if(pgdir == 0)
ffffffff801099c9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
ffffffff801099ce:	75 0c                	jne    ffffffff801099dc <freevm+0x1f>
    panic("freevm: no pgdir");
ffffffff801099d0:	48 c7 c7 b7 ae 10 80 	mov    $0xffffffff8010aeb7,%rdi
ffffffff801099d7:	e8 23 6f ff ff       	callq  ffffffff801008ff <panic>
  deallocuvm(pgdir, 0x3fa00000, 0);
ffffffff801099dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff801099e0:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff801099e5:	be 00 00 a0 3f       	mov    $0x3fa00000,%esi
ffffffff801099ea:	48 89 c7             	mov    %rax,%rdi
ffffffff801099ed:	e8 e8 fe ff ff       	callq  ffffffff801098da <deallocuvm>
  for(i = 0; i < NPDENTRIES-2; i++){
ffffffff801099f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff801099f9:	eb 54                	jmp    ffffffff80109a4f <freevm+0x92>
    if(pgdir[i] & PTE_P){
ffffffff801099fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff801099fe:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80109a05:	00 
ffffffff80109a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109a0a:	48 01 d0             	add    %rdx,%rax
ffffffff80109a0d:	48 8b 00             	mov    (%rax),%rax
ffffffff80109a10:	83 e0 01             	and    $0x1,%eax
ffffffff80109a13:	48 85 c0             	test   %rax,%rax
ffffffff80109a16:	74 33                	je     ffffffff80109a4b <freevm+0x8e>
      char * v = p2v(PTE_ADDR(pgdir[i]));
ffffffff80109a18:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80109a1b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
ffffffff80109a22:	00 
ffffffff80109a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109a27:	48 01 d0             	add    %rdx,%rax
ffffffff80109a2a:	48 8b 00             	mov    (%rax),%rax
ffffffff80109a2d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109a33:	48 89 c7             	mov    %rax,%rdi
ffffffff80109a36:	e8 9f fa ff ff       	callq  ffffffff801094da <p2v>
ffffffff80109a3b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
      kfree(v);
ffffffff80109a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109a43:	48 89 c7             	mov    %rax,%rdi
ffffffff80109a46:	e8 26 a2 ff ff       	callq  ffffffff80103c71 <kfree>
{
  uint i;
  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, 0x3fa00000, 0);
  for(i = 0; i < NPDENTRIES-2; i++){
ffffffff80109a4b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80109a4f:	81 7d fc fd 01 00 00 	cmpl   $0x1fd,-0x4(%rbp)
ffffffff80109a56:	76 a3                	jbe    ffffffff801099fb <freevm+0x3e>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
ffffffff80109a58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109a5c:	48 89 c7             	mov    %rax,%rdi
ffffffff80109a5f:	e8 0d a2 ff ff       	callq  ffffffff80103c71 <kfree>
}
ffffffff80109a64:	90                   	nop
ffffffff80109a65:	c9                   	leaveq 
ffffffff80109a66:	c3                   	retq   

ffffffff80109a67 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
ffffffff80109a67:	55                   	push   %rbp
ffffffff80109a68:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109a6b:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80109a6f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109a73:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffffffff80109a77:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffffffff80109a7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109a7f:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80109a84:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109a87:	48 89 c7             	mov    %rax,%rdi
ffffffff80109a8a:	e8 63 fa ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff80109a8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(pte == 0)
ffffffff80109a93:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
ffffffff80109a98:	75 0c                	jne    ffffffff80109aa6 <clearpteu+0x3f>
    panic("clearpteu");
ffffffff80109a9a:	48 c7 c7 c8 ae 10 80 	mov    $0xffffffff8010aec8,%rdi
ffffffff80109aa1:	e8 59 6e ff ff       	callq  ffffffff801008ff <panic>
  *pte &= ~PTE_U;
ffffffff80109aa6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109aaa:	48 8b 00             	mov    (%rax),%rax
ffffffff80109aad:	48 83 e0 fb          	and    $0xfffffffffffffffb,%rax
ffffffff80109ab1:	48 89 c2             	mov    %rax,%rdx
ffffffff80109ab4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109ab8:	48 89 10             	mov    %rdx,(%rax)
}
ffffffff80109abb:	90                   	nop
ffffffff80109abc:	c9                   	leaveq 
ffffffff80109abd:	c3                   	retq   

ffffffff80109abe <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
ffffffff80109abe:	55                   	push   %rbp
ffffffff80109abf:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109ac2:	53                   	push   %rbx
ffffffff80109ac3:	48 83 ec 48          	sub    $0x48,%rsp
ffffffff80109ac7:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
ffffffff80109acb:	89 75 b4             	mov    %esi,-0x4c(%rbp)
  pde_t *d;
  pte_t *pte;
  uintp pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
ffffffff80109ace:	e8 a4 06 00 00       	callq  ffffffff8010a177 <setupkvm>
ffffffff80109ad3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
ffffffff80109ad7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffffffff80109adc:	75 0a                	jne    ffffffff80109ae8 <copyuvm+0x2a>
    return 0;
ffffffff80109ade:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80109ae3:	e9 0f 01 00 00       	jmpq   ffffffff80109bf7 <copyuvm+0x139>
  for(i = 0; i < sz; i += PGSIZE){
ffffffff80109ae8:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
ffffffff80109aef:	00 
ffffffff80109af0:	e9 da 00 00 00       	jmpq   ffffffff80109bcf <copyuvm+0x111>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
ffffffff80109af5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
ffffffff80109af9:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
ffffffff80109afd:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80109b02:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109b05:	48 89 c7             	mov    %rax,%rdi
ffffffff80109b08:	e8 e5 f9 ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff80109b0d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
ffffffff80109b11:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
ffffffff80109b16:	75 0c                	jne    ffffffff80109b24 <copyuvm+0x66>
      panic("copyuvm: pte should exist");
ffffffff80109b18:	48 c7 c7 d2 ae 10 80 	mov    $0xffffffff8010aed2,%rdi
ffffffff80109b1f:	e8 db 6d ff ff       	callq  ffffffff801008ff <panic>
    if(!(*pte & PTE_P))
ffffffff80109b24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109b28:	48 8b 00             	mov    (%rax),%rax
ffffffff80109b2b:	83 e0 01             	and    $0x1,%eax
ffffffff80109b2e:	48 85 c0             	test   %rax,%rax
ffffffff80109b31:	75 0c                	jne    ffffffff80109b3f <copyuvm+0x81>
      panic("copyuvm: page not present");
ffffffff80109b33:	48 c7 c7 ec ae 10 80 	mov    $0xffffffff8010aeec,%rdi
ffffffff80109b3a:	e8 c0 6d ff ff       	callq  ffffffff801008ff <panic>
    pa = PTE_ADDR(*pte);
ffffffff80109b3f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109b43:	48 8b 00             	mov    (%rax),%rax
ffffffff80109b46:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109b4c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    flags = PTE_FLAGS(*pte);
ffffffff80109b50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109b54:	48 8b 00             	mov    (%rax),%rax
ffffffff80109b57:	25 ff 0f 00 00       	and    $0xfff,%eax
ffffffff80109b5c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    if((mem = kalloc()) == 0)
ffffffff80109b60:	e8 b6 a1 ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80109b65:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
ffffffff80109b69:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
ffffffff80109b6e:	74 72                	je     ffffffff80109be2 <copyuvm+0x124>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
ffffffff80109b70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff80109b74:	48 89 c7             	mov    %rax,%rdi
ffffffff80109b77:	e8 5e f9 ff ff       	callq  ffffffff801094da <p2v>
ffffffff80109b7c:	48 89 c1             	mov    %rax,%rcx
ffffffff80109b7f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80109b83:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109b88:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109b8b:	48 89 c7             	mov    %rax,%rdi
ffffffff80109b8e:	e8 6e d2 ff ff       	callq  ffffffff80106e01 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
ffffffff80109b93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80109b97:	89 c3                	mov    %eax,%ebx
ffffffff80109b99:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
ffffffff80109b9d:	48 89 c7             	mov    %rax,%rdi
ffffffff80109ba0:	e8 1b f9 ff ff       	callq  ffffffff801094c0 <v2p>
ffffffff80109ba5:	48 89 c2             	mov    %rax,%rdx
ffffffff80109ba8:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
ffffffff80109bac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109bb0:	41 89 d8             	mov    %ebx,%r8d
ffffffff80109bb3:	48 89 d1             	mov    %rdx,%rcx
ffffffff80109bb6:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109bbb:	48 89 c7             	mov    %rax,%rdi
ffffffff80109bbe:	e8 f7 f9 ff ff       	callq  ffffffff801095ba <mappages>
ffffffff80109bc3:	85 c0                	test   %eax,%eax
ffffffff80109bc5:	78 1e                	js     ffffffff80109be5 <copyuvm+0x127>
  uintp pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
ffffffff80109bc7:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
ffffffff80109bce:	00 
ffffffff80109bcf:	8b 45 b4             	mov    -0x4c(%rbp),%eax
ffffffff80109bd2:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
ffffffff80109bd6:	0f 87 19 ff ff ff    	ja     ffffffff80109af5 <copyuvm+0x37>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
ffffffff80109bdc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109be0:	eb 15                	jmp    ffffffff80109bf7 <copyuvm+0x139>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
ffffffff80109be2:	90                   	nop
ffffffff80109be3:	eb 01                	jmp    ffffffff80109be6 <copyuvm+0x128>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
ffffffff80109be5:	90                   	nop
  }
  return d;

bad:
  freevm(d);
ffffffff80109be6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109bea:	48 89 c7             	mov    %rax,%rdi
ffffffff80109bed:	e8 cb fd ff ff       	callq  ffffffff801099bd <freevm>
  return 0;
ffffffff80109bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80109bf7:	48 83 c4 48          	add    $0x48,%rsp
ffffffff80109bfb:	5b                   	pop    %rbx
ffffffff80109bfc:	5d                   	pop    %rbp
ffffffff80109bfd:	c3                   	retq   

ffffffff80109bfe <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
ffffffff80109bfe:	55                   	push   %rbp
ffffffff80109bff:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109c02:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80109c06:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109c0a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
ffffffff80109c0e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
ffffffff80109c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109c16:	ba 00 00 00 00       	mov    $0x0,%edx
ffffffff80109c1b:	48 89 ce             	mov    %rcx,%rsi
ffffffff80109c1e:	48 89 c7             	mov    %rax,%rdi
ffffffff80109c21:	e8 cc f8 ff ff       	callq  ffffffff801094f2 <walkpgdir>
ffffffff80109c26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if((*pte & PTE_P) == 0)
ffffffff80109c2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109c2e:	48 8b 00             	mov    (%rax),%rax
ffffffff80109c31:	83 e0 01             	and    $0x1,%eax
ffffffff80109c34:	48 85 c0             	test   %rax,%rax
ffffffff80109c37:	75 07                	jne    ffffffff80109c40 <uva2ka+0x42>
    return 0;
ffffffff80109c39:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80109c3e:	eb 2b                	jmp    ffffffff80109c6b <uva2ka+0x6d>
  if((*pte & PTE_U) == 0)
ffffffff80109c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109c44:	48 8b 00             	mov    (%rax),%rax
ffffffff80109c47:	83 e0 04             	and    $0x4,%eax
ffffffff80109c4a:	48 85 c0             	test   %rax,%rax
ffffffff80109c4d:	75 07                	jne    ffffffff80109c56 <uva2ka+0x58>
    return 0;
ffffffff80109c4f:	b8 00 00 00 00       	mov    $0x0,%eax
ffffffff80109c54:	eb 15                	jmp    ffffffff80109c6b <uva2ka+0x6d>
  return (char*)p2v(PTE_ADDR(*pte));
ffffffff80109c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109c5a:	48 8b 00             	mov    (%rax),%rax
ffffffff80109c5d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff80109c63:	48 89 c7             	mov    %rax,%rdi
ffffffff80109c66:	e8 6f f8 ff ff       	callq  ffffffff801094da <p2v>
}
ffffffff80109c6b:	c9                   	leaveq 
ffffffff80109c6c:	c3                   	retq   

ffffffff80109c6d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
ffffffff80109c6d:	55                   	push   %rbp
ffffffff80109c6e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109c71:	48 83 ec 40          	sub    $0x40,%rsp
ffffffff80109c75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
ffffffff80109c79:	89 75 d4             	mov    %esi,-0x2c(%rbp)
ffffffff80109c7c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
ffffffff80109c80:	89 4d d0             	mov    %ecx,-0x30(%rbp)
  char *buf, *pa0;
  uintp n, va0;

  buf = (char*)p;
ffffffff80109c83:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
ffffffff80109c87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while(len > 0){
ffffffff80109c8b:	e9 9c 00 00 00       	jmpq   ffffffff80109d2c <copyout+0xbf>
    va0 = (uint)PGROUNDDOWN(va);
ffffffff80109c90:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffffffff80109c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
ffffffff80109c98:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    pa0 = uva2ka(pgdir, (char*)va0);
ffffffff80109c9c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80109ca0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109ca4:	48 89 d6             	mov    %rdx,%rsi
ffffffff80109ca7:	48 89 c7             	mov    %rax,%rdi
ffffffff80109caa:	e8 4f ff ff ff       	callq  ffffffff80109bfe <uva2ka>
ffffffff80109caf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    if(pa0 == 0)
ffffffff80109cb3:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
ffffffff80109cb8:	75 07                	jne    ffffffff80109cc1 <copyout+0x54>
      return -1;
ffffffff80109cba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
ffffffff80109cbf:	eb 7a                	jmp    ffffffff80109d3b <copyout+0xce>
    n = PGSIZE - (va - va0);
ffffffff80109cc1:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffffffff80109cc4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80109cc8:	48 29 c2             	sub    %rax,%rdx
ffffffff80109ccb:	48 89 d0             	mov    %rdx,%rax
ffffffff80109cce:	48 05 00 10 00 00    	add    $0x1000,%rax
ffffffff80109cd4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if(n > len)
ffffffff80109cd8:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffffffff80109cdb:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
ffffffff80109cdf:	73 07                	jae    ffffffff80109ce8 <copyout+0x7b>
      n = len;
ffffffff80109ce1:	8b 45 d0             	mov    -0x30(%rbp),%eax
ffffffff80109ce4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    memmove(pa0 + (va - va0), buf, n);
ffffffff80109ce8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109cec:	89 c6                	mov    %eax,%esi
ffffffff80109cee:	8b 45 d4             	mov    -0x2c(%rbp),%eax
ffffffff80109cf1:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
ffffffff80109cf5:	48 89 c2             	mov    %rax,%rdx
ffffffff80109cf8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff80109cfc:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
ffffffff80109d00:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109d04:	89 f2                	mov    %esi,%edx
ffffffff80109d06:	48 89 c6             	mov    %rax,%rsi
ffffffff80109d09:	48 89 cf             	mov    %rcx,%rdi
ffffffff80109d0c:	e8 f0 d0 ff ff       	callq  ffffffff80106e01 <memmove>
    len -= n;
ffffffff80109d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109d15:	29 45 d0             	sub    %eax,-0x30(%rbp)
    buf += n;
ffffffff80109d18:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109d1c:	48 01 45 f8          	add    %rax,-0x8(%rbp)
    va = va0 + PGSIZE;
ffffffff80109d20:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109d24:	05 00 10 00 00       	add    $0x1000,%eax
ffffffff80109d29:	89 45 d4             	mov    %eax,-0x2c(%rbp)
{
  char *buf, *pa0;
  uintp n, va0;

  buf = (char*)p;
  while(len > 0){
ffffffff80109d2c:	83 7d d0 00          	cmpl   $0x0,-0x30(%rbp)
ffffffff80109d30:	0f 85 5a ff ff ff    	jne    ffffffff80109c90 <copyout+0x23>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
ffffffff80109d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
ffffffff80109d3b:	c9                   	leaveq 
ffffffff80109d3c:	c3                   	retq   

ffffffff80109d3d <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
ffffffff80109d3d:	55                   	push   %rbp
ffffffff80109d3e:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109d41:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80109d45:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109d49:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  volatile ushort pd[5];

  pd[0] = size-1;
ffffffff80109d4c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109d4f:	83 e8 01             	sub    $0x1,%eax
ffffffff80109d52:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[1] = (uintp)p;
ffffffff80109d56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109d5a:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[2] = (uintp)p >> 16;
ffffffff80109d5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109d62:	48 c1 e8 10          	shr    $0x10,%rax
ffffffff80109d66:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
#if X64
  pd[3] = (uintp)p >> 32;
ffffffff80109d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109d6e:	48 c1 e8 20          	shr    $0x20,%rax
ffffffff80109d72:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  pd[4] = (uintp)p >> 48;
ffffffff80109d76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109d7a:	48 c1 e8 30          	shr    $0x30,%rax
ffffffff80109d7e:	66 89 45 f8          	mov    %ax,-0x8(%rbp)
#endif
  asm volatile("lgdt (%0)" : : "r" (pd));
ffffffff80109d82:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80109d86:	0f 01 10             	lgdt   (%rax)
}
ffffffff80109d89:	90                   	nop
ffffffff80109d8a:	c9                   	leaveq 
ffffffff80109d8b:	c3                   	retq   

ffffffff80109d8c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
ffffffff80109d8c:	55                   	push   %rbp
ffffffff80109d8d:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109d90:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff80109d94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109d98:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  volatile ushort pd[5];

  pd[0] = size-1;
ffffffff80109d9b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109d9e:	83 e8 01             	sub    $0x1,%eax
ffffffff80109da1:	66 89 45 f0          	mov    %ax,-0x10(%rbp)
  pd[1] = (uintp)p;
ffffffff80109da5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109da9:	66 89 45 f2          	mov    %ax,-0xe(%rbp)
  pd[2] = (uintp)p >> 16;
ffffffff80109dad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109db1:	48 c1 e8 10          	shr    $0x10,%rax
ffffffff80109db5:	66 89 45 f4          	mov    %ax,-0xc(%rbp)
#if X64
  pd[3] = (uintp)p >> 32;
ffffffff80109db9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109dbd:	48 c1 e8 20          	shr    $0x20,%rax
ffffffff80109dc1:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
  pd[4] = (uintp)p >> 48;
ffffffff80109dc5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109dc9:	48 c1 e8 30          	shr    $0x30,%rax
ffffffff80109dcd:	66 89 45 f8          	mov    %ax,-0x8(%rbp)
#endif
  asm volatile("lidt (%0)" : : "r" (pd));
ffffffff80109dd1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
ffffffff80109dd5:	0f 01 18             	lidt   (%rax)
}
ffffffff80109dd8:	90                   	nop
ffffffff80109dd9:	c9                   	leaveq 
ffffffff80109dda:	c3                   	retq   

ffffffff80109ddb <ltr>:

static inline void
ltr(ushort sel)
{
ffffffff80109ddb:	55                   	push   %rbp
ffffffff80109ddc:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109ddf:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80109de3:	89 f8                	mov    %edi,%eax
ffffffff80109de5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  asm volatile("ltr %0" : : "r" (sel));
ffffffff80109de9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
ffffffff80109ded:	0f 00 d8             	ltr    %ax
}
ffffffff80109df0:	90                   	nop
ffffffff80109df1:	c9                   	leaveq 
ffffffff80109df2:	c3                   	retq   

ffffffff80109df3 <lcr3>:
  return val;
}

static inline void
lcr3(uintp val) 
{
ffffffff80109df3:	55                   	push   %rbp
ffffffff80109df4:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109df7:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80109dfb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  asm volatile("mov %0,%%cr3" : : "r" (val));
ffffffff80109dff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109e03:	0f 22 d8             	mov    %rax,%cr3
}
ffffffff80109e06:	90                   	nop
ffffffff80109e07:	c9                   	leaveq 
ffffffff80109e08:	c3                   	retq   

ffffffff80109e09 <v2p>:
#endif
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uintp v2p(void *a) { return ((uintp) (a)) - ((uintp)KERNBASE); }
ffffffff80109e09:	55                   	push   %rbp
ffffffff80109e0a:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109e0d:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff80109e11:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80109e15:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80109e19:	b8 00 00 00 80       	mov    $0x80000000,%eax
ffffffff80109e1e:	48 01 d0             	add    %rdx,%rax
ffffffff80109e21:	c9                   	leaveq 
ffffffff80109e22:	c3                   	retq   

ffffffff80109e23 <tvinit>:
static pde_t *kpgdir0;
static pde_t *kpgdir1;

void wrmsr(uint msr, uint64 val);

void tvinit(void) {}
ffffffff80109e23:	55                   	push   %rbp
ffffffff80109e24:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109e27:	90                   	nop
ffffffff80109e28:	5d                   	pop    %rbp
ffffffff80109e29:	c3                   	retq   

ffffffff80109e2a <idtinit>:
void idtinit(void) {}
ffffffff80109e2a:	55                   	push   %rbp
ffffffff80109e2b:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109e2e:	90                   	nop
ffffffff80109e2f:	5d                   	pop    %rbp
ffffffff80109e30:	c3                   	retq   

ffffffff80109e31 <mkgate>:

static void mkgate(uint *idt, uint n, void *kva, uint pl, uint trap) {
ffffffff80109e31:	55                   	push   %rbp
ffffffff80109e32:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109e35:	48 83 ec 30          	sub    $0x30,%rsp
ffffffff80109e39:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
ffffffff80109e3d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
ffffffff80109e40:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
ffffffff80109e44:	89 4d e0             	mov    %ecx,-0x20(%rbp)
ffffffff80109e47:	44 89 45 d4          	mov    %r8d,-0x2c(%rbp)
  uint64 addr = (uint64) kva;
ffffffff80109e4b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff80109e4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  n *= 4;
ffffffff80109e53:	c1 65 e4 02          	shll   $0x2,-0x1c(%rbp)
  trap = trap ? 0x8F00 : 0x8E00; // TRAP vs INTERRUPT gate;
ffffffff80109e57:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
ffffffff80109e5b:	74 07                	je     ffffffff80109e64 <mkgate+0x33>
ffffffff80109e5d:	b8 00 8f 00 00       	mov    $0x8f00,%eax
ffffffff80109e62:	eb 05                	jmp    ffffffff80109e69 <mkgate+0x38>
ffffffff80109e64:	b8 00 8e 00 00       	mov    $0x8e00,%eax
ffffffff80109e69:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  idt[n+0] = (addr & 0xFFFF) | ((SEG_KCODE << 3) << 16);
ffffffff80109e6c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109e6f:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109e76:	00 
ffffffff80109e77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109e7b:	48 01 d0             	add    %rdx,%rax
ffffffff80109e7e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80109e82:	0f b7 d2             	movzwl %dx,%edx
ffffffff80109e85:	81 ca 00 00 08 00    	or     $0x80000,%edx
ffffffff80109e8b:	89 10                	mov    %edx,(%rax)
  idt[n+1] = (addr & 0xFFFF0000) | trap | ((pl & 3) << 13); // P=1 DPL=pl
ffffffff80109e8d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109e90:	83 c0 01             	add    $0x1,%eax
ffffffff80109e93:	89 c0                	mov    %eax,%eax
ffffffff80109e95:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109e9c:	00 
ffffffff80109e9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109ea1:	48 01 d0             	add    %rdx,%rax
ffffffff80109ea4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80109ea8:	66 ba 00 00          	mov    $0x0,%dx
ffffffff80109eac:	0b 55 d4             	or     -0x2c(%rbp),%edx
ffffffff80109eaf:	8b 4d e0             	mov    -0x20(%rbp),%ecx
ffffffff80109eb2:	83 e1 03             	and    $0x3,%ecx
ffffffff80109eb5:	c1 e1 0d             	shl    $0xd,%ecx
ffffffff80109eb8:	09 ca                	or     %ecx,%edx
ffffffff80109eba:	89 10                	mov    %edx,(%rax)
  idt[n+2] = addr >> 32;
ffffffff80109ebc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109ebf:	83 c0 02             	add    $0x2,%eax
ffffffff80109ec2:	89 c0                	mov    %eax,%eax
ffffffff80109ec4:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109ecb:	00 
ffffffff80109ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109ed0:	48 01 d0             	add    %rdx,%rax
ffffffff80109ed3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
ffffffff80109ed7:	48 c1 ea 20          	shr    $0x20,%rdx
ffffffff80109edb:	89 10                	mov    %edx,(%rax)
  idt[n+3] = 0;
ffffffff80109edd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
ffffffff80109ee0:	83 c0 03             	add    $0x3,%eax
ffffffff80109ee3:	89 c0                	mov    %eax,%eax
ffffffff80109ee5:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109eec:	00 
ffffffff80109eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109ef1:	48 01 d0             	add    %rdx,%rax
ffffffff80109ef4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
}
ffffffff80109efa:	90                   	nop
ffffffff80109efb:	c9                   	leaveq 
ffffffff80109efc:	c3                   	retq   

ffffffff80109efd <tss_set_rsp>:

static void tss_set_rsp(uint *tss, uint n, uint64 rsp) {
ffffffff80109efd:	55                   	push   %rbp
ffffffff80109efe:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109f01:	48 83 ec 18          	sub    $0x18,%rsp
ffffffff80109f05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
ffffffff80109f09:	89 75 f4             	mov    %esi,-0xc(%rbp)
ffffffff80109f0c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  tss[n*2 + 1] = rsp;
ffffffff80109f10:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80109f13:	01 c0                	add    %eax,%eax
ffffffff80109f15:	83 c0 01             	add    $0x1,%eax
ffffffff80109f18:	89 c0                	mov    %eax,%eax
ffffffff80109f1a:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109f21:	00 
ffffffff80109f22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109f26:	48 01 d0             	add    %rdx,%rax
ffffffff80109f29:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80109f2d:	89 10                	mov    %edx,(%rax)
  tss[n*2 + 2] = rsp >> 32;
ffffffff80109f2f:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffff80109f32:	83 c0 01             	add    $0x1,%eax
ffffffff80109f35:	01 c0                	add    %eax,%eax
ffffffff80109f37:	89 c0                	mov    %eax,%eax
ffffffff80109f39:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
ffffffff80109f40:	00 
ffffffff80109f41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff80109f45:	48 01 d0             	add    %rdx,%rax
ffffffff80109f48:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff80109f4c:	48 c1 ea 20          	shr    $0x20,%rdx
ffffffff80109f50:	89 10                	mov    %edx,(%rax)
}
ffffffff80109f52:	90                   	nop
ffffffff80109f53:	c9                   	leaveq 
ffffffff80109f54:	c3                   	retq   

ffffffff80109f55 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
ffffffff80109f55:	55                   	push   %rbp
ffffffff80109f56:	48 89 e5             	mov    %rsp,%rbp
ffffffff80109f59:	48 83 ec 40          	sub    $0x40,%rsp
  uint64 *gdt;
  uint *tss;
  uint64 addr;
  void *local;
  struct cpu *c;
  uint *idt = (uint*) kalloc();
ffffffff80109f5d:	e8 b9 9d ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80109f62:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  int n;
  memset(idt, 0, PGSIZE);
ffffffff80109f66:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109f6a:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109f6f:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff80109f74:	48 89 c7             	mov    %rax,%rdi
ffffffff80109f77:	e8 96 cd ff ff       	callq  ffffffff80106d12 <memset>

  for (n = 0; n < 256; n++)
ffffffff80109f7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffff80109f83:	eb 2b                	jmp    ffffffff80109fb0 <seginit+0x5b>
    mkgate(idt, n, vectors[n], 0, 0);
ffffffff80109f85:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffff80109f88:	48 98                	cltq   
ffffffff80109f8a:	48 8b 14 c5 78 b6 10 	mov    -0x7fef4988(,%rax,8),%rdx
ffffffff80109f91:	80 
ffffffff80109f92:	8b 75 fc             	mov    -0x4(%rbp),%esi
ffffffff80109f95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109f99:	41 b8 00 00 00 00    	mov    $0x0,%r8d
ffffffff80109f9f:	b9 00 00 00 00       	mov    $0x0,%ecx
ffffffff80109fa4:	48 89 c7             	mov    %rax,%rdi
ffffffff80109fa7:	e8 85 fe ff ff       	callq  ffffffff80109e31 <mkgate>
  struct cpu *c;
  uint *idt = (uint*) kalloc();
  int n;
  memset(idt, 0, PGSIZE);

  for (n = 0; n < 256; n++)
ffffffff80109fac:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffff80109fb0:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
ffffffff80109fb7:	7e cc                	jle    ffffffff80109f85 <seginit+0x30>
    mkgate(idt, n, vectors[n], 0, 0);
  mkgate(idt, 64, vectors[64], 3, 1);
ffffffff80109fb9:	48 8b 15 b8 18 00 00 	mov    0x18b8(%rip),%rdx        # ffffffff8010b878 <vectors+0x200>
ffffffff80109fc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109fc4:	41 b8 01 00 00 00    	mov    $0x1,%r8d
ffffffff80109fca:	b9 03 00 00 00       	mov    $0x3,%ecx
ffffffff80109fcf:	be 40 00 00 00       	mov    $0x40,%esi
ffffffff80109fd4:	48 89 c7             	mov    %rax,%rdi
ffffffff80109fd7:	e8 55 fe ff ff       	callq  ffffffff80109e31 <mkgate>

  lidt((void*) idt, PGSIZE);
ffffffff80109fdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff80109fe0:	be 00 10 00 00       	mov    $0x1000,%esi
ffffffff80109fe5:	48 89 c7             	mov    %rax,%rdi
ffffffff80109fe8:	e8 9f fd ff ff       	callq  ffffffff80109d8c <lidt>

  // create a page for cpu local storage 
  local = kalloc();
ffffffff80109fed:	e8 29 9d ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff80109ff2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  memset(local, 0, PGSIZE);
ffffffff80109ff6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff80109ffa:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff80109fff:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a004:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a007:	e8 06 cd ff ff       	callq  ffffffff80106d12 <memset>

  gdt = (uint64*) local;
ffffffff8010a00c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a010:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  tss = (uint*) (((char*) local) + 1024);
ffffffff8010a014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a018:	48 05 00 04 00 00    	add    $0x400,%rax
ffffffff8010a01e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  tss[16] = 0x00680000; // IO Map Base = End of TSS
ffffffff8010a022:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a026:	48 83 c0 40          	add    $0x40,%rax
ffffffff8010a02a:	c7 00 00 00 68 00    	movl   $0x680000,(%rax)

  // point FS smack in the middle of our local storage page
  wrmsr(0xC0000100, ((uint64) local) + (PGSIZE / 2));
ffffffff8010a030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a034:	48 05 00 08 00 00    	add    $0x800,%rax
ffffffff8010a03a:	48 89 c6             	mov    %rax,%rsi
ffffffff8010a03d:	bf 00 01 00 c0       	mov    $0xc0000100,%edi
ffffffff8010a042:	e8 d4 60 ff ff       	callq  ffffffff8010011b <wrmsr>

  c = &cpus[cpunum()];
ffffffff8010a047:	e8 5e a0 ff ff       	callq  ffffffff801040aa <cpunum>
ffffffff8010a04c:	48 98                	cltq   
ffffffff8010a04e:	48 89 c2             	mov    %rax,%rdx
ffffffff8010a051:	48 89 d0             	mov    %rdx,%rax
ffffffff8010a054:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8010a058:	48 89 c2             	mov    %rax,%rdx
ffffffff8010a05b:	48 89 d0             	mov    %rdx,%rax
ffffffff8010a05e:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8010a062:	48 29 d0             	sub    %rdx,%rax
ffffffff8010a065:	48 05 e0 27 11 80    	add    $0xffffffff801127e0,%rax
ffffffff8010a06b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  c->local = local;
ffffffff8010a06f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010a073:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff8010a077:	48 89 90 e8 00 00 00 	mov    %rdx,0xe8(%rax)

  cpu = c;
ffffffff8010a07e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
ffffffff8010a082:	64 48 89 04 25 f0 ff 	mov    %rax,%fs:0xfffffffffffffff0
ffffffff8010a089:	ff ff 
  proc = 0;
ffffffff8010a08b:	64 48 c7 04 25 f8 ff 	movq   $0x0,%fs:0xfffffffffffffff8
ffffffff8010a092:	ff ff 00 00 00 00 

  addr = (uint64) tss;
ffffffff8010a098:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a09c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  gdt[0] =         0x0000000000000000;
ffffffff8010a0a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0a4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_KCODE] = 0x0020980000000000;  // Code, DPL=0, R/X
ffffffff8010a0ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0af:	48 83 c0 08          	add    $0x8,%rax
ffffffff8010a0b3:	48 bf 00 00 00 00 00 	movabs $0x20980000000000,%rdi
ffffffff8010a0ba:	98 20 00 
ffffffff8010a0bd:	48 89 38             	mov    %rdi,(%rax)
  gdt[SEG_UCODE] = 0x0020F80000000000;  // Code, DPL=3, R/X
ffffffff8010a0c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0c4:	48 83 c0 20          	add    $0x20,%rax
ffffffff8010a0c8:	48 b9 00 00 00 00 00 	movabs $0x20f80000000000,%rcx
ffffffff8010a0cf:	f8 20 00 
ffffffff8010a0d2:	48 89 08             	mov    %rcx,(%rax)
  gdt[SEG_KDATA] = 0x0000920000000000;  // Data, DPL=0, W
ffffffff8010a0d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0d9:	48 83 c0 10          	add    $0x10,%rax
ffffffff8010a0dd:	48 be 00 00 00 00 00 	movabs $0x920000000000,%rsi
ffffffff8010a0e4:	92 00 00 
ffffffff8010a0e7:	48 89 30             	mov    %rsi,(%rax)
  gdt[SEG_KCPU]  = 0x0000000000000000;  // unused
ffffffff8010a0ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0ee:	48 83 c0 18          	add    $0x18,%rax
ffffffff8010a0f2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  gdt[SEG_UDATA] = 0x0000F20000000000;  // Data, DPL=3, W
ffffffff8010a0f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a0fd:	48 83 c0 28          	add    $0x28,%rax
ffffffff8010a101:	48 bf 00 00 00 00 00 	movabs $0xf20000000000,%rdi
ffffffff8010a108:	f2 00 00 
ffffffff8010a10b:	48 89 38             	mov    %rdi,(%rax)
  gdt[SEG_TSS+0] = (0x0067) | ((addr & 0xFFFFFF) << 16) |
ffffffff8010a10e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a112:	48 83 c0 30          	add    $0x30,%rax
ffffffff8010a116:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffffffff8010a11a:	81 e2 ff ff ff 00    	and    $0xffffff,%edx
ffffffff8010a120:	48 89 d1             	mov    %rdx,%rcx
ffffffff8010a123:	48 c1 e1 10          	shl    $0x10,%rcx
                   (0x00E9LL << 40) | (((addr >> 24) & 0xFF) << 56);
ffffffff8010a127:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffffffff8010a12b:	48 c1 ea 18          	shr    $0x18,%rdx
ffffffff8010a12f:	48 c1 e2 38          	shl    $0x38,%rdx
ffffffff8010a133:	48 09 d1             	or     %rdx,%rcx
ffffffff8010a136:	48 ba 67 00 00 00 00 	movabs $0xe90000000067,%rdx
ffffffff8010a13d:	e9 00 00 
ffffffff8010a140:	48 09 ca             	or     %rcx,%rdx
  gdt[SEG_KCODE] = 0x0020980000000000;  // Code, DPL=0, R/X
  gdt[SEG_UCODE] = 0x0020F80000000000;  // Code, DPL=3, R/X
  gdt[SEG_KDATA] = 0x0000920000000000;  // Data, DPL=0, W
  gdt[SEG_KCPU]  = 0x0000000000000000;  // unused
  gdt[SEG_UDATA] = 0x0000F20000000000;  // Data, DPL=3, W
  gdt[SEG_TSS+0] = (0x0067) | ((addr & 0xFFFFFF) << 16) |
ffffffff8010a143:	48 89 10             	mov    %rdx,(%rax)
                   (0x00E9LL << 40) | (((addr >> 24) & 0xFF) << 56);
  gdt[SEG_TSS+1] = (addr >> 32);
ffffffff8010a146:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a14a:	48 83 c0 38          	add    $0x38,%rax
ffffffff8010a14e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
ffffffff8010a152:	48 c1 ea 20          	shr    $0x20,%rdx
ffffffff8010a156:	48 89 10             	mov    %rdx,(%rax)

  lgdt((void*) gdt, 8 * sizeof(uint64));
ffffffff8010a159:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a15d:	be 40 00 00 00       	mov    $0x40,%esi
ffffffff8010a162:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a165:	e8 d3 fb ff ff       	callq  ffffffff80109d3d <lgdt>

  ltr(SEG_TSS << 3);
ffffffff8010a16a:	bf 30 00 00 00       	mov    $0x30,%edi
ffffffff8010a16f:	e8 67 fc ff ff       	callq  ffffffff80109ddb <ltr>
};
ffffffff8010a174:	90                   	nop
ffffffff8010a175:	c9                   	leaveq 
ffffffff8010a176:	c3                   	retq   

ffffffff8010a177 <setupkvm>:
// because we need to find the other levels later, we'll stash
// backpointers to them in the top two entries of the level two
// table.
pde_t*
setupkvm(void)
{
ffffffff8010a177:	55                   	push   %rbp
ffffffff8010a178:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010a17b:	53                   	push   %rbx
ffffffff8010a17c:	48 83 ec 28          	sub    $0x28,%rsp
  pde_t *pml4 = (pde_t*) kalloc();
ffffffff8010a180:	e8 96 9b ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a185:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  pde_t *pdpt = (pde_t*) kalloc();
ffffffff8010a189:	e8 8d 9b ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a18e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  pde_t *pgdir = (pde_t*) kalloc();
ffffffff8010a192:	e8 84 9b ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a197:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

  memset(pml4, 0, PGSIZE);
ffffffff8010a19b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a19f:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a1a4:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a1a9:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a1ac:	e8 61 cb ff ff       	callq  ffffffff80106d12 <memset>
  memset(pdpt, 0, PGSIZE);
ffffffff8010a1b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a1b5:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a1ba:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a1bf:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a1c2:	e8 4b cb ff ff       	callq  ffffffff80106d12 <memset>
  memset(pgdir, 0, PGSIZE);
ffffffff8010a1c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a1cb:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a1d0:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a1d5:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a1d8:	e8 35 cb ff ff       	callq  ffffffff80106d12 <memset>
  pml4[511] = v2p(kpdpt) | PTE_P | PTE_W | PTE_U;
ffffffff8010a1dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a1e1:	48 8d 98 f8 0f 00 00 	lea    0xff8(%rax),%rbx
ffffffff8010a1e8:	48 8b 05 f1 ce 00 00 	mov    0xcef1(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a1ef:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a1f2:	e8 12 fc ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a1f7:	48 83 c8 07          	or     $0x7,%rax
ffffffff8010a1fb:	48 89 03             	mov    %rax,(%rbx)
  pml4[0] = v2p(pdpt) | PTE_P | PTE_W | PTE_U;
ffffffff8010a1fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a202:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a205:	e8 ff fb ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a20a:	48 83 c8 07          	or     $0x7,%rax
ffffffff8010a20e:	48 89 c2             	mov    %rax,%rdx
ffffffff8010a211:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a215:	48 89 10             	mov    %rdx,(%rax)
  pdpt[0] = v2p(pgdir) | PTE_P | PTE_W | PTE_U; 
ffffffff8010a218:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a21c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a21f:	e8 e5 fb ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a224:	48 83 c8 07          	or     $0x7,%rax
ffffffff8010a228:	48 89 c2             	mov    %rax,%rdx
ffffffff8010a22b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
ffffffff8010a22f:	48 89 10             	mov    %rdx,(%rax)

  // virtual backpointers
  pgdir[511] = ((uintp) pml4) | PTE_P;
ffffffff8010a232:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a236:	48 05 f8 0f 00 00    	add    $0xff8,%rax
ffffffff8010a23c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
ffffffff8010a240:	48 83 ca 01          	or     $0x1,%rdx
ffffffff8010a244:	48 89 10             	mov    %rdx,(%rax)
  pgdir[510] = ((uintp) pdpt) | PTE_P;
ffffffff8010a247:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
ffffffff8010a24b:	48 05 f0 0f 00 00    	add    $0xff0,%rax
ffffffff8010a251:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
ffffffff8010a255:	48 83 ca 01          	or     $0x1,%rdx
ffffffff8010a259:	48 89 10             	mov    %rdx,(%rax)

  return pgdir;
ffffffff8010a25c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
};
ffffffff8010a260:	48 83 c4 28          	add    $0x28,%rsp
ffffffff8010a264:	5b                   	pop    %rbx
ffffffff8010a265:	5d                   	pop    %rbp
ffffffff8010a266:	c3                   	retq   

ffffffff8010a267 <kvmalloc>:
// space for scheduler processes.
//
// linear map the first 4GB of physical memory starting at 0xFFFFFFFF80000000
void
kvmalloc(void)
{
ffffffff8010a267:	55                   	push   %rbp
ffffffff8010a268:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010a26b:	53                   	push   %rbx
ffffffff8010a26c:	48 83 ec 18          	sub    $0x18,%rsp
  int n;
  kpml4 = (pde_t*) kalloc();
ffffffff8010a270:	e8 a6 9a ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a275:	48 89 05 5c ce 00 00 	mov    %rax,0xce5c(%rip)        # ffffffff801170d8 <kpml4>
  kpdpt = (pde_t*) kalloc();
ffffffff8010a27c:	e8 9a 9a ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a281:	48 89 05 58 ce 00 00 	mov    %rax,0xce58(%rip)        # ffffffff801170e0 <kpdpt>
  kpgdir0 = (pde_t*) kalloc();
ffffffff8010a288:	e8 8e 9a ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a28d:	48 89 05 5c ce 00 00 	mov    %rax,0xce5c(%rip)        # ffffffff801170f0 <kpgdir0>
  kpgdir1 = (pde_t*) kalloc();
ffffffff8010a294:	e8 82 9a ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a299:	48 89 05 58 ce 00 00 	mov    %rax,0xce58(%rip)        # ffffffff801170f8 <kpgdir1>
  iopgdir = (pde_t*) kalloc();
ffffffff8010a2a0:	e8 76 9a ff ff       	callq  ffffffff80103d1b <kalloc>
ffffffff8010a2a5:	48 89 05 3c ce 00 00 	mov    %rax,0xce3c(%rip)        # ffffffff801170e8 <iopgdir>
  memset(kpml4, 0, PGSIZE);
ffffffff8010a2ac:	48 8b 05 25 ce 00 00 	mov    0xce25(%rip),%rax        # ffffffff801170d8 <kpml4>
ffffffff8010a2b3:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a2b8:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a2bd:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a2c0:	e8 4d ca ff ff       	callq  ffffffff80106d12 <memset>
  memset(kpdpt, 0, PGSIZE);
ffffffff8010a2c5:	48 8b 05 14 ce 00 00 	mov    0xce14(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a2cc:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a2d1:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a2d6:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a2d9:	e8 34 ca ff ff       	callq  ffffffff80106d12 <memset>
  memset(iopgdir, 0, PGSIZE);
ffffffff8010a2de:	48 8b 05 03 ce 00 00 	mov    0xce03(%rip),%rax        # ffffffff801170e8 <iopgdir>
ffffffff8010a2e5:	ba 00 10 00 00       	mov    $0x1000,%edx
ffffffff8010a2ea:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a2ef:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a2f2:	e8 1b ca ff ff       	callq  ffffffff80106d12 <memset>
  kpml4[511] = v2p(kpdpt) | PTE_P | PTE_W;
ffffffff8010a2f7:	48 8b 05 da cd 00 00 	mov    0xcdda(%rip),%rax        # ffffffff801170d8 <kpml4>
ffffffff8010a2fe:	48 8d 98 f8 0f 00 00 	lea    0xff8(%rax),%rbx
ffffffff8010a305:	48 8b 05 d4 cd 00 00 	mov    0xcdd4(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a30c:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a30f:	e8 f5 fa ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a314:	48 83 c8 03          	or     $0x3,%rax
ffffffff8010a318:	48 89 03             	mov    %rax,(%rbx)
  kpdpt[511] = v2p(kpgdir1) | PTE_P | PTE_W;
ffffffff8010a31b:	48 8b 05 be cd 00 00 	mov    0xcdbe(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a322:	48 8d 98 f8 0f 00 00 	lea    0xff8(%rax),%rbx
ffffffff8010a329:	48 8b 05 c8 cd 00 00 	mov    0xcdc8(%rip),%rax        # ffffffff801170f8 <kpgdir1>
ffffffff8010a330:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a333:	e8 d1 fa ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a338:	48 83 c8 03          	or     $0x3,%rax
ffffffff8010a33c:	48 89 03             	mov    %rax,(%rbx)
  kpdpt[510] = v2p(kpgdir0) | PTE_P | PTE_W;
ffffffff8010a33f:	48 8b 05 9a cd 00 00 	mov    0xcd9a(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a346:	48 8d 98 f0 0f 00 00 	lea    0xff0(%rax),%rbx
ffffffff8010a34d:	48 8b 05 9c cd 00 00 	mov    0xcd9c(%rip),%rax        # ffffffff801170f0 <kpgdir0>
ffffffff8010a354:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a357:	e8 ad fa ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a35c:	48 83 c8 03          	or     $0x3,%rax
ffffffff8010a360:	48 89 03             	mov    %rax,(%rbx)
  kpdpt[509] = v2p(iopgdir) | PTE_P | PTE_W;
ffffffff8010a363:	48 8b 05 76 cd 00 00 	mov    0xcd76(%rip),%rax        # ffffffff801170e0 <kpdpt>
ffffffff8010a36a:	48 8d 98 e8 0f 00 00 	lea    0xfe8(%rax),%rbx
ffffffff8010a371:	48 8b 05 70 cd 00 00 	mov    0xcd70(%rip),%rax        # ffffffff801170e8 <iopgdir>
ffffffff8010a378:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a37b:	e8 89 fa ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a380:	48 83 c8 03          	or     $0x3,%rax
ffffffff8010a384:	48 89 03             	mov    %rax,(%rbx)
  for (n = 0; n < NPDENTRIES; n++) {
ffffffff8010a387:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffffffff8010a38e:	eb 4b                	jmp    ffffffff8010a3db <kvmalloc+0x174>
    kpgdir0[n] = (n << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
ffffffff8010a390:	48 8b 05 59 cd 00 00 	mov    0xcd59(%rip),%rax        # ffffffff801170f0 <kpgdir0>
ffffffff8010a397:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff8010a39a:	48 63 d2             	movslq %edx,%rdx
ffffffff8010a39d:	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff8010a3a1:	48 01 c2             	add    %rax,%rdx
ffffffff8010a3a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010a3a7:	c1 e0 15             	shl    $0x15,%eax
ffffffff8010a3aa:	0c 83                	or     $0x83,%al
ffffffff8010a3ac:	48 98                	cltq   
ffffffff8010a3ae:	48 89 02             	mov    %rax,(%rdx)
    kpgdir1[n] = ((n + 512) << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
ffffffff8010a3b1:	48 8b 05 40 cd 00 00 	mov    0xcd40(%rip),%rax        # ffffffff801170f8 <kpgdir1>
ffffffff8010a3b8:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff8010a3bb:	48 63 d2             	movslq %edx,%rdx
ffffffff8010a3be:	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff8010a3c2:	48 01 c2             	add    %rax,%rdx
ffffffff8010a3c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
ffffffff8010a3c8:	05 00 02 00 00       	add    $0x200,%eax
ffffffff8010a3cd:	c1 e0 15             	shl    $0x15,%eax
ffffffff8010a3d0:	0c 83                	or     $0x83,%al
ffffffff8010a3d2:	48 98                	cltq   
ffffffff8010a3d4:	48 89 02             	mov    %rax,(%rdx)
  memset(iopgdir, 0, PGSIZE);
  kpml4[511] = v2p(kpdpt) | PTE_P | PTE_W;
  kpdpt[511] = v2p(kpgdir1) | PTE_P | PTE_W;
  kpdpt[510] = v2p(kpgdir0) | PTE_P | PTE_W;
  kpdpt[509] = v2p(iopgdir) | PTE_P | PTE_W;
  for (n = 0; n < NPDENTRIES; n++) {
ffffffff8010a3d7:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffffffff8010a3db:	81 7d ec ff 01 00 00 	cmpl   $0x1ff,-0x14(%rbp)
ffffffff8010a3e2:	7e ac                	jle    ffffffff8010a390 <kvmalloc+0x129>
    kpgdir0[n] = (n << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
    kpgdir1[n] = ((n + 512) << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
  }
  for (n = 0; n < 16; n++)
ffffffff8010a3e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
ffffffff8010a3eb:	eb 2c                	jmp    ffffffff8010a419 <kvmalloc+0x1b2>
    iopgdir[n] = (DEVSPACE + (n << PDXSHIFT)) | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
ffffffff8010a3ed:	48 8b 05 f4 cc 00 00 	mov    0xccf4(%rip),%rax        # ffffffff801170e8 <iopgdir>
ffffffff8010a3f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff8010a3f7:	48 63 d2             	movslq %edx,%rdx
ffffffff8010a3fa:	48 c1 e2 03          	shl    $0x3,%rdx
ffffffff8010a3fe:	48 01 d0             	add    %rdx,%rax
ffffffff8010a401:	8b 55 ec             	mov    -0x14(%rbp),%edx
ffffffff8010a404:	c1 e2 15             	shl    $0x15,%edx
ffffffff8010a407:	81 ea 00 00 00 02    	sub    $0x2000000,%edx
ffffffff8010a40d:	80 ca 9b             	or     $0x9b,%dl
ffffffff8010a410:	89 d2                	mov    %edx,%edx
ffffffff8010a412:	48 89 10             	mov    %rdx,(%rax)
  kpdpt[509] = v2p(iopgdir) | PTE_P | PTE_W;
  for (n = 0; n < NPDENTRIES; n++) {
    kpgdir0[n] = (n << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
    kpgdir1[n] = ((n + 512) << PDXSHIFT) | PTE_PS | PTE_P | PTE_W;
  }
  for (n = 0; n < 16; n++)
ffffffff8010a415:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
ffffffff8010a419:	83 7d ec 0f          	cmpl   $0xf,-0x14(%rbp)
ffffffff8010a41d:	7e ce                	jle    ffffffff8010a3ed <kvmalloc+0x186>
    iopgdir[n] = (DEVSPACE + (n << PDXSHIFT)) | PTE_PS | PTE_P | PTE_W | PTE_PWT | PTE_PCD;
  switchkvm();
ffffffff8010a41f:	e8 08 00 00 00       	callq  ffffffff8010a42c <switchkvm>
}
ffffffff8010a424:	90                   	nop
ffffffff8010a425:	48 83 c4 18          	add    $0x18,%rsp
ffffffff8010a429:	5b                   	pop    %rbx
ffffffff8010a42a:	5d                   	pop    %rbp
ffffffff8010a42b:	c3                   	retq   

ffffffff8010a42c <switchkvm>:

void
switchkvm(void)
{
ffffffff8010a42c:	55                   	push   %rbp
ffffffff8010a42d:	48 89 e5             	mov    %rsp,%rbp
  lcr3(v2p(kpml4));
ffffffff8010a430:	48 8b 05 a1 cc 00 00 	mov    0xcca1(%rip),%rax        # ffffffff801170d8 <kpml4>
ffffffff8010a437:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a43a:	e8 ca f9 ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a43f:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a442:	e8 ac f9 ff ff       	callq  ffffffff80109df3 <lcr3>
}
ffffffff8010a447:	90                   	nop
ffffffff8010a448:	5d                   	pop    %rbp
ffffffff8010a449:	c3                   	retq   

ffffffff8010a44a <switchuvm>:

void
switchuvm(struct proc *p)
{
ffffffff8010a44a:	55                   	push   %rbp
ffffffff8010a44b:	48 89 e5             	mov    %rsp,%rbp
ffffffff8010a44e:	48 83 ec 20          	sub    $0x20,%rsp
ffffffff8010a452:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  void *pml4;
  uint *tss;
  pushcli();
ffffffff8010a456:	e8 7a c7 ff ff       	callq  ffffffff80106bd5 <pushcli>
  if(p->pgdir == 0)
ffffffff8010a45b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a45f:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff8010a463:	48 85 c0             	test   %rax,%rax
ffffffff8010a466:	75 0c                	jne    ffffffff8010a474 <switchuvm+0x2a>
    panic("switchuvm: no pgdir");
ffffffff8010a468:	48 c7 c7 06 af 10 80 	mov    $0xffffffff8010af06,%rdi
ffffffff8010a46f:	e8 8b 64 ff ff       	callq  ffffffff801008ff <panic>
  tss = (uint*) (((char*) cpu->local) + 1024);
ffffffff8010a474:	64 48 8b 04 25 f0 ff 	mov    %fs:0xfffffffffffffff0,%rax
ffffffff8010a47b:	ff ff 
ffffffff8010a47d:	48 8b 80 e8 00 00 00 	mov    0xe8(%rax),%rax
ffffffff8010a484:	48 05 00 04 00 00    	add    $0x400,%rax
ffffffff8010a48a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  tss_set_rsp(tss, 0, (uintp)proc->kstack + KSTACKSIZE);
ffffffff8010a48e:	64 48 8b 04 25 f8 ff 	mov    %fs:0xfffffffffffffff8,%rax
ffffffff8010a495:	ff ff 
ffffffff8010a497:	48 8b 40 10          	mov    0x10(%rax),%rax
ffffffff8010a49b:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
ffffffff8010a4a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
ffffffff8010a4a6:	be 00 00 00 00       	mov    $0x0,%esi
ffffffff8010a4ab:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a4ae:	e8 4a fa ff ff       	callq  ffffffff80109efd <tss_set_rsp>
  pml4 = (void*) PTE_ADDR(p->pgdir[511]);
ffffffff8010a4b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
ffffffff8010a4b7:	48 8b 40 08          	mov    0x8(%rax),%rax
ffffffff8010a4bb:	48 05 f8 0f 00 00    	add    $0xff8,%rax
ffffffff8010a4c1:	48 8b 00             	mov    (%rax),%rax
ffffffff8010a4c4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
ffffffff8010a4ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  lcr3(v2p(pml4));
ffffffff8010a4ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
ffffffff8010a4d2:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a4d5:	e8 2f f9 ff ff       	callq  ffffffff80109e09 <v2p>
ffffffff8010a4da:	48 89 c7             	mov    %rax,%rdi
ffffffff8010a4dd:	e8 11 f9 ff ff       	callq  ffffffff80109df3 <lcr3>
  popcli();
ffffffff8010a4e2:	e8 3e c7 ff ff       	callq  ffffffff80106c25 <popcli>
}
ffffffff8010a4e7:	90                   	nop
ffffffff8010a4e8:	c9                   	leaveq 
ffffffff8010a4e9:	c3                   	retq   
