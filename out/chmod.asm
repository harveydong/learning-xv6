
.fs/chmod:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	41 56                	push   %r14
   6:	41 55                	push   %r13
   8:	41 54                	push   %r12
   a:	53                   	push   %rbx
   b:	48 83 ec 20          	sub    $0x20,%rsp
  if (argc < 3) exit();
   f:	83 ff 02             	cmp    $0x2,%edi
  12:	7e 2e                	jle    42 <main+0x42>

  int fd;
  struct stat st;
  int mode;

  char *path = argv[2];
  14:	4c 8b 66 10          	mov    0x10(%rsi),%r12
  18:	49 89 f6             	mov    %rsi,%r14
  if ((fd = open(path, 0)) < 0) {
  1b:	31 f6                	xor    %esi,%esi
  1d:	4c 89 e7             	mov    %r12,%rdi
  20:	e8 46 02 00 00       	callq  26b <open>
  25:	85 c0                	test   %eax,%eax
  27:	41 89 c5             	mov    %eax,%r13d
  2a:	79 1b                	jns    47 <main+0x47>
    printf(2, "chmod: cannot open %s\n", path);
  2c:	4c 89 e2             	mov    %r12,%rdx
  2f:	48 c7 c6 a0 06 00 00 	mov    $0x6a0,%rsi
  36:	bf 02 00 00 00       	mov    $0x2,%edi
  3b:	31 c0                	xor    %eax,%eax
  3d:	e8 1c 03 00 00       	callq  35e <printf>
    exit();
  42:	e8 e4 01 00 00       	callq  22b <exit>
  }
  if (fstat(fd, &st) < 0) {
  47:	48 8d 75 c4          	lea    -0x3c(%rbp),%rsi
  4b:	89 c7                	mov    %eax,%edi
  4d:	e8 31 02 00 00       	callq  283 <fstat>
  52:	85 c0                	test   %eax,%eax
  54:	79 20                	jns    76 <main+0x76>
    printf(2, "chmod: cannot stat %s\n", path);
  56:	4c 89 e2             	mov    %r12,%rdx
  59:	48 c7 c6 b7 06 00 00 	mov    $0x6b7,%rsi
  60:	bf 02 00 00 00       	mov    $0x2,%edi
  65:	31 c0                	xor    %eax,%eax
  67:	e8 f2 02 00 00       	callq  35e <printf>
    close(fd);
  6c:	44 89 ef             	mov    %r13d,%edi
  6f:	e8 df 01 00 00       	callq  253 <close>
  74:	eb cc                	jmp    42 <main+0x42>
    exit();
  }
  mode = st.mode;
  close(fd);
  76:	44 89 ef             	mov    %r13d,%edi
  if (fstat(fd, &st) < 0) {
    printf(2, "chmod: cannot stat %s\n", path);
    close(fd);
    exit();
  }
  mode = st.mode;
  79:	8b 5d d8             	mov    -0x28(%rbp),%ebx
  close(fd);
  7c:	e8 d2 01 00 00       	callq  253 <close>

  if (strcmp(argv[1], "-x") == 0)
  81:	49 8b 7e 08          	mov    0x8(%r14),%rdi
  85:	48 c7 c6 ce 06 00 00 	mov    $0x6ce,%rsi
  8c:	e8 4d 00 00 00       	callq  de <strcmp>
  91:	85 c0                	test   %eax,%eax
  93:	75 08                	jne    9d <main+0x9d>
    chmod(path, 0x677 & mode);
  95:	81 e3 77 06 00 00    	and    $0x677,%ebx
  9b:	eb 1a                	jmp    b7 <main+0xb7>
  else if (strcmp(argv[1], "+x") == 0)
  9d:	49 8b 7e 08          	mov    0x8(%r14),%rdi
  a1:	48 c7 c6 d1 06 00 00 	mov    $0x6d1,%rsi
  a8:	e8 31 00 00 00       	callq  de <strcmp>
  ad:	85 c0                	test   %eax,%eax
  af:	75 91                	jne    42 <main+0x42>
    chmod(path, 0x777 & mode);
  b1:	81 e3 77 07 00 00    	and    $0x777,%ebx
  b7:	89 de                	mov    %ebx,%esi
  b9:	4c 89 e7             	mov    %r12,%rdi
  bc:	e8 0a 02 00 00       	callq  2cb <chmod>
  c1:	e9 7c ff ff ff       	jmpq   42 <main+0x42>

