
.fs/sh:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  return 0;
}

int
main(void)
{
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
   4:	be 02 00 00 00       	mov    $0x2,%esi
   9:	48 c7 c7 d1 0f 00 00 	mov    $0xfd1,%rdi
  10:	e8 ec 0a 00 00       	callq  b01 <open>
  15:	85 c0                	test   %eax,%eax
  17:	78 68                	js     81 <main+0x81>
    if(fd >= 3){
  19:	83 f8 02             	cmp    $0x2,%eax
  1c:	7e e6                	jle    4 <main+0x4>
      close(fd);
  1e:	89 c7                	mov    %eax,%edi
  20:	e8 c4 0a 00 00       	callq  ae9 <close>
      break;
  25:	eb 5a                	jmp    81 <main+0x81>
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
  27:	80 3d b2 15 00 00 63 	cmpb   $0x63,0x15b2(%rip)        # 15e0 <buf.1503>
  2e:	75 68                	jne    98 <main+0x98>
  30:	80 3d aa 15 00 00 64 	cmpb   $0x64,0x15aa(%rip)        # 15e1 <buf.1503+0x1>
  37:	75 5f                	jne    98 <main+0x98>
  39:	80 3d a2 15 00 00 20 	cmpb   $0x20,0x15a2(%rip)        # 15e2 <buf.1503+0x2>
  40:	75 56                	jne    98 <main+0x98>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
  42:	48 c7 c7 e0 15 00 00 	mov    $0x15e0,%rdi
  49:	e8 44 09 00 00       	callq  992 <strlen>
      if(chdir(buf+3) < 0)
  4e:	48 c7 c7 e3 15 00 00 	mov    $0x15e3,%rdi
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
  55:	ff c8                	dec    %eax
  57:	c6 80 e0 15 00 00 00 	movb   $0x0,0x15e0(%rax)
      if(chdir(buf+3) < 0)
  5e:	e8 ce 0a 00 00       	callq  b31 <chdir>
  63:	85 c0                	test   %eax,%eax
  65:	79 1a                	jns    81 <main+0x81>
        printf(2, "cannot cd %s\n", buf+3);
  67:	48 c7 c2 e3 15 00 00 	mov    $0x15e3,%rdx
  6e:	48 c7 c6 d9 0f 00 00 	mov    $0xfd9,%rsi
  75:	bf 02 00 00 00       	mov    $0x2,%edi
  7a:	31 c0                	xor    %eax,%eax
  7c:	e8 73 0b 00 00       	callq  bf4 <printf>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
  81:	be 64 00 00 00       	mov    $0x64,%esi
  86:	48 c7 c7 e0 15 00 00 	mov    $0x15e0,%rdi
  8d:	e8 2f 00 00 00       	callq  c1 <getcmd>
  92:	85 c0                	test   %eax,%eax
  94:	79 91                	jns    27 <main+0x27>
  96:	eb 24                	jmp    bc <main+0xbc>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
  98:	e8 8a 00 00 00       	callq  127 <fork1>
  9d:	85 c0                	test   %eax,%eax
  9f:	75 14                	jne    b5 <main+0xb5>
      runcmd(parsecmd(buf));
  a1:	48 c7 c7 e0 15 00 00 	mov    $0x15e0,%rdi
  a8:	e8 37 08 00 00       	callq  8e4 <parsecmd>
  ad:	48 89 c7             	mov    %rax,%rdi
  b0:	e8 8e 00 00 00       	callq  143 <runcmd>
    wait();
  b5:	e8 0f 0a 00 00       	callq  ac9 <wait>
  ba:	eb c5                	jmp    81 <main+0x81>
  }
  exit();
  bc:	e8 00 0a 00 00       	callq  ac1 <exit>

00000000000000c1 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
  c1:	55                   	push   %rbp
  printf(2, "$ ");
  c2:	31 c0                	xor    %eax,%eax
  exit();
}

int
getcmd(char *buf, int nbuf)
{
  c4:	48 89 e5             	mov    %rsp,%rbp
  c7:	41 54                	push   %r12
  c9:	53                   	push   %rbx
  ca:	41 89 f4             	mov    %esi,%r12d
  cd:	48 89 fb             	mov    %rdi,%rbx
  printf(2, "$ ");
  d0:	48 c7 c6 30 0f 00 00 	mov    $0xf30,%rsi
  d7:	bf 02 00 00 00       	mov    $0x2,%edi
  dc:	e8 13 0b 00 00       	callq  bf4 <printf>
  memset(buf, 0, nbuf);
  e1:	44 89 e2             	mov    %r12d,%edx
  e4:	31 f6                	xor    %esi,%esi
  e6:	48 89 df             	mov    %rbx,%rdi
  e9:	e8 bc 08 00 00       	callq  9aa <memset>
  gets(buf, nbuf);
  ee:	44 89 e6             	mov    %r12d,%esi
  f1:	48 89 df             	mov    %rbx,%rdi
  f4:	e8 e1 08 00 00       	callq  9da <gets>
  f9:	31 c0                	xor    %eax,%eax
  fb:	80 3b 00             	cmpb   $0x0,(%rbx)
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
  fe:	5b                   	pop    %rbx
  ff:	41 5c                	pop    %r12
 101:	5d                   	pop    %rbp
 102:	0f 94 c0             	sete   %al
 105:	f7 d8                	neg    %eax
 107:	c3                   	retq   

0000000000000108 <panic>:
  exit();
}

void
panic(char *s)
{
 108:	55                   	push   %rbp
 109:	48 89 fa             	mov    %rdi,%rdx
  printf(2, "%s\n", s);
 10c:	48 c7 c6 cd 0f 00 00 	mov    $0xfcd,%rsi
 113:	bf 02 00 00 00       	mov    $0x2,%edi
 118:	31 c0                	xor    %eax,%eax
  exit();
}

void
panic(char *s)
{
 11a:	48 89 e5             	mov    %rsp,%rbp
  printf(2, "%s\n", s);
 11d:	e8 d2 0a 00 00       	callq  bf4 <printf>
  exit();
 122:	e8 9a 09 00 00       	callq  ac1 <exit>

0000000000000127 <fork1>:
}

int
fork1(void)
{
 127:	55                   	push   %rbp
 128:	48 89 e5             	mov    %rsp,%rbp
  int pid;
  
  pid = fork();
 12b:	e8 89 09 00 00       	callq  ab9 <fork>
  if(pid == -1)
 130:	83 f8 ff             	cmp    $0xffffffff,%eax
 133:	75 0c                	jne    141 <fork1+0x1a>
    panic("fork");
 135:	48 c7 c7 33 0f 00 00 	mov    $0xf33,%rdi
 13c:	e8 c7 ff ff ff       	callq  108 <panic>
  return pid;
}
 141:	5d                   	pop    %rbp
 142:	c3                   	retq   

