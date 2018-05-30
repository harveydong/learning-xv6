
.fs/kill:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %rbp
  int i;

  if(argc < 2){
   1:	83 ff 01             	cmp    $0x1,%edi
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	41 55                	push   %r13
   9:	41 54                	push   %r12
   b:	53                   	push   %rbx
   c:	50                   	push   %rax
  int i;

  if(argc < 2){
   d:	7f 15                	jg     24 <main+0x24>
    printf(2, "usage: kill pid...\n");
   f:	48 c7 c6 20 06 00 00 	mov    $0x620,%rsi
  16:	bf 02 00 00 00       	mov    $0x2,%edi
  1b:	31 c0                	xor    %eax,%eax
  1d:	e8 c4 02 00 00       	callq  2e6 <printf>
  22:	eb 25                	jmp    49 <main+0x49>
  24:	44 8d 67 fe          	lea    -0x2(%rdi),%r12d
  28:	49 89 f5             	mov    %rsi,%r13
int
main(int argc, char **argv)
{
  int i;

  if(argc < 2){
  2b:	31 db                	xor    %ebx,%ebx
  2d:	49 ff c4             	inc    %r12
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  30:	49 8b 7c dd 08       	mov    0x8(%r13,%rbx,8),%rdi
  35:	48 ff c3             	inc    %rbx
  38:	e8 2f 01 00 00       	callq  16c <atoi>
  3d:	89 c7                	mov    %eax,%edi
  3f:	e8 9f 01 00 00       	callq  1e3 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  44:	49 39 dc             	cmp    %rbx,%r12
  47:	75 e7                	jne    30 <main+0x30>
    kill(atoi(argv[i]));
  exit();
  49:	e8 65 01 00 00       	callq  1b3 <exit>

000000000000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  4e:	55                   	push   %rbp
  4f:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  52:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  54:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  57:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  5a:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  5d:	48 ff c2             	inc    %rdx
  60:	84 c9                	test   %cl,%cl
  62:	75 f3                	jne    57 <strcpy+0x9>
    ;
  return os;
}
  64:	5d                   	pop    %rbp
  65:	c3                   	retq   

0000000000000066 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  66:	55                   	push   %rbp
  67:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  6a:	0f b6 07             	movzbl (%rdi),%eax
  6d:	84 c0                	test   %al,%al
  6f:	74 0c                	je     7d <strcmp+0x17>
  71:	3a 06                	cmp    (%rsi),%al
  73:	75 08                	jne    7d <strcmp+0x17>
    p++, q++;
  75:	48 ff c7             	inc    %rdi
  78:	48 ff c6             	inc    %rsi
  7b:	eb ed                	jmp    6a <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  7d:	0f b6 16             	movzbl (%rsi),%edx
}
  80:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  81:	29 d0                	sub    %edx,%eax
}
  83:	c3                   	retq   

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  85:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  87:	48 89 e5             	mov    %rsp,%rbp
  8a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
  8e:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
  93:	74 05                	je     9a <strlen+0x16>
  95:	48 89 d0             	mov    %rdx,%rax
  98:	eb f0                	jmp    8a <strlen+0x6>
    ;
  return n;
}
  9a:	5d                   	pop    %rbp
  9b:	c3                   	retq   

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	55                   	push   %rbp
  9d:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a0:	89 d1                	mov    %edx,%ecx
  a2:	89 f0                	mov    %esi,%eax
  a4:	48 89 e5             	mov    %rsp,%rbp
  a7:	fc                   	cld    
  a8:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  aa:	4c 89 c0             	mov    %r8,%rax
  ad:	5d                   	pop    %rbp
  ae:	c3                   	retq   

00000000000000af <strchr>:

