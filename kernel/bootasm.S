#include "asm.h"
#include "memlayout.h"
#include "mmu.h"

#define ST2_SECTORS 16
#define ST2_STARTSECTOR 1
#define ST2_ADDRESS 0x8000
#define ST2_SEGMENT 0x0000

#define ST3_SECTORS 100
#define ST3_STARTSECTOR 1
#define ST3_ADDRESS 0x0000
//#define ST3_SEGMENT 0x6000
#define ST3_SEGMENT 0x1000


# Start the first CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
  movw    %ax,%ds             # -> Data Segment
  movw    %ax,%es             # -> Extra Segment
  movw    %ax,%ss             # -> Stack Segment
 movw $0x7c00,%ax
 movw %ax,%sp
  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.1

  movb    $0xd1,%al               # 0xd1 -> port 0x64
  outb    %al,$0x64

seta20.2:
  inb     $0x64,%al               # Wait for not busy
  testb   $0x2,%al
  jnz     seta20.2

  movb    $0xdf,%al               # 0xdf -> port 0x60
  outb    %al,$0x60

	movb %dl,DriveNumber 

#load kernel form disk by bios int 0x13h.

# Read the 2nd stage boot loader into memory.
	#mov ah, 0x42			; Extended Read
	#mov dl, [DriveNumber]		; http://www.ctyme.com/intr/rb-0708.htm
	#mov si, ST2_DAP;
	#int 0x13
	#jc read_fail

	
	movb $0x42,%ah 
	movb DriveNumber,%dl 
	movw $ST3_DAP,%si 
	int   $0x13
	jc read_fail


  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
  movl    %cr0, %eax
  orl     $CR0_PE, %eax
  movl    %eax, %cr0

//PAGEBREAK!
  # Complete transition to 32-bit protected mode by using long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
  movw    %ax, %ds                # -> DS: Data Segment
  movw    %ax, %es                # -> ES: Extra Segment
  movw    %ax, %ss                # -> SS: Stack Segment
  movw    $0, %ax                 # Zero segments not ready for use
  movw    %ax, %fs                # -> FS
  movw    %ax, %gs                # -> GS

  # Set up the stack pointer and call into C.
  movl    $start, %esp
  call    bootmain
  # If bootmain returns (it shouldn't), then loop
spin:
  jmp     spin



DriveNumber: .byte 0x00
msg_ReadFail: .asciz "Failed to read drive." 

print_string_16:		#	; Output string in SI to screen
	pusha
	movb $0x0e,%ah 		#	; int 0x10 teletype function
.repeat:
	lodsb			#	; Get char from string
	cmpb $0,%al   #, 0
	je .done			#; If char is zero, end of string
	int $0x10		#	; Otherwise, print it
	jmp   .repeat
.done:
	popa
	ret
	
	
read_fail:
	movw msg_ReadFail,%si
	call print_string_16
	jmp halt
 
halt:
	hlt
	jmp halt
	
	
	
# Bootstrap GDT
.p2align 2                                # force 4 byte alignment
gdt:
  SEG_NULLASM                             # null seg
  SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)   # code seg
  SEG_ASM(STA_W, 0x0, 0xffffffff)         # data seg

gdtdesc:
  .word   (gdtdesc - gdt - 1)             # sizeof(gdt) - 1
  .long   gdt                             # address gdt


ST2_DAP:
	.byte 0x10
	.byte 0x00
	.word ST2_SECTORS
	.word ST2_ADDRESS
	.word ST2_SEGMENT
	.quad ST2_STARTSECTOR


ST3_DAP:
	.byte 0x10
	.byte 0x00
	.word ST3_SECTORS
	.word ST3_ADDRESS
	.word ST3_SEGMENT
	.quad ST3_STARTSECTOR
