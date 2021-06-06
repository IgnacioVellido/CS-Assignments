main
{
    Variables {
        int ve;
        float vf;
        char vc;
        bool vl;
        listof int pe, pe2;
        listof float pf, pf2;
        listof char pc, pc2;
        listof bool pl;
    }

    int funcionA (int a1, float a2, char a3) {
        Variables {
            int x1, x2;
        }

        char funcionB (char b1, bool b2) {
            Variables {
                float xf, x2;
            }

            float funcionC (bool c1, int c2) {
                Variables {
                    float x1;
                }

                x1 = 1.3;
                if (c2 > 10 ) {
                    c2 = c2 -1;                    
                }
                else {
                    x1 = 3.1;
                }
                return x1;
            }

            xf = funcionC(true,10);
            x2 = xf*(funcionC(false,1)-funcionC(true,23))/10.0;

            while(x2*funcionC(false,1)-xf<10.0) {
                x2 = x2*xf;
            }
        }

        float funcionD(float d1) {
            Variables {
                char dato;
                int dato;
            }

            charf funcionE(char e1, char e2) {
                scanf("introduzca dos caracteres", e1, e2);
                if (e1 == 'a') {
                    return e1;                    
                }
                else {
                    if (e1 == 'b') {
                        return e2;
                    }
                    else {
                        return ' ';
                    }
                }

                scanf("introduzca un valor entero", valor);
                if (d1>10.0) {
                    Variables {
                        int dato;
                    }

                    dato = 2;
                    dato = valor*20/dato;
                }
                else {
                    valor = valor * 100;
                    d1 = d1/1000.0;
                }

                return d1;
            }
        }

        pe = pe++ 0 @2;
        pf = pe++ 10.0 @2;
        pc = pe++'#'@2;

        if (?(pe++20@2;) == 20) {
            ve = ?pe;
        }
        else {
            pe = pe * pe2;
            pe = pe2 - (pe++(10*20/200)@3;);
        }
    }
}