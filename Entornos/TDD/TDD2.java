package TDD;
import java.security.SecureRandom;
import java.util.stream.IntStream;

public class TDD2 {
    static SecureRandom random = new SecureRandom();

    public static boolean isPrime(int number) {
        return number > 1
                && IntStream.rangeClosed(2, (int) Math.sqrt(number))
                .noneMatch(n -> (number % n == 0));
    }

    public static int[] tresPrimos(int valorMinimo, int diferenciaMinima) {
        int[] primos = new int[3];
        boolean dif;

        for (int i = 0; i < primos.length; i++) {
            dif = true;
            do {
                primos[i] = random.nextInt(999999) + valorMinimo + 1; //Max int 2147483647
                if (i == 1) {
                    dif = Math.abs(primos[i-1] - primos[i]) >= diferenciaMinima;
                } else if (i == 2) {
                    dif = Math.abs(primos[i-1] - primos[i]) >= diferenciaMinima && Math.abs(primos[i-2] - primos[i]) >= diferenciaMinima;
                }
            } while (!isPrime(primos[i]) || !dif);
        }
        return primos;
    }
}
