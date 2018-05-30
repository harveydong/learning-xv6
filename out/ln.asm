
.fs/ln:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  if(argc != 3){
   1:	83 ff 03             	cmp    $0x3,%edi
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	53                   	push   %rbx
   8:	50                   	push   %rax
  if(argc != 3){
   9:	74 15                	je     20 <main+0x20>
    printf(2, "Usage: ln old new\n");
   b:	48 c7 c6 20 06 00 00 	mov    $0x620,%rsi
  12:	bf 02 00 00 00       	mov    $0x2,%edi
  17:	31 c0                	xor    %eax,%eax
  19:	e8 ce 02 00 00       	callq  2ec <printf>
  1e:	eb 2f                	jmp    4f <main+0x4f>
  20:	48 89 f3             	mov    %rsi,%rbx
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
  23:	48 8b 76 10          	mov    0x10(%rsi),%rsi
  27:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  2b:	e8 e9 01 00 00       	callq  219 <link>
  30:	85 c0                	test   %eax,%eax
  32:	79 1b                	jns    4f <main+0x4f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  34:	48 8b 4b 10          	mov    0x10(%rbx),%rcx
  38:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  3c:	48 c7 c6 33 06 00 00 	mov    $0x633,%rsi
  43:	bf 02 00 00 00       	mov    $0x2,%edi
  48:	31 c0                	xor    %eax,%eax
  4a:	e8 9d 02 00 00       	callq  2ec <printf>
  exit();
  4f:	e8 65 01 00 00       	callq  1b9 <exit>

0000000000000054 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  54:	55                   	push   %rbp
  55:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  58:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5a:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5d:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  60:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  63:	48 ff c2             	inc    %rdx
  66:	84 c9                	test   %cl,%cl
  68:	75 f3                	jne    5d <strcpy+0x9>
    ;
  return os;
}
  6a:	5d                   	pop    %rbp
  6b:	c3                   	retq   

000000000000006c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6c:	55                   	push   %rbp
  6d:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  70:	0f b6 07             	movzbl (%rdi),%eax
  73:	84 c0                	test   %al,%al
  75:	74 0c                	je     83 <strcmp+0x17>
  77:	3a 06                	cmp    (%rsi),%al
  79:	75 08                	jne    83 <strcmp+0x17>
    p++, q++;
  7b:	48 ff c7             	inc    %rdi
  7e:	48 ff c6             	inc    %rsi
  81:	eb ed                	jmp    70 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  83:	0f b6 16             	movzbl (%rsi),%edx
}
  86:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  87:	29 d0                	sub    %edx,%eax
}
  89:	c3                   	retq   

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  8b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  8d:	48 89 e5             	mov    %rsp,%rbp
  90:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
  94:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
  99:	74 05                	je     a0 <strlen+0x16>
  9b:	48 89 d0             	mov    %rdx,%rax
  9e:	eb f0                	jmp    90 <strlen+0x6>
    ;
  return n;
}
  a0:	5d                   	pop    %rbp
  a1:	c3                   	retq   

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	55                   	push   %rbp
  a3:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a6:	89 d1                	mov    %edx,%ecx
  a8:	89 f0                	mov    %esi,%eax
  aa:	48 89 e5             	mov    %rsp,%rbp
  ad:	fc                   	cld    
  ae:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  b0:	4c 89 c0             	mov    %r8,%rax
  b3:	5d                   	pop    %rbp
  b4:	c3                   	retq   

00000000000000b5 <strchr>:

char*
strchr(const char *s, char c)
{
  b5:	55                   	push   %rbp
  b6:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
  b9:	8a 07                	mov    (%rdi),%al
  bb:	84 c0                	test   %al,%al
  bd:	74 0a                	je     c9 <strchr+0x14>
    if(*s == c)
  bf:	40 38 f0             	cmp    %sil,%al
  c2:	74 09                	je     cd <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  c4:	48 ff c7             	inc    %rdi
  c7:	eb f0                	jmp    b9 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
  c9:	31 c0                	xor    %eax,%eax
  cb:	eb 03                	jmp    d0 <strchr+0x1b>
  cd:	48 89 f8             	mov    %rdi,%rax
}
  d0:	5d                   	pop    %rbp
  d1:	c3                   	retq   

