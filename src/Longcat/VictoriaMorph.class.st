"
Animacion de victoria superpuesta a la interfaz: velo oscuro, confeti y cartel con rebote. Al terminar se elimina y evalua el bloque alTerminar.
"
Class {
	#name : 'VictoriaMorph',
	#superclass : 'Morph',
	#instVars : [
		'inicio',
		'transcurrido',
		'duracion',
		'particulas',
		'azar',
		'centroCartel',
		'mensaje',
		'detalle',
		'alTerminar',
		'terminado'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
VictoriaMorph class >> sobre: unMorph centro: unPunto mensaje: unMensaje detalle: unDetalle alTerminar: unBloque [
	^ self new
		setSobre: unMorph
		centro: unPunto
		mensaje: unMensaje
		detalle: unDetalle
		alTerminar: unBloque
]

{ #category : 'private - drawing' }
VictoriaMorph >> colorBorde [
	^ EstiloLongcat colorMorado
]

{ #category : 'private - drawing' }
VictoriaMorph >> colorCartel [
	^ EstiloLongcat colorPizarra
]

{ #category : 'private - drawing' }
VictoriaMorph >> colorTitulo [
	^ EstiloLongcat colorAmarillo
]

{ #category : 'private - drawing' }
VictoriaMorph >> coloresConfeti [
	^ {
		EstiloLongcat colorNaranja.
		EstiloLongcat colorMorado.
		EstiloLongcat colorVerde.
		EstiloLongcat colorRosaConfeti.
		EstiloLongcat colorAmarillo.
		Color white }
]

{ #category : 'private - building' }
VictoriaMorph >> crearConfeti [
	| colores |
	colores := self coloresConfeti.
	particulas := OrderedCollection new.
	70 timesRepeat: [
		particulas add: {
			self left + (azar next * self width).
			self top - (azar next * self height * 0.7).
			(azar next - 0.5) * 3.
			1 + (azar next * 3).
			colores atRandom.
			(4 + (azar next * 5)) rounded } ].
	^ self
]

{ #category : 'private - drawing' }
VictoriaMorph >> dibujarCartelEn: aCanvas [
	| escala caja fuente fuenteChica anchoTexto |
	escala := self rebote: ((self progreso * 3) min: 1).
	escala <= 0 ifTrue: [ ^ self ].
	caja := Rectangle center: centroCartel extent: ((300 * escala) @ (86 * escala)) rounded.
	aCanvas fillRectangle: (caja expandBy: 4) color: Color white.
	aCanvas fillRectangle: caja color: self colorCartel.
	aCanvas frameRectangle: caja width: 3 color: self colorBorde.
	escala < 0.9 ifTrue: [ ^ self ].
	fuente := EstiloLongcat fuente: 20.
	fuenteChica := EstiloLongcat fuente: 12.
	anchoTexto := fuente widthOfString: mensaje.
	aCanvas
		drawString: mensaje
		at: (centroCartel x - (anchoTexto // 2)) @ (centroCartel y - 30)
		font: fuente
		color: self colorTitulo.
	anchoTexto := fuenteChica widthOfString: detalle.
	aCanvas
		drawString: detalle
		at: (centroCartel x - (anchoTexto // 2)) @ (centroCartel y + 10)
		font: fuenteChica
		color: Color white.
	^ self
]

{ #category : 'drawing' }
VictoriaMorph >> drawOn: aCanvas [
	aCanvas
		fillRectangle: self bounds
		color: (Color black alpha: 0.35 * ((self progreso * 4) min: 1)).
	particulas do: [ :particula |
		aCanvas
			fillRectangle: ((((particula at: 1) @ (particula at: 2)) rounded)
				extent: (particula at: 6) @ (particula at: 6))
			color: (particula at: 5) ].
	self dibujarCartelEn: aCanvas
]

{ #category : 'event handling' }
VictoriaMorph >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'initialization' }
VictoriaMorph >> initialize [
	super initialize.
	self color: Color transparent.
	duracion := 2500.
	transcurrido := 0.
	terminado := false.
	azar := Random new.
	particulas := OrderedCollection new.
	^ self
]

{ #category : 'event handling' }
VictoriaMorph >> mouseDown: anEvent [
	^ self
]

{ #category : 'private - drawing' }
VictoriaMorph >> progreso [
	^ (transcurrido / duracion) min: 1
]

{ #category : 'private - drawing' }
VictoriaMorph >> rebote: unValor [
	| c1 c3 x |
	c1 := 1.70158.
	c3 := c1 + 1.
	x := unValor - 1.
	^ 1 + (c3 * (x raisedTo: 3)) + (c1 * (x raisedTo: 2))
]

{ #category : 'initialization' }
VictoriaMorph >> setSobre: unMorph centro: unPunto mensaje: unMensaje detalle: unDetalle alTerminar: unBloque [
	self bounds: unMorph bounds.
	centroCartel := unPunto.
	mensaje := unMensaje.
	detalle := unDetalle.
	alTerminar := unBloque.
	self crearConfeti.
	^ self
]

{ #category : 'stepping' }
VictoriaMorph >> step [
	inicio ifNil: [ inicio := Time millisecondClockValue ].
	transcurrido := Time millisecondClockValue - inicio.
	particulas do: [ :particula |
		particula at: 1 put: (particula at: 1) + (particula at: 3).
		particula at: 2 put: (particula at: 2) + (particula at: 4).
		particula at: 4 put: (particula at: 4) + 0.15 ].
	self changed.
	(transcurrido >= duracion and: [ terminado not ]) ifTrue: [ self terminar ]
]

{ #category : 'stepping' }
VictoriaMorph >> stepTime [
	^ 30
]

{ #category : 'private - stepping' }
VictoriaMorph >> terminar [
	terminado := true.
	self stopStepping.
	self delete.
	alTerminar ifNotNil: [ alTerminar value ].
	^ self
]
