
.fs/echo:     file format elf64-x86-64


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
   b:	48 8d 5e 08          	lea    0x8(%rsi),%rbx
   f:	41 89 fe             	mov    %edi,%r14d
  int i;

  for(i = 1; i < argc; i++)
  12:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  18:	49 c7 c5 30 06 00 00 	mov    $0x630,%r13
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  1f:	45 39 f4             	cmp    %r14d,%r12d
  22:	7d 2d                	jge    51 <main+0x51>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	48 8b 13             	mov    (%rbx),%rdx
  27:	41 ff c4             	inc    %r12d
  2a:	48 c7 c1 32 06 00 00 	mov    $0x632,%rcx
  31:	45 39 e6             	cmp    %r12d,%r14d
  34:	48 c7 c6 34 06 00 00 	mov    $0x634,%rsi
  3b:	bf 01 00 00 00       	mov    $0x1,%edi
  40:	49 0f 4f cd          	cmovg  %r13,%rcx
  44:	31 c0                	xor    %eax,%eax
  46:	48 83 c3 08          	add    $0x8,%rbx
  4a:	e8 9f 02 00 00       	callq  2ee <printf>
  4f:	eb ce                	jmp    1f <main+0x1f>
  exit();
  51:	e8 65 01 00 00       	callq  1bb <exit>

0000000000000056 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  56:	55                   	push   %rbp
  57:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5f:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  62:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  65:	48 ff c2             	inc    %rdx
  68:	84 c9                	test   %cl,%cl
  6a:	75 f3                	jne    5f <strcpy+0x9>
    ;
  return os;
}
  6c:	5d                   	pop    %rbp
  6d:	c3                   	retq   

000000000000006e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6e:	55                   	push   %rbp
  6f:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  72:	0f b6 07             	movzbl (%rdi),%eax
  75:	84 c0                	test   %al,%al
  77:	74 0c                	je     85 <strcmp+0x17>
  79:	3a 06                	cmp    (%rsi),%al
  7b:	75 08                	jne    85 <strcmp+0x17>
    p++, q++;
  7d:	48 ff c7             	inc    %rdi
  80:	48 ff c6             	inc    %rsi
  83:	eb ed                	jmp    72 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  85:	0f b6 16             	movzbl (%rsi),%edx
}
  88:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  89:	29 d0                	sub    %edx,%eax
}
  8b:	c3                   	retq   

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  8d:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  8f:	48 89 e5             	mov    %rsp,%rbp
  92:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
  9b:	74 05                	je     a2 <strlen+0x16>
  9d:	48 89 d0             	mov    %rdx,%rax
  a0:	eb f0                	jmp    92 <strlen+0x6>
    ;
  return n;
}
  a2:	5d                   	pop    %rbp
  a3:	c3                   	retq   

00000000000000a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a4:	55                   	push   %rbp
  a5:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a8:	89 d1                	mov    %edx,%ecx
  aa:	89 f0                	mov    %esi,%eax
  ac:	48 89 e5             	mov    %rsp,%rbp
  af:	fc                   	cld    
  b0:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  b2:	4c 89 c0             	mov    %r8,%rax
  b5:	5d                   	pop    %rbp
  b6:	c3                   	retq   

00000000000000b7 <strchr>:

char*
strchr(const char *s, char c)
{
  b7:	55                   	push   %rbp
  b8:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
  bb:	8a 07                	mov    (%rdi),%al
  bd:	84 c0                	test   %al,%al
  bf:	74 0a                	je     cb <strchr+0x14>
    if(*s == c)
  c1:	40 38 f0             	cmp    %sil,%al
  c4:	74 09                	je     cf <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  c6:	48 ff c7             	inc    %rdi
  c9:	eb f0                	jmp    bb <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
  cb:	31 c0                	xor    %eax,%eax
  cd:	eb 03                	jmp    d2 <strchr+0x1b>
  cf:	48 89 f8             	mov    %rdi,%rax
}
  d2:	5d                   	pop    %rbp
  d3:	c3                   	retq   