00000000000000d2 <gets>:

char*
gets(char *buf, int max)
{
  d2:	55                   	push   %rbp
  d3:	48 89 e5             	mov    %rsp,%rbp
  d6:	41 57                	push   %r15
  d8:	41 56                	push   %r14
  da:	41 55                	push   %r13
  dc:	41 54                	push   %r12
  de:	41 89 f7             	mov    %esi,%r15d
  e1:	53                   	push   %rbx
  e2:	49 89 fc             	mov    %rdi,%r12
  e5:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e8:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
  ea:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ee:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  f2:	45 39 fd             	cmp    %r15d,%r13d
  f5:	7d 2c                	jge    123 <gets+0x51>
    cc = read(0, &c, 1);
  f7:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  fb:	31 ff                	xor    %edi,%edi
  fd:	ba 01 00 00 00       	mov    $0x1,%edx
 102:	e8 ca 00 00 00       	callq  1d1 <read>
    if(cc < 1)
 107:	85 c0                	test   %eax,%eax
 109:	7e 18                	jle    123 <gets+0x51>
      break;
    buf[i++] = c;
 10b:	8a 45 cf             	mov    -0x31(%rbp),%al
 10e:	49 ff c6             	inc    %r14
 111:	49 63 dd             	movslq %r13d,%rbx
 114:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 118:	3c 0a                	cmp    $0xa,%al
 11a:	74 04                	je     120 <gets+0x4e>
 11c:	3c 0d                	cmp    $0xd,%al
 11e:	75 ce                	jne    ee <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 120:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 123:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 128:	48 83 c4 18          	add    $0x18,%rsp
 12c:	4c 89 e0             	mov    %r12,%rax
 12f:	5b                   	pop    %rbx
 130:	41 5c                	pop    %r12
 132:	41 5d                	pop    %r13
 134:	41 5e                	pop    %r14
 136:	41 5f                	pop    %r15
 138:	5d                   	pop    %rbp
 139:	c3                   	retq   

000000000000013a <stat>:

int
stat(const char *n, struct stat *st)
{
 13a:	55                   	push   %rbp
 13b:	48 89 e5             	mov    %rsp,%rbp
 13e:	41 54                	push   %r12
 140:	53                   	push   %rbx
 141:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 144:	31 f6                	xor    %esi,%esi
 146:	e8 ae 00 00 00       	callq  1f9 <open>
 14b:	41 89 c4             	mov    %eax,%r12d
 14e:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 151:	45 85 e4             	test   %r12d,%r12d
 154:	78 17                	js     16d <stat+0x33>
    return -1;
  r = fstat(fd, st);
 156:	48 89 de             	mov    %rbx,%rsi
 159:	44 89 e7             	mov    %r12d,%edi
 15c:	e8 b0 00 00 00       	callq  211 <fstat>
  close(fd);
 161:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 164:	89 c3                	mov    %eax,%ebx
  close(fd);
 166:	e8 76 00 00 00       	callq  1e1 <close>
  return r;
 16b:	89 d8                	mov    %ebx,%eax
}
 16d:	5b                   	pop    %rbx
 16e:	41 5c                	pop    %r12
 170:	5d                   	pop    %rbp
 171:	c3                   	retq   

0000000000000172 <atoi>:

int
atoi(const char *s)
{
 172:	55                   	push   %rbp
  int n;

  n = 0;
 173:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 175:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 178:	0f be 17             	movsbl (%rdi),%edx
 17b:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 17e:	80 f9 09             	cmp    $0x9,%cl
 181:	77 0c                	ja     18f <atoi+0x1d>
    n = n*10 + *s++ - '0';
 183:	6b c0 0a             	imul   $0xa,%eax,%eax
 186:	48 ff c7             	inc    %rdi
 189:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 18d:	eb e9                	jmp    178 <atoi+0x6>
  return n;
}
 18f:	5d                   	pop    %rbp
 190:	c3                   	retq   

0000000000000191 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 191:	55                   	push   %rbp
 192:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 195:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 197:	48 89 e5             	mov    %rsp,%rbp
 19a:	89 d7                	mov    %edx,%edi
 19c:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 19e:	85 ff                	test   %edi,%edi
 1a0:	7e 0d                	jle    1af <memmove+0x1e>
    *dst++ = *src++;
 1a2:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 1a6:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 1aa:	48 ff c1             	inc    %rcx
 1ad:	eb eb                	jmp    19a <memmove+0x9>
  return vdst;
}
 1af:	5d                   	pop    %rbp
 1b0:	c3                   	retq   

