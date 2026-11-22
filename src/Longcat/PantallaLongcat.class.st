"
Superclase de todas las pantallas del juego. Dibuja el fondo violeta comun y ubica elementos sobre una escena virtual de 1340 x 740 escalable.
"
Class {
	#name : 'PantallaLongcat',
	#superclass : 'Morph',
	#instVars : [
		'app',
		'tamanoAnterior',
		'construida',
		'cacheFormas',
		'pixeles'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
PantallaLongcat class >> app: unaApp [
	^ self new setApp: unaApp
]

{ #category : 'showing' }
PantallaLongcat >> alMostrarse [
	construida == true ifFalse: [
		self construir.
		construida := true ].
	self reacomodar.
	^ self
]

{ #category : 'layout' }
PantallaLongcat >> alineacionVertical [
	^ 0.5
]

{ #category : 'accessing' }
PantallaLongcat >> app [
	^ app
]

{ #category : 'building' }
PantallaLongcat >> botonVolver [
	^ (BotonImagenMorph imagen: nil accion: #irAlMenu de: app)
		etiqueta: #flecha;
		yourself
]

{ #category : 'drawing' }
PantallaLongcat >> conEsquinas [
	^ true
]

{ #category : 'showing' }
PantallaLongcat >> construir [
	^ self
]

{ #category : 'initialization' }
PantallaLongcat >> crearPixeles [
	| azar |
	azar := Random seed: 11.
	pixeles := (1 to: 46) collect: [ :indice |
		{ (azar next @ azar next). (8 + (azar next * 18)) rounded. 0.04 + (azar next * 0.08) } ].
	^ self
]

{ #category : 'images' }
PantallaLongcat >> dibujar: unaClave en: unRectangulo sobre: aCanvas [
	| imagen |
	imagen := self forma: unaClave ajustadaA: unRectangulo extent.
	imagen ifNil: [ ^ self ].
	aCanvas translucentImage: imagen at: unRectangulo center - (imagen extent // 2).
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarEsquinasEn: aCanvas [
	| largo grosor margen caja |
	largo := (52 * self escala) rounded max: 16.
	grosor := (5 * self escala) rounded max: 2.
	margen := (18 * self escala) rounded max: 6.
	caja := self bounds insetBy: margen.
	{ caja topLeft -> (1 @ 1). caja topRight -> (-1 @ 1). caja bottomLeft -> (1 @ -1). caja bottomRight -> (-1 @ -1) } do: [ :esquina |
		{ (EstiloLongcat colorLavanda alpha: 0.3) -> 2. EstiloLongcat colorVioleta -> 0 } do: [ :capa |
			self
				esquina: esquina key
				sentido: esquina value
				largo: largo
				grosor: grosor
				color: capa key
				extra: capa value
				sobre: aCanvas ] ].
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarFondoEn: aCanvas [
	| bandas alto arriba abajo |
	arriba := EstiloLongcat colorFondoArriba.
	abajo := EstiloLongcat colorFondoAbajo.
	bandas := 32.
	alto := (self height / bandas) ceiling.
	0 to: bandas - 1 do: [ :indice |
		aCanvas
			fillRectangle: ((self left @ (self top + (indice * alto))) extent: self width @ alto)
			color: (abajo mixed: indice / (bandas - 1) with: arriba) ].
	pixeles ifNotNil: [
		pixeles do: [ :pixel | | lado esquina |
			lado := ((pixel at: 2) * self escala) rounded max: 3.
			esquina := self position + ((((pixel at: 1) x * self width) rounded) @ (((pixel at: 1) y * self height) rounded)).
			aCanvas fillRectangle: (esquina extent: lado @ lado) color: (EstiloLongcat colorLavanda alpha: (pixel at: 3)) ] ].
	self conEsquinas ifTrue: [ self dibujarEsquinasEn: aCanvas ].
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarIcono: unIcono en: unRectangulo sobre: aCanvas [
	| separacion lado grosor |
	unIcono = #grilla ifFalse: [ ^ self dibujar: unIcono en: unRectangulo sobre: aCanvas ].
	separacion := (unRectangulo width // 8) max: 2.
	lado := (unRectangulo width - separacion) // 2.
	grosor := (unRectangulo width // 14) max: 2.
	0 to: 1 do: [ :columna |
		0 to: 1 do: [ :fila |
			EstiloLongcat
				caja: ((unRectangulo origin + ((columna * (lado + separacion)) @ (fila * (lado + separacion)))) extent: lado @ lado)
				relleno: nil
				borde: EstiloLongcat colorLavanda
				grosor: grosor
				sobre: aCanvas ] ].
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarLogoEn: aCanvas [
	| lugar |
	lugar := self virtual: (390 @ 20 extent: 560 @ 122).
	(self imagen: #logo) ifNotNil: [ ^ self dibujar: #logo en: lugar sobre: aCanvas ].
	EstiloLongcat
		texto: 'LONGCAT.exe'
		centradoEn: lugar center
		fuente: (EstiloLongcat fuenteNegrita: (lugar height * 0.4) rounded)
		color: EstiloLongcat colorCrema
		sobre: aCanvas.
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarPie: unTexto sobre: aCanvas [
	EstiloLongcat
		texto: unTexto
		centradoEn: (self virtual: (670 @ 700 extent: 0 @ 0)) origin
		fuente: (EstiloLongcat fuente: ((16 * self escala) rounded max: 9))
		color: (EstiloLongcat colorLavanda alpha: 0.8)
		sobre: aCanvas.
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> dibujarTitulo: unTexto icono: unIcono en: unRectangulo sobre: aCanvas [
	| r grosor lado icono separador |
	r := self virtual: unRectangulo.
	grosor := (5 * self escala) rounded max: 2.
	EstiloLongcat caja: (r expandBy: grosor) relleno: nil borde: (EstiloLongcat colorVioleta alpha: 0.35) grosor: grosor sobre: aCanvas.
	EstiloLongcat caja: r relleno: (EstiloLongcat colorTarjeta alpha: 0.9) borde: EstiloLongcat colorLavanda grosor: grosor sobre: aCanvas.
	lado := (r height * 0.5) rounded.
	icono := ((r left + (r height * 0.4) rounded) @ (r center y - (lado // 2))) extent: lado @ lado.
	self dibujarIcono: unIcono en: icono sobre: aCanvas.
	separador := icono right + (lado // 3).
	aCanvas
		fillRectangle: ((separador @ (r top + (r height // 4))) extent: 2 @ (r height // 2))
		color: (EstiloLongcat colorLavanda alpha: 0.6).
	EstiloLongcat
		texto: unTexto
		centradoEn: (((separador + r right) // 2) @ r center y)
		fuente: (EstiloLongcat fuenteNegrita: (r height * 0.27) rounded)
		color: Color white
		sobre: aCanvas.
	^ self
]

{ #category : 'drawing' }
PantallaLongcat >> drawOn: aCanvas [
	self dibujarFondoEn: aCanvas
]

{ #category : 'layout' }
PantallaLongcat >> escala [
	^ ((self width / 1340) min: (self height / 740)) asFloat max: 0.2
]

{ #category : 'drawing' }
PantallaLongcat >> esquina: unPunto sentido: unSentido largo: unLargo grosor: unGrosor color: unColor extra: unExtra sobre: aCanvas [
	| horizontal vertical |
	horizontal := Rectangle encompassing: { unPunto. unPunto + ((unSentido x * unLargo) @ (unSentido y * unGrosor)) }.
	vertical := Rectangle encompassing: { unPunto. unPunto + ((unSentido x * unGrosor) @ (unSentido y * unLargo)) }.
	aCanvas fillRectangle: (horizontal expandBy: unExtra) color: unColor.
	aCanvas fillRectangle: (vertical expandBy: unExtra) color: unColor.
	^ self
]

{ #category : 'images' }
PantallaLongcat >> forma: unaClave ajustadaA: unTamano [
	| original guardada tamano |
	original := self imagen: unaClave.
	original ifNil: [ ^ nil ].
	cacheFormas ifNil: [ cacheFormas := Dictionary new ].
	tamano := ((unTamano x max: 1) @ (unTamano y max: 1)) rounded.
	guardada := cacheFormas at: unaClave ifAbsent: [ nil ].
	(guardada notNil and: [ guardada key = tamano ]) ifTrue: [ ^ guardada value ].
	guardada := tamano -> (original scaledToSize: tamano).
	cacheFormas at: unaClave put: guardada.
	^ guardada value
]

{ #category : 'images' }
PantallaLongcat >> forma: unaClave ajustadaAAncho: unAncho [
	"La imagen escalada al ancho pedido conservando su proporcion (nil si falta la imagen)"
	| original |
	original := self imagen: unaClave.
	original ifNil: [ ^ nil ].
	^ self forma: unaClave ajustadaA: unAncho @ ((unAncho * original height / original width) rounded)
]

{ #category : 'images' }
PantallaLongcat >> imagen: unaClave [
	^ app ifNotNil: [ :unaApp | unaApp imagen: unaClave ]
]

{ #category : 'initialization' }
PantallaLongcat >> initialize [
	super initialize.
	construida := false.
	cacheFormas := Dictionary new.
	self color: EstiloLongcat colorFondoArriba.
	self crearPixeles.
	^ self
]

{ #category : 'layout' }
PantallaLongcat >> origenVirtual [
	| e |
	e := self escala.
	^ self position + ((((self width - (1340 * e)) / 2) @ ((self height - (740 * e)) * self alineacionVertical)) rounded)
]

{ #category : 'layout' }
PantallaLongcat >> reacomodar [
	tamanoAnterior := self extent.
	self ubicarElementos.
	self changed.
	^ self
]

{ #category : 'showing' }
PantallaLongcat >> refrescar [
	self changed.
	^ self
]

{ #category : 'initialization' }
PantallaLongcat >> setApp: unaApp [
	app := unaApp.
	^ self
]

{ #category : 'stepping' }
PantallaLongcat >> step [
	self extent = tamanoAnterior ifFalse: [ self reacomodar ]
]

{ #category : 'stepping' }
PantallaLongcat >> stepTime [
	^ 50
]

{ #category : 'layout' }
PantallaLongcat >> ubicarElementos [
	^ self
]

{ #category : 'layout' }
PantallaLongcat >> virtual: unRectangulo [
	| e |
	e := self escala.
	^ ((self origenVirtual + (unRectangulo origin * e)) extent: (unRectangulo extent * e)) rounded
]
