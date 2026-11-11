"
Especializa Direccion para avanzar una fila hacia arriba.
"
Class {
	#name : 'Arriba',
	#superclass : 'Direccion',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'movement' }
Arriba >> desplazamiento [
    ^ (Smalltalk globals at: #Posicion) fila: -1 columna: 0
]
