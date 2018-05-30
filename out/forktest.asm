
.fs/forktest:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
  forktest();
   4:	e8 30 00 00 00       	callq  39 <forktest>
  exit();
   9:	e8 27 02 00 00       	callq  235 <exit>

000000000000000e <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   e:	55                   	push   %rbp
   f:	48 89 e5             	mov    %rsp,%rbp
  12:	53                   	push   %rbx
  13:	89 fb                	mov    %edi,%ebx
  write(fd, s, strlen(s));
  15:	48 89 f7             	mov    %rsi,%rdi

#define N  1000

void
printf(int fd, char *s, ...)
{
  18:	48 83 ec 18          	sub    $0x18,%rsp
  write(fd, s, strlen(s));
  1c:	48 89 75 e8          	mov    %rsi,-0x18(%rbp)
  20:	e8 e1 00 00 00       	callq  106 <strlen>
  25:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
  29:	89 df                	mov    %ebx,%edi
  2b:	89 c2                	mov    %eax,%edx
  2d:	e8 23 02 00 00       	callq  255 <write>
}
  32:	48 83 c4 18          	add    $0x18,%rsp
  36:	5b                   	pop    %rbx
  37:	5d                   	pop    %rbp
  38:	c3                   	retq   

0000000000000039 <forktest>:

void
forktest(void)
{
  39:	55                   	push   %rbp
  int n, pid;

  printf(1, "fork test\n");
  3a:	48 c7 c6 dd 02 00 00 	mov    $0x2dd,%rsi
  41:	bf 01 00 00 00       	mov    $0x1,%edi
  46:	31 c0                	xor    %eax,%eax
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  48:	48 89 e5             	mov    %rsp,%rbp
  4b:	53                   	push   %rbx
  4c:	51                   	push   %rcx
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  4d:	31 db                	xor    %ebx,%ebx
void
forktest(void)
{
  int n, pid;

  printf(1, "fork test\n");
  4f:	e8 ba ff ff ff       	callq  e <printf>

  for(n=0; n<N; n++){
    pid = fork();
  54:	e8 d4 01 00 00       	callq  22d <fork>
    if(pid < 0)
  59:	85 c0                	test   %eax,%eax
  5b:	78 2b                	js     88 <forktest+0x4f>
      break;
    if(pid == 0)
  5d:	74 22                	je     81 <forktest+0x48>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  5f:	ff c3                	inc    %ebx
  61:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  67:	75 eb                	jne    54 <forktest+0x1b>
    if(pid == 0)
      exit();
  }
  
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
  69:	ba e8 03 00 00       	mov    $0x3e8,%edx
  6e:	48 c7 c6 1d 03 00 00 	mov    $0x31d,%rsi
  75:	bf 01 00 00 00       	mov    $0x1,%edi
  7a:	31 c0                	xor    %eax,%eax
  7c:	e8 8d ff ff ff       	callq  e <printf>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
  81:	e8 af 01 00 00       	callq  235 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  86:	ff cb                	dec    %ebx
  88:	85 db                	test   %ebx,%ebx
  8a:	74 1e                	je     aa <forktest+0x71>
    if(wait() < 0){
  8c:	e8 ac 01 00 00       	callq  23d <wait>
  91:	85 c0                	test   %eax,%eax
  93:	79 f1                	jns    86 <forktest+0x4d>
      printf(1, "wait stopped early\n");
  95:	48 c7 c6 e8 02 00 00 	mov    $0x2e8,%rsi
  9c:	bf 01 00 00 00       	mov    $0x1,%edi
  a1:	31 c0                	xor    %eax,%eax
  a3:	e8 66 ff ff ff       	callq  e <printf>
  a8:	eb d7                	jmp    81 <forktest+0x48>
      exit();
    }
  }
  
  if(wait() != -1){
  aa:	e8 8e 01 00 00       	callq  23d <wait>
  af:	ff c0                	inc    %eax
    printf(1, "wait got too many\n");
  b1:	48 c7 c6 fc 02 00 00 	mov    $0x2fc,%rsi
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  b8:	75 e2                	jne    9c <forktest+0x63>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
}
  ba:	5a                   	pop    %rdx
  bb:	5b                   	pop    %rbx
  bc:	5d                   	pop    %rbp
  if(wait() != -1){
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
  bd:	48 c7 c6 0f 03 00 00 	mov    $0x30f,%rsi
  c4:	bf 01 00 00 00       	mov    $0x1,%edi
  c9:	31 c0                	xor    %eax,%eax
  cb:	e9 3e ff ff ff       	jmpq   e <printf>

00000000000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %rbp
  d1:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d6:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d9:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
  dc:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  df:	48 ff c2             	inc    %rdx
  e2:	84 c9                	test   %cl,%cl
  e4:	75 f3                	jne    d9 <strcpy+0x9>
    ;
  return os;
}
  e6:	5d                   	pop    %rbp
  e7:	c3                   	retq   

00000000000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	55                   	push   %rbp
  e9:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
  ec:	0f b6 07             	movzbl (%rdi),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 0c                	je     ff <strcmp+0x17>
  f3:	3a 06                	cmp    (%rsi),%al
  f5:	75 08                	jne    ff <strcmp+0x17>
    p++, q++;
  f7:	48 ff c7             	inc    %rdi
  fa:	48 ff c6             	inc    %rsi
  fd:	eb ed                	jmp    ec <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
  ff:	0f b6 16             	movzbl (%rsi),%edx
}
 102:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 103:	29 d0                	sub    %edx,%eax
}
 105:	c3                   	retq   

