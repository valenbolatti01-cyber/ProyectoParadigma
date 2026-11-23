"
Objeto nulo de RangoMovimientos para los niveles que no tienen movimientos de referencia (por ejemplo los niveles normales): nunca otorga estrellas.
"
Class {
	#name : 'SinRangoMovimientos',
	#superclass : 'RangoMovimientos',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'accessing' }
SinRangoMovimientos >> cantidadDeEstrellas [
    ^ 0
]

{ #category : 'testing' }
SinRangoMovimientos >> estaDefinido [
    ^ false
]

{ #category : 'accessing' }
SinRangoMovimientos >> estrellasPara: unaCantidadDeMovimientos [
    ^ 0
]