0000000000000143 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
 143:	55                   	push   %rbp
 144:	48 89 e5             	mov    %rsp,%rbp
 147:	53                   	push   %rbx
 148:	48 83 ec 18          	sub    $0x18,%rsp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 14c:	48 85 ff             	test   %rdi,%rdi
 14f:	74 6e                	je     1bf <runcmd+0x7c>
    exit();
  
  switch(cmd->type){
 151:	8b 07                	mov    (%rdi),%eax
 153:	48 89 fb             	mov    %rdi,%rbx
 156:	ff c8                	dec    %eax
 158:	83 f8 04             	cmp    $0x4,%eax
 15b:	77 07                	ja     164 <runcmd+0x21>
 15d:	ff 24 c5 e8 0f 00 00 	jmpq   *0xfe8(,%rax,8)
  default:
    panic("runcmd");
 164:	48 c7 c7 38 0f 00 00 	mov    $0xf38,%rdi
 16b:	eb 7f                	jmp    1ec <runcmd+0xa9>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
 16d:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
 171:	48 85 ff             	test   %rdi,%rdi
 174:	74 49                	je     1bf <runcmd+0x7c>
      exit();
    exec(ecmd->argv[0], ecmd->argv);
 176:	48 8d 73 08          	lea    0x8(%rbx),%rsi
 17a:	e8 7a 09 00 00       	callq  af9 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
 17f:	48 8b 53 08          	mov    0x8(%rbx),%rdx
 183:	48 c7 c6 3f 0f 00 00 	mov    $0xf3f,%rsi
 18a:	eb 27                	jmp    1b3 <runcmd+0x70>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
 18c:	8b 7f 24             	mov    0x24(%rdi),%edi
 18f:	e8 55 09 00 00       	callq  ae9 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 194:	8b 73 20             	mov    0x20(%rbx),%esi
 197:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
 19b:	e8 61 09 00 00       	callq  b01 <open>
 1a0:	85 c0                	test   %eax,%eax
 1a2:	0f 89 d0 00 00 00    	jns    278 <runcmd+0x135>
      printf(2, "open %s failed\n", rcmd->file);
 1a8:	48 8b 53 10          	mov    0x10(%rbx),%rdx
 1ac:	48 c7 c6 4f 0f 00 00 	mov    $0xf4f,%rsi
 1b3:	bf 02 00 00 00       	mov    $0x2,%edi
 1b8:	31 c0                	xor    %eax,%eax
 1ba:	e8 35 0a 00 00       	callq  bf4 <printf>
      exit();
 1bf:	e8 fd 08 00 00       	callq  ac1 <exit>
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
 1c4:	e8 5e ff ff ff       	callq  127 <fork1>
 1c9:	85 c0                	test   %eax,%eax
 1cb:	0f 84 a7 00 00 00    	je     278 <runcmd+0x135>
      runcmd(lcmd->left);
    wait();
 1d1:	e8 f3 08 00 00       	callq  ac9 <wait>
 1d6:	eb 6e                	jmp    246 <runcmd+0x103>
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
 1d8:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
 1dc:	e8 f0 08 00 00       	callq  ad1 <pipe>
 1e1:	85 c0                	test   %eax,%eax
 1e3:	79 0c                	jns    1f1 <runcmd+0xae>
      panic("pipe");
 1e5:	48 c7 c7 5f 0f 00 00 	mov    $0xf5f,%rdi
 1ec:	e8 17 ff ff ff       	callq  108 <panic>
    if(fork1() == 0){
 1f1:	e8 31 ff ff ff       	callq  127 <fork1>
 1f6:	85 c0                	test   %eax,%eax
 1f8:	75 24                	jne    21e <runcmd+0xdb>
      close(1);
 1fa:	bf 01 00 00 00       	mov    $0x1,%edi
 1ff:	e8 e5 08 00 00       	callq  ae9 <close>
      dup(p[1]);
 204:	8b 7d ec             	mov    -0x14(%rbp),%edi
 207:	e8 2d 09 00 00       	callq  b39 <dup>
      close(p[0]);
 20c:	8b 7d e8             	mov    -0x18(%rbp),%edi
 20f:	e8 d5 08 00 00       	callq  ae9 <close>
      close(p[1]);
 214:	8b 7d ec             	mov    -0x14(%rbp),%edi
 217:	e8 cd 08 00 00       	callq  ae9 <close>
 21c:	eb 5a                	jmp    278 <runcmd+0x135>
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
 21e:	e8 04 ff ff ff       	callq  127 <fork1>
 223:	85 c0                	test   %eax,%eax
 225:	75 25                	jne    24c <runcmd+0x109>
      close(0);
 227:	31 ff                	xor    %edi,%edi
 229:	e8 bb 08 00 00       	callq  ae9 <close>
      dup(p[0]);
 22e:	8b 7d e8             	mov    -0x18(%rbp),%edi
 231:	e8 03 09 00 00       	callq  b39 <dup>
      close(p[0]);
 236:	8b 7d e8             	mov    -0x18(%rbp),%edi
 239:	e8 ab 08 00 00       	callq  ae9 <close>
      close(p[1]);
 23e:	8b 7d ec             	mov    -0x14(%rbp),%edi
 241:	e8 a3 08 00 00       	callq  ae9 <close>
      runcmd(pcmd->right);
 246:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
 24a:	eb 30                	jmp    27c <runcmd+0x139>
    }
    close(p[0]);
 24c:	8b 7d e8             	mov    -0x18(%rbp),%edi
 24f:	e8 95 08 00 00       	callq  ae9 <close>
    close(p[1]);
 254:	8b 7d ec             	mov    -0x14(%rbp),%edi
 257:	e8 8d 08 00 00       	callq  ae9 <close>
    wait();
 25c:	e8 68 08 00 00       	callq  ac9 <wait>
    wait();
 261:	e8 63 08 00 00       	callq  ac9 <wait>
    break;
 266:	e9 54 ff ff ff       	jmpq   1bf <runcmd+0x7c>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
 26b:	e8 b7 fe ff ff       	callq  127 <fork1>
 270:	85 c0                	test   %eax,%eax
 272:	0f 85 47 ff ff ff    	jne    1bf <runcmd+0x7c>
      runcmd(bcmd->cmd);
 278:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
 27c:	e8 c2 fe ff ff       	callq  143 <runcmd>

0000000000000281 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 281:	55                   	push   %rbp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 282:	bf a8 00 00 00       	mov    $0xa8,%edi
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 287:	48 89 e5             	mov    %rsp,%rbp
 28a:	53                   	push   %rbx
 28b:	50                   	push   %rax
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 28c:	e8 c5 0b 00 00       	callq  e56 <malloc>
  memset(cmd, 0, sizeof(*cmd));
 291:	ba a8 00 00 00       	mov    $0xa8,%edx
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 296:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
 299:	31 f6                	xor    %esi,%esi
 29b:	48 89 c7             	mov    %rax,%rdi
 29e:	e8 07 07 00 00       	callq  9aa <memset>
  cmd->type = EXEC;
 2a3:	c7 03 01 00 00 00    	movl   $0x1,(%rbx)
  return (struct cmd*)cmd;
}
 2a9:	48 89 d8             	mov    %rbx,%rax
 2ac:	5a                   	pop    %rdx
 2ad:	5b                   	pop    %rbx
 2ae:	5d                   	pop    %rbp
 2af:	c3                   	retq   

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 2b0:	55                   	push   %rbp
 2b1:	48 89 e5             	mov    %rsp,%rbp
 2b4:	41 57                	push   %r15
 2b6:	41 56                	push   %r14
 2b8:	41 55                	push   %r13
 2ba:	41 54                	push   %r12
 2bc:	49 89 ff             	mov    %rdi,%r15
 2bf:	53                   	push   %rbx
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2c0:	bf 28 00 00 00       	mov    $0x28,%edi
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 2c5:	49 89 f6             	mov    %rsi,%r14
 2c8:	49 89 d5             	mov    %rdx,%r13
 2cb:	41 89 cc             	mov    %ecx,%r12d
 2ce:	48 83 ec 18          	sub    $0x18,%rsp
 2d2:	44 89 45 cc          	mov    %r8d,-0x34(%rbp)
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2d6:	e8 7b 0b 00 00       	callq  e56 <malloc>
  memset(cmd, 0, sizeof(*cmd));
 2db:	ba 28 00 00 00       	mov    $0x28,%edx
 2e0:	31 f6                	xor    %esi,%esi
 2e2:	48 89 c7             	mov    %rax,%rdi
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2e5:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
 2e8:	e8 bd 06 00 00       	callq  9aa <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
 2ed:	44 8b 45 cc          	mov    -0x34(%rbp),%r8d
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
 2f1:	c7 03 02 00 00 00    	movl   $0x2,(%rbx)
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
  return (struct cmd*)cmd;
}
 2f7:	48 89 d8             	mov    %rbx,%rax
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd = subcmd;
 2fa:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  cmd->file = file;
 2fe:	4c 89 73 10          	mov    %r14,0x10(%rbx)
  cmd->efile = efile;
 302:	4c 89 6b 18          	mov    %r13,0x18(%rbx)
  cmd->mode = mode;
 306:	44 89 63 20          	mov    %r12d,0x20(%rbx)
  cmd->fd = fd;
 30a:	44 89 43 24          	mov    %r8d,0x24(%rbx)
  return (struct cmd*)cmd;
}
 30e:	48 83 c4 18          	add    $0x18,%rsp
 312:	5b                   	pop    %rbx
 313:	41 5c                	pop    %r12
 315:	41 5d                	pop    %r13
 317:	41 5e                	pop    %r14
 319:	41 5f                	pop    %r15
 31b:	5d                   	pop    %rbp
 31c:	c3                   	retq   

000000000000031d <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 31d:	55                   	push   %rbp
 31e:	48 89 e5             	mov    %rsp,%rbp
 321:	41 55                	push   %r13
 323:	41 54                	push   %r12
 325:	53                   	push   %rbx
 326:	50                   	push   %rax
 327:	49 89 fd             	mov    %rdi,%r13
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 32a:	bf 18 00 00 00       	mov    $0x18,%edi
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 32f:	49 89 f4             	mov    %rsi,%r12
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 332:	e8 1f 0b 00 00       	callq  e56 <malloc>
  memset(cmd, 0, sizeof(*cmd));
 337:	ba 18 00 00 00       	mov    $0x18,%edx
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 33c:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
 33f:	31 f6                	xor    %esi,%esi
 341:	48 89 c7             	mov    %rax,%rdi
 344:	e8 61 06 00 00       	callq  9aa <memset>
  cmd->type = PIPE;
 349:	c7 03 03 00 00 00    	movl   $0x3,(%rbx)
  cmd->left = left;
 34f:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
  cmd->right = right;
  return (struct cmd*)cmd;
}
 353:	48 89 d8             	mov    %rbx,%rax

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
  cmd->left = left;
  cmd->right = right;
 356:	4c 89 63 10          	mov    %r12,0x10(%rbx)
  return (struct cmd*)cmd;
}
 35a:	5a                   	pop    %rdx
 35b:	5b                   	pop    %rbx
 35c:	41 5c                	pop    %r12
 35e:	41 5d                	pop    %r13
 360:	5d                   	pop    %rbp
 361:	c3                   	retq   

0000000000000362 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 362:	55                   	push   %rbp
 363:	48 89 e5             	mov    %rsp,%rbp
 366:	41 55                	push   %r13
 368:	41 54                	push   %r12
 36a:	53                   	push   %rbx
 36b:	50                   	push   %rax
 36c:	49 89 fd             	mov    %rdi,%r13
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 36f:	bf 18 00 00 00       	mov    $0x18,%edi
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 374:	49 89 f4             	mov    %rsi,%r12
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 377:	e8 da 0a 00 00       	callq  e56 <malloc>
  memset(cmd, 0, sizeof(*cmd));
 37c:	ba 18 00 00 00       	mov    $0x18,%edx
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 381:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
 384:	31 f6                	xor    %esi,%esi
 386:	48 89 c7             	mov    %rax,%rdi
 389:	e8 1c 06 00 00       	callq  9aa <memset>
  cmd->type = LIST;
 38e:	c7 03 04 00 00 00    	movl   $0x4,(%rbx)
  cmd->left = left;
 394:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
  cmd->right = right;
  return (struct cmd*)cmd;
}
 398:	48 89 d8             	mov    %rbx,%rax

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
  cmd->left = left;
  cmd->right = right;
 39b:	4c 89 63 10          	mov    %r12,0x10(%rbx)
  return (struct cmd*)cmd;
}
 39f:	5a                   	pop    %rdx
 3a0:	5b                   	pop    %rbx
 3a1:	41 5c                	pop    %r12
 3a3:	41 5d                	pop    %r13
 3a5:	5d                   	pop    %rbp
 3a6:	c3                   	retq   

