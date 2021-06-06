/* 
  Ignacio Vellido Expósito - TSI
  Se define el agente
*/

package practica_busqueda;

// Métodos de Java
import java.util.*;

// Métodos para GVGA
import com.sun.deploy.util.ArrayUtil;
import core.game.StateObservation;
import core.player.Player;
import ontology.Types;
import tools.ElapsedCpuTimer;

import javax.swing.plaf.nimbus.State;

public class Agent extends BaseAgent {
  // Nodo para el algoritmo A*
  class Nodo {
      ArrayList<Observation>[][] mapa;
      Types.ACTIONS accion;
      PlayerObservation casilla;
      Integer g,
              h,
              f;

      public Nodo (ArrayList<Observation>[][] m, PlayerObservation c, int g, int h, Types.ACTIONS accion) {
        this.mapa = m;
        this.casilla = c;
        this.g = g;
        this.h = h;
        this.f = g + h;
        this.accion = accion;
      }

      @Override
      public boolean equals (Object n) {
        if (n instanceof  Nodo) {
          Nodo toCompare = (Nodo) n;

          // Un mapa es distinto de otro si alguna casilla difiere
          for (Integer i=0; i < mapa.length; i++) {
            for (Integer j = 0; j < mapa[0].length; j++) {
              if (mapa[i][j].get(0).getType() != toCompare.mapa[i][j].get(0).getType())
                return false;
            }
          }

          return this.casilla.collides(toCompare.casilla)
              && (this.casilla.getOrientation() == toCompare.casilla.getOrientation());
        }
        return false;
      }

      @Override
      public int hashCode() {
        return Objects.hash(casilla.getX(), casilla.getY(), casilla.getOrientation(), mapa);
      }
  }

  // -------------------------------------------------------------------------------------------------------------------

  // Variables auxiliares del agente
  private StateObservation estado_actual;
  private ArrayList<Observation>[][] el_mapa;

  private Integer numGemas = 0;
  private Integer old_numGemas = 0; // Para saber si hemos encontrado una
  private ArrayList<Observation> gemas_accesibles;
  private Observation gema_objetivo;

  private Observation exit; // Pues no varía en el nivel

  private Boolean rocaCayendo = false;
  private Integer path_continuado = 0;

  // Variables del path
  private LinkedList<Types.ACTIONS> path;
  private Boolean hay_solucion = false;
  private Boolean reiniciarPath = true;

  private PriorityQueue<Nodo> abiertos;
  private HashSet<Nodo> cerrados;

  private HashMap<Nodo, Nodo> mejorPadre;
  private HashMap<Nodo, Integer> valorG, valorF;

  private Nodo origen;

  // -------------------------------------------------------------------------------------------------------------------
  public Agent (StateObservation so, ElapsedCpuTimer elapsedTimer) {
    super(so, elapsedTimer);

    path = new LinkedList<>();

    // En un principio, creamos una lista indicando que todas las gemas son accesibles
    gemas_accesibles = getGemsList(so);

    exit = getExit(so);
  }

  // -------------------------------------------------------------------------------------------------------------------
  // -------------------------------------------------------------------------------------------------------------------

  // Una casilla es transitable si es GROUND, EMPTY o DANGER y no está bajo una roca
  private Boolean esTransitable (Observation casilla, ArrayList<Observation>[][] mapa) {
    Boolean transitable = true;
    Integer x = casilla.getX(),
            y = casilla.getY();

    ObservationType tipo = mapa[x][y].get(0).getType();

    if (tipo == ObservationType.BAT || tipo == ObservationType.SCORPION || tipo == ObservationType.BOULDER || tipo == ObservationType.WALL) {
      transitable = false;
    }
    else {
      if (bajoRoca(casilla, mapa))
        transitable = false;
    }

    return transitable;
  }

  // Si la casilla está debajo de una roca
  private Boolean bajoRoca(Observation casilla, ArrayList<Observation>[][] stateObs) {
    Boolean debajo = false;
    Integer x = casilla.getX(), y = casilla.getY();

    if (stateObs[x][y-1].get(0).getType() == ObservationType.BOULDER)
      debajo = true;

    return debajo;
  }

