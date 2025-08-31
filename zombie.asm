
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2ae000ef          	jal	2b6 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2ac000ef          	jal	2be <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	336000ef          	jal	34e <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	292000ef          	jal	2be <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	1bc000ef          	jal	2d6 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	198000ef          	jal	2fe <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	1a2000ef          	jal	316 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	16a000ef          	jal	2e6 <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 286:	ce11                	beqz	a2,2a2 <strncmp+0x22>
 288:	00054783          	lbu	a5,0(a0)
 28c:	cf89                	beqz	a5,2a6 <strncmp+0x26>
 28e:	0005c703          	lbu	a4,0(a1)
 292:	00f71a63          	bne	a4,a5,2a6 <strncmp+0x26>
    n--, p++, q++;
 296:	367d                	addiw	a2,a2,-1
 298:	0505                	addi	a0,a0,1
 29a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 29c:	f675                	bnez	a2,288 <strncmp+0x8>
  if(n == 0)
    return 0;
 29e:	4501                	li	a0,0
 2a0:	a801                	j	2b0 <strncmp+0x30>
 2a2:	4501                	li	a0,0
 2a4:	a031                	j	2b0 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2a6:	00054503          	lbu	a0,0(a0)
 2aa:	0005c783          	lbu	a5,0(a1)
 2ae:	9d1d                	subw	a0,a0,a5
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b6:	4885                	li	a7,1
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <exit>:
.global exit
exit:
 li a7, SYS_exit
 2be:	4889                	li	a7,2
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c6:	488d                	li	a7,3
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ce:	4891                	li	a7,4
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <read>:
.global read
read:
 li a7, SYS_read
 2d6:	4895                	li	a7,5
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <write>:
.global write
write:
 li a7, SYS_write
 2de:	48c1                	li	a7,16
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <close>:
.global close
close:
 li a7, SYS_close
 2e6:	48d5                	li	a7,21
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <thread>:
.global thread
thread:
 li a7, SYS_thread
 35e:	48dd                	li	a7,23
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 366:	48e1                	li	a7,24
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 36e:	48d9                	li	a7,22
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 376:	48dd                	li	a7,23
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37e:	1101                	addi	sp,sp,-32
 380:	ec06                	sd	ra,24(sp)
 382:	e822                	sd	s0,16(sp)
 384:	1000                	addi	s0,sp,32
 386:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 38a:	4605                	li	a2,1
 38c:	fef40593          	addi	a1,s0,-17
 390:	f4fff0ef          	jal	2de <write>
}
 394:	60e2                	ld	ra,24(sp)
 396:	6442                	ld	s0,16(sp)
 398:	6105                	addi	sp,sp,32
 39a:	8082                	ret

