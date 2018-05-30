
.fs/grep:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %rbp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
   1:	83 ff 01             	cmp    $0x1,%edi
  }
}

int
main(int argc, char *argv[])
{
   4:	48 89 e5             	mov    %rsp,%rbp
   7:	41 57                	push   %r15
   9:	41 56                	push   %r14
   b:	41 55                	push   %r13
   d:	41 54                	push   %r12
   f:	53                   	push   %rbx
  10:	50                   	push   %rax
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
  11:	7f 15                	jg     28 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
  13:	48 c7 c6 20 08 00 00 	mov    $0x820,%rsi
  1a:	bf 02 00 00 00       	mov    $0x2,%edi
  1f:	31 c0                	xor    %eax,%eax
  21:	e8 ba 04 00 00       	callq  4e0 <printf>
  26:	eb 16                	jmp    3e <main+0x3e>
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
  28:	83 ff 02             	cmp    $0x2,%edi
  2b:	41 89 fd             	mov    %edi,%r13d
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  2e:	4c 8b 76 08          	mov    0x8(%rsi),%r14
  
  if(argc <= 2){
  32:	75 0f                	jne    43 <main+0x43>
    grep(pattern, 0);
  34:	31 f6                	xor    %esi,%esi
  36:	4c 89 f7             	mov    %r14,%rdi
  39:	e8 2e 01 00 00       	callq  16c <grep>
    exit();
  3e:	e8 6a 03 00 00       	callq  3ad <exit>
  43:	48 8d 5e 10          	lea    0x10(%rsi),%rbx
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
  47:	41 bc 02 00 00 00    	mov    $0x2,%r12d
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  4d:	48 8b 3b             	mov    (%rbx),%rdi
  50:	31 f6                	xor    %esi,%esi
  52:	e8 96 03 00 00       	callq  3ed <open>
  57:	85 c0                	test   %eax,%eax
  59:	41 89 c7             	mov    %eax,%r15d
  5c:	79 18                	jns    76 <main+0x76>
      printf(1, "grep: cannot open %s\n", argv[i]);
  5e:	48 8b 13             	mov    (%rbx),%rdx
  61:	48 c7 c6 40 08 00 00 	mov    $0x840,%rsi
  68:	bf 01 00 00 00       	mov    $0x1,%edi
  6d:	31 c0                	xor    %eax,%eax
  6f:	e8 6c 04 00 00       	callq  4e0 <printf>
  74:	eb c8                	jmp    3e <main+0x3e>
      exit();
    }
    grep(pattern, fd);
  76:	89 c6                	mov    %eax,%esi
  78:	4c 89 f7             	mov    %r14,%rdi
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  7b:	41 ff c4             	inc    %r12d
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  7e:	e8 e9 00 00 00       	callq  16c <grep>
    close(fd);
  83:	44 89 ff             	mov    %r15d,%edi
  86:	48 83 c3 08          	add    $0x8,%rbx
  8a:	e8 46 03 00 00       	callq  3d5 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  8f:	45 39 e5             	cmp    %r12d,%r13d
  92:	7f b9                	jg     4d <main+0x4d>
  94:	eb a8                	jmp    3e <main+0x3e>

0000000000000096 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  96:	55                   	push   %rbp
  97:	48 89 e5             	mov    %rsp,%rbp
  9a:	41 55                	push   %r13
  9c:	41 54                	push   %r12
  9e:	53                   	push   %rbx
  9f:	51                   	push   %rcx
  a0:	41 89 fd             	mov    %edi,%r13d
  a3:	49 89 f4             	mov    %rsi,%r12
  a6:	48 89 d3             	mov    %rdx,%rbx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  a9:	48 89 de             	mov    %rbx,%rsi
  ac:	4c 89 e7             	mov    %r12,%rdi
  af:	e8 28 00 00 00       	callq  dc <matchhere>
  b4:	85 c0                	test   %eax,%eax
  b6:	75 17                	jne    cf <matchstar+0x39>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  b8:	0f be 0b             	movsbl (%rbx),%ecx
  bb:	84 c9                	test   %cl,%cl
  bd:	74 15                	je     d4 <matchstar+0x3e>
  bf:	48 ff c3             	inc    %rbx
  c2:	41 83 fd 2e          	cmp    $0x2e,%r13d
  c6:	74 e1                	je     a9 <matchstar+0x13>
  c8:	44 39 e9             	cmp    %r13d,%ecx
  cb:	74 dc                	je     a9 <matchstar+0x13>
  cd:	eb 05                	jmp    d4 <matchstar+0x3e>
// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  cf:	b8 01 00 00 00       	mov    $0x1,%eax
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
  d4:	5a                   	pop    %rdx
  d5:	5b                   	pop    %rbx
  d6:	41 5c                	pop    %r12
  d8:	41 5d                	pop    %r13
  da:	5d                   	pop    %rbp
  db:	c3                   	retq   

00000000000000dc <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  dc:	55                   	push   %rbp
  dd:	48 89 f2             	mov    %rsi,%rdx
  e0:	48 89 e5             	mov    %rsp,%rbp
  if(re[0] == '\0')
  e3:	8a 07                	mov    (%rdi),%al
  e5:	84 c0                	test   %al,%al
  e7:	74 3a                	je     123 <matchhere+0x47>
    return 1;
  if(re[1] == '*')
  e9:	8a 4f 01             	mov    0x1(%rdi),%cl
  ec:	80 f9 2a             	cmp    $0x2a,%cl
  ef:	75 0a                	jne    fb <matchhere+0x1f>
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  f1:	5d                   	pop    %rbp
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  f2:	48 8d 77 02          	lea    0x2(%rdi),%rsi
  f6:	0f be f8             	movsbl %al,%edi
  f9:	eb 9b                	jmp    96 <matchstar>
  if(re[0] == '$' && re[1] == '\0')
  fb:	3c 24                	cmp    $0x24,%al
  fd:	75 0e                	jne    10d <matchhere+0x31>
  ff:	84 c9                	test   %cl,%cl
 101:	75 0a                	jne    10d <matchhere+0x31>
    return *text == '\0';
 103:	31 c0                	xor    %eax,%eax
 105:	80 3a 00             	cmpb   $0x0,(%rdx)
 108:	0f 94 c0             	sete   %al
 10b:	eb 1f                	jmp    12c <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 10d:	8a 0a                	mov    (%rdx),%cl
 10f:	84 c9                	test   %cl,%cl
 111:	74 17                	je     12a <matchhere+0x4e>
 113:	3c 2e                	cmp    $0x2e,%al
 115:	74 04                	je     11b <matchhere+0x3f>
 117:	38 c8                	cmp    %cl,%al
 119:	75 0f                	jne    12a <matchhere+0x4e>
    return matchhere(re+1, text+1);
 11b:	48 ff c2             	inc    %rdx
 11e:	48 ff c7             	inc    %rdi
 121:	eb c0                	jmp    e3 <matchhere+0x7>

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
 123:	b8 01 00 00 00       	mov    $0x1,%eax
 128:	eb 02                	jmp    12c <matchhere+0x50>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
 12a:	31 c0                	xor    %eax,%eax
}
 12c:	5d                   	pop    %rbp
 12d:	c3                   	retq   

