"
Menu principal: la habitacion del protagonista con el logo y los botones Jugar niveles normales, Jugar niveles personalizados, Skins y Salir.
"
Class {
	#name : 'MenuPrincipalMorph',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'botones'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'layout' }
MenuPrincipalMorph >> alineacionVertical [
	^ 0
]

{ #category : 'building' }
MenuPrincipalMorph >> boton: unaClave texto: unTexto accion: unSelector color: unColor [
	^ (BotonImagenMorph imagen: (self imagen: unaClave) accion: unSelector de: app)
		etiqueta: unTexto;
		colorBorde: unColor;
		yourself
]

{ #category : 'drawing' }
MenuPrincipalMorph >> conEsquinas [
	^ false
]

{ #category : 'building' }
MenuPrincipalMorph >> construir [
	"Tres botones: niveles normales, niveles personalizados y salir"
	botones := {
		self boton: #botonNormales texto: 'Jugar niveles normales' accion: #jugarNiveles color: EstiloLongcat colorVerde.
		self boton: #botonPersonalizados texto: 'Niveles personalizados' accion: #jugarPersonalizados color: EstiloLongcat colorVioleta.
		self boton: #botonSalir texto: 'Salir' accion: #salir color: EstiloLongcat colorRosa }.
	botones do: [ :boton | self addMorph: boton ].
	^ self
]

{ #category : 'drawing' }
MenuPrincipalMorph >> decoraciones [
	^ {
		#ventana -> (1170 @ 175 extent: 160 @ 200).
		#estante -> (985 @ 8 extent: 190 @ 138).
		#planta -> (0 @ 0 extent: 120 @ 237).
		#cartel -> (190 @ 105 extent: 150 @ 127).
		#tableroDecorativo -> (420 @ 160 extent: 150 @ 172).
		#escritorio -> (0 @ 640 extent: 700 @ 186).
		#protagonista -> (130 @ 300 extent: 520 @ 361).
		#taza -> (95 @ 546 extent: 85 @ 107) }
]

{ #category : 'drawing' }
MenuPrincipalMorph >> dibujarPisoEn: aCanvas [
	| y paso x |
	y := (self virtual: (0 @ 700 extent: 0 @ 0)) top.
	aCanvas fillRectangle: ((self left @ y) corner: self bottomRight) color: EstiloLongcat colorPiso.
	aCanvas fillRectangle: ((self left @ y) extent: self width @ 2) color: (EstiloLongcat colorMorado alpha: 0.7).
	paso := (80 * self escala) rounded max: 20.
	x := self left.
	[ x < self right ] whileTrue: [
		aCanvas
			fillRectangle: ((x @ (y + 2)) corner: ((x + 1) @ self bottom))
			color: (EstiloLongcat colorMorado alpha: 0.15).
		x := x + paso ].
	^ self
]

{ #category : 'drawing' }
MenuPrincipalMorph >> drawOn: aCanvas [
	aCanvas clipBy: self bounds during: [ :canvas |
		self dibujarFondoEn: canvas.
		self dibujarPisoEn: canvas.
		self decoraciones do: [ :decoracion |
			self dibujar: decoracion key en: (self virtual: decoracion value) sobre: canvas ].
		self dibujarLogoEn: canvas.
		EstiloLongcat
			chispasEn: (self virtual: (1124 @ 162 extent: 0 @ 0)) origin
			tamano: ((6 * self escala) rounded max: 2)
			sobre: canvas ]
]

{ #category : 'layout' }
MenuPrincipalMorph >> lugaresDeBotones [
	"Tres lugares iguales, con la misma separacion, centrados en el espacio que queda debajo del logo"
	^ (0 to: 2) collect: [ :indice | (680 @ (198 + (indice * 157))) extent: 470 @ 133 ]
]

{ #category : 'layout' }
MenuPrincipalMorph >> ubicarElementos [
	botones ifNil: [ ^ self ].
	botones with: self lugaresDeBotones do: [ :boton :lugar | boton bounds: (self virtual: lugar) ].
	^ self
]
