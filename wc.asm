
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9a8a0a13          	addi	s4,s4,-1624 # 9e0 <malloc+0xf8>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	39c000ef          	jal	414 <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x118>
  a6:	78e000ef          	jal	834 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	92850513          	addi	a0,a0,-1752 # 9f0 <malloc+0x108>
  d0:	764000ef          	jal	834 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	326000ef          	jal	3fc <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	334000ef          	jal	43c <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	308000ef          	jal	424 <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2d4000ef          	jal	3fc <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8b658593          	addi	a1,a1,-1866 # 9e8 <malloc+0x100>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2ba000ef          	jal	3fc <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8c650513          	addi	a0,a0,-1850 # a10 <malloc+0x128>
 152:	6e2000ef          	jal	834 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2a4000ef          	jal	3fc <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	292000ef          	jal	3fc <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	1bc000ef          	jal	414 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	198000ef          	jal	43c <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	1a2000ef          	jal	454 <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	16a000ef          	jal	424 <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 3c4:	ce11                	beqz	a2,3e0 <strncmp+0x22>
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	cf89                	beqz	a5,3e4 <strncmp+0x26>
 3cc:	0005c703          	lbu	a4,0(a1)
 3d0:	00f71a63          	bne	a4,a5,3e4 <strncmp+0x26>
    n--, p++, q++;
 3d4:	367d                	addiw	a2,a2,-1
 3d6:	0505                	addi	a0,a0,1
 3d8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 3da:	f675                	bnez	a2,3c6 <strncmp+0x8>
  if(n == 0)
    return 0;
 3dc:	4501                	li	a0,0
 3de:	a801                	j	3ee <strncmp+0x30>
 3e0:	4501                	li	a0,0
 3e2:	a031                	j	3ee <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 3e4:	00054503          	lbu	a0,0(a0)
 3e8:	0005c783          	lbu	a5,0(a1)
 3ec:	9d1d                	subw	a0,a0,a5
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f4:	4885                	li	a7,1
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fc:	4889                	li	a7,2
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <wait>:
.global wait
wait:
 li a7, SYS_wait
 404:	488d                	li	a7,3
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40c:	4891                	li	a7,4
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <read>:
.global read
read:
 li a7, SYS_read
 414:	4895                	li	a7,5
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <write>:
.global write
write:
 li a7, SYS_write
 41c:	48c1                	li	a7,16
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <close>:
.global close
close:
 li a7, SYS_close
 424:	48d5                	li	a7,21
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <kill>:
.global kill
kill:
 li a7, SYS_kill
 42c:	4899                	li	a7,6
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <exec>:
.global exec
exec:
 li a7, SYS_exec
 434:	489d                	li	a7,7
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <open>:
.global open
open:
 li a7, SYS_open
 43c:	48bd                	li	a7,15
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 444:	48c5                	li	a7,17
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44c:	48c9                	li	a7,18
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 454:	48a1                	li	a7,8
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <link>:
.global link
link:
 li a7, SYS_link
 45c:	48cd                	li	a7,19
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 464:	48d1                	li	a7,20
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46c:	48a5                	li	a7,9
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <dup>:
.global dup
dup:
 li a7, SYS_dup
 474:	48a9                	li	a7,10
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47c:	48ad                	li	a7,11
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 484:	48b1                	li	a7,12
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48c:	48b5                	li	a7,13
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 494:	48b9                	li	a7,14
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <thread>:
.global thread
thread:
 li a7, SYS_thread
 49c:	48dd                	li	a7,23
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 4a4:	48e1                	li	a7,24
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 4ac:	48d9                	li	a7,22
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 4b4:	48dd                	li	a7,23
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4bc:	1101                	addi	sp,sp,-32
 4be:	ec06                	sd	ra,24(sp)
 4c0:	e822                	sd	s0,16(sp)
 4c2:	1000                	addi	s0,sp,32
 4c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c8:	4605                	li	a2,1
 4ca:	fef40593          	addi	a1,s0,-17
 4ce:	f4fff0ef          	jal	41c <write>
}
 4d2:	60e2                	ld	ra,24(sp)
 4d4:	6442                	ld	s0,16(sp)
 4d6:	6105                	addi	sp,sp,32
 4d8:	8082                	ret