  // Mira si encima del agente hay una gema bajo una roca
  private Boolean gemaBajoRoca (PlayerObservation agente, ArrayList<Observation>[][] mapa) {
    if (bajoRoca(mapa[agente.getX()][agente.getY()-1].get(0), mapa))
      return true;

    return false;
  }

  // -------------------------------------------------------------------------------------------------------------------

  // Distancia Manhattan penalizada si hay peligro, puesto que entonces perderemos el path
  private int calculaH (Observation objetivo, Observation actual, ArrayList<Observation>[][] mapa) {
    if (enemigoCerca(actual, mapa, 2))
      return objetivo.getManhattanDistance(actual) + 100;
    else
      return objetivo.getManhattanDistance(actual);
  }

  // Penalizamos los movimientos a través de casillas marcadas como peligrosas
  private int calculaG (Observation casilla) {
    if (casilla.getType() == ObservationType.DANGER)
      return 10;
    else
      return 1;
  }

  // -------------------------------------------------------------------------------------------------------------------

  public static ArrayList<Observation>[][] cloneList(ArrayList<Observation>[][] list) {
    ArrayList<Observation>[][] clone = new ArrayList[list.length][list[0].length];

    for (Integer i=0; i < list.length; i++) {
      for (Integer j = 0; j < list[0].length; j++) {
        clone[i][j] = new ArrayList<>();
        clone[i][j].add(list[i][j].get(0).clone());
      }
    }

    return clone;
  }

  // -------------------------------------------------------------------------------------------------------------------

  private ArrayList<Observation>[][] actualizarTrasMOVE (ArrayList<Observation>[][] otrogrid, Observation agente) {
    return null;
  }


  // Actualiza el mapa tras hacer USE sobre la casilla
  private ArrayList<Observation>[][] actualizarTrasUSE (ArrayList<Observation>[][] otrogrid, Observation casilla) {
    Integer x = casilla.getX(),
            y = casilla.getY();

    ArrayList<Observation>[][] grid = cloneList(otrogrid);

    // Desde esa casilla hacia abajo mientras sea Empty, ahora suponemos que son muro
    Integer numero_empty = 0;

    // La primera es GROUND, por eso la excavamos
    Observation nueva = new Observation(x,y,ObservationType.DANGER);
    grid[x][y].remove(0);
    grid[x][y].add(nueva);

    y++;
    numero_empty++;

    while (grid[x][y].get(0).getType() == ObservationType.EMPTY) {
      nueva = new Observation(x,y,ObservationType.DANGER);
      grid[x][y].remove(0);
      grid[x][y].add(nueva);

      y++;
      numero_empty++;
    }

    // El nº de Empry encontradas por encima de la casilla (y mientras sea roca) ahora suponemos que son empty (aunque choque pasados los ticks podrá)
    x = casilla.getX();
    y = casilla.getY();

    // Empezamos mirando una por encima
    y--;
    numero_empty--;

    while (grid[x][y].get(0).getType() == ObservationType.BOULDER && numero_empty >= 0) {
      nueva = new Observation(x,y,ObservationType.EMPTY);
      grid[x][y].remove(0);
      grid[x][y].add(nueva);

      y--;
      numero_empty--;
    }

    return grid;
  }

  // -------------------------------------------------------------------------------------------------------------------

