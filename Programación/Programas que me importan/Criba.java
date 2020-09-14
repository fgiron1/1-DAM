/*
 * Variables de entrada: Límite numero primo a calcular
 * 
 * Variables de salida -
 * 
 * 
 * PSEUDOCÓDIGO GENERALIZADO
 * 
 * <Inicio>
 * 		pedirMaximo
 * 		primosHasta*
 * 		imprimitPrimos
 * 		preguntarRepetir
 * <Fin>
 * 
 *
 * 
 */
import java.util.Scanner;

public class Criba{
	
		public static void main(String[] args){
			
			Scanner input = new Scanner(System.in);
			int n;
			boolean valido = false;
			
			do{
				
				System.out.print("Introduzca el numero hasta el cual quiere calcular numeros primos: ");
				n = input.nextInt();
				
				if(n <= 0){
					valido = false;
				} else {
					valido = true;
				}
			
			}while(!valido);
			
			System.out.print("Los numeros primos hasta "+n+" son: ");
			
			for(int primo : primosHasta(n)){
				
				if(primo != 0){
					System.out.print(primo + " ");
				}
			}
			
		}
	
	/*
	 * Análisis: Este método calcula los números primos desde 3 hasta un valor pasado por parámetros
	 * 
	 * Interfaz: public static int[] primosHasta(int limite)
	 * 
	 * Entradas: El número hasta el cual se desean calcular primos
	 * 
	 * Salidas: Un array de enteroscon los numeros primos desde 3 hasta el número máximo dado
	 * 
	 * Entrada/salida: -
	 * 
	 * Precondiciones: -
	 * 
	 * Postcondiciones: Todos los elementos del array devueltos son números primos
	 * 
	 * 
	 * PSEUDOCODIGO DETALLADO:
	 * 
	 * <Inicio>
	 * 
	 * 		FOR(Numeros impares hasta el limite){
	 * 
	 * 			
	 * 		}
	 * 
	 * 		FOR(Numeros impares (i) hasta el limite){ //Este bucle me da los números que voy a tener que quitar de la lista de números naturales del 1 al N, para así quedarme solamente con los primos. Puedo optimiazrlo porque en los cálculos de cada múltiplo se repite una operación para cada número cuyos múltiplos se calculan (3 * 5 sucede en el cálculo de los múltiplos del 3 y del 5, etc...)
	 * 			FOR(Múltiplos de i (i * j) hasta <= Raiz del límite){ // Es inmanejable almacenar los múltiplos para cada i, se necesita mucho espacio
	 * 				FOR(Todos los naturales hasta el límite)
	 * 					IF (i * j está en alguno de los números naturales){
	 * 						Igualarlo a 0    //Es decir, se quita.
	 * 					}
	 * 			}
	 * 		}
	 * 
	 * 
	 * <Fin>
	 */
	 
	 //POSIBLE OPTIMIZACION: NO CALCULAR LOS MÚLTIPLOS QUE YA SE HAYAN CALCULADO
	 
	 public static int[] primosHasta(int limite){
		 
		 int[] primos = new int[limite];
		 int[] numsProhibidos = new int[limite]; //Aquí estoy haciendo uso de más memoria de la que voy a necesitar, por la restriccion de tamaño fijo de los arrays, con arrayList sería mmucho más eficiente
		 double raizLimite = Math.sqrt(limite);
		 
		 for(int i = 2; i <= limite; i++){ //Rellenando el array primos con todos los números naturales impares.
			
			if(i % 2 != 0){
				primos[i] = i;
			}
		 }
		 //ALMACENAR TODOS LOS MÚLTIPLOS OCUPARIA MUCHO ESPACIO, TEN EN CUENTA QUE POR CADA i HAY UNOS POCOS DE MULTIPLOS, EL ARRAY DE NUMPROHIBIDOS TIENE QUE SER MUCHO MAS GRANDE QUE [LIMITE]
		 for(int i = 3; i <= limite; i++){ //Este for recorre todos los números impares hasta el límite. De cada i se van a calcular sus múltiplos DUDA: La condición de impar no se podría poner en el bucle for, verdad?
			 if(i % 2 != 0){
				 for(int j = 2; ((i * j) <= limite); j++){ //Se calculan los múltiplos de cada i
					 for(int k = 0; k < limite; k++){ //Recorre el array de numeros naturales en búsqueda de coincidencias con cada múltiplo de i, es decir, con cada i*j
						 if(primos[k] == i*j){
							 primos[k] = 0;
						 }
					 }
				 }
			}
		 }
		 
		 return primos;
		 
	 }
	 
}

