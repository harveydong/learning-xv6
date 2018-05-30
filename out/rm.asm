
.fs/rm:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int i;

  if(argc < 2){
   1:	83 ff 01             	cmp    $0x1,%edi
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	41 55                	push   %r13
   9:	41 54                	push   %r12
   b:	53                   	push   %rbx
   c:	50                   	push   %rax
  int i;

  if(argc < 2){
   d:	7f 15                	jg     24 <main+0x24>
    printf(2, "Usage: rm files...\n");
   f:	48 c7 c6 40 06 00 00 	mov    $0x640,%rsi
  16:	bf 02 00 00 00       	mov    $0x2,%edi
  1b:	31 c0                	xor    %eax,%eax
  1d:	e8 dc 02 00 00       	callq  2fe <printf>
  22:	eb 3d                	jmp    61 <main+0x61>
  24:	48 8d 5e 08          	lea    0x8(%rsi),%rbx
  28:	41 89 fd             	mov    %edi,%r13d
int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
  2b:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  31:	48 8b 3b             	mov    (%rbx),%rdi
  34:	e8 e2 01 00 00       	callq  21b <unlink>
  39:	85 c0                	test   %eax,%eax
  3b:	79 18                	jns    55 <main+0x55>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  3d:	48 8b 13             	mov    (%rbx),%rdx
  40:	48 c7 c6 54 06 00 00 	mov    $0x654,%rsi
  47:	bf 02 00 00 00       	mov    $0x2,%edi
  4c:	31 c0                	xor    %eax,%eax
  4e:	e8 ab 02 00 00       	callq  2fe <printf>
      break;
  53:	eb 0c                	jmp    61 <main+0x61>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  55:	41 ff c4             	inc    %r12d
  58:	48 83 c3 08          	add    $0x8,%rbx
  5c:	45 39 e5             	cmp    %r12d,%r13d
  5f:	75 d0                	jne    31 <main+0x31>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  61:	e8 65 01 00 00       	callq  1cb <exit>

0000000000000066 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  66:	55                   	push   %rbp
  67:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  6c:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6f:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  72:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  75:	48 ff c2             	inc    %rdx
  78:	84 c9                	test   %cl,%cl
  7a:	75 f3                	jne    6f <strcpy+0x9>
    ;
  return os;
}
  7c:	5d                   	pop    %rbp
  7d:	c3                   	retq   

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %rbp
  7f:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  82:	0f b6 07             	movzbl (%rdi),%eax
  85:	84 c0                	test   %al,%al
  87:	74 0c                	je     95 <strcmp+0x17>
  89:	3a 06                	cmp    (%rsi),%al
  8b:	75 08                	jne    95 <strcmp+0x17>
    p++, q++;
  8d:	48 ff c7             	inc    %rdi
  90:	48 ff c6             	inc    %rsi
  93:	eb ed                	jmp    82 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  95:	0f b6 16             	movzbl (%rsi),%edx
}
  98:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  99:	29 d0                	sub    %edx,%eax
}
  9b:	c3                   	retq   

000000000000009c <strlen>:

uint
strlen(const char *s)
{
  9c:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  9d:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  9f:	48 89 e5             	mov    %rsp,%rbp
  a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
  a6:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
  ab:	74 05                	je     b2 <strlen+0x16>
  ad:	48 89 d0             	mov    %rdx,%rax
  b0:	eb f0                	jmp    a2 <strlen+0x6>
    ;
  return n;
}
  b2:	5d                   	pop    %rbp
  b3:	c3                   	retq   

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	55                   	push   %rbp
  b5:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b8:	89 d1                	mov    %edx,%ecx
  ba:	89 f0                	mov    %esi,%eax
  bc:	48 89 e5             	mov    %rsp,%rbp
  bf:	fc                   	cld    
  c0:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  c2:	4c 89 c0             	mov    %r8,%rax
  c5:	5d                   	pop    %rbp
  c6:	c3                   	retq   

00000000000000c7 <strchr>:

char*
strchr(const char *s, char c)
{
  c7:	55                   	push   %rbp
  c8:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
  cb:	8a 07                	mov    (%rdi),%al
  cd:	84 c0                	test   %al,%al
  cf:	74 0a                	je     db <strchr+0x14>
    if(*s == c)
  d1:	40 38 f0             	cmp    %sil,%al
  d4:	74 09                	je     df <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  d6:	48 ff c7             	inc    %rdi
  d9:	eb f0                	jmp    cb <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
  db:	31 c0                	xor    %eax,%eax
  dd:	eb 03                	jmp    e2 <strchr+0x1b>
  df:	48 89 f8             	mov    %rdi,%rax
}
  e2:	5d                   	pop    %rbp
  e3:	c3                   	retq   

00000000000000e4 <gets>:

char*
gets(char *buf, int max)
{
  e4:	55                   	push   %rbp
  e5:	48 89 e5             	mov    %rsp,%rbp
  e8:	41 57                	push   %r15
  ea:	41 56                	push   %r14
  ec:	41 55                	push   %r13
  ee:	41 54                	push   %r12
  f0:	41 89 f7             	mov    %esi,%r15d
  f3:	53                   	push   %rbx
  f4:	49 89 fc             	mov    %rdi,%r12
  f7:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fa:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
  fc:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 104:	45 39 fd             	cmp    %r15d,%r13d
 107:	7d 2c                	jge    135 <gets+0x51>
    cc = read(0, &c, 1);
 109:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 10d:	31 ff                	xor    %edi,%edi
 10f:	ba 01 00 00 00       	mov    $0x1,%edx
 114:	e8 ca 00 00 00       	callq  1e3 <read>
    if(cc < 1)
 119:	85 c0                	test   %eax,%eax
 11b:	7e 18                	jle    135 <gets+0x51>
      break;
    buf[i++] = c;
 11d:	8a 45 cf             	mov    -0x31(%rbp),%al
 120:	49 ff c6             	inc    %r14
 123:	49 63 dd             	movslq %r13d,%rbx
 126:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 12a:	3c 0a                	cmp    $0xa,%al
 12c:	74 04                	je     132 <gets+0x4e>
 12e:	3c 0d                	cmp    $0xd,%al
 130:	75 ce                	jne    100 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 135:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 13a:	48 83 c4 18          	add    $0x18,%rsp
 13e:	4c 89 e0             	mov    %r12,%rax
 141:	5b                   	pop    %rbx
 142:	41 5c                	pop    %r12
 144:	41 5d                	pop    %r13
 146:	41 5e                	pop    %r14
 148:	41 5f                	pop    %r15
 14a:	5d                   	pop    %rbp
 14b:	c3                   	retq   

000000000000014c <stat>:

int
stat(const char *n, struct stat *st)
{
 14c:	55                   	push   %rbp
 14d:	48 89 e5             	mov    %rsp,%rbp
 150:	41 54                	push   %r12
 152:	53                   	push   %rbx
 153:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 156:	31 f6                	xor    %esi,%esi
 158:	e8 ae 00 00 00       	callq  20b <open>
 15d:	41 89 c4             	mov    %eax,%r12d
 160:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 163:	45 85 e4             	test   %r12d,%r12d
 166:	78 17                	js     17f <stat+0x33>
    return -1;
  r = fstat(fd, st);
 168:	48 89 de             	mov    %rbx,%rsi
 16b:	44 89 e7             	mov    %r12d,%edi
 16e:	e8 b0 00 00 00       	callq  223 <fstat>
  close(fd);
 173:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 176:	89 c3                	mov    %eax,%ebx
  close(fd);
 178:	e8 76 00 00 00       	callq  1f3 <close>
  return r;
 17d:	89 d8                	mov    %ebx,%eax
}
 17f:	5b                   	pop    %rbx
 180:	41 5c                	pop    %r12
 182:	5d                   	pop    %rbp
 183:	c3                   	retq   

0000000000000184 <atoi>:

int
atoi(const char *s)
{
 184:	55                   	push   %rbp
  int n;

  n = 0;
 185:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 187:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18a:	0f be 17             	movsbl (%rdi),%edx
 18d:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 190:	80 f9 09             	cmp    $0x9,%cl
 193:	77 0c                	ja     1a1 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 195:	6b c0 0a             	imul   $0xa,%eax,%eax
 198:	48 ff c7             	inc    %rdi
 19b:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 19f:	eb e9                	jmp    18a <atoi+0x6>
  return n;
}
 1a1:	5d                   	pop    %rbp
 1a2:	c3                   	retq   

00000000000001a3 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1a3:	55                   	push   %rbp
 1a4:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1a7:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1a9:	48 89 e5             	mov    %rsp,%rbp
 1ac:	89 d7                	mov    %edx,%edi
 1ae:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1b0:	85 ff                	test   %edi,%edi
 1b2:	7e 0d                	jle    1c1 <memmove+0x1e>
    *dst++ = *src++;
 1b4:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 1b8:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 1bc:	48 ff c1             	inc    %rcx
 1bf:	eb eb                	jmp    1ac <memmove+0x9>
  return vdst;
}
 1c1:	5d                   	pop    %rbp
 1c2:	c3                   	retq   

