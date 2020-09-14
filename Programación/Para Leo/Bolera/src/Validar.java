public class Validar {

	public Validar() {
		
	}
	
	public boolean validarPuntuacion(int puntuacion) {
		
		boolean juicio = false;
		
		if(puntuacion < 3001 && puntuacion > -1 ) {
			juicio = true;
		}
		return juicio;
	}
	
	public boolean validarNombre(String nombre) {
		
		boolean juicio = false;
		
		if(nombre.length() < 31) {
			juicio = true;
		}
		return juicio;
	}
	
	public boolean validarLongitudJugadores(Jugador[] jugadores) {
		
		boolean juicio = false;
		
		if(jugadores.length == 4) {
			juicio = true;
		}
		
		return juicio;
		
	}
	
	public boolean validarNumeroPista(int numero) {
		
		boolean juicio = false;
		
		if(numero >= 1 && numero <= 12) {
			juicio = true;
		}
		
		return juicio;
	}
	
	public boolean validarSalirPrograma(char salir) {
		
		boolean juicio = false;
		
		if(salir == 's' || salir == 'n' || salir == 'S' || salir == 'N') {
		
			juicio = true;
		}
		
		return juicio;
	}
	
}
