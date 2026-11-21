"
Paquete tematico de niveles de Pokemon. Listo para incorporar mapas personalizados.
"
Class {
	#name : 'NivelesPokemon',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'accessing' }
NivelesPokemon >> claveIcono [
    ^ #pokemon
]

{ #category : 'theme' }
NivelesPokemon >> colorTema [
    ^ EstiloLongcat colorRosa
]

{ #category : 'levels' }
NivelesPokemon >> niveles [
    "Agregar aqui los objetos Nivel tematicos de Pokemon."
    ^ OrderedCollection new
]

{ #category : 'accessing' }
NivelesPokemon >> nombre [
    ^ 'Pokémon'
]

{ #category : 'theme' }
NivelesPokemon >> tituloVentana [
    ^ 'pokemon.exe'
]
