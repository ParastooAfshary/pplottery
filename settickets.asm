
user/_settickets:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50b63          	beq	a0,a5,20 <main+0x20>
    printf("Usage: settickets <num>\n");
   e:	00001517          	auipc	a0,0x1
  12:	8b250513          	addi	a0,a0,-1870 # 8c0 <malloc+0x104>
  16:	6f2000ef          	jal	708 <printf>
    exit(1);
  1a:	4505                	li	a0,1
  1c:	2b4000ef          	jal	2d0 <exit>
  }

  settickets(atoi(argv[1]));
  20:	6588                	ld	a0,8(a1)
  22:	182000ef          	jal	1a4 <atoi>
  26:	35a000ef          	jal	380 <settickets>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	2a4000ef          	jal	2d0 <exit>

0000000000000030 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  extern int main();
  main();
  38:	fc9ff0ef          	jal	0 <main>
  exit(0);
  3c:	4501                	li	a0,0
  3e:	292000ef          	jal	2d0 <exit>

0000000000000042 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	addi	a0,a0,1
  74:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	addi	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	86be                	mv	a3,a5
  9c:	0785                	addi	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	ff65                	bnez	a4,9a <strlen+0x10>
  a4:	40a6853b          	subw	a0,a3,a0
  a8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ca19                	beqz	a2,d0 <memset+0x1c>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x12>
  }
  return dst;
}
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strchr>:

char*
strchr(const char *s, char c)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cb99                	beqz	a5,f6 <strchr+0x20>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1a>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xc>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfe5                	j	f0 <strchr+0x1a>

00000000000000fa <gets>:

char*
gets(char *buf, int max)
{
  fa:	711d                	addi	sp,sp,-96
  fc:	ec86                	sd	ra,88(sp)
  fe:	e8a2                	sd	s0,80(sp)
 100:	e4a6                	sd	s1,72(sp)
 102:	e0ca                	sd	s2,64(sp)
 104:	fc4e                	sd	s3,56(sp)
 106:	f852                	sd	s4,48(sp)
 108:	f456                	sd	s5,40(sp)
 10a:	f05a                	sd	s6,32(sp)
 10c:	ec5e                	sd	s7,24(sp)
 10e:	1080                	addi	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 118:	4aa9                	li	s5,10
 11a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11c:	89a6                	mv	s3,s1
 11e:	2485                	addiw	s1,s1,1
 120:	0344d663          	bge	s1,s4,14c <gets+0x52>
    cc = read(0, &c, 1);
 124:	4605                	li	a2,1
 126:	faf40593          	addi	a1,s0,-81
 12a:	4501                	li	a0,0
 12c:	1bc000ef          	jal	2e8 <read>
    if(cc < 1)
 130:	00a05e63          	blez	a0,14c <gets+0x52>
    buf[i++] = c;
 134:	faf44783          	lbu	a5,-81(s0)
 138:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13c:	01578763          	beq	a5,s5,14a <gets+0x50>
 140:	0905                	addi	s2,s2,1
 142:	fd679de3          	bne	a5,s6,11c <gets+0x22>
    buf[i++] = c;
 146:	89a6                	mv	s3,s1
 148:	a011                	j	14c <gets+0x52>
 14a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14c:	99de                	add	s3,s3,s7
 14e:	00098023          	sb	zero,0(s3)
  return buf;
}
 152:	855e                	mv	a0,s7
 154:	60e6                	ld	ra,88(sp)
 156:	6446                	ld	s0,80(sp)
 158:	64a6                	ld	s1,72(sp)
 15a:	6906                	ld	s2,64(sp)
 15c:	79e2                	ld	s3,56(sp)
 15e:	7a42                	ld	s4,48(sp)
 160:	7aa2                	ld	s5,40(sp)
 162:	7b02                	ld	s6,32(sp)
 164:	6be2                	ld	s7,24(sp)
 166:	6125                	addi	sp,sp,96
 168:	8082                	ret