00000000000000d4 <gets>:

char*
gets(char *buf, int max)
{
  d4:	55                   	push   %rbp
  d5:	48 89 e5             	mov    %rsp,%rbp
  d8:	41 57                	push   %r15
  da:	41 56                	push   %r14
  dc:	41 55                	push   %r13
  de:	41 54                	push   %r12
  e0:	41 89 f7             	mov    %esi,%r15d
  e3:	53                   	push   %rbx
  e4:	49 89 fc             	mov    %rdi,%r12
  e7:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ea:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
  ec:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f0:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  f4:	45 39 fd             	cmp    %r15d,%r13d
  f7:	7d 2c                	jge    125 <gets+0x51>
    cc = read(0, &c, 1);
  f9:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  fd:	31 ff                	xor    %edi,%edi
  ff:	ba 01 00 00 00       	mov    $0x1,%edx
 104:	e8 ca 00 00 00       	callq  1d3 <read>
    if(cc < 1)
 109:	85 c0                	test   %eax,%eax
 10b:	7e 18                	jle    125 <gets+0x51>
      break;
    buf[i++] = c;
 10d:	8a 45 cf             	mov    -0x31(%rbp),%al
 110:	49 ff c6             	inc    %r14
 113:	49 63 dd             	movslq %r13d,%rbx
 116:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 11a:	3c 0a                	cmp    $0xa,%al
 11c:	74 04                	je     122 <gets+0x4e>
 11e:	3c 0d                	cmp    $0xd,%al
 120:	75 ce                	jne    f0 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 122:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 125:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 12a:	48 83 c4 18          	add    $0x18,%rsp
 12e:	4c 89 e0             	mov    %r12,%rax
 131:	5b                   	pop    %rbx
 132:	41 5c                	pop    %r12
 134:	41 5d                	pop    %r13
 136:	41 5e                	pop    %r14
 138:	41 5f                	pop    %r15
 13a:	5d                   	pop    %rbp
 13b:	c3                   	retq   

000000000000013c <stat>:

int
stat(const char *n, struct stat *st)
{
 13c:	55                   	push   %rbp
 13d:	48 89 e5             	mov    %rsp,%rbp
 140:	41 54                	push   %r12
 142:	53                   	push   %rbx
 143:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 146:	31 f6                	xor    %esi,%esi
 148:	e8 ae 00 00 00       	callq  1fb <open>
 14d:	41 89 c4             	mov    %eax,%r12d
 150:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 153:	45 85 e4             	test   %r12d,%r12d
 156:	78 17                	js     16f <stat+0x33>
    return -1;
  r = fstat(fd, st);
 158:	48 89 de             	mov    %rbx,%rsi
 15b:	44 89 e7             	mov    %r12d,%edi
 15e:	e8 b0 00 00 00       	callq  213 <fstat>
  close(fd);
 163:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 166:	89 c3                	mov    %eax,%ebx
  close(fd);
 168:	e8 76 00 00 00       	callq  1e3 <close>
  return r;
 16d:	89 d8                	mov    %ebx,%eax
}
 16f:	5b                   	pop    %rbx
 170:	41 5c                	pop    %r12
 172:	5d                   	pop    %rbp
 173:	c3                   	retq   

0000000000000174 <atoi>:

int
atoi(const char *s)
{
 174:	55                   	push   %rbp
  int n;

  n = 0;
 175:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 177:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 17a:	0f be 17             	movsbl (%rdi),%edx
 17d:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 180:	80 f9 09             	cmp    $0x9,%cl
 183:	77 0c                	ja     191 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 185:	6b c0 0a             	imul   $0xa,%eax,%eax
 188:	48 ff c7             	inc    %rdi
 18b:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 18f:	eb e9                	jmp    17a <atoi+0x6>
  return n;
}
 191:	5d                   	pop    %rbp
 192:	c3                   	retq   

0000000000000193 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 193:	55                   	push   %rbp
 194:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 197:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 199:	48 89 e5             	mov    %rsp,%rbp
 19c:	89 d7                	mov    %edx,%edi
 19e:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1a0:	85 ff                	test   %edi,%edi
 1a2:	7e 0d                	jle    1b1 <memmove+0x1e>
    *dst++ = *src++;
 1a4:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 1a8:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 1ac:	48 ff c1             	inc    %rcx
 1af:	eb eb                	jmp    19c <memmove+0x9>
  return vdst;
}
 1b1:	5d                   	pop    %rbp
 1b2:	c3                   	retq   