00000000000003a7 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 3a7:	55                   	push   %rbp
 3a8:	48 89 e5             	mov    %rsp,%rbp
 3ab:	41 54                	push   %r12
 3ad:	53                   	push   %rbx
 3ae:	49 89 fc             	mov    %rdi,%r12
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 3b1:	bf 10 00 00 00       	mov    $0x10,%edi
 3b6:	e8 9b 0a 00 00       	callq  e56 <malloc>
  memset(cmd, 0, sizeof(*cmd));
 3bb:	ba 10 00 00 00       	mov    $0x10,%edx
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 3c0:	48 89 c3             	mov    %rax,%rbx
  memset(cmd, 0, sizeof(*cmd));
 3c3:	31 f6                	xor    %esi,%esi
 3c5:	48 89 c7             	mov    %rax,%rdi
 3c8:	e8 dd 05 00 00       	callq  9aa <memset>
  cmd->type = BACK;
 3cd:	c7 03 05 00 00 00    	movl   $0x5,(%rbx)
  cmd->cmd = subcmd;
 3d3:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  return (struct cmd*)cmd;
}
 3d7:	48 89 d8             	mov    %rbx,%rax
 3da:	5b                   	pop    %rbx
 3db:	41 5c                	pop    %r12
 3dd:	5d                   	pop    %rbp
 3de:	c3                   	retq   

00000000000003df <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 3df:	55                   	push   %rbp
 3e0:	48 89 e5             	mov    %rsp,%rbp
 3e3:	41 57                	push   %r15
 3e5:	41 56                	push   %r14
 3e7:	41 55                	push   %r13
 3e9:	41 54                	push   %r12
 3eb:	49 89 fd             	mov    %rdi,%r13
 3ee:	53                   	push   %rbx
 3ef:	41 50                	push   %r8
 3f1:	49 89 f4             	mov    %rsi,%r12
  char *s;
  int ret;
  
  s = *ps;
 3f4:	48 8b 1f             	mov    (%rdi),%rbx
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 3f7:	49 89 d7             	mov    %rdx,%r15
 3fa:	49 89 ce             	mov    %rcx,%r14
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
 3fd:	4c 39 e3             	cmp    %r12,%rbx
 400:	72 0a                	jb     40c <gettoken+0x2d>
    s++;
  if(q)
 402:	4d 85 ff             	test   %r15,%r15
 405:	74 1e                	je     425 <gettoken+0x46>
    *q = s;
 407:	49 89 1f             	mov    %rbx,(%r15)
 40a:	eb 19                	jmp    425 <gettoken+0x46>
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
 40c:	0f be 33             	movsbl (%rbx),%esi
 40f:	48 c7 c7 c8 15 00 00 	mov    $0x15c8,%rdi
 416:	e8 a2 05 00 00       	callq  9bd <strchr>
 41b:	48 85 c0             	test   %rax,%rax
 41e:	74 e2                	je     402 <gettoken+0x23>
    s++;
 420:	48 ff c3             	inc    %rbx
 423:	eb d8                	jmp    3fd <gettoken+0x1e>
  if(q)
    *q = s;
  ret = *s;
 425:	44 0f be 3b          	movsbl (%rbx),%r15d
  switch(*s){
 429:	41 80 ff 29          	cmp    $0x29,%r15b
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
 42d:	44 89 f8             	mov    %r15d,%eax
  switch(*s){
 430:	7f 11                	jg     443 <gettoken+0x64>
 432:	41 80 ff 28          	cmp    $0x28,%r15b
 436:	7d 2a                	jge    462 <gettoken+0x83>
 438:	45 84 ff             	test   %r15b,%r15b
 43b:	74 6c                	je     4a9 <gettoken+0xca>
 43d:	41 80 ff 26          	cmp    $0x26,%r15b
 441:	eb 15                	jmp    458 <gettoken+0x79>
 443:	41 80 ff 3e          	cmp    $0x3e,%r15b
 447:	74 13                	je     45c <gettoken+0x7d>
 449:	7f 09                	jg     454 <gettoken+0x75>
 44b:	83 e8 3b             	sub    $0x3b,%eax
 44e:	3c 01                	cmp    $0x1,%al
 450:	77 4c                	ja     49e <gettoken+0xbf>
 452:	eb 0e                	jmp    462 <gettoken+0x83>
 454:	41 80 ff 7c          	cmp    $0x7c,%r15b
 458:	75 44                	jne    49e <gettoken+0xbf>
 45a:	eb 06                	jmp    462 <gettoken+0x83>
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
 45c:	80 7b 01 3e          	cmpb   $0x3e,0x1(%rbx)
 460:	74 05                	je     467 <gettoken+0x88>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
 462:	48 ff c3             	inc    %rbx
 465:	eb 42                	jmp    4a9 <gettoken+0xca>
    if(*s == '>'){
      ret = '+';
      s++;
 467:	48 83 c3 02          	add    $0x2,%rbx
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
 46b:	41 bf 2b 00 00 00    	mov    $0x2b,%r15d
 471:	eb 36                	jmp    4a9 <gettoken+0xca>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 473:	0f be 33             	movsbl (%rbx),%esi
 476:	48 c7 c7 c8 15 00 00 	mov    $0x15c8,%rdi
 47d:	e8 3b 05 00 00       	callq  9bd <strchr>
 482:	48 85 c0             	test   %rax,%rax
 485:	75 1c                	jne    4a3 <gettoken+0xc4>
 487:	0f be 33             	movsbl (%rbx),%esi
 48a:	48 c7 c7 c0 15 00 00 	mov    $0x15c0,%rdi
 491:	e8 27 05 00 00       	callq  9bd <strchr>
 496:	48 85 c0             	test   %rax,%rax
 499:	75 08                	jne    4a3 <gettoken+0xc4>
      s++;
 49b:	48 ff c3             	inc    %rbx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 49e:	4c 39 e3             	cmp    %r12,%rbx
 4a1:	72 d0                	jb     473 <gettoken+0x94>
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
 4a3:	41 bf 61 00 00 00    	mov    $0x61,%r15d
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 4a9:	4d 85 f6             	test   %r14,%r14
 4ac:	74 1c                	je     4ca <gettoken+0xeb>
    *eq = s;
 4ae:	49 89 1e             	mov    %rbx,(%r14)
 4b1:	eb 17                	jmp    4ca <gettoken+0xeb>
  
  while(s < es && strchr(whitespace, *s))
 4b3:	0f be 33             	movsbl (%rbx),%esi
 4b6:	48 c7 c7 c8 15 00 00 	mov    $0x15c8,%rdi
 4bd:	e8 fb 04 00 00       	callq  9bd <strchr>
 4c2:	48 85 c0             	test   %rax,%rax
 4c5:	74 08                	je     4cf <gettoken+0xf0>
    s++;
 4c7:	48 ff c3             	inc    %rbx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
 4ca:	4c 39 e3             	cmp    %r12,%rbx
 4cd:	72 e4                	jb     4b3 <gettoken+0xd4>
    s++;
  *ps = s;
 4cf:	49 89 5d 00          	mov    %rbx,0x0(%r13)
  return ret;
}
 4d3:	44 89 f8             	mov    %r15d,%eax
 4d6:	5a                   	pop    %rdx
 4d7:	5b                   	pop    %rbx
 4d8:	41 5c                	pop    %r12
 4da:	41 5d                	pop    %r13
 4dc:	41 5e                	pop    %r14
 4de:	41 5f                	pop    %r15
 4e0:	5d                   	pop    %rbp
 4e1:	c3                   	retq   

00000000000004e2 <peek>:

int
peek(char **ps, char *es, char *toks)
{
 4e2:	55                   	push   %rbp
 4e3:	48 89 e5             	mov    %rsp,%rbp
 4e6:	41 56                	push   %r14
 4e8:	41 55                	push   %r13
 4ea:	41 54                	push   %r12
 4ec:	53                   	push   %rbx
 4ed:	49 89 fc             	mov    %rdi,%r12
  char *s;
  
  s = *ps;
 4f0:	48 8b 1f             	mov    (%rdi),%rbx
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
 4f3:	49 89 f6             	mov    %rsi,%r14
 4f6:	49 89 d5             	mov    %rdx,%r13
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
 4f9:	4c 39 f3             	cmp    %r14,%rbx
 4fc:	72 21                	jb     51f <peek+0x3d>
    s++;
  *ps = s;
 4fe:	49 89 1c 24          	mov    %rbx,(%r12)
  return *s && strchr(toks, *s);
 502:	0f be 33             	movsbl (%rbx),%esi
 505:	31 c0                	xor    %eax,%eax
 507:	40 84 f6             	test   %sil,%sil
 50a:	74 2c                	je     538 <peek+0x56>
 50c:	4c 89 ef             	mov    %r13,%rdi
 50f:	e8 a9 04 00 00       	callq  9bd <strchr>
 514:	48 85 c0             	test   %rax,%rax
 517:	0f 95 c0             	setne  %al
 51a:	0f b6 c0             	movzbl %al,%eax
 51d:	eb 19                	jmp    538 <peek+0x56>
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
 51f:	0f be 33             	movsbl (%rbx),%esi
 522:	48 c7 c7 c8 15 00 00 	mov    $0x15c8,%rdi
 529:	e8 8f 04 00 00       	callq  9bd <strchr>
 52e:	48 85 c0             	test   %rax,%rax
 531:	74 cb                	je     4fe <peek+0x1c>
    s++;
 533:	48 ff c3             	inc    %rbx
 536:	eb c1                	jmp    4f9 <peek+0x17>
  *ps = s;
  return *s && strchr(toks, *s);
}
 538:	5b                   	pop    %rbx
 539:	41 5c                	pop    %r12
 53b:	41 5d                	pop    %r13
 53d:	41 5e                	pop    %r14
 53f:	5d                   	pop    %rbp
 540:	c3                   	retq   

0000000000000541 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 541:	55                   	push   %rbp
 542:	48 89 e5             	mov    %rsp,%rbp
 545:	41 56                	push   %r14
 547:	41 55                	push   %r13
 549:	41 54                	push   %r12
 54b:	53                   	push   %rbx
 54c:	49 89 f4             	mov    %rsi,%r12
 54f:	48 89 fb             	mov    %rdi,%rbx
 552:	49 89 d5             	mov    %rdx,%r13
 555:	48 83 ec 10          	sub    $0x10,%rsp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 559:	48 c7 c2 81 0f 00 00 	mov    $0xf81,%rdx
 560:	4c 89 ee             	mov    %r13,%rsi
 563:	4c 89 e7             	mov    %r12,%rdi
 566:	e8 77 ff ff ff       	callq  4e2 <peek>
 56b:	85 c0                	test   %eax,%eax
 56d:	74 74                	je     5e3 <parseredirs+0xa2>
    tok = gettoken(ps, es, 0, 0);
 56f:	31 c9                	xor    %ecx,%ecx
 571:	31 d2                	xor    %edx,%edx
 573:	4c 89 ee             	mov    %r13,%rsi
 576:	4c 89 e7             	mov    %r12,%rdi
 579:	e8 61 fe ff ff       	callq  3df <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
 57e:	48 8d 4d d8          	lea    -0x28(%rbp),%rcx
 582:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
 586:	4c 89 ee             	mov    %r13,%rsi
 589:	4c 89 e7             	mov    %r12,%rdi
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
 58c:	41 89 c6             	mov    %eax,%r14d
    if(gettoken(ps, es, &q, &eq) != 'a')
 58f:	e8 4b fe ff ff       	callq  3df <gettoken>
 594:	83 f8 61             	cmp    $0x61,%eax
 597:	74 0c                	je     5a5 <parseredirs+0x64>
      panic("missing file for redirection");
 599:	48 c7 c7 64 0f 00 00 	mov    $0xf64,%rdi
 5a0:	e8 63 fb ff ff       	callq  108 <panic>
    switch(tok){
 5a5:	41 83 fe 3c          	cmp    $0x3c,%r14d
 5a9:	74 0e                	je     5b9 <parseredirs+0x78>
 5ab:	41 83 fe 3e          	cmp    $0x3e,%r14d
 5af:	74 0f                	je     5c0 <parseredirs+0x7f>
 5b1:	41 83 fe 2b          	cmp    $0x2b,%r14d
 5b5:	75 a2                	jne    559 <parseredirs+0x18>
 5b7:	eb 07                	jmp    5c0 <parseredirs+0x7f>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 5b9:	45 31 c0             	xor    %r8d,%r8d
 5bc:	31 c9                	xor    %ecx,%ecx
 5be:	eb 0b                	jmp    5cb <parseredirs+0x8a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 5c0:	41 b8 01 00 00 00    	mov    $0x1,%r8d
 5c6:	b9 01 02 00 00       	mov    $0x201,%ecx
 5cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
 5cf:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
 5d3:	48 89 df             	mov    %rbx,%rdi
 5d6:	e8 d5 fc ff ff       	callq  2b0 <redircmd>
 5db:	48 89 c3             	mov    %rax,%rbx
      break;
 5de:	e9 76 ff ff ff       	jmpq   559 <parseredirs+0x18>
    }
  }
  return cmd;
}
 5e3:	5a                   	pop    %rdx
 5e4:	48 89 d8             	mov    %rbx,%rax
 5e7:	59                   	pop    %rcx
 5e8:	5b                   	pop    %rbx
 5e9:	41 5c                	pop    %r12
 5eb:	41 5d                	pop    %r13
 5ed:	41 5e                	pop    %r14
 5ef:	5d                   	pop    %rbp
 5f0:	c3                   	retq   

