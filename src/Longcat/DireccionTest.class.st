"
Verifica el desplazamiento polimórfico de las cuatro direcciones del tablero.
"
Class {
	#name : 'DireccionTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'tests - movement' }
DireccionTest >> testCadaDireccionCalculaLaPosicionSiguiente [
    | origen |
    origen := (Smalltalk globals at: #Posicion) fila: 3 columna: 4.
    self assert: ((Smalltalk globals at: #Arriba) new posicionSiguienteA: origen) = ((Smalltalk globals at: #Posicion) fila: 2 columna: 4).
    self assert: ((Smalltalk globals at: #Abajo) new posicionSiguienteA: origen) = ((Smalltalk globals at: #Posicion) fila: 4 columna: 4).
    self assert: ((Smalltalk globals at: #Derecha) new posicionSiguienteA: origen) = ((Smalltalk globals at: #Posicion) fila: 3 columna: 5).
    self assert: ((Smalltalk globals at: #Izquierda) new posicionSiguienteA: origen) = ((Smalltalk globals at: #Posicion) fila: 3 columna: 3)
]

{ #category : 'tests - movement' }
DireccionTest >> testHayCuatroDirecciones [
    self assert: (Smalltalk globals at: #Direccion) todas size = 4
]
