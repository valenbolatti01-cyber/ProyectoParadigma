"
Aspecto del mundo Dragon Ball: suelo de Namek que el gato convierte en suelo rocoso, capsulas danadas como obstaculos y el gatito guerrero como protagonista.
"
Class {
	#name : 'TemaDragonBall',
	#superclass : 'TemaTematico',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'accessing' }
TemaDragonBall class >> identificadorDeMundo [
	^ #dragonBall
]

{ #category : 'images' }
TemaDragonBall >> archivosDeImagenes [
	^ {
		#dragonBallCasillaLibre -> 'Dragon Ball Imagenes/Suelo_de_Namek.png'.
		#dragonBallCasillaRecorrida -> 'Dragon Ball Imagenes/Suelo_rocoso.png'.
		#dragonBallObstaculo -> 'Dragon Ball Imagenes/Capsula_danada_obstaculo.png'.
		#dragonBallProtagonista -> 'Dragon Ball Imagenes/Gatito_Dragon_Ball.png'.
		#dragonBallTituloReglas -> 'Dragon Ball Imagenes/Dragon_Ball_Reglas.png'.
		#dragonBallSeparador -> 'Dragon Ball Imagenes/separador_cara_gato.png' }
]

{ #category : 'images' }
TemaDragonBall >> claveCasillaLibre [
	^ #dragonBallCasillaLibre
]

{ #category : 'images' }
TemaDragonBall >> claveCasillaRecorrida [
	^ #dragonBallCasillaRecorrida
]

{ #category : 'images' }
TemaDragonBall >> claveObstaculo [
	^ #dragonBallObstaculo
]

{ #category : 'skins' }
TemaDragonBall >> claveProtagonista [
	^ #dragonBallProtagonista
]

{ #category : 'images' }
TemaDragonBall >> claveSeparador [
	^ #dragonBallSeparador
]

{ #category : 'images' }
TemaDragonBall >> claveTituloReglas [
	^ #dragonBallTituloReglas
]

{ #category : 'colors' }
TemaDragonBall >> colorMarco [
	^ EstiloLongcat colorNaranja mixed: 0.6 with: EstiloLongcat colorMorado
]

{ #category : 'rules' }
TemaDragonBall >> textoCasillaLibre [
	^ 'Suelo de Namek'
]

{ #category : 'rules' }
TemaDragonBall >> textoCasillaRecorrida [
	^ 'Suelo rocoso'
]

{ #category : 'rules' }
TemaDragonBall >> textoObstaculo [
	^ 'Cápsula dañada'
]
