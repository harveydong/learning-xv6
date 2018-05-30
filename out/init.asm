
.fs/init:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %rbp
  int pid, wpid;


  if(open("console", O_RDWR) < 0){
   1:	be 02 00 00 00       	mov    $0x2,%esi
   6:	48 c7 c7 b0 06 00 00 	mov    $0x6b0,%rdi

char *argv[] = { "sh", 0 };

int
main(void)
{
   d:	48 89 e5             	mov    %rsp,%rbp
  10:	53                   	push   %rbx
  11:	50                   	push   %rax
  int pid, wpid;


  if(open("console", O_RDWR) < 0){
  12:	e8 6d 02 00 00       	callq  284 <open>
  17:	85 c0                	test   %eax,%eax
  19:	79 27                	jns    42 <main+0x42>
    mknod("console", 1, 1);
  1b:	be 01 00 00 00       	mov    $0x1,%esi
  20:	48 c7 c7 b0 06 00 00 	mov    $0x6b0,%rdi
  27:	ba 01 00 00 00       	mov    $0x1,%edx
  2c:	e8 5b 02 00 00       	callq  28c <mknod>
    open("console", O_RDWR);
  31:	be 02 00 00 00       	mov    $0x2,%esi
  36:	48 c7 c7 b0 06 00 00 	mov    $0x6b0,%rdi
  3d:	e8 42 02 00 00       	callq  284 <open>
  }
  dup(0);  // stdout
  42:	31 ff                	xor    %edi,%edi
  44:	e8 73 02 00 00       	callq  2bc <dup>
  dup(0);  // stderr
  49:	31 ff                	xor    %edi,%edi
  4b:	e8 6c 02 00 00       	callq  2bc <dup>

  mknod("cpuid", CPUID, 1);
  50:	ba 01 00 00 00       	mov    $0x1,%edx
  55:	be 02 00 00 00       	mov    $0x2,%esi
  5a:	48 c7 c7 b8 06 00 00 	mov    $0x6b8,%rdi
  61:	e8 26 02 00 00       	callq  28c <mknod>

  for(;;){
    printf(1, "init: starting sh\n");
  66:	31 c0                	xor    %eax,%eax
  68:	48 c7 c6 be 06 00 00 	mov    $0x6be,%rsi
  6f:	bf 01 00 00 00       	mov    $0x1,%edi
  74:	e8 fe 02 00 00       	callq  377 <printf>
    pid = fork();
  79:	e8 be 01 00 00       	callq  23c <fork>
    if(pid < 0){
  7e:	85 c0                	test   %eax,%eax

  mknod("cpuid", CPUID, 1);

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  80:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  82:	79 09                	jns    8d <main+0x8d>
      printf(1, "init: fork failed\n");
  84:	48 c7 c6 d1 06 00 00 	mov    $0x6d1,%rsi
  8b:	eb 1c                	jmp    a9 <main+0xa9>
      exit();
    }
    if(pid == 0){
  8d:	75 42                	jne    d1 <main+0xd1>
      exec("sh", argv);
  8f:	48 c7 c6 50 09 00 00 	mov    $0x950,%rsi
  96:	48 c7 c7 e4 06 00 00 	mov    $0x6e4,%rdi
  9d:	e8 da 01 00 00       	callq  27c <exec>
      printf(1, "init: exec sh failed\n");
  a2:	48 c7 c6 e7 06 00 00 	mov    $0x6e7,%rsi
  a9:	bf 01 00 00 00       	mov    $0x1,%edi
  ae:	31 c0                	xor    %eax,%eax
  b0:	e8 c2 02 00 00       	callq  377 <printf>
      exit();
  b5:	e8 8a 01 00 00       	callq  244 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  ba:	39 c3                	cmp    %eax,%ebx
  bc:	74 a8                	je     66 <main+0x66>
      printf(1, "zombie!\n");
  be:	48 c7 c6 fd 06 00 00 	mov    $0x6fd,%rsi
  c5:	bf 01 00 00 00       	mov    $0x1,%edi
  ca:	31 c0                	xor    %eax,%eax
  cc:	e8 a6 02 00 00       	callq  377 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  d1:	e8 76 01 00 00       	callq  24c <wait>
  d6:	89 c1                	mov    %eax,%ecx
  d8:	83 e9 00             	sub    $0x0,%ecx
  db:	79 dd                	jns    ba <main+0xba>
  dd:	eb 87                	jmp    66 <main+0x66>

00000000000000df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  df:	55                   	push   %rbp
  e0:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e3:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e5:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  eb:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  ee:	48 ff c2             	inc    %rdx
  f1:	84 c9                	test   %cl,%cl
  f3:	75 f3                	jne    e8 <strcpy+0x9>
    ;
  return os;
}
  f5:	5d                   	pop    %rbp
  f6:	c3                   	retq   

00000000000000f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f7:	55                   	push   %rbp
  f8:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  fb:	0f b6 07             	movzbl (%rdi),%eax
  fe:	84 c0                	test   %al,%al
 100:	74 0c                	je     10e <strcmp+0x17>
 102:	3a 06                	cmp    (%rsi),%al
 104:	75 08                	jne    10e <strcmp+0x17>
    p++, q++;
 106:	48 ff c7             	inc    %rdi
 109:	48 ff c6             	inc    %rsi
 10c:	eb ed                	jmp    fb <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 10e:	0f b6 16             	movzbl (%rsi),%edx
}
 111:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 112:	29 d0                	sub    %edx,%eax
}
 114:	c3                   	retq   

0000000000000115 <strlen>:

uint
strlen(const char *s)
{
 115:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 116:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 118:	48 89 e5             	mov    %rsp,%rbp
 11b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 11f:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 124:	74 05                	je     12b <strlen+0x16>
 126:	48 89 d0             	mov    %rdx,%rax
 129:	eb f0                	jmp    11b <strlen+0x6>
    ;
  return n;
}
 12b:	5d                   	pop    %rbp
 12c:	c3                   	retq   

000000000000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %rbp
 12e:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 131:	89 d1                	mov    %edx,%ecx
 133:	89 f0                	mov    %esi,%eax
 135:	48 89 e5             	mov    %rsp,%rbp
 138:	fc                   	cld    
 139:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 13b:	4c 89 c0             	mov    %r8,%rax
 13e:	5d                   	pop    %rbp
 13f:	c3                   	retq   

0000000000000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %rbp
 141:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 144:	8a 07                	mov    (%rdi),%al
 146:	84 c0                	test   %al,%al
 148:	74 0a                	je     154 <strchr+0x14>
    if(*s == c)
 14a:	40 38 f0             	cmp    %sil,%al
 14d:	74 09                	je     158 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 14f:	48 ff c7             	inc    %rdi
 152:	eb f0                	jmp    144 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 154:	31 c0                	xor    %eax,%eax
 156:	eb 03                	jmp    15b <strchr+0x1b>
 158:	48 89 f8             	mov    %rdi,%rax
}
 15b:	5d                   	pop    %rbp
 15c:	c3                   	retq   