00000000000005f1 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 5f1:	55                   	push   %rbp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
 5f2:	48 c7 c2 84 0f 00 00 	mov    $0xf84,%rdx
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 5f9:	48 89 e5             	mov    %rsp,%rbp
 5fc:	41 57                	push   %r15
 5fe:	41 56                	push   %r14
 600:	41 55                	push   %r13
 602:	41 54                	push   %r12
 604:	49 89 f5             	mov    %rsi,%r13
 607:	53                   	push   %rbx
 608:	49 89 fc             	mov    %rdi,%r12
 60b:	48 83 ec 28          	sub    $0x28,%rsp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
 60f:	e8 ce fe ff ff       	callq  4e2 <peek>
 614:	85 c0                	test   %eax,%eax
 616:	74 10                	je     628 <parseexec+0x37>
    return parseblock(ps, es);
 618:	4c 89 ee             	mov    %r13,%rsi
 61b:	4c 89 e7             	mov    %r12,%rdi
 61e:	e8 ca 01 00 00       	callq  7ed <parseblock>
 623:	e9 bb 00 00 00       	jmpq   6e3 <parseexec+0xf2>

  ret = execcmd();
 628:	e8 54 fc ff ff       	callq  281 <execcmd>
 62d:	49 89 c7             	mov    %rax,%r15
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 630:	4c 89 ea             	mov    %r13,%rdx
 633:	4c 89 e6             	mov    %r12,%rsi
 636:	48 89 c7             	mov    %rax,%rdi
 639:	4d 8d 77 08          	lea    0x8(%r15),%r14
 63d:	e8 ff fe ff ff       	callq  541 <parseredirs>
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
 642:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%rbp)
  ret = parseredirs(ret, ps, es);
 649:	48 89 c3             	mov    %rax,%rbx
  while(!peek(ps, es, "|)&;")){
 64c:	48 c7 c2 9b 0f 00 00 	mov    $0xf9b,%rdx
 653:	4c 89 ee             	mov    %r13,%rsi
 656:	4c 89 e7             	mov    %r12,%rdi
 659:	e8 84 fe ff ff       	callq  4e2 <peek>
 65e:	85 c0                	test   %eax,%eax
 660:	75 17                	jne    679 <parseexec+0x88>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 662:	48 8d 4d c8          	lea    -0x38(%rbp),%rcx
 666:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
 66a:	4c 89 ee             	mov    %r13,%rsi
 66d:	4c 89 e7             	mov    %r12,%rdi
 670:	e8 6a fd ff ff       	callq  3df <gettoken>
 675:	85 c0                	test   %eax,%eax
 677:	75 1d                	jne    696 <parseexec+0xa5>
 679:	48 63 45 bc          	movslq -0x44(%rbp),%rax
 67d:	49 8d 04 c7          	lea    (%r15,%rax,8),%rax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
 681:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
 688:	00 
  cmd->eargv[argc] = 0;
 689:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
 690:	00 
 691:	48 89 d8             	mov    %rbx,%rax
 694:	eb 4d                	jmp    6e3 <parseexec+0xf2>
  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
 696:	83 f8 61             	cmp    $0x61,%eax
 699:	74 09                	je     6a4 <parseexec+0xb3>
      panic("syntax");
 69b:	48 c7 c7 86 0f 00 00 	mov    $0xf86,%rdi
 6a2:	eb 24                	jmp    6c8 <parseexec+0xd7>
    cmd->argv[argc] = q;
 6a4:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
    cmd->eargv[argc] = eq;
    argc++;
 6a8:	ff 45 bc             	incl   -0x44(%rbp)
 6ab:	49 83 c6 08          	add    $0x8,%r14
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
 6af:	49 89 46 f8          	mov    %rax,-0x8(%r14)
    cmd->eargv[argc] = eq;
 6b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
 6b7:	49 89 46 48          	mov    %rax,0x48(%r14)
    argc++;
    if(argc >= MAXARGS)
 6bb:	83 7d bc 0a          	cmpl   $0xa,-0x44(%rbp)
 6bf:	75 0c                	jne    6cd <parseexec+0xdc>
      panic("too many args");
 6c1:	48 c7 c7 8d 0f 00 00 	mov    $0xf8d,%rdi
 6c8:	e8 3b fa ff ff       	callq  108 <panic>
    ret = parseredirs(ret, ps, es);
 6cd:	48 89 df             	mov    %rbx,%rdi
 6d0:	4c 89 ea             	mov    %r13,%rdx
 6d3:	4c 89 e6             	mov    %r12,%rsi
 6d6:	e8 66 fe ff ff       	callq  541 <parseredirs>
 6db:	48 89 c3             	mov    %rax,%rbx
 6de:	e9 69 ff ff ff       	jmpq   64c <parseexec+0x5b>
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 6e3:	48 83 c4 28          	add    $0x28,%rsp
 6e7:	5b                   	pop    %rbx
 6e8:	41 5c                	pop    %r12
 6ea:	41 5d                	pop    %r13
 6ec:	41 5e                	pop    %r14
 6ee:	41 5f                	pop    %r15
 6f0:	5d                   	pop    %rbp
 6f1:	c3                   	retq   

00000000000006f2 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
 6f2:	55                   	push   %rbp
 6f3:	48 89 e5             	mov    %rsp,%rbp
 6f6:	41 55                	push   %r13
 6f8:	41 54                	push   %r12
 6fa:	53                   	push   %rbx
 6fb:	41 50                	push   %r8
 6fd:	48 89 fb             	mov    %rdi,%rbx
 700:	49 89 f4             	mov    %rsi,%r12
  struct cmd *cmd;

  cmd = parseexec(ps, es);
 703:	e8 e9 fe ff ff       	callq  5f1 <parseexec>
  if(peek(ps, es, "|")){
 708:	48 c7 c2 a0 0f 00 00 	mov    $0xfa0,%rdx
 70f:	4c 89 e6             	mov    %r12,%rsi
 712:	48 89 df             	mov    %rbx,%rdi
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
 715:	49 89 c5             	mov    %rax,%r13
  if(peek(ps, es, "|")){
 718:	e8 c5 fd ff ff       	callq  4e2 <peek>
 71d:	85 c0                	test   %eax,%eax
 71f:	74 2c                	je     74d <parsepipe+0x5b>
    gettoken(ps, es, 0, 0);
 721:	31 c9                	xor    %ecx,%ecx
 723:	4c 89 e6             	mov    %r12,%rsi
 726:	48 89 df             	mov    %rbx,%rdi
 729:	31 d2                	xor    %edx,%edx
 72b:	e8 af fc ff ff       	callq  3df <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 730:	4c 89 e6             	mov    %r12,%rsi
 733:	48 89 df             	mov    %rbx,%rdi
 736:	e8 b7 ff ff ff       	callq  6f2 <parsepipe>
  }
  return cmd;
}
 73b:	59                   	pop    %rcx
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
 73c:	4c 89 ef             	mov    %r13,%rdi
 73f:	48 89 c6             	mov    %rax,%rsi
  }
  return cmd;
}
 742:	5b                   	pop    %rbx
 743:	41 5c                	pop    %r12
 745:	41 5d                	pop    %r13
 747:	5d                   	pop    %rbp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
 748:	e9 d0 fb ff ff       	jmpq   31d <pipecmd>
  }
  return cmd;
}
 74d:	5a                   	pop    %rdx
 74e:	4c 89 e8             	mov    %r13,%rax
 751:	5b                   	pop    %rbx
 752:	41 5c                	pop    %r12
 754:	41 5d                	pop    %r13
 756:	5d                   	pop    %rbp
 757:	c3                   	retq   

