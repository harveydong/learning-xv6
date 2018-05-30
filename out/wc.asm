
.fs/wc:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int fd, i;

  if(argc <= 1){
   1:	83 ff 01             	cmp    $0x1,%edi
  printf(1, "%d %d %d %s\n", l, w, c, name);
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
   e:	7f 10                	jg     20 <main+0x20>
    wc(0, "");
  10:	48 c7 c6 35 07 00 00 	mov    $0x735,%rsi
  17:	31 ff                	xor    %edi,%edi
  19:	e8 5b 00 00 00       	callq  79 <wc>
  1e:	eb 34                	jmp    54 <main+0x54>
  20:	48 8d 5e 08          	lea    0x8(%rsi),%rbx
  24:	41 89 fe             	mov    %edi,%r14d
int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
  27:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  2d:	48 8b 3b             	mov    (%rbx),%rdi
  30:	31 f6                	xor    %esi,%esi
  32:	e8 bb 02 00 00       	callq  2f2 <open>
  37:	85 c0                	test   %eax,%eax
  39:	41 89 c5             	mov    %eax,%r13d
  3c:	79 1b                	jns    59 <main+0x59>
      printf(1, "wc: cannot open %s\n", argv[i]);
  3e:	48 8b 13             	mov    (%rbx),%rdx
  41:	48 c7 c6 43 07 00 00 	mov    $0x743,%rsi
  48:	bf 01 00 00 00       	mov    $0x1,%edi
  4d:	31 c0                	xor    %eax,%eax
  4f:	e8 91 03 00 00       	callq  3e5 <printf>
      exit();
  54:	e8 59 02 00 00       	callq  2b2 <exit>
    }
    wc(fd, argv[i]);
  59:	48 8b 33             	mov    (%rbx),%rsi
  5c:	89 c7                	mov    %eax,%edi
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  5e:	41 ff c4             	inc    %r12d
  61:	48 83 c3 08          	add    $0x8,%rbx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  65:	e8 0f 00 00 00       	callq  79 <wc>
    close(fd);
  6a:	44 89 ef             	mov    %r13d,%edi
  6d:	e8 68 02 00 00       	callq  2da <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  72:	45 39 e6             	cmp    %r12d,%r14d
  75:	75 b6                	jne    2d <main+0x2d>
  77:	eb db                	jmp    54 <main+0x54>

0000000000000079 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
  79:	55                   	push   %rbp
  7a:	48 89 e5             	mov    %rsp,%rbp
  7d:	41 57                	push   %r15
  7f:	41 56                	push   %r14
  81:	41 55                	push   %r13
  83:	41 54                	push   %r12
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  85:	45 31 f6             	xor    %r14d,%r14d

char buf[512];

