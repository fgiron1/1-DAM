/*
 * POSIBLES MEJORAS:
 * 
 * - Si el criterio de comparacion es por orden alfabetico en el metodo compareTo de la clase Jugadores,
 *   en realidad solamente compara la primera letra (Solo compruebo si el valor que me devuelve el metodo
 *   es mayor o menor que 0)
 *   
 * - Al mostrar la informacion de los jugadores de una partida, en lugar de explicitamente decir cual es el ganador,
 *   que se muestren ordenados por la puntuacion de manera descendiente, de tal forma que el ganador sea
 *   el primer jugador que se muestra, mucho mas intuitivo asi.
 *   
 * - Si almacenara los jugadores de manera ordenada atendiendo a su nombre, podria hacer la busqueda de jugadores
 *   por su nombre de manera mas eficiente aplicando la busqueda binaria
 *   
 * - Si hay varios jugadores que tienen la maxima puntuacion, solo uno de ellos se va a mostrar, cuando deberian
 *   mostrarse todos, en realidad.
 * 
 * - Implementar los conductores de cada clase
 * 
 * 
 * 
 * PREGUNTAS: 
 * 
 * 1.- Las precondiciones y postcondiciones de los métodos están bien?
 * 
 * 2.- En lugar de crear un array de Pistas en el main, seria mas adecuado y fiel a la
 * orientacion a objetos crear una clase competicion con un unico atributo que fuera un array
 * de 12 pistas? No lo he hecho porque al no tener ninguna funcionalidad, he pensado que seria innecesaria
 * 
 * 3.- Esta bien la estructuracion de clases que he hecho? Hay gente que incluye una clase gestora o
 * mete las cosas en varios paquetes, no se si asi seria mejor
 * 
 * 4.- En la clase del main declaro todas las variables de clase como static para poderlas usar tanto en los
 *  metodos que he definido, como en el propio main. No se si es buena practica
 * 
 * Variables de entrada: opcion del menu, opcion del submenu, numero de la pista, nombre del jugador para el registro, puntuacion de cada jugador para el registro, nombre del jugador para buscar, 
 * 
 * Variables de salida: 
 * 
 * PSEUDOCODIGO GENERALIZADO
 * 
 * 	INICIO
 * 		Dar bienvenida
 * 		Mostrar lista de pistas disponibles
 * 		Solicitar y validar eleccion de pista
 * 		FOR(hasta 4)
 * 			Solicitar datos de usuario y puntuacion
 * 			Validar datos de usuario y puntuacion
 * 		FIN_FOR
 * 
 * 		DO
 * 			Mostrar menu
 * 			Solicitar eleccion de menu
 * 			SWITCH
 *
 * 				CASE 1: Solicitar nombre de jugador a buscar
 * 						Validar existencia nombre
 * 						Mostrar informacion asociada al nombre
 * 				CASE 2: Mostrar menu con todas las pistas
 * 						Solicitar y validar eleccion de pista
 * 						SWITCH(eleccion de pista)
 * 							CASE 1: Mostrar partidas jugadas en pista 1 con todos los datos de los jugadores
 * 									Mostrar maxima puntuacion de la pista 1
 * 									
 * 							...
 * 							CASE 12: Mostrar partidas jugadas en pista 12 con todos los datos de los jugadores
 * 									 Mostrar maxima puntuacion de la pista 12
 * 									
 * 				CASE 3: Aniadir nueva partida
 * 				CASE 4: Mostrar maxima puntuacion de la competicion
 * 				CASE 5: Salir
 * 		WHILE(no quiera salir)
 * 	FIN
 * 
 * 
 * 
 * 
 */
import java.util.ArrayList;
import java.util.Objects;
import java.util.Scanner;
public class CompeticionBolos {
	
	private static Validar validador = new Validar();
	private static Scanner input = new Scanner(System.in);
	private static Pista[] pistas = new Pista[12]; //Habra 12 pistas