0000000000000106 <strlen>:

uint
strlen(const char *s)
{
 106:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 107:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 109:	48 89 e5             	mov    %rsp,%rbp
 10c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 110:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 115:	74 05                	je     11c <strlen+0x16>
 117:	48 89 d0             	mov    %rdx,%rax
 11a:	eb f0                	jmp    10c <strlen+0x6>
    ;
  return n;
}
 11c:	5d                   	pop    %rbp
 11d:	c3                   	retq   

000000000000011e <memset>:

void*
memset(void *dst, int c, uint n)
{
 11e:	55                   	push   %rbp
 11f:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 122:	89 d1                	mov    %edx,%ecx
 124:	89 f0                	mov    %esi,%eax
 126:	48 89 e5             	mov    %rsp,%rbp
 129:	fc                   	cld    
 12a:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 12c:	4c 89 c0             	mov    %r8,%rax
 12f:	5d                   	pop    %rbp
 130:	c3                   	retq   

0000000000000131 <strchr>:

char*
strchr(const char *s, char c)
{
 131:	55                   	push   %rbp
 132:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 135:	8a 07                	mov    (%rdi),%al
 137:	84 c0                	test   %al,%al
 139:	74 0a                	je     145 <strchr+0x14>
    if(*s == c)
 13b:	40 38 f0             	cmp    %sil,%al
 13e:	74 09                	je     149 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 140:	48 ff c7             	inc    %rdi
 143:	eb f0                	jmp    135 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 145:	31 c0                	xor    %eax,%eax
 147:	eb 03                	jmp    14c <strchr+0x1b>
 149:	48 89 f8             	mov    %rdi,%rax
}
 14c:	5d                   	pop    %rbp
 14d:	c3                   	retq   

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	55                   	push   %rbp
 14f:	48 89 e5             	mov    %rsp,%rbp
 152:	41 57                	push   %r15
 154:	41 56                	push   %r14
 156:	41 55                	push   %r13
 158:	41 54                	push   %r12
 15a:	41 89 f7             	mov    %esi,%r15d
 15d:	53                   	push   %rbx
 15e:	49 89 fc             	mov    %rdi,%r12
 161:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 166:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 16e:	45 39 fd             	cmp    %r15d,%r13d
 171:	7d 2c                	jge    19f <gets+0x51>
    cc = read(0, &c, 1);
 173:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 177:	31 ff                	xor    %edi,%edi
 179:	ba 01 00 00 00       	mov    $0x1,%edx
 17e:	e8 ca 00 00 00       	callq  24d <read>
    if(cc < 1)
 183:	85 c0                	test   %eax,%eax
 185:	7e 18                	jle    19f <gets+0x51>
      break;
    buf[i++] = c;
 187:	8a 45 cf             	mov    -0x31(%rbp),%al
 18a:	49 ff c6             	inc    %r14
 18d:	49 63 dd             	movslq %r13d,%rbx
 190:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 194:	3c 0a                	cmp    $0xa,%al
 196:	74 04                	je     19c <gets+0x4e>
 198:	3c 0d                	cmp    $0xd,%al
 19a:	75 ce                	jne    16a <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19f:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 1a4:	48 83 c4 18          	add    $0x18,%rsp
 1a8:	4c 89 e0             	mov    %r12,%rax
 1ab:	5b                   	pop    %rbx
 1ac:	41 5c                	pop    %r12
 1ae:	41 5d                	pop    %r13
 1b0:	41 5e                	pop    %r14
 1b2:	41 5f                	pop    %r15
 1b4:	5d                   	pop    %rbp
 1b5:	c3                   	retq   

00000000000001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b6:	55                   	push   %rbp
 1b7:	48 89 e5             	mov    %rsp,%rbp
 1ba:	41 54                	push   %r12
 1bc:	53                   	push   %rbx
 1bd:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c0:	31 f6                	xor    %esi,%esi
 1c2:	e8 ae 00 00 00       	callq  275 <open>
 1c7:	41 89 c4             	mov    %eax,%r12d
 1ca:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 1cd:	45 85 e4             	test   %r12d,%r12d
 1d0:	78 17                	js     1e9 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 1d2:	48 89 de             	mov    %rbx,%rsi
 1d5:	44 89 e7             	mov    %r12d,%edi
 1d8:	e8 b0 00 00 00       	callq  28d <fstat>
  close(fd);
 1dd:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1e0:	89 c3                	mov    %eax,%ebx
  close(fd);
 1e2:	e8 76 00 00 00       	callq  25d <close>
  return r;
 1e7:	89 d8                	mov    %ebx,%eax
}
 1e9:	5b                   	pop    %rbx
 1ea:	41 5c                	pop    %r12
 1ec:	5d                   	pop    %rbp
 1ed:	c3                   	retq   

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	55                   	push   %rbp
  int n;

  n = 0;
 1ef:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 1f1:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	0f be 17             	movsbl (%rdi),%edx
 1f7:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 1fa:	80 f9 09             	cmp    $0x9,%cl
 1fd:	77 0c                	ja     20b <atoi+0x1d>
    n = n*10 + *s++ - '0';
 1ff:	6b c0 0a             	imul   $0xa,%eax,%eax
 202:	48 ff c7             	inc    %rdi
 205:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 209:	eb e9                	jmp    1f4 <atoi+0x6>
  return n;
}
 20b:	5d                   	pop    %rbp
 20c:	c3                   	retq   