void
wc(int fd, char *name)
{
  88:	53                   	push   %rbx
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  89:	45 31 ed             	xor    %r13d,%r13d
  inword = 0;
  8c:	31 db                	xor    %ebx,%ebx
wc(int fd, char *name)
{
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  8e:	45 31 e4             	xor    %r12d,%r12d

char buf[512];

void
wc(int fd, char *name)
{
  91:	48 83 ec 28          	sub    $0x28,%rsp
  95:	89 7d cc             	mov    %edi,-0x34(%rbp)
  98:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  9c:	8b 7d cc             	mov    -0x34(%rbp),%edi
  9f:	ba 00 02 00 00       	mov    $0x200,%edx
  a4:	48 c7 c6 e0 09 00 00 	mov    $0x9e0,%rsi
  ab:	e8 1a 02 00 00       	callq  2ca <read>
  b0:	83 f8 00             	cmp    $0x0,%eax
  b3:	41 89 c7             	mov    %eax,%r15d
  b6:	7e 4d                	jle    105 <wc+0x8c>
  b8:	31 d2                	xor    %edx,%edx
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  ba:	0f be b2 e0 09 00 00 	movsbl 0x9e0(%rdx),%esi
        l++;
  c1:	31 c0                	xor    %eax,%eax
      if(strchr(" \r\t\n\v", buf[i]))
  c3:	48 c7 c7 20 07 00 00 	mov    $0x720,%rdi
  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  ca:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
        l++;
  ce:	40 80 fe 0a          	cmp    $0xa,%sil
  d2:	0f 94 c0             	sete   %al
  d5:	41 01 c4             	add    %eax,%r12d
      if(strchr(" \r\t\n\v", buf[i]))
  d8:	e8 d1 00 00 00       	callq  1ae <strchr>
  dd:	48 85 c0             	test   %rax,%rax
  e0:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  e4:	75 09                	jne    ef <wc+0x76>
        inword = 0;
      else if(!inword){
  e6:	85 db                	test   %ebx,%ebx
  e8:	75 09                	jne    f3 <wc+0x7a>
        w++;
  ea:	41 ff c5             	inc    %r13d
  ed:	eb 04                	jmp    f3 <wc+0x7a>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
  ef:	31 db                	xor    %ebx,%ebx
  f1:	eb 05                	jmp    f8 <wc+0x7f>
  f3:	bb 01 00 00 00       	mov    $0x1,%ebx
  f8:	48 ff c2             	inc    %rdx
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  fb:	41 39 d7             	cmp    %edx,%r15d
  fe:	7f ba                	jg     ba <wc+0x41>
 100:	45 01 fe             	add    %r15d,%r14d
 103:	eb 97                	jmp    9c <wc+0x23>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
 105:	74 18                	je     11f <wc+0xa6>
    printf(1, "wc: read error\n");
 107:	48 c7 c6 26 07 00 00 	mov    $0x726,%rsi
 10e:	bf 01 00 00 00       	mov    $0x1,%edi
 113:	31 c0                	xor    %eax,%eax
 115:	e8 cb 02 00 00       	callq  3e5 <printf>
    exit();
 11a:	e8 93 01 00 00       	callq  2b2 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
 11f:	4c 8b 4d c0          	mov    -0x40(%rbp),%r9
}
 123:	48 83 c4 28          	add    $0x28,%rsp
  }
  if(n < 0){
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
 127:	45 89 f0             	mov    %r14d,%r8d
}
 12a:	5b                   	pop    %rbx
  }
  if(n < 0){
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
 12b:	44 89 e9             	mov    %r13d,%ecx
 12e:	44 89 e2             	mov    %r12d,%edx
 131:	48 c7 c6 36 07 00 00 	mov    $0x736,%rsi
}
 138:	41 5c                	pop    %r12
 13a:	41 5d                	pop    %r13
 13c:	41 5e                	pop    %r14
 13e:	41 5f                	pop    %r15
 140:	5d                   	pop    %rbp
  }
  if(n < 0){
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
 141:	bf 01 00 00 00       	mov    $0x1,%edi
 146:	31 c0                	xor    %eax,%eax
 148:	e9 98 02 00 00       	jmpq   3e5 <printf>

000000000000014d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 14d:	55                   	push   %rbp
 14e:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 151:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 153:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 156:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
 159:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
 15c:	48 ff c2             	inc    %rdx
 15f:	84 c9                	test   %cl,%cl
 161:	75 f3                	jne    156 <strcpy+0x9>
    ;
  return os;
}
 163:	5d                   	pop    %rbp
 164:	c3                   	retq   

0000000000000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %rbp
 166:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
 169:	0f b6 07             	movzbl (%rdi),%eax
 16c:	84 c0                	test   %al,%al
 16e:	74 0c                	je     17c <strcmp+0x17>
 170:	3a 06                	cmp    (%rsi),%al
 172:	75 08                	jne    17c <strcmp+0x17>
    p++, q++;
 174:	48 ff c7             	inc    %rdi
 177:	48 ff c6             	inc    %rsi
 17a:	eb ed                	jmp    169 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 17c:	0f b6 16             	movzbl (%rsi),%edx
}
 17f:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 180:	29 d0                	sub    %edx,%eax
}
 182:	c3                   	retq   