000000000000012e <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 12e:	55                   	push   %rbp
 12f:	48 89 e5             	mov    %rsp,%rbp
 132:	41 54                	push   %r12
 134:	53                   	push   %rbx
  if(re[0] == '^')
 135:	80 3f 5e             	cmpb   $0x5e,(%rdi)
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 138:	49 89 fc             	mov    %rdi,%r12
 13b:	48 89 f3             	mov    %rsi,%rbx
  if(re[0] == '^')
 13e:	75 13                	jne    153 <match+0x25>
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 140:	5b                   	pop    %rbx
 141:	41 5c                	pop    %r12
 143:	5d                   	pop    %rbp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 144:	48 8d 7f 01          	lea    0x1(%rdi),%rdi
 148:	eb 92                	jmp    dc <matchhere>
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 14a:	48 ff c3             	inc    %rbx
 14d:	80 7b ff 00          	cmpb   $0x0,-0x1(%rbx)
 151:	74 14                	je     167 <match+0x39>
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 153:	48 89 de             	mov    %rbx,%rsi
 156:	4c 89 e7             	mov    %r12,%rdi
 159:	e8 7e ff ff ff       	callq  dc <matchhere>
 15e:	85 c0                	test   %eax,%eax
 160:	74 e8                	je     14a <match+0x1c>
      return 1;
 162:	b8 01 00 00 00       	mov    $0x1,%eax
  }while(*text++ != '\0');
  return 0;
}
 167:	5b                   	pop    %rbx
 168:	41 5c                	pop    %r12
 16a:	5d                   	pop    %rbp
 16b:	c3                   	retq   

