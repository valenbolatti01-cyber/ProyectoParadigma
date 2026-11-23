"
Especializa Direccion para avanzar una columna hacia la izquierda.
"
Class {
	#name : 'Izquierda',
	#superclass : 'Direccion',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'movement' }
Izquierda >> desplazamiento [
    ^ Posicion fila: 0 columna: -1
]

{ #category : 'testing' }
Izquierda >> esVertical [
    ^ false
]

{ #category : 'skins' }
Izquierda >> spriteDeSkin: unaSkin [
    ^ unaSkin cabezaIzquierda
]
