/*
 * 
 * 
 * 
 * tipo Jugador
 *  
 *  Atributos basicos
 *  
 *  	- nombre: String, consultable, no modificable
 *  	- puntuacion: int, consultable, no modificable
 *  
 *  Atributos derivados
 *  
 *  Atributos estaticos
 *  
 *  Funcionalidades
 *  
 *  	- compareTo: Compara la puntuacion de dos jugadores (mayor, menor o igual) o bien para comparar sus nombres segun el orden lexicografico
 *  	- equals: Sirve para ver si dos jugadores han tenido la misma puntuacion 
 *  	AUNQUE EL compareTo YA ME DIGA SI ES IGUAL O NO, OVERRIDEA EL equals PARA DARLE CONSISTENCIA AL PROGRAMA
 *  	- toString: Devuelve toda la informacion del jugador 
 *  
 *  Interfaz
 *  
 *  	- public String getNombre()
 *  	- public int getPuntuacion()
 *  	- public int compareTo()
 *  	- public boolean equals()
 *  
 * 
 */

public class Jugador implements Comparable<Jugador>{
	
	private static Validar validador = new Validar();
	private String nombre;
	private int puntuacion;
	

	
	//Constructor sin parametros
	public Jugador() {
		
		this.nombre = null;
		this.puntuacion = 0;
		
	}
	
	
	//Constructor con parametros
	public Jugador(String nombre, int puntuacion) {
		
		if(validador.validarNombre(nombre) && validador.validarPuntuacion(puntuacion)) {
			
			this.nombre = nombre;
			this.puntuacion = puntuacion;
			
		} else {
			
			new Jugador();
			
		}
		
	}
	
	//Constructor de copia
	
	public Jugador(Jugador j) {
		
		this.nombre = j.nombre;
		this.puntuacion = j.puntuacion;
		
	}
	
	//Getters
	
	public String getNombre() {
	
		return this.nombre;
		
	}
	
	public int getPuntuacion() {
		
		return this.puntuacion;
		
	}
	
	@Override
	//Primer criterio de ordenacion: Ordenacion por puntuacion
	public int compareTo(Jugador a) {
	
		//Devolverá -1 si la puntuacion es menor que el jugador pasado por parametros,
		//0 si es igual y 1 si es mayor
		
		int comparacion = 0;
		
		if(this.puntuacion < a.puntuacion) {
			comparacion = -1;
		} else if(this.puntuacion > a.puntuacion){
			comparacion = 1;
		} else if (this.puntuacion == a.puntuacion) {
			comparacion = 0;
		}
		
		return comparacion;
	}
	
	/*Segundo criterio de ordenacion: Ordenacion alfabetica de los nombres
	public int compareTo(Jugador a){
		
		int comparacion = 0;
		
		//La clase String ya implementa la ordenacion alfabetica (lexicografica)
		comparacion = this.nombre.compareTo(a.nombre);
		
		return comparacion;
		
	}*/
	
	@Override
	public boolean equals(Object o){
		
		boolean juicio = false;
		
		if(o instanceof Jugador) { //Si o es un objeto null o no es un objeto de la clase jugador, la condicion es falsa
			
			final Jugador j = (Jugador) o; //Lo casteamos como objeto de tipo Jugador
			
			if(this.puntuacion == j.puntuacion ) {
				juicio = true;
			}
			
		}
		return juicio;
	}
	
	@Override
	public String toString() {
		
		String info = "Nombre: "+this.nombre+"\nPuntuacion: "+this.puntuacion+" puntos\n";
		
		return info;
	}
	
	@Override
	public Jugador clone() {
		
		Jugador juega = null;
		
		try {
			
			juega = (Jugador) super.clone();
			
		} catch(CloneNotSupportedException error){
			System.out.println("No se puede clonar");
		}
		
		return juega;
		
	}
	
	@Override
	public int hashCode() {
		
		return this.puntuacion * 512 + (this.puntuacion - 5) * 987;
				
	}
	
	

}
