"
Dibuja el tablero como un monitor retro con el cuerpo continuo del gato y encapsula su propia animacion de sacudida. Consulta directamente al objeto SkinGato activo y delega colores en EstiloLongcat.
"
Class {
	#name : 'TableroMorph',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'skin',
		'cabezasEscaladas',
		'tamanoCache',
		'tamCelda',
		'borde',
		'barra',
		'pie',
		'sacudidaInicio',
		'sacudidaVertical',
		'posicionBase'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
TableroMorph class >> partida: unaPartida skin: unaSkin [
	^ self new setPartida: unaPartida skin: unaSkin
]

{ #category : 'instance creation' }
TableroMorph class >> partida: unaPartida skin: unaSkin coleccion: unaColeccion [
	^ self new setPartida: unaPartida skin: unaSkin coleccion: unaColeccion
]

{ #category : 'instance creation' }
TableroMorph class >> partida: unaPartida sprites: unosSprites [
	^ self new setPartida: unaPartida sprites: unosSprites

]

{ #category : 'layout' }
TableroMorph >> actualizarExtension [
	self extent: ((partida columnas * tamCelda) + (2 * borde))
		@ ((partida filas * tamCelda) + (2 * borde) + barra + pie).
	^ self
]

{ #category : 'layout' }
TableroMorph >> ajustarA: unTamano [
	tamCelda := (((unTamano x - (2 * borde)) // partida columnas)
		min: ((unTamano y - (2 * borde) - barra - pie) // partida filas)).
	tamCelda := (tamCelda min: 80) max: 16.
	self actualizarExtension.
	self changed.
	^ self
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

{ #category : 'private - animation' }
TableroMorph >> avanzarSacudida [
	| transcurrido fuerza desvio cruce |
	sacudidaInicio ifNil: [ ^ self ].
	transcurrido := Time millisecondClockValue - sacudidaInicio.
	transcurrido >= 380 ifTrue: [ ^ self detenerSacudida ].
	fuerza := 9 * (1 - (transcurrido / 380)).
	desvio := (((transcurrido / 24.0) * Float pi) sin * fuerza) rounded.
	cruce := ((transcurrido // 30) even ifTrue: [ 1 ] ifFalse: [ -1 ]) * (fuerza / 4) rounded.
	self position: posicionBase + (sacudidaVertical
		ifTrue: [ cruce @ desvio ]
		ifFalse: [ desvio @ cruce ]).
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> brazoEn: aCanvas origen: unOrigen desde: unaCelda hacia: unVecino margen: unMargen grosor: unGrosor color: unColor [
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
TableroMorph >> cabezaEscaladaPara: unaDireccion [
	| tamano original |
	skin ifNil: [ ^ nil ].
	tamano := tamCelda + 4.
	tamanoCache = tamano ifFalse: [
		cabezasEscaladas removeAll.
		tamanoCache := tamano ].
	^ cabezasEscaladas at: unaDireccion class ifAbsentPut: [
		original := skin cabezaParaDireccion: unaDireccion.
		original ifNotNil: [ original scaledToSize: tamano @ tamano ] ]
]

{ #category : 'private - drawing' }
TableroMorph >> colorAcento [
	^ coleccion ifNotNil: [ coleccion colorAcento ] ifNil: [ EstiloLongcat colorVerde ]
]

{ #category : 'private - drawing' }
TableroMorph >> colorBloque [
	^ coleccion ifNotNil: [ coleccion colorBloque ] ifNil: [ EstiloLongcat colorPizarra ]
]

{ #category : 'private - drawing' }
TableroMorph >> colorCodigo: unNumeroDeLinea [
	| colores |
	colores := {
		EstiloLongcat colorMorado.
		EstiloLongcat colorVerde.
		EstiloLongcat colorNaranja.
		EstiloLongcat colorCrema }.
	^ (colores at: ((unNumeroDeLinea - 1) \\ colores size) + 1)
		mixed: 0.45
		with: EstiloLongcat colorPantalla
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

{ #category : 'private - drawing' }
TableroMorph >> colorPantalla [
	^ coleccion ifNotNil: [ coleccion colorPantalla ] ifNil: [ EstiloLongcat colorPantalla ]
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

{ #category : 'private - drawing' }
TableroMorph >> colorTema [
	^ coleccion ifNotNil: [ coleccion colorTema ] ifNil: [ EstiloLongcat colorMorado ]
]

{ #category : 'private - colors' }
TableroMorph >> colorVerde [
	^ Color r: 140 g: 203 b: 103 range: 255

]

{ #category : 'animation' }
TableroMorph >> detenerSacudida [
	sacudidaInicio ifNil: [ ^ self ].
	sacudidaInicio := nil.
	self stopStepping.
	posicionBase ifNotNil: [ :base | self position: base ].
	posicionBase := nil.
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarBarraEn: aCanvas [
	| rectangulo fuente colores |
	rectangulo := (self position + (borde @ borde)) extent: self pantalla width @ barra.
	aCanvas fillRectangle: rectangulo color: EstiloLongcat colorPizarra.
	colores := { EstiloLongcat colorNaranja. EstiloLongcat colorCrema. EstiloLongcat colorVerde }.
	colores withIndexDo: [ :color :indice |
		aCanvas
			fillOval: ((rectangulo left + 6 + ((indice - 1) * 12)) @ (rectangulo top + 6) extent: 8 @ 8)
			color: color ].
	fuente := EstiloLongcat fuenteCodigo: 8.
	aCanvas
		drawString: 'longcat.exe'
		at: (rectangulo left + 46) @ (rectangulo top + 3)
		font: fuente
		color: EstiloLongcat colorCrema.
	rectangulo width >= 150 ifTrue: [
		aCanvas
			drawString: '</>'
			at: (rectangulo right - 26) @ (rectangulo top + 3)
			font: fuente
			color: EstiloLongcat colorMorado ].
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarBloqueEn: aCanvas casilla: unRectangulo [
	| fuente ancho bloque |
	bloque := EstiloLongcat colorPizarra.
	aCanvas fillRectangle: unRectangulo color: bloque.
	aCanvas fillRectangle: (unRectangulo topLeft extent: unRectangulo width @ 2) color: (bloque mixed: 0.6 with: Color white).
	aCanvas fillRectangle: (unRectangulo topLeft extent: 2 @ unRectangulo height) color: (bloque mixed: 0.6 with: Color white).
	aCanvas fillRectangle: ((unRectangulo left @ (unRectangulo bottom - 2)) extent: unRectangulo width @ 2) color: EstiloLongcat colorMarcoMonitor.
	aCanvas fillRectangle: (((unRectangulo right - 2) @ unRectangulo top) extent: 2 @ unRectangulo height) color: EstiloLongcat colorMarcoMonitor.
	fuente := EstiloLongcat fuenteCodigo: 8.
	ancho := fuente widthOfString: '</>'.
	aCanvas
		drawString: '</>'
		at: (unRectangulo center x - (ancho // 2)) @ (unRectangulo center y - 7)
		font: fuente
		color: EstiloLongcat colorMorado.
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCabezaEn: aCanvas [
	| cabeza forma centro |
	cabeza := partida posicionCabeza.
	forma := self cabezaEscaladaPara: partida direccionCabeza.
	centro := (self origenDe: cabeza) + (tamCelda // 2).
	forma
		ifNotNil: [ aCanvas translucentImage: forma at: centro - (forma extent // 2) ]
		ifNil: [
			aCanvas
				fillOval: (Rectangle center: centro extent: (self grosor @ self grosor))
				color: (skin ifNotNil: [ skin colorCuerpo ] ifNil: [ EstiloLongcat colorNaranja ]) ].
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCasillasEn: aCanvas [
	| ocupadas posicion casilla lineaGrilla |
	ocupadas := partida posicionesOcupadas.
	lineaGrilla := EstiloLongcat colorMorado mixed: 0.35 with: EstiloLongcat colorPantalla.
	1 to: partida filas do: [ :fila |
		1 to: partida columnas do: [ :columna |
			posicion := Posicion fila: fila columna: columna.
			casilla := (self origenDe: posicion) extent: tamCelda @ tamCelda.
			(partida casillaBloqueadaEn: posicion)
				ifTrue: [ self dibujarBloqueEn: aCanvas casilla: casilla ]
				ifFalse: [
					(ocupadas includes: posicion)
						ifTrue: [ aCanvas fillRectangle: casilla color: (EstiloLongcat colorVerde alpha: 0.18) ]
						ifFalse: [ aCanvas frameRectangle: casilla width: 1 color: lineaGrilla ] ] ] ].
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarCodigoEn: aCanvas [
	| pantalla fuente lineas y numero |
	pantalla := self pantalla.
	fuente := EstiloLongcat fuenteCodigo: 8.
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
				color: (EstiloLongcat colorPizarra mixed: 0.8 with: Color white).
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
	| marco cuello base anchoBase |
	marco := self marco.
	cuello := Rectangle center: (marco center x @ (marco bottom + 9)) extent: 36 @ 18.
	anchoBase := 140 min: (marco width - 20).
	base := Rectangle center: (marco center x @ (marco bottom + 24)) extent: anchoBase @ 10.
	aCanvas fillRectangle: cuello color: EstiloLongcat colorMarcoMonitor.
	aCanvas frameRectangle: cuello width: 1 color: (EstiloLongcat colorMorado mixed: 0.5 with: EstiloLongcat colorMarcoMonitor).
	aCanvas fillRectangle: base color: EstiloLongcat colorMarcoMonitor.
	aCanvas fillRectangle: (base topLeft extent: base width @ 2) color: EstiloLongcat colorMorado.
	aCanvas fillRectangle: marco color: EstiloLongcat colorMarcoMonitor.
	aCanvas frameRectangle: marco width: 2 color: EstiloLongcat colorMorado.
	aCanvas frameRectangle: (marco insetBy: 3) width: 1 color: EstiloLongcat colorPizarra.
	aCanvas
		fillOval: (Rectangle center: (marco center x @ (marco bottom - (borde // 2))) extent: 5 @ 5)
		color: EstiloLongcat colorVerde.
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarRayasEn: aCanvas [
	| segmentos margen largo mitad celda previo origen colorRayas |
	segmentos := partida posicionesOcupadas.
	segmentos size < 2 ifTrue: [ ^ self ].
	colorRayas := skin ifNotNil: [ skin colorRayas ] ifNil: [ EstiloLongcat colorRayas ].
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
						color: colorRayas ] ]
			ifFalse: [
				#(-6 3) do: [ :desvio |
					aCanvas
						fillRectangle: ((origen + (margen @ (mitad + desvio))) extent: largo @ 3)
						color: colorRayas ] ] ].
	^ self
]

{ #category : 'private - drawing' }
TableroMorph >> dibujarScanlinesEn: aCanvas [
	| pantalla y |
	pantalla := self pantalla.
	y := pantalla top.
	[ y < pantalla bottom ] whileTrue: [
		aCanvas
			fillRectangle: ((pantalla left @ y) extent: pantalla width @ 1)
			color: (Color black alpha: 0.18).
		y := y + 3 ].
	aCanvas frameRectangle: pantalla width: 1 color: (EstiloLongcat colorVerde alpha: 0.5).
	^ self
]

{ #category : 'drawing' }
TableroMorph >> drawOn: aCanvas [
	| colorCuerpo colorExterno colorInterno |
	partida ifNil: [ ^ super drawOn: aCanvas ].
	colorCuerpo := skin ifNotNil: [ skin colorCuerpo ] ifNil: [ EstiloLongcat colorNaranja ].
	colorExterno := skin ifNotNil: [ skin colorContornoExterno ] ifNil: [ Color white ].
	colorInterno := skin ifNotNil: [ skin colorContornoInterno ] ifNil: [ Color black ].
	self dibujarMonitorEn: aCanvas.
	self dibujarBarraEn: aCanvas.
	aCanvas fillRectangle: self pantalla color: EstiloLongcat colorPantalla.
	self dibujarCodigoEn: aCanvas.
	self dibujarCasillasEn: aCanvas.
	self dibujarCuerpoEn: aCanvas color: colorExterno extra: 8.
	self dibujarCuerpoEn: aCanvas color: colorInterno extra: 4.
	self dibujarCuerpoEn: aCanvas color: colorCuerpo extra: 0.
	self dibujarRayasEn: aCanvas.
	self dibujarCabezaEn: aCanvas.
	self dibujarScanlinesEn: aCanvas
]

{ #category : 'private - drawing' }
TableroMorph >> grosor [
	^ tamCelda * 2 // 3
]

{ #category : 'initialization' }
TableroMorph >> initialize [
	super initialize.
	tamCelda := 36.
	borde := 12.
	barra := 20.
	pie := 34.
	cabezasEscaladas := Dictionary new.
	tamanoCache := 0.
	sacudidaVertical := false.
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
	^ self position extent: (self pantalla width + (2 * borde)) @ (self pantalla height + (2 * borde) + barra)
]

{ #category : 'private - drawing' }
TableroMorph >> origenDe: unaPosicion [
	^ self pantalla topLeft
		+ (((unaPosicion columna - 1) * tamCelda) @ ((unaPosicion fila - 1) * tamCelda))
]

{ #category : 'accessing' }
TableroMorph >> pantalla [
	^ (self position + (borde @ (borde + barra)))
		extent: (partida columnas * tamCelda) @ (partida filas * tamCelda)
]

{ #category : 'animation' }
TableroMorph >> sacudirEn: unaDireccion [
	sacudidaInicio ifNil: [ posicionBase := self position ].
	sacudidaVertical := unaDireccion esVertical.
	sacudidaInicio := Time millisecondClockValue.
	self startStepping.
	^ self
]

{ #category : 'initialization' }
TableroMorph >> setPartida: unaPartida skin: unaSkin [
	partida := unaPartida.
	skin := unaSkin.
	tamCelda := (288 // (partida filas max: partida columnas)) min: 48.
	cabezasEscaladas removeAll.
	tamanoCache := 0.
	self actualizarExtension.
	^ self
]

{ #category : 'initialization' }
TableroMorph >> setPartida: unaPartida skin: unaSkin coleccion: unaColeccion [
	partida := unaPartida.
	skin := unaSkin.
	coleccion := unaColeccion.
	tamCelda := (288 // (partida filas max: partida columnas)) min: 48.
	cabezasEscaladas removeAll.
	tamanoCache := 0.
	self actualizarExtension.
	^ self
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

{ #category : 'accessing' }
TableroMorph >> skin: unaSkin [
	skin := unaSkin.
	cabezasEscaladas removeAll.
	tamanoCache := 0.
	self changed.
	^ self
]

{ #category : 'stepping' }
TableroMorph >> step [
	self avanzarSacudida
]

{ #category : 'stepping' }
TableroMorph >> stepTime [
	^ 30
]

{ #category : 'stepping' }
TableroMorph >> wantsSteps [
	^ sacudidaInicio notNil
]