	public static void main(String[] args) {
		
		int pista;
		boolean salir = false;
		
		//Instanciamos por defecto los objetos del array pistas
		for(int i = 0; i < pistas.length; i++) {	
			pistas[i] = new Pista();
		}

		System.out.println("Bienvenido a nuestra bolera!\n ");
		System.out.print("Introduzca la pista en la que habeis jugado (1-12): ");
		
		do {
			pista = input.nextInt();
			
			if(!validador.validarNumeroPista(pista)) {
				System.out.println("Pista invalida. Introduzca una pista valida: ");
			}
			
		}while(!validador.validarNumeroPista(pista));
		
		crearPartida(pista);
		
		do {
		
		System.out.println("\nInformacion sobre...");
		System.out.println("\n1. Jugadores");
		System.out.println("2. Partidas");
		System.out.println("3. Aniadir nueva partida");
		System.out.println("4. Maxima puntuacion");
		System.out.println("5. Salir");
		
		salir = opcionesMenu();
		
		}while(!salir);
		
		input.close();
		
	}
	
	
	/*
	 * Analisis: Este metodo presentara al usuario con el menu principal y pedira y validara su eleccion
	 * 
	 * Interfaz: public static boolean opcionesMenu()
	 * 
	 * Entradas: Ninguna 
	 * 
	 * Salidas: Un booleano que expresa si se quiere salir o no del programa
	 * 
	 * Precondiciones: Ninguna
	 * 
	 * Postcondiciones: Ninguna 
	 * 
	 */
	
	public static boolean opcionesMenu() {
		
		int pista, opcionMenu;
		String nombreBuscar;
		boolean salir = false;
		ArrayList<Jugador> coincidenciasNombres;
		Jugador maximo = new Jugador();
		
		Scanner input = new Scanner(System.in);
		
		System.out.print("\nIntroduzca su eleccion: ");
		
		//Validacion de la eleccion en el menu
		do {
			opcionMenu = input.nextInt();
			if(opcionMenu < 1 || opcionMenu > 5) {
				System.out.print("Opcion incorrecta. Introduzca un numero del 1 al 4: ");
			}
		}while(opcionMenu < 1 || opcionMenu > 5);
		
		switch(opcionMenu) {
		
		case 1:
			
			System.out.println("\nBusqueda de jugadores");
			
			System.out.print("\nIntroduzca el nombre a buscar: ");
			nombreBuscar = input.next();
			
			coincidenciasNombres = buscarNombre(nombreBuscar);
			
			if(coincidenciasNombres.size() == 0) {
				
				System.out.print("\nNo hay ninguna coincidencia\n");
				
			} else {
				
				for(int i = 0; i < coincidenciasNombres.size(); i++) {
					System.out.print(coincidenciasNombres.get(i).toString()+"\n");
				}
			}
			
			
			break;
			
		case 2:
			
			System.out.print("\nMenu de pistas\n");
			
			for(int i = 0; i < pistas.length; i++) {
				System.out.print("Pista "+(i+1)+"\n");
			}
			
			System.out.print("Escoja una pista: ");
			
			do {
				
				pista = input.nextInt();
				
				//Si la pista es un numero entre el 1 y el 12, comprueba que se haya jugado alguna partida
				//Si no se ha jugado ninguna, lo indica y vuelve a pedir otra pista.
				//En el caso en que se haya introducido una pista que no sea entre 1 y 12,
				//se comunica el error y se vuelve a pedir, sin comprobar que haya o no partidas en ella,
				//evitando asi una excepcion
				
				if(validador.validarNumeroPista(pista)) {
					if(pistas[pista-1].getPartidasJugadas().size() == 0) {
						System.out.print("Nadie ha jugado aun en esa pista. Introduzca otra pista: ");
					}
				} else {
					
					System.out.print("Pista invalida. Introduzca una pista valida: ");
				}
				
				
				
			}while(!validador.validarNumeroPista(pista) || pistas[pista-1].getPartidasJugadas().size() == 0);
				
				opcionesMenu(2, pista-1); //Me muestra la pista numero pista
				
				
				break;
				
		case 3:
			
			System.out.print("Introduzca la pista en la que habeis jugado (1-12): ");
			
			do {
				pista = input.nextInt();
				
				if(!validador.validarNumeroPista(pista)) {
					System.out.println("Pista invalida. Introduzca una pista valida: ");
				}
				
			}while(!validador.validarNumeroPista(pista));
			
			crearPartida(pista);
			
			break;
			
			
		case 4:
			
			//Si no se ha jugado ninguna partida en alguna pista, el objeto mejorJugador no se habria instanciado
			//por lo que comprobamos si es null o no antes de usarlo en el compareTo y asi evitamos una excepcion
			
			for(int i = 0; i < pistas.length; i++) {
				if(!Objects.isNull(pistas[i].getMejorJugador()) && maximo.compareTo(pistas[i].getMejorJugador()) < 0) {
					maximo = pistas[i].getMejorJugador();
				}
			}
			
			System.out.print("\nLa maxima puntuacion de la competicion ha sido...\n\n");
			System.out.println(maximo.toString());
			
			
		case 5:
			
			salir = true;
			
			break;
		}
		
		return salir;
		
	}
	/*
	 * Analisis: Este metodo se empleara para elegir opciones en los submenus dentro del menu principal
	 * 
	 * Interfaz: public static void opcionesMenu(int a, int b)
	 * 
	 * Entradas: La opcion del menu principal a la que se refiere (a), y dentro de la opcion a, en el submenu, se escoge la opcion b
	 * 
	 * Salidas: Ninguna
	 * 
	 * Precondiciones: Las opciones estaran ya validadas
	 * 
	 * Postcondiciones: Ninguna
	 * 
	 */
	public static void opcionesMenu(int a, int b) {
		
		if(a == 2) { //Si se escoje la opcion 2 en el menu principal,
					//la variable b expresa el numero de pista
			
			int cantidadPartidas = pistas[b].getPartidasJugadas().size();
			
			for(int i = 0; i < cantidadPartidas; i++) {
				System.out.println(pistas[b].getPartidasJugadas().get(i).toString());
			}
		}
		
	}
	

