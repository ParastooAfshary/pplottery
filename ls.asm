
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2b6000ef          	jal	2c2 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	28e000ef          	jal	2c2 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	270000ef          	jal	2c2 <strlen>
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3be000ef          	jal	424 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	256000ef          	jal	2c2 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	24c000ef          	jal	2c2 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	260000ef          	jal	2ec <memset>
  return buf;
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	49a000ef          	jal	548 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	d9840593          	addi	a1,s0,-616
  c0:	4a0000ef          	jal	560 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a3050513          	addi	a0,a0,-1488 # b20 <malloc+0x12c>
  f8:	049000ef          	jal	940 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	432000ef          	jal	530 <close>
 102:	25813483          	ld	s1,600(sp)
}
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	9d658593          	addi	a1,a1,-1578 # af0 <malloc+0xfc>
 122:	4509                	li	a0,2
 124:	7f2000ef          	jal	916 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9dc58593          	addi	a1,a1,-1572 # b08 <malloc+0x114>
 134:	4509                	li	a0,2
 136:	7e0000ef          	jal	916 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3f4000ef          	jal	530 <close>
    return;
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	17a000ef          	jal	2c2 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	9da50513          	addi	a0,a0,-1574 # b30 <malloc+0x13c>
 15e:	7e2000ef          	jal	940 <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	104000ef          	jal	27a <strcpy>
    p = buf+strlen(buf);
 17a:	dc040513          	addi	a0,s0,-576
 17e:	144000ef          	jal	2c2 <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19a:	00001a17          	auipc	s4,0x1
 19e:	986a0a13          	addi	s4,s4,-1658 # b20 <malloc+0x12c>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	966a8a93          	addi	s5,s5,-1690 # b08 <malloc+0x114>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	78e000ef          	jal	940 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	362000ef          	jal	520 <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
      if(de.inum == 0)
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	24e000ef          	jal	424 <memmove>
      p[DIRSIZ] = 0;
 1da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	1bc000ef          	jal	3a2 <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	73a000ef          	jal	940 <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 222:	4785                	li	a5,1
 224:	02a7d763          	bge	a5,a0,252 <main+0x38>
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	02091793          	slli	a5,s2,0x20
 238:	01d7d913          	srli	s2,a5,0x1d
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	2ba000ef          	jal	508 <exit>
 252:	e426                	sd	s1,8(sp)
 254:	e04a                	sd	s2,0(sp)
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	8f250513          	addi	a0,a0,-1806 # b48 <malloc+0x154>
 25e:	e3bff0ef          	jal	98 <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	2a4000ef          	jal	508 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fabff0ef          	jal	21a <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	292000ef          	jal	508 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cf91                	beqz	a5,2e8 <strlen+0x26>
 2ce:	0505                	addi	a0,a0,1
 2d0:	87aa                	mv	a5,a0
 2d2:	86be                	mv	a3,a5
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff7c703          	lbu	a4,-1(a5)
 2da:	ff65                	bnez	a4,2d2 <strlen+0x10>
 2dc:	40a6853b          	subw	a0,a3,a0
 2e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  for(n = 0; s[n]; n++)
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strlen+0x20>