000000000000015d <gets>:

char*
gets(char *buf, int max)
{
 15d:	55                   	push   %rbp
 15e:	48 89 e5             	mov    %rsp,%rbp
 161:	41 57                	push   %r15
 163:	41 56                	push   %r14
 165:	41 55                	push   %r13
 167:	41 54                	push   %r12
 169:	41 89 f7             	mov    %esi,%r15d
 16c:	53                   	push   %rbx
 16d:	49 89 fc             	mov    %rdi,%r12
 170:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 173:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 175:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 179:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 17d:	45 39 fd             	cmp    %r15d,%r13d
 180:	7d 2c                	jge    1ae <gets+0x51>
    cc = read(0, &c, 1);
 182:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 186:	31 ff                	xor    %edi,%edi
 188:	ba 01 00 00 00       	mov    $0x1,%edx
 18d:	e8 ca 00 00 00       	callq  25c <read>
    if(cc < 1)
 192:	85 c0                	test   %eax,%eax
 194:	7e 18                	jle    1ae <gets+0x51>
      break;
    buf[i++] = c;
 196:	8a 45 cf             	mov    -0x31(%rbp),%al
 199:	49 ff c6             	inc    %r14
 19c:	49 63 dd             	movslq %r13d,%rbx
 19f:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 1a3:	3c 0a                	cmp    $0xa,%al
 1a5:	74 04                	je     1ab <gets+0x4e>
 1a7:	3c 0d                	cmp    $0xd,%al
 1a9:	75 ce                	jne    179 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ab:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ae:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 1b3:	48 83 c4 18          	add    $0x18,%rsp
 1b7:	4c 89 e0             	mov    %r12,%rax
 1ba:	5b                   	pop    %rbx
 1bb:	41 5c                	pop    %r12
 1bd:	41 5d                	pop    %r13
 1bf:	41 5e                	pop    %r14
 1c1:	41 5f                	pop    %r15
 1c3:	5d                   	pop    %rbp
 1c4:	c3                   	retq   

00000000000001c5 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c5:	55                   	push   %rbp
 1c6:	48 89 e5             	mov    %rsp,%rbp
 1c9:	41 54                	push   %r12
 1cb:	53                   	push   %rbx
 1cc:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cf:	31 f6                	xor    %esi,%esi
 1d1:	e8 ae 00 00 00       	callq  284 <open>
 1d6:	41 89 c4             	mov    %eax,%r12d
 1d9:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 1dc:	45 85 e4             	test   %r12d,%r12d
 1df:	78 17                	js     1f8 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 1e1:	48 89 de             	mov    %rbx,%rsi
 1e4:	44 89 e7             	mov    %r12d,%edi
 1e7:	e8 b0 00 00 00       	callq  29c <fstat>
  close(fd);
 1ec:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1ef:	89 c3                	mov    %eax,%ebx
  close(fd);
 1f1:	e8 76 00 00 00       	callq  26c <close>
  return r;
 1f6:	89 d8                	mov    %ebx,%eax
}
 1f8:	5b                   	pop    %rbx
 1f9:	41 5c                	pop    %r12
 1fb:	5d                   	pop    %rbp
 1fc:	c3                   	retq   