  private ArrayList<Nodo> generarSucesores (Nodo nodo, Observation objetivo) {
    ArrayList<Observation>[][] mapa_padre = nodo.mapa,
                               mapa_hijo;
    ArrayList<Nodo> sucesores = new ArrayList();

    PlayerObservation actual = nodo.casilla;
    PlayerObservation siguiente;
    Observation enfrente;

    Integer x = actual.getX(),
            y = actual.getY();

    switch (actual.getOrientation()) {
      case N:
        enfrente = mapa_padre[x][y - 1].get(0);
        break;
      case S:
        enfrente = mapa_padre[x][y + 1].get(0);
        break;
      case E:
        enfrente = mapa_padre[x + 1][y].get(0);
        break;
      default:  // West, no hay más opciones
        enfrente = mapa_padre[x - 1][y].get(0);
        break;
    }

    // ACTION_UP:
    if (actual.getOrientation() == Orientation.N) {
      siguiente = new PlayerObservation(x, y - 1, Orientation.N);

      if (esTransitable(siguiente, mapa_padre))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + calculaG(enfrente), calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_UP));
      else if (siguiente.collides(objetivo))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, 0, Types.ACTIONS.ACTION_UP));
    }
    else {
      siguiente = new PlayerObservation(x, y, Orientation.N);
      sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_UP));
    }


    // ACTION_DOWN:
    if (actual.getOrientation() == Orientation.S) {
      siguiente = new PlayerObservation(x, y + 1, Orientation.S);

      if (esTransitable(siguiente, mapa_padre))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + calculaG(enfrente), calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_DOWN));
      else if (siguiente.collides(objetivo))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, 0, Types.ACTIONS.ACTION_DOWN));
    }
    else {
      siguiente = new PlayerObservation(x, y, Orientation.S);
      sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_DOWN));
    }


    // ACTION_LEFT:
    if (actual.getOrientation() == Orientation.W) {
      siguiente = new PlayerObservation(x - 1, y, Orientation.W);

      if (esTransitable(siguiente, mapa_padre))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + calculaG(enfrente), calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_LEFT));
      else if (siguiente.collides(objetivo))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, 0, Types.ACTIONS.ACTION_LEFT));
    }
    else {
      siguiente = new PlayerObservation(x, y, Orientation.W);
      sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_LEFT));
    }


    // ACTION_RIGHT:
    if (actual.getOrientation() == Orientation.E) {
      siguiente = new PlayerObservation(x + 1, y, Orientation.E);

      if (esTransitable(siguiente, mapa_padre))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + calculaG(enfrente), calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_RIGHT));
      else if (siguiente.collides(objetivo))
        sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, 0, Types.ACTIONS.ACTION_RIGHT));
    }
    else {
      siguiente = new PlayerObservation(x, y, Orientation.E);
      sucesores.add(new Nodo(mapa_padre, siguiente,nodo.g + 1, calculaH(objetivo, siguiente, mapa_padre), Types.ACTIONS.ACTION_RIGHT));
    }


    // ACTION_USE
    // Si caerían rocas donde excavamos, añadimos el estado cavando
    if (enfrente.getType() == ObservationType.GROUND && bajoRoca(enfrente, mapa_padre)) {  // Debe haber una roca encima y que no esté excavada
      mapa_hijo = actualizarTrasUSE(mapa_padre, enfrente);

      siguiente = new PlayerObservation(x, y, actual.getOrientation());
      sucesores.add(new Nodo(mapa_hijo, siguiente, nodo.g + 1,  calculaH(objetivo, siguiente, mapa_hijo), Types.ACTIONS.ACTION_USE));
    }

    return sucesores;
  }

  // -------------------------------------------------------------------------------------------------------------------

  // Calculamos el path
  private void recuperarPath(HashMap<Nodo, Nodo> mejorPadre, Nodo fin) {
    Nodo actual = fin;
    path = new LinkedList<>();

    path.addFirst(actual.accion);

    while (mejorPadre.keySet().contains(actual)) {
      actual = mejorPadre.get(actual);
      path.addFirst(actual.accion);
    }

    // La primera, como es la del padre, es null y la quitamos
    path.poll();
  }

  // A*
  private Boolean pathFinding (Observation objetivo, PlayerObservation casilla_actual, ElapsedCpuTimer elapsedTimer) {
    // Para ordenar los nodos en abiertos
    Comparator<Nodo> nodoComparator = new Comparator<Nodo>() {
      @Override
      public int compare(Nodo n1, Nodo n2) {
        if (n1.f > n2.f)
          return 1;
        else if (n1.f < n2.f)
          return -1;
        else
          return 0;
      }
    };

    if (reiniciarPath) {
      abiertos = new PriorityQueue<>(nodoComparator);
      cerrados = new HashSet<>();

      mejorPadre = new HashMap<>();
      valorG = new HashMap<>();
      valorF = new HashMap<>();

      origen = new Nodo(el_mapa, casilla_actual,0, calculaH(objetivo, casilla_actual, el_mapa), null);

      abiertos.add(origen);
      valorG.put(origen, 0);
      valorF.put(origen, calculaH(objetivo, origen.casilla, el_mapa));
    }

    // Iterar por abiertos
    while(!abiertos.isEmpty() && elapsedTimer.remainingTimeMillis() > 10) {
      // Cogemos el de menor f
      Nodo actual = abiertos.poll();

      // Si se ha encontrado solución
      if (actual.casilla.collides(objetivo)) {
        reiniciarPath = true;
        recuperarPath(mejorPadre, actual);

        return true;
      }

      // Añadimos a cerrados
      cerrados.add(actual);

      // Recorremos los sucesores
      ArrayList<Nodo> hijos = generarSucesores(actual, objetivo);

      for (Nodo sucesor : hijos) {
        // Si el hijo no está en cerrados
        if (!cerrados.contains(sucesor)) {
          Integer posible_g = valorG.get(actual) + calculaG(sucesor.casilla);

          if (!abiertos.contains(sucesor)) {
            abiertos.add(sucesor);
          }
          else {
            if (valorG.get(sucesor) == null) {
              valorG.put(sucesor, Integer.MAX_VALUE);
            }

            if (posible_g >= valorG.get(sucesor)) {
              continue;
            }
          }

          // Guardamos los datos del nodo
          mejorPadre.put(sucesor, actual);
          valorG.put(sucesor, posible_g);
          valorF.put(sucesor, valorG.get(sucesor) + calculaH(objetivo, sucesor.casilla, sucesor.mapa));
        }
      }
    }

    // Si no hay solución, devolvemos path nulo para buscar otra gema
    if (abiertos.isEmpty()) {      
      reiniciarPath = true;
      return false;
    }

    // En otro caso seguimos en la siguiente iteración
    reiniciarPath = false;
    return false;
  }

  // -------------------------------------------------------------------------------------------------------------------

  // Dice si la casilla entre el enemigo y el agente es transitable (está a una distancia Manhattan de 2)
  private Boolean tierraCavadaEntre (Observation casilla1, Observation casilla2, ArrayList<Observation>[][] grid) {
    Boolean hayTierraCavada = false;
    Integer c1_x = casilla1.getX(),
        c1_y = casilla1.getY(),
        c2_x = casilla2.getX(),
        c2_y = casilla2.getY();

    // El enemigo no está en una diagonal
    if (c1_x == c2_x) {
      if (grid[c1_x][(c1_y + c2_y) / 2].get(0).getType() == ObservationType.EMPTY)
        hayTierraCavada = true;
    }
    else if (c1_y == c2_y) {
      if (grid[(c1_x + c2_x) / 2][c1_y].get(0).getType() == ObservationType.EMPTY)
        hayTierraCavada = true;
    }
    else { // Enemigo en la diagonal
      hayTierraCavada = true;
    }

    return hayTierraCavada;
  }

  private ArrayList<Observation> getEnemigos (ArrayList<Observation>[][] mapa) {
    ArrayList<Observation> enemigos = new ArrayList<>();

    for (Integer i=0; i < mapa.length; i++) {
      for (Integer j=0; j < mapa[0].length; j++) {
        Observation casilla = mapa[i][j].get(0);

        if (casilla.getType() == ObservationType.BAT || casilla.getType() == ObservationType.SCORPION) {
          enemigos.add(casilla);
        }
      }
    }

    return enemigos;
  }

  // Mira si hay enemigos a cierta distancia
  private Boolean enemigoCerca (Observation casilla_a_comprobar, ArrayList<Observation>[][] mapa, Integer distancia) {
    Boolean cerca = false;
    ArrayList<Observation> enemigos = getEnemigos(mapa);

    for (Integer i=0; i < enemigos.size() && !cerca; i++) {
      if (casilla_a_comprobar.getManhattanDistance(enemigos.get(i)) <= distancia)
        cerca = true;
    }

    return cerca;
  }

  // Sabemos que hay peligro, así que guardamos las acciones posibles si la casilla no tiene el enemigo
  private Types.ACTIONS evitarPeligro (PlayerObservation agente, ArrayList<Observation>[][] mapa) {
    ArrayList<Types.ACTIONS> acciones = new ArrayList<>();

    Orientation orientacion = agente.getOrientation();
    Integer x_old = agente.getX(),
            y_old = agente.getY();

    Observation casilla_a_comprobar;

    // Si nos acercamos del enemigo no añadimos la acción
    casilla_a_comprobar = mapa[x_old][y_old-1].get(0);
    if (!enemigoCerca(casilla_a_comprobar, mapa, 1) && esTransitable(casilla_a_comprobar, mapa))
      acciones.add(Types.ACTIONS.ACTION_UP);

    // Sur
    casilla_a_comprobar = mapa[x_old][y_old+1].get(0);
    if (!enemigoCerca(casilla_a_comprobar, mapa, 1) && esTransitable(casilla_a_comprobar, mapa))
      acciones.add(Types.ACTIONS.ACTION_DOWN);

    // Este
    casilla_a_comprobar = mapa[x_old+1][y_old].get(0);
    if (!enemigoCerca(casilla_a_comprobar, mapa, 1) && esTransitable(casilla_a_comprobar, mapa))
      acciones.add(Types.ACTIONS.ACTION_RIGHT);

    // Oeste
    casilla_a_comprobar = mapa[x_old-1][y_old].get(0);
    if (!enemigoCerca(casilla_a_comprobar, mapa, 1) && esTransitable(casilla_a_comprobar, mapa))
      acciones.add(Types.ACTIONS.ACTION_LEFT);


    if (acciones.isEmpty())
      return Types.ACTIONS.ACTION_NIL;  // O ACTION_USE
    else {
      // Si estamos orientados en la misma posición que una de las acciones posibles nos movemos (así no perdemos un movimiento orientándonos)
      if (acciones.contains(Types.ACTIONS.ACTION_UP) && orientacion == Orientation.N)
        return Types.ACTIONS.ACTION_UP;

      if (acciones.contains(Types.ACTIONS.ACTION_DOWN) && orientacion == Orientation.S)
        return Types.ACTIONS.ACTION_DOWN;

      if (acciones.contains(Types.ACTIONS.ACTION_LEFT) && orientacion == Orientation.W)
        return Types.ACTIONS.ACTION_LEFT;

      if (acciones.contains(Types.ACTIONS.ACTION_RIGHT) && orientacion == Orientation.E)
        return Types.ACTIONS.ACTION_RIGHT;

      // En otro caso cogemos una al azar para no ciclar indefinidamente
      Collections.shuffle(acciones);
      return acciones.get(0);
    }
  }


  // Que haya al menos un enemigo a distancia de dos, se cogerá una que aumente la distancia con todos los enemigos
  private Boolean comprobarPeligro (Observation agente, ArrayList<Observation>[][] mapa) {
    Boolean peligro;

    peligro = comprobarEnemigo(agente, mapa, getEnemigos(mapa));

    if(!peligro && bajoRoca(agente, mapa))
      peligro = true;

    return peligro;
  }


  private Boolean comprobarEnemigo(Observation agente, ArrayList<Observation>[][] mapa, ArrayList<Observation> enemigos) {
    Boolean peligro = false;
    Integer distancia;

    for (Integer i = 0; i < enemigos.size() && !peligro; i++) {
      distancia = agente.getManhattanDistance(enemigos.get(i));

      if (distancia == 1)
        peligro = true;
      else if (distancia == 2 && tierraCavadaEntre(enemigos.get(i), agente, mapa))
        peligro = true;
    }

    return peligro;
  }

  // -------------------------------------------------------------------------------------------------------------------

  @Override
  public Types.ACTIONS act (StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
    Types.ACTIONS action;
    PlayerObservation jugador_actual = getPlayer(stateObs);

    // Variables del agente
    this.estado_actual = stateObs.copy();
    el_mapa = getObservationGrid(estado_actual);

    // Miramos el nº de gemas que llevamos
    numGemas = stateObs.getAvatarResources().get(6);
    if (numGemas == null)
      numGemas = 0;


    // Componente reactiva
    Boolean peligro = comprobarPeligro(jugador_actual, el_mapa);
    if (peligro || rocaCayendo) {
      action = evitarPeligro(jugador_actual, el_mapa);

      hay_solucion = false;  // El peligro nos descoloca del plan, recalculamos en la siguiente
    }
    else { // Componente deliverativa
      if (!hay_solucion || path.isEmpty()) {

        if (path_continuado > 10) { // Mirar que haya más de una accesible, sino no encuentra nunca
          gemas_accesibles.remove(gema_objetivo);
          reiniciarPath = true;
        }

        if (reiniciarPath) {
          path_continuado = 0;

          if (numGemas >= 9) { // Ir a la salida
            hay_solucion = pathFinding(exit, jugador_actual, elapsedTimer); // Es probable que devuelva el nodo actual

          } else {
            // Si nos hemos quedados sin gemas volvemos a dar por hecho que todas son accesibles
            if (gemas_accesibles.isEmpty() || numGemas > old_numGemas) {
              old_numGemas = numGemas;
              gemas_accesibles = getGemsList(stateObs);
            }

            // Elegimos gema
            Integer mejor_distancia = Integer.MAX_VALUE;

            for (Integer i = 0; i < gemas_accesibles.size(); i++) {
              Observation g = gemas_accesibles.get(i);
              Integer distancia = jugador_actual.getManhattanDistance(g);

              // Penalizamos las que estén cerca de un enemigo
              if (bajoRoca(g, el_mapa))
                distancia += 5;
              if (enemigoCerca(g, el_mapa, 3))
                distancia += 300;

              // Cogemos la más cercana (no se comprueba si es accesible, si no lo es no encontraremos path)
              if (distancia < mejor_distancia) {
                mejor_distancia = distancia;
                gema_objetivo = g;
              }
            }

            hay_solucion = pathFinding(gema_objetivo, jugador_actual, elapsedTimer);
          }
        }
        else { // Si no hay que reiniciar, continuamos con la búsqueda
          if (numGemas >= 9) {
            hay_solucion = pathFinding(exit, jugador_actual, elapsedTimer); // Es probable que devuelva el nodo actual
          }
          else {
            path_continuado++; // Para que no se atasque en una misma gema
            hay_solucion = pathFinding(gema_objetivo, jugador_actual, elapsedTimer); // Es probable que devuelva el nodo actual
          }
        }

        if (!hay_solucion) {
          action = Types.ACTIONS.ACTION_NIL;

          if (reiniciarPath) {
            gemas_accesibles.remove(gema_objetivo);
          }
        }
        else {
          action = path.poll();
        }
      }
      else // Sacamos la siguiente acción
        action = path.poll();
    }

    // Si cava hacia arriba, se orienta hacia un lateral para poder movernos y que no nos caiga encima la roca
    if (action == Types.ACTIONS.ACTION_USE && jugador_actual.getOrientation() == Orientation.N)
      rocaCayendo = true;
    else if (action == Types.ACTIONS.ACTION_UP && jugador_actual.getOrientation() == Orientation.N
                        && gemaBajoRoca(jugador_actual, el_mapa))    // O nos movemos a una gema que está bajo una roca
      rocaCayendo = true;
    else
      rocaCayendo = false;

    return action;
  }
}
