"
Paquete tematico de niveles de Pokemon. Listo para incorporar mapas personalizados.
"
Class {
	#name : 'NivelesPokemon',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'levels' }
NivelesPokemon >> niveles [
    "Agregar aqui los objetos Nivel tematicos de Pokemon."
    ^ OrderedCollection new
]

{ #category : 'accessing' }
NivelesPokemon >> nombre [
    ^ 'Pokémon'
]
