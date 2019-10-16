#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define TEST		0
#define COPY_PASTE_CALC	1

#if ! TEST
	#define NBITS 	20
	#define SIZE	(1<<NBITS)	// tamaño suficiente para tiempo apreciable
	unsigned lista[SIZE];
	#define RESULT	(NBITS*(1<<NBITS-1))
#else
/* ---------------------------------------------------------------------------- * /
	#define SIZE 	4
	unsigned lista[SIZE]={ 0x80000000, 0x00100000, 0x00000800, 0x00000001};
	#define RESULT	4
/* ---------------------------------------------------------------------------- * /
	#define SIZE	8
	unsigned lista[SIZE]={ 0x7fffffff, 0xffefffff, 0xfffff7ff, 0xfffffffe, 
			       0x01000024, 0x00356700, 0x8900ac00, 0x00bd00ef};
	#define RESULT	156
/* ---------------------------------------------------------------------------- */
	#define SIZE 	8
	unsigned lista[SIZE]={ 0x0	 , 0x10204080, 0x3590ac06, 0x70b0d0e0,
			       0xffffffff, 0x12345678, 0x9abcdef0, 0xcafebeef};
	#define RESULT	116
/* ---------------------------------------------------------------------------- */
#endif
	int resultado=0;

int popcount1(unsigned* array, int len) {
    int  	i,j;   
    unsigned	x;		// No puede ser int para que no meta bits de signo
    int	 result=0;

    for (i=0; i<len; i++) {
	x = array[i];	 
	for (j=0; j<8*sizeof(unsigned);j++) {	
	   result += x & 0x1;
	   x >>= 1;
	}
    }

    return result;
}

int popcount2(unsigned* array, int len) {
    int  	i;   
    unsigned	x;		// No puede ser int para que no meta bits de signo
    int	 result=0;

    for (i=0; i<len; i++) {
	x = array[i];	 
	do {
	   result += x & 0x1;
	   x >>= 1;
	} while (x);
    }

    return result;
}

int popcount3(unsigned* array, int len) {
    int  	i;   
    unsigned	x;		// No puede ser int para que no meta bits de signo
    int	 result=0;

    for (i=0; i<len; i++) {
	x = array[i];	 
        asm("\n"
	    "ini3:\n\t"			// saltar aquí mientras que x!=0
	    "shr %[x]\n\t"		// LSB en CF
	    "adc $0, %[r]\n\t"		// sumar el CF a result
	    "test %[x], %[x]\n\t"
	    "jne ini3\n\t"
	    : [r]"+r" (result)		// e/s: añadir a lo acumulado por el momento
	    : [x] "r" (x)		// entrada: valor elemento
	   );
    }

    return result;
}

int popcount4(unsigned* array, int len) {
    int    val = 0,
	result = 0,
   	      i, j;
    unsigned     x;

    for (i = 0; i < len; i++) {
      val = 0;
      x = array[i];

      for (j = 0; j < 8; j++) {
	val += x & 0x01010101;
	x >>= 1;
      }

      // Sumando en árbol los 4 Bytes
      val += (val >> 16);	
      val += (val >> 8);

      // Aplicando la máscara
      val &= 0xFF;

      result += val;
    }


    return result;
}


