import java.util.Objects;

/*
 * tipo Partida
 *  
 *  Atributos basicos
 *  
 *  	- jugadores: tipo Jugador[], consultable, modificable
 *  
 *  Atributos derivados
 *  
 *  	- ganador: tipo Jugador, consultable, no modificable.
 *  
 *  Atributos estaticos
 *  
 *  Funcionalidades
 *  
 *  	- ganadorPartida: 
 *  	- toString: Devuelve la informacion de todos los jugadores
 *  
 *  Interfaz
 *  
 *  	- public Jugador[] getJugadores()
 *  	- public Jugador getGanador()
 *  	- public void setJugadores(Jugador[] jugadores)
 *  	- public Jugador ganadorPartida()
 *  	- public String toString()
 *  	- public Partida clone()
 * 
 */

public class Partida {
	
	private static Validar validador = new Validar();
	private Jugador[] jugadores =  new Jugador[4]; //Inicializo el array aqui porque siempre va a ser de 4 jugadores
	private Jugador ganador; //Es el jugador con mayor puntuacion de la partida
	//Cada vez que se actualiza el atributo jugadores (a traves de un constructor o a traves de un setter)
	//se actualiza el atributo ganador a traves del metodo ganadorPartida.
	
	//Constructor sin parametros
	public Partida() {
		
		//Inicializo cada objeto del array jugadores
		for(int i = 0; i < 4; i++) {
			jugadores[i] = new Jugador(); 
		}
		
		
		
	}
	
	//Constructor con parametros
	
	public Partida(Jugador[] jugadores) {
		
		if(validador.validarLongitudJugadores(jugadores)){
			this.jugadores = jugadores;
			this.ganador = this.ganadorPartida();
		} else {
			
			this.jugadores = new Jugador[4]; 
			//Si el array pasado no tiene 4 casillas, se inicializa a un array con nulls
			
		}
	}

	
	//Constructor de copia
	
	public Partida(Partida p) {
		
		//Se instancia un array en el que se van a copiar las partidas de this.jugadores
		Jugador[] jugadoresCopia = new Jugador[4];
		
		for(int i = 0; i < this.jugadores.length; i++) {
			
			//Se añade cada jugador de this.jugadores copiado (a traves del constructor de copia)
			//al array jugadoresCopia
			jugadoresCopia[i] = new Jugador(this.jugadores[i]);
			
		}
		//Se crea una nueva Partida con el array de partidas copiadas
		new Partida(jugadoresCopia);
		
	}
	
	
	//Getters
	
	public Jugador[] getJugadores() {
		
		Jugador[] copiaJugadores = new Jugador[this.jugadores.length];
		
		System.arraycopy(this.jugadores, 0, copiaJugadores, 0, jugadores.length);
		
		return copiaJugadores;
		
	}
	
	public Jugador getGanador() {
		
		//Esta comprobacion se realiza para evitar excepciones NullPointerException 
		
		Jugador devolver;
		
		if(Objects.isNull(this.ganador)) {
			devolver = null;
		} else {
			devolver = this.ganador;
		}
		
		return devolver;
		
	}
	
	//Setters
	
	//Igual que en el constructor con parametros, cada vez que modifique el array de jugadores,
	//se vera modificado el ganador de la partida
	
	public void setJugadores(Jugador[] jugadores) {
		
		if(validador.validarLongitudJugadores(jugadores)) {
			
			this.jugadores = jugadores;
			this.ganador = this.ganadorPartida();
			
		}
		
	}
	
	
	/*
	 * INTERFAZ
	 * 
	 * Analisis: Este metodo devuelve el jugador cuya puntuacion sea mayor entre todos los de la partida
	 * 
	 * Interfaz: private Jugador ganadorPartida()
	 * 
	 * Variables de entrada: Ninguna
	 * 
	 * Variables de salida: El ganador (El jugador del array de jugadores con puntuacion mayor)
	 * 
	 * Precondiciones: Los jugadores del array que son legales (atributos validados)
	 * 
	 * Postcondiciones: ganador es el jugador de ese array con la mayor puntuacion entre todos
	 * 
	 */
	
	public Jugador ganadorPartida() {
		
		Jugador ganador = new Jugador();
		//Se crea una variable de tipo Jugador que  apunta a un jugador con puntuacion 0
		
		for(int i = 0; i < this.jugadores.length; i++) {
			if(ganador.compareTo(this.jugadores[i]) < 0) {
				ganador = this.jugadores[i];
				//La variable ganador apunta al objeto mas grande en cada comparacion
			}
		}
		
		return ganador;
		
	}
	
	
	
	@Override
	public String toString() {
		
		String info = "";
		
		info += "Ganador: "+this.ganador.getNombre()+"\n";
		
		for(Jugador jugador : jugadores) {
		
			info += jugador.toString()+"\n";
			
		}
		
		return info;
		
	}
	
	@Override
	public Partida clone() {
		
		Partida pt = null;
		
		try {
		
			pt = (Partida) super.clone();
			
		} catch (CloneNotSupportedException e) {
			System.out.print("No se puede clonar");	
		}
		return pt;
	}

}
