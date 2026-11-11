"
Representa una coordenada de fila y columna. Es un objeto de valor inmutable; puede representar una coordenada exterior al tablero para comprobar un límite.
"
Class {
	#name : 'Posicion',
	#superclass : 'Object',
	#instVars : [
		'fila',
		'columna'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Posicion class >> fila: unaFila columna: unaColumna [
    ^ self basicNew inicializarFila: unaFila columna: unaColumna
]

{ #category : 'arithmetic' }
Posicion >> + otraPosicion [
    (otraPosicion isKindOf: (Smalltalk globals at: #Posicion))
        ifFalse: [ self error: 'Solo se pueden sumar posiciones' ].
    ^ self class
        fila: fila + otraPosicion fila
        columna: columna + otraPosicion columna
]

{ #category : 'comparing' }
Posicion >> = otraPosicion [
    ^ otraPosicion class = self class
        and: [ fila = otraPosicion fila and: [ columna = otraPosicion columna ] ]
]

{ #category : 'accessing' }
Posicion >> columna [
    ^ columna
]

{ #category : 'accessing' }
Posicion >> fila [
    ^ fila
]

{ #category : 'comparing' }
Posicion >> hash [
    ^ fila hash bitXor: columna hash
]

{ #category : 'initialization' }
Posicion >> inicializarFila: unaFila columna: unaColumna [
    (unaFila isInteger and: [ unaColumna isInteger ])
        ifFalse: [ self error: 'La fila y la columna deben ser enteros' ].
    fila := unaFila.
    columna := unaColumna.
    ^ self
]

{ #category : 'printing' }
Posicion >> printOn: unFlujo [
    unFlujo
        nextPut: $(;
        print: fila;
        nextPutAll: ', ';
        print: columna;
        nextPut: $)
]

{ #category : 'initialization' }
Posicion >> setFila: unaFila columna: unaColumna [
    fila := unaFila.
    columna := unaColumna
]