char*
strchr(const char *s, char c)
{
  af:	55                   	push   %rbp
  b0:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
  b3:	8a 07                	mov    (%rdi),%al
  b5:	84 c0                	test   %al,%al
  b7:	74 0a                	je     c3 <strchr+0x14>
    if(*s == c)
  b9:	40 38 f0             	cmp    %sil,%al
  bc:	74 09                	je     c7 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  be:	48 ff c7             	inc    %rdi
  c1:	eb f0                	jmp    b3 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
  c3:	31 c0                	xor    %eax,%eax
  c5:	eb 03                	jmp    ca <strchr+0x1b>
  c7:	48 89 f8             	mov    %rdi,%rax
}
  ca:	5d                   	pop    %rbp
  cb:	c3                   	retq   

00000000000000cc <gets>:

char*
gets(char *buf, int max)
{
  cc:	55                   	push   %rbp
  cd:	48 89 e5             	mov    %rsp,%rbp
  d0:	41 57                	push   %r15
  d2:	41 56                	push   %r14
  d4:	41 55                	push   %r13
  d6:	41 54                	push   %r12
  d8:	41 89 f7             	mov    %esi,%r15d
  db:	53                   	push   %rbx
  dc:	49 89 fc             	mov    %rdi,%r12
  df:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e2:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
  e4:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e8:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  ec:	45 39 fd             	cmp    %r15d,%r13d
  ef:	7d 2c                	jge    11d <gets+0x51>
    cc = read(0, &c, 1);
  f1:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  f5:	31 ff                	xor    %edi,%edi
  f7:	ba 01 00 00 00       	mov    $0x1,%edx
  fc:	e8 ca 00 00 00       	callq  1cb <read>
    if(cc < 1)
 101:	85 c0                	test   %eax,%eax
 103:	7e 18                	jle    11d <gets+0x51>
      break;
    buf[i++] = c;
 105:	8a 45 cf             	mov    -0x31(%rbp),%al
 108:	49 ff c6             	inc    %r14
 10b:	49 63 dd             	movslq %r13d,%rbx
 10e:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 112:	3c 0a                	cmp    $0xa,%al
 114:	74 04                	je     11a <gets+0x4e>
 116:	3c 0d                	cmp    $0xd,%al
 118:	75 ce                	jne    e8 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11a:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 11d:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 122:	48 83 c4 18          	add    $0x18,%rsp
 126:	4c 89 e0             	mov    %r12,%rax
 129:	5b                   	pop    %rbx
 12a:	41 5c                	pop    %r12
 12c:	41 5d                	pop    %r13
 12e:	41 5e                	pop    %r14
 130:	41 5f                	pop    %r15
 132:	5d                   	pop    %rbp
 133:	c3                   	retq   

0000000000000134 <stat>:

int
stat(const char *n, struct stat *st)
{
 134:	55                   	push   %rbp
 135:	48 89 e5             	mov    %rsp,%rbp
 138:	41 54                	push   %r12
 13a:	53                   	push   %rbx
 13b:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13e:	31 f6                	xor    %esi,%esi
 140:	e8 ae 00 00 00       	callq  1f3 <open>
 145:	41 89 c4             	mov    %eax,%r12d
 148:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 14b:	45 85 e4             	test   %r12d,%r12d
 14e:	78 17                	js     167 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 150:	48 89 de             	mov    %rbx,%rsi
 153:	44 89 e7             	mov    %r12d,%edi
 156:	e8 b0 00 00 00       	callq  20b <fstat>
  close(fd);
 15b:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 15e:	89 c3                	mov    %eax,%ebx
  close(fd);
 160:	e8 76 00 00 00       	callq  1db <close>
  return r;
 165:	89 d8                	mov    %ebx,%eax
}
 167:	5b                   	pop    %rbx
 168:	41 5c                	pop    %r12
 16a:	5d                   	pop    %rbp
 16b:	c3                   	retq   

000000000000016c <atoi>:

int
atoi(const char *s)
{
 16c:	55                   	push   %rbp
  int n;

  n = 0;
 16d:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 16f:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 172:	0f be 17             	movsbl (%rdi),%edx
 175:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 178:	80 f9 09             	cmp    $0x9,%cl
 17b:	77 0c                	ja     189 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 17d:	6b c0 0a             	imul   $0xa,%eax,%eax
 180:	48 ff c7             	inc    %rdi
 183:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 187:	eb e9                	jmp    172 <atoi+0x6>
  return n;
}
 189:	5d                   	pop    %rbp
 18a:	c3                   	retq   

000000000000018b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 18b:	55                   	push   %rbp
 18c:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 18f:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 191:	48 89 e5             	mov    %rsp,%rbp
 194:	89 d7                	mov    %edx,%edi
 196:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 198:	85 ff                	test   %edi,%edi
 19a:	7e 0d                	jle    1a9 <memmove+0x1e>
    *dst++ = *src++;
 19c:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 1a0:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 1a4:	48 ff c1             	inc    %rcx
 1a7:	eb eb                	jmp    194 <memmove+0x9>
  return vdst;
}
 1a9:	5d                   	pop    %rbp
 1aa:	c3                   	retq   

