"
Verifica el analizador exhaustivo con tableros pequenos y que los 30 niveles personalizados (3 mundos x 10) cumplan los criterios de diseno: soluciones reales, rangos de movimientos coherentes con las soluciones y brecha suficiente entre minimo y maximo.
"
Class {
	#name : 'AnalizadorDeNivelTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'support' }
AnalizadorDeNivelTest >> jugar: unaSolucion en: unNivel [
    | partida |
    partida := Partida deNivel: unNivel.
    unaSolucion do: [ :simbolo |
        partida moverEn: (Direccion desdeSimbolo: simbolo) ].
    ^ partida
]

{ #category : 'support' }
AnalizadorDeNivelTest >> nivelesPersonalizados [
    ^ ColeccionNiveles personalizadas
        inject: OrderedCollection new
        into: [ :todos :coleccion | todos addAll: coleccion niveles; yourself ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testCadaMundoTieneDiezNiveles [
    ColeccionNiveles personalizadas do: [ :coleccion |
        self assert: coleccion cantidad = 10 description: coleccion nombre ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testElRangoDeCadaNivelCoincideConLasSolucionesRealesDelTablero [
    ColeccionNiveles personalizadas do: [ :coleccion |
        coleccion niveles do: [ :nivel | | analizador descripcion |
            descripcion := coleccion nombre, ' nivel ', nivel numero asString.
            analizador := AnalizadorDeNivel sobre: nivel.
            self assert: analizador sePuedeGanar description: descripcion.
            self assert: analizador movimientosMinimos = nivel rango minimo description: descripcion.
            self assert: analizador movimientosMaximos = nivel rango maximo description: descripcion ] ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testHayBrechaSuficienteEntreMinimoYMaximo [
    "Se evitan niveles con muy poco margen para diferenciar las calificaciones"
    self nivelesPersonalizados do: [ :nivel |
        self
            assert: nivel rango maximo - nivel rango minimo >= 3
            description: 'Nivel ', nivel numero asString ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testLaDificultadNoDecreceDentroDeCadaMundo [
    "Del nivel 1 (el mas facil) al 10 (el mas dificil): cada nivel exige al menos tantos movimientos minimos como el anterior"
    ColeccionNiveles personalizadas do: [ :coleccion | | anterior |
        anterior := 0.
        coleccion niveles do: [ :nivel |
            self
                assert: nivel rango minimo >= anterior
                description: coleccion nombre, ' nivel ', nivel numero asString.
            anterior := nivel rango minimo ] ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testLasEstrellasSeAsignanSegunLosMovimientosRealizados [
    self nivelesPersonalizados do: [ :nivel |
        self assert: (nivel estrellasPara: nivel rango minimo) = 3.
        self assert: (nivel estrellasPara: nivel rango maximo) = 1.
        self assert: (nivel estrellasPara: nivel rango limiteTresEstrellas) = 3.
        self assert: (nivel estrellasPara: nivel rango limiteTresEstrellas + 1) = 2.
        self assert: (nivel estrellasPara: nivel rango limiteDosEstrellas) = 2.
        self assert: (nivel estrellasPara: nivel rango limiteDosEstrellas + 1) = 1 ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testLasSolucionesMinimaYMaximaGananConLaCantidadDeMovimientosDeclarada [
    ColeccionNiveles personalizadas do: [ :coleccion |
        coleccion niveles do: [ :nivel | | minima maxima descripcion |
            descripcion := coleccion nombre, ' nivel ', nivel numero asString.
            minima := self jugar: nivel solucionMinima en: nivel.
            maxima := self jugar: nivel solucionMaxima en: nivel.
            self assert: minima estaGanada description: descripcion.
            self assert: maxima estaGanada description: descripcion.
            self assert: minima cantidadMovimientos = nivel rango minimo description: descripcion.
            self assert: maxima cantidadMovimientos = nivel rango maximo description: descripcion ] ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testLosMapasSonRectangularesConUnSoloInicio [
    self nivelesPersonalizados do: [ :nivel |
        nivel mapa do: [ :fila |
            self assert: fila size = nivel columnas ].
        self
            assert: (nivel mapa inject: 0 into: [ :suma :fila | suma + (fila occurrencesOf: $I) ]) = 1
            description: 'Nivel ', nivel numero asString ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testLosNivelesTienenCasillasDisponiblesSuficientes [
    self nivelesPersonalizados do: [ :nivel |
        self assert: nivel cantidadCasillasDisponibles >= 12 description: 'Nivel ', nivel numero asString.
        self
            assert: nivel cantidadCasillasDisponibles = (nivel filas * nivel columnas - nivel bloqueos size)
            description: 'Nivel ', nivel numero asString ]
]

{ #category : 'tests - levels' }
AnalizadorDeNivelTest >> testNoHayTablerosRepetidosEntreLosNiveles [
    | mapas |
    mapas := self nivelesPersonalizados collect: [ :nivel | nivel mapa ].
    self assert: mapas asSet size = mapas size
]

{ #category : 'tests - small boards' }
AnalizadorDeNivelTest >> testUnNivelSinSolucionNoSePuedeGanar [
    | nivel analizador |
    nivel := Nivel numero: 1 mapa: #('I.#.') solucion: #().
    analizador := AnalizadorDeNivel sobre: nivel.
    self deny: analizador sePuedeGanar.
    self assert: analizador movimientosMinimos isNil.
    self assert: analizador movimientosMaximos isNil
]

{ #category : 'tests - small boards' }
AnalizadorDeNivelTest >> testUnTableroConDosCaminosTieneMinimoYMaximoDistintos [
    | analizador |
    "En un 2x2 libre, desde una esquina: dos giros en un sentido o en el otro, siempre tres movimientos"
    analizador := AnalizadorDeNivel sobre: (Nivel numero: 1 mapa: #('I.' '..') solucion: #(#derecha #abajo #izquierda)).
    self assert: analizador movimientosMinimos = 3.
    self assert: analizador movimientosMaximos = 3
]

{ #category : 'tests - small boards' }
AnalizadorDeNivelTest >> testUnaFilaSeGanaEnUnMovimiento [
    | analizador |
    analizador := AnalizadorDeNivel sobre: (Nivel numero: 1 mapa: #('I...') solucion: #(#derecha)).
    self assert: analizador movimientosMinimos = 1.
    self assert: analizador movimientosMaximos = 1
]
