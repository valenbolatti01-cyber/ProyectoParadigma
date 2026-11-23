"
Aspecto del mundo Pokemon: casillas de pasto que el gato convierte en camino de tierra, rocas como obstaculos y el gatito entrenador como protagonista.
"
Class {
	#name : 'TemaPokemon',
	#superclass : 'TemaTematico',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'accessing' }
TemaPokemon class >> identificadorDeMundo [
	^ #pokemon
]

{ #category : 'images' }
TemaPokemon >> archivosDeImagenes [
	^ {
		#pokemonCasillaLibre -> 'Pokemon imagenes/Casilla_pasto.png'.
		#pokemonCasillaRecorrida -> 'Pokemon imagenes/Camino_tierra.png'.
		#pokemonObstaculo -> 'Pokemon imagenes/Roca.png'.
		#pokemonProtagonista -> 'Pokemon imagenes/Gatito_protagonista.png'.
		#pokemonTituloReglas -> 'Pokemon imagenes/Pokemon_Reglas.png'.
		#pokemonSeparador -> 'Pokemon imagenes/separador_cara_gato.png'.
		#pokemonCabezaArriba -> 'arriba_Pokémon.png'.
		#pokemonCabezaAbajo -> 'abajo_Pokémon.png'.
		#pokemonCabezaDerecha -> 'derecha_Pokémon.png'.
		#pokemonCabezaIzquierda -> 'izquierda_Pokémon.png' }
]

{ #category : 'images' }
TemaPokemon >> claveCasillaLibre [
	^ #pokemonCasillaLibre
]

{ #category : 'images' }
TemaPokemon >> claveCasillaRecorrida [
	^ #pokemonCasillaRecorrida
]

{ #category : 'images' }
TemaPokemon >> claveObstaculo [
	^ #pokemonObstaculo
]

{ #category : 'skins' }
TemaPokemon >> claveProtagonista [
	^ #pokemonProtagonista
]

{ #category : 'images' }
TemaPokemon >> claveSeparador [
	^ #pokemonSeparador
]

{ #category : 'images' }
TemaPokemon >> claveTituloReglas [
	^ #pokemonTituloReglas
]

{ #category : 'skins' }
TemaPokemon >> clavesDeCabeza [
	"Cabezas del personaje de este mundo: arriba_, abajo_, derecha_ e izquierda_ en assets/sprites"
	^ #(#pokemonCabezaArriba #pokemonCabezaAbajo #pokemonCabezaDerecha #pokemonCabezaIzquierda)
]

{ #category : 'colors' }
TemaPokemon >> colorMarco [
	^ EstiloLongcat colorRosa mixed: 0.6 with: EstiloLongcat colorMorado
]

{ #category : 'rules' }
TemaPokemon >> textoCasillaLibre [
	^ 'Pasto'
]

{ #category : 'rules' }
TemaPokemon >> textoCasillaRecorrida [
	^ 'Camino de tierra'
]

{ #category : 'rules' }
TemaPokemon >> textoObstaculo [
	^ 'Roca'
]
