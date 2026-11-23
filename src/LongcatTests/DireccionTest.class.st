"
Verifica el desplazamiento polimorfico, orientacion y despacho de sprites de las cuatro direcciones.
"
Class {
	#name : 'DireccionTest',
	#superclass : 'TestCase',
	#category : 'LongcatTests',
	#package : 'LongcatTests'
}

{ #category : 'tests - movement' }
DireccionTest >> testCadaDireccionCalculaLaPosicionSiguiente [
    | origen |
    origen := Posicion fila: 3 columna: 4.
    self assert: (Arriba new posicionSiguienteA: origen) = (Posicion fila: 2 columna: 4).
    self assert: (Abajo new posicionSiguienteA: origen) = (Posicion fila: 4 columna: 4).
    self assert: (Derecha new posicionSiguienteA: origen) = (Posicion fila: 3 columna: 5).
    self assert: (Izquierda new posicionSiguienteA: origen) = (Posicion fila: 3 columna: 3)
]

{ #category : 'tests - polymorphism' }
DireccionTest >> testCreacionDesdeSimbolo [
    self assert: (Direccion desdeSimbolo: #arriba) class = Arriba.
    self assert: (Direccion desdeSimbolo: #abajo) class = Abajo.
    self assert: (Direccion desdeSimbolo: #izquierda) class = Izquierda.
    self assert: (Direccion desdeSimbolo: #derecha) class = Derecha.
    self should: [ Direccion desdeSimbolo: #diagonal ] raise: Error
]

{ #category : 'tests - movement' }
DireccionTest >> testHayCuatroDirecciones [
    self assert: Direccion todas size = 4
]

{ #category : 'tests - polymorphism' }
DireccionTest >> testOrientacionPolimorfica [
    self assert: Arriba new esVertical.
    self assert: Abajo new esVertical.
    self deny: Derecha new esVertical.
    self deny: Izquierda new esVertical
]
