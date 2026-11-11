"
Especializa Direccion para avanzar una columna hacia la derecha.
"
Class {
	#name : 'Derecha',
	#superclass : 'Direccion',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'movement' }
Derecha >> desplazamiento [
    ^ (Smalltalk globals at: #Posicion) fila: 0 columna: 1
]