0000000000000758 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
 758:	55                   	push   %rbp
 759:	48 89 e5             	mov    %rsp,%rbp
 75c:	41 55                	push   %r13
 75e:	41 54                	push   %r12
 760:	53                   	push   %rbx
 761:	41 50                	push   %r8
 763:	48 89 fb             	mov    %rdi,%rbx
 766:	49 89 f4             	mov    %rsi,%r12
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
 769:	e8 84 ff ff ff       	callq  6f2 <parsepipe>
  while(peek(ps, es, "&")){
 76e:	48 c7 c2 a2 0f 00 00 	mov    $0xfa2,%rdx
 775:	4c 89 e6             	mov    %r12,%rsi
 778:	48 89 df             	mov    %rbx,%rdi
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
 77b:	49 89 c5             	mov    %rax,%r13
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
 77e:	e8 5f fd ff ff       	callq  4e2 <peek>
 783:	85 c0                	test   %eax,%eax
 785:	74 19                	je     7a0 <parseline+0x48>
    gettoken(ps, es, 0, 0);
 787:	48 89 df             	mov    %rbx,%rdi
 78a:	31 c9                	xor    %ecx,%ecx
 78c:	31 d2                	xor    %edx,%edx
 78e:	4c 89 e6             	mov    %r12,%rsi
 791:	e8 49 fc ff ff       	callq  3df <gettoken>
    cmd = backcmd(cmd);
 796:	4c 89 ef             	mov    %r13,%rdi
 799:	e8 09 fc ff ff       	callq  3a7 <backcmd>
 79e:	eb ce                	jmp    76e <parseline+0x16>
  }
  if(peek(ps, es, ";")){
 7a0:	48 c7 c2 9e 0f 00 00 	mov    $0xf9e,%rdx
 7a7:	4c 89 e6             	mov    %r12,%rsi
 7aa:	48 89 df             	mov    %rbx,%rdi
 7ad:	e8 30 fd ff ff       	callq  4e2 <peek>
 7b2:	85 c0                	test   %eax,%eax
 7b4:	74 2c                	je     7e2 <parseline+0x8a>
    gettoken(ps, es, 0, 0);
 7b6:	31 c9                	xor    %ecx,%ecx
 7b8:	4c 89 e6             	mov    %r12,%rsi
 7bb:	48 89 df             	mov    %rbx,%rdi
 7be:	31 d2                	xor    %edx,%edx
 7c0:	e8 1a fc ff ff       	callq  3df <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 7c5:	4c 89 e6             	mov    %r12,%rsi
 7c8:	48 89 df             	mov    %rbx,%rdi
 7cb:	e8 88 ff ff ff       	callq  758 <parseline>
  }
  return cmd;
}
 7d0:	59                   	pop    %rcx
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
 7d1:	4c 89 ef             	mov    %r13,%rdi
 7d4:	48 89 c6             	mov    %rax,%rsi
  }
  return cmd;
}
 7d7:	5b                   	pop    %rbx
 7d8:	41 5c                	pop    %r12
 7da:	41 5d                	pop    %r13
 7dc:	5d                   	pop    %rbp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
 7dd:	e9 80 fb ff ff       	jmpq   362 <listcmd>
  }
  return cmd;
}
 7e2:	5a                   	pop    %rdx
 7e3:	4c 89 e8             	mov    %r13,%rax
 7e6:	5b                   	pop    %rbx
 7e7:	41 5c                	pop    %r12
 7e9:	41 5d                	pop    %r13
 7eb:	5d                   	pop    %rbp
 7ec:	c3                   	retq   

00000000000007ed <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
 7ed:	55                   	push   %rbp
 7ee:	48 89 e5             	mov    %rsp,%rbp
 7f1:	41 55                	push   %r13
 7f3:	41 54                	push   %r12
 7f5:	53                   	push   %rbx
 7f6:	52                   	push   %rdx
  struct cmd *cmd;

  if(!peek(ps, es, "("))
 7f7:	48 c7 c2 84 0f 00 00 	mov    $0xf84,%rdx
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
 7fe:	48 89 fb             	mov    %rdi,%rbx
 801:	49 89 f4             	mov    %rsi,%r12
  struct cmd *cmd;

  if(!peek(ps, es, "("))
 804:	e8 d9 fc ff ff       	callq  4e2 <peek>
 809:	85 c0                	test   %eax,%eax
    panic("parseblock");
 80b:	48 c7 c7 a4 0f 00 00 	mov    $0xfa4,%rdi
struct cmd*
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
 812:	74 3a                	je     84e <parseblock+0x61>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
 814:	31 c9                	xor    %ecx,%ecx
 816:	31 d2                	xor    %edx,%edx
 818:	4c 89 e6             	mov    %r12,%rsi
 81b:	48 89 df             	mov    %rbx,%rdi
 81e:	e8 bc fb ff ff       	callq  3df <gettoken>
  cmd = parseline(ps, es);
 823:	4c 89 e6             	mov    %r12,%rsi
 826:	48 89 df             	mov    %rbx,%rdi
 829:	e8 2a ff ff ff       	callq  758 <parseline>
  if(!peek(ps, es, ")"))
 82e:	48 c7 c2 c0 0f 00 00 	mov    $0xfc0,%rdx
 835:	4c 89 e6             	mov    %r12,%rsi
 838:	48 89 df             	mov    %rbx,%rdi
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
 83b:	49 89 c5             	mov    %rax,%r13
  if(!peek(ps, es, ")"))
 83e:	e8 9f fc ff ff       	callq  4e2 <peek>
 843:	85 c0                	test   %eax,%eax
 845:	75 0c                	jne    853 <parseblock+0x66>
    panic("syntax - missing )");
 847:	48 c7 c7 af 0f 00 00 	mov    $0xfaf,%rdi
 84e:	e8 b5 f8 ff ff       	callq  108 <panic>
  gettoken(ps, es, 0, 0);
 853:	4c 89 e6             	mov    %r12,%rsi
 856:	48 89 df             	mov    %rbx,%rdi
 859:	31 d2                	xor    %edx,%edx
 85b:	31 c9                	xor    %ecx,%ecx
 85d:	e8 7d fb ff ff       	callq  3df <gettoken>
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}
 862:	58                   	pop    %rax
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
 863:	4c 89 e2             	mov    %r12,%rdx
 866:	48 89 de             	mov    %rbx,%rsi
 869:	4c 89 ef             	mov    %r13,%rdi
  return cmd;
}
 86c:	5b                   	pop    %rbx
 86d:	41 5c                	pop    %r12
 86f:	41 5d                	pop    %r13
 871:	5d                   	pop    %rbp
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
 872:	e9 ca fc ff ff       	jmpq   541 <parseredirs>

0000000000000877 <nulterminate>:
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
 877:	31 c0                	xor    %eax,%eax
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 879:	48 85 ff             	test   %rdi,%rdi
 87c:	74 65                	je     8e3 <nulterminate+0x6c>
    return 0;
  
  switch(cmd->type){
 87e:	8b 07                	mov    (%rdi),%eax
 880:	8d 50 ff             	lea    -0x1(%rax),%edx
 883:	48 89 f8             	mov    %rdi,%rax
 886:	83 fa 04             	cmp    $0x4,%edx
 889:	77 58                	ja     8e3 <nulterminate+0x6c>
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 88b:	55                   	push   %rbp
 88c:	48 89 e5             	mov    %rsp,%rbp
 88f:	53                   	push   %rbx
 890:	48 89 fb             	mov    %rdi,%rbx
 893:	51                   	push   %rcx
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
 894:	ff 24 d5 10 10 00 00 	jmpq   *0x1010(,%rdx,8)
 89b:	48 8d 47 08          	lea    0x8(%rdi),%rax
 89f:	48 83 c0 08          	add    $0x8,%rax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 8a3:	48 83 78 f8 00       	cmpq   $0x0,-0x8(%rax)
 8a8:	74 33                	je     8dd <nulterminate+0x66>
      *ecmd->eargv[i] = 0;
 8aa:	48 8b 50 48          	mov    0x48(%rax),%rdx
 8ae:	c6 02 00             	movb   $0x0,(%rdx)
 8b1:	eb ec                	jmp    89f <nulterminate+0x28>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 8b3:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
 8b7:	e8 bb ff ff ff       	callq  877 <nulterminate>
    *rcmd->efile = 0;
 8bc:	48 8b 43 18          	mov    0x18(%rbx),%rax
 8c0:	c6 00 00             	movb   $0x0,(%rax)
 8c3:	eb 18                	jmp    8dd <nulterminate+0x66>
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
 8c5:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
 8c9:	e8 a9 ff ff ff       	callq  877 <nulterminate>
    nulterminate(lcmd->right);
 8ce:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
 8d2:	eb 04                	jmp    8d8 <nulterminate+0x61>
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
 8d4:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
 8d8:	e8 9a ff ff ff       	callq  877 <nulterminate>
    break;
 8dd:	48 89 d8             	mov    %rbx,%rax
  }
  return cmd;
}
 8e0:	5a                   	pop    %rdx
 8e1:	5b                   	pop    %rbx
 8e2:	5d                   	pop    %rbp
 8e3:	c3                   	retq   

