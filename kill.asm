
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	1c8 <atoi>
  2c:	2f8000ef          	jal	324 <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2bc000ef          	jal	2f4 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8a058593          	addi	a1,a1,-1888 # 8e0 <malloc+0x100>
  48:	4509                	li	a0,2
  4a:	6b8000ef          	jal	702 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2a4000ef          	jal	2f4 <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	292000ef          	jal	2f4 <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	86be                	mv	a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	ff65                	bnez	a4,be <strlen+0x10>
  c8:	40a6853b          	subw	a0,a3,a0
  cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	1bc000ef          	jal	30c <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	198000ef          	jal	334 <open>
  if(fd < 0)
 1a0:	02054263          	bltz	a0,1c4 <stat+0x36>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	1a2000ef          	jal	34c <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	16a000ef          	jal	31c <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x2a>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f67ff0ef          	jal	210 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
 2bc:	ce11                	beqz	a2,2d8 <strncmp+0x22>
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	cf89                	beqz	a5,2dc <strncmp+0x26>
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00f71a63          	bne	a4,a5,2dc <strncmp+0x26>
    n--, p++, q++;
 2cc:	367d                	addiw	a2,a2,-1
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
 2d2:	f675                	bnez	a2,2be <strncmp+0x8>
  if(n == 0)
    return 0;
 2d4:	4501                	li	a0,0
 2d6:	a801                	j	2e6 <strncmp+0x30>
 2d8:	4501                	li	a0,0
 2da:	a031                	j	2e6 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
 2dc:	00054503          	lbu	a0,0(a0)
 2e0:	0005c783          	lbu	a5,0(a1)
 2e4:	9d1d                	subw	a0,a0,a5
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ec:	4885                	li	a7,1
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f4:	4889                	li	a7,2
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fc:	488d                	li	a7,3
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 304:	4891                	li	a7,4
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <read>:
.global read
read:
 li a7, SYS_read
 30c:	4895                	li	a7,5
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <write>:
.global write
write:
 li a7, SYS_write
 314:	48c1                	li	a7,16
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <close>:
.global close
close:
 li a7, SYS_close
 31c:	48d5                	li	a7,21
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <kill>:
.global kill
kill:
 li a7, SYS_kill
 324:	4899                	li	a7,6
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exec>:
.global exec
exec:
 li a7, SYS_exec
 32c:	489d                	li	a7,7
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <open>:
.global open
open:
 li a7, SYS_open
 334:	48bd                	li	a7,15
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33c:	48c5                	li	a7,17
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 344:	48c9                	li	a7,18
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34c:	48a1                	li	a7,8
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <link>:
.global link
link:
 li a7, SYS_link
 354:	48cd                	li	a7,19
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35c:	48d1                	li	a7,20
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 364:	48a5                	li	a7,9
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <dup>:
.global dup
dup:
 li a7, SYS_dup
 36c:	48a9                	li	a7,10
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 374:	48ad                	li	a7,11
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37c:	48b1                	li	a7,12
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 384:	48b5                	li	a7,13
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38c:	48b9                	li	a7,14
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <thread>:
.global thread
thread:
 li a7, SYS_thread
 394:	48dd                	li	a7,23
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
 39c:	48e1                	li	a7,24
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b4:	1101                	addi	sp,sp,-32
 3b6:	ec06                	sd	ra,24(sp)
 3b8:	e822                	sd	s0,16(sp)
 3ba:	1000                	addi	s0,sp,32
 3bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c0:	4605                	li	a2,1
 3c2:	fef40593          	addi	a1,s0,-17
 3c6:	f4fff0ef          	jal	314 <write>
}
 3ca:	60e2                	ld	ra,24(sp)
 3cc:	6442                	ld	s0,16(sp)
 3ce:	6105                	addi	sp,sp,32
 3d0:	8082                	ret

