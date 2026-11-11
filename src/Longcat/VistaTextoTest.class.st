"
Verifica que la vista de texto distinga cabeza, cuerpo, espacio libre y estado de la partida.
"
Class {
	#name : 'VistaTextoTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
VistaTextoTest >> setUp [
    super setUp.
    partida := (Smalltalk globals at: #Partida) deFilas: 2 columnas: 3 inicio: ((Smalltalk globals at: #Posicion) fila: 1 columna: 1)
]

{ #category : 'tests - rendering' }
VistaTextoTest >> testRepresentaCabezaEspaciosYEstado [
    | texto |
    texto := (Smalltalk globals at: #VistaTexto) representar: partida.
    self assert: (texto includesSubstring: 'G . .').
    self assert: (texto includesSubstring: 'Estado: activa')
]

{ #category : 'tests - rendering' }
VistaTextoTest >> testRepresentaElCuerpoLuegoDeAvanzar [
    | texto |
    partida moverEn: ((Smalltalk globals at: #Derecha) new).
    texto := (Smalltalk globals at: #VistaTexto) representar: partida.
    self assert: (texto includesSubstring: 'o o G')
]