00000000000001b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1b3:	b8 01 00 00 00       	mov    $0x1,%eax
 1b8:	cd 40                	int    $0x40
 1ba:	c3                   	retq   

00000000000001bb <exit>:
SYSCALL(exit)
 1bb:	b8 02 00 00 00       	mov    $0x2,%eax
 1c0:	cd 40                	int    $0x40
 1c2:	c3                   	retq   

00000000000001c3 <wait>:
SYSCALL(wait)
 1c3:	b8 03 00 00 00       	mov    $0x3,%eax
 1c8:	cd 40                	int    $0x40
 1ca:	c3                   	retq   

00000000000001cb <pipe>:
SYSCALL(pipe)
 1cb:	b8 04 00 00 00       	mov    $0x4,%eax
 1d0:	cd 40                	int    $0x40
 1d2:	c3                   	retq   

00000000000001d3 <read>:
SYSCALL(read)
 1d3:	b8 05 00 00 00       	mov    $0x5,%eax
 1d8:	cd 40                	int    $0x40
 1da:	c3                   	retq   

00000000000001db <write>:
SYSCALL(write)
 1db:	b8 10 00 00 00       	mov    $0x10,%eax
 1e0:	cd 40                	int    $0x40
 1e2:	c3                   	retq   

00000000000001e3 <close>:
SYSCALL(close)
 1e3:	b8 15 00 00 00       	mov    $0x15,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	retq   

00000000000001eb <kill>:
SYSCALL(kill)
 1eb:	b8 06 00 00 00       	mov    $0x6,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	retq   

00000000000001f3 <exec>:
SYSCALL(exec)
 1f3:	b8 07 00 00 00       	mov    $0x7,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	retq   

00000000000001fb <open>:
SYSCALL(open)
 1fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	retq   

0000000000000203 <mknod>:
SYSCALL(mknod)
 203:	b8 11 00 00 00       	mov    $0x11,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	retq   

000000000000020b <unlink>:
SYSCALL(unlink)
 20b:	b8 12 00 00 00       	mov    $0x12,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	retq   

0000000000000213 <fstat>:
SYSCALL(fstat)
 213:	b8 08 00 00 00       	mov    $0x8,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	retq   

000000000000021b <link>:
SYSCALL(link)
 21b:	b8 13 00 00 00       	mov    $0x13,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	retq   

0000000000000223 <mkdir>:
SYSCALL(mkdir)
 223:	b8 14 00 00 00       	mov    $0x14,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	retq   

000000000000022b <chdir>:
SYSCALL(chdir)
 22b:	b8 09 00 00 00       	mov    $0x9,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	retq   

0000000000000233 <dup>:
SYSCALL(dup)
 233:	b8 0a 00 00 00       	mov    $0xa,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	retq   

000000000000023b <getpid>:
SYSCALL(getpid)
 23b:	b8 0b 00 00 00       	mov    $0xb,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	retq   

0000000000000243 <sbrk>:
SYSCALL(sbrk)
 243:	b8 0c 00 00 00       	mov    $0xc,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	retq   

000000000000024b <sleep>:
SYSCALL(sleep)
 24b:	b8 0d 00 00 00       	mov    $0xd,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	retq   

0000000000000253 <uptime>:
SYSCALL(uptime)
 253:	b8 0e 00 00 00       	mov    $0xe,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	retq   