00000000000003d2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d2:	715d                	addi	sp,sp,-80
 3d4:	e486                	sd	ra,72(sp)
 3d6:	e0a2                	sd	s0,64(sp)
 3d8:	fc26                	sd	s1,56(sp)
 3da:	0880                	addi	s0,sp,80
 3dc:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3de:	c299                	beqz	a3,3e4 <printint+0x12>
 3e0:	0805c963          	bltz	a1,472 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e4:	2581                	sext.w	a1,a1
  neg = 0;
 3e6:	4881                	li	a7,0
 3e8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ee:	2601                	sext.w	a2,a2
 3f0:	00000517          	auipc	a0,0x0
 3f4:	51050513          	addi	a0,a0,1296 # 900 <digits>
 3f8:	883a                	mv	a6,a4
 3fa:	2705                	addiw	a4,a4,1
 3fc:	02c5f7bb          	remuw	a5,a1,a2
 400:	1782                	slli	a5,a5,0x20
 402:	9381                	srli	a5,a5,0x20
 404:	97aa                	add	a5,a5,a0
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40e:	0005879b          	sext.w	a5,a1
 412:	02c5d5bb          	divuw	a1,a1,a2
 416:	0685                	addi	a3,a3,1
 418:	fec7f0e3          	bgeu	a5,a2,3f8 <printint+0x26>
  if(neg)
 41c:	00088c63          	beqz	a7,434 <printint+0x62>
    buf[i++] = '-';
 420:	fd070793          	addi	a5,a4,-48
 424:	00878733          	add	a4,a5,s0
 428:	02d00793          	li	a5,45
 42c:	fef70423          	sb	a5,-24(a4)
 430:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 434:	02e05a63          	blez	a4,468 <printint+0x96>
 438:	f84a                	sd	s2,48(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	fb840793          	addi	a5,s0,-72
 440:	00e78933          	add	s2,a5,a4
 444:	fff78993          	addi	s3,a5,-1
 448:	99ba                	add	s3,s3,a4
 44a:	377d                	addiw	a4,a4,-1
 44c:	1702                	slli	a4,a4,0x20
 44e:	9301                	srli	a4,a4,0x20
 450:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 454:	fff94583          	lbu	a1,-1(s2)
 458:	8526                	mv	a0,s1
 45a:	f5bff0ef          	jal	3b4 <putc>
  while(--i >= 0)
 45e:	197d                	addi	s2,s2,-1
 460:	ff391ae3          	bne	s2,s3,454 <printint+0x82>
 464:	7942                	ld	s2,48(sp)
 466:	79a2                	ld	s3,40(sp)
}
 468:	60a6                	ld	ra,72(sp)
 46a:	6406                	ld	s0,64(sp)
 46c:	74e2                	ld	s1,56(sp)
 46e:	6161                	addi	sp,sp,80
 470:	8082                	ret
    x = -xx;
 472:	40b005bb          	negw	a1,a1
    neg = 1;
 476:	4885                	li	a7,1
    x = -xx;
 478:	bf85                	j	3e8 <printint+0x16>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	711d                	addi	sp,sp,-96
 47c:	ec86                	sd	ra,88(sp)
 47e:	e8a2                	sd	s0,80(sp)
 480:	e0ca                	sd	s2,64(sp)
 482:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c903          	lbu	s2,0(a1)
 488:	26090863          	beqz	s2,6f8 <vprintf+0x27e>
 48c:	e4a6                	sd	s1,72(sp)
 48e:	fc4e                	sd	s3,56(sp)
 490:	f852                	sd	s4,48(sp)
 492:	f456                	sd	s5,40(sp)
 494:	f05a                	sd	s6,32(sp)
 496:	ec5e                	sd	s7,24(sp)
 498:	e862                	sd	s8,16(sp)
 49a:	e466                	sd	s9,8(sp)
 49c:	8b2a                	mv	s6,a0
 49e:	8a2e                	mv	s4,a1
 4a0:	8bb2                	mv	s7,a2
  state = 0;
 4a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a4:	4481                	li	s1,0
 4a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b0:	06c00c93          	li	s9,108
 4b4:	a005                	j	4d4 <vprintf+0x5a>
        putc(fd, c0);
 4b6:	85ca                	mv	a1,s2
 4b8:	855a                	mv	a0,s6
 4ba:	efbff0ef          	jal	3b4 <putc>
 4be:	a019                	j	4c4 <vprintf+0x4a>
    } else if(state == '%'){
 4c0:	03598263          	beq	s3,s5,4e4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4c4:	2485                	addiw	s1,s1,1
 4c6:	8726                	mv	a4,s1
 4c8:	009a07b3          	add	a5,s4,s1
 4cc:	0007c903          	lbu	s2,0(a5)
 4d0:	20090c63          	beqz	s2,6e8 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d8:	fe0994e3          	bnez	s3,4c0 <vprintf+0x46>
      if(c0 == '%'){
 4dc:	fd579de3          	bne	a5,s5,4b6 <vprintf+0x3c>
        state = '%';
 4e0:	89be                	mv	s3,a5
 4e2:	b7cd                	j	4c4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e4:	00ea06b3          	add	a3,s4,a4
 4e8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ec:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ee:	c681                	beqz	a3,4f6 <vprintf+0x7c>
 4f0:	9752                	add	a4,a4,s4
 4f2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f6:	03878f63          	beq	a5,s8,534 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4fa:	05978963          	beq	a5,s9,54c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fe:	07500713          	li	a4,117
 502:	0ee78363          	beq	a5,a4,5e8 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 506:	07800713          	li	a4,120
 50a:	12e78563          	beq	a5,a4,634 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 50e:	07000713          	li	a4,112
 512:	14e78a63          	beq	a5,a4,666 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 516:	07300713          	li	a4,115
 51a:	18e78a63          	beq	a5,a4,6ae <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 51e:	02500713          	li	a4,37
 522:	04e79563          	bne	a5,a4,56c <vprintf+0xf2>
        putc(fd, '%');
 526:	02500593          	li	a1,37
 52a:	855a                	mv	a0,s6
 52c:	e89ff0ef          	jal	3b4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 530:	4981                	li	s3,0
 532:	bf49                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b8913          	addi	s2,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	e91ff0ef          	jal	3d2 <printint>
 546:	8bca                	mv	s7,s2
      state = 0;
 548:	4981                	li	s3,0
 54a:	bfad                	j	4c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 54c:	06400793          	li	a5,100
 550:	02f68963          	beq	a3,a5,582 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 554:	06c00793          	li	a5,108
 558:	04f68263          	beq	a3,a5,59c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 55c:	07500793          	li	a5,117
 560:	0af68063          	beq	a3,a5,600 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 564:	07800793          	li	a5,120
 568:	0ef68263          	beq	a3,a5,64c <vprintf+0x1d2>
        putc(fd, '%');
 56c:	02500593          	li	a1,37
 570:	855a                	mv	a0,s6
 572:	e43ff0ef          	jal	3b4 <putc>
        putc(fd, c0);
 576:	85ca                	mv	a1,s2
 578:	855a                	mv	a0,s6
 57a:	e3bff0ef          	jal	3b4 <putc>
      state = 0;
 57e:	4981                	li	s3,0
 580:	b791                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	008b8913          	addi	s2,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000bb583          	ld	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e43ff0ef          	jal	3d2 <printint>
        i += 1;
 594:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	8bca                	mv	s7,s2
      state = 0;
 598:	4981                	li	s3,0
        i += 1;
 59a:	b72d                	j	4c4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59c:	06400793          	li	a5,100
 5a0:	02f60763          	beq	a2,a5,5ce <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a4:	07500793          	li	a5,117
 5a8:	06f60963          	beq	a2,a5,61a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ac:	07800793          	li	a5,120
 5b0:	faf61ee3          	bne	a2,a5,56c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e11ff0ef          	jal	3d2 <printint>
        i += 2;
 5c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	bde5                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000bb583          	ld	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	df7ff0ef          	jal	3d2 <printint>
        i += 2;
 5e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
        i += 2;
 5e6:	bdf9                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	dddff0ef          	jal	3d2 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b5d9                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8913          	addi	s2,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	dc5ff0ef          	jal	3d2 <printint>
        i += 1;
 612:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
        i += 1;
 618:	b575                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000bb583          	ld	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	dabff0ef          	jal	3d2 <printint>
        i += 2;
 62c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
        i += 2;
 632:	bd49                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	d91ff0ef          	jal	3d2 <printint>
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bdad                	j	4c4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8913          	addi	s2,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	d79ff0ef          	jal	3d2 <printint>
        i += 1;
 65e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 1;
 664:	b585                	j	4c4 <vprintf+0x4a>
 666:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 668:	008b8d13          	addi	s10,s7,8
 66c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 670:	03000593          	li	a1,48
 674:	855a                	mv	a0,s6
 676:	d3fff0ef          	jal	3b4 <putc>
  putc(fd, 'x');
 67a:	07800593          	li	a1,120
 67e:	855a                	mv	a0,s6
 680:	d35ff0ef          	jal	3b4 <putc>
 684:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	27ab8b93          	addi	s7,s7,634 # 900 <digits>
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	855a                	mv	a0,s6
 69a:	d1bff0ef          	jal	3b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69e:	0992                	slli	s3,s3,0x4
 6a0:	397d                	addiw	s2,s2,-1
 6a2:	fe0916e3          	bnez	s2,68e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6a6:	8bea                	mv	s7,s10
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	6d02                	ld	s10,0(sp)
 6ac:	bd21                	j	4c4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ae:	008b8993          	addi	s3,s7,8
 6b2:	000bb903          	ld	s2,0(s7)
 6b6:	00090f63          	beqz	s2,6d4 <vprintf+0x25a>
        for(; *s; s++)
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	c195                	beqz	a1,6e2 <vprintf+0x268>
          putc(fd, *s);
 6c0:	855a                	mv	a0,s6
 6c2:	cf3ff0ef          	jal	3b4 <putc>
        for(; *s; s++)
 6c6:	0905                	addi	s2,s2,1
 6c8:	00094583          	lbu	a1,0(s2)
 6cc:	f9f5                	bnez	a1,6c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bbcd                	j	4c4 <vprintf+0x4a>
          s = "(null)";
 6d4:	00000917          	auipc	s2,0x0
 6d8:	22490913          	addi	s2,s2,548 # 8f8 <malloc+0x118>
        for(; *s; s++)
 6dc:	02800593          	li	a1,40
 6e0:	b7c5                	j	6c0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6e2:	8bce                	mv	s7,s3
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bbf9                	j	4c4 <vprintf+0x4a>
 6e8:	64a6                	ld	s1,72(sp)
 6ea:	79e2                	ld	s3,56(sp)
 6ec:	7a42                	ld	s4,48(sp)
 6ee:	7aa2                	ld	s5,40(sp)
 6f0:	7b02                	ld	s6,32(sp)
 6f2:	6be2                	ld	s7,24(sp)
 6f4:	6c42                	ld	s8,16(sp)
 6f6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6f8:	60e6                	ld	ra,88(sp)
 6fa:	6446                	ld	s0,80(sp)
 6fc:	6906                	ld	s2,64(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret

0000000000000702 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 702:	715d                	addi	sp,sp,-80
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	e010                	sd	a2,0(s0)
 70c:	e414                	sd	a3,8(s0)
 70e:	e818                	sd	a4,16(s0)
 710:	ec1c                	sd	a5,24(s0)
 712:	03043023          	sd	a6,32(s0)
 716:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71e:	8622                	mv	a2,s0
 720:	d5bff0ef          	jal	47a <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6161                	addi	sp,sp,80
 72a:	8082                	ret

000000000000072c <printf>:

void
printf(const char *fmt, ...)
{
 72c:	711d                	addi	sp,sp,-96
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e40c                	sd	a1,8(s0)
 736:	e810                	sd	a2,16(s0)
 738:	ec14                	sd	a3,24(s0)
 73a:	f018                	sd	a4,32(s0)
 73c:	f41c                	sd	a5,40(s0)
 73e:	03043823          	sd	a6,48(s0)
 742:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 746:	00840613          	addi	a2,s0,8
 74a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74e:	85aa                	mv	a1,a0
 750:	4505                	li	a0,1
 752:	d29ff0ef          	jal	47a <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret

000000000000075e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75e:	1141                	addi	sp,sp,-16
 760:	e422                	sd	s0,8(sp)
 762:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 764:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	00001797          	auipc	a5,0x1
 76c:	8987b783          	ld	a5,-1896(a5) # 1000 <freep>
 770:	a02d                	j	79a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 772:	4618                	lw	a4,8(a2)
 774:	9f2d                	addw	a4,a4,a1
 776:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77a:	6398                	ld	a4,0(a5)
 77c:	6310                	ld	a2,0(a4)
 77e:	a83d                	j	7bc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 780:	ff852703          	lw	a4,-8(a0)
 784:	9f31                	addw	a4,a4,a2
 786:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 788:	ff053683          	ld	a3,-16(a0)
 78c:	a091                	j	7d0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	6398                	ld	a4,0(a5)
 790:	00e7e463          	bltu	a5,a4,798 <free+0x3a>
 794:	00e6ea63          	bltu	a3,a4,7a8 <free+0x4a>
{
 798:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	fed7fae3          	bgeu	a5,a3,78e <free+0x30>
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e6e463          	bltu	a3,a4,7a8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	fee7eae3          	bltu	a5,a4,798 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7a8:	ff852583          	lw	a1,-8(a0)
 7ac:	6390                	ld	a2,0(a5)
 7ae:	02059813          	slli	a6,a1,0x20
 7b2:	01c85713          	srli	a4,a6,0x1c
 7b6:	9736                	add	a4,a4,a3
 7b8:	fae60de3          	beq	a2,a4,772 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7bc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c0:	4790                	lw	a2,8(a5)
 7c2:	02061593          	slli	a1,a2,0x20
 7c6:	01c5d713          	srli	a4,a1,0x1c
 7ca:	973e                	add	a4,a4,a5
 7cc:	fae68ae3          	beq	a3,a4,780 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d2:	00001717          	auipc	a4,0x1
 7d6:	82f73723          	sd	a5,-2002(a4) # 1000 <freep>
}
 7da:	6422                	ld	s0,8(sp)
 7dc:	0141                	addi	sp,sp,16
 7de:	8082                	ret

00000000000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	7139                	addi	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f426                	sd	s1,40(sp)
 7e8:	ec4e                	sd	s3,24(sp)
 7ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ec:	02051493          	slli	s1,a0,0x20
 7f0:	9081                	srli	s1,s1,0x20
 7f2:	04bd                	addi	s1,s1,15
 7f4:	8091                	srli	s1,s1,0x4
 7f6:	0014899b          	addiw	s3,s1,1
 7fa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7fc:	00001517          	auipc	a0,0x1
 800:	80453503          	ld	a0,-2044(a0) # 1000 <freep>
 804:	c915                	beqz	a0,838 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	08977a63          	bgeu	a4,s1,89e <malloc+0xbe>
 80e:	f04a                	sd	s2,32(sp)
 810:	e852                	sd	s4,16(sp)
 812:	e456                	sd	s5,8(sp)
 814:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 816:	8a4e                	mv	s4,s3
 818:	0009871b          	sext.w	a4,s3
 81c:	6685                	lui	a3,0x1
 81e:	00d77363          	bgeu	a4,a3,824 <malloc+0x44>
 822:	6a05                	lui	s4,0x1
 824:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 828:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82c:	00000917          	auipc	s2,0x0
 830:	7d490913          	addi	s2,s2,2004 # 1000 <freep>
  if(p == (char*)-1)
 834:	5afd                	li	s5,-1
 836:	a081                	j	876 <malloc+0x96>
 838:	f04a                	sd	s2,32(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 840:	00000797          	auipc	a5,0x0
 844:	7d078793          	addi	a5,a5,2000 # 1010 <base>
 848:	00000717          	auipc	a4,0x0
 84c:	7af73c23          	sd	a5,1976(a4) # 1000 <freep>
 850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 856:	b7c1                	j	816 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	a8a9                	j	8b6 <malloc+0xd6>
  hp->s.size = nu;
 85e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 862:	0541                	addi	a0,a0,16
 864:	efbff0ef          	jal	75e <free>
  return freep;
 868:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 86c:	c12d                	beqz	a0,8ce <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 870:	4798                	lw	a4,8(a5)
 872:	02977263          	bgeu	a4,s1,896 <malloc+0xb6>
    if(p == freep)
 876:	00093703          	ld	a4,0(s2)
 87a:	853e                	mv	a0,a5
 87c:	fef719e3          	bne	a4,a5,86e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 880:	8552                	mv	a0,s4
 882:	afbff0ef          	jal	37c <sbrk>
  if(p == (char*)-1)
 886:	fd551ce3          	bne	a0,s5,85e <malloc+0x7e>
        return 0;
 88a:	4501                	li	a0,0
 88c:	7902                	ld	s2,32(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	a03d                	j	8c2 <malloc+0xe2>
 896:	7902                	ld	s2,32(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89e:	fae48de3          	beq	s1,a4,858 <malloc+0x78>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	74a73523          	sd	a0,1866(a4) # 1000 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6121                	addi	sp,sp,64
 8cc:	8082                	ret
 8ce:	7902                	ld	s2,32(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	b7f5                	j	8c2 <malloc+0xe2>
