"
Boton hecho con una imagen (los PNG del menu). Al pasar el mouse la imagen crece un poco y al hacer clic envia la accion al target. Si no hay imagen dibuja una caja con etiqueta o flecha.
"
Class {
	#name : 'BotonImagenMorph',
	#superclass : 'Morph',
	#instVars : [
		'forma',
		'etiqueta',
		'target',
		'accion',
		'argumentos',
		'resaltado',
		'presionado',
		'colorBorde',
		'cache'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
BotonImagenMorph class >> imagen: unaForma accion: unSelector de: unTarget [
	^ self new setForma: unaForma accion: unSelector de: unTarget
]

{ #category : 'private - drawing' }
BotonImagenMorph >> areaImagen [
	^ resaltado
		ifTrue: [ self bounds ]
		ifFalse: [ self bounds insetBy: ((self width * 0.03) @ (self height * 0.05)) rounded ]
]

{ #category : 'accessing' }
BotonImagenMorph >> argumentos: unArray [
	argumentos := unArray
]

{ #category : 'accessing' }
BotonImagenMorph >> colorBorde: unColor [
	colorBorde := unColor.
	self changed
]

{ #category : 'private - drawing' }
BotonImagenMorph >> dibujarSinImagenEn: aCanvas [
	| caja grosor fuente |
	grosor := ((self height * 0.05) rounded) max: 2.
	caja := self areaImagen.
	presionado ifTrue: [ caja := caja translateBy: 0 @ 2 ].
	EstiloLongcat
		caja: caja
		relleno: EstiloLongcat colorTarjeta
		borde: colorBorde
		grosor: (resaltado ifTrue: [ grosor + 1 ] ifFalse: [ grosor ])
		sobre: aCanvas.
	etiqueta = #flecha ifTrue: [ ^ EstiloLongcat flechaEn: caja color: Color white sobre: aCanvas ].
	etiqueta ifNil: [ ^ self ].
	fuente := EstiloLongcat fuenteNegrita: (caja height * 0.3) rounded.
	EstiloLongcat texto: etiqueta centradoEn: caja center fuente: fuente color: Color white sobre: aCanvas
]

{ #category : 'drawing' }
BotonImagenMorph >> drawOn: aCanvas [
	| imagen destino |
	imagen := self formaAjustadaA: self areaImagen extent.
	imagen ifNil: [ ^ self dibujarSinImagenEn: aCanvas ].
	destino := self center - (imagen extent // 2).
	presionado ifTrue: [ destino := destino + (0 @ 2) ].
	aCanvas translucentImage: imagen at: destino
]

{ #category : 'actions' }
BotonImagenMorph >> ejecutar [
	self tieneAccion ifFalse: [ ^ self ].
	resaltado := false.
	^ target perform: accion withArguments: argumentos
]

{ #category : 'accessing' }
BotonImagenMorph >> etiqueta: unTextoOSimbolo [
	etiqueta := unTextoOSimbolo.
	self changed
]

{ #category : 'private - drawing' }
BotonImagenMorph >> formaAjustadaA: unTamano [
	| tamano |
	forma ifNil: [ ^ nil ].
	tamano := ((unTamano x max: 1) @ (unTamano y max: 1)) rounded.
	^ cache at: tamano ifAbsent: [
		cache size > 6 ifTrue: [ cache removeAll ].
		cache at: tamano put: (forma scaledToSize: tamano) ]
]

{ #category : 'event handling' }
BotonImagenMorph >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'event handling' }
BotonImagenMorph >> handlesMouseOver: anEvent [
	^ true
]

{ #category : 'initialization' }
BotonImagenMorph >> initialize [
	super initialize.
	resaltado := false.
	presionado := false.
	argumentos := #().
	colorBorde := EstiloLongcat colorLavanda.
	cache := Dictionary new.
	self color: Color transparent.
	self extent: 200 @ 60.
	^ self
]

{ #category : 'event handling' }
BotonImagenMorph >> mouseDown: anEvent [
	presionado := true.
	self changed
]

{ #category : 'event handling' }
BotonImagenMorph >> mouseEnter: anEvent [
	resaltado := true.
	self changed
]

{ #category : 'event handling' }
BotonImagenMorph >> mouseLeave: anEvent [
	resaltado := false.
	presionado := false.
	self changed
]

{ #category : 'event handling' }
BotonImagenMorph >> mouseUp: anEvent [
	| adentro |
	adentro := self containsPoint: anEvent cursorPoint.
	presionado := false.
	self changed.
	adentro ifTrue: [ self ejecutar ]
]

{ #category : 'initialization' }
BotonImagenMorph >> setForma: unaForma accion: unSelector de: unTarget [
	forma := unaForma.
	accion := unSelector.
	target := unTarget.
	^ self
]

{ #category : 'testing' }
BotonImagenMorph >> tieneAccion [
	^ accion notNil and: [ target notNil ]
]