00000000000001b1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1b1:	b8 01 00 00 00       	mov    $0x1,%eax
 1b6:	cd 40                	int    $0x40
 1b8:	c3                   	retq   

00000000000001b9 <exit>:
SYSCALL(exit)
 1b9:	b8 02 00 00 00       	mov    $0x2,%eax
 1be:	cd 40                	int    $0x40
 1c0:	c3                   	retq   

00000000000001c1 <wait>:
SYSCALL(wait)
 1c1:	b8 03 00 00 00       	mov    $0x3,%eax
 1c6:	cd 40                	int    $0x40
 1c8:	c3                   	retq   

00000000000001c9 <pipe>:
SYSCALL(pipe)
 1c9:	b8 04 00 00 00       	mov    $0x4,%eax
 1ce:	cd 40                	int    $0x40
 1d0:	c3                   	retq   

00000000000001d1 <read>:
SYSCALL(read)
 1d1:	b8 05 00 00 00       	mov    $0x5,%eax
 1d6:	cd 40                	int    $0x40
 1d8:	c3                   	retq   

00000000000001d9 <write>:
SYSCALL(write)
 1d9:	b8 10 00 00 00       	mov    $0x10,%eax
 1de:	cd 40                	int    $0x40
 1e0:	c3                   	retq   

00000000000001e1 <close>:
SYSCALL(close)
 1e1:	b8 15 00 00 00       	mov    $0x15,%eax
 1e6:	cd 40                	int    $0x40
 1e8:	c3                   	retq   

00000000000001e9 <kill>:
SYSCALL(kill)
 1e9:	b8 06 00 00 00       	mov    $0x6,%eax
 1ee:	cd 40                	int    $0x40
 1f0:	c3                   	retq   

00000000000001f1 <exec>:
SYSCALL(exec)
 1f1:	b8 07 00 00 00       	mov    $0x7,%eax
 1f6:	cd 40                	int    $0x40
 1f8:	c3                   	retq   

00000000000001f9 <open>:
SYSCALL(open)
 1f9:	b8 0f 00 00 00       	mov    $0xf,%eax
 1fe:	cd 40                	int    $0x40
 200:	c3                   	retq   

0000000000000201 <mknod>:
SYSCALL(mknod)
 201:	b8 11 00 00 00       	mov    $0x11,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	retq   

0000000000000209 <unlink>:
SYSCALL(unlink)
 209:	b8 12 00 00 00       	mov    $0x12,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	retq   

0000000000000211 <fstat>:
SYSCALL(fstat)
 211:	b8 08 00 00 00       	mov    $0x8,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	retq   

0000000000000219 <link>:
SYSCALL(link)
 219:	b8 13 00 00 00       	mov    $0x13,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	retq   

0000000000000221 <mkdir>:
SYSCALL(mkdir)
 221:	b8 14 00 00 00       	mov    $0x14,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	retq   

0000000000000229 <chdir>:
SYSCALL(chdir)
 229:	b8 09 00 00 00       	mov    $0x9,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	retq   

0000000000000231 <dup>:
SYSCALL(dup)
 231:	b8 0a 00 00 00       	mov    $0xa,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	retq   

0000000000000239 <getpid>:
SYSCALL(getpid)
 239:	b8 0b 00 00 00       	mov    $0xb,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	retq   

0000000000000241 <sbrk>:
SYSCALL(sbrk)
 241:	b8 0c 00 00 00       	mov    $0xc,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	retq   