00000000000000c6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  c6:	55                   	push   %rbp
  c7:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  cc:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  cf:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  d2:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  d5:	48 ff c2             	inc    %rdx
  d8:	84 c9                	test   %cl,%cl
  da:	75 f3                	jne    cf <strcpy+0x9>
    ;
  return os;
}
  dc:	5d                   	pop    %rbp
  dd:	c3                   	retq   

00000000000000de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  de:	55                   	push   %rbp
  df:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  e2:	0f b6 07             	movzbl (%rdi),%eax
  e5:	84 c0                	test   %al,%al
  e7:	74 0c                	je     f5 <strcmp+0x17>
  e9:	3a 06                	cmp    (%rsi),%al
  eb:	75 08                	jne    f5 <strcmp+0x17>
    p++, q++;
  ed:	48 ff c7             	inc    %rdi
  f0:	48 ff c6             	inc    %rsi
  f3:	eb ed                	jmp    e2 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  f5:	0f b6 16             	movzbl (%rsi),%edx
}
  f8:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f9:	29 d0                	sub    %edx,%eax
}
  fb:	c3                   	retq   

00000000000000fc <strlen>:

uint
strlen(const char *s)
{
  fc:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  fd:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  ff:	48 89 e5             	mov    %rsp,%rbp
 102:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 10b:	74 05                	je     112 <strlen+0x16>
 10d:	48 89 d0             	mov    %rdx,%rax
 110:	eb f0                	jmp    102 <strlen+0x6>
    ;
  return n;
}
 112:	5d                   	pop    %rbp
 113:	c3                   	retq   

0000000000000114 <memset>:

void*
memset(void *dst, int c, uint n)
{
 114:	55                   	push   %rbp
 115:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 118:	89 d1                	mov    %edx,%ecx
 11a:	89 f0                	mov    %esi,%eax
 11c:	48 89 e5             	mov    %rsp,%rbp
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 122:	4c 89 c0             	mov    %r8,%rax
 125:	5d                   	pop    %rbp
 126:	c3                   	retq   

0000000000000127 <strchr>:

char*
strchr(const char *s, char c)
{
 127:	55                   	push   %rbp
 128:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 12b:	8a 07                	mov    (%rdi),%al
 12d:	84 c0                	test   %al,%al
 12f:	74 0a                	je     13b <strchr+0x14>
    if(*s == c)
 131:	40 38 f0             	cmp    %sil,%al
 134:	74 09                	je     13f <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 136:	48 ff c7             	inc    %rdi
 139:	eb f0                	jmp    12b <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 13b:	31 c0                	xor    %eax,%eax
 13d:	eb 03                	jmp    142 <strchr+0x1b>
 13f:	48 89 f8             	mov    %rdi,%rax
}
 142:	5d                   	pop    %rbp
 143:	c3                   	retq   

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	55                   	push   %rbp
 145:	48 89 e5             	mov    %rsp,%rbp
 148:	41 57                	push   %r15
 14a:	41 56                	push   %r14
 14c:	41 55                	push   %r13
 14e:	41 54                	push   %r12
 150:	41 89 f7             	mov    %esi,%r15d
 153:	53                   	push   %rbx
 154:	49 89 fc             	mov    %rdi,%r12
 157:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 15c:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 164:	45 39 fd             	cmp    %r15d,%r13d
 167:	7d 2c                	jge    195 <gets+0x51>
    cc = read(0, &c, 1);
 169:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 16d:	31 ff                	xor    %edi,%edi
 16f:	ba 01 00 00 00       	mov    $0x1,%edx
 174:	e8 ca 00 00 00       	callq  243 <read>
    if(cc < 1)
 179:	85 c0                	test   %eax,%eax
 17b:	7e 18                	jle    195 <gets+0x51>
      break;
    buf[i++] = c;
 17d:	8a 45 cf             	mov    -0x31(%rbp),%al
 180:	49 ff c6             	inc    %r14
 183:	49 63 dd             	movslq %r13d,%rbx
 186:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 18a:	3c 0a                	cmp    $0xa,%al
 18c:	74 04                	je     192 <gets+0x4e>
 18e:	3c 0d                	cmp    $0xd,%al
 190:	75 ce                	jne    160 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 192:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 195:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 19a:	48 83 c4 18          	add    $0x18,%rsp
 19e:	4c 89 e0             	mov    %r12,%rax
 1a1:	5b                   	pop    %rbx
 1a2:	41 5c                	pop    %r12
 1a4:	41 5d                	pop    %r13
 1a6:	41 5e                	pop    %r14
 1a8:	41 5f                	pop    %r15
 1aa:	5d                   	pop    %rbp
 1ab:	c3                   	retq   

00000000000001ac <stat>:

int
stat(const char *n, struct stat *st)
{
 1ac:	55                   	push   %rbp
 1ad:	48 89 e5             	mov    %rsp,%rbp
 1b0:	41 54                	push   %r12
 1b2:	53                   	push   %rbx
 1b3:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	31 f6                	xor    %esi,%esi
 1b8:	e8 ae 00 00 00       	callq  26b <open>
 1bd:	41 89 c4             	mov    %eax,%r12d
 1c0:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 1c3:	45 85 e4             	test   %r12d,%r12d
 1c6:	78 17                	js     1df <stat+0x33>
    return -1;
  r = fstat(fd, st);
 1c8:	48 89 de             	mov    %rbx,%rsi
 1cb:	44 89 e7             	mov    %r12d,%edi
 1ce:	e8 b0 00 00 00       	callq  283 <fstat>
  close(fd);
 1d3:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1d6:	89 c3                	mov    %eax,%ebx
  close(fd);
 1d8:	e8 76 00 00 00       	callq  253 <close>
  return r;
 1dd:	89 d8                	mov    %ebx,%eax
}
 1df:	5b                   	pop    %rbx
 1e0:	41 5c                	pop    %r12
 1e2:	5d                   	pop    %rbp
 1e3:	c3                   	retq   

00000000000001e4 <atoi>:

int
atoi(const char *s)
{
 1e4:	55                   	push   %rbp
  int n;

  n = 0;
 1e5:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 1e7:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ea:	0f be 17             	movsbl (%rdi),%edx
 1ed:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 1f0:	80 f9 09             	cmp    $0x9,%cl
 1f3:	77 0c                	ja     201 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 1f5:	6b c0 0a             	imul   $0xa,%eax,%eax
 1f8:	48 ff c7             	inc    %rdi
 1fb:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 1ff:	eb e9                	jmp    1ea <atoi+0x6>
  return n;
}
 201:	5d                   	pop    %rbp
 202:	c3                   	retq   

0000000000000203 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 203:	55                   	push   %rbp
 204:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 207:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 209:	48 89 e5             	mov    %rsp,%rbp
 20c:	89 d7                	mov    %edx,%edi
 20e:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 210:	85 ff                	test   %edi,%edi
 212:	7e 0d                	jle    221 <memmove+0x1e>
    *dst++ = *src++;
 214:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 218:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 21c:	48 ff c1             	inc    %rcx
 21f:	eb eb                	jmp    20c <memmove+0x9>
  return vdst;
}
 221:	5d                   	pop    %rbp
 222:	c3                   	retq   

0000000000000223 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 223:	b8 01 00 00 00       	mov    $0x1,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	retq   

000000000000022b <exit>:
SYSCALL(exit)
 22b:	b8 02 00 00 00       	mov    $0x2,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	retq   

0000000000000233 <wait>:
SYSCALL(wait)
 233:	b8 03 00 00 00       	mov    $0x3,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	retq   

000000000000023b <pipe>:
SYSCALL(pipe)
 23b:	b8 04 00 00 00       	mov    $0x4,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	retq   

0000000000000243 <read>:
SYSCALL(read)
 243:	b8 05 00 00 00       	mov    $0x5,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	retq   

000000000000024b <write>:
SYSCALL(write)
 24b:	b8 10 00 00 00       	mov    $0x10,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	retq   

0000000000000253 <close>:
SYSCALL(close)
 253:	b8 15 00 00 00       	mov    $0x15,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	retq   

000000000000025b <kill>:
SYSCALL(kill)
 25b:	b8 06 00 00 00       	mov    $0x6,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	retq   

0000000000000263 <exec>:
SYSCALL(exec)
 263:	b8 07 00 00 00       	mov    $0x7,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	retq   