000000000000016c <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 16c:	55                   	push   %rbp
 16d:	48 89 e5             	mov    %rsp,%rbp
 170:	41 57                	push   %r15
 172:	41 56                	push   %r14
 174:	41 55                	push   %r13
 176:	41 54                	push   %r12
 178:	49 89 ff             	mov    %rdi,%r15
 17b:	53                   	push   %rbx
 17c:	48 83 ec 18          	sub    $0x18,%rsp
 180:	89 75 cc             	mov    %esi,-0x34(%rbp)
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
 183:	31 db                	xor    %ebx,%ebx
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 185:	8b 7d cc             	mov    -0x34(%rbp),%edi
 188:	ba ff 03 00 00       	mov    $0x3ff,%edx
 18d:	48 63 f3             	movslq %ebx,%rsi
 190:	29 da                	sub    %ebx,%edx
 192:	48 81 c6 80 0b 00 00 	add    $0xb80,%rsi
 199:	e8 27 02 00 00       	callq  3c5 <read>
 19e:	85 c0                	test   %eax,%eax
 1a0:	0f 8e 93 00 00 00    	jle    239 <grep+0xcd>
    m += n;
 1a6:	01 c3                	add    %eax,%ebx
    buf[m] = '\0';
    p = buf;
 1a8:	49 c7 c4 80 0b 00 00 	mov    $0xb80,%r12
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
 1af:	48 63 c3             	movslq %ebx,%rax
 1b2:	c6 80 80 0b 00 00 00 	movb   $0x0,0xb80(%rax)
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 1b9:	be 0a 00 00 00       	mov    $0xa,%esi
 1be:	4c 89 e7             	mov    %r12,%rdi
 1c1:	e8 e3 00 00 00       	callq  2a9 <strchr>
 1c6:	48 85 c0             	test   %rax,%rax
 1c9:	49 89 c5             	mov    %rax,%r13
 1cc:	74 35                	je     203 <grep+0x97>
      *q = 0;
 1ce:	41 c6 45 00 00       	movb   $0x0,0x0(%r13)
      if(match(pattern, p)){
 1d3:	4c 89 e6             	mov    %r12,%rsi
 1d6:	4c 89 ff             	mov    %r15,%rdi
 1d9:	e8 50 ff ff ff       	callq  12e <match>
 1de:	85 c0                	test   %eax,%eax
 1e0:	4d 8d 75 01          	lea    0x1(%r13),%r14
 1e4:	74 18                	je     1fe <grep+0x92>
        *q = '\n';
        write(1, p, q+1 - p);
 1e6:	4c 89 f2             	mov    %r14,%rdx
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      if(match(pattern, p)){
        *q = '\n';
 1e9:	41 c6 45 00 0a       	movb   $0xa,0x0(%r13)
        write(1, p, q+1 - p);
 1ee:	4c 89 e6             	mov    %r12,%rsi
 1f1:	4c 29 e2             	sub    %r12,%rdx
 1f4:	bf 01 00 00 00       	mov    $0x1,%edi
 1f9:	e8 cf 01 00 00       	callq  3cd <write>
      }
      p = q+1;
 1fe:	4d 89 f4             	mov    %r14,%r12
 201:	eb b6                	jmp    1b9 <grep+0x4d>
    }
    if(p == buf)
 203:	49 81 fc 80 0b 00 00 	cmp    $0xb80,%r12
 20a:	0f 84 73 ff ff ff    	je     183 <grep+0x17>
      m = 0;
    if(m > 0){
 210:	85 db                	test   %ebx,%ebx
 212:	0f 8e 6d ff ff ff    	jle    185 <grep+0x19>
      m -= p - buf;
 218:	4c 89 e0             	mov    %r12,%rax
      memmove(buf, p, m);
 21b:	4c 89 e6             	mov    %r12,%rsi
 21e:	48 c7 c7 80 0b 00 00 	mov    $0xb80,%rdi
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
      m -= p - buf;
 225:	48 2d 80 0b 00 00    	sub    $0xb80,%rax
 22b:	29 c3                	sub    %eax,%ebx
      memmove(buf, p, m);
 22d:	89 da                	mov    %ebx,%edx
 22f:	e8 51 01 00 00       	callq  385 <memmove>
 234:	e9 4c ff ff ff       	jmpq   185 <grep+0x19>
    }
  }
}
 239:	48 83 c4 18          	add    $0x18,%rsp
 23d:	5b                   	pop    %rbx
 23e:	41 5c                	pop    %r12
 240:	41 5d                	pop    %r13
 242:	41 5e                	pop    %r14
 244:	41 5f                	pop    %r15
 246:	5d                   	pop    %rbp
 247:	c3                   	retq   

0000000000000248 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 248:	55                   	push   %rbp
 249:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24c:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 24e:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 251:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
 254:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
 257:	48 ff c2             	inc    %rdx
 25a:	84 c9                	test   %cl,%cl
 25c:	75 f3                	jne    251 <strcpy+0x9>
    ;
  return os;
}
 25e:	5d                   	pop    %rbp
 25f:	c3                   	retq   

0000000000000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	55                   	push   %rbp
 261:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
 264:	0f b6 07             	movzbl (%rdi),%eax
 267:	84 c0                	test   %al,%al
 269:	74 0c                	je     277 <strcmp+0x17>
 26b:	3a 06                	cmp    (%rsi),%al
 26d:	75 08                	jne    277 <strcmp+0x17>
    p++, q++;
 26f:	48 ff c7             	inc    %rdi
 272:	48 ff c6             	inc    %rsi
 275:	eb ed                	jmp    264 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 277:	0f b6 16             	movzbl (%rsi),%edx
}
 27a:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 27b:	29 d0                	sub    %edx,%eax
}
 27d:	c3                   	retq   

000000000000027e <strlen>:

uint
strlen(const char *s)
{
 27e:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 27f:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 281:	48 89 e5             	mov    %rsp,%rbp
 284:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 288:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 28d:	74 05                	je     294 <strlen+0x16>
 28f:	48 89 d0             	mov    %rdx,%rax
 292:	eb f0                	jmp    284 <strlen+0x6>
    ;
  return n;
}
 294:	5d                   	pop    %rbp
 295:	c3                   	retq   

0000000000000296 <memset>:

void*
memset(void *dst, int c, uint n)
{
 296:	55                   	push   %rbp
 297:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 29a:	89 d1                	mov    %edx,%ecx
 29c:	89 f0                	mov    %esi,%eax
 29e:	48 89 e5             	mov    %rsp,%rbp
 2a1:	fc                   	cld    
 2a2:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 2a4:	4c 89 c0             	mov    %r8,%rax
 2a7:	5d                   	pop    %rbp
 2a8:	c3                   	retq   

00000000000002a9 <strchr>:

char*
strchr(const char *s, char c)
{
 2a9:	55                   	push   %rbp
 2aa:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 2ad:	8a 07                	mov    (%rdi),%al
 2af:	84 c0                	test   %al,%al
 2b1:	74 0a                	je     2bd <strchr+0x14>
    if(*s == c)
 2b3:	40 38 f0             	cmp    %sil,%al
 2b6:	74 09                	je     2c1 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b8:	48 ff c7             	inc    %rdi
 2bb:	eb f0                	jmp    2ad <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 2bd:	31 c0                	xor    %eax,%eax
 2bf:	eb 03                	jmp    2c4 <strchr+0x1b>
 2c1:	48 89 f8             	mov    %rdi,%rax
}
 2c4:	5d                   	pop    %rbp
 2c5:	c3                   	retq   

00000000000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %rbp
 2c7:	48 89 e5             	mov    %rsp,%rbp
 2ca:	41 57                	push   %r15
 2cc:	41 56                	push   %r14
 2ce:	41 55                	push   %r13
 2d0:	41 54                	push   %r12
 2d2:	41 89 f7             	mov    %esi,%r15d
 2d5:	53                   	push   %rbx
 2d6:	49 89 fc             	mov    %rdi,%r12
 2d9:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 2de:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e2:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 2e6:	45 39 fd             	cmp    %r15d,%r13d
 2e9:	7d 2c                	jge    317 <gets+0x51>
    cc = read(0, &c, 1);
 2eb:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 2ef:	31 ff                	xor    %edi,%edi
 2f1:	ba 01 00 00 00       	mov    $0x1,%edx
 2f6:	e8 ca 00 00 00       	callq  3c5 <read>
    if(cc < 1)
 2fb:	85 c0                	test   %eax,%eax
 2fd:	7e 18                	jle    317 <gets+0x51>
      break;
    buf[i++] = c;
 2ff:	8a 45 cf             	mov    -0x31(%rbp),%al
 302:	49 ff c6             	inc    %r14
 305:	49 63 dd             	movslq %r13d,%rbx
 308:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 30c:	3c 0a                	cmp    $0xa,%al
 30e:	74 04                	je     314 <gets+0x4e>
 310:	3c 0d                	cmp    $0xd,%al
 312:	75 ce                	jne    2e2 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 314:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 317:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 31c:	48 83 c4 18          	add    $0x18,%rsp
 320:	4c 89 e0             	mov    %r12,%rax
 323:	5b                   	pop    %rbx
 324:	41 5c                	pop    %r12
 326:	41 5d                	pop    %r13
 328:	41 5e                	pop    %r14
 32a:	41 5f                	pop    %r15
 32c:	5d                   	pop    %rbp
 32d:	c3                   	retq   

000000000000032e <stat>:

int
stat(const char *n, struct stat *st)
{
 32e:	55                   	push   %rbp
 32f:	48 89 e5             	mov    %rsp,%rbp
 332:	41 54                	push   %r12
 334:	53                   	push   %rbx
 335:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	31 f6                	xor    %esi,%esi
 33a:	e8 ae 00 00 00       	callq  3ed <open>
 33f:	41 89 c4             	mov    %eax,%r12d
 342:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 345:	45 85 e4             	test   %r12d,%r12d
 348:	78 17                	js     361 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 34a:	48 89 de             	mov    %rbx,%rsi
 34d:	44 89 e7             	mov    %r12d,%edi
 350:	e8 b0 00 00 00       	callq  405 <fstat>
  close(fd);
 355:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 358:	89 c3                	mov    %eax,%ebx
  close(fd);
 35a:	e8 76 00 00 00       	callq  3d5 <close>
  return r;
 35f:	89 d8                	mov    %ebx,%eax
}
 361:	5b                   	pop    %rbx
 362:	41 5c                	pop    %r12
 364:	5d                   	pop    %rbp
 365:	c3                   	retq   

0000000000000366 <atoi>:

int
atoi(const char *s)
{
 366:	55                   	push   %rbp
  int n;

  n = 0;
 367:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 369:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 36c:	0f be 17             	movsbl (%rdi),%edx
 36f:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 372:	80 f9 09             	cmp    $0x9,%cl
 375:	77 0c                	ja     383 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 377:	6b c0 0a             	imul   $0xa,%eax,%eax
 37a:	48 ff c7             	inc    %rdi
 37d:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 381:	eb e9                	jmp    36c <atoi+0x6>
  return n;
}
 383:	5d                   	pop    %rbp
 384:	c3                   	retq   

0000000000000385 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 385:	55                   	push   %rbp
 386:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 389:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 38b:	48 89 e5             	mov    %rsp,%rbp
 38e:	89 d7                	mov    %edx,%edi
 390:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 392:	85 ff                	test   %edi,%edi
 394:	7e 0d                	jle    3a3 <memmove+0x1e>
    *dst++ = *src++;
 396:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 39a:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 39e:	48 ff c1             	inc    %rcx
 3a1:	eb eb                	jmp    38e <memmove+0x9>
  return vdst;
}
 3a3:	5d                   	pop    %rbp
 3a4:	c3                   	retq   