00000000000001ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ab:	b8 01 00 00 00       	mov    $0x1,%eax
 1b0:	cd 40                	int    $0x40
 1b2:	c3                   	retq   

00000000000001b3 <exit>:
SYSCALL(exit)
 1b3:	b8 02 00 00 00       	mov    $0x2,%eax
 1b8:	cd 40                	int    $0x40
 1ba:	c3                   	retq   

00000000000001bb <wait>:
SYSCALL(wait)
 1bb:	b8 03 00 00 00       	mov    $0x3,%eax
 1c0:	cd 40                	int    $0x40
 1c2:	c3                   	retq   

00000000000001c3 <pipe>:
SYSCALL(pipe)
 1c3:	b8 04 00 00 00       	mov    $0x4,%eax
 1c8:	cd 40                	int    $0x40
 1ca:	c3                   	retq   

00000000000001cb <read>:
SYSCALL(read)
 1cb:	b8 05 00 00 00       	mov    $0x5,%eax
 1d0:	cd 40                	int    $0x40
 1d2:	c3                   	retq   

00000000000001d3 <write>:
SYSCALL(write)
 1d3:	b8 10 00 00 00       	mov    $0x10,%eax
 1d8:	cd 40                	int    $0x40
 1da:	c3                   	retq   

00000000000001db <close>:
SYSCALL(close)
 1db:	b8 15 00 00 00       	mov    $0x15,%eax
 1e0:	cd 40                	int    $0x40
 1e2:	c3                   	retq   

00000000000001e3 <kill>:
SYSCALL(kill)
 1e3:	b8 06 00 00 00       	mov    $0x6,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	retq   

00000000000001eb <exec>:
SYSCALL(exec)
 1eb:	b8 07 00 00 00       	mov    $0x7,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	retq   

00000000000001f3 <open>:
SYSCALL(open)
 1f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	retq   

00000000000001fb <mknod>:
SYSCALL(mknod)
 1fb:	b8 11 00 00 00       	mov    $0x11,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	retq   

0000000000000203 <unlink>:
SYSCALL(unlink)
 203:	b8 12 00 00 00       	mov    $0x12,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	retq   

000000000000020b <fstat>:
SYSCALL(fstat)
 20b:	b8 08 00 00 00       	mov    $0x8,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	retq   

0000000000000213 <link>:
SYSCALL(link)
 213:	b8 13 00 00 00       	mov    $0x13,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	retq   

000000000000021b <mkdir>:
SYSCALL(mkdir)
 21b:	b8 14 00 00 00       	mov    $0x14,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	retq   

0000000000000223 <chdir>:
SYSCALL(chdir)
 223:	b8 09 00 00 00       	mov    $0x9,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	retq   

000000000000022b <dup>:
SYSCALL(dup)
 22b:	b8 0a 00 00 00       	mov    $0xa,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	retq   

0000000000000233 <getpid>:
SYSCALL(getpid)
 233:	b8 0b 00 00 00       	mov    $0xb,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	retq   

000000000000023b <sbrk>:
SYSCALL(sbrk)
 23b:	b8 0c 00 00 00       	mov    $0xc,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	retq   

0000000000000243 <sleep>:
SYSCALL(sleep)
 243:	b8 0d 00 00 00       	mov    $0xd,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	retq   

