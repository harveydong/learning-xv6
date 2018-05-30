
.fs/stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int fd, i;
  char path[] = "stressfs0";
   1:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
   8:	73 66 73 
  char data[512];

  printf(1, "stressfs starting\n");
   b:	48 c7 c6 e0 06 00 00 	mov    $0x6e0,%rsi
  12:	bf 01 00 00 00       	mov    $0x1,%edi
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  17:	48 89 e5             	mov    %rsp,%rbp
  1a:	41 54                	push   %r12
  1c:	53                   	push   %rbx
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  1d:	31 db                	xor    %ebx,%ebx
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  1f:	48 81 ec 10 02 00 00 	sub    $0x210,%rsp
  int fd, i;
  char path[] = "stressfs0";
  26:	48 89 85 e6 fd ff ff 	mov    %rax,-0x21a(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
  2d:	31 c0                	xor    %eax,%eax

int
main(int argc, char *argv[])
{
  int fd, i;
  char path[] = "stressfs0";
  2f:	66 c7 85 ee fd ff ff 	movw   $0x30,-0x212(%rbp)
  36:	30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  38:	e8 65 03 00 00       	callq  3a2 <printf>
  memset(data, 'a', sizeof(data));
  3d:	48 8d bd f0 fd ff ff 	lea    -0x210(%rbp),%rdi
  44:	ba 00 02 00 00       	mov    $0x200,%edx
  49:	be 61 00 00 00       	mov    $0x61,%esi
  4e:	e8 05 01 00 00       	callq  158 <memset>

  for(i = 0; i < 4; i++)
    if(fork() > 0)
  53:	e8 0f 02 00 00       	callq  267 <fork>
  58:	85 c0                	test   %eax,%eax
  5a:	7f 07                	jg     63 <main+0x63>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  5c:	ff c3                	inc    %ebx
  5e:	83 fb 04             	cmp    $0x4,%ebx
  61:	75 f0                	jne    53 <main+0x53>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  63:	89 da                	mov    %ebx,%edx
  65:	48 c7 c6 f3 06 00 00 	mov    $0x6f3,%rsi
  6c:	bf 01 00 00 00       	mov    $0x1,%edi
  71:	31 c0                	xor    %eax,%eax
  73:	e8 2a 03 00 00       	callq  3a2 <printf>

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  78:	48 8d bd e6 fd ff ff 	lea    -0x21a(%rbp),%rdi
  7f:	be 02 02 00 00       	mov    $0x202,%esi
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);

  path[8] += i;
  84:	00 9d ee fd ff ff    	add    %bl,-0x212(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
  8a:	bb 14 00 00 00       	mov    $0x14,%ebx
  8f:	e8 1b 02 00 00       	callq  2af <open>
  94:	41 89 c4             	mov    %eax,%r12d
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  97:	48 8d b5 f0 fd ff ff 	lea    -0x210(%rbp),%rsi
  9e:	ba 00 02 00 00       	mov    $0x200,%edx
  a3:	44 89 e7             	mov    %r12d,%edi
  a6:	e8 e4 01 00 00       	callq  28f <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  ab:	ff cb                	dec    %ebx
  ad:	75 e8                	jne    97 <main+0x97>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  af:	44 89 e7             	mov    %r12d,%edi

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  b2:	bb 14 00 00 00       	mov    $0x14,%ebx
  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  b7:	e8 db 01 00 00       	callq  297 <close>

  printf(1, "read\n");
  bc:	48 c7 c6 fd 06 00 00 	mov    $0x6fd,%rsi
  c3:	bf 01 00 00 00       	mov    $0x1,%edi
  c8:	31 c0                	xor    %eax,%eax
  ca:	e8 d3 02 00 00       	callq  3a2 <printf>

  fd = open(path, O_RDONLY);
  cf:	48 8d bd e6 fd ff ff 	lea    -0x21a(%rbp),%rdi
  d6:	31 f6                	xor    %esi,%esi
  d8:	e8 d2 01 00 00       	callq  2af <open>
  dd:	41 89 c4             	mov    %eax,%r12d
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e0:	48 8d b5 f0 fd ff ff 	lea    -0x210(%rbp),%rsi
  e7:	ba 00 02 00 00       	mov    $0x200,%edx
  ec:	44 89 e7             	mov    %r12d,%edi
  ef:	e8 93 01 00 00       	callq  287 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
  f4:	ff cb                	dec    %ebx
  f6:	75 e8                	jne    e0 <main+0xe0>
    read(fd, data, sizeof(data));
  close(fd);
  f8:	44 89 e7             	mov    %r12d,%edi
  fb:	e8 97 01 00 00       	callq  297 <close>

  wait();
 100:	e8 72 01 00 00       	callq  277 <wait>
  
  exit();
 105:	e8 65 01 00 00       	callq  26f <exit>

000000000000010a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 10a:	55                   	push   %rbp
 10b:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10e:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 110:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 113:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
 116:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
 119:	48 ff c2             	inc    %rdx
 11c:	84 c9                	test   %cl,%cl
 11e:	75 f3                	jne    113 <strcpy+0x9>
    ;
  return os;
}
 120:	5d                   	pop    %rbp
 121:	c3                   	retq   

0000000000000122 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 122:	55                   	push   %rbp
 123:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
 126:	0f b6 07             	movzbl (%rdi),%eax
 129:	84 c0                	test   %al,%al
 12b:	74 0c                	je     139 <strcmp+0x17>
 12d:	3a 06                	cmp    (%rsi),%al
 12f:	75 08                	jne    139 <strcmp+0x17>
    p++, q++;
 131:	48 ff c7             	inc    %rdi
 134:	48 ff c6             	inc    %rsi
 137:	eb ed                	jmp    126 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 139:	0f b6 16             	movzbl (%rsi),%edx
}
 13c:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 13d:	29 d0                	sub    %edx,%eax
}
 13f:	c3                   	retq   

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 141:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 143:	48 89 e5             	mov    %rsp,%rbp
 146:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 14a:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 14f:	74 05                	je     156 <strlen+0x16>
 151:	48 89 d0             	mov    %rdx,%rax
 154:	eb f0                	jmp    146 <strlen+0x6>
    ;
  return n;
}
 156:	5d                   	pop    %rbp
 157:	c3                   	retq   