00000000000003a5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a5:	b8 01 00 00 00       	mov    $0x1,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	retq   

00000000000003ad <exit>:
SYSCALL(exit)
 3ad:	b8 02 00 00 00       	mov    $0x2,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	retq   

00000000000003b5 <wait>:
SYSCALL(wait)
 3b5:	b8 03 00 00 00       	mov    $0x3,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	retq   

00000000000003bd <pipe>:
SYSCALL(pipe)
 3bd:	b8 04 00 00 00       	mov    $0x4,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	retq   

00000000000003c5 <read>:
SYSCALL(read)
 3c5:	b8 05 00 00 00       	mov    $0x5,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	retq   

00000000000003cd <write>:
SYSCALL(write)
 3cd:	b8 10 00 00 00       	mov    $0x10,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	retq   

00000000000003d5 <close>:
SYSCALL(close)
 3d5:	b8 15 00 00 00       	mov    $0x15,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	retq   

00000000000003dd <kill>:
SYSCALL(kill)
 3dd:	b8 06 00 00 00       	mov    $0x6,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	retq   

00000000000003e5 <exec>:
SYSCALL(exec)
 3e5:	b8 07 00 00 00       	mov    $0x7,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	retq   

00000000000003ed <open>:
SYSCALL(open)
 3ed:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	retq   

00000000000003f5 <mknod>:
SYSCALL(mknod)
 3f5:	b8 11 00 00 00       	mov    $0x11,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	retq   

00000000000003fd <unlink>:
SYSCALL(unlink)
 3fd:	b8 12 00 00 00       	mov    $0x12,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	retq   

0000000000000405 <fstat>:
SYSCALL(fstat)
 405:	b8 08 00 00 00       	mov    $0x8,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	retq   

000000000000040d <link>:
SYSCALL(link)
 40d:	b8 13 00 00 00       	mov    $0x13,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	retq   

0000000000000415 <mkdir>:
SYSCALL(mkdir)
 415:	b8 14 00 00 00       	mov    $0x14,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	retq   

000000000000041d <chdir>:
SYSCALL(chdir)
 41d:	b8 09 00 00 00       	mov    $0x9,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	retq   

0000000000000425 <dup>:
SYSCALL(dup)
 425:	b8 0a 00 00 00       	mov    $0xa,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	retq   

000000000000042d <getpid>:
SYSCALL(getpid)
 42d:	b8 0b 00 00 00       	mov    $0xb,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	retq   

0000000000000435 <sbrk>:
SYSCALL(sbrk)
 435:	b8 0c 00 00 00       	mov    $0xc,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	retq   

000000000000043d <sleep>:
SYSCALL(sleep)
 43d:	b8 0d 00 00 00       	mov    $0xd,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	retq   

0000000000000445 <uptime>:
SYSCALL(uptime)
 445:	b8 0e 00 00 00       	mov    $0xe,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	retq   

000000000000044d <chmod>:
SYSCALL(chmod)
 44d:	b8 16 00 00 00       	mov    $0x16,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	retq   