0000000000000183 <strlen>:

uint
strlen(const char *s)
{
 183:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 184:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 186:	48 89 e5             	mov    %rsp,%rbp
 189:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 18d:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 192:	74 05                	je     199 <strlen+0x16>
 194:	48 89 d0             	mov    %rdx,%rax
 197:	eb f0                	jmp    189 <strlen+0x6>
    ;
  return n;
}
 199:	5d                   	pop    %rbp
 19a:	c3                   	retq   

000000000000019b <memset>:

void*
memset(void *dst, int c, uint n)
{
 19b:	55                   	push   %rbp
 19c:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19f:	89 d1                	mov    %edx,%ecx
 1a1:	89 f0                	mov    %esi,%eax
 1a3:	48 89 e5             	mov    %rsp,%rbp
 1a6:	fc                   	cld    
 1a7:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 1a9:	4c 89 c0             	mov    %r8,%rax
 1ac:	5d                   	pop    %rbp
 1ad:	c3                   	retq   

00000000000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	55                   	push   %rbp
 1af:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 1b2:	8a 07                	mov    (%rdi),%al
 1b4:	84 c0                	test   %al,%al
 1b6:	74 0a                	je     1c2 <strchr+0x14>
    if(*s == c)
 1b8:	40 38 f0             	cmp    %sil,%al
 1bb:	74 09                	je     1c6 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1bd:	48 ff c7             	inc    %rdi
 1c0:	eb f0                	jmp    1b2 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 1c2:	31 c0                	xor    %eax,%eax
 1c4:	eb 03                	jmp    1c9 <strchr+0x1b>
 1c6:	48 89 f8             	mov    %rdi,%rax
}
 1c9:	5d                   	pop    %rbp
 1ca:	c3                   	retq   

00000000000001cb <gets>:

