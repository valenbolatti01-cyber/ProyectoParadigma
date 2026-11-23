"
Superclase abstracta de las animaciones que se superponen a la interfaz cuando termina una partida: velo oscuro, lluvia de particulas y cartel con rebote. Al terminar se elimina y evalua el bloque alTerminar. Cada subclase solo declara su aspecto (colores) y su duracion: VictoriaMorph para ganar y DerrotaMorph para perder.
"
Class {
	#name : 'AnimacionResultadoMorph',
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
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
AnimacionResultadoMorph class >> sobre: unMorph centro: unPunto mensaje: unMensaje detalle: unDetalle alTerminar: unBloque [
	^ self new
		setSobre: unMorph
		centro: unPunto
		mensaje: unMensaje
		detalle: unDetalle
		alTerminar: unBloque
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> colorBorde [
	"Color del marco del cartel"
	self subclassResponsibility
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> colorCartel [
	^ EstiloLongcat colorPizarra
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> colorTitulo [
	"Color del mensaje principal del cartel"
	self subclassResponsibility
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> coloresConfeti [
	"Colores de las particulas que caen"
	self subclassResponsibility
]

{ #category : 'private - building' }
AnimacionResultadoMorph >> crearConfeti [
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
AnimacionResultadoMorph >> dibujarCartelEn: aCanvas [
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
AnimacionResultadoMorph >> drawOn: aCanvas [
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

{ #category : 'private - stepping' }
AnimacionResultadoMorph >> duracionEnMilisegundos [
	"Cuanto dura la animacion antes de cerrarse sola"
	self subclassResponsibility
]

{ #category : 'event handling' }
AnimacionResultadoMorph >> handlesMouseDown: anEvent [
	^ true
]

{ #category : 'initialization' }
AnimacionResultadoMorph >> initialize [
	super initialize.
	self color: Color transparent.
	duracion := self duracionEnMilisegundos.
	transcurrido := 0.
	terminado := false.
	azar := Random new.
	particulas := OrderedCollection new.
	^ self
]

{ #category : 'event handling' }
AnimacionResultadoMorph >> mouseDown: anEvent [
	^ self
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> progreso [
	^ (transcurrido / duracion) min: 1
]

{ #category : 'private - drawing' }
AnimacionResultadoMorph >> rebote: unValor [
	| c1 c3 x |
	c1 := 1.70158.
	c3 := c1 + 1.
	x := unValor - 1.
	^ 1 + (c3 * (x raisedTo: 3)) + (c1 * (x raisedTo: 2))
]

{ #category : 'initialization' }
AnimacionResultadoMorph >> setSobre: unMorph centro: unPunto mensaje: unMensaje detalle: unDetalle alTerminar: unBloque [
	self bounds: unMorph bounds.
	centroCartel := unPunto.
	mensaje := unMensaje.
	detalle := unDetalle.
	alTerminar := unBloque.
	self crearConfeti.
	^ self
]

{ #category : 'stepping' }
AnimacionResultadoMorph >> step [
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
AnimacionResultadoMorph >> stepTime [
	^ 30
]

{ #category : 'private - stepping' }
AnimacionResultadoMorph >> terminar [
	terminado := true.
	self stopStepping.
	self delete.
	alTerminar ifNotNil: [ alTerminar value ].
	^ self
]
