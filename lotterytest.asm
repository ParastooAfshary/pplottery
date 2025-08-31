
user/_lotterytest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cpu_bound_task>:
#include "kernel/types.h"
#include "user/user.h"

#define RUN_TIME 100000000

void cpu_bound_task(int id, int tickets) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	8aaa                	mv	s5,a0
  16:	8a2e                	mv	s4,a1
    settickets(tickets);
  18:	852e                	mv	a0,a1
  1a:	416000ef          	jal	430 <settickets>

    int i;
    for (i = 0; i < RUN_TIME; i++) {
  1e:	4481                	li	s1,0
        if (i % 10000000 == 0) {
  20:	009899b7          	lui	s3,0x989
  24:	6809899b          	addiw	s3,s3,1664 # 989680 <base+0x988670>
            printf("[proc %d, tickets %d] progress: %d\n", id, tickets, i);
  28:	00001b17          	auipc	s6,0x1
  2c:	948b0b13          	addi	s6,s6,-1720 # 970 <malloc+0x104>
    for (i = 0; i < RUN_TIME; i++) {
  30:	05f5e937          	lui	s2,0x5f5e
  34:	10090913          	addi	s2,s2,256 # 5f5e100 <base+0x5f5d0f0>
  38:	a021                	j	40 <cpu_bound_task+0x40>
  3a:	2485                	addiw	s1,s1,1
  3c:	01248c63          	beq	s1,s2,54 <cpu_bound_task+0x54>
        if (i % 10000000 == 0) {
  40:	0334e7bb          	remw	a5,s1,s3
  44:	fbfd                	bnez	a5,3a <cpu_bound_task+0x3a>
            printf("[proc %d, tickets %d] progress: %d\n", id, tickets, i);
  46:	86a6                	mv	a3,s1
  48:	8652                	mv	a2,s4
  4a:	85d6                	mv	a1,s5
  4c:	855a                	mv	a0,s6
  4e:	76a000ef          	jal	7b8 <printf>
  52:	b7e5                	j	3a <cpu_bound_task+0x3a>
        }
    }

    printf("[proc %d, tickets %d] DONE\n", id, tickets);
  54:	8652                	mv	a2,s4
  56:	85d6                	mv	a1,s5
  58:	00001517          	auipc	a0,0x1
  5c:	94050513          	addi	a0,a0,-1728 # 998 <malloc+0x12c>
  60:	758000ef          	jal	7b8 <printf>
    exit(0);
  64:	4501                	li	a0,0
  66:	31a000ef          	jal	380 <exit>

000000000000006a <main>:
}

int main(int argc, char *argv[]) {
  6a:	1101                	addi	sp,sp,-32
  6c:	ec06                	sd	ra,24(sp)
  6e:	e822                	sd	s0,16(sp)
  70:	1000                	addi	s0,sp,32
    int tickets[3] = {10, 30, 90};
  72:	47a9                	li	a5,10
  74:	fef42023          	sw	a5,-32(s0)
  78:	47f9                	li	a5,30
  7a:	fef42223          	sw	a5,-28(s0)
  7e:	05a00793          	li	a5,90
  82:	fef42423          	sw	a5,-24(s0)

    printf("Starting lottery scheduling test...\n");
  86:	00001517          	auipc	a0,0x1
  8a:	93250513          	addi	a0,a0,-1742 # 9b8 <malloc+0x14c>
  8e:	72a000ef          	jal	7b8 <printf>

    for (int i = 0; i < 3; i++) {
        int pid = fork();
  92:	2e6000ef          	jal	378 <fork>
        if (pid == 0) {
  96:	cd05                	beqz	a0,ce <main+0x64>
        int pid = fork();
  98:	2e0000ef          	jal	378 <fork>
        if (pid == 0) {
  9c:	c905                	beqz	a0,cc <main+0x62>
        int pid = fork();
  9e:	2da000ef          	jal	378 <fork>
        if (pid == 0) {
  a2:	c11d                	beqz	a0,c8 <main+0x5e>
            cpu_bound_task(i + 1, tickets[i]);
        }
    }

    for (int i = 0; i < 3; i++) {
        wait(0);
  a4:	4501                	li	a0,0
  a6:	2e2000ef          	jal	388 <wait>
  aa:	4501                	li	a0,0
  ac:	2dc000ef          	jal	388 <wait>
  b0:	4501                	li	a0,0
  b2:	2d6000ef          	jal	388 <wait>
    }

    printf("Lottery scheduling test finished.\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	92a50513          	addi	a0,a0,-1750 # 9e0 <malloc+0x174>
  be:	6fa000ef          	jal	7b8 <printf>
    exit(0);
  c2:	4501                	li	a0,0
  c4:	2bc000ef          	jal	380 <exit>
  c8:	4509                	li	a0,2
  ca:	a011                	j	ce <main+0x64>
    for (int i = 0; i < 3; i++) {
  cc:	4505                	li	a0,1
            cpu_bound_task(i + 1, tickets[i]);
  ce:	00251793          	slli	a5,a0,0x2
  d2:	17c1                	addi	a5,a5,-16
  d4:	97a2                	add	a5,a5,s0
  d6:	ff07a583          	lw	a1,-16(a5)
  da:	2505                	addiw	a0,a0,1
  dc:	f25ff0ef          	jal	0 <cpu_bound_task>

00000000000000e0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e8:	f83ff0ef          	jal	6a <main>
  exit(0);
  ec:	4501                	li	a0,0
  ee:	292000ef          	jal	380 <exit>

00000000000000f2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f8:	87aa                	mv	a5,a0
  fa:	0585                	addi	a1,a1,1
  fc:	0785                	addi	a5,a5,1
  fe:	fff5c703          	lbu	a4,-1(a1)
 102:	fee78fa3          	sb	a4,-1(a5)
 106:	fb75                	bnez	a4,fa <strcpy+0x8>
    ;
  return os;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 114:	00054783          	lbu	a5,0(a0)
 118:	cb91                	beqz	a5,12c <strcmp+0x1e>
 11a:	0005c703          	lbu	a4,0(a1)
 11e:	00f71763          	bne	a4,a5,12c <strcmp+0x1e>
    p++, q++;
 122:	0505                	addi	a0,a0,1
 124:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 126:	00054783          	lbu	a5,0(a0)
 12a:	fbe5                	bnez	a5,11a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 12c:	0005c503          	lbu	a0,0(a1)
}
 130:	40a7853b          	subw	a0,a5,a0
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strlen>:

uint
strlen(const char *s)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 140:	00054783          	lbu	a5,0(a0)
 144:	cf91                	beqz	a5,160 <strlen+0x26>
 146:	0505                	addi	a0,a0,1
 148:	87aa                	mv	a5,a0
 14a:	86be                	mv	a3,a5
 14c:	0785                	addi	a5,a5,1
 14e:	fff7c703          	lbu	a4,-1(a5)
 152:	ff65                	bnez	a4,14a <strlen+0x10>
 154:	40a6853b          	subw	a0,a3,a0
 158:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret
  for(n = 0; s[n]; n++)
 160:	4501                	li	a0,0
 162:	bfe5                	j	15a <strlen+0x20>

0000000000000164 <memset>:

void*
memset(void *dst, int c, uint n)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 16a:	ca19                	beqz	a2,180 <memset+0x1c>
 16c:	87aa                	mv	a5,a0
 16e:	1602                	slli	a2,a2,0x20
 170:	9201                	srli	a2,a2,0x20
 172:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 176:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 17a:	0785                	addi	a5,a5,1
 17c:	fee79de3          	bne	a5,a4,176 <memset+0x12>
  }
  return dst;
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strchr>:

char*
strchr(const char *s, char c)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	cb99                	beqz	a5,1a6 <strchr+0x20>
    if(*s == c)
 192:	00f58763          	beq	a1,a5,1a0 <strchr+0x1a>
  for(; *s; s++)
 196:	0505                	addi	a0,a0,1
 198:	00054783          	lbu	a5,0(a0)
 19c:	fbfd                	bnez	a5,192 <strchr+0xc>
      return (char*)s;
  return 0;
 19e:	4501                	li	a0,0
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
  return 0;
 1a6:	4501                	li	a0,0
 1a8:	bfe5                	j	1a0 <strchr+0x1a>

00000000000001aa <gets>:

char*
gets(char *buf, int max)
{
 1aa:	711d                	addi	sp,sp,-96
 1ac:	ec86                	sd	ra,88(sp)
 1ae:	e8a2                	sd	s0,80(sp)
 1b0:	e4a6                	sd	s1,72(sp)
 1b2:	e0ca                	sd	s2,64(sp)
 1b4:	fc4e                	sd	s3,56(sp)
 1b6:	f852                	sd	s4,48(sp)
 1b8:	f456                	sd	s5,40(sp)
 1ba:	f05a                	sd	s6,32(sp)
 1bc:	ec5e                	sd	s7,24(sp)
 1be:	1080                	addi	s0,sp,96
 1c0:	8baa                	mv	s7,a0
 1c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c4:	892a                	mv	s2,a0
 1c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c8:	4aa9                	li	s5,10
 1ca:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1cc:	89a6                	mv	s3,s1
 1ce:	2485                	addiw	s1,s1,1
 1d0:	0344d663          	bge	s1,s4,1fc <gets+0x52>
    cc = read(0, &c, 1);
 1d4:	4605                	li	a2,1
 1d6:	faf40593          	addi	a1,s0,-81
 1da:	4501                	li	a0,0
 1dc:	1bc000ef          	jal	398 <read>
    if(cc < 1)
 1e0:	00a05e63          	blez	a0,1fc <gets+0x52>
    buf[i++] = c;
 1e4:	faf44783          	lbu	a5,-81(s0)
 1e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ec:	01578763          	beq	a5,s5,1fa <gets+0x50>
 1f0:	0905                	addi	s2,s2,1
 1f2:	fd679de3          	bne	a5,s6,1cc <gets+0x22>
    buf[i++] = c;
 1f6:	89a6                	mv	s3,s1
 1f8:	a011                	j	1fc <gets+0x52>
 1fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1fc:	99de                	add	s3,s3,s7
 1fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 202:	855e                	mv	a0,s7
 204:	60e6                	ld	ra,88(sp)
 206:	6446                	ld	s0,80(sp)
 208:	64a6                	ld	s1,72(sp)
 20a:	6906                	ld	s2,64(sp)
 20c:	79e2                	ld	s3,56(sp)
 20e:	7a42                	ld	s4,48(sp)
 210:	7aa2                	ld	s5,40(sp)
 212:	7b02                	ld	s6,32(sp)
 214:	6be2                	ld	s7,24(sp)
 216:	6125                	addi	sp,sp,96
 218:	8082                	ret

000000000000021a <stat>:

int
stat(const char *n, struct stat *st)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	198000ef          	jal	3c0 <open>
  if(fd < 0)
 22c:	02054263          	bltz	a0,250 <stat+0x36>
 230:	e426                	sd	s1,8(sp)
 232:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 234:	85ca                	mv	a1,s2
 236:	1a2000ef          	jal	3d8 <fstat>
 23a:	892a                	mv	s2,a0
  close(fd);
 23c:	8526                	mv	a0,s1
 23e:	16a000ef          	jal	3a8 <close>
  return r;
 242:	64a2                	ld	s1,8(sp)
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	6902                	ld	s2,0(sp)
 24c:	6105                	addi	sp,sp,32
 24e:	8082                	ret
    return -1;
 250:	597d                	li	s2,-1
 252:	bfcd                	j	244 <stat+0x2a>

0000000000000254 <atoi>:

int
atoi(const char *s)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25a:	00054683          	lbu	a3,0(a0)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	4625                	li	a2,9
 268:	02f66863          	bltu	a2,a5,298 <atoi+0x44>
 26c:	872a                	mv	a4,a0
  n = 0;
 26e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 270:	0705                	addi	a4,a4,1
 272:	0025179b          	slliw	a5,a0,0x2
 276:	9fa9                	addw	a5,a5,a0
 278:	0017979b          	slliw	a5,a5,0x1
 27c:	9fb5                	addw	a5,a5,a3
 27e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 282:	00074683          	lbu	a3,0(a4)
 286:	fd06879b          	addiw	a5,a3,-48
 28a:	0ff7f793          	zext.b	a5,a5
 28e:	fef671e3          	bgeu	a2,a5,270 <atoi+0x1c>
  return n;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  n = 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <atoi+0x3e>

000000000000029c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a2:	02b57463          	bgeu	a0,a1,2ca <memmove+0x2e>
    while(n-- > 0)
 2a6:	00c05f63          	blez	a2,2c4 <memmove+0x28>
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b4:	0585                	addi	a1,a1,1
 2b6:	0705                	addi	a4,a4,1
 2b8:	fff5c683          	lbu	a3,-1(a1)
 2bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c0:	fef71ae3          	bne	a4,a5,2b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
    dst += n;
 2ca:	00c50733          	add	a4,a0,a2
    src += n;
 2ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d0:	fec05ae3          	blez	a2,2c4 <memmove+0x28>
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	fff7c793          	not	a5,a5
 2e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e2:	15fd                	addi	a1,a1,-1
 2e4:	177d                	addi	a4,a4,-1
 2e6:	0005c683          	lbu	a3,0(a1)
 2ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ee:	fee79ae3          	bne	a5,a4,2e2 <memmove+0x46>
 2f2:	bfc9                	j	2c4 <memmove+0x28>

00000000000002f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fa:	ca05                	beqz	a2,32a <memcmp+0x36>
 2fc:	fff6069b          	addiw	a3,a2,-1
 300:	1682                	slli	a3,a3,0x20
 302:	9281                	srli	a3,a3,0x20
 304:	0685                	addi	a3,a3,1
 306:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 308:	00054783          	lbu	a5,0(a0)
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00e79863          	bne	a5,a4,320 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 314:	0505                	addi	a0,a0,1
    p2++;
 316:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 318:	fed518e3          	bne	a0,a3,308 <memcmp+0x14>
  }
  return 0;
 31c:	4501                	li	a0,0
 31e:	a019                	j	324 <memcmp+0x30>
      return *p1 - *p2;
 320:	40e7853b          	subw	a0,a5,a4
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  return 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <memcmp+0x30>

000000000000032e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 336:	f67ff0ef          	jal	29c <memmove>
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 348:	ce11                	beqz	a2,364 <strncmp+0x22>
 34a:	00054783          	lbu	a5,0(a0)
 34e:	cf89                	beqz	a5,368 <strncmp+0x26>
 350:	0005c703          	lbu	a4,0(a1)
 354:	00f71a63          	bne	a4,a5,368 <strncmp+0x26>
    n--, p++, q++;
 358:	367d                	addiw	a2,a2,-1
 35a:	0505                	addi	a0,a0,1
 35c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 35e:	f675                	bnez	a2,34a <strncmp+0x8>
  if(n == 0)
    return 0;
 360:	4501                	li	a0,0
 362:	a801                	j	372 <strncmp+0x30>
 364:	4501                	li	a0,0
 366:	a031                	j	372 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 368:	00054503          	lbu	a0,0(a0)
 36c:	0005c783          	lbu	a5,0(a1)
 370:	9d1d                	subw	a0,a0,a5
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret

0000000000000378 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 378:	4885                	li	a7,1
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <exit>:
.global exit
exit:
 li a7, SYS_exit
 380:	4889                	li	a7,2
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <wait>:
.global wait
wait:
 li a7, SYS_wait
 388:	488d                	li	a7,3
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 390:	4891                	li	a7,4
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <read>:
.global read
read:
 li a7, SYS_read
 398:	4895                	li	a7,5
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <write>:
.global write
write:
 li a7, SYS_write
 3a0:	48c1                	li	a7,16
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <close>:
.global close
close:
 li a7, SYS_close
 3a8:	48d5                	li	a7,21
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b0:	4899                	li	a7,6
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b8:	489d                	li	a7,7
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <open>:
.global open
open:
 li a7, SYS_open
 3c0:	48bd                	li	a7,15
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c8:	48c5                	li	a7,17
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d0:	48c9                	li	a7,18
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d8:	48a1                	li	a7,8
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <link>:
.global link
link:
 li a7, SYS_link
 3e0:	48cd                	li	a7,19
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e8:	48d1                	li	a7,20
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f0:	48a5                	li	a7,9
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f8:	48a9                	li	a7,10
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 400:	48ad                	li	a7,11
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 408:	48b1                	li	a7,12
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 410:	48b5                	li	a7,13
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 418:	48b9                	li	a7,14
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <thread>:
.global thread
thread:
 li a7, SYS_thread
 420:	48dd                	li	a7,23
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 428:	48e1                	li	a7,24
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 430:	48d9                	li	a7,22
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 438:	48dd                	li	a7,23
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	f4fff0ef          	jal	3a0 <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 45e:	715d                	addi	sp,sp,-80
 460:	e486                	sd	ra,72(sp)
 462:	e0a2                	sd	s0,64(sp)
 464:	fc26                	sd	s1,56(sp)
 466:	0880                	addi	s0,sp,80
 468:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46a:	c299                	beqz	a3,470 <printint+0x12>
 46c:	0805c963          	bltz	a1,4fe <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 470:	2581                	sext.w	a1,a1
  neg = 0;
 472:	4881                	li	a7,0
 474:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 478:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47a:	2601                	sext.w	a2,a2
 47c:	00000517          	auipc	a0,0x0
 480:	59450513          	addi	a0,a0,1428 # a10 <digits>
 484:	883a                	mv	a6,a4
 486:	2705                	addiw	a4,a4,1
 488:	02c5f7bb          	remuw	a5,a1,a2
 48c:	1782                	slli	a5,a5,0x20
 48e:	9381                	srli	a5,a5,0x20
 490:	97aa                	add	a5,a5,a0
 492:	0007c783          	lbu	a5,0(a5)
 496:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49a:	0005879b          	sext.w	a5,a1
 49e:	02c5d5bb          	divuw	a1,a1,a2
 4a2:	0685                	addi	a3,a3,1
 4a4:	fec7f0e3          	bgeu	a5,a2,484 <printint+0x26>
  if(neg)
 4a8:	00088c63          	beqz	a7,4c0 <printint+0x62>
    buf[i++] = '-';
 4ac:	fd070793          	addi	a5,a4,-48
 4b0:	00878733          	add	a4,a5,s0
 4b4:	02d00793          	li	a5,45
 4b8:	fef70423          	sb	a5,-24(a4)
 4bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c0:	02e05a63          	blez	a4,4f4 <printint+0x96>
 4c4:	f84a                	sd	s2,48(sp)
 4c6:	f44e                	sd	s3,40(sp)
 4c8:	fb840793          	addi	a5,s0,-72
 4cc:	00e78933          	add	s2,a5,a4
 4d0:	fff78993          	addi	s3,a5,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	377d                	addiw	a4,a4,-1
 4d8:	1702                	slli	a4,a4,0x20
 4da:	9301                	srli	a4,a4,0x20
 4dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e0:	fff94583          	lbu	a1,-1(s2)
 4e4:	8526                	mv	a0,s1
 4e6:	f5bff0ef          	jal	440 <putc>
  while(--i >= 0)
 4ea:	197d                	addi	s2,s2,-1
 4ec:	ff391ae3          	bne	s2,s3,4e0 <printint+0x82>
 4f0:	7942                	ld	s2,48(sp)
 4f2:	79a2                	ld	s3,40(sp)
}
 4f4:	60a6                	ld	ra,72(sp)
 4f6:	6406                	ld	s0,64(sp)
 4f8:	74e2                	ld	s1,56(sp)
 4fa:	6161                	addi	sp,sp,80
 4fc:	8082                	ret
    x = -xx;
 4fe:	40b005bb          	negw	a1,a1
    neg = 1;
 502:	4885                	li	a7,1
    x = -xx;
 504:	bf85                	j	474 <printint+0x16>

0000000000000506 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 506:	711d                	addi	sp,sp,-96
 508:	ec86                	sd	ra,88(sp)
 50a:	e8a2                	sd	s0,80(sp)
 50c:	e0ca                	sd	s2,64(sp)
 50e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 510:	0005c903          	lbu	s2,0(a1)
 514:	26090863          	beqz	s2,784 <vprintf+0x27e>
 518:	e4a6                	sd	s1,72(sp)
 51a:	fc4e                	sd	s3,56(sp)
 51c:	f852                	sd	s4,48(sp)
 51e:	f456                	sd	s5,40(sp)
 520:	f05a                	sd	s6,32(sp)
 522:	ec5e                	sd	s7,24(sp)
 524:	e862                	sd	s8,16(sp)
 526:	e466                	sd	s9,8(sp)
 528:	8b2a                	mv	s6,a0
 52a:	8a2e                	mv	s4,a1
 52c:	8bb2                	mv	s7,a2
  state = 0;
 52e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 530:	4481                	li	s1,0
 532:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 534:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 538:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	06c00c93          	li	s9,108
 540:	a005                	j	560 <vprintf+0x5a>
        putc(fd, c0);
 542:	85ca                	mv	a1,s2
 544:	855a                	mv	a0,s6
 546:	efbff0ef          	jal	440 <putc>
 54a:	a019                	j	550 <vprintf+0x4a>
    } else if(state == '%'){
 54c:	03598263          	beq	s3,s5,570 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 550:	2485                	addiw	s1,s1,1
 552:	8726                	mv	a4,s1
 554:	009a07b3          	add	a5,s4,s1
 558:	0007c903          	lbu	s2,0(a5)
 55c:	20090c63          	beqz	s2,774 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 560:	0009079b          	sext.w	a5,s2
    if(state == 0){
 564:	fe0994e3          	bnez	s3,54c <vprintf+0x46>
      if(c0 == '%'){
 568:	fd579de3          	bne	a5,s5,542 <vprintf+0x3c>
        state = '%';
 56c:	89be                	mv	s3,a5
 56e:	b7cd                	j	550 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 570:	00ea06b3          	add	a3,s4,a4
 574:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 578:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 57a:	c681                	beqz	a3,582 <vprintf+0x7c>
 57c:	9752                	add	a4,a4,s4
 57e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 582:	03878f63          	beq	a5,s8,5c0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 586:	05978963          	beq	a5,s9,5d8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 58a:	07500713          	li	a4,117
 58e:	0ee78363          	beq	a5,a4,674 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 592:	07800713          	li	a4,120
 596:	12e78563          	beq	a5,a4,6c0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 59a:	07000713          	li	a4,112
 59e:	14e78a63          	beq	a5,a4,6f2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a2:	07300713          	li	a4,115
 5a6:	18e78a63          	beq	a5,a4,73a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5aa:	02500713          	li	a4,37
 5ae:	04e79563          	bne	a5,a4,5f8 <vprintf+0xf2>
        putc(fd, '%');
 5b2:	02500593          	li	a1,37
 5b6:	855a                	mv	a0,s6
 5b8:	e89ff0ef          	jal	440 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bf49                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e91ff0ef          	jal	45e <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bfad                	j	550 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	06400793          	li	a5,100
 5dc:	02f68963          	beq	a3,a5,60e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e0:	06c00793          	li	a5,108
 5e4:	04f68263          	beq	a3,a5,628 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5e8:	07500793          	li	a5,117
 5ec:	0af68063          	beq	a3,a5,68c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5f0:	07800793          	li	a5,120
 5f4:	0ef68263          	beq	a3,a5,6d8 <vprintf+0x1d2>
        putc(fd, '%');
 5f8:	02500593          	li	a1,37
 5fc:	855a                	mv	a0,s6
 5fe:	e43ff0ef          	jal	440 <putc>
        putc(fd, c0);
 602:	85ca                	mv	a1,s2
 604:	855a                	mv	a0,s6
 606:	e3bff0ef          	jal	440 <putc>
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b791                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8913          	addi	s2,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e43ff0ef          	jal	45e <printint>
        i += 1;
 620:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 1;
 626:	b72d                	j	550 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 628:	06400793          	li	a5,100
 62c:	02f60763          	beq	a2,a5,65a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 630:	07500793          	li	a5,117
 634:	06f60963          	beq	a2,a5,6a6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 638:	07800793          	li	a5,120
 63c:	faf61ee3          	bne	a2,a5,5f8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e11ff0ef          	jal	45e <printint>
        i += 2;
 652:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	bde5                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4685                	li	a3,1
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	df7ff0ef          	jal	45e <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bdf9                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dddff0ef          	jal	45e <printint>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b5d9                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	dc5ff0ef          	jal	45e <printint>
        i += 1;
 69e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	b575                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dabff0ef          	jal	45e <printint>
        i += 2;
 6b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 2;
 6be:	bd49                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d91ff0ef          	jal	45e <printint>
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bdad                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	d79ff0ef          	jal	45e <printint>
        i += 1;
 6ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 1;
 6f0:	b585                	j	550 <vprintf+0x4a>
 6f2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f4:	008b8d13          	addi	s10,s7,8
 6f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fc:	03000593          	li	a1,48
 700:	855a                	mv	a0,s6
 702:	d3fff0ef          	jal	440 <putc>
  putc(fd, 'x');
 706:	07800593          	li	a1,120
 70a:	855a                	mv	a0,s6
 70c:	d35ff0ef          	jal	440 <putc>
 710:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 712:	00000b97          	auipc	s7,0x0
 716:	2feb8b93          	addi	s7,s7,766 # a10 <digits>
 71a:	03c9d793          	srli	a5,s3,0x3c
 71e:	97de                	add	a5,a5,s7
 720:	0007c583          	lbu	a1,0(a5)
 724:	855a                	mv	a0,s6
 726:	d1bff0ef          	jal	440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72a:	0992                	slli	s3,s3,0x4
 72c:	397d                	addiw	s2,s2,-1
 72e:	fe0916e3          	bnez	s2,71a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 732:	8bea                	mv	s7,s10
      state = 0;
 734:	4981                	li	s3,0
 736:	6d02                	ld	s10,0(sp)
 738:	bd21                	j	550 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 73a:	008b8993          	addi	s3,s7,8
 73e:	000bb903          	ld	s2,0(s7)
 742:	00090f63          	beqz	s2,760 <vprintf+0x25a>
        for(; *s; s++)
 746:	00094583          	lbu	a1,0(s2)
 74a:	c195                	beqz	a1,76e <vprintf+0x268>
          putc(fd, *s);
 74c:	855a                	mv	a0,s6
 74e:	cf3ff0ef          	jal	440 <putc>
        for(; *s; s++)
 752:	0905                	addi	s2,s2,1
 754:	00094583          	lbu	a1,0(s2)
 758:	f9f5                	bnez	a1,74c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbcd                	j	550 <vprintf+0x4a>
          s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	2a890913          	addi	s2,s2,680 # a08 <malloc+0x19c>
        for(; *s; s++)
 768:	02800593          	li	a1,40
 76c:	b7c5                	j	74c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bbf9                	j	550 <vprintf+0x4a>
 774:	64a6                	ld	s1,72(sp)
 776:	79e2                	ld	s3,56(sp)
 778:	7a42                	ld	s4,48(sp)
 77a:	7aa2                	ld	s5,40(sp)
 77c:	7b02                	ld	s6,32(sp)
 77e:	6be2                	ld	s7,24(sp)
 780:	6c42                	ld	s8,16(sp)
 782:	6ca2                	ld	s9,8(sp)
    }
  }
}
 784:	60e6                	ld	ra,88(sp)
 786:	6446                	ld	s0,80(sp)
 788:	6906                	ld	s2,64(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78e:	715d                	addi	sp,sp,-80
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e010                	sd	a2,0(s0)
 798:	e414                	sd	a3,8(s0)
 79a:	e818                	sd	a4,16(s0)
 79c:	ec1c                	sd	a5,24(s0)
 79e:	03043023          	sd	a6,32(s0)
 7a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7aa:	8622                	mv	a2,s0
 7ac:	d5bff0ef          	jal	506 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6161                	addi	sp,sp,80
 7b6:	8082                	ret

00000000000007b8 <printf>:

void
printf(const char *fmt, ...)
{
 7b8:	711d                	addi	sp,sp,-96
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e40c                	sd	a1,8(s0)
 7c2:	e810                	sd	a2,16(s0)
 7c4:	ec14                	sd	a3,24(s0)
 7c6:	f018                	sd	a4,32(s0)
 7c8:	f41c                	sd	a5,40(s0)
 7ca:	03043823          	sd	a6,48(s0)
 7ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	00840613          	addi	a2,s0,8
 7d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7da:	85aa                	mv	a1,a0
 7dc:	4505                	li	a0,1
 7de:	d29ff0ef          	jal	506 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret

00000000000007ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e422                	sd	s0,8(sp)
 7ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	00001797          	auipc	a5,0x1
 7f8:	80c7b783          	ld	a5,-2036(a5) # 1000 <freep>
 7fc:	a02d                	j	826 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fe:	4618                	lw	a4,8(a2)
 800:	9f2d                	addw	a4,a4,a1
 802:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	6310                	ld	a2,0(a4)
 80a:	a83d                	j	848 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80c:	ff852703          	lw	a4,-8(a0)
 810:	9f31                	addw	a4,a4,a2
 812:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 814:	ff053683          	ld	a3,-16(a0)
 818:	a091                	j	85c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x3a>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x4a>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x30>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059813          	slli	a6,a1,0x20
 83e:	01c85713          	srli	a4,a6,0x1c
 842:	9736                	add	a4,a4,a3
 844:	fae60de3          	beq	a2,a4,7fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061593          	slli	a1,a2,0x20
 852:	01c5d713          	srli	a4,a1,0x1c
 856:	973e                	add	a4,a4,a5
 858:	fae68ae3          	beq	a3,a4,80c <free+0x22>
    p->s.ptr = bp->s.ptr;
 85c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	6422                	ld	s0,8(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret

000000000000086c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	ec4e                	sd	s3,24(sp)
 876:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 878:	02051493          	slli	s1,a0,0x20
 87c:	9081                	srli	s1,s1,0x20
 87e:	04bd                	addi	s1,s1,15
 880:	8091                	srli	s1,s1,0x4
 882:	0014899b          	addiw	s3,s1,1
 886:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 888:	00000517          	auipc	a0,0x0
 88c:	77853503          	ld	a0,1912(a0) # 1000 <freep>
 890:	c915                	beqz	a0,8c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	08977a63          	bgeu	a4,s1,92a <malloc+0xbe>
 89a:	f04a                	sd	s2,32(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a2:	8a4e                	mv	s4,s3
 8a4:	0009871b          	sext.w	a4,s3
 8a8:	6685                	lui	a3,0x1
 8aa:	00d77363          	bgeu	a4,a3,8b0 <malloc+0x44>
 8ae:	6a05                	lui	s4,0x1
 8b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b8:	00000917          	auipc	s2,0x0
 8bc:	74890913          	addi	s2,s2,1864 # 1000 <freep>
  if(p == (char*)-1)
 8c0:	5afd                	li	s5,-1
 8c2:	a081                	j	902 <malloc+0x96>
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8cc:	00000797          	auipc	a5,0x0
 8d0:	74478793          	addi	a5,a5,1860 # 1010 <base>
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72f73623          	sd	a5,1836(a4) # 1000 <freep>
 8dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e2:	b7c1                	j	8a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e4:	6398                	ld	a4,0(a5)
 8e6:	e118                	sd	a4,0(a0)
 8e8:	a8a9                	j	942 <malloc+0xd6>
  hp->s.size = nu;
 8ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ee:	0541                	addi	a0,a0,16
 8f0:	efbff0ef          	jal	7ea <free>
  return freep;
 8f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f8:	c12d                	beqz	a0,95a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	02977263          	bgeu	a4,s1,922 <malloc+0xb6>
    if(p == freep)
 902:	00093703          	ld	a4,0(s2)
 906:	853e                	mv	a0,a5
 908:	fef719e3          	bne	a4,a5,8fa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 90c:	8552                	mv	a0,s4
 90e:	afbff0ef          	jal	408 <sbrk>
  if(p == (char*)-1)
 912:	fd551ce3          	bne	a0,s5,8ea <malloc+0x7e>
        return 0;
 916:	4501                	li	a0,0
 918:	7902                	ld	s2,32(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	a03d                	j	94e <malloc+0xe2>
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 92a:	fae48de3          	beq	s1,a4,8e4 <malloc+0x78>
        p->s.size -= nunits;
 92e:	4137073b          	subw	a4,a4,s3
 932:	c798                	sw	a4,8(a5)
        p += p->s.size;
 934:	02071693          	slli	a3,a4,0x20
 938:	01c6d713          	srli	a4,a3,0x1c
 93c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 942:	00000717          	auipc	a4,0x0
 946:	6aa73f23          	sd	a0,1726(a4) # 1000 <freep>
      return (void*)(p + 1);
 94a:	01078513          	addi	a0,a5,16
  }
}
 94e:	70e2                	ld	ra,56(sp)
 950:	7442                	ld	s0,48(sp)
 952:	74a2                	ld	s1,40(sp)
 954:	69e2                	ld	s3,24(sp)
 956:	6121                	addi	sp,sp,64
 958:	8082                	ret
 95a:	7902                	ld	s2,32(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	b7f5                	j	94e <malloc+0xe2>
