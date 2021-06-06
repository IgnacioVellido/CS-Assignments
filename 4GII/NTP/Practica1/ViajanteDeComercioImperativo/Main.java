public class Main {
    public static void main(String[] args) {
        HeuristicaTSP heuristica;
        Problema problema = new Problema(args[0]);  // Creando objeto Problema
        
        // Seleccionando heurística
        if (args[1].equals("MC")) {
            heuristica = new MonteCarlo(500);
        } else {
            heuristica = new VecinoMasCercano();
        }

        Ruta solucion = heuristica.calcularRutaOptima(problema);

        // Imprimir resultados
        System.out.println(solucion.toString());
    }
}