000000000000026b <open>:
SYSCALL(open)
 26b:	b8 0f 00 00 00       	mov    $0xf,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	retq   

0000000000000273 <mknod>:
SYSCALL(mknod)
 273:	b8 11 00 00 00       	mov    $0x11,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	retq   

000000000000027b <unlink>:
SYSCALL(unlink)
 27b:	b8 12 00 00 00       	mov    $0x12,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	retq   

0000000000000283 <fstat>:
SYSCALL(fstat)
 283:	b8 08 00 00 00       	mov    $0x8,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	retq   

000000000000028b <link>:
SYSCALL(link)
 28b:	b8 13 00 00 00       	mov    $0x13,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	retq   

0000000000000293 <mkdir>:
SYSCALL(mkdir)
 293:	b8 14 00 00 00       	mov    $0x14,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	retq   

000000000000029b <chdir>:
SYSCALL(chdir)
 29b:	b8 09 00 00 00       	mov    $0x9,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	retq   

00000000000002a3 <dup>:
SYSCALL(dup)
 2a3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	retq   

00000000000002ab <getpid>:
SYSCALL(getpid)
 2ab:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	retq   

00000000000002b3 <sbrk>:
SYSCALL(sbrk)
 2b3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	retq   

00000000000002bb <sleep>:
SYSCALL(sleep)
 2bb:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	retq   

00000000000002c3 <uptime>:
SYSCALL(uptime)
 2c3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	retq   

00000000000002cb <chmod>:
SYSCALL(chmod)
 2cb:	b8 16 00 00 00       	mov    $0x16,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	retq   

