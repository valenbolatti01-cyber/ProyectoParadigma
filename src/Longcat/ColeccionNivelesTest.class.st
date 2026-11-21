"
Verifica el polimorfismo y configuracion de los paquetes de niveles normales y tematicos.
"
Class {
	#name : 'ColeccionNivelesTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'tests - extensibility' }
ColeccionNivelesTest >> testColeccionesPersonalizadasTienenIdentidadYColoresPropios [
    | personalizadas nombres |
    personalizadas := ColeccionNiveles personalizadas.
    self assert: personalizadas size = 3.
    nombres := personalizadas collect: [ :c | c nombre ].
    self assert: (nombres includes: 'Minecraft').
    self assert: (nombres includes: 'Pokémon').
    self assert: (nombres includes: 'Dragon Ball')
]

{ #category : 'tests - extensibility' }
ColeccionNivelesTest >> testColeccionesPersonalizadasTienenNombresPropios [
    | personalizadas nombres |
    personalizadas := ColeccionNiveles personalizadas.
    self assert: personalizadas size = 3.
    nombres := personalizadas collect: [ :c | c nombre ].
    self assert: (nombres includes: 'Minecraft').
    self assert: (nombres includes: 'Pokémon').
    self assert: (nombres includes: 'Dragon Ball')
]

{ #category : 'tests - levels' }
ColeccionNivelesTest >> testNivelesNormalesEstaDisponibleYProveeMapas [
    | coleccion |
    coleccion := ColeccionNiveles normales.
    self assert: coleccion estaDisponible.
    self assert: coleccion cantidad >= 10.
    self assert: (coleccion nivel: 1) numero = 1
]
