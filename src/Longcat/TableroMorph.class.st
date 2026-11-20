"
Dibuja el tablero como un monitor: marco oscuro con borde neon, barra de titulo 'longcat.exe', pantalla con codigo de fondo y lineas de scan, y un pie de monitor.
Las casillas van pegadas, sin separacion, y el cuerpo del gato es un tubo continuo (contorno blanco, contorno negro, relleno naranja y rayas) con el sprite de la cabeza encima.
Cada segmento pinta un circulo en el centro de su casilla y un brazo hacia el segmento anterior y hacia el siguiente; asi las rectas y las curvas salen solas.
"
Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'cabezas',
		'tamCelda',
		'borde',
		'barra',
		'pie'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
TableroMorph class >> partida: unaPartida sprites: unosSprites [
	^ self new setPartida: unaPartida sprites: unosSprites

]

{ #category : 'initialization' }
TableroMorph >> ajustarA: unTamano sprites: unosSprites [
    "Agranda o achica las casillas para que el monitor entre en el tamano disponible"
    | tamano |
    tamCelda := (((unTamano x - (2 * borde)) // partida columnas)
        min: ((unTamano y - (2 * borde) - barra - pie) // partida filas)).
    tamCelda := (tamCelda min: 80) max: 16.
    tamano := tamCelda + 4.
    #(#cabezaArriba #cabezaAbajo #cabezaDerecha #cabezaIzquierda) do: [ :clave |
        cabezas at: clave put: ((unosSprites at: clave) scaledToSize: tamano @ tamano) ].
    self extent: ((partida columnas * tamCelda) + (2 * borde))
        @ ((partida filas * tamCelda) + (2 * borde) + barra + pie).
    self changed.
    ^ self

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

{ #category : 'private - colors' }
TableroMorph >> colorCodigo: unNumeroDeLinea [
	"Colores de la paleta, apagados para que el codigo quede de fondo"
	| colores |
	colores := {
		Color r: 139 g: 115 b: 214 range: 255.
		Color r: 140 g: 203 b: 103 range: 255.
		Color r: 233 g: 154 b: 69 range: 255.
		Color r: 245 g: 214 b: 160 range: 255 }.
	^ (colores at: ((unNumeroDeLinea - 1) \\ colores size) + 1) mixed: 0.45 with: self colorPantalla

]

{ #category : 'private - colors' }
TableroMorph >> colorCrema [
	^ Color r: 245 g: 214 b: 160 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorMarco [
	^ Color r: 26 g: 29 b: 38 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorMorado [
	^ Color r: 139 g: 115 b: 214 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorPantalla [
	^ Color r: 16 g: 19 b: 27 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorPelaje [
	^ Color r: 233 g: 154 b: 69 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorPizarra [
	^ Color r: 52 g: 59 b: 73 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorRayas [
	^ Color r: 196 g: 110 b: 40 range: 255

]

{ #category : 'private - colors' }
TableroMorph >> colorVerde [
	^ Color r: 140 g: 203 b: 103 range: 255

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarBarraEn: aCanvas [
	"Barra de titulo de la ventana, como en un editor de codigo"
	| rectangulo fuente colores |
	rectangulo := (self position + (borde @ borde)) extent: self pantalla width @ barra.
	aCanvas fillRectangle: rectangulo color: self colorPizarra.
	colores := { self colorPelaje. self colorCrema. self colorVerde }.
	colores withIndexDo: [ :color :indice |
		aCanvas
			fillOval: ((rectangulo left + 6 + ((indice - 1) * 12)) @ (rectangulo top + 6) extent: 8 @ 8)
			color: color ].
	fuente := LogicalFont familyName: 'Source Code Pro' pointSize: 8.
	aCanvas
		drawString: 'longcat.exe'
		at: (rectangulo left + 46) @ (rectangulo top + 3)
		font: fuente
		color: self colorCrema.
	rectangulo width >= 150 ifTrue: [
		aCanvas
			drawString: '</>'
			at: (rectangulo right - 26) @ (rectangulo top + 3)
			font: fuente
			color: self colorMorado ].
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarBloqueEn: aCanvas casilla: unRectangulo [
	"Las paredes son bloques de codigo con relieve"
	| fuente ancho |
	aCanvas fillRectangle: unRectangulo color: self colorPizarra.
	aCanvas fillRectangle: (unRectangulo topLeft extent: unRectangulo width @ 2) color: (self colorPizarra mixed: 0.6 with: Color white).
	aCanvas fillRectangle: (unRectangulo topLeft extent: 2 @ unRectangulo height) color: (self colorPizarra mixed: 0.6 with: Color white).
	aCanvas fillRectangle: ((unRectangulo left @ (unRectangulo bottom - 2)) extent: unRectangulo width @ 2) color: self colorMarco.
	aCanvas fillRectangle: (((unRectangulo right - 2) @ unRectangulo top) extent: 2 @ unRectangulo height) color: self colorMarco.
	fuente := LogicalFont familyName: 'Source Code Pro' pointSize: 8.
	ancho := fuente widthOfString: '</>'.
	aCanvas
		drawString: '</>'
		at: (unRectangulo center x - (ancho // 2)) @ (unRectangulo center y - 7)
		font: fuente
		color: self colorMorado.
	^ self

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
	| ocupadas posicion casilla lineaGrilla |
	ocupadas := partida posicionesOcupadas.
	lineaGrilla := self colorMorado mixed: 0.35 with: self colorPantalla.
	1 to: partida filas do: [ :fila |
		1 to: partida columnas do: [ :columna |
			posicion := (Smalltalk globals at: #Posicion) fila: fila columna: columna.
			casilla := (self origenDe: posicion) extent: tamCelda @ tamCelda.
			(partida casillaBloqueadaEn: posicion)
				ifTrue: [ self dibujarBloqueEn: aCanvas casilla: casilla ]
				ifFalse: [
					(ocupadas includes: posicion)
						ifTrue: [ aCanvas fillRectangle: casilla color: (self colorVerde alpha: 0.18) ]
						ifFalse: [ aCanvas frameRectangle: casilla width: 1 color: lineaGrilla ] ] ] ].
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCodigoEn: aCanvas [
	"Codigo de fondo en la pantalla, con numeros de linea"
	| pantalla fuente lineas y numero |
	pantalla := self pantalla.
	fuente := LogicalFont familyName: 'Source Code Pro' pointSize: 8.
	lineas := self lineasDeCodigo.
	aCanvas clipBy: pantalla during: [ :canvas |
		y := pantalla top + 2.
		numero := 0.
		[ y < pantalla bottom ] whileTrue: [
			numero := numero + 1.
			canvas
				drawString: (numero printPaddedWith: $0 to: 2)
				at: (pantalla left + 3) @ y
				font: fuente
				color: (self colorPizarra mixed: 0.8 with: Color white).
			canvas
				drawString: (lineas at: ((numero - 1) \\ lineas size) + 1)
				at: (pantalla left + 22) @ y
				font: fuente
				color: (self colorCodigo: numero).
			y := y + 12 ] ].
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
TableroMorph >> dibujarMonitorEn: aCanvas [
	"Marco del monitor con borde neon, luz de encendido y pie"
	| marco cuello base anchoBase |
	marco := self marco.
	cuello := Rectangle center: (marco center x @ (marco bottom + 9)) extent: 36 @ 18.
	anchoBase := 140 min: (marco width - 20).
	base := Rectangle center: (marco center x @ (marco bottom + 24)) extent: anchoBase @ 10.
	aCanvas fillRectangle: cuello color: self colorMarco.
	aCanvas frameRectangle: cuello width: 1 color: (self colorMorado mixed: 0.5 with: self colorMarco).
	aCanvas fillRectangle: base color: self colorMarco.
	aCanvas fillRectangle: (base topLeft extent: base width @ 2) color: self colorMorado.
	aCanvas fillRectangle: marco color: self colorMarco.
	aCanvas frameRectangle: marco width: 2 color: self colorMorado.
	aCanvas frameRectangle: (marco insetBy: 3) width: 1 color: self colorPizarra.
	aCanvas
		fillOval: (Rectangle center: (marco center x @ (marco bottom - (borde // 2))) extent: 5 @ 5)
		color: self colorVerde.
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

{ #category : 'private - drawing' }
TableroMorph >> dibujarScanlinesEn: aCanvas [
	"Lineas horizontales finitas, como una pantalla vieja"
	| pantalla y |
	pantalla := self pantalla.
	y := pantalla top.
	[ y < pantalla bottom ] whileTrue: [
		aCanvas
			fillRectangle: ((pantalla left @ y) extent: pantalla width @ 1)
			color: (Color black alpha: 0.18).
		y := y + 3 ].
	aCanvas frameRectangle: pantalla width: 1 color: (self colorVerde alpha: 0.5).
	^ self

]

{ #category : 'drawing' }
TableroMorph >> drawOn: aCanvas [
	partida ifNil: [ ^ super drawOn: aCanvas ].
	self dibujarMonitorEn: aCanvas.
	self dibujarBarraEn: aCanvas.
	aCanvas fillRectangle: self pantalla color: self colorPantalla.
	self dibujarCodigoEn: aCanvas.
	self dibujarCasillasEn: aCanvas.
	"El cuerpo se pinta tres veces: contorno blanco, contorno negro y relleno"
	self dibujarCuerpoEn: aCanvas color: Color white extra: 8.
	self dibujarCuerpoEn: aCanvas color: Color black extra: 4.
	self dibujarCuerpoEn: aCanvas color: self colorPelaje extra: 0.
	self dibujarRayasEn: aCanvas.
	self dibujarCabezaEn: aCanvas.
	self dibujarScanlinesEn: aCanvas

]

{ #category : 'private - drawing' }
TableroMorph >> grosor [
	"Ancho del relleno naranja del cuerpo: dos tercios de la casilla"
	^ tamCelda * 2 // 3

]

{ #category : 'initialization' }
TableroMorph >> initialize [
	super initialize.
	tamCelda := 36.
	borde := 12.
	barra := 20.
	pie := 34.
	cabezas := Dictionary new.
	self color: Color transparent.
	^ self

]

{ #category : 'private - drawing' }
TableroMorph >> lineasDeCodigo [
	^ #(
		'Object subclass: #Gato'
		'gato := Gato en: inicio.'
		'[ tablero lleno ] whileFalse: ['
		'    gato avanzarA: siguiente ].'
		'"compilando..."'
		'cafe := Monster new.'
		'nivel := nivel + 1.'
		'^ self ganar'
		'Transcript show: ''GG''.'
		'[ dormir ] ifFalse: [ codear ].'
		'self assert: gato esLargo.'
		'entrega := ''manana 23:59''.' )

]

{ #category : 'accessing' }
TableroMorph >> marco [
	"Rectangulo del monitor, sin el pie"
	^ self position extent: (self pantalla width + (2 * borde)) @ (self pantalla height + (2 * borde) + barra)

]

{ #category : 'private - drawing' }
TableroMorph >> origenDe: unaPosicion [
	"Esquina superior izquierda de la casilla en pantalla"
	^ self pantalla topLeft
		+ (((unaPosicion columna - 1) * tamCelda) @ ((unaPosicion fila - 1) * tamCelda))

]

{ #category : 'accessing' }
TableroMorph >> pantalla [
	"Zona de la pantalla donde estan las casillas"
	^ (self position + (borde @ (borde + barra)))
		extent: (partida columnas * tamCelda) @ (partida filas * tamCelda)

]

{ #category : 'initialization' }
TableroMorph >> setPartida: unaPartida sprites: unosSprites [
	| tamano |
	partida := unaPartida.
	"Los niveles chicos usan casillas mas grandes (como maximo 48), los grandes 36"
	tamCelda := (288 // (partida filas max: partida columnas)) min: 48.
	"La cabeza se escala una sola vez, un poco mas grande que la casilla"
	tamano := tamCelda + 4.
	#(#cabezaArriba #cabezaAbajo #cabezaDerecha #cabezaIzquierda) do: [ :clave |
		cabezas at: clave put: ((unosSprites at: clave) scaledToSize: tamano @ tamano) ].
	self extent: ((partida columnas * tamCelda) + (2 * borde))
		@ ((partida filas * tamCelda) + (2 * borde) + barra + pie).
	^ self

]