0000000000000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	55                   	push   %rbp
 159:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 15c:	89 d1                	mov    %edx,%ecx
 15e:	89 f0                	mov    %esi,%eax
 160:	48 89 e5             	mov    %rsp,%rbp
 163:	fc                   	cld    
 164:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 166:	4c 89 c0             	mov    %r8,%rax
 169:	5d                   	pop    %rbp
 16a:	c3                   	retq   

000000000000016b <strchr>:

char*
strchr(const char *s, char c)
{
 16b:	55                   	push   %rbp
 16c:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 16f:	8a 07                	mov    (%rdi),%al
 171:	84 c0                	test   %al,%al
 173:	74 0a                	je     17f <strchr+0x14>
    if(*s == c)
 175:	40 38 f0             	cmp    %sil,%al
 178:	74 09                	je     183 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17a:	48 ff c7             	inc    %rdi
 17d:	eb f0                	jmp    16f <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 17f:	31 c0                	xor    %eax,%eax
 181:	eb 03                	jmp    186 <strchr+0x1b>
 183:	48 89 f8             	mov    %rdi,%rax
}
 186:	5d                   	pop    %rbp
 187:	c3                   	retq   

0000000000000188 <gets>:

char*
gets(char *buf, int max)
{
 188:	55                   	push   %rbp
 189:	48 89 e5             	mov    %rsp,%rbp
 18c:	41 57                	push   %r15
 18e:	41 56                	push   %r14
 190:	41 55                	push   %r13
 192:	41 54                	push   %r12
 194:	41 89 f7             	mov    %esi,%r15d
 197:	53                   	push   %rbx
 198:	49 89 fc             	mov    %rdi,%r12
 19b:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 1a0:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 1a8:	45 39 fd             	cmp    %r15d,%r13d
 1ab:	7d 2c                	jge    1d9 <gets+0x51>
    cc = read(0, &c, 1);
 1ad:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 1b1:	31 ff                	xor    %edi,%edi
 1b3:	ba 01 00 00 00       	mov    $0x1,%edx
 1b8:	e8 ca 00 00 00       	callq  287 <read>
    if(cc < 1)
 1bd:	85 c0                	test   %eax,%eax
 1bf:	7e 18                	jle    1d9 <gets+0x51>
      break;
    buf[i++] = c;
 1c1:	8a 45 cf             	mov    -0x31(%rbp),%al
 1c4:	49 ff c6             	inc    %r14
 1c7:	49 63 dd             	movslq %r13d,%rbx
 1ca:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 1ce:	3c 0a                	cmp    $0xa,%al
 1d0:	74 04                	je     1d6 <gets+0x4e>
 1d2:	3c 0d                	cmp    $0xd,%al
 1d4:	75 ce                	jne    1a4 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d9:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 1de:	48 83 c4 18          	add    $0x18,%rsp
 1e2:	4c 89 e0             	mov    %r12,%rax
 1e5:	5b                   	pop    %rbx
 1e6:	41 5c                	pop    %r12
 1e8:	41 5d                	pop    %r13
 1ea:	41 5e                	pop    %r14
 1ec:	41 5f                	pop    %r15
 1ee:	5d                   	pop    %rbp
 1ef:	c3                   	retq   

00000000000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %rbp
 1f1:	48 89 e5             	mov    %rsp,%rbp
 1f4:	41 54                	push   %r12
 1f6:	53                   	push   %rbx
 1f7:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	31 f6                	xor    %esi,%esi
 1fc:	e8 ae 00 00 00       	callq  2af <open>
 201:	41 89 c4             	mov    %eax,%r12d
 204:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 207:	45 85 e4             	test   %r12d,%r12d
 20a:	78 17                	js     223 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 20c:	48 89 de             	mov    %rbx,%rsi
 20f:	44 89 e7             	mov    %r12d,%edi
 212:	e8 b0 00 00 00       	callq  2c7 <fstat>
  close(fd);
 217:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 21a:	89 c3                	mov    %eax,%ebx
  close(fd);
 21c:	e8 76 00 00 00       	callq  297 <close>
  return r;
 221:	89 d8                	mov    %ebx,%eax
}
 223:	5b                   	pop    %rbx
 224:	41 5c                	pop    %r12
 226:	5d                   	pop    %rbp
 227:	c3                   	retq   