00000000000002d3 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d3:	55                   	push   %rbp
 2d4:	41 89 d0             	mov    %edx,%r8d
 2d7:	48 89 e5             	mov    %rsp,%rbp
 2da:	41 54                	push   %r12
 2dc:	53                   	push   %rbx
 2dd:	41 89 fc             	mov    %edi,%r12d
 2e0:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e4:	85 c9                	test   %ecx,%ecx
 2e6:	74 12                	je     2fa <printint+0x27>
 2e8:	89 f0                	mov    %esi,%eax
 2ea:	c1 e8 1f             	shr    $0x1f,%eax
 2ed:	74 0b                	je     2fa <printint+0x27>
    neg = 1;
    x = -xx;
 2ef:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 2f1:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 2f6:	f7 d8                	neg    %eax
 2f8:	eb 04                	jmp    2fe <printint+0x2b>
  } else {
    x = xx;
 2fa:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 2fc:	31 f6                	xor    %esi,%esi
 2fe:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 302:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 304:	31 d2                	xor    %edx,%edx
 306:	48 ff c7             	inc    %rdi
 309:	8d 59 01             	lea    0x1(%rcx),%ebx
 30c:	41 f7 f0             	div    %r8d
 30f:	89 d2                	mov    %edx,%edx
 311:	8a 92 e0 06 00 00    	mov    0x6e0(%rdx),%dl
 317:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 31a:	85 c0                	test   %eax,%eax
 31c:	74 04                	je     322 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 31e:	89 d9                	mov    %ebx,%ecx
 320:	eb e2                	jmp    304 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 322:	85 f6                	test   %esi,%esi
 324:	74 0b                	je     331 <printint+0x5e>
    buf[i++] = '-';
 326:	48 63 db             	movslq %ebx,%rbx
 329:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 32e:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 331:	ff cb                	dec    %ebx
 333:	83 fb ff             	cmp    $0xffffffff,%ebx
 336:	74 1d                	je     355 <printint+0x82>
    putc(fd, buf[i]);
 338:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 33b:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 33f:	ba 01 00 00 00       	mov    $0x1,%edx
 344:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 348:	44 89 e7             	mov    %r12d,%edi
 34b:	88 45 df             	mov    %al,-0x21(%rbp)
 34e:	e8 f8 fe ff ff       	callq  24b <write>
 353:	eb dc                	jmp    331 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 355:	48 83 c4 20          	add    $0x20,%rsp
 359:	5b                   	pop    %rbx
 35a:	41 5c                	pop    %r12
 35c:	5d                   	pop    %rbp
 35d:	c3                   	retq   

000000000000035e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 35e:	55                   	push   %rbp
 35f:	48 89 e5             	mov    %rsp,%rbp
 362:	41 56                	push   %r14
 364:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 366:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 36a:	41 54                	push   %r12
 36c:	53                   	push   %rbx
 36d:	41 89 fc             	mov    %edi,%r12d
 370:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 373:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 375:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 379:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 37d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 381:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 385:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 389:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 38d:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 391:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 398:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 39c:	45 8a 2e             	mov    (%r14),%r13b
 39f:	45 84 ed             	test   %r13b,%r13b
 3a2:	0f 84 8f 01 00 00    	je     537 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 3a8:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3aa:	41 0f be d5          	movsbl %r13b,%edx
 3ae:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 3b2:	75 23                	jne    3d7 <printf+0x79>
      if(c == '%'){
 3b4:	83 f8 25             	cmp    $0x25,%eax
 3b7:	0f 84 6d 01 00 00    	je     52a <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3bd:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 3c1:	ba 01 00 00 00       	mov    $0x1,%edx
 3c6:	44 89 e7             	mov    %r12d,%edi
 3c9:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 3cd:	e8 79 fe ff ff       	callq  24b <write>
 3d2:	e9 58 01 00 00       	jmpq   52f <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d7:	83 fb 25             	cmp    $0x25,%ebx
 3da:	0f 85 4f 01 00 00    	jne    52f <printf+0x1d1>
      if(c == 'd'){
 3e0:	83 f8 64             	cmp    $0x64,%eax
 3e3:	75 2e                	jne    413 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 3e5:	8b 55 98             	mov    -0x68(%rbp),%edx
 3e8:	83 fa 2f             	cmp    $0x2f,%edx
 3eb:	77 0e                	ja     3fb <printf+0x9d>
 3ed:	89 d0                	mov    %edx,%eax
 3ef:	83 c2 08             	add    $0x8,%edx
 3f2:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3f6:	89 55 98             	mov    %edx,-0x68(%rbp)
 3f9:	eb 0c                	jmp    407 <printf+0xa9>
 3fb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3ff:	48 8d 50 08          	lea    0x8(%rax),%rdx
 403:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 407:	b9 01 00 00 00       	mov    $0x1,%ecx
 40c:	ba 0a 00 00 00       	mov    $0xa,%edx
 411:	eb 34                	jmp    447 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 413:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 419:	83 fa 70             	cmp    $0x70,%edx
 41c:	75 38                	jne    456 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 41e:	8b 55 98             	mov    -0x68(%rbp),%edx
 421:	83 fa 2f             	cmp    $0x2f,%edx
 424:	77 0e                	ja     434 <printf+0xd6>
 426:	89 d0                	mov    %edx,%eax
 428:	83 c2 08             	add    $0x8,%edx
 42b:	48 03 45 a8          	add    -0x58(%rbp),%rax
 42f:	89 55 98             	mov    %edx,-0x68(%rbp)
 432:	eb 0c                	jmp    440 <printf+0xe2>
 434:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 438:	48 8d 50 08          	lea    0x8(%rax),%rdx
 43c:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 440:	31 c9                	xor    %ecx,%ecx
 442:	ba 10 00 00 00       	mov    $0x10,%edx
 447:	8b 30                	mov    (%rax),%esi
 449:	44 89 e7             	mov    %r12d,%edi
 44c:	e8 82 fe ff ff       	callq  2d3 <printint>
 451:	e9 d0 00 00 00       	jmpq   526 <printf+0x1c8>
      } else if(c == 's'){
 456:	83 f8 73             	cmp    $0x73,%eax
 459:	75 56                	jne    4b1 <printf+0x153>
        s = va_arg(ap, char*);
 45b:	8b 55 98             	mov    -0x68(%rbp),%edx
 45e:	83 fa 2f             	cmp    $0x2f,%edx
 461:	77 0e                	ja     471 <printf+0x113>
 463:	89 d0                	mov    %edx,%eax
 465:	83 c2 08             	add    $0x8,%edx
 468:	48 03 45 a8          	add    -0x58(%rbp),%rax
 46c:	89 55 98             	mov    %edx,-0x68(%rbp)
 46f:	eb 0c                	jmp    47d <printf+0x11f>
 471:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 475:	48 8d 50 08          	lea    0x8(%rax),%rdx
 479:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 47d:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 480:	48 c7 c0 d4 06 00 00 	mov    $0x6d4,%rax
 487:	48 85 db             	test   %rbx,%rbx
 48a:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 48e:	8a 03                	mov    (%rbx),%al
 490:	84 c0                	test   %al,%al
 492:	0f 84 8e 00 00 00    	je     526 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 498:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 49c:	ba 01 00 00 00       	mov    $0x1,%edx
 4a1:	44 89 e7             	mov    %r12d,%edi
 4a4:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4a7:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4aa:	e8 9c fd ff ff       	callq  24b <write>
 4af:	eb dd                	jmp    48e <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b1:	83 f8 63             	cmp    $0x63,%eax
 4b4:	75 32                	jne    4e8 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 4b6:	8b 55 98             	mov    -0x68(%rbp),%edx
 4b9:	83 fa 2f             	cmp    $0x2f,%edx
 4bc:	77 0e                	ja     4cc <printf+0x16e>
 4be:	89 d0                	mov    %edx,%eax
 4c0:	83 c2 08             	add    $0x8,%edx
 4c3:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4c7:	89 55 98             	mov    %edx,-0x68(%rbp)
 4ca:	eb 0c                	jmp    4d8 <printf+0x17a>
 4cc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4d0:	48 8d 50 08          	lea    0x8(%rax),%rdx
 4d4:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4d8:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4da:	ba 01 00 00 00       	mov    $0x1,%edx
 4df:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 4e3:	88 45 94             	mov    %al,-0x6c(%rbp)
 4e6:	eb 36                	jmp    51e <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	75 0f                	jne    4fc <printf+0x19e>
 4ed:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f1:	ba 01 00 00 00       	mov    $0x1,%edx
 4f6:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 4fa:	eb 22                	jmp    51e <printf+0x1c0>
 4fc:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 500:	ba 01 00 00 00       	mov    $0x1,%edx
 505:	44 89 e7             	mov    %r12d,%edi
 508:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 50c:	e8 3a fd ff ff       	callq  24b <write>
 511:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 515:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 519:	ba 01 00 00 00       	mov    $0x1,%edx
 51e:	44 89 e7             	mov    %r12d,%edi
 521:	e8 25 fd ff ff       	callq  24b <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 526:	31 db                	xor    %ebx,%ebx
 528:	eb 05                	jmp    52f <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 52a:	bb 25 00 00 00       	mov    $0x25,%ebx
 52f:	49 ff c6             	inc    %r14
 532:	e9 65 fe ff ff       	jmpq   39c <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 537:	48 83 c4 50          	add    $0x50,%rsp
 53b:	5b                   	pop    %rbx
 53c:	41 5c                	pop    %r12
 53e:	41 5d                	pop    %r13
 540:	41 5e                	pop    %r14
 542:	5d                   	pop    %rbp
 543:	c3                   	retq   

0000000000000544 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 544:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 545:	48 8b 05 e4 03 00 00 	mov    0x3e4(%rip),%rax        # 930 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54c:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 550:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 553:	48 39 d0             	cmp    %rdx,%rax
 556:	48 8b 08             	mov    (%rax),%rcx
 559:	72 14                	jb     56f <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55b:	48 39 c8             	cmp    %rcx,%rax
 55e:	72 0a                	jb     56a <free+0x26>
 560:	48 39 ca             	cmp    %rcx,%rdx
 563:	72 0f                	jb     574 <free+0x30>
 565:	48 39 d0             	cmp    %rdx,%rax
 568:	72 0a                	jb     574 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 56a:	48 89 c8             	mov    %rcx,%rax
 56d:	eb e4                	jmp    553 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56f:	48 39 ca             	cmp    %rcx,%rdx
 572:	73 e7                	jae    55b <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 574:	8b 77 f8             	mov    -0x8(%rdi),%esi
 577:	49 89 f0             	mov    %rsi,%r8
 57a:	48 c1 e6 04          	shl    $0x4,%rsi
 57e:	48 01 d6             	add    %rdx,%rsi
 581:	48 39 ce             	cmp    %rcx,%rsi
 584:	75 0e                	jne    594 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 586:	44 03 41 08          	add    0x8(%rcx),%r8d
 58a:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 58e:	48 8b 08             	mov    (%rax),%rcx
 591:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 594:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 598:	8b 48 08             	mov    0x8(%rax),%ecx
 59b:	48 89 ce             	mov    %rcx,%rsi
 59e:	48 c1 e1 04          	shl    $0x4,%rcx
 5a2:	48 01 c1             	add    %rax,%rcx
 5a5:	48 39 ca             	cmp    %rcx,%rdx
 5a8:	75 0a                	jne    5b4 <free+0x70>
    p->s.size += bp->s.size;
 5aa:	03 77 f8             	add    -0x8(%rdi),%esi
 5ad:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 5b0:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 5b4:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 5b7:	48 89 05 72 03 00 00 	mov    %rax,0x372(%rip)        # 930 <freep>
}
 5be:	5d                   	pop    %rbp
 5bf:	c3                   	retq   

00000000000005c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5c0:	55                   	push   %rbp
 5c1:	48 89 e5             	mov    %rsp,%rbp
 5c4:	41 55                	push   %r13
 5c6:	41 54                	push   %r12
 5c8:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c9:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 5cb:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 5cc:	48 8b 0d 5d 03 00 00 	mov    0x35d(%rip),%rcx        # 930 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d3:	48 83 c3 0f          	add    $0xf,%rbx
 5d7:	48 c1 eb 04          	shr    $0x4,%rbx
 5db:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 5dd:	48 85 c9             	test   %rcx,%rcx
 5e0:	75 27                	jne    609 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 5e2:	48 c7 05 43 03 00 00 	movq   $0x940,0x343(%rip)        # 930 <freep>
 5e9:	40 09 00 00 
 5ed:	48 c7 05 48 03 00 00 	movq   $0x940,0x348(%rip)        # 940 <base>
 5f4:	40 09 00 00 
 5f8:	48 c7 c1 40 09 00 00 	mov    $0x940,%rcx
    base.s.size = 0;
 5ff:	c7 05 3f 03 00 00 00 	movl   $0x0,0x33f(%rip)        # 948 <base+0x8>
 606:	00 00 00 
 609:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 60f:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 615:	48 8b 01             	mov    (%rcx),%rax
 618:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 61c:	45 89 e5             	mov    %r12d,%r13d
 61f:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 623:	8b 50 08             	mov    0x8(%rax),%edx
 626:	39 d3                	cmp    %edx,%ebx
 628:	77 26                	ja     650 <malloc+0x90>
      if(p->s.size == nunits)
 62a:	75 08                	jne    634 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 62c:	48 8b 10             	mov    (%rax),%rdx
 62f:	48 89 11             	mov    %rdx,(%rcx)
 632:	eb 0f                	jmp    643 <malloc+0x83>
      else {
        p->s.size -= nunits;
 634:	29 da                	sub    %ebx,%edx
 636:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 639:	48 c1 e2 04          	shl    $0x4,%rdx
 63d:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 640:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 643:	48 89 0d e6 02 00 00 	mov    %rcx,0x2e6(%rip)        # 930 <freep>
      return (void*)(p + 1);
 64a:	48 83 c0 10          	add    $0x10,%rax
 64e:	eb 3a                	jmp    68a <malloc+0xca>
    }
    if(p == freep)
 650:	48 3b 05 d9 02 00 00 	cmp    0x2d9(%rip),%rax        # 930 <freep>
 657:	75 27                	jne    680 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 659:	44 89 ef             	mov    %r13d,%edi
 65c:	e8 52 fc ff ff       	callq  2b3 <sbrk>
  if(p == (char*)-1)
 661:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 665:	74 21                	je     688 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 667:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 66b:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 66f:	e8 d0 fe ff ff       	callq  544 <free>
  return freep;
 674:	48 8b 05 b5 02 00 00 	mov    0x2b5(%rip),%rax        # 930 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 67b:	48 85 c0             	test   %rax,%rax
 67e:	74 08                	je     688 <malloc+0xc8>
        return 0;
  }
 680:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 686:	eb 9b                	jmp    623 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 688:	31 c0                	xor    %eax,%eax
  }
}
 68a:	5a                   	pop    %rdx
 68b:	5b                   	pop    %rbx
 68c:	41 5c                	pop    %r12
 68e:	41 5d                	pop    %r13
 690:	5d                   	pop    %rbp
 691:	c3                   	retq   
