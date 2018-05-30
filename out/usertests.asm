
.fs/usertests:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	55                   	push   %rbp
  printf(1, "usertests starting\n");
       1:	31 c0                	xor    %eax,%eax
       3:	48 c7 c6 dc 45 00 00 	mov    $0x45dc,%rsi
       a:	bf 01 00 00 00       	mov    $0x1,%edi
  return randstate;
}

int
main(int argc, char *argv[])
{
       f:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "usertests starting\n");
      12:	e8 12 2c 00 00       	callq  2c29 <printf>

  if(open("usertests.ran", 0) >= 0){
      17:	31 f6                	xor    %esi,%esi
      19:	48 c7 c7 f0 45 00 00 	mov    $0x45f0,%rdi
      20:	e8 11 2b 00 00       	callq  2b36 <open>
      25:	85 c0                	test   %eax,%eax
      27:	78 18                	js     41 <main+0x41>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      29:	48 c7 c6 fe 45 00 00 	mov    $0x45fe,%rsi
      30:	bf 01 00 00 00       	mov    $0x1,%edi
      35:	31 c0                	xor    %eax,%eax
      37:	e8 ed 2b 00 00       	callq  2c29 <printf>
      3c:	e9 bf 00 00 00       	jmpq   100 <main+0x100>
    exit();
  }
  close(open("usertests.ran", O_CREATE));
      41:	be 00 02 00 00       	mov    $0x200,%esi
      46:	48 c7 c7 f0 45 00 00 	mov    $0x45f0,%rdi
      4d:	e8 e4 2a 00 00       	callq  2b36 <open>
      52:	89 c7                	mov    %eax,%edi
      54:	e8 c5 2a 00 00       	callq  2b1e <close>

  createdelete();
      59:	e8 02 0e 00 00       	callq  e60 <createdelete>
  linkunlink();
      5e:	31 c0                	xor    %eax,%eax
      60:	e8 d6 14 00 00       	callq  153b <linkunlink>
  concreate();
      65:	e8 6f 12 00 00       	callq  12d9 <concreate>
  fourfiles();
      6a:	e8 42 0c 00 00       	callq  cb1 <fourfiles>
  sharedfd();
      6f:	e8 c8 0a 00 00       	callq  b3c <sharedfd>

  bigargtest();
      74:	e8 a5 26 00 00       	callq  271e <bigargtest>
  bigwrite();
      79:	e8 61 1b 00 00       	callq  1bdf <bigwrite>
  bigargtest();
      7e:	e8 9b 26 00 00       	callq  271e <bigargtest>
  bsstest();
      83:	e8 33 26 00 00       	callq  26bb <bsstest>
  sbrktest();
      88:	e8 5d 22 00 00       	callq  22ea <sbrktest>
  validatetest();
      8d:	e8 91 25 00 00       	callq  2623 <validatetest>

  opentest();
      92:	e8 52 02 00 00       	callq  2e9 <opentest>
  writetest();
      97:	e8 c7 02 00 00       	callq  363 <writetest>
  writetest1();
      9c:	e8 40 04 00 00       	callq  4e1 <writetest1>
  createtest();
      a1:	e8 a1 05 00 00       	callq  647 <createtest>

  openiputtest();
      a6:	e8 92 01 00 00       	callq  23d <openiputtest>
  exitiputtest();
      ab:	e8 f0 00 00 00       	callq  1a0 <exitiputtest>
  iputtest();
      b0:	e8 50 00 00 00       	callq  105 <iputtest>

  mem();
      b5:	e8 d0 09 00 00       	callq  a8a <mem>
  pipe1();
      ba:	e8 fc 06 00 00       	callq  7bb <pipe1>
  preempt();
      bf:	e8 4a 08 00 00       	callq  90e <preempt>
  exitwait();
      c4:	e8 6b 09 00 00       	callq  a34 <exitwait>

  rmdot();
      c9:	e8 35 1e 00 00       	callq  1f03 <rmdot>
  fourteen();
      ce:	e8 4b 1d 00 00       	callq  1e1e <fourteen>
  bigfile();
      d3:	e8 e3 1b 00 00       	callq  1cbb <bigfile>
  subdir();
      d8:	e8 4e 16 00 00       	callq  172b <subdir>
  linktest();
      dd:	e8 65 10 00 00       	callq  1147 <linktest>
  unlinkread();
      e2:	e8 19 0f 00 00       	callq  1000 <unlinkread>
  dirfile();
      e7:	e8 19 1f 00 00       	callq  2005 <dirfile>
  iref();
      ec:	e8 87 20 00 00       	callq  2178 <iref>
  forktest();
      f1:	e8 6e 21 00 00       	callq  2264 <forktest>
  bigdir(); // slow
      f6:	e8 29 15 00 00       	callq  1624 <bigdir>
  exectest();
      fb:	e8 71 06 00 00       	callq  771 <exectest>

  exit();
     100:	e8 f1 29 00 00       	callq  2af6 <exit>