00000000000002ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ca19                	beqz	a2,308 <memset+0x1c>
 2f4:	87aa                	mv	a5,a0
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x12>
  }
  return dst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb99                	beqz	a5,32e <strchr+0x20>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1a>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xc>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strchr+0x1a>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 350:	4aa9                	li	s5,10
 352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	2485                	addiw	s1,s1,1
 358:	0344d663          	bge	s1,s4,384 <gets+0x52>
    cc = read(0, &c, 1);
 35c:	4605                	li	a2,1
 35e:	faf40593          	addi	a1,s0,-81
 362:	4501                	li	a0,0
 364:	1bc000ef          	jal	520 <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x52>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x50>
 378:	0905                	addi	s2,s2,1
 37a:	fd679de3          	bne	a5,s6,354 <gets+0x22>
    buf[i++] = c;
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x52>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e04a                	sd	s2,0(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ae:	4581                	li	a1,0
 3b0:	198000ef          	jal	548 <open>
  if(fd < 0)
 3b4:	02054263          	bltz	a0,3d8 <stat+0x36>
 3b8:	e426                	sd	s1,8(sp)
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	1a2000ef          	jal	560 <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	16a000ef          	jal	530 <close>
  return r;
 3ca:	64a2                	ld	s1,8(sp)
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6902                	ld	s2,0(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret
    return -1;
 3d8:	597d                	li	s2,-1
 3da:	bfcd                	j	3cc <stat+0x2a>

00000000000003dc <atoi>:

int
atoi(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054683          	lbu	a3,0(a0)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	4625                	li	a2,9
 3f0:	02f66863          	bltu	a2,a5,420 <atoi+0x44>
 3f4:	872a                	mv	a4,a0
  n = 0;
 3f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f8:	0705                	addi	a4,a4,1
 3fa:	0025179b          	slliw	a5,a0,0x2
 3fe:	9fa9                	addw	a5,a5,a0
 400:	0017979b          	slliw	a5,a5,0x1
 404:	9fb5                	addw	a5,a5,a3
 406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40a:	00074683          	lbu	a3,0(a4)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	fef671e3          	bgeu	a2,a5,3f8 <atoi+0x1c>
  return n;
}
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret
  n = 0;
 420:	4501                	li	a0,0
 422:	bfe5                	j	41a <atoi+0x3e>

0000000000000424 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42a:	02b57463          	bgeu	a0,a1,452 <memmove+0x2e>
    while(n-- > 0)
 42e:	00c05f63          	blez	a2,44c <memmove+0x28>
 432:	1602                	slli	a2,a2,0x20
 434:	9201                	srli	a2,a2,0x20
 436:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fef71ae3          	bne	a4,a5,43c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x28>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x46>
 47a:	bfc9                	j	44c <memmove+0x28>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f67ff0ef          	jal	424 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 4d0:	ce11                	beqz	a2,4ec <strncmp+0x22>
 4d2:	00054783          	lbu	a5,0(a0)
 4d6:	cf89                	beqz	a5,4f0 <strncmp+0x26>
 4d8:	0005c703          	lbu	a4,0(a1)
 4dc:	00f71a63          	bne	a4,a5,4f0 <strncmp+0x26>
    n--, p++, q++;
 4e0:	367d                	addiw	a2,a2,-1
 4e2:	0505                	addi	a0,a0,1
 4e4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 4e6:	f675                	bnez	a2,4d2 <strncmp+0x8>
  if(n == 0)
    return 0;
 4e8:	4501                	li	a0,0
 4ea:	a801                	j	4fa <strncmp+0x30>
 4ec:	4501                	li	a0,0
 4ee:	a031                	j	4fa <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 4f0:	00054503          	lbu	a0,0(a0)
 4f4:	0005c783          	lbu	a5,0(a1)
 4f8:	9d1d                	subw	a0,a0,a5
}
 4fa:	6422                	ld	s0,8(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 500:	4885                	li	a7,1
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <exit>:
.global exit
exit:
 li a7, SYS_exit
 508:	4889                	li	a7,2
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <wait>:
.global wait
wait:
 li a7, SYS_wait
 510:	488d                	li	a7,3
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 518:	4891                	li	a7,4
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <read>:
.global read
read:
 li a7, SYS_read
 520:	4895                	li	a7,5
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <write>:
.global write
write:
 li a7, SYS_write
 528:	48c1                	li	a7,16
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <close>:
.global close
close:
 li a7, SYS_close
 530:	48d5                	li	a7,21
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <kill>:
.global kill
kill:
 li a7, SYS_kill
 538:	4899                	li	a7,6
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <exec>:
.global exec
exec:
 li a7, SYS_exec
 540:	489d                	li	a7,7
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <open>:
.global open
open:
 li a7, SYS_open
 548:	48bd                	li	a7,15
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 550:	48c5                	li	a7,17
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 558:	48c9                	li	a7,18
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 560:	48a1                	li	a7,8
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <link>:
.global link
link:
 li a7, SYS_link
 568:	48cd                	li	a7,19
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 570:	48d1                	li	a7,20
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 578:	48a5                	li	a7,9
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <dup>:
.global dup
dup:
 li a7, SYS_dup
 580:	48a9                	li	a7,10
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 588:	48ad                	li	a7,11
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 590:	48b1                	li	a7,12
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 598:	48b5                	li	a7,13
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a0:	48b9                	li	a7,14
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <thread>:
.global thread
thread:
 li a7, SYS_thread
 5a8:	48dd                	li	a7,23
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 5b0:	48e1                	li	a7,24
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 5b8:	48d9                	li	a7,22
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 5c0:	48dd                	li	a7,23
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c8:	1101                	addi	sp,sp,-32
 5ca:	ec06                	sd	ra,24(sp)
 5cc:	e822                	sd	s0,16(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d4:	4605                	li	a2,1
 5d6:	fef40593          	addi	a1,s0,-17
 5da:	f4fff0ef          	jal	528 <write>
}
 5de:	60e2                	ld	ra,24(sp)
 5e0:	6442                	ld	s0,16(sp)
 5e2:	6105                	addi	sp,sp,32
 5e4:	8082                	ret

00000000000005e6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e6:	715d                	addi	sp,sp,-80
 5e8:	e486                	sd	ra,72(sp)
 5ea:	e0a2                	sd	s0,64(sp)
 5ec:	fc26                	sd	s1,56(sp)
 5ee:	0880                	addi	s0,sp,80
 5f0:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f2:	c299                	beqz	a3,5f8 <printint+0x12>
 5f4:	0805c963          	bltz	a1,686 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f8:	2581                	sext.w	a1,a1
  neg = 0;
 5fa:	4881                	li	a7,0
 5fc:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 600:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 602:	2601                	sext.w	a2,a2
 604:	00000517          	auipc	a0,0x0
 608:	55450513          	addi	a0,a0,1364 # b58 <digits>
 60c:	883a                	mv	a6,a4
 60e:	2705                	addiw	a4,a4,1
 610:	02c5f7bb          	remuw	a5,a1,a2
 614:	1782                	slli	a5,a5,0x20
 616:	9381                	srli	a5,a5,0x20
 618:	97aa                	add	a5,a5,a0
 61a:	0007c783          	lbu	a5,0(a5)
 61e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 622:	0005879b          	sext.w	a5,a1
 626:	02c5d5bb          	divuw	a1,a1,a2
 62a:	0685                	addi	a3,a3,1
 62c:	fec7f0e3          	bgeu	a5,a2,60c <printint+0x26>
  if(neg)
 630:	00088c63          	beqz	a7,648 <printint+0x62>
    buf[i++] = '-';
 634:	fd070793          	addi	a5,a4,-48
 638:	00878733          	add	a4,a5,s0
 63c:	02d00793          	li	a5,45
 640:	fef70423          	sb	a5,-24(a4)
 644:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 648:	02e05a63          	blez	a4,67c <printint+0x96>
 64c:	f84a                	sd	s2,48(sp)
 64e:	f44e                	sd	s3,40(sp)
 650:	fb840793          	addi	a5,s0,-72
 654:	00e78933          	add	s2,a5,a4
 658:	fff78993          	addi	s3,a5,-1
 65c:	99ba                	add	s3,s3,a4
 65e:	377d                	addiw	a4,a4,-1
 660:	1702                	slli	a4,a4,0x20
 662:	9301                	srli	a4,a4,0x20
 664:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 668:	fff94583          	lbu	a1,-1(s2)
 66c:	8526                	mv	a0,s1
 66e:	f5bff0ef          	jal	5c8 <putc>
  while(--i >= 0)
 672:	197d                	addi	s2,s2,-1
 674:	ff391ae3          	bne	s2,s3,668 <printint+0x82>
 678:	7942                	ld	s2,48(sp)
 67a:	79a2                	ld	s3,40(sp)
}
 67c:	60a6                	ld	ra,72(sp)
 67e:	6406                	ld	s0,64(sp)
 680:	74e2                	ld	s1,56(sp)
 682:	6161                	addi	sp,sp,80
 684:	8082                	ret
    x = -xx;
 686:	40b005bb          	negw	a1,a1
    neg = 1;
 68a:	4885                	li	a7,1
    x = -xx;
 68c:	bf85                	j	5fc <printint+0x16>

000000000000068e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 68e:	711d                	addi	sp,sp,-96
 690:	ec86                	sd	ra,88(sp)
 692:	e8a2                	sd	s0,80(sp)
 694:	e0ca                	sd	s2,64(sp)
 696:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 698:	0005c903          	lbu	s2,0(a1)
 69c:	26090863          	beqz	s2,90c <vprintf+0x27e>
 6a0:	e4a6                	sd	s1,72(sp)
 6a2:	fc4e                	sd	s3,56(sp)
 6a4:	f852                	sd	s4,48(sp)
 6a6:	f456                	sd	s5,40(sp)
 6a8:	f05a                	sd	s6,32(sp)
 6aa:	ec5e                	sd	s7,24(sp)
 6ac:	e862                	sd	s8,16(sp)
 6ae:	e466                	sd	s9,8(sp)
 6b0:	8b2a                	mv	s6,a0
 6b2:	8a2e                	mv	s4,a1
 6b4:	8bb2                	mv	s7,a2
  state = 0;
 6b6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6b8:	4481                	li	s1,0
 6ba:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6c0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6c4:	06c00c93          	li	s9,108
 6c8:	a005                	j	6e8 <vprintf+0x5a>
        putc(fd, c0);
 6ca:	85ca                	mv	a1,s2
 6cc:	855a                	mv	a0,s6
 6ce:	efbff0ef          	jal	5c8 <putc>
 6d2:	a019                	j	6d8 <vprintf+0x4a>
    } else if(state == '%'){
 6d4:	03598263          	beq	s3,s5,6f8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6d8:	2485                	addiw	s1,s1,1
 6da:	8726                	mv	a4,s1
 6dc:	009a07b3          	add	a5,s4,s1
 6e0:	0007c903          	lbu	s2,0(a5)
 6e4:	20090c63          	beqz	s2,8fc <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6e8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ec:	fe0994e3          	bnez	s3,6d4 <vprintf+0x46>
      if(c0 == '%'){
 6f0:	fd579de3          	bne	a5,s5,6ca <vprintf+0x3c>
        state = '%';
 6f4:	89be                	mv	s3,a5
 6f6:	b7cd                	j	6d8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6f8:	00ea06b3          	add	a3,s4,a4
 6fc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 700:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 702:	c681                	beqz	a3,70a <vprintf+0x7c>
 704:	9752                	add	a4,a4,s4
 706:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 70a:	03878f63          	beq	a5,s8,748 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 70e:	05978963          	beq	a5,s9,760 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 712:	07500713          	li	a4,117
 716:	0ee78363          	beq	a5,a4,7fc <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 71a:	07800713          	li	a4,120
 71e:	12e78563          	beq	a5,a4,848 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 722:	07000713          	li	a4,112
 726:	14e78a63          	beq	a5,a4,87a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 72a:	07300713          	li	a4,115
 72e:	18e78a63          	beq	a5,a4,8c2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 732:	02500713          	li	a4,37
 736:	04e79563          	bne	a5,a4,780 <vprintf+0xf2>
        putc(fd, '%');
 73a:	02500593          	li	a1,37
 73e:	855a                	mv	a0,s6
 740:	e89ff0ef          	jal	5c8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 744:	4981                	li	s3,0
 746:	bf49                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 748:	008b8913          	addi	s2,s7,8
 74c:	4685                	li	a3,1
 74e:	4629                	li	a2,10
 750:	000ba583          	lw	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	e91ff0ef          	jal	5e6 <printint>
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bfad                	j	6d8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 760:	06400793          	li	a5,100
 764:	02f68963          	beq	a3,a5,796 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 768:	06c00793          	li	a5,108
 76c:	04f68263          	beq	a3,a5,7b0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 770:	07500793          	li	a5,117
 774:	0af68063          	beq	a3,a5,814 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 778:	07800793          	li	a5,120
 77c:	0ef68263          	beq	a3,a5,860 <vprintf+0x1d2>
        putc(fd, '%');
 780:	02500593          	li	a1,37
 784:	855a                	mv	a0,s6
 786:	e43ff0ef          	jal	5c8 <putc>
        putc(fd, c0);
 78a:	85ca                	mv	a1,s2
 78c:	855a                	mv	a0,s6
 78e:	e3bff0ef          	jal	5c8 <putc>
      state = 0;
 792:	4981                	li	s3,0
 794:	b791                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 796:	008b8913          	addi	s2,s7,8
 79a:	4685                	li	a3,1
 79c:	4629                	li	a2,10
 79e:	000bb583          	ld	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e43ff0ef          	jal	5e6 <printint>
        i += 1;
 7a8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
        i += 1;
 7ae:	b72d                	j	6d8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7b0:	06400793          	li	a5,100
 7b4:	02f60763          	beq	a2,a5,7e2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b8:	07500793          	li	a5,117
 7bc:	06f60963          	beq	a2,a5,82e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c0:	07800793          	li	a5,120
 7c4:	faf61ee3          	bne	a2,a5,780 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c8:	008b8913          	addi	s2,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4641                	li	a2,16
 7d0:	000bb583          	ld	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	e11ff0ef          	jal	5e6 <printint>
        i += 2;
 7da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
        i += 2;
 7e0:	bde5                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4685                	li	a3,1
 7e8:	4629                	li	a2,10
 7ea:	000bb583          	ld	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	df7ff0ef          	jal	5e6 <printint>
        i += 2;
 7f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7f6:	8bca                	mv	s7,s2
      state = 0;
 7f8:	4981                	li	s3,0
        i += 2;
 7fa:	bdf9                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7fc:	008b8913          	addi	s2,s7,8
 800:	4681                	li	a3,0
 802:	4629                	li	a2,10
 804:	000ba583          	lw	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	dddff0ef          	jal	5e6 <printint>
 80e:	8bca                	mv	s7,s2
      state = 0;
 810:	4981                	li	s3,0
 812:	b5d9                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 814:	008b8913          	addi	s2,s7,8
 818:	4681                	li	a3,0
 81a:	4629                	li	a2,10
 81c:	000bb583          	ld	a1,0(s7)
 820:	855a                	mv	a0,s6
 822:	dc5ff0ef          	jal	5e6 <printint>
        i += 1;
 826:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 828:	8bca                	mv	s7,s2
      state = 0;
 82a:	4981                	li	s3,0
        i += 1;
 82c:	b575                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 82e:	008b8913          	addi	s2,s7,8
 832:	4681                	li	a3,0
 834:	4629                	li	a2,10
 836:	000bb583          	ld	a1,0(s7)
 83a:	855a                	mv	a0,s6
 83c:	dabff0ef          	jal	5e6 <printint>
        i += 2;
 840:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 842:	8bca                	mv	s7,s2
      state = 0;
 844:	4981                	li	s3,0
        i += 2;
 846:	bd49                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 848:	008b8913          	addi	s2,s7,8
 84c:	4681                	li	a3,0
 84e:	4641                	li	a2,16
 850:	000ba583          	lw	a1,0(s7)
 854:	855a                	mv	a0,s6
 856:	d91ff0ef          	jal	5e6 <printint>
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
 85e:	bdad                	j	6d8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 860:	008b8913          	addi	s2,s7,8
 864:	4681                	li	a3,0
 866:	4641                	li	a2,16
 868:	000bb583          	ld	a1,0(s7)
 86c:	855a                	mv	a0,s6
 86e:	d79ff0ef          	jal	5e6 <printint>
        i += 1;
 872:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 874:	8bca                	mv	s7,s2
      state = 0;
 876:	4981                	li	s3,0
        i += 1;
 878:	b585                	j	6d8 <vprintf+0x4a>
 87a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 87c:	008b8d13          	addi	s10,s7,8
 880:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 884:	03000593          	li	a1,48
 888:	855a                	mv	a0,s6
 88a:	d3fff0ef          	jal	5c8 <putc>
  putc(fd, 'x');
 88e:	07800593          	li	a1,120
 892:	855a                	mv	a0,s6
 894:	d35ff0ef          	jal	5c8 <putc>
 898:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 89a:	00000b97          	auipc	s7,0x0
 89e:	2beb8b93          	addi	s7,s7,702 # b58 <digits>
 8a2:	03c9d793          	srli	a5,s3,0x3c
 8a6:	97de                	add	a5,a5,s7
 8a8:	0007c583          	lbu	a1,0(a5)
 8ac:	855a                	mv	a0,s6
 8ae:	d1bff0ef          	jal	5c8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8b2:	0992                	slli	s3,s3,0x4
 8b4:	397d                	addiw	s2,s2,-1
 8b6:	fe0916e3          	bnez	s2,8a2 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 8ba:	8bea                	mv	s7,s10
      state = 0;
 8bc:	4981                	li	s3,0
 8be:	6d02                	ld	s10,0(sp)
 8c0:	bd21                	j	6d8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8c2:	008b8993          	addi	s3,s7,8
 8c6:	000bb903          	ld	s2,0(s7)
 8ca:	00090f63          	beqz	s2,8e8 <vprintf+0x25a>
        for(; *s; s++)
 8ce:	00094583          	lbu	a1,0(s2)
 8d2:	c195                	beqz	a1,8f6 <vprintf+0x268>
          putc(fd, *s);
 8d4:	855a                	mv	a0,s6
 8d6:	cf3ff0ef          	jal	5c8 <putc>
        for(; *s; s++)
 8da:	0905                	addi	s2,s2,1
 8dc:	00094583          	lbu	a1,0(s2)
 8e0:	f9f5                	bnez	a1,8d4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8e2:	8bce                	mv	s7,s3
      state = 0;
 8e4:	4981                	li	s3,0
 8e6:	bbcd                	j	6d8 <vprintf+0x4a>
          s = "(null)";
 8e8:	00000917          	auipc	s2,0x0
 8ec:	26890913          	addi	s2,s2,616 # b50 <malloc+0x15c>
        for(; *s; s++)
 8f0:	02800593          	li	a1,40
 8f4:	b7c5                	j	8d4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8f6:	8bce                	mv	s7,s3
      state = 0;
 8f8:	4981                	li	s3,0
 8fa:	bbf9                	j	6d8 <vprintf+0x4a>
 8fc:	64a6                	ld	s1,72(sp)
 8fe:	79e2                	ld	s3,56(sp)
 900:	7a42                	ld	s4,48(sp)
 902:	7aa2                	ld	s5,40(sp)
 904:	7b02                	ld	s6,32(sp)
 906:	6be2                	ld	s7,24(sp)
 908:	6c42                	ld	s8,16(sp)
 90a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 90c:	60e6                	ld	ra,88(sp)
 90e:	6446                	ld	s0,80(sp)
 910:	6906                	ld	s2,64(sp)
 912:	6125                	addi	sp,sp,96
 914:	8082                	ret

0000000000000916 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 916:	715d                	addi	sp,sp,-80
 918:	ec06                	sd	ra,24(sp)
 91a:	e822                	sd	s0,16(sp)
 91c:	1000                	addi	s0,sp,32
 91e:	e010                	sd	a2,0(s0)
 920:	e414                	sd	a3,8(s0)
 922:	e818                	sd	a4,16(s0)
 924:	ec1c                	sd	a5,24(s0)
 926:	03043023          	sd	a6,32(s0)
 92a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 92e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 932:	8622                	mv	a2,s0
 934:	d5bff0ef          	jal	68e <vprintf>
}
 938:	60e2                	ld	ra,24(sp)
 93a:	6442                	ld	s0,16(sp)
 93c:	6161                	addi	sp,sp,80
 93e:	8082                	ret

0000000000000940 <printf>:

void
printf(const char *fmt, ...)
{
 940:	711d                	addi	sp,sp,-96
 942:	ec06                	sd	ra,24(sp)
 944:	e822                	sd	s0,16(sp)
 946:	1000                	addi	s0,sp,32
 948:	e40c                	sd	a1,8(s0)
 94a:	e810                	sd	a2,16(s0)
 94c:	ec14                	sd	a3,24(s0)
 94e:	f018                	sd	a4,32(s0)
 950:	f41c                	sd	a5,40(s0)
 952:	03043823          	sd	a6,48(s0)
 956:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 95a:	00840613          	addi	a2,s0,8
 95e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 962:	85aa                	mv	a1,a0
 964:	4505                	li	a0,1
 966:	d29ff0ef          	jal	68e <vprintf>
}
 96a:	60e2                	ld	ra,24(sp)
 96c:	6442                	ld	s0,16(sp)
 96e:	6125                	addi	sp,sp,96
 970:	8082                	ret

0000000000000972 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 972:	1141                	addi	sp,sp,-16
 974:	e422                	sd	s0,8(sp)
 976:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 978:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97c:	00000797          	auipc	a5,0x0
 980:	6847b783          	ld	a5,1668(a5) # 1000 <freep>
 984:	a02d                	j	9ae <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 986:	4618                	lw	a4,8(a2)
 988:	9f2d                	addw	a4,a4,a1
 98a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 98e:	6398                	ld	a4,0(a5)
 990:	6310                	ld	a2,0(a4)
 992:	a83d                	j	9d0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 994:	ff852703          	lw	a4,-8(a0)
 998:	9f31                	addw	a4,a4,a2
 99a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 99c:	ff053683          	ld	a3,-16(a0)
 9a0:	a091                	j	9e4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a2:	6398                	ld	a4,0(a5)
 9a4:	00e7e463          	bltu	a5,a4,9ac <free+0x3a>
 9a8:	00e6ea63          	bltu	a3,a4,9bc <free+0x4a>
{
 9ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ae:	fed7fae3          	bgeu	a5,a3,9a2 <free+0x30>
 9b2:	6398                	ld	a4,0(a5)
 9b4:	00e6e463          	bltu	a3,a4,9bc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b8:	fee7eae3          	bltu	a5,a4,9ac <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9bc:	ff852583          	lw	a1,-8(a0)
 9c0:	6390                	ld	a2,0(a5)
 9c2:	02059813          	slli	a6,a1,0x20
 9c6:	01c85713          	srli	a4,a6,0x1c
 9ca:	9736                	add	a4,a4,a3
 9cc:	fae60de3          	beq	a2,a4,986 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d4:	4790                	lw	a2,8(a5)
 9d6:	02061593          	slli	a1,a2,0x20
 9da:	01c5d713          	srli	a4,a1,0x1c
 9de:	973e                	add	a4,a4,a5
 9e0:	fae68ae3          	beq	a3,a4,994 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9e4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e6:	00000717          	auipc	a4,0x0
 9ea:	60f73d23          	sd	a5,1562(a4) # 1000 <freep>
}
 9ee:	6422                	ld	s0,8(sp)
 9f0:	0141                	addi	sp,sp,16
 9f2:	8082                	ret

00000000000009f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f4:	7139                	addi	sp,sp,-64
 9f6:	fc06                	sd	ra,56(sp)
 9f8:	f822                	sd	s0,48(sp)
 9fa:	f426                	sd	s1,40(sp)
 9fc:	ec4e                	sd	s3,24(sp)
 9fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a00:	02051493          	slli	s1,a0,0x20
 a04:	9081                	srli	s1,s1,0x20
 a06:	04bd                	addi	s1,s1,15
 a08:	8091                	srli	s1,s1,0x4
 a0a:	0014899b          	addiw	s3,s1,1
 a0e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a10:	00000517          	auipc	a0,0x0
 a14:	5f053503          	ld	a0,1520(a0) # 1000 <freep>
 a18:	c915                	beqz	a0,a4c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1c:	4798                	lw	a4,8(a5)
 a1e:	08977a63          	bgeu	a4,s1,ab2 <malloc+0xbe>
 a22:	f04a                	sd	s2,32(sp)
 a24:	e852                	sd	s4,16(sp)
 a26:	e456                	sd	s5,8(sp)
 a28:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a2a:	8a4e                	mv	s4,s3
 a2c:	0009871b          	sext.w	a4,s3
 a30:	6685                	lui	a3,0x1
 a32:	00d77363          	bgeu	a4,a3,a38 <malloc+0x44>
 a36:	6a05                	lui	s4,0x1
 a38:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a3c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a40:	00000917          	auipc	s2,0x0
 a44:	5c090913          	addi	s2,s2,1472 # 1000 <freep>
  if(p == (char*)-1)
 a48:	5afd                	li	s5,-1
 a4a:	a081                	j	a8a <malloc+0x96>
 a4c:	f04a                	sd	s2,32(sp)
 a4e:	e852                	sd	s4,16(sp)
 a50:	e456                	sd	s5,8(sp)
 a52:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a54:	00000797          	auipc	a5,0x0
 a58:	5cc78793          	addi	a5,a5,1484 # 1020 <base>
 a5c:	00000717          	auipc	a4,0x0
 a60:	5af73223          	sd	a5,1444(a4) # 1000 <freep>
 a64:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a66:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a6a:	b7c1                	j	a2a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a6c:	6398                	ld	a4,0(a5)
 a6e:	e118                	sd	a4,0(a0)
 a70:	a8a9                	j	aca <malloc+0xd6>
  hp->s.size = nu;
 a72:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a76:	0541                	addi	a0,a0,16
 a78:	efbff0ef          	jal	972 <free>
  return freep;
 a7c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a80:	c12d                	beqz	a0,ae2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a84:	4798                	lw	a4,8(a5)
 a86:	02977263          	bgeu	a4,s1,aaa <malloc+0xb6>
    if(p == freep)
 a8a:	00093703          	ld	a4,0(s2)
 a8e:	853e                	mv	a0,a5
 a90:	fef719e3          	bne	a4,a5,a82 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a94:	8552                	mv	a0,s4
 a96:	afbff0ef          	jal	590 <sbrk>
  if(p == (char*)-1)
 a9a:	fd551ce3          	bne	a0,s5,a72 <malloc+0x7e>
        return 0;
 a9e:	4501                	li	a0,0
 aa0:	7902                	ld	s2,32(sp)
 aa2:	6a42                	ld	s4,16(sp)
 aa4:	6aa2                	ld	s5,8(sp)
 aa6:	6b02                	ld	s6,0(sp)
 aa8:	a03d                	j	ad6 <malloc+0xe2>
 aaa:	7902                	ld	s2,32(sp)
 aac:	6a42                	ld	s4,16(sp)
 aae:	6aa2                	ld	s5,8(sp)
 ab0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab2:	fae48de3          	beq	s1,a4,a6c <malloc+0x78>
        p->s.size -= nunits;
 ab6:	4137073b          	subw	a4,a4,s3
 aba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 abc:	02071693          	slli	a3,a4,0x20
 ac0:	01c6d713          	srli	a4,a3,0x1c
 ac4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aca:	00000717          	auipc	a4,0x0
 ace:	52a73b23          	sd	a0,1334(a4) # 1000 <freep>
      return (void*)(p + 1);
 ad2:	01078513          	addi	a0,a5,16
  }
}
 ad6:	70e2                	ld	ra,56(sp)
 ad8:	7442                	ld	s0,48(sp)
 ada:	74a2                	ld	s1,40(sp)
 adc:	69e2                	ld	s3,24(sp)
 ade:	6121                	addi	sp,sp,64
 ae0:	8082                	ret
 ae2:	7902                	ld	s2,32(sp)
 ae4:	6a42                	ld	s4,16(sp)
 ae6:	6aa2                	ld	s5,8(sp)
 ae8:	6b02                	ld	s6,0(sp)
 aea:	b7f5                	j	ad6 <malloc+0xe2>
