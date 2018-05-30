
.fs/ls:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int i;

  if(argc < 2){
   1:	83 ff 01             	cmp    $0x1,%edi
  close(fd);
}

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
   d:	7f 0e                	jg     1d <main+0x1d>
    ls(".");
   f:	48 c7 c7 78 09 00 00 	mov    $0x978,%rdi
  16:	e8 b0 00 00 00       	callq  cb <ls>
  1b:	eb 1e                	jmp    3b <main+0x3b>
  1d:	44 8d 67 fe          	lea    -0x2(%rdi),%r12d
  21:	49 89 f5             	mov    %rsi,%r13
int
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
  24:	31 db                	xor    %ebx,%ebx
  26:	49 ff c4             	inc    %r12
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  29:	49 8b 7c dd 08       	mov    0x8(%r13,%rbx,8),%rdi
  2e:	48 ff c3             	inc    %rbx
  31:	e8 95 00 00 00       	callq  cb <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	49 39 dc             	cmp    %rbx,%r12
  39:	75 ee                	jne    29 <main+0x29>
    ls(argv[i]);
  exit();
  3b:	e8 62 04 00 00       	callq  4a2 <exit>

0000000000000040 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
  40:	55                   	push   %rbp
  41:	48 89 e5             	mov    %rsp,%rbp
  44:	41 54                	push   %r12
  46:	53                   	push   %rbx
  47:	49 89 fc             	mov    %rdi,%r12
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  4a:	e8 24 03 00 00       	callq  373 <strlen>
  4f:	89 c3                	mov    %eax,%ebx
  51:	4c 01 e3             	add    %r12,%rbx
  54:	4c 39 e3             	cmp    %r12,%rbx
  57:	73 60                	jae    b9 <fmtname+0x79>
    ;
  p++;
  59:	48 ff c3             	inc    %rbx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  5c:	48 89 df             	mov    %rbx,%rdi
  5f:	e8 0f 03 00 00       	callq  373 <strlen>
  64:	83 f8 0d             	cmp    $0xd,%eax
  67:	77 5a                	ja     c3 <fmtname+0x83>
    return p;
  memmove(buf, p, strlen(p));
  69:	48 89 df             	mov    %rbx,%rdi
  6c:	e8 02 03 00 00       	callq  373 <strlen>
  71:	48 89 de             	mov    %rbx,%rsi
  74:	89 c2                	mov    %eax,%edx
  76:	48 c7 c7 30 0c 00 00 	mov    $0xc30,%rdi
  7d:	e8 f8 03 00 00       	callq  47a <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  82:	48 89 df             	mov    %rbx,%rdi
  85:	e8 e9 02 00 00       	callq  373 <strlen>
  8a:	48 89 df             	mov    %rbx,%rdi
  8d:	41 89 c4             	mov    %eax,%r12d
  return buf;
  90:	48 c7 c3 30 0c 00 00 	mov    $0xc30,%rbx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  97:	e8 d7 02 00 00       	callq  373 <strlen>
  9c:	ba 0e 00 00 00       	mov    $0xe,%edx
  a1:	89 c7                	mov    %eax,%edi
  a3:	be 20 00 00 00       	mov    $0x20,%esi
  a8:	44 29 e2             	sub    %r12d,%edx
  ab:	48 81 c7 30 0c 00 00 	add    $0xc30,%rdi
  b2:	e8 d4 02 00 00       	callq  38b <memset>
  return buf;
  b7:	eb 0a                	jmp    c3 <fmtname+0x83>
{
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  b9:	80 3b 2f             	cmpb   $0x2f,(%rbx)
  bc:	74 9b                	je     59 <fmtname+0x19>
  be:	48 ff cb             	dec    %rbx
  c1:	eb 91                	jmp    54 <fmtname+0x14>
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  c3:	48 89 d8             	mov    %rbx,%rax
  c6:	5b                   	pop    %rbx
  c7:	41 5c                	pop    %r12
  c9:	5d                   	pop    %rbp
  ca:	c3                   	retq   

00000000000000cb <ls>:

void
ls(char *path)
{
  cb:	55                   	push   %rbp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  cc:	31 f6                	xor    %esi,%esi
  return buf;
}

void
ls(char *path)
{
  ce:	48 89 e5             	mov    %rsp,%rbp
  d1:	41 57                	push   %r15
  d3:	41 56                	push   %r14
  d5:	41 55                	push   %r13
  d7:	41 54                	push   %r12
  d9:	53                   	push   %rbx
  da:	48 89 fb             	mov    %rdi,%rbx
  dd:	48 81 ec 58 02 00 00 	sub    $0x258,%rsp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  e4:	e8 f9 03 00 00       	callq  4e2 <open>
  e9:	85 c0                	test   %eax,%eax
  eb:	79 1b                	jns    108 <ls+0x3d>
    printf(2, "ls: cannot open %s\n", path);
  ed:	48 89 da             	mov    %rbx,%rdx
  f0:	48 c7 c6 10 09 00 00 	mov    $0x910,%rsi
  f7:	bf 02 00 00 00       	mov    $0x2,%edi
  fc:	31 c0                	xor    %eax,%eax
  fe:	e8 d2 04 00 00       	callq  5d5 <printf>
    return;
 103:	e9 26 02 00 00       	jmpq   32e <ls+0x263>
  }
  
  if(fstat(fd, &st) < 0){
 108:	48 8d b5 b4 fd ff ff 	lea    -0x24c(%rbp),%rsi
 10f:	89 c7                	mov    %eax,%edi
 111:	41 89 c4             	mov    %eax,%r12d
 114:	e8 e1 03 00 00       	callq  4fa <fstat>
 119:	85 c0                	test   %eax,%eax
 11b:	79 1b                	jns    138 <ls+0x6d>
    printf(2, "ls: cannot stat %s\n", path);
 11d:	48 89 da             	mov    %rbx,%rdx
 120:	48 c7 c6 24 09 00 00 	mov    $0x924,%rsi
 127:	bf 02 00 00 00       	mov    $0x2,%edi
 12c:	31 c0                	xor    %eax,%eax
 12e:	e8 a2 04 00 00       	callq  5d5 <printf>
 133:	e9 ee 01 00 00       	jmpq   326 <ls+0x25b>
    close(fd);
    return;
  }
  
  switch(st.type){
 138:	8b 85 b4 fd ff ff    	mov    -0x24c(%rbp),%eax
 13e:	66 83 f8 01          	cmp    $0x1,%ax
 142:	74 7e                	je     1c2 <ls+0xf7>
 144:	66 83 f8 02          	cmp    $0x2,%ax
 148:	0f 85 d8 01 00 00    	jne    326 <ls+0x25b>
  case T_FILE:
    printf(1, "%s %d %d %d %x %d %d\n", fmtname(path), st.type, st.ownerid, st.groupid, st.mode, st.ino, st.size);
 14e:	44 0f bf 8d c4 fd ff 	movswl -0x23c(%rbp),%r9d
 155:	ff 
 156:	44 0f bf 85 c2 fd ff 	movswl -0x23e(%rbp),%r8d
 15d:	ff 
 15e:	48 89 df             	mov    %rbx,%rdi
 161:	44 8b bd cc fd ff ff 	mov    -0x234(%rbp),%r15d
 168:	44 8b b5 bc fd ff ff 	mov    -0x244(%rbp),%r14d
 16f:	44 8b ad c8 fd ff ff 	mov    -0x238(%rbp),%r13d
 176:	44 89 8d 94 fd ff ff 	mov    %r9d,-0x26c(%rbp)
 17d:	44 89 85 98 fd ff ff 	mov    %r8d,-0x268(%rbp)
 184:	e8 b7 fe ff ff       	callq  40 <fmtname>
 189:	44 8b 8d 94 fd ff ff 	mov    -0x26c(%rbp),%r9d
 190:	44 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%r8d
 197:	48 89 c2             	mov    %rax,%rdx
 19a:	51                   	push   %rcx
 19b:	41 57                	push   %r15
 19d:	b9 02 00 00 00       	mov    $0x2,%ecx
 1a2:	41 56                	push   %r14
 1a4:	41 55                	push   %r13
 1a6:	48 c7 c6 38 09 00 00 	mov    $0x938,%rsi
 1ad:	bf 01 00 00 00       	mov    $0x1,%edi
 1b2:	31 c0                	xor    %eax,%eax
 1b4:	e8 1c 04 00 00       	callq  5d5 <printf>
    break;
 1b9:	48 83 c4 20          	add    $0x20,%rsp
 1bd:	e9 64 01 00 00       	jmpq   326 <ls+0x25b>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1c2:	48 89 df             	mov    %rbx,%rdi
 1c5:	e8 a9 01 00 00       	callq  373 <strlen>
 1ca:	83 c0 10             	add    $0x10,%eax
 1cd:	3d 00 02 00 00       	cmp    $0x200,%eax
 1d2:	76 18                	jbe    1ec <ls+0x121>
      printf(1, "ls: path too long\n");
 1d4:	48 c7 c6 4e 09 00 00 	mov    $0x94e,%rsi
 1db:	bf 01 00 00 00       	mov    $0x1,%edi
 1e0:	31 c0                	xor    %eax,%eax
 1e2:	e8 ee 03 00 00       	callq  5d5 <printf>
      break;
 1e7:	e9 3a 01 00 00       	jmpq   326 <ls+0x25b>
    }
    strcpy(buf, path);
 1ec:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
 1f3:	48 89 de             	mov    %rbx,%rsi
 1f6:	e8 42 01 00 00       	callq  33d <strcpy>
    p = buf+strlen(buf);
 1fb:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
 202:	e8 6c 01 00 00       	callq  373 <strlen>
 207:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
 20e:	89 c0                	mov    %eax,%eax
 210:	48 8d 1c 01          	lea    (%rcx,%rax,1),%rbx
    *p++ = '/';
 214:	48 8d 84 05 d1 fd ff 	lea    -0x22f(%rbp,%rax,1),%rax
 21b:	ff 
 21c:	c6 03 2f             	movb   $0x2f,(%rbx)
 21f:	48 89 85 98 fd ff ff 	mov    %rax,-0x268(%rbp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 226:	48 8d b5 a4 fd ff ff 	lea    -0x25c(%rbp),%rsi
 22d:	ba 10 00 00 00       	mov    $0x10,%edx
 232:	44 89 e7             	mov    %r12d,%edi
 235:	e8 80 02 00 00       	callq  4ba <read>
 23a:	83 f8 10             	cmp    $0x10,%eax
 23d:	0f 85 e3 00 00 00    	jne    326 <ls+0x25b>
      if(de.inum == 0)
 243:	66 83 bd a4 fd ff ff 	cmpw   $0x0,-0x25c(%rbp)
 24a:	00 
 24b:	74 d9                	je     226 <ls+0x15b>
        continue;
      memmove(p, de.name, DIRSIZ);
 24d:	48 8d 85 a4 fd ff ff 	lea    -0x25c(%rbp),%rax
 254:	48 8b bd 98 fd ff ff 	mov    -0x268(%rbp),%rdi
 25b:	ba 0e 00 00 00       	mov    $0xe,%edx
 260:	48 8d 70 02          	lea    0x2(%rax),%rsi
 264:	e8 11 02 00 00       	callq  47a <memmove>
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
 269:	48 8d b5 b4 fd ff ff 	lea    -0x24c(%rbp),%rsi
 270:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 277:	c6 43 0f 00          	movb   $0x0,0xf(%rbx)
      if(stat(buf, &st) < 0){
 27b:	e8 a3 01 00 00       	callq  423 <stat>
 280:	85 c0                	test   %eax,%eax
 282:	79 1c                	jns    2a0 <ls+0x1d5>
        printf(1, "ls: cannot stat %s\n", buf);
 284:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
 28b:	48 c7 c6 24 09 00 00 	mov    $0x924,%rsi
 292:	bf 01 00 00 00       	mov    $0x1,%edi
 297:	31 c0                	xor    %eax,%eax
 299:	e8 37 03 00 00       	callq  5d5 <printf>
        continue;
 29e:	eb 86                	jmp    226 <ls+0x15b>
      }
      printf(1, "%s  %d %d %d %x %d %d\n", fmtname(buf), st.type, st.ownerid, st.groupid, st.mode, st.ino, st.size);
 2a0:	44 0f bf 8d c4 fd ff 	movswl -0x23c(%rbp),%r9d
 2a7:	ff 
 2a8:	44 0f bf 85 c2 fd ff 	movswl -0x23e(%rbp),%r8d
 2af:	ff 
 2b0:	48 8d bd d0 fd ff ff 	lea    -0x230(%rbp),%rdi
 2b7:	0f bf 8d b4 fd ff ff 	movswl -0x24c(%rbp),%ecx
 2be:	44 8b b5 cc fd ff ff 	mov    -0x234(%rbp),%r14d
 2c5:	44 8b ad bc fd ff ff 	mov    -0x244(%rbp),%r13d
 2cc:	44 8b bd c8 fd ff ff 	mov    -0x238(%rbp),%r15d
 2d3:	44 89 8d 8c fd ff ff 	mov    %r9d,-0x274(%rbp)
 2da:	44 89 85 90 fd ff ff 	mov    %r8d,-0x270(%rbp)
 2e1:	89 8d 94 fd ff ff    	mov    %ecx,-0x26c(%rbp)
 2e7:	e8 54 fd ff ff       	callq  40 <fmtname>
 2ec:	44 8b 8d 8c fd ff ff 	mov    -0x274(%rbp),%r9d
 2f3:	44 8b 85 90 fd ff ff 	mov    -0x270(%rbp),%r8d
 2fa:	48 c7 c6 61 09 00 00 	mov    $0x961,%rsi
 301:	8b 8d 94 fd ff ff    	mov    -0x26c(%rbp),%ecx
 307:	52                   	push   %rdx
 308:	bf 01 00 00 00       	mov    $0x1,%edi
 30d:	41 56                	push   %r14
 30f:	41 55                	push   %r13
 311:	48 89 c2             	mov    %rax,%rdx
 314:	41 57                	push   %r15
 316:	31 c0                	xor    %eax,%eax
 318:	e8 b8 02 00 00       	callq  5d5 <printf>
 31d:	48 83 c4 20          	add    $0x20,%rsp
 321:	e9 00 ff ff ff       	jmpq   226 <ls+0x15b>
    }
    break;
  }
  close(fd);
 326:	44 89 e7             	mov    %r12d,%edi
 329:	e8 9c 01 00 00       	callq  4ca <close>
}
 32e:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
 332:	5b                   	pop    %rbx
 333:	41 5c                	pop    %r12
 335:	41 5d                	pop    %r13
 337:	41 5e                	pop    %r14
 339:	41 5f                	pop    %r15
 33b:	5d                   	pop    %rbp
 33c:	c3                   	retq   