0000000000000455 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 455:	55                   	push   %rbp
 456:	41 89 d0             	mov    %edx,%r8d
 459:	48 89 e5             	mov    %rsp,%rbp
 45c:	41 54                	push   %r12
 45e:	53                   	push   %rbx
 45f:	41 89 fc             	mov    %edi,%r12d
 462:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 466:	85 c9                	test   %ecx,%ecx
 468:	74 12                	je     47c <printint+0x27>
 46a:	89 f0                	mov    %esi,%eax
 46c:	c1 e8 1f             	shr    $0x1f,%eax
 46f:	74 0b                	je     47c <printint+0x27>
    neg = 1;
    x = -xx;
 471:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 473:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 478:	f7 d8                	neg    %eax
 47a:	eb 04                	jmp    480 <printint+0x2b>
  } else {
    x = xx;
 47c:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47e:	31 f6                	xor    %esi,%esi
 480:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 484:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 486:	31 d2                	xor    %edx,%edx
 488:	48 ff c7             	inc    %rdi
 48b:	8d 59 01             	lea    0x1(%rcx),%ebx
 48e:	41 f7 f0             	div    %r8d
 491:	89 d2                	mov    %edx,%edx
 493:	8a 92 60 08 00 00    	mov    0x860(%rdx),%dl
 499:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 49c:	85 c0                	test   %eax,%eax
 49e:	74 04                	je     4a4 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 4a0:	89 d9                	mov    %ebx,%ecx
 4a2:	eb e2                	jmp    486 <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 4a4:	85 f6                	test   %esi,%esi
 4a6:	74 0b                	je     4b3 <printint+0x5e>
    buf[i++] = '-';
 4a8:	48 63 db             	movslq %ebx,%rbx
 4ab:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 4b0:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 4b3:	ff cb                	dec    %ebx
 4b5:	83 fb ff             	cmp    $0xffffffff,%ebx
 4b8:	74 1d                	je     4d7 <printint+0x82>
    putc(fd, buf[i]);
 4ba:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4bd:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 4c1:	ba 01 00 00 00       	mov    $0x1,%edx
 4c6:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 4ca:	44 89 e7             	mov    %r12d,%edi
 4cd:	88 45 df             	mov    %al,-0x21(%rbp)
 4d0:	e8 f8 fe ff ff       	callq  3cd <write>
 4d5:	eb dc                	jmp    4b3 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 4d7:	48 83 c4 20          	add    $0x20,%rsp
 4db:	5b                   	pop    %rbx
 4dc:	41 5c                	pop    %r12
 4de:	5d                   	pop    %rbp
 4df:	c3                   	retq   

00000000000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e0:	55                   	push   %rbp
 4e1:	48 89 e5             	mov    %rsp,%rbp
 4e4:	41 56                	push   %r14
 4e6:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 4e8:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ec:	41 54                	push   %r12
 4ee:	53                   	push   %rbx
 4ef:	41 89 fc             	mov    %edi,%r12d
 4f2:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 4f5:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f7:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 4fb:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 4ff:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 503:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 507:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 50b:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 50f:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 513:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 51a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 51e:	45 8a 2e             	mov    (%r14),%r13b
 521:	45 84 ed             	test   %r13b,%r13b
 524:	0f 84 8f 01 00 00    	je     6b9 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 52a:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 52c:	41 0f be d5          	movsbl %r13b,%edx
 530:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 534:	75 23                	jne    559 <printf+0x79>
      if(c == '%'){
 536:	83 f8 25             	cmp    $0x25,%eax
 539:	0f 84 6d 01 00 00    	je     6ac <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53f:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 543:	ba 01 00 00 00       	mov    $0x1,%edx
 548:	44 89 e7             	mov    %r12d,%edi
 54b:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 54f:	e8 79 fe ff ff       	callq  3cd <write>
 554:	e9 58 01 00 00       	jmpq   6b1 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 559:	83 fb 25             	cmp    $0x25,%ebx
 55c:	0f 85 4f 01 00 00    	jne    6b1 <printf+0x1d1>
      if(c == 'd'){
 562:	83 f8 64             	cmp    $0x64,%eax
 565:	75 2e                	jne    595 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 567:	8b 55 98             	mov    -0x68(%rbp),%edx
 56a:	83 fa 2f             	cmp    $0x2f,%edx
 56d:	77 0e                	ja     57d <printf+0x9d>
 56f:	89 d0                	mov    %edx,%eax
 571:	83 c2 08             	add    $0x8,%edx
 574:	48 03 45 a8          	add    -0x58(%rbp),%rax
 578:	89 55 98             	mov    %edx,-0x68(%rbp)
 57b:	eb 0c                	jmp    589 <printf+0xa9>
 57d:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 581:	48 8d 50 08          	lea    0x8(%rax),%rdx
 585:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 589:	b9 01 00 00 00       	mov    $0x1,%ecx
 58e:	ba 0a 00 00 00       	mov    $0xa,%edx
 593:	eb 34                	jmp    5c9 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 595:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 59b:	83 fa 70             	cmp    $0x70,%edx
 59e:	75 38                	jne    5d8 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 5a0:	8b 55 98             	mov    -0x68(%rbp),%edx
 5a3:	83 fa 2f             	cmp    $0x2f,%edx
 5a6:	77 0e                	ja     5b6 <printf+0xd6>
 5a8:	89 d0                	mov    %edx,%eax
 5aa:	83 c2 08             	add    $0x8,%edx
 5ad:	48 03 45 a8          	add    -0x58(%rbp),%rax
 5b1:	89 55 98             	mov    %edx,-0x68(%rbp)
 5b4:	eb 0c                	jmp    5c2 <printf+0xe2>
 5b6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 5ba:	48 8d 50 08          	lea    0x8(%rax),%rdx
 5be:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 5c2:	31 c9                	xor    %ecx,%ecx
 5c4:	ba 10 00 00 00       	mov    $0x10,%edx
 5c9:	8b 30                	mov    (%rax),%esi
 5cb:	44 89 e7             	mov    %r12d,%edi
 5ce:	e8 82 fe ff ff       	callq  455 <printint>
 5d3:	e9 d0 00 00 00       	jmpq   6a8 <printf+0x1c8>
      } else if(c == 's'){
 5d8:	83 f8 73             	cmp    $0x73,%eax
 5db:	75 56                	jne    633 <printf+0x153>
        s = va_arg(ap, char*);
 5dd:	8b 55 98             	mov    -0x68(%rbp),%edx
 5e0:	83 fa 2f             	cmp    $0x2f,%edx
 5e3:	77 0e                	ja     5f3 <printf+0x113>
 5e5:	89 d0                	mov    %edx,%eax
 5e7:	83 c2 08             	add    $0x8,%edx
 5ea:	48 03 45 a8          	add    -0x58(%rbp),%rax
 5ee:	89 55 98             	mov    %edx,-0x68(%rbp)
 5f1:	eb 0c                	jmp    5ff <printf+0x11f>
 5f3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 5f7:	48 8d 50 08          	lea    0x8(%rax),%rdx
 5fb:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 5ff:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 602:	48 c7 c0 56 08 00 00 	mov    $0x856,%rax
 609:	48 85 db             	test   %rbx,%rbx
 60c:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 610:	8a 03                	mov    (%rbx),%al
 612:	84 c0                	test   %al,%al
 614:	0f 84 8e 00 00 00    	je     6a8 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61a:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 61e:	ba 01 00 00 00       	mov    $0x1,%edx
 623:	44 89 e7             	mov    %r12d,%edi
 626:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 629:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62c:	e8 9c fd ff ff       	callq  3cd <write>
 631:	eb dd                	jmp    610 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 633:	83 f8 63             	cmp    $0x63,%eax
 636:	75 32                	jne    66a <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 638:	8b 55 98             	mov    -0x68(%rbp),%edx
 63b:	83 fa 2f             	cmp    $0x2f,%edx
 63e:	77 0e                	ja     64e <printf+0x16e>
 640:	89 d0                	mov    %edx,%eax
 642:	83 c2 08             	add    $0x8,%edx
 645:	48 03 45 a8          	add    -0x58(%rbp),%rax
 649:	89 55 98             	mov    %edx,-0x68(%rbp)
 64c:	eb 0c                	jmp    65a <printf+0x17a>
 64e:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 652:	48 8d 50 08          	lea    0x8(%rax),%rdx
 656:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 65a:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65c:	ba 01 00 00 00       	mov    $0x1,%edx
 661:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 665:	88 45 94             	mov    %al,-0x6c(%rbp)
 668:	eb 36                	jmp    6a0 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 66a:	83 f8 25             	cmp    $0x25,%eax
 66d:	75 0f                	jne    67e <printf+0x19e>
 66f:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 673:	ba 01 00 00 00       	mov    $0x1,%edx
 678:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 67c:	eb 22                	jmp    6a0 <printf+0x1c0>
 67e:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 682:	ba 01 00 00 00       	mov    $0x1,%edx
 687:	44 89 e7             	mov    %r12d,%edi
 68a:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 68e:	e8 3a fd ff ff       	callq  3cd <write>
 693:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 697:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 69b:	ba 01 00 00 00       	mov    $0x1,%edx
 6a0:	44 89 e7             	mov    %r12d,%edi
 6a3:	e8 25 fd ff ff       	callq  3cd <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6a8:	31 db                	xor    %ebx,%ebx
 6aa:	eb 05                	jmp    6b1 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6ac:	bb 25 00 00 00       	mov    $0x25,%ebx
 6b1:	49 ff c6             	inc    %r14
 6b4:	e9 65 fe ff ff       	jmpq   51e <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b9:	48 83 c4 50          	add    $0x50,%rsp
 6bd:	5b                   	pop    %rbx
 6be:	41 5c                	pop    %r12
 6c0:	41 5d                	pop    %r13
 6c2:	41 5e                	pop    %r14
 6c4:	5d                   	pop    %rbp
 6c5:	c3                   	retq   

00000000000006c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c6:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	48 8b 05 b2 08 00 00 	mov    0x8b2(%rip),%rax        # f80 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ce:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d2:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d5:	48 39 d0             	cmp    %rdx,%rax
 6d8:	48 8b 08             	mov    (%rax),%rcx
 6db:	72 14                	jb     6f1 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dd:	48 39 c8             	cmp    %rcx,%rax
 6e0:	72 0a                	jb     6ec <free+0x26>
 6e2:	48 39 ca             	cmp    %rcx,%rdx
 6e5:	72 0f                	jb     6f6 <free+0x30>
 6e7:	48 39 d0             	cmp    %rdx,%rax
 6ea:	72 0a                	jb     6f6 <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ec:	48 89 c8             	mov    %rcx,%rax
 6ef:	eb e4                	jmp    6d5 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	48 39 ca             	cmp    %rcx,%rdx
 6f4:	73 e7                	jae    6dd <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f6:	8b 77 f8             	mov    -0x8(%rdi),%esi
 6f9:	49 89 f0             	mov    %rsi,%r8
 6fc:	48 c1 e6 04          	shl    $0x4,%rsi
 700:	48 01 d6             	add    %rdx,%rsi
 703:	48 39 ce             	cmp    %rcx,%rsi
 706:	75 0e                	jne    716 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 708:	44 03 41 08          	add    0x8(%rcx),%r8d
 70c:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	48 8b 08             	mov    (%rax),%rcx
 713:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 716:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 71a:	8b 48 08             	mov    0x8(%rax),%ecx
 71d:	48 89 ce             	mov    %rcx,%rsi
 720:	48 c1 e1 04          	shl    $0x4,%rcx
 724:	48 01 c1             	add    %rax,%rcx
 727:	48 39 ca             	cmp    %rcx,%rdx
 72a:	75 0a                	jne    736 <free+0x70>
    p->s.size += bp->s.size;
 72c:	03 77 f8             	add    -0x8(%rdi),%esi
 72f:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 732:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 736:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 739:	48 89 05 40 08 00 00 	mov    %rax,0x840(%rip)        # f80 <freep>
}
 740:	5d                   	pop    %rbp
 741:	c3                   	retq   

0000000000000742 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 742:	55                   	push   %rbp
 743:	48 89 e5             	mov    %rsp,%rbp
 746:	41 55                	push   %r13
 748:	41 54                	push   %r12
 74a:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74b:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 74d:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 74e:	48 8b 0d 2b 08 00 00 	mov    0x82b(%rip),%rcx        # f80 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 755:	48 83 c3 0f          	add    $0xf,%rbx
 759:	48 c1 eb 04          	shr    $0x4,%rbx
 75d:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 75f:	48 85 c9             	test   %rcx,%rcx
 762:	75 27                	jne    78b <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 764:	48 c7 05 11 08 00 00 	movq   $0xf90,0x811(%rip)        # f80 <freep>
 76b:	90 0f 00 00 
 76f:	48 c7 05 16 08 00 00 	movq   $0xf90,0x816(%rip)        # f90 <base>
 776:	90 0f 00 00 
 77a:	48 c7 c1 90 0f 00 00 	mov    $0xf90,%rcx
    base.s.size = 0;
 781:	c7 05 0d 08 00 00 00 	movl   $0x0,0x80d(%rip)        # f98 <base+0x8>
 788:	00 00 00 
 78b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 791:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 797:	48 8b 01             	mov    (%rcx),%rax
 79a:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 79e:	45 89 e5             	mov    %r12d,%r13d
 7a1:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7a5:	8b 50 08             	mov    0x8(%rax),%edx
 7a8:	39 d3                	cmp    %edx,%ebx
 7aa:	77 26                	ja     7d2 <malloc+0x90>
      if(p->s.size == nunits)
 7ac:	75 08                	jne    7b6 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7ae:	48 8b 10             	mov    (%rax),%rdx
 7b1:	48 89 11             	mov    %rdx,(%rcx)
 7b4:	eb 0f                	jmp    7c5 <malloc+0x83>
      else {
        p->s.size -= nunits;
 7b6:	29 da                	sub    %ebx,%edx
 7b8:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 7bb:	48 c1 e2 04          	shl    $0x4,%rdx
 7bf:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 7c2:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 7c5:	48 89 0d b4 07 00 00 	mov    %rcx,0x7b4(%rip)        # f80 <freep>
      return (void*)(p + 1);
 7cc:	48 83 c0 10          	add    $0x10,%rax
 7d0:	eb 3a                	jmp    80c <malloc+0xca>
    }
    if(p == freep)
 7d2:	48 3b 05 a7 07 00 00 	cmp    0x7a7(%rip),%rax        # f80 <freep>
 7d9:	75 27                	jne    802 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7db:	44 89 ef             	mov    %r13d,%edi
 7de:	e8 52 fc ff ff       	callq  435 <sbrk>
  if(p == (char*)-1)
 7e3:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 7e7:	74 21                	je     80a <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 7e9:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7ed:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 7f1:	e8 d0 fe ff ff       	callq  6c6 <free>
  return freep;
 7f6:	48 8b 05 83 07 00 00 	mov    0x783(%rip),%rax        # f80 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7fd:	48 85 c0             	test   %rax,%rax
 800:	74 08                	je     80a <malloc+0xc8>
        return 0;
  }
 802:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 805:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 808:	eb 9b                	jmp    7a5 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 80a:	31 c0                	xor    %eax,%eax
  }
}
 80c:	5a                   	pop    %rdx
 80d:	5b                   	pop    %rbx
 80e:	41 5c                	pop    %r12
 810:	41 5d                	pop    %r13
 812:	5d                   	pop    %rbp
 813:	c3                   	retq   
