package ejercicio7;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class PasapalabrasTest {

	@Test
	void test() {
		
		
		
		Celda[][] sopaLetras = new Celda[12][12];
		String[] filas = new String[12];
		
		//Se crea un tablero con caracteres escogidos al azar
		//NOTA: No se crean usando la clase random debido a que en cada ejecucion del programa
		//se generaria un nuevo tablero, impidiendome hacer las comprobaciones posteriores
		
		filas[0] = "jeinoslpwomn";
		filas[1] = "entycxzomntr";
		filas[2] = "lmomkpjiunmj";
		filas[3] = "zsadqewrtygd";
		filas[4] = "zxasdfcvghbn";
		filas[5] = "lecuymbqohcy";
		filas[6] = "mopflrybsxfg";
		filas[7] = "algotpemznsd";
		filas[8] = "iqprmblamzit";
		filas[9] = "urhjczxmiutr";
		filas[10] ="mjoepslzmrny";
		filas[11] ="lobpbmzncyrt";
		
		//CREACION DEL TABLERO
		
		//Rellenamos el tablero
		for(int i = 0; i < 12; i ++) {
			for(int j = 0; j < 12; j ++) {
				sopaLetras[i][j] = new Celda(filas[i].charAt(j));
			}
		}
		
		Pasapalabras tablero = new Pasapalabras(sopaLetras);
		
		//Cada forma de obtener la palabra se va a someter a las siguientes pruebas:
		
				//1. La palabra tiene algun caracter en una esquina
				//2. La palabra tiene algun caracter en la parte superior del tablero
				//3. La palabra tiene algun caracter en la parte izquierda del tablero
				//4. La palabra tiene algun caracter en la parte derecha del tablero
				//5. La palabra no tiene ningun caracter en ningun lateral del tablero
				//6. La palabra tiene algun caracter en la parte inferior del tablero
				//7. Pedir una palabra que se salga del tablero
		
		//1. Vertical de arriba hacia abajo
		
		//Condicion 1
		String obtener1 = tablero.obtenerPalabra(0, 0, 4, 1);
		assertEquals("jelz", obtener1);
		
		//Condicion 2
		String obtener2 = tablero.obtenerPalabra(0, 2, 5, 1);
		assertEquals("itoaa", obtener2);
		
		//Condicion 3
		String obtener3 = tablero.obtenerPalabra(5, 0, 6, 1);
		assertEquals("lmaium", obtener3);
		
		//Condicion 4
		String obtener4 = tablero.obtenerPalabra(2, 10, 3, 1);
		assertEquals("mgb", obtener4);
				
		//Condicion 5
		String obtener5 = tablero.obtenerPalabra(4, 5, 2, 1);
		assertEquals("fm", obtener5);
				
		//Condicion 6
		String obtener6 = tablero.obtenerPalabra(3, 7, 4, 1);
		assertEquals("rvqb", obtener6);
		
		//Condicion 7
		String obtener7 = tablero.obtenerPalabra(0, 3, 13, 1);
		assertEquals("null", obtener7);
		
		
		
		
		//2. Vertical de abajo hacia arriba
		
		//Condicion 1
		String obtener21 = tablero.obtenerPalabra(3, 0, 4, 2);
		assertEquals("zlej", obtener21);
				
		//Condicion 2
		String obtener22 = tablero.obtenerPalabra(4, 2, 5, 2);
		assertEquals("aaoti", obtener22);
				
		//Condicion 3
		String obtener23 = tablero.obtenerPalabra(10, 0, 6, 2);
		assertEquals("muiaml", obtener23);
				
		//Condicion 4
		String obtener24 = tablero.obtenerPalabra(4, 10, 3, 2);
		assertEquals("bgm", obtener24);
						
		//Condicion 5
		String obtener25 = tablero.obtenerPalabra(5, 5, 2, 2);
		assertEquals("mf", obtener25);
						
		//Condicion 6
		String obtener26 = tablero.obtenerPalabra(6, 7, 4, 2);
		assertEquals("bqvr", obtener26);
				
		//Condicion 7
		String obtener27 = tablero.obtenerPalabra(10, 3, 13, 2);
		assertEquals("null", obtener27);
		
		
		
		//3. Horizontal de izquierda a derecha
		
		//Condicion 1
		String obtener31 = tablero.obtenerPalabra(0, 0, 4, 3);
		assertEquals("jein", obtener31);
				
		//Condicion 2
		String obtener32 = tablero.obtenerPalabra(0, 2, 5, 3);
		assertEquals("inosl", obtener32);
						
		//Condicion 3
		String obtener33 = tablero.obtenerPalabra(6, 0, 2, 3);
		assertEquals("mo", obtener33);
						
		//Condicion 4
		String obtener34 = tablero.obtenerPalabra(4, 9, 3, 3);
		assertEquals("hbn", obtener34);
								
		//Condicion 5
		String obtener35 = tablero.obtenerPalabra(3, 3, 4, 3);
		assertEquals("dqew", obtener35);
								
		//Condicion 6
		String obtener36 = tablero.obtenerPalabra(11, 2, 3, 3);
		assertEquals("bpb", obtener36);
						
		//Condicion 7
		String obtener37 = tablero.obtenerPalabra(10, 3, 13, 3);
		assertEquals("null", obtener37);
		
		
		//4. Horizontal de derecha a izquierda
		
		//Condicion 1
		String obtener41 = tablero.obtenerPalabra(0, 3, 4, 4);
		assertEquals("niej", obtener41);
						
		//Condicion 2
		String obtener42 = tablero.obtenerPalabra(0, 7, 5, 4);
		assertEquals("plson", obtener42);
								
		//Condicion 3
		String obtener43 = tablero.obtenerPalabra(6, 1, 2, 4);
		assertEquals("om", obtener43);
								
		//Condicion 4
		String obtener44 = tablero.obtenerPalabra(4, 11, 3, 4);
		assertEquals("nbh", obtener44);
										
		//Condicion 5
		String obtener45 = tablero.obtenerPalabra(3, 6, 4, 4);
		assertEquals("weqd", obtener45);
										
		//Condicion 6
		String obtener46 = tablero.obtenerPalabra(11, 4, 3, 4);
		assertEquals("bpb", obtener46);
								
		//Condicion 7
		String obtener47 = tablero.obtenerPalabra(10, 3, 13, 4);
		assertEquals("null", obtener47);
		
		
		
		//5. Diagonal de izquierda a derecha de arriba hacia abajo
		
		
		//Condicion 1
		String obtener51 = tablero.obtenerPalabra(0, 0, 4, 5);
		assertEquals("jnod", obtener51);
														
		//Condicion 2
		String obtener52 = tablero.obtenerPalabra(0, 1, 4, 5);
		assertEquals("etmq", obtener52);
														
		//Condicion 3
		String obtener53 = tablero.obtenerPalabra(3, 0, 4, 5);
		assertEquals("zxcf", obtener53);
														
		//Condicion 4
		String obtener54 = tablero.obtenerPalabra(5, 9, 3, 5);
		assertEquals("hfd", obtener54);
																
		//Condicion 5
		String obtener55 = tablero.obtenerPalabra(5, 5, 2, 5);
		assertEquals("my", obtener55);
																
		//Condicion 6
		String obtener56 = tablero.obtenerPalabra(8, 7, 4, 5);
		assertEquals("airr", obtener56);
													
		//Condicion 7
		String obtener57 = tablero.obtenerPalabra(10, 3, 13, 5);
		assertEquals("null", obtener57);
		

		
		
		//6. Diagonal de derecha a izquierda de abajo hacia arriba
		
		
		//Condicion 1
		String obtener61 = tablero.obtenerPalabra(2, 9, 3, 6);
		assertEquals("ntn", obtener61);
												
		//Condicion 2
		String obtener62 = tablero.obtenerPalabra(4, 1, 5, 6);
		assertEquals("xamcs", obtener62);
										
		//Condicion 3
		String obtener63 = tablero.obtenerPalabra(3, 0, 2, 6);
		assertEquals("zm", obtener63);
												
		//Condicion 4
		String obtener64 = tablero.obtenerPalabra(10, 9, 3, 6);
		assertEquals("rtt", obtener64);
														
		//Condicion 5
		String obtener65 = tablero.obtenerPalabra(8, 2, 4, 6);
		assertEquals("polm", obtener65);
														
		//Condicion 6
		String obtener66 = tablero.obtenerPalabra(11, 5, 3, 6);
		assertEquals("mlm", obtener66);
												
		//Condicion 7
		String obtener67 = tablero.obtenerPalabra(10, 3, 13, 6);
		assertEquals("null", obtener67);
		
		
		//7. Diagonal de derecha a izquierda de arriba hacia abajo

				
		//Condicion 1
		String obtener71 = tablero.obtenerPalabra(0, 11, 3, 7);
		assertEquals("ntn", obtener71);
										
		//Condicion 2
		String obtener72 = tablero.obtenerPalabra(0, 5, 5, 7);
		assertEquals("scmax", obtener72);
										
		//Condicion 3
		String obtener73 = tablero.obtenerPalabra(2, 1, 2, 7);
		assertEquals("mz", obtener73);
										
		//Condicion 4
		String obtener74 = tablero.obtenerPalabra(8, 11, 3, 7);
		assertEquals("ttr", obtener74);
												
		//Condicion 5
		String obtener75 = tablero.obtenerPalabra(5, 5, 4, 7);
		assertEquals("mlop", obtener75);
												
		//Condicion 6
		String obtener76 = tablero.obtenerPalabra(9, 7, 3, 7);
		assertEquals("mlm", obtener76);
										
		//Condicion 7
		String obtener77 = tablero.obtenerPalabra(10, 3, 13, 7);
		assertEquals("null", obtener77);
		
		
		
		
		//8. Diagonal de izquierda a derecha de abajo hacia arriba
		
	
		//Condicion 1
		String obtener81 = tablero.obtenerPalabra(3, 3, 4, 8);
		assertEquals("donj", obtener81);
														
		//Condicion 2
		String obtener82 = tablero.obtenerPalabra(3, 4, 4, 8);
		assertEquals("qmte", obtener82);
														
		//Condicion 3
		String obtener83 = tablero.obtenerPalabra(7, 4, 5, 8);
		assertEquals("tfcxz", obtener83);
														
		//Condicion 4
		String obtener84 = tablero.obtenerPalabra(7, 11, 3, 8);
		assertEquals("dfh", obtener84);
																
		//Condicion 5
		String obtener85 = tablero.obtenerPalabra(6, 6, 2, 8);
		assertEquals("ym", obtener85);
																
		//Condicion 6
		String obtener86 = tablero.obtenerPalabra(11, 10, 4, 8);
		assertEquals("rria", obtener86);
													
		//Condicion 7
		String obtener87 = tablero.obtenerPalabra(10, 3, 13, 8);
		assertEquals("null", obtener87);
		
		
		
	
	}

}