0000000000000249 <sleep>:
SYSCALL(sleep)
 249:	b8 0d 00 00 00       	mov    $0xd,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	retq   

0000000000000251 <uptime>:
SYSCALL(uptime)
 251:	b8 0e 00 00 00       	mov    $0xe,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	retq   

0000000000000259 <chmod>:
SYSCALL(chmod)
 259:	b8 16 00 00 00       	mov    $0x16,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	retq   

0000000000000261 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 261:	55                   	push   %rbp
 262:	41 89 d0             	mov    %edx,%r8d
 265:	48 89 e5             	mov    %rsp,%rbp
 268:	41 54                	push   %r12
 26a:	53                   	push   %rbx
 26b:	41 89 fc             	mov    %edi,%r12d
 26e:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 272:	85 c9                	test   %ecx,%ecx
 274:	74 12                	je     288 <printint+0x27>
 276:	89 f0                	mov    %esi,%eax
 278:	c1 e8 1f             	shr    $0x1f,%eax
 27b:	74 0b                	je     288 <printint+0x27>
    neg = 1;
    x = -xx;
 27d:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 27f:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 284:	f7 d8                	neg    %eax
 286:	eb 04                	jmp    28c <printint+0x2b>
  } else {
    x = xx;
 288:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 28a:	31 f6                	xor    %esi,%esi
 28c:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 290:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 292:	31 d2                	xor    %edx,%edx
 294:	48 ff c7             	inc    %rdi
 297:	8d 59 01             	lea    0x1(%rcx),%ebx
 29a:	41 f7 f0             	div    %r8d
 29d:	89 d2                	mov    %edx,%edx
 29f:	8a 92 50 06 00 00    	mov    0x650(%rdx),%dl
 2a5:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 2a8:	85 c0                	test   %eax,%eax
 2aa:	74 04                	je     2b0 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 2ac:	89 d9                	mov    %ebx,%ecx
 2ae:	eb e2                	jmp    292 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 2b0:	85 f6                	test   %esi,%esi
 2b2:	74 0b                	je     2bf <printint+0x5e>
    buf[i++] = '-';
 2b4:	48 63 db             	movslq %ebx,%rbx
 2b7:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 2bc:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 2bf:	ff cb                	dec    %ebx
 2c1:	83 fb ff             	cmp    $0xffffffff,%ebx
 2c4:	74 1d                	je     2e3 <printint+0x82>
    putc(fd, buf[i]);
 2c6:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 2c9:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 2cd:	ba 01 00 00 00       	mov    $0x1,%edx
 2d2:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 2d6:	44 89 e7             	mov    %r12d,%edi
 2d9:	88 45 df             	mov    %al,-0x21(%rbp)
 2dc:	e8 f8 fe ff ff       	callq  1d9 <write>
 2e1:	eb dc                	jmp    2bf <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 2e3:	48 83 c4 20          	add    $0x20,%rsp
 2e7:	5b                   	pop    %rbx
 2e8:	41 5c                	pop    %r12
 2ea:	5d                   	pop    %rbp
 2eb:	c3                   	retq   

00000000000002ec <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2ec:	55                   	push   %rbp
 2ed:	48 89 e5             	mov    %rsp,%rbp
 2f0:	41 56                	push   %r14
 2f2:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2f4:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2f8:	41 54                	push   %r12
 2fa:	53                   	push   %rbx
 2fb:	41 89 fc             	mov    %edi,%r12d
 2fe:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 301:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 303:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 307:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 30b:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 30f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 313:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 317:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 31b:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 31f:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 326:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 32a:	45 8a 2e             	mov    (%r14),%r13b
 32d:	45 84 ed             	test   %r13b,%r13b
 330:	0f 84 8f 01 00 00    	je     4c5 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 336:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 338:	41 0f be d5          	movsbl %r13b,%edx
 33c:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 340:	75 23                	jne    365 <printf+0x79>
      if(c == '%'){
 342:	83 f8 25             	cmp    $0x25,%eax
 345:	0f 84 6d 01 00 00    	je     4b8 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 34b:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 34f:	ba 01 00 00 00       	mov    $0x1,%edx
 354:	44 89 e7             	mov    %r12d,%edi
 357:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 35b:	e8 79 fe ff ff       	callq  1d9 <write>
 360:	e9 58 01 00 00       	jmpq   4bd <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 365:	83 fb 25             	cmp    $0x25,%ebx
 368:	0f 85 4f 01 00 00    	jne    4bd <printf+0x1d1>
      if(c == 'd'){
 36e:	83 f8 64             	cmp    $0x64,%eax
 371:	75 2e                	jne    3a1 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 373:	8b 55 98             	mov    -0x68(%rbp),%edx
 376:	83 fa 2f             	cmp    $0x2f,%edx
 379:	77 0e                	ja     389 <printf+0x9d>
 37b:	89 d0                	mov    %edx,%eax
 37d:	83 c2 08             	add    $0x8,%edx
 380:	48 03 45 a8          	add    -0x58(%rbp),%rax
 384:	89 55 98             	mov    %edx,-0x68(%rbp)
 387:	eb 0c                	jmp    395 <printf+0xa9>
 389:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 38d:	48 8d 50 08          	lea    0x8(%rax),%rdx
 391:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 395:	b9 01 00 00 00       	mov    $0x1,%ecx
 39a:	ba 0a 00 00 00       	mov    $0xa,%edx
 39f:	eb 34                	jmp    3d5 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 3a1:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3a7:	83 fa 70             	cmp    $0x70,%edx
 3aa:	75 38                	jne    3e4 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 3ac:	8b 55 98             	mov    -0x68(%rbp),%edx
 3af:	83 fa 2f             	cmp    $0x2f,%edx
 3b2:	77 0e                	ja     3c2 <printf+0xd6>
 3b4:	89 d0                	mov    %edx,%eax
 3b6:	83 c2 08             	add    $0x8,%edx
 3b9:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3bd:	89 55 98             	mov    %edx,-0x68(%rbp)
 3c0:	eb 0c                	jmp    3ce <printf+0xe2>
 3c2:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3c6:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3ca:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3ce:	31 c9                	xor    %ecx,%ecx
 3d0:	ba 10 00 00 00       	mov    $0x10,%edx
 3d5:	8b 30                	mov    (%rax),%esi
 3d7:	44 89 e7             	mov    %r12d,%edi
 3da:	e8 82 fe ff ff       	callq  261 <printint>
 3df:	e9 d0 00 00 00       	jmpq   4b4 <printf+0x1c8>
      } else if(c == 's'){
 3e4:	83 f8 73             	cmp    $0x73,%eax
 3e7:	75 56                	jne    43f <printf+0x153>
        s = va_arg(ap, char*);
 3e9:	8b 55 98             	mov    -0x68(%rbp),%edx
 3ec:	83 fa 2f             	cmp    $0x2f,%edx
 3ef:	77 0e                	ja     3ff <printf+0x113>
 3f1:	89 d0                	mov    %edx,%eax
 3f3:	83 c2 08             	add    $0x8,%edx
 3f6:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3fa:	89 55 98             	mov    %edx,-0x68(%rbp)
 3fd:	eb 0c                	jmp    40b <printf+0x11f>
 3ff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 403:	48 8d 50 08          	lea    0x8(%rax),%rdx
 407:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 40b:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 40e:	48 c7 c0 47 06 00 00 	mov    $0x647,%rax
 415:	48 85 db             	test   %rbx,%rbx
 418:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 41c:	8a 03                	mov    (%rbx),%al
 41e:	84 c0                	test   %al,%al
 420:	0f 84 8e 00 00 00    	je     4b4 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 426:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 42a:	ba 01 00 00 00       	mov    $0x1,%edx
 42f:	44 89 e7             	mov    %r12d,%edi
 432:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 435:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 438:	e8 9c fd ff ff       	callq  1d9 <write>
 43d:	eb dd                	jmp    41c <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 43f:	83 f8 63             	cmp    $0x63,%eax
 442:	75 32                	jne    476 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 444:	8b 55 98             	mov    -0x68(%rbp),%edx
 447:	83 fa 2f             	cmp    $0x2f,%edx
 44a:	77 0e                	ja     45a <printf+0x16e>
 44c:	89 d0                	mov    %edx,%eax
 44e:	83 c2 08             	add    $0x8,%edx
 451:	48 03 45 a8          	add    -0x58(%rbp),%rax
 455:	89 55 98             	mov    %edx,-0x68(%rbp)
 458:	eb 0c                	jmp    466 <printf+0x17a>
 45a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 45e:	48 8d 50 08          	lea    0x8(%rax),%rdx
 462:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 466:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 468:	ba 01 00 00 00       	mov    $0x1,%edx
 46d:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 471:	88 45 94             	mov    %al,-0x6c(%rbp)
 474:	eb 36                	jmp    4ac <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 476:	83 f8 25             	cmp    $0x25,%eax
 479:	75 0f                	jne    48a <printf+0x19e>
 47b:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 47f:	ba 01 00 00 00       	mov    $0x1,%edx
 484:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 488:	eb 22                	jmp    4ac <printf+0x1c0>
 48a:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 48e:	ba 01 00 00 00       	mov    $0x1,%edx
 493:	44 89 e7             	mov    %r12d,%edi
 496:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 49a:	e8 3a fd ff ff       	callq  1d9 <write>
 49f:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 4a3:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 4a7:	ba 01 00 00 00       	mov    $0x1,%edx
 4ac:	44 89 e7             	mov    %r12d,%edi
 4af:	e8 25 fd ff ff       	callq  1d9 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b4:	31 db                	xor    %ebx,%ebx
 4b6:	eb 05                	jmp    4bd <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4b8:	bb 25 00 00 00       	mov    $0x25,%ebx
 4bd:	49 ff c6             	inc    %r14
 4c0:	e9 65 fe ff ff       	jmpq   32a <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c5:	48 83 c4 50          	add    $0x50,%rsp
 4c9:	5b                   	pop    %rbx
 4ca:	41 5c                	pop    %r12
 4cc:	41 5d                	pop    %r13
 4ce:	41 5e                	pop    %r14
 4d0:	5d                   	pop    %rbp
 4d1:	c3                   	retq   

00000000000004d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d2:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d3:	48 8b 05 b6 03 00 00 	mov    0x3b6(%rip),%rax        # 890 <__bss_start>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4da:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 4de:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e1:	48 39 d0             	cmp    %rdx,%rax
 4e4:	48 8b 08             	mov    (%rax),%rcx
 4e7:	72 14                	jb     4fd <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e9:	48 39 c8             	cmp    %rcx,%rax
 4ec:	72 0a                	jb     4f8 <free+0x26>
 4ee:	48 39 ca             	cmp    %rcx,%rdx
 4f1:	72 0f                	jb     502 <free+0x30>
 4f3:	48 39 d0             	cmp    %rdx,%rax
 4f6:	72 0a                	jb     502 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f8:	48 89 c8             	mov    %rcx,%rax
 4fb:	eb e4                	jmp    4e1 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4fd:	48 39 ca             	cmp    %rcx,%rdx
 500:	73 e7                	jae    4e9 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 502:	8b 77 f8             	mov    -0x8(%rdi),%esi
 505:	49 89 f0             	mov    %rsi,%r8
 508:	48 c1 e6 04          	shl    $0x4,%rsi
 50c:	48 01 d6             	add    %rdx,%rsi
 50f:	48 39 ce             	cmp    %rcx,%rsi
 512:	75 0e                	jne    522 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 514:	44 03 41 08          	add    0x8(%rcx),%r8d
 518:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 51c:	48 8b 08             	mov    (%rax),%rcx
 51f:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 522:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 526:	8b 48 08             	mov    0x8(%rax),%ecx
 529:	48 89 ce             	mov    %rcx,%rsi
 52c:	48 c1 e1 04          	shl    $0x4,%rcx
 530:	48 01 c1             	add    %rax,%rcx
 533:	48 39 ca             	cmp    %rcx,%rdx
 536:	75 0a                	jne    542 <free+0x70>
    p->s.size += bp->s.size;
 538:	03 77 f8             	add    -0x8(%rdi),%esi
 53b:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 53e:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 542:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 545:	48 89 05 44 03 00 00 	mov    %rax,0x344(%rip)        # 890 <__bss_start>
}
 54c:	5d                   	pop    %rbp
 54d:	c3                   	retq   

000000000000054e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 54e:	55                   	push   %rbp
 54f:	48 89 e5             	mov    %rsp,%rbp
 552:	41 55                	push   %r13
 554:	41 54                	push   %r12
 556:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 557:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 559:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 55a:	48 8b 0d 2f 03 00 00 	mov    0x32f(%rip),%rcx        # 890 <__bss_start>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 561:	48 83 c3 0f          	add    $0xf,%rbx
 565:	48 c1 eb 04          	shr    $0x4,%rbx
 569:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 56b:	48 85 c9             	test   %rcx,%rcx
 56e:	75 27                	jne    597 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 570:	48 c7 05 15 03 00 00 	movq   $0x8a0,0x315(%rip)        # 890 <__bss_start>
 577:	a0 08 00 00 
 57b:	48 c7 05 1a 03 00 00 	movq   $0x8a0,0x31a(%rip)        # 8a0 <base>
 582:	a0 08 00 00 
 586:	48 c7 c1 a0 08 00 00 	mov    $0x8a0,%rcx
    base.s.size = 0;
 58d:	c7 05 11 03 00 00 00 	movl   $0x0,0x311(%rip)        # 8a8 <base+0x8>
 594:	00 00 00 
 597:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 59d:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a3:	48 8b 01             	mov    (%rcx),%rax
 5a6:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5aa:	45 89 e5             	mov    %r12d,%r13d
 5ad:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5b1:	8b 50 08             	mov    0x8(%rax),%edx
 5b4:	39 d3                	cmp    %edx,%ebx
 5b6:	77 26                	ja     5de <malloc+0x90>
      if(p->s.size == nunits)
 5b8:	75 08                	jne    5c2 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 5ba:	48 8b 10             	mov    (%rax),%rdx
 5bd:	48 89 11             	mov    %rdx,(%rcx)
 5c0:	eb 0f                	jmp    5d1 <malloc+0x83>
      else {
        p->s.size -= nunits;
 5c2:	29 da                	sub    %ebx,%edx
 5c4:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 5c7:	48 c1 e2 04          	shl    $0x4,%rdx
 5cb:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 5ce:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 5d1:	48 89 0d b8 02 00 00 	mov    %rcx,0x2b8(%rip)        # 890 <__bss_start>
      return (void*)(p + 1);
 5d8:	48 83 c0 10          	add    $0x10,%rax
 5dc:	eb 3a                	jmp    618 <malloc+0xca>
    }
    if(p == freep)
 5de:	48 3b 05 ab 02 00 00 	cmp    0x2ab(%rip),%rax        # 890 <__bss_start>
 5e5:	75 27                	jne    60e <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5e7:	44 89 ef             	mov    %r13d,%edi
 5ea:	e8 52 fc ff ff       	callq  241 <sbrk>
  if(p == (char*)-1)
 5ef:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 5f3:	74 21                	je     616 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 5f5:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5f9:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 5fd:	e8 d0 fe ff ff       	callq  4d2 <free>
  return freep;
 602:	48 8b 05 87 02 00 00 	mov    0x287(%rip),%rax        # 890 <__bss_start>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 609:	48 85 c0             	test   %rax,%rax
 60c:	74 08                	je     616 <malloc+0xc8>
        return 0;
  }
 60e:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 611:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 614:	eb 9b                	jmp    5b1 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 616:	31 c0                	xor    %eax,%eax
  }
}
 618:	5a                   	pop    %rdx
 619:	5b                   	pop    %rbx
 61a:	41 5c                	pop    %r12
 61c:	41 5d                	pop    %r13
 61e:	5d                   	pop    %rbp
 61f:	c3                   	retq   
