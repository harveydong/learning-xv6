
.fs/cat:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int fd, i;

  if(argc <= 1){
   1:	83 ff 01             	cmp    $0x1,%edi
  }
}

int
main(int argc, char *argv[])
{
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	41 56                	push   %r14
   9:	41 55                	push   %r13
   b:	41 54                	push   %r12
   d:	53                   	push   %rbx
  int fd, i;

  if(argc <= 1){
   e:	7f 09                	jg     19 <main+0x19>
    cat(0);
  10:	31 ff                	xor    %edi,%edi
  12:	e8 58 00 00 00       	callq  6f <cat>
  17:	eb 34                	jmp    4d <main+0x4d>
  19:	48 8d 5e 08          	lea    0x8(%rsi),%rbx
  1d:	41 89 fe             	mov    %edi,%r14d
int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
  20:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  26:	48 8b 3b             	mov    (%rbx),%rdi
  29:	31 f6                	xor    %esi,%esi
  2b:	e8 37 02 00 00       	callq  267 <open>
  30:	85 c0                	test   %eax,%eax
  32:	41 89 c5             	mov    %eax,%r13d
  35:	79 1b                	jns    52 <main+0x52>
      printf(1, "cat: cannot open %s\n", argv[i]);
  37:	48 8b 13             	mov    (%rbx),%rdx
  3a:	48 c7 c6 a1 06 00 00 	mov    $0x6a1,%rsi
  41:	bf 01 00 00 00       	mov    $0x1,%edi
  46:	31 c0                	xor    %eax,%eax
  48:	e8 0d 03 00 00       	callq  35a <printf>
      exit();
  4d:	e8 d5 01 00 00       	callq  227 <exit>
    }
    cat(fd);
  52:	89 c7                	mov    %eax,%edi
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  54:	41 ff c4             	inc    %r12d
  57:	48 83 c3 08          	add    $0x8,%rbx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  5b:	e8 0f 00 00 00       	callq  6f <cat>
    close(fd);
  60:	44 89 ef             	mov    %r13d,%edi
  63:	e8 e7 01 00 00       	callq  24f <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  68:	45 39 e6             	cmp    %r12d,%r14d
  6b:	75 b9                	jne    26 <main+0x26>
  6d:	eb de                	jmp    4d <main+0x4d>

000000000000006f <cat>:

char buf[512];

void
cat(int fd)
{
  6f:	55                   	push   %rbp
  70:	48 89 e5             	mov    %rsp,%rbp
  73:	53                   	push   %rbx
  74:	52                   	push   %rdx
  75:	89 fb                	mov    %edi,%ebx
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  77:	ba 00 02 00 00       	mov    $0x200,%edx
  7c:	48 c7 c6 40 09 00 00 	mov    $0x940,%rsi
  83:	89 df                	mov    %ebx,%edi
  85:	e8 b5 01 00 00       	callq  23f <read>
  8a:	83 f8 00             	cmp    $0x0,%eax
  8d:	7e 15                	jle    a4 <cat+0x35>
    write(1, buf, n);
  8f:	89 c2                	mov    %eax,%edx
  91:	48 c7 c6 40 09 00 00 	mov    $0x940,%rsi
  98:	bf 01 00 00 00       	mov    $0x1,%edi
  9d:	e8 a5 01 00 00       	callq  247 <write>
  a2:	eb d3                	jmp    77 <cat+0x8>
  if(n < 0){
  a4:	74 18                	je     be <cat+0x4f>
    printf(1, "cat: read error\n");
  a6:	48 c7 c6 90 06 00 00 	mov    $0x690,%rsi
  ad:	bf 01 00 00 00       	mov    $0x1,%edi
  b2:	31 c0                	xor    %eax,%eax
  b4:	e8 a1 02 00 00       	callq  35a <printf>
    exit();
  b9:	e8 69 01 00 00       	callq  227 <exit>
  }
}
  be:	58                   	pop    %rax
  bf:	5b                   	pop    %rbx
  c0:	5d                   	pop    %rbp
  c1:	c3                   	retq   

00000000000000c2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  c2:	55                   	push   %rbp
  c3:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c6:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  c8:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  cb:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  ce:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  d1:	48 ff c2             	inc    %rdx
  d4:	84 c9                	test   %cl,%cl
  d6:	75 f3                	jne    cb <strcpy+0x9>
    ;
  return os;
}
  d8:	5d                   	pop    %rbp
  d9:	c3                   	retq   

