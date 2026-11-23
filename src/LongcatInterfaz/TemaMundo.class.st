"
Abstraccion Estrategia del aspecto visual de un mundo de niveles (capa de interfaz: el dominio no la conoce). Decide que interfaz de partida se usa y con que imagenes se viste. Para agregar un mundo nuevo alcanza con una subclase de TemaTematico que declare su identificador, sus imagenes y su aspecto: no hay que tocar LongcatApp ni InterfazPartida. Los mundos sin tema propio usan TemaClasico.
"
Class {
	#name : 'TemaMundo',
	#superclass : 'Object',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'images' }
TemaMundo class >> archivosDeImagenes [
	"Imagenes de todos los temas (clave -> ruta relativa dentro de la carpeta de assets)"
	^ self allSubclasses
		inject: OrderedCollection new
		into: [ :todos :tema | todos addAll: tema new archivosDeImagenes; yourself ]
]

{ #category : 'accessing' }
TemaMundo class >> identificadorDeMundo [
	"Identificador de la ColeccionNiveles a la que viste este tema (nil en los temas abstractos)"
	^ nil
]

{ #category : 'instance creation' }
TemaMundo class >> paraColeccion: unaColeccion [
	^ (self allSubclasses
		detect: [ :tema | tema identificadorDeMundo = unaColeccion identificador ]
		ifNone: [ TemaClasico ]) new
]

{ #category : 'images' }
TemaMundo >> archivosDeImagenes [
	^ #()
]

{ #category : 'skins' }
TemaMundo >> claveProtagonista [
	^ #protagonista
]

{ #category : 'instance creation' }
TemaMundo >> crearInterfazPara: unaApp progreso: unProgreso [
	self subclassResponsibility
]
