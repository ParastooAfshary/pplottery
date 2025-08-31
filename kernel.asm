
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00008117          	auipc	sp,0x8
    80000004:	92010113          	addi	sp,sp,-1760 # 80007920 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddbaf>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	1e4020ef          	jal	800022de <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	0000f517          	auipc	a0,0xf
    80000158:	7cc50513          	addi	a0,a0,1996 # 8000f920 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	0000f497          	auipc	s1,0xf
    80000164:	7c048493          	addi	s1,s1,1984 # 8000f920 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00010917          	auipc	s2,0x10
    8000016c:	85090913          	addi	s2,s2,-1968 # 8000f9b8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	760010ef          	jal	800018e0 <myproc>
    80000184:	7ed010ef          	jal	80002170 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	5ab010ef          	jal	80001f38 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	0000f717          	auipc	a4,0xf
    800001a4:	78070713          	addi	a4,a4,1920 # 8000f920 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	0c2020ef          	jal	80002294 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	0000f517          	auipc	a0,0xf
    800001ee:	73650513          	addi	a0,a0,1846 # 8000f920 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	0000f717          	auipc	a4,0xf
    80000218:	7af72223          	sw	a5,1956(a4) # 8000f9b8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	0000f517          	auipc	a0,0xf
    8000022e:	6f650513          	addi	a0,a0,1782 # 8000f920 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	0000f517          	auipc	a0,0xf
    80000282:	6a250513          	addi	a0,a0,1698 # 8000f920 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	088020ef          	jal	80002328 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	0000f517          	auipc	a0,0xf
    800002a8:	67c50513          	addi	a0,a0,1660 # 8000f920 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	0000f717          	auipc	a4,0xf
    800002c6:	65e70713          	addi	a4,a4,1630 # 8000f920 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	0000f797          	auipc	a5,0xf
    800002ec:	63878793          	addi	a5,a5,1592 # 8000f920 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	0000f797          	auipc	a5,0xf
    8000031a:	6a27a783          	lw	a5,1698(a5) # 8000f9b8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	0000f717          	auipc	a4,0xf
    80000330:	5f470713          	addi	a4,a4,1524 # 8000f920 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	0000f497          	auipc	s1,0xf
    80000340:	5e448493          	addi	s1,s1,1508 # 8000f920 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	0000f717          	auipc	a4,0xf
    80000382:	5a270713          	addi	a4,a4,1442 # 8000f920 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	0000f717          	auipc	a4,0xf
    80000398:	62f72623          	sw	a5,1580(a4) # 8000f9c0 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	0000f797          	auipc	a5,0xf
    800003b6:	56e78793          	addi	a5,a5,1390 # 8000f920 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	0000f797          	auipc	a5,0xf
    800003da:	5ec7a323          	sw	a2,1510(a5) # 8000f9bc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	0000f517          	auipc	a0,0xf
    800003e2:	5da50513          	addi	a0,a0,1498 # 8000f9b8 <cons+0x98>
    800003e6:	39f010ef          	jal	80001f84 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	0000f517          	auipc	a0,0xf
    80000400:	52450513          	addi	a0,a0,1316 # 8000f920 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	0001f797          	auipc	a5,0x1f
    80000410:	6ac78793          	addi	a5,a5,1708 # 8001fab8 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7139                	addi	sp,sp,-64
    80000432:	fc06                	sd	ra,56(sp)
    80000434:	f822                	sd	s0,48(sp)
    80000436:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fc840693          	addi	a3,s0,-56

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	32a60613          	addi	a2,a2,810 # 80007770 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78423          	sb	a4,-24(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	f426                	sd	s1,40(sp)
    80000486:	f04a                	sd	s2,32(sp)
    80000488:	fc840713          	addi	a4,s0,-56
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	74a2                	ld	s1,40(sp)
    800004b0:	7902                	ld	s2,32(sp)
}
    800004b2:	70e2                	ld	ra,56(sp)
    800004b4:	7442                	ld	s0,48(sp)
    800004b6:	6121                	addi	sp,sp,64
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	0000f797          	auipc	a5,0xf
    800004e4:	5007a783          	lw	a5,1280(a5) # 8000f9e0 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	0000f517          	auipc	a0,0xf
    80000530:	49c50513          	addi	a0,a0,1180 # 8000f9c8 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	084b8b93          	addi	s7,s7,132 # 80007770 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	0000f517          	auipc	a0,0xf
    8000078a:	24250513          	addi	a0,a0,578 # 8000f9c8 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	0000f797          	auipc	a5,0xf
    800007a4:	2407a023          	sw	zero,576(a5) # 8000f9e0 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	00007717          	auipc	a4,0x7
    800007c8:	10f72e23          	sw	a5,284(a4) # 800078e0 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	0000f497          	auipc	s1,0xf
    800007dc:	1f048493          	addi	s1,s1,496 # 8000f9c8 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	0000f517          	auipc	a0,0xf
    80000844:	1a850513          	addi	a0,a0,424 # 8000f9e8 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	00007797          	auipc	a5,0x7
    80000868:	07c7a783          	lw	a5,124(a5) # 800078e0 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	00007797          	auipc	a5,0x7
    8000089e:	04e7b783          	ld	a5,78(a5) # 800078e8 <uart_tx_r>
    800008a2:	00007717          	auipc	a4,0x7
    800008a6:	04e73703          	ld	a4,78(a4) # 800078f0 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	0000fa97          	auipc	s5,0xf
    800008cc:	120a8a93          	addi	s5,s5,288 # 8000f9e8 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	00007497          	auipc	s1,0x7
    800008d4:	01848493          	addi	s1,s1,24 # 800078e8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	00007997          	auipc	s3,0x7
    800008e0:	01498993          	addi	s3,s3,20 # 800078f0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	686010ef          	jal	80001f84 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	0000f517          	auipc	a0,0xf
    80000950:	09c50513          	addi	a0,a0,156 # 8000f9e8 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	00007797          	auipc	a5,0x7
    8000095c:	f887a783          	lw	a5,-120(a5) # 800078e0 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	00007717          	auipc	a4,0x7
    80000966:	f8e73703          	ld	a4,-114(a4) # 800078f0 <uart_tx_w>
    8000096a:	00007797          	auipc	a5,0x7
    8000096e:	f7e7b783          	ld	a5,-130(a5) # 800078e8 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	0000f997          	auipc	s3,0xf
    8000097a:	07298993          	addi	s3,s3,114 # 8000f9e8 <uart_tx_lock>
    8000097e:	00007497          	auipc	s1,0x7
    80000982:	f6a48493          	addi	s1,s1,-150 # 800078e8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00007917          	auipc	s2,0x7
    8000098a:	f6a90913          	addi	s2,s2,-150 # 800078f0 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	5a2010ef          	jal	80001f38 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	0000f497          	auipc	s1,0xf
    800009ac:	04048493          	addi	s1,s1,64 # 8000f9e8 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	00007797          	auipc	a5,0x7
    800009c0:	f2e7ba23          	sd	a4,-204(a5) # 800078f0 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	0000f497          	auipc	s1,0xf
    80000a24:	fc848493          	addi	s1,s1,-56 # 8000f9e8 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00020797          	auipc	a5,0x20
    80000a5a:	1fa78793          	addi	a5,a5,506 # 80020c50 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	0000f917          	auipc	s2,0xf
    80000a76:	fae90913          	addi	s2,s2,-82 # 8000fa20 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	0000f517          	auipc	a0,0xf
    80000b04:	f2050513          	addi	a0,a0,-224 # 8000fa20 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00020517          	auipc	a0,0x20
    80000b14:	14050513          	addi	a0,a0,320 # 80020c50 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	0000f497          	auipc	s1,0xf
    80000b32:	ef248493          	addi	s1,s1,-270 # 8000fa20 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f517          	auipc	a0,0xf
    80000b46:	ede50513          	addi	a0,a0,-290 # 8000fa20 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	0000f517          	auipc	a0,0xf
    80000b6a:	eba50513          	addi	a0,a0,-326 # 8000fa20 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	527000ef          	jal	800018c4 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	4f9000ef          	jal	800018c4 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	4f1000ef          	jal	800018c4 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	4dd000ef          	jal	800018c4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1c:	4a9000ef          	jal	800018c4 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	485000ef          	jal	800018c4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca6:	0f50000f          	fence	iorw,ow
    80000caa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffde3b1>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	24b000ef          	jal	800018b4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00007717          	auipc	a4,0x7
    80000e72:	a8a70713          	addi	a4,a4,-1398 # 800078f8 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e82:	233000ef          	jal	800018b4 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	5f0010ef          	jal	80002488 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	4cc040ef          	jal	80005368 <plicinithart>
  }

  scheduler();        
    80000ea0:	679000ef          	jal	80001d18 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	123000ef          	jal	800017fe <procinit>
    trapinit();      // trap vectors
    80000ee0:	584010ef          	jal	80002464 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	5a4010ef          	jal	80002488 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	466040ef          	jal	8000534e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	47c040ef          	jal	80005368 <plicinithart>
    binit();         // buffer cache
    80000ef0:	42b010ef          	jal	80002b1a <binit>
    iinit();         // inode table
    80000ef4:	21c020ef          	jal	80003110 <iinit>
    fileinit();      // file table
    80000ef8:	7c9020ef          	jal	80003ec0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	55c040ef          	jal	80005458 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	44d000ef          	jal	80001b4c <userinit>
    __sync_synchronize();
    80000f04:	0ff0000f          	fence
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00007717          	auipc	a4,0x7
    80000f0e:	9ef72723          	sw	a5,-1554(a4) # 800078f8 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00007797          	auipc	a5,0x7
    80000f22:	9e27b783          	ld	a5,-1566(a5) # 80007900 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde3a7>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00006517          	auipc	a0,0x6
    8000107c:	04050513          	addi	a0,a0,64 # 800070b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	05450513          	addi	a0,a0,84 # 800070d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00006517          	auipc	a0,0x6
    80001094:	06850513          	addi	a0,a0,104 # 800070f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00006517          	auipc	a0,0x6
    800010a0:	06c50513          	addi	a0,a0,108 # 80007108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00006517          	auipc	a0,0x6
    800010e4:	03850513          	addi	a0,a0,56 # 80007118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00006917          	auipc	s2,0x6
    80001142:	ec290913          	addi	s2,s2,-318 # 80007000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80006697          	auipc	a3,0x80006
    8000114c:	eb868693          	addi	a3,a3,-328 # 7000 <_entry-0x7fff9000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00005617          	auipc	a2,0x5
    80001178:	e8c60613          	addi	a2,a2,-372 # 80006000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	00006797          	auipc	a5,0x6
    800011ae:	74a7bb23          	sd	a0,1878(a5) # 80007900 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00006517          	auipc	a0,0x6
    800011fe:	f2650513          	addi	a0,a0,-218 # 80007120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00006517          	auipc	a0,0x6
    8000120a:	f3250513          	addi	a0,a0,-206 # 80007138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00006517          	auipc	a0,0x6
    80001216:	f3650513          	addi	a0,a0,-202 # 80007148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00006517          	auipc	a0,0x6
    80001222:	f4250513          	addi	a0,a0,-190 # 80007160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80007178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00006517          	auipc	a0,0x6
    80001426:	d7650513          	addi	a0,a0,-650 # 80007198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00006517          	auipc	a0,0x6
    800014e4:	cc850513          	addi	a0,a0,-824 # 800071a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00006517          	auipc	a0,0x6
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800071c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00006517          	auipc	a0,0x6
    8000154a:	ca250513          	addi	a0,a0,-862 # 800071e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	0000e497          	auipc	s1,0xe
    80001780:	6f448493          	addi	s1,s1,1780 # 8000fe70 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	04fa5937          	lui	s2,0x4fa5
    8000178a:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    8000178e:	0932                	slli	s2,s2,0xc
    80001790:	fa590913          	addi	s2,s2,-91
    80001794:	0932                	slli	s2,s2,0xc
    80001796:	fa590913          	addi	s2,s2,-91
    8000179a:	0932                	slli	s2,s2,0xc
    8000179c:	fa590913          	addi	s2,s2,-91
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00014a97          	auipc	s5,0x14
    800017ac:	0c8a8a93          	addi	s5,s5,200 # 80015870 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	858d                	srai	a1,a1,0x3
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	16848493          	addi	s1,s1,360
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00006517          	auipc	a0,0x6
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800071f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017fe:	7139                	addi	sp,sp,-64
    80001800:	fc06                	sd	ra,56(sp)
    80001802:	f822                	sd	s0,48(sp)
    80001804:	f426                	sd	s1,40(sp)
    80001806:	f04a                	sd	s2,32(sp)
    80001808:	ec4e                	sd	s3,24(sp)
    8000180a:	e852                	sd	s4,16(sp)
    8000180c:	e456                	sd	s5,8(sp)
    8000180e:	e05a                	sd	s6,0(sp)
    80001810:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001812:	00006597          	auipc	a1,0x6
    80001816:	9ee58593          	addi	a1,a1,-1554 # 80007200 <etext+0x200>
    8000181a:	0000e517          	auipc	a0,0xe
    8000181e:	22650513          	addi	a0,a0,550 # 8000fa40 <pid_lock>
    80001822:	b52ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001826:	00006597          	auipc	a1,0x6
    8000182a:	9e258593          	addi	a1,a1,-1566 # 80007208 <etext+0x208>
    8000182e:	0000e517          	auipc	a0,0xe
    80001832:	22a50513          	addi	a0,a0,554 # 8000fa58 <wait_lock>
    80001836:	b3eff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183a:	0000e497          	auipc	s1,0xe
    8000183e:	63648493          	addi	s1,s1,1590 # 8000fe70 <proc>
      initlock(&p->lock, "proc");
    80001842:	00006b17          	auipc	s6,0x6
    80001846:	9d6b0b13          	addi	s6,s6,-1578 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000184a:	8aa6                	mv	s5,s1
    8000184c:	04fa5937          	lui	s2,0x4fa5
    80001850:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001854:	0932                	slli	s2,s2,0xc
    80001856:	fa590913          	addi	s2,s2,-91
    8000185a:	0932                	slli	s2,s2,0xc
    8000185c:	fa590913          	addi	s2,s2,-91
    80001860:	0932                	slli	s2,s2,0xc
    80001862:	fa590913          	addi	s2,s2,-91
    80001866:	040009b7          	lui	s3,0x4000
    8000186a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000186c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186e:	00014a17          	auipc	s4,0x14
    80001872:	002a0a13          	addi	s4,s4,2 # 80015870 <tickslock>
      initlock(&p->lock, "proc");
    80001876:	85da                	mv	a1,s6
    80001878:	8526                	mv	a0,s1
    8000187a:	afaff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    8000187e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001882:	415487b3          	sub	a5,s1,s5
    80001886:	878d                	srai	a5,a5,0x3
    80001888:	032787b3          	mul	a5,a5,s2
    8000188c:	2785                	addiw	a5,a5,1
    8000188e:	00d7979b          	slliw	a5,a5,0xd
    80001892:	40f987b3          	sub	a5,s3,a5
    80001896:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001898:	16848493          	addi	s1,s1,360
    8000189c:	fd449de3          	bne	s1,s4,80001876 <procinit+0x78>
  }
}
    800018a0:	70e2                	ld	ra,56(sp)
    800018a2:	7442                	ld	s0,48(sp)
    800018a4:	74a2                	ld	s1,40(sp)
    800018a6:	7902                	ld	s2,32(sp)
    800018a8:	69e2                	ld	s3,24(sp)
    800018aa:	6a42                	ld	s4,16(sp)
    800018ac:	6aa2                	ld	s5,8(sp)
    800018ae:	6b02                	ld	s6,0(sp)
    800018b0:	6121                	addi	sp,sp,64
    800018b2:	8082                	ret

00000000800018b4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018b4:	1141                	addi	sp,sp,-16
    800018b6:	e422                	sd	s0,8(sp)
    800018b8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ba:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018bc:	2501                	sext.w	a0,a0
    800018be:	6422                	ld	s0,8(sp)
    800018c0:	0141                	addi	sp,sp,16
    800018c2:	8082                	ret

00000000800018c4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018c4:	1141                	addi	sp,sp,-16
    800018c6:	e422                	sd	s0,8(sp)
    800018c8:	0800                	addi	s0,sp,16
    800018ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018cc:	2781                	sext.w	a5,a5
    800018ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800018d0:	0000e517          	auipc	a0,0xe
    800018d4:	1a050513          	addi	a0,a0,416 # 8000fa70 <cpus>
    800018d8:	953e                	add	a0,a0,a5
    800018da:	6422                	ld	s0,8(sp)
    800018dc:	0141                	addi	sp,sp,16
    800018de:	8082                	ret

00000000800018e0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800018e0:	1101                	addi	sp,sp,-32
    800018e2:	ec06                	sd	ra,24(sp)
    800018e4:	e822                	sd	s0,16(sp)
    800018e6:	e426                	sd	s1,8(sp)
    800018e8:	1000                	addi	s0,sp,32
  push_off();
    800018ea:	acaff0ef          	jal	80000bb4 <push_off>
    800018ee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018f0:	2781                	sext.w	a5,a5
    800018f2:	079e                	slli	a5,a5,0x7
    800018f4:	0000e717          	auipc	a4,0xe
    800018f8:	14c70713          	addi	a4,a4,332 # 8000fa40 <pid_lock>
    800018fc:	97ba                	add	a5,a5,a4
    800018fe:	7b84                	ld	s1,48(a5)
  pop_off();
    80001900:	b38ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001904:	8526                	mv	a0,s1
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001910:	1141                	addi	sp,sp,-16
    80001912:	e406                	sd	ra,8(sp)
    80001914:	e022                	sd	s0,0(sp)
    80001916:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001918:	fc9ff0ef          	jal	800018e0 <myproc>
    8000191c:	b70ff0ef          	jal	80000c8c <release>

  if (first) {
    80001920:	00006797          	auipc	a5,0x6
    80001924:	f707a783          	lw	a5,-144(a5) # 80007890 <first.1>
    80001928:	e799                	bnez	a5,80001936 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000192a:	377000ef          	jal	800024a0 <usertrapret>
}
    8000192e:	60a2                	ld	ra,8(sp)
    80001930:	6402                	ld	s0,0(sp)
    80001932:	0141                	addi	sp,sp,16
    80001934:	8082                	ret
    fsinit(ROOTDEV);
    80001936:	4505                	li	a0,1
    80001938:	76c010ef          	jal	800030a4 <fsinit>
    first = 0;
    8000193c:	00006797          	auipc	a5,0x6
    80001940:	f407aa23          	sw	zero,-172(a5) # 80007890 <first.1>
    __sync_synchronize();
    80001944:	0ff0000f          	fence
    80001948:	b7cd                	j	8000192a <forkret+0x1a>

000000008000194a <allocpid>:
{
    8000194a:	1101                	addi	sp,sp,-32
    8000194c:	ec06                	sd	ra,24(sp)
    8000194e:	e822                	sd	s0,16(sp)
    80001950:	e426                	sd	s1,8(sp)
    80001952:	e04a                	sd	s2,0(sp)
    80001954:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001956:	0000e917          	auipc	s2,0xe
    8000195a:	0ea90913          	addi	s2,s2,234 # 8000fa40 <pid_lock>
    8000195e:	854a                	mv	a0,s2
    80001960:	a94ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    80001964:	00006797          	auipc	a5,0x6
    80001968:	f3078793          	addi	a5,a5,-208 # 80007894 <nextpid>
    8000196c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000196e:	0014871b          	addiw	a4,s1,1
    80001972:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001974:	854a                	mv	a0,s2
    80001976:	b16ff0ef          	jal	80000c8c <release>
}
    8000197a:	8526                	mv	a0,s1
    8000197c:	60e2                	ld	ra,24(sp)
    8000197e:	6442                	ld	s0,16(sp)
    80001980:	64a2                	ld	s1,8(sp)
    80001982:	6902                	ld	s2,0(sp)
    80001984:	6105                	addi	sp,sp,32
    80001986:	8082                	ret

0000000080001988 <proc_pagetable>:
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	e426                	sd	s1,8(sp)
    80001990:	e04a                	sd	s2,0(sp)
    80001992:	1000                	addi	s0,sp,32
    80001994:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001996:	8e1ff0ef          	jal	80001276 <uvmcreate>
    8000199a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000199c:	cd05                	beqz	a0,800019d4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000199e:	4729                	li	a4,10
    800019a0:	00004697          	auipc	a3,0x4
    800019a4:	66068693          	addi	a3,a3,1632 # 80006000 <_trampoline>
    800019a8:	6605                	lui	a2,0x1
    800019aa:	040005b7          	lui	a1,0x4000
    800019ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019b0:	05b2                	slli	a1,a1,0xc
    800019b2:	e62ff0ef          	jal	80001014 <mappages>
    800019b6:	02054663          	bltz	a0,800019e2 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019ba:	4719                	li	a4,6
    800019bc:	05893683          	ld	a3,88(s2)
    800019c0:	6605                	lui	a2,0x1
    800019c2:	020005b7          	lui	a1,0x2000
    800019c6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019c8:	05b6                	slli	a1,a1,0xd
    800019ca:	8526                	mv	a0,s1
    800019cc:	e48ff0ef          	jal	80001014 <mappages>
    800019d0:	00054f63          	bltz	a0,800019ee <proc_pagetable+0x66>
}
    800019d4:	8526                	mv	a0,s1
    800019d6:	60e2                	ld	ra,24(sp)
    800019d8:	6442                	ld	s0,16(sp)
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	6902                	ld	s2,0(sp)
    800019de:	6105                	addi	sp,sp,32
    800019e0:	8082                	ret
    uvmfree(pagetable, 0);
    800019e2:	4581                	li	a1,0
    800019e4:	8526                	mv	a0,s1
    800019e6:	a5fff0ef          	jal	80001444 <uvmfree>
    return 0;
    800019ea:	4481                	li	s1,0
    800019ec:	b7e5                	j	800019d4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800019ee:	4681                	li	a3,0
    800019f0:	4605                	li	a2,1
    800019f2:	040005b7          	lui	a1,0x4000
    800019f6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019f8:	05b2                	slli	a1,a1,0xc
    800019fa:	8526                	mv	a0,s1
    800019fc:	fbeff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a00:	4581                	li	a1,0
    80001a02:	8526                	mv	a0,s1
    80001a04:	a41ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a08:	4481                	li	s1,0
    80001a0a:	b7e9                	j	800019d4 <proc_pagetable+0x4c>

0000000080001a0c <proc_freepagetable>:
{
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
    80001a18:	84aa                	mv	s1,a0
    80001a1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a1c:	4681                	li	a3,0
    80001a1e:	4605                	li	a2,1
    80001a20:	040005b7          	lui	a1,0x4000
    80001a24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a26:	05b2                	slli	a1,a1,0xc
    80001a28:	f92ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a2c:	4681                	li	a3,0
    80001a2e:	4605                	li	a2,1
    80001a30:	020005b7          	lui	a1,0x2000
    80001a34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a36:	05b6                	slli	a1,a1,0xd
    80001a38:	8526                	mv	a0,s1
    80001a3a:	f80ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a3e:	85ca                	mv	a1,s2
    80001a40:	8526                	mv	a0,s1
    80001a42:	a03ff0ef          	jal	80001444 <uvmfree>
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret

0000000080001a52 <freeproc>:
{
    80001a52:	1101                	addi	sp,sp,-32
    80001a54:	ec06                	sd	ra,24(sp)
    80001a56:	e822                	sd	s0,16(sp)
    80001a58:	e426                	sd	s1,8(sp)
    80001a5a:	1000                	addi	s0,sp,32
    80001a5c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a5e:	6d28                	ld	a0,88(a0)
    80001a60:	c119                	beqz	a0,80001a66 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a62:	fe1fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001a66:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a6a:	68a8                	ld	a0,80(s1)
    80001a6c:	c501                	beqz	a0,80001a74 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a6e:	64ac                	ld	a1,72(s1)
    80001a70:	f9dff0ef          	jal	80001a0c <proc_freepagetable>
  p->pagetable = 0;
    80001a74:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a78:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a7c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001a80:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001a84:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a88:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001a8c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001a90:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001a94:	0004ac23          	sw	zero,24(s1)
}
    80001a98:	60e2                	ld	ra,24(sp)
    80001a9a:	6442                	ld	s0,16(sp)
    80001a9c:	64a2                	ld	s1,8(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret

0000000080001aa2 <allocproc>:
{
    80001aa2:	1101                	addi	sp,sp,-32
    80001aa4:	ec06                	sd	ra,24(sp)
    80001aa6:	e822                	sd	s0,16(sp)
    80001aa8:	e426                	sd	s1,8(sp)
    80001aaa:	e04a                	sd	s2,0(sp)
    80001aac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aae:	0000e497          	auipc	s1,0xe
    80001ab2:	3c248493          	addi	s1,s1,962 # 8000fe70 <proc>
    80001ab6:	00014917          	auipc	s2,0x14
    80001aba:	dba90913          	addi	s2,s2,-582 # 80015870 <tickslock>
    acquire(&p->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	934ff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001ac4:	4c9c                	lw	a5,24(s1)
    80001ac6:	cb91                	beqz	a5,80001ada <allocproc+0x38>
      release(&p->lock);
    80001ac8:	8526                	mv	a0,s1
    80001aca:	9c2ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ace:	16848493          	addi	s1,s1,360
    80001ad2:	ff2496e3          	bne	s1,s2,80001abe <allocproc+0x1c>
  return 0;
    80001ad6:	4481                	li	s1,0
    80001ad8:	a099                	j	80001b1e <allocproc+0x7c>
  p->pid = allocpid();
    80001ada:	e71ff0ef          	jal	8000194a <allocpid>
    80001ade:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ae0:	4785                	li	a5,1
    80001ae2:	cc9c                	sw	a5,24(s1)
p->tickets = 10; // Default tickets
    80001ae4:	47a9                	li	a5,10
    80001ae6:	d8dc                	sw	a5,52(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001ae8:	83cff0ef          	jal	80000b24 <kalloc>
    80001aec:	892a                	mv	s2,a0
    80001aee:	eca8                	sd	a0,88(s1)
    80001af0:	cd15                	beqz	a0,80001b2c <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001af2:	8526                	mv	a0,s1
    80001af4:	e95ff0ef          	jal	80001988 <proc_pagetable>
    80001af8:	892a                	mv	s2,a0
    80001afa:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001afc:	c121                	beqz	a0,80001b3c <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001afe:	07000613          	li	a2,112
    80001b02:	4581                	li	a1,0
    80001b04:	06048513          	addi	a0,s1,96
    80001b08:	9c0ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b0c:	00000797          	auipc	a5,0x0
    80001b10:	e0478793          	addi	a5,a5,-508 # 80001910 <forkret>
    80001b14:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b16:	60bc                	ld	a5,64(s1)
    80001b18:	6705                	lui	a4,0x1
    80001b1a:	97ba                	add	a5,a5,a4
    80001b1c:	f4bc                	sd	a5,104(s1)
}
    80001b1e:	8526                	mv	a0,s1
    80001b20:	60e2                	ld	ra,24(sp)
    80001b22:	6442                	ld	s0,16(sp)
    80001b24:	64a2                	ld	s1,8(sp)
    80001b26:	6902                	ld	s2,0(sp)
    80001b28:	6105                	addi	sp,sp,32
    80001b2a:	8082                	ret
    freeproc(p);
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	f25ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b32:	8526                	mv	a0,s1
    80001b34:	958ff0ef          	jal	80000c8c <release>
    return 0;
    80001b38:	84ca                	mv	s1,s2
    80001b3a:	b7d5                	j	80001b1e <allocproc+0x7c>
    freeproc(p);
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	f15ff0ef          	jal	80001a52 <freeproc>
    release(&p->lock);
    80001b42:	8526                	mv	a0,s1
    80001b44:	948ff0ef          	jal	80000c8c <release>
    return 0;
    80001b48:	84ca                	mv	s1,s2
    80001b4a:	bfd1                	j	80001b1e <allocproc+0x7c>

0000000080001b4c <userinit>:
{
    80001b4c:	1101                	addi	sp,sp,-32
    80001b4e:	ec06                	sd	ra,24(sp)
    80001b50:	e822                	sd	s0,16(sp)
    80001b52:	e426                	sd	s1,8(sp)
    80001b54:	1000                	addi	s0,sp,32
  p = allocproc();
    80001b56:	f4dff0ef          	jal	80001aa2 <allocproc>
    80001b5a:	84aa                	mv	s1,a0
  initproc = p;
    80001b5c:	00006797          	auipc	a5,0x6
    80001b60:	daa7b623          	sd	a0,-596(a5) # 80007908 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001b64:	03400613          	li	a2,52
    80001b68:	00006597          	auipc	a1,0x6
    80001b6c:	d3858593          	addi	a1,a1,-712 # 800078a0 <initcode>
    80001b70:	6928                	ld	a0,80(a0)
    80001b72:	f2aff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001b76:	6785                	lui	a5,0x1
    80001b78:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001b7a:	6cb8                	ld	a4,88(s1)
    80001b7c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001b80:	6cb8                	ld	a4,88(s1)
    80001b82:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001b84:	4641                	li	a2,16
    80001b86:	00005597          	auipc	a1,0x5
    80001b8a:	69a58593          	addi	a1,a1,1690 # 80007220 <etext+0x220>
    80001b8e:	15848513          	addi	a0,s1,344
    80001b92:	a74ff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001b96:	00005517          	auipc	a0,0x5
    80001b9a:	69a50513          	addi	a0,a0,1690 # 80007230 <etext+0x230>
    80001b9e:	615010ef          	jal	800039b2 <namei>
    80001ba2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001ba6:	478d                	li	a5,3
    80001ba8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001baa:	8526                	mv	a0,s1
    80001bac:	8e0ff0ef          	jal	80000c8c <release>
}
    80001bb0:	60e2                	ld	ra,24(sp)
    80001bb2:	6442                	ld	s0,16(sp)
    80001bb4:	64a2                	ld	s1,8(sp)
    80001bb6:	6105                	addi	sp,sp,32
    80001bb8:	8082                	ret

0000000080001bba <growproc>:
{
    80001bba:	1101                	addi	sp,sp,-32
    80001bbc:	ec06                	sd	ra,24(sp)
    80001bbe:	e822                	sd	s0,16(sp)
    80001bc0:	e426                	sd	s1,8(sp)
    80001bc2:	e04a                	sd	s2,0(sp)
    80001bc4:	1000                	addi	s0,sp,32
    80001bc6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001bc8:	d19ff0ef          	jal	800018e0 <myproc>
    80001bcc:	84aa                	mv	s1,a0
  sz = p->sz;
    80001bce:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001bd0:	01204c63          	bgtz	s2,80001be8 <growproc+0x2e>
  } else if(n < 0){
    80001bd4:	02094463          	bltz	s2,80001bfc <growproc+0x42>
  p->sz = sz;
    80001bd8:	e4ac                	sd	a1,72(s1)
  return 0;
    80001bda:	4501                	li	a0,0
}
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6902                	ld	s2,0(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001be8:	4691                	li	a3,4
    80001bea:	00b90633          	add	a2,s2,a1
    80001bee:	6928                	ld	a0,80(a0)
    80001bf0:	f4eff0ef          	jal	8000133e <uvmalloc>
    80001bf4:	85aa                	mv	a1,a0
    80001bf6:	f16d                	bnez	a0,80001bd8 <growproc+0x1e>
      return -1;
    80001bf8:	557d                	li	a0,-1
    80001bfa:	b7cd                	j	80001bdc <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001bfc:	00b90633          	add	a2,s2,a1
    80001c00:	6928                	ld	a0,80(a0)
    80001c02:	ef8ff0ef          	jal	800012fa <uvmdealloc>
    80001c06:	85aa                	mv	a1,a0
    80001c08:	bfc1                	j	80001bd8 <growproc+0x1e>

0000000080001c0a <fork>:
{
    80001c0a:	7139                	addi	sp,sp,-64
    80001c0c:	fc06                	sd	ra,56(sp)
    80001c0e:	f822                	sd	s0,48(sp)
    80001c10:	f04a                	sd	s2,32(sp)
    80001c12:	e456                	sd	s5,8(sp)
    80001c14:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c16:	ccbff0ef          	jal	800018e0 <myproc>
    80001c1a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c1c:	e87ff0ef          	jal	80001aa2 <allocproc>
    80001c20:	0e050a63          	beqz	a0,80001d14 <fork+0x10a>
    80001c24:	e852                	sd	s4,16(sp)
    80001c26:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c28:	048ab603          	ld	a2,72(s5)
    80001c2c:	692c                	ld	a1,80(a0)
    80001c2e:	050ab503          	ld	a0,80(s5)
    80001c32:	845ff0ef          	jal	80001476 <uvmcopy>
    80001c36:	04054a63          	bltz	a0,80001c8a <fork+0x80>
    80001c3a:	f426                	sd	s1,40(sp)
    80001c3c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001c3e:	048ab783          	ld	a5,72(s5)
    80001c42:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001c46:	058ab683          	ld	a3,88(s5)
    80001c4a:	87b6                	mv	a5,a3
    80001c4c:	058a3703          	ld	a4,88(s4)
    80001c50:	12068693          	addi	a3,a3,288
    80001c54:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c58:	6788                	ld	a0,8(a5)
    80001c5a:	6b8c                	ld	a1,16(a5)
    80001c5c:	6f90                	ld	a2,24(a5)
    80001c5e:	01073023          	sd	a6,0(a4)
    80001c62:	e708                	sd	a0,8(a4)
    80001c64:	eb0c                	sd	a1,16(a4)
    80001c66:	ef10                	sd	a2,24(a4)
    80001c68:	02078793          	addi	a5,a5,32
    80001c6c:	02070713          	addi	a4,a4,32
    80001c70:	fed792e3          	bne	a5,a3,80001c54 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001c74:	058a3783          	ld	a5,88(s4)
    80001c78:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001c7c:	0d0a8493          	addi	s1,s5,208
    80001c80:	0d0a0913          	addi	s2,s4,208
    80001c84:	150a8993          	addi	s3,s5,336
    80001c88:	a831                	j	80001ca4 <fork+0x9a>
    freeproc(np);
    80001c8a:	8552                	mv	a0,s4
    80001c8c:	dc7ff0ef          	jal	80001a52 <freeproc>
    release(&np->lock);
    80001c90:	8552                	mv	a0,s4
    80001c92:	ffbfe0ef          	jal	80000c8c <release>
    return -1;
    80001c96:	597d                	li	s2,-1
    80001c98:	6a42                	ld	s4,16(sp)
    80001c9a:	a0b5                	j	80001d06 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001c9c:	04a1                	addi	s1,s1,8
    80001c9e:	0921                	addi	s2,s2,8
    80001ca0:	01348963          	beq	s1,s3,80001cb2 <fork+0xa8>
    if(p->ofile[i])
    80001ca4:	6088                	ld	a0,0(s1)
    80001ca6:	d97d                	beqz	a0,80001c9c <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ca8:	29a020ef          	jal	80003f42 <filedup>
    80001cac:	00a93023          	sd	a0,0(s2)
    80001cb0:	b7f5                	j	80001c9c <fork+0x92>
  np->cwd = idup(p->cwd);
    80001cb2:	150ab503          	ld	a0,336(s5)
    80001cb6:	5ec010ef          	jal	800032a2 <idup>
    80001cba:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cbe:	4641                	li	a2,16
    80001cc0:	158a8593          	addi	a1,s5,344
    80001cc4:	158a0513          	addi	a0,s4,344
    80001cc8:	93eff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001ccc:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001cd0:	8552                	mv	a0,s4
    80001cd2:	fbbfe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001cd6:	0000e497          	auipc	s1,0xe
    80001cda:	d8248493          	addi	s1,s1,-638 # 8000fa58 <wait_lock>
    80001cde:	8526                	mv	a0,s1
    80001ce0:	f15fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80001ce4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001ce8:	8526                	mv	a0,s1
    80001cea:	fa3fe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001cee:	8552                	mv	a0,s4
    80001cf0:	f05fe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001cf4:	478d                	li	a5,3
    80001cf6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001cfa:	8552                	mv	a0,s4
    80001cfc:	f91fe0ef          	jal	80000c8c <release>
  return pid;
    80001d00:	74a2                	ld	s1,40(sp)
    80001d02:	69e2                	ld	s3,24(sp)
    80001d04:	6a42                	ld	s4,16(sp)
}
    80001d06:	854a                	mv	a0,s2
    80001d08:	70e2                	ld	ra,56(sp)
    80001d0a:	7442                	ld	s0,48(sp)
    80001d0c:	7902                	ld	s2,32(sp)
    80001d0e:	6aa2                	ld	s5,8(sp)
    80001d10:	6121                	addi	sp,sp,64
    80001d12:	8082                	ret
    return -1;
    80001d14:	597d                	li	s2,-1
    80001d16:	bfc5                	j	80001d06 <fork+0xfc>

0000000080001d18 <scheduler>:
{
    80001d18:	711d                	addi	sp,sp,-96
    80001d1a:	ec86                	sd	ra,88(sp)
    80001d1c:	e8a2                	sd	s0,80(sp)
    80001d1e:	e4a6                	sd	s1,72(sp)
    80001d20:	e0ca                	sd	s2,64(sp)
    80001d22:	fc4e                	sd	s3,56(sp)
    80001d24:	f852                	sd	s4,48(sp)
    80001d26:	f456                	sd	s5,40(sp)
    80001d28:	f05a                	sd	s6,32(sp)
    80001d2a:	ec5e                	sd	s7,24(sp)
    80001d2c:	e862                	sd	s8,16(sp)
    80001d2e:	e466                	sd	s9,8(sp)
    80001d30:	1080                	addi	s0,sp,96
    80001d32:	8792                	mv	a5,tp
  int id = r_tp();
    80001d34:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d36:	00779a93          	slli	s5,a5,0x7
    80001d3a:	0000e717          	auipc	a4,0xe
    80001d3e:	d0670713          	addi	a4,a4,-762 # 8000fa40 <pid_lock>
    80001d42:	9756                	add	a4,a4,s5
    80001d44:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &p->context);
    80001d48:	0000e717          	auipc	a4,0xe
    80001d4c:	d3070713          	addi	a4,a4,-720 # 8000fa78 <cpus+0x8>
    80001d50:	9aba                	add	s5,s5,a4
    if (scheduler_mode == 1) {
    80001d52:	00006b97          	auipc	s7,0x6
    80001d56:	bbeb8b93          	addi	s7,s7,-1090 # 80007910 <scheduler_mode>
    80001d5a:	4b05                	li	s6,1
          c->proc = p;
    80001d5c:	079e                	slli	a5,a5,0x7
    80001d5e:	0000ea17          	auipc	s4,0xe
    80001d62:	ce2a0a13          	addi	s4,s4,-798 # 8000fa40 <pid_lock>
    80001d66:	9a3e                	add	s4,s4,a5
      for (p = proc; p < &proc[NPROC]; p++) {
    80001d68:	00014917          	auipc	s2,0x14
    80001d6c:	b0890913          	addi	s2,s2,-1272 # 80015870 <tickslock>
    80001d70:	a025                	j	80001d98 <scheduler+0x80>
        release(&p->lock);
    80001d72:	8526                	mv	a0,s1
    80001d74:	f19fe0ef          	jal	80000c8c <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001d78:	16848493          	addi	s1,s1,360
    80001d7c:	01248c63          	beq	s1,s2,80001d94 <scheduler+0x7c>
        acquire(&p->lock);
    80001d80:	8526                	mv	a0,s1
    80001d82:	e73fe0ef          	jal	80000bf4 <acquire>
        if (p->state == RUNNABLE) {
    80001d86:	4c9c                	lw	a5,24(s1)
    80001d88:	ff3795e3          	bne	a5,s3,80001d72 <scheduler+0x5a>
          total_tickets += p->tickets;
    80001d8c:	58dc                	lw	a5,52(s1)
    80001d8e:	01878c3b          	addw	s8,a5,s8
    80001d92:	b7c5                	j	80001d72 <scheduler+0x5a>
      if (total_tickets == 0)
    80001d94:	020c1363          	bnez	s8,80001dba <scheduler+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d9c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da0:	10079073          	csrw	sstatus,a5
    if (scheduler_mode == 1) {
    80001da4:	000ba783          	lw	a5,0(s7)
    80001da8:	07679563          	bne	a5,s6,80001e12 <scheduler+0xfa>
      int total_tickets = 0;
    80001dac:	4c01                	li	s8,0
      for (p = proc; p < &proc[NPROC]; p++) {
    80001dae:	0000e497          	auipc	s1,0xe
    80001db2:	0c248493          	addi	s1,s1,194 # 8000fe70 <proc>
        if (p->state == RUNNABLE) {
    80001db6:	498d                	li	s3,3
    80001db8:	b7e1                	j	80001d80 <scheduler+0x68>
      int winning_ticket = random(total_tickets);
    80001dba:	8562                	mv	a0,s8
    80001dbc:	34f030ef          	jal	8000590a <random>
    80001dc0:	8caa                	mv	s9,a0
      int current_ticket_sum = 0;
    80001dc2:	4981                	li	s3,0
      for (p = proc; p < &proc[NPROC]; p++) {
    80001dc4:	0000e497          	auipc	s1,0xe
    80001dc8:	0ac48493          	addi	s1,s1,172 # 8000fe70 <proc>
        if (p->state == RUNNABLE) {
    80001dcc:	4c0d                	li	s8,3
    80001dce:	a801                	j	80001dde <scheduler+0xc6>
        release(&p->lock);
    80001dd0:	8526                	mv	a0,s1
    80001dd2:	ebbfe0ef          	jal	80000c8c <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001dd6:	16848493          	addi	s1,s1,360
    80001dda:	fb248fe3          	beq	s1,s2,80001d98 <scheduler+0x80>
        acquire(&p->lock);
    80001dde:	8526                	mv	a0,s1
    80001de0:	e15fe0ef          	jal	80000bf4 <acquire>
        if (p->state == RUNNABLE) {
    80001de4:	4c9c                	lw	a5,24(s1)
    80001de6:	ff8795e3          	bne	a5,s8,80001dd0 <scheduler+0xb8>
          current_ticket_sum += p->tickets;
    80001dea:	58dc                	lw	a5,52(s1)
    80001dec:	013789bb          	addw	s3,a5,s3
          if (current_ticket_sum > winning_ticket) {
    80001df0:	ff3cd0e3          	bge	s9,s3,80001dd0 <scheduler+0xb8>
            p->state = RUNNING;
    80001df4:	4791                	li	a5,4
    80001df6:	cc9c                	sw	a5,24(s1)
            c->proc = p;
    80001df8:	029a3823          	sd	s1,48(s4)
            swtch(&c->context, &p->context);
    80001dfc:	06048593          	addi	a1,s1,96
    80001e00:	8556                	mv	a0,s5
    80001e02:	5f8000ef          	jal	800023fa <swtch>
            c->proc = 0;
    80001e06:	020a3823          	sd	zero,48(s4)
            release(&p->lock);
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	e81fe0ef          	jal	80000c8c <release>
            break;
    80001e10:	b761                	j	80001d98 <scheduler+0x80>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001e12:	0000e497          	auipc	s1,0xe
    80001e16:	05e48493          	addi	s1,s1,94 # 8000fe70 <proc>
        if (p->state == RUNNABLE) {
    80001e1a:	498d                	li	s3,3
          p->state = RUNNING;
    80001e1c:	4c11                	li	s8,4
    80001e1e:	a801                	j	80001e2e <scheduler+0x116>
        release(&p->lock);
    80001e20:	8526                	mv	a0,s1
    80001e22:	e6bfe0ef          	jal	80000c8c <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001e26:	16848493          	addi	s1,s1,360
    80001e2a:	f72487e3          	beq	s1,s2,80001d98 <scheduler+0x80>
        acquire(&p->lock);
    80001e2e:	8526                	mv	a0,s1
    80001e30:	dc5fe0ef          	jal	80000bf4 <acquire>
        if (p->state == RUNNABLE) {
    80001e34:	4c9c                	lw	a5,24(s1)
    80001e36:	ff3795e3          	bne	a5,s3,80001e20 <scheduler+0x108>
          p->state = RUNNING;
    80001e3a:	0184ac23          	sw	s8,24(s1)
          c->proc = p;
    80001e3e:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &p->context);
    80001e42:	06048593          	addi	a1,s1,96
    80001e46:	8556                	mv	a0,s5
    80001e48:	5b2000ef          	jal	800023fa <swtch>
          c->proc = 0;
    80001e4c:	020a3823          	sd	zero,48(s4)
    80001e50:	bfc1                	j	80001e20 <scheduler+0x108>

0000000080001e52 <sched>:
{
    80001e52:	7179                	addi	sp,sp,-48
    80001e54:	f406                	sd	ra,40(sp)
    80001e56:	f022                	sd	s0,32(sp)
    80001e58:	ec26                	sd	s1,24(sp)
    80001e5a:	e84a                	sd	s2,16(sp)
    80001e5c:	e44e                	sd	s3,8(sp)
    80001e5e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e60:	a81ff0ef          	jal	800018e0 <myproc>
    80001e64:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e66:	d25fe0ef          	jal	80000b8a <holding>
    80001e6a:	c92d                	beqz	a0,80001edc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e6c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001e6e:	2781                	sext.w	a5,a5
    80001e70:	079e                	slli	a5,a5,0x7
    80001e72:	0000e717          	auipc	a4,0xe
    80001e76:	bce70713          	addi	a4,a4,-1074 # 8000fa40 <pid_lock>
    80001e7a:	97ba                	add	a5,a5,a4
    80001e7c:	0a87a703          	lw	a4,168(a5)
    80001e80:	4785                	li	a5,1
    80001e82:	06f71363          	bne	a4,a5,80001ee8 <sched+0x96>
  if(p->state == RUNNING)
    80001e86:	4c98                	lw	a4,24(s1)
    80001e88:	4791                	li	a5,4
    80001e8a:	06f70563          	beq	a4,a5,80001ef4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e92:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e94:	e7b5                	bnez	a5,80001f00 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e96:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e98:	0000e917          	auipc	s2,0xe
    80001e9c:	ba890913          	addi	s2,s2,-1112 # 8000fa40 <pid_lock>
    80001ea0:	2781                	sext.w	a5,a5
    80001ea2:	079e                	slli	a5,a5,0x7
    80001ea4:	97ca                	add	a5,a5,s2
    80001ea6:	0ac7a983          	lw	s3,172(a5)
    80001eaa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001eac:	2781                	sext.w	a5,a5
    80001eae:	079e                	slli	a5,a5,0x7
    80001eb0:	0000e597          	auipc	a1,0xe
    80001eb4:	bc858593          	addi	a1,a1,-1080 # 8000fa78 <cpus+0x8>
    80001eb8:	95be                	add	a1,a1,a5
    80001eba:	06048513          	addi	a0,s1,96
    80001ebe:	53c000ef          	jal	800023fa <swtch>
    80001ec2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ec4:	2781                	sext.w	a5,a5
    80001ec6:	079e                	slli	a5,a5,0x7
    80001ec8:	993e                	add	s2,s2,a5
    80001eca:	0b392623          	sw	s3,172(s2)
}
    80001ece:	70a2                	ld	ra,40(sp)
    80001ed0:	7402                	ld	s0,32(sp)
    80001ed2:	64e2                	ld	s1,24(sp)
    80001ed4:	6942                	ld	s2,16(sp)
    80001ed6:	69a2                	ld	s3,8(sp)
    80001ed8:	6145                	addi	sp,sp,48
    80001eda:	8082                	ret
    panic("sched p->lock");
    80001edc:	00005517          	auipc	a0,0x5
    80001ee0:	35c50513          	addi	a0,a0,860 # 80007238 <etext+0x238>
    80001ee4:	8b1fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	36050513          	addi	a0,a0,864 # 80007248 <etext+0x248>
    80001ef0:	8a5fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001ef4:	00005517          	auipc	a0,0x5
    80001ef8:	36450513          	addi	a0,a0,868 # 80007258 <etext+0x258>
    80001efc:	899fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001f00:	00005517          	auipc	a0,0x5
    80001f04:	36850513          	addi	a0,a0,872 # 80007268 <etext+0x268>
    80001f08:	88dfe0ef          	jal	80000794 <panic>

0000000080001f0c <yield>:
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f16:	9cbff0ef          	jal	800018e0 <myproc>
    80001f1a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f1c:	cd9fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001f20:	478d                	li	a5,3
    80001f22:	cc9c                	sw	a5,24(s1)
  sched();
    80001f24:	f2fff0ef          	jal	80001e52 <sched>
  release(&p->lock);
    80001f28:	8526                	mv	a0,s1
    80001f2a:	d63fe0ef          	jal	80000c8c <release>
}
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f38:	7179                	addi	sp,sp,-48
    80001f3a:	f406                	sd	ra,40(sp)
    80001f3c:	f022                	sd	s0,32(sp)
    80001f3e:	ec26                	sd	s1,24(sp)
    80001f40:	e84a                	sd	s2,16(sp)
    80001f42:	e44e                	sd	s3,8(sp)
    80001f44:	1800                	addi	s0,sp,48
    80001f46:	89aa                	mv	s3,a0
    80001f48:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f4a:	997ff0ef          	jal	800018e0 <myproc>
    80001f4e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f50:	ca5fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001f54:	854a                	mv	a0,s2
    80001f56:	d37fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001f5a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f5e:	4789                	li	a5,2
    80001f60:	cc9c                	sw	a5,24(s1)

  sched();
    80001f62:	ef1ff0ef          	jal	80001e52 <sched>

  // Tidy up.
  p->chan = 0;
    80001f66:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	d21fe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001f70:	854a                	mv	a0,s2
    80001f72:	c83fe0ef          	jal	80000bf4 <acquire>
}
    80001f76:	70a2                	ld	ra,40(sp)
    80001f78:	7402                	ld	s0,32(sp)
    80001f7a:	64e2                	ld	s1,24(sp)
    80001f7c:	6942                	ld	s2,16(sp)
    80001f7e:	69a2                	ld	s3,8(sp)
    80001f80:	6145                	addi	sp,sp,48
    80001f82:	8082                	ret

0000000080001f84 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001f84:	7139                	addi	sp,sp,-64
    80001f86:	fc06                	sd	ra,56(sp)
    80001f88:	f822                	sd	s0,48(sp)
    80001f8a:	f426                	sd	s1,40(sp)
    80001f8c:	f04a                	sd	s2,32(sp)
    80001f8e:	ec4e                	sd	s3,24(sp)
    80001f90:	e852                	sd	s4,16(sp)
    80001f92:	e456                	sd	s5,8(sp)
    80001f94:	0080                	addi	s0,sp,64
    80001f96:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001f98:	0000e497          	auipc	s1,0xe
    80001f9c:	ed848493          	addi	s1,s1,-296 # 8000fe70 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001fa0:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001fa2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fa4:	00014917          	auipc	s2,0x14
    80001fa8:	8cc90913          	addi	s2,s2,-1844 # 80015870 <tickslock>
    80001fac:	a801                	j	80001fbc <wakeup+0x38>
      }
      release(&p->lock);
    80001fae:	8526                	mv	a0,s1
    80001fb0:	cddfe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fb4:	16848493          	addi	s1,s1,360
    80001fb8:	03248263          	beq	s1,s2,80001fdc <wakeup+0x58>
    if(p != myproc()){
    80001fbc:	925ff0ef          	jal	800018e0 <myproc>
    80001fc0:	fea48ae3          	beq	s1,a0,80001fb4 <wakeup+0x30>
      acquire(&p->lock);
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	c2ffe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001fca:	4c9c                	lw	a5,24(s1)
    80001fcc:	ff3791e3          	bne	a5,s3,80001fae <wakeup+0x2a>
    80001fd0:	709c                	ld	a5,32(s1)
    80001fd2:	fd479ee3          	bne	a5,s4,80001fae <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fd6:	0154ac23          	sw	s5,24(s1)
    80001fda:	bfd1                	j	80001fae <wakeup+0x2a>
    }
  }
}
    80001fdc:	70e2                	ld	ra,56(sp)
    80001fde:	7442                	ld	s0,48(sp)
    80001fe0:	74a2                	ld	s1,40(sp)
    80001fe2:	7902                	ld	s2,32(sp)
    80001fe4:	69e2                	ld	s3,24(sp)
    80001fe6:	6a42                	ld	s4,16(sp)
    80001fe8:	6aa2                	ld	s5,8(sp)
    80001fea:	6121                	addi	sp,sp,64
    80001fec:	8082                	ret

0000000080001fee <reparent>:
{
    80001fee:	7179                	addi	sp,sp,-48
    80001ff0:	f406                	sd	ra,40(sp)
    80001ff2:	f022                	sd	s0,32(sp)
    80001ff4:	ec26                	sd	s1,24(sp)
    80001ff6:	e84a                	sd	s2,16(sp)
    80001ff8:	e44e                	sd	s3,8(sp)
    80001ffa:	e052                	sd	s4,0(sp)
    80001ffc:	1800                	addi	s0,sp,48
    80001ffe:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002000:	0000e497          	auipc	s1,0xe
    80002004:	e7048493          	addi	s1,s1,-400 # 8000fe70 <proc>
      pp->parent = initproc;
    80002008:	00006a17          	auipc	s4,0x6
    8000200c:	900a0a13          	addi	s4,s4,-1792 # 80007908 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002010:	00014997          	auipc	s3,0x14
    80002014:	86098993          	addi	s3,s3,-1952 # 80015870 <tickslock>
    80002018:	a029                	j	80002022 <reparent+0x34>
    8000201a:	16848493          	addi	s1,s1,360
    8000201e:	01348b63          	beq	s1,s3,80002034 <reparent+0x46>
    if(pp->parent == p){
    80002022:	7c9c                	ld	a5,56(s1)
    80002024:	ff279be3          	bne	a5,s2,8000201a <reparent+0x2c>
      pp->parent = initproc;
    80002028:	000a3503          	ld	a0,0(s4)
    8000202c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000202e:	f57ff0ef          	jal	80001f84 <wakeup>
    80002032:	b7e5                	j	8000201a <reparent+0x2c>
}
    80002034:	70a2                	ld	ra,40(sp)
    80002036:	7402                	ld	s0,32(sp)
    80002038:	64e2                	ld	s1,24(sp)
    8000203a:	6942                	ld	s2,16(sp)
    8000203c:	69a2                	ld	s3,8(sp)
    8000203e:	6a02                	ld	s4,0(sp)
    80002040:	6145                	addi	sp,sp,48
    80002042:	8082                	ret

0000000080002044 <exit>:
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	e052                	sd	s4,0(sp)
    80002052:	1800                	addi	s0,sp,48
    80002054:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002056:	88bff0ef          	jal	800018e0 <myproc>
    8000205a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000205c:	00006797          	auipc	a5,0x6
    80002060:	8ac7b783          	ld	a5,-1876(a5) # 80007908 <initproc>
    80002064:	0d050493          	addi	s1,a0,208
    80002068:	15050913          	addi	s2,a0,336
    8000206c:	00a79f63          	bne	a5,a0,8000208a <exit+0x46>
    panic("init exiting");
    80002070:	00005517          	auipc	a0,0x5
    80002074:	21050513          	addi	a0,a0,528 # 80007280 <etext+0x280>
    80002078:	f1cfe0ef          	jal	80000794 <panic>
      fileclose(f);
    8000207c:	70d010ef          	jal	80003f88 <fileclose>
      p->ofile[fd] = 0;
    80002080:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002084:	04a1                	addi	s1,s1,8
    80002086:	01248563          	beq	s1,s2,80002090 <exit+0x4c>
    if(p->ofile[fd]){
    8000208a:	6088                	ld	a0,0(s1)
    8000208c:	f965                	bnez	a0,8000207c <exit+0x38>
    8000208e:	bfdd                	j	80002084 <exit+0x40>
  begin_op();
    80002090:	2df010ef          	jal	80003b6e <begin_op>
  iput(p->cwd);
    80002094:	1509b503          	ld	a0,336(s3)
    80002098:	3c2010ef          	jal	8000345a <iput>
  end_op();
    8000209c:	33d010ef          	jal	80003bd8 <end_op>
  p->cwd = 0;
    800020a0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020a4:	0000e497          	auipc	s1,0xe
    800020a8:	9b448493          	addi	s1,s1,-1612 # 8000fa58 <wait_lock>
    800020ac:	8526                	mv	a0,s1
    800020ae:	b47fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    800020b2:	854e                	mv	a0,s3
    800020b4:	f3bff0ef          	jal	80001fee <reparent>
  wakeup(p->parent);
    800020b8:	0389b503          	ld	a0,56(s3)
    800020bc:	ec9ff0ef          	jal	80001f84 <wakeup>
  acquire(&p->lock);
    800020c0:	854e                	mv	a0,s3
    800020c2:	b33fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    800020c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020ca:	4795                	li	a5,5
    800020cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020d0:	8526                	mv	a0,s1
    800020d2:	bbbfe0ef          	jal	80000c8c <release>
  sched();
    800020d6:	d7dff0ef          	jal	80001e52 <sched>
  panic("zombie exit");
    800020da:	00005517          	auipc	a0,0x5
    800020de:	1b650513          	addi	a0,a0,438 # 80007290 <etext+0x290>
    800020e2:	eb2fe0ef          	jal	80000794 <panic>

00000000800020e6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800020e6:	7179                	addi	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	e84a                	sd	s2,16(sp)
    800020f0:	e44e                	sd	s3,8(sp)
    800020f2:	1800                	addi	s0,sp,48
    800020f4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800020f6:	0000e497          	auipc	s1,0xe
    800020fa:	d7a48493          	addi	s1,s1,-646 # 8000fe70 <proc>
    800020fe:	00013997          	auipc	s3,0x13
    80002102:	77298993          	addi	s3,s3,1906 # 80015870 <tickslock>
    acquire(&p->lock);
    80002106:	8526                	mv	a0,s1
    80002108:	aedfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    8000210c:	589c                	lw	a5,48(s1)
    8000210e:	01278b63          	beq	a5,s2,80002124 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	b79fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002118:	16848493          	addi	s1,s1,360
    8000211c:	ff3495e3          	bne	s1,s3,80002106 <kill+0x20>
  }
  return -1;
    80002120:	557d                	li	a0,-1
    80002122:	a819                	j	80002138 <kill+0x52>
      p->killed = 1;
    80002124:	4785                	li	a5,1
    80002126:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002128:	4c98                	lw	a4,24(s1)
    8000212a:	4789                	li	a5,2
    8000212c:	00f70d63          	beq	a4,a5,80002146 <kill+0x60>
      release(&p->lock);
    80002130:	8526                	mv	a0,s1
    80002132:	b5bfe0ef          	jal	80000c8c <release>
      return 0;
    80002136:	4501                	li	a0,0
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6145                	addi	sp,sp,48
    80002144:	8082                	ret
        p->state = RUNNABLE;
    80002146:	478d                	li	a5,3
    80002148:	cc9c                	sw	a5,24(s1)
    8000214a:	b7dd                	j	80002130 <kill+0x4a>

000000008000214c <setkilled>:

void
setkilled(struct proc *p)
{
    8000214c:	1101                	addi	sp,sp,-32
    8000214e:	ec06                	sd	ra,24(sp)
    80002150:	e822                	sd	s0,16(sp)
    80002152:	e426                	sd	s1,8(sp)
    80002154:	1000                	addi	s0,sp,32
    80002156:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002158:	a9dfe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    8000215c:	4785                	li	a5,1
    8000215e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	b2bfe0ef          	jal	80000c8c <release>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <killed>:

int
killed(struct proc *p)
{
    80002170:	1101                	addi	sp,sp,-32
    80002172:	ec06                	sd	ra,24(sp)
    80002174:	e822                	sd	s0,16(sp)
    80002176:	e426                	sd	s1,8(sp)
    80002178:	e04a                	sd	s2,0(sp)
    8000217a:	1000                	addi	s0,sp,32
    8000217c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000217e:	a77fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80002182:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002186:	8526                	mv	a0,s1
    80002188:	b05fe0ef          	jal	80000c8c <release>
  return k;
}
    8000218c:	854a                	mv	a0,s2
    8000218e:	60e2                	ld	ra,24(sp)
    80002190:	6442                	ld	s0,16(sp)
    80002192:	64a2                	ld	s1,8(sp)
    80002194:	6902                	ld	s2,0(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <wait>:
{
    8000219a:	715d                	addi	sp,sp,-80
    8000219c:	e486                	sd	ra,72(sp)
    8000219e:	e0a2                	sd	s0,64(sp)
    800021a0:	fc26                	sd	s1,56(sp)
    800021a2:	f84a                	sd	s2,48(sp)
    800021a4:	f44e                	sd	s3,40(sp)
    800021a6:	f052                	sd	s4,32(sp)
    800021a8:	ec56                	sd	s5,24(sp)
    800021aa:	e85a                	sd	s6,16(sp)
    800021ac:	e45e                	sd	s7,8(sp)
    800021ae:	e062                	sd	s8,0(sp)
    800021b0:	0880                	addi	s0,sp,80
    800021b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800021b4:	f2cff0ef          	jal	800018e0 <myproc>
    800021b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021ba:	0000e517          	auipc	a0,0xe
    800021be:	89e50513          	addi	a0,a0,-1890 # 8000fa58 <wait_lock>
    800021c2:	a33fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    800021c6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800021c8:	4a15                	li	s4,5
        havekids = 1;
    800021ca:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800021cc:	00013997          	auipc	s3,0x13
    800021d0:	6a498993          	addi	s3,s3,1700 # 80015870 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021d4:	0000ec17          	auipc	s8,0xe
    800021d8:	884c0c13          	addi	s8,s8,-1916 # 8000fa58 <wait_lock>
    800021dc:	a871                	j	80002278 <wait+0xde>
          pid = pp->pid;
    800021de:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021e2:	000b0c63          	beqz	s6,800021fa <wait+0x60>
    800021e6:	4691                	li	a3,4
    800021e8:	02c48613          	addi	a2,s1,44
    800021ec:	85da                	mv	a1,s6
    800021ee:	05093503          	ld	a0,80(s2)
    800021f2:	b60ff0ef          	jal	80001552 <copyout>
    800021f6:	02054b63          	bltz	a0,8000222c <wait+0x92>
          freeproc(pp);
    800021fa:	8526                	mv	a0,s1
    800021fc:	857ff0ef          	jal	80001a52 <freeproc>
          release(&pp->lock);
    80002200:	8526                	mv	a0,s1
    80002202:	a8bfe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80002206:	0000e517          	auipc	a0,0xe
    8000220a:	85250513          	addi	a0,a0,-1966 # 8000fa58 <wait_lock>
    8000220e:	a7ffe0ef          	jal	80000c8c <release>
}
    80002212:	854e                	mv	a0,s3
    80002214:	60a6                	ld	ra,72(sp)
    80002216:	6406                	ld	s0,64(sp)
    80002218:	74e2                	ld	s1,56(sp)
    8000221a:	7942                	ld	s2,48(sp)
    8000221c:	79a2                	ld	s3,40(sp)
    8000221e:	7a02                	ld	s4,32(sp)
    80002220:	6ae2                	ld	s5,24(sp)
    80002222:	6b42                	ld	s6,16(sp)
    80002224:	6ba2                	ld	s7,8(sp)
    80002226:	6c02                	ld	s8,0(sp)
    80002228:	6161                	addi	sp,sp,80
    8000222a:	8082                	ret
            release(&pp->lock);
    8000222c:	8526                	mv	a0,s1
    8000222e:	a5ffe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80002232:	0000e517          	auipc	a0,0xe
    80002236:	82650513          	addi	a0,a0,-2010 # 8000fa58 <wait_lock>
    8000223a:	a53fe0ef          	jal	80000c8c <release>
            return -1;
    8000223e:	59fd                	li	s3,-1
    80002240:	bfc9                	j	80002212 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002242:	16848493          	addi	s1,s1,360
    80002246:	03348063          	beq	s1,s3,80002266 <wait+0xcc>
      if(pp->parent == p){
    8000224a:	7c9c                	ld	a5,56(s1)
    8000224c:	ff279be3          	bne	a5,s2,80002242 <wait+0xa8>
        acquire(&pp->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	9a3fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80002256:	4c9c                	lw	a5,24(s1)
    80002258:	f94783e3          	beq	a5,s4,800021de <wait+0x44>
        release(&pp->lock);
    8000225c:	8526                	mv	a0,s1
    8000225e:	a2ffe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002262:	8756                	mv	a4,s5
    80002264:	bff9                	j	80002242 <wait+0xa8>
    if(!havekids || killed(p)){
    80002266:	cf19                	beqz	a4,80002284 <wait+0xea>
    80002268:	854a                	mv	a0,s2
    8000226a:	f07ff0ef          	jal	80002170 <killed>
    8000226e:	e919                	bnez	a0,80002284 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002270:	85e2                	mv	a1,s8
    80002272:	854a                	mv	a0,s2
    80002274:	cc5ff0ef          	jal	80001f38 <sleep>
    havekids = 0;
    80002278:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000227a:	0000e497          	auipc	s1,0xe
    8000227e:	bf648493          	addi	s1,s1,-1034 # 8000fe70 <proc>
    80002282:	b7e1                	j	8000224a <wait+0xb0>
      release(&wait_lock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	7d450513          	addi	a0,a0,2004 # 8000fa58 <wait_lock>
    8000228c:	a01fe0ef          	jal	80000c8c <release>
      return -1;
    80002290:	59fd                	li	s3,-1
    80002292:	b741                	j	80002212 <wait+0x78>

0000000080002294 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002294:	7179                	addi	sp,sp,-48
    80002296:	f406                	sd	ra,40(sp)
    80002298:	f022                	sd	s0,32(sp)
    8000229a:	ec26                	sd	s1,24(sp)
    8000229c:	e84a                	sd	s2,16(sp)
    8000229e:	e44e                	sd	s3,8(sp)
    800022a0:	e052                	sd	s4,0(sp)
    800022a2:	1800                	addi	s0,sp,48
    800022a4:	84aa                	mv	s1,a0
    800022a6:	892e                	mv	s2,a1
    800022a8:	89b2                	mv	s3,a2
    800022aa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022ac:	e34ff0ef          	jal	800018e0 <myproc>
  if(user_dst){
    800022b0:	cc99                	beqz	s1,800022ce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022b2:	86d2                	mv	a3,s4
    800022b4:	864e                	mv	a2,s3
    800022b6:	85ca                	mv	a1,s2
    800022b8:	6928                	ld	a0,80(a0)
    800022ba:	a98ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022be:	70a2                	ld	ra,40(sp)
    800022c0:	7402                	ld	s0,32(sp)
    800022c2:	64e2                	ld	s1,24(sp)
    800022c4:	6942                	ld	s2,16(sp)
    800022c6:	69a2                	ld	s3,8(sp)
    800022c8:	6a02                	ld	s4,0(sp)
    800022ca:	6145                	addi	sp,sp,48
    800022cc:	8082                	ret
    memmove((char *)dst, src, len);
    800022ce:	000a061b          	sext.w	a2,s4
    800022d2:	85ce                	mv	a1,s3
    800022d4:	854a                	mv	a0,s2
    800022d6:	a4ffe0ef          	jal	80000d24 <memmove>
    return 0;
    800022da:	8526                	mv	a0,s1
    800022dc:	b7cd                	j	800022be <either_copyout+0x2a>

00000000800022de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022de:	7179                	addi	sp,sp,-48
    800022e0:	f406                	sd	ra,40(sp)
    800022e2:	f022                	sd	s0,32(sp)
    800022e4:	ec26                	sd	s1,24(sp)
    800022e6:	e84a                	sd	s2,16(sp)
    800022e8:	e44e                	sd	s3,8(sp)
    800022ea:	e052                	sd	s4,0(sp)
    800022ec:	1800                	addi	s0,sp,48
    800022ee:	892a                	mv	s2,a0
    800022f0:	84ae                	mv	s1,a1
    800022f2:	89b2                	mv	s3,a2
    800022f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022f6:	deaff0ef          	jal	800018e0 <myproc>
  if(user_src){
    800022fa:	cc99                	beqz	s1,80002318 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022fc:	86d2                	mv	a3,s4
    800022fe:	864e                	mv	a2,s3
    80002300:	85ca                	mv	a1,s2
    80002302:	6928                	ld	a0,80(a0)
    80002304:	b24ff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002308:	70a2                	ld	ra,40(sp)
    8000230a:	7402                	ld	s0,32(sp)
    8000230c:	64e2                	ld	s1,24(sp)
    8000230e:	6942                	ld	s2,16(sp)
    80002310:	69a2                	ld	s3,8(sp)
    80002312:	6a02                	ld	s4,0(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret
    memmove(dst, (char*)src, len);
    80002318:	000a061b          	sext.w	a2,s4
    8000231c:	85ce                	mv	a1,s3
    8000231e:	854a                	mv	a0,s2
    80002320:	a05fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002324:	8526                	mv	a0,s1
    80002326:	b7cd                	j	80002308 <either_copyin+0x2a>

0000000080002328 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002328:	715d                	addi	sp,sp,-80
    8000232a:	e486                	sd	ra,72(sp)
    8000232c:	e0a2                	sd	s0,64(sp)
    8000232e:	fc26                	sd	s1,56(sp)
    80002330:	f84a                	sd	s2,48(sp)
    80002332:	f44e                	sd	s3,40(sp)
    80002334:	f052                	sd	s4,32(sp)
    80002336:	ec56                	sd	s5,24(sp)
    80002338:	e85a                	sd	s6,16(sp)
    8000233a:	e45e                	sd	s7,8(sp)
    8000233c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000233e:	00005517          	auipc	a0,0x5
    80002342:	d3a50513          	addi	a0,a0,-710 # 80007078 <etext+0x78>
    80002346:	97cfe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000234a:	0000e497          	auipc	s1,0xe
    8000234e:	c7e48493          	addi	s1,s1,-898 # 8000ffc8 <proc+0x158>
    80002352:	00013917          	auipc	s2,0x13
    80002356:	67690913          	addi	s2,s2,1654 # 800159c8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000235a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000235c:	00005997          	auipc	s3,0x5
    80002360:	f4498993          	addi	s3,s3,-188 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80002364:	00005a97          	auipc	s5,0x5
    80002368:	f44a8a93          	addi	s5,s5,-188 # 800072a8 <etext+0x2a8>
    printf("\n");
    8000236c:	00005a17          	auipc	s4,0x5
    80002370:	d0ca0a13          	addi	s4,s4,-756 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002374:	00005b97          	auipc	s7,0x5
    80002378:	414b8b93          	addi	s7,s7,1044 # 80007788 <states.0>
    8000237c:	a829                	j	80002396 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000237e:	ed86a583          	lw	a1,-296(a3)
    80002382:	8556                	mv	a0,s5
    80002384:	93efe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002388:	8552                	mv	a0,s4
    8000238a:	938fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000238e:	16848493          	addi	s1,s1,360
    80002392:	03248263          	beq	s1,s2,800023b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80002396:	86a6                	mv	a3,s1
    80002398:	ec04a783          	lw	a5,-320(s1)
    8000239c:	dbed                	beqz	a5,8000238e <procdump+0x66>
      state = "???";
    8000239e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023a0:	fcfb6fe3          	bltu	s6,a5,8000237e <procdump+0x56>
    800023a4:	02079713          	slli	a4,a5,0x20
    800023a8:	01d75793          	srli	a5,a4,0x1d
    800023ac:	97de                	add	a5,a5,s7
    800023ae:	6390                	ld	a2,0(a5)
    800023b0:	f679                	bnez	a2,8000237e <procdump+0x56>
      state = "???";
    800023b2:	864e                	mv	a2,s3
    800023b4:	b7e9                	j	8000237e <procdump+0x56>
  }
}
    800023b6:	60a6                	ld	ra,72(sp)
    800023b8:	6406                	ld	s0,64(sp)
    800023ba:	74e2                	ld	s1,56(sp)
    800023bc:	7942                	ld	s2,48(sp)
    800023be:	79a2                	ld	s3,40(sp)
    800023c0:	7a02                	ld	s4,32(sp)
    800023c2:	6ae2                	ld	s5,24(sp)
    800023c4:	6b42                	ld	s6,16(sp)
    800023c6:	6ba2                	ld	s7,8(sp)
    800023c8:	6161                	addi	sp,sp,80
    800023ca:	8082                	ret

00000000800023cc <settickets>:

void
settickets(int n)
{
    800023cc:	1101                	addi	sp,sp,-32
    800023ce:	ec06                	sd	ra,24(sp)
    800023d0:	e822                	sd	s0,16(sp)
    800023d2:	e426                	sd	s1,8(sp)
    800023d4:	e04a                	sd	s2,0(sp)
    800023d6:	1000                	addi	s0,sp,32
    800023d8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800023da:	d06ff0ef          	jal	800018e0 <myproc>
    800023de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023e0:	815fe0ef          	jal	80000bf4 <acquire>
  p->tickets = n;
    800023e4:	0324aa23          	sw	s2,52(s1)
  release(&p->lock);
    800023e8:	8526                	mv	a0,s1
    800023ea:	8a3fe0ef          	jal	80000c8c <release>
}
    800023ee:	60e2                	ld	ra,24(sp)
    800023f0:	6442                	ld	s0,16(sp)
    800023f2:	64a2                	ld	s1,8(sp)
    800023f4:	6902                	ld	s2,0(sp)
    800023f6:	6105                	addi	sp,sp,32
    800023f8:	8082                	ret

00000000800023fa <swtch>:
    800023fa:	00153023          	sd	ra,0(a0)
    800023fe:	00253423          	sd	sp,8(a0)
    80002402:	e900                	sd	s0,16(a0)
    80002404:	ed04                	sd	s1,24(a0)
    80002406:	03253023          	sd	s2,32(a0)
    8000240a:	03353423          	sd	s3,40(a0)
    8000240e:	03453823          	sd	s4,48(a0)
    80002412:	03553c23          	sd	s5,56(a0)
    80002416:	05653023          	sd	s6,64(a0)
    8000241a:	05753423          	sd	s7,72(a0)
    8000241e:	05853823          	sd	s8,80(a0)
    80002422:	05953c23          	sd	s9,88(a0)
    80002426:	07a53023          	sd	s10,96(a0)
    8000242a:	07b53423          	sd	s11,104(a0)
    8000242e:	0005b083          	ld	ra,0(a1)
    80002432:	0085b103          	ld	sp,8(a1)
    80002436:	6980                	ld	s0,16(a1)
    80002438:	6d84                	ld	s1,24(a1)
    8000243a:	0205b903          	ld	s2,32(a1)
    8000243e:	0285b983          	ld	s3,40(a1)
    80002442:	0305ba03          	ld	s4,48(a1)
    80002446:	0385ba83          	ld	s5,56(a1)
    8000244a:	0405bb03          	ld	s6,64(a1)
    8000244e:	0485bb83          	ld	s7,72(a1)
    80002452:	0505bc03          	ld	s8,80(a1)
    80002456:	0585bc83          	ld	s9,88(a1)
    8000245a:	0605bd03          	ld	s10,96(a1)
    8000245e:	0685bd83          	ld	s11,104(a1)
    80002462:	8082                	ret

0000000080002464 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002464:	1141                	addi	sp,sp,-16
    80002466:	e406                	sd	ra,8(sp)
    80002468:	e022                	sd	s0,0(sp)
    8000246a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000246c:	00005597          	auipc	a1,0x5
    80002470:	e7c58593          	addi	a1,a1,-388 # 800072e8 <etext+0x2e8>
    80002474:	00013517          	auipc	a0,0x13
    80002478:	3fc50513          	addi	a0,a0,1020 # 80015870 <tickslock>
    8000247c:	ef8fe0ef          	jal	80000b74 <initlock>
}
    80002480:	60a2                	ld	ra,8(sp)
    80002482:	6402                	ld	s0,0(sp)
    80002484:	0141                	addi	sp,sp,16
    80002486:	8082                	ret

0000000080002488 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002488:	1141                	addi	sp,sp,-16
    8000248a:	e422                	sd	s0,8(sp)
    8000248c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000248e:	00003797          	auipc	a5,0x3
    80002492:	e6278793          	addi	a5,a5,-414 # 800052f0 <kernelvec>
    80002496:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000249a:	6422                	ld	s0,8(sp)
    8000249c:	0141                	addi	sp,sp,16
    8000249e:	8082                	ret

00000000800024a0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800024a0:	1141                	addi	sp,sp,-16
    800024a2:	e406                	sd	ra,8(sp)
    800024a4:	e022                	sd	s0,0(sp)
    800024a6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800024a8:	c38ff0ef          	jal	800018e0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800024b0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024b2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800024b6:	00004697          	auipc	a3,0x4
    800024ba:	b4a68693          	addi	a3,a3,-1206 # 80006000 <_trampoline>
    800024be:	00004717          	auipc	a4,0x4
    800024c2:	b4270713          	addi	a4,a4,-1214 # 80006000 <_trampoline>
    800024c6:	8f15                	sub	a4,a4,a3
    800024c8:	040007b7          	lui	a5,0x4000
    800024cc:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800024ce:	07b2                	slli	a5,a5,0xc
    800024d0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024d2:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024d6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024d8:	18002673          	csrr	a2,satp
    800024dc:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024de:	6d30                	ld	a2,88(a0)
    800024e0:	6138                	ld	a4,64(a0)
    800024e2:	6585                	lui	a1,0x1
    800024e4:	972e                	add	a4,a4,a1
    800024e6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024e8:	6d38                	ld	a4,88(a0)
    800024ea:	00000617          	auipc	a2,0x0
    800024ee:	11060613          	addi	a2,a2,272 # 800025fa <usertrap>
    800024f2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800024f4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024f6:	8612                	mv	a2,tp
    800024f8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024fa:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024fe:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002502:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002506:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000250a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000250c:	6f18                	ld	a4,24(a4)
    8000250e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002512:	6928                	ld	a0,80(a0)
    80002514:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002516:	00004717          	auipc	a4,0x4
    8000251a:	b8670713          	addi	a4,a4,-1146 # 8000609c <userret>
    8000251e:	8f15                	sub	a4,a4,a3
    80002520:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002522:	577d                	li	a4,-1
    80002524:	177e                	slli	a4,a4,0x3f
    80002526:	8d59                	or	a0,a0,a4
    80002528:	9782                	jalr	a5
}
    8000252a:	60a2                	ld	ra,8(sp)
    8000252c:	6402                	ld	s0,0(sp)
    8000252e:	0141                	addi	sp,sp,16
    80002530:	8082                	ret

0000000080002532 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002532:	1101                	addi	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000253a:	b7aff0ef          	jal	800018b4 <cpuid>
    8000253e:	cd11                	beqz	a0,8000255a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002540:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002544:	000f4737          	lui	a4,0xf4
    80002548:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000254c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000254e:	14d79073          	csrw	stimecmp,a5
}
    80002552:	60e2                	ld	ra,24(sp)
    80002554:	6442                	ld	s0,16(sp)
    80002556:	6105                	addi	sp,sp,32
    80002558:	8082                	ret
    8000255a:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000255c:	00013497          	auipc	s1,0x13
    80002560:	31448493          	addi	s1,s1,788 # 80015870 <tickslock>
    80002564:	8526                	mv	a0,s1
    80002566:	e8efe0ef          	jal	80000bf4 <acquire>
    ticks++;
    8000256a:	00005517          	auipc	a0,0x5
    8000256e:	3aa50513          	addi	a0,a0,938 # 80007914 <ticks>
    80002572:	411c                	lw	a5,0(a0)
    80002574:	2785                	addiw	a5,a5,1
    80002576:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002578:	a0dff0ef          	jal	80001f84 <wakeup>
    release(&tickslock);
    8000257c:	8526                	mv	a0,s1
    8000257e:	f0efe0ef          	jal	80000c8c <release>
    80002582:	64a2                	ld	s1,8(sp)
    80002584:	bf75                	j	80002540 <clockintr+0xe>

0000000080002586 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002586:	1101                	addi	sp,sp,-32
    80002588:	ec06                	sd	ra,24(sp)
    8000258a:	e822                	sd	s0,16(sp)
    8000258c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000258e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002592:	57fd                	li	a5,-1
    80002594:	17fe                	slli	a5,a5,0x3f
    80002596:	07a5                	addi	a5,a5,9
    80002598:	00f70c63          	beq	a4,a5,800025b0 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000259c:	57fd                	li	a5,-1
    8000259e:	17fe                	slli	a5,a5,0x3f
    800025a0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800025a2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800025a4:	04f70763          	beq	a4,a5,800025f2 <devintr+0x6c>
  }
}
    800025a8:	60e2                	ld	ra,24(sp)
    800025aa:	6442                	ld	s0,16(sp)
    800025ac:	6105                	addi	sp,sp,32
    800025ae:	8082                	ret
    800025b0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800025b2:	5eb020ef          	jal	8000539c <plic_claim>
    800025b6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025b8:	47a9                	li	a5,10
    800025ba:	00f50963          	beq	a0,a5,800025cc <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800025be:	4785                	li	a5,1
    800025c0:	00f50963          	beq	a0,a5,800025d2 <devintr+0x4c>
    return 1;
    800025c4:	4505                	li	a0,1
    } else if(irq){
    800025c6:	e889                	bnez	s1,800025d8 <devintr+0x52>
    800025c8:	64a2                	ld	s1,8(sp)
    800025ca:	bff9                	j	800025a8 <devintr+0x22>
      uartintr();
    800025cc:	c3afe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800025d0:	a819                	j	800025e6 <devintr+0x60>
      virtio_disk_intr();
    800025d2:	290030ef          	jal	80005862 <virtio_disk_intr>
    if(irq)
    800025d6:	a801                	j	800025e6 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800025d8:	85a6                	mv	a1,s1
    800025da:	00005517          	auipc	a0,0x5
    800025de:	d1650513          	addi	a0,a0,-746 # 800072f0 <etext+0x2f0>
    800025e2:	ee1fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800025e6:	8526                	mv	a0,s1
    800025e8:	5d5020ef          	jal	800053bc <plic_complete>
    return 1;
    800025ec:	4505                	li	a0,1
    800025ee:	64a2                	ld	s1,8(sp)
    800025f0:	bf65                	j	800025a8 <devintr+0x22>
    clockintr();
    800025f2:	f41ff0ef          	jal	80002532 <clockintr>
    return 2;
    800025f6:	4509                	li	a0,2
    800025f8:	bf45                	j	800025a8 <devintr+0x22>

00000000800025fa <usertrap>:
{
    800025fa:	1101                	addi	sp,sp,-32
    800025fc:	ec06                	sd	ra,24(sp)
    800025fe:	e822                	sd	s0,16(sp)
    80002600:	e426                	sd	s1,8(sp)
    80002602:	e04a                	sd	s2,0(sp)
    80002604:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002606:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000260a:	1007f793          	andi	a5,a5,256
    8000260e:	ef85                	bnez	a5,80002646 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002610:	00003797          	auipc	a5,0x3
    80002614:	ce078793          	addi	a5,a5,-800 # 800052f0 <kernelvec>
    80002618:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000261c:	ac4ff0ef          	jal	800018e0 <myproc>
    80002620:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002622:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002624:	14102773          	csrr	a4,sepc
    80002628:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000262a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000262e:	47a1                	li	a5,8
    80002630:	02f70163          	beq	a4,a5,80002652 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002634:	f53ff0ef          	jal	80002586 <devintr>
    80002638:	892a                	mv	s2,a0
    8000263a:	c135                	beqz	a0,8000269e <usertrap+0xa4>
  if(killed(p))
    8000263c:	8526                	mv	a0,s1
    8000263e:	b33ff0ef          	jal	80002170 <killed>
    80002642:	cd1d                	beqz	a0,80002680 <usertrap+0x86>
    80002644:	a81d                	j	8000267a <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002646:	00005517          	auipc	a0,0x5
    8000264a:	cca50513          	addi	a0,a0,-822 # 80007310 <etext+0x310>
    8000264e:	946fe0ef          	jal	80000794 <panic>
    if(killed(p))
    80002652:	b1fff0ef          	jal	80002170 <killed>
    80002656:	e121                	bnez	a0,80002696 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002658:	6cb8                	ld	a4,88(s1)
    8000265a:	6f1c                	ld	a5,24(a4)
    8000265c:	0791                	addi	a5,a5,4
    8000265e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002660:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002664:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002668:	10079073          	csrw	sstatus,a5
    syscall();
    8000266c:	248000ef          	jal	800028b4 <syscall>
  if(killed(p))
    80002670:	8526                	mv	a0,s1
    80002672:	affff0ef          	jal	80002170 <killed>
    80002676:	c901                	beqz	a0,80002686 <usertrap+0x8c>
    80002678:	4901                	li	s2,0
    exit(-1);
    8000267a:	557d                	li	a0,-1
    8000267c:	9c9ff0ef          	jal	80002044 <exit>
  if(which_dev == 2)
    80002680:	4789                	li	a5,2
    80002682:	04f90563          	beq	s2,a5,800026cc <usertrap+0xd2>
  usertrapret();
    80002686:	e1bff0ef          	jal	800024a0 <usertrapret>
}
    8000268a:	60e2                	ld	ra,24(sp)
    8000268c:	6442                	ld	s0,16(sp)
    8000268e:	64a2                	ld	s1,8(sp)
    80002690:	6902                	ld	s2,0(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret
      exit(-1);
    80002696:	557d                	li	a0,-1
    80002698:	9adff0ef          	jal	80002044 <exit>
    8000269c:	bf75                	j	80002658 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000269e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800026a2:	5890                	lw	a2,48(s1)
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	c8c50513          	addi	a0,a0,-884 # 80007330 <etext+0x330>
    800026ac:	e17fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026b0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026b4:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800026b8:	00005517          	auipc	a0,0x5
    800026bc:	ca850513          	addi	a0,a0,-856 # 80007360 <etext+0x360>
    800026c0:	e03fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    800026c4:	8526                	mv	a0,s1
    800026c6:	a87ff0ef          	jal	8000214c <setkilled>
    800026ca:	b75d                	j	80002670 <usertrap+0x76>
    yield();
    800026cc:	841ff0ef          	jal	80001f0c <yield>
    800026d0:	bf5d                	j	80002686 <usertrap+0x8c>

00000000800026d2 <kerneltrap>:
{
    800026d2:	7179                	addi	sp,sp,-48
    800026d4:	f406                	sd	ra,40(sp)
    800026d6:	f022                	sd	s0,32(sp)
    800026d8:	ec26                	sd	s1,24(sp)
    800026da:	e84a                	sd	s2,16(sp)
    800026dc:	e44e                	sd	s3,8(sp)
    800026de:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026e0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026e4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026e8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800026ec:	1004f793          	andi	a5,s1,256
    800026f0:	c795                	beqz	a5,8000271c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026f2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026f6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800026f8:	eb85                	bnez	a5,80002728 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800026fa:	e8dff0ef          	jal	80002586 <devintr>
    800026fe:	c91d                	beqz	a0,80002734 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002700:	4789                	li	a5,2
    80002702:	04f50a63          	beq	a0,a5,80002756 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002706:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000270a:	10049073          	csrw	sstatus,s1
}
    8000270e:	70a2                	ld	ra,40(sp)
    80002710:	7402                	ld	s0,32(sp)
    80002712:	64e2                	ld	s1,24(sp)
    80002714:	6942                	ld	s2,16(sp)
    80002716:	69a2                	ld	s3,8(sp)
    80002718:	6145                	addi	sp,sp,48
    8000271a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000271c:	00005517          	auipc	a0,0x5
    80002720:	c6c50513          	addi	a0,a0,-916 # 80007388 <etext+0x388>
    80002724:	870fe0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	c8850513          	addi	a0,a0,-888 # 800073b0 <etext+0x3b0>
    80002730:	864fe0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002734:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002738:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000273c:	85ce                	mv	a1,s3
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	c9250513          	addi	a0,a0,-878 # 800073d0 <etext+0x3d0>
    80002746:	d7dfd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    8000274a:	00005517          	auipc	a0,0x5
    8000274e:	cae50513          	addi	a0,a0,-850 # 800073f8 <etext+0x3f8>
    80002752:	842fe0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002756:	98aff0ef          	jal	800018e0 <myproc>
    8000275a:	d555                	beqz	a0,80002706 <kerneltrap+0x34>
    yield();
    8000275c:	fb0ff0ef          	jal	80001f0c <yield>
    80002760:	b75d                	j	80002706 <kerneltrap+0x34>

0000000080002762 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	1000                	addi	s0,sp,32
    8000276c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000276e:	972ff0ef          	jal	800018e0 <myproc>
  switch (n) {
    80002772:	4795                	li	a5,5
    80002774:	0497e163          	bltu	a5,s1,800027b6 <argraw+0x54>
    80002778:	048a                	slli	s1,s1,0x2
    8000277a:	00005717          	auipc	a4,0x5
    8000277e:	03e70713          	addi	a4,a4,62 # 800077b8 <states.0+0x30>
    80002782:	94ba                	add	s1,s1,a4
    80002784:	409c                	lw	a5,0(s1)
    80002786:	97ba                	add	a5,a5,a4
    80002788:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000278a:	6d3c                	ld	a5,88(a0)
    8000278c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6105                	addi	sp,sp,32
    80002796:	8082                	ret
    return p->trapframe->a1;
    80002798:	6d3c                	ld	a5,88(a0)
    8000279a:	7fa8                	ld	a0,120(a5)
    8000279c:	bfcd                	j	8000278e <argraw+0x2c>
    return p->trapframe->a2;
    8000279e:	6d3c                	ld	a5,88(a0)
    800027a0:	63c8                	ld	a0,128(a5)
    800027a2:	b7f5                	j	8000278e <argraw+0x2c>
    return p->trapframe->a3;
    800027a4:	6d3c                	ld	a5,88(a0)
    800027a6:	67c8                	ld	a0,136(a5)
    800027a8:	b7dd                	j	8000278e <argraw+0x2c>
    return p->trapframe->a4;
    800027aa:	6d3c                	ld	a5,88(a0)
    800027ac:	6bc8                	ld	a0,144(a5)
    800027ae:	b7c5                	j	8000278e <argraw+0x2c>
    return p->trapframe->a5;
    800027b0:	6d3c                	ld	a5,88(a0)
    800027b2:	6fc8                	ld	a0,152(a5)
    800027b4:	bfe9                	j	8000278e <argraw+0x2c>
  panic("argraw");
    800027b6:	00005517          	auipc	a0,0x5
    800027ba:	c5250513          	addi	a0,a0,-942 # 80007408 <etext+0x408>
    800027be:	fd7fd0ef          	jal	80000794 <panic>

00000000800027c2 <fetchaddr>:
{
    800027c2:	1101                	addi	sp,sp,-32
    800027c4:	ec06                	sd	ra,24(sp)
    800027c6:	e822                	sd	s0,16(sp)
    800027c8:	e426                	sd	s1,8(sp)
    800027ca:	e04a                	sd	s2,0(sp)
    800027cc:	1000                	addi	s0,sp,32
    800027ce:	84aa                	mv	s1,a0
    800027d0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027d2:	90eff0ef          	jal	800018e0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027d6:	653c                	ld	a5,72(a0)
    800027d8:	02f4f663          	bgeu	s1,a5,80002804 <fetchaddr+0x42>
    800027dc:	00848713          	addi	a4,s1,8
    800027e0:	02e7e463          	bltu	a5,a4,80002808 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800027e4:	46a1                	li	a3,8
    800027e6:	8626                	mv	a2,s1
    800027e8:	85ca                	mv	a1,s2
    800027ea:	6928                	ld	a0,80(a0)
    800027ec:	e3dfe0ef          	jal	80001628 <copyin>
    800027f0:	00a03533          	snez	a0,a0
    800027f4:	40a00533          	neg	a0,a0
}
    800027f8:	60e2                	ld	ra,24(sp)
    800027fa:	6442                	ld	s0,16(sp)
    800027fc:	64a2                	ld	s1,8(sp)
    800027fe:	6902                	ld	s2,0(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret
    return -1;
    80002804:	557d                	li	a0,-1
    80002806:	bfcd                	j	800027f8 <fetchaddr+0x36>
    80002808:	557d                	li	a0,-1
    8000280a:	b7fd                	j	800027f8 <fetchaddr+0x36>

000000008000280c <fetchstr>:
{
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	1800                	addi	s0,sp,48
    8000281a:	892a                	mv	s2,a0
    8000281c:	84ae                	mv	s1,a1
    8000281e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002820:	8c0ff0ef          	jal	800018e0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002824:	86ce                	mv	a3,s3
    80002826:	864a                	mv	a2,s2
    80002828:	85a6                	mv	a1,s1
    8000282a:	6928                	ld	a0,80(a0)
    8000282c:	e83fe0ef          	jal	800016ae <copyinstr>
    80002830:	00054c63          	bltz	a0,80002848 <fetchstr+0x3c>
  return strlen(buf);
    80002834:	8526                	mv	a0,s1
    80002836:	e02fe0ef          	jal	80000e38 <strlen>
}
    8000283a:	70a2                	ld	ra,40(sp)
    8000283c:	7402                	ld	s0,32(sp)
    8000283e:	64e2                	ld	s1,24(sp)
    80002840:	6942                	ld	s2,16(sp)
    80002842:	69a2                	ld	s3,8(sp)
    80002844:	6145                	addi	sp,sp,48
    80002846:	8082                	ret
    return -1;
    80002848:	557d                	li	a0,-1
    8000284a:	bfc5                	j	8000283a <fetchstr+0x2e>

000000008000284c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000284c:	1101                	addi	sp,sp,-32
    8000284e:	ec06                	sd	ra,24(sp)
    80002850:	e822                	sd	s0,16(sp)
    80002852:	e426                	sd	s1,8(sp)
    80002854:	1000                	addi	s0,sp,32
    80002856:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002858:	f0bff0ef          	jal	80002762 <argraw>
    8000285c:	c088                	sw	a0,0(s1)
}
    8000285e:	60e2                	ld	ra,24(sp)
    80002860:	6442                	ld	s0,16(sp)
    80002862:	64a2                	ld	s1,8(sp)
    80002864:	6105                	addi	sp,sp,32
    80002866:	8082                	ret

0000000080002868 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002868:	1101                	addi	sp,sp,-32
    8000286a:	ec06                	sd	ra,24(sp)
    8000286c:	e822                	sd	s0,16(sp)
    8000286e:	e426                	sd	s1,8(sp)
    80002870:	1000                	addi	s0,sp,32
    80002872:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002874:	eefff0ef          	jal	80002762 <argraw>
    80002878:	e088                	sd	a0,0(s1)
}
    8000287a:	60e2                	ld	ra,24(sp)
    8000287c:	6442                	ld	s0,16(sp)
    8000287e:	64a2                	ld	s1,8(sp)
    80002880:	6105                	addi	sp,sp,32
    80002882:	8082                	ret

0000000080002884 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002884:	7179                	addi	sp,sp,-48
    80002886:	f406                	sd	ra,40(sp)
    80002888:	f022                	sd	s0,32(sp)
    8000288a:	ec26                	sd	s1,24(sp)
    8000288c:	e84a                	sd	s2,16(sp)
    8000288e:	1800                	addi	s0,sp,48
    80002890:	84ae                	mv	s1,a1
    80002892:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002894:	fd840593          	addi	a1,s0,-40
    80002898:	fd1ff0ef          	jal	80002868 <argaddr>
  return fetchstr(addr, buf, max);
    8000289c:	864a                	mv	a2,s2
    8000289e:	85a6                	mv	a1,s1
    800028a0:	fd843503          	ld	a0,-40(s0)
    800028a4:	f69ff0ef          	jal	8000280c <fetchstr>
}
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret

00000000800028b4 <syscall>:

};

void
syscall(void)
{
    800028b4:	1101                	addi	sp,sp,-32
    800028b6:	ec06                	sd	ra,24(sp)
    800028b8:	e822                	sd	s0,16(sp)
    800028ba:	e426                	sd	s1,8(sp)
    800028bc:	e04a                	sd	s2,0(sp)
    800028be:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028c0:	820ff0ef          	jal	800018e0 <myproc>
    800028c4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028c6:	05853903          	ld	s2,88(a0)
    800028ca:	0a893783          	ld	a5,168(s2)
    800028ce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028d2:	37fd                	addiw	a5,a5,-1
    800028d4:	4759                	li	a4,22
    800028d6:	00f76f63          	bltu	a4,a5,800028f4 <syscall+0x40>
    800028da:	00369713          	slli	a4,a3,0x3
    800028de:	00005797          	auipc	a5,0x5
    800028e2:	ef278793          	addi	a5,a5,-270 # 800077d0 <syscalls>
    800028e6:	97ba                	add	a5,a5,a4
    800028e8:	639c                	ld	a5,0(a5)
    800028ea:	c789                	beqz	a5,800028f4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028ec:	9782                	jalr	a5
    800028ee:	06a93823          	sd	a0,112(s2)
    800028f2:	a829                	j	8000290c <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800028f4:	15848613          	addi	a2,s1,344
    800028f8:	588c                	lw	a1,48(s1)
    800028fa:	00005517          	auipc	a0,0x5
    800028fe:	b1650513          	addi	a0,a0,-1258 # 80007410 <etext+0x410>
    80002902:	bc1fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002906:	6cbc                	ld	a5,88(s1)
    80002908:	577d                	li	a4,-1
    8000290a:	fbb8                	sd	a4,112(a5)
  }
}
    8000290c:	60e2                	ld	ra,24(sp)
    8000290e:	6442                	ld	s0,16(sp)
    80002910:	64a2                	ld	s1,8(sp)
    80002912:	6902                	ld	s2,0(sp)
    80002914:	6105                	addi	sp,sp,32
    80002916:	8082                	ret

0000000080002918 <sys_exit>:
extern int scheduler_mode;


uint64
sys_exit(void)
{
    80002918:	1101                	addi	sp,sp,-32
    8000291a:	ec06                	sd	ra,24(sp)
    8000291c:	e822                	sd	s0,16(sp)
    8000291e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002920:	fec40593          	addi	a1,s0,-20
    80002924:	4501                	li	a0,0
    80002926:	f27ff0ef          	jal	8000284c <argint>
  exit(n);
    8000292a:	fec42503          	lw	a0,-20(s0)
    8000292e:	f16ff0ef          	jal	80002044 <exit>
  return 0;  // not reached
}
    80002932:	4501                	li	a0,0
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	6105                	addi	sp,sp,32
    8000293a:	8082                	ret

000000008000293c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000293c:	1141                	addi	sp,sp,-16
    8000293e:	e406                	sd	ra,8(sp)
    80002940:	e022                	sd	s0,0(sp)
    80002942:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002944:	f9dfe0ef          	jal	800018e0 <myproc>
}
    80002948:	5908                	lw	a0,48(a0)
    8000294a:	60a2                	ld	ra,8(sp)
    8000294c:	6402                	ld	s0,0(sp)
    8000294e:	0141                	addi	sp,sp,16
    80002950:	8082                	ret

0000000080002952 <sys_fork>:

uint64
sys_fork(void)
{
    80002952:	1141                	addi	sp,sp,-16
    80002954:	e406                	sd	ra,8(sp)
    80002956:	e022                	sd	s0,0(sp)
    80002958:	0800                	addi	s0,sp,16
  return fork();
    8000295a:	ab0ff0ef          	jal	80001c0a <fork>
}
    8000295e:	60a2                	ld	ra,8(sp)
    80002960:	6402                	ld	s0,0(sp)
    80002962:	0141                	addi	sp,sp,16
    80002964:	8082                	ret

0000000080002966 <sys_wait>:

uint64
sys_wait(void)
{
    80002966:	1101                	addi	sp,sp,-32
    80002968:	ec06                	sd	ra,24(sp)
    8000296a:	e822                	sd	s0,16(sp)
    8000296c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000296e:	fe840593          	addi	a1,s0,-24
    80002972:	4501                	li	a0,0
    80002974:	ef5ff0ef          	jal	80002868 <argaddr>
  return wait(p);
    80002978:	fe843503          	ld	a0,-24(s0)
    8000297c:	81fff0ef          	jal	8000219a <wait>
}
    80002980:	60e2                	ld	ra,24(sp)
    80002982:	6442                	ld	s0,16(sp)
    80002984:	6105                	addi	sp,sp,32
    80002986:	8082                	ret

0000000080002988 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002988:	7179                	addi	sp,sp,-48
    8000298a:	f406                	sd	ra,40(sp)
    8000298c:	f022                	sd	s0,32(sp)
    8000298e:	ec26                	sd	s1,24(sp)
    80002990:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002992:	fdc40593          	addi	a1,s0,-36
    80002996:	4501                	li	a0,0
    80002998:	eb5ff0ef          	jal	8000284c <argint>
  addr = myproc()->sz;
    8000299c:	f45fe0ef          	jal	800018e0 <myproc>
    800029a0:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800029a2:	fdc42503          	lw	a0,-36(s0)
    800029a6:	a14ff0ef          	jal	80001bba <growproc>
    800029aa:	00054863          	bltz	a0,800029ba <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800029ae:	8526                	mv	a0,s1
    800029b0:	70a2                	ld	ra,40(sp)
    800029b2:	7402                	ld	s0,32(sp)
    800029b4:	64e2                	ld	s1,24(sp)
    800029b6:	6145                	addi	sp,sp,48
    800029b8:	8082                	ret
    return -1;
    800029ba:	54fd                	li	s1,-1
    800029bc:	bfcd                	j	800029ae <sys_sbrk+0x26>

00000000800029be <sys_sleep>:

uint64
sys_sleep(void)
{
    800029be:	7139                	addi	sp,sp,-64
    800029c0:	fc06                	sd	ra,56(sp)
    800029c2:	f822                	sd	s0,48(sp)
    800029c4:	f04a                	sd	s2,32(sp)
    800029c6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029c8:	fcc40593          	addi	a1,s0,-52
    800029cc:	4501                	li	a0,0
    800029ce:	e7fff0ef          	jal	8000284c <argint>
  if(n < 0)
    800029d2:	fcc42783          	lw	a5,-52(s0)
    800029d6:	0607c763          	bltz	a5,80002a44 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    800029da:	00013517          	auipc	a0,0x13
    800029de:	e9650513          	addi	a0,a0,-362 # 80015870 <tickslock>
    800029e2:	a12fe0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    800029e6:	00005917          	auipc	s2,0x5
    800029ea:	f2e92903          	lw	s2,-210(s2) # 80007914 <ticks>
  while(ticks - ticks0 < n){
    800029ee:	fcc42783          	lw	a5,-52(s0)
    800029f2:	cf8d                	beqz	a5,80002a2c <sys_sleep+0x6e>
    800029f4:	f426                	sd	s1,40(sp)
    800029f6:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800029f8:	00013997          	auipc	s3,0x13
    800029fc:	e7898993          	addi	s3,s3,-392 # 80015870 <tickslock>
    80002a00:	00005497          	auipc	s1,0x5
    80002a04:	f1448493          	addi	s1,s1,-236 # 80007914 <ticks>
    if(killed(myproc())){
    80002a08:	ed9fe0ef          	jal	800018e0 <myproc>
    80002a0c:	f64ff0ef          	jal	80002170 <killed>
    80002a10:	ed0d                	bnez	a0,80002a4a <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002a12:	85ce                	mv	a1,s3
    80002a14:	8526                	mv	a0,s1
    80002a16:	d22ff0ef          	jal	80001f38 <sleep>
  while(ticks - ticks0 < n){
    80002a1a:	409c                	lw	a5,0(s1)
    80002a1c:	412787bb          	subw	a5,a5,s2
    80002a20:	fcc42703          	lw	a4,-52(s0)
    80002a24:	fee7e2e3          	bltu	a5,a4,80002a08 <sys_sleep+0x4a>
    80002a28:	74a2                	ld	s1,40(sp)
    80002a2a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a2c:	00013517          	auipc	a0,0x13
    80002a30:	e4450513          	addi	a0,a0,-444 # 80015870 <tickslock>
    80002a34:	a58fe0ef          	jal	80000c8c <release>
  return 0;
    80002a38:	4501                	li	a0,0
}
    80002a3a:	70e2                	ld	ra,56(sp)
    80002a3c:	7442                	ld	s0,48(sp)
    80002a3e:	7902                	ld	s2,32(sp)
    80002a40:	6121                	addi	sp,sp,64
    80002a42:	8082                	ret
    n = 0;
    80002a44:	fc042623          	sw	zero,-52(s0)
    80002a48:	bf49                	j	800029da <sys_sleep+0x1c>
      release(&tickslock);
    80002a4a:	00013517          	auipc	a0,0x13
    80002a4e:	e2650513          	addi	a0,a0,-474 # 80015870 <tickslock>
    80002a52:	a3afe0ef          	jal	80000c8c <release>
      return -1;
    80002a56:	557d                	li	a0,-1
    80002a58:	74a2                	ld	s1,40(sp)
    80002a5a:	69e2                	ld	s3,24(sp)
    80002a5c:	bff9                	j	80002a3a <sys_sleep+0x7c>

0000000080002a5e <sys_kill>:

uint64
sys_kill(void)
{
    80002a5e:	1101                	addi	sp,sp,-32
    80002a60:	ec06                	sd	ra,24(sp)
    80002a62:	e822                	sd	s0,16(sp)
    80002a64:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a66:	fec40593          	addi	a1,s0,-20
    80002a6a:	4501                	li	a0,0
    80002a6c:	de1ff0ef          	jal	8000284c <argint>
  return kill(pid);
    80002a70:	fec42503          	lw	a0,-20(s0)
    80002a74:	e72ff0ef          	jal	800020e6 <kill>
}
    80002a78:	60e2                	ld	ra,24(sp)
    80002a7a:	6442                	ld	s0,16(sp)
    80002a7c:	6105                	addi	sp,sp,32
    80002a7e:	8082                	ret

0000000080002a80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002a80:	1101                	addi	sp,sp,-32
    80002a82:	ec06                	sd	ra,24(sp)
    80002a84:	e822                	sd	s0,16(sp)
    80002a86:	e426                	sd	s1,8(sp)
    80002a88:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002a8a:	00013517          	auipc	a0,0x13
    80002a8e:	de650513          	addi	a0,a0,-538 # 80015870 <tickslock>
    80002a92:	962fe0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002a96:	00005497          	auipc	s1,0x5
    80002a9a:	e7e4a483          	lw	s1,-386(s1) # 80007914 <ticks>
  release(&tickslock);
    80002a9e:	00013517          	auipc	a0,0x13
    80002aa2:	dd250513          	addi	a0,a0,-558 # 80015870 <tickslock>
    80002aa6:	9e6fe0ef          	jal	80000c8c <release>
  return xticks;
}
    80002aaa:	02049513          	slli	a0,s1,0x20
    80002aae:	9101                	srli	a0,a0,0x20
    80002ab0:	60e2                	ld	ra,24(sp)
    80002ab2:	6442                	ld	s0,16(sp)
    80002ab4:	64a2                	ld	s1,8(sp)
    80002ab6:	6105                	addi	sp,sp,32
    80002ab8:	8082                	ret

0000000080002aba <sys_settickets>:

uint64
sys_settickets(void)
{
    80002aba:	1101                	addi	sp,sp,-32
    80002abc:	ec06                	sd	ra,24(sp)
    80002abe:	e822                	sd	s0,16(sp)
    80002ac0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);       // argint returns void in your version
    80002ac2:	fec40593          	addi	a1,s0,-20
    80002ac6:	4501                	li	a0,0
    80002ac8:	d85ff0ef          	jal	8000284c <argint>
  if(n < 1)
    80002acc:	fec42783          	lw	a5,-20(s0)
    return -1;
    80002ad0:	557d                	li	a0,-1
  if(n < 1)
    80002ad2:	00f05663          	blez	a5,80002ade <sys_settickets+0x24>
  settickets(n);
    80002ad6:	853e                	mv	a0,a5
    80002ad8:	8f5ff0ef          	jal	800023cc <settickets>
  return 0;
    80002adc:	4501                	li	a0,0
}
    80002ade:	60e2                	ld	ra,24(sp)
    80002ae0:	6442                	ld	s0,16(sp)
    80002ae2:	6105                	addi	sp,sp,32
    80002ae4:	8082                	ret

0000000080002ae6 <sys_setsched>:

uint64
sys_setsched(void)
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	1000                	addi	s0,sp,32
  int mode;
  argint(0, &mode);
    80002aee:	fec40593          	addi	a1,s0,-20
    80002af2:	4501                	li	a0,0
    80002af4:	d59ff0ef          	jal	8000284c <argint>
  if (mode != 0 && mode != 1)
    80002af8:	fec42783          	lw	a5,-20(s0)
    80002afc:	0007869b          	sext.w	a3,a5
    80002b00:	4705                	li	a4,1
    return -1;
    80002b02:	557d                	li	a0,-1
  if (mode != 0 && mode != 1)
    80002b04:	00d76763          	bltu	a4,a3,80002b12 <sys_setsched+0x2c>
  scheduler_mode = mode;
    80002b08:	00005717          	auipc	a4,0x5
    80002b0c:	e0f72423          	sw	a5,-504(a4) # 80007910 <scheduler_mode>
  return 0;
    80002b10:	4501                	li	a0,0
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret

0000000080002b1a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b1a:	7179                	addi	sp,sp,-48
    80002b1c:	f406                	sd	ra,40(sp)
    80002b1e:	f022                	sd	s0,32(sp)
    80002b20:	ec26                	sd	s1,24(sp)
    80002b22:	e84a                	sd	s2,16(sp)
    80002b24:	e44e                	sd	s3,8(sp)
    80002b26:	e052                	sd	s4,0(sp)
    80002b28:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b2a:	00005597          	auipc	a1,0x5
    80002b2e:	90658593          	addi	a1,a1,-1786 # 80007430 <etext+0x430>
    80002b32:	00013517          	auipc	a0,0x13
    80002b36:	d5650513          	addi	a0,a0,-682 # 80015888 <bcache>
    80002b3a:	83afe0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b3e:	0001b797          	auipc	a5,0x1b
    80002b42:	d4a78793          	addi	a5,a5,-694 # 8001d888 <bcache+0x8000>
    80002b46:	0001b717          	auipc	a4,0x1b
    80002b4a:	faa70713          	addi	a4,a4,-86 # 8001daf0 <bcache+0x8268>
    80002b4e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b52:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b56:	00013497          	auipc	s1,0x13
    80002b5a:	d4a48493          	addi	s1,s1,-694 # 800158a0 <bcache+0x18>
    b->next = bcache.head.next;
    80002b5e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b60:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b62:	00005a17          	auipc	s4,0x5
    80002b66:	8d6a0a13          	addi	s4,s4,-1834 # 80007438 <etext+0x438>
    b->next = bcache.head.next;
    80002b6a:	2b893783          	ld	a5,696(s2)
    80002b6e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b70:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b74:	85d2                	mv	a1,s4
    80002b76:	01048513          	addi	a0,s1,16
    80002b7a:	248010ef          	jal	80003dc2 <initsleeplock>
    bcache.head.next->prev = b;
    80002b7e:	2b893783          	ld	a5,696(s2)
    80002b82:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b84:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002b88:	45848493          	addi	s1,s1,1112
    80002b8c:	fd349fe3          	bne	s1,s3,80002b6a <binit+0x50>
  }
}
    80002b90:	70a2                	ld	ra,40(sp)
    80002b92:	7402                	ld	s0,32(sp)
    80002b94:	64e2                	ld	s1,24(sp)
    80002b96:	6942                	ld	s2,16(sp)
    80002b98:	69a2                	ld	s3,8(sp)
    80002b9a:	6a02                	ld	s4,0(sp)
    80002b9c:	6145                	addi	sp,sp,48
    80002b9e:	8082                	ret

0000000080002ba0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ba0:	7179                	addi	sp,sp,-48
    80002ba2:	f406                	sd	ra,40(sp)
    80002ba4:	f022                	sd	s0,32(sp)
    80002ba6:	ec26                	sd	s1,24(sp)
    80002ba8:	e84a                	sd	s2,16(sp)
    80002baa:	e44e                	sd	s3,8(sp)
    80002bac:	1800                	addi	s0,sp,48
    80002bae:	892a                	mv	s2,a0
    80002bb0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002bb2:	00013517          	auipc	a0,0x13
    80002bb6:	cd650513          	addi	a0,a0,-810 # 80015888 <bcache>
    80002bba:	83afe0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002bbe:	0001b497          	auipc	s1,0x1b
    80002bc2:	f824b483          	ld	s1,-126(s1) # 8001db40 <bcache+0x82b8>
    80002bc6:	0001b797          	auipc	a5,0x1b
    80002bca:	f2a78793          	addi	a5,a5,-214 # 8001daf0 <bcache+0x8268>
    80002bce:	02f48b63          	beq	s1,a5,80002c04 <bread+0x64>
    80002bd2:	873e                	mv	a4,a5
    80002bd4:	a021                	j	80002bdc <bread+0x3c>
    80002bd6:	68a4                	ld	s1,80(s1)
    80002bd8:	02e48663          	beq	s1,a4,80002c04 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002bdc:	449c                	lw	a5,8(s1)
    80002bde:	ff279ce3          	bne	a5,s2,80002bd6 <bread+0x36>
    80002be2:	44dc                	lw	a5,12(s1)
    80002be4:	ff3799e3          	bne	a5,s3,80002bd6 <bread+0x36>
      b->refcnt++;
    80002be8:	40bc                	lw	a5,64(s1)
    80002bea:	2785                	addiw	a5,a5,1
    80002bec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bee:	00013517          	auipc	a0,0x13
    80002bf2:	c9a50513          	addi	a0,a0,-870 # 80015888 <bcache>
    80002bf6:	896fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002bfa:	01048513          	addi	a0,s1,16
    80002bfe:	1fa010ef          	jal	80003df8 <acquiresleep>
      return b;
    80002c02:	a889                	j	80002c54 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c04:	0001b497          	auipc	s1,0x1b
    80002c08:	f344b483          	ld	s1,-204(s1) # 8001db38 <bcache+0x82b0>
    80002c0c:	0001b797          	auipc	a5,0x1b
    80002c10:	ee478793          	addi	a5,a5,-284 # 8001daf0 <bcache+0x8268>
    80002c14:	00f48863          	beq	s1,a5,80002c24 <bread+0x84>
    80002c18:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002c1a:	40bc                	lw	a5,64(s1)
    80002c1c:	cb91                	beqz	a5,80002c30 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c1e:	64a4                	ld	s1,72(s1)
    80002c20:	fee49de3          	bne	s1,a4,80002c1a <bread+0x7a>
  panic("bget: no buffers");
    80002c24:	00005517          	auipc	a0,0x5
    80002c28:	81c50513          	addi	a0,a0,-2020 # 80007440 <etext+0x440>
    80002c2c:	b69fd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002c30:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c34:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c38:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c3c:	4785                	li	a5,1
    80002c3e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c40:	00013517          	auipc	a0,0x13
    80002c44:	c4850513          	addi	a0,a0,-952 # 80015888 <bcache>
    80002c48:	844fe0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002c4c:	01048513          	addi	a0,s1,16
    80002c50:	1a8010ef          	jal	80003df8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002c54:	409c                	lw	a5,0(s1)
    80002c56:	cb89                	beqz	a5,80002c68 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c58:	8526                	mv	a0,s1
    80002c5a:	70a2                	ld	ra,40(sp)
    80002c5c:	7402                	ld	s0,32(sp)
    80002c5e:	64e2                	ld	s1,24(sp)
    80002c60:	6942                	ld	s2,16(sp)
    80002c62:	69a2                	ld	s3,8(sp)
    80002c64:	6145                	addi	sp,sp,48
    80002c66:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c68:	4581                	li	a1,0
    80002c6a:	8526                	mv	a0,s1
    80002c6c:	1e5020ef          	jal	80005650 <virtio_disk_rw>
    b->valid = 1;
    80002c70:	4785                	li	a5,1
    80002c72:	c09c                	sw	a5,0(s1)
  return b;
    80002c74:	b7d5                	j	80002c58 <bread+0xb8>

0000000080002c76 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c76:	1101                	addi	sp,sp,-32
    80002c78:	ec06                	sd	ra,24(sp)
    80002c7a:	e822                	sd	s0,16(sp)
    80002c7c:	e426                	sd	s1,8(sp)
    80002c7e:	1000                	addi	s0,sp,32
    80002c80:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002c82:	0541                	addi	a0,a0,16
    80002c84:	1f2010ef          	jal	80003e76 <holdingsleep>
    80002c88:	c911                	beqz	a0,80002c9c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c8a:	4585                	li	a1,1
    80002c8c:	8526                	mv	a0,s1
    80002c8e:	1c3020ef          	jal	80005650 <virtio_disk_rw>
}
    80002c92:	60e2                	ld	ra,24(sp)
    80002c94:	6442                	ld	s0,16(sp)
    80002c96:	64a2                	ld	s1,8(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    panic("bwrite");
    80002c9c:	00004517          	auipc	a0,0x4
    80002ca0:	7bc50513          	addi	a0,a0,1980 # 80007458 <etext+0x458>
    80002ca4:	af1fd0ef          	jal	80000794 <panic>

0000000080002ca8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002cb6:	01050913          	addi	s2,a0,16
    80002cba:	854a                	mv	a0,s2
    80002cbc:	1ba010ef          	jal	80003e76 <holdingsleep>
    80002cc0:	c135                	beqz	a0,80002d24 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	17a010ef          	jal	80003e3e <releasesleep>

  acquire(&bcache.lock);
    80002cc8:	00013517          	auipc	a0,0x13
    80002ccc:	bc050513          	addi	a0,a0,-1088 # 80015888 <bcache>
    80002cd0:	f25fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002cd4:	40bc                	lw	a5,64(s1)
    80002cd6:	37fd                	addiw	a5,a5,-1
    80002cd8:	0007871b          	sext.w	a4,a5
    80002cdc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002cde:	e71d                	bnez	a4,80002d0c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002ce0:	68b8                	ld	a4,80(s1)
    80002ce2:	64bc                	ld	a5,72(s1)
    80002ce4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002ce6:	68b8                	ld	a4,80(s1)
    80002ce8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002cea:	0001b797          	auipc	a5,0x1b
    80002cee:	b9e78793          	addi	a5,a5,-1122 # 8001d888 <bcache+0x8000>
    80002cf2:	2b87b703          	ld	a4,696(a5)
    80002cf6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002cf8:	0001b717          	auipc	a4,0x1b
    80002cfc:	df870713          	addi	a4,a4,-520 # 8001daf0 <bcache+0x8268>
    80002d00:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d02:	2b87b703          	ld	a4,696(a5)
    80002d06:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d08:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002d0c:	00013517          	auipc	a0,0x13
    80002d10:	b7c50513          	addi	a0,a0,-1156 # 80015888 <bcache>
    80002d14:	f79fd0ef          	jal	80000c8c <release>
}
    80002d18:	60e2                	ld	ra,24(sp)
    80002d1a:	6442                	ld	s0,16(sp)
    80002d1c:	64a2                	ld	s1,8(sp)
    80002d1e:	6902                	ld	s2,0(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret
    panic("brelse");
    80002d24:	00004517          	auipc	a0,0x4
    80002d28:	73c50513          	addi	a0,a0,1852 # 80007460 <etext+0x460>
    80002d2c:	a69fd0ef          	jal	80000794 <panic>

0000000080002d30 <bpin>:

void
bpin(struct buf *b) {
    80002d30:	1101                	addi	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	e426                	sd	s1,8(sp)
    80002d38:	1000                	addi	s0,sp,32
    80002d3a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d3c:	00013517          	auipc	a0,0x13
    80002d40:	b4c50513          	addi	a0,a0,-1204 # 80015888 <bcache>
    80002d44:	eb1fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80002d48:	40bc                	lw	a5,64(s1)
    80002d4a:	2785                	addiw	a5,a5,1
    80002d4c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d4e:	00013517          	auipc	a0,0x13
    80002d52:	b3a50513          	addi	a0,a0,-1222 # 80015888 <bcache>
    80002d56:	f37fd0ef          	jal	80000c8c <release>
}
    80002d5a:	60e2                	ld	ra,24(sp)
    80002d5c:	6442                	ld	s0,16(sp)
    80002d5e:	64a2                	ld	s1,8(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret

0000000080002d64 <bunpin>:

void
bunpin(struct buf *b) {
    80002d64:	1101                	addi	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	e426                	sd	s1,8(sp)
    80002d6c:	1000                	addi	s0,sp,32
    80002d6e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d70:	00013517          	auipc	a0,0x13
    80002d74:	b1850513          	addi	a0,a0,-1256 # 80015888 <bcache>
    80002d78:	e7dfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80002d7c:	40bc                	lw	a5,64(s1)
    80002d7e:	37fd                	addiw	a5,a5,-1
    80002d80:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d82:	00013517          	auipc	a0,0x13
    80002d86:	b0650513          	addi	a0,a0,-1274 # 80015888 <bcache>
    80002d8a:	f03fd0ef          	jal	80000c8c <release>
}
    80002d8e:	60e2                	ld	ra,24(sp)
    80002d90:	6442                	ld	s0,16(sp)
    80002d92:	64a2                	ld	s1,8(sp)
    80002d94:	6105                	addi	sp,sp,32
    80002d96:	8082                	ret

0000000080002d98 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d98:	1101                	addi	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	e426                	sd	s1,8(sp)
    80002da0:	e04a                	sd	s2,0(sp)
    80002da2:	1000                	addi	s0,sp,32
    80002da4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002da6:	00d5d59b          	srliw	a1,a1,0xd
    80002daa:	0001b797          	auipc	a5,0x1b
    80002dae:	1ba7a783          	lw	a5,442(a5) # 8001df64 <sb+0x1c>
    80002db2:	9dbd                	addw	a1,a1,a5
    80002db4:	dedff0ef          	jal	80002ba0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002db8:	0074f713          	andi	a4,s1,7
    80002dbc:	4785                	li	a5,1
    80002dbe:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002dc2:	14ce                	slli	s1,s1,0x33
    80002dc4:	90d9                	srli	s1,s1,0x36
    80002dc6:	00950733          	add	a4,a0,s1
    80002dca:	05874703          	lbu	a4,88(a4)
    80002dce:	00e7f6b3          	and	a3,a5,a4
    80002dd2:	c29d                	beqz	a3,80002df8 <bfree+0x60>
    80002dd4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002dd6:	94aa                	add	s1,s1,a0
    80002dd8:	fff7c793          	not	a5,a5
    80002ddc:	8f7d                	and	a4,a4,a5
    80002dde:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002de2:	711000ef          	jal	80003cf2 <log_write>
  brelse(bp);
    80002de6:	854a                	mv	a0,s2
    80002de8:	ec1ff0ef          	jal	80002ca8 <brelse>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6902                	ld	s2,0(sp)
    80002df4:	6105                	addi	sp,sp,32
    80002df6:	8082                	ret
    panic("freeing free block");
    80002df8:	00004517          	auipc	a0,0x4
    80002dfc:	67050513          	addi	a0,a0,1648 # 80007468 <etext+0x468>
    80002e00:	995fd0ef          	jal	80000794 <panic>

0000000080002e04 <balloc>:
{
    80002e04:	711d                	addi	sp,sp,-96
    80002e06:	ec86                	sd	ra,88(sp)
    80002e08:	e8a2                	sd	s0,80(sp)
    80002e0a:	e4a6                	sd	s1,72(sp)
    80002e0c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002e0e:	0001b797          	auipc	a5,0x1b
    80002e12:	13e7a783          	lw	a5,318(a5) # 8001df4c <sb+0x4>
    80002e16:	0e078f63          	beqz	a5,80002f14 <balloc+0x110>
    80002e1a:	e0ca                	sd	s2,64(sp)
    80002e1c:	fc4e                	sd	s3,56(sp)
    80002e1e:	f852                	sd	s4,48(sp)
    80002e20:	f456                	sd	s5,40(sp)
    80002e22:	f05a                	sd	s6,32(sp)
    80002e24:	ec5e                	sd	s7,24(sp)
    80002e26:	e862                	sd	s8,16(sp)
    80002e28:	e466                	sd	s9,8(sp)
    80002e2a:	8baa                	mv	s7,a0
    80002e2c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e2e:	0001bb17          	auipc	s6,0x1b
    80002e32:	11ab0b13          	addi	s6,s6,282 # 8001df48 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e36:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002e38:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002e3a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002e3c:	6c89                	lui	s9,0x2
    80002e3e:	a0b5                	j	80002eaa <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002e40:	97ca                	add	a5,a5,s2
    80002e42:	8e55                	or	a2,a2,a3
    80002e44:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e48:	854a                	mv	a0,s2
    80002e4a:	6a9000ef          	jal	80003cf2 <log_write>
        brelse(bp);
    80002e4e:	854a                	mv	a0,s2
    80002e50:	e59ff0ef          	jal	80002ca8 <brelse>
  bp = bread(dev, bno);
    80002e54:	85a6                	mv	a1,s1
    80002e56:	855e                	mv	a0,s7
    80002e58:	d49ff0ef          	jal	80002ba0 <bread>
    80002e5c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e5e:	40000613          	li	a2,1024
    80002e62:	4581                	li	a1,0
    80002e64:	05850513          	addi	a0,a0,88
    80002e68:	e61fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80002e6c:	854a                	mv	a0,s2
    80002e6e:	685000ef          	jal	80003cf2 <log_write>
  brelse(bp);
    80002e72:	854a                	mv	a0,s2
    80002e74:	e35ff0ef          	jal	80002ca8 <brelse>
}
    80002e78:	6906                	ld	s2,64(sp)
    80002e7a:	79e2                	ld	s3,56(sp)
    80002e7c:	7a42                	ld	s4,48(sp)
    80002e7e:	7aa2                	ld	s5,40(sp)
    80002e80:	7b02                	ld	s6,32(sp)
    80002e82:	6be2                	ld	s7,24(sp)
    80002e84:	6c42                	ld	s8,16(sp)
    80002e86:	6ca2                	ld	s9,8(sp)
}
    80002e88:	8526                	mv	a0,s1
    80002e8a:	60e6                	ld	ra,88(sp)
    80002e8c:	6446                	ld	s0,80(sp)
    80002e8e:	64a6                	ld	s1,72(sp)
    80002e90:	6125                	addi	sp,sp,96
    80002e92:	8082                	ret
    brelse(bp);
    80002e94:	854a                	mv	a0,s2
    80002e96:	e13ff0ef          	jal	80002ca8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002e9a:	015c87bb          	addw	a5,s9,s5
    80002e9e:	00078a9b          	sext.w	s5,a5
    80002ea2:	004b2703          	lw	a4,4(s6)
    80002ea6:	04eaff63          	bgeu	s5,a4,80002f04 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002eaa:	41fad79b          	sraiw	a5,s5,0x1f
    80002eae:	0137d79b          	srliw	a5,a5,0x13
    80002eb2:	015787bb          	addw	a5,a5,s5
    80002eb6:	40d7d79b          	sraiw	a5,a5,0xd
    80002eba:	01cb2583          	lw	a1,28(s6)
    80002ebe:	9dbd                	addw	a1,a1,a5
    80002ec0:	855e                	mv	a0,s7
    80002ec2:	cdfff0ef          	jal	80002ba0 <bread>
    80002ec6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ec8:	004b2503          	lw	a0,4(s6)
    80002ecc:	000a849b          	sext.w	s1,s5
    80002ed0:	8762                	mv	a4,s8
    80002ed2:	fca4f1e3          	bgeu	s1,a0,80002e94 <balloc+0x90>
      m = 1 << (bi % 8);
    80002ed6:	00777693          	andi	a3,a4,7
    80002eda:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002ede:	41f7579b          	sraiw	a5,a4,0x1f
    80002ee2:	01d7d79b          	srliw	a5,a5,0x1d
    80002ee6:	9fb9                	addw	a5,a5,a4
    80002ee8:	4037d79b          	sraiw	a5,a5,0x3
    80002eec:	00f90633          	add	a2,s2,a5
    80002ef0:	05864603          	lbu	a2,88(a2)
    80002ef4:	00c6f5b3          	and	a1,a3,a2
    80002ef8:	d5a1                	beqz	a1,80002e40 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002efa:	2705                	addiw	a4,a4,1
    80002efc:	2485                	addiw	s1,s1,1
    80002efe:	fd471ae3          	bne	a4,s4,80002ed2 <balloc+0xce>
    80002f02:	bf49                	j	80002e94 <balloc+0x90>
    80002f04:	6906                	ld	s2,64(sp)
    80002f06:	79e2                	ld	s3,56(sp)
    80002f08:	7a42                	ld	s4,48(sp)
    80002f0a:	7aa2                	ld	s5,40(sp)
    80002f0c:	7b02                	ld	s6,32(sp)
    80002f0e:	6be2                	ld	s7,24(sp)
    80002f10:	6c42                	ld	s8,16(sp)
    80002f12:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002f14:	00004517          	auipc	a0,0x4
    80002f18:	56c50513          	addi	a0,a0,1388 # 80007480 <etext+0x480>
    80002f1c:	da6fd0ef          	jal	800004c2 <printf>
  return 0;
    80002f20:	4481                	li	s1,0
    80002f22:	b79d                	j	80002e88 <balloc+0x84>

0000000080002f24 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f24:	7179                	addi	sp,sp,-48
    80002f26:	f406                	sd	ra,40(sp)
    80002f28:	f022                	sd	s0,32(sp)
    80002f2a:	ec26                	sd	s1,24(sp)
    80002f2c:	e84a                	sd	s2,16(sp)
    80002f2e:	e44e                	sd	s3,8(sp)
    80002f30:	1800                	addi	s0,sp,48
    80002f32:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002f34:	47ad                	li	a5,11
    80002f36:	02b7e663          	bltu	a5,a1,80002f62 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002f3a:	02059793          	slli	a5,a1,0x20
    80002f3e:	01e7d593          	srli	a1,a5,0x1e
    80002f42:	00b504b3          	add	s1,a0,a1
    80002f46:	0504a903          	lw	s2,80(s1)
    80002f4a:	06091a63          	bnez	s2,80002fbe <bmap+0x9a>
      addr = balloc(ip->dev);
    80002f4e:	4108                	lw	a0,0(a0)
    80002f50:	eb5ff0ef          	jal	80002e04 <balloc>
    80002f54:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f58:	06090363          	beqz	s2,80002fbe <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002f5c:	0524a823          	sw	s2,80(s1)
    80002f60:	a8b9                	j	80002fbe <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f62:	ff45849b          	addiw	s1,a1,-12
    80002f66:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002f6a:	0ff00793          	li	a5,255
    80002f6e:	06e7ee63          	bltu	a5,a4,80002fea <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002f72:	08052903          	lw	s2,128(a0)
    80002f76:	00091d63          	bnez	s2,80002f90 <bmap+0x6c>
      addr = balloc(ip->dev);
    80002f7a:	4108                	lw	a0,0(a0)
    80002f7c:	e89ff0ef          	jal	80002e04 <balloc>
    80002f80:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002f84:	02090d63          	beqz	s2,80002fbe <bmap+0x9a>
    80002f88:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f8a:	0929a023          	sw	s2,128(s3)
    80002f8e:	a011                	j	80002f92 <bmap+0x6e>
    80002f90:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f92:	85ca                	mv	a1,s2
    80002f94:	0009a503          	lw	a0,0(s3)
    80002f98:	c09ff0ef          	jal	80002ba0 <bread>
    80002f9c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002f9e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002fa2:	02049713          	slli	a4,s1,0x20
    80002fa6:	01e75593          	srli	a1,a4,0x1e
    80002faa:	00b784b3          	add	s1,a5,a1
    80002fae:	0004a903          	lw	s2,0(s1)
    80002fb2:	00090e63          	beqz	s2,80002fce <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002fb6:	8552                	mv	a0,s4
    80002fb8:	cf1ff0ef          	jal	80002ca8 <brelse>
    return addr;
    80002fbc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002fbe:	854a                	mv	a0,s2
    80002fc0:	70a2                	ld	ra,40(sp)
    80002fc2:	7402                	ld	s0,32(sp)
    80002fc4:	64e2                	ld	s1,24(sp)
    80002fc6:	6942                	ld	s2,16(sp)
    80002fc8:	69a2                	ld	s3,8(sp)
    80002fca:	6145                	addi	sp,sp,48
    80002fcc:	8082                	ret
      addr = balloc(ip->dev);
    80002fce:	0009a503          	lw	a0,0(s3)
    80002fd2:	e33ff0ef          	jal	80002e04 <balloc>
    80002fd6:	0005091b          	sext.w	s2,a0
      if(addr){
    80002fda:	fc090ee3          	beqz	s2,80002fb6 <bmap+0x92>
        a[bn] = addr;
    80002fde:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002fe2:	8552                	mv	a0,s4
    80002fe4:	50f000ef          	jal	80003cf2 <log_write>
    80002fe8:	b7f9                	j	80002fb6 <bmap+0x92>
    80002fea:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002fec:	00004517          	auipc	a0,0x4
    80002ff0:	4ac50513          	addi	a0,a0,1196 # 80007498 <etext+0x498>
    80002ff4:	fa0fd0ef          	jal	80000794 <panic>

0000000080002ff8 <iget>:
{
    80002ff8:	7179                	addi	sp,sp,-48
    80002ffa:	f406                	sd	ra,40(sp)
    80002ffc:	f022                	sd	s0,32(sp)
    80002ffe:	ec26                	sd	s1,24(sp)
    80003000:	e84a                	sd	s2,16(sp)
    80003002:	e44e                	sd	s3,8(sp)
    80003004:	e052                	sd	s4,0(sp)
    80003006:	1800                	addi	s0,sp,48
    80003008:	89aa                	mv	s3,a0
    8000300a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000300c:	0001b517          	auipc	a0,0x1b
    80003010:	f5c50513          	addi	a0,a0,-164 # 8001df68 <itable>
    80003014:	be1fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80003018:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000301a:	0001b497          	auipc	s1,0x1b
    8000301e:	f6648493          	addi	s1,s1,-154 # 8001df80 <itable+0x18>
    80003022:	0001d697          	auipc	a3,0x1d
    80003026:	9ee68693          	addi	a3,a3,-1554 # 8001fa10 <log>
    8000302a:	a039                	j	80003038 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000302c:	02090963          	beqz	s2,8000305e <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003030:	08848493          	addi	s1,s1,136
    80003034:	02d48863          	beq	s1,a3,80003064 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003038:	449c                	lw	a5,8(s1)
    8000303a:	fef059e3          	blez	a5,8000302c <iget+0x34>
    8000303e:	4098                	lw	a4,0(s1)
    80003040:	ff3716e3          	bne	a4,s3,8000302c <iget+0x34>
    80003044:	40d8                	lw	a4,4(s1)
    80003046:	ff4713e3          	bne	a4,s4,8000302c <iget+0x34>
      ip->ref++;
    8000304a:	2785                	addiw	a5,a5,1
    8000304c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000304e:	0001b517          	auipc	a0,0x1b
    80003052:	f1a50513          	addi	a0,a0,-230 # 8001df68 <itable>
    80003056:	c37fd0ef          	jal	80000c8c <release>
      return ip;
    8000305a:	8926                	mv	s2,s1
    8000305c:	a02d                	j	80003086 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000305e:	fbe9                	bnez	a5,80003030 <iget+0x38>
      empty = ip;
    80003060:	8926                	mv	s2,s1
    80003062:	b7f9                	j	80003030 <iget+0x38>
  if(empty == 0)
    80003064:	02090a63          	beqz	s2,80003098 <iget+0xa0>
  ip->dev = dev;
    80003068:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000306c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003070:	4785                	li	a5,1
    80003072:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003076:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000307a:	0001b517          	auipc	a0,0x1b
    8000307e:	eee50513          	addi	a0,a0,-274 # 8001df68 <itable>
    80003082:	c0bfd0ef          	jal	80000c8c <release>
}
    80003086:	854a                	mv	a0,s2
    80003088:	70a2                	ld	ra,40(sp)
    8000308a:	7402                	ld	s0,32(sp)
    8000308c:	64e2                	ld	s1,24(sp)
    8000308e:	6942                	ld	s2,16(sp)
    80003090:	69a2                	ld	s3,8(sp)
    80003092:	6a02                	ld	s4,0(sp)
    80003094:	6145                	addi	sp,sp,48
    80003096:	8082                	ret
    panic("iget: no inodes");
    80003098:	00004517          	auipc	a0,0x4
    8000309c:	41850513          	addi	a0,a0,1048 # 800074b0 <etext+0x4b0>
    800030a0:	ef4fd0ef          	jal	80000794 <panic>

00000000800030a4 <fsinit>:
fsinit(int dev) {
    800030a4:	7179                	addi	sp,sp,-48
    800030a6:	f406                	sd	ra,40(sp)
    800030a8:	f022                	sd	s0,32(sp)
    800030aa:	ec26                	sd	s1,24(sp)
    800030ac:	e84a                	sd	s2,16(sp)
    800030ae:	e44e                	sd	s3,8(sp)
    800030b0:	1800                	addi	s0,sp,48
    800030b2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800030b4:	4585                	li	a1,1
    800030b6:	aebff0ef          	jal	80002ba0 <bread>
    800030ba:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800030bc:	0001b997          	auipc	s3,0x1b
    800030c0:	e8c98993          	addi	s3,s3,-372 # 8001df48 <sb>
    800030c4:	02000613          	li	a2,32
    800030c8:	05850593          	addi	a1,a0,88
    800030cc:	854e                	mv	a0,s3
    800030ce:	c57fd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    800030d2:	8526                	mv	a0,s1
    800030d4:	bd5ff0ef          	jal	80002ca8 <brelse>
  if(sb.magic != FSMAGIC)
    800030d8:	0009a703          	lw	a4,0(s3)
    800030dc:	102037b7          	lui	a5,0x10203
    800030e0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800030e4:	02f71063          	bne	a4,a5,80003104 <fsinit+0x60>
  initlog(dev, &sb);
    800030e8:	0001b597          	auipc	a1,0x1b
    800030ec:	e6058593          	addi	a1,a1,-416 # 8001df48 <sb>
    800030f0:	854a                	mv	a0,s2
    800030f2:	1f9000ef          	jal	80003aea <initlog>
}
    800030f6:	70a2                	ld	ra,40(sp)
    800030f8:	7402                	ld	s0,32(sp)
    800030fa:	64e2                	ld	s1,24(sp)
    800030fc:	6942                	ld	s2,16(sp)
    800030fe:	69a2                	ld	s3,8(sp)
    80003100:	6145                	addi	sp,sp,48
    80003102:	8082                	ret
    panic("invalid file system");
    80003104:	00004517          	auipc	a0,0x4
    80003108:	3bc50513          	addi	a0,a0,956 # 800074c0 <etext+0x4c0>
    8000310c:	e88fd0ef          	jal	80000794 <panic>

0000000080003110 <iinit>:
{
    80003110:	7179                	addi	sp,sp,-48
    80003112:	f406                	sd	ra,40(sp)
    80003114:	f022                	sd	s0,32(sp)
    80003116:	ec26                	sd	s1,24(sp)
    80003118:	e84a                	sd	s2,16(sp)
    8000311a:	e44e                	sd	s3,8(sp)
    8000311c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000311e:	00004597          	auipc	a1,0x4
    80003122:	3ba58593          	addi	a1,a1,954 # 800074d8 <etext+0x4d8>
    80003126:	0001b517          	auipc	a0,0x1b
    8000312a:	e4250513          	addi	a0,a0,-446 # 8001df68 <itable>
    8000312e:	a47fd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003132:	0001b497          	auipc	s1,0x1b
    80003136:	e5e48493          	addi	s1,s1,-418 # 8001df90 <itable+0x28>
    8000313a:	0001d997          	auipc	s3,0x1d
    8000313e:	8e698993          	addi	s3,s3,-1818 # 8001fa20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003142:	00004917          	auipc	s2,0x4
    80003146:	39e90913          	addi	s2,s2,926 # 800074e0 <etext+0x4e0>
    8000314a:	85ca                	mv	a1,s2
    8000314c:	8526                	mv	a0,s1
    8000314e:	475000ef          	jal	80003dc2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003152:	08848493          	addi	s1,s1,136
    80003156:	ff349ae3          	bne	s1,s3,8000314a <iinit+0x3a>
}
    8000315a:	70a2                	ld	ra,40(sp)
    8000315c:	7402                	ld	s0,32(sp)
    8000315e:	64e2                	ld	s1,24(sp)
    80003160:	6942                	ld	s2,16(sp)
    80003162:	69a2                	ld	s3,8(sp)
    80003164:	6145                	addi	sp,sp,48
    80003166:	8082                	ret

0000000080003168 <ialloc>:
{
    80003168:	7139                	addi	sp,sp,-64
    8000316a:	fc06                	sd	ra,56(sp)
    8000316c:	f822                	sd	s0,48(sp)
    8000316e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003170:	0001b717          	auipc	a4,0x1b
    80003174:	de472703          	lw	a4,-540(a4) # 8001df54 <sb+0xc>
    80003178:	4785                	li	a5,1
    8000317a:	06e7f063          	bgeu	a5,a4,800031da <ialloc+0x72>
    8000317e:	f426                	sd	s1,40(sp)
    80003180:	f04a                	sd	s2,32(sp)
    80003182:	ec4e                	sd	s3,24(sp)
    80003184:	e852                	sd	s4,16(sp)
    80003186:	e456                	sd	s5,8(sp)
    80003188:	e05a                	sd	s6,0(sp)
    8000318a:	8aaa                	mv	s5,a0
    8000318c:	8b2e                	mv	s6,a1
    8000318e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003190:	0001ba17          	auipc	s4,0x1b
    80003194:	db8a0a13          	addi	s4,s4,-584 # 8001df48 <sb>
    80003198:	00495593          	srli	a1,s2,0x4
    8000319c:	018a2783          	lw	a5,24(s4)
    800031a0:	9dbd                	addw	a1,a1,a5
    800031a2:	8556                	mv	a0,s5
    800031a4:	9fdff0ef          	jal	80002ba0 <bread>
    800031a8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800031aa:	05850993          	addi	s3,a0,88
    800031ae:	00f97793          	andi	a5,s2,15
    800031b2:	079a                	slli	a5,a5,0x6
    800031b4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800031b6:	00099783          	lh	a5,0(s3)
    800031ba:	cb9d                	beqz	a5,800031f0 <ialloc+0x88>
    brelse(bp);
    800031bc:	aedff0ef          	jal	80002ca8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800031c0:	0905                	addi	s2,s2,1
    800031c2:	00ca2703          	lw	a4,12(s4)
    800031c6:	0009079b          	sext.w	a5,s2
    800031ca:	fce7e7e3          	bltu	a5,a4,80003198 <ialloc+0x30>
    800031ce:	74a2                	ld	s1,40(sp)
    800031d0:	7902                	ld	s2,32(sp)
    800031d2:	69e2                	ld	s3,24(sp)
    800031d4:	6a42                	ld	s4,16(sp)
    800031d6:	6aa2                	ld	s5,8(sp)
    800031d8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800031da:	00004517          	auipc	a0,0x4
    800031de:	30e50513          	addi	a0,a0,782 # 800074e8 <etext+0x4e8>
    800031e2:	ae0fd0ef          	jal	800004c2 <printf>
  return 0;
    800031e6:	4501                	li	a0,0
}
    800031e8:	70e2                	ld	ra,56(sp)
    800031ea:	7442                	ld	s0,48(sp)
    800031ec:	6121                	addi	sp,sp,64
    800031ee:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800031f0:	04000613          	li	a2,64
    800031f4:	4581                	li	a1,0
    800031f6:	854e                	mv	a0,s3
    800031f8:	ad1fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    800031fc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003200:	8526                	mv	a0,s1
    80003202:	2f1000ef          	jal	80003cf2 <log_write>
      brelse(bp);
    80003206:	8526                	mv	a0,s1
    80003208:	aa1ff0ef          	jal	80002ca8 <brelse>
      return iget(dev, inum);
    8000320c:	0009059b          	sext.w	a1,s2
    80003210:	8556                	mv	a0,s5
    80003212:	de7ff0ef          	jal	80002ff8 <iget>
    80003216:	74a2                	ld	s1,40(sp)
    80003218:	7902                	ld	s2,32(sp)
    8000321a:	69e2                	ld	s3,24(sp)
    8000321c:	6a42                	ld	s4,16(sp)
    8000321e:	6aa2                	ld	s5,8(sp)
    80003220:	6b02                	ld	s6,0(sp)
    80003222:	b7d9                	j	800031e8 <ialloc+0x80>

0000000080003224 <iupdate>:
{
    80003224:	1101                	addi	sp,sp,-32
    80003226:	ec06                	sd	ra,24(sp)
    80003228:	e822                	sd	s0,16(sp)
    8000322a:	e426                	sd	s1,8(sp)
    8000322c:	e04a                	sd	s2,0(sp)
    8000322e:	1000                	addi	s0,sp,32
    80003230:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003232:	415c                	lw	a5,4(a0)
    80003234:	0047d79b          	srliw	a5,a5,0x4
    80003238:	0001b597          	auipc	a1,0x1b
    8000323c:	d285a583          	lw	a1,-728(a1) # 8001df60 <sb+0x18>
    80003240:	9dbd                	addw	a1,a1,a5
    80003242:	4108                	lw	a0,0(a0)
    80003244:	95dff0ef          	jal	80002ba0 <bread>
    80003248:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000324a:	05850793          	addi	a5,a0,88
    8000324e:	40d8                	lw	a4,4(s1)
    80003250:	8b3d                	andi	a4,a4,15
    80003252:	071a                	slli	a4,a4,0x6
    80003254:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003256:	04449703          	lh	a4,68(s1)
    8000325a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000325e:	04649703          	lh	a4,70(s1)
    80003262:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003266:	04849703          	lh	a4,72(s1)
    8000326a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000326e:	04a49703          	lh	a4,74(s1)
    80003272:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003276:	44f8                	lw	a4,76(s1)
    80003278:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000327a:	03400613          	li	a2,52
    8000327e:	05048593          	addi	a1,s1,80
    80003282:	00c78513          	addi	a0,a5,12
    80003286:	a9ffd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    8000328a:	854a                	mv	a0,s2
    8000328c:	267000ef          	jal	80003cf2 <log_write>
  brelse(bp);
    80003290:	854a                	mv	a0,s2
    80003292:	a17ff0ef          	jal	80002ca8 <brelse>
}
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	64a2                	ld	s1,8(sp)
    8000329c:	6902                	ld	s2,0(sp)
    8000329e:	6105                	addi	sp,sp,32
    800032a0:	8082                	ret

00000000800032a2 <idup>:
{
    800032a2:	1101                	addi	sp,sp,-32
    800032a4:	ec06                	sd	ra,24(sp)
    800032a6:	e822                	sd	s0,16(sp)
    800032a8:	e426                	sd	s1,8(sp)
    800032aa:	1000                	addi	s0,sp,32
    800032ac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800032ae:	0001b517          	auipc	a0,0x1b
    800032b2:	cba50513          	addi	a0,a0,-838 # 8001df68 <itable>
    800032b6:	93ffd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800032ba:	449c                	lw	a5,8(s1)
    800032bc:	2785                	addiw	a5,a5,1
    800032be:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800032c0:	0001b517          	auipc	a0,0x1b
    800032c4:	ca850513          	addi	a0,a0,-856 # 8001df68 <itable>
    800032c8:	9c5fd0ef          	jal	80000c8c <release>
}
    800032cc:	8526                	mv	a0,s1
    800032ce:	60e2                	ld	ra,24(sp)
    800032d0:	6442                	ld	s0,16(sp)
    800032d2:	64a2                	ld	s1,8(sp)
    800032d4:	6105                	addi	sp,sp,32
    800032d6:	8082                	ret

00000000800032d8 <ilock>:
{
    800032d8:	1101                	addi	sp,sp,-32
    800032da:	ec06                	sd	ra,24(sp)
    800032dc:	e822                	sd	s0,16(sp)
    800032de:	e426                	sd	s1,8(sp)
    800032e0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800032e2:	cd19                	beqz	a0,80003300 <ilock+0x28>
    800032e4:	84aa                	mv	s1,a0
    800032e6:	451c                	lw	a5,8(a0)
    800032e8:	00f05c63          	blez	a5,80003300 <ilock+0x28>
  acquiresleep(&ip->lock);
    800032ec:	0541                	addi	a0,a0,16
    800032ee:	30b000ef          	jal	80003df8 <acquiresleep>
  if(ip->valid == 0){
    800032f2:	40bc                	lw	a5,64(s1)
    800032f4:	cf89                	beqz	a5,8000330e <ilock+0x36>
}
    800032f6:	60e2                	ld	ra,24(sp)
    800032f8:	6442                	ld	s0,16(sp)
    800032fa:	64a2                	ld	s1,8(sp)
    800032fc:	6105                	addi	sp,sp,32
    800032fe:	8082                	ret
    80003300:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003302:	00004517          	auipc	a0,0x4
    80003306:	1fe50513          	addi	a0,a0,510 # 80007500 <etext+0x500>
    8000330a:	c8afd0ef          	jal	80000794 <panic>
    8000330e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003310:	40dc                	lw	a5,4(s1)
    80003312:	0047d79b          	srliw	a5,a5,0x4
    80003316:	0001b597          	auipc	a1,0x1b
    8000331a:	c4a5a583          	lw	a1,-950(a1) # 8001df60 <sb+0x18>
    8000331e:	9dbd                	addw	a1,a1,a5
    80003320:	4088                	lw	a0,0(s1)
    80003322:	87fff0ef          	jal	80002ba0 <bread>
    80003326:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003328:	05850593          	addi	a1,a0,88
    8000332c:	40dc                	lw	a5,4(s1)
    8000332e:	8bbd                	andi	a5,a5,15
    80003330:	079a                	slli	a5,a5,0x6
    80003332:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003334:	00059783          	lh	a5,0(a1)
    80003338:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000333c:	00259783          	lh	a5,2(a1)
    80003340:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003344:	00459783          	lh	a5,4(a1)
    80003348:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000334c:	00659783          	lh	a5,6(a1)
    80003350:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003354:	459c                	lw	a5,8(a1)
    80003356:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003358:	03400613          	li	a2,52
    8000335c:	05b1                	addi	a1,a1,12
    8000335e:	05048513          	addi	a0,s1,80
    80003362:	9c3fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003366:	854a                	mv	a0,s2
    80003368:	941ff0ef          	jal	80002ca8 <brelse>
    ip->valid = 1;
    8000336c:	4785                	li	a5,1
    8000336e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003370:	04449783          	lh	a5,68(s1)
    80003374:	c399                	beqz	a5,8000337a <ilock+0xa2>
    80003376:	6902                	ld	s2,0(sp)
    80003378:	bfbd                	j	800032f6 <ilock+0x1e>
      panic("ilock: no type");
    8000337a:	00004517          	auipc	a0,0x4
    8000337e:	18e50513          	addi	a0,a0,398 # 80007508 <etext+0x508>
    80003382:	c12fd0ef          	jal	80000794 <panic>

0000000080003386 <iunlock>:
{
    80003386:	1101                	addi	sp,sp,-32
    80003388:	ec06                	sd	ra,24(sp)
    8000338a:	e822                	sd	s0,16(sp)
    8000338c:	e426                	sd	s1,8(sp)
    8000338e:	e04a                	sd	s2,0(sp)
    80003390:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003392:	c505                	beqz	a0,800033ba <iunlock+0x34>
    80003394:	84aa                	mv	s1,a0
    80003396:	01050913          	addi	s2,a0,16
    8000339a:	854a                	mv	a0,s2
    8000339c:	2db000ef          	jal	80003e76 <holdingsleep>
    800033a0:	cd09                	beqz	a0,800033ba <iunlock+0x34>
    800033a2:	449c                	lw	a5,8(s1)
    800033a4:	00f05b63          	blez	a5,800033ba <iunlock+0x34>
  releasesleep(&ip->lock);
    800033a8:	854a                	mv	a0,s2
    800033aa:	295000ef          	jal	80003e3e <releasesleep>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	64a2                	ld	s1,8(sp)
    800033b4:	6902                	ld	s2,0(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret
    panic("iunlock");
    800033ba:	00004517          	auipc	a0,0x4
    800033be:	15e50513          	addi	a0,a0,350 # 80007518 <etext+0x518>
    800033c2:	bd2fd0ef          	jal	80000794 <panic>

00000000800033c6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800033c6:	7179                	addi	sp,sp,-48
    800033c8:	f406                	sd	ra,40(sp)
    800033ca:	f022                	sd	s0,32(sp)
    800033cc:	ec26                	sd	s1,24(sp)
    800033ce:	e84a                	sd	s2,16(sp)
    800033d0:	e44e                	sd	s3,8(sp)
    800033d2:	1800                	addi	s0,sp,48
    800033d4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800033d6:	05050493          	addi	s1,a0,80
    800033da:	08050913          	addi	s2,a0,128
    800033de:	a021                	j	800033e6 <itrunc+0x20>
    800033e0:	0491                	addi	s1,s1,4
    800033e2:	01248b63          	beq	s1,s2,800033f8 <itrunc+0x32>
    if(ip->addrs[i]){
    800033e6:	408c                	lw	a1,0(s1)
    800033e8:	dde5                	beqz	a1,800033e0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800033ea:	0009a503          	lw	a0,0(s3)
    800033ee:	9abff0ef          	jal	80002d98 <bfree>
      ip->addrs[i] = 0;
    800033f2:	0004a023          	sw	zero,0(s1)
    800033f6:	b7ed                	j	800033e0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800033f8:	0809a583          	lw	a1,128(s3)
    800033fc:	ed89                	bnez	a1,80003416 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800033fe:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003402:	854e                	mv	a0,s3
    80003404:	e21ff0ef          	jal	80003224 <iupdate>
}
    80003408:	70a2                	ld	ra,40(sp)
    8000340a:	7402                	ld	s0,32(sp)
    8000340c:	64e2                	ld	s1,24(sp)
    8000340e:	6942                	ld	s2,16(sp)
    80003410:	69a2                	ld	s3,8(sp)
    80003412:	6145                	addi	sp,sp,48
    80003414:	8082                	ret
    80003416:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003418:	0009a503          	lw	a0,0(s3)
    8000341c:	f84ff0ef          	jal	80002ba0 <bread>
    80003420:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003422:	05850493          	addi	s1,a0,88
    80003426:	45850913          	addi	s2,a0,1112
    8000342a:	a021                	j	80003432 <itrunc+0x6c>
    8000342c:	0491                	addi	s1,s1,4
    8000342e:	01248963          	beq	s1,s2,80003440 <itrunc+0x7a>
      if(a[j])
    80003432:	408c                	lw	a1,0(s1)
    80003434:	dde5                	beqz	a1,8000342c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003436:	0009a503          	lw	a0,0(s3)
    8000343a:	95fff0ef          	jal	80002d98 <bfree>
    8000343e:	b7fd                	j	8000342c <itrunc+0x66>
    brelse(bp);
    80003440:	8552                	mv	a0,s4
    80003442:	867ff0ef          	jal	80002ca8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003446:	0809a583          	lw	a1,128(s3)
    8000344a:	0009a503          	lw	a0,0(s3)
    8000344e:	94bff0ef          	jal	80002d98 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003452:	0809a023          	sw	zero,128(s3)
    80003456:	6a02                	ld	s4,0(sp)
    80003458:	b75d                	j	800033fe <itrunc+0x38>

000000008000345a <iput>:
{
    8000345a:	1101                	addi	sp,sp,-32
    8000345c:	ec06                	sd	ra,24(sp)
    8000345e:	e822                	sd	s0,16(sp)
    80003460:	e426                	sd	s1,8(sp)
    80003462:	1000                	addi	s0,sp,32
    80003464:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003466:	0001b517          	auipc	a0,0x1b
    8000346a:	b0250513          	addi	a0,a0,-1278 # 8001df68 <itable>
    8000346e:	f86fd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003472:	4498                	lw	a4,8(s1)
    80003474:	4785                	li	a5,1
    80003476:	02f70063          	beq	a4,a5,80003496 <iput+0x3c>
  ip->ref--;
    8000347a:	449c                	lw	a5,8(s1)
    8000347c:	37fd                	addiw	a5,a5,-1
    8000347e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003480:	0001b517          	auipc	a0,0x1b
    80003484:	ae850513          	addi	a0,a0,-1304 # 8001df68 <itable>
    80003488:	805fd0ef          	jal	80000c8c <release>
}
    8000348c:	60e2                	ld	ra,24(sp)
    8000348e:	6442                	ld	s0,16(sp)
    80003490:	64a2                	ld	s1,8(sp)
    80003492:	6105                	addi	sp,sp,32
    80003494:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003496:	40bc                	lw	a5,64(s1)
    80003498:	d3ed                	beqz	a5,8000347a <iput+0x20>
    8000349a:	04a49783          	lh	a5,74(s1)
    8000349e:	fff1                	bnez	a5,8000347a <iput+0x20>
    800034a0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800034a2:	01048913          	addi	s2,s1,16
    800034a6:	854a                	mv	a0,s2
    800034a8:	151000ef          	jal	80003df8 <acquiresleep>
    release(&itable.lock);
    800034ac:	0001b517          	auipc	a0,0x1b
    800034b0:	abc50513          	addi	a0,a0,-1348 # 8001df68 <itable>
    800034b4:	fd8fd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800034b8:	8526                	mv	a0,s1
    800034ba:	f0dff0ef          	jal	800033c6 <itrunc>
    ip->type = 0;
    800034be:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800034c2:	8526                	mv	a0,s1
    800034c4:	d61ff0ef          	jal	80003224 <iupdate>
    ip->valid = 0;
    800034c8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800034cc:	854a                	mv	a0,s2
    800034ce:	171000ef          	jal	80003e3e <releasesleep>
    acquire(&itable.lock);
    800034d2:	0001b517          	auipc	a0,0x1b
    800034d6:	a9650513          	addi	a0,a0,-1386 # 8001df68 <itable>
    800034da:	f1afd0ef          	jal	80000bf4 <acquire>
    800034de:	6902                	ld	s2,0(sp)
    800034e0:	bf69                	j	8000347a <iput+0x20>

00000000800034e2 <iunlockput>:
{
    800034e2:	1101                	addi	sp,sp,-32
    800034e4:	ec06                	sd	ra,24(sp)
    800034e6:	e822                	sd	s0,16(sp)
    800034e8:	e426                	sd	s1,8(sp)
    800034ea:	1000                	addi	s0,sp,32
    800034ec:	84aa                	mv	s1,a0
  iunlock(ip);
    800034ee:	e99ff0ef          	jal	80003386 <iunlock>
  iput(ip);
    800034f2:	8526                	mv	a0,s1
    800034f4:	f67ff0ef          	jal	8000345a <iput>
}
    800034f8:	60e2                	ld	ra,24(sp)
    800034fa:	6442                	ld	s0,16(sp)
    800034fc:	64a2                	ld	s1,8(sp)
    800034fe:	6105                	addi	sp,sp,32
    80003500:	8082                	ret

0000000080003502 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003502:	1141                	addi	sp,sp,-16
    80003504:	e422                	sd	s0,8(sp)
    80003506:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003508:	411c                	lw	a5,0(a0)
    8000350a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000350c:	415c                	lw	a5,4(a0)
    8000350e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003510:	04451783          	lh	a5,68(a0)
    80003514:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003518:	04a51783          	lh	a5,74(a0)
    8000351c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003520:	04c56783          	lwu	a5,76(a0)
    80003524:	e99c                	sd	a5,16(a1)
}
    80003526:	6422                	ld	s0,8(sp)
    80003528:	0141                	addi	sp,sp,16
    8000352a:	8082                	ret

000000008000352c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000352c:	457c                	lw	a5,76(a0)
    8000352e:	0ed7eb63          	bltu	a5,a3,80003624 <readi+0xf8>
{
    80003532:	7159                	addi	sp,sp,-112
    80003534:	f486                	sd	ra,104(sp)
    80003536:	f0a2                	sd	s0,96(sp)
    80003538:	eca6                	sd	s1,88(sp)
    8000353a:	e0d2                	sd	s4,64(sp)
    8000353c:	fc56                	sd	s5,56(sp)
    8000353e:	f85a                	sd	s6,48(sp)
    80003540:	f45e                	sd	s7,40(sp)
    80003542:	1880                	addi	s0,sp,112
    80003544:	8b2a                	mv	s6,a0
    80003546:	8bae                	mv	s7,a1
    80003548:	8a32                	mv	s4,a2
    8000354a:	84b6                	mv	s1,a3
    8000354c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000354e:	9f35                	addw	a4,a4,a3
    return 0;
    80003550:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003552:	0cd76063          	bltu	a4,a3,80003612 <readi+0xe6>
    80003556:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003558:	00e7f463          	bgeu	a5,a4,80003560 <readi+0x34>
    n = ip->size - off;
    8000355c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003560:	080a8f63          	beqz	s5,800035fe <readi+0xd2>
    80003564:	e8ca                	sd	s2,80(sp)
    80003566:	f062                	sd	s8,32(sp)
    80003568:	ec66                	sd	s9,24(sp)
    8000356a:	e86a                	sd	s10,16(sp)
    8000356c:	e46e                	sd	s11,8(sp)
    8000356e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003570:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003574:	5c7d                	li	s8,-1
    80003576:	a80d                	j	800035a8 <readi+0x7c>
    80003578:	020d1d93          	slli	s11,s10,0x20
    8000357c:	020ddd93          	srli	s11,s11,0x20
    80003580:	05890613          	addi	a2,s2,88
    80003584:	86ee                	mv	a3,s11
    80003586:	963a                	add	a2,a2,a4
    80003588:	85d2                	mv	a1,s4
    8000358a:	855e                	mv	a0,s7
    8000358c:	d09fe0ef          	jal	80002294 <either_copyout>
    80003590:	05850763          	beq	a0,s8,800035de <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003594:	854a                	mv	a0,s2
    80003596:	f12ff0ef          	jal	80002ca8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000359a:	013d09bb          	addw	s3,s10,s3
    8000359e:	009d04bb          	addw	s1,s10,s1
    800035a2:	9a6e                	add	s4,s4,s11
    800035a4:	0559f763          	bgeu	s3,s5,800035f2 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800035a8:	00a4d59b          	srliw	a1,s1,0xa
    800035ac:	855a                	mv	a0,s6
    800035ae:	977ff0ef          	jal	80002f24 <bmap>
    800035b2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800035b6:	c5b1                	beqz	a1,80003602 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800035b8:	000b2503          	lw	a0,0(s6)
    800035bc:	de4ff0ef          	jal	80002ba0 <bread>
    800035c0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800035c2:	3ff4f713          	andi	a4,s1,1023
    800035c6:	40ec87bb          	subw	a5,s9,a4
    800035ca:	413a86bb          	subw	a3,s5,s3
    800035ce:	8d3e                	mv	s10,a5
    800035d0:	2781                	sext.w	a5,a5
    800035d2:	0006861b          	sext.w	a2,a3
    800035d6:	faf671e3          	bgeu	a2,a5,80003578 <readi+0x4c>
    800035da:	8d36                	mv	s10,a3
    800035dc:	bf71                	j	80003578 <readi+0x4c>
      brelse(bp);
    800035de:	854a                	mv	a0,s2
    800035e0:	ec8ff0ef          	jal	80002ca8 <brelse>
      tot = -1;
    800035e4:	59fd                	li	s3,-1
      break;
    800035e6:	6946                	ld	s2,80(sp)
    800035e8:	7c02                	ld	s8,32(sp)
    800035ea:	6ce2                	ld	s9,24(sp)
    800035ec:	6d42                	ld	s10,16(sp)
    800035ee:	6da2                	ld	s11,8(sp)
    800035f0:	a831                	j	8000360c <readi+0xe0>
    800035f2:	6946                	ld	s2,80(sp)
    800035f4:	7c02                	ld	s8,32(sp)
    800035f6:	6ce2                	ld	s9,24(sp)
    800035f8:	6d42                	ld	s10,16(sp)
    800035fa:	6da2                	ld	s11,8(sp)
    800035fc:	a801                	j	8000360c <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800035fe:	89d6                	mv	s3,s5
    80003600:	a031                	j	8000360c <readi+0xe0>
    80003602:	6946                	ld	s2,80(sp)
    80003604:	7c02                	ld	s8,32(sp)
    80003606:	6ce2                	ld	s9,24(sp)
    80003608:	6d42                	ld	s10,16(sp)
    8000360a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000360c:	0009851b          	sext.w	a0,s3
    80003610:	69a6                	ld	s3,72(sp)
}
    80003612:	70a6                	ld	ra,104(sp)
    80003614:	7406                	ld	s0,96(sp)
    80003616:	64e6                	ld	s1,88(sp)
    80003618:	6a06                	ld	s4,64(sp)
    8000361a:	7ae2                	ld	s5,56(sp)
    8000361c:	7b42                	ld	s6,48(sp)
    8000361e:	7ba2                	ld	s7,40(sp)
    80003620:	6165                	addi	sp,sp,112
    80003622:	8082                	ret
    return 0;
    80003624:	4501                	li	a0,0
}
    80003626:	8082                	ret

0000000080003628 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003628:	457c                	lw	a5,76(a0)
    8000362a:	10d7e063          	bltu	a5,a3,8000372a <writei+0x102>
{
    8000362e:	7159                	addi	sp,sp,-112
    80003630:	f486                	sd	ra,104(sp)
    80003632:	f0a2                	sd	s0,96(sp)
    80003634:	e8ca                	sd	s2,80(sp)
    80003636:	e0d2                	sd	s4,64(sp)
    80003638:	fc56                	sd	s5,56(sp)
    8000363a:	f85a                	sd	s6,48(sp)
    8000363c:	f45e                	sd	s7,40(sp)
    8000363e:	1880                	addi	s0,sp,112
    80003640:	8aaa                	mv	s5,a0
    80003642:	8bae                	mv	s7,a1
    80003644:	8a32                	mv	s4,a2
    80003646:	8936                	mv	s2,a3
    80003648:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000364a:	00e687bb          	addw	a5,a3,a4
    8000364e:	0ed7e063          	bltu	a5,a3,8000372e <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003652:	00043737          	lui	a4,0x43
    80003656:	0cf76e63          	bltu	a4,a5,80003732 <writei+0x10a>
    8000365a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000365c:	0a0b0f63          	beqz	s6,8000371a <writei+0xf2>
    80003660:	eca6                	sd	s1,88(sp)
    80003662:	f062                	sd	s8,32(sp)
    80003664:	ec66                	sd	s9,24(sp)
    80003666:	e86a                	sd	s10,16(sp)
    80003668:	e46e                	sd	s11,8(sp)
    8000366a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000366c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003670:	5c7d                	li	s8,-1
    80003672:	a825                	j	800036aa <writei+0x82>
    80003674:	020d1d93          	slli	s11,s10,0x20
    80003678:	020ddd93          	srli	s11,s11,0x20
    8000367c:	05848513          	addi	a0,s1,88
    80003680:	86ee                	mv	a3,s11
    80003682:	8652                	mv	a2,s4
    80003684:	85de                	mv	a1,s7
    80003686:	953a                	add	a0,a0,a4
    80003688:	c57fe0ef          	jal	800022de <either_copyin>
    8000368c:	05850a63          	beq	a0,s8,800036e0 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003690:	8526                	mv	a0,s1
    80003692:	660000ef          	jal	80003cf2 <log_write>
    brelse(bp);
    80003696:	8526                	mv	a0,s1
    80003698:	e10ff0ef          	jal	80002ca8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000369c:	013d09bb          	addw	s3,s10,s3
    800036a0:	012d093b          	addw	s2,s10,s2
    800036a4:	9a6e                	add	s4,s4,s11
    800036a6:	0569f063          	bgeu	s3,s6,800036e6 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800036aa:	00a9559b          	srliw	a1,s2,0xa
    800036ae:	8556                	mv	a0,s5
    800036b0:	875ff0ef          	jal	80002f24 <bmap>
    800036b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800036b8:	c59d                	beqz	a1,800036e6 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800036ba:	000aa503          	lw	a0,0(s5)
    800036be:	ce2ff0ef          	jal	80002ba0 <bread>
    800036c2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800036c4:	3ff97713          	andi	a4,s2,1023
    800036c8:	40ec87bb          	subw	a5,s9,a4
    800036cc:	413b06bb          	subw	a3,s6,s3
    800036d0:	8d3e                	mv	s10,a5
    800036d2:	2781                	sext.w	a5,a5
    800036d4:	0006861b          	sext.w	a2,a3
    800036d8:	f8f67ee3          	bgeu	a2,a5,80003674 <writei+0x4c>
    800036dc:	8d36                	mv	s10,a3
    800036de:	bf59                	j	80003674 <writei+0x4c>
      brelse(bp);
    800036e0:	8526                	mv	a0,s1
    800036e2:	dc6ff0ef          	jal	80002ca8 <brelse>
  }

  if(off > ip->size)
    800036e6:	04caa783          	lw	a5,76(s5)
    800036ea:	0327fa63          	bgeu	a5,s2,8000371e <writei+0xf6>
    ip->size = off;
    800036ee:	052aa623          	sw	s2,76(s5)
    800036f2:	64e6                	ld	s1,88(sp)
    800036f4:	7c02                	ld	s8,32(sp)
    800036f6:	6ce2                	ld	s9,24(sp)
    800036f8:	6d42                	ld	s10,16(sp)
    800036fa:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800036fc:	8556                	mv	a0,s5
    800036fe:	b27ff0ef          	jal	80003224 <iupdate>

  return tot;
    80003702:	0009851b          	sext.w	a0,s3
    80003706:	69a6                	ld	s3,72(sp)
}
    80003708:	70a6                	ld	ra,104(sp)
    8000370a:	7406                	ld	s0,96(sp)
    8000370c:	6946                	ld	s2,80(sp)
    8000370e:	6a06                	ld	s4,64(sp)
    80003710:	7ae2                	ld	s5,56(sp)
    80003712:	7b42                	ld	s6,48(sp)
    80003714:	7ba2                	ld	s7,40(sp)
    80003716:	6165                	addi	sp,sp,112
    80003718:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000371a:	89da                	mv	s3,s6
    8000371c:	b7c5                	j	800036fc <writei+0xd4>
    8000371e:	64e6                	ld	s1,88(sp)
    80003720:	7c02                	ld	s8,32(sp)
    80003722:	6ce2                	ld	s9,24(sp)
    80003724:	6d42                	ld	s10,16(sp)
    80003726:	6da2                	ld	s11,8(sp)
    80003728:	bfd1                	j	800036fc <writei+0xd4>
    return -1;
    8000372a:	557d                	li	a0,-1
}
    8000372c:	8082                	ret
    return -1;
    8000372e:	557d                	li	a0,-1
    80003730:	bfe1                	j	80003708 <writei+0xe0>
    return -1;
    80003732:	557d                	li	a0,-1
    80003734:	bfd1                	j	80003708 <writei+0xe0>

0000000080003736 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003736:	1141                	addi	sp,sp,-16
    80003738:	e406                	sd	ra,8(sp)
    8000373a:	e022                	sd	s0,0(sp)
    8000373c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000373e:	4639                	li	a2,14
    80003740:	e54fd0ef          	jal	80000d94 <strncmp>
}
    80003744:	60a2                	ld	ra,8(sp)
    80003746:	6402                	ld	s0,0(sp)
    80003748:	0141                	addi	sp,sp,16
    8000374a:	8082                	ret

000000008000374c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000374c:	7139                	addi	sp,sp,-64
    8000374e:	fc06                	sd	ra,56(sp)
    80003750:	f822                	sd	s0,48(sp)
    80003752:	f426                	sd	s1,40(sp)
    80003754:	f04a                	sd	s2,32(sp)
    80003756:	ec4e                	sd	s3,24(sp)
    80003758:	e852                	sd	s4,16(sp)
    8000375a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000375c:	04451703          	lh	a4,68(a0)
    80003760:	4785                	li	a5,1
    80003762:	00f71a63          	bne	a4,a5,80003776 <dirlookup+0x2a>
    80003766:	892a                	mv	s2,a0
    80003768:	89ae                	mv	s3,a1
    8000376a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000376c:	457c                	lw	a5,76(a0)
    8000376e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003770:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003772:	e39d                	bnez	a5,80003798 <dirlookup+0x4c>
    80003774:	a095                	j	800037d8 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003776:	00004517          	auipc	a0,0x4
    8000377a:	daa50513          	addi	a0,a0,-598 # 80007520 <etext+0x520>
    8000377e:	816fd0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003782:	00004517          	auipc	a0,0x4
    80003786:	db650513          	addi	a0,a0,-586 # 80007538 <etext+0x538>
    8000378a:	80afd0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000378e:	24c1                	addiw	s1,s1,16
    80003790:	04c92783          	lw	a5,76(s2)
    80003794:	04f4f163          	bgeu	s1,a5,800037d6 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003798:	4741                	li	a4,16
    8000379a:	86a6                	mv	a3,s1
    8000379c:	fc040613          	addi	a2,s0,-64
    800037a0:	4581                	li	a1,0
    800037a2:	854a                	mv	a0,s2
    800037a4:	d89ff0ef          	jal	8000352c <readi>
    800037a8:	47c1                	li	a5,16
    800037aa:	fcf51ce3          	bne	a0,a5,80003782 <dirlookup+0x36>
    if(de.inum == 0)
    800037ae:	fc045783          	lhu	a5,-64(s0)
    800037b2:	dff1                	beqz	a5,8000378e <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800037b4:	fc240593          	addi	a1,s0,-62
    800037b8:	854e                	mv	a0,s3
    800037ba:	f7dff0ef          	jal	80003736 <namecmp>
    800037be:	f961                	bnez	a0,8000378e <dirlookup+0x42>
      if(poff)
    800037c0:	000a0463          	beqz	s4,800037c8 <dirlookup+0x7c>
        *poff = off;
    800037c4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800037c8:	fc045583          	lhu	a1,-64(s0)
    800037cc:	00092503          	lw	a0,0(s2)
    800037d0:	829ff0ef          	jal	80002ff8 <iget>
    800037d4:	a011                	j	800037d8 <dirlookup+0x8c>
  return 0;
    800037d6:	4501                	li	a0,0
}
    800037d8:	70e2                	ld	ra,56(sp)
    800037da:	7442                	ld	s0,48(sp)
    800037dc:	74a2                	ld	s1,40(sp)
    800037de:	7902                	ld	s2,32(sp)
    800037e0:	69e2                	ld	s3,24(sp)
    800037e2:	6a42                	ld	s4,16(sp)
    800037e4:	6121                	addi	sp,sp,64
    800037e6:	8082                	ret

00000000800037e8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800037e8:	711d                	addi	sp,sp,-96
    800037ea:	ec86                	sd	ra,88(sp)
    800037ec:	e8a2                	sd	s0,80(sp)
    800037ee:	e4a6                	sd	s1,72(sp)
    800037f0:	e0ca                	sd	s2,64(sp)
    800037f2:	fc4e                	sd	s3,56(sp)
    800037f4:	f852                	sd	s4,48(sp)
    800037f6:	f456                	sd	s5,40(sp)
    800037f8:	f05a                	sd	s6,32(sp)
    800037fa:	ec5e                	sd	s7,24(sp)
    800037fc:	e862                	sd	s8,16(sp)
    800037fe:	e466                	sd	s9,8(sp)
    80003800:	1080                	addi	s0,sp,96
    80003802:	84aa                	mv	s1,a0
    80003804:	8b2e                	mv	s6,a1
    80003806:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003808:	00054703          	lbu	a4,0(a0)
    8000380c:	02f00793          	li	a5,47
    80003810:	00f70e63          	beq	a4,a5,8000382c <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003814:	8ccfe0ef          	jal	800018e0 <myproc>
    80003818:	15053503          	ld	a0,336(a0)
    8000381c:	a87ff0ef          	jal	800032a2 <idup>
    80003820:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003822:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003826:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003828:	4b85                	li	s7,1
    8000382a:	a871                	j	800038c6 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    8000382c:	4585                	li	a1,1
    8000382e:	4505                	li	a0,1
    80003830:	fc8ff0ef          	jal	80002ff8 <iget>
    80003834:	8a2a                	mv	s4,a0
    80003836:	b7f5                	j	80003822 <namex+0x3a>
      iunlockput(ip);
    80003838:	8552                	mv	a0,s4
    8000383a:	ca9ff0ef          	jal	800034e2 <iunlockput>
      return 0;
    8000383e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003840:	8552                	mv	a0,s4
    80003842:	60e6                	ld	ra,88(sp)
    80003844:	6446                	ld	s0,80(sp)
    80003846:	64a6                	ld	s1,72(sp)
    80003848:	6906                	ld	s2,64(sp)
    8000384a:	79e2                	ld	s3,56(sp)
    8000384c:	7a42                	ld	s4,48(sp)
    8000384e:	7aa2                	ld	s5,40(sp)
    80003850:	7b02                	ld	s6,32(sp)
    80003852:	6be2                	ld	s7,24(sp)
    80003854:	6c42                	ld	s8,16(sp)
    80003856:	6ca2                	ld	s9,8(sp)
    80003858:	6125                	addi	sp,sp,96
    8000385a:	8082                	ret
      iunlock(ip);
    8000385c:	8552                	mv	a0,s4
    8000385e:	b29ff0ef          	jal	80003386 <iunlock>
      return ip;
    80003862:	bff9                	j	80003840 <namex+0x58>
      iunlockput(ip);
    80003864:	8552                	mv	a0,s4
    80003866:	c7dff0ef          	jal	800034e2 <iunlockput>
      return 0;
    8000386a:	8a4e                	mv	s4,s3
    8000386c:	bfd1                	j	80003840 <namex+0x58>
  len = path - s;
    8000386e:	40998633          	sub	a2,s3,s1
    80003872:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003876:	099c5063          	bge	s8,s9,800038f6 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    8000387a:	4639                	li	a2,14
    8000387c:	85a6                	mv	a1,s1
    8000387e:	8556                	mv	a0,s5
    80003880:	ca4fd0ef          	jal	80000d24 <memmove>
    80003884:	84ce                	mv	s1,s3
  while(*path == '/')
    80003886:	0004c783          	lbu	a5,0(s1)
    8000388a:	01279763          	bne	a5,s2,80003898 <namex+0xb0>
    path++;
    8000388e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003890:	0004c783          	lbu	a5,0(s1)
    80003894:	ff278de3          	beq	a5,s2,8000388e <namex+0xa6>
    ilock(ip);
    80003898:	8552                	mv	a0,s4
    8000389a:	a3fff0ef          	jal	800032d8 <ilock>
    if(ip->type != T_DIR){
    8000389e:	044a1783          	lh	a5,68(s4)
    800038a2:	f9779be3          	bne	a5,s7,80003838 <namex+0x50>
    if(nameiparent && *path == '\0'){
    800038a6:	000b0563          	beqz	s6,800038b0 <namex+0xc8>
    800038aa:	0004c783          	lbu	a5,0(s1)
    800038ae:	d7dd                	beqz	a5,8000385c <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    800038b0:	4601                	li	a2,0
    800038b2:	85d6                	mv	a1,s5
    800038b4:	8552                	mv	a0,s4
    800038b6:	e97ff0ef          	jal	8000374c <dirlookup>
    800038ba:	89aa                	mv	s3,a0
    800038bc:	d545                	beqz	a0,80003864 <namex+0x7c>
    iunlockput(ip);
    800038be:	8552                	mv	a0,s4
    800038c0:	c23ff0ef          	jal	800034e2 <iunlockput>
    ip = next;
    800038c4:	8a4e                	mv	s4,s3
  while(*path == '/')
    800038c6:	0004c783          	lbu	a5,0(s1)
    800038ca:	01279763          	bne	a5,s2,800038d8 <namex+0xf0>
    path++;
    800038ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800038d0:	0004c783          	lbu	a5,0(s1)
    800038d4:	ff278de3          	beq	a5,s2,800038ce <namex+0xe6>
  if(*path == 0)
    800038d8:	cb8d                	beqz	a5,8000390a <namex+0x122>
  while(*path != '/' && *path != 0)
    800038da:	0004c783          	lbu	a5,0(s1)
    800038de:	89a6                	mv	s3,s1
  len = path - s;
    800038e0:	4c81                	li	s9,0
    800038e2:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800038e4:	01278963          	beq	a5,s2,800038f6 <namex+0x10e>
    800038e8:	d3d9                	beqz	a5,8000386e <namex+0x86>
    path++;
    800038ea:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800038ec:	0009c783          	lbu	a5,0(s3)
    800038f0:	ff279ce3          	bne	a5,s2,800038e8 <namex+0x100>
    800038f4:	bfad                	j	8000386e <namex+0x86>
    memmove(name, s, len);
    800038f6:	2601                	sext.w	a2,a2
    800038f8:	85a6                	mv	a1,s1
    800038fa:	8556                	mv	a0,s5
    800038fc:	c28fd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003900:	9cd6                	add	s9,s9,s5
    80003902:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003906:	84ce                	mv	s1,s3
    80003908:	bfbd                	j	80003886 <namex+0x9e>
  if(nameiparent){
    8000390a:	f20b0be3          	beqz	s6,80003840 <namex+0x58>
    iput(ip);
    8000390e:	8552                	mv	a0,s4
    80003910:	b4bff0ef          	jal	8000345a <iput>
    return 0;
    80003914:	4a01                	li	s4,0
    80003916:	b72d                	j	80003840 <namex+0x58>

0000000080003918 <dirlink>:
{
    80003918:	7139                	addi	sp,sp,-64
    8000391a:	fc06                	sd	ra,56(sp)
    8000391c:	f822                	sd	s0,48(sp)
    8000391e:	f04a                	sd	s2,32(sp)
    80003920:	ec4e                	sd	s3,24(sp)
    80003922:	e852                	sd	s4,16(sp)
    80003924:	0080                	addi	s0,sp,64
    80003926:	892a                	mv	s2,a0
    80003928:	8a2e                	mv	s4,a1
    8000392a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000392c:	4601                	li	a2,0
    8000392e:	e1fff0ef          	jal	8000374c <dirlookup>
    80003932:	e535                	bnez	a0,8000399e <dirlink+0x86>
    80003934:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003936:	04c92483          	lw	s1,76(s2)
    8000393a:	c48d                	beqz	s1,80003964 <dirlink+0x4c>
    8000393c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000393e:	4741                	li	a4,16
    80003940:	86a6                	mv	a3,s1
    80003942:	fc040613          	addi	a2,s0,-64
    80003946:	4581                	li	a1,0
    80003948:	854a                	mv	a0,s2
    8000394a:	be3ff0ef          	jal	8000352c <readi>
    8000394e:	47c1                	li	a5,16
    80003950:	04f51b63          	bne	a0,a5,800039a6 <dirlink+0x8e>
    if(de.inum == 0)
    80003954:	fc045783          	lhu	a5,-64(s0)
    80003958:	c791                	beqz	a5,80003964 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000395a:	24c1                	addiw	s1,s1,16
    8000395c:	04c92783          	lw	a5,76(s2)
    80003960:	fcf4efe3          	bltu	s1,a5,8000393e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003964:	4639                	li	a2,14
    80003966:	85d2                	mv	a1,s4
    80003968:	fc240513          	addi	a0,s0,-62
    8000396c:	c5efd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003970:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003974:	4741                	li	a4,16
    80003976:	86a6                	mv	a3,s1
    80003978:	fc040613          	addi	a2,s0,-64
    8000397c:	4581                	li	a1,0
    8000397e:	854a                	mv	a0,s2
    80003980:	ca9ff0ef          	jal	80003628 <writei>
    80003984:	1541                	addi	a0,a0,-16
    80003986:	00a03533          	snez	a0,a0
    8000398a:	40a00533          	neg	a0,a0
    8000398e:	74a2                	ld	s1,40(sp)
}
    80003990:	70e2                	ld	ra,56(sp)
    80003992:	7442                	ld	s0,48(sp)
    80003994:	7902                	ld	s2,32(sp)
    80003996:	69e2                	ld	s3,24(sp)
    80003998:	6a42                	ld	s4,16(sp)
    8000399a:	6121                	addi	sp,sp,64
    8000399c:	8082                	ret
    iput(ip);
    8000399e:	abdff0ef          	jal	8000345a <iput>
    return -1;
    800039a2:	557d                	li	a0,-1
    800039a4:	b7f5                	j	80003990 <dirlink+0x78>
      panic("dirlink read");
    800039a6:	00004517          	auipc	a0,0x4
    800039aa:	ba250513          	addi	a0,a0,-1118 # 80007548 <etext+0x548>
    800039ae:	de7fc0ef          	jal	80000794 <panic>

00000000800039b2 <namei>:

struct inode*
namei(char *path)
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800039ba:	fe040613          	addi	a2,s0,-32
    800039be:	4581                	li	a1,0
    800039c0:	e29ff0ef          	jal	800037e8 <namex>
}
    800039c4:	60e2                	ld	ra,24(sp)
    800039c6:	6442                	ld	s0,16(sp)
    800039c8:	6105                	addi	sp,sp,32
    800039ca:	8082                	ret

00000000800039cc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800039cc:	1141                	addi	sp,sp,-16
    800039ce:	e406                	sd	ra,8(sp)
    800039d0:	e022                	sd	s0,0(sp)
    800039d2:	0800                	addi	s0,sp,16
    800039d4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800039d6:	4585                	li	a1,1
    800039d8:	e11ff0ef          	jal	800037e8 <namex>
}
    800039dc:	60a2                	ld	ra,8(sp)
    800039de:	6402                	ld	s0,0(sp)
    800039e0:	0141                	addi	sp,sp,16
    800039e2:	8082                	ret

00000000800039e4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	e04a                	sd	s2,0(sp)
    800039ee:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800039f0:	0001c917          	auipc	s2,0x1c
    800039f4:	02090913          	addi	s2,s2,32 # 8001fa10 <log>
    800039f8:	01892583          	lw	a1,24(s2)
    800039fc:	02892503          	lw	a0,40(s2)
    80003a00:	9a0ff0ef          	jal	80002ba0 <bread>
    80003a04:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003a06:	02c92603          	lw	a2,44(s2)
    80003a0a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003a0c:	00c05f63          	blez	a2,80003a2a <write_head+0x46>
    80003a10:	0001c717          	auipc	a4,0x1c
    80003a14:	03070713          	addi	a4,a4,48 # 8001fa40 <log+0x30>
    80003a18:	87aa                	mv	a5,a0
    80003a1a:	060a                	slli	a2,a2,0x2
    80003a1c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003a1e:	4314                	lw	a3,0(a4)
    80003a20:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003a22:	0711                	addi	a4,a4,4
    80003a24:	0791                	addi	a5,a5,4
    80003a26:	fec79ce3          	bne	a5,a2,80003a1e <write_head+0x3a>
  }
  bwrite(buf);
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	a4aff0ef          	jal	80002c76 <bwrite>
  brelse(buf);
    80003a30:	8526                	mv	a0,s1
    80003a32:	a76ff0ef          	jal	80002ca8 <brelse>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	64a2                	ld	s1,8(sp)
    80003a3c:	6902                	ld	s2,0(sp)
    80003a3e:	6105                	addi	sp,sp,32
    80003a40:	8082                	ret

0000000080003a42 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a42:	0001c797          	auipc	a5,0x1c
    80003a46:	ffa7a783          	lw	a5,-6(a5) # 8001fa3c <log+0x2c>
    80003a4a:	08f05f63          	blez	a5,80003ae8 <install_trans+0xa6>
{
    80003a4e:	7139                	addi	sp,sp,-64
    80003a50:	fc06                	sd	ra,56(sp)
    80003a52:	f822                	sd	s0,48(sp)
    80003a54:	f426                	sd	s1,40(sp)
    80003a56:	f04a                	sd	s2,32(sp)
    80003a58:	ec4e                	sd	s3,24(sp)
    80003a5a:	e852                	sd	s4,16(sp)
    80003a5c:	e456                	sd	s5,8(sp)
    80003a5e:	e05a                	sd	s6,0(sp)
    80003a60:	0080                	addi	s0,sp,64
    80003a62:	8b2a                	mv	s6,a0
    80003a64:	0001ca97          	auipc	s5,0x1c
    80003a68:	fdca8a93          	addi	s5,s5,-36 # 8001fa40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a6c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a6e:	0001c997          	auipc	s3,0x1c
    80003a72:	fa298993          	addi	s3,s3,-94 # 8001fa10 <log>
    80003a76:	a829                	j	80003a90 <install_trans+0x4e>
    brelse(lbuf);
    80003a78:	854a                	mv	a0,s2
    80003a7a:	a2eff0ef          	jal	80002ca8 <brelse>
    brelse(dbuf);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	a28ff0ef          	jal	80002ca8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a84:	2a05                	addiw	s4,s4,1
    80003a86:	0a91                	addi	s5,s5,4
    80003a88:	02c9a783          	lw	a5,44(s3)
    80003a8c:	04fa5463          	bge	s4,a5,80003ad4 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003a90:	0189a583          	lw	a1,24(s3)
    80003a94:	014585bb          	addw	a1,a1,s4
    80003a98:	2585                	addiw	a1,a1,1
    80003a9a:	0289a503          	lw	a0,40(s3)
    80003a9e:	902ff0ef          	jal	80002ba0 <bread>
    80003aa2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003aa4:	000aa583          	lw	a1,0(s5)
    80003aa8:	0289a503          	lw	a0,40(s3)
    80003aac:	8f4ff0ef          	jal	80002ba0 <bread>
    80003ab0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ab2:	40000613          	li	a2,1024
    80003ab6:	05890593          	addi	a1,s2,88
    80003aba:	05850513          	addi	a0,a0,88
    80003abe:	a66fd0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	9b2ff0ef          	jal	80002c76 <bwrite>
    if(recovering == 0)
    80003ac8:	fa0b18e3          	bnez	s6,80003a78 <install_trans+0x36>
      bunpin(dbuf);
    80003acc:	8526                	mv	a0,s1
    80003ace:	a96ff0ef          	jal	80002d64 <bunpin>
    80003ad2:	b75d                	j	80003a78 <install_trans+0x36>
}
    80003ad4:	70e2                	ld	ra,56(sp)
    80003ad6:	7442                	ld	s0,48(sp)
    80003ad8:	74a2                	ld	s1,40(sp)
    80003ada:	7902                	ld	s2,32(sp)
    80003adc:	69e2                	ld	s3,24(sp)
    80003ade:	6a42                	ld	s4,16(sp)
    80003ae0:	6aa2                	ld	s5,8(sp)
    80003ae2:	6b02                	ld	s6,0(sp)
    80003ae4:	6121                	addi	sp,sp,64
    80003ae6:	8082                	ret
    80003ae8:	8082                	ret

0000000080003aea <initlog>:
{
    80003aea:	7179                	addi	sp,sp,-48
    80003aec:	f406                	sd	ra,40(sp)
    80003aee:	f022                	sd	s0,32(sp)
    80003af0:	ec26                	sd	s1,24(sp)
    80003af2:	e84a                	sd	s2,16(sp)
    80003af4:	e44e                	sd	s3,8(sp)
    80003af6:	1800                	addi	s0,sp,48
    80003af8:	892a                	mv	s2,a0
    80003afa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003afc:	0001c497          	auipc	s1,0x1c
    80003b00:	f1448493          	addi	s1,s1,-236 # 8001fa10 <log>
    80003b04:	00004597          	auipc	a1,0x4
    80003b08:	a5458593          	addi	a1,a1,-1452 # 80007558 <etext+0x558>
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	866fd0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003b12:	0149a583          	lw	a1,20(s3)
    80003b16:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003b18:	0109a783          	lw	a5,16(s3)
    80003b1c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003b1e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003b22:	854a                	mv	a0,s2
    80003b24:	87cff0ef          	jal	80002ba0 <bread>
  log.lh.n = lh->n;
    80003b28:	4d30                	lw	a2,88(a0)
    80003b2a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003b2c:	00c05f63          	blez	a2,80003b4a <initlog+0x60>
    80003b30:	87aa                	mv	a5,a0
    80003b32:	0001c717          	auipc	a4,0x1c
    80003b36:	f0e70713          	addi	a4,a4,-242 # 8001fa40 <log+0x30>
    80003b3a:	060a                	slli	a2,a2,0x2
    80003b3c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003b3e:	4ff4                	lw	a3,92(a5)
    80003b40:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003b42:	0791                	addi	a5,a5,4
    80003b44:	0711                	addi	a4,a4,4
    80003b46:	fec79ce3          	bne	a5,a2,80003b3e <initlog+0x54>
  brelse(buf);
    80003b4a:	95eff0ef          	jal	80002ca8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003b4e:	4505                	li	a0,1
    80003b50:	ef3ff0ef          	jal	80003a42 <install_trans>
  log.lh.n = 0;
    80003b54:	0001c797          	auipc	a5,0x1c
    80003b58:	ee07a423          	sw	zero,-280(a5) # 8001fa3c <log+0x2c>
  write_head(); // clear the log
    80003b5c:	e89ff0ef          	jal	800039e4 <write_head>
}
    80003b60:	70a2                	ld	ra,40(sp)
    80003b62:	7402                	ld	s0,32(sp)
    80003b64:	64e2                	ld	s1,24(sp)
    80003b66:	6942                	ld	s2,16(sp)
    80003b68:	69a2                	ld	s3,8(sp)
    80003b6a:	6145                	addi	sp,sp,48
    80003b6c:	8082                	ret

0000000080003b6e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003b6e:	1101                	addi	sp,sp,-32
    80003b70:	ec06                	sd	ra,24(sp)
    80003b72:	e822                	sd	s0,16(sp)
    80003b74:	e426                	sd	s1,8(sp)
    80003b76:	e04a                	sd	s2,0(sp)
    80003b78:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003b7a:	0001c517          	auipc	a0,0x1c
    80003b7e:	e9650513          	addi	a0,a0,-362 # 8001fa10 <log>
    80003b82:	872fd0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003b86:	0001c497          	auipc	s1,0x1c
    80003b8a:	e8a48493          	addi	s1,s1,-374 # 8001fa10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b8e:	4979                	li	s2,30
    80003b90:	a029                	j	80003b9a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003b92:	85a6                	mv	a1,s1
    80003b94:	8526                	mv	a0,s1
    80003b96:	ba2fe0ef          	jal	80001f38 <sleep>
    if(log.committing){
    80003b9a:	50dc                	lw	a5,36(s1)
    80003b9c:	fbfd                	bnez	a5,80003b92 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003b9e:	5098                	lw	a4,32(s1)
    80003ba0:	2705                	addiw	a4,a4,1
    80003ba2:	0027179b          	slliw	a5,a4,0x2
    80003ba6:	9fb9                	addw	a5,a5,a4
    80003ba8:	0017979b          	slliw	a5,a5,0x1
    80003bac:	54d4                	lw	a3,44(s1)
    80003bae:	9fb5                	addw	a5,a5,a3
    80003bb0:	00f95763          	bge	s2,a5,80003bbe <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003bb4:	85a6                	mv	a1,s1
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	b80fe0ef          	jal	80001f38 <sleep>
    80003bbc:	bff9                	j	80003b9a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003bbe:	0001c517          	auipc	a0,0x1c
    80003bc2:	e5250513          	addi	a0,a0,-430 # 8001fa10 <log>
    80003bc6:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003bc8:	8c4fd0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003bcc:	60e2                	ld	ra,24(sp)
    80003bce:	6442                	ld	s0,16(sp)
    80003bd0:	64a2                	ld	s1,8(sp)
    80003bd2:	6902                	ld	s2,0(sp)
    80003bd4:	6105                	addi	sp,sp,32
    80003bd6:	8082                	ret

0000000080003bd8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003bd8:	7139                	addi	sp,sp,-64
    80003bda:	fc06                	sd	ra,56(sp)
    80003bdc:	f822                	sd	s0,48(sp)
    80003bde:	f426                	sd	s1,40(sp)
    80003be0:	f04a                	sd	s2,32(sp)
    80003be2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003be4:	0001c497          	auipc	s1,0x1c
    80003be8:	e2c48493          	addi	s1,s1,-468 # 8001fa10 <log>
    80003bec:	8526                	mv	a0,s1
    80003bee:	806fd0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003bf2:	509c                	lw	a5,32(s1)
    80003bf4:	37fd                	addiw	a5,a5,-1
    80003bf6:	0007891b          	sext.w	s2,a5
    80003bfa:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003bfc:	50dc                	lw	a5,36(s1)
    80003bfe:	ef9d                	bnez	a5,80003c3c <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003c00:	04091763          	bnez	s2,80003c4e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003c04:	0001c497          	auipc	s1,0x1c
    80003c08:	e0c48493          	addi	s1,s1,-500 # 8001fa10 <log>
    80003c0c:	4785                	li	a5,1
    80003c0e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003c10:	8526                	mv	a0,s1
    80003c12:	87afd0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003c16:	54dc                	lw	a5,44(s1)
    80003c18:	04f04b63          	bgtz	a5,80003c6e <end_op+0x96>
    acquire(&log.lock);
    80003c1c:	0001c497          	auipc	s1,0x1c
    80003c20:	df448493          	addi	s1,s1,-524 # 8001fa10 <log>
    80003c24:	8526                	mv	a0,s1
    80003c26:	fcffc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003c2a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003c2e:	8526                	mv	a0,s1
    80003c30:	b54fe0ef          	jal	80001f84 <wakeup>
    release(&log.lock);
    80003c34:	8526                	mv	a0,s1
    80003c36:	856fd0ef          	jal	80000c8c <release>
}
    80003c3a:	a025                	j	80003c62 <end_op+0x8a>
    80003c3c:	ec4e                	sd	s3,24(sp)
    80003c3e:	e852                	sd	s4,16(sp)
    80003c40:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003c42:	00004517          	auipc	a0,0x4
    80003c46:	91e50513          	addi	a0,a0,-1762 # 80007560 <etext+0x560>
    80003c4a:	b4bfc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003c4e:	0001c497          	auipc	s1,0x1c
    80003c52:	dc248493          	addi	s1,s1,-574 # 8001fa10 <log>
    80003c56:	8526                	mv	a0,s1
    80003c58:	b2cfe0ef          	jal	80001f84 <wakeup>
  release(&log.lock);
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	82efd0ef          	jal	80000c8c <release>
}
    80003c62:	70e2                	ld	ra,56(sp)
    80003c64:	7442                	ld	s0,48(sp)
    80003c66:	74a2                	ld	s1,40(sp)
    80003c68:	7902                	ld	s2,32(sp)
    80003c6a:	6121                	addi	sp,sp,64
    80003c6c:	8082                	ret
    80003c6e:	ec4e                	sd	s3,24(sp)
    80003c70:	e852                	sd	s4,16(sp)
    80003c72:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c74:	0001ca97          	auipc	s5,0x1c
    80003c78:	dcca8a93          	addi	s5,s5,-564 # 8001fa40 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003c7c:	0001ca17          	auipc	s4,0x1c
    80003c80:	d94a0a13          	addi	s4,s4,-620 # 8001fa10 <log>
    80003c84:	018a2583          	lw	a1,24(s4)
    80003c88:	012585bb          	addw	a1,a1,s2
    80003c8c:	2585                	addiw	a1,a1,1
    80003c8e:	028a2503          	lw	a0,40(s4)
    80003c92:	f0ffe0ef          	jal	80002ba0 <bread>
    80003c96:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003c98:	000aa583          	lw	a1,0(s5)
    80003c9c:	028a2503          	lw	a0,40(s4)
    80003ca0:	f01fe0ef          	jal	80002ba0 <bread>
    80003ca4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ca6:	40000613          	li	a2,1024
    80003caa:	05850593          	addi	a1,a0,88
    80003cae:	05848513          	addi	a0,s1,88
    80003cb2:	872fd0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	fbffe0ef          	jal	80002c76 <bwrite>
    brelse(from);
    80003cbc:	854e                	mv	a0,s3
    80003cbe:	febfe0ef          	jal	80002ca8 <brelse>
    brelse(to);
    80003cc2:	8526                	mv	a0,s1
    80003cc4:	fe5fe0ef          	jal	80002ca8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cc8:	2905                	addiw	s2,s2,1
    80003cca:	0a91                	addi	s5,s5,4
    80003ccc:	02ca2783          	lw	a5,44(s4)
    80003cd0:	faf94ae3          	blt	s2,a5,80003c84 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003cd4:	d11ff0ef          	jal	800039e4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003cd8:	4501                	li	a0,0
    80003cda:	d69ff0ef          	jal	80003a42 <install_trans>
    log.lh.n = 0;
    80003cde:	0001c797          	auipc	a5,0x1c
    80003ce2:	d407af23          	sw	zero,-674(a5) # 8001fa3c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003ce6:	cffff0ef          	jal	800039e4 <write_head>
    80003cea:	69e2                	ld	s3,24(sp)
    80003cec:	6a42                	ld	s4,16(sp)
    80003cee:	6aa2                	ld	s5,8(sp)
    80003cf0:	b735                	j	80003c1c <end_op+0x44>

0000000080003cf2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003cf2:	1101                	addi	sp,sp,-32
    80003cf4:	ec06                	sd	ra,24(sp)
    80003cf6:	e822                	sd	s0,16(sp)
    80003cf8:	e426                	sd	s1,8(sp)
    80003cfa:	e04a                	sd	s2,0(sp)
    80003cfc:	1000                	addi	s0,sp,32
    80003cfe:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003d00:	0001c917          	auipc	s2,0x1c
    80003d04:	d1090913          	addi	s2,s2,-752 # 8001fa10 <log>
    80003d08:	854a                	mv	a0,s2
    80003d0a:	eebfc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003d0e:	02c92603          	lw	a2,44(s2)
    80003d12:	47f5                	li	a5,29
    80003d14:	06c7c363          	blt	a5,a2,80003d7a <log_write+0x88>
    80003d18:	0001c797          	auipc	a5,0x1c
    80003d1c:	d147a783          	lw	a5,-748(a5) # 8001fa2c <log+0x1c>
    80003d20:	37fd                	addiw	a5,a5,-1
    80003d22:	04f65c63          	bge	a2,a5,80003d7a <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003d26:	0001c797          	auipc	a5,0x1c
    80003d2a:	d0a7a783          	lw	a5,-758(a5) # 8001fa30 <log+0x20>
    80003d2e:	04f05c63          	blez	a5,80003d86 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003d32:	4781                	li	a5,0
    80003d34:	04c05f63          	blez	a2,80003d92 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d38:	44cc                	lw	a1,12(s1)
    80003d3a:	0001c717          	auipc	a4,0x1c
    80003d3e:	d0670713          	addi	a4,a4,-762 # 8001fa40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003d42:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003d44:	4314                	lw	a3,0(a4)
    80003d46:	04b68663          	beq	a3,a1,80003d92 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80003d4a:	2785                	addiw	a5,a5,1
    80003d4c:	0711                	addi	a4,a4,4
    80003d4e:	fef61be3          	bne	a2,a5,80003d44 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003d52:	0621                	addi	a2,a2,8
    80003d54:	060a                	slli	a2,a2,0x2
    80003d56:	0001c797          	auipc	a5,0x1c
    80003d5a:	cba78793          	addi	a5,a5,-838 # 8001fa10 <log>
    80003d5e:	97b2                	add	a5,a5,a2
    80003d60:	44d8                	lw	a4,12(s1)
    80003d62:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003d64:	8526                	mv	a0,s1
    80003d66:	fcbfe0ef          	jal	80002d30 <bpin>
    log.lh.n++;
    80003d6a:	0001c717          	auipc	a4,0x1c
    80003d6e:	ca670713          	addi	a4,a4,-858 # 8001fa10 <log>
    80003d72:	575c                	lw	a5,44(a4)
    80003d74:	2785                	addiw	a5,a5,1
    80003d76:	d75c                	sw	a5,44(a4)
    80003d78:	a80d                	j	80003daa <log_write+0xb8>
    panic("too big a transaction");
    80003d7a:	00003517          	auipc	a0,0x3
    80003d7e:	7f650513          	addi	a0,a0,2038 # 80007570 <etext+0x570>
    80003d82:	a13fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80003d86:	00004517          	auipc	a0,0x4
    80003d8a:	80250513          	addi	a0,a0,-2046 # 80007588 <etext+0x588>
    80003d8e:	a07fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80003d92:	00878693          	addi	a3,a5,8
    80003d96:	068a                	slli	a3,a3,0x2
    80003d98:	0001c717          	auipc	a4,0x1c
    80003d9c:	c7870713          	addi	a4,a4,-904 # 8001fa10 <log>
    80003da0:	9736                	add	a4,a4,a3
    80003da2:	44d4                	lw	a3,12(s1)
    80003da4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003da6:	faf60fe3          	beq	a2,a5,80003d64 <log_write+0x72>
  }
  release(&log.lock);
    80003daa:	0001c517          	auipc	a0,0x1c
    80003dae:	c6650513          	addi	a0,a0,-922 # 8001fa10 <log>
    80003db2:	edbfc0ef          	jal	80000c8c <release>
}
    80003db6:	60e2                	ld	ra,24(sp)
    80003db8:	6442                	ld	s0,16(sp)
    80003dba:	64a2                	ld	s1,8(sp)
    80003dbc:	6902                	ld	s2,0(sp)
    80003dbe:	6105                	addi	sp,sp,32
    80003dc0:	8082                	ret

0000000080003dc2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003dc2:	1101                	addi	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	addi	s0,sp,32
    80003dce:	84aa                	mv	s1,a0
    80003dd0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003dd2:	00003597          	auipc	a1,0x3
    80003dd6:	7d658593          	addi	a1,a1,2006 # 800075a8 <etext+0x5a8>
    80003dda:	0521                	addi	a0,a0,8
    80003ddc:	d99fc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    80003de0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003de4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003de8:	0204a423          	sw	zero,40(s1)
}
    80003dec:	60e2                	ld	ra,24(sp)
    80003dee:	6442                	ld	s0,16(sp)
    80003df0:	64a2                	ld	s1,8(sp)
    80003df2:	6902                	ld	s2,0(sp)
    80003df4:	6105                	addi	sp,sp,32
    80003df6:	8082                	ret

0000000080003df8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003df8:	1101                	addi	sp,sp,-32
    80003dfa:	ec06                	sd	ra,24(sp)
    80003dfc:	e822                	sd	s0,16(sp)
    80003dfe:	e426                	sd	s1,8(sp)
    80003e00:	e04a                	sd	s2,0(sp)
    80003e02:	1000                	addi	s0,sp,32
    80003e04:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e06:	00850913          	addi	s2,a0,8
    80003e0a:	854a                	mv	a0,s2
    80003e0c:	de9fc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    80003e10:	409c                	lw	a5,0(s1)
    80003e12:	c799                	beqz	a5,80003e20 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003e14:	85ca                	mv	a1,s2
    80003e16:	8526                	mv	a0,s1
    80003e18:	920fe0ef          	jal	80001f38 <sleep>
  while (lk->locked) {
    80003e1c:	409c                	lw	a5,0(s1)
    80003e1e:	fbfd                	bnez	a5,80003e14 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003e20:	4785                	li	a5,1
    80003e22:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003e24:	abdfd0ef          	jal	800018e0 <myproc>
    80003e28:	591c                	lw	a5,48(a0)
    80003e2a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003e2c:	854a                	mv	a0,s2
    80003e2e:	e5ffc0ef          	jal	80000c8c <release>
}
    80003e32:	60e2                	ld	ra,24(sp)
    80003e34:	6442                	ld	s0,16(sp)
    80003e36:	64a2                	ld	s1,8(sp)
    80003e38:	6902                	ld	s2,0(sp)
    80003e3a:	6105                	addi	sp,sp,32
    80003e3c:	8082                	ret

0000000080003e3e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003e3e:	1101                	addi	sp,sp,-32
    80003e40:	ec06                	sd	ra,24(sp)
    80003e42:	e822                	sd	s0,16(sp)
    80003e44:	e426                	sd	s1,8(sp)
    80003e46:	e04a                	sd	s2,0(sp)
    80003e48:	1000                	addi	s0,sp,32
    80003e4a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003e4c:	00850913          	addi	s2,a0,8
    80003e50:	854a                	mv	a0,s2
    80003e52:	da3fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80003e56:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003e5a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003e5e:	8526                	mv	a0,s1
    80003e60:	924fe0ef          	jal	80001f84 <wakeup>
  release(&lk->lk);
    80003e64:	854a                	mv	a0,s2
    80003e66:	e27fc0ef          	jal	80000c8c <release>
}
    80003e6a:	60e2                	ld	ra,24(sp)
    80003e6c:	6442                	ld	s0,16(sp)
    80003e6e:	64a2                	ld	s1,8(sp)
    80003e70:	6902                	ld	s2,0(sp)
    80003e72:	6105                	addi	sp,sp,32
    80003e74:	8082                	ret

0000000080003e76 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003e76:	7179                	addi	sp,sp,-48
    80003e78:	f406                	sd	ra,40(sp)
    80003e7a:	f022                	sd	s0,32(sp)
    80003e7c:	ec26                	sd	s1,24(sp)
    80003e7e:	e84a                	sd	s2,16(sp)
    80003e80:	1800                	addi	s0,sp,48
    80003e82:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003e84:	00850913          	addi	s2,a0,8
    80003e88:	854a                	mv	a0,s2
    80003e8a:	d6bfc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003e8e:	409c                	lw	a5,0(s1)
    80003e90:	ef81                	bnez	a5,80003ea8 <holdingsleep+0x32>
    80003e92:	4481                	li	s1,0
  release(&lk->lk);
    80003e94:	854a                	mv	a0,s2
    80003e96:	df7fc0ef          	jal	80000c8c <release>
  return r;
}
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	70a2                	ld	ra,40(sp)
    80003e9e:	7402                	ld	s0,32(sp)
    80003ea0:	64e2                	ld	s1,24(sp)
    80003ea2:	6942                	ld	s2,16(sp)
    80003ea4:	6145                	addi	sp,sp,48
    80003ea6:	8082                	ret
    80003ea8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003eaa:	0284a983          	lw	s3,40(s1)
    80003eae:	a33fd0ef          	jal	800018e0 <myproc>
    80003eb2:	5904                	lw	s1,48(a0)
    80003eb4:	413484b3          	sub	s1,s1,s3
    80003eb8:	0014b493          	seqz	s1,s1
    80003ebc:	69a2                	ld	s3,8(sp)
    80003ebe:	bfd9                	j	80003e94 <holdingsleep+0x1e>

0000000080003ec0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ec0:	1141                	addi	sp,sp,-16
    80003ec2:	e406                	sd	ra,8(sp)
    80003ec4:	e022                	sd	s0,0(sp)
    80003ec6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ec8:	00003597          	auipc	a1,0x3
    80003ecc:	6f058593          	addi	a1,a1,1776 # 800075b8 <etext+0x5b8>
    80003ed0:	0001c517          	auipc	a0,0x1c
    80003ed4:	c8850513          	addi	a0,a0,-888 # 8001fb58 <ftable>
    80003ed8:	c9dfc0ef          	jal	80000b74 <initlock>
}
    80003edc:	60a2                	ld	ra,8(sp)
    80003ede:	6402                	ld	s0,0(sp)
    80003ee0:	0141                	addi	sp,sp,16
    80003ee2:	8082                	ret

0000000080003ee4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ee4:	1101                	addi	sp,sp,-32
    80003ee6:	ec06                	sd	ra,24(sp)
    80003ee8:	e822                	sd	s0,16(sp)
    80003eea:	e426                	sd	s1,8(sp)
    80003eec:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003eee:	0001c517          	auipc	a0,0x1c
    80003ef2:	c6a50513          	addi	a0,a0,-918 # 8001fb58 <ftable>
    80003ef6:	cfffc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003efa:	0001c497          	auipc	s1,0x1c
    80003efe:	c7648493          	addi	s1,s1,-906 # 8001fb70 <ftable+0x18>
    80003f02:	0001d717          	auipc	a4,0x1d
    80003f06:	c0e70713          	addi	a4,a4,-1010 # 80020b10 <disk>
    if(f->ref == 0){
    80003f0a:	40dc                	lw	a5,4(s1)
    80003f0c:	cf89                	beqz	a5,80003f26 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003f0e:	02848493          	addi	s1,s1,40
    80003f12:	fee49ce3          	bne	s1,a4,80003f0a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003f16:	0001c517          	auipc	a0,0x1c
    80003f1a:	c4250513          	addi	a0,a0,-958 # 8001fb58 <ftable>
    80003f1e:	d6ffc0ef          	jal	80000c8c <release>
  return 0;
    80003f22:	4481                	li	s1,0
    80003f24:	a809                	j	80003f36 <filealloc+0x52>
      f->ref = 1;
    80003f26:	4785                	li	a5,1
    80003f28:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003f2a:	0001c517          	auipc	a0,0x1c
    80003f2e:	c2e50513          	addi	a0,a0,-978 # 8001fb58 <ftable>
    80003f32:	d5bfc0ef          	jal	80000c8c <release>
}
    80003f36:	8526                	mv	a0,s1
    80003f38:	60e2                	ld	ra,24(sp)
    80003f3a:	6442                	ld	s0,16(sp)
    80003f3c:	64a2                	ld	s1,8(sp)
    80003f3e:	6105                	addi	sp,sp,32
    80003f40:	8082                	ret

0000000080003f42 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003f42:	1101                	addi	sp,sp,-32
    80003f44:	ec06                	sd	ra,24(sp)
    80003f46:	e822                	sd	s0,16(sp)
    80003f48:	e426                	sd	s1,8(sp)
    80003f4a:	1000                	addi	s0,sp,32
    80003f4c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003f4e:	0001c517          	auipc	a0,0x1c
    80003f52:	c0a50513          	addi	a0,a0,-1014 # 8001fb58 <ftable>
    80003f56:	c9ffc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003f5a:	40dc                	lw	a5,4(s1)
    80003f5c:	02f05063          	blez	a5,80003f7c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003f60:	2785                	addiw	a5,a5,1
    80003f62:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003f64:	0001c517          	auipc	a0,0x1c
    80003f68:	bf450513          	addi	a0,a0,-1036 # 8001fb58 <ftable>
    80003f6c:	d21fc0ef          	jal	80000c8c <release>
  return f;
}
    80003f70:	8526                	mv	a0,s1
    80003f72:	60e2                	ld	ra,24(sp)
    80003f74:	6442                	ld	s0,16(sp)
    80003f76:	64a2                	ld	s1,8(sp)
    80003f78:	6105                	addi	sp,sp,32
    80003f7a:	8082                	ret
    panic("filedup");
    80003f7c:	00003517          	auipc	a0,0x3
    80003f80:	64450513          	addi	a0,a0,1604 # 800075c0 <etext+0x5c0>
    80003f84:	811fc0ef          	jal	80000794 <panic>

0000000080003f88 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003f88:	7139                	addi	sp,sp,-64
    80003f8a:	fc06                	sd	ra,56(sp)
    80003f8c:	f822                	sd	s0,48(sp)
    80003f8e:	f426                	sd	s1,40(sp)
    80003f90:	0080                	addi	s0,sp,64
    80003f92:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003f94:	0001c517          	auipc	a0,0x1c
    80003f98:	bc450513          	addi	a0,a0,-1084 # 8001fb58 <ftable>
    80003f9c:	c59fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80003fa0:	40dc                	lw	a5,4(s1)
    80003fa2:	04f05a63          	blez	a5,80003ff6 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003fa6:	37fd                	addiw	a5,a5,-1
    80003fa8:	0007871b          	sext.w	a4,a5
    80003fac:	c0dc                	sw	a5,4(s1)
    80003fae:	04e04e63          	bgtz	a4,8000400a <fileclose+0x82>
    80003fb2:	f04a                	sd	s2,32(sp)
    80003fb4:	ec4e                	sd	s3,24(sp)
    80003fb6:	e852                	sd	s4,16(sp)
    80003fb8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003fba:	0004a903          	lw	s2,0(s1)
    80003fbe:	0094ca83          	lbu	s5,9(s1)
    80003fc2:	0104ba03          	ld	s4,16(s1)
    80003fc6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003fca:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003fce:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003fd2:	0001c517          	auipc	a0,0x1c
    80003fd6:	b8650513          	addi	a0,a0,-1146 # 8001fb58 <ftable>
    80003fda:	cb3fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80003fde:	4785                	li	a5,1
    80003fe0:	04f90063          	beq	s2,a5,80004020 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003fe4:	3979                	addiw	s2,s2,-2
    80003fe6:	4785                	li	a5,1
    80003fe8:	0527f563          	bgeu	a5,s2,80004032 <fileclose+0xaa>
    80003fec:	7902                	ld	s2,32(sp)
    80003fee:	69e2                	ld	s3,24(sp)
    80003ff0:	6a42                	ld	s4,16(sp)
    80003ff2:	6aa2                	ld	s5,8(sp)
    80003ff4:	a00d                	j	80004016 <fileclose+0x8e>
    80003ff6:	f04a                	sd	s2,32(sp)
    80003ff8:	ec4e                	sd	s3,24(sp)
    80003ffa:	e852                	sd	s4,16(sp)
    80003ffc:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003ffe:	00003517          	auipc	a0,0x3
    80004002:	5ca50513          	addi	a0,a0,1482 # 800075c8 <etext+0x5c8>
    80004006:	f8efc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    8000400a:	0001c517          	auipc	a0,0x1c
    8000400e:	b4e50513          	addi	a0,a0,-1202 # 8001fb58 <ftable>
    80004012:	c7bfc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004016:	70e2                	ld	ra,56(sp)
    80004018:	7442                	ld	s0,48(sp)
    8000401a:	74a2                	ld	s1,40(sp)
    8000401c:	6121                	addi	sp,sp,64
    8000401e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004020:	85d6                	mv	a1,s5
    80004022:	8552                	mv	a0,s4
    80004024:	336000ef          	jal	8000435a <pipeclose>
    80004028:	7902                	ld	s2,32(sp)
    8000402a:	69e2                	ld	s3,24(sp)
    8000402c:	6a42                	ld	s4,16(sp)
    8000402e:	6aa2                	ld	s5,8(sp)
    80004030:	b7dd                	j	80004016 <fileclose+0x8e>
    begin_op();
    80004032:	b3dff0ef          	jal	80003b6e <begin_op>
    iput(ff.ip);
    80004036:	854e                	mv	a0,s3
    80004038:	c22ff0ef          	jal	8000345a <iput>
    end_op();
    8000403c:	b9dff0ef          	jal	80003bd8 <end_op>
    80004040:	7902                	ld	s2,32(sp)
    80004042:	69e2                	ld	s3,24(sp)
    80004044:	6a42                	ld	s4,16(sp)
    80004046:	6aa2                	ld	s5,8(sp)
    80004048:	b7f9                	j	80004016 <fileclose+0x8e>

000000008000404a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000404a:	715d                	addi	sp,sp,-80
    8000404c:	e486                	sd	ra,72(sp)
    8000404e:	e0a2                	sd	s0,64(sp)
    80004050:	fc26                	sd	s1,56(sp)
    80004052:	f44e                	sd	s3,40(sp)
    80004054:	0880                	addi	s0,sp,80
    80004056:	84aa                	mv	s1,a0
    80004058:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000405a:	887fd0ef          	jal	800018e0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000405e:	409c                	lw	a5,0(s1)
    80004060:	37f9                	addiw	a5,a5,-2
    80004062:	4705                	li	a4,1
    80004064:	04f76063          	bltu	a4,a5,800040a4 <filestat+0x5a>
    80004068:	f84a                	sd	s2,48(sp)
    8000406a:	892a                	mv	s2,a0
    ilock(f->ip);
    8000406c:	6c88                	ld	a0,24(s1)
    8000406e:	a6aff0ef          	jal	800032d8 <ilock>
    stati(f->ip, &st);
    80004072:	fb840593          	addi	a1,s0,-72
    80004076:	6c88                	ld	a0,24(s1)
    80004078:	c8aff0ef          	jal	80003502 <stati>
    iunlock(f->ip);
    8000407c:	6c88                	ld	a0,24(s1)
    8000407e:	b08ff0ef          	jal	80003386 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004082:	46e1                	li	a3,24
    80004084:	fb840613          	addi	a2,s0,-72
    80004088:	85ce                	mv	a1,s3
    8000408a:	05093503          	ld	a0,80(s2)
    8000408e:	cc4fd0ef          	jal	80001552 <copyout>
    80004092:	41f5551b          	sraiw	a0,a0,0x1f
    80004096:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004098:	60a6                	ld	ra,72(sp)
    8000409a:	6406                	ld	s0,64(sp)
    8000409c:	74e2                	ld	s1,56(sp)
    8000409e:	79a2                	ld	s3,40(sp)
    800040a0:	6161                	addi	sp,sp,80
    800040a2:	8082                	ret
  return -1;
    800040a4:	557d                	li	a0,-1
    800040a6:	bfcd                	j	80004098 <filestat+0x4e>

00000000800040a8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800040a8:	7179                	addi	sp,sp,-48
    800040aa:	f406                	sd	ra,40(sp)
    800040ac:	f022                	sd	s0,32(sp)
    800040ae:	e84a                	sd	s2,16(sp)
    800040b0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800040b2:	00854783          	lbu	a5,8(a0)
    800040b6:	cfd1                	beqz	a5,80004152 <fileread+0xaa>
    800040b8:	ec26                	sd	s1,24(sp)
    800040ba:	e44e                	sd	s3,8(sp)
    800040bc:	84aa                	mv	s1,a0
    800040be:	89ae                	mv	s3,a1
    800040c0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800040c2:	411c                	lw	a5,0(a0)
    800040c4:	4705                	li	a4,1
    800040c6:	04e78363          	beq	a5,a4,8000410c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800040ca:	470d                	li	a4,3
    800040cc:	04e78763          	beq	a5,a4,8000411a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800040d0:	4709                	li	a4,2
    800040d2:	06e79a63          	bne	a5,a4,80004146 <fileread+0x9e>
    ilock(f->ip);
    800040d6:	6d08                	ld	a0,24(a0)
    800040d8:	a00ff0ef          	jal	800032d8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800040dc:	874a                	mv	a4,s2
    800040de:	5094                	lw	a3,32(s1)
    800040e0:	864e                	mv	a2,s3
    800040e2:	4585                	li	a1,1
    800040e4:	6c88                	ld	a0,24(s1)
    800040e6:	c46ff0ef          	jal	8000352c <readi>
    800040ea:	892a                	mv	s2,a0
    800040ec:	00a05563          	blez	a0,800040f6 <fileread+0x4e>
      f->off += r;
    800040f0:	509c                	lw	a5,32(s1)
    800040f2:	9fa9                	addw	a5,a5,a0
    800040f4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800040f6:	6c88                	ld	a0,24(s1)
    800040f8:	a8eff0ef          	jal	80003386 <iunlock>
    800040fc:	64e2                	ld	s1,24(sp)
    800040fe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004100:	854a                	mv	a0,s2
    80004102:	70a2                	ld	ra,40(sp)
    80004104:	7402                	ld	s0,32(sp)
    80004106:	6942                	ld	s2,16(sp)
    80004108:	6145                	addi	sp,sp,48
    8000410a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000410c:	6908                	ld	a0,16(a0)
    8000410e:	388000ef          	jal	80004496 <piperead>
    80004112:	892a                	mv	s2,a0
    80004114:	64e2                	ld	s1,24(sp)
    80004116:	69a2                	ld	s3,8(sp)
    80004118:	b7e5                	j	80004100 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000411a:	02451783          	lh	a5,36(a0)
    8000411e:	03079693          	slli	a3,a5,0x30
    80004122:	92c1                	srli	a3,a3,0x30
    80004124:	4725                	li	a4,9
    80004126:	02d76863          	bltu	a4,a3,80004156 <fileread+0xae>
    8000412a:	0792                	slli	a5,a5,0x4
    8000412c:	0001c717          	auipc	a4,0x1c
    80004130:	98c70713          	addi	a4,a4,-1652 # 8001fab8 <devsw>
    80004134:	97ba                	add	a5,a5,a4
    80004136:	639c                	ld	a5,0(a5)
    80004138:	c39d                	beqz	a5,8000415e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000413a:	4505                	li	a0,1
    8000413c:	9782                	jalr	a5
    8000413e:	892a                	mv	s2,a0
    80004140:	64e2                	ld	s1,24(sp)
    80004142:	69a2                	ld	s3,8(sp)
    80004144:	bf75                	j	80004100 <fileread+0x58>
    panic("fileread");
    80004146:	00003517          	auipc	a0,0x3
    8000414a:	49250513          	addi	a0,a0,1170 # 800075d8 <etext+0x5d8>
    8000414e:	e46fc0ef          	jal	80000794 <panic>
    return -1;
    80004152:	597d                	li	s2,-1
    80004154:	b775                	j	80004100 <fileread+0x58>
      return -1;
    80004156:	597d                	li	s2,-1
    80004158:	64e2                	ld	s1,24(sp)
    8000415a:	69a2                	ld	s3,8(sp)
    8000415c:	b755                	j	80004100 <fileread+0x58>
    8000415e:	597d                	li	s2,-1
    80004160:	64e2                	ld	s1,24(sp)
    80004162:	69a2                	ld	s3,8(sp)
    80004164:	bf71                	j	80004100 <fileread+0x58>

0000000080004166 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004166:	00954783          	lbu	a5,9(a0)
    8000416a:	10078b63          	beqz	a5,80004280 <filewrite+0x11a>
{
    8000416e:	715d                	addi	sp,sp,-80
    80004170:	e486                	sd	ra,72(sp)
    80004172:	e0a2                	sd	s0,64(sp)
    80004174:	f84a                	sd	s2,48(sp)
    80004176:	f052                	sd	s4,32(sp)
    80004178:	e85a                	sd	s6,16(sp)
    8000417a:	0880                	addi	s0,sp,80
    8000417c:	892a                	mv	s2,a0
    8000417e:	8b2e                	mv	s6,a1
    80004180:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004182:	411c                	lw	a5,0(a0)
    80004184:	4705                	li	a4,1
    80004186:	02e78763          	beq	a5,a4,800041b4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000418a:	470d                	li	a4,3
    8000418c:	02e78863          	beq	a5,a4,800041bc <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004190:	4709                	li	a4,2
    80004192:	0ce79c63          	bne	a5,a4,8000426a <filewrite+0x104>
    80004196:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004198:	0ac05863          	blez	a2,80004248 <filewrite+0xe2>
    8000419c:	fc26                	sd	s1,56(sp)
    8000419e:	ec56                	sd	s5,24(sp)
    800041a0:	e45e                	sd	s7,8(sp)
    800041a2:	e062                	sd	s8,0(sp)
    int i = 0;
    800041a4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800041a6:	6b85                	lui	s7,0x1
    800041a8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800041ac:	6c05                	lui	s8,0x1
    800041ae:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800041b2:	a8b5                	j	8000422e <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800041b4:	6908                	ld	a0,16(a0)
    800041b6:	1fc000ef          	jal	800043b2 <pipewrite>
    800041ba:	a04d                	j	8000425c <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800041bc:	02451783          	lh	a5,36(a0)
    800041c0:	03079693          	slli	a3,a5,0x30
    800041c4:	92c1                	srli	a3,a3,0x30
    800041c6:	4725                	li	a4,9
    800041c8:	0ad76e63          	bltu	a4,a3,80004284 <filewrite+0x11e>
    800041cc:	0792                	slli	a5,a5,0x4
    800041ce:	0001c717          	auipc	a4,0x1c
    800041d2:	8ea70713          	addi	a4,a4,-1814 # 8001fab8 <devsw>
    800041d6:	97ba                	add	a5,a5,a4
    800041d8:	679c                	ld	a5,8(a5)
    800041da:	c7dd                	beqz	a5,80004288 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800041dc:	4505                	li	a0,1
    800041de:	9782                	jalr	a5
    800041e0:	a8b5                	j	8000425c <filewrite+0xf6>
      if(n1 > max)
    800041e2:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800041e6:	989ff0ef          	jal	80003b6e <begin_op>
      ilock(f->ip);
    800041ea:	01893503          	ld	a0,24(s2)
    800041ee:	8eaff0ef          	jal	800032d8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800041f2:	8756                	mv	a4,s5
    800041f4:	02092683          	lw	a3,32(s2)
    800041f8:	01698633          	add	a2,s3,s6
    800041fc:	4585                	li	a1,1
    800041fe:	01893503          	ld	a0,24(s2)
    80004202:	c26ff0ef          	jal	80003628 <writei>
    80004206:	84aa                	mv	s1,a0
    80004208:	00a05763          	blez	a0,80004216 <filewrite+0xb0>
        f->off += r;
    8000420c:	02092783          	lw	a5,32(s2)
    80004210:	9fa9                	addw	a5,a5,a0
    80004212:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004216:	01893503          	ld	a0,24(s2)
    8000421a:	96cff0ef          	jal	80003386 <iunlock>
      end_op();
    8000421e:	9bbff0ef          	jal	80003bd8 <end_op>

      if(r != n1){
    80004222:	029a9563          	bne	s5,s1,8000424c <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004226:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000422a:	0149da63          	bge	s3,s4,8000423e <filewrite+0xd8>
      int n1 = n - i;
    8000422e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004232:	0004879b          	sext.w	a5,s1
    80004236:	fafbd6e3          	bge	s7,a5,800041e2 <filewrite+0x7c>
    8000423a:	84e2                	mv	s1,s8
    8000423c:	b75d                	j	800041e2 <filewrite+0x7c>
    8000423e:	74e2                	ld	s1,56(sp)
    80004240:	6ae2                	ld	s5,24(sp)
    80004242:	6ba2                	ld	s7,8(sp)
    80004244:	6c02                	ld	s8,0(sp)
    80004246:	a039                	j	80004254 <filewrite+0xee>
    int i = 0;
    80004248:	4981                	li	s3,0
    8000424a:	a029                	j	80004254 <filewrite+0xee>
    8000424c:	74e2                	ld	s1,56(sp)
    8000424e:	6ae2                	ld	s5,24(sp)
    80004250:	6ba2                	ld	s7,8(sp)
    80004252:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004254:	033a1c63          	bne	s4,s3,8000428c <filewrite+0x126>
    80004258:	8552                	mv	a0,s4
    8000425a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000425c:	60a6                	ld	ra,72(sp)
    8000425e:	6406                	ld	s0,64(sp)
    80004260:	7942                	ld	s2,48(sp)
    80004262:	7a02                	ld	s4,32(sp)
    80004264:	6b42                	ld	s6,16(sp)
    80004266:	6161                	addi	sp,sp,80
    80004268:	8082                	ret
    8000426a:	fc26                	sd	s1,56(sp)
    8000426c:	f44e                	sd	s3,40(sp)
    8000426e:	ec56                	sd	s5,24(sp)
    80004270:	e45e                	sd	s7,8(sp)
    80004272:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004274:	00003517          	auipc	a0,0x3
    80004278:	37450513          	addi	a0,a0,884 # 800075e8 <etext+0x5e8>
    8000427c:	d18fc0ef          	jal	80000794 <panic>
    return -1;
    80004280:	557d                	li	a0,-1
}
    80004282:	8082                	ret
      return -1;
    80004284:	557d                	li	a0,-1
    80004286:	bfd9                	j	8000425c <filewrite+0xf6>
    80004288:	557d                	li	a0,-1
    8000428a:	bfc9                	j	8000425c <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000428c:	557d                	li	a0,-1
    8000428e:	79a2                	ld	s3,40(sp)
    80004290:	b7f1                	j	8000425c <filewrite+0xf6>

0000000080004292 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004292:	7179                	addi	sp,sp,-48
    80004294:	f406                	sd	ra,40(sp)
    80004296:	f022                	sd	s0,32(sp)
    80004298:	ec26                	sd	s1,24(sp)
    8000429a:	e052                	sd	s4,0(sp)
    8000429c:	1800                	addi	s0,sp,48
    8000429e:	84aa                	mv	s1,a0
    800042a0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800042a2:	0005b023          	sd	zero,0(a1)
    800042a6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800042aa:	c3bff0ef          	jal	80003ee4 <filealloc>
    800042ae:	e088                	sd	a0,0(s1)
    800042b0:	c549                	beqz	a0,8000433a <pipealloc+0xa8>
    800042b2:	c33ff0ef          	jal	80003ee4 <filealloc>
    800042b6:	00aa3023          	sd	a0,0(s4)
    800042ba:	cd25                	beqz	a0,80004332 <pipealloc+0xa0>
    800042bc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800042be:	867fc0ef          	jal	80000b24 <kalloc>
    800042c2:	892a                	mv	s2,a0
    800042c4:	c12d                	beqz	a0,80004326 <pipealloc+0x94>
    800042c6:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800042c8:	4985                	li	s3,1
    800042ca:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800042ce:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800042d2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800042d6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800042da:	00003597          	auipc	a1,0x3
    800042de:	31e58593          	addi	a1,a1,798 # 800075f8 <etext+0x5f8>
    800042e2:	893fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800042e6:	609c                	ld	a5,0(s1)
    800042e8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800042ec:	609c                	ld	a5,0(s1)
    800042ee:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800042f2:	609c                	ld	a5,0(s1)
    800042f4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800042f8:	609c                	ld	a5,0(s1)
    800042fa:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800042fe:	000a3783          	ld	a5,0(s4)
    80004302:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004306:	000a3783          	ld	a5,0(s4)
    8000430a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000430e:	000a3783          	ld	a5,0(s4)
    80004312:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004316:	000a3783          	ld	a5,0(s4)
    8000431a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000431e:	4501                	li	a0,0
    80004320:	6942                	ld	s2,16(sp)
    80004322:	69a2                	ld	s3,8(sp)
    80004324:	a01d                	j	8000434a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004326:	6088                	ld	a0,0(s1)
    80004328:	c119                	beqz	a0,8000432e <pipealloc+0x9c>
    8000432a:	6942                	ld	s2,16(sp)
    8000432c:	a029                	j	80004336 <pipealloc+0xa4>
    8000432e:	6942                	ld	s2,16(sp)
    80004330:	a029                	j	8000433a <pipealloc+0xa8>
    80004332:	6088                	ld	a0,0(s1)
    80004334:	c10d                	beqz	a0,80004356 <pipealloc+0xc4>
    fileclose(*f0);
    80004336:	c53ff0ef          	jal	80003f88 <fileclose>
  if(*f1)
    8000433a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000433e:	557d                	li	a0,-1
  if(*f1)
    80004340:	c789                	beqz	a5,8000434a <pipealloc+0xb8>
    fileclose(*f1);
    80004342:	853e                	mv	a0,a5
    80004344:	c45ff0ef          	jal	80003f88 <fileclose>
  return -1;
    80004348:	557d                	li	a0,-1
}
    8000434a:	70a2                	ld	ra,40(sp)
    8000434c:	7402                	ld	s0,32(sp)
    8000434e:	64e2                	ld	s1,24(sp)
    80004350:	6a02                	ld	s4,0(sp)
    80004352:	6145                	addi	sp,sp,48
    80004354:	8082                	ret
  return -1;
    80004356:	557d                	li	a0,-1
    80004358:	bfcd                	j	8000434a <pipealloc+0xb8>

000000008000435a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000435a:	1101                	addi	sp,sp,-32
    8000435c:	ec06                	sd	ra,24(sp)
    8000435e:	e822                	sd	s0,16(sp)
    80004360:	e426                	sd	s1,8(sp)
    80004362:	e04a                	sd	s2,0(sp)
    80004364:	1000                	addi	s0,sp,32
    80004366:	84aa                	mv	s1,a0
    80004368:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000436a:	88bfc0ef          	jal	80000bf4 <acquire>
  if(writable){
    8000436e:	02090763          	beqz	s2,8000439c <pipeclose+0x42>
    pi->writeopen = 0;
    80004372:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004376:	21848513          	addi	a0,s1,536
    8000437a:	c0bfd0ef          	jal	80001f84 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000437e:	2204b783          	ld	a5,544(s1)
    80004382:	e785                	bnez	a5,800043aa <pipeclose+0x50>
    release(&pi->lock);
    80004384:	8526                	mv	a0,s1
    80004386:	907fc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    8000438a:	8526                	mv	a0,s1
    8000438c:	eb6fc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004390:	60e2                	ld	ra,24(sp)
    80004392:	6442                	ld	s0,16(sp)
    80004394:	64a2                	ld	s1,8(sp)
    80004396:	6902                	ld	s2,0(sp)
    80004398:	6105                	addi	sp,sp,32
    8000439a:	8082                	ret
    pi->readopen = 0;
    8000439c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800043a0:	21c48513          	addi	a0,s1,540
    800043a4:	be1fd0ef          	jal	80001f84 <wakeup>
    800043a8:	bfd9                	j	8000437e <pipeclose+0x24>
    release(&pi->lock);
    800043aa:	8526                	mv	a0,s1
    800043ac:	8e1fc0ef          	jal	80000c8c <release>
}
    800043b0:	b7c5                	j	80004390 <pipeclose+0x36>

00000000800043b2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800043b2:	711d                	addi	sp,sp,-96
    800043b4:	ec86                	sd	ra,88(sp)
    800043b6:	e8a2                	sd	s0,80(sp)
    800043b8:	e4a6                	sd	s1,72(sp)
    800043ba:	e0ca                	sd	s2,64(sp)
    800043bc:	fc4e                	sd	s3,56(sp)
    800043be:	f852                	sd	s4,48(sp)
    800043c0:	f456                	sd	s5,40(sp)
    800043c2:	1080                	addi	s0,sp,96
    800043c4:	84aa                	mv	s1,a0
    800043c6:	8aae                	mv	s5,a1
    800043c8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800043ca:	d16fd0ef          	jal	800018e0 <myproc>
    800043ce:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800043d0:	8526                	mv	a0,s1
    800043d2:	823fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    800043d6:	0b405a63          	blez	s4,8000448a <pipewrite+0xd8>
    800043da:	f05a                	sd	s6,32(sp)
    800043dc:	ec5e                	sd	s7,24(sp)
    800043de:	e862                	sd	s8,16(sp)
  int i = 0;
    800043e0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800043e2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800043e4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800043e8:	21c48b93          	addi	s7,s1,540
    800043ec:	a81d                	j	80004422 <pipewrite+0x70>
      release(&pi->lock);
    800043ee:	8526                	mv	a0,s1
    800043f0:	89dfc0ef          	jal	80000c8c <release>
      return -1;
    800043f4:	597d                	li	s2,-1
    800043f6:	7b02                	ld	s6,32(sp)
    800043f8:	6be2                	ld	s7,24(sp)
    800043fa:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800043fc:	854a                	mv	a0,s2
    800043fe:	60e6                	ld	ra,88(sp)
    80004400:	6446                	ld	s0,80(sp)
    80004402:	64a6                	ld	s1,72(sp)
    80004404:	6906                	ld	s2,64(sp)
    80004406:	79e2                	ld	s3,56(sp)
    80004408:	7a42                	ld	s4,48(sp)
    8000440a:	7aa2                	ld	s5,40(sp)
    8000440c:	6125                	addi	sp,sp,96
    8000440e:	8082                	ret
      wakeup(&pi->nread);
    80004410:	8562                	mv	a0,s8
    80004412:	b73fd0ef          	jal	80001f84 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004416:	85a6                	mv	a1,s1
    80004418:	855e                	mv	a0,s7
    8000441a:	b1ffd0ef          	jal	80001f38 <sleep>
  while(i < n){
    8000441e:	05495b63          	bge	s2,s4,80004474 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004422:	2204a783          	lw	a5,544(s1)
    80004426:	d7e1                	beqz	a5,800043ee <pipewrite+0x3c>
    80004428:	854e                	mv	a0,s3
    8000442a:	d47fd0ef          	jal	80002170 <killed>
    8000442e:	f161                	bnez	a0,800043ee <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004430:	2184a783          	lw	a5,536(s1)
    80004434:	21c4a703          	lw	a4,540(s1)
    80004438:	2007879b          	addiw	a5,a5,512
    8000443c:	fcf70ae3          	beq	a4,a5,80004410 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004440:	4685                	li	a3,1
    80004442:	01590633          	add	a2,s2,s5
    80004446:	faf40593          	addi	a1,s0,-81
    8000444a:	0509b503          	ld	a0,80(s3)
    8000444e:	9dafd0ef          	jal	80001628 <copyin>
    80004452:	03650e63          	beq	a0,s6,8000448e <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004456:	21c4a783          	lw	a5,540(s1)
    8000445a:	0017871b          	addiw	a4,a5,1
    8000445e:	20e4ae23          	sw	a4,540(s1)
    80004462:	1ff7f793          	andi	a5,a5,511
    80004466:	97a6                	add	a5,a5,s1
    80004468:	faf44703          	lbu	a4,-81(s0)
    8000446c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004470:	2905                	addiw	s2,s2,1
    80004472:	b775                	j	8000441e <pipewrite+0x6c>
    80004474:	7b02                	ld	s6,32(sp)
    80004476:	6be2                	ld	s7,24(sp)
    80004478:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000447a:	21848513          	addi	a0,s1,536
    8000447e:	b07fd0ef          	jal	80001f84 <wakeup>
  release(&pi->lock);
    80004482:	8526                	mv	a0,s1
    80004484:	809fc0ef          	jal	80000c8c <release>
  return i;
    80004488:	bf95                	j	800043fc <pipewrite+0x4a>
  int i = 0;
    8000448a:	4901                	li	s2,0
    8000448c:	b7fd                	j	8000447a <pipewrite+0xc8>
    8000448e:	7b02                	ld	s6,32(sp)
    80004490:	6be2                	ld	s7,24(sp)
    80004492:	6c42                	ld	s8,16(sp)
    80004494:	b7dd                	j	8000447a <pipewrite+0xc8>

0000000080004496 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004496:	715d                	addi	sp,sp,-80
    80004498:	e486                	sd	ra,72(sp)
    8000449a:	e0a2                	sd	s0,64(sp)
    8000449c:	fc26                	sd	s1,56(sp)
    8000449e:	f84a                	sd	s2,48(sp)
    800044a0:	f44e                	sd	s3,40(sp)
    800044a2:	f052                	sd	s4,32(sp)
    800044a4:	ec56                	sd	s5,24(sp)
    800044a6:	0880                	addi	s0,sp,80
    800044a8:	84aa                	mv	s1,a0
    800044aa:	892e                	mv	s2,a1
    800044ac:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800044ae:	c32fd0ef          	jal	800018e0 <myproc>
    800044b2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800044b4:	8526                	mv	a0,s1
    800044b6:	f3efc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044ba:	2184a703          	lw	a4,536(s1)
    800044be:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800044c2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044c6:	02f71563          	bne	a4,a5,800044f0 <piperead+0x5a>
    800044ca:	2244a783          	lw	a5,548(s1)
    800044ce:	cb85                	beqz	a5,800044fe <piperead+0x68>
    if(killed(pr)){
    800044d0:	8552                	mv	a0,s4
    800044d2:	c9ffd0ef          	jal	80002170 <killed>
    800044d6:	ed19                	bnez	a0,800044f4 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800044d8:	85a6                	mv	a1,s1
    800044da:	854e                	mv	a0,s3
    800044dc:	a5dfd0ef          	jal	80001f38 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800044e0:	2184a703          	lw	a4,536(s1)
    800044e4:	21c4a783          	lw	a5,540(s1)
    800044e8:	fef701e3          	beq	a4,a5,800044ca <piperead+0x34>
    800044ec:	e85a                	sd	s6,16(sp)
    800044ee:	a809                	j	80004500 <piperead+0x6a>
    800044f0:	e85a                	sd	s6,16(sp)
    800044f2:	a039                	j	80004500 <piperead+0x6a>
      release(&pi->lock);
    800044f4:	8526                	mv	a0,s1
    800044f6:	f96fc0ef          	jal	80000c8c <release>
      return -1;
    800044fa:	59fd                	li	s3,-1
    800044fc:	a8b1                	j	80004558 <piperead+0xc2>
    800044fe:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004500:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004502:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004504:	05505263          	blez	s5,80004548 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004508:	2184a783          	lw	a5,536(s1)
    8000450c:	21c4a703          	lw	a4,540(s1)
    80004510:	02f70c63          	beq	a4,a5,80004548 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004514:	0017871b          	addiw	a4,a5,1
    80004518:	20e4ac23          	sw	a4,536(s1)
    8000451c:	1ff7f793          	andi	a5,a5,511
    80004520:	97a6                	add	a5,a5,s1
    80004522:	0187c783          	lbu	a5,24(a5)
    80004526:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000452a:	4685                	li	a3,1
    8000452c:	fbf40613          	addi	a2,s0,-65
    80004530:	85ca                	mv	a1,s2
    80004532:	050a3503          	ld	a0,80(s4)
    80004536:	81cfd0ef          	jal	80001552 <copyout>
    8000453a:	01650763          	beq	a0,s6,80004548 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000453e:	2985                	addiw	s3,s3,1
    80004540:	0905                	addi	s2,s2,1
    80004542:	fd3a93e3          	bne	s5,s3,80004508 <piperead+0x72>
    80004546:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004548:	21c48513          	addi	a0,s1,540
    8000454c:	a39fd0ef          	jal	80001f84 <wakeup>
  release(&pi->lock);
    80004550:	8526                	mv	a0,s1
    80004552:	f3afc0ef          	jal	80000c8c <release>
    80004556:	6b42                	ld	s6,16(sp)
  return i;
}
    80004558:	854e                	mv	a0,s3
    8000455a:	60a6                	ld	ra,72(sp)
    8000455c:	6406                	ld	s0,64(sp)
    8000455e:	74e2                	ld	s1,56(sp)
    80004560:	7942                	ld	s2,48(sp)
    80004562:	79a2                	ld	s3,40(sp)
    80004564:	7a02                	ld	s4,32(sp)
    80004566:	6ae2                	ld	s5,24(sp)
    80004568:	6161                	addi	sp,sp,80
    8000456a:	8082                	ret

000000008000456c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000456c:	1141                	addi	sp,sp,-16
    8000456e:	e422                	sd	s0,8(sp)
    80004570:	0800                	addi	s0,sp,16
    80004572:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004574:	8905                	andi	a0,a0,1
    80004576:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004578:	8b89                	andi	a5,a5,2
    8000457a:	c399                	beqz	a5,80004580 <flags2perm+0x14>
      perm |= PTE_W;
    8000457c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004580:	6422                	ld	s0,8(sp)
    80004582:	0141                	addi	sp,sp,16
    80004584:	8082                	ret

0000000080004586 <exec>:

int
exec(char *path, char **argv)
{
    80004586:	df010113          	addi	sp,sp,-528
    8000458a:	20113423          	sd	ra,520(sp)
    8000458e:	20813023          	sd	s0,512(sp)
    80004592:	ffa6                	sd	s1,504(sp)
    80004594:	fbca                	sd	s2,496(sp)
    80004596:	0c00                	addi	s0,sp,528
    80004598:	892a                	mv	s2,a0
    8000459a:	dea43c23          	sd	a0,-520(s0)
    8000459e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800045a2:	b3efd0ef          	jal	800018e0 <myproc>
    800045a6:	84aa                	mv	s1,a0

  begin_op();
    800045a8:	dc6ff0ef          	jal	80003b6e <begin_op>

  if((ip = namei(path)) == 0){
    800045ac:	854a                	mv	a0,s2
    800045ae:	c04ff0ef          	jal	800039b2 <namei>
    800045b2:	c931                	beqz	a0,80004606 <exec+0x80>
    800045b4:	f3d2                	sd	s4,480(sp)
    800045b6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800045b8:	d21fe0ef          	jal	800032d8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800045bc:	04000713          	li	a4,64
    800045c0:	4681                	li	a3,0
    800045c2:	e5040613          	addi	a2,s0,-432
    800045c6:	4581                	li	a1,0
    800045c8:	8552                	mv	a0,s4
    800045ca:	f63fe0ef          	jal	8000352c <readi>
    800045ce:	04000793          	li	a5,64
    800045d2:	00f51a63          	bne	a0,a5,800045e6 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800045d6:	e5042703          	lw	a4,-432(s0)
    800045da:	464c47b7          	lui	a5,0x464c4
    800045de:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800045e2:	02f70663          	beq	a4,a5,8000460e <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800045e6:	8552                	mv	a0,s4
    800045e8:	efbfe0ef          	jal	800034e2 <iunlockput>
    end_op();
    800045ec:	decff0ef          	jal	80003bd8 <end_op>
  }
  return -1;
    800045f0:	557d                	li	a0,-1
    800045f2:	7a1e                	ld	s4,480(sp)
}
    800045f4:	20813083          	ld	ra,520(sp)
    800045f8:	20013403          	ld	s0,512(sp)
    800045fc:	74fe                	ld	s1,504(sp)
    800045fe:	795e                	ld	s2,496(sp)
    80004600:	21010113          	addi	sp,sp,528
    80004604:	8082                	ret
    end_op();
    80004606:	dd2ff0ef          	jal	80003bd8 <end_op>
    return -1;
    8000460a:	557d                	li	a0,-1
    8000460c:	b7e5                	j	800045f4 <exec+0x6e>
    8000460e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004610:	8526                	mv	a0,s1
    80004612:	b76fd0ef          	jal	80001988 <proc_pagetable>
    80004616:	8b2a                	mv	s6,a0
    80004618:	2c050b63          	beqz	a0,800048ee <exec+0x368>
    8000461c:	f7ce                	sd	s3,488(sp)
    8000461e:	efd6                	sd	s5,472(sp)
    80004620:	e7de                	sd	s7,456(sp)
    80004622:	e3e2                	sd	s8,448(sp)
    80004624:	ff66                	sd	s9,440(sp)
    80004626:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004628:	e7042d03          	lw	s10,-400(s0)
    8000462c:	e8845783          	lhu	a5,-376(s0)
    80004630:	12078963          	beqz	a5,80004762 <exec+0x1dc>
    80004634:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004636:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004638:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000463a:	6c85                	lui	s9,0x1
    8000463c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004640:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004644:	6a85                	lui	s5,0x1
    80004646:	a085                	j	800046a6 <exec+0x120>
      panic("loadseg: address should exist");
    80004648:	00003517          	auipc	a0,0x3
    8000464c:	fb850513          	addi	a0,a0,-72 # 80007600 <etext+0x600>
    80004650:	944fc0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004654:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004656:	8726                	mv	a4,s1
    80004658:	012c06bb          	addw	a3,s8,s2
    8000465c:	4581                	li	a1,0
    8000465e:	8552                	mv	a0,s4
    80004660:	ecdfe0ef          	jal	8000352c <readi>
    80004664:	2501                	sext.w	a0,a0
    80004666:	24a49a63          	bne	s1,a0,800048ba <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    8000466a:	012a893b          	addw	s2,s5,s2
    8000466e:	03397363          	bgeu	s2,s3,80004694 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004672:	02091593          	slli	a1,s2,0x20
    80004676:	9181                	srli	a1,a1,0x20
    80004678:	95de                	add	a1,a1,s7
    8000467a:	855a                	mv	a0,s6
    8000467c:	95bfc0ef          	jal	80000fd6 <walkaddr>
    80004680:	862a                	mv	a2,a0
    if(pa == 0)
    80004682:	d179                	beqz	a0,80004648 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004684:	412984bb          	subw	s1,s3,s2
    80004688:	0004879b          	sext.w	a5,s1
    8000468c:	fcfcf4e3          	bgeu	s9,a5,80004654 <exec+0xce>
    80004690:	84d6                	mv	s1,s5
    80004692:	b7c9                	j	80004654 <exec+0xce>
    sz = sz1;
    80004694:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004698:	2d85                	addiw	s11,s11,1
    8000469a:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    8000469e:	e8845783          	lhu	a5,-376(s0)
    800046a2:	08fdd063          	bge	s11,a5,80004722 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800046a6:	2d01                	sext.w	s10,s10
    800046a8:	03800713          	li	a4,56
    800046ac:	86ea                	mv	a3,s10
    800046ae:	e1840613          	addi	a2,s0,-488
    800046b2:	4581                	li	a1,0
    800046b4:	8552                	mv	a0,s4
    800046b6:	e77fe0ef          	jal	8000352c <readi>
    800046ba:	03800793          	li	a5,56
    800046be:	1cf51663          	bne	a0,a5,8000488a <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800046c2:	e1842783          	lw	a5,-488(s0)
    800046c6:	4705                	li	a4,1
    800046c8:	fce798e3          	bne	a5,a4,80004698 <exec+0x112>
    if(ph.memsz < ph.filesz)
    800046cc:	e4043483          	ld	s1,-448(s0)
    800046d0:	e3843783          	ld	a5,-456(s0)
    800046d4:	1af4ef63          	bltu	s1,a5,80004892 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800046d8:	e2843783          	ld	a5,-472(s0)
    800046dc:	94be                	add	s1,s1,a5
    800046de:	1af4ee63          	bltu	s1,a5,8000489a <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800046e2:	df043703          	ld	a4,-528(s0)
    800046e6:	8ff9                	and	a5,a5,a4
    800046e8:	1a079d63          	bnez	a5,800048a2 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800046ec:	e1c42503          	lw	a0,-484(s0)
    800046f0:	e7dff0ef          	jal	8000456c <flags2perm>
    800046f4:	86aa                	mv	a3,a0
    800046f6:	8626                	mv	a2,s1
    800046f8:	85ca                	mv	a1,s2
    800046fa:	855a                	mv	a0,s6
    800046fc:	c43fc0ef          	jal	8000133e <uvmalloc>
    80004700:	e0a43423          	sd	a0,-504(s0)
    80004704:	1a050363          	beqz	a0,800048aa <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004708:	e2843b83          	ld	s7,-472(s0)
    8000470c:	e2042c03          	lw	s8,-480(s0)
    80004710:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004714:	00098463          	beqz	s3,8000471c <exec+0x196>
    80004718:	4901                	li	s2,0
    8000471a:	bfa1                	j	80004672 <exec+0xec>
    sz = sz1;
    8000471c:	e0843903          	ld	s2,-504(s0)
    80004720:	bfa5                	j	80004698 <exec+0x112>
    80004722:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004724:	8552                	mv	a0,s4
    80004726:	dbdfe0ef          	jal	800034e2 <iunlockput>
  end_op();
    8000472a:	caeff0ef          	jal	80003bd8 <end_op>
  p = myproc();
    8000472e:	9b2fd0ef          	jal	800018e0 <myproc>
    80004732:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004734:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004738:	6985                	lui	s3,0x1
    8000473a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000473c:	99ca                	add	s3,s3,s2
    8000473e:	77fd                	lui	a5,0xfffff
    80004740:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004744:	4691                	li	a3,4
    80004746:	6609                	lui	a2,0x2
    80004748:	964e                	add	a2,a2,s3
    8000474a:	85ce                	mv	a1,s3
    8000474c:	855a                	mv	a0,s6
    8000474e:	bf1fc0ef          	jal	8000133e <uvmalloc>
    80004752:	892a                	mv	s2,a0
    80004754:	e0a43423          	sd	a0,-504(s0)
    80004758:	e519                	bnez	a0,80004766 <exec+0x1e0>
  if(pagetable)
    8000475a:	e1343423          	sd	s3,-504(s0)
    8000475e:	4a01                	li	s4,0
    80004760:	aab1                	j	800048bc <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004762:	4901                	li	s2,0
    80004764:	b7c1                	j	80004724 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004766:	75f9                	lui	a1,0xffffe
    80004768:	95aa                	add	a1,a1,a0
    8000476a:	855a                	mv	a0,s6
    8000476c:	dbdfc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004770:	7bfd                	lui	s7,0xfffff
    80004772:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004774:	e0043783          	ld	a5,-512(s0)
    80004778:	6388                	ld	a0,0(a5)
    8000477a:	cd39                	beqz	a0,800047d8 <exec+0x252>
    8000477c:	e9040993          	addi	s3,s0,-368
    80004780:	f9040c13          	addi	s8,s0,-112
    80004784:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004786:	eb2fc0ef          	jal	80000e38 <strlen>
    8000478a:	0015079b          	addiw	a5,a0,1
    8000478e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004792:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004796:	11796e63          	bltu	s2,s7,800048b2 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000479a:	e0043d03          	ld	s10,-512(s0)
    8000479e:	000d3a03          	ld	s4,0(s10)
    800047a2:	8552                	mv	a0,s4
    800047a4:	e94fc0ef          	jal	80000e38 <strlen>
    800047a8:	0015069b          	addiw	a3,a0,1
    800047ac:	8652                	mv	a2,s4
    800047ae:	85ca                	mv	a1,s2
    800047b0:	855a                	mv	a0,s6
    800047b2:	da1fc0ef          	jal	80001552 <copyout>
    800047b6:	10054063          	bltz	a0,800048b6 <exec+0x330>
    ustack[argc] = sp;
    800047ba:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800047be:	0485                	addi	s1,s1,1
    800047c0:	008d0793          	addi	a5,s10,8
    800047c4:	e0f43023          	sd	a5,-512(s0)
    800047c8:	008d3503          	ld	a0,8(s10)
    800047cc:	c909                	beqz	a0,800047de <exec+0x258>
    if(argc >= MAXARG)
    800047ce:	09a1                	addi	s3,s3,8
    800047d0:	fb899be3          	bne	s3,s8,80004786 <exec+0x200>
  ip = 0;
    800047d4:	4a01                	li	s4,0
    800047d6:	a0dd                	j	800048bc <exec+0x336>
  sp = sz;
    800047d8:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800047dc:	4481                	li	s1,0
  ustack[argc] = 0;
    800047de:	00349793          	slli	a5,s1,0x3
    800047e2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde340>
    800047e6:	97a2                	add	a5,a5,s0
    800047e8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800047ec:	00148693          	addi	a3,s1,1
    800047f0:	068e                	slli	a3,a3,0x3
    800047f2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800047f6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800047fa:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800047fe:	f5796ee3          	bltu	s2,s7,8000475a <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004802:	e9040613          	addi	a2,s0,-368
    80004806:	85ca                	mv	a1,s2
    80004808:	855a                	mv	a0,s6
    8000480a:	d49fc0ef          	jal	80001552 <copyout>
    8000480e:	0e054263          	bltz	a0,800048f2 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004812:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004816:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000481a:	df843783          	ld	a5,-520(s0)
    8000481e:	0007c703          	lbu	a4,0(a5)
    80004822:	cf11                	beqz	a4,8000483e <exec+0x2b8>
    80004824:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004826:	02f00693          	li	a3,47
    8000482a:	a039                	j	80004838 <exec+0x2b2>
      last = s+1;
    8000482c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004830:	0785                	addi	a5,a5,1
    80004832:	fff7c703          	lbu	a4,-1(a5)
    80004836:	c701                	beqz	a4,8000483e <exec+0x2b8>
    if(*s == '/')
    80004838:	fed71ce3          	bne	a4,a3,80004830 <exec+0x2aa>
    8000483c:	bfc5                	j	8000482c <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000483e:	4641                	li	a2,16
    80004840:	df843583          	ld	a1,-520(s0)
    80004844:	158a8513          	addi	a0,s5,344
    80004848:	dbefc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    8000484c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004850:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004854:	e0843783          	ld	a5,-504(s0)
    80004858:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000485c:	058ab783          	ld	a5,88(s5)
    80004860:	e6843703          	ld	a4,-408(s0)
    80004864:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004866:	058ab783          	ld	a5,88(s5)
    8000486a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000486e:	85e6                	mv	a1,s9
    80004870:	99cfd0ef          	jal	80001a0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004874:	0004851b          	sext.w	a0,s1
    80004878:	79be                	ld	s3,488(sp)
    8000487a:	7a1e                	ld	s4,480(sp)
    8000487c:	6afe                	ld	s5,472(sp)
    8000487e:	6b5e                	ld	s6,464(sp)
    80004880:	6bbe                	ld	s7,456(sp)
    80004882:	6c1e                	ld	s8,448(sp)
    80004884:	7cfa                	ld	s9,440(sp)
    80004886:	7d5a                	ld	s10,432(sp)
    80004888:	b3b5                	j	800045f4 <exec+0x6e>
    8000488a:	e1243423          	sd	s2,-504(s0)
    8000488e:	7dba                	ld	s11,424(sp)
    80004890:	a035                	j	800048bc <exec+0x336>
    80004892:	e1243423          	sd	s2,-504(s0)
    80004896:	7dba                	ld	s11,424(sp)
    80004898:	a015                	j	800048bc <exec+0x336>
    8000489a:	e1243423          	sd	s2,-504(s0)
    8000489e:	7dba                	ld	s11,424(sp)
    800048a0:	a831                	j	800048bc <exec+0x336>
    800048a2:	e1243423          	sd	s2,-504(s0)
    800048a6:	7dba                	ld	s11,424(sp)
    800048a8:	a811                	j	800048bc <exec+0x336>
    800048aa:	e1243423          	sd	s2,-504(s0)
    800048ae:	7dba                	ld	s11,424(sp)
    800048b0:	a031                	j	800048bc <exec+0x336>
  ip = 0;
    800048b2:	4a01                	li	s4,0
    800048b4:	a021                	j	800048bc <exec+0x336>
    800048b6:	4a01                	li	s4,0
  if(pagetable)
    800048b8:	a011                	j	800048bc <exec+0x336>
    800048ba:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800048bc:	e0843583          	ld	a1,-504(s0)
    800048c0:	855a                	mv	a0,s6
    800048c2:	94afd0ef          	jal	80001a0c <proc_freepagetable>
  return -1;
    800048c6:	557d                	li	a0,-1
  if(ip){
    800048c8:	000a1b63          	bnez	s4,800048de <exec+0x358>
    800048cc:	79be                	ld	s3,488(sp)
    800048ce:	7a1e                	ld	s4,480(sp)
    800048d0:	6afe                	ld	s5,472(sp)
    800048d2:	6b5e                	ld	s6,464(sp)
    800048d4:	6bbe                	ld	s7,456(sp)
    800048d6:	6c1e                	ld	s8,448(sp)
    800048d8:	7cfa                	ld	s9,440(sp)
    800048da:	7d5a                	ld	s10,432(sp)
    800048dc:	bb21                	j	800045f4 <exec+0x6e>
    800048de:	79be                	ld	s3,488(sp)
    800048e0:	6afe                	ld	s5,472(sp)
    800048e2:	6b5e                	ld	s6,464(sp)
    800048e4:	6bbe                	ld	s7,456(sp)
    800048e6:	6c1e                	ld	s8,448(sp)
    800048e8:	7cfa                	ld	s9,440(sp)
    800048ea:	7d5a                	ld	s10,432(sp)
    800048ec:	b9ed                	j	800045e6 <exec+0x60>
    800048ee:	6b5e                	ld	s6,464(sp)
    800048f0:	b9dd                	j	800045e6 <exec+0x60>
  sz = sz1;
    800048f2:	e0843983          	ld	s3,-504(s0)
    800048f6:	b595                	j	8000475a <exec+0x1d4>

00000000800048f8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800048f8:	7179                	addi	sp,sp,-48
    800048fa:	f406                	sd	ra,40(sp)
    800048fc:	f022                	sd	s0,32(sp)
    800048fe:	ec26                	sd	s1,24(sp)
    80004900:	e84a                	sd	s2,16(sp)
    80004902:	1800                	addi	s0,sp,48
    80004904:	892e                	mv	s2,a1
    80004906:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004908:	fdc40593          	addi	a1,s0,-36
    8000490c:	f41fd0ef          	jal	8000284c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004910:	fdc42703          	lw	a4,-36(s0)
    80004914:	47bd                	li	a5,15
    80004916:	02e7e963          	bltu	a5,a4,80004948 <argfd+0x50>
    8000491a:	fc7fc0ef          	jal	800018e0 <myproc>
    8000491e:	fdc42703          	lw	a4,-36(s0)
    80004922:	01a70793          	addi	a5,a4,26
    80004926:	078e                	slli	a5,a5,0x3
    80004928:	953e                	add	a0,a0,a5
    8000492a:	611c                	ld	a5,0(a0)
    8000492c:	c385                	beqz	a5,8000494c <argfd+0x54>
    return -1;
  if(pfd)
    8000492e:	00090463          	beqz	s2,80004936 <argfd+0x3e>
    *pfd = fd;
    80004932:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004936:	4501                	li	a0,0
  if(pf)
    80004938:	c091                	beqz	s1,8000493c <argfd+0x44>
    *pf = f;
    8000493a:	e09c                	sd	a5,0(s1)
}
    8000493c:	70a2                	ld	ra,40(sp)
    8000493e:	7402                	ld	s0,32(sp)
    80004940:	64e2                	ld	s1,24(sp)
    80004942:	6942                	ld	s2,16(sp)
    80004944:	6145                	addi	sp,sp,48
    80004946:	8082                	ret
    return -1;
    80004948:	557d                	li	a0,-1
    8000494a:	bfcd                	j	8000493c <argfd+0x44>
    8000494c:	557d                	li	a0,-1
    8000494e:	b7fd                	j	8000493c <argfd+0x44>

0000000080004950 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004950:	1101                	addi	sp,sp,-32
    80004952:	ec06                	sd	ra,24(sp)
    80004954:	e822                	sd	s0,16(sp)
    80004956:	e426                	sd	s1,8(sp)
    80004958:	1000                	addi	s0,sp,32
    8000495a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000495c:	f85fc0ef          	jal	800018e0 <myproc>
    80004960:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004962:	0d050793          	addi	a5,a0,208
    80004966:	4501                	li	a0,0
    80004968:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000496a:	6398                	ld	a4,0(a5)
    8000496c:	cb19                	beqz	a4,80004982 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000496e:	2505                	addiw	a0,a0,1
    80004970:	07a1                	addi	a5,a5,8
    80004972:	fed51ce3          	bne	a0,a3,8000496a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004976:	557d                	li	a0,-1
}
    80004978:	60e2                	ld	ra,24(sp)
    8000497a:	6442                	ld	s0,16(sp)
    8000497c:	64a2                	ld	s1,8(sp)
    8000497e:	6105                	addi	sp,sp,32
    80004980:	8082                	ret
      p->ofile[fd] = f;
    80004982:	01a50793          	addi	a5,a0,26
    80004986:	078e                	slli	a5,a5,0x3
    80004988:	963e                	add	a2,a2,a5
    8000498a:	e204                	sd	s1,0(a2)
      return fd;
    8000498c:	b7f5                	j	80004978 <fdalloc+0x28>

000000008000498e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000498e:	715d                	addi	sp,sp,-80
    80004990:	e486                	sd	ra,72(sp)
    80004992:	e0a2                	sd	s0,64(sp)
    80004994:	fc26                	sd	s1,56(sp)
    80004996:	f84a                	sd	s2,48(sp)
    80004998:	f44e                	sd	s3,40(sp)
    8000499a:	ec56                	sd	s5,24(sp)
    8000499c:	e85a                	sd	s6,16(sp)
    8000499e:	0880                	addi	s0,sp,80
    800049a0:	8b2e                	mv	s6,a1
    800049a2:	89b2                	mv	s3,a2
    800049a4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800049a6:	fb040593          	addi	a1,s0,-80
    800049aa:	822ff0ef          	jal	800039cc <nameiparent>
    800049ae:	84aa                	mv	s1,a0
    800049b0:	10050a63          	beqz	a0,80004ac4 <create+0x136>
    return 0;

  ilock(dp);
    800049b4:	925fe0ef          	jal	800032d8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800049b8:	4601                	li	a2,0
    800049ba:	fb040593          	addi	a1,s0,-80
    800049be:	8526                	mv	a0,s1
    800049c0:	d8dfe0ef          	jal	8000374c <dirlookup>
    800049c4:	8aaa                	mv	s5,a0
    800049c6:	c129                	beqz	a0,80004a08 <create+0x7a>
    iunlockput(dp);
    800049c8:	8526                	mv	a0,s1
    800049ca:	b19fe0ef          	jal	800034e2 <iunlockput>
    ilock(ip);
    800049ce:	8556                	mv	a0,s5
    800049d0:	909fe0ef          	jal	800032d8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800049d4:	4789                	li	a5,2
    800049d6:	02fb1463          	bne	s6,a5,800049fe <create+0x70>
    800049da:	044ad783          	lhu	a5,68(s5)
    800049de:	37f9                	addiw	a5,a5,-2
    800049e0:	17c2                	slli	a5,a5,0x30
    800049e2:	93c1                	srli	a5,a5,0x30
    800049e4:	4705                	li	a4,1
    800049e6:	00f76c63          	bltu	a4,a5,800049fe <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800049ea:	8556                	mv	a0,s5
    800049ec:	60a6                	ld	ra,72(sp)
    800049ee:	6406                	ld	s0,64(sp)
    800049f0:	74e2                	ld	s1,56(sp)
    800049f2:	7942                	ld	s2,48(sp)
    800049f4:	79a2                	ld	s3,40(sp)
    800049f6:	6ae2                	ld	s5,24(sp)
    800049f8:	6b42                	ld	s6,16(sp)
    800049fa:	6161                	addi	sp,sp,80
    800049fc:	8082                	ret
    iunlockput(ip);
    800049fe:	8556                	mv	a0,s5
    80004a00:	ae3fe0ef          	jal	800034e2 <iunlockput>
    return 0;
    80004a04:	4a81                	li	s5,0
    80004a06:	b7d5                	j	800049ea <create+0x5c>
    80004a08:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004a0a:	85da                	mv	a1,s6
    80004a0c:	4088                	lw	a0,0(s1)
    80004a0e:	f5afe0ef          	jal	80003168 <ialloc>
    80004a12:	8a2a                	mv	s4,a0
    80004a14:	cd15                	beqz	a0,80004a50 <create+0xc2>
  ilock(ip);
    80004a16:	8c3fe0ef          	jal	800032d8 <ilock>
  ip->major = major;
    80004a1a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004a1e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004a22:	4905                	li	s2,1
    80004a24:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004a28:	8552                	mv	a0,s4
    80004a2a:	ffafe0ef          	jal	80003224 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004a2e:	032b0763          	beq	s6,s2,80004a5c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a32:	004a2603          	lw	a2,4(s4)
    80004a36:	fb040593          	addi	a1,s0,-80
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	eddfe0ef          	jal	80003918 <dirlink>
    80004a40:	06054563          	bltz	a0,80004aaa <create+0x11c>
  iunlockput(dp);
    80004a44:	8526                	mv	a0,s1
    80004a46:	a9dfe0ef          	jal	800034e2 <iunlockput>
  return ip;
    80004a4a:	8ad2                	mv	s5,s4
    80004a4c:	7a02                	ld	s4,32(sp)
    80004a4e:	bf71                	j	800049ea <create+0x5c>
    iunlockput(dp);
    80004a50:	8526                	mv	a0,s1
    80004a52:	a91fe0ef          	jal	800034e2 <iunlockput>
    return 0;
    80004a56:	8ad2                	mv	s5,s4
    80004a58:	7a02                	ld	s4,32(sp)
    80004a5a:	bf41                	j	800049ea <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004a5c:	004a2603          	lw	a2,4(s4)
    80004a60:	00003597          	auipc	a1,0x3
    80004a64:	bc058593          	addi	a1,a1,-1088 # 80007620 <etext+0x620>
    80004a68:	8552                	mv	a0,s4
    80004a6a:	eaffe0ef          	jal	80003918 <dirlink>
    80004a6e:	02054e63          	bltz	a0,80004aaa <create+0x11c>
    80004a72:	40d0                	lw	a2,4(s1)
    80004a74:	00003597          	auipc	a1,0x3
    80004a78:	bb458593          	addi	a1,a1,-1100 # 80007628 <etext+0x628>
    80004a7c:	8552                	mv	a0,s4
    80004a7e:	e9bfe0ef          	jal	80003918 <dirlink>
    80004a82:	02054463          	bltz	a0,80004aaa <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004a86:	004a2603          	lw	a2,4(s4)
    80004a8a:	fb040593          	addi	a1,s0,-80
    80004a8e:	8526                	mv	a0,s1
    80004a90:	e89fe0ef          	jal	80003918 <dirlink>
    80004a94:	00054b63          	bltz	a0,80004aaa <create+0x11c>
    dp->nlink++;  // for ".."
    80004a98:	04a4d783          	lhu	a5,74(s1)
    80004a9c:	2785                	addiw	a5,a5,1
    80004a9e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aa2:	8526                	mv	a0,s1
    80004aa4:	f80fe0ef          	jal	80003224 <iupdate>
    80004aa8:	bf71                	j	80004a44 <create+0xb6>
  ip->nlink = 0;
    80004aaa:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004aae:	8552                	mv	a0,s4
    80004ab0:	f74fe0ef          	jal	80003224 <iupdate>
  iunlockput(ip);
    80004ab4:	8552                	mv	a0,s4
    80004ab6:	a2dfe0ef          	jal	800034e2 <iunlockput>
  iunlockput(dp);
    80004aba:	8526                	mv	a0,s1
    80004abc:	a27fe0ef          	jal	800034e2 <iunlockput>
  return 0;
    80004ac0:	7a02                	ld	s4,32(sp)
    80004ac2:	b725                	j	800049ea <create+0x5c>
    return 0;
    80004ac4:	8aaa                	mv	s5,a0
    80004ac6:	b715                	j	800049ea <create+0x5c>

0000000080004ac8 <sys_dup>:
{
    80004ac8:	7179                	addi	sp,sp,-48
    80004aca:	f406                	sd	ra,40(sp)
    80004acc:	f022                	sd	s0,32(sp)
    80004ace:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004ad0:	fd840613          	addi	a2,s0,-40
    80004ad4:	4581                	li	a1,0
    80004ad6:	4501                	li	a0,0
    80004ad8:	e21ff0ef          	jal	800048f8 <argfd>
    return -1;
    80004adc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004ade:	02054363          	bltz	a0,80004b04 <sys_dup+0x3c>
    80004ae2:	ec26                	sd	s1,24(sp)
    80004ae4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004ae6:	fd843903          	ld	s2,-40(s0)
    80004aea:	854a                	mv	a0,s2
    80004aec:	e65ff0ef          	jal	80004950 <fdalloc>
    80004af0:	84aa                	mv	s1,a0
    return -1;
    80004af2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004af4:	00054d63          	bltz	a0,80004b0e <sys_dup+0x46>
  filedup(f);
    80004af8:	854a                	mv	a0,s2
    80004afa:	c48ff0ef          	jal	80003f42 <filedup>
  return fd;
    80004afe:	87a6                	mv	a5,s1
    80004b00:	64e2                	ld	s1,24(sp)
    80004b02:	6942                	ld	s2,16(sp)
}
    80004b04:	853e                	mv	a0,a5
    80004b06:	70a2                	ld	ra,40(sp)
    80004b08:	7402                	ld	s0,32(sp)
    80004b0a:	6145                	addi	sp,sp,48
    80004b0c:	8082                	ret
    80004b0e:	64e2                	ld	s1,24(sp)
    80004b10:	6942                	ld	s2,16(sp)
    80004b12:	bfcd                	j	80004b04 <sys_dup+0x3c>

0000000080004b14 <sys_read>:
{
    80004b14:	7179                	addi	sp,sp,-48
    80004b16:	f406                	sd	ra,40(sp)
    80004b18:	f022                	sd	s0,32(sp)
    80004b1a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b1c:	fd840593          	addi	a1,s0,-40
    80004b20:	4505                	li	a0,1
    80004b22:	d47fd0ef          	jal	80002868 <argaddr>
  argint(2, &n);
    80004b26:	fe440593          	addi	a1,s0,-28
    80004b2a:	4509                	li	a0,2
    80004b2c:	d21fd0ef          	jal	8000284c <argint>
  if(argfd(0, 0, &f) < 0)
    80004b30:	fe840613          	addi	a2,s0,-24
    80004b34:	4581                	li	a1,0
    80004b36:	4501                	li	a0,0
    80004b38:	dc1ff0ef          	jal	800048f8 <argfd>
    80004b3c:	87aa                	mv	a5,a0
    return -1;
    80004b3e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b40:	0007ca63          	bltz	a5,80004b54 <sys_read+0x40>
  return fileread(f, p, n);
    80004b44:	fe442603          	lw	a2,-28(s0)
    80004b48:	fd843583          	ld	a1,-40(s0)
    80004b4c:	fe843503          	ld	a0,-24(s0)
    80004b50:	d58ff0ef          	jal	800040a8 <fileread>
}
    80004b54:	70a2                	ld	ra,40(sp)
    80004b56:	7402                	ld	s0,32(sp)
    80004b58:	6145                	addi	sp,sp,48
    80004b5a:	8082                	ret

0000000080004b5c <sys_write>:
{
    80004b5c:	7179                	addi	sp,sp,-48
    80004b5e:	f406                	sd	ra,40(sp)
    80004b60:	f022                	sd	s0,32(sp)
    80004b62:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004b64:	fd840593          	addi	a1,s0,-40
    80004b68:	4505                	li	a0,1
    80004b6a:	cfffd0ef          	jal	80002868 <argaddr>
  argint(2, &n);
    80004b6e:	fe440593          	addi	a1,s0,-28
    80004b72:	4509                	li	a0,2
    80004b74:	cd9fd0ef          	jal	8000284c <argint>
  if(argfd(0, 0, &f) < 0)
    80004b78:	fe840613          	addi	a2,s0,-24
    80004b7c:	4581                	li	a1,0
    80004b7e:	4501                	li	a0,0
    80004b80:	d79ff0ef          	jal	800048f8 <argfd>
    80004b84:	87aa                	mv	a5,a0
    return -1;
    80004b86:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b88:	0007ca63          	bltz	a5,80004b9c <sys_write+0x40>
  return filewrite(f, p, n);
    80004b8c:	fe442603          	lw	a2,-28(s0)
    80004b90:	fd843583          	ld	a1,-40(s0)
    80004b94:	fe843503          	ld	a0,-24(s0)
    80004b98:	dceff0ef          	jal	80004166 <filewrite>
}
    80004b9c:	70a2                	ld	ra,40(sp)
    80004b9e:	7402                	ld	s0,32(sp)
    80004ba0:	6145                	addi	sp,sp,48
    80004ba2:	8082                	ret

0000000080004ba4 <sys_close>:
{
    80004ba4:	1101                	addi	sp,sp,-32
    80004ba6:	ec06                	sd	ra,24(sp)
    80004ba8:	e822                	sd	s0,16(sp)
    80004baa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004bac:	fe040613          	addi	a2,s0,-32
    80004bb0:	fec40593          	addi	a1,s0,-20
    80004bb4:	4501                	li	a0,0
    80004bb6:	d43ff0ef          	jal	800048f8 <argfd>
    return -1;
    80004bba:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004bbc:	02054063          	bltz	a0,80004bdc <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004bc0:	d21fc0ef          	jal	800018e0 <myproc>
    80004bc4:	fec42783          	lw	a5,-20(s0)
    80004bc8:	07e9                	addi	a5,a5,26
    80004bca:	078e                	slli	a5,a5,0x3
    80004bcc:	953e                	add	a0,a0,a5
    80004bce:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004bd2:	fe043503          	ld	a0,-32(s0)
    80004bd6:	bb2ff0ef          	jal	80003f88 <fileclose>
  return 0;
    80004bda:	4781                	li	a5,0
}
    80004bdc:	853e                	mv	a0,a5
    80004bde:	60e2                	ld	ra,24(sp)
    80004be0:	6442                	ld	s0,16(sp)
    80004be2:	6105                	addi	sp,sp,32
    80004be4:	8082                	ret

0000000080004be6 <sys_fstat>:
{
    80004be6:	1101                	addi	sp,sp,-32
    80004be8:	ec06                	sd	ra,24(sp)
    80004bea:	e822                	sd	s0,16(sp)
    80004bec:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004bee:	fe040593          	addi	a1,s0,-32
    80004bf2:	4505                	li	a0,1
    80004bf4:	c75fd0ef          	jal	80002868 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004bf8:	fe840613          	addi	a2,s0,-24
    80004bfc:	4581                	li	a1,0
    80004bfe:	4501                	li	a0,0
    80004c00:	cf9ff0ef          	jal	800048f8 <argfd>
    80004c04:	87aa                	mv	a5,a0
    return -1;
    80004c06:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004c08:	0007c863          	bltz	a5,80004c18 <sys_fstat+0x32>
  return filestat(f, st);
    80004c0c:	fe043583          	ld	a1,-32(s0)
    80004c10:	fe843503          	ld	a0,-24(s0)
    80004c14:	c36ff0ef          	jal	8000404a <filestat>
}
    80004c18:	60e2                	ld	ra,24(sp)
    80004c1a:	6442                	ld	s0,16(sp)
    80004c1c:	6105                	addi	sp,sp,32
    80004c1e:	8082                	ret

0000000080004c20 <sys_link>:
{
    80004c20:	7169                	addi	sp,sp,-304
    80004c22:	f606                	sd	ra,296(sp)
    80004c24:	f222                	sd	s0,288(sp)
    80004c26:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c28:	08000613          	li	a2,128
    80004c2c:	ed040593          	addi	a1,s0,-304
    80004c30:	4501                	li	a0,0
    80004c32:	c53fd0ef          	jal	80002884 <argstr>
    return -1;
    80004c36:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c38:	0c054e63          	bltz	a0,80004d14 <sys_link+0xf4>
    80004c3c:	08000613          	li	a2,128
    80004c40:	f5040593          	addi	a1,s0,-176
    80004c44:	4505                	li	a0,1
    80004c46:	c3ffd0ef          	jal	80002884 <argstr>
    return -1;
    80004c4a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004c4c:	0c054463          	bltz	a0,80004d14 <sys_link+0xf4>
    80004c50:	ee26                	sd	s1,280(sp)
  begin_op();
    80004c52:	f1dfe0ef          	jal	80003b6e <begin_op>
  if((ip = namei(old)) == 0){
    80004c56:	ed040513          	addi	a0,s0,-304
    80004c5a:	d59fe0ef          	jal	800039b2 <namei>
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	c53d                	beqz	a0,80004cce <sys_link+0xae>
  ilock(ip);
    80004c62:	e76fe0ef          	jal	800032d8 <ilock>
  if(ip->type == T_DIR){
    80004c66:	04449703          	lh	a4,68(s1)
    80004c6a:	4785                	li	a5,1
    80004c6c:	06f70663          	beq	a4,a5,80004cd8 <sys_link+0xb8>
    80004c70:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004c72:	04a4d783          	lhu	a5,74(s1)
    80004c76:	2785                	addiw	a5,a5,1
    80004c78:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	da6fe0ef          	jal	80003224 <iupdate>
  iunlock(ip);
    80004c82:	8526                	mv	a0,s1
    80004c84:	f02fe0ef          	jal	80003386 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c88:	fd040593          	addi	a1,s0,-48
    80004c8c:	f5040513          	addi	a0,s0,-176
    80004c90:	d3dfe0ef          	jal	800039cc <nameiparent>
    80004c94:	892a                	mv	s2,a0
    80004c96:	cd21                	beqz	a0,80004cee <sys_link+0xce>
  ilock(dp);
    80004c98:	e40fe0ef          	jal	800032d8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c9c:	00092703          	lw	a4,0(s2)
    80004ca0:	409c                	lw	a5,0(s1)
    80004ca2:	04f71363          	bne	a4,a5,80004ce8 <sys_link+0xc8>
    80004ca6:	40d0                	lw	a2,4(s1)
    80004ca8:	fd040593          	addi	a1,s0,-48
    80004cac:	854a                	mv	a0,s2
    80004cae:	c6bfe0ef          	jal	80003918 <dirlink>
    80004cb2:	02054b63          	bltz	a0,80004ce8 <sys_link+0xc8>
  iunlockput(dp);
    80004cb6:	854a                	mv	a0,s2
    80004cb8:	82bfe0ef          	jal	800034e2 <iunlockput>
  iput(ip);
    80004cbc:	8526                	mv	a0,s1
    80004cbe:	f9cfe0ef          	jal	8000345a <iput>
  end_op();
    80004cc2:	f17fe0ef          	jal	80003bd8 <end_op>
  return 0;
    80004cc6:	4781                	li	a5,0
    80004cc8:	64f2                	ld	s1,280(sp)
    80004cca:	6952                	ld	s2,272(sp)
    80004ccc:	a0a1                	j	80004d14 <sys_link+0xf4>
    end_op();
    80004cce:	f0bfe0ef          	jal	80003bd8 <end_op>
    return -1;
    80004cd2:	57fd                	li	a5,-1
    80004cd4:	64f2                	ld	s1,280(sp)
    80004cd6:	a83d                	j	80004d14 <sys_link+0xf4>
    iunlockput(ip);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	809fe0ef          	jal	800034e2 <iunlockput>
    end_op();
    80004cde:	efbfe0ef          	jal	80003bd8 <end_op>
    return -1;
    80004ce2:	57fd                	li	a5,-1
    80004ce4:	64f2                	ld	s1,280(sp)
    80004ce6:	a03d                	j	80004d14 <sys_link+0xf4>
    iunlockput(dp);
    80004ce8:	854a                	mv	a0,s2
    80004cea:	ff8fe0ef          	jal	800034e2 <iunlockput>
  ilock(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	de8fe0ef          	jal	800032d8 <ilock>
  ip->nlink--;
    80004cf4:	04a4d783          	lhu	a5,74(s1)
    80004cf8:	37fd                	addiw	a5,a5,-1
    80004cfa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004cfe:	8526                	mv	a0,s1
    80004d00:	d24fe0ef          	jal	80003224 <iupdate>
  iunlockput(ip);
    80004d04:	8526                	mv	a0,s1
    80004d06:	fdcfe0ef          	jal	800034e2 <iunlockput>
  end_op();
    80004d0a:	ecffe0ef          	jal	80003bd8 <end_op>
  return -1;
    80004d0e:	57fd                	li	a5,-1
    80004d10:	64f2                	ld	s1,280(sp)
    80004d12:	6952                	ld	s2,272(sp)
}
    80004d14:	853e                	mv	a0,a5
    80004d16:	70b2                	ld	ra,296(sp)
    80004d18:	7412                	ld	s0,288(sp)
    80004d1a:	6155                	addi	sp,sp,304
    80004d1c:	8082                	ret

0000000080004d1e <sys_unlink>:
{
    80004d1e:	7151                	addi	sp,sp,-240
    80004d20:	f586                	sd	ra,232(sp)
    80004d22:	f1a2                	sd	s0,224(sp)
    80004d24:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004d26:	08000613          	li	a2,128
    80004d2a:	f3040593          	addi	a1,s0,-208
    80004d2e:	4501                	li	a0,0
    80004d30:	b55fd0ef          	jal	80002884 <argstr>
    80004d34:	16054063          	bltz	a0,80004e94 <sys_unlink+0x176>
    80004d38:	eda6                	sd	s1,216(sp)
  begin_op();
    80004d3a:	e35fe0ef          	jal	80003b6e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004d3e:	fb040593          	addi	a1,s0,-80
    80004d42:	f3040513          	addi	a0,s0,-208
    80004d46:	c87fe0ef          	jal	800039cc <nameiparent>
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	c945                	beqz	a0,80004dfc <sys_unlink+0xde>
  ilock(dp);
    80004d4e:	d8afe0ef          	jal	800032d8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d52:	00003597          	auipc	a1,0x3
    80004d56:	8ce58593          	addi	a1,a1,-1842 # 80007620 <etext+0x620>
    80004d5a:	fb040513          	addi	a0,s0,-80
    80004d5e:	9d9fe0ef          	jal	80003736 <namecmp>
    80004d62:	10050e63          	beqz	a0,80004e7e <sys_unlink+0x160>
    80004d66:	00003597          	auipc	a1,0x3
    80004d6a:	8c258593          	addi	a1,a1,-1854 # 80007628 <etext+0x628>
    80004d6e:	fb040513          	addi	a0,s0,-80
    80004d72:	9c5fe0ef          	jal	80003736 <namecmp>
    80004d76:	10050463          	beqz	a0,80004e7e <sys_unlink+0x160>
    80004d7a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d7c:	f2c40613          	addi	a2,s0,-212
    80004d80:	fb040593          	addi	a1,s0,-80
    80004d84:	8526                	mv	a0,s1
    80004d86:	9c7fe0ef          	jal	8000374c <dirlookup>
    80004d8a:	892a                	mv	s2,a0
    80004d8c:	0e050863          	beqz	a0,80004e7c <sys_unlink+0x15e>
  ilock(ip);
    80004d90:	d48fe0ef          	jal	800032d8 <ilock>
  if(ip->nlink < 1)
    80004d94:	04a91783          	lh	a5,74(s2)
    80004d98:	06f05763          	blez	a5,80004e06 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d9c:	04491703          	lh	a4,68(s2)
    80004da0:	4785                	li	a5,1
    80004da2:	06f70963          	beq	a4,a5,80004e14 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004da6:	4641                	li	a2,16
    80004da8:	4581                	li	a1,0
    80004daa:	fc040513          	addi	a0,s0,-64
    80004dae:	f1bfb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004db2:	4741                	li	a4,16
    80004db4:	f2c42683          	lw	a3,-212(s0)
    80004db8:	fc040613          	addi	a2,s0,-64
    80004dbc:	4581                	li	a1,0
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	869fe0ef          	jal	80003628 <writei>
    80004dc4:	47c1                	li	a5,16
    80004dc6:	08f51b63          	bne	a0,a5,80004e5c <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004dca:	04491703          	lh	a4,68(s2)
    80004dce:	4785                	li	a5,1
    80004dd0:	08f70d63          	beq	a4,a5,80004e6a <sys_unlink+0x14c>
  iunlockput(dp);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	f0cfe0ef          	jal	800034e2 <iunlockput>
  ip->nlink--;
    80004dda:	04a95783          	lhu	a5,74(s2)
    80004dde:	37fd                	addiw	a5,a5,-1
    80004de0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004de4:	854a                	mv	a0,s2
    80004de6:	c3efe0ef          	jal	80003224 <iupdate>
  iunlockput(ip);
    80004dea:	854a                	mv	a0,s2
    80004dec:	ef6fe0ef          	jal	800034e2 <iunlockput>
  end_op();
    80004df0:	de9fe0ef          	jal	80003bd8 <end_op>
  return 0;
    80004df4:	4501                	li	a0,0
    80004df6:	64ee                	ld	s1,216(sp)
    80004df8:	694e                	ld	s2,208(sp)
    80004dfa:	a849                	j	80004e8c <sys_unlink+0x16e>
    end_op();
    80004dfc:	dddfe0ef          	jal	80003bd8 <end_op>
    return -1;
    80004e00:	557d                	li	a0,-1
    80004e02:	64ee                	ld	s1,216(sp)
    80004e04:	a061                	j	80004e8c <sys_unlink+0x16e>
    80004e06:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004e08:	00003517          	auipc	a0,0x3
    80004e0c:	82850513          	addi	a0,a0,-2008 # 80007630 <etext+0x630>
    80004e10:	985fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e14:	04c92703          	lw	a4,76(s2)
    80004e18:	02000793          	li	a5,32
    80004e1c:	f8e7f5e3          	bgeu	a5,a4,80004da6 <sys_unlink+0x88>
    80004e20:	e5ce                	sd	s3,200(sp)
    80004e22:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e26:	4741                	li	a4,16
    80004e28:	86ce                	mv	a3,s3
    80004e2a:	f1840613          	addi	a2,s0,-232
    80004e2e:	4581                	li	a1,0
    80004e30:	854a                	mv	a0,s2
    80004e32:	efafe0ef          	jal	8000352c <readi>
    80004e36:	47c1                	li	a5,16
    80004e38:	00f51c63          	bne	a0,a5,80004e50 <sys_unlink+0x132>
    if(de.inum != 0)
    80004e3c:	f1845783          	lhu	a5,-232(s0)
    80004e40:	efa1                	bnez	a5,80004e98 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e42:	29c1                	addiw	s3,s3,16
    80004e44:	04c92783          	lw	a5,76(s2)
    80004e48:	fcf9efe3          	bltu	s3,a5,80004e26 <sys_unlink+0x108>
    80004e4c:	69ae                	ld	s3,200(sp)
    80004e4e:	bfa1                	j	80004da6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004e50:	00002517          	auipc	a0,0x2
    80004e54:	7f850513          	addi	a0,a0,2040 # 80007648 <etext+0x648>
    80004e58:	93dfb0ef          	jal	80000794 <panic>
    80004e5c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e5e:	00003517          	auipc	a0,0x3
    80004e62:	80250513          	addi	a0,a0,-2046 # 80007660 <etext+0x660>
    80004e66:	92ffb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80004e6a:	04a4d783          	lhu	a5,74(s1)
    80004e6e:	37fd                	addiw	a5,a5,-1
    80004e70:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e74:	8526                	mv	a0,s1
    80004e76:	baefe0ef          	jal	80003224 <iupdate>
    80004e7a:	bfa9                	j	80004dd4 <sys_unlink+0xb6>
    80004e7c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e7e:	8526                	mv	a0,s1
    80004e80:	e62fe0ef          	jal	800034e2 <iunlockput>
  end_op();
    80004e84:	d55fe0ef          	jal	80003bd8 <end_op>
  return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	64ee                	ld	s1,216(sp)
}
    80004e8c:	70ae                	ld	ra,232(sp)
    80004e8e:	740e                	ld	s0,224(sp)
    80004e90:	616d                	addi	sp,sp,240
    80004e92:	8082                	ret
    return -1;
    80004e94:	557d                	li	a0,-1
    80004e96:	bfdd                	j	80004e8c <sys_unlink+0x16e>
    iunlockput(ip);
    80004e98:	854a                	mv	a0,s2
    80004e9a:	e48fe0ef          	jal	800034e2 <iunlockput>
    goto bad;
    80004e9e:	694e                	ld	s2,208(sp)
    80004ea0:	69ae                	ld	s3,200(sp)
    80004ea2:	bff1                	j	80004e7e <sys_unlink+0x160>

0000000080004ea4 <sys_open>:

uint64
sys_open(void)
{
    80004ea4:	7131                	addi	sp,sp,-192
    80004ea6:	fd06                	sd	ra,184(sp)
    80004ea8:	f922                	sd	s0,176(sp)
    80004eaa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004eac:	f4c40593          	addi	a1,s0,-180
    80004eb0:	4505                	li	a0,1
    80004eb2:	99bfd0ef          	jal	8000284c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004eb6:	08000613          	li	a2,128
    80004eba:	f5040593          	addi	a1,s0,-176
    80004ebe:	4501                	li	a0,0
    80004ec0:	9c5fd0ef          	jal	80002884 <argstr>
    80004ec4:	87aa                	mv	a5,a0
    return -1;
    80004ec6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ec8:	0a07c263          	bltz	a5,80004f6c <sys_open+0xc8>
    80004ecc:	f526                	sd	s1,168(sp)

  begin_op();
    80004ece:	ca1fe0ef          	jal	80003b6e <begin_op>

  if(omode & O_CREATE){
    80004ed2:	f4c42783          	lw	a5,-180(s0)
    80004ed6:	2007f793          	andi	a5,a5,512
    80004eda:	c3d5                	beqz	a5,80004f7e <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004edc:	4681                	li	a3,0
    80004ede:	4601                	li	a2,0
    80004ee0:	4589                	li	a1,2
    80004ee2:	f5040513          	addi	a0,s0,-176
    80004ee6:	aa9ff0ef          	jal	8000498e <create>
    80004eea:	84aa                	mv	s1,a0
    if(ip == 0){
    80004eec:	c541                	beqz	a0,80004f74 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004eee:	04449703          	lh	a4,68(s1)
    80004ef2:	478d                	li	a5,3
    80004ef4:	00f71763          	bne	a4,a5,80004f02 <sys_open+0x5e>
    80004ef8:	0464d703          	lhu	a4,70(s1)
    80004efc:	47a5                	li	a5,9
    80004efe:	0ae7ed63          	bltu	a5,a4,80004fb8 <sys_open+0x114>
    80004f02:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f04:	fe1fe0ef          	jal	80003ee4 <filealloc>
    80004f08:	892a                	mv	s2,a0
    80004f0a:	c179                	beqz	a0,80004fd0 <sys_open+0x12c>
    80004f0c:	ed4e                	sd	s3,152(sp)
    80004f0e:	a43ff0ef          	jal	80004950 <fdalloc>
    80004f12:	89aa                	mv	s3,a0
    80004f14:	0a054a63          	bltz	a0,80004fc8 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f18:	04449703          	lh	a4,68(s1)
    80004f1c:	478d                	li	a5,3
    80004f1e:	0cf70263          	beq	a4,a5,80004fe2 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f22:	4789                	li	a5,2
    80004f24:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f28:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f2c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f30:	f4c42783          	lw	a5,-180(s0)
    80004f34:	0017c713          	xori	a4,a5,1
    80004f38:	8b05                	andi	a4,a4,1
    80004f3a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f3e:	0037f713          	andi	a4,a5,3
    80004f42:	00e03733          	snez	a4,a4
    80004f46:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f4a:	4007f793          	andi	a5,a5,1024
    80004f4e:	c791                	beqz	a5,80004f5a <sys_open+0xb6>
    80004f50:	04449703          	lh	a4,68(s1)
    80004f54:	4789                	li	a5,2
    80004f56:	08f70d63          	beq	a4,a5,80004ff0 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f5a:	8526                	mv	a0,s1
    80004f5c:	c2afe0ef          	jal	80003386 <iunlock>
  end_op();
    80004f60:	c79fe0ef          	jal	80003bd8 <end_op>

  return fd;
    80004f64:	854e                	mv	a0,s3
    80004f66:	74aa                	ld	s1,168(sp)
    80004f68:	790a                	ld	s2,160(sp)
    80004f6a:	69ea                	ld	s3,152(sp)
}
    80004f6c:	70ea                	ld	ra,184(sp)
    80004f6e:	744a                	ld	s0,176(sp)
    80004f70:	6129                	addi	sp,sp,192
    80004f72:	8082                	ret
      end_op();
    80004f74:	c65fe0ef          	jal	80003bd8 <end_op>
      return -1;
    80004f78:	557d                	li	a0,-1
    80004f7a:	74aa                	ld	s1,168(sp)
    80004f7c:	bfc5                	j	80004f6c <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004f7e:	f5040513          	addi	a0,s0,-176
    80004f82:	a31fe0ef          	jal	800039b2 <namei>
    80004f86:	84aa                	mv	s1,a0
    80004f88:	c11d                	beqz	a0,80004fae <sys_open+0x10a>
    ilock(ip);
    80004f8a:	b4efe0ef          	jal	800032d8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f8e:	04449703          	lh	a4,68(s1)
    80004f92:	4785                	li	a5,1
    80004f94:	f4f71de3          	bne	a4,a5,80004eee <sys_open+0x4a>
    80004f98:	f4c42783          	lw	a5,-180(s0)
    80004f9c:	d3bd                	beqz	a5,80004f02 <sys_open+0x5e>
      iunlockput(ip);
    80004f9e:	8526                	mv	a0,s1
    80004fa0:	d42fe0ef          	jal	800034e2 <iunlockput>
      end_op();
    80004fa4:	c35fe0ef          	jal	80003bd8 <end_op>
      return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	74aa                	ld	s1,168(sp)
    80004fac:	b7c1                	j	80004f6c <sys_open+0xc8>
      end_op();
    80004fae:	c2bfe0ef          	jal	80003bd8 <end_op>
      return -1;
    80004fb2:	557d                	li	a0,-1
    80004fb4:	74aa                	ld	s1,168(sp)
    80004fb6:	bf5d                	j	80004f6c <sys_open+0xc8>
    iunlockput(ip);
    80004fb8:	8526                	mv	a0,s1
    80004fba:	d28fe0ef          	jal	800034e2 <iunlockput>
    end_op();
    80004fbe:	c1bfe0ef          	jal	80003bd8 <end_op>
    return -1;
    80004fc2:	557d                	li	a0,-1
    80004fc4:	74aa                	ld	s1,168(sp)
    80004fc6:	b75d                	j	80004f6c <sys_open+0xc8>
      fileclose(f);
    80004fc8:	854a                	mv	a0,s2
    80004fca:	fbffe0ef          	jal	80003f88 <fileclose>
    80004fce:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	d10fe0ef          	jal	800034e2 <iunlockput>
    end_op();
    80004fd6:	c03fe0ef          	jal	80003bd8 <end_op>
    return -1;
    80004fda:	557d                	li	a0,-1
    80004fdc:	74aa                	ld	s1,168(sp)
    80004fde:	790a                	ld	s2,160(sp)
    80004fe0:	b771                	j	80004f6c <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004fe2:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004fe6:	04649783          	lh	a5,70(s1)
    80004fea:	02f91223          	sh	a5,36(s2)
    80004fee:	bf3d                	j	80004f2c <sys_open+0x88>
    itrunc(ip);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	bd4fe0ef          	jal	800033c6 <itrunc>
    80004ff6:	b795                	j	80004f5a <sys_open+0xb6>

0000000080004ff8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ff8:	7175                	addi	sp,sp,-144
    80004ffa:	e506                	sd	ra,136(sp)
    80004ffc:	e122                	sd	s0,128(sp)
    80004ffe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005000:	b6ffe0ef          	jal	80003b6e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005004:	08000613          	li	a2,128
    80005008:	f7040593          	addi	a1,s0,-144
    8000500c:	4501                	li	a0,0
    8000500e:	877fd0ef          	jal	80002884 <argstr>
    80005012:	02054363          	bltz	a0,80005038 <sys_mkdir+0x40>
    80005016:	4681                	li	a3,0
    80005018:	4601                	li	a2,0
    8000501a:	4585                	li	a1,1
    8000501c:	f7040513          	addi	a0,s0,-144
    80005020:	96fff0ef          	jal	8000498e <create>
    80005024:	c911                	beqz	a0,80005038 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005026:	cbcfe0ef          	jal	800034e2 <iunlockput>
  end_op();
    8000502a:	baffe0ef          	jal	80003bd8 <end_op>
  return 0;
    8000502e:	4501                	li	a0,0
}
    80005030:	60aa                	ld	ra,136(sp)
    80005032:	640a                	ld	s0,128(sp)
    80005034:	6149                	addi	sp,sp,144
    80005036:	8082                	ret
    end_op();
    80005038:	ba1fe0ef          	jal	80003bd8 <end_op>
    return -1;
    8000503c:	557d                	li	a0,-1
    8000503e:	bfcd                	j	80005030 <sys_mkdir+0x38>

0000000080005040 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005040:	7135                	addi	sp,sp,-160
    80005042:	ed06                	sd	ra,152(sp)
    80005044:	e922                	sd	s0,144(sp)
    80005046:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005048:	b27fe0ef          	jal	80003b6e <begin_op>
  argint(1, &major);
    8000504c:	f6c40593          	addi	a1,s0,-148
    80005050:	4505                	li	a0,1
    80005052:	ffafd0ef          	jal	8000284c <argint>
  argint(2, &minor);
    80005056:	f6840593          	addi	a1,s0,-152
    8000505a:	4509                	li	a0,2
    8000505c:	ff0fd0ef          	jal	8000284c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005060:	08000613          	li	a2,128
    80005064:	f7040593          	addi	a1,s0,-144
    80005068:	4501                	li	a0,0
    8000506a:	81bfd0ef          	jal	80002884 <argstr>
    8000506e:	02054563          	bltz	a0,80005098 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005072:	f6841683          	lh	a3,-152(s0)
    80005076:	f6c41603          	lh	a2,-148(s0)
    8000507a:	458d                	li	a1,3
    8000507c:	f7040513          	addi	a0,s0,-144
    80005080:	90fff0ef          	jal	8000498e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005084:	c911                	beqz	a0,80005098 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005086:	c5cfe0ef          	jal	800034e2 <iunlockput>
  end_op();
    8000508a:	b4ffe0ef          	jal	80003bd8 <end_op>
  return 0;
    8000508e:	4501                	li	a0,0
}
    80005090:	60ea                	ld	ra,152(sp)
    80005092:	644a                	ld	s0,144(sp)
    80005094:	610d                	addi	sp,sp,160
    80005096:	8082                	ret
    end_op();
    80005098:	b41fe0ef          	jal	80003bd8 <end_op>
    return -1;
    8000509c:	557d                	li	a0,-1
    8000509e:	bfcd                	j	80005090 <sys_mknod+0x50>

00000000800050a0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050a0:	7135                	addi	sp,sp,-160
    800050a2:	ed06                	sd	ra,152(sp)
    800050a4:	e922                	sd	s0,144(sp)
    800050a6:	e14a                	sd	s2,128(sp)
    800050a8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050aa:	837fc0ef          	jal	800018e0 <myproc>
    800050ae:	892a                	mv	s2,a0
  
  begin_op();
    800050b0:	abffe0ef          	jal	80003b6e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050b4:	08000613          	li	a2,128
    800050b8:	f6040593          	addi	a1,s0,-160
    800050bc:	4501                	li	a0,0
    800050be:	fc6fd0ef          	jal	80002884 <argstr>
    800050c2:	04054363          	bltz	a0,80005108 <sys_chdir+0x68>
    800050c6:	e526                	sd	s1,136(sp)
    800050c8:	f6040513          	addi	a0,s0,-160
    800050cc:	8e7fe0ef          	jal	800039b2 <namei>
    800050d0:	84aa                	mv	s1,a0
    800050d2:	c915                	beqz	a0,80005106 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800050d4:	a04fe0ef          	jal	800032d8 <ilock>
  if(ip->type != T_DIR){
    800050d8:	04449703          	lh	a4,68(s1)
    800050dc:	4785                	li	a5,1
    800050de:	02f71963          	bne	a4,a5,80005110 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050e2:	8526                	mv	a0,s1
    800050e4:	aa2fe0ef          	jal	80003386 <iunlock>
  iput(p->cwd);
    800050e8:	15093503          	ld	a0,336(s2)
    800050ec:	b6efe0ef          	jal	8000345a <iput>
  end_op();
    800050f0:	ae9fe0ef          	jal	80003bd8 <end_op>
  p->cwd = ip;
    800050f4:	14993823          	sd	s1,336(s2)
  return 0;
    800050f8:	4501                	li	a0,0
    800050fa:	64aa                	ld	s1,136(sp)
}
    800050fc:	60ea                	ld	ra,152(sp)
    800050fe:	644a                	ld	s0,144(sp)
    80005100:	690a                	ld	s2,128(sp)
    80005102:	610d                	addi	sp,sp,160
    80005104:	8082                	ret
    80005106:	64aa                	ld	s1,136(sp)
    end_op();
    80005108:	ad1fe0ef          	jal	80003bd8 <end_op>
    return -1;
    8000510c:	557d                	li	a0,-1
    8000510e:	b7fd                	j	800050fc <sys_chdir+0x5c>
    iunlockput(ip);
    80005110:	8526                	mv	a0,s1
    80005112:	bd0fe0ef          	jal	800034e2 <iunlockput>
    end_op();
    80005116:	ac3fe0ef          	jal	80003bd8 <end_op>
    return -1;
    8000511a:	557d                	li	a0,-1
    8000511c:	64aa                	ld	s1,136(sp)
    8000511e:	bff9                	j	800050fc <sys_chdir+0x5c>

0000000080005120 <sys_exec>:

uint64
sys_exec(void)
{
    80005120:	7121                	addi	sp,sp,-448
    80005122:	ff06                	sd	ra,440(sp)
    80005124:	fb22                	sd	s0,432(sp)
    80005126:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005128:	e4840593          	addi	a1,s0,-440
    8000512c:	4505                	li	a0,1
    8000512e:	f3afd0ef          	jal	80002868 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005132:	08000613          	li	a2,128
    80005136:	f5040593          	addi	a1,s0,-176
    8000513a:	4501                	li	a0,0
    8000513c:	f48fd0ef          	jal	80002884 <argstr>
    80005140:	87aa                	mv	a5,a0
    return -1;
    80005142:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005144:	0c07c463          	bltz	a5,8000520c <sys_exec+0xec>
    80005148:	f726                	sd	s1,424(sp)
    8000514a:	f34a                	sd	s2,416(sp)
    8000514c:	ef4e                	sd	s3,408(sp)
    8000514e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005150:	10000613          	li	a2,256
    80005154:	4581                	li	a1,0
    80005156:	e5040513          	addi	a0,s0,-432
    8000515a:	b6ffb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000515e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005162:	89a6                	mv	s3,s1
    80005164:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005166:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000516a:	00391513          	slli	a0,s2,0x3
    8000516e:	e4040593          	addi	a1,s0,-448
    80005172:	e4843783          	ld	a5,-440(s0)
    80005176:	953e                	add	a0,a0,a5
    80005178:	e4afd0ef          	jal	800027c2 <fetchaddr>
    8000517c:	02054663          	bltz	a0,800051a8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005180:	e4043783          	ld	a5,-448(s0)
    80005184:	c3a9                	beqz	a5,800051c6 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005186:	99ffb0ef          	jal	80000b24 <kalloc>
    8000518a:	85aa                	mv	a1,a0
    8000518c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005190:	cd01                	beqz	a0,800051a8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005192:	6605                	lui	a2,0x1
    80005194:	e4043503          	ld	a0,-448(s0)
    80005198:	e74fd0ef          	jal	8000280c <fetchstr>
    8000519c:	00054663          	bltz	a0,800051a8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800051a0:	0905                	addi	s2,s2,1
    800051a2:	09a1                	addi	s3,s3,8
    800051a4:	fd4913e3          	bne	s2,s4,8000516a <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051a8:	f5040913          	addi	s2,s0,-176
    800051ac:	6088                	ld	a0,0(s1)
    800051ae:	c931                	beqz	a0,80005202 <sys_exec+0xe2>
    kfree(argv[i]);
    800051b0:	893fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b4:	04a1                	addi	s1,s1,8
    800051b6:	ff249be3          	bne	s1,s2,800051ac <sys_exec+0x8c>
  return -1;
    800051ba:	557d                	li	a0,-1
    800051bc:	74ba                	ld	s1,424(sp)
    800051be:	791a                	ld	s2,416(sp)
    800051c0:	69fa                	ld	s3,408(sp)
    800051c2:	6a5a                	ld	s4,400(sp)
    800051c4:	a0a1                	j	8000520c <sys_exec+0xec>
      argv[i] = 0;
    800051c6:	0009079b          	sext.w	a5,s2
    800051ca:	078e                	slli	a5,a5,0x3
    800051cc:	fd078793          	addi	a5,a5,-48
    800051d0:	97a2                	add	a5,a5,s0
    800051d2:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800051d6:	e5040593          	addi	a1,s0,-432
    800051da:	f5040513          	addi	a0,s0,-176
    800051de:	ba8ff0ef          	jal	80004586 <exec>
    800051e2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e4:	f5040993          	addi	s3,s0,-176
    800051e8:	6088                	ld	a0,0(s1)
    800051ea:	c511                	beqz	a0,800051f6 <sys_exec+0xd6>
    kfree(argv[i]);
    800051ec:	857fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051f0:	04a1                	addi	s1,s1,8
    800051f2:	ff349be3          	bne	s1,s3,800051e8 <sys_exec+0xc8>
  return ret;
    800051f6:	854a                	mv	a0,s2
    800051f8:	74ba                	ld	s1,424(sp)
    800051fa:	791a                	ld	s2,416(sp)
    800051fc:	69fa                	ld	s3,408(sp)
    800051fe:	6a5a                	ld	s4,400(sp)
    80005200:	a031                	j	8000520c <sys_exec+0xec>
  return -1;
    80005202:	557d                	li	a0,-1
    80005204:	74ba                	ld	s1,424(sp)
    80005206:	791a                	ld	s2,416(sp)
    80005208:	69fa                	ld	s3,408(sp)
    8000520a:	6a5a                	ld	s4,400(sp)
}
    8000520c:	70fa                	ld	ra,440(sp)
    8000520e:	745a                	ld	s0,432(sp)
    80005210:	6139                	addi	sp,sp,448
    80005212:	8082                	ret

0000000080005214 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005214:	7139                	addi	sp,sp,-64
    80005216:	fc06                	sd	ra,56(sp)
    80005218:	f822                	sd	s0,48(sp)
    8000521a:	f426                	sd	s1,40(sp)
    8000521c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000521e:	ec2fc0ef          	jal	800018e0 <myproc>
    80005222:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005224:	fd840593          	addi	a1,s0,-40
    80005228:	4501                	li	a0,0
    8000522a:	e3efd0ef          	jal	80002868 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000522e:	fc840593          	addi	a1,s0,-56
    80005232:	fd040513          	addi	a0,s0,-48
    80005236:	85cff0ef          	jal	80004292 <pipealloc>
    return -1;
    8000523a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000523c:	0a054463          	bltz	a0,800052e4 <sys_pipe+0xd0>
  fd0 = -1;
    80005240:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005244:	fd043503          	ld	a0,-48(s0)
    80005248:	f08ff0ef          	jal	80004950 <fdalloc>
    8000524c:	fca42223          	sw	a0,-60(s0)
    80005250:	08054163          	bltz	a0,800052d2 <sys_pipe+0xbe>
    80005254:	fc843503          	ld	a0,-56(s0)
    80005258:	ef8ff0ef          	jal	80004950 <fdalloc>
    8000525c:	fca42023          	sw	a0,-64(s0)
    80005260:	06054063          	bltz	a0,800052c0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005264:	4691                	li	a3,4
    80005266:	fc440613          	addi	a2,s0,-60
    8000526a:	fd843583          	ld	a1,-40(s0)
    8000526e:	68a8                	ld	a0,80(s1)
    80005270:	ae2fc0ef          	jal	80001552 <copyout>
    80005274:	00054e63          	bltz	a0,80005290 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005278:	4691                	li	a3,4
    8000527a:	fc040613          	addi	a2,s0,-64
    8000527e:	fd843583          	ld	a1,-40(s0)
    80005282:	0591                	addi	a1,a1,4
    80005284:	68a8                	ld	a0,80(s1)
    80005286:	accfc0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000528a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000528c:	04055c63          	bgez	a0,800052e4 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005290:	fc442783          	lw	a5,-60(s0)
    80005294:	07e9                	addi	a5,a5,26
    80005296:	078e                	slli	a5,a5,0x3
    80005298:	97a6                	add	a5,a5,s1
    8000529a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000529e:	fc042783          	lw	a5,-64(s0)
    800052a2:	07e9                	addi	a5,a5,26
    800052a4:	078e                	slli	a5,a5,0x3
    800052a6:	94be                	add	s1,s1,a5
    800052a8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800052ac:	fd043503          	ld	a0,-48(s0)
    800052b0:	cd9fe0ef          	jal	80003f88 <fileclose>
    fileclose(wf);
    800052b4:	fc843503          	ld	a0,-56(s0)
    800052b8:	cd1fe0ef          	jal	80003f88 <fileclose>
    return -1;
    800052bc:	57fd                	li	a5,-1
    800052be:	a01d                	j	800052e4 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800052c0:	fc442783          	lw	a5,-60(s0)
    800052c4:	0007c763          	bltz	a5,800052d2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800052c8:	07e9                	addi	a5,a5,26
    800052ca:	078e                	slli	a5,a5,0x3
    800052cc:	97a6                	add	a5,a5,s1
    800052ce:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052d2:	fd043503          	ld	a0,-48(s0)
    800052d6:	cb3fe0ef          	jal	80003f88 <fileclose>
    fileclose(wf);
    800052da:	fc843503          	ld	a0,-56(s0)
    800052de:	cabfe0ef          	jal	80003f88 <fileclose>
    return -1;
    800052e2:	57fd                	li	a5,-1
}
    800052e4:	853e                	mv	a0,a5
    800052e6:	70e2                	ld	ra,56(sp)
    800052e8:	7442                	ld	s0,48(sp)
    800052ea:	74a2                	ld	s1,40(sp)
    800052ec:	6121                	addi	sp,sp,64
    800052ee:	8082                	ret

00000000800052f0 <kernelvec>:
    800052f0:	7111                	addi	sp,sp,-256
    800052f2:	e006                	sd	ra,0(sp)
    800052f4:	e40a                	sd	sp,8(sp)
    800052f6:	e80e                	sd	gp,16(sp)
    800052f8:	ec12                	sd	tp,24(sp)
    800052fa:	f016                	sd	t0,32(sp)
    800052fc:	f41a                	sd	t1,40(sp)
    800052fe:	f81e                	sd	t2,48(sp)
    80005300:	e4aa                	sd	a0,72(sp)
    80005302:	e8ae                	sd	a1,80(sp)
    80005304:	ecb2                	sd	a2,88(sp)
    80005306:	f0b6                	sd	a3,96(sp)
    80005308:	f4ba                	sd	a4,104(sp)
    8000530a:	f8be                	sd	a5,112(sp)
    8000530c:	fcc2                	sd	a6,120(sp)
    8000530e:	e146                	sd	a7,128(sp)
    80005310:	edf2                	sd	t3,216(sp)
    80005312:	f1f6                	sd	t4,224(sp)
    80005314:	f5fa                	sd	t5,232(sp)
    80005316:	f9fe                	sd	t6,240(sp)
    80005318:	bbafd0ef          	jal	800026d2 <kerneltrap>
    8000531c:	6082                	ld	ra,0(sp)
    8000531e:	6122                	ld	sp,8(sp)
    80005320:	61c2                	ld	gp,16(sp)
    80005322:	7282                	ld	t0,32(sp)
    80005324:	7322                	ld	t1,40(sp)
    80005326:	73c2                	ld	t2,48(sp)
    80005328:	6526                	ld	a0,72(sp)
    8000532a:	65c6                	ld	a1,80(sp)
    8000532c:	6666                	ld	a2,88(sp)
    8000532e:	7686                	ld	a3,96(sp)
    80005330:	7726                	ld	a4,104(sp)
    80005332:	77c6                	ld	a5,112(sp)
    80005334:	7866                	ld	a6,120(sp)
    80005336:	688a                	ld	a7,128(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	addi	sp,sp,256
    80005342:	10200073          	sret
	...

000000008000534e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534e:	1141                	addi	sp,sp,-16
    80005350:	e422                	sd	s0,8(sp)
    80005352:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005354:	0c0007b7          	lui	a5,0xc000
    80005358:	4705                	li	a4,1
    8000535a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000535c:	0c0007b7          	lui	a5,0xc000
    80005360:	c3d8                	sw	a4,4(a5)
}
    80005362:	6422                	ld	s0,8(sp)
    80005364:	0141                	addi	sp,sp,16
    80005366:	8082                	ret

0000000080005368 <plicinithart>:

void
plicinithart(void)
{
    80005368:	1141                	addi	sp,sp,-16
    8000536a:	e406                	sd	ra,8(sp)
    8000536c:	e022                	sd	s0,0(sp)
    8000536e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005370:	d44fc0ef          	jal	800018b4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005374:	0085171b          	slliw	a4,a0,0x8
    80005378:	0c0027b7          	lui	a5,0xc002
    8000537c:	97ba                	add	a5,a5,a4
    8000537e:	40200713          	li	a4,1026
    80005382:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005386:	00d5151b          	slliw	a0,a0,0xd
    8000538a:	0c2017b7          	lui	a5,0xc201
    8000538e:	97aa                	add	a5,a5,a0
    80005390:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000539c:	1141                	addi	sp,sp,-16
    8000539e:	e406                	sd	ra,8(sp)
    800053a0:	e022                	sd	s0,0(sp)
    800053a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a4:	d10fc0ef          	jal	800018b4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5151b          	slliw	a0,a0,0xd
    800053ac:	0c2017b7          	lui	a5,0xc201
    800053b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800053b2:	43c8                	lw	a0,4(a5)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	cecfc0ef          	jal	800018b4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053cc:	00d5151b          	slliw	a0,a0,0xd
    800053d0:	0c2017b7          	lui	a5,0xc201
    800053d4:	97aa                	add	a5,a5,a0
    800053d6:	c3c4                	sw	s1,4(a5)
}
    800053d8:	60e2                	ld	ra,24(sp)
    800053da:	6442                	ld	s0,16(sp)
    800053dc:	64a2                	ld	s1,8(sp)
    800053de:	6105                	addi	sp,sp,32
    800053e0:	8082                	ret

00000000800053e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e2:	1141                	addi	sp,sp,-16
    800053e4:	e406                	sd	ra,8(sp)
    800053e6:	e022                	sd	s0,0(sp)
    800053e8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ea:	479d                	li	a5,7
    800053ec:	04a7ca63          	blt	a5,a0,80005440 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800053f0:	0001b797          	auipc	a5,0x1b
    800053f4:	72078793          	addi	a5,a5,1824 # 80020b10 <disk>
    800053f8:	97aa                	add	a5,a5,a0
    800053fa:	0187c783          	lbu	a5,24(a5)
    800053fe:	e7b9                	bnez	a5,8000544c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005400:	00451693          	slli	a3,a0,0x4
    80005404:	0001b797          	auipc	a5,0x1b
    80005408:	70c78793          	addi	a5,a5,1804 # 80020b10 <disk>
    8000540c:	6398                	ld	a4,0(a5)
    8000540e:	9736                	add	a4,a4,a3
    80005410:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005414:	6398                	ld	a4,0(a5)
    80005416:	9736                	add	a4,a4,a3
    80005418:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000541c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005420:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005424:	97aa                	add	a5,a5,a0
    80005426:	4705                	li	a4,1
    80005428:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000542c:	0001b517          	auipc	a0,0x1b
    80005430:	6fc50513          	addi	a0,a0,1788 # 80020b28 <disk+0x18>
    80005434:	b51fc0ef          	jal	80001f84 <wakeup>
}
    80005438:	60a2                	ld	ra,8(sp)
    8000543a:	6402                	ld	s0,0(sp)
    8000543c:	0141                	addi	sp,sp,16
    8000543e:	8082                	ret
    panic("free_desc 1");
    80005440:	00002517          	auipc	a0,0x2
    80005444:	23050513          	addi	a0,a0,560 # 80007670 <etext+0x670>
    80005448:	b4cfb0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000544c:	00002517          	auipc	a0,0x2
    80005450:	23450513          	addi	a0,a0,564 # 80007680 <etext+0x680>
    80005454:	b40fb0ef          	jal	80000794 <panic>

0000000080005458 <virtio_disk_init>:
{
    80005458:	1101                	addi	sp,sp,-32
    8000545a:	ec06                	sd	ra,24(sp)
    8000545c:	e822                	sd	s0,16(sp)
    8000545e:	e426                	sd	s1,8(sp)
    80005460:	e04a                	sd	s2,0(sp)
    80005462:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005464:	00002597          	auipc	a1,0x2
    80005468:	22c58593          	addi	a1,a1,556 # 80007690 <etext+0x690>
    8000546c:	0001b517          	auipc	a0,0x1b
    80005470:	7cc50513          	addi	a0,a0,1996 # 80020c38 <disk+0x128>
    80005474:	f00fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005478:	100017b7          	lui	a5,0x10001
    8000547c:	4398                	lw	a4,0(a5)
    8000547e:	2701                	sext.w	a4,a4
    80005480:	747277b7          	lui	a5,0x74727
    80005484:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005488:	18f71063          	bne	a4,a5,80005608 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000548c:	100017b7          	lui	a5,0x10001
    80005490:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005492:	439c                	lw	a5,0(a5)
    80005494:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005496:	4709                	li	a4,2
    80005498:	16e79863          	bne	a5,a4,80005608 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000549c:	100017b7          	lui	a5,0x10001
    800054a0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054a2:	439c                	lw	a5,0(a5)
    800054a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054a6:	16e79163          	bne	a5,a4,80005608 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054aa:	100017b7          	lui	a5,0x10001
    800054ae:	47d8                	lw	a4,12(a5)
    800054b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054b2:	554d47b7          	lui	a5,0x554d4
    800054b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ba:	14f71763          	bne	a4,a5,80005608 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054be:	100017b7          	lui	a5,0x10001
    800054c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c6:	4705                	li	a4,1
    800054c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ca:	470d                	li	a4,3
    800054cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054ce:	10001737          	lui	a4,0x10001
    800054d2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054d4:	c7ffe737          	lui	a4,0xc7ffe
    800054d8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb0f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054dc:	8ef9                	and	a3,a3,a4
    800054de:	10001737          	lui	a4,0x10001
    800054e2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e4:	472d                	li	a4,11
    800054e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800054ec:	439c                	lw	a5,0(a5)
    800054ee:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054f2:	8ba1                	andi	a5,a5,8
    800054f4:	12078063          	beqz	a5,80005614 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054f8:	100017b7          	lui	a5,0x10001
    800054fc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005500:	100017b7          	lui	a5,0x10001
    80005504:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005508:	439c                	lw	a5,0(a5)
    8000550a:	2781                	sext.w	a5,a5
    8000550c:	10079a63          	bnez	a5,80005620 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005510:	100017b7          	lui	a5,0x10001
    80005514:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005518:	439c                	lw	a5,0(a5)
    8000551a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000551c:	10078863          	beqz	a5,8000562c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005520:	471d                	li	a4,7
    80005522:	10f77b63          	bgeu	a4,a5,80005638 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005526:	dfefb0ef          	jal	80000b24 <kalloc>
    8000552a:	0001b497          	auipc	s1,0x1b
    8000552e:	5e648493          	addi	s1,s1,1510 # 80020b10 <disk>
    80005532:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005534:	df0fb0ef          	jal	80000b24 <kalloc>
    80005538:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000553a:	deafb0ef          	jal	80000b24 <kalloc>
    8000553e:	87aa                	mv	a5,a0
    80005540:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005542:	6088                	ld	a0,0(s1)
    80005544:	10050063          	beqz	a0,80005644 <virtio_disk_init+0x1ec>
    80005548:	0001b717          	auipc	a4,0x1b
    8000554c:	5d073703          	ld	a4,1488(a4) # 80020b18 <disk+0x8>
    80005550:	0e070a63          	beqz	a4,80005644 <virtio_disk_init+0x1ec>
    80005554:	0e078863          	beqz	a5,80005644 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005558:	6605                	lui	a2,0x1
    8000555a:	4581                	li	a1,0
    8000555c:	f6cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005560:	0001b497          	auipc	s1,0x1b
    80005564:	5b048493          	addi	s1,s1,1456 # 80020b10 <disk>
    80005568:	6605                	lui	a2,0x1
    8000556a:	4581                	li	a1,0
    8000556c:	6488                	ld	a0,8(s1)
    8000556e:	f5afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005572:	6605                	lui	a2,0x1
    80005574:	4581                	li	a1,0
    80005576:	6888                	ld	a0,16(s1)
    80005578:	f50fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	4721                	li	a4,8
    80005582:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005584:	4098                	lw	a4,0(s1)
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000558e:	40d8                	lw	a4,4(s1)
    80005590:	100017b7          	lui	a5,0x10001
    80005594:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005598:	649c                	ld	a5,8(s1)
    8000559a:	0007869b          	sext.w	a3,a5
    8000559e:	10001737          	lui	a4,0x10001
    800055a2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055a6:	9781                	srai	a5,a5,0x20
    800055a8:	10001737          	lui	a4,0x10001
    800055ac:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055b0:	689c                	ld	a5,16(s1)
    800055b2:	0007869b          	sext.w	a3,a5
    800055b6:	10001737          	lui	a4,0x10001
    800055ba:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055be:	9781                	srai	a5,a5,0x20
    800055c0:	10001737          	lui	a4,0x10001
    800055c4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055c8:	10001737          	lui	a4,0x10001
    800055cc:	4785                	li	a5,1
    800055ce:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800055d0:	00f48c23          	sb	a5,24(s1)
    800055d4:	00f48ca3          	sb	a5,25(s1)
    800055d8:	00f48d23          	sb	a5,26(s1)
    800055dc:	00f48da3          	sb	a5,27(s1)
    800055e0:	00f48e23          	sb	a5,28(s1)
    800055e4:	00f48ea3          	sb	a5,29(s1)
    800055e8:	00f48f23          	sb	a5,30(s1)
    800055ec:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055f0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055f4:	100017b7          	lui	a5,0x10001
    800055f8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800055fc:	60e2                	ld	ra,24(sp)
    800055fe:	6442                	ld	s0,16(sp)
    80005600:	64a2                	ld	s1,8(sp)
    80005602:	6902                	ld	s2,0(sp)
    80005604:	6105                	addi	sp,sp,32
    80005606:	8082                	ret
    panic("could not find virtio disk");
    80005608:	00002517          	auipc	a0,0x2
    8000560c:	09850513          	addi	a0,a0,152 # 800076a0 <etext+0x6a0>
    80005610:	984fb0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005614:	00002517          	auipc	a0,0x2
    80005618:	0ac50513          	addi	a0,a0,172 # 800076c0 <etext+0x6c0>
    8000561c:	978fb0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005620:	00002517          	auipc	a0,0x2
    80005624:	0c050513          	addi	a0,a0,192 # 800076e0 <etext+0x6e0>
    80005628:	96cfb0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    8000562c:	00002517          	auipc	a0,0x2
    80005630:	0d450513          	addi	a0,a0,212 # 80007700 <etext+0x700>
    80005634:	960fb0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005638:	00002517          	auipc	a0,0x2
    8000563c:	0e850513          	addi	a0,a0,232 # 80007720 <etext+0x720>
    80005640:	954fb0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005644:	00002517          	auipc	a0,0x2
    80005648:	0fc50513          	addi	a0,a0,252 # 80007740 <etext+0x740>
    8000564c:	948fb0ef          	jal	80000794 <panic>

0000000080005650 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005650:	7159                	addi	sp,sp,-112
    80005652:	f486                	sd	ra,104(sp)
    80005654:	f0a2                	sd	s0,96(sp)
    80005656:	eca6                	sd	s1,88(sp)
    80005658:	e8ca                	sd	s2,80(sp)
    8000565a:	e4ce                	sd	s3,72(sp)
    8000565c:	e0d2                	sd	s4,64(sp)
    8000565e:	fc56                	sd	s5,56(sp)
    80005660:	f85a                	sd	s6,48(sp)
    80005662:	f45e                	sd	s7,40(sp)
    80005664:	f062                	sd	s8,32(sp)
    80005666:	ec66                	sd	s9,24(sp)
    80005668:	1880                	addi	s0,sp,112
    8000566a:	8a2a                	mv	s4,a0
    8000566c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000566e:	00c52c83          	lw	s9,12(a0)
    80005672:	001c9c9b          	slliw	s9,s9,0x1
    80005676:	1c82                	slli	s9,s9,0x20
    80005678:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000567c:	0001b517          	auipc	a0,0x1b
    80005680:	5bc50513          	addi	a0,a0,1468 # 80020c38 <disk+0x128>
    80005684:	d70fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005688:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000568a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000568c:	0001bb17          	auipc	s6,0x1b
    80005690:	484b0b13          	addi	s6,s6,1156 # 80020b10 <disk>
  for(int i = 0; i < 3; i++){
    80005694:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005696:	0001bc17          	auipc	s8,0x1b
    8000569a:	5a2c0c13          	addi	s8,s8,1442 # 80020c38 <disk+0x128>
    8000569e:	a8b9                	j	800056fc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800056a0:	00fb0733          	add	a4,s6,a5
    800056a4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800056a8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056aa:	0207c563          	bltz	a5,800056d4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056ae:	2905                	addiw	s2,s2,1
    800056b0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800056b2:	05590963          	beq	s2,s5,80005704 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800056b6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056b8:	0001b717          	auipc	a4,0x1b
    800056bc:	45870713          	addi	a4,a4,1112 # 80020b10 <disk>
    800056c0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056c2:	01874683          	lbu	a3,24(a4)
    800056c6:	fee9                	bnez	a3,800056a0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800056c8:	2785                	addiw	a5,a5,1
    800056ca:	0705                	addi	a4,a4,1
    800056cc:	fe979be3          	bne	a5,s1,800056c2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056d0:	57fd                	li	a5,-1
    800056d2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056d4:	01205d63          	blez	s2,800056ee <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056d8:	f9042503          	lw	a0,-112(s0)
    800056dc:	d07ff0ef          	jal	800053e2 <free_desc>
      for(int j = 0; j < i; j++)
    800056e0:	4785                	li	a5,1
    800056e2:	0127d663          	bge	a5,s2,800056ee <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800056e6:	f9442503          	lw	a0,-108(s0)
    800056ea:	cf9ff0ef          	jal	800053e2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056ee:	85e2                	mv	a1,s8
    800056f0:	0001b517          	auipc	a0,0x1b
    800056f4:	43850513          	addi	a0,a0,1080 # 80020b28 <disk+0x18>
    800056f8:	841fc0ef          	jal	80001f38 <sleep>
  for(int i = 0; i < 3; i++){
    800056fc:	f9040613          	addi	a2,s0,-112
    80005700:	894e                	mv	s2,s3
    80005702:	bf55                	j	800056b6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005704:	f9042503          	lw	a0,-112(s0)
    80005708:	00451693          	slli	a3,a0,0x4

  if(write)
    8000570c:	0001b797          	auipc	a5,0x1b
    80005710:	40478793          	addi	a5,a5,1028 # 80020b10 <disk>
    80005714:	00a50713          	addi	a4,a0,10
    80005718:	0712                	slli	a4,a4,0x4
    8000571a:	973e                	add	a4,a4,a5
    8000571c:	01703633          	snez	a2,s7
    80005720:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005722:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005726:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000572a:	6398                	ld	a4,0(a5)
    8000572c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000572e:	0a868613          	addi	a2,a3,168
    80005732:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005734:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005736:	6390                	ld	a2,0(a5)
    80005738:	00d605b3          	add	a1,a2,a3
    8000573c:	4741                	li	a4,16
    8000573e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005740:	4805                	li	a6,1
    80005742:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005746:	f9442703          	lw	a4,-108(s0)
    8000574a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000574e:	0712                	slli	a4,a4,0x4
    80005750:	963a                	add	a2,a2,a4
    80005752:	058a0593          	addi	a1,s4,88
    80005756:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005758:	0007b883          	ld	a7,0(a5)
    8000575c:	9746                	add	a4,a4,a7
    8000575e:	40000613          	li	a2,1024
    80005762:	c710                	sw	a2,8(a4)
  if(write)
    80005764:	001bb613          	seqz	a2,s7
    80005768:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000576c:	00166613          	ori	a2,a2,1
    80005770:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005774:	f9842583          	lw	a1,-104(s0)
    80005778:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000577c:	00250613          	addi	a2,a0,2
    80005780:	0612                	slli	a2,a2,0x4
    80005782:	963e                	add	a2,a2,a5
    80005784:	577d                	li	a4,-1
    80005786:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000578a:	0592                	slli	a1,a1,0x4
    8000578c:	98ae                	add	a7,a7,a1
    8000578e:	03068713          	addi	a4,a3,48
    80005792:	973e                	add	a4,a4,a5
    80005794:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005798:	6398                	ld	a4,0(a5)
    8000579a:	972e                	add	a4,a4,a1
    8000579c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057a0:	4689                	li	a3,2
    800057a2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800057a6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057aa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800057ae:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057b2:	6794                	ld	a3,8(a5)
    800057b4:	0026d703          	lhu	a4,2(a3)
    800057b8:	8b1d                	andi	a4,a4,7
    800057ba:	0706                	slli	a4,a4,0x1
    800057bc:	96ba                	add	a3,a3,a4
    800057be:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057c2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057c6:	6798                	ld	a4,8(a5)
    800057c8:	00275783          	lhu	a5,2(a4)
    800057cc:	2785                	addiw	a5,a5,1
    800057ce:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057d2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057d6:	100017b7          	lui	a5,0x10001
    800057da:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057de:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057e2:	0001b917          	auipc	s2,0x1b
    800057e6:	45690913          	addi	s2,s2,1110 # 80020c38 <disk+0x128>
  while(b->disk == 1) {
    800057ea:	4485                	li	s1,1
    800057ec:	01079a63          	bne	a5,a6,80005800 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800057f0:	85ca                	mv	a1,s2
    800057f2:	8552                	mv	a0,s4
    800057f4:	f44fc0ef          	jal	80001f38 <sleep>
  while(b->disk == 1) {
    800057f8:	004a2783          	lw	a5,4(s4)
    800057fc:	fe978ae3          	beq	a5,s1,800057f0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005800:	f9042903          	lw	s2,-112(s0)
    80005804:	00290713          	addi	a4,s2,2
    80005808:	0712                	slli	a4,a4,0x4
    8000580a:	0001b797          	auipc	a5,0x1b
    8000580e:	30678793          	addi	a5,a5,774 # 80020b10 <disk>
    80005812:	97ba                	add	a5,a5,a4
    80005814:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005818:	0001b997          	auipc	s3,0x1b
    8000581c:	2f898993          	addi	s3,s3,760 # 80020b10 <disk>
    80005820:	00491713          	slli	a4,s2,0x4
    80005824:	0009b783          	ld	a5,0(s3)
    80005828:	97ba                	add	a5,a5,a4
    8000582a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000582e:	854a                	mv	a0,s2
    80005830:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005834:	bafff0ef          	jal	800053e2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005838:	8885                	andi	s1,s1,1
    8000583a:	f0fd                	bnez	s1,80005820 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000583c:	0001b517          	auipc	a0,0x1b
    80005840:	3fc50513          	addi	a0,a0,1020 # 80020c38 <disk+0x128>
    80005844:	c48fb0ef          	jal	80000c8c <release>
}
    80005848:	70a6                	ld	ra,104(sp)
    8000584a:	7406                	ld	s0,96(sp)
    8000584c:	64e6                	ld	s1,88(sp)
    8000584e:	6946                	ld	s2,80(sp)
    80005850:	69a6                	ld	s3,72(sp)
    80005852:	6a06                	ld	s4,64(sp)
    80005854:	7ae2                	ld	s5,56(sp)
    80005856:	7b42                	ld	s6,48(sp)
    80005858:	7ba2                	ld	s7,40(sp)
    8000585a:	7c02                	ld	s8,32(sp)
    8000585c:	6ce2                	ld	s9,24(sp)
    8000585e:	6165                	addi	sp,sp,112
    80005860:	8082                	ret

0000000080005862 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005862:	1101                	addi	sp,sp,-32
    80005864:	ec06                	sd	ra,24(sp)
    80005866:	e822                	sd	s0,16(sp)
    80005868:	e426                	sd	s1,8(sp)
    8000586a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000586c:	0001b497          	auipc	s1,0x1b
    80005870:	2a448493          	addi	s1,s1,676 # 80020b10 <disk>
    80005874:	0001b517          	auipc	a0,0x1b
    80005878:	3c450513          	addi	a0,a0,964 # 80020c38 <disk+0x128>
    8000587c:	b78fb0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005880:	100017b7          	lui	a5,0x10001
    80005884:	53b8                	lw	a4,96(a5)
    80005886:	8b0d                	andi	a4,a4,3
    80005888:	100017b7          	lui	a5,0x10001
    8000588c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000588e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005892:	689c                	ld	a5,16(s1)
    80005894:	0204d703          	lhu	a4,32(s1)
    80005898:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000589c:	04f70663          	beq	a4,a5,800058e8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    800058a0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058a4:	6898                	ld	a4,16(s1)
    800058a6:	0204d783          	lhu	a5,32(s1)
    800058aa:	8b9d                	andi	a5,a5,7
    800058ac:	078e                	slli	a5,a5,0x3
    800058ae:	97ba                	add	a5,a5,a4
    800058b0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058b2:	00278713          	addi	a4,a5,2
    800058b6:	0712                	slli	a4,a4,0x4
    800058b8:	9726                	add	a4,a4,s1
    800058ba:	01074703          	lbu	a4,16(a4)
    800058be:	e321                	bnez	a4,800058fe <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058c0:	0789                	addi	a5,a5,2
    800058c2:	0792                	slli	a5,a5,0x4
    800058c4:	97a6                	add	a5,a5,s1
    800058c6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058c8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058cc:	eb8fc0ef          	jal	80001f84 <wakeup>

    disk.used_idx += 1;
    800058d0:	0204d783          	lhu	a5,32(s1)
    800058d4:	2785                	addiw	a5,a5,1
    800058d6:	17c2                	slli	a5,a5,0x30
    800058d8:	93c1                	srli	a5,a5,0x30
    800058da:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058de:	6898                	ld	a4,16(s1)
    800058e0:	00275703          	lhu	a4,2(a4)
    800058e4:	faf71ee3          	bne	a4,a5,800058a0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058e8:	0001b517          	auipc	a0,0x1b
    800058ec:	35050513          	addi	a0,a0,848 # 80020c38 <disk+0x128>
    800058f0:	b9cfb0ef          	jal	80000c8c <release>
}
    800058f4:	60e2                	ld	ra,24(sp)
    800058f6:	6442                	ld	s0,16(sp)
    800058f8:	64a2                	ld	s1,8(sp)
    800058fa:	6105                	addi	sp,sp,32
    800058fc:	8082                	ret
      panic("virtio_disk_intr status");
    800058fe:	00002517          	auipc	a0,0x2
    80005902:	e5a50513          	addi	a0,a0,-422 # 80007758 <etext+0x758>
    80005906:	e8ffa0ef          	jal	80000794 <panic>

000000008000590a <random>:
unsigned int seed = 1;

int
random(int max) {
    8000590a:	1141                	addi	sp,sp,-16
    8000590c:	e422                	sd	s0,8(sp)
    8000590e:	0800                	addi	s0,sp,16
  seed = seed * 1664525 + 1013904223;
    80005910:	00002697          	auipc	a3,0x2
    80005914:	f8868693          	addi	a3,a3,-120 # 80007898 <seed>
    80005918:	4298                	lw	a4,0(a3)
    8000591a:	001967b7          	lui	a5,0x196
    8000591e:	60d7879b          	addiw	a5,a5,1549 # 19660d <_entry-0x7fe699f3>
    80005922:	02e787bb          	mulw	a5,a5,a4
    80005926:	3c6ef737          	lui	a4,0x3c6ef
    8000592a:	35f7071b          	addiw	a4,a4,863 # 3c6ef35f <_entry-0x43910ca1>
    8000592e:	9fb9                	addw	a5,a5,a4
    80005930:	c29c                	sw	a5,0(a3)
  return seed % max;
}
    80005932:	02a7f53b          	remuw	a0,a5,a0
    80005936:	6422                	ld	s0,8(sp)
    80005938:	0141                	addi	sp,sp,16
    8000593a:	8082                	ret
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