000000000000025b <chmod>:
SYSCALL(chmod)
 25b:	b8 16 00 00 00       	mov    $0x16,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	retq   

0000000000000263 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 263:	55                   	push   %rbp
 264:	41 89 d0             	mov    %edx,%r8d
 267:	48 89 e5             	mov    %rsp,%rbp
 26a:	41 54                	push   %r12
 26c:	53                   	push   %rbx
 26d:	41 89 fc             	mov    %edi,%r12d
 270:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 274:	85 c9                	test   %ecx,%ecx
 276:	74 12                	je     28a <printint+0x27>
 278:	89 f0                	mov    %esi,%eax
 27a:	c1 e8 1f             	shr    $0x1f,%eax
 27d:	74 0b                	je     28a <printint+0x27>
    neg = 1;
    x = -xx;
 27f:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 281:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 286:	f7 d8                	neg    %eax
 288:	eb 04                	jmp    28e <printint+0x2b>
  } else {
    x = xx;
 28a:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 28c:	31 f6                	xor    %esi,%esi
 28e:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 292:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 294:	31 d2                	xor    %edx,%edx
 296:	48 ff c7             	inc    %rdi
 299:	8d 59 01             	lea    0x1(%rcx),%ebx
 29c:	41 f7 f0             	div    %r8d
 29f:	89 d2                	mov    %edx,%edx
 2a1:	8a 92 40 06 00 00    	mov    0x640(%rdx),%dl
 2a7:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 2aa:	85 c0                	test   %eax,%eax
 2ac:	74 04                	je     2b2 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 2ae:	89 d9                	mov    %ebx,%ecx
 2b0:	eb e2                	jmp    294 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 2b2:	85 f6                	test   %esi,%esi
 2b4:	74 0b                	je     2c1 <printint+0x5e>
    buf[i++] = '-';
 2b6:	48 63 db             	movslq %ebx,%rbx
 2b9:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 2be:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 2c1:	ff cb                	dec    %ebx
 2c3:	83 fb ff             	cmp    $0xffffffff,%ebx
 2c6:	74 1d                	je     2e5 <printint+0x82>
    putc(fd, buf[i]);
 2c8:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 2cb:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 2cf:	ba 01 00 00 00       	mov    $0x1,%edx
 2d4:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 2d8:	44 89 e7             	mov    %r12d,%edi
 2db:	88 45 df             	mov    %al,-0x21(%rbp)
 2de:	e8 f8 fe ff ff       	callq  1db <write>
 2e3:	eb dc                	jmp    2c1 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 2e5:	48 83 c4 20          	add    $0x20,%rsp
 2e9:	5b                   	pop    %rbx
 2ea:	41 5c                	pop    %r12
 2ec:	5d                   	pop    %rbp
 2ed:	c3                   	retq   

00000000000002ee <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2ee:	55                   	push   %rbp
 2ef:	48 89 e5             	mov    %rsp,%rbp
 2f2:	41 56                	push   %r14
 2f4:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2f6:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2fa:	41 54                	push   %r12
 2fc:	53                   	push   %rbx
 2fd:	41 89 fc             	mov    %edi,%r12d
 300:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 303:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 305:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 309:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 30d:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 311:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 315:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 319:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 31d:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 321:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 328:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 32c:	45 8a 2e             	mov    (%r14),%r13b
 32f:	45 84 ed             	test   %r13b,%r13b
 332:	0f 84 8f 01 00 00    	je     4c7 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 338:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 33a:	41 0f be d5          	movsbl %r13b,%edx
 33e:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 342:	75 23                	jne    367 <printf+0x79>
      if(c == '%'){
 344:	83 f8 25             	cmp    $0x25,%eax
 347:	0f 84 6d 01 00 00    	je     4ba <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 34d:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 351:	ba 01 00 00 00       	mov    $0x1,%edx
 356:	44 89 e7             	mov    %r12d,%edi
 359:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 35d:	e8 79 fe ff ff       	callq  1db <write>
 362:	e9 58 01 00 00       	jmpq   4bf <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 367:	83 fb 25             	cmp    $0x25,%ebx
 36a:	0f 85 4f 01 00 00    	jne    4bf <printf+0x1d1>
      if(c == 'd'){
 370:	83 f8 64             	cmp    $0x64,%eax
 373:	75 2e                	jne    3a3 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 375:	8b 55 98             	mov    -0x68(%rbp),%edx
 378:	83 fa 2f             	cmp    $0x2f,%edx
 37b:	77 0e                	ja     38b <printf+0x9d>
 37d:	89 d0                	mov    %edx,%eax
 37f:	83 c2 08             	add    $0x8,%edx
 382:	48 03 45 a8          	add    -0x58(%rbp),%rax
 386:	89 55 98             	mov    %edx,-0x68(%rbp)
 389:	eb 0c                	jmp    397 <printf+0xa9>
 38b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 38f:	48 8d 50 08          	lea    0x8(%rax),%rdx
 393:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 397:	b9 01 00 00 00       	mov    $0x1,%ecx
 39c:	ba 0a 00 00 00       	mov    $0xa,%edx
 3a1:	eb 34                	jmp    3d7 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 3a3:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3a9:	83 fa 70             	cmp    $0x70,%edx
 3ac:	75 38                	jne    3e6 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 3ae:	8b 55 98             	mov    -0x68(%rbp),%edx
 3b1:	83 fa 2f             	cmp    $0x2f,%edx
 3b4:	77 0e                	ja     3c4 <printf+0xd6>
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	83 c2 08             	add    $0x8,%edx
 3bb:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3bf:	89 55 98             	mov    %edx,-0x68(%rbp)
 3c2:	eb 0c                	jmp    3d0 <printf+0xe2>
 3c4:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3c8:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3cc:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3d0:	31 c9                	xor    %ecx,%ecx
 3d2:	ba 10 00 00 00       	mov    $0x10,%edx
 3d7:	8b 30                	mov    (%rax),%esi
 3d9:	44 89 e7             	mov    %r12d,%edi
 3dc:	e8 82 fe ff ff       	callq  263 <printint>
 3e1:	e9 d0 00 00 00       	jmpq   4b6 <printf+0x1c8>
      } else if(c == 's'){
 3e6:	83 f8 73             	cmp    $0x73,%eax
 3e9:	75 56                	jne    441 <printf+0x153>
        s = va_arg(ap, char*);
 3eb:	8b 55 98             	mov    -0x68(%rbp),%edx
 3ee:	83 fa 2f             	cmp    $0x2f,%edx
 3f1:	77 0e                	ja     401 <printf+0x113>
 3f3:	89 d0                	mov    %edx,%eax
 3f5:	83 c2 08             	add    $0x8,%edx
 3f8:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3fc:	89 55 98             	mov    %edx,-0x68(%rbp)
 3ff:	eb 0c                	jmp    40d <printf+0x11f>
 401:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 405:	48 8d 50 08          	lea    0x8(%rax),%rdx
 409:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 40d:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 410:	48 c7 c0 39 06 00 00 	mov    $0x639,%rax
 417:	48 85 db             	test   %rbx,%rbx
 41a:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 41e:	8a 03                	mov    (%rbx),%al
 420:	84 c0                	test   %al,%al
 422:	0f 84 8e 00 00 00    	je     4b6 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 428:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 42c:	ba 01 00 00 00       	mov    $0x1,%edx
 431:	44 89 e7             	mov    %r12d,%edi
 434:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 437:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 43a:	e8 9c fd ff ff       	callq  1db <write>
 43f:	eb dd                	jmp    41e <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 441:	83 f8 63             	cmp    $0x63,%eax
 444:	75 32                	jne    478 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 446:	8b 55 98             	mov    -0x68(%rbp),%edx
 449:	83 fa 2f             	cmp    $0x2f,%edx
 44c:	77 0e                	ja     45c <printf+0x16e>
 44e:	89 d0                	mov    %edx,%eax
 450:	83 c2 08             	add    $0x8,%edx
 453:	48 03 45 a8          	add    -0x58(%rbp),%rax
 457:	89 55 98             	mov    %edx,-0x68(%rbp)
 45a:	eb 0c                	jmp    468 <printf+0x17a>
 45c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 460:	48 8d 50 08          	lea    0x8(%rax),%rdx
 464:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 468:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46a:	ba 01 00 00 00       	mov    $0x1,%edx
 46f:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 473:	88 45 94             	mov    %al,-0x6c(%rbp)
 476:	eb 36                	jmp    4ae <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	75 0f                	jne    48c <printf+0x19e>
 47d:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 481:	ba 01 00 00 00       	mov    $0x1,%edx
 486:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 48a:	eb 22                	jmp    4ae <printf+0x1c0>
 48c:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 490:	ba 01 00 00 00       	mov    $0x1,%edx
 495:	44 89 e7             	mov    %r12d,%edi
 498:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 49c:	e8 3a fd ff ff       	callq  1db <write>
 4a1:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 4a5:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 4a9:	ba 01 00 00 00       	mov    $0x1,%edx
 4ae:	44 89 e7             	mov    %r12d,%edi
 4b1:	e8 25 fd ff ff       	callq  1db <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b6:	31 db                	xor    %ebx,%ebx
 4b8:	eb 05                	jmp    4bf <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4ba:	bb 25 00 00 00       	mov    $0x25,%ebx
 4bf:	49 ff c6             	inc    %r14
 4c2:	e9 65 fe ff ff       	jmpq   32c <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c7:	48 83 c4 50          	add    $0x50,%rsp
 4cb:	5b                   	pop    %rbx
 4cc:	41 5c                	pop    %r12
 4ce:	41 5d                	pop    %r13
 4d0:	41 5e                	pop    %r14
 4d2:	5d                   	pop    %rbp
 4d3:	c3                   	retq   

00000000000004d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d4:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d5:	48 8b 05 b4 03 00 00 	mov    0x3b4(%rip),%rax        # 890 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4dc:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 4e0:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e3:	48 39 d0             	cmp    %rdx,%rax
 4e6:	48 8b 08             	mov    (%rax),%rcx
 4e9:	72 14                	jb     4ff <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4eb:	48 39 c8             	cmp    %rcx,%rax
 4ee:	72 0a                	jb     4fa <free+0x26>
 4f0:	48 39 ca             	cmp    %rcx,%rdx
 4f3:	72 0f                	jb     504 <free+0x30>
 4f5:	48 39 d0             	cmp    %rdx,%rax
 4f8:	72 0a                	jb     504 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 4fa:	48 89 c8             	mov    %rcx,%rax
 4fd:	eb e4                	jmp    4e3 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ff:	48 39 ca             	cmp    %rcx,%rdx
 502:	73 e7                	jae    4eb <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 504:	8b 77 f8             	mov    -0x8(%rdi),%esi
 507:	49 89 f0             	mov    %rsi,%r8
 50a:	48 c1 e6 04          	shl    $0x4,%rsi
 50e:	48 01 d6             	add    %rdx,%rsi
 511:	48 39 ce             	cmp    %rcx,%rsi
 514:	75 0e                	jne    524 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 516:	44 03 41 08          	add    0x8(%rcx),%r8d
 51a:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 51e:	48 8b 08             	mov    (%rax),%rcx
 521:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 524:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 528:	8b 48 08             	mov    0x8(%rax),%ecx
 52b:	48 89 ce             	mov    %rcx,%rsi
 52e:	48 c1 e1 04          	shl    $0x4,%rcx
 532:	48 01 c1             	add    %rax,%rcx
 535:	48 39 ca             	cmp    %rcx,%rdx
 538:	75 0a                	jne    544 <free+0x70>
    p->s.size += bp->s.size;
 53a:	03 77 f8             	add    -0x8(%rdi),%esi
 53d:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 540:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 544:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 547:	48 89 05 42 03 00 00 	mov    %rax,0x342(%rip)        # 890 <freep>
}
 54e:	5d                   	pop    %rbp
 54f:	c3                   	retq   

0000000000000550 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 550:	55                   	push   %rbp
 551:	48 89 e5             	mov    %rsp,%rbp
 554:	41 55                	push   %r13
 556:	41 54                	push   %r12
 558:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 559:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 55b:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 55c:	48 8b 0d 2d 03 00 00 	mov    0x32d(%rip),%rcx        # 890 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 563:	48 83 c3 0f          	add    $0xf,%rbx
 567:	48 c1 eb 04          	shr    $0x4,%rbx
 56b:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 56d:	48 85 c9             	test   %rcx,%rcx
 570:	75 27                	jne    599 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 572:	48 c7 05 13 03 00 00 	movq   $0x8a0,0x313(%rip)        # 890 <freep>
 579:	a0 08 00 00 
 57d:	48 c7 05 18 03 00 00 	movq   $0x8a0,0x318(%rip)        # 8a0 <base>
 584:	a0 08 00 00 
 588:	48 c7 c1 a0 08 00 00 	mov    $0x8a0,%rcx
    base.s.size = 0;
 58f:	c7 05 0f 03 00 00 00 	movl   $0x0,0x30f(%rip)        # 8a8 <base+0x8>
 596:	00 00 00 
 599:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 59f:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a5:	48 8b 01             	mov    (%rcx),%rax
 5a8:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5ac:	45 89 e5             	mov    %r12d,%r13d
 5af:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5b3:	8b 50 08             	mov    0x8(%rax),%edx
 5b6:	39 d3                	cmp    %edx,%ebx
 5b8:	77 26                	ja     5e0 <malloc+0x90>
      if(p->s.size == nunits)
 5ba:	75 08                	jne    5c4 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 5bc:	48 8b 10             	mov    (%rax),%rdx
 5bf:	48 89 11             	mov    %rdx,(%rcx)
 5c2:	eb 0f                	jmp    5d3 <malloc+0x83>
      else {
        p->s.size -= nunits;
 5c4:	29 da                	sub    %ebx,%edx
 5c6:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 5c9:	48 c1 e2 04          	shl    $0x4,%rdx
 5cd:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 5d0:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 5d3:	48 89 0d b6 02 00 00 	mov    %rcx,0x2b6(%rip)        # 890 <freep>
      return (void*)(p + 1);
 5da:	48 83 c0 10          	add    $0x10,%rax
 5de:	eb 3a                	jmp    61a <malloc+0xca>
    }
    if(p == freep)
 5e0:	48 3b 05 a9 02 00 00 	cmp    0x2a9(%rip),%rax        # 890 <freep>
 5e7:	75 27                	jne    610 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5e9:	44 89 ef             	mov    %r13d,%edi
 5ec:	e8 52 fc ff ff       	callq  243 <sbrk>
  if(p == (char*)-1)
 5f1:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 5f5:	74 21                	je     618 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 5f7:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5fb:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 5ff:	e8 d0 fe ff ff       	callq  4d4 <free>
  return freep;
 604:	48 8b 05 85 02 00 00 	mov    0x285(%rip),%rax        # 890 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 60b:	48 85 c0             	test   %rax,%rax
 60e:	74 08                	je     618 <malloc+0xc8>
        return 0;
  }
 610:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 613:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 616:	eb 9b                	jmp    5b3 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 618:	31 c0                	xor    %eax,%eax
  }
}
 61a:	5a                   	pop    %rdx
 61b:	5b                   	pop    %rbx
 61c:	41 5c                	pop    %r12
 61e:	41 5d                	pop    %r13
 620:	5d                   	pop    %rbp
 621:	c3                   	retq   
