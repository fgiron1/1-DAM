/*
 * Variables de entrada: tamaño de la matriz
 * 
 * Variables de salida: -
 * 
 * PSEUDOCÓDIGO GENERALIZADO
 * 
 * <Inicio>
 * 		introducirTamañoMatriz
 * 		validarTamañoMatriz
 * 		introducirNumero
 * 		validarNumero
 * 		construirMatriz*
 * <Fin>
 * 
 * 
 * 
 */


import java.util.Scanner;

public class CuadradoMagico{
	
	public static void main(String[] args){
			
		Scanner input = new Scanner(System.in);
		int n;
		
		System.out.print("Introducir el tamanio del cuadrado magico, entre 1 y 9: ");
		
		do{
			boolean condicion = n < 0 || n > 9;
			n = input.nextInt();
			if(condicion){
				System.out.print("Tamanio incorrecto\n");
			}
			
		}while(condicion);
		
		matriz = construirMatriz(n);
		
		imprimirMatriz(matriz);
			
		
	}
	
}

/*
 * INTERFAZ
 * 
 * Análisis: Devuelve un array bidimensional (matriz) de dimensión n
 * 
 * Signatura: 
 * 
 * Variables de entrada: 
 * 
 * Variables de salida: 
 * 
 * Precondiciones: 
 * 
 * Postcondiciones: 
 * 
 * 
 * 
 * PSEUDOCÓDIGO DETALLADO
 * 		
 * i = 0;
 * j = n/2;
 * 
 * FOR(i desde 0 hasta n){
 * 	FOR(j desde 0 hasta n){
 * 
 * 		matriz[i][j] = 0 //Relleno la matriz de 0
 * 
 * 	}
 * }
 * 
 * 	FOR(i desde n hasta 0){
 * 		FOR(j desde n hasta 0){
 * 		matriz[i][j] = numero+=1;
 * 	  }
 * }
 * 
 * FOR(k desde 0 hasta numero de casillas){
 * 		
 * 
 * 		IF(matriz[i][j] no está rellenado (== 0)){
 * 
 * 			IF(te vas a salir de la matriz por arriba (i es un numero de fila ilegal por arriba)){
 * 
 * 				i = n; //En realidad es n-1 por empezar en 0 en el array
 * 
 * 			}	ELSE IF (te vas a salir de la matriz por debajo (i es un numero de fila ilegal por debajo)){
 * 
 * 				i = 0;
 * 
 *			}	ELSE IF(te vas a salir de la matriz por la izquierda (j es un numero de columna ilegal por la izquierda)){
 * 
 * 				j = n; //En realidad es n-1 por empezar en 0 en el array
 * 
 * 			} ELSE IF (te vas a salir de la matriz por la derecha (j es un numero de columna ilegal por la derecha)){
 * 	
 * 				j = 0;
 * 
 *			}
 * 		} ELSE {
 * 	
 * 			i += 2;
 * 			j -= 1;
 * 
 * 		}
 * 
 * 		matriz[i][j] = numero
 * 		i--;
 * 		j--;
 * 		numero += 1;
 * 
 * 
 * 
 */

public static int[][] construirMatriz(int n){
	
	int filas = 0;
	int columnas = n/2;
	int[][] matriz = matriz[n][n];
	numero = 1;
	
	//Relleno la matriz de 0
	for(int i = 0; i < n; i++){
		for(int j = 0; j < n; j++){
			matriz[i][j] = 0;
		}
	}
	
	for(int i = 0; i < n*n; i++){ //Se repite tantas veces como casillas vaya a tener la matriz
		
		if(matriz[filas][columnas] == 0){
			
			if(filas = -1){
				
				i = n-1;
				
			} else if(filas = n){
				
				i = 0;
				
			} else if(columnas = -1){
				
				j = n-1;
				
			} else if(columnas = n){
				
				j = 0;
				
			}else {
			
				filas += 2;
				columnas -= 1;
			
			}
		}
		
		matriz[filas][columnas] = numero;
		i--;
		j--;
		numero += 1;
		
	}
	
	return matriz;
	
}

/*
 * INTERFAZ
 * 
 * Análisis: Devuelve un array bidimensional (matriz) de dimensión n
 * 
 * Signatura: 
 * 
 * Variables de entrada: 
 * 
 * Variables de salida: 
 * 
 * Precondiciones: 
 * 
 * Postcondiciones: 
 * 
 */

public static String imprimirMatriz(int[][] matriz){
	
	for(int i = 0; i < matriz.length; i++){
		for(int j = 0; j < matriz.length[i]; i++){
			
			
		}
	}
	
	
}
