
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7119                	addi	sp,sp,-128
      76:	fc86                	sd	ra,120(sp)
      78:	f8a2                	sd	s0,112(sp)
      7a:	f4a6                	sd	s1,104(sp)
      7c:	e4d6                	sd	s5,72(sp)
      7e:	0100                	addi	s0,sp,128
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	389000ef          	jal	c0c <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	0e650513          	addi	a0,a0,230 # 1170 <malloc+0x100>
      92:	35b000ef          	jal	bec <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	0da50513          	addi	a0,a0,218 # 1170 <malloc+0x100>
      9e:	357000ef          	jal	bf4 <chdir>
      a2:	cd19                	beqz	a0,c0 <go+0x4c>
      a4:	f0ca                	sd	s2,96(sp)
      a6:	ecce                	sd	s3,88(sp)
      a8:	e8d2                	sd	s4,80(sp)
      aa:	e0da                	sd	s6,64(sp)
      ac:	fc5e                	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
      ae:	00001517          	auipc	a0,0x1
      b2:	0ca50513          	addi	a0,a0,202 # 1178 <malloc+0x108>
      b6:	707000ef          	jal	fbc <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	2c9000ef          	jal	b84 <exit>
      c0:	f0ca                	sd	s2,96(sp)
      c2:	ecce                	sd	s3,88(sp)
      c4:	e8d2                	sd	s4,80(sp)
      c6:	e0da                	sd	s6,64(sp)
      c8:	fc5e                	sd	s7,56(sp)
  }
  chdir("/");
      ca:	00001517          	auipc	a0,0x1
      ce:	0d650513          	addi	a0,a0,214 # 11a0 <malloc+0x130>
      d2:	323000ef          	jal	bf4 <chdir>
      d6:	00001997          	auipc	s3,0x1
      da:	0da98993          	addi	s3,s3,218 # 11b0 <malloc+0x140>
      de:	c489                	beqz	s1,e8 <go+0x74>
      e0:	00001997          	auipc	s3,0x1
      e4:	0c898993          	addi	s3,s3,200 # 11a8 <malloc+0x138>
  uint64 iters = 0;
      e8:	4481                	li	s1,0
  int fd = -1;
      ea:	5a7d                	li	s4,-1
      ec:	00001917          	auipc	s2,0x1
      f0:	39490913          	addi	s2,s2,916 # 1480 <malloc+0x410>
      f4:	a819                	j	10a <go+0x96>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f6:	20200593          	li	a1,514
      fa:	00001517          	auipc	a0,0x1
      fe:	0be50513          	addi	a0,a0,190 # 11b8 <malloc+0x148>
     102:	2c3000ef          	jal	bc4 <open>
     106:	2a7000ef          	jal	bac <close>
    iters++;
     10a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     10c:	1f400793          	li	a5,500
     110:	02f4f7b3          	remu	a5,s1,a5
     114:	e791                	bnez	a5,120 <go+0xac>
      write(1, which_child?"B":"A", 1);
     116:	4605                	li	a2,1
     118:	85ce                	mv	a1,s3
     11a:	4505                	li	a0,1
     11c:	289000ef          	jal	ba4 <write>
    int what = rand() % 23;
     120:	f39ff0ef          	jal	58 <rand>
     124:	47dd                	li	a5,23
     126:	02f5653b          	remw	a0,a0,a5
     12a:	0005071b          	sext.w	a4,a0
     12e:	47d9                	li	a5,22
     130:	fce7ede3          	bltu	a5,a4,10a <go+0x96>
     134:	02051793          	slli	a5,a0,0x20
     138:	01e7d513          	srli	a0,a5,0x1e
     13c:	954a                	add	a0,a0,s2
     13e:	411c                	lw	a5,0(a0)
     140:	97ca                	add	a5,a5,s2
     142:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     144:	20200593          	li	a1,514
     148:	00001517          	auipc	a0,0x1
     14c:	08050513          	addi	a0,a0,128 # 11c8 <malloc+0x158>
     150:	275000ef          	jal	bc4 <open>
     154:	259000ef          	jal	bac <close>
     158:	bf4d                	j	10a <go+0x96>
    } else if(what == 3){
      unlink("grindir/../a");
     15a:	00001517          	auipc	a0,0x1
     15e:	05e50513          	addi	a0,a0,94 # 11b8 <malloc+0x148>
     162:	273000ef          	jal	bd4 <unlink>
     166:	b755                	j	10a <go+0x96>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     168:	00001517          	auipc	a0,0x1
     16c:	00850513          	addi	a0,a0,8 # 1170 <malloc+0x100>
     170:	285000ef          	jal	bf4 <chdir>
     174:	ed11                	bnez	a0,190 <go+0x11c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     176:	00001517          	auipc	a0,0x1
     17a:	06a50513          	addi	a0,a0,106 # 11e0 <malloc+0x170>
     17e:	257000ef          	jal	bd4 <unlink>
      chdir("/");
     182:	00001517          	auipc	a0,0x1
     186:	01e50513          	addi	a0,a0,30 # 11a0 <malloc+0x130>
     18a:	26b000ef          	jal	bf4 <chdir>
     18e:	bfb5                	j	10a <go+0x96>
        printf("grind: chdir grindir failed\n");
     190:	00001517          	auipc	a0,0x1
     194:	fe850513          	addi	a0,a0,-24 # 1178 <malloc+0x108>
     198:	625000ef          	jal	fbc <printf>
        exit(1);
     19c:	4505                	li	a0,1
     19e:	1e7000ef          	jal	b84 <exit>
    } else if(what == 5){
      close(fd);
     1a2:	8552                	mv	a0,s4
     1a4:	209000ef          	jal	bac <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a8:	20200593          	li	a1,514
     1ac:	00001517          	auipc	a0,0x1
     1b0:	03c50513          	addi	a0,a0,60 # 11e8 <malloc+0x178>
     1b4:	211000ef          	jal	bc4 <open>
     1b8:	8a2a                	mv	s4,a0
     1ba:	bf81                	j	10a <go+0x96>
    } else if(what == 6){
      close(fd);
     1bc:	8552                	mv	a0,s4
     1be:	1ef000ef          	jal	bac <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1c2:	20200593          	li	a1,514
     1c6:	00001517          	auipc	a0,0x1
     1ca:	03250513          	addi	a0,a0,50 # 11f8 <malloc+0x188>
     1ce:	1f7000ef          	jal	bc4 <open>
     1d2:	8a2a                	mv	s4,a0
     1d4:	bf1d                	j	10a <go+0x96>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d6:	3e700613          	li	a2,999
     1da:	00002597          	auipc	a1,0x2
     1de:	e4658593          	addi	a1,a1,-442 # 2020 <buf.0>
     1e2:	8552                	mv	a0,s4
     1e4:	1c1000ef          	jal	ba4 <write>
     1e8:	b70d                	j	10a <go+0x96>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1ea:	3e700613          	li	a2,999
     1ee:	00002597          	auipc	a1,0x2
     1f2:	e3258593          	addi	a1,a1,-462 # 2020 <buf.0>
     1f6:	8552                	mv	a0,s4
     1f8:	1a5000ef          	jal	b9c <read>
     1fc:	b739                	j	10a <go+0x96>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fe:	00001517          	auipc	a0,0x1
     202:	fba50513          	addi	a0,a0,-70 # 11b8 <malloc+0x148>
     206:	1e7000ef          	jal	bec <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     20a:	20200593          	li	a1,514
     20e:	00001517          	auipc	a0,0x1
     212:	00250513          	addi	a0,a0,2 # 1210 <malloc+0x1a0>
     216:	1af000ef          	jal	bc4 <open>
     21a:	193000ef          	jal	bac <close>
      unlink("a/a");
     21e:	00001517          	auipc	a0,0x1
     222:	00250513          	addi	a0,a0,2 # 1220 <malloc+0x1b0>
     226:	1af000ef          	jal	bd4 <unlink>
     22a:	b5c5                	j	10a <go+0x96>
    } else if(what == 10){
      mkdir("/../b");
     22c:	00001517          	auipc	a0,0x1
     230:	ffc50513          	addi	a0,a0,-4 # 1228 <malloc+0x1b8>
     234:	1b9000ef          	jal	bec <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	ff450513          	addi	a0,a0,-12 # 1230 <malloc+0x1c0>
     244:	181000ef          	jal	bc4 <open>
     248:	165000ef          	jal	bac <close>
      unlink("b/b");
     24c:	00001517          	auipc	a0,0x1
     250:	ff450513          	addi	a0,a0,-12 # 1240 <malloc+0x1d0>
     254:	181000ef          	jal	bd4 <unlink>
     258:	bd4d                	j	10a <go+0x96>
    } else if(what == 11){
      unlink("b");
     25a:	00001517          	auipc	a0,0x1
     25e:	fee50513          	addi	a0,a0,-18 # 1248 <malloc+0x1d8>
     262:	173000ef          	jal	bd4 <unlink>
      link("../grindir/./../a", "../b");
     266:	00001597          	auipc	a1,0x1
     26a:	f7a58593          	addi	a1,a1,-134 # 11e0 <malloc+0x170>
     26e:	00001517          	auipc	a0,0x1
     272:	fe250513          	addi	a0,a0,-30 # 1250 <malloc+0x1e0>
     276:	16f000ef          	jal	be4 <link>
     27a:	bd41                	j	10a <go+0x96>
    } else if(what == 12){
      unlink("../grindir/../a");
     27c:	00001517          	auipc	a0,0x1
     280:	fec50513          	addi	a0,a0,-20 # 1268 <malloc+0x1f8>
     284:	151000ef          	jal	bd4 <unlink>
      link(".././b", "/grindir/../a");
     288:	00001597          	auipc	a1,0x1
     28c:	f6058593          	addi	a1,a1,-160 # 11e8 <malloc+0x178>
     290:	00001517          	auipc	a0,0x1
     294:	fe850513          	addi	a0,a0,-24 # 1278 <malloc+0x208>
     298:	14d000ef          	jal	be4 <link>
     29c:	b5bd                	j	10a <go+0x96>
    } else if(what == 13){
      int pid = fork();
     29e:	0df000ef          	jal	b7c <fork>
      if(pid == 0){
     2a2:	c519                	beqz	a0,2b0 <go+0x23c>
        exit(0);
      } else if(pid < 0){
     2a4:	00054863          	bltz	a0,2b4 <go+0x240>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a8:	4501                	li	a0,0
     2aa:	0e3000ef          	jal	b8c <wait>
     2ae:	bdb1                	j	10a <go+0x96>
        exit(0);
     2b0:	0d5000ef          	jal	b84 <exit>
        printf("grind: fork failed\n");
     2b4:	00001517          	auipc	a0,0x1
     2b8:	fcc50513          	addi	a0,a0,-52 # 1280 <malloc+0x210>
     2bc:	501000ef          	jal	fbc <printf>
        exit(1);
     2c0:	4505                	li	a0,1
     2c2:	0c3000ef          	jal	b84 <exit>
    } else if(what == 14){
      int pid = fork();
     2c6:	0b7000ef          	jal	b7c <fork>
      if(pid == 0){
     2ca:	c519                	beqz	a0,2d8 <go+0x264>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2cc:	00054d63          	bltz	a0,2e6 <go+0x272>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2d0:	4501                	li	a0,0
     2d2:	0bb000ef          	jal	b8c <wait>
     2d6:	bd15                	j	10a <go+0x96>
        fork();
     2d8:	0a5000ef          	jal	b7c <fork>
        fork();
     2dc:	0a1000ef          	jal	b7c <fork>
        exit(0);
     2e0:	4501                	li	a0,0
     2e2:	0a3000ef          	jal	b84 <exit>
        printf("grind: fork failed\n");
     2e6:	00001517          	auipc	a0,0x1
     2ea:	f9a50513          	addi	a0,a0,-102 # 1280 <malloc+0x210>
     2ee:	4cf000ef          	jal	fbc <printf>
        exit(1);
     2f2:	4505                	li	a0,1
     2f4:	091000ef          	jal	b84 <exit>
    } else if(what == 15){
      sbrk(6011);
     2f8:	6505                	lui	a0,0x1
     2fa:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x29b>
     2fe:	10f000ef          	jal	c0c <sbrk>
     302:	b521                	j	10a <go+0x96>
    } else if(what == 16){
      if(sbrk(0) > break0)
     304:	4501                	li	a0,0
     306:	107000ef          	jal	c0c <sbrk>
     30a:	e0aaf0e3          	bgeu	s5,a0,10a <go+0x96>
        sbrk(-(sbrk(0) - break0));
     30e:	4501                	li	a0,0
     310:	0fd000ef          	jal	c0c <sbrk>
     314:	40aa853b          	subw	a0,s5,a0
     318:	0f5000ef          	jal	c0c <sbrk>
     31c:	b3fd                	j	10a <go+0x96>
    } else if(what == 17){
      int pid = fork();
     31e:	05f000ef          	jal	b7c <fork>
     322:	8b2a                	mv	s6,a0
      if(pid == 0){
     324:	c10d                	beqz	a0,346 <go+0x2d2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     326:	02054d63          	bltz	a0,360 <go+0x2ec>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     32a:	00001517          	auipc	a0,0x1
     32e:	f7650513          	addi	a0,a0,-138 # 12a0 <malloc+0x230>
     332:	0c3000ef          	jal	bf4 <chdir>
     336:	ed15                	bnez	a0,372 <go+0x2fe>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     338:	855a                	mv	a0,s6
     33a:	07b000ef          	jal	bb4 <kill>
      wait(0);
     33e:	4501                	li	a0,0
     340:	04d000ef          	jal	b8c <wait>
     344:	b3d9                	j	10a <go+0x96>
        close(open("a", O_CREATE|O_RDWR));
     346:	20200593          	li	a1,514
     34a:	00001517          	auipc	a0,0x1
     34e:	f4e50513          	addi	a0,a0,-178 # 1298 <malloc+0x228>
     352:	073000ef          	jal	bc4 <open>
     356:	057000ef          	jal	bac <close>
        exit(0);
     35a:	4501                	li	a0,0
     35c:	029000ef          	jal	b84 <exit>
        printf("grind: fork failed\n");
     360:	00001517          	auipc	a0,0x1
     364:	f2050513          	addi	a0,a0,-224 # 1280 <malloc+0x210>
     368:	455000ef          	jal	fbc <printf>
        exit(1);
     36c:	4505                	li	a0,1
     36e:	017000ef          	jal	b84 <exit>
        printf("grind: chdir failed\n");
     372:	00001517          	auipc	a0,0x1
     376:	f3e50513          	addi	a0,a0,-194 # 12b0 <malloc+0x240>
     37a:	443000ef          	jal	fbc <printf>
        exit(1);
     37e:	4505                	li	a0,1
     380:	005000ef          	jal	b84 <exit>
    } else if(what == 18){
      int pid = fork();
     384:	7f8000ef          	jal	b7c <fork>
      if(pid == 0){
     388:	c519                	beqz	a0,396 <go+0x322>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     38a:	00054d63          	bltz	a0,3a4 <go+0x330>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38e:	4501                	li	a0,0
     390:	7fc000ef          	jal	b8c <wait>
     394:	bb9d                	j	10a <go+0x96>
        kill(getpid());
     396:	06f000ef          	jal	c04 <getpid>
     39a:	01b000ef          	jal	bb4 <kill>
        exit(0);
     39e:	4501                	li	a0,0
     3a0:	7e4000ef          	jal	b84 <exit>
        printf("grind: fork failed\n");
     3a4:	00001517          	auipc	a0,0x1
     3a8:	edc50513          	addi	a0,a0,-292 # 1280 <malloc+0x210>
     3ac:	411000ef          	jal	fbc <printf>
        exit(1);
     3b0:	4505                	li	a0,1
     3b2:	7d2000ef          	jal	b84 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3b6:	f9840513          	addi	a0,s0,-104
     3ba:	7da000ef          	jal	b94 <pipe>
     3be:	02054363          	bltz	a0,3e4 <go+0x370>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3c2:	7ba000ef          	jal	b7c <fork>
      if(pid == 0){
     3c6:	c905                	beqz	a0,3f6 <go+0x382>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3c8:	08054263          	bltz	a0,44c <go+0x3d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3cc:	f9842503          	lw	a0,-104(s0)
     3d0:	7dc000ef          	jal	bac <close>
      close(fds[1]);
     3d4:	f9c42503          	lw	a0,-100(s0)
     3d8:	7d4000ef          	jal	bac <close>
      wait(0);
     3dc:	4501                	li	a0,0
     3de:	7ae000ef          	jal	b8c <wait>
     3e2:	b325                	j	10a <go+0x96>
        printf("grind: pipe failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	ee450513          	addi	a0,a0,-284 # 12c8 <malloc+0x258>
     3ec:	3d1000ef          	jal	fbc <printf>
        exit(1);
     3f0:	4505                	li	a0,1
     3f2:	792000ef          	jal	b84 <exit>
        fork();
     3f6:	786000ef          	jal	b7c <fork>
        fork();
     3fa:	782000ef          	jal	b7c <fork>
        if(write(fds[1], "x", 1) != 1)
     3fe:	4605                	li	a2,1
     400:	00001597          	auipc	a1,0x1
     404:	ee058593          	addi	a1,a1,-288 # 12e0 <malloc+0x270>
     408:	f9c42503          	lw	a0,-100(s0)
     40c:	798000ef          	jal	ba4 <write>
     410:	4785                	li	a5,1
     412:	00f51f63          	bne	a0,a5,430 <go+0x3bc>
        if(read(fds[0], &c, 1) != 1)
     416:	4605                	li	a2,1
     418:	f9040593          	addi	a1,s0,-112
     41c:	f9842503          	lw	a0,-104(s0)
     420:	77c000ef          	jal	b9c <read>
     424:	4785                	li	a5,1
     426:	00f51c63          	bne	a0,a5,43e <go+0x3ca>
        exit(0);
     42a:	4501                	li	a0,0
     42c:	758000ef          	jal	b84 <exit>
          printf("grind: pipe write failed\n");
     430:	00001517          	auipc	a0,0x1
     434:	eb850513          	addi	a0,a0,-328 # 12e8 <malloc+0x278>
     438:	385000ef          	jal	fbc <printf>
     43c:	bfe9                	j	416 <go+0x3a2>
          printf("grind: pipe read failed\n");
     43e:	00001517          	auipc	a0,0x1
     442:	eca50513          	addi	a0,a0,-310 # 1308 <malloc+0x298>
     446:	377000ef          	jal	fbc <printf>
     44a:	b7c5                	j	42a <go+0x3b6>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	e3450513          	addi	a0,a0,-460 # 1280 <malloc+0x210>
     454:	369000ef          	jal	fbc <printf>
        exit(1);
     458:	4505                	li	a0,1
     45a:	72a000ef          	jal	b84 <exit>
    } else if(what == 20){
      int pid = fork();
     45e:	71e000ef          	jal	b7c <fork>
      if(pid == 0){
     462:	c519                	beqz	a0,470 <go+0x3fc>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     464:	04054f63          	bltz	a0,4c2 <go+0x44e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     468:	4501                	li	a0,0
     46a:	722000ef          	jal	b8c <wait>
     46e:	b971                	j	10a <go+0x96>
        unlink("a");
     470:	00001517          	auipc	a0,0x1
     474:	e2850513          	addi	a0,a0,-472 # 1298 <malloc+0x228>
     478:	75c000ef          	jal	bd4 <unlink>
        mkdir("a");
     47c:	00001517          	auipc	a0,0x1
     480:	e1c50513          	addi	a0,a0,-484 # 1298 <malloc+0x228>
     484:	768000ef          	jal	bec <mkdir>
        chdir("a");
     488:	00001517          	auipc	a0,0x1
     48c:	e1050513          	addi	a0,a0,-496 # 1298 <malloc+0x228>
     490:	764000ef          	jal	bf4 <chdir>
        unlink("../a");
     494:	00001517          	auipc	a0,0x1
     498:	e9450513          	addi	a0,a0,-364 # 1328 <malloc+0x2b8>
     49c:	738000ef          	jal	bd4 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     4a0:	20200593          	li	a1,514
     4a4:	00001517          	auipc	a0,0x1
     4a8:	e3c50513          	addi	a0,a0,-452 # 12e0 <malloc+0x270>
     4ac:	718000ef          	jal	bc4 <open>
        unlink("x");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	e3050513          	addi	a0,a0,-464 # 12e0 <malloc+0x270>
     4b8:	71c000ef          	jal	bd4 <unlink>
        exit(0);
     4bc:	4501                	li	a0,0
     4be:	6c6000ef          	jal	b84 <exit>
        printf("grind: fork failed\n");
     4c2:	00001517          	auipc	a0,0x1
     4c6:	dbe50513          	addi	a0,a0,-578 # 1280 <malloc+0x210>
     4ca:	2f3000ef          	jal	fbc <printf>
        exit(1);
     4ce:	4505                	li	a0,1
     4d0:	6b4000ef          	jal	b84 <exit>
    } else if(what == 21){
      unlink("c");
     4d4:	00001517          	auipc	a0,0x1
     4d8:	e5c50513          	addi	a0,a0,-420 # 1330 <malloc+0x2c0>
     4dc:	6f8000ef          	jal	bd4 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4e0:	20200593          	li	a1,514
     4e4:	00001517          	auipc	a0,0x1
     4e8:	e4c50513          	addi	a0,a0,-436 # 1330 <malloc+0x2c0>
     4ec:	6d8000ef          	jal	bc4 <open>
     4f0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4f2:	04054763          	bltz	a0,540 <go+0x4cc>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4f6:	4605                	li	a2,1
     4f8:	00001597          	auipc	a1,0x1
     4fc:	de858593          	addi	a1,a1,-536 # 12e0 <malloc+0x270>
     500:	6a4000ef          	jal	ba4 <write>
     504:	4785                	li	a5,1
     506:	04f51663          	bne	a0,a5,552 <go+0x4de>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     50a:	f9840593          	addi	a1,s0,-104
     50e:	855a                	mv	a0,s6
     510:	6cc000ef          	jal	bdc <fstat>
     514:	e921                	bnez	a0,564 <go+0x4f0>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     516:	fa843583          	ld	a1,-88(s0)
     51a:	4785                	li	a5,1
     51c:	04f59d63          	bne	a1,a5,576 <go+0x502>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     520:	f9c42583          	lw	a1,-100(s0)
     524:	0c800793          	li	a5,200
     528:	06b7e163          	bltu	a5,a1,58a <go+0x516>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     52c:	855a                	mv	a0,s6
     52e:	67e000ef          	jal	bac <close>
      unlink("c");
     532:	00001517          	auipc	a0,0x1
     536:	dfe50513          	addi	a0,a0,-514 # 1330 <malloc+0x2c0>
     53a:	69a000ef          	jal	bd4 <unlink>
     53e:	b6f1                	j	10a <go+0x96>
        printf("grind: create c failed\n");
     540:	00001517          	auipc	a0,0x1
     544:	df850513          	addi	a0,a0,-520 # 1338 <malloc+0x2c8>
     548:	275000ef          	jal	fbc <printf>
        exit(1);
     54c:	4505                	li	a0,1
     54e:	636000ef          	jal	b84 <exit>
        printf("grind: write c failed\n");
     552:	00001517          	auipc	a0,0x1
     556:	dfe50513          	addi	a0,a0,-514 # 1350 <malloc+0x2e0>
     55a:	263000ef          	jal	fbc <printf>
        exit(1);
     55e:	4505                	li	a0,1
     560:	624000ef          	jal	b84 <exit>
        printf("grind: fstat failed\n");
     564:	00001517          	auipc	a0,0x1
     568:	e0450513          	addi	a0,a0,-508 # 1368 <malloc+0x2f8>
     56c:	251000ef          	jal	fbc <printf>
        exit(1);
     570:	4505                	li	a0,1
     572:	612000ef          	jal	b84 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     576:	2581                	sext.w	a1,a1
     578:	00001517          	auipc	a0,0x1
     57c:	e0850513          	addi	a0,a0,-504 # 1380 <malloc+0x310>
     580:	23d000ef          	jal	fbc <printf>
        exit(1);
     584:	4505                	li	a0,1
     586:	5fe000ef          	jal	b84 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     58a:	00001517          	auipc	a0,0x1
     58e:	e1e50513          	addi	a0,a0,-482 # 13a8 <malloc+0x338>
     592:	22b000ef          	jal	fbc <printf>
        exit(1);
     596:	4505                	li	a0,1
     598:	5ec000ef          	jal	b84 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     59c:	f8840513          	addi	a0,s0,-120
     5a0:	5f4000ef          	jal	b94 <pipe>
     5a4:	0a054563          	bltz	a0,64e <go+0x5da>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5a8:	f9040513          	addi	a0,s0,-112
     5ac:	5e8000ef          	jal	b94 <pipe>
     5b0:	0a054963          	bltz	a0,662 <go+0x5ee>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b4:	5c8000ef          	jal	b7c <fork>
      if(pid1 == 0){
     5b8:	cd5d                	beqz	a0,676 <go+0x602>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5ba:	14054263          	bltz	a0,6fe <go+0x68a>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5be:	5be000ef          	jal	b7c <fork>
      if(pid2 == 0){
     5c2:	14050863          	beqz	a0,712 <go+0x69e>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5c6:	1e054663          	bltz	a0,7b2 <go+0x73e>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5ca:	f8842503          	lw	a0,-120(s0)
     5ce:	5de000ef          	jal	bac <close>
      close(aa[1]);
     5d2:	f8c42503          	lw	a0,-116(s0)
     5d6:	5d6000ef          	jal	bac <close>
      close(bb[1]);
     5da:	f9442503          	lw	a0,-108(s0)
     5de:	5ce000ef          	jal	bac <close>
      char buf[4] = { 0, 0, 0, 0 };
     5e2:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
     5e6:	4605                	li	a2,1
     5e8:	f8040593          	addi	a1,s0,-128
     5ec:	f9042503          	lw	a0,-112(s0)
     5f0:	5ac000ef          	jal	b9c <read>
      read(bb[0], buf+1, 1);
     5f4:	4605                	li	a2,1
     5f6:	f8140593          	addi	a1,s0,-127
     5fa:	f9042503          	lw	a0,-112(s0)
     5fe:	59e000ef          	jal	b9c <read>
      read(bb[0], buf+2, 1);
     602:	4605                	li	a2,1
     604:	f8240593          	addi	a1,s0,-126
     608:	f9042503          	lw	a0,-112(s0)
     60c:	590000ef          	jal	b9c <read>
      close(bb[0]);
     610:	f9042503          	lw	a0,-112(s0)
     614:	598000ef          	jal	bac <close>
      int st1, st2;
      wait(&st1);
     618:	f8440513          	addi	a0,s0,-124
     61c:	570000ef          	jal	b8c <wait>
      wait(&st2);
     620:	f9840513          	addi	a0,s0,-104
     624:	568000ef          	jal	b8c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     628:	f8442783          	lw	a5,-124(s0)
     62c:	f9842b83          	lw	s7,-104(s0)
     630:	0177eb33          	or	s6,a5,s7
     634:	180b1963          	bnez	s6,7c6 <go+0x752>
     638:	00001597          	auipc	a1,0x1
     63c:	e1058593          	addi	a1,a1,-496 # 1448 <malloc+0x3d8>
     640:	f8040513          	addi	a0,s0,-128
     644:	2ce000ef          	jal	912 <strcmp>
     648:	ac0501e3          	beqz	a0,10a <go+0x96>
     64c:	aab5                	j	7c8 <go+0x754>
        fprintf(2, "grind: pipe failed\n");
     64e:	00001597          	auipc	a1,0x1
     652:	c7a58593          	addi	a1,a1,-902 # 12c8 <malloc+0x258>
     656:	4509                	li	a0,2
     658:	13b000ef          	jal	f92 <fprintf>
        exit(1);
     65c:	4505                	li	a0,1
     65e:	526000ef          	jal	b84 <exit>
        fprintf(2, "grind: pipe failed\n");
     662:	00001597          	auipc	a1,0x1
     666:	c6658593          	addi	a1,a1,-922 # 12c8 <malloc+0x258>
     66a:	4509                	li	a0,2
     66c:	127000ef          	jal	f92 <fprintf>
        exit(1);
     670:	4505                	li	a0,1
     672:	512000ef          	jal	b84 <exit>
        close(bb[0]);
     676:	f9042503          	lw	a0,-112(s0)
     67a:	532000ef          	jal	bac <close>
        close(bb[1]);
     67e:	f9442503          	lw	a0,-108(s0)
     682:	52a000ef          	jal	bac <close>
        close(aa[0]);
     686:	f8842503          	lw	a0,-120(s0)
     68a:	522000ef          	jal	bac <close>
        close(1);
     68e:	4505                	li	a0,1
     690:	51c000ef          	jal	bac <close>
        if(dup(aa[1]) != 1){
     694:	f8c42503          	lw	a0,-116(s0)
     698:	564000ef          	jal	bfc <dup>
     69c:	4785                	li	a5,1
     69e:	00f50c63          	beq	a0,a5,6b6 <go+0x642>
          fprintf(2, "grind: dup failed\n");
     6a2:	00001597          	auipc	a1,0x1
     6a6:	d2e58593          	addi	a1,a1,-722 # 13d0 <malloc+0x360>
     6aa:	4509                	li	a0,2
     6ac:	0e7000ef          	jal	f92 <fprintf>
          exit(1);
     6b0:	4505                	li	a0,1
     6b2:	4d2000ef          	jal	b84 <exit>
        close(aa[1]);
     6b6:	f8c42503          	lw	a0,-116(s0)
     6ba:	4f2000ef          	jal	bac <close>
        char *args[3] = { "echo", "hi", 0 };
     6be:	00001797          	auipc	a5,0x1
     6c2:	d2a78793          	addi	a5,a5,-726 # 13e8 <malloc+0x378>
     6c6:	f8f43c23          	sd	a5,-104(s0)
     6ca:	00001797          	auipc	a5,0x1
     6ce:	d2678793          	addi	a5,a5,-730 # 13f0 <malloc+0x380>
     6d2:	faf43023          	sd	a5,-96(s0)
     6d6:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
     6da:	f9840593          	addi	a1,s0,-104
     6de:	00001517          	auipc	a0,0x1
     6e2:	d1a50513          	addi	a0,a0,-742 # 13f8 <malloc+0x388>
     6e6:	4d6000ef          	jal	bbc <exec>
        fprintf(2, "grind: echo: not found\n");
     6ea:	00001597          	auipc	a1,0x1
     6ee:	d1e58593          	addi	a1,a1,-738 # 1408 <malloc+0x398>
     6f2:	4509                	li	a0,2
     6f4:	09f000ef          	jal	f92 <fprintf>
        exit(2);
     6f8:	4509                	li	a0,2
     6fa:	48a000ef          	jal	b84 <exit>
        fprintf(2, "grind: fork failed\n");
     6fe:	00001597          	auipc	a1,0x1
     702:	b8258593          	addi	a1,a1,-1150 # 1280 <malloc+0x210>
     706:	4509                	li	a0,2
     708:	08b000ef          	jal	f92 <fprintf>
        exit(3);
     70c:	450d                	li	a0,3
     70e:	476000ef          	jal	b84 <exit>
        close(aa[1]);
     712:	f8c42503          	lw	a0,-116(s0)
     716:	496000ef          	jal	bac <close>
        close(bb[0]);
     71a:	f9042503          	lw	a0,-112(s0)
     71e:	48e000ef          	jal	bac <close>
        close(0);
     722:	4501                	li	a0,0
     724:	488000ef          	jal	bac <close>
        if(dup(aa[0]) != 0){
     728:	f8842503          	lw	a0,-120(s0)
     72c:	4d0000ef          	jal	bfc <dup>
     730:	c919                	beqz	a0,746 <go+0x6d2>
          fprintf(2, "grind: dup failed\n");
     732:	00001597          	auipc	a1,0x1
     736:	c9e58593          	addi	a1,a1,-866 # 13d0 <malloc+0x360>
     73a:	4509                	li	a0,2
     73c:	057000ef          	jal	f92 <fprintf>
          exit(4);
     740:	4511                	li	a0,4
     742:	442000ef          	jal	b84 <exit>
        close(aa[0]);
     746:	f8842503          	lw	a0,-120(s0)
     74a:	462000ef          	jal	bac <close>
        close(1);
     74e:	4505                	li	a0,1
     750:	45c000ef          	jal	bac <close>
        if(dup(bb[1]) != 1){
     754:	f9442503          	lw	a0,-108(s0)
     758:	4a4000ef          	jal	bfc <dup>
     75c:	4785                	li	a5,1
     75e:	00f50c63          	beq	a0,a5,776 <go+0x702>
          fprintf(2, "grind: dup failed\n");
     762:	00001597          	auipc	a1,0x1
     766:	c6e58593          	addi	a1,a1,-914 # 13d0 <malloc+0x360>
     76a:	4509                	li	a0,2
     76c:	027000ef          	jal	f92 <fprintf>
          exit(5);
     770:	4515                	li	a0,5
     772:	412000ef          	jal	b84 <exit>
        close(bb[1]);
     776:	f9442503          	lw	a0,-108(s0)
     77a:	432000ef          	jal	bac <close>
        char *args[2] = { "cat", 0 };
     77e:	00001797          	auipc	a5,0x1
     782:	ca278793          	addi	a5,a5,-862 # 1420 <malloc+0x3b0>
     786:	f8f43c23          	sd	a5,-104(s0)
     78a:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
     78e:	f9840593          	addi	a1,s0,-104
     792:	00001517          	auipc	a0,0x1
     796:	c9650513          	addi	a0,a0,-874 # 1428 <malloc+0x3b8>
     79a:	422000ef          	jal	bbc <exec>
        fprintf(2, "grind: cat: not found\n");
     79e:	00001597          	auipc	a1,0x1
     7a2:	c9258593          	addi	a1,a1,-878 # 1430 <malloc+0x3c0>
     7a6:	4509                	li	a0,2
     7a8:	7ea000ef          	jal	f92 <fprintf>
        exit(6);
     7ac:	4519                	li	a0,6
     7ae:	3d6000ef          	jal	b84 <exit>
        fprintf(2, "grind: fork failed\n");
     7b2:	00001597          	auipc	a1,0x1
     7b6:	ace58593          	addi	a1,a1,-1330 # 1280 <malloc+0x210>
     7ba:	4509                	li	a0,2
     7bc:	7d6000ef          	jal	f92 <fprintf>
        exit(7);
     7c0:	451d                	li	a0,7
     7c2:	3c2000ef          	jal	b84 <exit>
     7c6:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     7c8:	f8040693          	addi	a3,s0,-128
     7cc:	865e                	mv	a2,s7
     7ce:	85da                	mv	a1,s6
     7d0:	00001517          	auipc	a0,0x1
     7d4:	c8050513          	addi	a0,a0,-896 # 1450 <malloc+0x3e0>
     7d8:	7e4000ef          	jal	fbc <printf>
        exit(1);
     7dc:	4505                	li	a0,1
     7de:	3a6000ef          	jal	b84 <exit>

00000000000007e2 <iter>:
  }
}

void
iter()
{
     7e2:	7179                	addi	sp,sp,-48
     7e4:	f406                	sd	ra,40(sp)
     7e6:	f022                	sd	s0,32(sp)
     7e8:	1800                	addi	s0,sp,48
  unlink("a");
     7ea:	00001517          	auipc	a0,0x1
     7ee:	aae50513          	addi	a0,a0,-1362 # 1298 <malloc+0x228>
     7f2:	3e2000ef          	jal	bd4 <unlink>
  unlink("b");
     7f6:	00001517          	auipc	a0,0x1
     7fa:	a5250513          	addi	a0,a0,-1454 # 1248 <malloc+0x1d8>
     7fe:	3d6000ef          	jal	bd4 <unlink>
  
  int pid1 = fork();
     802:	37a000ef          	jal	b7c <fork>
  if(pid1 < 0){
     806:	02054163          	bltz	a0,828 <iter+0x46>
     80a:	ec26                	sd	s1,24(sp)
     80c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     80e:	e905                	bnez	a0,83e <iter+0x5c>
     810:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     812:	00001717          	auipc	a4,0x1
     816:	7ee70713          	addi	a4,a4,2030 # 2000 <rand_next>
     81a:	631c                	ld	a5,0(a4)
     81c:	01f7c793          	xori	a5,a5,31
     820:	e31c                	sd	a5,0(a4)
    go(0);
     822:	4501                	li	a0,0
     824:	851ff0ef          	jal	74 <go>
     828:	ec26                	sd	s1,24(sp)
     82a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     82c:	00001517          	auipc	a0,0x1
     830:	a5450513          	addi	a0,a0,-1452 # 1280 <malloc+0x210>
     834:	788000ef          	jal	fbc <printf>
    exit(1);
     838:	4505                	li	a0,1
     83a:	34a000ef          	jal	b84 <exit>
     83e:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     840:	33c000ef          	jal	b7c <fork>
     844:	892a                	mv	s2,a0
  if(pid2 < 0){
     846:	02054063          	bltz	a0,866 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     84a:	e51d                	bnez	a0,878 <iter+0x96>
    rand_next ^= 7177;
     84c:	00001697          	auipc	a3,0x1
     850:	7b468693          	addi	a3,a3,1972 # 2000 <rand_next>
     854:	629c                	ld	a5,0(a3)
     856:	6709                	lui	a4,0x2
     858:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x729>
     85c:	8fb9                	xor	a5,a5,a4
     85e:	e29c                	sd	a5,0(a3)
    go(1);
     860:	4505                	li	a0,1
     862:	813ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     866:	00001517          	auipc	a0,0x1
     86a:	a1a50513          	addi	a0,a0,-1510 # 1280 <malloc+0x210>
     86e:	74e000ef          	jal	fbc <printf>
    exit(1);
     872:	4505                	li	a0,1
     874:	310000ef          	jal	b84 <exit>
    exit(0);
  }

  int st1 = -1;
     878:	57fd                	li	a5,-1
     87a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     87e:	fdc40513          	addi	a0,s0,-36
     882:	30a000ef          	jal	b8c <wait>
  if(st1 != 0){
     886:	fdc42783          	lw	a5,-36(s0)
     88a:	eb99                	bnez	a5,8a0 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     88c:	57fd                	li	a5,-1
     88e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     892:	fd840513          	addi	a0,s0,-40
     896:	2f6000ef          	jal	b8c <wait>

  exit(0);
     89a:	4501                	li	a0,0
     89c:	2e8000ef          	jal	b84 <exit>
    kill(pid1);
     8a0:	8526                	mv	a0,s1
     8a2:	312000ef          	jal	bb4 <kill>
    kill(pid2);
     8a6:	854a                	mv	a0,s2
     8a8:	30c000ef          	jal	bb4 <kill>
     8ac:	b7c5                	j	88c <iter+0xaa>

00000000000008ae <main>:
}

int
main()
{
     8ae:	1101                	addi	sp,sp,-32
     8b0:	ec06                	sd	ra,24(sp)
     8b2:	e822                	sd	s0,16(sp)
     8b4:	e426                	sd	s1,8(sp)
     8b6:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     8b8:	00001497          	auipc	s1,0x1
     8bc:	74848493          	addi	s1,s1,1864 # 2000 <rand_next>
     8c0:	a809                	j	8d2 <main+0x24>
      iter();
     8c2:	f21ff0ef          	jal	7e2 <iter>
    sleep(20);
     8c6:	4551                	li	a0,20
     8c8:	34c000ef          	jal	c14 <sleep>
    rand_next += 1;
     8cc:	609c                	ld	a5,0(s1)
     8ce:	0785                	addi	a5,a5,1
     8d0:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8d2:	2aa000ef          	jal	b7c <fork>
    if(pid == 0){
     8d6:	d575                	beqz	a0,8c2 <main+0x14>
    if(pid > 0){
     8d8:	fea057e3          	blez	a0,8c6 <main+0x18>
      wait(0);
     8dc:	4501                	li	a0,0
     8de:	2ae000ef          	jal	b8c <wait>
     8e2:	b7d5                	j	8c6 <main+0x18>

00000000000008e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     8e4:	1141                	addi	sp,sp,-16
     8e6:	e406                	sd	ra,8(sp)
     8e8:	e022                	sd	s0,0(sp)
     8ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8ec:	fc3ff0ef          	jal	8ae <main>
  exit(0);
     8f0:	4501                	li	a0,0
     8f2:	292000ef          	jal	b84 <exit>

00000000000008f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f6:	1141                	addi	sp,sp,-16
     8f8:	e422                	sd	s0,8(sp)
     8fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8fc:	87aa                	mv	a5,a0
     8fe:	0585                	addi	a1,a1,1
     900:	0785                	addi	a5,a5,1
     902:	fff5c703          	lbu	a4,-1(a1)
     906:	fee78fa3          	sb	a4,-1(a5)
     90a:	fb75                	bnez	a4,8fe <strcpy+0x8>
    ;
  return os;
}
     90c:	6422                	ld	s0,8(sp)
     90e:	0141                	addi	sp,sp,16
     910:	8082                	ret

0000000000000912 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     912:	1141                	addi	sp,sp,-16
     914:	e422                	sd	s0,8(sp)
     916:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cb91                	beqz	a5,930 <strcmp+0x1e>
     91e:	0005c703          	lbu	a4,0(a1)
     922:	00f71763          	bne	a4,a5,930 <strcmp+0x1e>
    p++, q++;
     926:	0505                	addi	a0,a0,1
     928:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     92a:	00054783          	lbu	a5,0(a0)
     92e:	fbe5                	bnez	a5,91e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     930:	0005c503          	lbu	a0,0(a1)
}
     934:	40a7853b          	subw	a0,a5,a0
     938:	6422                	ld	s0,8(sp)
     93a:	0141                	addi	sp,sp,16
     93c:	8082                	ret

000000000000093e <strlen>:

uint
strlen(const char *s)
{
     93e:	1141                	addi	sp,sp,-16
     940:	e422                	sd	s0,8(sp)
     942:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     944:	00054783          	lbu	a5,0(a0)
     948:	cf91                	beqz	a5,964 <strlen+0x26>
     94a:	0505                	addi	a0,a0,1
     94c:	87aa                	mv	a5,a0
     94e:	86be                	mv	a3,a5
     950:	0785                	addi	a5,a5,1
     952:	fff7c703          	lbu	a4,-1(a5)
     956:	ff65                	bnez	a4,94e <strlen+0x10>
     958:	40a6853b          	subw	a0,a3,a0
     95c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     95e:	6422                	ld	s0,8(sp)
     960:	0141                	addi	sp,sp,16
     962:	8082                	ret
  for(n = 0; s[n]; n++)
     964:	4501                	li	a0,0
     966:	bfe5                	j	95e <strlen+0x20>

0000000000000968 <memset>:

void*
memset(void *dst, int c, uint n)
{
     968:	1141                	addi	sp,sp,-16
     96a:	e422                	sd	s0,8(sp)
     96c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     96e:	ca19                	beqz	a2,984 <memset+0x1c>
     970:	87aa                	mv	a5,a0
     972:	1602                	slli	a2,a2,0x20
     974:	9201                	srli	a2,a2,0x20
     976:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     97a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     97e:	0785                	addi	a5,a5,1
     980:	fee79de3          	bne	a5,a4,97a <memset+0x12>
  }
  return dst;
}
     984:	6422                	ld	s0,8(sp)
     986:	0141                	addi	sp,sp,16
     988:	8082                	ret

000000000000098a <strchr>:

char*
strchr(const char *s, char c)
{
     98a:	1141                	addi	sp,sp,-16
     98c:	e422                	sd	s0,8(sp)
     98e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     990:	00054783          	lbu	a5,0(a0)
     994:	cb99                	beqz	a5,9aa <strchr+0x20>
    if(*s == c)
     996:	00f58763          	beq	a1,a5,9a4 <strchr+0x1a>
  for(; *s; s++)
     99a:	0505                	addi	a0,a0,1
     99c:	00054783          	lbu	a5,0(a0)
     9a0:	fbfd                	bnez	a5,996 <strchr+0xc>
      return (char*)s;
  return 0;
     9a2:	4501                	li	a0,0
}
     9a4:	6422                	ld	s0,8(sp)
     9a6:	0141                	addi	sp,sp,16
     9a8:	8082                	ret
  return 0;
     9aa:	4501                	li	a0,0
     9ac:	bfe5                	j	9a4 <strchr+0x1a>

00000000000009ae <gets>:

char*
gets(char *buf, int max)
{
     9ae:	711d                	addi	sp,sp,-96
     9b0:	ec86                	sd	ra,88(sp)
     9b2:	e8a2                	sd	s0,80(sp)
     9b4:	e4a6                	sd	s1,72(sp)
     9b6:	e0ca                	sd	s2,64(sp)
     9b8:	fc4e                	sd	s3,56(sp)
     9ba:	f852                	sd	s4,48(sp)
     9bc:	f456                	sd	s5,40(sp)
     9be:	f05a                	sd	s6,32(sp)
     9c0:	ec5e                	sd	s7,24(sp)
     9c2:	1080                	addi	s0,sp,96
     9c4:	8baa                	mv	s7,a0
     9c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c8:	892a                	mv	s2,a0
     9ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9cc:	4aa9                	li	s5,10
     9ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9d0:	89a6                	mv	s3,s1
     9d2:	2485                	addiw	s1,s1,1
     9d4:	0344d663          	bge	s1,s4,a00 <gets+0x52>
    cc = read(0, &c, 1);
     9d8:	4605                	li	a2,1
     9da:	faf40593          	addi	a1,s0,-81
     9de:	4501                	li	a0,0
     9e0:	1bc000ef          	jal	b9c <read>
    if(cc < 1)
     9e4:	00a05e63          	blez	a0,a00 <gets+0x52>
    buf[i++] = c;
     9e8:	faf44783          	lbu	a5,-81(s0)
     9ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9f0:	01578763          	beq	a5,s5,9fe <gets+0x50>
     9f4:	0905                	addi	s2,s2,1
     9f6:	fd679de3          	bne	a5,s6,9d0 <gets+0x22>
    buf[i++] = c;
     9fa:	89a6                	mv	s3,s1
     9fc:	a011                	j	a00 <gets+0x52>
     9fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a00:	99de                	add	s3,s3,s7
     a02:	00098023          	sb	zero,0(s3)
  return buf;
}
     a06:	855e                	mv	a0,s7
     a08:	60e6                	ld	ra,88(sp)
     a0a:	6446                	ld	s0,80(sp)
     a0c:	64a6                	ld	s1,72(sp)
     a0e:	6906                	ld	s2,64(sp)
     a10:	79e2                	ld	s3,56(sp)
     a12:	7a42                	ld	s4,48(sp)
     a14:	7aa2                	ld	s5,40(sp)
     a16:	7b02                	ld	s6,32(sp)
     a18:	6be2                	ld	s7,24(sp)
     a1a:	6125                	addi	sp,sp,96
     a1c:	8082                	ret

0000000000000a1e <stat>:

int
stat(const char *n, struct stat *st)
{
     a1e:	1101                	addi	sp,sp,-32
     a20:	ec06                	sd	ra,24(sp)
     a22:	e822                	sd	s0,16(sp)
     a24:	e04a                	sd	s2,0(sp)
     a26:	1000                	addi	s0,sp,32
     a28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a2a:	4581                	li	a1,0
     a2c:	198000ef          	jal	bc4 <open>
  if(fd < 0)
     a30:	02054263          	bltz	a0,a54 <stat+0x36>
     a34:	e426                	sd	s1,8(sp)
     a36:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a38:	85ca                	mv	a1,s2
     a3a:	1a2000ef          	jal	bdc <fstat>
     a3e:	892a                	mv	s2,a0
  close(fd);
     a40:	8526                	mv	a0,s1
     a42:	16a000ef          	jal	bac <close>
  return r;
     a46:	64a2                	ld	s1,8(sp)
}
     a48:	854a                	mv	a0,s2
     a4a:	60e2                	ld	ra,24(sp)
     a4c:	6442                	ld	s0,16(sp)
     a4e:	6902                	ld	s2,0(sp)
     a50:	6105                	addi	sp,sp,32
     a52:	8082                	ret
    return -1;
     a54:	597d                	li	s2,-1
     a56:	bfcd                	j	a48 <stat+0x2a>

0000000000000a58 <atoi>:

int
atoi(const char *s)
{
     a58:	1141                	addi	sp,sp,-16
     a5a:	e422                	sd	s0,8(sp)
     a5c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a5e:	00054683          	lbu	a3,0(a0)
     a62:	fd06879b          	addiw	a5,a3,-48
     a66:	0ff7f793          	zext.b	a5,a5
     a6a:	4625                	li	a2,9
     a6c:	02f66863          	bltu	a2,a5,a9c <atoi+0x44>
     a70:	872a                	mv	a4,a0
  n = 0;
     a72:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a74:	0705                	addi	a4,a4,1
     a76:	0025179b          	slliw	a5,a0,0x2
     a7a:	9fa9                	addw	a5,a5,a0
     a7c:	0017979b          	slliw	a5,a5,0x1
     a80:	9fb5                	addw	a5,a5,a3
     a82:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a86:	00074683          	lbu	a3,0(a4)
     a8a:	fd06879b          	addiw	a5,a3,-48
     a8e:	0ff7f793          	zext.b	a5,a5
     a92:	fef671e3          	bgeu	a2,a5,a74 <atoi+0x1c>
  return n;
}
     a96:	6422                	ld	s0,8(sp)
     a98:	0141                	addi	sp,sp,16
     a9a:	8082                	ret
  n = 0;
     a9c:	4501                	li	a0,0
     a9e:	bfe5                	j	a96 <atoi+0x3e>

0000000000000aa0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     aa0:	1141                	addi	sp,sp,-16
     aa2:	e422                	sd	s0,8(sp)
     aa4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aa6:	02b57463          	bgeu	a0,a1,ace <memmove+0x2e>
    while(n-- > 0)
     aaa:	00c05f63          	blez	a2,ac8 <memmove+0x28>
     aae:	1602                	slli	a2,a2,0x20
     ab0:	9201                	srli	a2,a2,0x20
     ab2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ab6:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab8:	0585                	addi	a1,a1,1
     aba:	0705                	addi	a4,a4,1
     abc:	fff5c683          	lbu	a3,-1(a1)
     ac0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ac4:	fef71ae3          	bne	a4,a5,ab8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac8:	6422                	ld	s0,8(sp)
     aca:	0141                	addi	sp,sp,16
     acc:	8082                	ret
    dst += n;
     ace:	00c50733          	add	a4,a0,a2
    src += n;
     ad2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ad4:	fec05ae3          	blez	a2,ac8 <memmove+0x28>
     ad8:	fff6079b          	addiw	a5,a2,-1
     adc:	1782                	slli	a5,a5,0x20
     ade:	9381                	srli	a5,a5,0x20
     ae0:	fff7c793          	not	a5,a5
     ae4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ae6:	15fd                	addi	a1,a1,-1
     ae8:	177d                	addi	a4,a4,-1
     aea:	0005c683          	lbu	a3,0(a1)
     aee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     af2:	fee79ae3          	bne	a5,a4,ae6 <memmove+0x46>
     af6:	bfc9                	j	ac8 <memmove+0x28>

0000000000000af8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af8:	1141                	addi	sp,sp,-16
     afa:	e422                	sd	s0,8(sp)
     afc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     afe:	ca05                	beqz	a2,b2e <memcmp+0x36>
     b00:	fff6069b          	addiw	a3,a2,-1
     b04:	1682                	slli	a3,a3,0x20
     b06:	9281                	srli	a3,a3,0x20
     b08:	0685                	addi	a3,a3,1
     b0a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b0c:	00054783          	lbu	a5,0(a0)
     b10:	0005c703          	lbu	a4,0(a1)
     b14:	00e79863          	bne	a5,a4,b24 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b18:	0505                	addi	a0,a0,1
    p2++;
     b1a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b1c:	fed518e3          	bne	a0,a3,b0c <memcmp+0x14>
  }
  return 0;
     b20:	4501                	li	a0,0
     b22:	a019                	j	b28 <memcmp+0x30>
      return *p1 - *p2;
     b24:	40e7853b          	subw	a0,a5,a4
}
     b28:	6422                	ld	s0,8(sp)
     b2a:	0141                	addi	sp,sp,16
     b2c:	8082                	ret
  return 0;
     b2e:	4501                	li	a0,0
     b30:	bfe5                	j	b28 <memcmp+0x30>

0000000000000b32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b32:	1141                	addi	sp,sp,-16
     b34:	e406                	sd	ra,8(sp)
     b36:	e022                	sd	s0,0(sp)
     b38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b3a:	f67ff0ef          	jal	aa0 <memmove>
}
     b3e:	60a2                	ld	ra,8(sp)
     b40:	6402                	ld	s0,0(sp)
     b42:	0141                	addi	sp,sp,16
     b44:	8082                	ret

0000000000000b46 <strncmp>:



int
strncmp(const char *p, const char *q, uint n)
{
     b46:	1141                	addi	sp,sp,-16
     b48:	e422                	sd	s0,8(sp)
     b4a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
     b4c:	ce11                	beqz	a2,b68 <strncmp+0x22>
     b4e:	00054783          	lbu	a5,0(a0)
     b52:	cf89                	beqz	a5,b6c <strncmp+0x26>
     b54:	0005c703          	lbu	a4,0(a1)
     b58:	00f71a63          	bne	a4,a5,b6c <strncmp+0x26>
    n--, p++, q++;
     b5c:	367d                	addiw	a2,a2,-1
     b5e:	0505                	addi	a0,a0,1
     b60:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
     b62:	f675                	bnez	a2,b4e <strncmp+0x8>
  if(n == 0)
    return 0;
     b64:	4501                	li	a0,0
     b66:	a801                	j	b76 <strncmp+0x30>
     b68:	4501                	li	a0,0
     b6a:	a031                	j	b76 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
     b6c:	00054503          	lbu	a0,0(a0)
     b70:	0005c783          	lbu	a5,0(a1)
     b74:	9d1d                	subw	a0,a0,a5
}
     b76:	6422                	ld	s0,8(sp)
     b78:	0141                	addi	sp,sp,16
     b7a:	8082                	ret

0000000000000b7c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b7c:	4885                	li	a7,1
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b84:	4889                	li	a7,2
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b8c:	488d                	li	a7,3
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b94:	4891                	li	a7,4
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <read>:
.global read
read:
 li a7, SYS_read
     b9c:	4895                	li	a7,5
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <write>:
.global write
write:
 li a7, SYS_write
     ba4:	48c1                	li	a7,16
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <close>:
.global close
close:
 li a7, SYS_close
     bac:	48d5                	li	a7,21
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bb4:	4899                	li	a7,6
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <exec>:
.global exec
exec:
 li a7, SYS_exec
     bbc:	489d                	li	a7,7
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <open>:
.global open
open:
 li a7, SYS_open
     bc4:	48bd                	li	a7,15
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bcc:	48c5                	li	a7,17
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bd4:	48c9                	li	a7,18
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bdc:	48a1                	li	a7,8
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <link>:
.global link
link:
 li a7, SYS_link
     be4:	48cd                	li	a7,19
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bec:	48d1                	li	a7,20
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bf4:	48a5                	li	a7,9
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <dup>:
.global dup
dup:
 li a7, SYS_dup
     bfc:	48a9                	li	a7,10
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c04:	48ad                	li	a7,11
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c0c:	48b1                	li	a7,12
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c14:	48b5                	li	a7,13
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c1c:	48b9                	li	a7,14
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <thread>:
.global thread
thread:
 li a7, SYS_thread
     c24:	48dd                	li	a7,23
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <jointhread>:
.global jointhread
jointhread:
 li a7, SYS_jointhread
     c2c:	48e1                	li	a7,24
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
     c34:	48d9                	li	a7,22
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <setsched>:
.global setsched
setsched:
 li a7, SYS_setsched
     c3c:	48dd                	li	a7,23
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c44:	1101                	addi	sp,sp,-32
     c46:	ec06                	sd	ra,24(sp)
     c48:	e822                	sd	s0,16(sp)
     c4a:	1000                	addi	s0,sp,32
     c4c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c50:	4605                	li	a2,1
     c52:	fef40593          	addi	a1,s0,-17
     c56:	f4fff0ef          	jal	ba4 <write>
}
     c5a:	60e2                	ld	ra,24(sp)
     c5c:	6442                	ld	s0,16(sp)
     c5e:	6105                	addi	sp,sp,32
     c60:	8082                	ret

0000000000000c62 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c62:	715d                	addi	sp,sp,-80
     c64:	e486                	sd	ra,72(sp)
     c66:	e0a2                	sd	s0,64(sp)
     c68:	fc26                	sd	s1,56(sp)
     c6a:	0880                	addi	s0,sp,80
     c6c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c6e:	c299                	beqz	a3,c74 <printint+0x12>
     c70:	0805c963          	bltz	a1,d02 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c74:	2581                	sext.w	a1,a1
  neg = 0;
     c76:	4881                	li	a7,0
     c78:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     c7c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c7e:	2601                	sext.w	a2,a2
     c80:	00001517          	auipc	a0,0x1
     c84:	86050513          	addi	a0,a0,-1952 # 14e0 <digits>
     c88:	883a                	mv	a6,a4
     c8a:	2705                	addiw	a4,a4,1
     c8c:	02c5f7bb          	remuw	a5,a1,a2
     c90:	1782                	slli	a5,a5,0x20
     c92:	9381                	srli	a5,a5,0x20
     c94:	97aa                	add	a5,a5,a0
     c96:	0007c783          	lbu	a5,0(a5)
     c9a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c9e:	0005879b          	sext.w	a5,a1
     ca2:	02c5d5bb          	divuw	a1,a1,a2
     ca6:	0685                	addi	a3,a3,1
     ca8:	fec7f0e3          	bgeu	a5,a2,c88 <printint+0x26>
  if(neg)
     cac:	00088c63          	beqz	a7,cc4 <printint+0x62>
    buf[i++] = '-';
     cb0:	fd070793          	addi	a5,a4,-48
     cb4:	00878733          	add	a4,a5,s0
     cb8:	02d00793          	li	a5,45
     cbc:	fef70423          	sb	a5,-24(a4)
     cc0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cc4:	02e05a63          	blez	a4,cf8 <printint+0x96>
     cc8:	f84a                	sd	s2,48(sp)
     cca:	f44e                	sd	s3,40(sp)
     ccc:	fb840793          	addi	a5,s0,-72
     cd0:	00e78933          	add	s2,a5,a4
     cd4:	fff78993          	addi	s3,a5,-1
     cd8:	99ba                	add	s3,s3,a4
     cda:	377d                	addiw	a4,a4,-1
     cdc:	1702                	slli	a4,a4,0x20
     cde:	9301                	srli	a4,a4,0x20
     ce0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ce4:	fff94583          	lbu	a1,-1(s2)
     ce8:	8526                	mv	a0,s1
     cea:	f5bff0ef          	jal	c44 <putc>
  while(--i >= 0)
     cee:	197d                	addi	s2,s2,-1
     cf0:	ff391ae3          	bne	s2,s3,ce4 <printint+0x82>
     cf4:	7942                	ld	s2,48(sp)
     cf6:	79a2                	ld	s3,40(sp)
}
     cf8:	60a6                	ld	ra,72(sp)
     cfa:	6406                	ld	s0,64(sp)
     cfc:	74e2                	ld	s1,56(sp)
     cfe:	6161                	addi	sp,sp,80
     d00:	8082                	ret
    x = -xx;
     d02:	40b005bb          	negw	a1,a1
    neg = 1;
     d06:	4885                	li	a7,1
    x = -xx;
     d08:	bf85                	j	c78 <printint+0x16>

0000000000000d0a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d0a:	711d                	addi	sp,sp,-96
     d0c:	ec86                	sd	ra,88(sp)
     d0e:	e8a2                	sd	s0,80(sp)
     d10:	e0ca                	sd	s2,64(sp)
     d12:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d14:	0005c903          	lbu	s2,0(a1)
     d18:	26090863          	beqz	s2,f88 <vprintf+0x27e>
     d1c:	e4a6                	sd	s1,72(sp)
     d1e:	fc4e                	sd	s3,56(sp)
     d20:	f852                	sd	s4,48(sp)
     d22:	f456                	sd	s5,40(sp)
     d24:	f05a                	sd	s6,32(sp)
     d26:	ec5e                	sd	s7,24(sp)
     d28:	e862                	sd	s8,16(sp)
     d2a:	e466                	sd	s9,8(sp)
     d2c:	8b2a                	mv	s6,a0
     d2e:	8a2e                	mv	s4,a1
     d30:	8bb2                	mv	s7,a2
  state = 0;
     d32:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d34:	4481                	li	s1,0
     d36:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d38:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d3c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d40:	06c00c93          	li	s9,108
     d44:	a005                	j	d64 <vprintf+0x5a>
        putc(fd, c0);
     d46:	85ca                	mv	a1,s2
     d48:	855a                	mv	a0,s6
     d4a:	efbff0ef          	jal	c44 <putc>
     d4e:	a019                	j	d54 <vprintf+0x4a>
    } else if(state == '%'){
     d50:	03598263          	beq	s3,s5,d74 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     d54:	2485                	addiw	s1,s1,1
     d56:	8726                	mv	a4,s1
     d58:	009a07b3          	add	a5,s4,s1
     d5c:	0007c903          	lbu	s2,0(a5)
     d60:	20090c63          	beqz	s2,f78 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
     d64:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d68:	fe0994e3          	bnez	s3,d50 <vprintf+0x46>
      if(c0 == '%'){
     d6c:	fd579de3          	bne	a5,s5,d46 <vprintf+0x3c>
        state = '%';
     d70:	89be                	mv	s3,a5
     d72:	b7cd                	j	d54 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     d74:	00ea06b3          	add	a3,s4,a4
     d78:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d7c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d7e:	c681                	beqz	a3,d86 <vprintf+0x7c>
     d80:	9752                	add	a4,a4,s4
     d82:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d86:	03878f63          	beq	a5,s8,dc4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     d8a:	05978963          	beq	a5,s9,ddc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d8e:	07500713          	li	a4,117
     d92:	0ee78363          	beq	a5,a4,e78 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d96:	07800713          	li	a4,120
     d9a:	12e78563          	beq	a5,a4,ec4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d9e:	07000713          	li	a4,112
     da2:	14e78a63          	beq	a5,a4,ef6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     da6:	07300713          	li	a4,115
     daa:	18e78a63          	beq	a5,a4,f3e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     dae:	02500713          	li	a4,37
     db2:	04e79563          	bne	a5,a4,dfc <vprintf+0xf2>
        putc(fd, '%');
     db6:	02500593          	li	a1,37
     dba:	855a                	mv	a0,s6
     dbc:	e89ff0ef          	jal	c44 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     dc0:	4981                	li	s3,0
     dc2:	bf49                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     dc4:	008b8913          	addi	s2,s7,8
     dc8:	4685                	li	a3,1
     dca:	4629                	li	a2,10
     dcc:	000ba583          	lw	a1,0(s7)
     dd0:	855a                	mv	a0,s6
     dd2:	e91ff0ef          	jal	c62 <printint>
     dd6:	8bca                	mv	s7,s2
      state = 0;
     dd8:	4981                	li	s3,0
     dda:	bfad                	j	d54 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     ddc:	06400793          	li	a5,100
     de0:	02f68963          	beq	a3,a5,e12 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     de4:	06c00793          	li	a5,108
     de8:	04f68263          	beq	a3,a5,e2c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     dec:	07500793          	li	a5,117
     df0:	0af68063          	beq	a3,a5,e90 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     df4:	07800793          	li	a5,120
     df8:	0ef68263          	beq	a3,a5,edc <vprintf+0x1d2>
        putc(fd, '%');
     dfc:	02500593          	li	a1,37
     e00:	855a                	mv	a0,s6
     e02:	e43ff0ef          	jal	c44 <putc>
        putc(fd, c0);
     e06:	85ca                	mv	a1,s2
     e08:	855a                	mv	a0,s6
     e0a:	e3bff0ef          	jal	c44 <putc>
      state = 0;
     e0e:	4981                	li	s3,0
     e10:	b791                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e12:	008b8913          	addi	s2,s7,8
     e16:	4685                	li	a3,1
     e18:	4629                	li	a2,10
     e1a:	000bb583          	ld	a1,0(s7)
     e1e:	855a                	mv	a0,s6
     e20:	e43ff0ef          	jal	c62 <printint>
        i += 1;
     e24:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e26:	8bca                	mv	s7,s2
      state = 0;
     e28:	4981                	li	s3,0
        i += 1;
     e2a:	b72d                	j	d54 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e2c:	06400793          	li	a5,100
     e30:	02f60763          	beq	a2,a5,e5e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e34:	07500793          	li	a5,117
     e38:	06f60963          	beq	a2,a5,eaa <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e3c:	07800793          	li	a5,120
     e40:	faf61ee3          	bne	a2,a5,dfc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e44:	008b8913          	addi	s2,s7,8
     e48:	4681                	li	a3,0
     e4a:	4641                	li	a2,16
     e4c:	000bb583          	ld	a1,0(s7)
     e50:	855a                	mv	a0,s6
     e52:	e11ff0ef          	jal	c62 <printint>
        i += 2;
     e56:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e58:	8bca                	mv	s7,s2
      state = 0;
     e5a:	4981                	li	s3,0
        i += 2;
     e5c:	bde5                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e5e:	008b8913          	addi	s2,s7,8
     e62:	4685                	li	a3,1
     e64:	4629                	li	a2,10
     e66:	000bb583          	ld	a1,0(s7)
     e6a:	855a                	mv	a0,s6
     e6c:	df7ff0ef          	jal	c62 <printint>
        i += 2;
     e70:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e72:	8bca                	mv	s7,s2
      state = 0;
     e74:	4981                	li	s3,0
        i += 2;
     e76:	bdf9                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     e78:	008b8913          	addi	s2,s7,8
     e7c:	4681                	li	a3,0
     e7e:	4629                	li	a2,10
     e80:	000ba583          	lw	a1,0(s7)
     e84:	855a                	mv	a0,s6
     e86:	dddff0ef          	jal	c62 <printint>
     e8a:	8bca                	mv	s7,s2
      state = 0;
     e8c:	4981                	li	s3,0
     e8e:	b5d9                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e90:	008b8913          	addi	s2,s7,8
     e94:	4681                	li	a3,0
     e96:	4629                	li	a2,10
     e98:	000bb583          	ld	a1,0(s7)
     e9c:	855a                	mv	a0,s6
     e9e:	dc5ff0ef          	jal	c62 <printint>
        i += 1;
     ea2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ea4:	8bca                	mv	s7,s2
      state = 0;
     ea6:	4981                	li	s3,0
        i += 1;
     ea8:	b575                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eaa:	008b8913          	addi	s2,s7,8
     eae:	4681                	li	a3,0
     eb0:	4629                	li	a2,10
     eb2:	000bb583          	ld	a1,0(s7)
     eb6:	855a                	mv	a0,s6
     eb8:	dabff0ef          	jal	c62 <printint>
        i += 2;
     ebc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ebe:	8bca                	mv	s7,s2
      state = 0;
     ec0:	4981                	li	s3,0
        i += 2;
     ec2:	bd49                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     ec4:	008b8913          	addi	s2,s7,8
     ec8:	4681                	li	a3,0
     eca:	4641                	li	a2,16
     ecc:	000ba583          	lw	a1,0(s7)
     ed0:	855a                	mv	a0,s6
     ed2:	d91ff0ef          	jal	c62 <printint>
     ed6:	8bca                	mv	s7,s2
      state = 0;
     ed8:	4981                	li	s3,0
     eda:	bdad                	j	d54 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     edc:	008b8913          	addi	s2,s7,8
     ee0:	4681                	li	a3,0
     ee2:	4641                	li	a2,16
     ee4:	000bb583          	ld	a1,0(s7)
     ee8:	855a                	mv	a0,s6
     eea:	d79ff0ef          	jal	c62 <printint>
        i += 1;
     eee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     ef0:	8bca                	mv	s7,s2
      state = 0;
     ef2:	4981                	li	s3,0
        i += 1;
     ef4:	b585                	j	d54 <vprintf+0x4a>
     ef6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     ef8:	008b8d13          	addi	s10,s7,8
     efc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f00:	03000593          	li	a1,48
     f04:	855a                	mv	a0,s6
     f06:	d3fff0ef          	jal	c44 <putc>
  putc(fd, 'x');
     f0a:	07800593          	li	a1,120
     f0e:	855a                	mv	a0,s6
     f10:	d35ff0ef          	jal	c44 <putc>
     f14:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f16:	00000b97          	auipc	s7,0x0
     f1a:	5cab8b93          	addi	s7,s7,1482 # 14e0 <digits>
     f1e:	03c9d793          	srli	a5,s3,0x3c
     f22:	97de                	add	a5,a5,s7
     f24:	0007c583          	lbu	a1,0(a5)
     f28:	855a                	mv	a0,s6
     f2a:	d1bff0ef          	jal	c44 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f2e:	0992                	slli	s3,s3,0x4
     f30:	397d                	addiw	s2,s2,-1
     f32:	fe0916e3          	bnez	s2,f1e <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     f36:	8bea                	mv	s7,s10
      state = 0;
     f38:	4981                	li	s3,0
     f3a:	6d02                	ld	s10,0(sp)
     f3c:	bd21                	j	d54 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     f3e:	008b8993          	addi	s3,s7,8
     f42:	000bb903          	ld	s2,0(s7)
     f46:	00090f63          	beqz	s2,f64 <vprintf+0x25a>
        for(; *s; s++)
     f4a:	00094583          	lbu	a1,0(s2)
     f4e:	c195                	beqz	a1,f72 <vprintf+0x268>
          putc(fd, *s);
     f50:	855a                	mv	a0,s6
     f52:	cf3ff0ef          	jal	c44 <putc>
        for(; *s; s++)
     f56:	0905                	addi	s2,s2,1
     f58:	00094583          	lbu	a1,0(s2)
     f5c:	f9f5                	bnez	a1,f50 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f5e:	8bce                	mv	s7,s3
      state = 0;
     f60:	4981                	li	s3,0
     f62:	bbcd                	j	d54 <vprintf+0x4a>
          s = "(null)";
     f64:	00000917          	auipc	s2,0x0
     f68:	51490913          	addi	s2,s2,1300 # 1478 <malloc+0x408>
        for(; *s; s++)
     f6c:	02800593          	li	a1,40
     f70:	b7c5                	j	f50 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
     f72:	8bce                	mv	s7,s3
      state = 0;
     f74:	4981                	li	s3,0
     f76:	bbf9                	j	d54 <vprintf+0x4a>
     f78:	64a6                	ld	s1,72(sp)
     f7a:	79e2                	ld	s3,56(sp)
     f7c:	7a42                	ld	s4,48(sp)
     f7e:	7aa2                	ld	s5,40(sp)
     f80:	7b02                	ld	s6,32(sp)
     f82:	6be2                	ld	s7,24(sp)
     f84:	6c42                	ld	s8,16(sp)
     f86:	6ca2                	ld	s9,8(sp)
    }
  }
}
     f88:	60e6                	ld	ra,88(sp)
     f8a:	6446                	ld	s0,80(sp)
     f8c:	6906                	ld	s2,64(sp)
     f8e:	6125                	addi	sp,sp,96
     f90:	8082                	ret

0000000000000f92 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f92:	715d                	addi	sp,sp,-80
     f94:	ec06                	sd	ra,24(sp)
     f96:	e822                	sd	s0,16(sp)
     f98:	1000                	addi	s0,sp,32
     f9a:	e010                	sd	a2,0(s0)
     f9c:	e414                	sd	a3,8(s0)
     f9e:	e818                	sd	a4,16(s0)
     fa0:	ec1c                	sd	a5,24(s0)
     fa2:	03043023          	sd	a6,32(s0)
     fa6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     faa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fae:	8622                	mv	a2,s0
     fb0:	d5bff0ef          	jal	d0a <vprintf>
}
     fb4:	60e2                	ld	ra,24(sp)
     fb6:	6442                	ld	s0,16(sp)
     fb8:	6161                	addi	sp,sp,80
     fba:	8082                	ret

0000000000000fbc <printf>:

void
printf(const char *fmt, ...)
{
     fbc:	711d                	addi	sp,sp,-96
     fbe:	ec06                	sd	ra,24(sp)
     fc0:	e822                	sd	s0,16(sp)
     fc2:	1000                	addi	s0,sp,32
     fc4:	e40c                	sd	a1,8(s0)
     fc6:	e810                	sd	a2,16(s0)
     fc8:	ec14                	sd	a3,24(s0)
     fca:	f018                	sd	a4,32(s0)
     fcc:	f41c                	sd	a5,40(s0)
     fce:	03043823          	sd	a6,48(s0)
     fd2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fd6:	00840613          	addi	a2,s0,8
     fda:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fde:	85aa                	mv	a1,a0
     fe0:	4505                	li	a0,1
     fe2:	d29ff0ef          	jal	d0a <vprintf>
}
     fe6:	60e2                	ld	ra,24(sp)
     fe8:	6442                	ld	s0,16(sp)
     fea:	6125                	addi	sp,sp,96
     fec:	8082                	ret

0000000000000fee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     fee:	1141                	addi	sp,sp,-16
     ff0:	e422                	sd	s0,8(sp)
     ff2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ff4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ff8:	00001797          	auipc	a5,0x1
     ffc:	0187b783          	ld	a5,24(a5) # 2010 <freep>
    1000:	a02d                	j	102a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1002:	4618                	lw	a4,8(a2)
    1004:	9f2d                	addw	a4,a4,a1
    1006:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    100a:	6398                	ld	a4,0(a5)
    100c:	6310                	ld	a2,0(a4)
    100e:	a83d                	j	104c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1010:	ff852703          	lw	a4,-8(a0)
    1014:	9f31                	addw	a4,a4,a2
    1016:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1018:	ff053683          	ld	a3,-16(a0)
    101c:	a091                	j	1060 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    101e:	6398                	ld	a4,0(a5)
    1020:	00e7e463          	bltu	a5,a4,1028 <free+0x3a>
    1024:	00e6ea63          	bltu	a3,a4,1038 <free+0x4a>
{
    1028:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    102a:	fed7fae3          	bgeu	a5,a3,101e <free+0x30>
    102e:	6398                	ld	a4,0(a5)
    1030:	00e6e463          	bltu	a3,a4,1038 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1034:	fee7eae3          	bltu	a5,a4,1028 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1038:	ff852583          	lw	a1,-8(a0)
    103c:	6390                	ld	a2,0(a5)
    103e:	02059813          	slli	a6,a1,0x20
    1042:	01c85713          	srli	a4,a6,0x1c
    1046:	9736                	add	a4,a4,a3
    1048:	fae60de3          	beq	a2,a4,1002 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    104c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1050:	4790                	lw	a2,8(a5)
    1052:	02061593          	slli	a1,a2,0x20
    1056:	01c5d713          	srli	a4,a1,0x1c
    105a:	973e                	add	a4,a4,a5
    105c:	fae68ae3          	beq	a3,a4,1010 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1060:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1062:	00001717          	auipc	a4,0x1
    1066:	faf73723          	sd	a5,-82(a4) # 2010 <freep>
}
    106a:	6422                	ld	s0,8(sp)
    106c:	0141                	addi	sp,sp,16
    106e:	8082                	ret

0000000000001070 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1070:	7139                	addi	sp,sp,-64
    1072:	fc06                	sd	ra,56(sp)
    1074:	f822                	sd	s0,48(sp)
    1076:	f426                	sd	s1,40(sp)
    1078:	ec4e                	sd	s3,24(sp)
    107a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    107c:	02051493          	slli	s1,a0,0x20
    1080:	9081                	srli	s1,s1,0x20
    1082:	04bd                	addi	s1,s1,15
    1084:	8091                	srli	s1,s1,0x4
    1086:	0014899b          	addiw	s3,s1,1
    108a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    108c:	00001517          	auipc	a0,0x1
    1090:	f8453503          	ld	a0,-124(a0) # 2010 <freep>
    1094:	c915                	beqz	a0,10c8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1096:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1098:	4798                	lw	a4,8(a5)
    109a:	08977a63          	bgeu	a4,s1,112e <malloc+0xbe>
    109e:	f04a                	sd	s2,32(sp)
    10a0:	e852                	sd	s4,16(sp)
    10a2:	e456                	sd	s5,8(sp)
    10a4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10a6:	8a4e                	mv	s4,s3
    10a8:	0009871b          	sext.w	a4,s3
    10ac:	6685                	lui	a3,0x1
    10ae:	00d77363          	bgeu	a4,a3,10b4 <malloc+0x44>
    10b2:	6a05                	lui	s4,0x1
    10b4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10b8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10bc:	00001917          	auipc	s2,0x1
    10c0:	f5490913          	addi	s2,s2,-172 # 2010 <freep>
  if(p == (char*)-1)
    10c4:	5afd                	li	s5,-1
    10c6:	a081                	j	1106 <malloc+0x96>
    10c8:	f04a                	sd	s2,32(sp)
    10ca:	e852                	sd	s4,16(sp)
    10cc:	e456                	sd	s5,8(sp)
    10ce:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10d0:	00001797          	auipc	a5,0x1
    10d4:	33878793          	addi	a5,a5,824 # 2408 <base>
    10d8:	00001717          	auipc	a4,0x1
    10dc:	f2f73c23          	sd	a5,-200(a4) # 2010 <freep>
    10e0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10e2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10e6:	b7c1                	j	10a6 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    10e8:	6398                	ld	a4,0(a5)
    10ea:	e118                	sd	a4,0(a0)
    10ec:	a8a9                	j	1146 <malloc+0xd6>
  hp->s.size = nu;
    10ee:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10f2:	0541                	addi	a0,a0,16
    10f4:	efbff0ef          	jal	fee <free>
  return freep;
    10f8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10fc:	c12d                	beqz	a0,115e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1100:	4798                	lw	a4,8(a5)
    1102:	02977263          	bgeu	a4,s1,1126 <malloc+0xb6>
    if(p == freep)
    1106:	00093703          	ld	a4,0(s2)
    110a:	853e                	mv	a0,a5
    110c:	fef719e3          	bne	a4,a5,10fe <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1110:	8552                	mv	a0,s4
    1112:	afbff0ef          	jal	c0c <sbrk>
  if(p == (char*)-1)
    1116:	fd551ce3          	bne	a0,s5,10ee <malloc+0x7e>
        return 0;
    111a:	4501                	li	a0,0
    111c:	7902                	ld	s2,32(sp)
    111e:	6a42                	ld	s4,16(sp)
    1120:	6aa2                	ld	s5,8(sp)
    1122:	6b02                	ld	s6,0(sp)
    1124:	a03d                	j	1152 <malloc+0xe2>
    1126:	7902                	ld	s2,32(sp)
    1128:	6a42                	ld	s4,16(sp)
    112a:	6aa2                	ld	s5,8(sp)
    112c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    112e:	fae48de3          	beq	s1,a4,10e8 <malloc+0x78>
        p->s.size -= nunits;
    1132:	4137073b          	subw	a4,a4,s3
    1136:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1138:	02071693          	slli	a3,a4,0x20
    113c:	01c6d713          	srli	a4,a3,0x1c
    1140:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1142:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1146:	00001717          	auipc	a4,0x1
    114a:	eca73523          	sd	a0,-310(a4) # 2010 <freep>
      return (void*)(p + 1);
    114e:	01078513          	addi	a0,a5,16
  }
}
    1152:	70e2                	ld	ra,56(sp)
    1154:	7442                	ld	s0,48(sp)
    1156:	74a2                	ld	s1,40(sp)
    1158:	69e2                	ld	s3,24(sp)
    115a:	6121                	addi	sp,sp,64
    115c:	8082                	ret
    115e:	7902                	ld	s2,32(sp)
    1160:	6a42                	ld	s4,16(sp)
    1162:	6aa2                	ld	s5,8(sp)
    1164:	6b02                	ld	s6,0(sp)
    1166:	b7f5                	j	1152 <malloc+0xe2>
