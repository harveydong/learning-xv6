
.fs/zombie:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
  if(fork() > 0)
   4:	e8 70 01 00 00       	callq  179 <fork>
   9:	85 c0                	test   %eax,%eax
   b:	7e 0a                	jle    17 <main+0x17>
    sleep(5);  // Let child exit before parent.
   d:	bf 05 00 00 00       	mov    $0x5,%edi
  12:	e8 fa 01 00 00       	callq  211 <sleep>
  exit();
  17:	e8 65 01 00 00       	callq  181 <exit>

000000000000001c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  1c:	55                   	push   %rbp
  1d:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  20:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  22:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  25:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  28:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  2b:	48 ff c2             	inc    %rdx
  2e:	84 c9                	test   %cl,%cl
  30:	75 f3                	jne    25 <strcpy+0x9>
    ;
  return os;
}
  32:	5d                   	pop    %rbp
  33:	c3                   	retq   

0000000000000034 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  34:	55                   	push   %rbp
  35:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  38:	0f b6 07             	movzbl (%rdi),%eax
  3b:	84 c0                	test   %al,%al
  3d:	74 0c                	je     4b <strcmp+0x17>
  3f:	3a 06                	cmp    (%rsi),%al
  41:	75 08                	jne    4b <strcmp+0x17>
    p++, q++;
  43:	48 ff c7             	inc    %rdi
  46:	48 ff c6             	inc    %rsi
  49:	eb ed                	jmp    38 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  4b:	0f b6 16             	movzbl (%rsi),%edx
}
  4e:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  4f:	29 d0                	sub    %edx,%eax
}
  51:	c3                   	retq   

0000000000000052 <strlen>:

uint
strlen(const char *s)
{
  52:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  53:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  55:	48 89 e5             	mov    %rsp,%rbp
  58:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
  5c:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
  61:	74 05                	je     68 <strlen+0x16>
  63:	48 89 d0             	mov    %rdx,%rax
  66:	eb f0                	jmp    58 <strlen+0x6>
    ;
  return n;
}
  68:	5d                   	pop    %rbp
  69:	c3                   	retq   

000000000000006a <memset>:

