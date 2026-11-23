"
Verifica que la vista de texto distinga cabeza, cuerpo, espacio libre y estado de la partida.
"
Class {
	#name : 'VistaTextoTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'LongcatTests',
	#package : 'LongcatTests'
}

{ #category : 'running' }
VistaTextoTest >> setUp [
    super setUp.
    partida := Partida deFilas: 2 columnas: 3 inicio: (Posicion fila: 1 columna: 1)
]

{ #category : 'tests - rendering' }
VistaTextoTest >> testRepresentaCabezaEspaciosYEstado [
    | texto |
    texto := VistaTexto representar: partida.
    self assert: (texto includesSubstring: 'G . .').
    self assert: (texto includesSubstring: 'Estado: activa')
]

{ #category : 'tests - rendering' }
VistaTextoTest >> testRepresentaElCuerpoLuegoDeAvanzar [
    | texto |
    partida moverEn: Derecha new.
    texto := VistaTexto representar: partida.
    self assert: (texto includesSubstring: 'o o G')
]