000000000000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	1101                	addi	sp,sp,-32
 16c:	ec06                	sd	ra,24(sp)
 16e:	e822                	sd	s0,16(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	4581                	li	a1,0
 178:	198000ef          	jal	310 <open>
  if(fd < 0)
 17c:	02054263          	bltz	a0,1a0 <stat+0x36>
 180:	e426                	sd	s1,8(sp)
 182:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 184:	85ca                	mv	a1,s2
 186:	1a2000ef          	jal	328 <fstat>
 18a:	892a                	mv	s2,a0
  close(fd);
 18c:	8526                	mv	a0,s1
 18e:	16a000ef          	jal	2f8 <close>
  return r;
 192:	64a2                	ld	s1,8(sp)
}
 194:	854a                	mv	a0,s2
 196:	60e2                	ld	ra,24(sp)
 198:	6442                	ld	s0,16(sp)
 19a:	6902                	ld	s2,0(sp)
 19c:	6105                	addi	sp,sp,32
 19e:	8082                	ret
    return -1;
 1a0:	597d                	li	s2,-1
 1a2:	bfcd                	j	194 <stat+0x2a>

00000000000001a4 <atoi>:

int
atoi(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1aa:	00054683          	lbu	a3,0(a0)
 1ae:	fd06879b          	addiw	a5,a3,-48
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	4625                	li	a2,9
 1b8:	02f66863          	bltu	a2,a5,1e8 <atoi+0x44>
 1bc:	872a                	mv	a4,a0
  n = 0;
 1be:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c0:	0705                	addi	a4,a4,1
 1c2:	0025179b          	slliw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	slliw	a5,a5,0x1
 1cc:	9fb5                	addw	a5,a5,a3
 1ce:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d2:	00074683          	lbu	a3,0(a4)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	fef671e3          	bgeu	a2,a5,1c0 <atoi+0x1c>
  return n;
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <atoi+0x3e>

00000000000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57463          	bgeu	a0,a1,21a <memmove+0x2e>
    while(n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x28>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 210:	fef71ae3          	bne	a4,a5,204 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
    dst += n;
 21a:	00c50733          	add	a4,a0,a2
    src += n;
 21e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 220:	fec05ae3          	blez	a2,214 <memmove+0x28>
 224:	fff6079b          	addiw	a5,a2,-1
 228:	1782                	slli	a5,a5,0x20
 22a:	9381                	srli	a5,a5,0x20
 22c:	fff7c793          	not	a5,a5
 230:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 232:	15fd                	addi	a1,a1,-1
 234:	177d                	addi	a4,a4,-1
 236:	0005c683          	lbu	a3,0(a1)
 23a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x46>
 242:	bfc9                	j	214 <memmove+0x28>

0000000000000244 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24a:	ca05                	beqz	a2,27a <memcmp+0x36>
 24c:	fff6069b          	addiw	a3,a2,-1
 250:	1682                	slli	a3,a3,0x20
 252:	9281                	srli	a3,a3,0x20
 254:	0685                	addi	a3,a3,1
 256:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x14>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x30>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  return 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <memcmp+0x30>

000000000000027e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 286:	f67ff0ef          	jal	1ec <memmove>
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 298:	ce11                	beqz	a2,2b4 <strncmp+0x22>
 29a:	00054783          	lbu	a5,0(a0)
 29e:	cf89                	beqz	a5,2b8 <strncmp+0x26>
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00f71a63          	bne	a4,a5,2b8 <strncmp+0x26>
    n--, p++, q++;
 2a8:	367d                	addiw	a2,a2,-1
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 2ae:	f675                	bnez	a2,29a <strncmp+0x8>
  if(n == 0)
    return 0;
 2b0:	4501                	li	a0,0
 2b2:	a801                	j	2c2 <strncmp+0x30>
 2b4:	4501                	li	a0,0
 2b6:	a031                	j	2c2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2b8:	00054503          	lbu	a0,0(a0)
 2bc:	0005c783          	lbu	a5,0(a1)
 2c0:	9d1d                	subw	a0,a0,a5
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c8:	4885                	li	a7,1
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d0:	4889                	li	a7,2
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d8:	488d                	li	a7,3
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <close>:
.global close
close:
 li a7, SYS_close
 2f8:	48d5                	li	a7,21
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48bd                	li	a7,15
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 318:	48c5                	li	a7,17
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 320:	48c9                	li	a7,18
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 328:	48a1                	li	a7,8
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <link>:
.global link
link:
 li a7, SYS_link
 330:	48cd                	li	a7,19
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 338:	48d1                	li	a7,20
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 340:	48a5                	li	a7,9
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <dup>:
.global dup
dup:
 li a7, SYS_dup
 348:	48a9                	li	a7,10
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 350:	48ad                	li	a7,11
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 358:	48b1                	li	a7,12
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 360:	48b5                	li	a7,13
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 368:	48b9                	li	a7,14
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <thread>:
.global thread
thread:
 li a7, SYS_thread
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 378:	48e1                	li	a7,24
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 380:	48d9                	li	a7,22
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 388:	48dd                	li	a7,23
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 390:	1101                	addi	sp,sp,-32
 392:	ec06                	sd	ra,24(sp)
 394:	e822                	sd	s0,16(sp)
 396:	1000                	addi	s0,sp,32
 398:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39c:	4605                	li	a2,1
 39e:	fef40593          	addi	a1,s0,-17
 3a2:	f4fff0ef          	jal	2f0 <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ae:	715d                	addi	sp,sp,-80
 3b0:	e486                	sd	ra,72(sp)
 3b2:	e0a2                	sd	s0,64(sp)
 3b4:	fc26                	sd	s1,56(sp)
 3b6:	0880                	addi	s0,sp,80
 3b8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ba:	c299                	beqz	a3,3c0 <printint+0x12>
 3bc:	0805c963          	bltz	a1,44e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c0:	2581                	sext.w	a1,a1
  neg = 0;
 3c2:	4881                	li	a7,0
 3c4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ca:	2601                	sext.w	a2,a2
 3cc:	00000517          	auipc	a0,0x0
 3d0:	51c50513          	addi	a0,a0,1308 # 8e8 <digits>
 3d4:	883a                	mv	a6,a4
 3d6:	2705                	addiw	a4,a4,1
 3d8:	02c5f7bb          	remuw	a5,a1,a2
 3dc:	1782                	slli	a5,a5,0x20
 3de:	9381                	srli	a5,a5,0x20
 3e0:	97aa                	add	a5,a5,a0
 3e2:	0007c783          	lbu	a5,0(a5)
 3e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ea:	0005879b          	sext.w	a5,a1
 3ee:	02c5d5bb          	divuw	a1,a1,a2
 3f2:	0685                	addi	a3,a3,1
 3f4:	fec7f0e3          	bgeu	a5,a2,3d4 <printint+0x26>
  if(neg)
 3f8:	00088c63          	beqz	a7,410 <printint+0x62>
    buf[i++] = '-';
 3fc:	fd070793          	addi	a5,a4,-48
 400:	00878733          	add	a4,a5,s0
 404:	02d00793          	li	a5,45
 408:	fef70423          	sb	a5,-24(a4)
 40c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 410:	02e05a63          	blez	a4,444 <printint+0x96>
 414:	f84a                	sd	s2,48(sp)
 416:	f44e                	sd	s3,40(sp)
 418:	fb840793          	addi	a5,s0,-72
 41c:	00e78933          	add	s2,a5,a4
 420:	fff78993          	addi	s3,a5,-1
 424:	99ba                	add	s3,s3,a4
 426:	377d                	addiw	a4,a4,-1
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	fff94583          	lbu	a1,-1(s2)
 434:	8526                	mv	a0,s1
 436:	f5bff0ef          	jal	390 <putc>
  while(--i >= 0)
 43a:	197d                	addi	s2,s2,-1
 43c:	ff391ae3          	bne	s2,s3,430 <printint+0x82>
 440:	7942                	ld	s2,48(sp)
 442:	79a2                	ld	s3,40(sp)
}
 444:	60a6                	ld	ra,72(sp)
 446:	6406                	ld	s0,64(sp)
 448:	74e2                	ld	s1,56(sp)
 44a:	6161                	addi	sp,sp,80
 44c:	8082                	ret
    x = -xx;
 44e:	40b005bb          	negw	a1,a1
    neg = 1;
 452:	4885                	li	a7,1
    x = -xx;
 454:	bf85                	j	3c4 <printint+0x16>

0000000000000456 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 456:	711d                	addi	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e0ca                	sd	s2,64(sp)
 45e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 460:	0005c903          	lbu	s2,0(a1)
 464:	26090863          	beqz	s2,6d4 <vprintf+0x27e>
 468:	e4a6                	sd	s1,72(sp)
 46a:	fc4e                	sd	s3,56(sp)
 46c:	f852                	sd	s4,48(sp)
 46e:	f456                	sd	s5,40(sp)
 470:	f05a                	sd	s6,32(sp)
 472:	ec5e                	sd	s7,24(sp)
 474:	e862                	sd	s8,16(sp)
 476:	e466                	sd	s9,8(sp)
 478:	8b2a                	mv	s6,a0
 47a:	8a2e                	mv	s4,a1
 47c:	8bb2                	mv	s7,a2
  state = 0;
 47e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 480:	4481                	li	s1,0
 482:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 484:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 488:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 48c:	06c00c93          	li	s9,108
 490:	a005                	j	4b0 <vprintf+0x5a>
        putc(fd, c0);
 492:	85ca                	mv	a1,s2
 494:	855a                	mv	a0,s6
 496:	efbff0ef          	jal	390 <putc>
 49a:	a019                	j	4a0 <vprintf+0x4a>
    } else if(state == '%'){
 49c:	03598263          	beq	s3,s5,4c0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4a0:	2485                	addiw	s1,s1,1
 4a2:	8726                	mv	a4,s1
 4a4:	009a07b3          	add	a5,s4,s1
 4a8:	0007c903          	lbu	s2,0(a5)
 4ac:	20090c63          	beqz	s2,6c4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4b0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b4:	fe0994e3          	bnez	s3,49c <vprintf+0x46>
      if(c0 == '%'){
 4b8:	fd579de3          	bne	a5,s5,492 <vprintf+0x3c>
        state = '%';
 4bc:	89be                	mv	s3,a5
 4be:	b7cd                	j	4a0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4c0:	00ea06b3          	add	a3,s4,a4
 4c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ca:	c681                	beqz	a3,4d2 <vprintf+0x7c>
 4cc:	9752                	add	a4,a4,s4
 4ce:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4d2:	03878f63          	beq	a5,s8,510 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4d6:	05978963          	beq	a5,s9,528 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4da:	07500713          	li	a4,117
 4de:	0ee78363          	beq	a5,a4,5c4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4e2:	07800713          	li	a4,120
 4e6:	12e78563          	beq	a5,a4,610 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ea:	07000713          	li	a4,112
 4ee:	14e78a63          	beq	a5,a4,642 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4f2:	07300713          	li	a4,115
 4f6:	18e78a63          	beq	a5,a4,68a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4fa:	02500713          	li	a4,37
 4fe:	04e79563          	bne	a5,a4,548 <vprintf+0xf2>
        putc(fd, '%');
 502:	02500593          	li	a1,37
 506:	855a                	mv	a0,s6
 508:	e89ff0ef          	jal	390 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 50c:	4981                	li	s3,0
 50e:	bf49                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 510:	008b8913          	addi	s2,s7,8
 514:	4685                	li	a3,1
 516:	4629                	li	a2,10
 518:	000ba583          	lw	a1,0(s7)
 51c:	855a                	mv	a0,s6
 51e:	e91ff0ef          	jal	3ae <printint>
 522:	8bca                	mv	s7,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	bfad                	j	4a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 528:	06400793          	li	a5,100
 52c:	02f68963          	beq	a3,a5,55e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 530:	06c00793          	li	a5,108
 534:	04f68263          	beq	a3,a5,578 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 538:	07500793          	li	a5,117
 53c:	0af68063          	beq	a3,a5,5dc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 540:	07800793          	li	a5,120
 544:	0ef68263          	beq	a3,a5,628 <vprintf+0x1d2>
        putc(fd, '%');
 548:	02500593          	li	a1,37
 54c:	855a                	mv	a0,s6
 54e:	e43ff0ef          	jal	390 <putc>
        putc(fd, c0);
 552:	85ca                	mv	a1,s2
 554:	855a                	mv	a0,s6
 556:	e3bff0ef          	jal	390 <putc>
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b791                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	008b8913          	addi	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000bb583          	ld	a1,0(s7)
 56a:	855a                	mv	a0,s6
 56c:	e43ff0ef          	jal	3ae <printint>
        i += 1;
 570:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 572:	8bca                	mv	s7,s2
      state = 0;
 574:	4981                	li	s3,0
        i += 1;
 576:	b72d                	j	4a0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 578:	06400793          	li	a5,100
 57c:	02f60763          	beq	a2,a5,5aa <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 580:	07500793          	li	a5,117
 584:	06f60963          	beq	a2,a5,5f6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 588:	07800793          	li	a5,120
 58c:	faf61ee3          	bne	a2,a5,548 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	008b8913          	addi	s2,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000bb583          	ld	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e11ff0ef          	jal	3ae <printint>
        i += 2;
 5a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	8bca                	mv	s7,s2
      state = 0;
 5a6:	4981                	li	s3,0
        i += 2;
 5a8:	bde5                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000bb583          	ld	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	df7ff0ef          	jal	3ae <printint>
        i += 2;
 5bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
        i += 2;
 5c2:	bdf9                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	dddff0ef          	jal	3ae <printint>
 5d6:	8bca                	mv	s7,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b5d9                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	dc5ff0ef          	jal	3ae <printint>
        i += 1;
 5ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	8bca                	mv	s7,s2
      state = 0;
 5f2:	4981                	li	s3,0
        i += 1;
 5f4:	b575                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000bb583          	ld	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	dabff0ef          	jal	3ae <printint>
        i += 2;
 608:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
        i += 2;
 60e:	bd49                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	d91ff0ef          	jal	3ae <printint>
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	bdad                	j	4a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	008b8913          	addi	s2,s7,8
 62c:	4681                	li	a3,0
 62e:	4641                	li	a2,16
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	d79ff0ef          	jal	3ae <printint>
        i += 1;
 63a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
        i += 1;
 640:	b585                	j	4a0 <vprintf+0x4a>
 642:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 644:	008b8d13          	addi	s10,s7,8
 648:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 64c:	03000593          	li	a1,48
 650:	855a                	mv	a0,s6
 652:	d3fff0ef          	jal	390 <putc>
  putc(fd, 'x');
 656:	07800593          	li	a1,120
 65a:	855a                	mv	a0,s6
 65c:	d35ff0ef          	jal	390 <putc>
 660:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 662:	00000b97          	auipc	s7,0x0
 666:	286b8b93          	addi	s7,s7,646 # 8e8 <digits>
 66a:	03c9d793          	srli	a5,s3,0x3c
 66e:	97de                	add	a5,a5,s7
 670:	0007c583          	lbu	a1,0(a5)
 674:	855a                	mv	a0,s6
 676:	d1bff0ef          	jal	390 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67a:	0992                	slli	s3,s3,0x4
 67c:	397d                	addiw	s2,s2,-1
 67e:	fe0916e3          	bnez	s2,66a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 682:	8bea                	mv	s7,s10
      state = 0;
 684:	4981                	li	s3,0
 686:	6d02                	ld	s10,0(sp)
 688:	bd21                	j	4a0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 68a:	008b8993          	addi	s3,s7,8
 68e:	000bb903          	ld	s2,0(s7)
 692:	00090f63          	beqz	s2,6b0 <vprintf+0x25a>
        for(; *s; s++)
 696:	00094583          	lbu	a1,0(s2)
 69a:	c195                	beqz	a1,6be <vprintf+0x268>
          putc(fd, *s);
 69c:	855a                	mv	a0,s6
 69e:	cf3ff0ef          	jal	390 <putc>
        for(; *s; s++)
 6a2:	0905                	addi	s2,s2,1
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	f9f5                	bnez	a1,69c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6aa:	8bce                	mv	s7,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bbcd                	j	4a0 <vprintf+0x4a>
          s = "(null)";
 6b0:	00000917          	auipc	s2,0x0
 6b4:	23090913          	addi	s2,s2,560 # 8e0 <malloc+0x124>
        for(; *s; s++)
 6b8:	02800593          	li	a1,40
 6bc:	b7c5                	j	69c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6be:	8bce                	mv	s7,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bbf9                	j	4a0 <vprintf+0x4a>
 6c4:	64a6                	ld	s1,72(sp)
 6c6:	79e2                	ld	s3,56(sp)
 6c8:	7a42                	ld	s4,48(sp)
 6ca:	7aa2                	ld	s5,40(sp)
 6cc:	7b02                	ld	s6,32(sp)
 6ce:	6be2                	ld	s7,24(sp)
 6d0:	6c42                	ld	s8,16(sp)
 6d2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6d4:	60e6                	ld	ra,88(sp)
 6d6:	6446                	ld	s0,80(sp)
 6d8:	6906                	ld	s2,64(sp)
 6da:	6125                	addi	sp,sp,96
 6dc:	8082                	ret

00000000000006de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e010                	sd	a2,0(s0)
 6e8:	e414                	sd	a3,8(s0)
 6ea:	e818                	sd	a4,16(s0)
 6ec:	ec1c                	sd	a5,24(s0)
 6ee:	03043023          	sd	a6,32(s0)
 6f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fa:	8622                	mv	a2,s0
 6fc:	d5bff0ef          	jal	456 <vprintf>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6161                	addi	sp,sp,80
 706:	8082                	ret

0000000000000708 <printf>:

void
printf(const char *fmt, ...)
{
 708:	711d                	addi	sp,sp,-96
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e40c                	sd	a1,8(s0)
 712:	e810                	sd	a2,16(s0)
 714:	ec14                	sd	a3,24(s0)
 716:	f018                	sd	a4,32(s0)
 718:	f41c                	sd	a5,40(s0)
 71a:	03043823          	sd	a6,48(s0)
 71e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	00840613          	addi	a2,s0,8
 726:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72a:	85aa                	mv	a1,a0
 72c:	4505                	li	a0,1
 72e:	d29ff0ef          	jal	456 <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73a:	1141                	addi	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	00001797          	auipc	a5,0x1
 748:	8bc7b783          	ld	a5,-1860(a5) # 1000 <freep>
 74c:	a02d                	j	776 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74e:	4618                	lw	a4,8(a2)
 750:	9f2d                	addw	a4,a4,a1
 752:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	6398                	ld	a4,0(a5)
 758:	6310                	ld	a2,0(a4)
 75a:	a83d                	j	798 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75c:	ff852703          	lw	a4,-8(a0)
 760:	9f31                	addw	a4,a4,a2
 762:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 764:	ff053683          	ld	a3,-16(a0)
 768:	a091                	j	7ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x3a>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x4a>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x30>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	slli	a6,a1,0x20
 78e:	01c85713          	srli	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	fae60de3          	beq	a2,a4,74e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	slli	a1,a2,0x20
 7a2:	01c5d713          	srli	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	fae68ae3          	beq	a3,a4,75c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
}
 7b6:	6422                	ld	s0,8(sp)
 7b8:	0141                	addi	sp,sp,16
 7ba:	8082                	ret

00000000000007bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7bc:	7139                	addi	sp,sp,-64
 7be:	fc06                	sd	ra,56(sp)
 7c0:	f822                	sd	s0,48(sp)
 7c2:	f426                	sd	s1,40(sp)
 7c4:	ec4e                	sd	s3,24(sp)
 7c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c8:	02051493          	slli	s1,a0,0x20
 7cc:	9081                	srli	s1,s1,0x20
 7ce:	04bd                	addi	s1,s1,15
 7d0:	8091                	srli	s1,s1,0x4
 7d2:	0014899b          	addiw	s3,s1,1
 7d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d8:	00001517          	auipc	a0,0x1
 7dc:	82853503          	ld	a0,-2008(a0) # 1000 <freep>
 7e0:	c915                	beqz	a0,814 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e4:	4798                	lw	a4,8(a5)
 7e6:	08977a63          	bgeu	a4,s1,87a <malloc+0xbe>
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7f2:	8a4e                	mv	s4,s3
 7f4:	0009871b          	sext.w	a4,s3
 7f8:	6685                	lui	a3,0x1
 7fa:	00d77363          	bgeu	a4,a3,800 <malloc+0x44>
 7fe:	6a05                	lui	s4,0x1
 800:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 804:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 808:	00000917          	auipc	s2,0x0
 80c:	7f890913          	addi	s2,s2,2040 # 1000 <freep>
  if(p == (char*)-1)
 810:	5afd                	li	s5,-1
 812:	a081                	j	852 <malloc+0x96>
 814:	f04a                	sd	s2,32(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 81c:	00000797          	auipc	a5,0x0
 820:	7f478793          	addi	a5,a5,2036 # 1010 <base>
 824:	00000717          	auipc	a4,0x0
 828:	7cf73e23          	sd	a5,2012(a4) # 1000 <freep>
 82c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 832:	b7c1                	j	7f2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	e118                	sd	a4,0(a0)
 838:	a8a9                	j	892 <malloc+0xd6>
  hp->s.size = nu;
 83a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83e:	0541                	addi	a0,a0,16
 840:	efbff0ef          	jal	73a <free>
  return freep;
 844:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 848:	c12d                	beqz	a0,8aa <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	02977263          	bgeu	a4,s1,872 <malloc+0xb6>
    if(p == freep)
 852:	00093703          	ld	a4,0(s2)
 856:	853e                	mv	a0,a5
 858:	fef719e3          	bne	a4,a5,84a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 85c:	8552                	mv	a0,s4
 85e:	afbff0ef          	jal	358 <sbrk>
  if(p == (char*)-1)
 862:	fd551ce3          	bne	a0,s5,83a <malloc+0x7e>
        return 0;
 866:	4501                	li	a0,0
 868:	7902                	ld	s2,32(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
 870:	a03d                	j	89e <malloc+0xe2>
 872:	7902                	ld	s2,32(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 87a:	fae48de3          	beq	s1,a4,834 <malloc+0x78>
        p->s.size -= nunits;
 87e:	4137073b          	subw	a4,a4,s3
 882:	c798                	sw	a4,8(a5)
        p += p->s.size;
 884:	02071693          	slli	a3,a4,0x20
 888:	01c6d713          	srli	a4,a3,0x1c
 88c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 892:	00000717          	auipc	a4,0x0
 896:	76a73723          	sd	a0,1902(a4) # 1000 <freep>
      return (void*)(p + 1);
 89a:	01078513          	addi	a0,a5,16
  }
}
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	69e2                	ld	s3,24(sp)
 8a6:	6121                	addi	sp,sp,64
 8a8:	8082                	ret
 8aa:	7902                	ld	s2,32(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
 8b2:	b7f5                	j	89e <malloc+0xe2>
