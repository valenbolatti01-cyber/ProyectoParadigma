"
Menu de niveles personalizados generado polimorficamente a partir de las subclases de ColeccionNiveles (Minecraft, Pokemon, Dragon Ball).
"
Class {
	#name : 'MenuPersonalizadosMorph',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'volver',
		'tarjetas'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'private - building' }
MenuPersonalizadosMorph >> claveIconoParaColeccion: unaColeccion [
	^ {
		NivelesMinecraft -> #minecraft.
		NivelesPokemon -> #pokemon.
		NivelesDragonBall -> #dragonBall } asDictionary
		at: unaColeccion class
		ifAbsent: [ nil ]
]

{ #category : 'private - building' }
MenuPersonalizadosMorph >> colorParaColeccion: unaColeccion [
	^ {
		NivelesMinecraft -> EstiloLongcat colorVerde.
		NivelesPokemon -> EstiloLongcat colorRosa.
		NivelesDragonBall -> EstiloLongcat colorNaranja } asDictionary
		at: unaColeccion class
		ifAbsent: [ EstiloLongcat colorMorado ]
]

{ #category : 'building' }
MenuPersonalizadosMorph >> construir [
	volver := self botonVolver.
	tarjetas := ColeccionNiveles personalizadas collect: [ :coleccion |
		self tarjetaParaColeccion: coleccion ].
	self addMorph: volver.
	tarjetas do: [ :tarjeta | self addMorph: tarjeta ].
	^ self
]

{ #category : 'drawing' }
MenuPersonalizadosMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	self dibujarLogoEn: aCanvas.
	self dibujarTitulo: 'Jugar Niveles Personalizados' icono: #grilla en: (290 @ 170 extent: 760 @ 92) sobre: aCanvas.
	EstiloLongcat
		chispasEn: (self virtual: (1040 @ 128 extent: 0 @ 0)) origin
		tamano: ((6 * self escala) rounded max: 2)
		sobre: aCanvas.
	self dibujarPie: 'Elegí un mundo: 10 niveles y hasta 3 estrellas en cada uno' sobre: aCanvas
]

{ #category : 'building' }
MenuPersonalizadosMorph >> tarjetaParaColeccion: unaColeccion [
	| accion argumentos tarjeta |
	accion := unaColeccion estaDisponible ifTrue: [ #jugarColeccion: ] ifFalse: [ nil ].
	argumentos := unaColeccion estaDisponible ifTrue: [ Array with: unaColeccion ] ifFalse: [ #() ].
	tarjeta := (TarjetaMorph imagen: (self imagen: (self claveIconoParaColeccion: unaColeccion)) accion: accion de: app)
		titulo: unaColeccion nombre;
		colorBorde: (self colorParaColeccion: unaColeccion);
		argumentos: argumentos;
		yourself.
	unaColeccion estaDisponible ifTrue: [ tarjeta insignia: 'JUGAR' ].
	^ tarjeta
]

{ #category : 'layout' }
MenuPersonalizadosMorph >> ubicarElementos [
	volver ifNil: [ ^ self ].
	volver bounds: (self virtual: (55 @ 45 extent: 95 @ 75)).
	tarjetas withIndexDo: [ :tarjeta :indice |
		tarjeta bounds: (self virtual: ((110 + ((indice - 1) * 387)) @ 300 extent: 345 @ 330)) ].
	^ self
]
