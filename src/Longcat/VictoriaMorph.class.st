"
Animacion de victoria que se pone encima de la interfaz: oscurece un poco la pantalla, tira confeti y muestra un cartel que aparece con rebote. Mientras dura bloquea los clics. Al terminar se borra sola y evalua el bloque alTerminar (por ejemplo, pasar al siguiente nivel).
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
VictoriaMorph >> colorCartel [
	^ Color r: 52 g: 59 b: 73 range: 255

]

{ #category : 'private - drawing' }
VictoriaMorph >> colorMorado [
	^ Color r: 139 g: 115 b: 214 range: 255

]

{ #category : 'private - building' }
VictoriaMorph >> crearConfeti [
	| colores |
	colores := {
		Color r: 233 g: 154 b: 69 range: 255.
		Color r: 139 g: 115 b: 214 range: 255.
		Color r: 140 g: 203 b: 103 range: 255.
		Color r: 255 g: 105 b: 150 range: 255.
		Color yellow.
		Color white }.
	particulas := OrderedCollection new.
	70 timesRepeat: [
		"Cada particula: x, y, velocidad x, velocidad y, color, tamano"
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
	"El cartel crece durante el primer tercio de la animacion, con un pequeno rebote"
	escala := self rebote: ((self progreso * 3) min: 1).
	escala <= 0 ifTrue: [ ^ self ].
	caja := Rectangle center: centroCartel extent: ((300 * escala) @ (86 * escala)) rounded.
	aCanvas fillRectangle: (caja expandBy: 4) color: Color white.
	aCanvas fillRectangle: caja color: self colorCartel.
	aCanvas frameRectangle: caja width: 3 color: self colorMorado.
	escala < 0.9 ifTrue: [ ^ self ].
	fuente := LogicalFont familyName: 'Source Sans Pro' pointSize: 20.
	fuenteChica := LogicalFont familyName: 'Source Sans Pro' pointSize: 12.
	anchoTexto := fuente widthOfString: mensaje.
	aCanvas
		drawString: mensaje
		at: (centroCartel x - (anchoTexto // 2)) @ (centroCartel y - 30)
		font: fuente
		color: Color yellow.
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
	"Velo oscuro que aparece de a poco"
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
	"Mientras dura la animacion no se puede tocar nada de abajo"
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
	"De 0 a 1 a lo largo de la animacion"
	^ (transcurrido / duracion) min: 1

]

{ #category : 'private - drawing' }
VictoriaMorph >> rebote: unValor [
	"Curva easeOutBack: pasa un poco de 1 y vuelve, para que el cartel 'salte'"
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
