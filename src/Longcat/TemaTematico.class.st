"
Superclase abstracta de los temas ilustrados (Minecraft, Pokemon, Dragon Ball...). Usa InterfazPartidaTematica y un TableroTematicoMorph; cada subclase solo declara las claves de sus imagenes y los archivos que las contienen.
"
Class {
	#name : 'TemaTematico',
	#superclass : 'TemaMundo',
	#category : 'Longcat',
	#package : 'Longcat'
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