char*
gets(char *buf, int max)
{
 1cb:	55                   	push   %rbp
 1cc:	48 89 e5             	mov    %rsp,%rbp
 1cf:	41 57                	push   %r15
 1d1:	41 56                	push   %r14
 1d3:	41 55                	push   %r13
 1d5:	41 54                	push   %r12
 1d7:	41 89 f7             	mov    %esi,%r15d
 1da:	53                   	push   %rbx
 1db:	49 89 fc             	mov    %rdi,%r12
 1de:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e1:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 1e3:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e7:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 1eb:	45 39 fd             	cmp    %r15d,%r13d
 1ee:	7d 2c                	jge    21c <gets+0x51>
    cc = read(0, &c, 1);
 1f0:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 1f4:	31 ff                	xor    %edi,%edi
 1f6:	ba 01 00 00 00       	mov    $0x1,%edx
 1fb:	e8 ca 00 00 00       	callq  2ca <read>
    if(cc < 1)
 200:	85 c0                	test   %eax,%eax
 202:	7e 18                	jle    21c <gets+0x51>
      break;
    buf[i++] = c;
 204:	8a 45 cf             	mov    -0x31(%rbp),%al
 207:	49 ff c6             	inc    %r14
 20a:	49 63 dd             	movslq %r13d,%rbx
 20d:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 211:	3c 0a                	cmp    $0xa,%al
 213:	74 04                	je     219 <gets+0x4e>
 215:	3c 0d                	cmp    $0xd,%al
 217:	75 ce                	jne    1e7 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 219:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21c:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 221:	48 83 c4 18          	add    $0x18,%rsp
 225:	4c 89 e0             	mov    %r12,%rax
 228:	5b                   	pop    %rbx
 229:	41 5c                	pop    %r12
 22b:	41 5d                	pop    %r13
 22d:	41 5e                	pop    %r14
 22f:	41 5f                	pop    %r15
 231:	5d                   	pop    %rbp
 232:	c3                   	retq   

0000000000000233 <stat>:

int
stat(const char *n, struct stat *st)
{
 233:	55                   	push   %rbp
 234:	48 89 e5             	mov    %rsp,%rbp
 237:	41 54                	push   %r12
 239:	53                   	push   %rbx
 23a:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23d:	31 f6                	xor    %esi,%esi
 23f:	e8 ae 00 00 00       	callq  2f2 <open>
 244:	41 89 c4             	mov    %eax,%r12d
 247:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 24a:	45 85 e4             	test   %r12d,%r12d
 24d:	78 17                	js     266 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 24f:	48 89 de             	mov    %rbx,%rsi
 252:	44 89 e7             	mov    %r12d,%edi
 255:	e8 b0 00 00 00       	callq  30a <fstat>
  close(fd);
 25a:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 25d:	89 c3                	mov    %eax,%ebx
  close(fd);
 25f:	e8 76 00 00 00       	callq  2da <close>
  return r;
 264:	89 d8                	mov    %ebx,%eax
}
 266:	5b                   	pop    %rbx
 267:	41 5c                	pop    %r12
 269:	5d                   	pop    %rbp
 26a:	c3                   	retq   

000000000000026b <atoi>:

int
atoi(const char *s)
{
 26b:	55                   	push   %rbp
  int n;

  n = 0;
 26c:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 26e:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	0f be 17             	movsbl (%rdi),%edx
 274:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 277:	80 f9 09             	cmp    $0x9,%cl
 27a:	77 0c                	ja     288 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 27c:	6b c0 0a             	imul   $0xa,%eax,%eax
 27f:	48 ff c7             	inc    %rdi
 282:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 286:	eb e9                	jmp    271 <atoi+0x6>
  return n;
}
 288:	5d                   	pop    %rbp
 289:	c3                   	retq   

000000000000028a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28a:	55                   	push   %rbp
 28b:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	48 89 e5             	mov    %rsp,%rbp
 293:	89 d7                	mov    %edx,%edi
 295:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 297:	85 ff                	test   %edi,%edi
 299:	7e 0d                	jle    2a8 <memmove+0x1e>
    *dst++ = *src++;
 29b:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 29f:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 2a3:	48 ff c1             	inc    %rcx
 2a6:	eb eb                	jmp    293 <memmove+0x9>
  return vdst;
}
 2a8:	5d                   	pop    %rbp
 2a9:	c3                   	retq   

00000000000002aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	retq   

00000000000002b2 <exit>:
SYSCALL(exit)
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	retq   

00000000000002ba <wait>:
SYSCALL(wait)
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	retq   

00000000000002c2 <pipe>:
SYSCALL(pipe)
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	retq   

00000000000002ca <read>:
SYSCALL(read)
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	retq   

00000000000002d2 <write>:
SYSCALL(write)
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	retq   

00000000000002da <close>:
SYSCALL(close)
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	retq   

00000000000002e2 <kill>:
SYSCALL(kill)
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	retq   

00000000000002ea <exec>:
SYSCALL(exec)
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	retq   

00000000000002f2 <open>:
SYSCALL(open)
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	retq   

00000000000002fa <mknod>:
SYSCALL(mknod)
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	retq   

0000000000000302 <unlink>:
SYSCALL(unlink)
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	retq   

000000000000030a <fstat>:
SYSCALL(fstat)
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	retq   

0000000000000312 <link>:
SYSCALL(link)
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	retq   

000000000000031a <mkdir>:
SYSCALL(mkdir)
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	retq   

0000000000000322 <chdir>:
SYSCALL(chdir)
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	retq   

000000000000032a <dup>:
SYSCALL(dup)
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	retq   

0000000000000332 <getpid>:
SYSCALL(getpid)
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	retq   

000000000000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	retq   

0000000000000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	retq   

000000000000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	retq   

0000000000000352 <chmod>:
SYSCALL(chmod)
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	retq   

