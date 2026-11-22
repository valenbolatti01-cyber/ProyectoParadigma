"
Objeto de valor del dominio: rango de movimientos de referencia de un nivel (minimo y maximo de soluciones reales) y los limites que determinan las estrellas: tres estrellas hasta limiteTresEstrellas, dos hasta limiteDosEstrellas y una estrella hasta el maximo.
"
Class {
	#name : 'RangoMovimientos',
	#superclass : 'Object',
	#instVars : [
		'minimo',
		'maximo',
		'limiteTresEstrellas',
		'limiteDosEstrellas'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
RangoMovimientos class >> minimo: unMinimo maximo: unMaximo [
    "Reparte los movimientos posibles en tres tramos parejos; si sobran, los tramos de mas estrellas reciben uno extra (8 a 15 -> 8-10, 11-13, 14-15)"
    | cantidad base resto tramoTres tramoDos |
    cantidad := unMaximo - unMinimo + 1.
    base := cantidad // 3.
    resto := cantidad \\ 3.
    tramoTres := base + (resto min: 1).
    tramoDos := base + ((resto - 1) max: 0).
    ^ self
        minimo: unMinimo
        maximo: unMaximo
        tresEstrellasHasta: unMinimo + tramoTres - 1
        dosEstrellasHasta: unMinimo + tramoTres + tramoDos - 1
]

{ #category : 'instance creation' }
RangoMovimientos class >> minimo: unMinimo maximo: unMaximo tresEstrellasHasta: unLimiteTres dosEstrellasHasta: unLimiteDos [
    ^ self basicNew
        inicializarMinimo: unMinimo
        maximo: unMaximo
        tresEstrellasHasta: unLimiteTres
        dosEstrellasHasta: unLimiteDos
]

{ #category : 'accessing' }
RangoMovimientos >> cantidadDeEstrellas [
    ^ 3
]

{ #category : 'testing' }
RangoMovimientos >> estaDefinido [
    ^ true
]

{ #category : 'accessing' }
RangoMovimientos >> estrellasPara: unaCantidadDeMovimientos [
    "Cantidad de estrellas que corresponde a completar el tablero con esa cantidad de movimientos"
    ^ (self umbrales
        detect: [ :umbral | unaCantidadDeMovimientos <= umbral value ]
        ifNone: [ 1 -> nil ]) key
]

{ #category : 'initialization' }
RangoMovimientos >> inicializarMinimo: unMinimo maximo: unMaximo tresEstrellasHasta: unLimiteTres dosEstrellasHasta: unLimiteDos [
    ((unMinimo <= unLimiteTres) and: [ (unLimiteTres < unLimiteDos) and: [ unLimiteDos < unMaximo ] ])
        ifFalse: [ self error: 'Debe cumplirse minimo <= tres estrellas < dos estrellas < maximo' ].
    minimo := unMinimo.
    maximo := unMaximo.
    limiteTresEstrellas := unLimiteTres.
    limiteDosEstrellas := unLimiteDos.
    ^ self
]

{ #category : 'accessing' }
RangoMovimientos >> limiteDosEstrellas [
    ^ limiteDosEstrellas
]

{ #category : 'accessing' }
RangoMovimientos >> limiteSuperiorDeEstrellas: unaCantidadDeEstrellas [
    "Mayor cantidad de movimientos con la que todavia se obtiene esa cantidad de estrellas"
    ^ ((self umbrales , { 1 -> maximo })
        detect: [ :umbral | umbral key = unaCantidadDeEstrellas ]
        ifNone: [ self error: 'Cantidad de estrellas inexistente' ]) value
]

{ #category : 'accessing' }
RangoMovimientos >> limiteTresEstrellas [
    ^ limiteTresEstrellas
]

{ #category : 'accessing' }
RangoMovimientos >> maximo [
    ^ maximo
]

{ #category : 'accessing' }
RangoMovimientos >> minimo [
    ^ minimo
]

{ #category : 'private' }
RangoMovimientos >> umbrales [
    "Pares estrellas -> movimientos maximos, de la mejor calificacion a la peor"
    ^ { 3 -> limiteTresEstrellas. 2 -> limiteDosEstrellas }
]