00000000000001c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1c3:	b8 01 00 00 00       	mov    $0x1,%eax
 1c8:	cd 40                	int    $0x40
 1ca:	c3                   	retq   

00000000000001cb <exit>:
SYSCALL(exit)
 1cb:	b8 02 00 00 00       	mov    $0x2,%eax
 1d0:	cd 40                	int    $0x40
 1d2:	c3                   	retq   

00000000000001d3 <wait>:
SYSCALL(wait)
 1d3:	b8 03 00 00 00       	mov    $0x3,%eax
 1d8:	cd 40                	int    $0x40
 1da:	c3                   	retq   

00000000000001db <pipe>:
SYSCALL(pipe)
 1db:	b8 04 00 00 00       	mov    $0x4,%eax
 1e0:	cd 40                	int    $0x40
 1e2:	c3                   	retq   

00000000000001e3 <read>:
SYSCALL(read)
 1e3:	b8 05 00 00 00       	mov    $0x5,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	retq   

00000000000001eb <write>:
SYSCALL(write)
 1eb:	b8 10 00 00 00       	mov    $0x10,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	retq   

00000000000001f3 <close>:
SYSCALL(close)
 1f3:	b8 15 00 00 00       	mov    $0x15,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	retq   

00000000000001fb <kill>:
SYSCALL(kill)
 1fb:	b8 06 00 00 00       	mov    $0x6,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	retq   

0000000000000203 <exec>:
SYSCALL(exec)
 203:	b8 07 00 00 00       	mov    $0x7,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	retq   

000000000000020b <open>:
SYSCALL(open)
 20b:	b8 0f 00 00 00       	mov    $0xf,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	retq   

0000000000000213 <mknod>:
SYSCALL(mknod)
 213:	b8 11 00 00 00       	mov    $0x11,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	retq   

000000000000021b <unlink>:
SYSCALL(unlink)
 21b:	b8 12 00 00 00       	mov    $0x12,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	retq   

0000000000000223 <fstat>:
SYSCALL(fstat)
 223:	b8 08 00 00 00       	mov    $0x8,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	retq   

000000000000022b <link>:
SYSCALL(link)
 22b:	b8 13 00 00 00       	mov    $0x13,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	retq   

0000000000000233 <mkdir>:
SYSCALL(mkdir)
 233:	b8 14 00 00 00       	mov    $0x14,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	retq   

000000000000023b <chdir>:
SYSCALL(chdir)
 23b:	b8 09 00 00 00       	mov    $0x9,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	retq   

0000000000000243 <dup>:
SYSCALL(dup)
 243:	b8 0a 00 00 00       	mov    $0xa,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	retq   

000000000000024b <getpid>:
SYSCALL(getpid)
 24b:	b8 0b 00 00 00       	mov    $0xb,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	retq   

0000000000000253 <sbrk>:
SYSCALL(sbrk)
 253:	b8 0c 00 00 00       	mov    $0xc,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	retq   