	/*
	 * Analisis: Este metodo es empleado para que se introduzcan por teclado el nombre y puntuacion de cada
	 * 			 jugador que ha jugado una partida en una pista determinada. Es decir, se crea una partida
	 * 			 que se ha jugado en la pista pasada por parametros 
	 * 
	 * Interfaz: public static Jugador[] crearPartida(int pista)
	 * 
	 * Variables de entrada: La pista en la que se jugara la partida
	 * 
	 * Variables de salida: Ninguna
	 * 
	 * Precondiciones: El numero de pista es valido
	 * 
	 * Postcondiciones: En la pista especificada, se habra creado una nueva partida cuyos datos de los jugadores son validos
	 * 
	 */
	
	public static void crearPartida(int pista) {
		
		Jugador[] jugadores = new Jugador[4];
		
		for(int i = 0; i < 4; i++) {
			System.out.println("\nIntroduzca los datos del jugador "+(i+1));
			jugadores[i] = crearUsuario();
		}
		
		pistas[pista-1].setPartidasJugadas(new Partida(jugadores));
		//De todas las pistas, cojo la pista de indice pista, y a su atributo partidasJugadas, que es un ArrayList
		//(y representa las partidas que se han jugado en esa pista) le añado un NUEVO objeto partida construido
		//con el array de jugadores que acabo de llenar de objetos Jugador
		
	}
	
	/*
	 * Analisis: Este metodo pide y valida al usuario los datos de un jugador y despues, lo crea
	 * 
	 * Interfaz: public static Jugador crearUsuario()
	 * 
	 * Entradas: Ninguna
	 * 
	 * Salidas: El objeto Jugador creado con los datos especificados
	 * 
	 * Precondiciones: Ninguna
	 * 
	 * Postcondiciones: Los atributos del objeto Jugador devuelto estan validados
	 * 
	 */
	