00000000000001fd <atoi>:

int
atoi(const char *s)
{
 1fd:	55                   	push   %rbp
  int n;

  n = 0;
 1fe:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 200:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 203:	0f be 17             	movsbl (%rdi),%edx
 206:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 209:	80 f9 09             	cmp    $0x9,%cl
 20c:	77 0c                	ja     21a <atoi+0x1d>
    n = n*10 + *s++ - '0';
 20e:	6b c0 0a             	imul   $0xa,%eax,%eax
 211:	48 ff c7             	inc    %rdi
 214:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 218:	eb e9                	jmp    203 <atoi+0x6>
  return n;
}
 21a:	5d                   	pop    %rbp
 21b:	c3                   	retq   

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	55                   	push   %rbp
 21d:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 220:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	48 89 e5             	mov    %rsp,%rbp
 225:	89 d7                	mov    %edx,%edi
 227:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 229:	85 ff                	test   %edi,%edi
 22b:	7e 0d                	jle    23a <memmove+0x1e>
    *dst++ = *src++;
 22d:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 231:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 235:	48 ff c1             	inc    %rcx
 238:	eb eb                	jmp    225 <memmove+0x9>
  return vdst;
}
 23a:	5d                   	pop    %rbp
 23b:	c3                   	retq   

000000000000023c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23c:	b8 01 00 00 00       	mov    $0x1,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	retq   

0000000000000244 <exit>:
SYSCALL(exit)
 244:	b8 02 00 00 00       	mov    $0x2,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	retq   

000000000000024c <wait>:
SYSCALL(wait)
 24c:	b8 03 00 00 00       	mov    $0x3,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	retq   

0000000000000254 <pipe>:
SYSCALL(pipe)
 254:	b8 04 00 00 00       	mov    $0x4,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	retq   

000000000000025c <read>:
SYSCALL(read)
 25c:	b8 05 00 00 00       	mov    $0x5,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	retq   

0000000000000264 <write>:
SYSCALL(write)
 264:	b8 10 00 00 00       	mov    $0x10,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	retq   

000000000000026c <close>:
SYSCALL(close)
 26c:	b8 15 00 00 00       	mov    $0x15,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	retq   

0000000000000274 <kill>:
SYSCALL(kill)
 274:	b8 06 00 00 00       	mov    $0x6,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	retq   

000000000000027c <exec>:
SYSCALL(exec)
 27c:	b8 07 00 00 00       	mov    $0x7,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	retq   

0000000000000284 <open>:
SYSCALL(open)
 284:	b8 0f 00 00 00       	mov    $0xf,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	retq   