0000000000000105 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
     105:	55                   	push   %rbp
  printf(stdout, "iput test\n");
     106:	8b 3d 7c 4d 00 00    	mov    0x4d7c(%rip),%edi        # 4e88 <stdout>
     10c:	48 c7 c6 f4 2f 00 00 	mov    $0x2ff4,%rsi
     113:	31 c0                	xor    %eax,%eax
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
     115:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "iput test\n");
     118:	e8 0c 2b 00 00       	callq  2c29 <printf>

  if(mkdir("iputdir") < 0){
     11d:	48 c7 c7 87 2f 00 00 	mov    $0x2f87,%rdi
     124:	e8 35 2a 00 00       	callq  2b5e <mkdir>
     129:	85 c0                	test   %eax,%eax
    printf(stdout, "mkdir failed\n");
     12b:	48 c7 c6 60 2f 00 00 	mov    $0x2f60,%rsi
void
iputtest(void)
{
  printf(stdout, "iput test\n");

  if(mkdir("iputdir") < 0){
     132:	78 17                	js     14b <iputtest+0x46>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
     134:	48 c7 c7 87 2f 00 00 	mov    $0x2f87,%rdi
     13b:	e8 26 2a 00 00       	callq  2b66 <chdir>
     140:	85 c0                	test   %eax,%eax
     142:	79 19                	jns    15d <iputtest+0x58>
    printf(stdout, "chdir iputdir failed\n");
     144:	48 c7 c6 6e 2f 00 00 	mov    $0x2f6e,%rsi
     14b:	8b 3d 37 4d 00 00    	mov    0x4d37(%rip),%edi        # 4e88 <stdout>
     151:	31 c0                	xor    %eax,%eax
     153:	e8 d1 2a 00 00       	callq  2c29 <printf>
    exit();
     158:	e8 99 29 00 00       	callq  2af6 <exit>
  }
  if(unlink("../iputdir") < 0){
     15d:	48 c7 c7 84 2f 00 00 	mov    $0x2f84,%rdi
     164:	e8 dd 29 00 00       	callq  2b46 <unlink>
     169:	85 c0                	test   %eax,%eax
    printf(stdout, "unlink ../iputdir failed\n");
     16b:	48 c7 c6 8f 2f 00 00 	mov    $0x2f8f,%rsi
  }
  if(chdir("iputdir") < 0){
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
     172:	78 d7                	js     14b <iputtest+0x46>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
     174:	48 c7 c7 a9 2f 00 00 	mov    $0x2fa9,%rdi
     17b:	e8 e6 29 00 00       	callq  2b66 <chdir>
     180:	85 c0                	test   %eax,%eax
    printf(stdout, "chdir / failed\n");
     182:	48 c7 c6 ab 2f 00 00 	mov    $0x2fab,%rsi
     189:	8b 3d f9 4c 00 00    	mov    0x4cf9(%rip),%edi        # 4e88 <stdout>
  }
  if(unlink("../iputdir") < 0){
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
     18f:	78 c0                	js     151 <iputtest+0x4c>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
}
     191:	5d                   	pop    %rbp
  }
  if(chdir("/") < 0){
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
     192:	48 c7 c6 50 30 00 00 	mov    $0x3050,%rsi
     199:	31 c0                	xor    %eax,%eax
     19b:	e9 89 2a 00 00       	jmpq   2c29 <printf>

00000000000001a0 <exitiputtest>:
}

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
     1a0:	55                   	push   %rbp
  int pid;

  printf(stdout, "exitiput test\n");
     1a1:	8b 3d e1 4c 00 00    	mov    0x4ce1(%rip),%edi        # 4e88 <stdout>
     1a7:	48 c7 c6 bb 2f 00 00 	mov    $0x2fbb,%rsi
     1ae:	31 c0                	xor    %eax,%eax
}

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
     1b0:	48 89 e5             	mov    %rsp,%rbp
  int pid;

  printf(stdout, "exitiput test\n");
     1b3:	e8 71 2a 00 00       	callq  2c29 <printf>

  pid = fork();
     1b8:	e8 31 29 00 00       	callq  2aee <fork>
  if(pid < 0){
     1bd:	85 c0                	test   %eax,%eax
    printf(stdout, "fork failed\n");
     1bf:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
  int pid;

  printf(stdout, "exitiput test\n");

  pid = fork();
  if(pid < 0){
     1c6:	78 19                	js     1e1 <exitiputtest+0x41>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     1c8:	75 59                	jne    223 <exitiputtest+0x83>
    if(mkdir("iputdir") < 0){
     1ca:	48 c7 c7 87 2f 00 00 	mov    $0x2f87,%rdi
     1d1:	e8 88 29 00 00       	callq  2b5e <mkdir>
     1d6:	85 c0                	test   %eax,%eax
     1d8:	79 19                	jns    1f3 <exitiputtest+0x53>
      printf(stdout, "mkdir failed\n");
     1da:	48 c7 c6 60 2f 00 00 	mov    $0x2f60,%rsi
     1e1:	8b 3d a1 4c 00 00    	mov    0x4ca1(%rip),%edi        # 4e88 <stdout>
     1e7:	31 c0                	xor    %eax,%eax
     1e9:	e8 3b 2a 00 00       	callq  2c29 <printf>
      exit();
     1ee:	e8 03 29 00 00       	callq  2af6 <exit>
    }
    if(chdir("iputdir") < 0){
     1f3:	48 c7 c7 87 2f 00 00 	mov    $0x2f87,%rdi
     1fa:	e8 67 29 00 00       	callq  2b66 <chdir>
     1ff:	85 c0                	test   %eax,%eax
      printf(stdout, "child chdir failed\n");
     201:	48 c7 c6 ca 2f 00 00 	mov    $0x2fca,%rsi
  if(pid == 0){
    if(mkdir("iputdir") < 0){
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     208:	78 d7                	js     1e1 <exitiputtest+0x41>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     20a:	48 c7 c7 84 2f 00 00 	mov    $0x2f84,%rdi
     211:	e8 30 29 00 00       	callq  2b46 <unlink>
     216:	85 c0                	test   %eax,%eax
      printf(stdout, "unlink ../iputdir failed\n");
     218:	48 c7 c6 8f 2f 00 00 	mov    $0x2f8f,%rsi
    }
    if(chdir("iputdir") < 0){
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     21f:	79 cd                	jns    1ee <exitiputtest+0x4e>
     221:	eb be                	jmp    1e1 <exitiputtest+0x41>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
  }
  wait();
     223:	e8 d6 28 00 00       	callq  2afe <wait>
  printf(stdout, "exitiput test ok\n");
}
     228:	5d                   	pop    %rbp
      exit();
    }
    exit();
  }
  wait();
  printf(stdout, "exitiput test ok\n");
     229:	8b 3d 59 4c 00 00    	mov    0x4c59(%rip),%edi        # 4e88 <stdout>
     22f:	48 c7 c6 de 2f 00 00 	mov    $0x2fde,%rsi
     236:	31 c0                	xor    %eax,%eax
     238:	e9 ec 29 00 00       	jmpq   2c29 <printf>

000000000000023d <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     23d:	55                   	push   %rbp
  int pid;

  printf(stdout, "openiput test\n");
     23e:	8b 3d 44 4c 00 00    	mov    0x4c44(%rip),%edi        # 4e88 <stdout>
     244:	48 c7 c6 f0 2f 00 00 	mov    $0x2ff0,%rsi
     24b:	31 c0                	xor    %eax,%eax
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     24d:	48 89 e5             	mov    %rsp,%rbp
  int pid;

  printf(stdout, "openiput test\n");
     250:	e8 d4 29 00 00       	callq  2c29 <printf>
  if(mkdir("oidir") < 0){
     255:	48 c7 c7 ff 2f 00 00 	mov    $0x2fff,%rdi
     25c:	e8 fd 28 00 00       	callq  2b5e <mkdir>
     261:	85 c0                	test   %eax,%eax
    printf(stdout, "mkdir oidir failed\n");
     263:	48 c7 c6 05 30 00 00 	mov    $0x3005,%rsi
openiputtest(void)
{
  int pid;

  printf(stdout, "openiput test\n");
  if(mkdir("oidir") < 0){
     26a:	78 10                	js     27c <openiputtest+0x3f>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     26c:	e8 7d 28 00 00       	callq  2aee <fork>
  if(pid < 0){
     271:	85 c0                	test   %eax,%eax
     273:	79 19                	jns    28e <openiputtest+0x51>
    printf(stdout, "fork failed\n");
     275:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
     27c:	8b 3d 06 4c 00 00    	mov    0x4c06(%rip),%edi        # 4e88 <stdout>
     282:	31 c0                	xor    %eax,%eax
     284:	e8 a0 29 00 00       	callq  2c29 <printf>
    exit();
     289:	e8 68 28 00 00       	callq  2af6 <exit>
  }
  if(pid == 0){
     28e:	75 1e                	jne    2ae <openiputtest+0x71>
    int fd = open("oidir", O_RDWR);
     290:	be 02 00 00 00       	mov    $0x2,%esi
     295:	48 c7 c7 ff 2f 00 00 	mov    $0x2fff,%rdi
     29c:	e8 95 28 00 00       	callq  2b36 <open>
    if(fd >= 0){
     2a1:	85 c0                	test   %eax,%eax
      printf(stdout, "open directory for write succeeded\n");
     2a3:	48 c7 c6 19 30 00 00 	mov    $0x3019,%rsi
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
    int fd = open("oidir", O_RDWR);
    if(fd >= 0){
     2aa:	79 d0                	jns    27c <openiputtest+0x3f>
     2ac:	eb db                	jmp    289 <openiputtest+0x4c>
      printf(stdout, "open directory for write succeeded\n");
      exit();
    }
    exit();
  }
  sleep(1);
     2ae:	bf 01 00 00 00       	mov    $0x1,%edi
     2b3:	e8 ce 28 00 00       	callq  2b86 <sleep>
  if(unlink("oidir") != 0){
     2b8:	48 c7 c7 ff 2f 00 00 	mov    $0x2fff,%rdi
     2bf:	e8 82 28 00 00       	callq  2b46 <unlink>
     2c4:	85 c0                	test   %eax,%eax
    printf(stdout, "unlink failed\n");
     2c6:	48 c7 c6 3d 30 00 00 	mov    $0x303d,%rsi
      exit();
    }
    exit();
  }
  sleep(1);
  if(unlink("oidir") != 0){
     2cd:	75 ad                	jne    27c <openiputtest+0x3f>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     2cf:	e8 2a 28 00 00       	callq  2afe <wait>
  printf(stdout, "openiput test ok\n");
}
     2d4:	5d                   	pop    %rbp
  if(unlink("oidir") != 0){
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
  printf(stdout, "openiput test ok\n");
     2d5:	8b 3d ad 4b 00 00    	mov    0x4bad(%rip),%edi        # 4e88 <stdout>
     2db:	48 c7 c6 4c 30 00 00 	mov    $0x304c,%rsi
     2e2:	31 c0                	xor    %eax,%eax
     2e4:	e9 40 29 00 00       	jmpq   2c29 <printf>

00000000000002e9 <opentest>:

// simple file system tests

void
opentest(void)
{
     2e9:	55                   	push   %rbp
  int fd;

  printf(stdout, "open test\n");
     2ea:	8b 3d 98 4b 00 00    	mov    0x4b98(%rip),%edi        # 4e88 <stdout>
     2f0:	31 c0                	xor    %eax,%eax
     2f2:	48 c7 c6 5e 30 00 00 	mov    $0x305e,%rsi

// simple file system tests

void
opentest(void)
{
     2f9:	48 89 e5             	mov    %rsp,%rbp
  int fd;

  printf(stdout, "open test\n");
     2fc:	e8 28 29 00 00       	callq  2c29 <printf>
  fd = open("echo", 0);
     301:	31 f6                	xor    %esi,%esi
     303:	48 c7 c7 69 30 00 00 	mov    $0x3069,%rdi
     30a:	e8 27 28 00 00       	callq  2b36 <open>
  if(fd < 0){
     30f:	85 c0                	test   %eax,%eax
     311:	79 0f                	jns    322 <opentest+0x39>
    printf(stdout, "open echo failed!\n");
     313:	48 c7 c6 6e 30 00 00 	mov    $0x306e,%rsi
     31a:	8b 3d 68 4b 00 00    	mov    0x4b68(%rip),%edi        # 4e88 <stdout>
     320:	eb 26                	jmp    348 <opentest+0x5f>
    exit();
  }
  close(fd);
     322:	89 c7                	mov    %eax,%edi
     324:	e8 f5 27 00 00       	callq  2b1e <close>
  fd = open("doesnotexist", 0);
     329:	31 f6                	xor    %esi,%esi
     32b:	48 c7 c7 81 30 00 00 	mov    $0x3081,%rdi
     332:	e8 ff 27 00 00       	callq  2b36 <open>
  if(fd >= 0){
     337:	85 c0                	test   %eax,%eax
     339:	8b 3d 49 4b 00 00    	mov    0x4b49(%rip),%edi        # 4e88 <stdout>
     33f:	78 13                	js     354 <opentest+0x6b>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	48 c7 c6 8e 30 00 00 	mov    $0x308e,%rsi
     348:	31 c0                	xor    %eax,%eax
     34a:	e8 da 28 00 00       	callq  2c29 <printf>
    exit();
     34f:	e8 a2 27 00 00       	callq  2af6 <exit>
  }
  printf(stdout, "open test ok\n");
}
     354:	5d                   	pop    %rbp
  fd = open("doesnotexist", 0);
  if(fd >= 0){
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     355:	48 c7 c6 ac 30 00 00 	mov    $0x30ac,%rsi
     35c:	31 c0                	xor    %eax,%eax
     35e:	e9 c6 28 00 00       	jmpq   2c29 <printf>

0000000000000363 <writetest>:
}

void
writetest(void)
{
     363:	55                   	push   %rbp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     364:	8b 3d 1e 4b 00 00    	mov    0x4b1e(%rip),%edi        # 4e88 <stdout>
     36a:	31 c0                	xor    %eax,%eax
     36c:	48 c7 c6 ba 30 00 00 	mov    $0x30ba,%rsi
  printf(stdout, "open test ok\n");
}

void
writetest(void)
{
     373:	48 89 e5             	mov    %rsp,%rbp
     376:	41 54                	push   %r12
     378:	53                   	push   %rbx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     379:	e8 ab 28 00 00       	callq  2c29 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     37e:	48 c7 c7 cb 30 00 00 	mov    $0x30cb,%rdi
     385:	be 02 02 00 00       	mov    $0x202,%esi
     38a:	e8 a7 27 00 00       	callq  2b36 <open>
  if(fd >= 0){
     38f:	85 c0                	test   %eax,%eax
     391:	8b 3d f1 4a 00 00    	mov    0x4af1(%rip),%edi        # 4e88 <stdout>
     397:	78 15                	js     3ae <writetest+0x4b>
     399:	41 89 c4             	mov    %eax,%r12d
    printf(stdout, "creat small succeeded; ok\n");
     39c:	48 c7 c6 d1 30 00 00 	mov    $0x30d1,%rsi
     3a3:	31 c0                	xor    %eax,%eax
     3a5:	e8 7f 28 00 00       	callq  2c29 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3aa:	31 db                	xor    %ebx,%ebx
     3ac:	eb 13                	jmp    3c1 <writetest+0x5e>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3ae:	48 c7 c6 ec 30 00 00 	mov    $0x30ec,%rsi
     3b5:	e9 09 01 00 00       	jmpq   4c3 <writetest+0x160>
    exit();
  }
  for(i = 0; i < 100; i++){
     3ba:	ff c3                	inc    %ebx
     3bc:	83 fb 64             	cmp    $0x64,%ebx
     3bf:	74 58                	je     419 <writetest+0xb6>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3c1:	ba 0a 00 00 00       	mov    $0xa,%edx
     3c6:	48 c7 c6 08 31 00 00 	mov    $0x3108,%rsi
     3cd:	44 89 e7             	mov    %r12d,%edi
     3d0:	e8 41 27 00 00       	callq  2b16 <write>
     3d5:	83 f8 0a             	cmp    $0xa,%eax
     3d8:	74 1b                	je     3f5 <writetest+0x92>
      printf(stdout, "error: write aa %d new file failed\n", i);
     3da:	89 da                	mov    %ebx,%edx
     3dc:	48 c7 c6 13 31 00 00 	mov    $0x3113,%rsi
     3e3:	8b 3d 9f 4a 00 00    	mov    0x4a9f(%rip),%edi        # 4e88 <stdout>
     3e9:	31 c0                	xor    %eax,%eax
     3eb:	e8 39 28 00 00       	callq  2c29 <printf>
      exit();
     3f0:	e8 01 27 00 00       	callq  2af6 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3f5:	ba 0a 00 00 00       	mov    $0xa,%edx
     3fa:	48 c7 c6 37 31 00 00 	mov    $0x3137,%rsi
     401:	44 89 e7             	mov    %r12d,%edi
     404:	e8 0d 27 00 00       	callq  2b16 <write>
     409:	83 f8 0a             	cmp    $0xa,%eax
     40c:	74 ac                	je     3ba <writetest+0x57>
      printf(stdout, "error: write bb %d new file failed\n", i);
     40e:	89 da                	mov    %ebx,%edx
     410:	48 c7 c6 42 31 00 00 	mov    $0x3142,%rsi
     417:	eb ca                	jmp    3e3 <writetest+0x80>
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     419:	8b 3d 69 4a 00 00    	mov    0x4a69(%rip),%edi        # 4e88 <stdout>
     41f:	48 c7 c6 66 31 00 00 	mov    $0x3166,%rsi
     426:	31 c0                	xor    %eax,%eax
     428:	e8 fc 27 00 00       	callq  2c29 <printf>
  close(fd);
     42d:	44 89 e7             	mov    %r12d,%edi
     430:	e8 e9 26 00 00       	callq  2b1e <close>
  fd = open("small", O_RDONLY);
     435:	31 f6                	xor    %esi,%esi
     437:	48 c7 c7 cb 30 00 00 	mov    $0x30cb,%rdi
     43e:	e8 f3 26 00 00       	callq  2b36 <open>
  if(fd >= 0){
     443:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  printf(stdout, "writes ok\n");
  close(fd);
  fd = open("small", O_RDONLY);
     445:	89 c3                	mov    %eax,%ebx
     447:	8b 3d 3b 4a 00 00    	mov    0x4a3b(%rip),%edi        # 4e88 <stdout>
  if(fd >= 0){
     44d:	78 30                	js     47f <writetest+0x11c>
    printf(stdout, "open small succeeded ok\n");
     44f:	31 c0                	xor    %eax,%eax
     451:	48 c7 c6 71 31 00 00 	mov    $0x3171,%rsi
     458:	e8 cc 27 00 00       	callq  2c29 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     45d:	89 df                	mov    %ebx,%edi
     45f:	ba d0 07 00 00       	mov    $0x7d0,%edx
     464:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     46b:	e8 9e 26 00 00       	callq  2b0e <read>
  if(i == 2000){
     470:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     475:	8b 3d 0d 4a 00 00    	mov    0x4a0d(%rip),%edi        # 4e88 <stdout>
     47b:	74 0b                	je     488 <writetest+0x125>
     47d:	eb 3d                	jmp    4bc <writetest+0x159>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     47f:	48 c7 c6 8a 31 00 00 	mov    $0x318a,%rsi
     486:	eb 3b                	jmp    4c3 <writetest+0x160>
    exit();
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     488:	48 c7 c6 a5 31 00 00 	mov    $0x31a5,%rsi
     48f:	31 c0                	xor    %eax,%eax
     491:	e8 93 27 00 00       	callq  2c29 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     496:	89 df                	mov    %ebx,%edi
     498:	e8 81 26 00 00       	callq  2b1e <close>

  if(unlink("small") < 0){
     49d:	48 c7 c7 cb 30 00 00 	mov    $0x30cb,%rdi
     4a4:	e8 9d 26 00 00       	callq  2b46 <unlink>
     4a9:	85 c0                	test   %eax,%eax
     4ab:	8b 3d d7 49 00 00    	mov    0x49d7(%rip),%edi        # 4e88 <stdout>
     4b1:	79 1c                	jns    4cf <writetest+0x16c>
    printf(stdout, "unlink small failed\n");
     4b3:	48 c7 c6 b8 31 00 00 	mov    $0x31b8,%rsi
     4ba:	eb 07                	jmp    4c3 <writetest+0x160>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     4bc:	48 c7 c6 f6 35 00 00 	mov    $0x35f6,%rsi
    exit();
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     4c3:	31 c0                	xor    %eax,%eax
     4c5:	e8 5f 27 00 00       	callq  2c29 <printf>
     4ca:	e9 21 ff ff ff       	jmpq   3f0 <writetest+0x8d>
    exit();
  }
  printf(stdout, "small file test ok\n");
}
     4cf:	5b                   	pop    %rbx
     4d0:	41 5c                	pop    %r12
     4d2:	5d                   	pop    %rbp

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     4d3:	48 c7 c6 cd 31 00 00 	mov    $0x31cd,%rsi
     4da:	31 c0                	xor    %eax,%eax
     4dc:	e9 48 27 00 00       	jmpq   2c29 <printf>

00000000000004e1 <writetest1>:
}

void
writetest1(void)
{
     4e1:	55                   	push   %rbp
  int i, fd, n;

  printf(stdout, "big files test\n");
     4e2:	8b 3d a0 49 00 00    	mov    0x49a0(%rip),%edi        # 4e88 <stdout>
     4e8:	31 c0                	xor    %eax,%eax
     4ea:	48 c7 c6 e1 31 00 00 	mov    $0x31e1,%rsi
  printf(stdout, "small file test ok\n");
}

void
writetest1(void)
{
     4f1:	48 89 e5             	mov    %rsp,%rbp
     4f4:	41 54                	push   %r12
     4f6:	53                   	push   %rbx
  int i, fd, n;

  printf(stdout, "big files test\n");
     4f7:	e8 2d 27 00 00       	callq  2c29 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     4fc:	be 02 02 00 00       	mov    $0x202,%esi
     501:	48 c7 c7 5b 32 00 00 	mov    $0x325b,%rdi
     508:	e8 29 26 00 00       	callq  2b36 <open>
  if(fd < 0){
     50d:	85 c0                	test   %eax,%eax
    printf(stdout, "error: creat big failed!\n");
     50f:	48 c7 c6 f1 31 00 00 	mov    $0x31f1,%rsi
  int i, fd, n;

  printf(stdout, "big files test\n");

  fd = open("big", O_CREATE|O_RDWR);
  if(fd < 0){
     516:	78 71                	js     589 <writetest1+0xa8>
     518:	41 89 c4             	mov    %eax,%r12d
     51b:	31 db                	xor    %ebx,%ebx
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
    if(write(fd, buf, 512) != 512){
     51d:	ba 00 02 00 00       	mov    $0x200,%edx
     522:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     529:	44 89 e7             	mov    %r12d,%edi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
     52c:	89 1d ce 70 00 00    	mov    %ebx,0x70ce(%rip)        # 7600 <buf>
    if(write(fd, buf, 512) != 512){
     532:	e8 df 25 00 00       	callq  2b16 <write>
     537:	3d 00 02 00 00       	cmp    $0x200,%eax
     53c:	74 1b                	je     559 <writetest1+0x78>
      printf(stdout, "error: write big file failed\n", i);
     53e:	89 da                	mov    %ebx,%edx
     540:	48 c7 c6 0b 32 00 00 	mov    $0x320b,%rsi
     547:	8b 3d 3b 49 00 00    	mov    0x493b(%rip),%edi        # 4e88 <stdout>
     54d:	31 c0                	xor    %eax,%eax
     54f:	e8 d5 26 00 00       	callq  2c29 <printf>
      exit();
     554:	e8 9d 25 00 00       	callq  2af6 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     559:	ff c3                	inc    %ebx
     55b:	81 fb 8a 00 00 00    	cmp    $0x8a,%ebx
     561:	75 ba                	jne    51d <writetest1+0x3c>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     563:	44 89 e7             	mov    %r12d,%edi
     566:	31 db                	xor    %ebx,%ebx
     568:	e8 b1 25 00 00       	callq  2b1e <close>

  fd = open("big", O_RDONLY);
     56d:	31 f6                	xor    %esi,%esi
     56f:	48 c7 c7 5b 32 00 00 	mov    $0x325b,%rdi
     576:	e8 bb 25 00 00       	callq  2b36 <open>
  if(fd < 0){
     57b:	85 c0                	test   %eax,%eax
    }
  }

  close(fd);

  fd = open("big", O_RDONLY);
     57d:	41 89 c4             	mov    %eax,%r12d
  if(fd < 0){
     580:	79 14                	jns    596 <writetest1+0xb5>
    printf(stdout, "error: open big failed!\n");
     582:	48 c7 c6 29 32 00 00 	mov    $0x3229,%rsi
     589:	8b 3d f9 48 00 00    	mov    0x48f9(%rip),%edi        # 4e88 <stdout>
     58f:	e9 95 00 00 00       	jmpq   629 <writetest1+0x148>
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     594:	ff c3                	inc    %ebx
    exit();
  }

  n = 0;
  for(;;){
    i = read(fd, buf, 512);
     596:	ba 00 02 00 00       	mov    $0x200,%edx
     59b:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     5a2:	44 89 e7             	mov    %r12d,%edi
     5a5:	e8 64 25 00 00       	callq  2b0e <read>
    if(i == 0){
     5aa:	85 c0                	test   %eax,%eax
     5ac:	75 1c                	jne    5ca <writetest1+0xe9>
      if(n == MAXFILE - 1){
     5ae:	81 fb 89 00 00 00    	cmp    $0x89,%ebx
     5b4:	75 4e                	jne    604 <writetest1+0x123>
        printf(stdout, "read only %d blocks from big", n);
     5b6:	ba 89 00 00 00       	mov    $0x89,%edx
     5bb:	48 c7 c6 42 32 00 00 	mov    $0x3242,%rsi
     5c2:	8b 3d c0 48 00 00    	mov    0x48c0(%rip),%edi        # 4e88 <stdout>
     5c8:	eb 85                	jmp    54f <writetest1+0x6e>
        exit();
      }
      break;
    } else if(i != 512){
     5ca:	3d 00 02 00 00       	cmp    $0x200,%eax
     5cf:	74 0e                	je     5df <writetest1+0xfe>
      printf(stdout, "read failed %d\n", i);
     5d1:	89 c2                	mov    %eax,%edx
     5d3:	48 c7 c6 5f 32 00 00 	mov    $0x325f,%rsi
     5da:	e9 68 ff ff ff       	jmpq   547 <writetest1+0x66>
      exit();
    }
    if(((int*)buf)[0] != n){
     5df:	8b 0d 1b 70 00 00    	mov    0x701b(%rip),%ecx        # 7600 <buf>
     5e5:	39 cb                	cmp    %ecx,%ebx
     5e7:	74 ab                	je     594 <writetest1+0xb3>
      printf(stdout, "read content of block %d is %d\n",
     5e9:	8b 3d 99 48 00 00    	mov    0x4899(%rip),%edi        # 4e88 <stdout>
     5ef:	89 da                	mov    %ebx,%edx
     5f1:	48 c7 c6 6f 32 00 00 	mov    $0x326f,%rsi
     5f8:	31 c0                	xor    %eax,%eax
     5fa:	e8 2a 26 00 00       	callq  2c29 <printf>
     5ff:	e9 50 ff ff ff       	jmpq   554 <writetest1+0x73>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     604:	44 89 e7             	mov    %r12d,%edi
     607:	e8 12 25 00 00       	callq  2b1e <close>
  if(unlink("big") < 0){
     60c:	48 c7 c7 5b 32 00 00 	mov    $0x325b,%rdi
     613:	e8 2e 25 00 00       	callq  2b46 <unlink>
     618:	85 c0                	test   %eax,%eax
     61a:	8b 3d 68 48 00 00    	mov    0x4868(%rip),%edi        # 4e88 <stdout>
     620:	79 13                	jns    635 <writetest1+0x154>
    printf(stdout, "unlink big failed\n");
     622:	48 c7 c6 8f 32 00 00 	mov    $0x328f,%rsi
     629:	31 c0                	xor    %eax,%eax
     62b:	e8 f9 25 00 00       	callq  2c29 <printf>
     630:	e9 1f ff ff ff       	jmpq   554 <writetest1+0x73>
    exit();
  }
  printf(stdout, "big files ok\n");
}
     635:	5b                   	pop    %rbx
     636:	41 5c                	pop    %r12
     638:	5d                   	pop    %rbp
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     639:	48 c7 c6 a2 32 00 00 	mov    $0x32a2,%rsi
     640:	31 c0                	xor    %eax,%eax
     642:	e9 e2 25 00 00       	jmpq   2c29 <printf>

0000000000000647 <createtest>:
}

void
createtest(void)
{
     647:	55                   	push   %rbp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     648:	48 c7 c6 b0 32 00 00 	mov    $0x32b0,%rsi
     64f:	31 c0                	xor    %eax,%eax
  printf(stdout, "big files ok\n");
}

void
createtest(void)
{
     651:	48 89 e5             	mov    %rsp,%rbp
     654:	53                   	push   %rbx
     655:	51                   	push   %rcx
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     656:	8b 3d 2c 48 00 00    	mov    0x482c(%rip),%edi        # 4e88 <stdout>

  name[0] = 'a';
  name[2] = '\0';
     65c:	b3 30                	mov    $0x30,%bl
void
createtest(void)
{
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     65e:	e8 c6 25 00 00       	callq  2c29 <printf>

  name[0] = 'a';
     663:	c6 05 86 6f 00 00 61 	movb   $0x61,0x6f86(%rip)        # 75f0 <name>
  name[2] = '\0';
     66a:	c6 05 81 6f 00 00 00 	movb   $0x0,0x6f81(%rip)        # 75f2 <name+0x2>
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
     671:	be 02 02 00 00       	mov    $0x202,%esi
     676:	48 c7 c7 f0 75 00 00 	mov    $0x75f0,%rdi
  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     67d:	88 1d 6e 6f 00 00    	mov    %bl,0x6f6e(%rip)        # 75f1 <name+0x1>
    fd = open(name, O_CREATE|O_RDWR);
     683:	e8 ae 24 00 00       	callq  2b36 <open>
     688:	ff c3                	inc    %ebx
    close(fd);
     68a:	89 c7                	mov    %eax,%edi
     68c:	e8 8d 24 00 00       	callq  2b1e <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     691:	80 fb 64             	cmp    $0x64,%bl
     694:	75 db                	jne    671 <createtest+0x2a>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     696:	c6 05 53 6f 00 00 61 	movb   $0x61,0x6f53(%rip)        # 75f0 <name>
  name[2] = '\0';
     69d:	c6 05 4e 6f 00 00 00 	movb   $0x0,0x6f4e(%rip)        # 75f2 <name+0x2>
     6a4:	b3 30                	mov    $0x30,%bl
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     6a6:	88 1d 45 6f 00 00    	mov    %bl,0x6f45(%rip)        # 75f1 <name+0x1>
    unlink(name);
     6ac:	48 c7 c7 f0 75 00 00 	mov    $0x75f0,%rdi
     6b3:	ff c3                	inc    %ebx
     6b5:	e8 8c 24 00 00       	callq  2b46 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     6ba:	80 fb 64             	cmp    $0x64,%bl
     6bd:	75 e7                	jne    6a6 <createtest+0x5f>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     6bf:	8b 3d c3 47 00 00    	mov    0x47c3(%rip),%edi        # 4e88 <stdout>
     6c5:	48 c7 c6 d7 32 00 00 	mov    $0x32d7,%rsi
     6cc:	31 c0                	xor    %eax,%eax
}
     6ce:	5a                   	pop    %rdx
     6cf:	5b                   	pop    %rbx
     6d0:	5d                   	pop    %rbp
  name[2] = '\0';
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     6d1:	e9 53 25 00 00       	jmpq   2c29 <printf>

00000000000006d6 <dirtest>:
}

void dirtest(void)
{
     6d6:	55                   	push   %rbp
  printf(stdout, "mkdir test\n");
     6d7:	8b 3d ab 47 00 00    	mov    0x47ab(%rip),%edi        # 4e88 <stdout>
     6dd:	48 c7 c6 fd 32 00 00 	mov    $0x32fd,%rsi
     6e4:	31 c0                	xor    %eax,%eax
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
}

void dirtest(void)
{
     6e6:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "mkdir test\n");
     6e9:	e8 3b 25 00 00       	callq  2c29 <printf>

  if(mkdir("dir0") < 0){
     6ee:	48 c7 c7 09 33 00 00 	mov    $0x3309,%rdi
     6f5:	e8 64 24 00 00       	callq  2b5e <mkdir>
     6fa:	85 c0                	test   %eax,%eax
    printf(stdout, "mkdir failed\n");
     6fc:	48 c7 c6 60 2f 00 00 	mov    $0x2f60,%rsi

void dirtest(void)
{
  printf(stdout, "mkdir test\n");

  if(mkdir("dir0") < 0){
     703:	78 17                	js     71c <dirtest+0x46>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     705:	48 c7 c7 09 33 00 00 	mov    $0x3309,%rdi
     70c:	e8 55 24 00 00       	callq  2b66 <chdir>
     711:	85 c0                	test   %eax,%eax
     713:	79 19                	jns    72e <dirtest+0x58>
    printf(stdout, "chdir dir0 failed\n");
     715:	48 c7 c6 0e 33 00 00 	mov    $0x330e,%rsi
     71c:	8b 3d 66 47 00 00    	mov    0x4766(%rip),%edi        # 4e88 <stdout>
     722:	31 c0                	xor    %eax,%eax
     724:	e8 00 25 00 00       	callq  2c29 <printf>
    exit();
     729:	e8 c8 23 00 00       	callq  2af6 <exit>
  }

  if(chdir("..") < 0){
     72e:	48 c7 c7 4a 3a 00 00 	mov    $0x3a4a,%rdi
     735:	e8 2c 24 00 00       	callq  2b66 <chdir>
     73a:	85 c0                	test   %eax,%eax
    printf(stdout, "chdir .. failed\n");
     73c:	48 c7 c6 21 33 00 00 	mov    $0x3321,%rsi
  if(chdir("dir0") < 0){
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     743:	78 d7                	js     71c <dirtest+0x46>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     745:	48 c7 c7 09 33 00 00 	mov    $0x3309,%rdi
     74c:	e8 f5 23 00 00       	callq  2b46 <unlink>
     751:	85 c0                	test   %eax,%eax
    printf(stdout, "unlink dir0 failed\n");
     753:	48 c7 c6 32 33 00 00 	mov    $0x3332,%rsi
     75a:	8b 3d 28 47 00 00    	mov    0x4728(%rip),%edi        # 4e88 <stdout>
  if(chdir("..") < 0){
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     760:	78 c0                	js     722 <dirtest+0x4c>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
}
     762:	5d                   	pop    %rbp

  if(unlink("dir0") < 0){
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     763:	48 c7 c6 46 33 00 00 	mov    $0x3346,%rsi
     76a:	31 c0                	xor    %eax,%eax
     76c:	e9 b8 24 00 00       	jmpq   2c29 <printf>

0000000000000771 <exectest>:
}

void
exectest(void)
{
     771:	55                   	push   %rbp
  printf(stdout, "exec test\n");
     772:	8b 3d 10 47 00 00    	mov    0x4710(%rip),%edi        # 4e88 <stdout>
     778:	31 c0                	xor    %eax,%eax
     77a:	48 c7 c6 55 33 00 00 	mov    $0x3355,%rsi
  printf(stdout, "mkdir test ok\n");
}

void
exectest(void)
{
     781:	48 89 e5             	mov    %rsp,%rbp
  printf(stdout, "exec test\n");
     784:	e8 a0 24 00 00       	callq  2c29 <printf>
  if(exec("echo", echoargv) < 0){
     789:	48 c7 c6 a0 4e 00 00 	mov    $0x4ea0,%rsi
     790:	48 c7 c7 69 30 00 00 	mov    $0x3069,%rdi
     797:	e8 92 23 00 00       	callq  2b2e <exec>
     79c:	85 c0                	test   %eax,%eax
     79e:	79 19                	jns    7b9 <exectest+0x48>
    printf(stdout, "exec echo failed\n");
     7a0:	8b 3d e2 46 00 00    	mov    0x46e2(%rip),%edi        # 4e88 <stdout>
     7a6:	48 c7 c6 60 33 00 00 	mov    $0x3360,%rsi
     7ad:	31 c0                	xor    %eax,%eax
     7af:	e8 75 24 00 00       	callq  2c29 <printf>
    exit();
     7b4:	e8 3d 23 00 00       	callq  2af6 <exit>
  }
}
     7b9:	5d                   	pop    %rbp
     7ba:	c3                   	retq   

00000000000007bb <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     7bb:	55                   	push   %rbp
     7bc:	48 89 e5             	mov    %rsp,%rbp
     7bf:	41 56                	push   %r14
     7c1:	41 55                	push   %r13
     7c3:	41 54                	push   %r12
     7c5:	53                   	push   %rbx
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     7c6:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi

// simple fork and pipe read/write

void
pipe1(void)
{
     7ca:	48 83 ec 10          	sub    $0x10,%rsp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     7ce:	e8 33 23 00 00       	callq  2b06 <pipe>
     7d3:	85 c0                	test   %eax,%eax
    printf(1, "pipe() failed\n");
     7d5:	48 c7 c6 72 33 00 00 	mov    $0x3372,%rsi
pipe1(void)
{
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     7dc:	75 5c                	jne    83a <pipe1+0x7f>
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     7de:	e8 0b 23 00 00       	callq  2aee <fork>
  seq = 0;
  if(pid == 0){
     7e3:	83 f8 00             	cmp    $0x0,%eax
     7e6:	75 63                	jne    84b <pipe1+0x90>
    close(fds[0]);
     7e8:	8b 7d d8             	mov    -0x28(%rbp),%edi
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
  seq = 0;
     7eb:	31 db                	xor    %ebx,%ebx
  if(pid == 0){
    close(fds[0]);
     7ed:	e8 2c 23 00 00       	callq  2b1e <close>
     7f2:	eb 08                	jmp    7fc <pipe1+0x41>
    for(n = 0; n < 5; n++){
     7f4:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     7fa:	74 4a                	je     846 <pipe1+0x8b>

// simple fork and pipe read/write

void
pipe1(void)
{
     7fc:	31 c0                	xor    %eax,%eax
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
     7fe:	8d 14 03             	lea    (%rbx,%rax,1),%edx
     801:	88 90 00 76 00 00    	mov    %dl,0x7600(%rax)
     807:	48 ff c0             	inc    %rax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     80a:	48 3d 09 04 00 00    	cmp    $0x409,%rax
     810:	75 ec                	jne    7fe <pipe1+0x43>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     812:	8b 7d dc             	mov    -0x24(%rbp),%edi
     815:	ba 09 04 00 00       	mov    $0x409,%edx
     81a:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     821:	81 c3 09 04 00 00    	add    $0x409,%ebx
     827:	e8 ea 22 00 00       	callq  2b16 <write>
     82c:	3d 09 04 00 00       	cmp    $0x409,%eax
     831:	74 c1                	je     7f4 <pipe1+0x39>
        printf(1, "pipe1 oops 1\n");
     833:	48 c7 c6 81 33 00 00 	mov    $0x3381,%rsi
     83a:	bf 01 00 00 00       	mov    $0x1,%edi
     83f:	31 c0                	xor    %eax,%eax
     841:	e8 e3 23 00 00       	callq  2c29 <printf>
        exit();
     846:	e8 ab 22 00 00       	callq  2af6 <exit>
      }
    }
    exit();
  } else if(pid > 0){
     84b:	0f 8e b1 00 00 00    	jle    902 <pipe1+0x147>
    close(fds[1]);
     851:	8b 7d dc             	mov    -0x24(%rbp),%edi
    total = 0;
     854:	45 31 e4             	xor    %r12d,%r12d
    cc = 1;
     857:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
  seq = 0;
     85c:	45 31 ed             	xor    %r13d,%r13d
     85f:	41 be 00 20 00 00    	mov    $0x2000,%r14d
        exit();
      }
    }
    exit();
  } else if(pid > 0){
    close(fds[1]);
     865:	e8 b4 22 00 00       	callq  2b1e <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     86a:	8b 7d d8             	mov    -0x28(%rbp),%edi
     86d:	89 da                	mov    %ebx,%edx
     86f:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     876:	e8 93 22 00 00       	callq  2b0e <read>
     87b:	85 c0                	test   %eax,%eax
     87d:	7e 34                	jle    8b3 <pipe1+0xf8>
     87f:	44 89 e9             	mov    %r13d,%ecx
     882:	31 d2                	xor    %edx,%edx
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     884:	41 ff c5             	inc    %r13d
     887:	38 8a 00 76 00 00    	cmp    %cl,0x7600(%rdx)
     88d:	74 09                	je     898 <pipe1+0xdd>
          printf(1, "pipe1 oops 2\n");
     88f:	48 c7 c6 8f 33 00 00 	mov    $0x338f,%rsi
     896:	eb 53                	jmp    8eb <pipe1+0x130>
     898:	48 ff c2             	inc    %rdx
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     89b:	44 89 e9             	mov    %r13d,%ecx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     89e:	39 d0                	cmp    %edx,%eax
     8a0:	7f e2                	jg     884 <pipe1+0xc9>
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
      cc = cc * 2;
     8a2:	01 db                	add    %ebx,%ebx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     8a4:	41 01 c4             	add    %eax,%r12d
     8a7:	81 fb 00 20 00 00    	cmp    $0x2000,%ebx
     8ad:	41 0f 4f de          	cmovg  %r14d,%ebx
     8b1:	eb b7                	jmp    86a <pipe1+0xaf>
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     8b3:	41 81 fc 2d 14 00 00 	cmp    $0x142d,%r12d
     8ba:	74 1b                	je     8d7 <pipe1+0x11c>
      printf(1, "pipe1 oops 3 total %d\n", total);
     8bc:	44 89 e2             	mov    %r12d,%edx
     8bf:	48 c7 c6 9d 33 00 00 	mov    $0x339d,%rsi
     8c6:	bf 01 00 00 00       	mov    $0x1,%edi
     8cb:	31 c0                	xor    %eax,%eax
     8cd:	e8 57 23 00 00       	callq  2c29 <printf>
     8d2:	e9 6f ff ff ff       	jmpq   846 <pipe1+0x8b>
      exit();
    }
    close(fds[0]);
     8d7:	8b 7d d8             	mov    -0x28(%rbp),%edi
     8da:	e8 3f 22 00 00       	callq  2b1e <close>
    wait();
     8df:	e8 1a 22 00 00       	callq  2afe <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     8e4:	48 c7 c6 b4 33 00 00 	mov    $0x33b4,%rsi
     8eb:	31 c0                	xor    %eax,%eax
     8ed:	bf 01 00 00 00       	mov    $0x1,%edi
     8f2:	e8 32 23 00 00       	callq  2c29 <printf>
}
     8f7:	58                   	pop    %rax
     8f8:	5a                   	pop    %rdx
     8f9:	5b                   	pop    %rbx
     8fa:	41 5c                	pop    %r12
     8fc:	41 5d                	pop    %r13
     8fe:	41 5e                	pop    %r14
     900:	5d                   	pop    %rbp
     901:	c3                   	retq   
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     902:	48 c7 c6 be 33 00 00 	mov    $0x33be,%rsi
     909:	e9 2c ff ff ff       	jmpq   83a <pipe1+0x7f>

000000000000090e <preempt>:
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     90e:	55                   	push   %rbp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     90f:	31 c0                	xor    %eax,%eax
     911:	48 c7 c6 cd 33 00 00 	mov    $0x33cd,%rsi
     918:	bf 01 00 00 00       	mov    $0x1,%edi
}

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     91d:	48 89 e5             	mov    %rsp,%rbp
     920:	41 55                	push   %r13
     922:	41 54                	push   %r12
     924:	53                   	push   %rbx
     925:	48 83 ec 18          	sub    $0x18,%rsp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     929:	e8 fb 22 00 00       	callq  2c29 <printf>
  pid1 = fork();
     92e:	e8 bb 21 00 00       	callq  2aee <fork>
  if(pid1 == 0)
     933:	85 c0                	test   %eax,%eax
     935:	75 02                	jne    939 <preempt+0x2b>
     937:	eb fe                	jmp    937 <preempt+0x29>
     939:	41 89 c5             	mov    %eax,%r13d
    for(;;)
      ;

  pid2 = fork();
     93c:	e8 ad 21 00 00       	callq  2aee <fork>
  if(pid2 == 0)
     941:	85 c0                	test   %eax,%eax
  pid1 = fork();
  if(pid1 == 0)
    for(;;)
      ;

  pid2 = fork();
     943:	41 89 c4             	mov    %eax,%r12d
  if(pid2 == 0)
     946:	75 02                	jne    94a <preempt+0x3c>
     948:	eb fe                	jmp    948 <preempt+0x3a>
    for(;;)
      ;

  pipe(pfds);
     94a:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
     94e:	e8 b3 21 00 00       	callq  2b06 <pipe>
  pid3 = fork();
     953:	e8 96 21 00 00       	callq  2aee <fork>
  if(pid3 == 0){
     958:	85 c0                	test   %eax,%eax
  if(pid2 == 0)
    for(;;)
      ;

  pipe(pfds);
  pid3 = fork();
     95a:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     95c:	75 3d                	jne    99b <preempt+0x8d>
    close(pfds[0]);
     95e:	8b 7d d8             	mov    -0x28(%rbp),%edi
     961:	e8 b8 21 00 00       	callq  2b1e <close>
    if(write(pfds[1], "x", 1) != 1)
     966:	8b 7d dc             	mov    -0x24(%rbp),%edi
     969:	ba 01 00 00 00       	mov    $0x1,%edx
     96e:	48 c7 c6 53 3b 00 00 	mov    $0x3b53,%rsi
     975:	e8 9c 21 00 00       	callq  2b16 <write>
     97a:	ff c8                	dec    %eax
     97c:	74 13                	je     991 <preempt+0x83>
      printf(1, "preempt write error");
     97e:	48 c7 c6 d7 33 00 00 	mov    $0x33d7,%rsi
     985:	bf 01 00 00 00       	mov    $0x1,%edi
     98a:	31 c0                	xor    %eax,%eax
     98c:	e8 98 22 00 00       	callq  2c29 <printf>
    close(pfds[1]);
     991:	8b 7d dc             	mov    -0x24(%rbp),%edi
     994:	e8 85 21 00 00       	callq  2b1e <close>
     999:	eb fe                	jmp    999 <preempt+0x8b>
    for(;;)
      ;
  }

  close(pfds[1]);
     99b:	8b 7d dc             	mov    -0x24(%rbp),%edi
     99e:	e8 7b 21 00 00       	callq  2b1e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     9a3:	8b 7d d8             	mov    -0x28(%rbp),%edi
     9a6:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     9ad:	ba 00 20 00 00       	mov    $0x2000,%edx
     9b2:	e8 57 21 00 00       	callq  2b0e <read>
     9b7:	ff c8                	dec    %eax
    printf(1, "preempt read error");
     9b9:	48 c7 c6 eb 33 00 00 	mov    $0x33eb,%rsi
    for(;;)
      ;
  }

  close(pfds[1]);
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     9c0:	75 5b                	jne    a1d <preempt+0x10f>
    printf(1, "preempt read error");
    return;
  }
  close(pfds[0]);
     9c2:	8b 7d d8             	mov    -0x28(%rbp),%edi
     9c5:	e8 54 21 00 00       	callq  2b1e <close>
  printf(1, "kill... ");
     9ca:	48 c7 c6 fe 33 00 00 	mov    $0x33fe,%rsi
     9d1:	bf 01 00 00 00       	mov    $0x1,%edi
     9d6:	31 c0                	xor    %eax,%eax
     9d8:	e8 4c 22 00 00       	callq  2c29 <printf>
  kill(pid1);
     9dd:	44 89 ef             	mov    %r13d,%edi
     9e0:	e8 41 21 00 00       	callq  2b26 <kill>
  kill(pid2);
     9e5:	44 89 e7             	mov    %r12d,%edi
     9e8:	e8 39 21 00 00       	callq  2b26 <kill>
  kill(pid3);
     9ed:	89 df                	mov    %ebx,%edi
     9ef:	e8 32 21 00 00       	callq  2b26 <kill>
  printf(1, "wait... ");
     9f4:	48 c7 c6 07 34 00 00 	mov    $0x3407,%rsi
     9fb:	bf 01 00 00 00       	mov    $0x1,%edi
     a00:	31 c0                	xor    %eax,%eax
     a02:	e8 22 22 00 00       	callq  2c29 <printf>
  wait();
     a07:	e8 f2 20 00 00       	callq  2afe <wait>
  wait();
     a0c:	e8 ed 20 00 00       	callq  2afe <wait>
  wait();
     a11:	e8 e8 20 00 00       	callq  2afe <wait>
  printf(1, "preempt ok\n");
     a16:	48 c7 c6 10 34 00 00 	mov    $0x3410,%rsi
     a1d:	bf 01 00 00 00       	mov    $0x1,%edi
     a22:	31 c0                	xor    %eax,%eax
     a24:	e8 00 22 00 00       	callq  2c29 <printf>
}
     a29:	48 83 c4 18          	add    $0x18,%rsp
     a2d:	5b                   	pop    %rbx
     a2e:	41 5c                	pop    %r12
     a30:	41 5d                	pop    %r13
     a32:	5d                   	pop    %rbp
     a33:	c3                   	retq   

0000000000000a34 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     a34:	55                   	push   %rbp
     a35:	48 89 e5             	mov    %rsp,%rbp
     a38:	41 54                	push   %r12
     a3a:	53                   	push   %rbx
     a3b:	bb 64 00 00 00       	mov    $0x64,%ebx
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     a40:	e8 a9 20 00 00       	callq  2aee <fork>
    if(pid < 0){
     a45:	85 c0                	test   %eax,%eax
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     a47:	41 89 c4             	mov    %eax,%r12d
    if(pid < 0){
     a4a:	79 09                	jns    a55 <exitwait+0x21>
      printf(1, "fork failed\n");
     a4c:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
     a53:	eb 25                	jmp    a7a <exitwait+0x46>
      return;
    }
    if(pid){
     a55:	74 13                	je     a6a <exitwait+0x36>
      if(wait() != pid){
     a57:	e8 a2 20 00 00       	callq  2afe <wait>
     a5c:	41 39 c4             	cmp    %eax,%r12d
     a5f:	74 0e                	je     a6f <exitwait+0x3b>
        printf(1, "wait wrong pid\n");
     a61:	48 c7 c6 1c 34 00 00 	mov    $0x341c,%rsi
     a68:	eb 10                	jmp    a7a <exitwait+0x46>
        return;
      }
    } else {
      exit();
     a6a:	e8 87 20 00 00       	callq  2af6 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     a6f:	ff cb                	dec    %ebx
     a71:	75 cd                	jne    a40 <exitwait+0xc>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a73:	48 c7 c6 2c 34 00 00 	mov    $0x342c,%rsi
}
     a7a:	5b                   	pop    %rbx
     a7b:	41 5c                	pop    %r12
     a7d:	5d                   	pop    %rbp
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a7e:	bf 01 00 00 00       	mov    $0x1,%edi
     a83:	31 c0                	xor    %eax,%eax
     a85:	e9 9f 21 00 00       	jmpq   2c29 <printf>

0000000000000a8a <mem>:
}

void
mem(void)
{
     a8a:	55                   	push   %rbp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a8b:	48 c7 c6 39 34 00 00 	mov    $0x3439,%rsi
     a92:	bf 01 00 00 00       	mov    $0x1,%edi
     a97:	31 c0                	xor    %eax,%eax
  printf(1, "exitwait ok\n");
}

void
mem(void)
{
     a99:	48 89 e5             	mov    %rsp,%rbp
     a9c:	41 55                	push   %r13
     a9e:	41 54                	push   %r12
     aa0:	53                   	push   %rbx
     aa1:	52                   	push   %rdx
     aa2:	31 db                	xor    %ebx,%ebx
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     aa4:	e8 80 21 00 00       	callq  2c29 <printf>
  ppid = getpid();
     aa9:	e8 c8 20 00 00       	callq  2b76 <getpid>
     aae:	41 89 c4             	mov    %eax,%r12d
  if((pid = fork()) == 0){
     ab1:	e8 38 20 00 00       	callq  2aee <fork>
     ab6:	85 c0                	test   %eax,%eax
     ab8:	75 76                	jne    b30 <mem+0xa6>
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     aba:	bf 11 27 00 00       	mov    $0x2711,%edi
     abf:	e8 c7 23 00 00       	callq  2e8b <malloc>
     ac4:	48 85 c0             	test   %rax,%rax
     ac7:	74 08                	je     ad1 <mem+0x47>
      *(char**)m2 = m1;
     ac9:	48 89 18             	mov    %rbx,(%rax)
     acc:	48 89 c3             	mov    %rax,%rbx
     acf:	eb e9                	jmp    aba <mem+0x30>
      m1 = m2;
    }
    while(m1){
     ad1:	48 85 db             	test   %rbx,%rbx
     ad4:	74 10                	je     ae6 <mem+0x5c>
      m2 = *(char**)m1;
     ad6:	4c 8b 2b             	mov    (%rbx),%r13
      free(m1);
     ad9:	48 89 df             	mov    %rbx,%rdi
     adc:	e8 2e 23 00 00       	callq  2e0f <free>
      m1 = m2;
     ae1:	4c 89 eb             	mov    %r13,%rbx
     ae4:	eb eb                	jmp    ad1 <mem+0x47>
    }
    m1 = malloc(1024*20);
     ae6:	bf 00 50 00 00       	mov    $0x5000,%edi
     aeb:	e8 9b 23 00 00       	callq  2e8b <malloc>
    if(m1 == 0){
     af0:	48 85 c0             	test   %rax,%rax
     af3:	75 1b                	jne    b10 <mem+0x86>
      printf(1, "couldn't allocate mem?!!\n");
     af5:	48 c7 c6 43 34 00 00 	mov    $0x3443,%rsi
     afc:	bf 01 00 00 00       	mov    $0x1,%edi
     b01:	e8 23 21 00 00       	callq  2c29 <printf>
      kill(ppid);
     b06:	44 89 e7             	mov    %r12d,%edi
     b09:	e8 18 20 00 00       	callq  2b26 <kill>
     b0e:	eb 1b                	jmp    b2b <mem+0xa1>
      exit();
    }
    free(m1);
     b10:	48 89 c7             	mov    %rax,%rdi
     b13:	e8 f7 22 00 00       	callq  2e0f <free>
    printf(1, "mem ok\n");
     b18:	48 c7 c6 5d 34 00 00 	mov    $0x345d,%rsi
     b1f:	bf 01 00 00 00       	mov    $0x1,%edi
     b24:	31 c0                	xor    %eax,%eax
     b26:	e8 fe 20 00 00       	callq  2c29 <printf>
    exit();
     b2b:	e8 c6 1f 00 00       	callq  2af6 <exit>
  } else {
    wait();
  }
}
     b30:	58                   	pop    %rax
     b31:	5b                   	pop    %rbx
     b32:	41 5c                	pop    %r12
     b34:	41 5d                	pop    %r13
     b36:	5d                   	pop    %rbp
    }
    free(m1);
    printf(1, "mem ok\n");
    exit();
  } else {
    wait();
     b37:	e9 c2 1f 00 00       	jmpq   2afe <wait>

0000000000000b3c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b3c:	55                   	push   %rbp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b3d:	48 c7 c6 65 34 00 00 	mov    $0x3465,%rsi
     b44:	31 c0                	xor    %eax,%eax
     b46:	bf 01 00 00 00       	mov    $0x1,%edi

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b4b:	48 89 e5             	mov    %rsp,%rbp
     b4e:	41 55                	push   %r13
     b50:	41 54                	push   %r12
     b52:	53                   	push   %rbx
     b53:	48 83 ec 18          	sub    $0x18,%rsp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b57:	e8 cd 20 00 00       	callq  2c29 <printf>

  unlink("sharedfd");
     b5c:	48 c7 c7 74 34 00 00 	mov    $0x3474,%rdi
     b63:	e8 de 1f 00 00       	callq  2b46 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b68:	be 02 02 00 00       	mov    $0x202,%esi
     b6d:	48 c7 c7 74 34 00 00 	mov    $0x3474,%rdi
     b74:	e8 bd 1f 00 00       	callq  2b36 <open>
  if(fd < 0){
     b79:	85 c0                	test   %eax,%eax
    printf(1, "fstests: cannot open sharedfd for writing");
     b7b:	48 c7 c6 7d 34 00 00 	mov    $0x347d,%rsi

  printf(1, "sharedfd test\n");

  unlink("sharedfd");
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
     b82:	0f 88 f5 00 00 00    	js     c7d <sharedfd+0x141>
     b88:	89 c3                	mov    %eax,%ebx
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
     b8a:	41 bc e8 03 00 00    	mov    $0x3e8,%r12d
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     b90:	e8 59 1f 00 00       	callq  2aee <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     b95:	83 f8 01             	cmp    $0x1,%eax
     b98:	48 8d 7d d6          	lea    -0x2a(%rbp),%rdi
     b9c:	ba 0a 00 00 00       	mov    $0xa,%edx
     ba1:	19 f6                	sbb    %esi,%esi
  fd = open("sharedfd", O_CREATE|O_RDWR);
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     ba3:	41 89 c5             	mov    %eax,%r13d
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ba6:	83 e6 f3             	and    $0xfffffff3,%esi
     ba9:	83 c6 70             	add    $0x70,%esi
     bac:	e8 2e 1e 00 00       	callq  29df <memset>
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     bb1:	48 8d 75 d6          	lea    -0x2a(%rbp),%rsi
     bb5:	ba 0a 00 00 00       	mov    $0xa,%edx
     bba:	89 df                	mov    %ebx,%edi
     bbc:	e8 55 1f 00 00       	callq  2b16 <write>
     bc1:	83 f8 0a             	cmp    $0xa,%eax
     bc4:	74 15                	je     bdb <sharedfd+0x9f>
      printf(1, "fstests: write sharedfd failed\n");
     bc6:	48 c7 c6 a7 34 00 00 	mov    $0x34a7,%rsi
     bcd:	bf 01 00 00 00       	mov    $0x1,%edi
     bd2:	31 c0                	xor    %eax,%eax
     bd4:	e8 50 20 00 00       	callq  2c29 <printf>
      break;
     bd9:	eb 05                	jmp    be0 <sharedfd+0xa4>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     bdb:	41 ff cc             	dec    %r12d
     bde:	75 d1                	jne    bb1 <sharedfd+0x75>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     be0:	45 85 ed             	test   %r13d,%r13d
     be3:	0f 84 c3 00 00 00    	je     cac <sharedfd+0x170>
    exit();
  else
    wait();
     be9:	e8 10 1f 00 00       	callq  2afe <wait>
  close(fd);
     bee:	89 df                	mov    %ebx,%edi
     bf0:	e8 29 1f 00 00       	callq  2b1e <close>
  fd = open("sharedfd", 0);
     bf5:	31 f6                	xor    %esi,%esi
     bf7:	48 c7 c7 74 34 00 00 	mov    $0x3474,%rdi
     bfe:	e8 33 1f 00 00       	callq  2b36 <open>
  if(fd < 0){
     c03:	85 c0                	test   %eax,%eax
  if(pid == 0)
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
     c05:	41 89 c5             	mov    %eax,%r13d
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c08:	48 c7 c6 c7 34 00 00 	mov    $0x34c7,%rsi
    exit();
  else
    wait();
  close(fd);
  fd = open("sharedfd", 0);
  if(fd < 0){
     c0f:	78 6c                	js     c7d <sharedfd+0x141>
     c11:	45 31 e4             	xor    %r12d,%r12d
     c14:	31 db                	xor    %ebx,%ebx
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c16:	48 8d 75 d6          	lea    -0x2a(%rbp),%rsi
     c1a:	ba 0a 00 00 00       	mov    $0xa,%edx
     c1f:	44 89 ef             	mov    %r13d,%edi
     c22:	e8 e7 1e 00 00       	callq  2b0e <read>
     c27:	85 c0                	test   %eax,%eax
     c29:	7e 26                	jle    c51 <sharedfd+0x115>
     c2b:	31 c0                	xor    %eax,%eax
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
     c2d:	8a 54 05 d6          	mov    -0x2a(%rbp,%rax,1),%dl
     c31:	80 fa 63             	cmp    $0x63,%dl
     c34:	75 04                	jne    c3a <sharedfd+0xfe>
        nc++;
     c36:	ff c3                	inc    %ebx
     c38:	eb 0c                	jmp    c46 <sharedfd+0x10a>
      if(buf[i] == 'p')
        np++;
     c3a:	80 fa 70             	cmp    $0x70,%dl
     c3d:	0f 94 c2             	sete   %dl
     c40:	0f b6 d2             	movzbl %dl,%edx
     c43:	41 01 d4             	add    %edx,%r12d
     c46:	48 ff c0             	inc    %rax
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     c49:	48 83 f8 0a          	cmp    $0xa,%rax
     c4d:	75 de                	jne    c2d <sharedfd+0xf1>
     c4f:	eb c5                	jmp    c16 <sharedfd+0xda>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     c51:	44 89 ef             	mov    %r13d,%edi
     c54:	e8 c5 1e 00 00       	callq  2b1e <close>
  unlink("sharedfd");
     c59:	48 c7 c7 74 34 00 00 	mov    $0x3474,%rdi
     c60:	e8 e1 1e 00 00       	callq  2b46 <unlink>
  if(nc == 10000 && np == 10000){
     c65:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     c6b:	75 27                	jne    c94 <sharedfd+0x158>
     c6d:	41 81 fc 10 27 00 00 	cmp    $0x2710,%r12d
     c74:	75 1e                	jne    c94 <sharedfd+0x158>
    printf(1, "sharedfd ok\n");
     c76:	48 c7 c6 f2 34 00 00 	mov    $0x34f2,%rsi
     c7d:	bf 01 00 00 00       	mov    $0x1,%edi
     c82:	31 c0                	xor    %eax,%eax
     c84:	e8 a0 1f 00 00       	callq  2c29 <printf>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     c89:	48 83 c4 18          	add    $0x18,%rsp
     c8d:	5b                   	pop    %rbx
     c8e:	41 5c                	pop    %r12
     c90:	41 5d                	pop    %r13
     c92:	5d                   	pop    %rbp
     c93:	c3                   	retq   
  close(fd);
  unlink("sharedfd");
  if(nc == 10000 && np == 10000){
    printf(1, "sharedfd ok\n");
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     c94:	44 89 e1             	mov    %r12d,%ecx
     c97:	89 da                	mov    %ebx,%edx
     c99:	48 c7 c6 ff 34 00 00 	mov    $0x34ff,%rsi
     ca0:	bf 01 00 00 00       	mov    $0x1,%edi
     ca5:	31 c0                	xor    %eax,%eax
     ca7:	e8 7d 1f 00 00       	callq  2c29 <printf>
    exit();
     cac:	e8 45 1e 00 00       	callq  2af6 <exit>

0000000000000cb1 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     cb1:	55                   	push   %rbp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     cb2:	48 c7 c6 40 46 00 00 	mov    $0x4640,%rsi
     cb9:	b9 08 00 00 00       	mov    $0x8,%ecx
  char *fname;

  printf(1, "fourfiles test\n");
     cbe:	31 c0                	xor    %eax,%eax

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     cc0:	48 89 e5             	mov    %rsp,%rbp
     cc3:	41 57                	push   %r15
     cc5:	41 56                	push   %r14
     cc7:	41 55                	push   %r13
     cc9:	41 54                	push   %r12
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     ccb:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     ccf:	53                   	push   %rbx
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");
     cd0:	31 db                	xor    %ebx,%ebx

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     cd2:	48 83 ec 28          	sub    $0x28,%rsp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     cd6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  char *fname;

  printf(1, "fourfiles test\n");
     cd8:	48 c7 c6 14 35 00 00 	mov    $0x3514,%rsi
     cdf:	bf 01 00 00 00       	mov    $0x1,%edi
     ce4:	e8 40 1f 00 00       	callq  2c29 <printf>

  for(pi = 0; pi < 4; pi++){
    fname = names[pi];
     ce9:	4c 8b 6c dd b0       	mov    -0x50(%rbp,%rbx,8),%r13
    unlink(fname);
     cee:	4c 89 ef             	mov    %r13,%rdi
     cf1:	e8 50 1e 00 00       	callq  2b46 <unlink>

    pid = fork();
     cf6:	e8 f3 1d 00 00       	callq  2aee <fork>
    if(pid < 0){
     cfb:	85 c0                	test   %eax,%eax
     cfd:	79 09                	jns    d08 <fourfiles+0x57>
      printf(1, "fork failed\n");
     cff:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
     d06:	eb 1d                	jmp    d25 <fourfiles+0x74>
      exit();
    }

    if(pid == 0){
     d08:	75 74                	jne    d7e <fourfiles+0xcd>
      fd = open(fname, O_CREATE | O_RDWR);
     d0a:	4c 89 ef             	mov    %r13,%rdi
     d0d:	be 02 02 00 00       	mov    $0x202,%esi
     d12:	e8 1f 1e 00 00       	callq  2b36 <open>
      if(fd < 0){
     d17:	85 c0                	test   %eax,%eax
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      fd = open(fname, O_CREATE | O_RDWR);
     d19:	41 89 c5             	mov    %eax,%r13d
      if(fd < 0){
     d1c:	79 18                	jns    d36 <fourfiles+0x85>
        printf(1, "create failed\n");
     d1e:	48 c7 c6 71 38 00 00 	mov    $0x3871,%rsi
     d25:	bf 01 00 00 00       	mov    $0x1,%edi
     d2a:	31 c0                	xor    %eax,%eax
     d2c:	e8 f8 1e 00 00       	callq  2c29 <printf>
        exit();
     d31:	e8 c0 1d 00 00       	callq  2af6 <exit>
      }
      
      memset(buf, '0'+pi, 512);
     d36:	8d 73 30             	lea    0x30(%rbx),%esi
     d39:	ba 00 02 00 00       	mov    $0x200,%edx
     d3e:	48 c7 c7 00 76 00 00 	mov    $0x7600,%rdi
     d45:	bb 0c 00 00 00       	mov    $0xc,%ebx
     d4a:	e8 90 1c 00 00       	callq  29df <memset>
      for(i = 0; i < 12; i++){
        if((n = write(fd, buf, 500)) != 500){
     d4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
     d54:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     d5b:	44 89 ef             	mov    %r13d,%edi
     d5e:	e8 b3 1d 00 00       	callq  2b16 <write>
     d63:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     d68:	74 0e                	je     d78 <fourfiles+0xc7>
          printf(1, "write failed %d\n", n);
     d6a:	89 c2                	mov    %eax,%edx
     d6c:	48 c7 c6 24 35 00 00 	mov    $0x3524,%rsi
     d73:	e9 9d 00 00 00       	jmpq   e15 <fourfiles+0x164>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
     d78:	ff cb                	dec    %ebx
     d7a:	75 d3                	jne    d4f <fourfiles+0x9e>
     d7c:	eb b3                	jmp    d31 <fourfiles+0x80>
     d7e:	48 ff c3             	inc    %rbx
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
     d81:	48 83 fb 04          	cmp    $0x4,%rbx
     d85:	0f 85 5e ff ff ff    	jne    ce9 <fourfiles+0x38>
     d8b:	48 8d 5d b0          	lea    -0x50(%rbp),%rbx
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     d8f:	41 bc 30 00 00 00    	mov    $0x30,%r12d
     d95:	e8 64 1d 00 00       	callq  2afe <wait>
     d9a:	e8 5f 1d 00 00       	callq  2afe <wait>
     d9f:	e8 5a 1d 00 00       	callq  2afe <wait>
     da4:	e8 55 1d 00 00       	callq  2afe <wait>
  }

  for(i = 0; i < 2; i++){
    fname = names[i];
     da9:	4c 8b 33             	mov    (%rbx),%r14
    fd = open(fname, 0);
     dac:	31 f6                	xor    %esi,%esi
    total = 0;
     dae:	45 31 ed             	xor    %r13d,%r13d
    wait();
  }

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
     db1:	4c 89 f7             	mov    %r14,%rdi
     db4:	e8 7d 1d 00 00       	callq  2b36 <open>
     db9:	41 89 c7             	mov    %eax,%r15d
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     dbc:	ba 00 20 00 00       	mov    $0x2000,%edx
     dc1:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
     dc8:	44 89 ff             	mov    %r15d,%edi
     dcb:	e8 3e 1d 00 00       	callq  2b0e <read>
     dd0:	85 c0                	test   %eax,%eax
     dd2:	7e 26                	jle    dfa <fourfiles+0x149>
     dd4:	31 d2                	xor    %edx,%edx
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
     dd6:	0f be 8a 00 76 00 00 	movsbl 0x7600(%rdx),%ecx
     ddd:	44 39 e1             	cmp    %r12d,%ecx
     de0:	74 0c                	je     dee <fourfiles+0x13d>
          printf(1, "wrong char\n");
     de2:	48 c7 c6 35 35 00 00 	mov    $0x3535,%rsi
     de9:	e9 37 ff ff ff       	jmpq   d25 <fourfiles+0x74>
     dee:	48 ff c2             	inc    %rdx
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
     df1:	39 d0                	cmp    %edx,%eax
     df3:	7f e1                	jg     dd6 <fourfiles+0x125>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     df5:	41 01 c5             	add    %eax,%r13d
     df8:	eb c2                	jmp    dbc <fourfiles+0x10b>
    }
    close(fd);
     dfa:	44 89 ff             	mov    %r15d,%edi
     dfd:	e8 1c 1d 00 00       	callq  2b1e <close>
    if(total != 12*500){
     e02:	41 81 fd 70 17 00 00 	cmp    $0x1770,%r13d
     e09:	74 1b                	je     e26 <fourfiles+0x175>
      printf(1, "wrong length %d\n", total);
     e0b:	44 89 ea             	mov    %r13d,%edx
     e0e:	48 c7 c6 41 35 00 00 	mov    $0x3541,%rsi
     e15:	bf 01 00 00 00       	mov    $0x1,%edi
     e1a:	31 c0                	xor    %eax,%eax
     e1c:	e8 08 1e 00 00       	callq  2c29 <printf>
     e21:	e9 0b ff ff ff       	jmpq   d31 <fourfiles+0x80>
      exit();
    }
    unlink(fname);
     e26:	4c 89 f7             	mov    %r14,%rdi
     e29:	41 ff c4             	inc    %r12d
     e2c:	48 83 c3 08          	add    $0x8,%rbx
     e30:	e8 11 1d 00 00       	callq  2b46 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
     e35:	41 83 fc 32          	cmp    $0x32,%r12d
     e39:	0f 85 6a ff ff ff    	jne    da9 <fourfiles+0xf8>
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
}
     e3f:	48 83 c4 28          	add    $0x28,%rsp
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
     e43:	48 c7 c6 52 35 00 00 	mov    $0x3552,%rsi
     e4a:	bf 01 00 00 00       	mov    $0x1,%edi
}
     e4f:	5b                   	pop    %rbx
     e50:	41 5c                	pop    %r12
     e52:	41 5d                	pop    %r13
     e54:	41 5e                	pop    %r14
     e56:	41 5f                	pop    %r15
     e58:	5d                   	pop    %rbp
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
     e59:	31 c0                	xor    %eax,%eax
     e5b:	e9 c9 1d 00 00       	jmpq   2c29 <printf>

0000000000000e60 <createdelete>:
}

// four processes create and delete different files in same directory
void
createdelete(void)
{
     e60:	55                   	push   %rbp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
     e61:	48 c7 c6 66 35 00 00 	mov    $0x3566,%rsi
     e68:	bf 01 00 00 00       	mov    $0x1,%edi
     e6d:	31 c0                	xor    %eax,%eax
}

// four processes create and delete different files in same directory
void
createdelete(void)
{
     e6f:	48 89 e5             	mov    %rsp,%rbp
     e72:	41 56                	push   %r14
     e74:	41 55                	push   %r13
     e76:	41 54                	push   %r12
     e78:	53                   	push   %rbx
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
     e79:	31 db                	xor    %ebx,%ebx
}

// four processes create and delete different files in same directory
void
createdelete(void)
{
     e7b:	48 83 ec 20          	sub    $0x20,%rsp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
     e7f:	e8 a5 1d 00 00       	callq  2c29 <printf>

  for(pi = 0; pi < 4; pi++){
    pid = fork();
     e84:	e8 65 1c 00 00       	callq  2aee <fork>
    if(pid < 0){
     e89:	85 c0                	test   %eax,%eax
     e8b:	79 09                	jns    e96 <createdelete+0x36>
      printf(1, "fork failed\n");
     e8d:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
     e94:	eb 2d                	jmp    ec3 <createdelete+0x63>
      exit();
    }

    if(pid == 0){
     e96:	75 75                	jne    f0d <createdelete+0xad>
      name[0] = 'p' + pi;
     e98:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
     e9b:	c6 45 c2 00          	movb   $0x0,-0x3e(%rbp)
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      name[0] = 'p' + pi;
     e9f:	88 5d c0             	mov    %bl,-0x40(%rbp)
      name[2] = '\0';
      for(i = 0; i < N; i++){
     ea2:	31 db                	xor    %ebx,%ebx
        name[1] = '0' + i;
     ea4:	8d 43 30             	lea    0x30(%rbx),%eax
        fd = open(name, O_CREATE | O_RDWR);
     ea7:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
     eab:	be 02 02 00 00       	mov    $0x202,%esi

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
        name[1] = '0' + i;
     eb0:	88 45 c1             	mov    %al,-0x3f(%rbp)
        fd = open(name, O_CREATE | O_RDWR);
     eb3:	e8 7e 1c 00 00       	callq  2b36 <open>
        if(fd < 0){
     eb8:	85 c0                	test   %eax,%eax
     eba:	79 18                	jns    ed4 <createdelete+0x74>
          printf(1, "create failed\n");
     ebc:	48 c7 c6 71 38 00 00 	mov    $0x3871,%rsi
     ec3:	bf 01 00 00 00       	mov    $0x1,%edi
     ec8:	31 c0                	xor    %eax,%eax
     eca:	e8 5a 1d 00 00       	callq  2c29 <printf>
          exit();
     ecf:	e8 22 1c 00 00       	callq  2af6 <exit>
        }
        close(fd);
     ed4:	89 c7                	mov    %eax,%edi
     ed6:	e8 43 1c 00 00       	callq  2b1e <close>
        if(i > 0 && (i % 2 ) == 0){
     edb:	85 db                	test   %ebx,%ebx
     edd:	74 25                	je     f04 <createdelete+0xa4>
     edf:	f6 c3 01             	test   $0x1,%bl
     ee2:	75 20                	jne    f04 <createdelete+0xa4>
          name[1] = '0' + (i / 2);
     ee4:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
     ee6:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
          printf(1, "create failed\n");
          exit();
        }
        close(fd);
        if(i > 0 && (i % 2 ) == 0){
          name[1] = '0' + (i / 2);
     eea:	d1 f8                	sar    %eax
     eec:	83 c0 30             	add    $0x30,%eax
     eef:	88 45 c1             	mov    %al,-0x3f(%rbp)
          if(unlink(name) < 0){
     ef2:	e8 4f 1c 00 00       	callq  2b46 <unlink>
     ef7:	85 c0                	test   %eax,%eax
     ef9:	79 09                	jns    f04 <createdelete+0xa4>
            printf(1, "unlink failed\n");
     efb:	48 c7 c6 3d 30 00 00 	mov    $0x303d,%rsi
     f02:	eb bf                	jmp    ec3 <createdelete+0x63>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
     f04:	ff c3                	inc    %ebx
     f06:	83 fb 14             	cmp    $0x14,%ebx
     f09:	75 99                	jne    ea4 <createdelete+0x44>
     f0b:	eb c2                	jmp    ecf <createdelete+0x6f>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
     f0d:	ff c3                	inc    %ebx
     f0f:	83 fb 04             	cmp    $0x4,%ebx
     f12:	0f 85 6c ff ff ff    	jne    e84 <createdelete+0x24>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     f18:	e8 e1 1b 00 00       	callq  2afe <wait>
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
     f1d:	31 db                	xor    %ebx,%ebx
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     f1f:	e8 da 1b 00 00       	callq  2afe <wait>
     f24:	e8 d5 1b 00 00       	callq  2afe <wait>
     f29:	e8 d0 1b 00 00       	callq  2afe <wait>
  }

  name[0] = name[1] = name[2] = 0;
     f2e:	c6 45 c2 00          	movb   $0x0,-0x3e(%rbp)
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
     f32:	44 8d 73 30          	lea    0x30(%rbx),%r14d
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
     f36:	44 8d 6b ff          	lea    -0x1(%rbx),%r13d
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
     f3a:	41 b4 70             	mov    $0x70,%r12b
  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
     f3d:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
     f41:	31 f6                	xor    %esi,%esi
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
     f43:	44 88 65 c0          	mov    %r12b,-0x40(%rbp)
      name[1] = '0' + i;
     f47:	44 88 75 c1          	mov    %r14b,-0x3f(%rbp)
      fd = open(name, 0);
     f4b:	e8 e6 1b 00 00       	callq  2b36 <open>
      if((i == 0 || i >= N/2) && fd < 0){
     f50:	85 db                	test   %ebx,%ebx
     f52:	0f 94 c1             	sete   %cl
     f55:	83 fb 09             	cmp    $0x9,%ebx
     f58:	0f 9f c2             	setg   %dl
     f5b:	08 d1                	or     %dl,%cl
     f5d:	74 14                	je     f73 <createdelete+0x113>
     f5f:	89 c2                	mov    %eax,%edx
     f61:	c1 ea 1f             	shr    $0x1f,%edx
     f64:	74 0d                	je     f73 <createdelete+0x113>
        printf(1, "oops createdelete %s didn't exist\n", name);
     f66:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
     f6a:	48 c7 c6 79 35 00 00 	mov    $0x3579,%rsi
     f71:	eb 15                	jmp    f88 <createdelete+0x128>
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
     f73:	41 83 fd 08          	cmp    $0x8,%r13d
     f77:	77 20                	ja     f99 <createdelete+0x139>
     f79:	85 c0                	test   %eax,%eax
     f7b:	78 27                	js     fa4 <createdelete+0x144>
        printf(1, "oops createdelete %s did exist\n", name);
     f7d:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
     f81:	48 c7 c6 9c 35 00 00 	mov    $0x359c,%rsi
     f88:	bf 01 00 00 00       	mov    $0x1,%edi
     f8d:	31 c0                	xor    %eax,%eax
     f8f:	e8 95 1c 00 00       	callq  2c29 <printf>
     f94:	e9 36 ff ff ff       	jmpq   ecf <createdelete+0x6f>
        exit();
      }
      if(fd >= 0)
     f99:	85 c0                	test   %eax,%eax
     f9b:	78 07                	js     fa4 <createdelete+0x144>
        close(fd);
     f9d:	89 c7                	mov    %eax,%edi
     f9f:	e8 7a 1b 00 00       	callq  2b1e <close>
     fa4:	41 ff c4             	inc    %r12d
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
     fa7:	41 80 fc 74          	cmp    $0x74,%r12b
     fab:	75 90                	jne    f3d <createdelete+0xdd>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
     fad:	ff c3                	inc    %ebx
     faf:	83 fb 14             	cmp    $0x14,%ebx
     fb2:	0f 85 7a ff ff ff    	jne    f32 <createdelete+0xd2>
     fb8:	b3 70                	mov    $0x70,%bl
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
      name[1] = '0' + i;
     fba:	44 8d 6b c0          	lea    -0x40(%rbx),%r13d
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
     fbe:	41 bc 04 00 00 00    	mov    $0x4,%r12d

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
      name[1] = '0' + i;
      unlink(name);
     fc4:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
     fc8:	88 5d c0             	mov    %bl,-0x40(%rbp)
      name[1] = '0' + i;
     fcb:	44 88 6d c1          	mov    %r13b,-0x3f(%rbp)
      unlink(name);
     fcf:	e8 72 1b 00 00       	callq  2b46 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
     fd4:	41 ff cc             	dec    %r12d
     fd7:	75 eb                	jne    fc4 <createdelete+0x164>
     fd9:	ff c3                	inc    %ebx
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
     fdb:	80 fb 84             	cmp    $0x84,%bl
     fde:	75 da                	jne    fba <createdelete+0x15a>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
     fe0:	48 c7 c6 bc 35 00 00 	mov    $0x35bc,%rsi
     fe7:	bf 01 00 00 00       	mov    $0x1,%edi
     fec:	31 c0                	xor    %eax,%eax
     fee:	e8 36 1c 00 00       	callq  2c29 <printf>
}
     ff3:	48 83 c4 20          	add    $0x20,%rsp
     ff7:	5b                   	pop    %rbx
     ff8:	41 5c                	pop    %r12
     ffa:	41 5d                	pop    %r13
     ffc:	41 5e                	pop    %r14
     ffe:	5d                   	pop    %rbp
     fff:	c3                   	retq   

0000000000001000 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1000:	55                   	push   %rbp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1001:	31 c0                	xor    %eax,%eax
    1003:	48 c7 c6 cd 35 00 00 	mov    $0x35cd,%rsi
    100a:	bf 01 00 00 00       	mov    $0x1,%edi
}

// can I unlink a file and still read it?
void
unlinkread(void)
{
    100f:	48 89 e5             	mov    %rsp,%rbp
    1012:	41 54                	push   %r12
    1014:	53                   	push   %rbx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1015:	e8 0f 1c 00 00       	callq  2c29 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    101a:	be 02 02 00 00       	mov    $0x202,%esi
    101f:	48 c7 c7 de 35 00 00 	mov    $0x35de,%rdi
    1026:	e8 0b 1b 00 00       	callq  2b36 <open>
  if(fd < 0){
    102b:	85 c0                	test   %eax,%eax
    printf(1, "create unlinkread failed\n");
    102d:	48 c7 c6 e9 35 00 00 	mov    $0x35e9,%rsi
{
  int fd, fd1;

  printf(1, "unlinkread test\n");
  fd = open("unlinkread", O_CREATE | O_RDWR);
  if(fd < 0){
    1034:	78 3a                	js     1070 <unlinkread+0x70>
    1036:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1038:	ba 05 00 00 00       	mov    $0x5,%edx
    103d:	48 c7 c6 03 36 00 00 	mov    $0x3603,%rsi
    1044:	89 c7                	mov    %eax,%edi
    1046:	e8 cb 1a 00 00       	callq  2b16 <write>
  close(fd);
    104b:	89 df                	mov    %ebx,%edi
    104d:	e8 cc 1a 00 00       	callq  2b1e <close>

  fd = open("unlinkread", O_RDWR);
    1052:	be 02 00 00 00       	mov    $0x2,%esi
    1057:	48 c7 c7 de 35 00 00 	mov    $0x35de,%rdi
    105e:	e8 d3 1a 00 00       	callq  2b36 <open>
  if(fd < 0){
    1063:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "hello", 5);
  close(fd);

  fd = open("unlinkread", O_RDWR);
    1065:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1067:	79 18                	jns    1081 <unlinkread+0x81>
    printf(1, "open unlinkread failed\n");
    1069:	48 c7 c6 09 36 00 00 	mov    $0x3609,%rsi
    1070:	bf 01 00 00 00       	mov    $0x1,%edi
    1075:	31 c0                	xor    %eax,%eax
    1077:	e8 ad 1b 00 00       	callq  2c29 <printf>
    exit();
    107c:	e8 75 1a 00 00       	callq  2af6 <exit>
  }
  if(unlink("unlinkread") != 0){
    1081:	48 c7 c7 de 35 00 00 	mov    $0x35de,%rdi
    1088:	e8 b9 1a 00 00       	callq  2b46 <unlink>
    108d:	85 c0                	test   %eax,%eax
    printf(1, "unlink unlinkread failed\n");
    108f:	48 c7 c6 21 36 00 00 	mov    $0x3621,%rsi
  fd = open("unlinkread", O_RDWR);
  if(fd < 0){
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    1096:	75 d8                	jne    1070 <unlinkread+0x70>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1098:	be 02 02 00 00       	mov    $0x202,%esi
    109d:	48 c7 c7 de 35 00 00 	mov    $0x35de,%rdi
    10a4:	e8 8d 1a 00 00       	callq  2b36 <open>
  write(fd1, "yyy", 3);
    10a9:	ba 03 00 00 00       	mov    $0x3,%edx
    10ae:	48 c7 c6 3b 36 00 00 	mov    $0x363b,%rsi
  if(unlink("unlinkread") != 0){
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    10b5:	41 89 c4             	mov    %eax,%r12d
  write(fd1, "yyy", 3);
    10b8:	89 c7                	mov    %eax,%edi
    10ba:	e8 57 1a 00 00       	callq  2b16 <write>
  close(fd1);
    10bf:	44 89 e7             	mov    %r12d,%edi
    10c2:	e8 57 1a 00 00       	callq  2b1e <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    10c7:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    10ce:	ba 00 20 00 00       	mov    $0x2000,%edx
    10d3:	89 df                	mov    %ebx,%edi
    10d5:	e8 34 1a 00 00       	callq  2b0e <read>
    10da:	83 f8 05             	cmp    $0x5,%eax
    printf(1, "unlinkread read failed");
    10dd:	48 c7 c6 3f 36 00 00 	mov    $0x363f,%rsi

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
  write(fd1, "yyy", 3);
  close(fd1);

  if(read(fd, buf, sizeof(buf)) != 5){
    10e4:	75 8a                	jne    1070 <unlinkread+0x70>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    10e6:	80 3d 13 65 00 00 68 	cmpb   $0x68,0x6513(%rip)        # 7600 <buf>
    printf(1, "unlinkread wrong data\n");
    10ed:	48 c7 c6 56 36 00 00 	mov    $0x3656,%rsi

  if(read(fd, buf, sizeof(buf)) != 5){
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    10f4:	0f 85 76 ff ff ff    	jne    1070 <unlinkread+0x70>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    10fa:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1101:	ba 0a 00 00 00       	mov    $0xa,%edx
    1106:	89 df                	mov    %ebx,%edi
    1108:	e8 09 1a 00 00       	callq  2b16 <write>
    110d:	83 f8 0a             	cmp    $0xa,%eax
    printf(1, "unlinkread write failed\n");
    1110:	48 c7 c6 6d 36 00 00 	mov    $0x366d,%rsi
  }
  if(buf[0] != 'h'){
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    1117:	0f 85 53 ff ff ff    	jne    1070 <unlinkread+0x70>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    111d:	89 df                	mov    %ebx,%edi
    111f:	e8 fa 19 00 00       	callq  2b1e <close>
  unlink("unlinkread");
    1124:	48 c7 c7 de 35 00 00 	mov    $0x35de,%rdi
    112b:	e8 16 1a 00 00       	callq  2b46 <unlink>
  printf(1, "unlinkread ok\n");
}
    1130:	5b                   	pop    %rbx
    1131:	41 5c                	pop    %r12
    1133:	5d                   	pop    %rbp
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
  unlink("unlinkread");
  printf(1, "unlinkread ok\n");
    1134:	48 c7 c6 86 36 00 00 	mov    $0x3686,%rsi
    113b:	bf 01 00 00 00       	mov    $0x1,%edi
    1140:	31 c0                	xor    %eax,%eax
    1142:	e9 e2 1a 00 00       	jmpq   2c29 <printf>

0000000000001147 <linktest>:
}

void
linktest(void)
{
    1147:	55                   	push   %rbp
  int fd;

  printf(1, "linktest\n");
    1148:	48 c7 c6 95 36 00 00 	mov    $0x3695,%rsi
    114f:	31 c0                	xor    %eax,%eax
    1151:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "unlinkread ok\n");
}

void
linktest(void)
{
    1156:	48 89 e5             	mov    %rsp,%rbp
    1159:	53                   	push   %rbx
    115a:	51                   	push   %rcx
  int fd;

  printf(1, "linktest\n");
    115b:	e8 c9 1a 00 00       	callq  2c29 <printf>

  unlink("lf1");
    1160:	48 c7 c7 9f 36 00 00 	mov    $0x369f,%rdi
    1167:	e8 da 19 00 00       	callq  2b46 <unlink>
  unlink("lf2");
    116c:	48 c7 c7 a3 36 00 00 	mov    $0x36a3,%rdi
    1173:	e8 ce 19 00 00       	callq  2b46 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1178:	be 02 02 00 00       	mov    $0x202,%esi
    117d:	48 c7 c7 9f 36 00 00 	mov    $0x369f,%rdi
    1184:	e8 ad 19 00 00       	callq  2b36 <open>
  if(fd < 0){
    1189:	85 c0                	test   %eax,%eax
    printf(1, "create lf1 failed\n");
    118b:	48 c7 c6 a7 36 00 00 	mov    $0x36a7,%rsi

  unlink("lf1");
  unlink("lf2");

  fd = open("lf1", O_CREATE|O_RDWR);
  if(fd < 0){
    1192:	78 21                	js     11b5 <linktest+0x6e>
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    1194:	ba 05 00 00 00       	mov    $0x5,%edx
    1199:	48 c7 c6 03 36 00 00 	mov    $0x3603,%rsi
    11a0:	89 c7                	mov    %eax,%edi
    11a2:	89 c3                	mov    %eax,%ebx
    11a4:	e8 6d 19 00 00       	callq  2b16 <write>
    11a9:	83 f8 05             	cmp    $0x5,%eax
    11ac:	74 18                	je     11c6 <linktest+0x7f>
    printf(1, "write lf1 failed\n");
    11ae:	48 c7 c6 ba 36 00 00 	mov    $0x36ba,%rsi
    11b5:	bf 01 00 00 00       	mov    $0x1,%edi
    11ba:	31 c0                	xor    %eax,%eax
    11bc:	e8 68 1a 00 00       	callq  2c29 <printf>
    exit();
    11c1:	e8 30 19 00 00       	callq  2af6 <exit>
  }
  close(fd);
    11c6:	89 df                	mov    %ebx,%edi
    11c8:	e8 51 19 00 00       	callq  2b1e <close>

  if(link("lf1", "lf2") < 0){
    11cd:	48 c7 c6 a3 36 00 00 	mov    $0x36a3,%rsi
    11d4:	48 c7 c7 9f 36 00 00 	mov    $0x369f,%rdi
    11db:	e8 76 19 00 00       	callq  2b56 <link>
    11e0:	85 c0                	test   %eax,%eax
    printf(1, "link lf1 lf2 failed\n");
    11e2:	48 c7 c6 cc 36 00 00 	mov    $0x36cc,%rsi
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);

  if(link("lf1", "lf2") < 0){
    11e9:	78 ca                	js     11b5 <linktest+0x6e>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    11eb:	48 c7 c7 9f 36 00 00 	mov    $0x369f,%rdi
    11f2:	e8 4f 19 00 00       	callq  2b46 <unlink>

  if(open("lf1", 0) >= 0){
    11f7:	31 f6                	xor    %esi,%esi
    11f9:	48 c7 c7 9f 36 00 00 	mov    $0x369f,%rdi
    1200:	e8 31 19 00 00       	callq  2b36 <open>
    1205:	85 c0                	test   %eax,%eax
    printf(1, "unlinked lf1 but it is still there!\n");
    1207:	48 c7 c6 e1 36 00 00 	mov    $0x36e1,%rsi
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");

  if(open("lf1", 0) >= 0){
    120e:	79 a5                	jns    11b5 <linktest+0x6e>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1210:	31 f6                	xor    %esi,%esi
    1212:	48 c7 c7 a3 36 00 00 	mov    $0x36a3,%rdi
    1219:	e8 18 19 00 00       	callq  2b36 <open>
  if(fd < 0){
    121e:	85 c0                	test   %eax,%eax
  if(open("lf1", 0) >= 0){
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1220:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    1222:	48 c7 c6 06 37 00 00 	mov    $0x3706,%rsi
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
  if(fd < 0){
    1229:	78 8a                	js     11b5 <linktest+0x6e>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    122b:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1232:	ba 00 20 00 00       	mov    $0x2000,%edx
    1237:	89 c7                	mov    %eax,%edi
    1239:	e8 d0 18 00 00       	callq  2b0e <read>
    123e:	83 f8 05             	cmp    $0x5,%eax
    printf(1, "read lf2 failed\n");
    1241:	48 c7 c6 17 37 00 00 	mov    $0x3717,%rsi
  fd = open("lf2", 0);
  if(fd < 0){
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1248:	0f 85 67 ff ff ff    	jne    11b5 <linktest+0x6e>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    124e:	89 df                	mov    %ebx,%edi
    1250:	e8 c9 18 00 00       	callq  2b1e <close>

  if(link("lf2", "lf2") >= 0){
    1255:	48 c7 c6 a3 36 00 00 	mov    $0x36a3,%rsi
    125c:	48 89 f7             	mov    %rsi,%rdi
    125f:	e8 f2 18 00 00       	callq  2b56 <link>
    1264:	85 c0                	test   %eax,%eax
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1266:	48 c7 c6 28 37 00 00 	mov    $0x3728,%rsi
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);

  if(link("lf2", "lf2") >= 0){
    126d:	0f 89 42 ff ff ff    	jns    11b5 <linktest+0x6e>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    1273:	48 c7 c7 a3 36 00 00 	mov    $0x36a3,%rdi
    127a:	e8 c7 18 00 00       	callq  2b46 <unlink>
  if(link("lf2", "lf1") >= 0){
    127f:	48 c7 c6 9f 36 00 00 	mov    $0x369f,%rsi
    1286:	48 c7 c7 a3 36 00 00 	mov    $0x36a3,%rdi
    128d:	e8 c4 18 00 00       	callq  2b56 <link>
    1292:	85 c0                	test   %eax,%eax
    printf(1, "link non-existant succeeded! oops\n");
    1294:	48 c7 c6 46 37 00 00 	mov    $0x3746,%rsi
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
  if(link("lf2", "lf1") >= 0){
    129b:	0f 89 14 ff ff ff    	jns    11b5 <linktest+0x6e>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    12a1:	48 c7 c6 9f 36 00 00 	mov    $0x369f,%rsi
    12a8:	48 c7 c7 4b 3a 00 00 	mov    $0x3a4b,%rdi
    12af:	e8 a2 18 00 00       	callq  2b56 <link>
    12b4:	85 c0                	test   %eax,%eax
    printf(1, "link . lf1 succeeded! oops\n");
    12b6:	48 c7 c6 69 37 00 00 	mov    $0x3769,%rsi
  if(link("lf2", "lf1") >= 0){
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    12bd:	0f 89 f2 fe ff ff    	jns    11b5 <linktest+0x6e>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
}
    12c3:	5a                   	pop    %rdx
    12c4:	5b                   	pop    %rbx
    12c5:	5d                   	pop    %rbp
  if(link(".", "lf1") >= 0){
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    12c6:	48 c7 c6 85 37 00 00 	mov    $0x3785,%rsi
    12cd:	bf 01 00 00 00       	mov    $0x1,%edi
    12d2:	31 c0                	xor    %eax,%eax
    12d4:	e9 50 19 00 00       	jmpq   2c29 <printf>

00000000000012d9 <concreate>:
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    12d9:	55                   	push   %rbp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    12da:	48 c7 c6 92 37 00 00 	mov    $0x3792,%rsi
    12e1:	bf 01 00 00 00       	mov    $0x1,%edi
    12e6:	31 c0                	xor    %eax,%eax
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    12e8:	48 89 e5             	mov    %rsp,%rbp
    12eb:	41 55                	push   %r13
    12ed:	41 54                	push   %r12
    12ef:	53                   	push   %rbx
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    12f0:	31 db                	xor    %ebx,%ebx
}

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    12f2:	48 83 ec 48          	sub    $0x48,%rsp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    12f6:	e8 2e 19 00 00       	callq  2c29 <printf>
  file[0] = 'C';
    12fb:	c6 45 a5 43          	movb   $0x43,-0x5b(%rbp)
  file[2] = '\0';
    12ff:	c6 45 a7 00          	movb   $0x0,-0x59(%rbp)
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    1303:	8d 43 30             	lea    0x30(%rbx),%eax
    unlink(file);
    1306:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    130a:	88 45 a6             	mov    %al,-0x5a(%rbp)
    unlink(file);
    130d:	e8 34 18 00 00       	callq  2b46 <unlink>
    pid = fork();
    1312:	e8 d7 17 00 00       	callq  2aee <fork>
    if(pid && (i % 3) == 1){
    1317:	85 c0                	test   %eax,%eax
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    1319:	41 89 c4             	mov    %eax,%r12d
    if(pid && (i % 3) == 1){
    131c:	74 20                	je     133e <concreate+0x65>
    131e:	89 d8                	mov    %ebx,%eax
    1320:	b9 03 00 00 00       	mov    $0x3,%ecx
    1325:	99                   	cltd   
    1326:	f7 f9                	idiv   %ecx
    1328:	ff ca                	dec    %edx
    132a:	75 35                	jne    1361 <concreate+0x88>
      link("C0", file);
    132c:	48 8d 75 a5          	lea    -0x5b(%rbp),%rsi
    1330:	48 c7 c7 a2 37 00 00 	mov    $0x37a2,%rdi
    1337:	e8 1a 18 00 00       	callq  2b56 <link>
    133c:	eb 55                	jmp    1393 <concreate+0xba>
    } else if(pid == 0 && (i % 5) == 1){
    133e:	89 d8                	mov    %ebx,%eax
    1340:	b9 05 00 00 00       	mov    $0x5,%ecx
    1345:	99                   	cltd   
    1346:	f7 f9                	idiv   %ecx
    1348:	ff ca                	dec    %edx
    134a:	75 15                	jne    1361 <concreate+0x88>
      link("C0", file);
    134c:	48 8d 75 a5          	lea    -0x5b(%rbp),%rsi
    1350:	48 c7 c7 a2 37 00 00 	mov    $0x37a2,%rdi
    1357:	e8 fa 17 00 00       	callq  2b56 <link>
    135c:	e9 1a 01 00 00       	jmpq   147b <concreate+0x1a2>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1361:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    1365:	be 02 02 00 00       	mov    $0x202,%esi
    136a:	e8 c7 17 00 00       	callq  2b36 <open>
      if(fd < 0){
    136f:	85 c0                	test   %eax,%eax
    1371:	79 10                	jns    1383 <concreate+0xaa>
        printf(1, "concreate create %s failed\n", file);
    1373:	48 8d 55 a5          	lea    -0x5b(%rbp),%rdx
    1377:	48 c7 c6 a5 37 00 00 	mov    $0x37a5,%rsi
    137e:	e9 8f 00 00 00       	jmpq   1412 <concreate+0x139>
        exit();
      }
      close(fd);
    1383:	89 c7                	mov    %eax,%edi
    1385:	e8 94 17 00 00       	callq  2b1e <close>
    }
    if(pid == 0)
    138a:	45 85 e4             	test   %r12d,%r12d
    138d:	0f 84 e8 00 00 00    	je     147b <concreate+0x1a2>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1393:	ff c3                	inc    %ebx
      close(fd);
    }
    if(pid == 0)
      exit();
    else
      wait();
    1395:	e8 64 17 00 00       	callq  2afe <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    139a:	83 fb 28             	cmp    $0x28,%ebx
    139d:	0f 85 60 ff ff ff    	jne    1303 <concreate+0x2a>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    13a3:	48 8d 7d b8          	lea    -0x48(%rbp),%rdi
    13a7:	ba 28 00 00 00       	mov    $0x28,%edx
    13ac:	31 f6                	xor    %esi,%esi
  fd = open(".", 0);
  n = 0;
    13ae:	45 31 e4             	xor    %r12d,%r12d
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    13b1:	e8 29 16 00 00       	callq  29df <memset>
  fd = open(".", 0);
    13b6:	31 f6                	xor    %esi,%esi
    13b8:	48 c7 c7 4b 3a 00 00 	mov    $0x3a4b,%rdi
    13bf:	e8 72 17 00 00       	callq  2b36 <open>
    13c4:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    13c6:	eb 08                	jmp    13d0 <concreate+0xf7>
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    13c8:	c6 44 05 b8 01       	movb   $0x1,-0x48(%rbp,%rax,1)
      n++;
    13cd:	41 ff c4             	inc    %r12d
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    13d0:	48 8d 75 a8          	lea    -0x58(%rbp),%rsi
    13d4:	ba 10 00 00 00       	mov    $0x10,%edx
    13d9:	89 df                	mov    %ebx,%edi
    13db:	e8 2e 17 00 00       	callq  2b0e <read>
    13e0:	85 c0                	test   %eax,%eax
    13e2:	7e 56                	jle    143a <concreate+0x161>
    if(de.inum == 0)
    13e4:	66 83 7d a8 00       	cmpw   $0x0,-0x58(%rbp)
    13e9:	74 e5                	je     13d0 <concreate+0xf7>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    13eb:	80 7d aa 43          	cmpb   $0x43,-0x56(%rbp)
    13ef:	75 df                	jne    13d0 <concreate+0xf7>
    13f1:	80 7d ac 00          	cmpb   $0x0,-0x54(%rbp)
    13f5:	75 d9                	jne    13d0 <concreate+0xf7>
      i = de.name[1] - '0';
    13f7:	0f be 45 ab          	movsbl -0x55(%rbp),%eax
    13fb:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    13fe:	83 f8 27             	cmp    $0x27,%eax
    1401:	76 1d                	jbe    1420 <concreate+0x147>
        printf(1, "concreate weird file %s\n", de.name);
    1403:	48 8d 45 a8          	lea    -0x58(%rbp),%rax
    1407:	48 c7 c6 c1 37 00 00 	mov    $0x37c1,%rsi
    140e:	48 8d 50 02          	lea    0x2(%rax),%rdx
        exit();
      }
      if(fa[i]){
        printf(1, "concreate duplicate file %s\n", de.name);
    1412:	bf 01 00 00 00       	mov    $0x1,%edi
    1417:	31 c0                	xor    %eax,%eax
    1419:	e8 0b 18 00 00       	callq  2c29 <printf>
    141e:	eb 5b                	jmp    147b <concreate+0x1a2>
      i = de.name[1] - '0';
      if(i < 0 || i >= sizeof(fa)){
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1420:	48 98                	cltq   
    1422:	80 7c 05 b8 00       	cmpb   $0x0,-0x48(%rbp,%rax,1)
    1427:	74 9f                	je     13c8 <concreate+0xef>
        printf(1, "concreate duplicate file %s\n", de.name);
    1429:	48 8d 45 a8          	lea    -0x58(%rbp),%rax
    142d:	48 c7 c6 da 37 00 00 	mov    $0x37da,%rsi
    1434:	48 8d 50 02          	lea    0x2(%rax),%rdx
    1438:	eb d8                	jmp    1412 <concreate+0x139>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    143a:	89 df                	mov    %ebx,%edi
    143c:	31 db                	xor    %ebx,%ebx
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    143e:	41 bd 03 00 00 00    	mov    $0x3,%r13d
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1444:	e8 d5 16 00 00       	callq  2b1e <close>

  if(n != 40){
    1449:	41 83 fc 28          	cmp    $0x28,%r12d
    printf(1, "concreate not enough files in directory listing\n");
    144d:	48 c7 c6 f7 37 00 00 	mov    $0x37f7,%rsi
      n++;
    }
  }
  close(fd);

  if(n != 40){
    1454:	75 19                	jne    146f <concreate+0x196>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    1456:	8d 43 30             	lea    0x30(%rbx),%eax
    1459:	88 45 a6             	mov    %al,-0x5a(%rbp)
    pid = fork();
    145c:	e8 8d 16 00 00       	callq  2aee <fork>
    if(pid < 0){
    1461:	85 c0                	test   %eax,%eax
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    pid = fork();
    1463:	41 89 c4             	mov    %eax,%r12d
    if(pid < 0){
    1466:	79 18                	jns    1480 <concreate+0x1a7>
      printf(1, "fork failed\n");
    1468:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
    146f:	bf 01 00 00 00       	mov    $0x1,%edi
    1474:	31 c0                	xor    %eax,%eax
    1476:	e8 ae 17 00 00       	callq  2c29 <printf>
      exit();
    147b:	e8 76 16 00 00       	callq  2af6 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1480:	89 d8                	mov    %ebx,%eax
    1482:	99                   	cltd   
    1483:	41 f7 fd             	idiv   %r13d
    1486:	44 89 e0             	mov    %r12d,%eax
    1489:	09 d0                	or     %edx,%eax
    148b:	74 09                	je     1496 <concreate+0x1bd>
       ((i % 3) == 1 && pid != 0)){
    148d:	45 85 e4             	test   %r12d,%r12d
    1490:	74 4e                	je     14e0 <concreate+0x207>
    1492:	ff ca                	dec    %edx
    1494:	75 4a                	jne    14e0 <concreate+0x207>
      close(open(file, 0));
    1496:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    149a:	31 f6                	xor    %esi,%esi
    149c:	e8 95 16 00 00       	callq  2b36 <open>
    14a1:	89 c7                	mov    %eax,%edi
    14a3:	e8 76 16 00 00       	callq  2b1e <close>
      close(open(file, 0));
    14a8:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14ac:	31 f6                	xor    %esi,%esi
    14ae:	e8 83 16 00 00       	callq  2b36 <open>
    14b3:	89 c7                	mov    %eax,%edi
    14b5:	e8 64 16 00 00       	callq  2b1e <close>
      close(open(file, 0));
    14ba:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14be:	31 f6                	xor    %esi,%esi
    14c0:	e8 71 16 00 00       	callq  2b36 <open>
    14c5:	89 c7                	mov    %eax,%edi
    14c7:	e8 52 16 00 00       	callq  2b1e <close>
      close(open(file, 0));
    14cc:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14d0:	31 f6                	xor    %esi,%esi
    14d2:	e8 5f 16 00 00       	callq  2b36 <open>
    14d7:	89 c7                	mov    %eax,%edi
    14d9:	e8 40 16 00 00       	callq  2b1e <close>
    14de:	eb 24                	jmp    1504 <concreate+0x22b>
    } else {
      unlink(file);
    14e0:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14e4:	e8 5d 16 00 00       	callq  2b46 <unlink>
      unlink(file);
    14e9:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14ed:	e8 54 16 00 00       	callq  2b46 <unlink>
      unlink(file);
    14f2:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14f6:	e8 4b 16 00 00       	callq  2b46 <unlink>
      unlink(file);
    14fb:	48 8d 7d a5          	lea    -0x5b(%rbp),%rdi
    14ff:	e8 42 16 00 00       	callq  2b46 <unlink>
    }
    if(pid == 0)
    1504:	45 85 e4             	test   %r12d,%r12d
    1507:	0f 84 6e ff ff ff    	je     147b <concreate+0x1a2>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    150d:	ff c3                	inc    %ebx
      unlink(file);
    }
    if(pid == 0)
      exit();
    else
      wait();
    150f:	e8 ea 15 00 00       	callq  2afe <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1514:	83 fb 28             	cmp    $0x28,%ebx
    1517:	0f 85 39 ff ff ff    	jne    1456 <concreate+0x17d>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    151d:	48 c7 c6 28 38 00 00 	mov    $0x3828,%rsi
    1524:	bf 01 00 00 00       	mov    $0x1,%edi
    1529:	31 c0                	xor    %eax,%eax
    152b:	e8 f9 16 00 00       	callq  2c29 <printf>
}
    1530:	48 83 c4 48          	add    $0x48,%rsp
    1534:	5b                   	pop    %rbx
    1535:	41 5c                	pop    %r12
    1537:	41 5d                	pop    %r13
    1539:	5d                   	pop    %rbp
    153a:	c3                   	retq   

000000000000153b <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    153b:	55                   	push   %rbp
  int pid, i;

  printf(1, "linkunlink test\n");
    153c:	48 c7 c6 36 38 00 00 	mov    $0x3836,%rsi
    1543:	31 c0                	xor    %eax,%eax
    1545:	bf 01 00 00 00       	mov    $0x1,%edi

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    154a:	48 89 e5             	mov    %rsp,%rbp
    154d:	41 56                	push   %r14
    154f:	41 55                	push   %r13
    1551:	41 54                	push   %r12
    1553:	53                   	push   %rbx
  int pid, i;

  printf(1, "linkunlink test\n");
    1554:	e8 d0 16 00 00       	callq  2c29 <printf>

  unlink("x");
    1559:	48 c7 c7 53 3b 00 00 	mov    $0x3b53,%rdi
    1560:	e8 e1 15 00 00       	callq  2b46 <unlink>
  pid = fork();
    1565:	e8 84 15 00 00       	callq  2aee <fork>
  if(pid < 0){
    156a:	85 c0                	test   %eax,%eax
    156c:	79 18                	jns    1586 <linkunlink+0x4b>
    printf(1, "fork failed\n");
    156e:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
    1575:	bf 01 00 00 00       	mov    $0x1,%edi
    157a:	31 c0                	xor    %eax,%eax
    157c:	e8 a8 16 00 00       	callq  2c29 <printf>
    1581:	e9 99 00 00 00       	jmpq   161f <linkunlink+0xe4>
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    1586:	83 f8 01             	cmp    $0x1,%eax
    1589:	41 89 c4             	mov    %eax,%r12d
    158c:	41 bd 64 00 00 00    	mov    $0x64,%r13d
    1592:	19 db                	sbb    %ebx,%ebx
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    1594:	41 be 03 00 00 00    	mov    $0x3,%r14d
  if(pid < 0){
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    159a:	83 e3 60             	and    $0x60,%ebx
    159d:	ff c3                	inc    %ebx
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    159f:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    if((x % 3) == 0){
    15a5:	31 d2                	xor    %edx,%edx
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    15a7:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    15ad:	89 d8                	mov    %ebx,%eax
    15af:	41 f7 f6             	div    %r14d
    15b2:	85 d2                	test   %edx,%edx
    15b4:	75 1a                	jne    15d0 <linkunlink+0x95>
      close(open("x", O_RDWR | O_CREATE));
    15b6:	be 02 02 00 00       	mov    $0x202,%esi
    15bb:	48 c7 c7 53 3b 00 00 	mov    $0x3b53,%rdi
    15c2:	e8 6f 15 00 00       	callq  2b36 <open>
    15c7:	89 c7                	mov    %eax,%edi
    15c9:	e8 50 15 00 00       	callq  2b1e <close>
    15ce:	eb 25                	jmp    15f5 <linkunlink+0xba>
    } else if((x % 3) == 1){
    15d0:	ff ca                	dec    %edx
    15d2:	75 15                	jne    15e9 <linkunlink+0xae>
      link("cat", "x");
    15d4:	48 c7 c6 53 3b 00 00 	mov    $0x3b53,%rsi
    15db:	48 c7 c7 47 38 00 00 	mov    $0x3847,%rdi
    15e2:	e8 6f 15 00 00       	callq  2b56 <link>
    15e7:	eb 0c                	jmp    15f5 <linkunlink+0xba>
    } else {
      unlink("x");
    15e9:	48 c7 c7 53 3b 00 00 	mov    $0x3b53,%rdi
    15f0:	e8 51 15 00 00       	callq  2b46 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    15f5:	41 ff cd             	dec    %r13d
    15f8:	75 a5                	jne    159f <linkunlink+0x64>
    } else {
      unlink("x");
    }
  }

  if(pid)
    15fa:	45 85 e4             	test   %r12d,%r12d
    15fd:	74 20                	je     161f <linkunlink+0xe4>
    wait();
    15ff:	e8 fa 14 00 00       	callq  2afe <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
}
    1604:	5b                   	pop    %rbx
    1605:	41 5c                	pop    %r12
    1607:	41 5d                	pop    %r13
    1609:	41 5e                	pop    %r14
    160b:	5d                   	pop    %rbp
  if(pid)
    wait();
  else 
    exit();

  printf(1, "linkunlink ok\n");
    160c:	48 c7 c6 4b 38 00 00 	mov    $0x384b,%rsi
    1613:	bf 01 00 00 00       	mov    $0x1,%edi
    1618:	31 c0                	xor    %eax,%eax
    161a:	e9 0a 16 00 00       	jmpq   2c29 <printf>
  }

  if(pid)
    wait();
  else 
    exit();
    161f:	e8 d2 14 00 00       	callq  2af6 <exit>

0000000000001624 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1624:	55                   	push   %rbp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1625:	48 c7 c6 5a 38 00 00 	mov    $0x385a,%rsi
    162c:	31 c0                	xor    %eax,%eax
    162e:	bf 01 00 00 00       	mov    $0x1,%edi
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1633:	48 89 e5             	mov    %rsp,%rbp
    1636:	53                   	push   %rbx
    1637:	48 83 ec 18          	sub    $0x18,%rsp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    163b:	e8 e9 15 00 00       	callq  2c29 <printf>
  unlink("bd");
    1640:	48 c7 c7 67 38 00 00 	mov    $0x3867,%rdi
    1647:	e8 fa 14 00 00       	callq  2b46 <unlink>

  fd = open("bd", O_CREATE);
    164c:	be 00 02 00 00       	mov    $0x200,%esi
    1651:	48 c7 c7 67 38 00 00 	mov    $0x3867,%rdi
    1658:	e8 d9 14 00 00       	callq  2b36 <open>
  if(fd < 0){
    165d:	85 c0                	test   %eax,%eax
    printf(1, "bigdir create failed\n");
    165f:	48 c7 c6 6a 38 00 00 	mov    $0x386a,%rsi

  printf(1, "bigdir test\n");
  unlink("bd");

  fd = open("bd", O_CREATE);
  if(fd < 0){
    1666:	78 42                	js     16aa <bigdir+0x86>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    1668:	89 c7                	mov    %eax,%edi

  for(i = 0; i < 500; i++){
    166a:	31 db                	xor    %ebx,%ebx
  fd = open("bd", O_CREATE);
  if(fd < 0){
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    166c:	e8 ad 14 00 00       	callq  2b1e <close>

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1671:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    1673:	48 8d 75 e6          	lea    -0x1a(%rbp),%rsi
    1677:	48 c7 c7 67 38 00 00 	mov    $0x3867,%rdi
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    167e:	c1 f8 06             	sar    $0x6,%eax
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    1681:	c6 45 e6 78          	movb   $0x78,-0x1a(%rbp)
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    1685:	c6 45 e9 00          	movb   $0x0,-0x17(%rbp)
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    1689:	83 c0 30             	add    $0x30,%eax
    168c:	88 45 e7             	mov    %al,-0x19(%rbp)
    name[2] = '0' + (i % 64);
    168f:	89 d8                	mov    %ebx,%eax
    1691:	83 e0 3f             	and    $0x3f,%eax
    1694:	83 c0 30             	add    $0x30,%eax
    1697:	88 45 e8             	mov    %al,-0x18(%rbp)
    name[3] = '\0';
    if(link("bd", name) != 0){
    169a:	e8 b7 14 00 00       	callq  2b56 <link>
    169f:	85 c0                	test   %eax,%eax
    16a1:	74 18                	je     16bb <bigdir+0x97>
      printf(1, "bigdir link failed\n");
    16a3:	48 c7 c6 80 38 00 00 	mov    $0x3880,%rsi
    16aa:	bf 01 00 00 00       	mov    $0x1,%edi
    16af:	31 c0                	xor    %eax,%eax
    16b1:	e8 73 15 00 00       	callq  2c29 <printf>
      exit();
    16b6:	e8 3b 14 00 00       	callq  2af6 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    16bb:	ff c3                	inc    %ebx
    16bd:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    16c3:	75 ac                	jne    1671 <bigdir+0x4d>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    16c5:	48 c7 c7 67 38 00 00 	mov    $0x3867,%rdi
  for(i = 0; i < 500; i++){
    16cc:	31 db                	xor    %ebx,%ebx
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    16ce:	e8 73 14 00 00       	callq  2b46 <unlink>
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    16d3:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    16d5:	48 8d 7d e6          	lea    -0x1a(%rbp),%rdi
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    16d9:	c6 45 e6 78          	movb   $0x78,-0x1a(%rbp)
    name[1] = '0' + (i / 64);
    16dd:	c1 f8 06             	sar    $0x6,%eax
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    16e0:	c6 45 e9 00          	movb   $0x0,-0x17(%rbp)
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    16e4:	83 c0 30             	add    $0x30,%eax
    16e7:	88 45 e7             	mov    %al,-0x19(%rbp)
    name[2] = '0' + (i % 64);
    16ea:	89 d8                	mov    %ebx,%eax
    16ec:	83 e0 3f             	and    $0x3f,%eax
    16ef:	83 c0 30             	add    $0x30,%eax
    16f2:	88 45 e8             	mov    %al,-0x18(%rbp)
    name[3] = '\0';
    if(unlink(name) != 0){
    16f5:	e8 4c 14 00 00       	callq  2b46 <unlink>
    16fa:	85 c0                	test   %eax,%eax
    16fc:	74 09                	je     1707 <bigdir+0xe3>
      printf(1, "bigdir unlink failed");
    16fe:	48 c7 c6 94 38 00 00 	mov    $0x3894,%rsi
    1705:	eb a3                	jmp    16aa <bigdir+0x86>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1707:	ff c3                	inc    %ebx
    1709:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    170f:	75 c2                	jne    16d3 <bigdir+0xaf>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1711:	48 c7 c6 a9 38 00 00 	mov    $0x38a9,%rsi
    1718:	bf 01 00 00 00       	mov    $0x1,%edi
    171d:	31 c0                	xor    %eax,%eax
    171f:	e8 05 15 00 00       	callq  2c29 <printf>
}
    1724:	48 83 c4 18          	add    $0x18,%rsp
    1728:	5b                   	pop    %rbx
    1729:	5d                   	pop    %rbp
    172a:	c3                   	retq   

000000000000172b <subdir>:

void
subdir(void)
{
    172b:	55                   	push   %rbp
  int fd, cc;

  printf(1, "subdir test\n");
    172c:	48 c7 c6 b4 38 00 00 	mov    $0x38b4,%rsi
    1733:	31 c0                	xor    %eax,%eax
    1735:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "bigdir ok\n");
}

void
subdir(void)
{
    173a:	48 89 e5             	mov    %rsp,%rbp
    173d:	53                   	push   %rbx
    173e:	51                   	push   %rcx
  int fd, cc;

  printf(1, "subdir test\n");
    173f:	e8 e5 14 00 00       	callq  2c29 <printf>

  unlink("ff");
    1744:	48 c7 c7 63 39 00 00 	mov    $0x3963,%rdi
    174b:	e8 f6 13 00 00       	callq  2b46 <unlink>
  if(mkdir("dd") != 0){
    1750:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    1757:	e8 02 14 00 00       	callq  2b5e <mkdir>
    175c:	85 c0                	test   %eax,%eax
    printf(1, "subdir mkdir dd failed\n");
    175e:	48 c7 c6 c1 38 00 00 	mov    $0x38c1,%rsi
  int fd, cc;

  printf(1, "subdir test\n");

  unlink("ff");
  if(mkdir("dd") != 0){
    1765:	75 1e                	jne    1785 <subdir+0x5a>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1767:	be 02 02 00 00       	mov    $0x202,%esi
    176c:	48 c7 c7 39 39 00 00 	mov    $0x3939,%rdi
    1773:	e8 be 13 00 00       	callq  2b36 <open>
  if(fd < 0){
    1778:	85 c0                	test   %eax,%eax
  if(mkdir("dd") != 0){
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    177a:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    177c:	79 18                	jns    1796 <subdir+0x6b>
    printf(1, "create dd/ff failed\n");
    177e:	48 c7 c6 d9 38 00 00 	mov    $0x38d9,%rsi
    1785:	bf 01 00 00 00       	mov    $0x1,%edi
    178a:	31 c0                	xor    %eax,%eax
    178c:	e8 98 14 00 00       	callq  2c29 <printf>
    exit();
    1791:	e8 60 13 00 00       	callq  2af6 <exit>
  }
  write(fd, "ff", 2);
    1796:	48 c7 c6 63 39 00 00 	mov    $0x3963,%rsi
    179d:	ba 02 00 00 00       	mov    $0x2,%edx
    17a2:	89 c7                	mov    %eax,%edi
    17a4:	e8 6d 13 00 00       	callq  2b16 <write>
  close(fd);
    17a9:	89 df                	mov    %ebx,%edi
    17ab:	e8 6e 13 00 00       	callq  2b1e <close>
  
  if(unlink("dd") >= 0){
    17b0:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    17b7:	e8 8a 13 00 00       	callq  2b46 <unlink>
    17bc:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    17be:	48 c7 c6 ee 38 00 00 	mov    $0x38ee,%rsi
    exit();
  }
  write(fd, "ff", 2);
  close(fd);
  
  if(unlink("dd") >= 0){
    17c5:	79 be                	jns    1785 <subdir+0x5a>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    17c7:	48 c7 c7 14 39 00 00 	mov    $0x3914,%rdi
    17ce:	e8 8b 13 00 00       	callq  2b5e <mkdir>
    17d3:	85 c0                	test   %eax,%eax
    printf(1, "subdir mkdir dd/dd failed\n");
    17d5:	48 c7 c6 1b 39 00 00 	mov    $0x391b,%rsi
  if(unlink("dd") >= 0){
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    17dc:	75 a7                	jne    1785 <subdir+0x5a>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    17de:	be 02 02 00 00       	mov    $0x202,%esi
    17e3:	48 c7 c7 36 39 00 00 	mov    $0x3936,%rdi
    17ea:	e8 47 13 00 00       	callq  2b36 <open>
  if(fd < 0){
    17ef:	85 c0                	test   %eax,%eax
  if(mkdir("/dd/dd") != 0){
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    17f1:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    printf(1, "create dd/dd/ff failed\n");
    17f3:	48 c7 c6 3f 39 00 00 	mov    $0x393f,%rsi
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
  if(fd < 0){
    17fa:	78 89                	js     1785 <subdir+0x5a>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    17fc:	ba 02 00 00 00       	mov    $0x2,%edx
    1801:	48 c7 c6 57 39 00 00 	mov    $0x3957,%rsi
    1808:	89 c7                	mov    %eax,%edi
    180a:	e8 07 13 00 00       	callq  2b16 <write>
  close(fd);
    180f:	89 df                	mov    %ebx,%edi
    1811:	e8 08 13 00 00       	callq  2b1e <close>

  fd = open("dd/dd/../ff", 0);
    1816:	31 f6                	xor    %esi,%esi
    1818:	48 c7 c7 5a 39 00 00 	mov    $0x395a,%rdi
    181f:	e8 12 13 00 00       	callq  2b36 <open>
  if(fd < 0){
    1824:	85 c0                	test   %eax,%eax
    exit();
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
    1826:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    printf(1, "open dd/dd/../ff failed\n");
    1828:	48 c7 c6 66 39 00 00 	mov    $0x3966,%rsi
  }
  write(fd, "FF", 2);
  close(fd);

  fd = open("dd/dd/../ff", 0);
  if(fd < 0){
    182f:	0f 88 50 ff ff ff    	js     1785 <subdir+0x5a>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1835:	ba 00 20 00 00       	mov    $0x2000,%edx
    183a:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1841:	89 c7                	mov    %eax,%edi
    1843:	e8 c6 12 00 00       	callq  2b0e <read>
  if(cc != 2 || buf[0] != 'f'){
    1848:	83 f8 02             	cmp    $0x2,%eax
    184b:	75 09                	jne    1856 <subdir+0x12b>
    184d:	80 3d ac 5d 00 00 66 	cmpb   $0x66,0x5dac(%rip)        # 7600 <buf>
    1854:	74 0c                	je     1862 <subdir+0x137>
    printf(1, "dd/dd/../ff wrong content\n");
    1856:	48 c7 c6 7f 39 00 00 	mov    $0x397f,%rsi
    185d:	e9 23 ff ff ff       	jmpq   1785 <subdir+0x5a>
    exit();
  }
  close(fd);
    1862:	89 df                	mov    %ebx,%edi
    1864:	e8 b5 12 00 00       	callq  2b1e <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1869:	48 c7 c6 9a 39 00 00 	mov    $0x399a,%rsi
    1870:	48 c7 c7 36 39 00 00 	mov    $0x3936,%rdi
    1877:	e8 da 12 00 00       	callq  2b56 <link>
    187c:	85 c0                	test   %eax,%eax
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    187e:	48 c7 c6 a5 39 00 00 	mov    $0x39a5,%rsi
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1885:	0f 85 fa fe ff ff    	jne    1785 <subdir+0x5a>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    188b:	48 c7 c7 36 39 00 00 	mov    $0x3936,%rdi
    1892:	e8 af 12 00 00       	callq  2b46 <unlink>
    1897:	85 c0                	test   %eax,%eax
    1899:	74 0c                	je     18a7 <subdir+0x17c>
    printf(1, "unlink dd/dd/ff failed\n");
    189b:	48 c7 c6 c6 39 00 00 	mov    $0x39c6,%rsi
    18a2:	e9 de fe ff ff       	jmpq   1785 <subdir+0x5a>
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    18a7:	31 f6                	xor    %esi,%esi
    18a9:	48 c7 c7 36 39 00 00 	mov    $0x3936,%rdi
    18b0:	e8 81 12 00 00       	callq  2b36 <open>
    18b5:	85 c0                	test   %eax,%eax
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    18b7:	48 c7 c6 de 39 00 00 	mov    $0x39de,%rsi

  if(unlink("dd/dd/ff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    18be:	0f 89 c1 fe ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    18c4:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    18cb:	e8 96 12 00 00       	callq  2b66 <chdir>
    18d0:	85 c0                	test   %eax,%eax
    printf(1, "chdir dd failed\n");
    18d2:	48 c7 c6 02 3a 00 00 	mov    $0x3a02,%rsi
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    18d9:	0f 85 a6 fe ff ff    	jne    1785 <subdir+0x5a>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    18df:	48 c7 c7 13 3a 00 00 	mov    $0x3a13,%rdi
    18e6:	e8 7b 12 00 00       	callq  2b66 <chdir>
    18eb:	85 c0                	test   %eax,%eax
    18ed:	74 0c                	je     18fb <subdir+0x1d0>
    printf(1, "chdir dd/../../dd failed\n");
    18ef:	48 c7 c6 1f 3a 00 00 	mov    $0x3a1f,%rsi
    18f6:	e9 8a fe ff ff       	jmpq   1785 <subdir+0x5a>
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    18fb:	48 c7 c7 39 3a 00 00 	mov    $0x3a39,%rdi
    1902:	e8 5f 12 00 00       	callq  2b66 <chdir>
    1907:	85 c0                	test   %eax,%eax
    1909:	75 e4                	jne    18ef <subdir+0x1c4>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    190b:	48 c7 c7 48 3a 00 00 	mov    $0x3a48,%rdi
    1912:	e8 4f 12 00 00       	callq  2b66 <chdir>
    1917:	85 c0                	test   %eax,%eax
    printf(1, "chdir ./.. failed\n");
    1919:	48 c7 c6 4d 3a 00 00 	mov    $0x3a4d,%rsi
  }
  if(chdir("dd/../../../dd") != 0){
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1920:	0f 85 5f fe ff ff    	jne    1785 <subdir+0x5a>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1926:	31 f6                	xor    %esi,%esi
    1928:	48 c7 c7 9a 39 00 00 	mov    $0x399a,%rdi
    192f:	e8 02 12 00 00       	callq  2b36 <open>
  if(fd < 0){
    1934:	85 c0                	test   %eax,%eax
  if(chdir("./..") != 0){
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1936:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    1938:	48 c7 c6 60 3a 00 00 	mov    $0x3a60,%rsi
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    193f:	0f 88 40 fe ff ff    	js     1785 <subdir+0x5a>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1945:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    194c:	ba 00 20 00 00       	mov    $0x2000,%edx
    1951:	89 c7                	mov    %eax,%edi
    1953:	e8 b6 11 00 00       	callq  2b0e <read>
    1958:	83 f8 02             	cmp    $0x2,%eax
    printf(1, "read dd/dd/ffff wrong len\n");
    195b:	48 c7 c6 78 3a 00 00 	mov    $0x3a78,%rsi
  fd = open("dd/dd/ffff", 0);
  if(fd < 0){
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1962:	0f 85 1d fe ff ff    	jne    1785 <subdir+0x5a>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1968:	89 df                	mov    %ebx,%edi
    196a:	e8 af 11 00 00       	callq  2b1e <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    196f:	31 f6                	xor    %esi,%esi
    1971:	48 c7 c7 36 39 00 00 	mov    $0x3936,%rdi
    1978:	e8 b9 11 00 00       	callq  2b36 <open>
    197d:	85 c0                	test   %eax,%eax
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    197f:	48 c7 c6 93 3a 00 00 	mov    $0x3a93,%rsi
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1986:	0f 89 f9 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    198c:	be 02 02 00 00       	mov    $0x202,%esi
    1991:	48 c7 c7 b8 3a 00 00 	mov    $0x3ab8,%rdi
    1998:	e8 99 11 00 00       	callq  2b36 <open>
    199d:	85 c0                	test   %eax,%eax
    printf(1, "create dd/ff/ff succeeded!\n");
    199f:	48 c7 c6 c1 3a 00 00 	mov    $0x3ac1,%rsi
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    19a6:	0f 89 d9 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    19ac:	be 02 02 00 00       	mov    $0x202,%esi
    19b1:	48 c7 c7 dd 3a 00 00 	mov    $0x3add,%rdi
    19b8:	e8 79 11 00 00       	callq  2b36 <open>
    19bd:	85 c0                	test   %eax,%eax
    printf(1, "create dd/xx/ff succeeded!\n");
    19bf:	48 c7 c6 e6 3a 00 00 	mov    $0x3ae6,%rsi

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    19c6:	0f 89 b9 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    19cc:	be 00 02 00 00       	mov    $0x200,%esi
    19d1:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    19d8:	e8 59 11 00 00       	callq  2b36 <open>
    19dd:	85 c0                	test   %eax,%eax
    printf(1, "create dd succeeded!\n");
    19df:	48 c7 c6 02 3b 00 00 	mov    $0x3b02,%rsi
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    19e6:	0f 89 99 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    19ec:	be 02 00 00 00       	mov    $0x2,%esi
    19f1:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    19f8:	e8 39 11 00 00       	callq  2b36 <open>
    19fd:	85 c0                	test   %eax,%eax
    printf(1, "open dd rdwr succeeded!\n");
    19ff:	48 c7 c6 18 3b 00 00 	mov    $0x3b18,%rsi
  }
  if(open("dd", O_CREATE) >= 0){
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1a06:	0f 89 79 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1a0c:	be 01 00 00 00       	mov    $0x1,%esi
    1a11:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    1a18:	e8 19 11 00 00       	callq  2b36 <open>
    1a1d:	85 c0                	test   %eax,%eax
    printf(1, "open dd wronly succeeded!\n");
    1a1f:	48 c7 c6 31 3b 00 00 	mov    $0x3b31,%rsi
  }
  if(open("dd", O_RDWR) >= 0){
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1a26:	0f 89 59 fd ff ff    	jns    1785 <subdir+0x5a>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1a2c:	48 c7 c6 4c 3b 00 00 	mov    $0x3b4c,%rsi
    1a33:	48 c7 c7 b8 3a 00 00 	mov    $0x3ab8,%rdi
    1a3a:	e8 17 11 00 00       	callq  2b56 <link>
    1a3f:	85 c0                	test   %eax,%eax
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    1a41:	48 c7 c6 55 3b 00 00 	mov    $0x3b55,%rsi
  }
  if(open("dd", O_WRONLY) >= 0){
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1a48:	0f 84 3b 01 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1a4e:	48 c7 c6 4c 3b 00 00 	mov    $0x3b4c,%rsi
    1a55:	48 c7 c7 dd 3a 00 00 	mov    $0x3add,%rdi
    1a5c:	e8 f5 10 00 00       	callq  2b56 <link>
    1a61:	85 c0                	test   %eax,%eax
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    1a63:	48 c7 c6 78 3b 00 00 	mov    $0x3b78,%rsi
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1a6a:	0f 84 19 01 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1a70:	48 c7 c6 9a 39 00 00 	mov    $0x399a,%rsi
    1a77:	48 c7 c7 39 39 00 00 	mov    $0x3939,%rdi
    1a7e:	e8 d3 10 00 00       	callq  2b56 <link>
    1a83:	85 c0                	test   %eax,%eax
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1a85:	48 c7 c6 9b 3b 00 00 	mov    $0x3b9b,%rsi
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1a8c:	0f 84 f7 00 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1a92:	48 c7 c7 b8 3a 00 00 	mov    $0x3ab8,%rdi
    1a99:	e8 c0 10 00 00       	callq  2b5e <mkdir>
    1a9e:	85 c0                	test   %eax,%eax
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    1aa0:	48 c7 c6 bd 3b 00 00 	mov    $0x3bbd,%rsi
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1aa7:	0f 84 dc 00 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1aad:	48 c7 c7 dd 3a 00 00 	mov    $0x3add,%rdi
    1ab4:	e8 a5 10 00 00       	callq  2b5e <mkdir>
    1ab9:	85 c0                	test   %eax,%eax
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    1abb:	48 c7 c6 d8 3b 00 00 	mov    $0x3bd8,%rsi
  }
  if(mkdir("dd/ff/ff") == 0){
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1ac2:	0f 84 c1 00 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1ac8:	48 c7 c7 9a 39 00 00 	mov    $0x399a,%rdi
    1acf:	e8 8a 10 00 00       	callq  2b5e <mkdir>
    1ad4:	85 c0                	test   %eax,%eax
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    1ad6:	48 c7 c6 f3 3b 00 00 	mov    $0x3bf3,%rsi
  }
  if(mkdir("dd/xx/ff") == 0){
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1add:	0f 84 a6 00 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1ae3:	48 c7 c7 dd 3a 00 00 	mov    $0x3add,%rdi
    1aea:	e8 57 10 00 00       	callq  2b46 <unlink>
    1aef:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd/xx/ff succeeded!\n");
    1af1:	48 c7 c6 10 3c 00 00 	mov    $0x3c10,%rsi
  }
  if(mkdir("dd/dd/ffff") == 0){
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1af8:	0f 84 8b 00 00 00    	je     1b89 <subdir+0x45e>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1afe:	48 c7 c7 b8 3a 00 00 	mov    $0x3ab8,%rdi
    1b05:	e8 3c 10 00 00       	callq  2b46 <unlink>
    1b0a:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd/ff/ff succeeded!\n");
    1b0c:	48 c7 c6 2c 3c 00 00 	mov    $0x3c2c,%rsi
  }
  if(unlink("dd/xx/ff") == 0){
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1b13:	74 74                	je     1b89 <subdir+0x45e>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1b15:	48 c7 c7 39 39 00 00 	mov    $0x3939,%rdi
    1b1c:	e8 45 10 00 00       	callq  2b66 <chdir>
    1b21:	85 c0                	test   %eax,%eax
    printf(1, "chdir dd/ff succeeded!\n");
    1b23:	48 c7 c6 48 3c 00 00 	mov    $0x3c48,%rsi
  }
  if(unlink("dd/ff/ff") == 0){
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1b2a:	74 5d                	je     1b89 <subdir+0x45e>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1b2c:	48 c7 c7 4f 3b 00 00 	mov    $0x3b4f,%rdi
    1b33:	e8 2e 10 00 00       	callq  2b66 <chdir>
    1b38:	85 c0                	test   %eax,%eax
    printf(1, "chdir dd/xx succeeded!\n");
    1b3a:	48 c7 c6 60 3c 00 00 	mov    $0x3c60,%rsi
  }
  if(chdir("dd/ff") == 0){
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1b41:	74 46                	je     1b89 <subdir+0x45e>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1b43:	48 c7 c7 9a 39 00 00 	mov    $0x399a,%rdi
    1b4a:	e8 f7 0f 00 00       	callq  2b46 <unlink>
    1b4f:	85 c0                	test   %eax,%eax
    1b51:	0f 85 44 fd ff ff    	jne    189b <subdir+0x170>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1b57:	48 c7 c7 39 39 00 00 	mov    $0x3939,%rdi
    1b5e:	e8 e3 0f 00 00       	callq  2b46 <unlink>
    1b63:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd/ff failed\n");
    1b65:	48 c7 c6 78 3c 00 00 	mov    $0x3c78,%rsi

  if(unlink("dd/dd/ffff") != 0){
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1b6c:	0f 85 13 fc ff ff    	jne    1785 <subdir+0x5a>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1b72:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    1b79:	e8 c8 0f 00 00       	callq  2b46 <unlink>
    1b7e:	85 c0                	test   %eax,%eax
    1b80:	75 11                	jne    1b93 <subdir+0x468>
    printf(1, "unlink non-empty dd succeeded!\n");
    1b82:	48 c7 c6 8d 3c 00 00 	mov    $0x3c8d,%rsi
    1b89:	bf 01 00 00 00       	mov    $0x1,%edi
    1b8e:	e9 f9 fb ff ff       	jmpq   178c <subdir+0x61>
    exit();
  }
  if(unlink("dd/dd") < 0){
    1b93:	48 c7 c7 15 39 00 00 	mov    $0x3915,%rdi
    1b9a:	e8 a7 0f 00 00       	callq  2b46 <unlink>
    1b9f:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd/dd failed\n");
    1ba1:	48 c7 c6 ad 3c 00 00 	mov    $0x3cad,%rsi
  }
  if(unlink("dd") == 0){
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1ba8:	0f 88 d7 fb ff ff    	js     1785 <subdir+0x5a>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1bae:	48 c7 c7 45 3a 00 00 	mov    $0x3a45,%rdi
    1bb5:	e8 8c 0f 00 00       	callq  2b46 <unlink>
    1bba:	85 c0                	test   %eax,%eax
    printf(1, "unlink dd failed\n");
    1bbc:	48 c7 c6 c2 3c 00 00 	mov    $0x3cc2,%rsi
  }
  if(unlink("dd/dd") < 0){
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1bc3:	0f 88 bc fb ff ff    	js     1785 <subdir+0x5a>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
}
    1bc9:	5a                   	pop    %rdx
    1bca:	5b                   	pop    %rbx
    1bcb:	5d                   	pop    %rbp
  if(unlink("dd") < 0){
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1bcc:	48 c7 c6 d4 3c 00 00 	mov    $0x3cd4,%rsi
    1bd3:	bf 01 00 00 00       	mov    $0x1,%edi
    1bd8:	31 c0                	xor    %eax,%eax
    1bda:	e9 4a 10 00 00       	jmpq   2c29 <printf>

0000000000001bdf <bigwrite>:
}

// test writes that are larger than the log.
void
bigwrite(void)
{
    1bdf:	55                   	push   %rbp
  int fd, sz;

  printf(1, "bigwrite test\n");
    1be0:	48 c7 c6 df 3c 00 00 	mov    $0x3cdf,%rsi
    1be7:	bf 01 00 00 00       	mov    $0x1,%edi
    1bec:	31 c0                	xor    %eax,%eax
}

// test writes that are larger than the log.
void
bigwrite(void)
{
    1bee:	48 89 e5             	mov    %rsp,%rbp
    1bf1:	41 54                	push   %r12
    1bf3:	53                   	push   %rbx
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    1bf4:	bb f3 01 00 00       	mov    $0x1f3,%ebx
void
bigwrite(void)
{
  int fd, sz;

  printf(1, "bigwrite test\n");
    1bf9:	e8 2b 10 00 00       	callq  2c29 <printf>

  unlink("bigwrite");
    1bfe:	48 c7 c7 ee 3c 00 00 	mov    $0x3cee,%rdi
    1c05:	e8 3c 0f 00 00       	callq  2b46 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
    1c0a:	be 02 02 00 00       	mov    $0x202,%esi
    1c0f:	48 c7 c7 ee 3c 00 00 	mov    $0x3cee,%rdi
    1c16:	e8 1b 0f 00 00       	callq  2b36 <open>
    if(fd < 0){
    1c1b:	85 c0                	test   %eax,%eax

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
    1c1d:	41 89 c4             	mov    %eax,%r12d
    if(fd < 0){
    1c20:	78 2b                	js     1c4d <bigwrite+0x6e>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    1c22:	89 da                	mov    %ebx,%edx
    1c24:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1c2b:	89 c7                	mov    %eax,%edi
    1c2d:	e8 e4 0e 00 00       	callq  2b16 <write>
      if(cc != sz){
    1c32:	39 c3                	cmp    %eax,%ebx
    1c34:	75 2c                	jne    1c62 <bigwrite+0x83>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    1c36:	89 da                	mov    %ebx,%edx
    1c38:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1c3f:	44 89 e7             	mov    %r12d,%edi
    1c42:	e8 cf 0e 00 00       	callq  2b16 <write>
      if(cc != sz){
    1c47:	39 c3                	cmp    %eax,%ebx
    1c49:	74 33                	je     1c7e <bigwrite+0x9f>
    1c4b:	eb 15                	jmp    1c62 <bigwrite+0x83>

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    1c4d:	48 c7 c6 f7 3c 00 00 	mov    $0x3cf7,%rsi
    1c54:	bf 01 00 00 00       	mov    $0x1,%edi
    1c59:	31 c0                	xor    %eax,%eax
    1c5b:	e8 c9 0f 00 00       	callq  2c29 <printf>
    1c60:	eb 17                	jmp    1c79 <bigwrite+0x9a>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    1c62:	89 c1                	mov    %eax,%ecx
    1c64:	89 da                	mov    %ebx,%edx
    1c66:	48 c7 c6 0f 3d 00 00 	mov    $0x3d0f,%rsi
    1c6d:	bf 01 00 00 00       	mov    $0x1,%edi
    1c72:	31 c0                	xor    %eax,%eax
    1c74:	e8 b0 0f 00 00       	callq  2c29 <printf>
        exit();
    1c79:	e8 78 0e 00 00       	callq  2af6 <exit>
      }
    }
    close(fd);
    1c7e:	44 89 e7             	mov    %r12d,%edi
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    1c81:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    1c87:	e8 92 0e 00 00       	callq  2b1e <close>
    unlink("bigwrite");
    1c8c:	48 c7 c7 ee 3c 00 00 	mov    $0x3cee,%rdi
    1c93:	e8 ae 0e 00 00       	callq  2b46 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    1c98:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    1c9e:	0f 85 66 ff ff ff    	jne    1c0a <bigwrite+0x2b>
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
}
    1ca4:	5b                   	pop    %rbx
    1ca5:	41 5c                	pop    %r12
    1ca7:	5d                   	pop    %rbp
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    1ca8:	48 c7 c6 21 3d 00 00 	mov    $0x3d21,%rsi
    1caf:	bf 01 00 00 00       	mov    $0x1,%edi
    1cb4:	31 c0                	xor    %eax,%eax
    1cb6:	e9 6e 0f 00 00       	jmpq   2c29 <printf>

0000000000001cbb <bigfile>:
}

void
bigfile(void)
{
    1cbb:	55                   	push   %rbp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    1cbc:	48 c7 c6 2e 3d 00 00 	mov    $0x3d2e,%rsi
    1cc3:	31 c0                	xor    %eax,%eax
    1cc5:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "bigwrite ok\n");
}

void
bigfile(void)
{
    1cca:	48 89 e5             	mov    %rsp,%rbp
    1ccd:	41 55                	push   %r13
    1ccf:	41 54                	push   %r12
    1cd1:	53                   	push   %rbx
    1cd2:	51                   	push   %rcx
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    1cd3:	e8 51 0f 00 00       	callq  2c29 <printf>

  unlink("bigfile");
    1cd8:	48 c7 c7 4a 3d 00 00 	mov    $0x3d4a,%rdi
    1cdf:	e8 62 0e 00 00       	callq  2b46 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    1ce4:	be 02 02 00 00       	mov    $0x202,%esi
    1ce9:	48 c7 c7 4a 3d 00 00 	mov    $0x3d4a,%rdi
    1cf0:	e8 41 0e 00 00       	callq  2b36 <open>
  if(fd < 0){
    1cf5:	85 c0                	test   %eax,%eax
    printf(1, "cannot create bigfile");
    1cf7:	48 c7 c6 3c 3d 00 00 	mov    $0x3d3c,%rsi

  printf(1, "bigfile test\n");

  unlink("bigfile");
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    1cfe:	78 3a                	js     1d3a <bigfile+0x7f>
    1d00:	41 89 c4             	mov    %eax,%r12d
    1d03:	31 db                	xor    %ebx,%ebx
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    1d05:	ba 58 02 00 00       	mov    $0x258,%edx
    1d0a:	89 de                	mov    %ebx,%esi
    1d0c:	48 c7 c7 00 76 00 00 	mov    $0x7600,%rdi
    1d13:	e8 c7 0c 00 00       	callq  29df <memset>
    if(write(fd, buf, 600) != 600){
    1d18:	ba 58 02 00 00       	mov    $0x258,%edx
    1d1d:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1d24:	44 89 e7             	mov    %r12d,%edi
    1d27:	e8 ea 0d 00 00       	callq  2b16 <write>
    1d2c:	3d 58 02 00 00       	cmp    $0x258,%eax
    1d31:	74 18                	je     1d4b <bigfile+0x90>
      printf(1, "write bigfile failed\n");
    1d33:	48 c7 c6 52 3d 00 00 	mov    $0x3d52,%rsi
    1d3a:	bf 01 00 00 00       	mov    $0x1,%edi
    1d3f:	31 c0                	xor    %eax,%eax
    1d41:	e8 e3 0e 00 00       	callq  2c29 <printf>
      exit();
    1d46:	e8 ab 0d 00 00       	callq  2af6 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    1d4b:	ff c3                	inc    %ebx
    1d4d:	83 fb 14             	cmp    $0x14,%ebx
    1d50:	75 b3                	jne    1d05 <bigfile+0x4a>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    1d52:	44 89 e7             	mov    %r12d,%edi
    1d55:	31 db                	xor    %ebx,%ebx
    1d57:	e8 c2 0d 00 00       	callq  2b1e <close>

  fd = open("bigfile", 0);
    1d5c:	31 f6                	xor    %esi,%esi
    1d5e:	48 c7 c7 4a 3d 00 00 	mov    $0x3d4a,%rdi
    1d65:	e8 cc 0d 00 00       	callq  2b36 <open>
  if(fd < 0){
    1d6a:	85 c0                	test   %eax,%eax
      exit();
    }
  }
  close(fd);

  fd = open("bigfile", 0);
    1d6c:	41 89 c4             	mov    %eax,%r12d
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    1d6f:	48 c7 c6 68 3d 00 00 	mov    $0x3d68,%rsi
    }
  }
  close(fd);

  fd = open("bigfile", 0);
  if(fd < 0){
    1d76:	78 c2                	js     1d3a <bigfile+0x7f>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    1d78:	ba 2c 01 00 00       	mov    $0x12c,%edx
    1d7d:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    1d84:	44 89 e7             	mov    %r12d,%edi
    1d87:	44 69 eb 2c 01 00 00 	imul   $0x12c,%ebx,%r13d
    1d8e:	e8 7b 0d 00 00       	callq  2b0e <read>
    if(cc < 0){
    1d93:	85 c0                	test   %eax,%eax
    1d95:	79 09                	jns    1da0 <bigfile+0xe5>
      printf(1, "read bigfile failed\n");
    1d97:	48 c7 c6 7d 3d 00 00 	mov    $0x3d7d,%rsi
    1d9e:	eb 9a                	jmp    1d3a <bigfile+0x7f>
      exit();
    }
    if(cc == 0)
    1da0:	74 3a                	je     1ddc <bigfile+0x121>
      break;
    if(cc != 300){
    1da2:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    1da7:	74 09                	je     1db2 <bigfile+0xf7>
      printf(1, "short read bigfile\n");
    1da9:	48 c7 c6 92 3d 00 00 	mov    $0x3d92,%rsi
    1db0:	eb 88                	jmp    1d3a <bigfile+0x7f>
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    1db2:	0f be 05 47 58 00 00 	movsbl 0x5847(%rip),%eax        # 7600 <buf>
    1db9:	89 da                	mov    %ebx,%edx
    1dbb:	d1 fa                	sar    %edx
    1dbd:	39 d0                	cmp    %edx,%eax
    1dbf:	75 0b                	jne    1dcc <bigfile+0x111>
    1dc1:	0f be 15 63 59 00 00 	movsbl 0x5963(%rip),%edx        # 772b <buf+0x12b>
    1dc8:	39 d0                	cmp    %edx,%eax
    1dca:	74 0c                	je     1dd8 <bigfile+0x11d>
      printf(1, "read bigfile wrong data\n");
    1dcc:	48 c7 c6 a6 3d 00 00 	mov    $0x3da6,%rsi
    1dd3:	e9 62 ff ff ff       	jmpq   1d3a <bigfile+0x7f>
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    1dd8:	ff c3                	inc    %ebx
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    1dda:	eb 9c                	jmp    1d78 <bigfile+0xbd>
  close(fd);
    1ddc:	44 89 e7             	mov    %r12d,%edi
    1ddf:	e8 3a 0d 00 00       	callq  2b1e <close>
  if(total != 20*600){
    1de4:	41 81 fd e0 2e 00 00 	cmp    $0x2ee0,%r13d
    printf(1, "read bigfile wrong total\n");
    1deb:	48 c7 c6 bf 3d 00 00 	mov    $0x3dbf,%rsi
      exit();
    }
    total += cc;
  }
  close(fd);
  if(total != 20*600){
    1df2:	0f 85 42 ff ff ff    	jne    1d3a <bigfile+0x7f>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    1df8:	48 c7 c7 4a 3d 00 00 	mov    $0x3d4a,%rdi
    1dff:	e8 42 0d 00 00       	callq  2b46 <unlink>

  printf(1, "bigfile test ok\n");
}
    1e04:	5a                   	pop    %rdx
    1e05:	5b                   	pop    %rbx
    1e06:	41 5c                	pop    %r12
    1e08:	41 5d                	pop    %r13
    1e0a:	5d                   	pop    %rbp
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");

  printf(1, "bigfile test ok\n");
    1e0b:	48 c7 c6 d9 3d 00 00 	mov    $0x3dd9,%rsi
    1e12:	bf 01 00 00 00       	mov    $0x1,%edi
    1e17:	31 c0                	xor    %eax,%eax
    1e19:	e9 0b 0e 00 00       	jmpq   2c29 <printf>

0000000000001e1e <fourteen>:
}

void
fourteen(void)
{
    1e1e:	55                   	push   %rbp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    1e1f:	48 c7 c6 ea 3d 00 00 	mov    $0x3dea,%rsi
    1e26:	31 c0                	xor    %eax,%eax
    1e28:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "bigfile test ok\n");
}

void
fourteen(void)
{
    1e2d:	48 89 e5             	mov    %rsp,%rbp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    1e30:	e8 f4 0d 00 00       	callq  2c29 <printf>

  if(mkdir("12345678901234") != 0){
    1e35:	48 c7 c7 ef 3e 00 00 	mov    $0x3eef,%rdi
    1e3c:	e8 1d 0d 00 00       	callq  2b5e <mkdir>
    1e41:	85 c0                	test   %eax,%eax
    printf(1, "mkdir 12345678901234 failed\n");
    1e43:	48 c7 c6 f9 3d 00 00 	mov    $0x3df9,%rsi
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");

  if(mkdir("12345678901234") != 0){
    1e4a:	75 17                	jne    1e63 <fourteen+0x45>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    1e4c:	48 c7 c7 16 3e 00 00 	mov    $0x3e16,%rdi
    1e53:	e8 06 0d 00 00       	callq  2b5e <mkdir>
    1e58:	85 c0                	test   %eax,%eax
    1e5a:	74 18                	je     1e74 <fourteen+0x56>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    1e5c:	48 c7 c6 35 3e 00 00 	mov    $0x3e35,%rsi
    1e63:	bf 01 00 00 00       	mov    $0x1,%edi
    1e68:	31 c0                	xor    %eax,%eax
    1e6a:	e8 ba 0d 00 00       	callq  2c29 <printf>
    exit();
    1e6f:	e8 82 0c 00 00       	callq  2af6 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    1e74:	be 00 02 00 00       	mov    $0x200,%esi
    1e79:	48 c7 c7 62 3e 00 00 	mov    $0x3e62,%rdi
    1e80:	e8 b1 0c 00 00       	callq  2b36 <open>
  if(fd < 0){
    1e85:	85 c0                	test   %eax,%eax
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    1e87:	48 c7 c6 92 3e 00 00 	mov    $0x3e92,%rsi
  if(mkdir("12345678901234/123456789012345") != 0){
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
  if(fd < 0){
    1e8e:	78 d3                	js     1e63 <fourteen+0x45>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    1e90:	89 c7                	mov    %eax,%edi
    1e92:	e8 87 0c 00 00       	callq  2b1e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    1e97:	31 f6                	xor    %esi,%esi
    1e99:	48 c7 c7 d1 3e 00 00 	mov    $0x3ed1,%rdi
    1ea0:	e8 91 0c 00 00       	callq  2b36 <open>
  if(fd < 0){
    1ea5:	85 c0                	test   %eax,%eax
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    1ea7:	48 c7 c6 fe 3e 00 00 	mov    $0x3efe,%rsi
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
  fd = open("12345678901234/12345678901234/12345678901234", 0);
  if(fd < 0){
    1eae:	78 b3                	js     1e63 <fourteen+0x45>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    1eb0:	89 c7                	mov    %eax,%edi
    1eb2:	e8 67 0c 00 00       	callq  2b1e <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    1eb7:	48 c7 c7 e0 3e 00 00 	mov    $0x3ee0,%rdi
    1ebe:	e8 9b 0c 00 00       	callq  2b5e <mkdir>
    1ec3:	85 c0                	test   %eax,%eax
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    1ec5:	48 c7 c6 38 3f 00 00 	mov    $0x3f38,%rsi
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);

  if(mkdir("12345678901234/12345678901234") == 0){
    1ecc:	74 17                	je     1ee5 <fourteen+0xc7>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    1ece:	48 c7 c7 68 3f 00 00 	mov    $0x3f68,%rdi
    1ed5:	e8 84 0c 00 00       	callq  2b5e <mkdir>
    1eda:	85 c0                	test   %eax,%eax
    1edc:	75 11                	jne    1eef <fourteen+0xd1>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    1ede:	48 c7 c6 87 3f 00 00 	mov    $0x3f87,%rsi
    1ee5:	bf 01 00 00 00       	mov    $0x1,%edi
    1eea:	e9 7b ff ff ff       	jmpq   1e6a <fourteen+0x4c>
    exit();
  }

  printf(1, "fourteen ok\n");
}
    1eef:	5d                   	pop    %rbp
  if(mkdir("123456789012345/12345678901234") == 0){
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    1ef0:	48 c7 c6 b8 3f 00 00 	mov    $0x3fb8,%rsi
    1ef7:	bf 01 00 00 00       	mov    $0x1,%edi
    1efc:	31 c0                	xor    %eax,%eax
    1efe:	e9 26 0d 00 00       	jmpq   2c29 <printf>

0000000000001f03 <rmdot>:
}

void
rmdot(void)
{
    1f03:	55                   	push   %rbp
  printf(1, "rmdot test\n");
    1f04:	48 c7 c6 c5 3f 00 00 	mov    $0x3fc5,%rsi
    1f0b:	31 c0                	xor    %eax,%eax
    1f0d:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "fourteen ok\n");
}

void
rmdot(void)
{
    1f12:	48 89 e5             	mov    %rsp,%rbp
  printf(1, "rmdot test\n");
    1f15:	e8 0f 0d 00 00       	callq  2c29 <printf>
  if(mkdir("dots") != 0){
    1f1a:	48 c7 c7 d1 3f 00 00 	mov    $0x3fd1,%rdi
    1f21:	e8 38 0c 00 00       	callq  2b5e <mkdir>
    1f26:	85 c0                	test   %eax,%eax
    printf(1, "mkdir dots failed\n");
    1f28:	48 c7 c6 d6 3f 00 00 	mov    $0x3fd6,%rsi

void
rmdot(void)
{
  printf(1, "rmdot test\n");
  if(mkdir("dots") != 0){
    1f2f:	75 17                	jne    1f48 <rmdot+0x45>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    1f31:	48 c7 c7 d1 3f 00 00 	mov    $0x3fd1,%rdi
    1f38:	e8 29 0c 00 00       	callq  2b66 <chdir>
    1f3d:	85 c0                	test   %eax,%eax
    1f3f:	74 18                	je     1f59 <rmdot+0x56>
    printf(1, "chdir dots failed\n");
    1f41:	48 c7 c6 e9 3f 00 00 	mov    $0x3fe9,%rsi
    1f48:	bf 01 00 00 00       	mov    $0x1,%edi
    1f4d:	31 c0                	xor    %eax,%eax
    1f4f:	e8 d5 0c 00 00       	callq  2c29 <printf>
    exit();
    1f54:	e8 9d 0b 00 00       	callq  2af6 <exit>
  }
  if(unlink(".") == 0){
    1f59:	48 c7 c7 4b 3a 00 00 	mov    $0x3a4b,%rdi
    1f60:	e8 e1 0b 00 00       	callq  2b46 <unlink>
    1f65:	85 c0                	test   %eax,%eax
    printf(1, "rm . worked!\n");
    1f67:	48 c7 c6 fc 3f 00 00 	mov    $0x3ffc,%rsi
  }
  if(chdir("dots") != 0){
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    1f6e:	74 5c                	je     1fcc <rmdot+0xc9>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    1f70:	48 c7 c7 4a 3a 00 00 	mov    $0x3a4a,%rdi
    1f77:	e8 ca 0b 00 00       	callq  2b46 <unlink>
    1f7c:	85 c0                	test   %eax,%eax
    printf(1, "rm .. worked!\n");
    1f7e:	48 c7 c6 0a 40 00 00 	mov    $0x400a,%rsi
  }
  if(unlink(".") == 0){
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    1f85:	74 45                	je     1fcc <rmdot+0xc9>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    1f87:	48 c7 c7 a9 2f 00 00 	mov    $0x2fa9,%rdi
    1f8e:	e8 d3 0b 00 00       	callq  2b66 <chdir>
    1f93:	85 c0                	test   %eax,%eax
    printf(1, "chdir / failed\n");
    1f95:	48 c7 c6 ab 2f 00 00 	mov    $0x2fab,%rsi
  }
  if(unlink("..") == 0){
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    1f9c:	75 aa                	jne    1f48 <rmdot+0x45>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    1f9e:	48 c7 c7 19 40 00 00 	mov    $0x4019,%rdi
    1fa5:	e8 9c 0b 00 00       	callq  2b46 <unlink>
    1faa:	85 c0                	test   %eax,%eax
    printf(1, "unlink dots/. worked!\n");
    1fac:	48 c7 c6 20 40 00 00 	mov    $0x4020,%rsi
  }
  if(chdir("/") != 0){
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    1fb3:	74 17                	je     1fcc <rmdot+0xc9>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    1fb5:	48 c7 c7 37 40 00 00 	mov    $0x4037,%rdi
    1fbc:	e8 85 0b 00 00       	callq  2b46 <unlink>
    1fc1:	85 c0                	test   %eax,%eax
    1fc3:	75 11                	jne    1fd6 <rmdot+0xd3>
    printf(1, "unlink dots/.. worked!\n");
    1fc5:	48 c7 c6 3f 40 00 00 	mov    $0x403f,%rsi
    1fcc:	bf 01 00 00 00       	mov    $0x1,%edi
    1fd1:	e9 79 ff ff ff       	jmpq   1f4f <rmdot+0x4c>
    exit();
  }
  if(unlink("dots") != 0){
    1fd6:	48 c7 c7 d1 3f 00 00 	mov    $0x3fd1,%rdi
    1fdd:	e8 64 0b 00 00       	callq  2b46 <unlink>
    1fe2:	85 c0                	test   %eax,%eax
    printf(1, "unlink dots failed!\n");
    1fe4:	48 c7 c6 57 40 00 00 	mov    $0x4057,%rsi
  }
  if(unlink("dots/..") == 0){
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    1feb:	0f 85 57 ff ff ff    	jne    1f48 <rmdot+0x45>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
}
    1ff1:	5d                   	pop    %rbp
  }
  if(unlink("dots") != 0){
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    1ff2:	48 c7 c6 6c 40 00 00 	mov    $0x406c,%rsi
    1ff9:	bf 01 00 00 00       	mov    $0x1,%edi
    1ffe:	31 c0                	xor    %eax,%eax
    2000:	e9 24 0c 00 00       	jmpq   2c29 <printf>

0000000000002005 <dirfile>:
}

void
dirfile(void)
{
    2005:	55                   	push   %rbp
  int fd;

  printf(1, "dir vs file\n");
    2006:	31 c0                	xor    %eax,%eax
    2008:	48 c7 c6 76 40 00 00 	mov    $0x4076,%rsi
    200f:	bf 01 00 00 00       	mov    $0x1,%edi
  printf(1, "rmdot ok\n");
}

void
dirfile(void)
{
    2014:	48 89 e5             	mov    %rsp,%rbp
    2017:	53                   	push   %rbx
    2018:	51                   	push   %rcx
  int fd;

  printf(1, "dir vs file\n");
    2019:	e8 0b 0c 00 00       	callq  2c29 <printf>

  fd = open("dirfile", O_CREATE);
    201e:	be 00 02 00 00       	mov    $0x200,%esi
    2023:	48 c7 c7 83 40 00 00 	mov    $0x4083,%rdi
    202a:	e8 07 0b 00 00       	callq  2b36 <open>
  if(fd < 0){
    202f:	85 c0                	test   %eax,%eax
    printf(1, "create dirfile failed\n");
    2031:	48 c7 c6 8b 40 00 00 	mov    $0x408b,%rsi
  int fd;

  printf(1, "dir vs file\n");

  fd = open("dirfile", O_CREATE);
  if(fd < 0){
    2038:	0f 88 11 01 00 00    	js     214f <dirfile+0x14a>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    203e:	89 c7                	mov    %eax,%edi
    2040:	e8 d9 0a 00 00       	callq  2b1e <close>
  if(chdir("dirfile") == 0){
    2045:	48 c7 c7 83 40 00 00 	mov    $0x4083,%rdi
    204c:	e8 15 0b 00 00       	callq  2b66 <chdir>
    2051:	85 c0                	test   %eax,%eax
    2053:	75 16                	jne    206b <dirfile+0x66>
    printf(1, "chdir dirfile succeeded!\n");
    2055:	48 c7 c6 a2 40 00 00 	mov    $0x40a2,%rsi
    205c:	bf 01 00 00 00       	mov    $0x1,%edi
    2061:	e8 c3 0b 00 00       	callq  2c29 <printf>
    exit();
    2066:	e8 8b 0a 00 00       	callq  2af6 <exit>
  }
  fd = open("dirfile/xx", 0);
    206b:	31 f6                	xor    %esi,%esi
    206d:	48 c7 c7 bc 40 00 00 	mov    $0x40bc,%rdi
    2074:	e8 bd 0a 00 00       	callq  2b36 <open>
  if(fd >= 0){
    2079:	85 c0                	test   %eax,%eax
    207b:	78 0c                	js     2089 <dirfile+0x84>
    printf(1, "create dirfile/xx succeeded!\n");
    207d:	48 c7 c6 c7 40 00 00 	mov    $0x40c7,%rsi
    2084:	e9 c6 00 00 00       	jmpq   214f <dirfile+0x14a>
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2089:	be 00 02 00 00       	mov    $0x200,%esi
    208e:	48 c7 c7 bc 40 00 00 	mov    $0x40bc,%rdi
    2095:	e8 9c 0a 00 00       	callq  2b36 <open>
  if(fd >= 0){
    209a:	85 c0                	test   %eax,%eax
    209c:	79 df                	jns    207d <dirfile+0x78>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    209e:	48 c7 c7 bc 40 00 00 	mov    $0x40bc,%rdi
    20a5:	e8 b4 0a 00 00       	callq  2b5e <mkdir>
    20aa:	85 c0                	test   %eax,%eax
    printf(1, "mkdir dirfile/xx succeeded!\n");
    20ac:	48 c7 c6 e5 40 00 00 	mov    $0x40e5,%rsi
  fd = open("dirfile/xx", O_CREATE);
  if(fd >= 0){
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    20b3:	74 a7                	je     205c <dirfile+0x57>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    20b5:	48 c7 c7 bc 40 00 00 	mov    $0x40bc,%rdi
    20bc:	e8 85 0a 00 00       	callq  2b46 <unlink>
    20c1:	85 c0                	test   %eax,%eax
    printf(1, "unlink dirfile/xx succeeded!\n");
    20c3:	48 c7 c6 02 41 00 00 	mov    $0x4102,%rsi
  }
  if(mkdir("dirfile/xx") == 0){
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    20ca:	74 90                	je     205c <dirfile+0x57>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    20cc:	48 c7 c6 bc 40 00 00 	mov    $0x40bc,%rsi
    20d3:	48 c7 c7 20 41 00 00 	mov    $0x4120,%rdi
    20da:	e8 77 0a 00 00       	callq  2b56 <link>
    20df:	85 c0                	test   %eax,%eax
    printf(1, "link to dirfile/xx succeeded!\n");
    20e1:	48 c7 c6 27 41 00 00 	mov    $0x4127,%rsi
  }
  if(unlink("dirfile/xx") == 0){
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    20e8:	0f 84 6e ff ff ff    	je     205c <dirfile+0x57>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    20ee:	48 c7 c7 83 40 00 00 	mov    $0x4083,%rdi
    20f5:	e8 4c 0a 00 00       	callq  2b46 <unlink>
    20fa:	85 c0                	test   %eax,%eax
    printf(1, "unlink dirfile failed!\n");
    20fc:	48 c7 c6 46 41 00 00 	mov    $0x4146,%rsi
  }
  if(link("README", "dirfile/xx") == 0){
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    2103:	75 4a                	jne    214f <dirfile+0x14a>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2105:	be 02 00 00 00       	mov    $0x2,%esi
    210a:	48 c7 c7 4b 3a 00 00 	mov    $0x3a4b,%rdi
    2111:	e8 20 0a 00 00       	callq  2b36 <open>
  if(fd >= 0){
    2116:	85 c0                	test   %eax,%eax
    printf(1, "open . for writing succeeded!\n");
    2118:	48 c7 c6 5e 41 00 00 	mov    $0x415e,%rsi
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
  if(fd >= 0){
    211f:	79 2e                	jns    214f <dirfile+0x14a>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    2121:	31 f6                	xor    %esi,%esi
    2123:	48 c7 c7 4b 3a 00 00 	mov    $0x3a4b,%rdi
    212a:	e8 07 0a 00 00       	callq  2b36 <open>
  if(write(fd, "x", 1) > 0){
    212f:	ba 01 00 00 00       	mov    $0x1,%edx
    2134:	48 c7 c6 53 3b 00 00 	mov    $0x3b53,%rsi
    213b:	89 c7                	mov    %eax,%edi
  fd = open(".", O_RDWR);
  if(fd >= 0){
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    213d:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    213f:	e8 d2 09 00 00       	callq  2b16 <write>
    2144:	85 c0                	test   %eax,%eax
    2146:	7e 13                	jle    215b <dirfile+0x156>
    printf(1, "write . succeeded!\n");
    2148:	48 c7 c6 7d 41 00 00 	mov    $0x417d,%rsi
    214f:	bf 01 00 00 00       	mov    $0x1,%edi
    2154:	31 c0                	xor    %eax,%eax
    2156:	e9 06 ff ff ff       	jmpq   2061 <dirfile+0x5c>
    exit();
  }
  close(fd);
    215b:	89 df                	mov    %ebx,%edi
    215d:	e8 bc 09 00 00       	callq  2b1e <close>

  printf(1, "dir vs file OK\n");
}
    2162:	5a                   	pop    %rdx
    2163:	5b                   	pop    %rbx
    2164:	5d                   	pop    %rbp
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);

  printf(1, "dir vs file OK\n");
    2165:	48 c7 c6 91 41 00 00 	mov    $0x4191,%rsi
    216c:	bf 01 00 00 00       	mov    $0x1,%edi
    2171:	31 c0                	xor    %eax,%eax
    2173:	e9 b1 0a 00 00       	jmpq   2c29 <printf>

0000000000002178 <iref>:
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2178:	55                   	push   %rbp
  int i, fd;

  printf(1, "empty file name\n");
    2179:	48 c7 c6 a1 41 00 00 	mov    $0x41a1,%rsi
    2180:	bf 01 00 00 00       	mov    $0x1,%edi
    2185:	31 c0                	xor    %eax,%eax
}

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2187:	48 89 e5             	mov    %rsp,%rbp
    218a:	53                   	push   %rbx
    218b:	51                   	push   %rcx
  int i, fd;

  printf(1, "empty file name\n");
    218c:	bb 33 00 00 00       	mov    $0x33,%ebx
    2191:	e8 93 0a 00 00       	callq  2c29 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
    2196:	48 c7 c7 b2 41 00 00 	mov    $0x41b2,%rdi
    219d:	e8 bc 09 00 00       	callq  2b5e <mkdir>
    21a2:	85 c0                	test   %eax,%eax
    21a4:	74 09                	je     21af <iref+0x37>
      printf(1, "mkdir irefd failed\n");
    21a6:	48 c7 c6 b8 41 00 00 	mov    $0x41b8,%rsi
    21ad:	eb 17                	jmp    21c6 <iref+0x4e>
      exit();
    }
    if(chdir("irefd") != 0){
    21af:	48 c7 c7 b2 41 00 00 	mov    $0x41b2,%rdi
    21b6:	e8 ab 09 00 00       	callq  2b66 <chdir>
    21bb:	85 c0                	test   %eax,%eax
    21bd:	74 18                	je     21d7 <iref+0x5f>
      printf(1, "chdir irefd failed\n");
    21bf:	48 c7 c6 cc 41 00 00 	mov    $0x41cc,%rsi
    21c6:	bf 01 00 00 00       	mov    $0x1,%edi
    21cb:	31 c0                	xor    %eax,%eax
    21cd:	e8 57 0a 00 00       	callq  2c29 <printf>
      exit();
    21d2:	e8 1f 09 00 00       	callq  2af6 <exit>
    }

    mkdir("");
    21d7:	48 c7 c7 5c 34 00 00 	mov    $0x345c,%rdi
    21de:	e8 7b 09 00 00       	callq  2b5e <mkdir>
    link("README", "");
    21e3:	48 c7 c6 5c 34 00 00 	mov    $0x345c,%rsi
    21ea:	48 c7 c7 20 41 00 00 	mov    $0x4120,%rdi
    21f1:	e8 60 09 00 00       	callq  2b56 <link>
    fd = open("", O_CREATE);
    21f6:	be 00 02 00 00       	mov    $0x200,%esi
    21fb:	48 c7 c7 5c 34 00 00 	mov    $0x345c,%rdi
    2202:	e8 2f 09 00 00       	callq  2b36 <open>
    if(fd >= 0)
    2207:	85 c0                	test   %eax,%eax
    2209:	78 07                	js     2212 <iref+0x9a>
      close(fd);
    220b:	89 c7                	mov    %eax,%edi
    220d:	e8 0c 09 00 00       	callq  2b1e <close>
    fd = open("xx", O_CREATE);
    2212:	be 00 02 00 00       	mov    $0x200,%esi
    2217:	48 c7 c7 52 3b 00 00 	mov    $0x3b52,%rdi
    221e:	e8 13 09 00 00       	callq  2b36 <open>
    if(fd >= 0)
    2223:	85 c0                	test   %eax,%eax
    2225:	78 07                	js     222e <iref+0xb6>
      close(fd);
    2227:	89 c7                	mov    %eax,%edi
    2229:	e8 f0 08 00 00       	callq  2b1e <close>
    unlink("xx");
    222e:	48 c7 c7 52 3b 00 00 	mov    $0x3b52,%rdi
    2235:	e8 0c 09 00 00       	callq  2b46 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    223a:	ff cb                	dec    %ebx
    223c:	0f 85 54 ff ff ff    	jne    2196 <iref+0x1e>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2242:	48 c7 c7 a9 2f 00 00 	mov    $0x2fa9,%rdi
    2249:	e8 18 09 00 00       	callq  2b66 <chdir>
  printf(1, "empty file name OK\n");
}
    224e:	5a                   	pop    %rdx
    224f:	5b                   	pop    %rbx
    2250:	5d                   	pop    %rbp
      close(fd);
    unlink("xx");
  }

  chdir("/");
  printf(1, "empty file name OK\n");
    2251:	48 c7 c6 e0 41 00 00 	mov    $0x41e0,%rsi
    2258:	bf 01 00 00 00       	mov    $0x1,%edi
    225d:	31 c0                	xor    %eax,%eax
    225f:	e9 c5 09 00 00       	jmpq   2c29 <printf>

0000000000002264 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2264:	55                   	push   %rbp
  int n, pid;

  printf(1, "fork test\n");
    2265:	48 c7 c6 f4 41 00 00 	mov    $0x41f4,%rsi
    226c:	bf 01 00 00 00       	mov    $0x1,%edi
    2271:	31 c0                	xor    %eax,%eax
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2273:	48 89 e5             	mov    %rsp,%rbp
    2276:	53                   	push   %rbx
    2277:	51                   	push   %rcx
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2278:	31 db                	xor    %ebx,%ebx
void
forktest(void)
{
  int n, pid;

  printf(1, "fork test\n");
    227a:	e8 aa 09 00 00       	callq  2c29 <printf>

  for(n=0; n<1000; n++){
    pid = fork();
    227f:	e8 6a 08 00 00       	callq  2aee <fork>
    if(pid < 0)
    2284:	85 c0                	test   %eax,%eax
    2286:	78 26                	js     22ae <forktest+0x4a>
      break;
    if(pid == 0)
    2288:	74 1d                	je     22a7 <forktest+0x43>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    228a:	ff c3                	inc    %ebx
    228c:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2292:	75 eb                	jne    227f <forktest+0x1b>
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    2294:	48 c7 c6 34 42 00 00 	mov    $0x4234,%rsi
    exit();
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
    229b:	bf 01 00 00 00       	mov    $0x1,%edi
    22a0:	31 c0                	xor    %eax,%eax
    22a2:	e8 82 09 00 00       	callq  2c29 <printf>
      exit();
    22a7:	e8 4a 08 00 00       	callq  2af6 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    22ac:	ff cb                	dec    %ebx
    22ae:	85 db                	test   %ebx,%ebx
    22b0:	74 12                	je     22c4 <forktest+0x60>
    if(wait() < 0){
    22b2:	e8 47 08 00 00       	callq  2afe <wait>
    22b7:	85 c0                	test   %eax,%eax
    22b9:	79 f1                	jns    22ac <forktest+0x48>
      printf(1, "wait stopped early\n");
    22bb:	48 c7 c6 ff 41 00 00 	mov    $0x41ff,%rsi
    22c2:	eb d7                	jmp    229b <forktest+0x37>
      exit();
    }
  }
  
  if(wait() != -1){
    22c4:	e8 35 08 00 00       	callq  2afe <wait>
    22c9:	ff c0                	inc    %eax
    printf(1, "wait got too many\n");
    22cb:	48 c7 c6 13 42 00 00 	mov    $0x4213,%rsi
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    22d2:	75 c7                	jne    229b <forktest+0x37>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
}
    22d4:	5a                   	pop    %rdx
    22d5:	5b                   	pop    %rbx
    22d6:	5d                   	pop    %rbp
  if(wait() != -1){
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
    22d7:	48 c7 c6 26 42 00 00 	mov    $0x4226,%rsi
    22de:	bf 01 00 00 00       	mov    $0x1,%edi
    22e3:	31 c0                	xor    %eax,%eax
    22e5:	e9 3f 09 00 00       	jmpq   2c29 <printf>

00000000000022ea <sbrktest>:
}

void
sbrktest(void)
{
    22ea:	55                   	push   %rbp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    22eb:	48 c7 c6 56 42 00 00 	mov    $0x4256,%rsi
    22f2:	31 c0                	xor    %eax,%eax
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
    22f4:	48 89 e5             	mov    %rsp,%rbp
    22f7:	41 55                	push   %r13
    22f9:	41 54                	push   %r12
    22fb:	53                   	push   %rbx
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    22fc:	45 31 ed             	xor    %r13d,%r13d
  printf(1, "fork test OK\n");
}

void
sbrktest(void)
{
    22ff:	48 83 ec 48          	sub    $0x48,%rsp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2303:	8b 3d 7f 2b 00 00    	mov    0x2b7f(%rip),%edi        # 4e88 <stdout>
    2309:	e8 1b 09 00 00       	callq  2c29 <printf>
  oldbrk = sbrk(0);
    230e:	31 ff                	xor    %edi,%edi
    2310:	e8 69 08 00 00       	callq  2b7e <sbrk>

  // can one sbrk() less than a page?
  a = sbrk(0);
    2315:	31 ff                	xor    %edi,%edi
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
  oldbrk = sbrk(0);
    2317:	49 89 c4             	mov    %rax,%r12

  // can one sbrk() less than a page?
  a = sbrk(0);
    231a:	e8 5f 08 00 00       	callq  2b7e <sbrk>
    231f:	48 89 c3             	mov    %rax,%rbx
  int i;
  for(i = 0; i < 5000; i++){ 
    b = sbrk(1);
    2322:	bf 01 00 00 00       	mov    $0x1,%edi
    2327:	e8 52 08 00 00       	callq  2b7e <sbrk>
    if(b != a){
    232c:	48 39 d8             	cmp    %rbx,%rax

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    b = sbrk(1);
    232f:	49 89 c0             	mov    %rax,%r8
    if(b != a){
    2332:	74 1c                	je     2350 <sbrktest+0x66>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2334:	8b 3d 4e 2b 00 00    	mov    0x2b4e(%rip),%edi        # 4e88 <stdout>
    233a:	48 89 d9             	mov    %rbx,%rcx
    233d:	44 89 ea             	mov    %r13d,%edx
    2340:	48 c7 c6 61 42 00 00 	mov    $0x4261,%rsi
    2347:	31 c0                	xor    %eax,%eax
    2349:	e8 db 08 00 00       	callq  2c29 <printf>
    234e:	eb 32                	jmp    2382 <sbrktest+0x98>
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    2350:	41 ff c5             	inc    %r13d
    b = sbrk(1);
    if(b != a){
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    2353:	c6 03 01             	movb   $0x1,(%rbx)
    a = b + 1;
    2356:	48 ff c3             	inc    %rbx
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    2359:	41 81 fd 88 13 00 00 	cmp    $0x1388,%r13d
    2360:	75 c0                	jne    2322 <sbrktest+0x38>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2362:	e8 87 07 00 00       	callq  2aee <fork>
  if(pid < 0){
    2367:	85 c0                	test   %eax,%eax
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2369:	41 89 c5             	mov    %eax,%r13d
  if(pid < 0){
    236c:	79 19                	jns    2387 <sbrktest+0x9d>
    printf(stdout, "sbrk test fork failed\n");
    236e:	48 c7 c6 7c 42 00 00 	mov    $0x427c,%rsi
    2375:	8b 3d 0d 2b 00 00    	mov    0x2b0d(%rip),%edi        # 4e88 <stdout>
    237b:	31 c0                	xor    %eax,%eax
    237d:	e8 a7 08 00 00       	callq  2c29 <printf>
    exit();
    2382:	e8 6f 07 00 00       	callq  2af6 <exit>
  }
  c = sbrk(1);
    2387:	bf 01 00 00 00       	mov    $0x1,%edi
  c = sbrk(1);
  if(c != a + 1){
    238c:	48 ff c3             	inc    %rbx
  pid = fork();
  if(pid < 0){
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    238f:	e8 ea 07 00 00       	callq  2b7e <sbrk>
  c = sbrk(1);
    2394:	bf 01 00 00 00       	mov    $0x1,%edi
    2399:	e8 e0 07 00 00       	callq  2b7e <sbrk>
  if(c != a + 1){
    239e:	48 39 d8             	cmp    %rbx,%rax
    printf(stdout, "sbrk test failed post-fork\n");
    23a1:	48 c7 c6 93 42 00 00 	mov    $0x4293,%rsi
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
  c = sbrk(1);
  if(c != a + 1){
    23a8:	75 cb                	jne    2375 <sbrktest+0x8b>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    23aa:	45 85 ed             	test   %r13d,%r13d
    23ad:	74 d3                	je     2382 <sbrktest+0x98>
    exit();
  wait();
    23af:	e8 4a 07 00 00       	callq  2afe <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    23b4:	31 ff                	xor    %edi,%edi
    23b6:	e8 c3 07 00 00       	callq  2b7e <sbrk>
  amt = (BIG) - (uint)(uintp)a;
  p = sbrk(amt);
    23bb:	bf 00 00 40 06       	mov    $0x6400000,%edi
    exit();
  wait();

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    23c0:	48 89 c3             	mov    %rax,%rbx
  amt = (BIG) - (uint)(uintp)a;
  p = sbrk(amt);
    23c3:	29 c7                	sub    %eax,%edi
    23c5:	e8 b4 07 00 00       	callq  2b7e <sbrk>
  if (p != a) { 
    23ca:	48 39 c3             	cmp    %rax,%rbx
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    23cd:	48 c7 c6 af 42 00 00 	mov    $0x42af,%rsi
  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
  amt = (BIG) - (uint)(uintp)a;
  p = sbrk(amt);
  if (p != a) { 
    23d4:	75 9f                	jne    2375 <sbrktest+0x8b>
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
    23d6:	31 ff                	xor    %edi,%edi
  if (p != a) { 
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    23d8:	c6 04 25 ff ff 3f 06 	movb   $0x63,0x63fffff
    23df:	63 

  // can one de-allocate?
  a = sbrk(0);
    23e0:	e8 99 07 00 00       	callq  2b7e <sbrk>
  c = sbrk(-4096);
    23e5:	bf 00 f0 ff ff       	mov    $0xfffff000,%edi
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
    23ea:	48 89 c3             	mov    %rax,%rbx
  c = sbrk(-4096);
    23ed:	e8 8c 07 00 00       	callq  2b7e <sbrk>
  if(c == (char*)0xffffffff){
    23f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    printf(stdout, "sbrk could not deallocate\n");
    23f7:	48 c7 c6 ed 42 00 00 	mov    $0x42ed,%rsi
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
  c = sbrk(-4096);
  if(c == (char*)0xffffffff){
    23fe:	48 39 d0             	cmp    %rdx,%rax
    2401:	0f 84 6e ff ff ff    	je     2375 <sbrktest+0x8b>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2407:	31 ff                	xor    %edi,%edi
    2409:	e8 70 07 00 00       	callq  2b7e <sbrk>
  if(c != a - 4096){
    240e:	48 8d 93 00 f0 ff ff 	lea    -0x1000(%rbx),%rdx
    2415:	48 39 d0             	cmp    %rdx,%rax
    2418:	74 12                	je     242c <sbrktest+0x142>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    241a:	48 89 c1             	mov    %rax,%rcx
    241d:	48 89 da             	mov    %rbx,%rdx
    2420:	48 c7 c6 08 43 00 00 	mov    $0x4308,%rsi
    2427:	e9 88 00 00 00       	jmpq   24b4 <sbrktest+0x1ca>
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    242c:	31 ff                	xor    %edi,%edi
    242e:	e8 4b 07 00 00       	callq  2b7e <sbrk>
  c = sbrk(4096);
    2433:	bf 00 10 00 00       	mov    $0x1000,%edi
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2438:	48 89 c3             	mov    %rax,%rbx
  c = sbrk(4096);
    243b:	e8 3e 07 00 00       	callq  2b7e <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2440:	48 39 c3             	cmp    %rax,%rbx
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
    2443:	49 89 c5             	mov    %rax,%r13
  if(c != a || sbrk(0) != a + 4096){
    2446:	74 0f                	je     2457 <sbrktest+0x16d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2448:	4c 89 e9             	mov    %r13,%rcx
    244b:	48 89 da             	mov    %rbx,%rdx
    244e:	48 c7 c6 3d 43 00 00 	mov    $0x433d,%rsi
    2455:	eb 5d                	jmp    24b4 <sbrktest+0x1ca>
  }

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
  if(c != a || sbrk(0) != a + 4096){
    2457:	31 ff                	xor    %edi,%edi
    2459:	e8 20 07 00 00       	callq  2b7e <sbrk>
    245e:	48 8d 93 00 10 00 00 	lea    0x1000(%rbx),%rdx
    2465:	48 39 d0             	cmp    %rdx,%rax
    2468:	75 de                	jne    2448 <sbrktest+0x15e>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    246a:	80 3c 25 ff ff 3f 06 	cmpb   $0x63,0x63fffff
    2471:	63 
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2472:	48 c7 c6 63 43 00 00 	mov    $0x4363,%rsi
  c = sbrk(4096);
  if(c != a || sbrk(0) != a + 4096){
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2479:	0f 84 f6 fe ff ff    	je     2375 <sbrktest+0x8b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    247f:	31 ff                	xor    %edi,%edi
    2481:	48 c7 c3 00 00 00 80 	mov    $0xffffffff80000000,%rbx
    2488:	e8 f1 06 00 00       	callq  2b7e <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    248d:	31 ff                	xor    %edi,%edi
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    248f:	49 89 c5             	mov    %rax,%r13
  c = sbrk(-(sbrk(0) - oldbrk));
    2492:	e8 e7 06 00 00       	callq  2b7e <sbrk>
    2497:	4c 89 e7             	mov    %r12,%rdi
    249a:	48 29 c7             	sub    %rax,%rdi
    249d:	e8 dc 06 00 00       	callq  2b7e <sbrk>
  if(c != a){
    24a2:	49 39 c5             	cmp    %rax,%r13
    24a5:	74 34                	je     24db <sbrktest+0x1f1>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    24a7:	48 89 c1             	mov    %rax,%rcx
    24aa:	4c 89 ea             	mov    %r13,%rdx
    24ad:	48 c7 c6 90 43 00 00 	mov    $0x4390,%rsi
    24b4:	8b 3d ce 29 00 00    	mov    0x29ce(%rip),%edi        # 4e88 <stdout>
    24ba:	31 c0                	xor    %eax,%eax
    24bc:	e8 68 07 00 00       	callq  2c29 <printf>
    24c1:	e9 bc fe ff ff       	jmpq   2382 <sbrktest+0x98>
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    24c6:	48 81 c3 50 c3 00 00 	add    $0xc350,%rbx
    if(pid == 0){
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    24cd:	e8 2c 06 00 00       	callq  2afe <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    24d2:	48 81 fb 80 84 1e 80 	cmp    $0xffffffff801e8480,%rbx
    24d9:	74 46                	je     2521 <sbrktest+0x237>
    ppid = getpid();
    24db:	e8 96 06 00 00       	callq  2b76 <getpid>
    24e0:	41 89 c5             	mov    %eax,%r13d
    pid = fork();
    24e3:	e8 06 06 00 00       	callq  2aee <fork>
    if(pid < 0){
    24e8:	85 c0                	test   %eax,%eax
    24ea:	79 0c                	jns    24f8 <sbrktest+0x20e>
      printf(stdout, "fork failed\n");
    24ec:	48 c7 c6 6b 45 00 00 	mov    $0x456b,%rsi
    24f3:	e9 7d fe ff ff       	jmpq   2375 <sbrktest+0x8b>
      exit();
    }
    if(pid == 0){
    24f8:	75 cc                	jne    24c6 <sbrktest+0x1dc>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    24fa:	0f be 0b             	movsbl (%rbx),%ecx
    24fd:	8b 3d 85 29 00 00    	mov    0x2985(%rip),%edi        # 4e88 <stdout>
    2503:	48 89 da             	mov    %rbx,%rdx
    2506:	48 c7 c6 b1 43 00 00 	mov    $0x43b1,%rsi
    250d:	31 c0                	xor    %eax,%eax
    250f:	e8 15 07 00 00       	callq  2c29 <printf>
      kill(ppid);
    2514:	44 89 ef             	mov    %r13d,%edi
    2517:	e8 0a 06 00 00       	callq  2b26 <kill>
    251c:	e9 61 fe ff ff       	jmpq   2382 <sbrktest+0x98>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2521:	48 8d 7d b0          	lea    -0x50(%rbp),%rdi
    2525:	31 db                	xor    %ebx,%ebx
    2527:	e8 da 05 00 00       	callq  2b06 <pipe>
    252c:	85 c0                	test   %eax,%eax
    printf(1, "pipe() failed\n");
    252e:	48 c7 c6 72 33 00 00 	mov    $0x3372,%rsi
    2535:	bf 01 00 00 00       	mov    $0x1,%edi
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    253a:	0f 85 3b fe ff ff    	jne    237b <sbrktest+0x91>
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
    2540:	e8 a9 05 00 00       	callq  2aee <fork>
    2545:	85 c0                	test   %eax,%eax
    2547:	89 44 2b b8          	mov    %eax,-0x48(%rbx,%rbp,1)
    254b:	75 33                	jne    2580 <sbrktest+0x296>
      // allocate a lot of memory
      sbrk(BIG - (uint)(uintp)sbrk(0));
    254d:	31 ff                	xor    %edi,%edi
    254f:	e8 2a 06 00 00       	callq  2b7e <sbrk>
    2554:	bf 00 00 40 06       	mov    $0x6400000,%edi
    2559:	29 c7                	sub    %eax,%edi
    255b:	e8 1e 06 00 00       	callq  2b7e <sbrk>
      write(fds[1], "x", 1);
    2560:	8b 7d b4             	mov    -0x4c(%rbp),%edi
    2563:	ba 01 00 00 00       	mov    $0x1,%edx
    2568:	48 c7 c6 53 3b 00 00 	mov    $0x3b53,%rsi
    256f:	e8 a2 05 00 00       	callq  2b16 <write>
      // sit around until killed
      for(;;) sleep(1000);
    2574:	bf e8 03 00 00       	mov    $0x3e8,%edi
    2579:	e8 08 06 00 00       	callq  2b86 <sleep>
    257e:	eb f4                	jmp    2574 <sbrktest+0x28a>
    }
    if(pids[i] != -1)
    2580:	ff c0                	inc    %eax
    2582:	74 11                	je     2595 <sbrktest+0x2ab>
      read(fds[0], &scratch, 1);
    2584:	8b 7d b0             	mov    -0x50(%rbp),%edi
    2587:	48 8d 75 af          	lea    -0x51(%rbp),%rsi
    258b:	ba 01 00 00 00       	mov    $0x1,%edx
    2590:	e8 79 05 00 00       	callq  2b0e <read>
    2595:	48 83 c3 04          	add    $0x4,%rbx
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2599:	48 83 fb 28          	cmp    $0x28,%rbx
    259d:	75 a1                	jne    2540 <sbrktest+0x256>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    259f:	bf 00 10 00 00       	mov    $0x1000,%edi
    25a4:	31 db                	xor    %ebx,%ebx
    25a6:	e8 d3 05 00 00       	callq  2b7e <sbrk>
    25ab:	49 89 c5             	mov    %rax,%r13
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    25ae:	8b 7c 1d b8          	mov    -0x48(%rbp,%rbx,1),%edi
    25b2:	83 ff ff             	cmp    $0xffffffff,%edi
    25b5:	74 0a                	je     25c1 <sbrktest+0x2d7>
      continue;
    kill(pids[i]);
    25b7:	e8 6a 05 00 00       	callq  2b26 <kill>
    wait();
    25bc:	e8 3d 05 00 00       	callq  2afe <wait>
    25c1:	48 83 c3 04          	add    $0x4,%rbx
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    25c5:	48 83 fb 28          	cmp    $0x28,%rbx
    25c9:	75 e3                	jne    25ae <sbrktest+0x2c4>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    25cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    printf(stdout, "failed sbrk leaked memory\n");
    25d0:	48 c7 c6 ca 43 00 00 	mov    $0x43ca,%rsi
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    25d7:	49 39 c5             	cmp    %rax,%r13
    25da:	0f 84 95 fd ff ff    	je     2375 <sbrktest+0x8b>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    25e0:	31 ff                	xor    %edi,%edi
    25e2:	e8 97 05 00 00       	callq  2b7e <sbrk>
    25e7:	49 39 c4             	cmp    %rax,%r12
    25ea:	73 12                	jae    25fe <sbrktest+0x314>
    sbrk(-(sbrk(0) - oldbrk));
    25ec:	31 ff                	xor    %edi,%edi
    25ee:	e8 8b 05 00 00       	callq  2b7e <sbrk>
    25f3:	4c 89 e7             	mov    %r12,%rdi
    25f6:	48 29 c7             	sub    %rax,%rdi
    25f9:	e8 80 05 00 00       	callq  2b7e <sbrk>

  printf(stdout, "sbrk test OK\n");
    25fe:	8b 3d 84 28 00 00    	mov    0x2884(%rip),%edi        # 4e88 <stdout>
    2604:	48 c7 c6 e5 43 00 00 	mov    $0x43e5,%rsi
    260b:	31 c0                	xor    %eax,%eax
    260d:	e8 17 06 00 00       	callq  2c29 <printf>
}
    2612:	48 83 c4 48          	add    $0x48,%rsp
    2616:	5b                   	pop    %rbx
    2617:	41 5c                	pop    %r12
    2619:	41 5d                	pop    %r13
    261b:	5d                   	pop    %rbp
    261c:	c3                   	retq   

000000000000261d <validateint>:

void
validateint(int *p)
{
    261d:	55                   	push   %rbp
    261e:	48 89 e5             	mov    %rsp,%rbp
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
#endif
}
    2621:	5d                   	pop    %rbp
    2622:	c3                   	retq   

0000000000002623 <validatetest>:

void
validatetest(void)
{
    2623:	55                   	push   %rbp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2624:	8b 3d 5e 28 00 00    	mov    0x285e(%rip),%edi        # 4e88 <stdout>
    262a:	48 c7 c6 f3 43 00 00 	mov    $0x43f3,%rsi
    2631:	31 c0                	xor    %eax,%eax
#endif
}

void
validatetest(void)
{
    2633:	48 89 e5             	mov    %rsp,%rbp
    2636:	41 54                	push   %r12
    2638:	53                   	push   %rbx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2639:	31 db                	xor    %ebx,%ebx
    263b:	e8 e9 05 00 00       	callq  2c29 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    if((pid = fork()) == 0){
    2640:	e8 a9 04 00 00       	callq  2aee <fork>
    2645:	85 c0                	test   %eax,%eax
    2647:	41 89 c4             	mov    %eax,%r12d
    264a:	74 42                	je     268e <validatetest+0x6b>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)(uintp)p);
      exit();
    }
    sleep(0);
    264c:	31 ff                	xor    %edi,%edi
    264e:	e8 33 05 00 00       	callq  2b86 <sleep>
    sleep(0);
    2653:	31 ff                	xor    %edi,%edi
    2655:	e8 2c 05 00 00       	callq  2b86 <sleep>
    kill(pid);
    265a:	44 89 e7             	mov    %r12d,%edi
    265d:	e8 c4 04 00 00       	callq  2b26 <kill>
    wait();
    2662:	e8 97 04 00 00       	callq  2afe <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)(uintp)p) != -1){
    2667:	48 89 de             	mov    %rbx,%rsi
    266a:	48 c7 c7 02 44 00 00 	mov    $0x4402,%rdi
    2671:	e8 e0 04 00 00       	callq  2b56 <link>
    2676:	ff c0                	inc    %eax
    2678:	74 19                	je     2693 <validatetest+0x70>
      printf(stdout, "link should not succeed\n");
    267a:	8b 3d 08 28 00 00    	mov    0x2808(%rip),%edi        # 4e88 <stdout>
    2680:	48 c7 c6 0d 44 00 00 	mov    $0x440d,%rsi
    2687:	31 c0                	xor    %eax,%eax
    2689:	e8 9b 05 00 00       	callq  2c29 <printf>
      exit();
    268e:	e8 63 04 00 00       	callq  2af6 <exit>
    2693:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    269a:	48 81 fb 00 40 11 00 	cmp    $0x114000,%rbx
    26a1:	75 9d                	jne    2640 <validatetest+0x1d>
      exit();
    }
  }

  printf(stdout, "validate ok\n");
}
    26a3:	5b                   	pop    %rbx
    26a4:	41 5c                	pop    %r12
    26a6:	5d                   	pop    %rbp
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    26a7:	8b 3d db 27 00 00    	mov    0x27db(%rip),%edi        # 4e88 <stdout>
    26ad:	48 c7 c6 26 44 00 00 	mov    $0x4426,%rsi
    26b4:	31 c0                	xor    %eax,%eax
    26b6:	e9 6e 05 00 00       	jmpq   2c29 <printf>

00000000000026bb <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    26bb:	55                   	push   %rbp
  int i;

  printf(stdout, "bss test\n");
    26bc:	8b 3d c6 27 00 00    	mov    0x27c6(%rip),%edi        # 4e88 <stdout>
    26c2:	31 c0                	xor    %eax,%eax
    26c4:	48 c7 c6 33 44 00 00 	mov    $0x4433,%rsi

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    26cb:	48 89 e5             	mov    %rsp,%rbp
  int i;

  printf(stdout, "bss test\n");
    26ce:	e8 56 05 00 00       	callq  2c29 <printf>
    26d3:	31 c0                	xor    %eax,%eax
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
    26d5:	48 ba df 4e 00 00 00 	movabs $0x4edf,%rdx
    26dc:	00 00 00 
    26df:	48 ff c0             	inc    %rax
    26e2:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
    26e6:	74 19                	je     2701 <bsstest+0x46>
      printf(stdout, "bss test failed\n");
    26e8:	8b 3d 9a 27 00 00    	mov    0x279a(%rip),%edi        # 4e88 <stdout>
    26ee:	48 c7 c6 3d 44 00 00 	mov    $0x443d,%rsi
    26f5:	31 c0                	xor    %eax,%eax
    26f7:	e8 2d 05 00 00       	callq  2c29 <printf>
      exit();
    26fc:	e8 f5 03 00 00       	callq  2af6 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    2701:	48 3d 10 27 00 00    	cmp    $0x2710,%rax
    2707:	75 d6                	jne    26df <bsstest+0x24>
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
}
    2709:	5d                   	pop    %rbp
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    270a:	8b 3d 78 27 00 00    	mov    0x2778(%rip),%edi        # 4e88 <stdout>
    2710:	48 c7 c6 4e 44 00 00 	mov    $0x444e,%rsi
    2717:	31 c0                	xor    %eax,%eax
    2719:	e9 0b 05 00 00       	jmpq   2c29 <printf>

000000000000271e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    271e:	55                   	push   %rbp
  int pid, fd;

  unlink("bigarg-ok");
    271f:	48 c7 c7 5b 44 00 00 	mov    $0x445b,%rdi
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    2726:	48 89 e5             	mov    %rsp,%rbp
  int pid, fd;

  unlink("bigarg-ok");
    2729:	e8 18 04 00 00       	callq  2b46 <unlink>
  pid = fork();
    272e:	e8 bb 03 00 00       	callq  2aee <fork>
  if(pid == 0){
    2733:	85 c0                	test   %eax,%eax
    2735:	75 79                	jne    27b0 <bigargtest+0x92>
    2737:	31 c0                	xor    %eax,%eax
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2739:	48 c7 80 00 96 00 00 	movq   $0x4465,0x9600(%rax)
    2740:	65 44 00 00 
    2744:	48 83 c0 08          	add    $0x8,%rax
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    2748:	48 3d f8 00 00 00    	cmp    $0xf8,%rax
    274e:	75 e9                	jne    2739 <bigargtest+0x1b>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    printf(stdout, "bigarg test\n");
    2750:	8b 3d 32 27 00 00    	mov    0x2732(%rip),%edi        # 4e88 <stdout>
    2756:	31 c0                	xor    %eax,%eax
    2758:	48 c7 c6 42 45 00 00 	mov    $0x4542,%rsi
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    275f:	48 c7 05 8e 6f 00 00 	movq   $0x0,0x6f8e(%rip)        # 96f8 <args.1837+0xf8>
    2766:	00 00 00 00 
    printf(stdout, "bigarg test\n");
    276a:	e8 ba 04 00 00       	callq  2c29 <printf>
    exec("echo", args);
    276f:	48 c7 c6 00 96 00 00 	mov    $0x9600,%rsi
    2776:	48 c7 c7 69 30 00 00 	mov    $0x3069,%rdi
    277d:	e8 ac 03 00 00       	callq  2b2e <exec>
    printf(stdout, "bigarg test ok\n");
    2782:	8b 3d 00 27 00 00    	mov    0x2700(%rip),%edi        # 4e88 <stdout>
    2788:	31 c0                	xor    %eax,%eax
    278a:	48 c7 c6 4f 45 00 00 	mov    $0x454f,%rsi
    2791:	e8 93 04 00 00       	callq  2c29 <printf>
    fd = open("bigarg-ok", O_CREATE);
    2796:	be 00 02 00 00       	mov    $0x200,%esi
    279b:	48 c7 c7 5b 44 00 00 	mov    $0x445b,%rdi
    27a2:	e8 8f 03 00 00       	callq  2b36 <open>
    close(fd);
    27a7:	89 c7                	mov    %eax,%edi
    27a9:	e8 70 03 00 00       	callq  2b1e <close>
    27ae:	eb 16                	jmp    27c6 <bigargtest+0xa8>
    exit();
  } else if(pid < 0){
    27b0:	79 19                	jns    27cb <bigargtest+0xad>
    printf(stdout, "bigargtest: fork failed\n");
    27b2:	48 c7 c6 5f 45 00 00 	mov    $0x455f,%rsi
    27b9:	8b 3d c9 26 00 00    	mov    0x26c9(%rip),%edi        # 4e88 <stdout>
    27bf:	31 c0                	xor    %eax,%eax
    27c1:	e8 63 04 00 00       	callq  2c29 <printf>
    exit();
    27c6:	e8 2b 03 00 00       	callq  2af6 <exit>
  }
  wait();
    27cb:	e8 2e 03 00 00       	callq  2afe <wait>
  fd = open("bigarg-ok", 0);
    27d0:	31 f6                	xor    %esi,%esi
    27d2:	48 c7 c7 5b 44 00 00 	mov    $0x445b,%rdi
    27d9:	e8 58 03 00 00       	callq  2b36 <open>
  if(fd < 0){
    27de:	85 c0                	test   %eax,%eax
    printf(stdout, "bigarg test failed!\n");
    27e0:	48 c7 c6 78 45 00 00 	mov    $0x4578,%rsi
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
  fd = open("bigarg-ok", 0);
  if(fd < 0){
    27e7:	78 d0                	js     27b9 <bigargtest+0x9b>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    27e9:	89 c7                	mov    %eax,%edi
    27eb:	e8 2e 03 00 00       	callq  2b1e <close>
  unlink("bigarg-ok");
}
    27f0:	5d                   	pop    %rbp
  if(fd < 0){
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
  unlink("bigarg-ok");
    27f1:	48 c7 c7 5b 44 00 00 	mov    $0x445b,%rdi
    27f8:	e9 49 03 00 00       	jmpq   2b46 <unlink>

00000000000027fd <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    27fd:	55                   	push   %rbp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    27fe:	48 c7 c6 8d 45 00 00 	mov    $0x458d,%rsi
    2805:	bf 01 00 00 00       	mov    $0x1,%edi
    280a:	31 c0                	xor    %eax,%eax

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    280c:	48 89 e5             	mov    %rsp,%rbp
    280f:	41 55                	push   %r13
    2811:	41 54                	push   %r12
    2813:	53                   	push   %rbx
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    2814:	31 db                	xor    %ebx,%ebx

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    2816:	48 83 ec 48          	sub    $0x48,%rsp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    281a:	e8 0a 04 00 00       	callq  2c29 <printf>

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    281f:	89 d8                	mov    %ebx,%eax
    2821:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    2826:	48 c7 c6 9a 45 00 00 	mov    $0x459a,%rsi
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    282d:	99                   	cltd   
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    282e:	bf 01 00 00 00       	mov    $0x1,%edi

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    2833:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    2837:	f7 f9                	idiv   %ecx
    name[2] = '0' + (nfiles % 1000) / 100;
    2839:	b9 64 00 00 00       	mov    $0x64,%ecx
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    283e:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    2842:	83 c0 30             	add    $0x30,%eax
    2845:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    2848:	89 d0                	mov    %edx,%eax
    284a:	99                   	cltd   
    284b:	f7 f9                	idiv   %ecx
    284d:	8d 50 30             	lea    0x30(%rax),%edx
    name[3] = '0' + (nfiles % 100) / 10;
    2850:	89 d8                	mov    %ebx,%eax

  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    2852:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    2855:	99                   	cltd   
    2856:	f7 f9                	idiv   %ecx
    2858:	b9 0a 00 00 00       	mov    $0xa,%ecx
    285d:	89 d0                	mov    %edx,%eax
    285f:	99                   	cltd   
    2860:	f7 f9                	idiv   %ecx
    2862:	8d 50 30             	lea    0x30(%rax),%edx
    name[4] = '0' + (nfiles % 10);
    2865:	89 d8                	mov    %ebx,%eax
  for(nfiles = 0; ; nfiles++){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    2867:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    286a:	99                   	cltd   
    286b:	f7 f9                	idiv   %ecx
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    286d:	31 c0                	xor    %eax,%eax
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    286f:	83 c2 30             	add    $0x30,%edx
    2872:	88 55 a4             	mov    %dl,-0x5c(%rbp)
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    2875:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
    2879:	e8 ab 03 00 00       	callq  2c29 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    287e:	48 8d 7d a0          	lea    -0x60(%rbp),%rdi
    2882:	be 02 02 00 00       	mov    $0x202,%esi
    2887:	e8 aa 02 00 00       	callq  2b36 <open>
    if(fd < 0){
    288c:	85 c0                	test   %eax,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    printf(1, "writing %s\n", name);
    int fd = open(name, O_CREATE|O_RDWR);
    288e:	41 89 c5             	mov    %eax,%r13d
    if(fd < 0){
    2891:	78 05                	js     2898 <fsfull+0x9b>
    2893:	45 31 e4             	xor    %r12d,%r12d
    2896:	eb 19                	jmp    28b1 <fsfull+0xb4>
      printf(1, "open %s failed\n", name);
    2898:	48 8d 55 a0          	lea    -0x60(%rbp),%rdx
    289c:	48 c7 c6 a6 45 00 00 	mov    $0x45a6,%rsi
    28a3:	bf 01 00 00 00       	mov    $0x1,%edi
    28a8:	31 c0                	xor    %eax,%eax
    28aa:	e8 7a 03 00 00       	callq  2c29 <printf>
      break;
    28af:	eb 4a                	jmp    28fb <fsfull+0xfe>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
    28b1:	ba 00 02 00 00       	mov    $0x200,%edx
    28b6:	48 c7 c6 00 76 00 00 	mov    $0x7600,%rsi
    28bd:	44 89 ef             	mov    %r13d,%edi
    28c0:	e8 51 02 00 00       	callq  2b16 <write>
      if(cc < 512)
    28c5:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    28ca:	7e 05                	jle    28d1 <fsfull+0xd4>
        break;
      total += cc;
    28cc:	41 01 c4             	add    %eax,%r12d
      fsblocks++;
    }
    28cf:	eb e0                	jmp    28b1 <fsfull+0xb4>
    printf(1, "wrote %d bytes\n", total);
    28d1:	31 c0                	xor    %eax,%eax
    28d3:	44 89 e2             	mov    %r12d,%edx
    28d6:	48 c7 c6 b6 45 00 00 	mov    $0x45b6,%rsi
    28dd:	bf 01 00 00 00       	mov    $0x1,%edi
    28e2:	e8 42 03 00 00       	callq  2c29 <printf>
    close(fd);
    28e7:	44 89 ef             	mov    %r13d,%edi
    28ea:	e8 2f 02 00 00       	callq  2b1e <close>
    if(total == 0)
    28ef:	45 85 e4             	test   %r12d,%r12d
    28f2:	74 07                	je     28fb <fsfull+0xfe>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    28f4:	ff c3                	inc    %ebx
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    28f6:	e9 24 ff ff ff       	jmpq   281f <fsfull+0x22>

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    28fb:	41 bc e8 03 00 00    	mov    $0x3e8,%r12d
    2901:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    2903:	b9 64 00 00 00       	mov    $0x64,%ecx
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    unlink(name);
    2908:	48 8d 7d a0          	lea    -0x60(%rbp),%rdi
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    290c:	99                   	cltd   
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    290d:	c6 45 a0 66          	movb   $0x66,-0x60(%rbp)
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    name[4] = '0' + (nfiles % 10);
    name[5] = '\0';
    2911:	c6 45 a5 00          	movb   $0x0,-0x5b(%rbp)
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    2915:	41 f7 fc             	idiv   %r12d
    2918:	83 c0 30             	add    $0x30,%eax
    291b:	88 45 a1             	mov    %al,-0x5f(%rbp)
    name[2] = '0' + (nfiles % 1000) / 100;
    291e:	89 d0                	mov    %edx,%eax
    2920:	99                   	cltd   
    2921:	f7 f9                	idiv   %ecx
    2923:	8d 50 30             	lea    0x30(%rax),%edx
    name[3] = '0' + (nfiles % 100) / 10;
    2926:	89 d8                	mov    %ebx,%eax

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    2928:	88 55 a2             	mov    %dl,-0x5e(%rbp)
    name[3] = '0' + (nfiles % 100) / 10;
    292b:	99                   	cltd   
    292c:	f7 f9                	idiv   %ecx
    292e:	b9 0a 00 00 00       	mov    $0xa,%ecx
    2933:	89 d0                	mov    %edx,%eax
    2935:	99                   	cltd   
    2936:	f7 f9                	idiv   %ecx
    2938:	8d 50 30             	lea    0x30(%rax),%edx
    name[4] = '0' + (nfiles % 10);
    293b:	89 d8                	mov    %ebx,%eax
    name[5] = '\0';
    unlink(name);
    nfiles--;
    293d:	ff cb                	dec    %ebx
  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    name[1] = '0' + nfiles / 1000;
    name[2] = '0' + (nfiles % 1000) / 100;
    name[3] = '0' + (nfiles % 100) / 10;
    293f:	88 55 a3             	mov    %dl,-0x5d(%rbp)
    name[4] = '0' + (nfiles % 10);
    2942:	99                   	cltd   
    2943:	f7 f9                	idiv   %ecx
    2945:	83 c2 30             	add    $0x30,%edx
    2948:	88 55 a4             	mov    %dl,-0x5c(%rbp)
    name[5] = '\0';
    unlink(name);
    294b:	e8 f6 01 00 00       	callq  2b46 <unlink>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    2950:	83 fb ff             	cmp    $0xffffffff,%ebx
    2953:	75 ac                	jne    2901 <fsfull+0x104>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    2955:	48 c7 c6 c6 45 00 00 	mov    $0x45c6,%rsi
    295c:	bf 01 00 00 00       	mov    $0x1,%edi
    2961:	31 c0                	xor    %eax,%eax
    2963:	e8 c1 02 00 00       	callq  2c29 <printf>
}
    2968:	48 83 c4 48          	add    $0x48,%rsp
    296c:	5b                   	pop    %rbx
    296d:	41 5c                	pop    %r12
    296f:	41 5d                	pop    %r13
    2971:	5d                   	pop    %rbp
    2972:	c3                   	retq   

0000000000002973 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    2973:	48 69 05 02 25 00 00 	imul   $0x19660d,0x2502(%rip),%rax        # 4e80 <randstate>
    297a:	0d 66 19 00 
}

unsigned long randstate = 1;
unsigned int
rand()
{
    297e:	55                   	push   %rbp
    297f:	48 89 e5             	mov    %rsp,%rbp
  randstate = randstate * 1664525 + 1013904223;
  return randstate;
}
    2982:	5d                   	pop    %rbp

unsigned long randstate = 1;
unsigned int
rand()
{
  randstate = randstate * 1664525 + 1013904223;
    2983:	48 05 5f f3 6e 3c    	add    $0x3c6ef35f,%rax
    2989:	48 89 05 f0 24 00 00 	mov    %rax,0x24f0(%rip)        # 4e80 <randstate>
  return randstate;
}
    2990:	c3                   	retq   

0000000000002991 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    2991:	55                   	push   %rbp
    2992:	48 89 f8             	mov    %rdi,%rax
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    2995:	31 d2                	xor    %edx,%edx
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    2997:	48 89 e5             	mov    %rsp,%rbp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    299a:	8a 0c 16             	mov    (%rsi,%rdx,1),%cl
    299d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    29a0:	48 ff c2             	inc    %rdx
    29a3:	84 c9                	test   %cl,%cl
    29a5:	75 f3                	jne    299a <strcpy+0x9>
    ;
  return os;
}
    29a7:	5d                   	pop    %rbp
    29a8:	c3                   	retq   

00000000000029a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    29a9:	55                   	push   %rbp
    29aa:	48 89 e5             	mov    %rsp,%rbp
  while(*p && *p == *q)
    29ad:	0f b6 07             	movzbl (%rdi),%eax
    29b0:	84 c0                	test   %al,%al
    29b2:	74 0c                	je     29c0 <strcmp+0x17>
    29b4:	3a 06                	cmp    (%rsi),%al
    29b6:	75 08                	jne    29c0 <strcmp+0x17>
    p++, q++;
    29b8:	48 ff c7             	inc    %rdi
    29bb:	48 ff c6             	inc    %rsi
    29be:	eb ed                	jmp    29ad <strcmp+0x4>
  return (uchar)*p - (uchar)*q;
    29c0:	0f b6 16             	movzbl (%rsi),%edx
}
    29c3:	5d                   	pop    %rbp
int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
    29c4:	29 d0                	sub    %edx,%eax
}
    29c6:	c3                   	retq   

00000000000029c7 <strlen>:

uint
strlen(const char *s)
{
    29c7:	55                   	push   %rbp
  int n;

  for(n = 0; s[n]; n++)
    29c8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
    29ca:	48 89 e5             	mov    %rsp,%rbp
    29cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  int n;

  for(n = 0; s[n]; n++)
    29d1:	80 7c 17 ff 00       	cmpb   $0x0,-0x1(%rdi,%rdx,1)
    29d6:	74 05                	je     29dd <strlen+0x16>
    29d8:	48 89 d0             	mov    %rdx,%rax
    29db:	eb f0                	jmp    29cd <strlen+0x6>
    ;
  return n;
}
    29dd:	5d                   	pop    %rbp
    29de:	c3                   	retq   

00000000000029df <memset>:

void*
memset(void *dst, int c, uint n)
{
    29df:	55                   	push   %rbp
    29e0:	49 89 f8             	mov    %rdi,%r8
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    29e3:	89 d1                	mov    %edx,%ecx
    29e5:	89 f0                	mov    %esi,%eax
    29e7:	48 89 e5             	mov    %rsp,%rbp
    29ea:	fc                   	cld    
    29eb:	f3 aa                	rep stos %al,%es:(%rdi)
  stosb(dst, c, n);
  return dst;
}
    29ed:	4c 89 c0             	mov    %r8,%rax
    29f0:	5d                   	pop    %rbp
    29f1:	c3                   	retq   

00000000000029f2 <strchr>:

char*
strchr(const char *s, char c)
{
    29f2:	55                   	push   %rbp
    29f3:	48 89 e5             	mov    %rsp,%rbp
  for(; *s; s++)
    29f6:	8a 07                	mov    (%rdi),%al
    29f8:	84 c0                	test   %al,%al
    29fa:	74 0a                	je     2a06 <strchr+0x14>
    if(*s == c)
    29fc:	40 38 f0             	cmp    %sil,%al
    29ff:	74 09                	je     2a0a <strchr+0x18>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    2a01:	48 ff c7             	inc    %rdi
    2a04:	eb f0                	jmp    29f6 <strchr+0x4>
    if(*s == c)
      return (char*)s;
  return 0;
    2a06:	31 c0                	xor    %eax,%eax
    2a08:	eb 03                	jmp    2a0d <strchr+0x1b>
    2a0a:	48 89 f8             	mov    %rdi,%rax
}
    2a0d:	5d                   	pop    %rbp
    2a0e:	c3                   	retq   

0000000000002a0f <gets>:

char*
gets(char *buf, int max)
{
    2a0f:	55                   	push   %rbp
    2a10:	48 89 e5             	mov    %rsp,%rbp
    2a13:	41 57                	push   %r15
    2a15:	41 56                	push   %r14
    2a17:	41 55                	push   %r13
    2a19:	41 54                	push   %r12
    2a1b:	41 89 f7             	mov    %esi,%r15d
    2a1e:	53                   	push   %rbx
    2a1f:	49 89 fc             	mov    %rdi,%r12
    2a22:	49 89 fe             	mov    %rdi,%r14
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2a25:	31 db                	xor    %ebx,%ebx
  return 0;
}

char*
gets(char *buf, int max)
{
    2a27:	48 83 ec 18          	sub    $0x18,%rsp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2a2b:	44 8d 6b 01          	lea    0x1(%rbx),%r13d
    2a2f:	45 39 fd             	cmp    %r15d,%r13d
    2a32:	7d 2c                	jge    2a60 <gets+0x51>
    cc = read(0, &c, 1);
    2a34:	48 8d 75 cf          	lea    -0x31(%rbp),%rsi
    2a38:	31 ff                	xor    %edi,%edi
    2a3a:	ba 01 00 00 00       	mov    $0x1,%edx
    2a3f:	e8 ca 00 00 00       	callq  2b0e <read>
    if(cc < 1)
    2a44:	85 c0                	test   %eax,%eax
    2a46:	7e 18                	jle    2a60 <gets+0x51>
      break;
    buf[i++] = c;
    2a48:	8a 45 cf             	mov    -0x31(%rbp),%al
    2a4b:	49 ff c6             	inc    %r14
    2a4e:	49 63 dd             	movslq %r13d,%rbx
    2a51:	41 88 46 ff          	mov    %al,-0x1(%r14)
    if(c == '\n' || c == '\r')
    2a55:	3c 0a                	cmp    $0xa,%al
    2a57:	74 04                	je     2a5d <gets+0x4e>
    2a59:	3c 0d                	cmp    $0xd,%al
    2a5b:	75 ce                	jne    2a2b <gets+0x1c>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    2a5d:	49 63 dd             	movslq %r13d,%rbx
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    2a60:	41 c6 04 1c 00       	movb   $0x0,(%r12,%rbx,1)
  return buf;
}
    2a65:	48 83 c4 18          	add    $0x18,%rsp
    2a69:	4c 89 e0             	mov    %r12,%rax
    2a6c:	5b                   	pop    %rbx
    2a6d:	41 5c                	pop    %r12
    2a6f:	41 5d                	pop    %r13
    2a71:	41 5e                	pop    %r14
    2a73:	41 5f                	pop    %r15
    2a75:	5d                   	pop    %rbp
    2a76:	c3                   	retq   

0000000000002a77 <stat>:

int
stat(const char *n, struct stat *st)
{
    2a77:	55                   	push   %rbp
    2a78:	48 89 e5             	mov    %rsp,%rbp
    2a7b:	41 54                	push   %r12
    2a7d:	53                   	push   %rbx
    2a7e:	48 89 f3             	mov    %rsi,%rbx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    2a81:	31 f6                	xor    %esi,%esi
    2a83:	e8 ae 00 00 00       	callq  2b36 <open>
    2a88:	41 89 c4             	mov    %eax,%r12d
    2a8b:	83 c8 ff             	or     $0xffffffff,%eax
  if(fd < 0)
    2a8e:	45 85 e4             	test   %r12d,%r12d
    2a91:	78 17                	js     2aaa <stat+0x33>
    return -1;
  r = fstat(fd, st);
    2a93:	48 89 de             	mov    %rbx,%rsi
    2a96:	44 89 e7             	mov    %r12d,%edi
    2a99:	e8 b0 00 00 00       	callq  2b4e <fstat>
  close(fd);
    2a9e:	44 89 e7             	mov    %r12d,%edi
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    2aa1:	89 c3                	mov    %eax,%ebx
  close(fd);
    2aa3:	e8 76 00 00 00       	callq  2b1e <close>
  return r;
    2aa8:	89 d8                	mov    %ebx,%eax
}
    2aaa:	5b                   	pop    %rbx
    2aab:	41 5c                	pop    %r12
    2aad:	5d                   	pop    %rbp
    2aae:	c3                   	retq   

0000000000002aaf <atoi>:

int
atoi(const char *s)
{
    2aaf:	55                   	push   %rbp
  int n;

  n = 0;
    2ab0:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
    2ab2:	48 89 e5             	mov    %rsp,%rbp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    2ab5:	0f be 17             	movsbl (%rdi),%edx
    2ab8:	8d 4a d0             	lea    -0x30(%rdx),%ecx
    2abb:	80 f9 09             	cmp    $0x9,%cl
    2abe:	77 0c                	ja     2acc <atoi+0x1d>
    n = n*10 + *s++ - '0';
    2ac0:	6b c0 0a             	imul   $0xa,%eax,%eax
    2ac3:	48 ff c7             	inc    %rdi
    2ac6:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
    2aca:	eb e9                	jmp    2ab5 <atoi+0x6>
  return n;
}
    2acc:	5d                   	pop    %rbp
    2acd:	c3                   	retq   

0000000000002ace <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    2ace:	55                   	push   %rbp
    2acf:	48 89 f8             	mov    %rdi,%rax
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2ad2:	31 c9                	xor    %ecx,%ecx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
    2ad4:	48 89 e5             	mov    %rsp,%rbp
    2ad7:	89 d7                	mov    %edx,%edi
    2ad9:	29 cf                	sub    %ecx,%edi
  char *dst;
  const char *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    2adb:	85 ff                	test   %edi,%edi
    2add:	7e 0d                	jle    2aec <memmove+0x1e>
    *dst++ = *src++;
    2adf:	40 8a 3c 0e          	mov    (%rsi,%rcx,1),%dil
    2ae3:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
    2ae7:	48 ff c1             	inc    %rcx
    2aea:	eb eb                	jmp    2ad7 <memmove+0x9>
  return vdst;
}
    2aec:	5d                   	pop    %rbp
    2aed:	c3                   	retq   

0000000000002aee <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    2aee:	b8 01 00 00 00       	mov    $0x1,%eax
    2af3:	cd 40                	int    $0x40
    2af5:	c3                   	retq   

0000000000002af6 <exit>:
SYSCALL(exit)
    2af6:	b8 02 00 00 00       	mov    $0x2,%eax
    2afb:	cd 40                	int    $0x40
    2afd:	c3                   	retq   

0000000000002afe <wait>:
SYSCALL(wait)
    2afe:	b8 03 00 00 00       	mov    $0x3,%eax
    2b03:	cd 40                	int    $0x40
    2b05:	c3                   	retq   

0000000000002b06 <pipe>:
SYSCALL(pipe)
    2b06:	b8 04 00 00 00       	mov    $0x4,%eax
    2b0b:	cd 40                	int    $0x40
    2b0d:	c3                   	retq   

0000000000002b0e <read>:
SYSCALL(read)
    2b0e:	b8 05 00 00 00       	mov    $0x5,%eax
    2b13:	cd 40                	int    $0x40
    2b15:	c3                   	retq   

0000000000002b16 <write>:
SYSCALL(write)
    2b16:	b8 10 00 00 00       	mov    $0x10,%eax
    2b1b:	cd 40                	int    $0x40
    2b1d:	c3                   	retq   

0000000000002b1e <close>:
SYSCALL(close)
    2b1e:	b8 15 00 00 00       	mov    $0x15,%eax
    2b23:	cd 40                	int    $0x40
    2b25:	c3                   	retq   

0000000000002b26 <kill>:
SYSCALL(kill)
    2b26:	b8 06 00 00 00       	mov    $0x6,%eax
    2b2b:	cd 40                	int    $0x40
    2b2d:	c3                   	retq   

0000000000002b2e <exec>:
SYSCALL(exec)
    2b2e:	b8 07 00 00 00       	mov    $0x7,%eax
    2b33:	cd 40                	int    $0x40
    2b35:	c3                   	retq   

0000000000002b36 <open>:
SYSCALL(open)
    2b36:	b8 0f 00 00 00       	mov    $0xf,%eax
    2b3b:	cd 40                	int    $0x40
    2b3d:	c3                   	retq   

0000000000002b3e <mknod>:
SYSCALL(mknod)
    2b3e:	b8 11 00 00 00       	mov    $0x11,%eax
    2b43:	cd 40                	int    $0x40
    2b45:	c3                   	retq   

0000000000002b46 <unlink>:
SYSCALL(unlink)
    2b46:	b8 12 00 00 00       	mov    $0x12,%eax
    2b4b:	cd 40                	int    $0x40
    2b4d:	c3                   	retq   

0000000000002b4e <fstat>:
SYSCALL(fstat)
    2b4e:	b8 08 00 00 00       	mov    $0x8,%eax
    2b53:	cd 40                	int    $0x40
    2b55:	c3                   	retq   

0000000000002b56 <link>:
SYSCALL(link)
    2b56:	b8 13 00 00 00       	mov    $0x13,%eax
    2b5b:	cd 40                	int    $0x40
    2b5d:	c3                   	retq   

0000000000002b5e <mkdir>:
SYSCALL(mkdir)
    2b5e:	b8 14 00 00 00       	mov    $0x14,%eax
    2b63:	cd 40                	int    $0x40
    2b65:	c3                   	retq   

0000000000002b66 <chdir>:
SYSCALL(chdir)
    2b66:	b8 09 00 00 00       	mov    $0x9,%eax
    2b6b:	cd 40                	int    $0x40
    2b6d:	c3                   	retq   

0000000000002b6e <dup>:
SYSCALL(dup)
    2b6e:	b8 0a 00 00 00       	mov    $0xa,%eax
    2b73:	cd 40                	int    $0x40
    2b75:	c3                   	retq   

0000000000002b76 <getpid>:
SYSCALL(getpid)
    2b76:	b8 0b 00 00 00       	mov    $0xb,%eax
    2b7b:	cd 40                	int    $0x40
    2b7d:	c3                   	retq   

0000000000002b7e <sbrk>:
SYSCALL(sbrk)
    2b7e:	b8 0c 00 00 00       	mov    $0xc,%eax
    2b83:	cd 40                	int    $0x40
    2b85:	c3                   	retq   

0000000000002b86 <sleep>:
SYSCALL(sleep)
    2b86:	b8 0d 00 00 00       	mov    $0xd,%eax
    2b8b:	cd 40                	int    $0x40
    2b8d:	c3                   	retq   

0000000000002b8e <uptime>:
SYSCALL(uptime)
    2b8e:	b8 0e 00 00 00       	mov    $0xe,%eax
    2b93:	cd 40                	int    $0x40
    2b95:	c3                   	retq   

0000000000002b96 <chmod>:
SYSCALL(chmod)
    2b96:	b8 16 00 00 00       	mov    $0x16,%eax
    2b9b:	cd 40                	int    $0x40
    2b9d:	c3                   	retq   

0000000000002b9e <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    2b9e:	55                   	push   %rbp
    2b9f:	41 89 d0             	mov    %edx,%r8d
    2ba2:	48 89 e5             	mov    %rsp,%rbp
    2ba5:	41 54                	push   %r12
    2ba7:	53                   	push   %rbx
    2ba8:	41 89 fc             	mov    %edi,%r12d
    2bab:	48 83 ec 20          	sub    $0x20,%rsp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    2baf:	85 c9                	test   %ecx,%ecx
    2bb1:	74 12                	je     2bc5 <printint+0x27>
    2bb3:	89 f0                	mov    %esi,%eax
    2bb5:	c1 e8 1f             	shr    $0x1f,%eax
    2bb8:	74 0b                	je     2bc5 <printint+0x27>
    neg = 1;
    x = -xx;
    2bba:	89 f0                	mov    %esi,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    2bbc:	be 01 00 00 00       	mov    $0x1,%esi
    x = -xx;
    2bc1:	f7 d8                	neg    %eax
    2bc3:	eb 04                	jmp    2bc9 <printint+0x2b>
  } else {
    x = xx;
    2bc5:	89 f0                	mov    %esi,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    2bc7:	31 f6                	xor    %esi,%esi
    2bc9:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    2bcd:	31 c9                	xor    %ecx,%ecx
  do{
    buf[i++] = digits[x % base];
    2bcf:	31 d2                	xor    %edx,%edx
    2bd1:	48 ff c7             	inc    %rdi
    2bd4:	8d 59 01             	lea    0x1(%rcx),%ebx
    2bd7:	41 f7 f0             	div    %r8d
    2bda:	89 d2                	mov    %edx,%edx
    2bdc:	8a 92 70 46 00 00    	mov    0x4670(%rdx),%dl
    2be2:	88 57 ff             	mov    %dl,-0x1(%rdi)
  }while((x /= base) != 0);
    2be5:	85 c0                	test   %eax,%eax
    2be7:	74 04                	je     2bed <printint+0x4f>
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    2be9:	89 d9                	mov    %ebx,%ecx
    2beb:	eb e2                	jmp    2bcf <printint+0x31>
  }while((x /= base) != 0);
  if(neg)
    2bed:	85 f6                	test   %esi,%esi
    2bef:	74 0b                	je     2bfc <printint+0x5e>
    buf[i++] = '-';
    2bf1:	48 63 db             	movslq %ebx,%rbx
    2bf4:	c6 44 1d e0 2d       	movb   $0x2d,-0x20(%rbp,%rbx,1)
    2bf9:	8d 59 02             	lea    0x2(%rcx),%ebx

  while(--i >= 0)
    2bfc:	ff cb                	dec    %ebx
    2bfe:	83 fb ff             	cmp    $0xffffffff,%ebx
    2c01:	74 1d                	je     2c20 <printint+0x82>
    putc(fd, buf[i]);
    2c03:	48 63 c3             	movslq %ebx,%rax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2c06:	48 8d 75 df          	lea    -0x21(%rbp),%rsi
    2c0a:	ba 01 00 00 00       	mov    $0x1,%edx
    2c0f:	8a 44 05 e0          	mov    -0x20(%rbp,%rax,1),%al
    2c13:	44 89 e7             	mov    %r12d,%edi
    2c16:	88 45 df             	mov    %al,-0x21(%rbp)
    2c19:	e8 f8 fe ff ff       	callq  2b16 <write>
    2c1e:	eb dc                	jmp    2bfc <printint+0x5e>
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}
    2c20:	48 83 c4 20          	add    $0x20,%rsp
    2c24:	5b                   	pop    %rbx
    2c25:	41 5c                	pop    %r12
    2c27:	5d                   	pop    %rbp
    2c28:	c3                   	retq   

0000000000002c29 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2c29:	55                   	push   %rbp
    2c2a:	48 89 e5             	mov    %rsp,%rbp
    2c2d:	41 56                	push   %r14
    2c2f:	41 55                	push   %r13
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
    2c31:	48 8d 45 10          	lea    0x10(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2c35:	41 54                	push   %r12
    2c37:	53                   	push   %rbx
    2c38:	41 89 fc             	mov    %edi,%r12d
    2c3b:	49 89 f6             	mov    %rsi,%r14
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
    2c3e:	31 db                	xor    %ebx,%ebx
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2c40:	48 83 ec 50          	sub    $0x50,%rsp
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
    2c44:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
    2c48:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    2c4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
    2c50:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    2c54:	4c 89 45 d0          	mov    %r8,-0x30(%rbp)
    2c58:	4c 89 4d d8          	mov    %r9,-0x28(%rbp)
  va_list ap;
  char *s;
  int c, i, state;
  va_start(ap, fmt);
    2c5c:	c7 45 98 10 00 00 00 	movl   $0x10,-0x68(%rbp)
    2c63:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

  state = 0;
  for(i = 0; fmt[i]; i++){
    2c67:	45 8a 2e             	mov    (%r14),%r13b
    2c6a:	45 84 ed             	test   %r13b,%r13b
    2c6d:	0f 84 8f 01 00 00    	je     2e02 <printf+0x1d9>
    c = fmt[i] & 0xff;
    if(state == 0){
    2c73:	85 db                	test   %ebx,%ebx
  int c, i, state;
  va_start(ap, fmt);

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    2c75:	41 0f be d5          	movsbl %r13b,%edx
    2c79:	41 0f b6 c5          	movzbl %r13b,%eax
    if(state == 0){
    2c7d:	75 23                	jne    2ca2 <printf+0x79>
      if(c == '%'){
    2c7f:	83 f8 25             	cmp    $0x25,%eax
    2c82:	0f 84 6d 01 00 00    	je     2df5 <printf+0x1cc>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2c88:	48 8d 75 92          	lea    -0x6e(%rbp),%rsi
    2c8c:	ba 01 00 00 00       	mov    $0x1,%edx
    2c91:	44 89 e7             	mov    %r12d,%edi
    2c94:	44 88 6d 92          	mov    %r13b,-0x6e(%rbp)
    2c98:	e8 79 fe ff ff       	callq  2b16 <write>
    2c9d:	e9 58 01 00 00       	jmpq   2dfa <printf+0x1d1>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    2ca2:	83 fb 25             	cmp    $0x25,%ebx
    2ca5:	0f 85 4f 01 00 00    	jne    2dfa <printf+0x1d1>
      if(c == 'd'){
    2cab:	83 f8 64             	cmp    $0x64,%eax
    2cae:	75 2e                	jne    2cde <printf+0xb5>
        printint(fd, va_arg(ap, int), 10, 1);
    2cb0:	8b 55 98             	mov    -0x68(%rbp),%edx
    2cb3:	83 fa 2f             	cmp    $0x2f,%edx
    2cb6:	77 0e                	ja     2cc6 <printf+0x9d>
    2cb8:	89 d0                	mov    %edx,%eax
    2cba:	83 c2 08             	add    $0x8,%edx
    2cbd:	48 03 45 a8          	add    -0x58(%rbp),%rax
    2cc1:	89 55 98             	mov    %edx,-0x68(%rbp)
    2cc4:	eb 0c                	jmp    2cd2 <printf+0xa9>
    2cc6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
    2cca:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2cce:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
    2cd2:	b9 01 00 00 00       	mov    $0x1,%ecx
    2cd7:	ba 0a 00 00 00       	mov    $0xa,%edx
    2cdc:	eb 34                	jmp    2d12 <printf+0xe9>
      } else if(c == 'x' || c == 'p'){
    2cde:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    2ce4:	83 fa 70             	cmp    $0x70,%edx
    2ce7:	75 38                	jne    2d21 <printf+0xf8>
        printint(fd, va_arg(ap, int), 16, 0);
    2ce9:	8b 55 98             	mov    -0x68(%rbp),%edx
    2cec:	83 fa 2f             	cmp    $0x2f,%edx
    2cef:	77 0e                	ja     2cff <printf+0xd6>
    2cf1:	89 d0                	mov    %edx,%eax
    2cf3:	83 c2 08             	add    $0x8,%edx
    2cf6:	48 03 45 a8          	add    -0x58(%rbp),%rax
    2cfa:	89 55 98             	mov    %edx,-0x68(%rbp)
    2cfd:	eb 0c                	jmp    2d0b <printf+0xe2>
    2cff:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
    2d03:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2d07:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
    2d0b:	31 c9                	xor    %ecx,%ecx
    2d0d:	ba 10 00 00 00       	mov    $0x10,%edx
    2d12:	8b 30                	mov    (%rax),%esi
    2d14:	44 89 e7             	mov    %r12d,%edi
    2d17:	e8 82 fe ff ff       	callq  2b9e <printint>
    2d1c:	e9 d0 00 00 00       	jmpq   2df1 <printf+0x1c8>
      } else if(c == 's'){
    2d21:	83 f8 73             	cmp    $0x73,%eax
    2d24:	75 56                	jne    2d7c <printf+0x153>
        s = va_arg(ap, char*);
    2d26:	8b 55 98             	mov    -0x68(%rbp),%edx
    2d29:	83 fa 2f             	cmp    $0x2f,%edx
    2d2c:	77 0e                	ja     2d3c <printf+0x113>
    2d2e:	89 d0                	mov    %edx,%eax
    2d30:	83 c2 08             	add    $0x8,%edx
    2d33:	48 03 45 a8          	add    -0x58(%rbp),%rax
    2d37:	89 55 98             	mov    %edx,-0x68(%rbp)
    2d3a:	eb 0c                	jmp    2d48 <printf+0x11f>
    2d3c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
    2d40:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2d44:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
    2d48:	48 8b 18             	mov    (%rax),%rbx
        if(s == 0)
          s = "(null)";
    2d4b:	48 c7 c0 60 46 00 00 	mov    $0x4660,%rax
    2d52:	48 85 db             	test   %rbx,%rbx
    2d55:	48 0f 44 d8          	cmove  %rax,%rbx
        while(*s != 0){
    2d59:	8a 03                	mov    (%rbx),%al
    2d5b:	84 c0                	test   %al,%al
    2d5d:	0f 84 8e 00 00 00    	je     2df1 <printf+0x1c8>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2d63:	48 8d 75 93          	lea    -0x6d(%rbp),%rsi
    2d67:	ba 01 00 00 00       	mov    $0x1,%edx
    2d6c:	44 89 e7             	mov    %r12d,%edi
    2d6f:	88 45 93             	mov    %al,-0x6d(%rbp)
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    2d72:	48 ff c3             	inc    %rbx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2d75:	e8 9c fd ff ff       	callq  2b16 <write>
    2d7a:	eb dd                	jmp    2d59 <printf+0x130>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    2d7c:	83 f8 63             	cmp    $0x63,%eax
    2d7f:	75 32                	jne    2db3 <printf+0x18a>
        putc(fd, va_arg(ap, uint));
    2d81:	8b 55 98             	mov    -0x68(%rbp),%edx
    2d84:	83 fa 2f             	cmp    $0x2f,%edx
    2d87:	77 0e                	ja     2d97 <printf+0x16e>
    2d89:	89 d0                	mov    %edx,%eax
    2d8b:	83 c2 08             	add    $0x8,%edx
    2d8e:	48 03 45 a8          	add    -0x58(%rbp),%rax
    2d92:	89 55 98             	mov    %edx,-0x68(%rbp)
    2d95:	eb 0c                	jmp    2da3 <printf+0x17a>
    2d97:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
    2d9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2d9f:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
    2da3:	8b 00                	mov    (%rax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2da5:	ba 01 00 00 00       	mov    $0x1,%edx
    2daa:	48 8d 75 94          	lea    -0x6c(%rbp),%rsi
    2dae:	88 45 94             	mov    %al,-0x6c(%rbp)
    2db1:	eb 36                	jmp    2de9 <printf+0x1c0>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    2db3:	83 f8 25             	cmp    $0x25,%eax
    2db6:	75 0f                	jne    2dc7 <printf+0x19e>
    2db8:	44 88 6d 95          	mov    %r13b,-0x6b(%rbp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    2dbc:	ba 01 00 00 00       	mov    $0x1,%edx
    2dc1:	48 8d 75 95          	lea    -0x6b(%rbp),%rsi
    2dc5:	eb 22                	jmp    2de9 <printf+0x1c0>
    2dc7:	48 8d 75 97          	lea    -0x69(%rbp),%rsi
    2dcb:	ba 01 00 00 00       	mov    $0x1,%edx
    2dd0:	44 89 e7             	mov    %r12d,%edi
    2dd3:	c6 45 97 25          	movb   $0x25,-0x69(%rbp)
    2dd7:	e8 3a fd ff ff       	callq  2b16 <write>
    2ddc:	48 8d 75 96          	lea    -0x6a(%rbp),%rsi
    2de0:	44 88 6d 96          	mov    %r13b,-0x6a(%rbp)
    2de4:	ba 01 00 00 00       	mov    $0x1,%edx
    2de9:	44 89 e7             	mov    %r12d,%edi
    2dec:	e8 25 fd ff ff       	callq  2b16 <write>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    2df1:	31 db                	xor    %ebx,%ebx
    2df3:	eb 05                	jmp    2dfa <printf+0x1d1>
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    2df5:	bb 25 00 00 00       	mov    $0x25,%ebx
    2dfa:	49 ff c6             	inc    %r14
    2dfd:	e9 65 fe ff ff       	jmpq   2c67 <printf+0x3e>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    2e02:	48 83 c4 50          	add    $0x50,%rsp
    2e06:	5b                   	pop    %rbx
    2e07:	41 5c                	pop    %r12
    2e09:	41 5d                	pop    %r13
    2e0b:	41 5e                	pop    %r14
    2e0d:	5d                   	pop    %rbp
    2e0e:	c3                   	retq   

0000000000002e0f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2e0f:	55                   	push   %rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2e10:	48 8b 05 e9 68 00 00 	mov    0x68e9(%rip),%rax        # 9700 <freep>
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2e17:	48 8d 57 f0          	lea    -0x10(%rdi),%rdx
static Header base;
static Header *freep;

void
free(void *ap)
{
    2e1b:	48 89 e5             	mov    %rsp,%rbp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2e1e:	48 39 d0             	cmp    %rdx,%rax
    2e21:	48 8b 08             	mov    (%rax),%rcx
    2e24:	72 14                	jb     2e3a <free+0x2b>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2e26:	48 39 c8             	cmp    %rcx,%rax
    2e29:	72 0a                	jb     2e35 <free+0x26>
    2e2b:	48 39 ca             	cmp    %rcx,%rdx
    2e2e:	72 0f                	jb     2e3f <free+0x30>
    2e30:	48 39 d0             	cmp    %rdx,%rax
    2e33:	72 0a                	jb     2e3f <free+0x30>
static Header base;
static Header *freep;

void
free(void *ap)
{
    2e35:	48 89 c8             	mov    %rcx,%rax
    2e38:	eb e4                	jmp    2e1e <free+0xf>
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2e3a:	48 39 ca             	cmp    %rcx,%rdx
    2e3d:	73 e7                	jae    2e26 <free+0x17>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    2e3f:	8b 77 f8             	mov    -0x8(%rdi),%esi
    2e42:	49 89 f0             	mov    %rsi,%r8
    2e45:	48 c1 e6 04          	shl    $0x4,%rsi
    2e49:	48 01 d6             	add    %rdx,%rsi
    2e4c:	48 39 ce             	cmp    %rcx,%rsi
    2e4f:	75 0e                	jne    2e5f <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    2e51:	44 03 41 08          	add    0x8(%rcx),%r8d
    2e55:	44 89 47 f8          	mov    %r8d,-0x8(%rdi)
    bp->s.ptr = p->s.ptr->s.ptr;
    2e59:	48 8b 08             	mov    (%rax),%rcx
    2e5c:	48 8b 09             	mov    (%rcx),%rcx
  } else
    bp->s.ptr = p->s.ptr;
    2e5f:	48 89 4f f0          	mov    %rcx,-0x10(%rdi)
  if(p + p->s.size == bp){
    2e63:	8b 48 08             	mov    0x8(%rax),%ecx
    2e66:	48 89 ce             	mov    %rcx,%rsi
    2e69:	48 c1 e1 04          	shl    $0x4,%rcx
    2e6d:	48 01 c1             	add    %rax,%rcx
    2e70:	48 39 ca             	cmp    %rcx,%rdx
    2e73:	75 0a                	jne    2e7f <free+0x70>
    p->s.size += bp->s.size;
    2e75:	03 77 f8             	add    -0x8(%rdi),%esi
    2e78:	89 70 08             	mov    %esi,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    2e7b:	48 8b 57 f0          	mov    -0x10(%rdi),%rdx
  } else
    p->s.ptr = bp;
    2e7f:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2e82:	48 89 05 77 68 00 00 	mov    %rax,0x6877(%rip)        # 9700 <freep>
}
    2e89:	5d                   	pop    %rbp
    2e8a:	c3                   	retq   

0000000000002e8b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    2e8b:	55                   	push   %rbp
    2e8c:	48 89 e5             	mov    %rsp,%rbp
    2e8f:	41 55                	push   %r13
    2e91:	41 54                	push   %r12
    2e93:	53                   	push   %rbx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2e94:	89 fb                	mov    %edi,%ebx
  return freep;
}

void*
malloc(uint nbytes)
{
    2e96:	51                   	push   %rcx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    2e97:	48 8b 0d 62 68 00 00 	mov    0x6862(%rip),%rcx        # 9700 <freep>
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2e9e:	48 83 c3 0f          	add    $0xf,%rbx
    2ea2:	48 c1 eb 04          	shr    $0x4,%rbx
    2ea6:	ff c3                	inc    %ebx
  if((prevp = freep) == 0){
    2ea8:	48 85 c9             	test   %rcx,%rcx
    2eab:	75 27                	jne    2ed4 <malloc+0x49>
    base.s.ptr = freep = prevp = &base;
    2ead:	48 c7 05 48 68 00 00 	movq   $0x9710,0x6848(%rip)        # 9700 <freep>
    2eb4:	10 97 00 00 
    2eb8:	48 c7 05 4d 68 00 00 	movq   $0x9710,0x684d(%rip)        # 9710 <base>
    2ebf:	10 97 00 00 
    2ec3:	48 c7 c1 10 97 00 00 	mov    $0x9710,%rcx
    base.s.size = 0;
    2eca:	c7 05 44 68 00 00 00 	movl   $0x0,0x6844(%rip)        # 9718 <base+0x8>
    2ed1:	00 00 00 
    2ed4:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    2eda:	41 bc 00 10 00 00    	mov    $0x1000,%r12d
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2ee0:	48 8b 01             	mov    (%rcx),%rax
    2ee3:	44 0f 43 e3          	cmovae %ebx,%r12d
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    2ee7:	45 89 e5             	mov    %r12d,%r13d
    2eea:	41 c1 e5 04          	shl    $0x4,%r13d
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    2eee:	8b 50 08             	mov    0x8(%rax),%edx
    2ef1:	39 d3                	cmp    %edx,%ebx
    2ef3:	77 26                	ja     2f1b <malloc+0x90>
      if(p->s.size == nunits)
    2ef5:	75 08                	jne    2eff <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
    2ef7:	48 8b 10             	mov    (%rax),%rdx
    2efa:	48 89 11             	mov    %rdx,(%rcx)
    2efd:	eb 0f                	jmp    2f0e <malloc+0x83>
      else {
        p->s.size -= nunits;
    2eff:	29 da                	sub    %ebx,%edx
    2f01:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2f04:	48 c1 e2 04          	shl    $0x4,%rdx
    2f08:	48 01 d0             	add    %rdx,%rax
        p->s.size = nunits;
    2f0b:	89 58 08             	mov    %ebx,0x8(%rax)
      }
      freep = prevp;
    2f0e:	48 89 0d eb 67 00 00 	mov    %rcx,0x67eb(%rip)        # 9700 <freep>
      return (void*)(p + 1);
    2f15:	48 83 c0 10          	add    $0x10,%rax
    2f19:	eb 3a                	jmp    2f55 <malloc+0xca>
    }
    if(p == freep)
    2f1b:	48 3b 05 de 67 00 00 	cmp    0x67de(%rip),%rax        # 9700 <freep>
    2f22:	75 27                	jne    2f4b <malloc+0xc0>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    2f24:	44 89 ef             	mov    %r13d,%edi
    2f27:	e8 52 fc ff ff       	callq  2b7e <sbrk>
  if(p == (char*)-1)
    2f2c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
    2f30:	74 21                	je     2f53 <malloc+0xc8>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
    2f32:	48 8d 78 10          	lea    0x10(%rax),%rdi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    2f36:	44 89 60 08          	mov    %r12d,0x8(%rax)
  free((void*)(hp + 1));
    2f3a:	e8 d0 fe ff ff       	callq  2e0f <free>
  return freep;
    2f3f:	48 8b 05 ba 67 00 00 	mov    0x67ba(%rip),%rax        # 9700 <freep>
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    2f46:	48 85 c0             	test   %rax,%rax
    2f49:	74 08                	je     2f53 <malloc+0xc8>
        return 0;
  }
    2f4b:	48 89 c1             	mov    %rax,%rcx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2f4e:	48 8b 00             	mov    (%rax),%rax
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    2f51:	eb 9b                	jmp    2eee <malloc+0x63>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
    2f53:	31 c0                	xor    %eax,%eax
  }
}
    2f55:	5a                   	pop    %rdx
    2f56:	5b                   	pop    %rbx
    2f57:	41 5c                	pop    %r12
    2f59:	41 5d                	pop    %r13
    2f5b:	5d                   	pop    %rbp
    2f5c:	c3                   	retq   
