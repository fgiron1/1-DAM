package ejercicio7;

public class Celda {

	char letra;
	
	//Por defecto, si no se inicializa, letra contendra el valor '\u0000'
	
	public Celda(char letra) {
		
		this.letra = letra;
		
	}
	
	public void setLetra(char letra) {
		
		this.letra = letra;
		
	}
	
	public char getLetra() {
		
		return this.letra;
		
	}
	
}