000000000000039c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 39c:	715d                	addi	sp,sp,-80
 39e:	e486                	sd	ra,72(sp)
 3a0:	e0a2                	sd	s0,64(sp)
 3a2:	fc26                	sd	s1,56(sp)
 3a4:	0880                	addi	s0,sp,80
 3a6:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a8:	c299                	beqz	a3,3ae <printint+0x12>
 3aa:	0805c963          	bltz	a1,43c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ae:	2581                	sext.w	a1,a1
  neg = 0;
 3b0:	4881                	li	a7,0
 3b2:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b8:	2601                	sext.w	a2,a2
 3ba:	00000517          	auipc	a0,0x0
 3be:	4fe50513          	addi	a0,a0,1278 # 8b8 <digits>
 3c2:	883a                	mv	a6,a4
 3c4:	2705                	addiw	a4,a4,1
 3c6:	02c5f7bb          	remuw	a5,a1,a2
 3ca:	1782                	slli	a5,a5,0x20
 3cc:	9381                	srli	a5,a5,0x20
 3ce:	97aa                	add	a5,a5,a0
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	0005879b          	sext.w	a5,a1
 3dc:	02c5d5bb          	divuw	a1,a1,a2
 3e0:	0685                	addi	a3,a3,1
 3e2:	fec7f0e3          	bgeu	a5,a2,3c2 <printint+0x26>
  if(neg)
 3e6:	00088c63          	beqz	a7,3fe <printint+0x62>
    buf[i++] = '-';
 3ea:	fd070793          	addi	a5,a4,-48
 3ee:	00878733          	add	a4,a5,s0
 3f2:	02d00793          	li	a5,45
 3f6:	fef70423          	sb	a5,-24(a4)
 3fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05a63          	blez	a4,432 <printint+0x96>
 402:	f84a                	sd	s2,48(sp)
 404:	f44e                	sd	s3,40(sp)
 406:	fb840793          	addi	a5,s0,-72
 40a:	00e78933          	add	s2,a5,a4
 40e:	fff78993          	addi	s3,a5,-1
 412:	99ba                	add	s3,s3,a4
 414:	377d                	addiw	a4,a4,-1
 416:	1702                	slli	a4,a4,0x20
 418:	9301                	srli	a4,a4,0x20
 41a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41e:	fff94583          	lbu	a1,-1(s2)
 422:	8526                	mv	a0,s1
 424:	f5bff0ef          	jal	37e <putc>
  while(--i >= 0)
 428:	197d                	addi	s2,s2,-1
 42a:	ff391ae3          	bne	s2,s3,41e <printint+0x82>
 42e:	7942                	ld	s2,48(sp)
 430:	79a2                	ld	s3,40(sp)
}
 432:	60a6                	ld	ra,72(sp)
 434:	6406                	ld	s0,64(sp)
 436:	74e2                	ld	s1,56(sp)
 438:	6161                	addi	sp,sp,80
 43a:	8082                	ret
    x = -xx;
 43c:	40b005bb          	negw	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	bf85                	j	3b2 <printint+0x16>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	711d                	addi	sp,sp,-96
 446:	ec86                	sd	ra,88(sp)
 448:	e8a2                	sd	s0,80(sp)
 44a:	e0ca                	sd	s2,64(sp)
 44c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 44e:	0005c903          	lbu	s2,0(a1)
 452:	26090863          	beqz	s2,6c2 <vprintf+0x27e>
 456:	e4a6                	sd	s1,72(sp)
 458:	fc4e                	sd	s3,56(sp)
 45a:	f852                	sd	s4,48(sp)
 45c:	f456                	sd	s5,40(sp)
 45e:	f05a                	sd	s6,32(sp)
 460:	ec5e                	sd	s7,24(sp)
 462:	e862                	sd	s8,16(sp)
 464:	e466                	sd	s9,8(sp)
 466:	8b2a                	mv	s6,a0
 468:	8a2e                	mv	s4,a1
 46a:	8bb2                	mv	s7,a2
  state = 0;
 46c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 46e:	4481                	li	s1,0
 470:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 472:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 476:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 47a:	06c00c93          	li	s9,108
 47e:	a005                	j	49e <vprintf+0x5a>
        putc(fd, c0);
 480:	85ca                	mv	a1,s2
 482:	855a                	mv	a0,s6
 484:	efbff0ef          	jal	37e <putc>
 488:	a019                	j	48e <vprintf+0x4a>
    } else if(state == '%'){
 48a:	03598263          	beq	s3,s5,4ae <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 48e:	2485                	addiw	s1,s1,1
 490:	8726                	mv	a4,s1
 492:	009a07b3          	add	a5,s4,s1
 496:	0007c903          	lbu	s2,0(a5)
 49a:	20090c63          	beqz	s2,6b2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 49e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a2:	fe0994e3          	bnez	s3,48a <vprintf+0x46>
      if(c0 == '%'){
 4a6:	fd579de3          	bne	a5,s5,480 <vprintf+0x3c>
        state = '%';
 4aa:	89be                	mv	s3,a5
 4ac:	b7cd                	j	48e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ae:	00ea06b3          	add	a3,s4,a4
 4b2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b8:	c681                	beqz	a3,4c0 <vprintf+0x7c>
 4ba:	9752                	add	a4,a4,s4
 4bc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4c0:	03878f63          	beq	a5,s8,4fe <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4c4:	05978963          	beq	a5,s9,516 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c8:	07500713          	li	a4,117
 4cc:	0ee78363          	beq	a5,a4,5b2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4d0:	07800713          	li	a4,120
 4d4:	12e78563          	beq	a5,a4,5fe <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d8:	07000713          	li	a4,112
 4dc:	14e78a63          	beq	a5,a4,630 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4e0:	07300713          	li	a4,115
 4e4:	18e78a63          	beq	a5,a4,678 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e8:	02500713          	li	a4,37
 4ec:	04e79563          	bne	a5,a4,536 <vprintf+0xf2>
        putc(fd, '%');
 4f0:	02500593          	li	a1,37
 4f4:	855a                	mv	a0,s6
 4f6:	e89ff0ef          	jal	37e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bf49                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b8913          	addi	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	e91ff0ef          	jal	39c <printint>
 510:	8bca                	mv	s7,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	bfad                	j	48e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	06400793          	li	a5,100
 51a:	02f68963          	beq	a3,a5,54c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51e:	06c00793          	li	a5,108
 522:	04f68263          	beq	a3,a5,566 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 526:	07500793          	li	a5,117
 52a:	0af68063          	beq	a3,a5,5ca <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 52e:	07800793          	li	a5,120
 532:	0ef68263          	beq	a3,a5,616 <vprintf+0x1d2>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	e43ff0ef          	jal	37e <putc>
        putc(fd, c0);
 540:	85ca                	mv	a1,s2
 542:	855a                	mv	a0,s6
 544:	e3bff0ef          	jal	37e <putc>
      state = 0;
 548:	4981                	li	s3,0
 54a:	b791                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54c:	008b8913          	addi	s2,s7,8
 550:	4685                	li	a3,1
 552:	4629                	li	a2,10
 554:	000bb583          	ld	a1,0(s7)
 558:	855a                	mv	a0,s6
 55a:	e43ff0ef          	jal	39c <printint>
        i += 1;
 55e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
        i += 1;
 564:	b72d                	j	48e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 566:	06400793          	li	a5,100
 56a:	02f60763          	beq	a2,a5,598 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56e:	07500793          	li	a5,117
 572:	06f60963          	beq	a2,a5,5e4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 576:	07800793          	li	a5,120
 57a:	faf61ee3          	bne	a2,a5,536 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57e:	008b8913          	addi	s2,s7,8
 582:	4681                	li	a3,0
 584:	4641                	li	a2,16
 586:	000bb583          	ld	a1,0(s7)
 58a:	855a                	mv	a0,s6
 58c:	e11ff0ef          	jal	39c <printint>
        i += 2;
 590:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
        i += 2;
 596:	bde5                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	008b8913          	addi	s2,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000bb583          	ld	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	df7ff0ef          	jal	39c <printint>
        i += 2;
 5aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	bdf9                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	dddff0ef          	jal	39c <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b5d9                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	dc5ff0ef          	jal	39c <printint>
        i += 1;
 5dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
        i += 1;
 5e2:	b575                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	dabff0ef          	jal	39c <printint>
        i += 2;
 5f6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	bd49                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	d91ff0ef          	jal	39c <printint>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	bdad                	j	48e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8913          	addi	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	d79ff0ef          	jal	39c <printint>
        i += 1;
 628:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
        i += 1;
 62e:	b585                	j	48e <vprintf+0x4a>
 630:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 632:	008b8d13          	addi	s10,s7,8
 636:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 63a:	03000593          	li	a1,48
 63e:	855a                	mv	a0,s6
 640:	d3fff0ef          	jal	37e <putc>
  putc(fd, 'x');
 644:	07800593          	li	a1,120
 648:	855a                	mv	a0,s6
 64a:	d35ff0ef          	jal	37e <putc>
 64e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 650:	00000b97          	auipc	s7,0x0
 654:	268b8b93          	addi	s7,s7,616 # 8b8 <digits>
 658:	03c9d793          	srli	a5,s3,0x3c
 65c:	97de                	add	a5,a5,s7
 65e:	0007c583          	lbu	a1,0(a5)
 662:	855a                	mv	a0,s6
 664:	d1bff0ef          	jal	37e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 668:	0992                	slli	s3,s3,0x4
 66a:	397d                	addiw	s2,s2,-1
 66c:	fe0916e3          	bnez	s2,658 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 670:	8bea                	mv	s7,s10
      state = 0;
 672:	4981                	li	s3,0
 674:	6d02                	ld	s10,0(sp)
 676:	bd21                	j	48e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 678:	008b8993          	addi	s3,s7,8
 67c:	000bb903          	ld	s2,0(s7)
 680:	00090f63          	beqz	s2,69e <vprintf+0x25a>
        for(; *s; s++)
 684:	00094583          	lbu	a1,0(s2)
 688:	c195                	beqz	a1,6ac <vprintf+0x268>
          putc(fd, *s);
 68a:	855a                	mv	a0,s6
 68c:	cf3ff0ef          	jal	37e <putc>
        for(; *s; s++)
 690:	0905                	addi	s2,s2,1
 692:	00094583          	lbu	a1,0(s2)
 696:	f9f5                	bnez	a1,68a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 698:	8bce                	mv	s7,s3
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bbcd                	j	48e <vprintf+0x4a>
          s = "(null)";
 69e:	00000917          	auipc	s2,0x0
 6a2:	21290913          	addi	s2,s2,530 # 8b0 <malloc+0x106>
        for(; *s; s++)
 6a6:	02800593          	li	a1,40
 6aa:	b7c5                	j	68a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bbf9                	j	48e <vprintf+0x4a>
 6b2:	64a6                	ld	s1,72(sp)
 6b4:	79e2                	ld	s3,56(sp)
 6b6:	7a42                	ld	s4,48(sp)
 6b8:	7aa2                	ld	s5,40(sp)
 6ba:	7b02                	ld	s6,32(sp)
 6bc:	6be2                	ld	s7,24(sp)
 6be:	6c42                	ld	s8,16(sp)
 6c0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c2:	60e6                	ld	ra,88(sp)
 6c4:	6446                	ld	s0,80(sp)
 6c6:	6906                	ld	s2,64(sp)
 6c8:	6125                	addi	sp,sp,96
 6ca:	8082                	ret

00000000000006cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6cc:	715d                	addi	sp,sp,-80
 6ce:	ec06                	sd	ra,24(sp)
 6d0:	e822                	sd	s0,16(sp)
 6d2:	1000                	addi	s0,sp,32
 6d4:	e010                	sd	a2,0(s0)
 6d6:	e414                	sd	a3,8(s0)
 6d8:	e818                	sd	a4,16(s0)
 6da:	ec1c                	sd	a5,24(s0)
 6dc:	03043023          	sd	a6,32(s0)
 6e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e8:	8622                	mv	a2,s0
 6ea:	d5bff0ef          	jal	444 <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6161                	addi	sp,sp,80
 6f4:	8082                	ret

00000000000006f6 <printf>:

void
printf(const char *fmt, ...)
{
 6f6:	711d                	addi	sp,sp,-96
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	addi	s0,sp,32
 6fe:	e40c                	sd	a1,8(s0)
 700:	e810                	sd	a2,16(s0)
 702:	ec14                	sd	a3,24(s0)
 704:	f018                	sd	a4,32(s0)
 706:	f41c                	sd	a5,40(s0)
 708:	03043823          	sd	a6,48(s0)
 70c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	00840613          	addi	a2,s0,8
 714:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 718:	85aa                	mv	a1,a0
 71a:	4505                	li	a0,1
 71c:	d29ff0ef          	jal	444 <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6125                	addi	sp,sp,96
 726:	8082                	ret

0000000000000728 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 728:	1141                	addi	sp,sp,-16
 72a:	e422                	sd	s0,8(sp)
 72c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	00001797          	auipc	a5,0x1
 736:	8ce7b783          	ld	a5,-1842(a5) # 1000 <freep>
 73a:	a02d                	j	764 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73c:	4618                	lw	a4,8(a2)
 73e:	9f2d                	addw	a4,a4,a1
 740:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	6398                	ld	a4,0(a5)
 746:	6310                	ld	a2,0(a4)
 748:	a83d                	j	786 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74a:	ff852703          	lw	a4,-8(a0)
 74e:	9f31                	addw	a4,a4,a2
 750:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 752:	ff053683          	ld	a3,-16(a0)
 756:	a091                	j	79a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	6398                	ld	a4,0(a5)
 75a:	00e7e463          	bltu	a5,a4,762 <free+0x3a>
 75e:	00e6ea63          	bltu	a3,a4,772 <free+0x4a>
{
 762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	fed7fae3          	bgeu	a5,a3,758 <free+0x30>
 768:	6398                	ld	a4,0(a5)
 76a:	00e6e463          	bltu	a3,a4,772 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76e:	fee7eae3          	bltu	a5,a4,762 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 772:	ff852583          	lw	a1,-8(a0)
 776:	6390                	ld	a2,0(a5)
 778:	02059813          	slli	a6,a1,0x20
 77c:	01c85713          	srli	a4,a6,0x1c
 780:	9736                	add	a4,a4,a3
 782:	fae60de3          	beq	a2,a4,73c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78a:	4790                	lw	a2,8(a5)
 78c:	02061593          	slli	a1,a2,0x20
 790:	01c5d713          	srli	a4,a1,0x1c
 794:	973e                	add	a4,a4,a5
 796:	fae68ae3          	beq	a3,a4,74a <free+0x22>
    p->s.ptr = bp->s.ptr;
 79a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79c:	00001717          	auipc	a4,0x1
 7a0:	86f73223          	sd	a5,-1948(a4) # 1000 <freep>
}
 7a4:	6422                	ld	s0,8(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret

00000000000007aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7aa:	7139                	addi	sp,sp,-64
 7ac:	fc06                	sd	ra,56(sp)
 7ae:	f822                	sd	s0,48(sp)
 7b0:	f426                	sd	s1,40(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b6:	02051493          	slli	s1,a0,0x20
 7ba:	9081                	srli	s1,s1,0x20
 7bc:	04bd                	addi	s1,s1,15
 7be:	8091                	srli	s1,s1,0x4
 7c0:	0014899b          	addiw	s3,s1,1
 7c4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c6:	00001517          	auipc	a0,0x1
 7ca:	83a53503          	ld	a0,-1990(a0) # 1000 <freep>
 7ce:	c915                	beqz	a0,802 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d2:	4798                	lw	a4,8(a5)
 7d4:	08977a63          	bgeu	a4,s1,868 <malloc+0xbe>
 7d8:	f04a                	sd	s2,32(sp)
 7da:	e852                	sd	s4,16(sp)
 7dc:	e456                	sd	s5,8(sp)
 7de:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e0:	8a4e                	mv	s4,s3
 7e2:	0009871b          	sext.w	a4,s3
 7e6:	6685                	lui	a3,0x1
 7e8:	00d77363          	bgeu	a4,a3,7ee <malloc+0x44>
 7ec:	6a05                	lui	s4,0x1
 7ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f6:	00001917          	auipc	s2,0x1
 7fa:	80a90913          	addi	s2,s2,-2038 # 1000 <freep>
  if(p == (char*)-1)
 7fe:	5afd                	li	s5,-1
 800:	a081                	j	840 <malloc+0x96>
 802:	f04a                	sd	s2,32(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80a:	00001797          	auipc	a5,0x1
 80e:	80678793          	addi	a5,a5,-2042 # 1010 <base>
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
 81a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 820:	b7c1                	j	7e0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	e118                	sd	a4,0(a0)
 826:	a8a9                	j	880 <malloc+0xd6>
  hp->s.size = nu;
 828:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82c:	0541                	addi	a0,a0,16
 82e:	efbff0ef          	jal	728 <free>
  return freep;
 832:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 836:	c12d                	beqz	a0,898 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	02977263          	bgeu	a4,s1,860 <malloc+0xb6>
    if(p == freep)
 840:	00093703          	ld	a4,0(s2)
 844:	853e                	mv	a0,a5
 846:	fef719e3          	bne	a4,a5,838 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 84a:	8552                	mv	a0,s4
 84c:	afbff0ef          	jal	346 <sbrk>
  if(p == (char*)-1)
 850:	fd551ce3          	bne	a0,s5,828 <malloc+0x7e>
        return 0;
 854:	4501                	li	a0,0
 856:	7902                	ld	s2,32(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	a03d                	j	88c <malloc+0xe2>
 860:	7902                	ld	s2,32(sp)
 862:	6a42                	ld	s4,16(sp)
 864:	6aa2                	ld	s5,8(sp)
 866:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 868:	fae48de3          	beq	s1,a4,822 <malloc+0x78>
        p->s.size -= nunits;
 86c:	4137073b          	subw	a4,a4,s3
 870:	c798                	sw	a4,8(a5)
        p += p->s.size;
 872:	02071693          	slli	a3,a4,0x20
 876:	01c6d713          	srli	a4,a3,0x1c
 87a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 880:	00000717          	auipc	a4,0x0
 884:	78a73023          	sd	a0,1920(a4) # 1000 <freep>
      return (void*)(p + 1);
 888:	01078513          	addi	a0,a5,16
  }
}
 88c:	70e2                	ld	ra,56(sp)
 88e:	7442                	ld	s0,48(sp)
 890:	74a2                	ld	s1,40(sp)
 892:	69e2                	ld	s3,24(sp)
 894:	6121                	addi	sp,sp,64
 896:	8082                	ret
 898:	7902                	ld	s2,32(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	b7f5                	j	88c <malloc+0xe2>
