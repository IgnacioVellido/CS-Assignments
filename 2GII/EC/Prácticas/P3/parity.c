#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define TEST		0
#define COPY_PASTE_CALC	1

#if ! TEST
	#define NBITS 	20
	#define SIZE	(1<<NBITS)	// tamaño suficiente para tiempo apreciable
	unsigned lista[SIZE];
	#define RESULT	(1<<NBITS-1))
#else
/* ---------------------------------------------------------------------------- */
	#define SIZE 	4
	unsigned lista[SIZE]={ 0x80000000, 0x00100000, 0x00000800, 0x00000001};
	#define RESULT	4
/* ---------------------------------------------------------------------------- * /
	#define SIZE	8
	unsigned lista[SIZE]={ 0x7fffffff, 0xffefffff, 0xfffff7ff, 0xfffffffe, 
			       0x01000024, 0x00356700, 0x8900ac00, 0x00bd00ef};
	#define RESULT	8
/* ---------------------------------------------------------------------------- * /
	#define SIZE 	8
	unsigned lista[SIZE]={ 0x0	 , 0x10204080, 0x3590ac06, 0x70b0d0e0,
			       0xffffffff, 0x12345678, 0x9abcdef0, 0xcafebeef};
	#define RESULT	2
/* ---------------------------------------------------------------------------- */
#endif
	int resultado=0;

int parity1(unsigned* array, int len) {
    int  	   i,j;   
    unsigned	     x;		// No deber ser int para que no meta bits de signo
    int	 val, result=0;

    for (i=0; i<len; i++) {
	x = array[i];
        val = 0;	 
	for (j=0; j<8*sizeof(unsigned);j++) {	
	   val ^= x & 0x1;
	   x >>= 1;
	}
        result += val;
    }

    return result;
}

int parity2(unsigned* array, int len) {
    int  	     i;   
    unsigned	     x;		// No debe ser int para que no meta bits de signo
    int	 val, result=0;

    for (i=0; i<len; i++) {
	x = array[i];
        val = 0;	 
	do {
	   val ^= x & 0x1; 	// Acumular XOR lateralmente
	   x >>= 1;
	} while (x);
        result += val;
    }

    return result;
}

int parity3(unsigned* array, int len) {
    int  	     i;   
    unsigned	     x;		// No debe ser int para que no meta bits de signo
    int	 val, result=0;

    for (i=0; i<len; i++) {
	x = array[i];
        val = 0;	 
	while (x) {
	  val ^= x;
	  x >>= 1;
	}	
	val &= 0x1;
        result += val;
    }

    return result;
}

int parity4(unsigned* array, int len) {
    int  	     i;   
    unsigned	     x;		
    int	 val, result=0;

    for (i=0; i<len; i++) {
	x = array[i];	 
	val = 0;
        asm("\n"
	    "ini4:		\n\t"	// saltar aquí mientras que x!=0
	    "xor  %[x], %[v]	\n\t"   // val ^= x
	    "shr  %[x]		\n\t"
	    "jne ini4		\n\t"	// volver si x!=0
	    "and $0x1,  %[v]	\n\t"   // aplicando la máscara
	    : [v]"+r" (val)		// e/s: entrada 0, salida paridad elemento
	    : [x] "r" (x)		// entrada: valor elemento
	   );
	result += val;
    }

    return result;
}


int parity5(unsigned* array, int len) {
    int    val = 0,
	result = 0,
   	      i, j;
    unsigned     x;

    for (i = 0; i < len; i++) {
      val = 0;
      x = array[i];

      for (j = 16; j > 0; j>>=1) {
	   x ^= x >> j; 	
	   val ^= x & 0x1; 	
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

int parity6(unsigned* array, int len) {
    int    val = 0,
	result = 0,
   	      	 i;
    unsigned     x;

    for (i = 0; i < len; i++) {
      val = 0;
      x = array[i];

      asm("\n"
	"mov	 %[x],	%%edx	\n\t" // sacar copia para XOR. Controlar el registro... 
	"shr   	   $16,	%[x]	\n\t" 
	"xor     %[x], %%edx	\n\t"
	"xorb    %%dh, %%dl	\n\t" // xor de los 8 bits superiores de dx con los 8 inferiores
	"setnp   %%dl		\n\t" // Pone val a uno según la paridad de los últimos 8bits	
	"movzx	 %%dl,	 %[x]	\n\t" // devolver en 32bits
	: [x]   "+r" (x)	      // e/s: entrada valor elemento, salida paridad 
	:
	: "edx"			      // clobber
      );
  

      result += x;
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

    crono(parity1, "parity1 (en lenguaje C -        for)");
    crono(parity2, "parity2 (en lenguaje C -      while)");
    crono(parity3, "parity3 (len.CS:APP 3.22-mask final)");
    crono(parity4, "parity4 (leng.ASM   -  cuerpo while)");
    crono(parity5, "parity5 (len.CS:APP 3.49- 32b.16.1b)");
    crono(parity6, "parity6 (leng.ASM-cuerpo  for-setnp)");

#if ! COPY_PASTE_CALC
    printf("calculado = %d\n", RESULT);
#endif

    exit(0);
}