000000000000028c <mknod>:
SYSCALL(mknod)
 28c:	b8 11 00 00 00       	mov    $0x11,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	retq   

0000000000000294 <unlink>:
SYSCALL(unlink)
 294:	b8 12 00 00 00       	mov    $0x12,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	retq   

000000000000029c <fstat>:
SYSCALL(fstat)
 29c:	b8 08 00 00 00       	mov    $0x8,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	retq   

00000000000002a4 <link>:
SYSCALL(link)
 2a4:	b8 13 00 00 00       	mov    $0x13,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	retq   

00000000000002ac <mkdir>:
SYSCALL(mkdir)
 2ac:	b8 14 00 00 00       	mov    $0x14,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	retq   

00000000000002b4 <chdir>:
SYSCALL(chdir)
 2b4:	b8 09 00 00 00       	mov    $0x9,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	retq   

00000000000002bc <dup>:
SYSCALL(dup)
 2bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	retq   

00000000000002c4 <getpid>:
SYSCALL(getpid)
 2c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	retq   

00000000000002cc <sbrk>:
SYSCALL(sbrk)
 2cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	retq   

00000000000002d4 <sleep>:
SYSCALL(sleep)
 2d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	retq   

00000000000002dc <uptime>:
SYSCALL(uptime)
 2dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	retq   

00000000000002e4 <chmod>:
SYSCALL(chmod)
 2e4:	b8 16 00 00 00       	mov    $0x16,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	retq   

