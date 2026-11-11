"
Especializa Direccion para avanzar una fila hacia abajo.
"
Class {
	#name : 'Abajo',
	#superclass : 'Direccion',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'movement' }
Abajo >> desplazamiento [
    ^ (Smalltalk globals at: #Posicion) fila: 1 columna: 0
]
