"
Coordina tablero y gato, acepta movimientos mientras está activa, actualiza el estado terminal y reinicia el mismo nivel. No imprime ni recibe entradas de interfaz.
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'gato',
		'estado',
		'posicionInicial'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Partida class >> deFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas [
    ^ self
        deFilas: unaCantidadDeFilas
        columnas: unaCantidadDeColumnas
        inicio: ((Smalltalk globals at: #Posicion) fila: 1 columna: 1)
]

{ #category : 'instance creation' }
Partida class >> deFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas inicio: unaPosicion [
    ^ self basicNew
        inicializarFilas: unaCantidadDeFilas
        columnas: unaCantidadDeColumnas
        inicio: unaPosicion
]

{ #category : 'private - state' }
Partida >> actualizarEstado [
    (tablero cantidadDisponibles = 0)
        ifTrue: [ estado := #victoria. ^ self ].
    self tieneMovimientosPosibles
        ifFalse: [ estado := #derrota ].
    ^ self
]

{ #category : 'accessing' }
Partida >> cantidadDisponibles [
    ^ tablero cantidadDisponibles
]

{ #category : 'accessing' }
Partida >> casillaBloqueadaEn: unaPosicion [
    ^ tablero estaBloqueada: unaPosicion
]

{ #category : 'accessing' }
Partida >> columnas [
	^ tablero columnas
]

{ #category : 'accessing' }
Partida >> estado [
    ^ estado
]

{ #category : 'accessing' }
Partida >> filas [
	^ tablero filas
]

{ #category : 'initialization' }
Partida >> inicializarFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas inicio: unaPosicion [
    tablero := (Smalltalk globals at: #Tablero) filas: unaCantidadDeFilas columnas: unaCantidadDeColumnas.
    (unaPosicion isKindOf: (Smalltalk globals at: #Posicion))
        ifFalse: [ self error: 'La posicion inicial debe ser una (Smalltalk globals at: #Posicion)' ].
    (tablero contiene: unaPosicion)
        ifFalse: [ self error: 'La posicion inicial esta fuera del tablero' ].
    posicionInicial := (Smalltalk globals at: #Posicion) fila: unaPosicion fila columna: unaPosicion columna.
    gato := (Smalltalk globals at: #Gato) en: posicionInicial.
    tablero ocupar: posicionInicial.
    estado := #activa.
    self actualizarEstado.
    ^ self
]

{ #category : 'accessing' }
Partida >> longitudGato [
    ^ gato longitud
]

{ #category : 'movement' }
Partida >> moverEn: unaDireccion [
    | siguiente |
    estado = #activa ifFalse: [ ^ self ].
    (unaDireccion isKindOf: (Smalltalk globals at: #Direccion))
        ifFalse: [ self error: 'Se necesita una direccion de movimiento' ].
    siguiente := unaDireccion posicionSiguienteA: gato cabeza.
    [ tablero estaDisponible: siguiente ] whileTrue: [
        tablero ocupar: siguiente.
        gato avanzarA: siguiente enDireccion: unaDireccion.
        siguiente := unaDireccion posicionSiguienteA: gato cabeza
    ].
    self actualizarEstado.
    ^ self
]

{ #category : 'accessing' }
Partida >> posicionCabeza [
    ^ gato cabeza
]

{ #category : 'accessing' }
Partida >> posicionesOcupadas [
    ^ gato posicionesOcupadas
]

{ #category : 'testing' }
Partida >> puedeMoverseEn: unaDireccion [
    (unaDireccion isKindOf: (Smalltalk globals at: #Direccion)) ifFalse: [ ^ false ].
    ^ tablero estaDisponible: (unaDireccion posicionSiguienteA: gato cabeza)
]

{ #category : 'changing state' }
Partida >> reiniciar [
    tablero reiniciar.
    gato reiniciarEn: posicionInicial.
    tablero ocupar: posicionInicial.
    estado := #activa.
    self actualizarEstado.
    ^ self
]

{ #category : 'testing' }
Partida >> tieneMovimientosPosibles [
    ^ (Smalltalk globals at: #Direccion) todas anySatisfy: [ :direccion |
        self puedeMoverseEn: direccion
    ]
]