000000000000033d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 33d:	55                   	push   %rbp
 33e:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 341:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 343:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 346:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
 349:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
 34c:	48 ff c2             	inc    %rdx
 34f:	84 c9                	test   %cl,%cl
 351:	75 f3                	jne    346 <strcpy+0x9>
    ;
  return os;
}
 353:	5d                   	pop    %rbp
 354:	c3                   	retq   

0000000000000355 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 355:	55                   	push   %rbp
 356:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
 359:	0f b6 07             	movzbl (%rdi),%eax
 35c:	84 c0                	test   %al,%al
 35e:	74 0c                	je     36c <strcmp+0x17>
 360:	3a 06                	cmp    (%rsi),%al
 362:	75 08                	jne    36c <strcmp+0x17>
    p++, q++;
 364:	48 ff c7             	inc    %rdi
 367:	48 ff c6             	inc    %rsi
 36a:	eb ed                	jmp    359 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 36c:	0f b6 16             	movzbl (%rsi),%edx
}
 36f:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 370:	29 d0                	sub    %edx,%eax
}
 372:	c3                   	retq   

0000000000000373 <strlen>:

uint
strlen(const char *s)
{
 373:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 374:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 376:	48 89 e5             	mov    %rsp,%rbp
 379:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 37d:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 382:	74 05                	je     389 <strlen+0x16>
 384:	48 89 d0             	mov    %rdx,%rax
 387:	eb f0                	jmp    379 <strlen+0x6>
    ;
  return n;
}
 389:	5d                   	pop    %rbp
 38a:	c3                   	retq   