0000000000000228 <atoi>:

int
atoi(const char *s)
{
 228:	55                   	push   %rbp
  int n;

  n = 0;
 229:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 22b:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22e:	0f be 17             	movsbl (%rdi),%edx
 231:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 234:	80 f9 09             	cmp    $0x9,%cl
 237:	77 0c                	ja     245 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 239:	6b c0 0a             	imul   $0xa,%eax,%eax
 23c:	48 ff c7             	inc    %rdi
 23f:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 243:	eb e9                	jmp    22e <atoi+0x6>
  return n;
}
 245:	5d                   	pop    %rbp
 246:	c3                   	retq   

0000000000000247 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 247:	55                   	push   %rbp
 248:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24b:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24d:	48 89 e5             	mov    %rsp,%rbp
 250:	89 d7                	mov    %edx,%edi
 252:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 254:	85 ff                	test   %edi,%edi
 256:	7e 0d                	jle    265 <memmove+0x1e>
    *dst++ = *src++;
 258:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 25c:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 260:	48 ff c1             	inc    %rcx
 263:	eb eb                	jmp    250 <memmove+0x9>
  return vdst;
}
 265:	5d                   	pop    %rbp
 266:	c3                   	retq   

0000000000000267 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 267:	b8 01 00 00 00       	mov    $0x1,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	retq   

000000000000026f <exit>:
SYSCALL(exit)
 26f:	b8 02 00 00 00       	mov    $0x2,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	retq   

0000000000000277 <wait>:
SYSCALL(wait)
 277:	b8 03 00 00 00       	mov    $0x3,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	retq   

000000000000027f <pipe>:
SYSCALL(pipe)
 27f:	b8 04 00 00 00       	mov    $0x4,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	retq   

0000000000000287 <read>:
SYSCALL(read)
 287:	b8 05 00 00 00       	mov    $0x5,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	retq   

000000000000028f <write>:
SYSCALL(write)
 28f:	b8 10 00 00 00       	mov    $0x10,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	retq   

0000000000000297 <close>:
SYSCALL(close)
 297:	b8 15 00 00 00       	mov    $0x15,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	retq   

000000000000029f <kill>:
SYSCALL(kill)
 29f:	b8 06 00 00 00       	mov    $0x6,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	retq   

00000000000002a7 <exec>:
SYSCALL(exec)
 2a7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	retq   

00000000000002af <open>:
SYSCALL(open)
 2af:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	retq   

