"
Superclase abstracta de los temas ilustrados (Minecraft, Pokemon, Dragon Ball...). Usa InterfazPartidaTematica y un TableroTematicoMorph; cada subclase solo declara las claves de sus imagenes y los archivos que las contienen.
"
Class {
	#name : 'TemaTematico',
	#superclass : 'TemaMundo',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'images' }
TemaTematico >> claveCasillaLibre [
	self subclassResponsibility
]

{ #category : 'images' }
TemaTematico >> claveCasillaRecorrida [
	self subclassResponsibility
]

{ #category : 'images' }
TemaTematico >> claveObstaculo [
	self subclassResponsibility
]

{ #category : 'images' }
TemaTematico >> claveSeparador [
	self subclassResponsibility
]

{ #category : 'images' }
TemaTematico >> claveTituloReglas [
	self subclassResponsibility
]

{ #category : 'skins' }
TemaTematico >> clavesDeCabeza [
	"Claves de las imagenes de la cabeza del personaje del mundo, en orden: arriba, abajo, derecha, izquierda"
	self subclassResponsibility
]

{ #category : 'colors' }
TemaTematico >> colorMarco [
	^ EstiloLongcat colorMorado
]

{ #category : 'instance creation' }
TemaTematico >> crearInterfazPara: unaApp progreso: unProgreso [
	^ InterfazPartidaTematica app: unaApp progreso: unProgreso tema: self
]

{ #category : 'instance creation' }
TemaTematico >> crearTableroPara: unaPartida skin: unaSkin imagenes: unProveedorDeImagenes [
	^ TableroTematicoMorph
		partida: unaPartida
		skin: unaSkin
		tema: self
		imagenes: unProveedorDeImagenes
]

{ #category : 'rules' }
TemaTematico >> entradasDeLeyenda [
	"Pares clave de imagen -> texto que explican cada elemento del tablero"
	^ {
		self claveCasillaLibre -> self textoCasillaLibre.
		self claveCasillaRecorrida -> self textoCasillaRecorrida.
		self claveObstaculo -> self textoObstaculo }
]

{ #category : 'skins' }
TemaTematico >> skinConImagenes: unProveedorDeImagenes [
	"Skin del gato en este mundo: la cabeza del personaje del tema en sus cuatro direcciones,
	 con el cuerpo naranja de siempre. Responde nil si falta alguna de las imagenes."
	| cabezas |
	cabezas := self clavesDeCabeza collect: [ :clave | unProveedorDeImagenes imagen: clave ].
	(cabezas includes: nil) ifTrue: [ ^ nil ].
	^ SkinGato
		identificador: self class identificadorDeMundo
		nombre: self class identificadorDeMundo asString
		colorCuerpo: EstiloLongcat colorNaranja
		colorRayas: EstiloLongcat colorRayas
		colorBorde: self colorMarco
		cabezaArriba: (cabezas at: 1)
		cabezaAbajo: (cabezas at: 2)
		cabezaDerecha: (cabezas at: 3)
		cabezaIzquierda: (cabezas at: 4)
]

{ #category : 'rules' }
TemaTematico >> textoCasillaLibre [
	^ 'Casilla libre'
]

{ #category : 'rules' }
TemaTematico >> textoCasillaRecorrida [
	^ 'Recorrida'
]

{ #category : 'rules' }
TemaTematico >> textoObstaculo [
	^ 'Obstáculo'
]
