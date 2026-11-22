"
Verifica los rangos de movimientos y la asignacion de estrellas (tres, dos o una segun los movimientos realizados).
"
Class {
	#name : 'RangoMovimientosTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'tests - stars' }
RangoMovimientosTest >> testElEjemploDeOchoAQuinceSeReparteEnTresTramos [
    | rango |
    rango := RangoMovimientos minimo: 8 maximo: 15.
    self assert: rango limiteTresEstrellas = 10.
    self assert: rango limiteDosEstrellas = 13.
    #(8 9 10) do: [ :movimientos | self assert: (rango estrellasPara: movimientos) = 3 ].
    #(11 12 13) do: [ :movimientos | self assert: (rango estrellasPara: movimientos) = 2 ].
    #(14 15) do: [ :movimientos | self assert: (rango estrellasPara: movimientos) = 1 ]
]

{ #category : 'tests - stars' }
RangoMovimientosTest >> testElRepartoSiempreDejaAlMenosUnMovimientoPorEstrella [
    #(3 4 5 6 7 8 9 10 11) do: [ :cantidad | | rango |
        rango := RangoMovimientos minimo: 10 maximo: 10 + cantidad - 1.
        self assert: (rango estrellasPara: 10) = 3.
        self assert: (rango estrellasPara: rango maximo) = 1.
        self assert: rango limiteTresEstrellas < rango limiteDosEstrellas.
        self assert: rango limiteDosEstrellas < rango maximo ]
]

{ #category : 'tests - stars' }
RangoMovimientosTest >> testLosLimitesPuedenConfigurarseParaCadaNivel [
    | rango |
    rango := RangoMovimientos minimo: 8 maximo: 15 tresEstrellasHasta: 9 dosEstrellasHasta: 12.
    self assert: (rango estrellasPara: 9) = 3.
    self assert: (rango estrellasPara: 10) = 2.
    self assert: (rango estrellasPara: 12) = 2.
    self assert: (rango estrellasPara: 13) = 1
]

{ #category : 'tests - stars' }
RangoMovimientosTest >> testLosLimitesSuperioresPorEstrellas [
    | rango |
    rango := RangoMovimientos minimo: 8 maximo: 15.
    self assert: (rango limiteSuperiorDeEstrellas: 3) = 10.
    self assert: (rango limiteSuperiorDeEstrellas: 2) = 13.
    self assert: (rango limiteSuperiorDeEstrellas: 1) = 15
]

{ #category : 'tests - validation' }
RangoMovimientosTest >> testRechazaLimitesIncoherentes [
    self should: [ RangoMovimientos minimo: 8 maximo: 15 tresEstrellasHasta: 12 dosEstrellasHasta: 10 ] raise: Error.
    self should: [ RangoMovimientos minimo: 8 maximo: 15 tresEstrellasHasta: 7 dosEstrellasHasta: 10 ] raise: Error.
    self should: [ RangoMovimientos minimo: 8 maximo: 15 tresEstrellasHasta: 9 dosEstrellasHasta: 15 ] raise: Error.
    self should: [ RangoMovimientos minimo: 5 maximo: 6 ] raise: Error
]

{ #category : 'tests - null object' }
RangoMovimientosTest >> testSinRangoNuncaOtorgaEstrellas [
    | sinRango |
    sinRango := SinRangoMovimientos new.
    self deny: sinRango estaDefinido.
    self assert: sinRango cantidadDeEstrellas = 0.
    self assert: (sinRango estrellasPara: 1) = 0
]