00000000000002b7 <mknod>:
SYSCALL(mknod)
 2b7:	b8 11 00 00 00       	mov    $0x11,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	retq   

00000000000002bf <unlink>:
SYSCALL(unlink)
 2bf:	b8 12 00 00 00       	mov    $0x12,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	retq   

00000000000002c7 <fstat>:
SYSCALL(fstat)
 2c7:	b8 08 00 00 00       	mov    $0x8,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	retq   

00000000000002cf <link>:
SYSCALL(link)
 2cf:	b8 13 00 00 00       	mov    $0x13,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	retq   

00000000000002d7 <mkdir>:
SYSCALL(mkdir)
 2d7:	b8 14 00 00 00       	mov    $0x14,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	retq   

00000000000002df <chdir>:
SYSCALL(chdir)
 2df:	b8 09 00 00 00       	mov    $0x9,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	retq   

00000000000002e7 <dup>:
SYSCALL(dup)
 2e7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	retq   

00000000000002ef <getpid>:
SYSCALL(getpid)
 2ef:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	retq   

00000000000002f7 <sbrk>:
SYSCALL(sbrk)
 2f7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	retq   

00000000000002ff <sleep>:
SYSCALL(sleep)
 2ff:	b8 0d 00 00 00       	mov    $0xd,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	retq   

0000000000000307 <uptime>:
SYSCALL(uptime)
 307:	b8 0e 00 00 00       	mov    $0xe,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	retq   

000000000000030f <chmod>:
SYSCALL(chmod)
 30f:	b8 16 00 00 00       	mov    $0x16,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	retq   

