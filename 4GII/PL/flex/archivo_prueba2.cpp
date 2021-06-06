//gencodigo1.c

    main
    {
        int n, curr ;
        print("introduce numero : ");
        scanf("%d");
        print(" %d == ",n);
        curr = 2 ;
        while( curr <= n )
        {
            int d = n/curr ;
            if ( d*curr == n ) /* curr divide a n */
            {
                print("* %d ",curr);
                n = n/curr ;
            }
            else
                curr = curr+1 ;
        }
        print("\n");
    }