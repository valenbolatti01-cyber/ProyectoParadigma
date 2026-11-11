"
Representa una celda y su estado: libre, ocupada o bloqueada. Expone consultas y cambios controlados sin compartir estructuras internas.
"
Class {
	#name : 'Casilla',
	#superclass : 'Object',
	#instVars : [
		'estado'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Casilla class >> bloqueada [
    ^ self basicNew inicializarConEstado: #bloqueada
]

{ #category : 'instance creation' }
Casilla class >> libre [
    ^ self basicNew inicializarConEstado: #libre
]

{ #category : 'instance creation' }
Casilla class >> ocupada [
    ^ self basicNew inicializarConEstado: #ocupada
]

{ #category : 'changing state' }
Casilla >> bloquear [
    self estaDisponible
        ifFalse: [ self error: 'Solo se puede bloquear una casilla libre' ].
    estado := #bloqueada.
    ^ self
]

{ #category : 'testing' }
Casilla >> estaBloqueada [
    ^ estado = #bloqueada
]

{ #category : 'testing' }
Casilla >> estaDisponible [
    ^ estado = #libre
]

{ #category : 'testing' }
Casilla >> estaOcupada [
    ^ estado = #ocupada
]

{ #category : 'accessing' }
Casilla >> estado [
    ^ estado
]

{ #category : 'initialization' }
Casilla >> inicializarConEstado: unEstado [
    (#(#libre #ocupada #bloqueada) includes: unEstado)
        ifFalse: [ self error: 'Estado de casilla desconocido' ].
    estado := unEstado.
    ^ self
]

{ #category : 'changing state' }
Casilla >> ocupar [
    self estaDisponible
        ifFalse: [ self error: 'Solo se puede ocupar una casilla libre' ].
    estado := #ocupada.
    ^ self
]

{ #category : 'changing state' }
Casilla >> reiniciar [
    self estaOcupada ifTrue: [ estado := #libre ].
    ^ self
]