0000000000000317 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 317:	55                   	push   %rbp
 318:	41 89 d0             	mov    %edx,%r8d
 31b:	48 89 e5             	mov    %rsp,%rbp
 31e:	41 54                	push   %r12
 320:	53                   	push   %rbx
 321:	41 89 fc             	mov    %edi,%r12d
 324:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 328:	85 c9                	test   %ecx,%ecx
 32a:	74 12                	je     33e <printint+0x27>
 32c:	89 f0                	mov    %esi,%eax
 32e:	c1 e8 1f             	shr    $0x1f,%eax
 331:	74 0b                	je     33e <printint+0x27>
    neg = 1;
    x = -xx;
 333:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 335:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 33a:	f7 d8                	neg    %eax
 33c:	eb 04                	jmp    342 <printint+0x2b>
  } else {
    x = xx;
 33e:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 340:	31 f6                	xor    %esi,%esi
 342:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 346:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 348:	31 d2                	xor    %edx,%edx
 34a:	48 ff c7             	inc    %rdi
 34d:	8d 59 01             	lea    0x1(%rcx),%ebx
 350:	41 f7 f0             	div    %r8d
 353:	89 d2                	mov    %edx,%edx
 355:	8a 92 10 07 00 00    	mov    0x710(%rdx),%dl
 35b:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 35e:	85 c0                	test   %eax,%eax
 360:	74 04                	je     366 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 362:	89 d9                	mov    %ebx,%ecx
 364:	eb e2                	jmp    348 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 366:	85 f6                	test   %esi,%esi
 368:	74 0b                	je     375 <printint+0x5e>
    buf[i++] = '-';
 36a:	48 63 db             	movslq %ebx,%rbx
 36d:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 372:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 375:	ff cb                	dec    %ebx
 377:	83 fb ff             	cmp    $0xffffffff,%ebx
 37a:	74 1d                	je     399 <printint+0x82>
    putc(fd, buf[i]);
 37c:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 37f:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 383:	ba 01 00 00 00       	mov    $0x1,%edx
 388:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 38c:	44 89 e7             	mov    %r12d,%edi
 38f:	88 45 df             	mov    %al,-0x21(%rbp)
 392:	e8 f8 fe ff ff       	callq  28f <write>
 397:	eb dc                	jmp    375 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 399:	48 83 c4 20          	add    $0x20,%rsp
 39d:	5b                   	pop    %rbx
 39e:	41 5c                	pop    %r12
 3a0:	5d                   	pop    %rbp
 3a1:	c3                   	retq   

00000000000003a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3a2:	55                   	push   %rbp
 3a3:	48 89 e5             	mov    %rsp,%rbp
 3a6:	41 56                	push   %r14
 3a8:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 3aa:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3ae:	41 54                	push   %r12
 3b0:	53                   	push   %rbx
 3b1:	41 89 fc             	mov    %edi,%r12d
 3b4:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 3b7:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3b9:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 3bd:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 3c1:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 3c9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 3cd:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 3d1:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 3d5:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 3dc:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 3e0:	45 8a 2e             	mov    (%r14),%r13b
 3e3:	45 84 ed             	test   %r13b,%r13b
 3e6:	0f 84 8f 01 00 00    	je     57b <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 3ec:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3ee:	41 0f be d5          	movsbl %r13b,%edx
 3f2:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 3f6:	75 23                	jne    41b <printf+0x79>
      if(c == '%'){
 3f8:	83 f8 25             	cmp    $0x25,%eax
 3fb:	0f 84 6d 01 00 00    	je     56e <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 401:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 405:	ba 01 00 00 00       	mov    $0x1,%edx
 40a:	44 89 e7             	mov    %r12d,%edi
 40d:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 411:	e8 79 fe ff ff       	callq  28f <write>
 416:	e9 58 01 00 00       	jmpq   573 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 41b:	83 fb 25             	cmp    $0x25,%ebx
 41e:	0f 85 4f 01 00 00    	jne    573 <printf+0x1d1>
      if(c == 'd'){
 424:	83 f8 64             	cmp    $0x64,%eax
 427:	75 2e                	jne    457 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 429:	8b 55 98             	mov    -0x68(%rbp),%edx
 42c:	83 fa 2f             	cmp    $0x2f,%edx
 42f:	77 0e                	ja     43f <printf+0x9d>
 431:	89 d0                	mov    %edx,%eax
 433:	83 c2 08             	add    $0x8,%edx
 436:	48 03 45 a8          	add    -0x58(%rbp),%rax
 43a:	89 55 98             	mov    %edx,-0x68(%rbp)
 43d:	eb 0c                	jmp    44b <printf+0xa9>
 43f:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 443:	48 8d 50 08          	lea    0x8(%rax),%rdx
 447:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 44b:	b9 01 00 00 00       	mov    $0x1,%ecx
 450:	ba 0a 00 00 00       	mov    $0xa,%edx
 455:	eb 34                	jmp    48b <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 457:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 45d:	83 fa 70             	cmp    $0x70,%edx
 460:	75 38                	jne    49a <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 462:	8b 55 98             	mov    -0x68(%rbp),%edx
 465:	83 fa 2f             	cmp    $0x2f,%edx
 468:	77 0e                	ja     478 <printf+0xd6>
 46a:	89 d0                	mov    %edx,%eax
 46c:	83 c2 08             	add    $0x8,%edx
 46f:	48 03 45 a8          	add    -0x58(%rbp),%rax
 473:	89 55 98             	mov    %edx,-0x68(%rbp)
 476:	eb 0c                	jmp    484 <printf+0xe2>
 478:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 47c:	48 8d 50 08          	lea    0x8(%rax),%rdx
 480:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 484:	31 c9                	xor    %ecx,%ecx
 486:	ba 10 00 00 00       	mov    $0x10,%edx
 48b:	8b 30                	mov    (%rax),%esi
 48d:	44 89 e7             	mov    %r12d,%edi
 490:	e8 82 fe ff ff       	callq  317 <printint>
 495:	e9 d0 00 00 00       	jmpq   56a <printf+0x1c8>
      } else if(c == 's'){
 49a:	83 f8 73             	cmp    $0x73,%eax
 49d:	75 56                	jne    4f5 <printf+0x153>
        s = va_arg(ap, char*);
 49f:	8b 55 98             	mov    -0x68(%rbp),%edx
 4a2:	83 fa 2f             	cmp    $0x2f,%edx
 4a5:	77 0e                	ja     4b5 <printf+0x113>
 4a7:	89 d0                	mov    %edx,%eax
 4a9:	83 c2 08             	add    $0x8,%edx
 4ac:	48 03 45 a8          	add    -0x58(%rbp),%rax
 4b0:	89 55 98             	mov    %edx,-0x68(%rbp)
 4b3:	eb 0c                	jmp    4c1 <printf+0x11f>
 4b5:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 4b9:	48 8d 50 08          	lea    0x8(%rax),%rdx
 4bd:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 4c1:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 4c4:	48 c7 c0 03 07 00 00 	mov    $0x703,%rax
 4cb:	48 85 db             	test   %rbx,%rbx
 4ce:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 4d2:	8a 03                	mov    (%rbx),%al
 4d4:	84 c0                	test   %al,%al
 4d6:	0f 84 8e 00 00 00    	je     56a <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4dc:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 4e0:	ba 01 00 00 00       	mov    $0x1,%edx
 4e5:	44 89 e7             	mov    %r12d,%edi
 4e8:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4eb:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ee:	e8 9c fd ff ff       	callq  28f <write>
 4f3:	eb dd                	jmp    4d2 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f5:	83 f8 63             	cmp    $0x63,%eax
 4f8:	75 32                	jne    52c <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 4fa:	8b 55 98             	mov    -0x68(%rbp),%edx
 4fd:	83 fa 2f             	cmp    $0x2f,%edx
 500:	77 0e                	ja     510 <printf+0x16e>
 502:	89 d0                	mov    %edx,%eax
 504:	83 c2 08             	add    $0x8,%edx
 507:	48 03 45 a8          	add    -0x58(%rbp),%rax
 50b:	89 55 98             	mov    %edx,-0x68(%rbp)
 50e:	eb 0c                	jmp    51c <printf+0x17a>
 510:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 514:	48 8d 50 08          	lea    0x8(%rax),%rdx
 518:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 51c:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51e:	ba 01 00 00 00       	mov    $0x1,%edx
 523:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 527:	88 45 94             	mov    %al,-0x6c(%rbp)
 52a:	eb 36                	jmp    562 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 52c:	83 f8 25             	cmp    $0x25,%eax
 52f:	75 0f                	jne    540 <printf+0x19e>
 531:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 535:	ba 01 00 00 00       	mov    $0x1,%edx
 53a:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 53e:	eb 22                	jmp    562 <printf+0x1c0>
 540:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 544:	ba 01 00 00 00       	mov    $0x1,%edx
 549:	44 89 e7             	mov    %r12d,%edi
 54c:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 550:	e8 3a fd ff ff       	callq  28f <write>
 555:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 559:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 55d:	ba 01 00 00 00       	mov    $0x1,%edx
 562:	44 89 e7             	mov    %r12d,%edi
 565:	e8 25 fd ff ff       	callq  28f <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56a:	31 db                	xor    %ebx,%ebx
 56c:	eb 05                	jmp    573 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 56e:	bb 25 00 00 00       	mov    $0x25,%ebx
 573:	49 ff c6             	inc    %r14
 576:	e9 65 fe ff ff       	jmpq   3e0 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 57b:	48 83 c4 50          	add    $0x50,%rsp
 57f:	5b                   	pop    %rbx
 580:	41 5c                	pop    %r12
 582:	41 5d                	pop    %r13
 584:	41 5e                	pop    %r14
 586:	5d                   	pop    %rbp
 587:	c3                   	retq   

0000000000000588 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 588:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 589:	48 8b 05 c0 03 00 00 	mov    0x3c0(%rip),%rax        # 950 <__bss_start>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 590:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 594:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 597:	48 39 d0             	cmp    %rdx,%rax
 59a:	48 8b 08             	mov    (%rax),%rcx
 59d:	72 14                	jb     5b3 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59f:	48 39 c8             	cmp    %rcx,%rax
 5a2:	72 0a                	jb     5ae <free+0x26>
 5a4:	48 39 ca             	cmp    %rcx,%rdx
 5a7:	72 0f                	jb     5b8 <free+0x30>
 5a9:	48 39 d0             	cmp    %rdx,%rax
 5ac:	72 0a                	jb     5b8 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ae:	48 89 c8             	mov    %rcx,%rax
 5b1:	eb e4                	jmp    597 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	48 39 ca             	cmp    %rcx,%rdx
 5b6:	73 e7                	jae    59f <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b8:	8b 77 f8             	mov    -0x8(%rdi),%esi
 5bb:	49 89 f0             	mov    %rsi,%r8
 5be:	48 c1 e6 04          	shl    $0x4,%rsi
 5c2:	48 01 d6             	add    %rdx,%rsi
 5c5:	48 39 ce             	cmp    %rcx,%rsi
 5c8:	75 0e                	jne    5d8 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 5ca:	44 03 41 08          	add    0x8(%rcx),%r8d
 5ce:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d2:	48 8b 08             	mov    (%rax),%rcx
 5d5:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 5d8:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 5dc:	8b 48 08             	mov    0x8(%rax),%ecx
 5df:	48 89 ce             	mov    %rcx,%rsi
 5e2:	48 c1 e1 04          	shl    $0x4,%rcx
 5e6:	48 01 c1             	add    %rax,%rcx
 5e9:	48 39 ca             	cmp    %rcx,%rdx
 5ec:	75 0a                	jne    5f8 <free+0x70>
    p->s.size += bp->s.size;
 5ee:	03 77 f8             	add    -0x8(%rdi),%esi
 5f1:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 5f4:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 5f8:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 5fb:	48 89 05 4e 03 00 00 	mov    %rax,0x34e(%rip)        # 950 <__bss_start>
}
 602:	5d                   	pop    %rbp
 603:	c3                   	retq   

0000000000000604 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 604:	55                   	push   %rbp
 605:	48 89 e5             	mov    %rsp,%rbp
 608:	41 55                	push   %r13
 60a:	41 54                	push   %r12
 60c:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 60d:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 60f:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 610:	48 8b 0d 39 03 00 00 	mov    0x339(%rip),%rcx        # 950 <__bss_start>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 617:	48 83 c3 0f          	add    $0xf,%rbx
 61b:	48 c1 eb 04          	shr    $0x4,%rbx
 61f:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 621:	48 85 c9             	test   %rcx,%rcx
 624:	75 27                	jne    64d <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 626:	48 c7 05 1f 03 00 00 	movq   $0x960,0x31f(%rip)        # 950 <__bss_start>
 62d:	60 09 00 00 
 631:	48 c7 05 24 03 00 00 	movq   $0x960,0x324(%rip)        # 960 <base>
 638:	60 09 00 00 
 63c:	48 c7 c1 60 09 00 00 	mov    $0x960,%rcx
    base.s.size = 0;
 643:	c7 05 1b 03 00 00 00 	movl   $0x0,0x31b(%rip)        # 968 <base+0x8>
 64a:	00 00 00 
 64d:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 653:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 659:	48 8b 01             	mov    (%rcx),%rax
 65c:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 660:	45 89 e5             	mov    %r12d,%r13d
 663:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 667:	8b 50 08             	mov    0x8(%rax),%edx
 66a:	39 d3                	cmp    %edx,%ebx
 66c:	77 26                	ja     694 <malloc+0x90>
      if(p->s.size == nunits)
 66e:	75 08                	jne    678 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 670:	48 8b 10             	mov    (%rax),%rdx
 673:	48 89 11             	mov    %rdx,(%rcx)
 676:	eb 0f                	jmp    687 <malloc+0x83>
      else {
        p->s.size -= nunits;
 678:	29 da                	sub    %ebx,%edx
 67a:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 67d:	48 c1 e2 04          	shl    $0x4,%rdx
 681:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 684:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 687:	48 89 0d c2 02 00 00 	mov    %rcx,0x2c2(%rip)        # 950 <__bss_start>
      return (void*)(p + 1);
 68e:	48 83 c0 10          	add    $0x10,%rax
 692:	eb 3a                	jmp    6ce <malloc+0xca>
    }
    if(p == freep)
 694:	48 3b 05 b5 02 00 00 	cmp    0x2b5(%rip),%rax        # 950 <__bss_start>
 69b:	75 27                	jne    6c4 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 69d:	44 89 ef             	mov    %r13d,%edi
 6a0:	e8 52 fc ff ff       	callq  2f7 <sbrk>
  if(p == (char*)-1)
 6a5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 6a9:	74 21                	je     6cc <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 6ab:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6af:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 6b3:	e8 d0 fe ff ff       	callq  588 <free>
  return freep;
 6b8:	48 8b 05 91 02 00 00 	mov    0x291(%rip),%rax        # 950 <__bss_start>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6bf:	48 85 c0             	test   %rax,%rax
 6c2:	74 08                	je     6cc <malloc+0xc8>
        return 0;
  }
 6c4:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c7:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 6ca:	eb 9b                	jmp    667 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 6cc:	31 c0                	xor    %eax,%eax
  }
}
 6ce:	5a                   	pop    %rdx
 6cf:	5b                   	pop    %rbx
 6d0:	41 5c                	pop    %r12
 6d2:	41 5d                	pop    %r13
 6d4:	5d                   	pop    %rbp
 6d5:	c3                   	retq   
