package EjercicioJose;

import org.junit.jupiter.api.Test;

import static org.junit.Assert.assertTrue;

import org.junit.Assert.*;

public class TDDTest {
    @Test
    void tresPrimos() {
        int[] primos;
        int valorMinimo, diferenciaMinima;

        //Prueba 1
        valorMinimo = 4;
        diferenciaMinima = 10;
        primos = TDD.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD.isPrime(primos[0]));
        assertTrue(TDD.isPrime(primos[1]));
        assertTrue(TDD.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);

        //Prueba 2
        valorMinimo = 666;
        diferenciaMinima = 42;
        primos = TDD.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD.isPrime(primos[0]));
        assertTrue(TDD.isPrime(primos[1]));
        assertTrue(TDD.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);

        //Prueba 3
        valorMinimo = 4000;
        diferenciaMinima = 2500;
        primos = TDD.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD.isPrime(primos[0]));
        assertTrue(TDD.isPrime(primos[1]));
        assertTrue(TDD.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);
    }
}
