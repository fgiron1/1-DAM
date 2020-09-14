package ejercicio7;

public class Pasapalabras {

	Celda[][] tablero;
	
	
	//Constructores
	
	public Pasapalabras() {
			
		tablero = new Celda[12][12];
		
	}
	
	public Pasapalabras(Celda[][] tablero) {
		
		this.tablero = tablero;
		
	}
	
	//Getters
	
	public Celda[][] getTablero() {
		
		return this.tablero;
		
	}
	
	/*
	 * Analisis:
	 * 
	 * Interfaz:
	 * 
	 * Entradas:
	 * 
	 * Salidas:
	 * 
	 * Precondiciones:
	 * 
	 * Postcondiciones: Devolverá null si la palabra a buscar se saldria del tablero, sino,
	 * devolvera la palabra buscada
	 * 
	 * 
	 */
	
	public String obtenerPalabra(int fila, int columna, int longitud, int direccion) {
		
		String devolver = "";
		
		//Para cada caso, comprobamos a priori que la palabra pedida no se sale del tablero
		//por ninguno de los dos sentidos.
		
		//Cada vez que aparece en dicho condicional fila-1, fila+1, columna-1 o columna+1,
		//se debe a que la casilla pasada por parametros tambien se contabiliza
		//en el calculo de la cantidad de espacios que va a ocupar la palabra.
		
		//Ademas, en
		
		switch(direccion) {
		
		case 1:
			
			if(fila-1 + longitud <= 11) {
			
				for(int i = 0; i < longitud; i++) {
				devolver += this.tablero[fila+i][columna].getLetra();	
				}
			
			} else {
				
				devolver = "null";
				
			}
			break;
			
		case 2:
			
			if(fila+1 - longitud >= 0 && fila + 1 - longitud <= 11 ) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila-i][columna].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
		
		case 3:
			
			if(columna - 1 + longitud <= 11 && columna - 1 + longitud >= 0) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila][columna+i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
		case 4:
			
			if(columna + 1 - longitud >= 0 && columna + 1 - longitud <= 11) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila][columna-i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
		case 5: 
			//\ arriba hacia abajo
			if(columna - 1 + longitud <= 11 && fila - 1 + longitud <= 11 &&
			   columna - 1 + longitud >= 0 && fila - 1 + longitud >= 0) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila+i][columna+i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
		case 6:
			// / abajo hacia arriba
			if(columna - 1 + longitud <= 11 && fila + 1 - longitud <= 11 &&
			   columna - 1 + longitud >= 0 && fila + 1 - longitud >= 0) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila-i][columna+i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
		case 7:
			// / arriba hacia abajo
			if(columna + 1 - longitud <= 11 && fila - 1 + longitud <= 11 &&
			   columna + 1 - longitud >= 0 && fila - 1 + longitud >= 0) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila+i][columna-i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
		case 8:
			// \ abajo hacia arriba
			if(columna + 1 - longitud <= 11 && columna + 1 - longitud >= 0
			   && fila + 1 - longitud <= 11 && fila + 1 - longitud >= 0) {
				
				for(int i = 0; i < longitud; i++) {
					devolver += this.tablero[fila-i][columna-i].getLetra();
				}
				
			} else {
				devolver = "null";
			}
			
			break;
			
			
		default:
			
			System.out.print("Entrada erronea");
		
		}
		
		return devolver;
	
	}
}
