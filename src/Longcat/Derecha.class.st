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
    ^ Posicion fila: 0 columna: 1
]

{ #category : 'testing' }
Derecha >> esVertical [
    ^ false
]

{ #category : 'skins' }
Derecha >> spriteDeSkin: unaSkin [
    ^ unaSkin cabezaDerecha
]
