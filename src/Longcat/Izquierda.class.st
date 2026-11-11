"
Especializa Direccion para avanzar una columna hacia la izquierda.
"
Class {
	#name : 'Izquierda',
	#superclass : 'Direccion',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'movement' }
Izquierda >> desplazamiento [
    ^ (Smalltalk globals at: #Posicion) fila: 0 columna: -1
]
