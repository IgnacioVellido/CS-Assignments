class Utilidades {
    /**    
     * @param x Ciudad 1
     * @param y Ciudad 2
     * @return  Distancia Euclídea entre las dos ciudades
     */
    public static double distanciaEuclidea(Ciudad x, Ciudad y) {
        double distanciaX, distanciaY;

        distanciaX = Math.abs (x.getX() - y.getX());    
        distanciaY = Math.abs (x.getY() - y.getY());

        return Math.sqrt((distanciaY)*(distanciaY) + 
                         (distanciaX)*(distanciaX));
    }
}