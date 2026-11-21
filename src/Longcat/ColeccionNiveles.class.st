"
Abstraccion Estrategia para paquetes de niveles tematicos. Cada subclase provee exclusivamente su nombre y sus mapas (Nivel).
"
Class {
	#name : 'ColeccionNiveles',
	#superclass : 'Object',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
ColeccionNiveles class >> normales [
    ^ NivelesNormales new
]

{ #category : 'instance creation' }
ColeccionNiveles class >> personalizadas [
    ^ { NivelesMinecraft new. NivelesPokemon new. NivelesDragonBall new }
]

{ #category : 'instance creation' }
ColeccionNiveles class >> todas [
    ^ { self normales }, self personalizadas
]

{ #category : 'comparing' }
ColeccionNiveles >> = otraColeccion [
    ^ self class = otraColeccion class
]

{ #category : 'levels' }
ColeccionNiveles >> cantidad [
    ^ self niveles size
]

{ #category : 'accessing' }
ColeccionNiveles >> claveIcono [
    self subclassResponsibility
]

{ #category : 'theme' }
ColeccionNiveles >> colorAcento [
    ^ EstiloLongcat colorVerde
]

{ #category : 'theme' }
ColeccionNiveles >> colorBloque [
    ^ EstiloLongcat colorPizarra
]

{ #category : 'theme' }
ColeccionNiveles >> colorPantalla [
    ^ EstiloLongcat colorPantalla
]

{ #category : 'theme' }
ColeccionNiveles >> colorTema [
    ^ EstiloLongcat colorMorado
]

{ #category : 'testing' }
ColeccionNiveles >> estaDisponible [
    ^ self niveles notEmpty
]

{ #category : 'comparing' }
ColeccionNiveles >> hash [
    ^ self class hash
]

{ #category : 'levels' }
ColeccionNiveles >> nivel: unNumero [
    ^ self niveles at: unNumero
]

{ #category : 'levels' }
ColeccionNiveles >> niveles [
    self subclassResponsibility
]

{ #category : 'accessing' }
ColeccionNiveles >> nombre [
    self subclassResponsibility
]

{ #category : 'theme' }
ColeccionNiveles >> tituloVentana [
    ^ 'longcat.exe'
]
