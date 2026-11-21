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