void*
memset(void *dst, int c, uint n)
{
  6a:	55                   	push   %rbp
  6b:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  6e:	89 d1                	mov    %edx,%ecx
  70:	89 f0                	mov    %esi,%eax
  72:	48 89 e5             	mov    %rsp,%rbp
  75:	fc                   	cld    
  76:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
  78:	4c 89 c0             	mov    %r8,%rax
  7b:	5d                   	pop    %rbp
  7c:	c3                   	retq   

000000000000007d <strchr>:

char*
strchr(const char *s, char c)
{
  7d:	55                   	push   %rbp
  7e:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
  81:	8a 07                	mov    (%rdi),%al
  83:	84 c0                	test   %al,%al
  85:	74 0a                	je     91 <strchr+0x14>
    if(*s == c)
  87:	40 38 f0             	cmp    %sil,%al
  8a:	74 09                	je     95 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  8c:	48 ff c7             	inc    %rdi
  8f:	eb f0                	jmp    81 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
  91:	31 c0                	xor    %eax,%eax
  93:	eb 03                	jmp    98 <strchr+0x1b>
  95:	48 89 f8             	mov    %rdi,%rax
}
  98:	5d                   	pop    %rbp
  99:	c3                   	retq   

000000000000009a <gets>:

char*
gets(char *buf, int max)
{
  9a:	55                   	push   %rbp
  9b:	48 89 e5             	mov    %rsp,%rbp
  9e:	41 57                	push   %r15
  a0:	41 56                	push   %r14
  a2:	41 55                	push   %r13
  a4:	41 54                	push   %r12
  a6:	41 89 f7             	mov    %esi,%r15d
  a9:	53                   	push   %rbx
  aa:	49 89 fc             	mov    %rdi,%r12
  ad:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  b0:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
  b2:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  b6:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
  ba:	45 39 fd             	cmp    %r15d,%r13d
  bd:	7d 2c                	jge    eb <gets+0x51>
    cc = read(0, &c, 1);
  bf:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
  c3:	31 ff                	xor    %edi,%edi
  c5:	ba 01 00 00 00       	mov    $0x1,%edx
  ca:	e8 ca 00 00 00       	callq  199 <read>
    if(cc < 1)
  cf:	85 c0                	test   %eax,%eax
  d1:	7e 18                	jle    eb <gets+0x51>
      break;
    buf[i++] = c;
  d3:	8a 45 cf             	mov    -0x31(%rbp),%al
  d6:	49 ff c6             	inc    %r14
  d9:	49 63 dd             	movslq %r13d,%rbx
  dc:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
  e0:	3c 0a                	cmp    $0xa,%al
  e2:	74 04                	je     e8 <gets+0x4e>
  e4:	3c 0d                	cmp    $0xd,%al
  e6:	75 ce                	jne    b6 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e8:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  eb:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
  f0:	48 83 c4 18          	add    $0x18,%rsp
  f4:	4c 89 e0             	mov    %r12,%rax
  f7:	5b                   	pop    %rbx
  f8:	41 5c                	pop    %r12
  fa:	41 5d                	pop    %r13
  fc:	41 5e                	pop    %r14
  fe:	41 5f                	pop    %r15
 100:	5d                   	pop    %rbp
 101:	c3                   	retq   

0000000000000102 <stat>:

int
stat(const char *n, struct stat *st)
{
 102:	55                   	push   %rbp
 103:	48 89 e5             	mov    %rsp,%rbp
 106:	41 54                	push   %r12
 108:	53                   	push   %rbx
 109:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 10c:	31 f6                	xor    %esi,%esi
 10e:	e8 ae 00 00 00       	callq  1c1 <open>
 113:	41 89 c4             	mov    %eax,%r12d
 116:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 119:	45 85 e4             	test   %r12d,%r12d
 11c:	78 17                	js     135 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 11e:	48 89 de             	mov    %rbx,%rsi
 121:	44 89 e7             	mov    %r12d,%edi
 124:	e8 b0 00 00 00       	callq  1d9 <fstat>
  close(fd);
 129:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 12c:	89 c3                	mov    %eax,%ebx
  close(fd);
 12e:	e8 76 00 00 00       	callq  1a9 <close>
  return r;
 133:	89 d8                	mov    %ebx,%eax
}
 135:	5b                   	pop    %rbx
 136:	41 5c                	pop    %r12
 138:	5d                   	pop    %rbp
 139:	c3                   	retq   

000000000000013a <atoi>:

int
atoi(const char *s)
{
 13a:	55                   	push   %rbp
  int n;

  n = 0;
 13b:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 13d:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 140:	0f be 17             	movsbl (%rdi),%edx
 143:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 146:	80 f9 09             	cmp    $0x9,%cl
 149:	77 0c                	ja     157 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 14b:	6b c0 0a             	imul   $0xa,%eax,%eax
 14e:	48 ff c7             	inc    %rdi
 151:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 155:	eb e9                	jmp    140 <atoi+0x6>
  return n;
}
 157:	5d                   	pop    %rbp
 158:	c3                   	retq   

0000000000000159 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 159:	55                   	push   %rbp
 15a:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 15d:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 15f:	48 89 e5             	mov    %rsp,%rbp
 162:	89 d7                	mov    %edx,%edi
 164:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 166:	85 ff                	test   %edi,%edi
 168:	7e 0d                	jle    177 <memmove+0x1e>
    *dst++ = *src++;
 16a:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 16e:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 172:	48 ff c1             	inc    %rcx
 175:	eb eb                	jmp    162 <memmove+0x9>
  return vdst;
}
 177:	5d                   	pop    %rbp
 178:	c3                   	retq   

0000000000000179 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 179:	b8 01 00 00 00       	mov    $0x1,%eax
 17e:	cd 40                	int    $0x40
 180:	c3                   	retq   

0000000000000181 <exit>:
SYSCALL(exit)
 181:	b8 02 00 00 00       	mov    $0x2,%eax
 186:	cd 40                	int    $0x40
 188:	c3                   	retq   

0000000000000189 <wait>:
SYSCALL(wait)
 189:	b8 03 00 00 00       	mov    $0x3,%eax
 18e:	cd 40                	int    $0x40
 190:	c3                   	retq   

0000000000000191 <pipe>:
SYSCALL(pipe)
 191:	b8 04 00 00 00       	mov    $0x4,%eax
 196:	cd 40                	int    $0x40
 198:	c3                   	retq   

0000000000000199 <read>:
SYSCALL(read)
 199:	b8 05 00 00 00       	mov    $0x5,%eax
 19e:	cd 40                	int    $0x40
 1a0:	c3                   	retq   

00000000000001a1 <write>:
SYSCALL(write)
 1a1:	b8 10 00 00 00       	mov    $0x10,%eax
 1a6:	cd 40                	int    $0x40
 1a8:	c3                   	retq   

00000000000001a9 <close>:
SYSCALL(close)
 1a9:	b8 15 00 00 00       	mov    $0x15,%eax
 1ae:	cd 40                	int    $0x40
 1b0:	c3                   	retq   

00000000000001b1 <kill>:
SYSCALL(kill)
 1b1:	b8 06 00 00 00       	mov    $0x6,%eax
 1b6:	cd 40                	int    $0x40
 1b8:	c3                   	retq   

00000000000001b9 <exec>:
SYSCALL(exec)
 1b9:	b8 07 00 00 00       	mov    $0x7,%eax
 1be:	cd 40                	int    $0x40
 1c0:	c3                   	retq   

00000000000001c1 <open>:
SYSCALL(open)
 1c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 1c6:	cd 40                	int    $0x40
 1c8:	c3                   	retq   

00000000000001c9 <mknod>:
SYSCALL(mknod)
 1c9:	b8 11 00 00 00       	mov    $0x11,%eax
 1ce:	cd 40                	int    $0x40
 1d0:	c3                   	retq   

00000000000001d1 <unlink>:
SYSCALL(unlink)
 1d1:	b8 12 00 00 00       	mov    $0x12,%eax
 1d6:	cd 40                	int    $0x40
 1d8:	c3                   	retq   

00000000000001d9 <fstat>:
SYSCALL(fstat)
 1d9:	b8 08 00 00 00       	mov    $0x8,%eax
 1de:	cd 40                	int    $0x40
 1e0:	c3                   	retq   

00000000000001e1 <link>:
SYSCALL(link)
 1e1:	b8 13 00 00 00       	mov    $0x13,%eax
 1e6:	cd 40                	int    $0x40
 1e8:	c3                   	retq   

00000000000001e9 <mkdir>:
SYSCALL(mkdir)
 1e9:	b8 14 00 00 00       	mov    $0x14,%eax
 1ee:	cd 40                	int    $0x40
 1f0:	c3                   	retq   

00000000000001f1 <chdir>:
SYSCALL(chdir)
 1f1:	b8 09 00 00 00       	mov    $0x9,%eax
 1f6:	cd 40                	int    $0x40
 1f8:	c3                   	retq   

00000000000001f9 <dup>:
SYSCALL(dup)
 1f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 1fe:	cd 40                	int    $0x40
 200:	c3                   	retq   

0000000000000201 <getpid>:
SYSCALL(getpid)
 201:	b8 0b 00 00 00       	mov    $0xb,%eax
 206:	cd 40                	int    $0x40
 208:	c3                   	retq   

0000000000000209 <sbrk>:
SYSCALL(sbrk)
 209:	b8 0c 00 00 00       	mov    $0xc,%eax
 20e:	cd 40                	int    $0x40
 210:	c3                   	retq   

0000000000000211 <sleep>:
SYSCALL(sleep)
 211:	b8 0d 00 00 00       	mov    $0xd,%eax
 216:	cd 40                	int    $0x40
 218:	c3                   	retq   

0000000000000219 <uptime>:
SYSCALL(uptime)
 219:	b8 0e 00 00 00       	mov    $0xe,%eax
 21e:	cd 40                	int    $0x40
 220:	c3                   	retq   

0000000000000221 <chmod>:
SYSCALL(chmod)
 221:	b8 16 00 00 00       	mov    $0x16,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	retq   

0000000000000229 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 229:	55                   	push   %rbp
 22a:	41 89 d0             	mov    %edx,%r8d
 22d:	48 89 e5             	mov    %rsp,%rbp
 230:	41 54                	push   %r12
 232:	53                   	push   %rbx
 233:	41 89 fc             	mov    %edi,%r12d
 236:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 23a:	85 c9                	test   %ecx,%ecx
 23c:	74 12                	je     250 <printint+0x27>
 23e:	89 f0                	mov    %esi,%eax
 240:	c1 e8 1f             	shr    $0x1f,%eax
 243:	74 0b                	je     250 <printint+0x27>
    neg = 1;
    x = -xx;
 245:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 247:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 24c:	f7 d8                	neg    %eax
 24e:	eb 04                	jmp    254 <printint+0x2b>
  } else {
    x = xx;
 250:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 252:	31 f6                	xor    %esi,%esi
 254:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 258:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 25a:	31 d2                	xor    %edx,%edx
 25c:	48 ff c7             	inc    %rdi
 25f:	8d 59 01             	lea    0x1(%rcx),%ebx
 262:	41 f7 f0             	div    %r8d
 265:	89 d2                	mov    %edx,%edx
 267:	8a 92 00 06 00 00    	mov    0x600(%rdx),%dl
 26d:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 270:	85 c0                	test   %eax,%eax
 272:	74 04                	je     278 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 274:	89 d9                	mov    %ebx,%ecx
 276:	eb e2                	jmp    25a <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 278:	85 f6                	test   %esi,%esi
 27a:	74 0b                	je     287 <printint+0x5e>
    buf[i++] = '-';
 27c:	48 63 db             	movslq %ebx,%rbx
 27f:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 284:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 287:	ff cb                	dec    %ebx
 289:	83 fb ff             	cmp    $0xffffffff,%ebx
 28c:	74 1d                	je     2ab <printint+0x82>
    putc(fd, buf[i]);
 28e:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 291:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 295:	ba 01 00 00 00       	mov    $0x1,%edx
 29a:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 29e:	44 89 e7             	mov    %r12d,%edi
 2a1:	88 45 df             	mov    %al,-0x21(%rbp)
 2a4:	e8 f8 fe ff ff       	callq  1a1 <write>
 2a9:	eb dc                	jmp    287 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 2ab:	48 83 c4 20          	add    $0x20,%rsp
 2af:	5b                   	pop    %rbx
 2b0:	41 5c                	pop    %r12
 2b2:	5d                   	pop    %rbp
 2b3:	c3                   	retq   

00000000000002b4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2b4:	55                   	push   %rbp
 2b5:	48 89 e5             	mov    %rsp,%rbp
 2b8:	41 56                	push   %r14
 2ba:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2bc:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2c0:	41 54                	push   %r12
 2c2:	53                   	push   %rbx
 2c3:	41 89 fc             	mov    %edi,%r12d
 2c6:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 2c9:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2cb:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2cf:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 2d3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 2d7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 2db:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 2df:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 2e3:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 2e7:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 2ee:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 2f2:	45 8a 2e             	mov    (%r14),%r13b
 2f5:	45 84 ed             	test   %r13b,%r13b
 2f8:	0f 84 8f 01 00 00    	je     48d <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 2fe:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 300:	41 0f be d5          	movsbl %r13b,%edx
 304:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 308:	75 23                	jne    32d <printf+0x79>
      if(c == '%'){
 30a:	83 f8 25             	cmp    $0x25,%eax
 30d:	0f 84 6d 01 00 00    	je     480 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 313:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 317:	ba 01 00 00 00       	mov    $0x1,%edx
 31c:	44 89 e7             	mov    %r12d,%edi
 31f:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 323:	e8 79 fe ff ff       	callq  1a1 <write>
 328:	e9 58 01 00 00       	jmpq   485 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 32d:	83 fb 25             	cmp    $0x25,%ebx
 330:	0f 85 4f 01 00 00    	jne    485 <printf+0x1d1>
      if(c == 'd'){
 336:	83 f8 64             	cmp    $0x64,%eax
 339:	75 2e                	jne    369 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 33b:	8b 55 98             	mov    -0x68(%rbp),%edx
 33e:	83 fa 2f             	cmp    $0x2f,%edx
 341:	77 0e                	ja     351 <printf+0x9d>
 343:	89 d0                	mov    %edx,%eax
 345:	83 c2 08             	add    $0x8,%edx
 348:	48 03 45 a8          	add    -0x58(%rbp),%rax
 34c:	89 55 98             	mov    %edx,-0x68(%rbp)
 34f:	eb 0c                	jmp    35d <printf+0xa9>
 351:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 355:	48 8d 50 08          	lea    0x8(%rax),%rdx
 359:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 35d:	b9 01 00 00 00       	mov    $0x1,%ecx
 362:	ba 0a 00 00 00       	mov    $0xa,%edx
 367:	eb 34                	jmp    39d <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 369:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 36f:	83 fa 70             	cmp    $0x70,%edx
 372:	75 38                	jne    3ac <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 374:	8b 55 98             	mov    -0x68(%rbp),%edx
 377:	83 fa 2f             	cmp    $0x2f,%edx
 37a:	77 0e                	ja     38a <printf+0xd6>
 37c:	89 d0                	mov    %edx,%eax
 37e:	83 c2 08             	add    $0x8,%edx
 381:	48 03 45 a8          	add    -0x58(%rbp),%rax
 385:	89 55 98             	mov    %edx,-0x68(%rbp)
 388:	eb 0c                	jmp    396 <printf+0xe2>
 38a:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 38e:	48 8d 50 08          	lea    0x8(%rax),%rdx
 392:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 396:	31 c9                	xor    %ecx,%ecx
 398:	ba 10 00 00 00       	mov    $0x10,%edx
 39d:	8b 30                	mov    (%rax),%esi
 39f:	44 89 e7             	mov    %r12d,%edi
 3a2:	e8 82 fe ff ff       	callq  229 <printint>
 3a7:	e9 d0 00 00 00       	jmpq   47c <printf+0x1c8>
      } else if(c == 's'){
 3ac:	83 f8 73             	cmp    $0x73,%eax
 3af:	75 56                	jne    407 <printf+0x153>
        s = va_arg(ap, char*);
 3b1:	8b 55 98             	mov    -0x68(%rbp),%edx
 3b4:	83 fa 2f             	cmp    $0x2f,%edx
 3b7:	77 0e                	ja     3c7 <printf+0x113>
 3b9:	89 d0                	mov    %edx,%eax
 3bb:	83 c2 08             	add    $0x8,%edx
 3be:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3c2:	89 55 98             	mov    %edx,-0x68(%rbp)
 3c5:	eb 0c                	jmp    3d3 <printf+0x11f>
 3c7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3cb:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3cf:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 3d3:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 3d6:	48 c7 c0 f0 05 00 00 	mov    $0x5f0,%rax
 3dd:	48 85 db             	test   %rbx,%rbx
 3e0:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 3e4:	8a 03                	mov    (%rbx),%al
 3e6:	84 c0                	test   %al,%al
 3e8:	0f 84 8e 00 00 00    	je     47c <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3ee:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 3f2:	ba 01 00 00 00       	mov    $0x1,%edx
 3f7:	44 89 e7             	mov    %r12d,%edi
 3fa:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 3fd:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 400:	e8 9c fd ff ff       	callq  1a1 <write>
 405:	eb dd                	jmp    3e4 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 407:	83 f8 63             	cmp    $0x63,%eax
 40a:	75 32                	jne    43e <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 40c:	8b 55 98             	mov    -0x68(%rbp),%edx
 40f:	83 fa 2f             	cmp    $0x2f,%edx
 412:	77 0e                	ja     422 <printf+0x16e>
 414:	89 d0                	mov    %edx,%eax
 416:	83 c2 08             	add    $0x8,%edx
 419:	48 03 45 a8          	add    -0x58(%rbp),%rax
 41d:	89 55 98             	mov    %edx,-0x68(%rbp)
 420:	eb 0c                	jmp    42e <printf+0x17a>
 422:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 426:	48 8d 50 08          	lea    0x8(%rax),%rdx
 42a:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 42e:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 430:	ba 01 00 00 00       	mov    $0x1,%edx
 435:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 439:	88 45 94             	mov    %al,-0x6c(%rbp)
 43c:	eb 36                	jmp    474 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 43e:	83 f8 25             	cmp    $0x25,%eax
 441:	75 0f                	jne    452 <printf+0x19e>
 443:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 447:	ba 01 00 00 00       	mov    $0x1,%edx
 44c:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 450:	eb 22                	jmp    474 <printf+0x1c0>
 452:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 456:	ba 01 00 00 00       	mov    $0x1,%edx
 45b:	44 89 e7             	mov    %r12d,%edi
 45e:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 462:	e8 3a fd ff ff       	callq  1a1 <write>
 467:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 46b:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 46f:	ba 01 00 00 00       	mov    $0x1,%edx
 474:	44 89 e7             	mov    %r12d,%edi
 477:	e8 25 fd ff ff       	callq  1a1 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 47c:	31 db                	xor    %ebx,%ebx
 47e:	eb 05                	jmp    485 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 480:	bb 25 00 00 00       	mov    $0x25,%ebx
 485:	49 ff c6             	inc    %r14
 488:	e9 65 fe ff ff       	jmpq   2f2 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 48d:	48 83 c4 50          	add    $0x50,%rsp
 491:	5b                   	pop    %rbx
 492:	41 5c                	pop    %r12
 494:	41 5d                	pop    %r13
 496:	41 5e                	pop    %r14
 498:	5d                   	pop    %rbp
 499:	c3                   	retq   

000000000000049a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 49a:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 49b:	48 8b 05 9e 03 00 00 	mov    0x39e(%rip),%rax        # 840 <__bss_start>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4a2:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 4a6:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4a9:	48 39 d0             	cmp    %rdx,%rax
 4ac:	48 8b 08             	mov    (%rax),%rcx
 4af:	72 14                	jb     4c5 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4b1:	48 39 c8             	cmp    %rcx,%rax
 4b4:	72 0a                	jb     4c0 <free+0x26>
 4b6:	48 39 ca             	cmp    %rcx,%rdx
 4b9:	72 0f                	jb     4ca <free+0x30>
 4bb:	48 39 d0             	cmp    %rdx,%rax
 4be:	72 0a                	jb     4ca <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c0:	48 89 c8             	mov    %rcx,%rax
 4c3:	eb e4                	jmp    4a9 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c5:	48 39 ca             	cmp    %rcx,%rdx
 4c8:	73 e7                	jae    4b1 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ca:	8b 77 f8             	mov    -0x8(%rdi),%esi
 4cd:	49 89 f0             	mov    %rsi,%r8
 4d0:	48 c1 e6 04          	shl    $0x4,%rsi
 4d4:	48 01 d6             	add    %rdx,%rsi
 4d7:	48 39 ce             	cmp    %rcx,%rsi
 4da:	75 0e                	jne    4ea <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 4dc:	44 03 41 08          	add    0x8(%rcx),%r8d
 4e0:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 4e4:	48 8b 08             	mov    (%rax),%rcx
 4e7:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 4ea:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 4ee:	8b 48 08             	mov    0x8(%rax),%ecx
 4f1:	48 89 ce             	mov    %rcx,%rsi
 4f4:	48 c1 e1 04          	shl    $0x4,%rcx
 4f8:	48 01 c1             	add    %rax,%rcx
 4fb:	48 39 ca             	cmp    %rcx,%rdx
 4fe:	75 0a                	jne    50a <free+0x70>
    p->s.size += bp->s.size;
 500:	03 77 f8             	add    -0x8(%rdi),%esi
 503:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 506:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 50a:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 50d:	48 89 05 2c 03 00 00 	mov    %rax,0x32c(%rip)        # 840 <__bss_start>
}
 514:	5d                   	pop    %rbp
 515:	c3                   	retq   

0000000000000516 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 516:	55                   	push   %rbp
 517:	48 89 e5             	mov    %rsp,%rbp
 51a:	41 55                	push   %r13
 51c:	41 54                	push   %r12
 51e:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 51f:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 521:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 522:	48 8b 0d 17 03 00 00 	mov    0x317(%rip),%rcx        # 840 <__bss_start>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 529:	48 83 c3 0f          	add    $0xf,%rbx
 52d:	48 c1 eb 04          	shr    $0x4,%rbx
 531:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 533:	48 85 c9             	test   %rcx,%rcx
 536:	75 27                	jne    55f <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 538:	48 c7 05 fd 02 00 00 	movq   $0x850,0x2fd(%rip)        # 840 <__bss_start>
 53f:	50 08 00 00 
 543:	48 c7 05 02 03 00 00 	movq   $0x850,0x302(%rip)        # 850 <base>
 54a:	50 08 00 00 
 54e:	48 c7 c1 50 08 00 00 	mov    $0x850,%rcx
    base.s.size = 0;
 555:	c7 05 f9 02 00 00 00 	movl   $0x0,0x2f9(%rip)        # 858 <base+0x8>
 55c:	00 00 00 
 55f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 565:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 56b:	48 8b 01             	mov    (%rcx),%rax
 56e:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 572:	45 89 e5             	mov    %r12d,%r13d
 575:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 579:	8b 50 08             	mov    0x8(%rax),%edx
 57c:	39 d3                	cmp    %edx,%ebx
 57e:	77 26                	ja     5a6 <malloc+0x90>
      if(p->s.size == nunits)
 580:	75 08                	jne    58a <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 582:	48 8b 10             	mov    (%rax),%rdx
 585:	48 89 11             	mov    %rdx,(%rcx)
 588:	eb 0f                	jmp    599 <malloc+0x83>
      else {
        p->s.size -= nunits;
 58a:	29 da                	sub    %ebx,%edx
 58c:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 58f:	48 c1 e2 04          	shl    $0x4,%rdx
 593:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 596:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 599:	48 89 0d a0 02 00 00 	mov    %rcx,0x2a0(%rip)        # 840 <__bss_start>
      return (void*)(p + 1);
 5a0:	48 83 c0 10          	add    $0x10,%rax
 5a4:	eb 3a                	jmp    5e0 <malloc+0xca>
    }
    if(p == freep)
 5a6:	48 3b 05 93 02 00 00 	cmp    0x293(%rip),%rax        # 840 <__bss_start>
 5ad:	75 27                	jne    5d6 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5af:	44 89 ef             	mov    %r13d,%edi
 5b2:	e8 52 fc ff ff       	callq  209 <sbrk>
  if(p == (char*)-1)
 5b7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 5bb:	74 21                	je     5de <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 5bd:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5c1:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 5c5:	e8 d0 fe ff ff       	callq  49a <free>
  return freep;
 5ca:	48 8b 05 6f 02 00 00 	mov    0x26f(%rip),%rax        # 840 <__bss_start>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 5d1:	48 85 c0             	test   %rax,%rax
 5d4:	74 08                	je     5de <malloc+0xc8>
        return 0;
  }
 5d6:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d9:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 5dc:	eb 9b                	jmp    579 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 5de:	31 c0                	xor    %eax,%eax
  }
}
 5e0:	5a                   	pop    %rdx
 5e1:	5b                   	pop    %rbx
 5e2:	41 5c                	pop    %r12
 5e4:	41 5d                	pop    %r13
 5e6:	5d                   	pop    %rbp
 5e7:	c3                   	retq   