000000000000020d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20d:	55                   	push   %rbp
 20e:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 211:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 213:	48 89 e5             	mov    %rsp,%rbp
 216:	89 d7                	mov    %edx,%edi
 218:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21a:	85 ff                	test   %edi,%edi
 21c:	7e 0d                	jle    22b <memmove+0x1e>
    *dst++ = *src++;
 21e:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 222:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 226:	48 ff c1             	inc    %rcx
 229:	eb eb                	jmp    216 <memmove+0x9>
  return vdst;
}
 22b:	5d                   	pop    %rbp
 22c:	c3                   	retq   

000000000000022d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 22d:	b8 01 00 00 00       	mov    $0x1,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	retq   

0000000000000235 <exit>:
SYSCALL(exit)
 235:	b8 02 00 00 00       	mov    $0x2,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	retq   

000000000000023d <wait>:
SYSCALL(wait)
 23d:	b8 03 00 00 00       	mov    $0x3,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	retq   

0000000000000245 <pipe>:
SYSCALL(pipe)
 245:	b8 04 00 00 00       	mov    $0x4,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	retq   

000000000000024d <read>:
SYSCALL(read)
 24d:	b8 05 00 00 00       	mov    $0x5,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	retq   

0000000000000255 <write>:
SYSCALL(write)
 255:	b8 10 00 00 00       	mov    $0x10,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	retq   

000000000000025d <close>:
SYSCALL(close)
 25d:	b8 15 00 00 00       	mov    $0x15,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	retq   

0000000000000265 <kill>:
SYSCALL(kill)
 265:	b8 06 00 00 00       	mov    $0x6,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	retq   

000000000000026d <exec>:
SYSCALL(exec)
 26d:	b8 07 00 00 00       	mov    $0x7,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	retq   

0000000000000275 <open>:
SYSCALL(open)
 275:	b8 0f 00 00 00       	mov    $0xf,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	retq   

000000000000027d <mknod>:
SYSCALL(mknod)
 27d:	b8 11 00 00 00       	mov    $0x11,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	retq   

0000000000000285 <unlink>:
SYSCALL(unlink)
 285:	b8 12 00 00 00       	mov    $0x12,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	retq   

000000000000028d <fstat>:
SYSCALL(fstat)
 28d:	b8 08 00 00 00       	mov    $0x8,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	retq   

0000000000000295 <link>:
SYSCALL(link)
 295:	b8 13 00 00 00       	mov    $0x13,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	retq   

000000000000029d <mkdir>:
SYSCALL(mkdir)
 29d:	b8 14 00 00 00       	mov    $0x14,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	retq   

00000000000002a5 <chdir>:
SYSCALL(chdir)
 2a5:	b8 09 00 00 00       	mov    $0x9,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	retq   

00000000000002ad <dup>:
SYSCALL(dup)
 2ad:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	retq   

00000000000002b5 <getpid>:
SYSCALL(getpid)
 2b5:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	retq   

00000000000002bd <sbrk>:
SYSCALL(sbrk)
 2bd:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	retq   

00000000000002c5 <sleep>:
SYSCALL(sleep)
 2c5:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	retq   

00000000000002cd <uptime>:
SYSCALL(uptime)
 2cd:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	retq   

00000000000002d5 <chmod>:
SYSCALL(chmod)
 2d5:	b8 16 00 00 00       	mov    $0x16,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	retq   
