package modeloqytetet;

import java.util.concurrent.ThreadLocalRandom;

public class Dado {
    // ----------------------- Constructor -------------------------------------   
    private Dado() { }
    
    // ----------------------- Métodos singleton -------------------------------   
    public static Dado getInstance() {
        return DadoHolder.INSTANCE;
    }
    
    private static class DadoHolder {
        private static final Dado INSTANCE = new Dado();
    }
        
    // ----------------------- Métodos ----------------------------------------   
    // El máximo no es inclusivo, hay que sumarle 1
    int tirar() {                        
        return ThreadLocalRandom.current().nextInt(1,6+1);
    }
    
}
