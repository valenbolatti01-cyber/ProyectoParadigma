"
Coordina tablero y gato, acepta movimientos mientras esta activa, actualiza el estado terminal y reinicia el mismo nivel. Cuenta los movimientos realizados: un movimiento es una accion valida que desplaza al gato, sin importar cuantas casillas recorra. No imprime ni recibe entradas de interfaz.
"
Class {
	#name : 'Partida',
	#superclass : 'Object',
	#instVars : [
		'tablero',
		'gato',
		'estado',
		'posicionInicial',
		'movimientos'
	],
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'instance creation' }
Partida class >> deFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas [
    ^ self
        deFilas: unaCantidadDeFilas
        columnas: unaCantidadDeColumnas
        inicio: (Posicion fila: 1 columna: 1)
]

{ #category : 'instance creation' }
Partida class >> deFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas inicio: unaPosicion [
    ^ self basicNew
        inicializarFilas: unaCantidadDeFilas
        columnas: unaCantidadDeColumnas
        inicio: unaPosicion
]

{ #category : 'instance creation' }
Partida class >> deNivel: unNivel [
    | nueva |
    nueva := self
        deFilas: unNivel filas
        columnas: unNivel columnas
        inicio: unNivel inicio.
    nueva bloquearTodas: unNivel bloqueos.
    ^ nueva
]

{ #category : 'private - state' }
Partida >> actualizarEstado [
    tablero cantidadDisponibles = 0
        ifTrue: [ estado := #victoria. ^ self ].
    self tieneMovimientosPosibles
        ifFalse: [ estado := #derrota ].
    ^ self
]

{ #category : 'changing state' }
Partida >> bloquearTodas: unasPosiciones [
    unasPosiciones do: [ :posicion | tablero bloquear: posicion ].
    self actualizarEstado.
    ^ self
]

{ #category : 'accessing' }
Partida >> cantidadDisponibles [
    ^ tablero cantidadDisponibles
]

{ #category : 'accessing' }
Partida >> cantidadMovimientos [
    ^ movimientos
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
Partida >> direccionCabeza [
    ^ gato direccionUltima ifNil: [ Abajo new ]
]

{ #category : 'testing' }
Partida >> estaActiva [
    ^ estado = #activa
]

{ #category : 'testing' }
Partida >> estaGanada [
    ^ estado = #victoria
]

{ #category : 'testing' }
Partida >> estaPerdida [
    ^ estado = #derrota
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
    tablero := Tablero filas: unaCantidadDeFilas columnas: unaCantidadDeColumnas.
    unaPosicion esPosicion
        ifFalse: [ self error: 'La posicion inicial debe ser una Posicion' ].
    (tablero contiene: unaPosicion)
        ifFalse: [ self error: 'La posicion inicial esta fuera del tablero' ].
    posicionInicial := Posicion fila: unaPosicion fila columna: unaPosicion columna.
    gato := Gato en: posicionInicial.
    tablero ocupar: posicionInicial.
    movimientos := 0.
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
    self estaActiva ifFalse: [ ^ self ].
    unaDireccion esDireccion
        ifFalse: [ self error: 'Se necesita una direccion de movimiento' ].
    "Una accion que no desplaza al gato no es un movimiento: no se cuenta"
    (self puedeMoverseEn: unaDireccion) ifFalse: [ ^ self ].
    siguiente := unaDireccion posicionSiguienteA: gato cabeza.
    [ tablero estaDisponible: siguiente ] whileTrue: [
        tablero ocupar: siguiente.
        gato avanzarA: siguiente enDireccion: unaDireccion.
        siguiente := unaDireccion posicionSiguienteA: gato cabeza ].
    movimientos := movimientos + 1.
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

{ #category : 'copying' }
Partida >> postCopy [
    super postCopy.
    tablero := tablero copy.
    gato := gato copy
]

{ #category : 'testing' }
Partida >> puedeMoverseEn: unaDireccion [
    unaDireccion esDireccion ifFalse: [ ^ false ].
    ^ tablero estaDisponible: (unaDireccion posicionSiguienteA: gato cabeza)
]

{ #category : 'changing state' }
Partida >> reiniciar [
    tablero reiniciar.
    gato reiniciarEn: posicionInicial.
    tablero ocupar: posicionInicial.
    movimientos := 0.
    estado := #activa.
    self actualizarEstado.
    ^ self
]

{ #category : 'testing' }
Partida >> tieneMovimientosPosibles [
    ^ Direccion todas anySatisfy: [ :direccion |
        self puedeMoverseEn: direccion ]
]
