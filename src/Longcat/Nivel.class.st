"
Describe un nivel de Longcat: su numero, el dibujo del mapa (# pared, . libre, I inicio del gato) y una solucion conocida que prueba que se puede ganar.
"
Class {
	#name : 'Nivel',
	#superclass : 'Object',
	#instVars : [
		'numero',
		'mapa',
		'solucion'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'levels' }
Nivel class >> cantidad [
    ^ self todos size
]

{ #category : 'levels' }
Nivel class >> nivel: unNumero [
    ^ self todos at: unNumero
]

{ #category : 'instance creation' }
Nivel class >> numero: unNumero mapa: unasFilas solucion: unaSolucion [
    ^ self basicNew setNumero: unNumero mapa: unasFilas solucion: unaSolucion
]

{ #category : 'levels' }
Nivel class >> todos [
    ^ NivelesNormales new niveles
]

{ #category : 'accessing' }
Nivel >> bloqueos [
    | lista |
    lista := OrderedCollection new.
    1 to: self filas do: [ :fila |
        1 to: self columnas do: [ :columna |
            ((mapa at: fila) at: columna) = $# ifTrue: [
                lista add: (Posicion fila: fila columna: columna) ] ] ].
    ^ lista
]

{ #category : 'accessing' }
Nivel >> cantidadCasillasDisponibles [
    ^ (self filas * self columnas) - self bloqueos size
]

{ #category : 'accessing' }
Nivel >> columnas [
    ^ mapa first size
]

{ #category : 'scoring' }
Nivel >> estrellasPara: unaCantidadDeMovimientos [
    ^ self rango estrellasPara: unaCantidadDeMovimientos
]

{ #category : 'accessing' }
Nivel >> filas [
    ^ mapa size
]

{ #category : 'accessing' }
Nivel >> inicio [
    1 to: self filas do: [ :fila |
        1 to: self columnas do: [ :columna |
            ((mapa at: fila) at: columna) = $I ifTrue: [
                ^ Posicion fila: fila columna: columna ] ] ].
    ^ self error: 'El mapa del nivel no tiene inicio (I)'
]

{ #category : 'accessing' }
Nivel >> mapa [
    ^ mapa
]

{ #category : 'accessing' }
Nivel >> numero [
    ^ numero
]

{ #category : 'scoring' }
Nivel >> rango [
    "Los niveles comunes no tienen movimientos de referencia: nunca dan estrellas"
    ^ SinRangoMovimientos new
]

{ #category : 'initialization' }
Nivel >> setNumero: unNumero mapa: unasFilas solucion: unaSolucion [
    numero := unNumero.
    mapa := unasFilas.
    solucion := unaSolucion.
    ^ self
]

{ #category : 'accessing' }
Nivel >> solucion [
    ^ solucion
]