000000000000035a <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35a:	55                   	push   %rbp
 35b:	41 89 d0             	mov    %edx,%r8d
 35e:	48 89 e5             	mov    %rsp,%rbp
 361:	41 54                	push   %r12
 363:	53                   	push   %rbx
 364:	41 89 fc             	mov    %edi,%r12d
 367:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36b:	85 c9                	test   %ecx,%ecx
 36d:	74 12                	je     381 <printint+0x27>
 36f:	89 f0                	mov    %esi,%eax
 371:	c1 e8 1f             	shr    $0x1f,%eax
 374:	74 0b                	je     381 <printint+0x27>
    neg = 1;
    x = -xx;
 376:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 378:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 37d:	f7 d8                	neg    %eax
 37f:	eb 04                	jmp    385 <printint+0x2b>
  } else {
    x = xx;
 381:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 383:	31 f6                	xor    %esi,%esi
 385:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 389:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 38b:	31 d2                	xor    %edx,%edx
 38d:	48 ff c7             	inc    %rdi
 390:	8d 59 01             	lea    0x1(%rcx),%ebx
 393:	41 f7 f0             	div    %r8d
 396:	89 d2                	mov    %edx,%edx
 398:	8a 92 60 07 00 00    	mov    0x760(%rdx),%dl
 39e:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 3a1:	85 c0                	test   %eax,%eax
 3a3:	74 04                	je     3a9 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3a5:	89 d9                	mov    %ebx,%ecx
 3a7:	eb e2                	jmp    38b <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 3a9:	85 f6                	test   %esi,%esi
 3ab:	74 0b                	je     3b8 <printint+0x5e>
    buf[i++] = '-';
 3ad:	48 63 db             	movslq %ebx,%rbx
 3b0:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 3b5:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 3b8:	ff cb                	dec    %ebx
 3ba:	83 fb ff             	cmp    $0xffffffff,%ebx
 3bd:	74 1d                	je     3dc <printint+0x82>
    putc(fd, buf[i]);
 3bf:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3c2:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 3c6:	ba 01 00 00 00       	mov    $0x1,%edx
 3cb:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 3cf:	44 89 e7             	mov    %r12d,%edi
 3d2:	88 45 df             	mov    %al,-0x21(%rbp)
 3d5:	e8 f8 fe ff ff       	callq  2d2 <write>
 3da:	eb dc                	jmp    3b8 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 3dc:	48 83 c4 20          	add    $0x20,%rsp
 3e0:	5b                   	pop    %rbx
 3e1:	41 5c                	pop    %r12
 3e3:	5d                   	pop    %rbp
 3e4:	c3                   	retq   

00000000000003e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3e5:	55                   	push   %rbp
 3e6:	48 89 e5             	mov    %rsp,%rbp
 3e9:	41 56                	push   %r14
 3eb:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 3ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f1:	41 54                	push   %r12
 3f3:	53                   	push   %rbx
 3f4:	41 89 fc             	mov    %edi,%r12d
 3f7:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 3fa:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fc:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 400:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 404:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 408:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 40c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 410:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 414:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 418:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 41f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 423:	45 8a 2e             	mov    (%r14),%r13b
 426:	45 84 ed             	test   %r13b,%r13b
 429:	0f 84 8f 01 00 00    	je     5be <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 42f:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 431:	41 0f be d5          	movsbl %r13b,%edx
 435:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 439:	75 23                	jne    45e <printf+0x79>
      if(c == '%'){
 43b:	83 f8 25             	cmp    $0x25,%eax
 43e:	0f 84 6d 01 00 00    	je     5b1 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 444:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 448:	ba 01 00 00 00       	mov    $0x1,%edx
 44d:	44 89 e7             	mov    %r12d,%edi
 450:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 454:	e8 79 fe ff ff       	callq  2d2 <write>
 459:	e9 58 01 00 00       	jmpq   5b6 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 45e:	83 fb 25             	cmp    $0x25,%ebx
 461:	0f 85 4f 01 00 00    	jne    5b6 <printf+0x1d1>
      if(c == 'd'){
 467:	83 f8 64             	cmp    $0x64,%eax
 46a:	75 2e                	jne    49a <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 46c:	8b 55 98             	mov    -0x68(%rbp),%edx
 46f:	83 fa 2f             	cmp    $0x2f,%edx
 472:	77 0e                	ja     482 <printf+0x9d>
 474:	89 d0                	mov    %edx,%eax
 476:	83 c2 08             	add    $0x8,%edx
 479:	48 03 45 a8          	add    -0x58(%rbp),%rax
 47d:	89 55 98             	mov    %edx,-0x68(%rbp)
 480:	eb 0c                	jmp    48e <printf+0xa9>
 482:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 486:	48 8d 50 08          	lea    0x8(%rax),%rdx
 48a:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 48e:	b9 01 00 00 00       	mov    $0x1,%ecx
 493:	ba 0a 00 00 00       	mov    $0xa,%edx
 498:	eb 34                	jmp    4ce <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 49a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4a0:	83 fa 70             	cmp    $0x70,%edx
 4a3:	75 38                	jne    4dd <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 4a5:	8b 55 98             	mov    -0x68(%rbp),%edx
 4a8:	83 fa 2f             	cmp    $0x2f,%edx
 4ab:	77 0e                	ja     4bb <printf+0xd6>
 4ad:	89 d0                	mov    %edx,%eax
 4af:	83 c2 08             	add    $0x8,%edx
 4b2:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4b6:	89 55 98             	mov    %edx,-0x68(%rbp)
 4b9:	eb 0c                	jmp    4c7 <printf+0xe2>
 4bb:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4bf:	48 8d 50 08          	lea    0x8(%rax),%rdx
 4c3:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4c7:	31 c9                	xor    %ecx,%ecx
 4c9:	ba 10 00 00 00       	mov    $0x10,%edx
 4ce:	8b 30                	mov    (%rax),%esi
 4d0:	44 89 e7             	mov    %r12d,%edi
 4d3:	e8 82 fe ff ff       	callq  35a <printint>
 4d8:	e9 d0 00 00 00       	jmpq   5ad <printf+0x1c8>
      } else if(c == 's'){
 4dd:	83 f8 73             	cmp    $0x73,%eax
 4e0:	75 56                	jne    538 <printf+0x153>
        s = va_arg(ap, char*);
 4e2:	8b 55 98             	mov    -0x68(%rbp),%edx
 4e5:	83 fa 2f             	cmp    $0x2f,%edx
 4e8:	77 0e                	ja     4f8 <printf+0x113>
 4ea:	89 d0                	mov    %edx,%eax
 4ec:	83 c2 08             	add    $0x8,%edx
 4ef:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4f3:	89 55 98             	mov    %edx,-0x68(%rbp)
 4f6:	eb 0c                	jmp    504 <printf+0x11f>
 4f8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4fc:	48 8d 50 08          	lea    0x8(%rax),%rdx
 500:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 504:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 507:	48 c7 c0 57 07 00 00 	mov    $0x757,%rax
 50e:	48 85 db             	test   %rbx,%rbx
 511:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 515:	8a 03                	mov    (%rbx),%al
 517:	84 c0                	test   %al,%al
 519:	0f 84 8e 00 00 00    	je     5ad <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51f:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 523:	ba 01 00 00 00       	mov    $0x1,%edx
 528:	44 89 e7             	mov    %r12d,%edi
 52b:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 52e:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 531:	e8 9c fd ff ff       	callq  2d2 <write>
 536:	eb dd                	jmp    515 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 538:	83 f8 63             	cmp    $0x63,%eax
 53b:	75 32                	jne    56f <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 53d:	8b 55 98             	mov    -0x68(%rbp),%edx
 540:	83 fa 2f             	cmp    $0x2f,%edx
 543:	77 0e                	ja     553 <printf+0x16e>
 545:	89 d0                	mov    %edx,%eax
 547:	83 c2 08             	add    $0x8,%edx
 54a:	48 03 45 a8          	add    -0x58(%rbp),%rax
 54e:	89 55 98             	mov    %edx,-0x68(%rbp)
 551:	eb 0c                	jmp    55f <printf+0x17a>
 553:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 557:	48 8d 50 08          	lea    0x8(%rax),%rdx
 55b:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 55f:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 561:	ba 01 00 00 00       	mov    $0x1,%edx
 566:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 56a:	88 45 94             	mov    %al,-0x6c(%rbp)
 56d:	eb 36                	jmp    5a5 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 56f:	83 f8 25             	cmp    $0x25,%eax
 572:	75 0f                	jne    583 <printf+0x19e>
 574:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 578:	ba 01 00 00 00       	mov    $0x1,%edx
 57d:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 581:	eb 22                	jmp    5a5 <printf+0x1c0>
 583:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 587:	ba 01 00 00 00       	mov    $0x1,%edx
 58c:	44 89 e7             	mov    %r12d,%edi
 58f:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 593:	e8 3a fd ff ff       	callq  2d2 <write>
 598:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 59c:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 5a0:	ba 01 00 00 00       	mov    $0x1,%edx
 5a5:	44 89 e7             	mov    %r12d,%edi
 5a8:	e8 25 fd ff ff       	callq  2d2 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ad:	31 db                	xor    %ebx,%ebx
 5af:	eb 05                	jmp    5b6 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5b1:	bb 25 00 00 00       	mov    $0x25,%ebx
 5b6:	49 ff c6             	inc    %r14
 5b9:	e9 65 fe ff ff       	jmpq   423 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5be:	48 83 c4 50          	add    $0x50,%rsp
 5c2:	5b                   	pop    %rbx
 5c3:	41 5c                	pop    %r12
 5c5:	41 5d                	pop    %r13
 5c7:	41 5e                	pop    %r14
 5c9:	5d                   	pop    %rbp
 5ca:	c3                   	retq   

00000000000005cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cb:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cc:	48 8b 05 0d 06 00 00 	mov    0x60d(%rip),%rax        # be0 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d3:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d7:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	48 39 d0             	cmp    %rdx,%rax
 5dd:	48 8b 08             	mov    (%rax),%rcx
 5e0:	72 14                	jb     5f6 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e2:	48 39 c8             	cmp    %rcx,%rax
 5e5:	72 0a                	jb     5f1 <free+0x26>
 5e7:	48 39 ca             	cmp    %rcx,%rdx
 5ea:	72 0f                	jb     5fb <free+0x30>
 5ec:	48 39 d0             	cmp    %rdx,%rax
 5ef:	72 0a                	jb     5fb <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f1:	48 89 c8             	mov    %rcx,%rax
 5f4:	eb e4                	jmp    5da <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f6:	48 39 ca             	cmp    %rcx,%rdx
 5f9:	73 e7                	jae    5e2 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5fb:	8b 77 f8             	mov    -0x8(%rdi),%esi
 5fe:	49 89 f0             	mov    %rsi,%r8
 601:	48 c1 e6 04          	shl    $0x4,%rsi
 605:	48 01 d6             	add    %rdx,%rsi
 608:	48 39 ce             	cmp    %rcx,%rsi
 60b:	75 0e                	jne    61b <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 60d:	44 03 41 08          	add    0x8(%rcx),%r8d
 611:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 615:	48 8b 08             	mov    (%rax),%rcx
 618:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 61b:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 61f:	8b 48 08             	mov    0x8(%rax),%ecx
 622:	48 89 ce             	mov    %rcx,%rsi
 625:	48 c1 e1 04          	shl    $0x4,%rcx
 629:	48 01 c1             	add    %rax,%rcx
 62c:	48 39 ca             	cmp    %rcx,%rdx
 62f:	75 0a                	jne    63b <free+0x70>
    p->s.size += bp->s.size;
 631:	03 77 f8             	add    -0x8(%rdi),%esi
 634:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 637:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 63b:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 63e:	48 89 05 9b 05 00 00 	mov    %rax,0x59b(%rip)        # be0 <freep>
}
 645:	5d                   	pop    %rbp
 646:	c3                   	retq   

0000000000000647 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 647:	55                   	push   %rbp
 648:	48 89 e5             	mov    %rsp,%rbp
 64b:	41 55                	push   %r13
 64d:	41 54                	push   %r12
 64f:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 650:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 652:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 653:	48 8b 0d 86 05 00 00 	mov    0x586(%rip),%rcx        # be0 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 65a:	48 83 c3 0f          	add    $0xf,%rbx
 65e:	48 c1 eb 04          	shr    $0x4,%rbx
 662:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 664:	48 85 c9             	test   %rcx,%rcx
 667:	75 27                	jne    690 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 669:	48 c7 05 6c 05 00 00 	movq   $0xbf0,0x56c(%rip)        # be0 <freep>
 670:	f0 0b 00 00 
 674:	48 c7 05 71 05 00 00 	movq   $0xbf0,0x571(%rip)        # bf0 <base>
 67b:	f0 0b 00 00 
 67f:	48 c7 c1 f0 0b 00 00 	mov    $0xbf0,%rcx
    base.s.size = 0;
 686:	c7 05 68 05 00 00 00 	movl   $0x0,0x568(%rip)        # bf8 <base+0x8>
 68d:	00 00 00 
 690:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 696:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 69c:	48 8b 01             	mov    (%rcx),%rax
 69f:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6a3:	45 89 e5             	mov    %r12d,%r13d
 6a6:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6aa:	8b 50 08             	mov    0x8(%rax),%edx
 6ad:	39 d3                	cmp    %edx,%ebx
 6af:	77 26                	ja     6d7 <malloc+0x90>
      if(p->s.size == nunits)
 6b1:	75 08                	jne    6bb <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 6b3:	48 8b 10             	mov    (%rax),%rdx
 6b6:	48 89 11             	mov    %rdx,(%rcx)
 6b9:	eb 0f                	jmp    6ca <malloc+0x83>
      else {
        p->s.size -= nunits;
 6bb:	29 da                	sub    %ebx,%edx
 6bd:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 6c0:	48 c1 e2 04          	shl    $0x4,%rdx
 6c4:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 6c7:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 6ca:	48 89 0d 0f 05 00 00 	mov    %rcx,0x50f(%rip)        # be0 <freep>
      return (void*)(p + 1);
 6d1:	48 83 c0 10          	add    $0x10,%rax
 6d5:	eb 3a                	jmp    711 <malloc+0xca>
    }
    if(p == freep)
 6d7:	48 3b 05 02 05 00 00 	cmp    0x502(%rip),%rax        # be0 <freep>
 6de:	75 27                	jne    707 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6e0:	44 89 ef             	mov    %r13d,%edi
 6e3:	e8 52 fc ff ff       	callq  33a <sbrk>
  if(p == (char*)-1)
 6e8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 6ec:	74 21                	je     70f <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 6ee:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6f2:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 6f6:	e8 d0 fe ff ff       	callq  5cb <free>
  return freep;
 6fb:	48 8b 05 de 04 00 00 	mov    0x4de(%rip),%rax        # be0 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 702:	48 85 c0             	test   %rax,%rax
 705:	74 08                	je     70f <malloc+0xc8>
        return 0;
  }
 707:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70a:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 70d:	eb 9b                	jmp    6aa <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 70f:	31 c0                	xor    %eax,%eax
  }
}
 711:	5a                   	pop    %rdx
 712:	5b                   	pop    %rbx
 713:	41 5c                	pop    %r12
 715:	41 5d                	pop    %r13
 717:	5d                   	pop    %rbp
 718:	c3                   	retq   