00000000000002ec <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2ec:	55                   	push   %rbp
 2ed:	41 89 d0             	mov    %edx,%r8d
 2f0:	48 89 e5             	mov    %rsp,%rbp
 2f3:	41 54                	push   %r12
 2f5:	53                   	push   %rbx
 2f6:	41 89 fc             	mov    %edi,%r12d
 2f9:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fd:	85 c9                	test   %ecx,%ecx
 2ff:	74 12                	je     313 <printint+0x27>
 301:	89 f0                	mov    %esi,%eax
 303:	c1 e8 1f             	shr    $0x1f,%eax
 306:	74 0b                	je     313 <printint+0x27>
    neg = 1;
    x = -xx;
 308:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 30a:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 30f:	f7 d8                	neg    %eax
 311:	eb 04                	jmp    317 <printint+0x2b>
  } else {
    x = xx;
 313:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 315:	31 f6                	xor    %esi,%esi
 317:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 31b:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 31d:	31 d2                	xor    %edx,%edx
 31f:	48 ff c7             	inc    %rdi
 322:	8d 59 01             	lea    0x1(%rcx),%ebx
 325:	41 f7 f0             	div    %r8d
 328:	89 d2                	mov    %edx,%edx
 32a:	8a 92 10 07 00 00    	mov    0x710(%rdx),%dl
 330:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 333:	85 c0                	test   %eax,%eax
 335:	74 04                	je     33b <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 337:	89 d9                	mov    %ebx,%ecx
 339:	eb e2                	jmp    31d <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 33b:	85 f6                	test   %esi,%esi
 33d:	74 0b                	je     34a <printint+0x5e>
    buf[i++] = '-';
 33f:	48 63 db             	movslq %ebx,%rbx
 342:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 347:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 34a:	ff cb                	dec    %ebx
 34c:	83 fb ff             	cmp    $0xffffffff,%ebx
 34f:	74 1d                	je     36e <printint+0x82>
    putc(fd, buf[i]);
 351:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 354:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 358:	ba 01 00 00 00       	mov    $0x1,%edx
 35d:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 361:	44 89 e7             	mov    %r12d,%edi
 364:	88 45 df             	mov    %al,-0x21(%rbp)
 367:	e8 f8 fe ff ff       	callq  264 <write>
 36c:	eb dc                	jmp    34a <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 36e:	48 83 c4 20          	add    $0x20,%rsp
 372:	5b                   	pop    %rbx
 373:	41 5c                	pop    %r12
 375:	5d                   	pop    %rbp
 376:	c3                   	retq   

0000000000000377 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 377:	55                   	push   %rbp
 378:	48 89 e5             	mov    %rsp,%rbp
 37b:	41 56                	push   %r14
 37d:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 37f:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 383:	41 54                	push   %r12
 385:	53                   	push   %rbx
 386:	41 89 fc             	mov    %edi,%r12d
 389:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 38c:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 38e:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 392:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 396:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 39a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 39e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 3a2:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 3a6:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 3aa:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 3b1:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 3b5:	45 8a 2e             	mov    (%r14),%r13b
 3b8:	45 84 ed             	test   %r13b,%r13b
 3bb:	0f 84 8f 01 00 00    	je     550 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 3c1:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3c3:	41 0f be d5          	movsbl %r13b,%edx
 3c7:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 3cb:	75 23                	jne    3f0 <printf+0x79>
      if(c == '%'){
 3cd:	83 f8 25             	cmp    $0x25,%eax
 3d0:	0f 84 6d 01 00 00    	je     543 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d6:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 3da:	ba 01 00 00 00       	mov    $0x1,%edx
 3df:	44 89 e7             	mov    %r12d,%edi
 3e2:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 3e6:	e8 79 fe ff ff       	callq  264 <write>
 3eb:	e9 58 01 00 00       	jmpq   548 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3f0:	83 fb 25             	cmp    $0x25,%ebx
 3f3:	0f 85 4f 01 00 00    	jne    548 <printf+0x1d1>
      if(c == 'd'){
 3f9:	83 f8 64             	cmp    $0x64,%eax
 3fc:	75 2e                	jne    42c <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 3fe:	8b 55 98             	mov    -0x68(%rbp),%edx
 401:	83 fa 2f             	cmp    $0x2f,%edx
 404:	77 0e                	ja     414 <printf+0x9d>
 406:	89 d0                	mov    %edx,%eax
 408:	83 c2 08             	add    $0x8,%edx
 40b:	48 03 45 a8          	add    -0x58(%rbp),%rax
 40f:	89 55 98             	mov    %edx,-0x68(%rbp)
 412:	eb 0c                	jmp    420 <printf+0xa9>
 414:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 418:	48 8d 50 08          	lea    0x8(%rax),%rdx
 41c:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 420:	b9 01 00 00 00       	mov    $0x1,%ecx
 425:	ba 0a 00 00 00       	mov    $0xa,%edx
 42a:	eb 34                	jmp    460 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 42c:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 432:	83 fa 70             	cmp    $0x70,%edx
 435:	75 38                	jne    46f <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 437:	8b 55 98             	mov    -0x68(%rbp),%edx
 43a:	83 fa 2f             	cmp    $0x2f,%edx
 43d:	77 0e                	ja     44d <printf+0xd6>
 43f:	89 d0                	mov    %edx,%eax
 441:	83 c2 08             	add    $0x8,%edx
 444:	48 03 45 a8          	add    -0x58(%rbp),%rax
 448:	89 55 98             	mov    %edx,-0x68(%rbp)
 44b:	eb 0c                	jmp    459 <printf+0xe2>
 44d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 451:	48 8d 50 08          	lea    0x8(%rax),%rdx
 455:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 459:	31 c9                	xor    %ecx,%ecx
 45b:	ba 10 00 00 00       	mov    $0x10,%edx
 460:	8b 30                	mov    (%rax),%esi
 462:	44 89 e7             	mov    %r12d,%edi
 465:	e8 82 fe ff ff       	callq  2ec <printint>
 46a:	e9 d0 00 00 00       	jmpq   53f <printf+0x1c8>
      } else if(c == 's'){
 46f:	83 f8 73             	cmp    $0x73,%eax
 472:	75 56                	jne    4ca <printf+0x153>
        s = va_arg(ap, char*);
 474:	8b 55 98             	mov    -0x68(%rbp),%edx
 477:	83 fa 2f             	cmp    $0x2f,%edx
 47a:	77 0e                	ja     48a <printf+0x113>
 47c:	89 d0                	mov    %edx,%eax
 47e:	83 c2 08             	add    $0x8,%edx
 481:	48 03 45 a8          	add    -0x58(%rbp),%rax
 485:	89 55 98             	mov    %edx,-0x68(%rbp)
 488:	eb 0c                	jmp    496 <printf+0x11f>
 48a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 48e:	48 8d 50 08          	lea    0x8(%rax),%rdx
 492:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 496:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 499:	48 c7 c0 06 07 00 00 	mov    $0x706,%rax
 4a0:	48 85 db             	test   %rbx,%rbx
 4a3:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 4a7:	8a 03                	mov    (%rbx),%al
 4a9:	84 c0                	test   %al,%al
 4ab:	0f 84 8e 00 00 00    	je     53f <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b1:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 4b5:	ba 01 00 00 00       	mov    $0x1,%edx
 4ba:	44 89 e7             	mov    %r12d,%edi
 4bd:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4c0:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c3:	e8 9c fd ff ff       	callq  264 <write>
 4c8:	eb dd                	jmp    4a7 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ca:	83 f8 63             	cmp    $0x63,%eax
 4cd:	75 32                	jne    501 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 4cf:	8b 55 98             	mov    -0x68(%rbp),%edx
 4d2:	83 fa 2f             	cmp    $0x2f,%edx
 4d5:	77 0e                	ja     4e5 <printf+0x16e>
 4d7:	89 d0                	mov    %edx,%eax
 4d9:	83 c2 08             	add    $0x8,%edx
 4dc:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4e0:	89 55 98             	mov    %edx,-0x68(%rbp)
 4e3:	eb 0c                	jmp    4f1 <printf+0x17a>
 4e5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4e9:	48 8d 50 08          	lea    0x8(%rax),%rdx
 4ed:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4f1:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f3:	ba 01 00 00 00       	mov    $0x1,%edx
 4f8:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 4fc:	88 45 94             	mov    %al,-0x6c(%rbp)
 4ff:	eb 36                	jmp    537 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 501:	83 f8 25             	cmp    $0x25,%eax
 504:	75 0f                	jne    515 <printf+0x19e>
 506:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 50a:	ba 01 00 00 00       	mov    $0x1,%edx
 50f:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 513:	eb 22                	jmp    537 <printf+0x1c0>
 515:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 519:	ba 01 00 00 00       	mov    $0x1,%edx
 51e:	44 89 e7             	mov    %r12d,%edi
 521:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 525:	e8 3a fd ff ff       	callq  264 <write>
 52a:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 52e:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 532:	ba 01 00 00 00       	mov    $0x1,%edx
 537:	44 89 e7             	mov    %r12d,%edi
 53a:	e8 25 fd ff ff       	callq  264 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53f:	31 db                	xor    %ebx,%ebx
 541:	eb 05                	jmp    548 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 543:	bb 25 00 00 00       	mov    $0x25,%ebx
 548:	49 ff c6             	inc    %r14
 54b:	e9 65 fe ff ff       	jmpq   3b5 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 550:	48 83 c4 50          	add    $0x50,%rsp
 554:	5b                   	pop    %rbx
 555:	41 5c                	pop    %r12
 557:	41 5d                	pop    %r13
 559:	41 5e                	pop    %r14
 55b:	5d                   	pop    %rbp
 55c:	c3                   	retq   

000000000000055d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 55d:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55e:	48 8b 05 fb 03 00 00 	mov    0x3fb(%rip),%rax        # 960 <_edata>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 565:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 569:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56c:	48 39 d0             	cmp    %rdx,%rax
 56f:	48 8b 08             	mov    (%rax),%rcx
 572:	72 14                	jb     588 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 574:	48 39 c8             	cmp    %rcx,%rax
 577:	72 0a                	jb     583 <free+0x26>
 579:	48 39 ca             	cmp    %rcx,%rdx
 57c:	72 0f                	jb     58d <free+0x30>
 57e:	48 39 d0             	cmp    %rdx,%rax
 581:	72 0a                	jb     58d <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 583:	48 89 c8             	mov    %rcx,%rax
 586:	eb e4                	jmp    56c <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 588:	48 39 ca             	cmp    %rcx,%rdx
 58b:	73 e7                	jae    574 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 58d:	8b 77 f8             	mov    -0x8(%rdi),%esi
 590:	49 89 f0             	mov    %rsi,%r8
 593:	48 c1 e6 04          	shl    $0x4,%rsi
 597:	48 01 d6             	add    %rdx,%rsi
 59a:	48 39 ce             	cmp    %rcx,%rsi
 59d:	75 0e                	jne    5ad <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 59f:	44 03 41 08          	add    0x8(%rcx),%r8d
 5a3:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a7:	48 8b 08             	mov    (%rax),%rcx
 5aa:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 5ad:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 5b1:	8b 48 08             	mov    0x8(%rax),%ecx
 5b4:	48 89 ce             	mov    %rcx,%rsi
 5b7:	48 c1 e1 04          	shl    $0x4,%rcx
 5bb:	48 01 c1             	add    %rax,%rcx
 5be:	48 39 ca             	cmp    %rcx,%rdx
 5c1:	75 0a                	jne    5cd <free+0x70>
    p->s.size += bp->s.size;
 5c3:	03 77 f8             	add    -0x8(%rdi),%esi
 5c6:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 5c9:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 5cd:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 5d0:	48 89 05 89 03 00 00 	mov    %rax,0x389(%rip)        # 960 <_edata>
}
 5d7:	5d                   	pop    %rbp
 5d8:	c3                   	retq   

00000000000005d9 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d9:	55                   	push   %rbp
 5da:	48 89 e5             	mov    %rsp,%rbp
 5dd:	41 55                	push   %r13
 5df:	41 54                	push   %r12
 5e1:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e2:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 5e4:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 5e5:	48 8b 0d 74 03 00 00 	mov    0x374(%rip),%rcx        # 960 <_edata>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5ec:	48 83 c3 0f          	add    $0xf,%rbx
 5f0:	48 c1 eb 04          	shr    $0x4,%rbx
 5f4:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 5f6:	48 85 c9             	test   %rcx,%rcx
 5f9:	75 27                	jne    622 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 5fb:	48 c7 05 5a 03 00 00 	movq   $0x970,0x35a(%rip)        # 960 <_edata>
 602:	70 09 00 00 
 606:	48 c7 05 5f 03 00 00 	movq   $0x970,0x35f(%rip)        # 970 <base>
 60d:	70 09 00 00 
 611:	48 c7 c1 70 09 00 00 	mov    $0x970,%rcx
    base.s.size = 0;
 618:	c7 05 56 03 00 00 00 	movl   $0x0,0x356(%rip)        # 978 <base+0x8>
 61f:	00 00 00 
 622:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 628:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62e:	48 8b 01             	mov    (%rcx),%rax
 631:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 635:	45 89 e5             	mov    %r12d,%r13d
 638:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 63c:	8b 50 08             	mov    0x8(%rax),%edx
 63f:	39 d3                	cmp    %edx,%ebx
 641:	77 26                	ja     669 <malloc+0x90>
      if(p->s.size == nunits)
 643:	75 08                	jne    64d <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 645:	48 8b 10             	mov    (%rax),%rdx
 648:	48 89 11             	mov    %rdx,(%rcx)
 64b:	eb 0f                	jmp    65c <malloc+0x83>
      else {
        p->s.size -= nunits;
 64d:	29 da                	sub    %ebx,%edx
 64f:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 652:	48 c1 e2 04          	shl    $0x4,%rdx
 656:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 659:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 65c:	48 89 0d fd 02 00 00 	mov    %rcx,0x2fd(%rip)        # 960 <_edata>
      return (void*)(p + 1);
 663:	48 83 c0 10          	add    $0x10,%rax
 667:	eb 3a                	jmp    6a3 <malloc+0xca>
    }
    if(p == freep)
 669:	48 3b 05 f0 02 00 00 	cmp    0x2f0(%rip),%rax        # 960 <_edata>
 670:	75 27                	jne    699 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 672:	44 89 ef             	mov    %r13d,%edi
 675:	e8 52 fc ff ff       	callq  2cc <sbrk>
  if(p == (char*)-1)
 67a:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 67e:	74 21                	je     6a1 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 680:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 684:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 688:	e8 d0 fe ff ff       	callq  55d <free>
  return freep;
 68d:	48 8b 05 cc 02 00 00 	mov    0x2cc(%rip),%rax        # 960 <_edata>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 694:	48 85 c0             	test   %rax,%rax
 697:	74 08                	je     6a1 <malloc+0xc8>
        return 0;
  }
 699:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69c:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 69f:	eb 9b                	jmp    63c <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 6a1:	31 c0                	xor    %eax,%eax
  }
}
 6a3:	5a                   	pop    %rdx
 6a4:	5b                   	pop    %rbx
 6a5:	41 5c                	pop    %r12
 6a7:	41 5d                	pop    %r13
 6a9:	5d                   	pop    %rbp
 6aa:	c3                   	retq   