00000000000000da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  da:	55                   	push   %rbp
  db:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  de:	0f b6 07             	movzbl (%rdi),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 0c                	je     f1 <strcmp+0x17>
  e5:	3a 06                	cmp    (%rsi),%al
  e7:	75 08                	jne    f1 <strcmp+0x17>
    p++, q++;
  e9:	48 ff c7             	inc    %rdi
  ec:	48 ff c6             	inc    %rsi
  ef:	eb ed                	jmp    de <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  f1:	0f b6 16             	movzbl (%rsi),%edx
}
  f4:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f5:	29 d0                	sub    %edx,%eax
}
  f7:	c3                   	retq   

00000000000000f8 <strlen>:

uint
strlen(const char *s)
{
  f8:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
  f9:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  fb:	48 89 e5             	mov    %rsp,%rbp
  fe:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 102:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 107:	74 05                	je     10e <strlen+0x16>
 109:	48 89 d0             	mov    %rdx,%rax
 10c:	eb f0                	jmp    fe <strlen+0x6>
    ;
  return n;
}
 10e:	5d                   	pop    %rbp
 10f:	c3                   	retq   

0000000000000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %rbp
 111:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 114:	89 d1                	mov    %edx,%ecx
 116:	89 f0                	mov    %esi,%eax
 118:	48 89 e5             	mov    %rsp,%rbp
 11b:	fc                   	cld    
 11c:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 11e:	4c 89 c0             	mov    %r8,%rax
 121:	5d                   	pop    %rbp
 122:	c3                   	retq   

0000000000000123 <strchr>:

char*
strchr(const char *s, char c)
{
 123:	55                   	push   %rbp
 124:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 127:	8a 07                	mov    (%rdi),%al
 129:	84 c0                	test   %al,%al
 12b:	74 0a                	je     137 <strchr+0x14>
    if(*s == c)
 12d:	40 38 f0             	cmp    %sil,%al
 130:	74 09                	je     13b <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 132:	48 ff c7             	inc    %rdi
 135:	eb f0                	jmp    127 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 137:	31 c0                	xor    %eax,%eax
 139:	eb 03                	jmp    13e <strchr+0x1b>
 13b:	48 89 f8             	mov    %rdi,%rax
}
 13e:	5d                   	pop    %rbp
 13f:	c3                   	retq   

0000000000000140 <gets>:

char*
gets(char *buf, int max)
{
 140:	55                   	push   %rbp
 141:	48 89 e5             	mov    %rsp,%rbp
 144:	41 57                	push   %r15
 146:	41 56                	push   %r14
 148:	41 55                	push   %r13
 14a:	41 54                	push   %r12
 14c:	41 89 f7             	mov    %esi,%r15d
 14f:	53                   	push   %rbx
 150:	49 89 fc             	mov    %rdi,%r12
 153:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 158:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15c:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 160:	45 39 fd             	cmp    %r15d,%r13d
 163:	7d 2c                	jge    191 <gets+0x51>
    cc = read(0, &c, 1);
 165:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 169:	31 ff                	xor    %edi,%edi
 16b:	ba 01 00 00 00       	mov    $0x1,%edx
 170:	e8 ca 00 00 00       	callq  23f <read>
    if(cc < 1)
 175:	85 c0                	test   %eax,%eax
 177:	7e 18                	jle    191 <gets+0x51>
      break;
    buf[i++] = c;
 179:	8a 45 cf             	mov    -0x31(%rbp),%al
 17c:	49 ff c6             	inc    %r14
 17f:	49 63 dd             	movslq %r13d,%rbx
 182:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 186:	3c 0a                	cmp    $0xa,%al
 188:	74 04                	je     18e <gets+0x4e>
 18a:	3c 0d                	cmp    $0xd,%al
 18c:	75 ce                	jne    15c <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 191:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 196:	48 83 c4 18          	add    $0x18,%rsp
 19a:	4c 89 e0             	mov    %r12,%rax
 19d:	5b                   	pop    %rbx
 19e:	41 5c                	pop    %r12
 1a0:	41 5d                	pop    %r13
 1a2:	41 5e                	pop    %r14
 1a4:	41 5f                	pop    %r15
 1a6:	5d                   	pop    %rbp
 1a7:	c3                   	retq   

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	55                   	push   %rbp
 1a9:	48 89 e5             	mov    %rsp,%rbp
 1ac:	41 54                	push   %r12
 1ae:	53                   	push   %rbx
 1af:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b2:	31 f6                	xor    %esi,%esi
 1b4:	e8 ae 00 00 00       	callq  267 <open>
 1b9:	41 89 c4             	mov    %eax,%r12d
 1bc:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 1bf:	45 85 e4             	test   %r12d,%r12d
 1c2:	78 17                	js     1db <stat+0x33>
    return -1;
  r = fstat(fd, st);
 1c4:	48 89 de             	mov    %rbx,%rsi
 1c7:	44 89 e7             	mov    %r12d,%edi
 1ca:	e8 b0 00 00 00       	callq  27f <fstat>
  close(fd);
 1cf:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1d2:	89 c3                	mov    %eax,%ebx
  close(fd);
 1d4:	e8 76 00 00 00       	callq  24f <close>
  return r;
 1d9:	89 d8                	mov    %ebx,%eax
}
 1db:	5b                   	pop    %rbx
 1dc:	41 5c                	pop    %r12
 1de:	5d                   	pop    %rbp
 1df:	c3                   	retq   

