"
Marcador general de la partida, comun a todos los mundos: muestra la cantidad de movimientos realizados y las estrellas que se obtendrian si se completara el tablero ahora (doradas las que se conservan, grises las perdidas). En niveles sin movimientos de referencia solo muestra el contador.
"
Class {
	#name : 'PanelMarcadorMorph',
	#superclass : 'PanelLongcatMorph',
	#instVars : [
		'movimientos',
		'rango'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'updating' }
PanelMarcadorMorph >> actualizarConPartida: unaPartida progreso: unProgreso [
	movimientos := unaPartida cantidadMovimientos.
	rango := unProgreso nivelActualObjeto rango.
	self changed.
	^ self
]

{ #category : 'private - drawing' }
PanelMarcadorMorph >> dibujarContadorEn: aCanvas [
	| etiqueta fuente centro |
	etiqueta := controlador forma: #etiquetaMovimientos ajustadaAAncho: (self height * 3) rounded.
	fuente := EstiloLongcat fuenteNegrita: 14.
	etiqueta
		ifNil: [
			EstiloLongcat
				caja: (self topLeft extent: 170 @ self height)
				relleno: EstiloLongcat colorMorado
				borde: EstiloLongcat colorLavanda
				grosor: 2
				sobre: aCanvas.
			EstiloLongcat
				texto: 'Movimientos: ', movimientos asString
				centradoEn: (self left + 85) @ self center y
				fuente: fuente
				color: Color white
				sobre: aCanvas ]
		ifNotNil: [
			aCanvas translucentImage: etiqueta at: self topLeft + (0 @ ((self height - etiqueta height) // 2)).
			"El numero va en el espacio libre que deja la imagen a la derecha de 'MOVIMIENTOS:'"
			centro := (self left + (etiqueta width * 0.86) rounded) @ self center y.
			EstiloLongcat
				texto: movimientos asString
				centradoEn: centro + (1 @ 2)
				fuente: fuente
				color: EstiloLongcat colorMarco
				sobre: aCanvas.
			EstiloLongcat
				texto: movimientos asString
				centradoEn: centro
				fuente: fuente
				color: Color white
				sobre: aCanvas ].
	^ self
]

{ #category : 'private - drawing' }
PanelMarcadorMorph >> dibujarEstrellaEn: aCanvas centro: unPunto dorada: seConserva [
	| forma |
	forma := controlador
		forma: (seConserva ifTrue: [ #estrellaDorada ] ifFalse: [ #estrellaGris ])
		ajustadaA: 90 @ 60.
	forma
		ifNotNil: [ aCanvas translucentImage: forma at: unPunto - (forma extent // 2) ]
		ifNil: [
			aCanvas
				fillOval: (Rectangle center: unPunto extent: 24 @ 24)
				color: (seConserva ifTrue: [ EstiloLongcat colorAmarillo ] ifFalse: [ EstiloLongcat colorGrisBloqueado ]) ].
	^ self
]

{ #category : 'private - drawing' }
PanelMarcadorMorph >> dibujarEstrellasEn: aCanvas [
	| conservadas total paso |
	total := rango cantidadDeEstrellas.
	total = 0 ifTrue: [ ^ self ].
	conservadas := rango estrellasPara: movimientos.
	paso := 46.
	1 to: total do: [ :indice |
		self
			dibujarEstrellaEn: aCanvas
			centro: ((self right - 14 - (paso // 2) - ((total - indice) * paso)) @ self center y)
			dorada: indice <= conservadas ].
	^ self
]

{ #category : 'private - drawing' }
PanelMarcadorMorph >> dibujarReferenciaEn: aCanvas [
	rango estaDefinido ifFalse: [ ^ self ].
	EstiloLongcat
		texto: 'Minimo posible: ', rango minimo asString, ' movimientos'
		centradoEn: (self center x + 40) @ (self center y - 9)
		fuente: (EstiloLongcat fuente: 11)
		color: EstiloLongcat colorCrema
		sobre: aCanvas.
	EstiloLongcat
		texto: '3 estrellas hasta ', rango limiteTresEstrellas asString, ' - 2 estrellas hasta ', rango limiteDosEstrellas asString
		centradoEn: (self center x + 40) @ (self center y + 9)
		fuente: (EstiloLongcat fuente: 10)
		color: EstiloLongcat colorLavandaSuave
		sobre: aCanvas.
	^ self
]

{ #category : 'drawing' }
PanelMarcadorMorph >> drawOn: aCanvas [
	movimientos ifNil: [ ^ self ].
	self dibujarContadorEn: aCanvas.
	self dibujarReferenciaEn: aCanvas.
	self dibujarEstrellasEn: aCanvas
]

{ #category : 'layout' }
PanelMarcadorMorph >> reacomodar [
	^ self
]