	public static Jugador crearUsuario() {
		
		Jugador jugador;
		String nombre;
		int puntuacion;
		

			System.out.print("Nombre: ");
			
			//Validacion nombre
			do {
				nombre = input.next();
				if(!validador.validarNombre(nombre)) {
					
					System.out.print("Nombre invalido. Introduzca otro nombre: ");
					
				}
				
			}while(!validador.validarNombre(nombre));
			
			System.out.print("Introduzca la puntuacion: ");
			
			//Validacion puntuacion
			do {
				puntuacion = input.nextInt();
				if(!validador.validarPuntuacion(puntuacion)) {
					
					System.out.print("Puntuacion invalida. Introduzca otra puntuacion: ");
					
				}
				
			}while(!validador.validarPuntuacion(puntuacion));
			
			jugador = new Jugador(nombre, puntuacion);
			
		
		return jugador;
		
	}
	
	/*
	 * Analisis: Este metodo busca un nombre entre todos los nombres de los jugadores
	 * 
	 * Entradas: El nombre a buscar
	 * 
	 * Interfaz: public static ArrayList<Jugador> buscarNombre(String nombreBuscar)
	 * 
	 * Salida: Un arraylist que contiene los objetos jugadores que tengan por nombre el nombre introducido
	 * 
	 * Precondiciones: El nombre es validado con anterioridad
	 * 
	 * Postcondiciones: -
	 * 
	 * Que no haya coincidencias es exactamente la misma condicion que el tamanio del arrayList sea 0
	 * 
	 */
	
	public static ArrayList<Jugador> buscarNombre(String nombreBuscar) {
		
		String nombreActual;
		ArrayList<Jugador> coincidencias = new ArrayList<Jugador>();
		
		//Para las 12 pistas
		for(int i = 0; i < 12; i++) {
			//Para cada partida jugada en cada pista
			for(int j = 0; j < pistas[i].getPartidasJugadas().size(); j++) {
				//Para los jugadores de cada partida jugada en cada pista
				for(int k = 0; k < 4; k++) {
					
					//Comprobamos  si el nombre introducido coincide con alguno
					nombreActual = pistas[i].getPartidasJugadas().get(j).getJugadores()[k].getNombre();
					if(nombreActual.equals(nombreBuscar)) {
						
						//Se aniade al ArrayList el jugador que tiene el mismo nombre que el buscado
						coincidencias.add(pistas[i].getPartidasJugadas().get(j).getJugadores()[k]);
					}
					
					//NO PARO LA BUSQUEDA DESPUES DE QUE ENCUENTRE UN RESULTADO PORQUE PUEDE HABER VARIOS
					//JUGADORES CON EL MISMO NOMBRE
				
				}
			}
			
		}
		
		return coincidencias;
		
	}
	
	
	/*
	 * Analisis: Este metodo busca la puntuacion mas alta entre las puntuaciones de todos los jugadores
	 * 
	 * Entradas: Ninguna
	 * 
	 * Interfaz: public ArrayList<Jugador> buscarPuntuacionMaxima()
	 * 
	 * Salidas: Un arrayList de jugadores que contiene al/los jugador/es con la puntuacion mas alta
	 * 
	 * Precondiciones: 
	 * 
	 * Postcondiciones:  
	 *
	 * Puede que haya mas de un jugador con la puntuacion maxima
	 */
	
	public ArrayList<Jugador> buscarPuntuacionMaxima(){
		
		ArrayList<Jugador> maximasPuntuaciones = new ArrayList<Jugador>();
		
		for(int i = 0; i < 11; i++) {
			
			//LA PROBLEMATICA AQUI ES SI ENCUENTRO A VARIOS JUGADORES QUE TENGAN LA MISMA PUNTUACION
			//PERO DESPUES ENCUENTRE A OTRO JUGADOR QUE TENGA UNA PUNTUACION MAYOR
			//ENTONCES TENDRIA QUE QUITAR DOS DEL ARRAY Y TAL
			if((pistas[i].getMejorJugador().compareTo(pistas[i+1].getMejorJugador())) < 0){
				maximasPuntuaciones.add(pistas[i].getMejorJugador());
			}
		}
		
		return maximasPuntuaciones;
		
		
	}
	 
	
}
