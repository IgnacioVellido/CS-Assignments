    //gencodigo2.c

    //    #include <stdio.h>

    main
    {
        int n, curr = 2, ultim = 0, cuenta = 0, primero = 1 ;
        print("introduce numero : ");
        scanf("%d");
        print("%d == ",n);
        curr = 2 ;
        while( curr <= n )
        {
            int d = n/curr ;
            if ( d*curr == n ) /* curr divide a n */
            {
                if ( curr != ultim )
                {
                    ultim = curr ;
                    cuenta = 1 ;
                }
                else
                    cuenta = cuenta + 1 ;
                n = n/curr ;
            }
            else /* curr no divide a ’n’ */
            {
                if ( cuenta > 0 )
                {
                    if ( primero == 0 ) print(" *");
                        primero = 0 ;
                        print(" %d",curr) ;
                    if ( cuenta > 1 ) print("^%d",cuenta) ;
                }
                curr = curr+1 ;
                cuenta = 0 ;
            }
        }
        if ( cuenta > 0 )
        {
            if ( primero == 0 ) print(" *");
            primero = 0 ;
            print(" %d",curr) ;
            if ( cuenta > 1 ) print("^%d",cuenta) ;
        }
        print("\n");

        subprog(int uno, uint dos) {
            char hola;
            return adios;
        }
    }