00000000000008e4 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
 8e4:	55                   	push   %rbp
 8e5:	48 89 e5             	mov    %rsp,%rbp
 8e8:	41 54                	push   %r12
 8ea:	53                   	push   %rbx
 8eb:	48 89 fb             	mov    %rdi,%rbx
 8ee:	48 83 ec 10          	sub    $0x10,%rsp
 8f2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
 8f6:	e8 97 00 00 00       	callq  992 <strlen>
 8fb:	89 c0                	mov    %eax,%eax
  cmd = parseline(&s, es);
 8fd:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
 901:	48 01 c3             	add    %rax,%rbx
  cmd = parseline(&s, es);
 904:	48 89 de             	mov    %rbx,%rsi
 907:	e8 4c fe ff ff       	callq  758 <parseline>
  peek(&s, es, "");
 90c:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
 910:	48 c7 c2 4e 0f 00 00 	mov    $0xf4e,%rdx
 917:	48 89 de             	mov    %rbx,%rsi
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
 91a:	49 89 c4             	mov    %rax,%r12
  peek(&s, es, "");
 91d:	e8 c0 fb ff ff       	callq  4e2 <peek>
  if(s != es){
 922:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
 926:	48 39 d3             	cmp    %rdx,%rbx
 929:	74 1f                	je     94a <parsecmd+0x66>
    printf(2, "leftovers: %s\n", s);
 92b:	bf 02 00 00 00       	mov    $0x2,%edi
 930:	48 c7 c6 c2 0f 00 00 	mov    $0xfc2,%rsi
 937:	31 c0                	xor    %eax,%eax
 939:	e8 b6 02 00 00       	callq  bf4 <printf>
    panic("syntax");
 93e:	48 c7 c7 86 0f 00 00 	mov    $0xf86,%rdi
 945:	e8 be f7 ff ff       	callq  108 <panic>
  }
  nulterminate(cmd);
 94a:	4c 89 e7             	mov    %r12,%rdi
 94d:	e8 25 ff ff ff       	callq  877 <nulterminate>
  return cmd;
}
 952:	5a                   	pop    %rdx
 953:	4c 89 e0             	mov    %r12,%rax
 956:	59                   	pop    %rcx
 957:	5b                   	pop    %rbx
 958:	41 5c                	pop    %r12
 95a:	5d                   	pop    %rbp
 95b:	c3                   	retq   

000000000000095c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 95c:	55                   	push   %rbp
 95d:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 960:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 962:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 965:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
 968:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
 96b:	48 ff c2             	inc    %rdx
 96e:	84 c9                	test   %cl,%cl
 970:	75 f3                	jne    965 <strcpy+0x9>
    ;
  return os;
}
 972:	5d                   	pop    %rbp
 973:	c3                   	retq   

0000000000000974 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 974:	55                   	push   %rbp
 975:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
 978:	0f b6 07             	movzbl (%rdi),%eax
 97b:	84 c0                	test   %al,%al
 97d:	74 0c                	je     98b <strcmp+0x17>
 97f:	3a 06                	cmp    (%rsi),%al
 981:	75 08                	jne    98b <strcmp+0x17>
    p++, q++;
 983:	48 ff c7             	inc    %rdi
 986:	48 ff c6             	inc    %rsi
 989:	eb ed                	jmp    978 <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
 98b:	0f b6 16             	movzbl (%rsi),%edx
}
 98e:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
 98f:	29 d0                	sub    %edx,%eax
}
 991:	c3                   	retq   

0000000000000992 <strlen>:

uint
strlen(const char *s)
{
 992:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
 993:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 995:	48 89 e5             	mov    %rsp,%rbp
 998:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
 99c:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
 9a1:	74 05                	je     9a8 <strlen+0x16>
 9a3:	48 89 d0             	mov    %rdx,%rax
 9a6:	eb f0                	jmp    998 <strlen+0x6>
    ;
  return n;
}
 9a8:	5d                   	pop    %rbp
 9a9:	c3                   	retq   

00000000000009aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 9aa:	55                   	push   %rbp
 9ab:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 9ae:	89 d1                	mov    %edx,%ecx
 9b0:	89 f0                	mov    %esi,%eax
 9b2:	48 89 e5             	mov    %rsp,%rbp
 9b5:	fc                   	cld    
 9b6:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
 9b8:	4c 89 c0             	mov    %r8,%rax
 9bb:	5d                   	pop    %rbp
 9bc:	c3                   	retq   

00000000000009bd <strchr>:

char*
strchr(const char *s, char c)
{
 9bd:	55                   	push   %rbp
 9be:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
 9c1:	8a 07                	mov    (%rdi),%al
 9c3:	84 c0                	test   %al,%al
 9c5:	74 0a                	je     9d1 <strchr+0x14>
    if(*s == c)
 9c7:	40 38 f0             	cmp    %sil,%al
 9ca:	74 09                	je     9d5 <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 9cc:	48 ff c7             	inc    %rdi
 9cf:	eb f0                	jmp    9c1 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
 9d1:	31 c0                	xor    %eax,%eax
 9d3:	eb 03                	jmp    9d8 <strchr+0x1b>
 9d5:	48 89 f8             	mov    %rdi,%rax
}
 9d8:	5d                   	pop    %rbp
 9d9:	c3                   	retq   

00000000000009da <gets>:

char*
gets(char *buf, int max)
{
 9da:	55                   	push   %rbp
 9db:	48 89 e5             	mov    %rsp,%rbp
 9de:	41 57                	push   %r15
 9e0:	41 56                	push   %r14
 9e2:	41 55                	push   %r13
 9e4:	41 54                	push   %r12
 9e6:	41 89 f7             	mov    %esi,%r15d
 9e9:	53                   	push   %rbx
 9ea:	49 89 fc             	mov    %rdi,%r12
 9ed:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9f0:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
 9f2:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 9f6:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
 9fa:	45 39 fd             	cmp    %r15d,%r13d
 9fd:	7d 2c                	jge    a2b <gets+0x51>
    cc = read(0, &c, 1);
 9ff:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
 a03:	31 ff                	xor    %edi,%edi
 a05:	ba 01 00 00 00       	mov    $0x1,%edx
 a0a:	e8 ca 00 00 00       	callq  ad9 <read>
    if(cc < 1)
 a0f:	85 c0                	test   %eax,%eax
 a11:	7e 18                	jle    a2b <gets+0x51>
      break;
    buf[i++] = c;
 a13:	8a 45 cf             	mov    -0x31(%rbp),%al
 a16:	49 ff c6             	inc    %r14
 a19:	49 63 dd             	movslq %r13d,%rbx
 a1c:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
 a20:	3c 0a                	cmp    $0xa,%al
 a22:	74 04                	je     a28 <gets+0x4e>
 a24:	3c 0d                	cmp    $0xd,%al
 a26:	75 ce                	jne    9f6 <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a28:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 a2b:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
 a30:	48 83 c4 18          	add    $0x18,%rsp
 a34:	4c 89 e0             	mov    %r12,%rax
 a37:	5b                   	pop    %rbx
 a38:	41 5c                	pop    %r12
 a3a:	41 5d                	pop    %r13
 a3c:	41 5e                	pop    %r14
 a3e:	41 5f                	pop    %r15
 a40:	5d                   	pop    %rbp
 a41:	c3                   	retq   

0000000000000a42 <stat>:

int
stat(const char *n, struct stat *st)
{
 a42:	55                   	push   %rbp
 a43:	48 89 e5             	mov    %rsp,%rbp
 a46:	41 54                	push   %r12
 a48:	53                   	push   %rbx
 a49:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a4c:	31 f6                	xor    %esi,%esi
 a4e:	e8 ae 00 00 00       	callq  b01 <open>
 a53:	41 89 c4             	mov    %eax,%r12d
 a56:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
 a59:	45 85 e4             	test   %r12d,%r12d
 a5c:	78 17                	js     a75 <stat+0x33>
    return -1;
  r = fstat(fd, st);
 a5e:	48 89 de             	mov    %rbx,%rsi
 a61:	44 89 e7             	mov    %r12d,%edi
 a64:	e8 b0 00 00 00       	callq  b19 <fstat>
  close(fd);
 a69:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 a6c:	89 c3                	mov    %eax,%ebx
  close(fd);
 a6e:	e8 76 00 00 00       	callq  ae9 <close>
  return r;
 a73:	89 d8                	mov    %ebx,%eax
}
 a75:	5b                   	pop    %rbx
 a76:	41 5c                	pop    %r12
 a78:	5d                   	pop    %rbp
 a79:	c3                   	retq   

0000000000000a7a <atoi>:

int
atoi(const char *s)
{
 a7a:	55                   	push   %rbp
  int n;

  n = 0;
 a7b:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 a7d:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a80:	0f be 17             	movsbl (%rdi),%edx
 a83:	8d 4a d0             	lea    -0x30(%rdx),%ecx
 a86:	80 f9 09             	cmp    $0x9,%cl
 a89:	77 0c                	ja     a97 <atoi+0x1d>
    n = n*10 + *s++ - '0';
 a8b:	6b c0 0a             	imul   $0xa,%eax,%eax
 a8e:	48 ff c7             	inc    %rdi
 a91:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
 a95:	eb e9                	jmp    a80 <atoi+0x6>
  return n;
}
 a97:	5d                   	pop    %rbp
 a98:	c3                   	retq   

0000000000000a99 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 a99:	55                   	push   %rbp
 a9a:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 a9d:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 a9f:	48 89 e5             	mov    %rsp,%rbp
 aa2:	89 d7                	mov    %edx,%edi
 aa4:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 aa6:	85 ff                	test   %edi,%edi
 aa8:	7e 0d                	jle    ab7 <memmove+0x1e>
    *dst++ = *src++;
 aaa:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
 aae:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
 ab2:	48 ff c1             	inc    %rcx
 ab5:	eb eb                	jmp    aa2 <memmove+0x9>
  return vdst;
}
 ab7:	5d                   	pop    %rbp
 ab8:	c3                   	retq   

0000000000000ab9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 ab9:	b8 01 00 00 00       	mov    $0x1,%eax
 abe:	cd 40                	int    $0x40
 ac0:	c3                   	retq   

0000000000000ac1 <exit>:
SYSCALL(exit)
 ac1:	b8 02 00 00 00       	mov    $0x2,%eax
 ac6:	cd 40                	int    $0x40
 ac8:	c3                   	retq   

0000000000000ac9 <wait>:
SYSCALL(wait)
 ac9:	b8 03 00 00 00       	mov    $0x3,%eax
 ace:	cd 40                	int    $0x40
 ad0:	c3                   	retq   

0000000000000ad1 <pipe>:
SYSCALL(pipe)
 ad1:	b8 04 00 00 00       	mov    $0x4,%eax
 ad6:	cd 40                	int    $0x40
 ad8:	c3                   	retq   

