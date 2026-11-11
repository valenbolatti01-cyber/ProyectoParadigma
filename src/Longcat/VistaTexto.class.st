"
Convierte una instantánea consultable de Partida en una representación textual. Mantiene la impresión separada de las reglas del juego.
"
Class {
	#name : 'VistaTexto',
	#superclass : 'Object',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'rendering' }
VistaTexto class >> representar: unaPartida [
    | posicionesOcupadas |
    posicionesOcupadas := unaPartida posicionesOcupadas.
    ^ String streamContents: [ :salida |
        1 to: unaPartida filas do: [ :fila |
            1 to: unaPartida columnas do: [ :columna |
                | posicion caracter |
                posicion := (Smalltalk globals at: #Posicion) fila: fila columna: columna.
                caracter := (posicion = unaPartida posicionCabeza)
                    ifTrue: [ $G ]
                    ifFalse: [
                        (posicionesOcupadas includes: posicion)
                            ifTrue: [ $o ]
                            ifFalse: [
                                (unaPartida casillaBloqueadaEn: posicion)
                                    ifTrue: [ $# ]
                                    ifFalse: [ $. ]
                            ]
                    ].
                salida nextPut: caracter.
                columna < unaPartida columnas
                    ifTrue: [ salida space ]
            ].
            fila < unaPartida filas ifTrue: [ salida cr ]
        ].
        salida cr; nextPutAll: 'Estado: '; nextPutAll: unaPartida estado asString
    ]
]
