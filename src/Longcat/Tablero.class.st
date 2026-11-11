"
Compone una matriz privada de Casilla y responde consultas de límites, estados y disponibilidad. El borde se modela como una coordenada exterior bloqueada.
"
Class {
	#name : 'Tablero',
	#superclass : 'Object',
	#instVars : [
		'filas',
		'columnas',
		'casillas'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Tablero class >> filas: unaCantidadDeFilas columnas: unaCantidadDeColumnas [
    ^ self basicNew
        inicializarFilas: unaCantidadDeFilas
        columnas: unaCantidadDeColumnas
]

{ #category : 'changing state' }
Tablero >> bloquear: unaPosicion [
    (self estaDisponible: unaPosicion)
        ifFalse: [ self error: 'La posicion no esta disponible para bloquearla' ].
    (self casillaEn: unaPosicion) bloquear.
    ^ self
]

{ #category : 'accessing state' }
Tablero >> cantidadDisponibles [
    | cantidad |
    cantidad := 0.
    1 to: filas do: [ :fila |
        1 to: columnas do: [ :columna |
            (self estaDisponible: ((Smalltalk globals at: #Posicion) fila: fila columna: columna))
                ifTrue: [ cantidad := cantidad + 1 ]
        ]
    ].
    ^ cantidad
]

{ #category : 'accessing state' }
Tablero >> cantidadOcupadas [
    | cantidad |
    cantidad := 0.
    1 to: filas do: [ :fila |
        1 to: columnas do: [ :columna |
            (self estaOcupada: ((Smalltalk globals at: #Posicion) fila: fila columna: columna))
                ifTrue: [ cantidad := cantidad + 1 ]
        ]
    ].
    ^ cantidad
]

{ #category : 'private - accessing' }
Tablero >> casillaEn: unaPosicion [
    (self contiene: unaPosicion)
        ifFalse: [ self error: 'La posicion esta fuera del tablero' ].
    ^ (casillas at: unaPosicion fila) at: unaPosicion columna
]

{ #category : 'accessing' }
Tablero >> columnas [
    ^ columnas
]

{ #category : 'testing' }
Tablero >> contiene: unaPosicion [
    ^ (unaPosicion fila between: 1 and: filas)
        and: [ unaPosicion columna between: 1 and: columnas ]
]

{ #category : 'testing' }
Tablero >> estaBloqueada: unaPosicion [
    (self contiene: unaPosicion) ifFalse: [ ^ true ].
    ^ (self casillaEn: unaPosicion) estaBloqueada
]

{ #category : 'testing' }
Tablero >> estaDisponible: unaPosicion [
    ^ (self contiene: unaPosicion)
        and: [ (self casillaEn: unaPosicion) estaDisponible ]
]

{ #category : 'testing' }
Tablero >> estaOcupada: unaPosicion [
    (self contiene: unaPosicion) ifFalse: [ ^ false ].
    ^ (self casillaEn: unaPosicion) estaOcupada
]

{ #category : 'accessing state' }
Tablero >> estadoDe: unaPosicion [
    ^ (self casillaEn: unaPosicion) estado
]

{ #category : 'accessing' }
Tablero >> filas [
    ^ filas
]

{ #category : 'initialization' }
Tablero >> inicializarFilas: unaCantidadDeFilas columnas: unaCantidadDeColumnas [
    (unaCantidadDeFilas isInteger and: [ unaCantidadDeFilas > 0 ])
        ifFalse: [ self error: 'La cantidad de filas debe ser un entero positivo' ].
    (unaCantidadDeColumnas isInteger and: [ unaCantidadDeColumnas > 0 ])
        ifFalse: [ self error: 'La cantidad de columnas debe ser un entero positivo' ].
    filas := unaCantidadDeFilas.
    columnas := unaCantidadDeColumnas.
    casillas := ((1 to: filas) collect: [ :fila |
        ((1 to: columnas) collect: [ :columna | (Smalltalk globals at: #Casilla) libre ]) asArray
    ]) asArray.
    ^ self
]

{ #category : 'changing state' }
Tablero >> ocupar: unaPosicion [
    (self estaDisponible: unaPosicion)
        ifFalse: [ self error: 'La posicion no esta disponible' ].
    (self casillaEn: unaPosicion) ocupar.
    ^ self
]

{ #category : 'changing state' }
Tablero >> reiniciar [
    casillas do: [ :filaDeCasillas |
        filaDeCasillas do: [ :casilla | casilla reiniciar ]
    ].
    ^ self
]