// ver https://github.com/WojciechMula/sse-popcount/blob/master/original/ssse3_popcount.c
// y http://web.archive.org/web/20100701222327/http:/wm.ite.pl/articles/sse-popcount.html
int popcount5(unsigned* array, int len) {
    int    val = 0,
	result = 0,
                 i,
         SSE_mask[] = {0x0f0f0f0f,0x0f0f0f0f,0x0f0f0f0f,0x0f0f0f0f}, 
         SSE_LUTb[] = {0x02010100,0x03020201,0x03020201,0x04030302};
		//     3 2 1 0    7 6 5 4    1110 9 8   15141312

    if (len & 0x3) 
      printf("leyendo 128b pero len no es múltiplo de 4?\n");

    for (i=0; i<len; i+=4) {
      asm("movdqu    %[x], %%xmm0 \n\t"
          "movdqa  %%xmm0, %%xmm1 \n\t" // dos copias de x
	  "movdqu    %[m], %%xmm6 \n\t" // máscara
	  "psrlw      $4 , %%xmm1 \n\t"
	  "pand    %%xmm6, %%xmm0 \n\t" //; xmm0 – nibbles inferiores
	  "pand    %%xmm6, %%xmm1 \n\t" //; xmm1 – nibbles superiores

	  "movdqu    %[l], %%xmm2 \n\t" //; ...como pshufb sobrescribe LUT
	  "movdqa  %%xmm2, %%xmm3 \n\t" //; ...queremos 2 copias
	  "pshufb  %%xmm0, %%xmm2 \n\t" //; xmm2 = vector popcount inferiores
	  "pshufb  %%xmm1, %%xmm3 \n\t" //; xmm3 = vector popcount superiores

	  "paddb   %%xmm2, %%xmm3 \n\t" //; xmm3 - vector popcount bytes
	  "pxor    %%xmm0, %%xmm0 \n\t" //; xmm0 = 0,0,0,0
	  "psadbw  %%xmm0, %%xmm3 \n\t" //; xmm3 = [pcnt bytes0..7|pcnt bytes8..15]
	  "movhlps %%xmm3, %%xmm0 \n\t" //; xmm0 = [ 	0 	 |pcnt bytes0..7 ]
	  "paddd   %%xmm3, %%xmm0 \n\t" //; xmm0 = [  no usado    |pcnt bytes     ]
	  "movd    %%xmm0, %[val] \n\t" //;

	  : [val]"=r" (val)
	  :   [x] "m" (array[i]),
	      [m] "m" (SSE_mask[0]),
	      [l] "m" (SSE_LUTb[0])
	  );
       result += val;
    }

    return result;
}

int popcount6(unsigned* array, int len) {
    int    val = 0,
	result = 0,
		 i;
    unsigned     x;

    for (i = 0; i < len; i++) {
      x = array[i];

      asm("popcnt %[x], %[val]"
	  : [val] "=r" (val)
 	  :   [x]  "r" (x)
      );

      result += val;
    }

    return result;
} 

int popcount7(unsigned* array, int len){
    int i;
    unsigned x1,x2;
    int val,result=0;

    if (len & 0x1)
      printf("leer 64b y len impar?\n");

    for (i=0; i<len; i+=2) {
      x1 = array[i]; x2 = array[i+1];
      asm("popcnt %[x1], %[val] \n\t"
	  "popcnt %[x2], %%edi \n\t"
	  "add    %%edi, %[val] \n\t"
	  : [val]"=&r" (val)
	  :  [x1] "r"  (x1),
             [x2] "r"  (x2)
          : "edi"
      );
      result += val;
    }
return result;
}

void crono(int (*func)(), char* msg) {
    struct timeval tv1,tv2;	// gettimeofday() secs-usecs
    long           tv_usecs;	// y sus cuentas

    gettimeofday(&tv1,NULL);
    resultado = func(lista, SIZE);
    gettimeofday(&tv2,NULL);

    tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
             (tv2.tv_usec-tv1.tv_usec);

#if COPY_PASTE_CALC
    printf(    "%ld" "\n",      tv_usecs);
#else
    printf("resultado = %d\t", resultado);
    printf("%s:%9ld us\n", msg, tv_usecs);
#endif

}

int main() {
#if ! TEST
    int i;			// inicializar array
    for (i=0; i<SIZE; i++)	// se queda en cache
	 lista[i]=i;
#endif

    crono(popcount1, "popcount1 (en lenguaje C -      for)");
    crono(popcount2, "popcount2 (en lenguaje C -    while)");
    crono(popcount3, "popcount3 (leng.ASM  - cuerpo while)");
    crono(popcount4, "popcount4 (len.CS:APP 3.49-group 8b)");
    crono(popcount5, "popcount5 (asm SSE3  -  pshufb 128b)");
    crono(popcount6, "popcount6 (asm SSE4  - popcount 32b)");
    crono(popcount7, "popcount7 (asm SSE4  - popcnt 2x32b)");

#if ! COPY_PASTE_CALC
    printf("calculado = %d\n", RESULT);
#endif

    exit(0);
}

