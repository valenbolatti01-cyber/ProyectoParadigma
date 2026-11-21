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
    ^ Posicion fila: 1 columna: 0
]

{ #category : 'testing' }
Abajo >> esVertical [
    ^ true
]

{ #category : 'skins' }
Abajo >> spriteDeSkin: unaSkin [
    ^ unaSkin cabezaAbajo
]