00000000000004da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4da:	715d                	addi	sp,sp,-80
 4dc:	e486                	sd	ra,72(sp)
 4de:	e0a2                	sd	s0,64(sp)
 4e0:	fc26                	sd	s1,56(sp)
 4e2:	0880                	addi	s0,sp,80
 4e4:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e6:	c299                	beqz	a3,4ec <printint+0x12>
 4e8:	0805c963          	bltz	a1,57a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4ec:	2581                	sext.w	a1,a1
  neg = 0;
 4ee:	4881                	li	a7,0
 4f0:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f6:	2601                	sext.w	a2,a2
 4f8:	00000517          	auipc	a0,0x0
 4fc:	53850513          	addi	a0,a0,1336 # a30 <digits>
 500:	883a                	mv	a6,a4
 502:	2705                	addiw	a4,a4,1
 504:	02c5f7bb          	remuw	a5,a1,a2
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	97aa                	add	a5,a5,a0
 50e:	0007c783          	lbu	a5,0(a5)
 512:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 516:	0005879b          	sext.w	a5,a1
 51a:	02c5d5bb          	divuw	a1,a1,a2
 51e:	0685                	addi	a3,a3,1
 520:	fec7f0e3          	bgeu	a5,a2,500 <printint+0x26>
  if(neg)
 524:	00088c63          	beqz	a7,53c <printint+0x62>
    buf[i++] = '-';
 528:	fd070793          	addi	a5,a4,-48
 52c:	00878733          	add	a4,a5,s0
 530:	02d00793          	li	a5,45
 534:	fef70423          	sb	a5,-24(a4)
 538:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 53c:	02e05a63          	blez	a4,570 <printint+0x96>
 540:	f84a                	sd	s2,48(sp)
 542:	f44e                	sd	s3,40(sp)
 544:	fb840793          	addi	a5,s0,-72
 548:	00e78933          	add	s2,a5,a4
 54c:	fff78993          	addi	s3,a5,-1
 550:	99ba                	add	s3,s3,a4
 552:	377d                	addiw	a4,a4,-1
 554:	1702                	slli	a4,a4,0x20
 556:	9301                	srli	a4,a4,0x20
 558:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55c:	fff94583          	lbu	a1,-1(s2)
 560:	8526                	mv	a0,s1
 562:	f5bff0ef          	jal	4bc <putc>
  while(--i >= 0)
 566:	197d                	addi	s2,s2,-1
 568:	ff391ae3          	bne	s2,s3,55c <printint+0x82>
 56c:	7942                	ld	s2,48(sp)
 56e:	79a2                	ld	s3,40(sp)
}
 570:	60a6                	ld	ra,72(sp)
 572:	6406                	ld	s0,64(sp)
 574:	74e2                	ld	s1,56(sp)
 576:	6161                	addi	sp,sp,80
 578:	8082                	ret
    x = -xx;
 57a:	40b005bb          	negw	a1,a1
    neg = 1;
 57e:	4885                	li	a7,1
    x = -xx;
 580:	bf85                	j	4f0 <printint+0x16>

