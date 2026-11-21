"
Verifica que los mapas de Nivel esten bien formados y que cada nivel se pueda ganar con su solucion.
"
Class {
	#name : 'NivelTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'support' }
NivelTest >> direccionPara: unSimbolo [
    unSimbolo = #arriba ifTrue: [ ^ (Smalltalk globals at: #Arriba) new ].
    unSimbolo = #abajo ifTrue: [ ^ (Smalltalk globals at: #Abajo) new ].
    unSimbolo = #izquierda ifTrue: [ ^ (Smalltalk globals at: #Izquierda) new ].
    ^ (Smalltalk globals at: #Derecha) new
]

{ #category : 'support' }
NivelTest >> niveles [
    ^ Nivel todos
]

{ #category : 'tests' }
NivelTest >> testCadaMapaEsRectangularYTieneUnSoloInicio [
    self niveles do: [ :nivel |
        nivel mapa do: [ :fila |
            self assert: fila size = nivel columnas ].
        self assert: (nivel mapa inject: 0 into: [ :suma :fila | suma + (fila occurrencesOf: $I) ]) = 1 ]
]

{ #category : 'tests' }
NivelTest >> testCadaNivelSePuedeGanarConSuSolucion [
    self niveles do: [ :nivel | | partida |
        partida := Partida deNivel: nivel.
        nivel solucion do: [ :simbolo |
            partida moverEn: (Direccion desdeSimbolo: simbolo) ].
        self assert: partida estaGanada description: 'Nivel ', nivel numero asString ]
]

{ #category : 'tests' }
NivelTest >> testHayAlMenosDiezNiveles [
    self assert: self niveles size >= 10
]
