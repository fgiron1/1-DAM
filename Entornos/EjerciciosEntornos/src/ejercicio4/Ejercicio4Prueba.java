package ejercicio4;

import java.util.Random;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class Ejercicio4Prueba {

	

	//Mi metodo generarPalabra recibira un input que ya esta validado
	@Test
	void testGenerarPalabra() {
		//Lo de que los caracteres esten dispuestos en posiciones aleatorias se podria comprobar pero
		//la comprobacion seria generar muchas cadenas y comprobar que cada letra tiene la misma probabilidad
		//de caer en cada posicion
		
		
		//Comprobamos que la cadena generada tiene la misma longitud que la pasada por parametros
		int longitud = 3;
		String palabra = Ejercicio4.generarPalabra(longitud);
		assertEquals(3, palabra.length());
		
		
		
		
		
		
	}

}
