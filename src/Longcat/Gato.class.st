"
Representa al personaje mediante una secuencia ordenada de Posicion. La primera es la cabeza; cada avance agrega una posicion y nunca elimina segmentos.
"
Class {
	#name : 'Gato',
	#superclass : 'Object',
	#instVars : [
		'segmentos',
		'direccionUltima'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Gato class >> en: unaPosicion [
    ^ self basicNew inicializarEn: unaPosicion
]

{ #category : 'movement' }
Gato >> avanzarA: unaPosicion enDireccion: unaDireccion [
    (unaDireccion posicionSiguienteA: self cabeza) = unaPosicion
        ifFalse: [ self error: 'El nuevo segmento debe ser adyacente en esa direccion' ].
    (segmentos includes: unaPosicion)
        ifTrue: [ self error: 'El gato no puede ocupar dos veces una posicion' ].
      segmentos addFirst: unaPosicion.
    direccionUltima := unaDireccion.
    ^ self
]

{ #category : 'accessing' }
Gato >> cabeza [
    ^ segmentos first
]

{ #category : 'accessing' }
Gato >> direccionUltima [
    ^ direccionUltima
]

{ #category : 'initialization' }
Gato >> inicializarEn: unaPosicion [
    (unaPosicion isKindOf: (Smalltalk globals at: #Posicion))
        ifFalse: [ self error: 'El gato necesita una posicion inicial' ].
    segmentos := OrderedCollection with: unaPosicion.
    direccionUltima := nil.
    ^ self
]

{ #category : 'accessing' }
Gato >> longitud [
    ^ segmentos size
]

{ #category : 'accessing' }
Gato >> posicionesOcupadas [
    ^ segmentos asArray
]

{ #category : 'changing state' }
Gato >> reiniciarEn: unaPosicion [
    (unaPosicion isKindOf: (Smalltalk globals at: #Posicion))
        ifFalse: [ self error: 'El gato necesita una posicion inicial' ].
    segmentos := OrderedCollection with: unaPosicion.
    direccionUltima := nil.
    ^ self
]