000000000000025b <sleep>:
SYSCALL(sleep)
 25b:	b8 0d 00 00 00       	mov    $0xd,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	retq   

0000000000000263 <uptime>:
SYSCALL(uptime)
 263:	b8 0e 00 00 00       	mov    $0xe,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	retq   

000000000000026b <chmod>:
SYSCALL(chmod)
 26b:	b8 16 00 00 00       	mov    $0x16,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	retq   

0000000000000273 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 273:	55                   	push   %rbp
 274:	41 89 d0             	mov    %edx,%r8d
 277:	48 89 e5             	mov    %rsp,%rbp
 27a:	41 54                	push   %r12
 27c:	53                   	push   %rbx
 27d:	41 89 fc             	mov    %edi,%r12d
 280:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 284:	85 c9                	test   %ecx,%ecx
 286:	74 12                	je     29a <printint+0x27>
 288:	89 f0                	mov    %esi,%eax
 28a:	c1 e8 1f             	shr    $0x1f,%eax
 28d:	74 0b                	je     29a <printint+0x27>
    neg = 1;
    x = -xx;
 28f:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 291:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 296:	f7 d8                	neg    %eax
 298:	eb 04                	jmp    29e <printint+0x2b>
  } else {
    x = xx;
 29a:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 29c:	31 f6                	xor    %esi,%esi
 29e:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2a2:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 2a4:	31 d2                	xor    %edx,%edx
 2a6:	48 ff c7             	inc    %rdi
 2a9:	8d 59 01             	lea    0x1(%rcx),%ebx
 2ac:	41 f7 f0             	div    %r8d
 2af:	89 d2                	mov    %edx,%edx
 2b1:	8a 92 80 06 00 00    	mov    0x680(%rdx),%dl
 2b7:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 2ba:	85 c0                	test   %eax,%eax
 2bc:	74 04                	je     2c2 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 2be:	89 d9                	mov    %ebx,%ecx
 2c0:	eb e2                	jmp    2a4 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 2c2:	85 f6                	test   %esi,%esi
 2c4:	74 0b                	je     2d1 <printint+0x5e>
    buf[i++] = '-';
 2c6:	48 63 db             	movslq %ebx,%rbx
 2c9:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 2ce:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 2d1:	ff cb                	dec    %ebx
 2d3:	83 fb ff             	cmp    $0xffffffff,%ebx
 2d6:	74 1d                	je     2f5 <printint+0x82>
    putc(fd, buf[i]);
 2d8:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 2db:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 2df:	ba 01 00 00 00       	mov    $0x1,%edx
 2e4:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 2e8:	44 89 e7             	mov    %r12d,%edi
 2eb:	88 45 df             	mov    %al,-0x21(%rbp)
 2ee:	e8 f8 fe ff ff       	callq  1eb <write>
 2f3:	eb dc                	jmp    2d1 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 2f5:	48 83 c4 20          	add    $0x20,%rsp
 2f9:	5b                   	pop    %rbx
 2fa:	41 5c                	pop    %r12
 2fc:	5d                   	pop    %rbp
 2fd:	c3                   	retq   

00000000000002fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2fe:	55                   	push   %rbp
 2ff:	48 89 e5             	mov    %rsp,%rbp
 302:	41 56                	push   %r14
 304:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 306:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 30a:	41 54                	push   %r12
 30c:	53                   	push   %rbx
 30d:	41 89 fc             	mov    %edi,%r12d
 310:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 313:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 315:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 319:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 31d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 321:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 325:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 329:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 32d:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 331:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 338:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 33c:	45 8a 2e             	mov    (%r14),%r13b
 33f:	45 84 ed             	test   %r13b,%r13b
 342:	0f 84 8f 01 00 00    	je     4d7 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 348:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 34a:	41 0f be d5          	movsbl %r13b,%edx
 34e:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 352:	75 23                	jne    377 <printf+0x79>
      if(c == '%'){
 354:	83 f8 25             	cmp    $0x25,%eax
 357:	0f 84 6d 01 00 00    	je     4ca <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 35d:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 361:	ba 01 00 00 00       	mov    $0x1,%edx
 366:	44 89 e7             	mov    %r12d,%edi
 369:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 36d:	e8 79 fe ff ff       	callq  1eb <write>
 372:	e9 58 01 00 00       	jmpq   4cf <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 377:	83 fb 25             	cmp    $0x25,%ebx
 37a:	0f 85 4f 01 00 00    	jne    4cf <printf+0x1d1>
      if(c == 'd'){
 380:	83 f8 64             	cmp    $0x64,%eax
 383:	75 2e                	jne    3b3 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 385:	8b 55 98             	mov    -0x68(%rbp),%edx
 388:	83 fa 2f             	cmp    $0x2f,%edx
 38b:	77 0e                	ja     39b <printf+0x9d>
 38d:	89 d0                	mov    %edx,%eax
 38f:	83 c2 08             	add    $0x8,%edx
 392:	48 03 45 a8          	add    -0x58(%rbp),%rax
 396:	89 55 98             	mov    %edx,-0x68(%rbp)
 399:	eb 0c                	jmp    3a7 <printf+0xa9>
 39b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 39f:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3a3:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3a7:	b9 01 00 00 00       	mov    $0x1,%ecx
 3ac:	ba 0a 00 00 00       	mov    $0xa,%edx
 3b1:	eb 34                	jmp    3e7 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 3b3:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3b9:	83 fa 70             	cmp    $0x70,%edx
 3bc:	75 38                	jne    3f6 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 3be:	8b 55 98             	mov    -0x68(%rbp),%edx
 3c1:	83 fa 2f             	cmp    $0x2f,%edx
 3c4:	77 0e                	ja     3d4 <printf+0xd6>
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	83 c2 08             	add    $0x8,%edx
 3cb:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3cf:	89 55 98             	mov    %edx,-0x68(%rbp)
 3d2:	eb 0c                	jmp    3e0 <printf+0xe2>
 3d4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3d8:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3dc:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3e0:	31 c9                	xor    %ecx,%ecx
 3e2:	ba 10 00 00 00       	mov    $0x10,%edx
 3e7:	8b 30                	mov    (%rax),%esi
 3e9:	44 89 e7             	mov    %r12d,%edi
 3ec:	e8 82 fe ff ff       	callq  273 <printint>
 3f1:	e9 d0 00 00 00       	jmpq   4c6 <printf+0x1c8>
      } else if(c == 's'){
 3f6:	83 f8 73             	cmp    $0x73,%eax
 3f9:	75 56                	jne    451 <printf+0x153>
        s = va_arg(ap, char*);
 3fb:	8b 55 98             	mov    -0x68(%rbp),%edx
 3fe:	83 fa 2f             	cmp    $0x2f,%edx
 401:	77 0e                	ja     411 <printf+0x113>
 403:	89 d0                	mov    %edx,%eax
 405:	83 c2 08             	add    $0x8,%edx
 408:	48 03 45 a8          	add    -0x58(%rbp),%rax
 40c:	89 55 98             	mov    %edx,-0x68(%rbp)
 40f:	eb 0c                	jmp    41d <printf+0x11f>
 411:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 415:	48 8d 50 08          	lea    0x8(%rax),%rdx
 419:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 41d:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 420:	48 c7 c0 6d 06 00 00 	mov    $0x66d,%rax
 427:	48 85 db             	test   %rbx,%rbx
 42a:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 42e:	8a 03                	mov    (%rbx),%al
 430:	84 c0                	test   %al,%al
 432:	0f 84 8e 00 00 00    	je     4c6 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 438:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 43c:	ba 01 00 00 00       	mov    $0x1,%edx
 441:	44 89 e7             	mov    %r12d,%edi
 444:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 447:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 44a:	e8 9c fd ff ff       	callq  1eb <write>
 44f:	eb dd                	jmp    42e <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 451:	83 f8 63             	cmp    $0x63,%eax
 454:	75 32                	jne    488 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 456:	8b 55 98             	mov    -0x68(%rbp),%edx
 459:	83 fa 2f             	cmp    $0x2f,%edx
 45c:	77 0e                	ja     46c <printf+0x16e>
 45e:	89 d0                	mov    %edx,%eax
 460:	83 c2 08             	add    $0x8,%edx
 463:	48 03 45 a8          	add    -0x58(%rbp),%rax
 467:	89 55 98             	mov    %edx,-0x68(%rbp)
 46a:	eb 0c                	jmp    478 <printf+0x17a>
 46c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 470:	48 8d 50 08          	lea    0x8(%rax),%rdx
 474:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 478:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 47a:	ba 01 00 00 00       	mov    $0x1,%edx
 47f:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 483:	88 45 94             	mov    %al,-0x6c(%rbp)
 486:	eb 36                	jmp    4be <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 488:	83 f8 25             	cmp    $0x25,%eax
 48b:	75 0f                	jne    49c <printf+0x19e>
 48d:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	ba 01 00 00 00       	mov    $0x1,%edx
 496:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 49a:	eb 22                	jmp    4be <printf+0x1c0>
 49c:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 4a0:	ba 01 00 00 00       	mov    $0x1,%edx
 4a5:	44 89 e7             	mov    %r12d,%edi
 4a8:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 4ac:	e8 3a fd ff ff       	callq  1eb <write>
 4b1:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 4b5:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 4b9:	ba 01 00 00 00       	mov    $0x1,%edx
 4be:	44 89 e7             	mov    %r12d,%edi
 4c1:	e8 25 fd ff ff       	callq  1eb <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c6:	31 db                	xor    %ebx,%ebx
 4c8:	eb 05                	jmp    4cf <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4ca:	bb 25 00 00 00       	mov    $0x25,%ebx
 4cf:	49 ff c6             	inc    %r14
 4d2:	e9 65 fe ff ff       	jmpq   33c <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4d7:	48 83 c4 50          	add    $0x50,%rsp
 4db:	5b                   	pop    %rbx
 4dc:	41 5c                	pop    %r12
 4de:	41 5d                	pop    %r13
 4e0:	41 5e                	pop    %r14
 4e2:	5d                   	pop    %rbp
 4e3:	c3                   	retq   

00000000000004e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e4:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e5:	48 8b 05 d4 03 00 00 	mov    0x3d4(%rip),%rax        # 8c0 <__bss_start>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ec:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f0:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f3:	48 39 d0             	cmp    %rdx,%rax
 4f6:	48 8b 08             	mov    (%rax),%rcx
 4f9:	72 14                	jb     50f <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4fb:	48 39 c8             	cmp    %rcx,%rax
 4fe:	72 0a                	jb     50a <free+0x26>
 500:	48 39 ca             	cmp    %rcx,%rdx
 503:	72 0f                	jb     514 <free+0x30>
 505:	48 39 d0             	cmp    %rdx,%rax
 508:	72 0a                	jb     514 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 50a:	48 89 c8             	mov    %rcx,%rax
 50d:	eb e4                	jmp    4f3 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 50f:	48 39 ca             	cmp    %rcx,%rdx
 512:	73 e7                	jae    4fb <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 514:	8b 77 f8             	mov    -0x8(%rdi),%esi
 517:	49 89 f0             	mov    %rsi,%r8
 51a:	48 c1 e6 04          	shl    $0x4,%rsi
 51e:	48 01 d6             	add    %rdx,%rsi
 521:	48 39 ce             	cmp    %rcx,%rsi
 524:	75 0e                	jne    534 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 526:	44 03 41 08          	add    0x8(%rcx),%r8d
 52a:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 52e:	48 8b 08             	mov    (%rax),%rcx
 531:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 534:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 538:	8b 48 08             	mov    0x8(%rax),%ecx
 53b:	48 89 ce             	mov    %rcx,%rsi
 53e:	48 c1 e1 04          	shl    $0x4,%rcx
 542:	48 01 c1             	add    %rax,%rcx
 545:	48 39 ca             	cmp    %rcx,%rdx
 548:	75 0a                	jne    554 <free+0x70>
    p->s.size += bp->s.size;
 54a:	03 77 f8             	add    -0x8(%rdi),%esi
 54d:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 550:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 554:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 557:	48 89 05 62 03 00 00 	mov    %rax,0x362(%rip)        # 8c0 <__bss_start>
}
 55e:	5d                   	pop    %rbp
 55f:	c3                   	retq   

0000000000000560 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 560:	55                   	push   %rbp
 561:	48 89 e5             	mov    %rsp,%rbp
 564:	41 55                	push   %r13
 566:	41 54                	push   %r12
 568:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 569:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 56b:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 56c:	48 8b 0d 4d 03 00 00 	mov    0x34d(%rip),%rcx        # 8c0 <__bss_start>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 573:	48 83 c3 0f          	add    $0xf,%rbx
 577:	48 c1 eb 04          	shr    $0x4,%rbx
 57b:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 57d:	48 85 c9             	test   %rcx,%rcx
 580:	75 27                	jne    5a9 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 582:	48 c7 05 33 03 00 00 	movq   $0x8d0,0x333(%rip)        # 8c0 <__bss_start>
 589:	d0 08 00 00 
 58d:	48 c7 05 38 03 00 00 	movq   $0x8d0,0x338(%rip)        # 8d0 <base>
 594:	d0 08 00 00 
 598:	48 c7 c1 d0 08 00 00 	mov    $0x8d0,%rcx
    base.s.size = 0;
 59f:	c7 05 2f 03 00 00 00 	movl   $0x0,0x32f(%rip)        # 8d8 <base+0x8>
 5a6:	00 00 00 
 5a9:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5af:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b5:	48 8b 01             	mov    (%rcx),%rax
 5b8:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5bc:	45 89 e5             	mov    %r12d,%r13d
 5bf:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5c3:	8b 50 08             	mov    0x8(%rax),%edx
 5c6:	39 d3                	cmp    %edx,%ebx
 5c8:	77 26                	ja     5f0 <malloc+0x90>
      if(p->s.size == nunits)
 5ca:	75 08                	jne    5d4 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 5cc:	48 8b 10             	mov    (%rax),%rdx
 5cf:	48 89 11             	mov    %rdx,(%rcx)
 5d2:	eb 0f                	jmp    5e3 <malloc+0x83>
      else {
        p->s.size -= nunits;
 5d4:	29 da                	sub    %ebx,%edx
 5d6:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 5d9:	48 c1 e2 04          	shl    $0x4,%rdx
 5dd:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 5e0:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 5e3:	48 89 0d d6 02 00 00 	mov    %rcx,0x2d6(%rip)        # 8c0 <__bss_start>
      return (void*)(p + 1);
 5ea:	48 83 c0 10          	add    $0x10,%rax
 5ee:	eb 3a                	jmp    62a <malloc+0xca>
    }
    if(p == freep)
 5f0:	48 3b 05 c9 02 00 00 	cmp    0x2c9(%rip),%rax        # 8c0 <__bss_start>
 5f7:	75 27                	jne    620 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5f9:	44 89 ef             	mov    %r13d,%edi
 5fc:	e8 52 fc ff ff       	callq  253 <sbrk>
  if(p == (char*)-1)
 601:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 605:	74 21                	je     628 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 607:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 60b:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 60f:	e8 d0 fe ff ff       	callq  4e4 <free>
  return freep;
 614:	48 8b 05 a5 02 00 00 	mov    0x2a5(%rip),%rax        # 8c0 <__bss_start>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 61b:	48 85 c0             	test   %rax,%rax
 61e:	74 08                	je     628 <malloc+0xc8>
        return 0;
  }
 620:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 623:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 626:	eb 9b                	jmp    5c3 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 628:	31 c0                	xor    %eax,%eax
  }
}
 62a:	5a                   	pop    %rdx
 62b:	5b                   	pop    %rbx
 62c:	41 5c                	pop    %r12
 62e:	41 5d                	pop    %r13
 630:	5d                   	pop    %rbp
 631:	c3                   	retq   