0000000000000ad9 <read>:
SYSCALL(read)
 ad9:	b8 05 00 00 00       	mov    $0x5,%eax
 ade:	cd 40                	int    $0x40
 ae0:	c3                   	retq   

0000000000000ae1 <write>:
SYSCALL(write)
 ae1:	b8 10 00 00 00       	mov    $0x10,%eax
 ae6:	cd 40                	int    $0x40
 ae8:	c3                   	retq   

0000000000000ae9 <close>:
SYSCALL(close)
 ae9:	b8 15 00 00 00       	mov    $0x15,%eax
 aee:	cd 40                	int    $0x40
 af0:	c3                   	retq   

0000000000000af1 <kill>:
SYSCALL(kill)
 af1:	b8 06 00 00 00       	mov    $0x6,%eax
 af6:	cd 40                	int    $0x40
 af8:	c3                   	retq   

0000000000000af9 <exec>:
SYSCALL(exec)
 af9:	b8 07 00 00 00       	mov    $0x7,%eax
 afe:	cd 40                	int    $0x40
 b00:	c3                   	retq   

0000000000000b01 <open>:
SYSCALL(open)
 b01:	b8 0f 00 00 00       	mov    $0xf,%eax
 b06:	cd 40                	int    $0x40
 b08:	c3                   	retq   

0000000000000b09 <mknod>:
SYSCALL(mknod)
 b09:	b8 11 00 00 00       	mov    $0x11,%eax
 b0e:	cd 40                	int    $0x40
 b10:	c3                   	retq   

0000000000000b11 <unlink>:
SYSCALL(unlink)
 b11:	b8 12 00 00 00       	mov    $0x12,%eax
 b16:	cd 40                	int    $0x40
 b18:	c3                   	retq   

0000000000000b19 <fstat>:
SYSCALL(fstat)
 b19:	b8 08 00 00 00       	mov    $0x8,%eax
 b1e:	cd 40                	int    $0x40
 b20:	c3                   	retq   

0000000000000b21 <link>:
SYSCALL(link)
 b21:	b8 13 00 00 00       	mov    $0x13,%eax
 b26:	cd 40                	int    $0x40
 b28:	c3                   	retq   

0000000000000b29 <mkdir>:
SYSCALL(mkdir)
 b29:	b8 14 00 00 00       	mov    $0x14,%eax
 b2e:	cd 40                	int    $0x40
 b30:	c3                   	retq   

0000000000000b31 <chdir>:
SYSCALL(chdir)
 b31:	b8 09 00 00 00       	mov    $0x9,%eax
 b36:	cd 40                	int    $0x40
 b38:	c3                   	retq   

0000000000000b39 <dup>:
SYSCALL(dup)
 b39:	b8 0a 00 00 00       	mov    $0xa,%eax
 b3e:	cd 40                	int    $0x40
 b40:	c3                   	retq   

0000000000000b41 <getpid>:
SYSCALL(getpid)
 b41:	b8 0b 00 00 00       	mov    $0xb,%eax
 b46:	cd 40                	int    $0x40
 b48:	c3                   	retq   

0000000000000b49 <sbrk>:
SYSCALL(sbrk)
 b49:	b8 0c 00 00 00       	mov    $0xc,%eax
 b4e:	cd 40                	int    $0x40
 b50:	c3                   	retq   

0000000000000b51 <sleep>:
SYSCALL(sleep)
 b51:	b8 0d 00 00 00       	mov    $0xd,%eax
 b56:	cd 40                	int    $0x40
 b58:	c3                   	retq   

0000000000000b59 <uptime>:
SYSCALL(uptime)
 b59:	b8 0e 00 00 00       	mov    $0xe,%eax
 b5e:	cd 40                	int    $0x40
 b60:	c3                   	retq   

0000000000000b61 <chmod>:
SYSCALL(chmod)
 b61:	b8 16 00 00 00       	mov    $0x16,%eax
 b66:	cd 40                	int    $0x40
 b68:	c3                   	retq   

