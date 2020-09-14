/*
* Usando la metodología TDD (Test Driven Development) se desea desarrollar un método que debe devolver un array con tres números
* primos que cumplan algunas restricciones. Los números primos deben ser mayores que el primer entero que se le pase como primer
* parámetro al método. El segundo entero pasado como parámetro indicará que la diferencia entre cualquiera de los números primos
* y cualquiera de los otros dos debe ser al menos esa cantidad en valor absoluto. Los números primos pueden estar dispuestos en
* cualquier orden en el array.
* */

package TDD;
import org.junit.jupiter.api.Test;
import org.junit.Assert.*;

public class TDD2Test {
    @Test
    void tresPrimos() {
        int[] primos;
        int valorMinimo, diferenciaMinima;

        //Prueba 1
        valorMinimo = 4;
        diferenciaMinima = 10;
        primos = TDD2.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD2.isPrime(primos[0]));
        assertTrue(TDD2.isPrime(primos[1]));
        assertTrue(TDD2.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);

        //Prueba 2
        valorMinimo = 666;
        diferenciaMinima = 42;
        primos = TDD2.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD2.isPrime(primos[0]));
        assertTrue(TDD2.isPrime(primos[1]));
        assertTrue(TDD2.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);

        //Prueba 3
        valorMinimo = 4000;
        diferenciaMinima = 2500;
        primos = TDD2.tresPrimos(valorMinimo, diferenciaMinima);

        assertTrue(TDD2.isPrime(primos[0]));
        assertTrue(TDD2.isPrime(primos[1]));
        assertTrue(TDD2.isPrime(primos[2]));

        assertTrue(primos[0] > valorMinimo);
        assertTrue(primos[1] > valorMinimo);
        assertTrue(primos[2] > valorMinimo);

        assertTrue(Math.abs(primos[0] - primos[1]) >= diferenciaMinima && Math.abs(primos[0] - primos[2]) >= diferenciaMinima && Math.abs(primos[1] - primos[2]) >= diferenciaMinima);
    }
}
