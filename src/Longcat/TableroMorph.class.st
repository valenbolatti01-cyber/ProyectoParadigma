"
Dibuja el tablero completo en un solo morph: las casillas pegadas, sin separacion, y el cuerpo del gato como un tubo continuo (contorno blanco, contorno negro, relleno naranja y rayas), con el sprite de la cabeza encima.
Cada segmento pinta un circulo en el centro de su casilla y un brazo hacia el segmento anterior y hacia el siguiente; asi las rectas y las curvas salen solas y los segmentos se tocan.
"
Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'cabezas',
		'tamCelda',
		'borde'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
TableroMorph class >> partida: unaPartida sprites: unosSprites [
	^ self new setPartida: unaPartida sprites: unosSprites

]

{ #category : 'private - drawing' }
TableroMorph >> brazoEn: aCanvas origen: unOrigen desde: unaCelda hacia: unVecino margen: unMargen grosor: unGrosor color: unColor [
	"Pinta el tramo que va desde el centro de unaCelda hasta el borde que comparte con unVecino."
	| mitad deltaFila deltaColumna rectangulo |
	mitad := tamCelda // 2.
	deltaFila := unVecino fila - unaCelda fila.
	deltaColumna := unVecino columna - unaCelda columna.
	deltaColumna = 1 ifTrue: [
		rectangulo := (unOrigen + (mitad @ unMargen)) extent: (tamCelda - mitad) @ unGrosor ].
	deltaColumna = -1 ifTrue: [
		rectangulo := (unOrigen + (0 @ unMargen)) extent: mitad @ unGrosor ].
	deltaFila = 1 ifTrue: [
		rectangulo := (unOrigen + (unMargen @ mitad)) extent: unGrosor @ (tamCelda - mitad) ].
	deltaFila = -1 ifTrue: [
		rectangulo := (unOrigen + (unMargen @ 0)) extent: unGrosor @ mitad ].
	rectangulo ifNotNil: [ aCanvas fillRectangle: rectangulo color: unColor ].
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> colorDe: unaPosicion ocupadas: unasPosiciones [
	"Debajo del gato va un verde suave y parejo (antes: cabeza amarilla y Color green)"
	(partida casillaBloqueadaEn: unaPosicion) ifTrue: [ ^ Color darkGray ].
	(unasPosiciones includes: unaPosicion) ifTrue: [ ^ Color r: 61 g: 181 b: 74 range: 255 ].
	^ Color white

]

{ #category : 'private - drawing' }
TableroMorph >> colorPelaje [
	^ Color r: 233 g: 154 b: 69 range: 255

]

{ #category : 'private - drawing' }
TableroMorph >> colorRayas [
	^ Color r: 196 g: 110 b: 40 range: 255

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCabezaEn: aCanvas [
	| segmentos cabeza cuello clave forma centro |
	segmentos := partida posicionesOcupadas.
	cabeza := segmentos first.
	clave := #cabezaAbajo.
	segmentos size > 1 ifTrue: [
		cuello := segmentos at: 2.
		cabeza fila < cuello fila ifTrue: [ clave := #cabezaArriba ].
		cabeza fila > cuello fila ifTrue: [ clave := #cabezaAbajo ].
		cabeza columna > cuello columna ifTrue: [ clave := #cabezaDerecha ].
		cabeza columna < cuello columna ifTrue: [ clave := #cabezaIzquierda ] ].
	forma := cabezas at: clave.
	centro := (self origenDe: cabeza) + (tamCelda // 2).
	aCanvas translucentImage: forma at: centro - (forma extent // 2).
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCasillasEn: aCanvas [
	| ocupadas posicion casilla |
	ocupadas := partida posicionesOcupadas.
	1 to: partida filas do: [ :fila |
		1 to: partida columnas do: [ :columna |
			posicion := (Smalltalk globals at: #Posicion) fila: fila columna: columna.
			casilla := (self origenDe: posicion) extent: tamCelda @ tamCelda.
			aCanvas fillRectangle: casilla color: (self colorDe: posicion ocupadas: ocupadas).
			"Solo las casillas libres o bloqueadas llevan una linea suave; debajo del gato no hay cortes"
			(ocupadas includes: posicion) ifFalse: [
				aCanvas frameRectangle: casilla width: 1 color: Color veryLightGray ] ] ].
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCuerpoEn: aCanvas color: unColor extra: unExtra [
	"Pinta la silueta completa del gato con un grosor dado. Se llama varias veces, de la mas gruesa a la mas fina, para que el contorno quede solo por fuera."
	| segmentos grosor margen origen |
	segmentos := partida posicionesOcupadas.
	grosor := self grosor + unExtra.
	margen := (tamCelda - grosor) // 2.
	segmentos withIndexDo: [ :celda :indice |
		origen := self origenDe: celda.
		aCanvas fillOval: ((origen + margen) extent: grosor @ grosor) color: unColor.
		indice > 1 ifTrue: [
			self brazoEn: aCanvas origen: origen desde: celda hacia: (segmentos at: indice - 1)
				margen: margen grosor: grosor color: unColor ].
		indice < segmentos size ifTrue: [
			self brazoEn: aCanvas origen: origen desde: celda hacia: (segmentos at: indice + 1)
				margen: margen grosor: grosor color: unColor ] ].
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarRayasEn: aCanvas [
	"Dos rayitas atigradas por segmento, cruzadas respecto al sentido del cuerpo."
	| segmentos margen largo mitad celda previo origen |
	segmentos := partida posicionesOcupadas.
	segmentos size < 2 ifTrue: [ ^ self ].
	margen := (tamCelda - self grosor) // 2.
	largo := self grosor * 2 // 5.
	mitad := tamCelda // 2.
	2 to: segmentos size do: [ :indice |
		celda := segmentos at: indice.
		previo := segmentos at: indice - 1.
		origen := self origenDe: celda.
		celda fila = previo fila
			ifTrue: [
				#(-6 3) do: [ :desvio |
					aCanvas
						fillRectangle: ((origen + ((mitad + desvio) @ margen)) extent: 3 @ largo)
						color: self colorRayas ] ]
			ifFalse: [
				#(-6 3) do: [ :desvio |
					aCanvas
						fillRectangle: ((origen + (margen @ (mitad + desvio))) extent: largo @ 3)
						color: self colorRayas ] ] ].
	^ self

]

{ #category : 'drawing' }
TableroMorph >> drawOn: aCanvas [
	partida ifNil: [ ^ super drawOn: aCanvas ].
	"Marco y fondo de una sola vez"
	aCanvas fillRectangle: self bounds color: Color white.
	self dibujarCasillasEn: aCanvas.
	"El cuerpo se pinta tres veces: contorno blanco, contorno negro y relleno"
	self dibujarCuerpoEn: aCanvas color: Color white extra: 8.
	self dibujarCuerpoEn: aCanvas color: Color black extra: 4.
	self dibujarCuerpoEn: aCanvas color: self colorPelaje extra: 0.
	self dibujarRayasEn: aCanvas.
	self dibujarCabezaEn: aCanvas

]

{ #category : 'private - drawing' }
TableroMorph >> grosor [
	"Ancho del relleno naranja del cuerpo"
	^ 24

]

{ #category : 'initialization' }
TableroMorph >> initialize [
	super initialize.
	tamCelda := 36.
	borde := 4.
	cabezas := Dictionary new.
	self color: Color white.
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> origenDe: unaPosicion [
	"Esquina superior izquierda de la casilla en pantalla"
	^ self position + borde
		+ (((unaPosicion columna - 1) * tamCelda) @ ((unaPosicion fila - 1) * tamCelda))

]

{ #category : 'initialization' }
TableroMorph >> setPartida: unaPartida sprites: unosSprites [
	| tamano |
	partida := unaPartida.
	"La cabeza se escala una sola vez, un poco mas grande que la casilla"
	tamano := tamCelda + 4.
	#(#cabezaArriba #cabezaAbajo #cabezaDerecha #cabezaIzquierda) do: [ :clave |
		cabezas at: clave put: ((unosSprites at: clave) scaledToSize: tamano @ tamano) ].
	self extent: ((partida columnas * tamCelda) + (2 * borde)) @ ((partida filas * tamCelda) + (2 * borde)).
	^ self

]