0000000000000b69 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 b69:	55                   	push   %rbp
 b6a:	41 89 d0             	mov    %edx,%r8d
 b6d:	48 89 e5             	mov    %rsp,%rbp
 b70:	41 54                	push   %r12
 b72:	53                   	push   %rbx
 b73:	41 89 fc             	mov    %edi,%r12d
 b76:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 b7a:	85 c9                	test   %ecx,%ecx
 b7c:	74 12                	je     b90 <printint+0x27>
 b7e:	89 f0                	mov    %esi,%eax
 b80:	c1 e8 1f             	shr    $0x1f,%eax
 b83:	74 0b                	je     b90 <printint+0x27>
    neg = 1;
    x = -xx;
 b85:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 b87:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
 b8c:	f7 d8                	neg    %eax
 b8e:	eb 04                	jmp    b94 <printint+0x2b>
  } else {
    x = xx;
 b90:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 b92:	31 f6                	xor    %esi,%esi
 b94:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 b98:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
 b9a:	31 d2                	xor    %edx,%edx
 b9c:	48 ff c7             	inc    %rdi
 b9f:	8d 59 01             	lea    0x1(%rcx),%ebx
 ba2:	41 f7 f0             	div    %r8d
 ba5:	89 d2                	mov    %edx,%edx
 ba7:	8a 92 40 10 00 00    	mov    0x1040(%rdx),%dl
 bad:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
 bb0:	85 c0                	test   %eax,%eax
 bb2:	74 04                	je     bb8 <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 bb4:	89 d9                	mov    %ebx,%ecx
 bb6:	eb e2                	jmp    b9a <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
 bb8:	85 f6                	test   %esi,%esi
 bba:	74 0b                	je     bc7 <printint+0x5e>
    buf[i++] = '-';
 bbc:	48 63 db             	movslq %ebx,%rbx
 bbf:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
 bc4:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
 bc7:	ff cb                	dec    %ebx
 bc9:	83 fb ff             	cmp    $0xffffffff,%ebx
 bcc:	74 1d                	je     beb <printint+0x82>
    putc(fd, buf[i]);
 bce:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bd1:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
 bd5:	ba 01 00 00 00       	mov    $0x1,%edx
 bda:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
 bde:	44 89 e7             	mov    %r12d,%edi
 be1:	88 45 df             	mov    %al,-0x21(%rbp)
 be4:	e8 f8 fe ff ff       	callq  ae1 <write>
 be9:	eb dc                	jmp    bc7 <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
 beb:	48 83 c4 20          	add    $0x20,%rsp
 bef:	5b                   	pop    %rbx
 bf0:	41 5c                	pop    %r12
 bf2:	5d                   	pop    %rbp
 bf3:	c3                   	retq   

0000000000000bf4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 bf4:	55                   	push   %rbp
 bf5:	48 89 e5             	mov    %rsp,%rbp
 bf8:	41 56                	push   %r14
 bfa:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 bfc:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c00:	41 54                	push   %r12
 c02:	53                   	push   %rbx
 c03:	41 89 fc             	mov    %edi,%r12d
 c06:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
 c09:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c0b:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 c0f:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
 c13:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c17:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
 c1b:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
 c1f:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
 c23:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
 c27:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
 c2e:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
 c32:	45 8a 2e             	mov    (%r14),%r13b
 c35:	45 84 ed             	test   %r13b,%r13b
 c38:	0f 84 8f 01 00 00    	je     dcd <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
 c3e:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 c40:	41 0f be d5          	movsbl %r13b,%edx
 c44:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
 c48:	75 23                	jne    c6d <printf+0x79>
      if(c == '%'){
 c4a:	83 f8 25             	cmp    $0x25,%eax
 c4d:	0f 84 6d 01 00 00    	je     dc0 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c53:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
 c57:	ba 01 00 00 00       	mov    $0x1,%edx
 c5c:	44 89 e7             	mov    %r12d,%edi
 c5f:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
 c63:	e8 79 fe ff ff       	callq  ae1 <write>
 c68:	e9 58 01 00 00       	jmpq   dc5 <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 c6d:	83 fb 25             	cmp    $0x25,%ebx
 c70:	0f 85 4f 01 00 00    	jne    dc5 <printf+0x1d1>
      if(c == 'd'){
 c76:	83 f8 64             	cmp    $0x64,%eax
 c79:	75 2e                	jne    ca9 <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
 c7b:	8b 55 98             	mov    -0x68(%rbp),%edx
 c7e:	83 fa 2f             	cmp    $0x2f,%edx
 c81:	77 0e                	ja     c91 <printf+0x9d>
 c83:	89 d0                	mov    %edx,%eax
 c85:	83 c2 08             	add    $0x8,%edx
 c88:	48 03 45 a8          	add    -0x58(%rbp),%rax
 c8c:	89 55 98             	mov    %edx,-0x68(%rbp)
 c8f:	eb 0c                	jmp    c9d <printf+0xa9>
 c91:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 c95:	48 8d 50 08          	lea    0x8(%rax),%rdx
 c99:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 c9d:	b9 01 00 00 00       	mov    $0x1,%ecx
 ca2:	ba 0a 00 00 00       	mov    $0xa,%edx
 ca7:	eb 34                	jmp    cdd <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
 ca9:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 caf:	83 fa 70             	cmp    $0x70,%edx
 cb2:	75 38                	jne    cec <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
 cb4:	8b 55 98             	mov    -0x68(%rbp),%edx
 cb7:	83 fa 2f             	cmp    $0x2f,%edx
 cba:	77 0e                	ja     cca <printf+0xd6>
 cbc:	89 d0                	mov    %edx,%eax
 cbe:	83 c2 08             	add    $0x8,%edx
 cc1:	48 03 45 a8          	add    -0x58(%rbp),%rax
 cc5:	89 55 98             	mov    %edx,-0x68(%rbp)
 cc8:	eb 0c                	jmp    cd6 <printf+0xe2>
 cca:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 cce:	48 8d 50 08          	lea    0x8(%rax),%rdx
 cd2:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 cd6:	31 c9                	xor    %ecx,%ecx
 cd8:	ba 10 00 00 00       	mov    $0x10,%edx
 cdd:	8b 30                	mov    (%rax),%esi
 cdf:	44 89 e7             	mov    %r12d,%edi
 ce2:	e8 82 fe ff ff       	callq  b69 <printint>
 ce7:	e9 d0 00 00 00       	jmpq   dbc <printf+0x1c8>
      } else if(c == 's'){
 cec:	83 f8 73             	cmp    $0x73,%eax
 cef:	75 56                	jne    d47 <printf+0x153>
        s = va_arg(ap, char*);
 cf1:	8b 55 98             	mov    -0x68(%rbp),%edx
 cf4:	83 fa 2f             	cmp    $0x2f,%edx
 cf7:	77 0e                	ja     d07 <printf+0x113>
 cf9:	89 d0                	mov    %edx,%eax
 cfb:	83 c2 08             	add    $0x8,%edx
 cfe:	48 03 45 a8          	add    -0x58(%rbp),%rax
 d02:	89 55 98             	mov    %edx,-0x68(%rbp)
 d05:	eb 0c                	jmp    d13 <printf+0x11f>
 d07:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 d0b:	48 8d 50 08          	lea    0x8(%rax),%rdx
 d0f:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 d13:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
 d16:	48 c7 c0 38 10 00 00 	mov    $0x1038,%rax
 d1d:	48 85 db             	test   %rbx,%rbx
 d20:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
 d24:	8a 03                	mov    (%rbx),%al
 d26:	84 c0                	test   %al,%al
 d28:	0f 84 8e 00 00 00    	je     dbc <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d2e:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
 d32:	ba 01 00 00 00       	mov    $0x1,%edx
 d37:	44 89 e7             	mov    %r12d,%edi
 d3a:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 d3d:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d40:	e8 9c fd ff ff       	callq  ae1 <write>
 d45:	eb dd                	jmp    d24 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 d47:	83 f8 63             	cmp    $0x63,%eax
 d4a:	75 32                	jne    d7e <printf+0x18a>
        putc(fd, va_arg(ap, uint));
 d4c:	8b 55 98             	mov    -0x68(%rbp),%edx
 d4f:	83 fa 2f             	cmp    $0x2f,%edx
 d52:	77 0e                	ja     d62 <printf+0x16e>
 d54:	89 d0                	mov    %edx,%eax
 d56:	83 c2 08             	add    $0x8,%edx
 d59:	48 03 45 a8          	add    -0x58(%rbp),%rax
 d5d:	89 55 98             	mov    %edx,-0x68(%rbp)
 d60:	eb 0c                	jmp    d6e <printf+0x17a>
 d62:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
 d66:	48 8d 50 08          	lea    0x8(%rax),%rdx
 d6a:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
 d6e:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d70:	ba 01 00 00 00       	mov    $0x1,%edx
 d75:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
 d79:	88 45 94             	mov    %al,-0x6c(%rbp)
 d7c:	eb 36                	jmp    db4 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 d7e:	83 f8 25             	cmp    $0x25,%eax
 d81:	75 0f                	jne    d92 <printf+0x19e>
 d83:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d87:	ba 01 00 00 00       	mov    $0x1,%edx
 d8c:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
 d90:	eb 22                	jmp    db4 <printf+0x1c0>
 d92:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
 d96:	ba 01 00 00 00       	mov    $0x1,%edx
 d9b:	44 89 e7             	mov    %r12d,%edi
 d9e:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
 da2:	e8 3a fd ff ff       	callq  ae1 <write>
 da7:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
 dab:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
 daf:	ba 01 00 00 00       	mov    $0x1,%edx
 db4:	44 89 e7             	mov    %r12d,%edi
 db7:	e8 25 fd ff ff       	callq  ae1 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 dbc:	31 db                	xor    %ebx,%ebx
 dbe:	eb 05                	jmp    dc5 <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 dc0:	bb 25 00 00 00       	mov    $0x25,%ebx
 dc5:	49 ff c6             	inc    %r14
 dc8:	e9 65 fe ff ff       	jmpq   c32 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 dcd:	48 83 c4 50          	add    $0x50,%rsp
 dd1:	5b                   	pop    %rbx
 dd2:	41 5c                	pop    %r12
 dd4:	41 5d                	pop    %r13
 dd6:	41 5e                	pop    %r14
 dd8:	5d                   	pop    %rbp
 dd9:	c3                   	retq   

0000000000000dda <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 dda:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ddb:	48 8b 05 6e 08 00 00 	mov    0x86e(%rip),%rax        # 1650 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 de2:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
 de6:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 de9:	48 39 d0             	cmp    %rdx,%rax
 dec:	48 8b 08             	mov    (%rax),%rcx
 def:	72 14                	jb     e05 <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 df1:	48 39 c8             	cmp    %rcx,%rax
 df4:	72 0a                	jb     e00 <free+0x26>
 df6:	48 39 ca             	cmp    %rcx,%rdx
 df9:	72 0f                	jb     e0a <free+0x30>
 dfb:	48 39 d0             	cmp    %rdx,%rax
 dfe:	72 0a                	jb     e0a <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
 e00:	48 89 c8             	mov    %rcx,%rax
 e03:	eb e4                	jmp    de9 <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e05:	48 39 ca             	cmp    %rcx,%rdx
 e08:	73 e7                	jae    df1 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 e0a:	8b 77 f8             	mov    -0x8(%rdi),%esi
 e0d:	49 89 f0             	mov    %rsi,%r8
 e10:	48 c1 e6 04          	shl    $0x4,%rsi
 e14:	48 01 d6             	add    %rdx,%rsi
 e17:	48 39 ce             	cmp    %rcx,%rsi
 e1a:	75 0e                	jne    e2a <free+0x50>
    bp->s.size += p->s.ptr->s.size;
 e1c:	44 03 41 08          	add    0x8(%rcx),%r8d
 e20:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
 e24:	48 8b 08             	mov    (%rax),%rcx
 e27:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
 e2a:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
 e2e:	8b 48 08             	mov    0x8(%rax),%ecx
 e31:	48 89 ce             	mov    %rcx,%rsi
 e34:	48 c1 e1 04          	shl    $0x4,%rcx
 e38:	48 01 c1             	add    %rax,%rcx
 e3b:	48 39 ca             	cmp    %rcx,%rdx
 e3e:	75 0a                	jne    e4a <free+0x70>
    p->s.size += bp->s.size;
 e40:	03 77 f8             	add    -0x8(%rdi),%esi
 e43:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
 e46:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
 e4a:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
 e4d:	48 89 05 fc 07 00 00 	mov    %rax,0x7fc(%rip)        # 1650 <freep>
}
 e54:	5d                   	pop    %rbp
 e55:	c3                   	retq   

0000000000000e56 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e56:	55                   	push   %rbp
 e57:	48 89 e5             	mov    %rsp,%rbp
 e5a:	41 55                	push   %r13
 e5c:	41 54                	push   %r12
 e5e:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e5f:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
 e61:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
 e62:	48 8b 0d e7 07 00 00 	mov    0x7e7(%rip),%rcx        # 1650 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e69:	48 83 c3 0f          	add    $0xf,%rbx
 e6d:	48 c1 eb 04          	shr    $0x4,%rbx
 e71:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
 e73:	48 85 c9             	test   %rcx,%rcx
 e76:	75 27                	jne    e9f <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
 e78:	48 c7 05 cd 07 00 00 	movq   $0x1660,0x7cd(%rip)        # 1650 <freep>
 e7f:	60 16 00 00 
 e83:	48 c7 05 d2 07 00 00 	movq   $0x1660,0x7d2(%rip)        # 1660 <base>
 e8a:	60 16 00 00 
 e8e:	48 c7 c1 60 16 00 00 	mov    $0x1660,%rcx
    base.s.size = 0;
 e95:	c7 05 c9 07 00 00 00 	movl   $0x0,0x7c9(%rip)        # 1668 <base+0x8>
 e9c:	00 00 00 
 e9f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 ea5:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eab:	48 8b 01             	mov    (%rcx),%rax
 eae:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 eb2:	45 89 e5             	mov    %r12d,%r13d
 eb5:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 eb9:	8b 50 08             	mov    0x8(%rax),%edx
 ebc:	39 d3                	cmp    %edx,%ebx
 ebe:	77 26                	ja     ee6 <malloc+0x90>
      if(p->s.size == nunits)
 ec0:	75 08                	jne    eca <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 ec2:	48 8b 10             	mov    (%rax),%rdx
 ec5:	48 89 11             	mov    %rdx,(%rcx)
 ec8:	eb 0f                	jmp    ed9 <malloc+0x83>
      else {
        p->s.size -= nunits;
 eca:	29 da                	sub    %ebx,%edx
 ecc:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
 ecf:	48 c1 e2 04          	shl    $0x4,%rdx
 ed3:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
 ed6:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
 ed9:	48 89 0d 70 07 00 00 	mov    %rcx,0x770(%rip)        # 1650 <freep>
      return (void*)(p + 1);
 ee0:	48 83 c0 10          	add    $0x10,%rax
 ee4:	eb 3a                	jmp    f20 <malloc+0xca>
    }
    if(p == freep)
 ee6:	48 3b 05 63 07 00 00 	cmp    0x763(%rip),%rax        # 1650 <freep>
 eed:	75 27                	jne    f16 <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 eef:	44 89 ef             	mov    %r13d,%edi
 ef2:	e8 52 fc ff ff       	callq  b49 <sbrk>
  if(p == (char*)-1)
 ef7:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
 efb:	74 21                	je     f1e <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
 efd:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f01:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
 f05:	e8 d0 fe ff ff       	callq  dda <free>
  return freep;
 f0a:	48 8b 05 3f 07 00 00 	mov    0x73f(%rip),%rax        # 1650 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 f11:	48 85 c0             	test   %rax,%rax
 f14:	74 08                	je     f1e <malloc+0xc8>
        return 0;
  }
 f16:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f19:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f1c:	eb 9b                	jmp    eb9 <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 f1e:	31 c0                	xor    %eax,%eax
  }
}
 f20:	5a                   	pop    %rdx
 f21:	5b                   	pop    %rbx
 f22:	41 5c                	pop    %r12
 f24:	41 5d                	pop    %r13
 f26:	5d                   	pop    %rbp
 f27:	c3                   	retq   