0000000000000582 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 582:	711d                	addi	sp,sp,-96
 584:	ec86                	sd	ra,88(sp)
 586:	e8a2                	sd	s0,80(sp)
 588:	e0ca                	sd	s2,64(sp)
 58a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58c:	0005c903          	lbu	s2,0(a1)
 590:	26090863          	beqz	s2,800 <vprintf+0x27e>
 594:	e4a6                	sd	s1,72(sp)
 596:	fc4e                	sd	s3,56(sp)
 598:	f852                	sd	s4,48(sp)
 59a:	f456                	sd	s5,40(sp)
 59c:	f05a                	sd	s6,32(sp)
 59e:	ec5e                	sd	s7,24(sp)
 5a0:	e862                	sd	s8,16(sp)
 5a2:	e466                	sd	s9,8(sp)
 5a4:	8b2a                	mv	s6,a0
 5a6:	8a2e                	mv	s4,a1
 5a8:	8bb2                	mv	s7,a2
  state = 0;
 5aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5ac:	4481                	li	s1,0
 5ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	06c00c93          	li	s9,108
 5bc:	a005                	j	5dc <vprintf+0x5a>
        putc(fd, c0);
 5be:	85ca                	mv	a1,s2
 5c0:	855a                	mv	a0,s6
 5c2:	efbff0ef          	jal	4bc <putc>
 5c6:	a019                	j	5cc <vprintf+0x4a>
    } else if(state == '%'){
 5c8:	03598263          	beq	s3,s5,5ec <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5cc:	2485                	addiw	s1,s1,1
 5ce:	8726                	mv	a4,s1
 5d0:	009a07b3          	add	a5,s4,s1
 5d4:	0007c903          	lbu	s2,0(a5)
 5d8:	20090c63          	beqz	s2,7f0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5e0:	fe0994e3          	bnez	s3,5c8 <vprintf+0x46>
      if(c0 == '%'){
 5e4:	fd579de3          	bne	a5,s5,5be <vprintf+0x3c>
        state = '%';
 5e8:	89be                	mv	s3,a5
 5ea:	b7cd                	j	5cc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ec:	00ea06b3          	add	a3,s4,a4
 5f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5f6:	c681                	beqz	a3,5fe <vprintf+0x7c>
 5f8:	9752                	add	a4,a4,s4
 5fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5fe:	03878f63          	beq	a5,s8,63c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 602:	05978963          	beq	a5,s9,654 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 606:	07500713          	li	a4,117
 60a:	0ee78363          	beq	a5,a4,6f0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 60e:	07800713          	li	a4,120
 612:	12e78563          	beq	a5,a4,73c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 616:	07000713          	li	a4,112
 61a:	14e78a63          	beq	a5,a4,76e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 61e:	07300713          	li	a4,115
 622:	18e78a63          	beq	a5,a4,7b6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 626:	02500713          	li	a4,37
 62a:	04e79563          	bne	a5,a4,674 <vprintf+0xf2>
        putc(fd, '%');
 62e:	02500593          	li	a1,37
 632:	855a                	mv	a0,s6
 634:	e89ff0ef          	jal	4bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 638:	4981                	li	s3,0
 63a:	bf49                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 63c:	008b8913          	addi	s2,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e91ff0ef          	jal	4da <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	bfad                	j	5cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 654:	06400793          	li	a5,100
 658:	02f68963          	beq	a3,a5,68a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65c:	06c00793          	li	a5,108
 660:	04f68263          	beq	a3,a5,6a4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 664:	07500793          	li	a5,117
 668:	0af68063          	beq	a3,a5,708 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 66c:	07800793          	li	a5,120
 670:	0ef68263          	beq	a3,a5,754 <vprintf+0x1d2>
        putc(fd, '%');
 674:	02500593          	li	a1,37
 678:	855a                	mv	a0,s6
 67a:	e43ff0ef          	jal	4bc <putc>
        putc(fd, c0);
 67e:	85ca                	mv	a1,s2
 680:	855a                	mv	a0,s6
 682:	e3bff0ef          	jal	4bc <putc>
      state = 0;
 686:	4981                	li	s3,0
 688:	b791                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e43ff0ef          	jal	4da <printint>
        i += 1;
 69c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b72d                	j	5cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a4:	06400793          	li	a5,100
 6a8:	02f60763          	beq	a2,a5,6d6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ac:	07500793          	li	a5,117
 6b0:	06f60963          	beq	a2,a5,722 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b4:	07800793          	li	a5,120
 6b8:	faf61ee3          	bne	a2,a5,674 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000bb583          	ld	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	e11ff0ef          	jal	4da <printint>
        i += 2;
 6ce:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 2;
 6d4:	bde5                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d6:	008b8913          	addi	s2,s7,8
 6da:	4685                	li	a3,1
 6dc:	4629                	li	a2,10
 6de:	000bb583          	ld	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	df7ff0ef          	jal	4da <printint>
        i += 2;
 6e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
        i += 2;
 6ee:	bdf9                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4629                	li	a2,10
 6f8:	000ba583          	lw	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	dddff0ef          	jal	4da <printint>
 702:	8bca                	mv	s7,s2
      state = 0;
 704:	4981                	li	s3,0
 706:	b5d9                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 708:	008b8913          	addi	s2,s7,8
 70c:	4681                	li	a3,0
 70e:	4629                	li	a2,10
 710:	000bb583          	ld	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	dc5ff0ef          	jal	4da <printint>
        i += 1;
 71a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
        i += 1;
 720:	b575                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	008b8913          	addi	s2,s7,8
 726:	4681                	li	a3,0
 728:	4629                	li	a2,10
 72a:	000bb583          	ld	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	dabff0ef          	jal	4da <printint>
        i += 2;
 734:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
        i += 2;
 73a:	bd49                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 73c:	008b8913          	addi	s2,s7,8
 740:	4681                	li	a3,0
 742:	4641                	li	a2,16
 744:	000ba583          	lw	a1,0(s7)
 748:	855a                	mv	a0,s6
 74a:	d91ff0ef          	jal	4da <printint>
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	bdad                	j	5cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	008b8913          	addi	s2,s7,8
 758:	4681                	li	a3,0
 75a:	4641                	li	a2,16
 75c:	000bb583          	ld	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	d79ff0ef          	jal	4da <printint>
        i += 1;
 766:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 768:	8bca                	mv	s7,s2
      state = 0;
 76a:	4981                	li	s3,0
        i += 1;
 76c:	b585                	j	5cc <vprintf+0x4a>
 76e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 770:	008b8d13          	addi	s10,s7,8
 774:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 778:	03000593          	li	a1,48
 77c:	855a                	mv	a0,s6
 77e:	d3fff0ef          	jal	4bc <putc>
  putc(fd, 'x');
 782:	07800593          	li	a1,120
 786:	855a                	mv	a0,s6
 788:	d35ff0ef          	jal	4bc <putc>
 78c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78e:	00000b97          	auipc	s7,0x0
 792:	2a2b8b93          	addi	s7,s7,674 # a30 <digits>
 796:	03c9d793          	srli	a5,s3,0x3c
 79a:	97de                	add	a5,a5,s7
 79c:	0007c583          	lbu	a1,0(a5)
 7a0:	855a                	mv	a0,s6
 7a2:	d1bff0ef          	jal	4bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a6:	0992                	slli	s3,s3,0x4
 7a8:	397d                	addiw	s2,s2,-1
 7aa:	fe0916e3          	bnez	s2,796 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7ae:	8bea                	mv	s7,s10
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	6d02                	ld	s10,0(sp)
 7b4:	bd21                	j	5cc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7b6:	008b8993          	addi	s3,s7,8
 7ba:	000bb903          	ld	s2,0(s7)
 7be:	00090f63          	beqz	s2,7dc <vprintf+0x25a>
        for(; *s; s++)
 7c2:	00094583          	lbu	a1,0(s2)
 7c6:	c195                	beqz	a1,7ea <vprintf+0x268>
          putc(fd, *s);
 7c8:	855a                	mv	a0,s6
 7ca:	cf3ff0ef          	jal	4bc <putc>
        for(; *s; s++)
 7ce:	0905                	addi	s2,s2,1
 7d0:	00094583          	lbu	a1,0(s2)
 7d4:	f9f5                	bnez	a1,7c8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	bbcd                	j	5cc <vprintf+0x4a>
          s = "(null)";
 7dc:	00000917          	auipc	s2,0x0
 7e0:	24c90913          	addi	s2,s2,588 # a28 <malloc+0x140>
        for(; *s; s++)
 7e4:	02800593          	li	a1,40
 7e8:	b7c5                	j	7c8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ea:	8bce                	mv	s7,s3
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bbf9                	j	5cc <vprintf+0x4a>
 7f0:	64a6                	ld	s1,72(sp)
 7f2:	79e2                	ld	s3,56(sp)
 7f4:	7a42                	ld	s4,48(sp)
 7f6:	7aa2                	ld	s5,40(sp)
 7f8:	7b02                	ld	s6,32(sp)
 7fa:	6be2                	ld	s7,24(sp)
 7fc:	6c42                	ld	s8,16(sp)
 7fe:	6ca2                	ld	s9,8(sp)
    }
  }
}
 800:	60e6                	ld	ra,88(sp)
 802:	6446                	ld	s0,80(sp)
 804:	6906                	ld	s2,64(sp)
 806:	6125                	addi	sp,sp,96
 808:	8082                	ret