000000000000024b <uptime>:
SYSCALL(uptime)
 24b:	b8 0e 00 00 00       	mov    $0xe,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	retq   

0000000000000253 <chmod>:
SYSCALL(chmod)
 253:	b8 16 00 00 00       	mov    $0x16,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	retq   

000000000000025b <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 25b:	55                   	push   %rbp
 25c:	41 89 d0             	mov    %edx,%r8d
 25f:	48 89 e5             	mov    %rsp,%rbp
 262:	41 54                	push   %r12
 264:	53                   	push   %rbx
 265:	41 89 fc             	mov    %edi,%r12d
 268:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 26c:	85 c9                	test   %ecx,%ecx
 26e:	74 12                	je     282 <printint+0x27>
 270:	89 f0                	mov    %esi,%eax
 272:	c1 e8 1f             	shr    $0x1f,%eax
 275:	74 0b                	je     282 <printint+0x27>
    neg = 1;
    x = -xx;
 277:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 279:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 27e:	f7 d8                	neg    %eax
 280:	eb 04                	jmp    286 <printint+0x2b>
  } else {
    x = xx;
 282:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 284:	31 f6                	xor    %esi,%esi
 286:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 28a:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 28c:	31 d2                	xor    %edx,%edx
 28e:	48 ff c7             	inc    %rdi
 291:	8d 59 01             	lea    0x1(%rcx),%ebx
 294:	41 f7 f0             	div    %r8d
 297:	89 d2                	mov    %edx,%edx
 299:	8a 92 40 06 00 00    	mov    0x640(%rdx),%dl
 29f:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 2a2:	85 c0                	test   %eax,%eax
 2a4:	74 04                	je     2aa <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 2a6:	89 d9                	mov    %ebx,%ecx
 2a8:	eb e2                	jmp    28c <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 2aa:	85 f6                	test   %esi,%esi
 2ac:	74 0b                	je     2b9 <printint+0x5e>
    buf[i++] = '-';
 2ae:	48 63 db             	movslq %ebx,%rbx
 2b1:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 2b6:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 2b9:	ff cb                	dec    %ebx
 2bb:	83 fb ff             	cmp    $0xffffffff,%ebx
 2be:	74 1d                	je     2dd <printint+0x82>
    putc(fd, buf[i]);
 2c0:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 2c3:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 2c7:	ba 01 00 00 00       	mov    $0x1,%edx
 2cc:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 2d0:	44 89 e7             	mov    %r12d,%edi
 2d3:	88 45 df             	mov    %al,-0x21(%rbp)
 2d6:	e8 f8 fe ff ff       	callq  1d3 <write>
 2db:	eb dc                	jmp    2b9 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 2dd:	48 83 c4 20          	add    $0x20,%rsp
 2e1:	5b                   	pop    %rbx
 2e2:	41 5c                	pop    %r12
 2e4:	5d                   	pop    %rbp
 2e5:	c3                   	retq   

00000000000002e6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2e6:	55                   	push   %rbp
 2e7:	48 89 e5             	mov    %rsp,%rbp
 2ea:	41 56                	push   %r14
 2ec:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2f2:	41 54                	push   %r12
 2f4:	53                   	push   %rbx
 2f5:	41 89 fc             	mov    %edi,%r12d
 2f8:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 2fb:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2fd:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 301:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 305:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 309:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 30d:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 311:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 315:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 319:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 320:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 324:	45 8a 2e             	mov    (%r14),%r13b
 327:	45 84 ed             	test   %r13b,%r13b
 32a:	0f 84 8f 01 00 00    	je     4bf <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 330:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 332:	41 0f be d5          	movsbl %r13b,%edx
 336:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 33a:	75 23                	jne    35f <printf+0x79>
      if(c == '%'){
 33c:	83 f8 25             	cmp    $0x25,%eax
 33f:	0f 84 6d 01 00 00    	je     4b2 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 345:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 349:	ba 01 00 00 00       	mov    $0x1,%edx
 34e:	44 89 e7             	mov    %r12d,%edi
 351:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 355:	e8 79 fe ff ff       	callq  1d3 <write>
 35a:	e9 58 01 00 00       	jmpq   4b7 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 35f:	83 fb 25             	cmp    $0x25,%ebx
 362:	0f 85 4f 01 00 00    	jne    4b7 <printf+0x1d1>
      if(c == 'd'){
 368:	83 f8 64             	cmp    $0x64,%eax
 36b:	75 2e                	jne    39b <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 36d:	8b 55 98             	mov    -0x68(%rbp),%edx
 370:	83 fa 2f             	cmp    $0x2f,%edx
 373:	77 0e                	ja     383 <printf+0x9d>
 375:	89 d0                	mov    %edx,%eax
 377:	83 c2 08             	add    $0x8,%edx
 37a:	48 03 45 a8          	add    -0x58(%rbp),%rax
 37e:	89 55 98             	mov    %edx,-0x68(%rbp)
 381:	eb 0c                	jmp    38f <printf+0xa9>
 383:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 387:	48 8d 50 08          	lea    0x8(%rax),%rdx
 38b:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 38f:	b9 01 00 00 00       	mov    $0x1,%ecx
 394:	ba 0a 00 00 00       	mov    $0xa,%edx
 399:	eb 34                	jmp    3cf <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 39b:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3a1:	83 fa 70             	cmp    $0x70,%edx
 3a4:	75 38                	jne    3de <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 3a6:	8b 55 98             	mov    -0x68(%rbp),%edx
 3a9:	83 fa 2f             	cmp    $0x2f,%edx
 3ac:	77 0e                	ja     3bc <printf+0xd6>
 3ae:	89 d0                	mov    %edx,%eax
 3b0:	83 c2 08             	add    $0x8,%edx
 3b3:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3b7:	89 55 98             	mov    %edx,-0x68(%rbp)
 3ba:	eb 0c                	jmp    3c8 <printf+0xe2>
 3bc:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3c0:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3c4:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3c8:	31 c9                	xor    %ecx,%ecx
 3ca:	ba 10 00 00 00       	mov    $0x10,%edx
 3cf:	8b 30                	mov    (%rax),%esi
 3d1:	44 89 e7             	mov    %r12d,%edi
 3d4:	e8 82 fe ff ff       	callq  25b <printint>
 3d9:	e9 d0 00 00 00       	jmpq   4ae <printf+0x1c8>
      } else if(c == 's'){
 3de:	83 f8 73             	cmp    $0x73,%eax
 3e1:	75 56                	jne    439 <printf+0x153>
        s = va_arg(ap, char*);
 3e3:	8b 55 98             	mov    -0x68(%rbp),%edx
 3e6:	83 fa 2f             	cmp    $0x2f,%edx
 3e9:	77 0e                	ja     3f9 <printf+0x113>
 3eb:	89 d0                	mov    %edx,%eax
 3ed:	83 c2 08             	add    $0x8,%edx
 3f0:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3f4:	89 55 98             	mov    %edx,-0x68(%rbp)
 3f7:	eb 0c                	jmp    405 <printf+0x11f>
 3f9:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3fd:	48 8d 50 08          	lea    0x8(%rax),%rdx
 401:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 405:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 408:	48 c7 c0 34 06 00 00 	mov    $0x634,%rax
 40f:	48 85 db             	test   %rbx,%rbx
 412:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 416:	8a 03                	mov    (%rbx),%al
 418:	84 c0                	test   %al,%al
 41a:	0f 84 8e 00 00 00    	je     4ae <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 420:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 424:	ba 01 00 00 00       	mov    $0x1,%edx
 429:	44 89 e7             	mov    %r12d,%edi
 42c:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 42f:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 432:	e8 9c fd ff ff       	callq  1d3 <write>
 437:	eb dd                	jmp    416 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 439:	83 f8 63             	cmp    $0x63,%eax
 43c:	75 32                	jne    470 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 43e:	8b 55 98             	mov    -0x68(%rbp),%edx
 441:	83 fa 2f             	cmp    $0x2f,%edx
 444:	77 0e                	ja     454 <printf+0x16e>
 446:	89 d0                	mov    %edx,%eax
 448:	83 c2 08             	add    $0x8,%edx
 44b:	48 03 45 a8          	add    -0x58(%rbp),%rax
 44f:	89 55 98             	mov    %edx,-0x68(%rbp)
 452:	eb 0c                	jmp    460 <printf+0x17a>
 454:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 458:	48 8d 50 08          	lea    0x8(%rax),%rdx
 45c:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 460:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 462:	ba 01 00 00 00       	mov    $0x1,%edx
 467:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 46b:	88 45 94             	mov    %al,-0x6c(%rbp)
 46e:	eb 36                	jmp    4a6 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 470:	83 f8 25             	cmp    $0x25,%eax
 473:	75 0f                	jne    484 <printf+0x19e>
 475:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 479:	ba 01 00 00 00       	mov    $0x1,%edx
 47e:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 482:	eb 22                	jmp    4a6 <printf+0x1c0>
 484:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 488:	ba 01 00 00 00       	mov    $0x1,%edx
 48d:	44 89 e7             	mov    %r12d,%edi
 490:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 494:	e8 3a fd ff ff       	callq  1d3 <write>
 499:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 49d:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 4a1:	ba 01 00 00 00       	mov    $0x1,%edx
 4a6:	44 89 e7             	mov    %r12d,%edi
 4a9:	e8 25 fd ff ff       	callq  1d3 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ae:	31 db                	xor    %ebx,%ebx
 4b0:	eb 05                	jmp    4b7 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4b2:	bb 25 00 00 00       	mov    $0x25,%ebx
 4b7:	49 ff c6             	inc    %r14
 4ba:	e9 65 fe ff ff       	jmpq   324 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4bf:	48 83 c4 50          	add    $0x50,%rsp
 4c3:	5b                   	pop    %rbx
 4c4:	41 5c                	pop    %r12
 4c6:	41 5d                	pop    %r13
 4c8:	41 5e                	pop    %r14
 4ca:	5d                   	pop    %rbp
 4cb:	c3                   	retq   

00000000000004cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4cc:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4cd:	48 8b 05 ac 03 00 00 	mov    0x3ac(%rip),%rax        # 880 <__bss_start>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d4:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d8:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4db:	48 39 d0             	cmp    %rdx,%rax
 4de:	48 8b 08             	mov    (%rax),%rcx
 4e1:	72 14                	jb     4f7 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e3:	48 39 c8             	cmp    %rcx,%rax
 4e6:	72 0a                	jb     4f2 <free+0x26>
 4e8:	48 39 ca             	cmp    %rcx,%rdx
 4eb:	72 0f                	jb     4fc <free+0x30>
 4ed:	48 39 d0             	cmp    %rdx,%rax
 4f0:	72 0a                	jb     4fc <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 4f2:	48 89 c8             	mov    %rcx,%rax
 4f5:	eb e4                	jmp    4db <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4f7:	48 39 ca             	cmp    %rcx,%rdx
 4fa:	73 e7                	jae    4e3 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fc:	8b 77 f8             	mov    -0x8(%rdi),%esi
 4ff:	49 89 f0             	mov    %rsi,%r8
 502:	48 c1 e6 04          	shl    $0x4,%rsi
 506:	48 01 d6             	add    %rdx,%rsi
 509:	48 39 ce             	cmp    %rcx,%rsi
 50c:	75 0e                	jne    51c <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 50e:	44 03 41 08          	add    0x8(%rcx),%r8d
 512:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 516:	48 8b 08             	mov    (%rax),%rcx
 519:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 51c:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 520:	8b 48 08             	mov    0x8(%rax),%ecx
 523:	48 89 ce             	mov    %rcx,%rsi
 526:	48 c1 e1 04          	shl    $0x4,%rcx
 52a:	48 01 c1             	add    %rax,%rcx
 52d:	48 39 ca             	cmp    %rcx,%rdx
 530:	75 0a                	jne    53c <free+0x70>
    p->s.size += bp->s.size;
 532:	03 77 f8             	add    -0x8(%rdi),%esi
 535:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 538:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 53c:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 53f:	48 89 05 3a 03 00 00 	mov    %rax,0x33a(%rip)        # 880 <__bss_start>
}
 546:	5d                   	pop    %rbp
 547:	c3                   	retq   

0000000000000548 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 548:	55                   	push   %rbp
 549:	48 89 e5             	mov    %rsp,%rbp
 54c:	41 55                	push   %r13
 54e:	41 54                	push   %r12
 550:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 551:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 553:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 554:	48 8b 0d 25 03 00 00 	mov    0x325(%rip),%rcx        # 880 <__bss_start>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 55b:	48 83 c3 0f          	add    $0xf,%rbx
 55f:	48 c1 eb 04          	shr    $0x4,%rbx
 563:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 565:	48 85 c9             	test   %rcx,%rcx
 568:	75 27                	jne    591 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 56a:	48 c7 05 0b 03 00 00 	movq   $0x890,0x30b(%rip)        # 880 <__bss_start>
 571:	90 08 00 00 
 575:	48 c7 05 10 03 00 00 	movq   $0x890,0x310(%rip)        # 890 <base>
 57c:	90 08 00 00 
 580:	48 c7 c1 90 08 00 00 	mov    $0x890,%rcx
    base.s.size = 0;
 587:	c7 05 07 03 00 00 00 	movl   $0x0,0x307(%rip)        # 898 <base+0x8>
 58e:	00 00 00 
 591:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 597:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 59d:	48 8b 01             	mov    (%rcx),%rax
 5a0:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5a4:	45 89 e5             	mov    %r12d,%r13d
 5a7:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 5ab:	8b 50 08             	mov    0x8(%rax),%edx
 5ae:	39 d3                	cmp    %edx,%ebx
 5b0:	77 26                	ja     5d8 <malloc+0x90>
      if(p->s.size == nunits)
 5b2:	75 08                	jne    5bc <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 5b4:	48 8b 10             	mov    (%rax),%rdx
 5b7:	48 89 11             	mov    %rdx,(%rcx)
 5ba:	eb 0f                	jmp    5cb <malloc+0x83>
      else {
        p->s.size -= nunits;
 5bc:	29 da                	sub    %ebx,%edx
 5be:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 5c1:	48 c1 e2 04          	shl    $0x4,%rdx
 5c5:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 5c8:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 5cb:	48 89 0d ae 02 00 00 	mov    %rcx,0x2ae(%rip)        # 880 <__bss_start>
      return (void*)(p + 1);
 5d2:	48 83 c0 10          	add    $0x10,%rax
 5d6:	eb 3a                	jmp    612 <malloc+0xca>
    }
    if(p == freep)
 5d8:	48 3b 05 a1 02 00 00 	cmp    0x2a1(%rip),%rax        # 880 <__bss_start>
 5df:	75 27                	jne    608 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5e1:	44 89 ef             	mov    %r13d,%edi
 5e4:	e8 52 fc ff ff       	callq  23b <sbrk>
  if(p == (char*)-1)
 5e9:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 5ed:	74 21                	je     610 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 5ef:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5f3:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 5f7:	e8 d0 fe ff ff       	callq  4cc <free>
  return freep;
 5fc:	48 8b 05 7d 02 00 00 	mov    0x27d(%rip),%rax        # 880 <__bss_start>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 603:	48 85 c0             	test   %rax,%rax
 606:	74 08                	je     610 <malloc+0xc8>
        return 0;
  }
 608:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60b:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 60e:	eb 9b                	jmp    5ab <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 610:	31 c0                	xor    %eax,%eax
  }
}
 612:	5a                   	pop    %rdx
 613:	5b                   	pop    %rbx
 614:	41 5c                	pop    %r12
 616:	41 5d                	pop    %r13
 618:	5d                   	pop    %rbp
 619:	c3                   	retq   
