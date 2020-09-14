import java.util.ArrayList;
import java.util.Objects;

/*
 * tipo Pista
 *  
 *  Atributos basicos
 *  
 *  	- partidasJugadas: Tipo ArrayList<Partida>, consultable, no modificable
 *  
 *  Atributos derivados
 *  
 *  	- mejorJugador: Tipo Jugador, consultable, no modificable 
 *  
 *  Atributos estaticos
 *  
 *  Funcionalidades
 *  
 *  	- toString: Devuelve la informacion de todas las partidas jugadas en una pista, ademas de la puntuacion maxima
 *  	- ganadorPista: Determina el jugador con mayor puntuacion de todas las prtidas que se han jugado en todas las pistas
 *  
 *  Interfaz
 *  
 *  	- public Partida[] getPartidasJugadas()
 *  	- public Jugador getMejorJugador()
 *  	- public void setPartidasJugadas(ArrayList<Partida> partidasJugadas)
 *  	- public void setPartidasJugadas(Partida p)
 *  	- public Jugador ganadorPista()
 *  	- public String toString()
 *  	- public Partida clone()
 *  
 *  Restricciones: maximaPuntuacion siempre se corresponderá con la puntuacion de alguno de los jugadores de alguna de las partidas
 * 
 */

public class Pista {

	private ArrayList<Partida> partidasJugadas;
	private Jugador mejorJugador; 
	//El mejor jugador no es mas que el jugador que haya conseguido la mayor
	//puntuacion de todas las partidas jugadas en esa pista
	
	//Cada vez que el array de partidasJugadas se actualiza (a traves de un constructor o de su setter),
	//el atributo mejorJugador se actualiza a traves del metodo ganadorPista
	
	
	//Constructor sin parametros
	
	public Pista() {
		
		//Se instancia el ArrayList de partidas
		
		this.partidasJugadas = new ArrayList<Partida>();
		
		
	}
	
	
	//Constructor con parametros
	
	//Cada vez que se editan las partidas jugadas, se hace la comprobacion del ganador.
	//Si se ha pasado por parametros un arrayList vacio,
	//no se hace esa comprobacion porque me tiraria una excepcion (si no hay partidas, no hay jugadores
	//y por lo tanto, no hay ganadores)
	
	public Pista(ArrayList<Partida> partidasJugadas) {
		
		this.partidasJugadas = partidasJugadas;
		
		
		if(!this.partidasJugadas.isEmpty()) {
			this.mejorJugador = this.ganadorPista();
		}
	}
	
	
	//Constructor de copia
	
	public Pista(Pista p) {
		
		//Se instancia un arrayList en el que se van a copiar las partidas de this.partidasJugadas
		ArrayList<Partida> partidasCopia = new ArrayList<Partida>();
		
		for(int i = 0; i < this.partidasJugadas.size(); i++) {
			
			//Se añade cada partida de this.partidasJugadas copiada (a traves del constructor de copia)
			//al arrayList partidasCopia
			partidasCopia.add(new Partida(this.partidasJugadas.get(i)));
			
		}
		//Se crea una nueva Pista con el arrayList de partidas copiadas
		new Pista(partidasCopia);
		
	}
	
	//Getters
	
	public ArrayList<Partida> getPartidasJugadas() {
		
		ArrayList<Partida> copia = new ArrayList<Partida>(this.partidasJugadas);
		
		return copia;
		
	}
	
	public Jugador getMejorJugador() {
		
		//Esta comprobacion se realiza para evitar excepciones NullPointerException 
		
		Jugador devolver;
		
		if(Objects.isNull(this.mejorJugador)) {
			devolver = null;
		} else {
			devolver = this.mejorJugador;
		}
		
		return devolver;
		
	}
	
	//Setters
	
	//EL SETTER ESTA SOBRECARGADO. Si le pasas una partida, te la va a añadir, si le pasas un arrayList,
	//sustituye el arrayList de partidas pasado por parametros por el suyo propio 
	
	public void setPartidasJugadas(ArrayList<Partida> partidasJugadas) {
		
		this.partidasJugadas = partidasJugadas;
		this.mejorJugador = this.ganadorPista();
		
	}
	
	public void setPartidasJugadas(Partida p) {
		
		this.partidasJugadas.add(p);
		this.mejorJugador = this.ganadorPista();
		
	}
	
	/*
	 * INTERFAZ
	 * 
	 * Analisis: Este metodo devuelve el jugador (de un array de jugadores) cuya puntuacion sea mayor entre todos los jugadores que han jugado a alguna partida
	 * 
	 * Interfaz: private Jugador ganador(Jugador[] jugadores)
	 * 
	 * Variables de entrada: Jugador[] jugadores (Array con los jugadores de una pista)
	 * 
	 * Variables de salida: ganador (El jugador del array con puntuacion mayor)
	 * 
	 * Precondiciones: jugadores es un array de jugadores legales
	 * 
	 * Postcondiciones: ganador es el jugador de ese array con la mayor puntuacion entre todos
	 * 
	 */
	
	private Jugador ganadorPista() {
		
		Jugador maximaPuntuacion = new Jugador();
		
		for(int i = 0; i < this.partidasJugadas.size(); i++) {
			
			
			//Aqui se comparan los ganadores de todas las partidas jugadas.
			//Compara la puntuacion del jugador que ha tenido mas puntos entre los i primeros jugadores
			// con el siguiente jugador
			if(maximaPuntuacion.compareTo(this.partidasJugadas.get(i).getGanador()) < 0) {
				maximaPuntuacion = this.partidasJugadas.get(i).getGanador();
			}
		}
		
		return maximaPuntuacion;
		
	}
	
	@Override
	public String toString() {
		
		String info = "";
		
		info += "Maxima puntuacion de la pista: "+this.mejorJugador.getPuntuacion()+"\nPor: "+this.mejorJugador.getNombre()+"\n\n";
		
		for(int i = 0; i < partidasJugadas.size(); i++) {
			
			info += "PARTIDA "+(i+1)+"\n"+partidasJugadas.get(i).toString();
			
		}
		
		return info;
		
	}
	
	@Override
	public Partida clone() {
		
		Partida p = null;
		
		try {
			
			p = (Partida) super.clone();
			
		} catch(CloneNotSupportedException error) {
			
			System.out.println("No se puede clonar");
			
		}
		
		return p;
		
	}
	
}