000000000000080a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80a:	715d                	addi	sp,sp,-80
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e010                	sd	a2,0(s0)
 814:	e414                	sd	a3,8(s0)
 816:	e818                	sd	a4,16(s0)
 818:	ec1c                	sd	a5,24(s0)
 81a:	03043023          	sd	a6,32(s0)
 81e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 826:	8622                	mv	a2,s0
 828:	d5bff0ef          	jal	582 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6161                	addi	sp,sp,80
 832:	8082                	ret

0000000000000834 <printf>:

void
printf(const char *fmt, ...)
{
 834:	711d                	addi	sp,sp,-96
 836:	ec06                	sd	ra,24(sp)
 838:	e822                	sd	s0,16(sp)
 83a:	1000                	addi	s0,sp,32
 83c:	e40c                	sd	a1,8(s0)
 83e:	e810                	sd	a2,16(s0)
 840:	ec14                	sd	a3,24(s0)
 842:	f018                	sd	a4,32(s0)
 844:	f41c                	sd	a5,40(s0)
 846:	03043823          	sd	a6,48(s0)
 84a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84e:	00840613          	addi	a2,s0,8
 852:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 856:	85aa                	mv	a1,a0
 858:	4505                	li	a0,1
 85a:	d29ff0ef          	jal	582 <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6125                	addi	sp,sp,96
 864:	8082                	ret

0000000000000866 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 866:	1141                	addi	sp,sp,-16
 868:	e422                	sd	s0,8(sp)
 86a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	00000797          	auipc	a5,0x0
 874:	7907b783          	ld	a5,1936(a5) # 1000 <freep>
 878:	a02d                	j	8a2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 87a:	4618                	lw	a4,8(a2)
 87c:	9f2d                	addw	a4,a4,a1
 87e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	6310                	ld	a2,0(a4)
 886:	a83d                	j	8c4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 888:	ff852703          	lw	a4,-8(a0)
 88c:	9f31                	addw	a4,a4,a2
 88e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 890:	ff053683          	ld	a3,-16(a0)
 894:	a091                	j	8d8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 896:	6398                	ld	a4,0(a5)
 898:	00e7e463          	bltu	a5,a4,8a0 <free+0x3a>
 89c:	00e6ea63          	bltu	a3,a4,8b0 <free+0x4a>
{
 8a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	fed7fae3          	bgeu	a5,a3,896 <free+0x30>
 8a6:	6398                	ld	a4,0(a5)
 8a8:	00e6e463          	bltu	a3,a4,8b0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	fee7eae3          	bltu	a5,a4,8a0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8b0:	ff852583          	lw	a1,-8(a0)
 8b4:	6390                	ld	a2,0(a5)
 8b6:	02059813          	slli	a6,a1,0x20
 8ba:	01c85713          	srli	a4,a6,0x1c
 8be:	9736                	add	a4,a4,a3
 8c0:	fae60de3          	beq	a2,a4,87a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c8:	4790                	lw	a2,8(a5)
 8ca:	02061593          	slli	a1,a2,0x20
 8ce:	01c5d713          	srli	a4,a1,0x1c
 8d2:	973e                	add	a4,a4,a5
 8d4:	fae68ae3          	beq	a3,a4,888 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
}
 8e2:	6422                	ld	s0,8(sp)
 8e4:	0141                	addi	sp,sp,16
 8e6:	8082                	ret

00000000000008e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e8:	7139                	addi	sp,sp,-64
 8ea:	fc06                	sd	ra,56(sp)
 8ec:	f822                	sd	s0,48(sp)
 8ee:	f426                	sd	s1,40(sp)
 8f0:	ec4e                	sd	s3,24(sp)
 8f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f4:	02051493          	slli	s1,a0,0x20
 8f8:	9081                	srli	s1,s1,0x20
 8fa:	04bd                	addi	s1,s1,15
 8fc:	8091                	srli	s1,s1,0x4
 8fe:	0014899b          	addiw	s3,s1,1
 902:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 904:	00000517          	auipc	a0,0x0
 908:	6fc53503          	ld	a0,1788(a0) # 1000 <freep>
 90c:	c915                	beqz	a0,940 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	08977a63          	bgeu	a4,s1,9a6 <malloc+0xbe>
 916:	f04a                	sd	s2,32(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 91e:	8a4e                	mv	s4,s3
 920:	0009871b          	sext.w	a4,s3
 924:	6685                	lui	a3,0x1
 926:	00d77363          	bgeu	a4,a3,92c <malloc+0x44>
 92a:	6a05                	lui	s4,0x1
 92c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 930:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 934:	00000917          	auipc	s2,0x0
 938:	6cc90913          	addi	s2,s2,1740 # 1000 <freep>
  if(p == (char*)-1)
 93c:	5afd                	li	s5,-1
 93e:	a081                	j	97e <malloc+0x96>
 940:	f04a                	sd	s2,32(sp)
 942:	e852                	sd	s4,16(sp)
 944:	e456                	sd	s5,8(sp)
 946:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 948:	00001797          	auipc	a5,0x1
 94c:	8c878793          	addi	a5,a5,-1848 # 1210 <base>
 950:	00000717          	auipc	a4,0x0
 954:	6af73823          	sd	a5,1712(a4) # 1000 <freep>
 958:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95e:	b7c1                	j	91e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	a8a9                	j	9be <malloc+0xd6>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96a:	0541                	addi	a0,a0,16
 96c:	efbff0ef          	jal	866 <free>
  return freep;
 970:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 974:	c12d                	beqz	a0,9d6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 976:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 978:	4798                	lw	a4,8(a5)
 97a:	02977263          	bgeu	a4,s1,99e <malloc+0xb6>
    if(p == freep)
 97e:	00093703          	ld	a4,0(s2)
 982:	853e                	mv	a0,a5
 984:	fef719e3          	bne	a4,a5,976 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 988:	8552                	mv	a0,s4
 98a:	afbff0ef          	jal	484 <sbrk>
  if(p == (char*)-1)
 98e:	fd551ce3          	bne	a0,s5,966 <malloc+0x7e>
        return 0;
 992:	4501                	li	a0,0
 994:	7902                	ld	s2,32(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
 99c:	a03d                	j	9ca <malloc+0xe2>
 99e:	7902                	ld	s2,32(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9a6:	fae48de3          	beq	s1,a4,960 <malloc+0x78>
        p->s.size -= nunits;
 9aa:	4137073b          	subw	a4,a4,s3
 9ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b0:	02071693          	slli	a3,a4,0x20
 9b4:	01c6d713          	srli	a4,a3,0x1c
 9b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9be:	00000717          	auipc	a4,0x0
 9c2:	64a73123          	sd	a0,1602(a4) # 1000 <freep>
      return (void*)(p + 1);
 9c6:	01078513          	addi	a0,a5,16
  }
}
 9ca:	70e2                	ld	ra,56(sp)
 9cc:	7442                	ld	s0,48(sp)
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	69e2                	ld	s3,24(sp)
 9d2:	6121                	addi	sp,sp,64
 9d4:	8082                	ret
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	b7f5                	j	9ca <malloc+0xe2>