00000000000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %rbp
  int n;

  n = 0;
 1e1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 1e3:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e6:	0f be 17             	movsbl (%rdi),%edx
 1e9:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 1ec:	80 f9 09             	cmp    $0x9,%cl
 1ef:	77 0c                	ja     1fd <atoi+0x1d>
    n = n*10 + *s++ - '0';
 1f1:	6b c0 0a             	imul   $0xa,%eax,%eax
 1f4:	48 ff c7             	inc    %rdi
 1f7:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 1fb:	eb e9                	jmp    1e6 <atoi+0x6>
  return n;
}
 1fd:	5d                   	pop    %rbp
 1fe:	c3                   	retq   

00000000000001ff <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ff:	55                   	push   %rbp
 200:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 203:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 205:	48 89 e5             	mov    %rsp,%rbp
 208:	89 d7                	mov    %edx,%edi
 20a:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 20c:	85 ff                	test   %edi,%edi
 20e:	7e 0d                	jle    21d <memmove+0x1e>
    *dst++ = *src++;
 210:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 214:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 218:	48 ff c1             	inc    %rcx
 21b:	eb eb                	jmp    208 <memmove+0x9>
  return vdst;
}
 21d:	5d                   	pop    %rbp
 21e:	c3                   	retq   

000000000000021f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	retq   

0000000000000227 <exit>:
SYSCALL(exit)
 227:	b8 02 00 00 00       	mov    $0x2,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	retq   

000000000000022f <wait>:
SYSCALL(wait)
 22f:	b8 03 00 00 00       	mov    $0x3,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	retq   

0000000000000237 <pipe>:
SYSCALL(pipe)
 237:	b8 04 00 00 00       	mov    $0x4,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	retq   

000000000000023f <read>:
SYSCALL(read)
 23f:	b8 05 00 00 00       	mov    $0x5,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	retq   

0000000000000247 <write>:
SYSCALL(write)
 247:	b8 10 00 00 00       	mov    $0x10,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	retq   

000000000000024f <close>:
SYSCALL(close)
 24f:	b8 15 00 00 00       	mov    $0x15,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	retq   

0000000000000257 <kill>:
SYSCALL(kill)
 257:	b8 06 00 00 00       	mov    $0x6,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	retq   

000000000000025f <exec>:
SYSCALL(exec)
 25f:	b8 07 00 00 00       	mov    $0x7,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	retq   

0000000000000267 <open>:
SYSCALL(open)
 267:	b8 0f 00 00 00       	mov    $0xf,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	retq   

000000000000026f <mknod>:
SYSCALL(mknod)
 26f:	b8 11 00 00 00       	mov    $0x11,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	retq   

0000000000000277 <unlink>:
SYSCALL(unlink)
 277:	b8 12 00 00 00       	mov    $0x12,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	retq   

