"
Aspecto del mundo Minecraft: casillas de pasto que el gato convierte en camino de piedra, bloques de piedra como obstaculos y el gato gamer con sudadera de Creeper como protagonista.
"
Class {
	#name : 'TemaMinecraft',
	#superclass : 'TemaTematico',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'accessing' }
TemaMinecraft class >> identificadorDeMundo [
	^ #minecraft
]

{ #category : 'images' }
TemaMinecraft >> archivosDeImagenes [
	^ {
		#minecraftCasillaLibre -> 'Minecraft imagenes/Casilla_pasto.png'.
		#minecraftCasillaRecorrida -> 'Minecraft imagenes/Casilla_piedra.png'.
		#minecraftObstaculo -> 'Minecraft imagenes/piedra.png'.
		#minecraftProtagonista -> 'Minecraft imagenes/Gato gamer con sudadera Creeper.png'.
		#minecraftTituloReglas -> 'Minecraft imagenes/titulo_minecraft_reglas.png'.
		#minecraftSeparador -> 'Minecraft imagenes/separador_cara_gato.png'.
		#minecraftCabezaArriba -> #('arriba_Minecraft.png' 'atras_Minecraft.png').
		#minecraftCabezaAbajo -> #('abajo_Minecraft.png' 'frente_Minecraft.png').
		#minecraftCabezaDerecha -> 'derecha_Minecraft.png'.
		#minecraftCabezaIzquierda -> 'izquierda_Minecraft.png' }
]

{ #category : 'images' }
TemaMinecraft >> claveCasillaLibre [
	^ #minecraftCasillaLibre
]

{ #category : 'images' }
TemaMinecraft >> claveCasillaRecorrida [
	^ #minecraftCasillaRecorrida
]

{ #category : 'images' }
TemaMinecraft >> claveObstaculo [
	^ #minecraftObstaculo
]

{ #category : 'skins' }
TemaMinecraft >> claveProtagonista [
	^ #minecraftProtagonista
]

{ #category : 'images' }
TemaMinecraft >> claveSeparador [
	^ #minecraftSeparador
]

{ #category : 'images' }
TemaMinecraft >> claveTituloReglas [
	^ #minecraftTituloReglas
]

{ #category : 'skins' }
TemaMinecraft >> clavesDeCabeza [
	"Cabezas del personaje de este mundo: arriba_, abajo_, derecha_ e izquierda_ en assets/sprites"
	^ #(#minecraftCabezaArriba #minecraftCabezaAbajo #minecraftCabezaDerecha #minecraftCabezaIzquierda)
]

{ #category : 'colors' }
TemaMinecraft >> colorMarco [
	^ EstiloLongcat colorVerde mixed: 0.55 with: EstiloLongcat colorMorado
]
