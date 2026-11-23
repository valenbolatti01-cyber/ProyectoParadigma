"
Especializa Direccion para avanzar una fila hacia arriba.
"
Class {
	#name : 'Arriba',
	#superclass : 'Direccion',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'movement' }
Arriba >> desplazamiento [
    ^ Posicion fila: -1 columna: 0
]

{ #category : 'testing' }
Arriba >> esVertical [
    ^ true
]

{ #category : 'skins' }
Arriba >> spriteDeSkin: unaSkin [
    ^ unaSkin cabezaArriba
]
