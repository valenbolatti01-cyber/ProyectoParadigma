"
Abstraccion de una direccion ortogonal. Define como calcular la posicion siguiente y delega en subclases desplazamiento, orientacion y sprite de cabeza.
"
Class {
	#name : 'Direccion',
	#superclass : 'Object',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'instance creation' }
Direccion class >> desdeSimbolo: unSimbolo [
    | mapa clase |
    mapa := {
        #arriba -> Arriba.
        #abajo -> Abajo.
        #izquierda -> Izquierda.
        #derecha -> Derecha } asDictionary.
    clase := mapa at: unSimbolo ifAbsent: [
        self error: 'Direccion desconocida: ', unSimbolo asString ].
    ^ clase new
]

{ #category : 'instance creation' }
Direccion class >> todas [
    ^ { Arriba new. Abajo new. Derecha new. Izquierda new }
]

{ #category : 'movement' }
Direccion >> desplazamiento [
    self subclassResponsibility
]

{ #category : 'testing' }
Direccion >> esDireccion [
    ^ true
]

{ #category : 'testing' }
Direccion >> esVertical [
    self subclassResponsibility
]

{ #category : 'movement' }
Direccion >> posicionSiguienteA: unaPosicion [
    ^ unaPosicion + self desplazamiento
]

{ #category : 'skins' }
Direccion >> spriteDeSkin: unaSkin [
    self subclassResponsibility
]