000000000000027f <fstat>:
SYSCALL(fstat)
 27f:	b8 08 00 00 00       	mov    $0x8,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	retq   

0000000000000287 <link>:
SYSCALL(link)
 287:	b8 13 00 00 00       	mov    $0x13,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	retq   

000000000000028f <mkdir>:
SYSCALL(mkdir)
 28f:	b8 14 00 00 00       	mov    $0x14,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	retq   

0000000000000297 <chdir>:
SYSCALL(chdir)
 297:	b8 09 00 00 00       	mov    $0x9,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	retq   

000000000000029f <dup>:
SYSCALL(dup)
 29f:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	retq   

00000000000002a7 <getpid>:
SYSCALL(getpid)
 2a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	retq   

00000000000002af <sbrk>:
SYSCALL(sbrk)
 2af:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	retq   

00000000000002b7 <sleep>:
SYSCALL(sleep)
 2b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	retq   

00000000000002bf <uptime>:
SYSCALL(uptime)
 2bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	retq   

00000000000002c7 <chmod>:
SYSCALL(chmod)
 2c7:	b8 16 00 00 00       	mov    $0x16,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	retq   

00000000000002cf <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2cf:	55                   	push   %rbp
 2d0:	41 89 d0             	mov    %edx,%r8d
 2d3:	48 89 e5             	mov    %rsp,%rbp
 2d6:	41 54                	push   %r12
 2d8:	53                   	push   %rbx
 2d9:	41 89 fc             	mov    %edi,%r12d
 2dc:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e0:	85 c9                	test   %ecx,%ecx
 2e2:	74 12                	je     2f6 <printint+0x27>
 2e4:	89 f0                	mov    %esi,%eax
 2e6:	c1 e8 1f             	shr    $0x1f,%eax
 2e9:	74 0b                	je     2f6 <printint+0x27>
    neg = 1;
    x = -xx;
 2eb:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 2ed:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 2f2:	f7 d8                	neg    %eax
 2f4:	eb 04                	jmp    2fa <printint+0x2b>
  } else {
    x = xx;
 2f6:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 2f8:	31 f6                	xor    %esi,%esi
 2fa:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2fe:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 300:	31 d2                	xor    %edx,%edx
 302:	48 ff c7             	inc    %rdi
 305:	8d 59 01             	lea    0x1(%rcx),%ebx
 308:	41 f7 f0             	div    %r8d
 30b:	89 d2                	mov    %edx,%edx
 30d:	8a 92 c0 06 00 00    	mov    0x6c0(%rdx),%dl
 313:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 316:	85 c0                	test   %eax,%eax
 318:	74 04                	je     31e <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 31a:	89 d9                	mov    %ebx,%ecx
 31c:	eb e2                	jmp    300 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 31e:	85 f6                	test   %esi,%esi
 320:	74 0b                	je     32d <printint+0x5e>
    buf[i++] = '-';
 322:	48 63 db             	movslq %ebx,%rbx
 325:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 32a:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 32d:	ff cb                	dec    %ebx
 32f:	83 fb ff             	cmp    $0xffffffff,%ebx
 332:	74 1d                	je     351 <printint+0x82>
    putc(fd, buf[i]);
 334:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 337:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 33b:	ba 01 00 00 00       	mov    $0x1,%edx
 340:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 344:	44 89 e7             	mov    %r12d,%edi
 347:	88 45 df             	mov    %al,-0x21(%rbp)
 34a:	e8 f8 fe ff ff       	callq  247 <write>
 34f:	eb dc                	jmp    32d <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 351:	48 83 c4 20          	add    $0x20,%rsp
 355:	5b                   	pop    %rbx
 356:	41 5c                	pop    %r12
 358:	5d                   	pop    %rbp
 359:	c3                   	retq   

000000000000035a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 35a:	55                   	push   %rbp
 35b:	48 89 e5             	mov    %rsp,%rbp
 35e:	41 56                	push   %r14
 360:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 362:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 366:	41 54                	push   %r12
 368:	53                   	push   %rbx
 369:	41 89 fc             	mov    %edi,%r12d
 36c:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 36f:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 371:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 375:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 379:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 37d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 381:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 385:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 389:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 38d:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 394:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 398:	45 8a 2e             	mov    (%r14),%r13b
 39b:	45 84 ed             	test   %r13b,%r13b
 39e:	0f 84 8f 01 00 00    	je     533 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 3a4:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3a6:	41 0f be d5          	movsbl %r13b,%edx
 3aa:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 3ae:	75 23                	jne    3d3 <printf+0x79>
      if(c == '%'){
 3b0:	83 f8 25             	cmp    $0x25,%eax
 3b3:	0f 84 6d 01 00 00    	je     526 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b9:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 3bd:	ba 01 00 00 00       	mov    $0x1,%edx
 3c2:	44 89 e7             	mov    %r12d,%edi
 3c5:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 3c9:	e8 79 fe ff ff       	callq  247 <write>
 3ce:	e9 58 01 00 00       	jmpq   52b <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d3:	83 fb 25             	cmp    $0x25,%ebx
 3d6:	0f 85 4f 01 00 00    	jne    52b <printf+0x1d1>
      if(c == 'd'){
 3dc:	83 f8 64             	cmp    $0x64,%eax
 3df:	75 2e                	jne    40f <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 3e1:	8b 55 98             	mov    -0x68(%rbp),%edx
 3e4:	83 fa 2f             	cmp    $0x2f,%edx
 3e7:	77 0e                	ja     3f7 <printf+0x9d>
 3e9:	89 d0                	mov    %edx,%eax
 3eb:	83 c2 08             	add    $0x8,%edx
 3ee:	48 03 45 a8          	add    -0x58(%rbp),%rax
 3f2:	89 55 98             	mov    %edx,-0x68(%rbp)
 3f5:	eb 0c                	jmp    403 <printf+0xa9>
 3f7:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 3fb:	48 8d 50 08          	lea    0x8(%rax),%rdx
 3ff:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 403:	b9 01 00 00 00       	mov    $0x1,%ecx
 408:	ba 0a 00 00 00       	mov    $0xa,%edx
 40d:	eb 34                	jmp    443 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 40f:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 415:	83 fa 70             	cmp    $0x70,%edx
 418:	75 38                	jne    452 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 41a:	8b 55 98             	mov    -0x68(%rbp),%edx
 41d:	83 fa 2f             	cmp    $0x2f,%edx
 420:	77 0e                	ja     430 <printf+0xd6>
 422:	89 d0                	mov    %edx,%eax
 424:	83 c2 08             	add    $0x8,%edx
 427:	48 03 45 a8          	add    -0x58(%rbp),%rax
 42b:	89 55 98             	mov    %edx,-0x68(%rbp)
 42e:	eb 0c                	jmp    43c <printf+0xe2>
 430:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 434:	48 8d 50 08          	lea    0x8(%rax),%rdx
 438:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 43c:	31 c9                	xor    %ecx,%ecx
 43e:	ba 10 00 00 00       	mov    $0x10,%edx
 443:	8b 30                	mov    (%rax),%esi
 445:	44 89 e7             	mov    %r12d,%edi
 448:	e8 82 fe ff ff       	callq  2cf <printint>
 44d:	e9 d0 00 00 00       	jmpq   522 <printf+0x1c8>
      } else if(c == 's'){
 452:	83 f8 73             	cmp    $0x73,%eax
 455:	75 56                	jne    4ad <printf+0x153>
        s = va_arg(ap, char*);
 457:	8b 55 98             	mov    -0x68(%rbp),%edx
 45a:	83 fa 2f             	cmp    $0x2f,%edx
 45d:	77 0e                	ja     46d <printf+0x113>
 45f:	89 d0                	mov    %edx,%eax
 461:	83 c2 08             	add    $0x8,%edx
 464:	48 03 45 a8          	add    -0x58(%rbp),%rax
 468:	89 55 98             	mov    %edx,-0x68(%rbp)
 46b:	eb 0c                	jmp    479 <printf+0x11f>
 46d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 471:	48 8d 50 08          	lea    0x8(%rax),%rdx
 475:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 479:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 47c:	48 c7 c0 b6 06 00 00 	mov    $0x6b6,%rax
 483:	48 85 db             	test   %rbx,%rbx
 486:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 48a:	8a 03                	mov    (%rbx),%al
 48c:	84 c0                	test   %al,%al
 48e:	0f 84 8e 00 00 00    	je     522 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 494:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 498:	ba 01 00 00 00       	mov    $0x1,%edx
 49d:	44 89 e7             	mov    %r12d,%edi
 4a0:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4a3:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a6:	e8 9c fd ff ff       	callq  247 <write>
 4ab:	eb dd                	jmp    48a <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ad:	83 f8 63             	cmp    $0x63,%eax
 4b0:	75 32                	jne    4e4 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 4b2:	8b 55 98             	mov    -0x68(%rbp),%edx
 4b5:	83 fa 2f             	cmp    $0x2f,%edx
 4b8:	77 0e                	ja     4c8 <printf+0x16e>
 4ba:	89 d0                	mov    %edx,%eax
 4bc:	83 c2 08             	add    $0x8,%edx
 4bf:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4c3:	89 55 98             	mov    %edx,-0x68(%rbp)
 4c6:	eb 0c                	jmp    4d4 <printf+0x17a>
 4c8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4cc:	48 8d 50 08          	lea    0x8(%rax),%rdx
 4d0:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4d4:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d6:	ba 01 00 00 00       	mov    $0x1,%edx
 4db:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 4df:	88 45 94             	mov    %al,-0x6c(%rbp)
 4e2:	eb 36                	jmp    51a <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4e4:	83 f8 25             	cmp    $0x25,%eax
 4e7:	75 0f                	jne    4f8 <printf+0x19e>
 4e9:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ed:	ba 01 00 00 00       	mov    $0x1,%edx
 4f2:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 4f6:	eb 22                	jmp    51a <printf+0x1c0>
 4f8:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 4fc:	ba 01 00 00 00       	mov    $0x1,%edx
 501:	44 89 e7             	mov    %r12d,%edi
 504:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 508:	e8 3a fd ff ff       	callq  247 <write>
 50d:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 511:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 515:	ba 01 00 00 00       	mov    $0x1,%edx
 51a:	44 89 e7             	mov    %r12d,%edi
 51d:	e8 25 fd ff ff       	callq  247 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 522:	31 db                	xor    %ebx,%ebx
 524:	eb 05                	jmp    52b <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 526:	bb 25 00 00 00       	mov    $0x25,%ebx
 52b:	49 ff c6             	inc    %r14
 52e:	e9 65 fe ff ff       	jmpq   398 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 533:	48 83 c4 50          	add    $0x50,%rsp
 537:	5b                   	pop    %rbx
 538:	41 5c                	pop    %r12
 53a:	41 5d                	pop    %r13
 53c:	41 5e                	pop    %r14
 53e:	5d                   	pop    %rbp
 53f:	c3                   	retq   

0000000000000540 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 540:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 541:	48 8b 05 f8 05 00 00 	mov    0x5f8(%rip),%rax        # b40 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 548:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 54c:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 54f:	48 39 d0             	cmp    %rdx,%rax
 552:	48 8b 08             	mov    (%rax),%rcx
 555:	72 14                	jb     56b <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 557:	48 39 c8             	cmp    %rcx,%rax
 55a:	72 0a                	jb     566 <free+0x26>
 55c:	48 39 ca             	cmp    %rcx,%rdx
 55f:	72 0f                	jb     570 <free+0x30>
 561:	48 39 d0             	cmp    %rdx,%rax
 564:	72 0a                	jb     570 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 566:	48 89 c8             	mov    %rcx,%rax
 569:	eb e4                	jmp    54f <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56b:	48 39 ca             	cmp    %rcx,%rdx
 56e:	73 e7                	jae    557 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 570:	8b 77 f8             	mov    -0x8(%rdi),%esi
 573:	49 89 f0             	mov    %rsi,%r8
 576:	48 c1 e6 04          	shl    $0x4,%rsi
 57a:	48 01 d6             	add    %rdx,%rsi
 57d:	48 39 ce             	cmp    %rcx,%rsi
 580:	75 0e                	jne    590 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 582:	44 03 41 08          	add    0x8(%rcx),%r8d
 586:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 58a:	48 8b 08             	mov    (%rax),%rcx
 58d:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 590:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 594:	8b 48 08             	mov    0x8(%rax),%ecx
 597:	48 89 ce             	mov    %rcx,%rsi
 59a:	48 c1 e1 04          	shl    $0x4,%rcx
 59e:	48 01 c1             	add    %rax,%rcx
 5a1:	48 39 ca             	cmp    %rcx,%rdx
 5a4:	75 0a                	jne    5b0 <free+0x70>
    p->s.size += bp->s.size;
 5a6:	03 77 f8             	add    -0x8(%rdi),%esi
 5a9:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 5ac:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 5b0:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 5b3:	48 89 05 86 05 00 00 	mov    %rax,0x586(%rip)        # b40 <freep>
}
 5ba:	5d                   	pop    %rbp
 5bb:	c3                   	retq   

00000000000005bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5bc:	55                   	push   %rbp
 5bd:	48 89 e5             	mov    %rsp,%rbp
 5c0:	41 55                	push   %r13
 5c2:	41 54                	push   %r12
 5c4:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c5:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 5c7:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 5c8:	48 8b 0d 71 05 00 00 	mov    0x571(%rip),%rcx        # b40 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5cf:	48 83 c3 0f          	add    $0xf,%rbx
 5d3:	48 c1 eb 04          	shr    $0x4,%rbx
 5d7:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 5d9:	48 85 c9             	test   %rcx,%rcx
 5dc:	75 27                	jne    605 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 5de:	48 c7 05 57 05 00 00 	movq   $0xb50,0x557(%rip)        # b40 <freep>
 5e5:	50 0b 00 00 
 5e9:	48 c7 05 5c 05 00 00 	movq   $0xb50,0x55c(%rip)        # b50 <base>
 5f0:	50 0b 00 00 
 5f4:	48 c7 c1 50 0b 00 00 	mov    $0xb50,%rcx
    base.s.size = 0;
 5fb:	c7 05 53 05 00 00 00 	movl   $0x0,0x553(%rip)        # b58 <base+0x8>
 602:	00 00 00 
 605:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 60b:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 611:	48 8b 01             	mov    (%rcx),%rax
 614:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 618:	45 89 e5             	mov    %r12d,%r13d
 61b:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 61f:	8b 50 08             	mov    0x8(%rax),%edx
 622:	39 d3                	cmp    %edx,%ebx
 624:	77 26                	ja     64c <malloc+0x90>
      if(p->s.size == nunits)
 626:	75 08                	jne    630 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 628:	48 8b 10             	mov    (%rax),%rdx
 62b:	48 89 11             	mov    %rdx,(%rcx)
 62e:	eb 0f                	jmp    63f <malloc+0x83>
      else {
        p->s.size -= nunits;
 630:	29 da                	sub    %ebx,%edx
 632:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 635:	48 c1 e2 04          	shl    $0x4,%rdx
 639:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 63c:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 63f:	48 89 0d fa 04 00 00 	mov    %rcx,0x4fa(%rip)        # b40 <freep>
      return (void*)(p + 1);
 646:	48 83 c0 10          	add    $0x10,%rax
 64a:	eb 3a                	jmp    686 <malloc+0xca>
    }
    if(p == freep)
 64c:	48 3b 05 ed 04 00 00 	cmp    0x4ed(%rip),%rax        # b40 <freep>
 653:	75 27                	jne    67c <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 655:	44 89 ef             	mov    %r13d,%edi
 658:	e8 52 fc ff ff       	callq  2af <sbrk>
  if(p == (char*)-1)
 65d:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 661:	74 21                	je     684 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 663:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 667:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 66b:	e8 d0 fe ff ff       	callq  540 <free>
  return freep;
 670:	48 8b 05 c9 04 00 00 	mov    0x4c9(%rip),%rax        # b40 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 677:	48 85 c0             	test   %rax,%rax
 67a:	74 08                	je     684 <malloc+0xc8>
        return 0;
  }
 67c:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67f:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 682:	eb 9b                	jmp    61f <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 684:	31 c0                	xor    %eax,%eax
  }
}
 686:	5a                   	pop    %rdx
 687:	5b                   	pop    %rbx
 688:	41 5c                	pop    %r12
 68a:	41 5d                	pop    %r13
 68c:	5d                   	pop    %rbp
 68d:	c3                   	retq   
