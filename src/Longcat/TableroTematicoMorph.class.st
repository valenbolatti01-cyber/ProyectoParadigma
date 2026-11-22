"
Tablero ilustrado de un mundo: en lugar del monitor retro dibuja un marco simple y cada casilla con las imagenes de su TemaTematico (libre, recorrida y obstaculo). El gato, su cuerpo y su animacion de sacudida se heredan de TableroMorph, por lo que la skin elegida se ve igual en todos los mundos.
"
Class {
	#name : 'TableroTematicoMorph',
	#superclass : 'TableroMorph',
	#instVars : [
		'tema',
		'imagenes',
		'formasDeCasilla',
		'tamanoDeFormas'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
TableroTematicoMorph class >> partida: unaPartida skin: unaSkin tema: unTema imagenes: unProveedorDeImagenes [
	^ self new
		setTema: unTema imagenes: unProveedorDeImagenes;
		setPartida: unaPartida skin: unaSkin;
		yourself
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarCasillaEn: aCanvas rectangulo: unRectangulo clave: unaClave respaldo: unColor [
	"Dibuja la imagen de la casilla; si falta el PNG la reemplaza por un color plano"
	(self formaDeCasilla: unaClave)
		ifNotNil: [ :forma | aCanvas translucentImage: forma at: unRectangulo topLeft ]
		ifNil: [ aCanvas fillRectangle: (unRectangulo insetBy: 1) color: unColor ].
	^ self
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarCasillasEn: aCanvas [
	| ocupadas posicion rectangulo |
	ocupadas := partida posicionesOcupadas.
	1 to: partida filas do: [ :fila |
		1 to: partida columnas do: [ :columna |
			posicion := Posicion fila: fila columna: columna.
			rectangulo := (self origenDe: posicion) extent: tamCelda @ tamCelda.
			(partida casillaBloqueadaEn: posicion)
				ifTrue: [ self dibujarObstaculoEn: aCanvas rectangulo: rectangulo ]
				ifFalse: [
					(ocupadas includes: posicion)
						ifTrue: [ self dibujarRecorridaEn: aCanvas rectangulo: rectangulo ]
						ifFalse: [ self dibujarLibreEn: aCanvas rectangulo: rectangulo ] ] ] ].
	^ self
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarEscenarioEn: aCanvas [
	| marco |
	marco := self marco.
	EstiloLongcat
		caja: (marco translateBy: 4 @ 4)
		relleno: (Color black alpha: 0.35)
		borde: nil
		grosor: 3
		sobre: aCanvas.
	EstiloLongcat
		caja: marco
		relleno: EstiloLongcat colorMarco
		borde: tema colorMarco
		grosor: 3
		sobre: aCanvas.
	^ self
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarFiltrosEn: aCanvas [
	"El tablero ilustrado no lleva el efecto de monitor"
	^ self
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarLibreEn: aCanvas rectangulo: unRectangulo [
	^ self
		dibujarCasillaEn: aCanvas
		rectangulo: unRectangulo
		clave: tema claveCasillaLibre
		respaldo: (EstiloLongcat colorVerde mixed: 0.3 with: EstiloLongcat colorPantalla)
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarObstaculoEn: aCanvas rectangulo: unRectangulo [
	"El obstaculo es un bloque con fondo transparente: se apoya sobre una casilla libre"
	(self formaDeCasilla: tema claveObstaculo)
		ifNil: [ ^ self dibujarBloqueEn: aCanvas casilla: unRectangulo ].
	self dibujarLibreEn: aCanvas rectangulo: unRectangulo.
	aCanvas translucentImage: (self formaDeCasilla: tema claveObstaculo) at: unRectangulo topLeft.
	^ self
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> dibujarRecorridaEn: aCanvas rectangulo: unRectangulo [
	^ self
		dibujarCasillaEn: aCanvas
		rectangulo: unRectangulo
		clave: tema claveCasillaRecorrida
		respaldo: (EstiloLongcat colorPizarra mixed: 0.5 with: EstiloLongcat colorPantalla)
]

{ #category : 'private - drawing' }
TableroTematicoMorph >> formaDeCasilla: unaClave [
	"Imagen del tema escalada al tamano de la casilla (se guarda hasta que cambie el tamano)"
	tamanoDeFormas = tamCelda ifFalse: [
		formasDeCasilla removeAll.
		tamanoDeFormas := tamCelda ].
	^ formasDeCasilla at: unaClave ifAbsentPut: [
		(imagenes imagen: unaClave) ifNotNil: [ :original |
			original scaledToSize: tamCelda @ tamCelda ] ]
]

{ #category : 'initialization' }
TableroTematicoMorph >> initialize [
	super initialize.
	borde := 8.
	barra := 0.
	pie := 0.
	formasDeCasilla := Dictionary new.
	tamanoDeFormas := 0.
	^ self
]

{ #category : 'initialization' }
TableroTematicoMorph >> setTema: unTema imagenes: unProveedorDeImagenes [
	tema := unTema.
	imagenes := unProveedorDeImagenes.
	^ self
]
