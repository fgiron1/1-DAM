package ejercicio4;

import java.util.Random;
public class Ejercicio4 {
	
	public static void main(String[] args) {
	
			System.out.print(generarPalabra(5));
	
	}
	
	
	
	
	public static String generarPalabra(int longitud) {
		
		//Lo de que los caracteres esten dispuestos en posiciones aleatorias se podria comprobar pero
		//la comprobacion seria generar muchas cadenas y comprobar que cada letra tiene la misma probabilidad
		//de caer en cada posicion
		char[] caracteres = new char[longitud];
		char caracter;
		Random posicionAleatoria = new Random();
		Random caracterAleatorio = new Random();
		
		int posicion;
		
		//Va a comprobar que un caracter de una posicion aleatoria del array caracteres tiene el valor por defecto,
		//es decir, '\u0000', si es asi, se le asigna un caracter aleatorio. De no ser asi, se sigue buscando una posicion
		//que no tenga dicho caracter por defecto. Solamente se contabilizan (a traves del indice i) aquellas veces en las
		//que si se ha cambiado el caracter por uno aleatorio, por lo que el proceso finalizara cuando i == longitud del array caracteres
		
		for(int i = 0; i < longitud; i++) {
			
			do {
				posicion = posicionAleatoria.nextInt(longitud);
				if(caracteres[posicion] == '\u0000') {
					
					caracter = (char) (caracterAleatorio.nextInt(26) + 'a');
					caracteres[posicion] = caracter;
				}
				
			}while(caracteres[posicion] == '\u0000');
			
		}
		
		//El array de caracteres se usa para construir el String palabra
		String palabra = new String(caracteres);
		
		return palabra;
		
	}

}
