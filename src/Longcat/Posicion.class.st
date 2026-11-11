"
Representa las casillassss del tablero mediante filas y columnas.”
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

{ #category : 'as yet unclassified' }
Posicion class >> fila: unaFila columna: unaColumna [
    ^ self new setFila: unaFila columna: unaColumna
]

{ #category : 'comparing' }
Posicion >> = otra [
    ^ self class = otra class and: [ fila = otra fila and: [ columna = otra columna ] ]
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
Posicion >> setFila: unaFila columna: unaColumna [
    fila := unaFila.
    columna := unaColumna
]
