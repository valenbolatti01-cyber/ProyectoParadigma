"
Paquete tematico de niveles de DragonBall. Listo para incorporar mapas personalizados.
"
Class {
	#name : 'NivelesDragonBall',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'accessing' }
NivelesDragonBall >> claveIcono [
    ^ #dragonBall
]

{ #category : 'theme' }
NivelesDragonBall >> colorTema [
    ^ EstiloLongcat colorNaranja
]

{ #category : 'levels' }
NivelesDragonBall >> niveles [
    "Agregar aqui los objetos Nivel tematicos de Dragon Ball."
    ^ OrderedCollection new
]

{ #category : 'accessing' }
NivelesDragonBall >> nombre [
    ^ 'Dragon Ball'
]

{ #category : 'theme' }
NivelesDragonBall >> tituloVentana [
    ^ 'dragonball.exe'
]