000000000000038b <memset>:

void*
memset(void *dst, int c, uint n)
{
 38b:	55                   	push   %rbp
 38c:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 38f:	89 d1                	mov    %edx,%ecx
 391:	89 f0                	mov    %esi,%eax
 393:	48 89 e5             	mov    %rsp,%rbp
 396:	fc                   	cld    
 397:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 399:	4c 89 c0             	mov    %r8,%rax
 39c:	5d                   	pop    %rbp
 39d:	c3                   	retq   

000000000000039e <strchr>:

char*
strchr(const char *s, char c)
{
 39e:	55                   	push   %rbp
 39f:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 3a2:	8a 07                	mov    (%rdi),%al
 3a4:	84 c0                	test   %al,%al
 3a6:	74 0a                	je     3b2 <strchr+0x14>
    if(*s == c)
 3a8:	40 38 f0             	cmp    %sil,%al
 3ab:	74 09                	je     3b6 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3ad:	48 ff c7             	inc    %rdi
 3b0:	eb f0                	jmp    3a2 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 3b2:	31 c0                	xor    %eax,%eax
 3b4:	eb 03                	jmp    3b9 <strchr+0x1b>
 3b6:	48 89 f8             	mov    %rdi,%rax
}
 3b9:	5d                   	pop    %rbp
 3ba:	c3                   	retq   

00000000000003bb <gets>:

char*
gets(char *buf, int max)
{
 3bb:	55                   	push   %rbp
 3bc:	48 89 e5             	mov    %rsp,%rbp
 3bf:	41 57                	push   %r15
 3c1:	41 56                	push   %r14
 3c3:	41 55                	push   %r13
 3c5:	41 54                	push   %r12
 3c7:	41 89 f7             	mov    %esi,%r15d
 3ca:	53                   	push   %rbx
 3cb:	49 89 fc             	mov    %rdi,%r12
 3ce:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d1:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 3d3:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d7:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 3db:	45 39 fd             	cmp    %r15d,%r13d
 3de:	7d 2c                	jge    40c <gets+0x51>
    cc = read(0, &c, 1);
 3e0:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 3e4:	31 ff                	xor    %edi,%edi
 3e6:	ba 01 00 00 00       	mov    $0x1,%edx
 3eb:	e8 ca 00 00 00       	callq  4ba <read>
    if(cc < 1)
 3f0:	85 c0                	test   %eax,%eax
 3f2:	7e 18                	jle    40c <gets+0x51>
      break;
    buf[i++] = c;
 3f4:	8a 45 cf             	mov    -0x31(%rbp),%al
 3f7:	49 ff c6             	inc    %r14
 3fa:	49 63 dd             	movslq %r13d,%rbx
 3fd:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 401:	3c 0a                	cmp    $0xa,%al
 403:	74 04                	je     409 <gets+0x4e>
 405:	3c 0d                	cmp    $0xd,%al
 407:	75 ce                	jne    3d7 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 409:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 40c:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 411:	48 83 c4 18          	add    $0x18,%rsp
 415:	4c 89 e0             	mov    %r12,%rax
 418:	5b                   	pop    %rbx
 419:	41 5c                	pop    %r12
 41b:	41 5d                	pop    %r13
 41d:	41 5e                	pop    %r14
 41f:	41 5f                	pop    %r15
 421:	5d                   	pop    %rbp
 422:	c3                   	retq   

0000000000000423 <stat>:

int
stat(const char *n, struct stat *st)
{
 423:	55                   	push   %rbp
 424:	48 89 e5             	mov    %rsp,%rbp
 427:	41 54                	push   %r12
 429:	53                   	push   %rbx
 42a:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42d:	31 f6                	xor    %esi,%esi
 42f:	e8 ae 00 00 00       	callq  4e2 <open>
 434:	41 89 c4             	mov    %eax,%r12d
 437:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 43a:	45 85 e4             	test   %r12d,%r12d
 43d:	78 17                	js     456 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 43f:	48 89 de             	mov    %rbx,%rsi
 442:	44 89 e7             	mov    %r12d,%edi
 445:	e8 b0 00 00 00       	callq  4fa <fstat>
  close(fd);
 44a:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 44d:	89 c3                	mov    %eax,%ebx
  close(fd);
 44f:	e8 76 00 00 00       	callq  4ca <close>
  return r;
 454:	89 d8                	mov    %ebx,%eax
}
 456:	5b                   	pop    %rbx
 457:	41 5c                	pop    %r12
 459:	5d                   	pop    %rbp
 45a:	c3                   	retq   

000000000000045b <atoi>:

int
atoi(const char *s)
{
 45b:	55                   	push   %rbp
  int n;

  n = 0;
 45c:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 45e:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 461:	0f be 17             	movsbl (%rdi),%edx
 464:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 467:	80 f9 09             	cmp    $0x9,%cl
 46a:	77 0c                	ja     478 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 46c:	6b c0 0a             	imul   $0xa,%eax,%eax
 46f:	48 ff c7             	inc    %rdi
 472:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 476:	eb e9                	jmp    461 <atoi+0x6>
  return n;
}
 478:	5d                   	pop    %rbp
 479:	c3                   	retq   

000000000000047a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 47a:	55                   	push   %rbp
 47b:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	48 89 e5             	mov    %rsp,%rbp
 483:	89 d7                	mov    %edx,%edi
 485:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 487:	85 ff                	test   %edi,%edi
 489:	7e 0d                	jle    498 <memmove+0x1e>
    *dst++ = *src++;
 48b:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 48f:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 493:	48 ff c1             	inc    %rcx
 496:	eb eb                	jmp    483 <memmove+0x9>
  return vdst;
}
 498:	5d                   	pop    %rbp
 499:	c3                   	retq   

000000000000049a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49a:	b8 01 00 00 00       	mov    $0x1,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	retq   

00000000000004a2 <exit>:
SYSCALL(exit)
 4a2:	b8 02 00 00 00       	mov    $0x2,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	retq   

00000000000004aa <wait>:
SYSCALL(wait)
 4aa:	b8 03 00 00 00       	mov    $0x3,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	retq   

00000000000004b2 <pipe>:
SYSCALL(pipe)
 4b2:	b8 04 00 00 00       	mov    $0x4,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	retq   

00000000000004ba <read>:
SYSCALL(read)
 4ba:	b8 05 00 00 00       	mov    $0x5,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	retq   

00000000000004c2 <write>:
SYSCALL(write)
 4c2:	b8 10 00 00 00       	mov    $0x10,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	retq   

00000000000004ca <close>:
SYSCALL(close)
 4ca:	b8 15 00 00 00       	mov    $0x15,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	retq   

00000000000004d2 <kill>:
SYSCALL(kill)
 4d2:	b8 06 00 00 00       	mov    $0x6,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	retq   

00000000000004da <exec>:
SYSCALL(exec)
 4da:	b8 07 00 00 00       	mov    $0x7,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	retq   

00000000000004e2 <open>:
SYSCALL(open)
 4e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	retq   

00000000000004ea <mknod>:
SYSCALL(mknod)
 4ea:	b8 11 00 00 00       	mov    $0x11,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	retq   

00000000000004f2 <unlink>:
SYSCALL(unlink)
 4f2:	b8 12 00 00 00       	mov    $0x12,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	retq   

00000000000004fa <fstat>:
SYSCALL(fstat)
 4fa:	b8 08 00 00 00       	mov    $0x8,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	retq   

0000000000000502 <link>:
SYSCALL(link)
 502:	b8 13 00 00 00       	mov    $0x13,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	retq   

000000000000050a <mkdir>:
SYSCALL(mkdir)
 50a:	b8 14 00 00 00       	mov    $0x14,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	retq   

0000000000000512 <chdir>:
SYSCALL(chdir)
 512:	b8 09 00 00 00       	mov    $0x9,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	retq   

000000000000051a <dup>:
SYSCALL(dup)
 51a:	b8 0a 00 00 00       	mov    $0xa,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	retq   

0000000000000522 <getpid>:
SYSCALL(getpid)
 522:	b8 0b 00 00 00       	mov    $0xb,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	retq   

000000000000052a <sbrk>:
SYSCALL(sbrk)
 52a:	b8 0c 00 00 00       	mov    $0xc,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	retq   

0000000000000532 <sleep>:
SYSCALL(sleep)
 532:	b8 0d 00 00 00       	mov    $0xd,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	retq   

000000000000053a <uptime>:
SYSCALL(uptime)
 53a:	b8 0e 00 00 00       	mov    $0xe,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	retq   

0000000000000542 <chmod>:
SYSCALL(chmod)
 542:	b8 16 00 00 00       	mov    $0x16,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	retq   

000000000000054a <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 54a:	55                   	push   %rbp
 54b:	41 89 d0             	mov    %edx,%r8d
 54e:	48 89 e5             	mov    %rsp,%rbp
 551:	41 54                	push   %r12
 553:	53                   	push   %rbx
 554:	41 89 fc             	mov    %edi,%r12d
 557:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 55b:	85 c9                	test   %ecx,%ecx
 55d:	74 12                	je     571 <printint+0x27>
 55f:	89 f0                	mov    %esi,%eax
 561:	c1 e8 1f             	shr    $0x1f,%eax
 564:	74 0b                	je     571 <printint+0x27>
    neg = 1;
    x = -xx;
 566:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 568:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 56d:	f7 d8                	neg    %eax
 56f:	eb 04                	jmp    575 <printint+0x2b>
  } else {
    x = xx;
 571:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 573:	31 f6                	xor    %esi,%esi
 575:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 579:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 57b:	31 d2                	xor    %edx,%edx
 57d:	48 ff c7             	inc    %rdi
 580:	8d 59 01             	lea    0x1(%rcx),%ebx
 583:	41 f7 f0             	div    %r8d
 586:	89 d2                	mov    %edx,%edx
 588:	8a 92 90 09 00 00    	mov    0x990(%rdx),%dl
 58e:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 591:	85 c0                	test   %eax,%eax
 593:	74 04                	je     599 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 595:	89 d9                	mov    %ebx,%ecx
 597:	eb e2                	jmp    57b <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 599:	85 f6                	test   %esi,%esi
 59b:	74 0b                	je     5a8 <printint+0x5e>
    buf[i++] = '-';
 59d:	48 63 db             	movslq %ebx,%rbx
 5a0:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 5a5:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 5a8:	ff cb                	dec    %ebx
 5aa:	83 fb ff             	cmp    $0xffffffff,%ebx
 5ad:	74 1d                	je     5cc <printint+0x82>
    putc(fd, buf[i]);
 5af:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b2:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 5b6:	ba 01 00 00 00       	mov    $0x1,%edx
 5bb:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 5bf:	44 89 e7             	mov    %r12d,%edi
 5c2:	88 45 df             	mov    %al,-0x21(%rbp)
 5c5:	e8 f8 fe ff ff       	callq  4c2 <write>
 5ca:	eb dc                	jmp    5a8 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 5cc:	48 83 c4 20          	add    $0x20,%rsp
 5d0:	5b                   	pop    %rbx
 5d1:	41 5c                	pop    %r12
 5d3:	5d                   	pop    %rbp
 5d4:	c3                   	retq   

00000000000005d5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d5:	55                   	push   %rbp
 5d6:	48 89 e5             	mov    %rsp,%rbp
 5d9:	41 56                	push   %r14
 5db:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 5dd:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e1:	41 54                	push   %r12
 5e3:	53                   	push   %rbx
 5e4:	41 89 fc             	mov    %edi,%r12d
 5e7:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 5ea:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ec:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 5f0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 5f4:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5f8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 5fc:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 600:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 604:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 608:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 60f:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 613:	45 8a 2e             	mov    (%r14),%r13b
 616:	45 84 ed             	test   %r13b,%r13b
 619:	0f 84 8f 01 00 00    	je     7ae <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 61f:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 621:	41 0f be d5          	movsbl %r13b,%edx
 625:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 629:	75 23                	jne    64e <printf+0x79>
      if(c == '%'){
 62b:	83 f8 25             	cmp    $0x25,%eax
 62e:	0f 84 6d 01 00 00    	je     7a1 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 634:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 638:	ba 01 00 00 00       	mov    $0x1,%edx
 63d:	44 89 e7             	mov    %r12d,%edi
 640:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 644:	e8 79 fe ff ff       	callq  4c2 <write>
 649:	e9 58 01 00 00       	jmpq   7a6 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64e:	83 fb 25             	cmp    $0x25,%ebx
 651:	0f 85 4f 01 00 00    	jne    7a6 <printf+0x1d1>
      if(c == 'd'){
 657:	83 f8 64             	cmp    $0x64,%eax
 65a:	75 2e                	jne    68a <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	8b 55 98             	mov    -0x68(%rbp),%edx
 65f:	83 fa 2f             	cmp    $0x2f,%edx
 662:	77 0e                	ja     672 <printf+0x9d>
 664:	89 d0                	mov    %edx,%eax
 666:	83 c2 08             	add    $0x8,%edx
 669:	48 03 45 a8          	add    -0x58(%rbp),%rax
 66d:	89 55 98             	mov    %edx,-0x68(%rbp)
 670:	eb 0c                	jmp    67e <printf+0xa9>
 672:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 676:	48 8d 50 08          	lea    0x8(%rax),%rdx
 67a:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 67e:	b9 01 00 00 00       	mov    $0x1,%ecx
 683:	ba 0a 00 00 00       	mov    $0xa,%edx
 688:	eb 34                	jmp    6be <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 68a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 690:	83 fa 70             	cmp    $0x70,%edx
 693:	75 38                	jne    6cd <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 695:	8b 55 98             	mov    -0x68(%rbp),%edx
 698:	83 fa 2f             	cmp    $0x2f,%edx
 69b:	77 0e                	ja     6ab <printf+0xd6>
 69d:	89 d0                	mov    %edx,%eax
 69f:	83 c2 08             	add    $0x8,%edx
 6a2:	48 03 45 a8          	add    -0x58(%rbp),%rax
 6a6:	89 55 98             	mov    %edx,-0x68(%rbp)
 6a9:	eb 0c                	jmp    6b7 <printf+0xe2>
 6ab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 6af:	48 8d 50 08          	lea    0x8(%rax),%rdx
 6b3:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 6b7:	31 c9                	xor    %ecx,%ecx
 6b9:	ba 10 00 00 00       	mov    $0x10,%edx
 6be:	8b 30                	mov    (%rax),%esi
 6c0:	44 89 e7             	mov    %r12d,%edi
 6c3:	e8 82 fe ff ff       	callq  54a <printint>
 6c8:	e9 d0 00 00 00       	jmpq   79d <printf+0x1c8>
      } else if(c == 's'){
 6cd:	83 f8 73             	cmp    $0x73,%eax
 6d0:	75 56                	jne    728 <printf+0x153>
        s = va_arg(ap, char*);
 6d2:	8b 55 98             	mov    -0x68(%rbp),%edx
 6d5:	83 fa 2f             	cmp    $0x2f,%edx
 6d8:	77 0e                	ja     6e8 <printf+0x113>
 6da:	89 d0                	mov    %edx,%eax
 6dc:	83 c2 08             	add    $0x8,%edx
 6df:	48 03 45 a8          	add    -0x58(%rbp),%rax
 6e3:	89 55 98             	mov    %edx,-0x68(%rbp)
 6e6:	eb 0c                	jmp    6f4 <printf+0x11f>
 6e8:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 6ec:	48 8d 50 08          	lea    0x8(%rax),%rdx
 6f0:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 6f4:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 6f7:	48 c7 c0 7a 09 00 00 	mov    $0x97a,%rax
 6fe:	48 85 db             	test   %rbx,%rbx
 701:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 705:	8a 03                	mov    (%rbx),%al
 707:	84 c0                	test   %al,%al
 709:	0f 84 8e 00 00 00    	je     79d <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 70f:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 713:	ba 01 00 00 00       	mov    $0x1,%edx
 718:	44 89 e7             	mov    %r12d,%edi
 71b:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 71e:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 721:	e8 9c fd ff ff       	callq  4c2 <write>
 726:	eb dd                	jmp    705 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 728:	83 f8 63             	cmp    $0x63,%eax
 72b:	75 32                	jne    75f <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 72d:	8b 55 98             	mov    -0x68(%rbp),%edx
 730:	83 fa 2f             	cmp    $0x2f,%edx
 733:	77 0e                	ja     743 <printf+0x16e>
 735:	89 d0                	mov    %edx,%eax
 737:	83 c2 08             	add    $0x8,%edx
 73a:	48 03 45 a8          	add    -0x58(%rbp),%rax
 73e:	89 55 98             	mov    %edx,-0x68(%rbp)
 741:	eb 0c                	jmp    74f <printf+0x17a>
 743:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 747:	48 8d 50 08          	lea    0x8(%rax),%rdx
 74b:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 74f:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 751:	ba 01 00 00 00       	mov    $0x1,%edx
 756:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 75a:	88 45 94             	mov    %al,-0x6c(%rbp)
 75d:	eb 36                	jmp    795 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 75f:	83 f8 25             	cmp    $0x25,%eax
 762:	75 0f                	jne    773 <printf+0x19e>
 764:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 768:	ba 01 00 00 00       	mov    $0x1,%edx
 76d:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 771:	eb 22                	jmp    795 <printf+0x1c0>
 773:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 777:	ba 01 00 00 00       	mov    $0x1,%edx
 77c:	44 89 e7             	mov    %r12d,%edi
 77f:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 783:	e8 3a fd ff ff       	callq  4c2 <write>
 788:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 78c:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 790:	ba 01 00 00 00       	mov    $0x1,%edx
 795:	44 89 e7             	mov    %r12d,%edi
 798:	e8 25 fd ff ff       	callq  4c2 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 79d:	31 db                	xor    %ebx,%ebx
 79f:	eb 05                	jmp    7a6 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7a1:	bb 25 00 00 00       	mov    $0x25,%ebx
 7a6:	49 ff c6             	inc    %r14
 7a9:	e9 65 fe ff ff       	jmpq   613 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ae:	48 83 c4 50          	add    $0x50,%rsp
 7b2:	5b                   	pop    %rbx
 7b3:	41 5c                	pop    %r12
 7b5:	41 5d                	pop    %r13
 7b7:	41 5e                	pop    %r14
 7b9:	5d                   	pop    %rbp
 7ba:	c3                   	retq   

00000000000007bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bb:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	48 8b 05 7d 04 00 00 	mov    0x47d(%rip),%rax        # c40 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c3:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c7:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	48 39 d0             	cmp    %rdx,%rax
 7cd:	48 8b 08             	mov    (%rax),%rcx
 7d0:	72 14                	jb     7e6 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	48 39 c8             	cmp    %rcx,%rax
 7d5:	72 0a                	jb     7e1 <free+0x26>
 7d7:	48 39 ca             	cmp    %rcx,%rdx
 7da:	72 0f                	jb     7eb <free+0x30>
 7dc:	48 39 d0             	cmp    %rdx,%rax
 7df:	72 0a                	jb     7eb <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e1:	48 89 c8             	mov    %rcx,%rax
 7e4:	eb e4                	jmp    7ca <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	48 39 ca             	cmp    %rcx,%rdx
 7e9:	73 e7                	jae    7d2 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7eb:	8b 77 f8             	mov    -0x8(%rdi),%esi
 7ee:	49 89 f0             	mov    %rsi,%r8
 7f1:	48 c1 e6 04          	shl    $0x4,%rsi
 7f5:	48 01 d6             	add    %rdx,%rsi
 7f8:	48 39 ce             	cmp    %rcx,%rsi
 7fb:	75 0e                	jne    80b <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 7fd:	44 03 41 08          	add    0x8(%rcx),%r8d
 801:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 805:	48 8b 08             	mov    (%rax),%rcx
 808:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 80b:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 80f:	8b 48 08             	mov    0x8(%rax),%ecx
 812:	48 89 ce             	mov    %rcx,%rsi
 815:	48 c1 e1 04          	shl    $0x4,%rcx
 819:	48 01 c1             	add    %rax,%rcx
 81c:	48 39 ca             	cmp    %rcx,%rdx
 81f:	75 0a                	jne    82b <free+0x70>
    p->s.size += bp->s.size;
 821:	03 77 f8             	add    -0x8(%rdi),%esi
 824:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 827:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 82b:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 82e:	48 89 05 0b 04 00 00 	mov    %rax,0x40b(%rip)        # c40 <freep>
}
 835:	5d                   	pop    %rbp
 836:	c3                   	retq   

0000000000000837 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 837:	55                   	push   %rbp
 838:	48 89 e5             	mov    %rsp,%rbp
 83b:	41 55                	push   %r13
 83d:	41 54                	push   %r12
 83f:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 843:	48 8b 0d f6 03 00 00 	mov    0x3f6(%rip),%rcx        # c40 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84a:	48 83 c3 0f          	add    $0xf,%rbx
 84e:	48 c1 eb 04          	shr    $0x4,%rbx
 852:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 854:	48 85 c9             	test   %rcx,%rcx
 857:	75 27                	jne    880 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 859:	48 c7 05 dc 03 00 00 	movq   $0xc50,0x3dc(%rip)        # c40 <freep>
 860:	50 0c 00 00 
 864:	48 c7 05 e1 03 00 00 	movq   $0xc50,0x3e1(%rip)        # c50 <base>
 86b:	50 0c 00 00 
 86f:	48 c7 c1 50 0c 00 00 	mov    $0xc50,%rcx
    base.s.size = 0;
 876:	c7 05 d8 03 00 00 00 	movl   $0x0,0x3d8(%rip)        # c58 <base+0x8>
 87d:	00 00 00 
 880:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 886:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	48 8b 01             	mov    (%rcx),%rax
 88f:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 893:	45 89 e5             	mov    %r12d,%r13d
 896:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 89a:	8b 50 08             	mov    0x8(%rax),%edx
 89d:	39 d3                	cmp    %edx,%ebx
 89f:	77 26                	ja     8c7 <malloc+0x90>
      if(p->s.size == nunits)
 8a1:	75 08                	jne    8ab <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 8a3:	48 8b 10             	mov    (%rax),%rdx
 8a6:	48 89 11             	mov    %rdx,(%rcx)
 8a9:	eb 0f                	jmp    8ba <malloc+0x83>
      else {
        p->s.size -= nunits;
 8ab:	29 da                	sub    %ebx,%edx
 8ad:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 8b0:	48 c1 e2 04          	shl    $0x4,%rdx
 8b4:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 8b7:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 8ba:	48 89 0d 7f 03 00 00 	mov    %rcx,0x37f(%rip)        # c40 <freep>
      return (void*)(p + 1);
 8c1:	48 83 c0 10          	add    $0x10,%rax
 8c5:	eb 3a                	jmp    901 <malloc+0xca>
    }
    if(p == freep)
 8c7:	48 3b 05 72 03 00 00 	cmp    0x372(%rip),%rax        # c40 <freep>
 8ce:	75 27                	jne    8f7 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8d0:	44 89 ef             	mov    %r13d,%edi
 8d3:	e8 52 fc ff ff       	callq  52a <sbrk>
  if(p == (char*)-1)
 8d8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 8dc:	74 21                	je     8ff <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 8de:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8e2:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 8e6:	e8 d0 fe ff ff       	callq  7bb <free>
  return freep;
 8eb:	48 8b 05 4e 03 00 00 	mov    0x34e(%rip),%rax        # c40 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8f2:	48 85 c0             	test   %rax,%rax
 8f5:	74 08                	je     8ff <malloc+0xc8>
        return 0;
  }
 8f7:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8fd:	eb 9b                	jmp    89a <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 8ff:	31 c0                	xor    %eax,%eax
  }
}
 901:	5a                   	pop    %rdx
 902:	5b                   	pop    %rbx
 903:	41 5c                	pop    %r12
 905:	41 5d                	pop    %r13
 907:	5d                   	pop    %rbp
 908:	c3                   	retq   
