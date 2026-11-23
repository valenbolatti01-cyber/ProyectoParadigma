"
Panel de reglas de un mundo ilustrado: titulo del mundo, leyenda de los elementos del tablero (casilla libre, recorrida y obstaculo) y cuantos movimientos hacen falta para cada cantidad de estrellas. Todo el contenido sale del TemaTematico y del rango del nivel actual.
"
Class {
	#name : 'PanelReglasMorph',
	#superclass : 'PanelLongcatMorph',
	#instVars : [
		'tema',
		'rango'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
PanelReglasMorph class >> controlador: unControlador tema: unTema [
	^ (self controlador: unControlador) setTema: unTema
]

{ #category : 'updating' }
PanelReglasMorph >> actualizarConProgreso: unProgreso [
	rango := unProgreso nivelActualObjeto rango.
	self changed.
	^ self
]

{ #category : 'private - drawing' }
PanelReglasMorph >> dibujarEstrellasEn: aCanvas desde: unY [
	"Una fila por calificacion: las estrellas doradas y hasta cuantos movimientos se consiguen"
	| fuente y forma |
	rango estaDefinido ifFalse: [ ^ unY ].
	fuente := EstiloLongcat fuente: 11.
	forma := controlador forma: #estrellaDorada ajustadaA: 45 @ 30.
	y := unY.
	3 to: 1 by: -1 do: [ :estrellas |
		1 to: estrellas do: [ :indice | | centro |
			centro := (self left + 28 + ((indice - 1) * 17)) @ (y + 11).
			forma
				ifNotNil: [ aCanvas translucentImage: forma at: centro - (forma extent // 2) ]
				ifNil: [ aCanvas fillOval: (Rectangle center: centro extent: 10 @ 10) color: EstiloLongcat colorAmarillo ] ].
		aCanvas
			drawString: 'hasta ', (rango limiteSuperiorDeEstrellas: estrellas) asString
			at: (self left + 84) @ (y + 3)
			font: fuente
			color: EstiloLongcat colorCrema.
		y := y + 24 ].
	^ y
]

{ #category : 'private - drawing' }
PanelReglasMorph >> dibujarLeyendaEn: aCanvas desde: unY [
	| fuente y |
	fuente := EstiloLongcat fuente: 11.
	y := unY.
	tema entradasDeLeyenda do: [ :entrada | | icono |
		icono := controlador forma: entrada key ajustadaA: 30 @ 30.
		icono
			ifNotNil: [ aCanvas translucentImage: icono at: (self left + 16) @ y ]
			ifNil: [ aCanvas fillRectangle: ((self left + 16) @ y extent: 30 @ 30) color: EstiloLongcat colorPizarra ].
		aCanvas
			drawString: entrada value
			at: (self left + 56) @ (y + 8)
			font: fuente
			color: EstiloLongcat colorCrema.
		y := y + 36 ].
	^ y
]

{ #category : 'drawing' }
PanelReglasMorph >> drawOn: aCanvas [
	| y |
	EstiloLongcat
		caja: self bounds
		relleno: (EstiloLongcat colorTarjeta alpha: 0.92)
		borde: tema colorMarco
		grosor: 2
		sobre: aCanvas.
	y := self top + 8.
	y := self mostrarTituloEn: aCanvas desde: y.
	y := self mostrarSeparadorEn: aCanvas desde: y.
	y := self dibujarLeyendaEn: aCanvas desde: y + 2.
	y := self mostrarSeparadorEn: aCanvas desde: y.
	self dibujarEstrellasEn: aCanvas desde: y + 2
]

{ #category : 'private - drawing' }
PanelReglasMorph >> mostrarSeparadorEn: aCanvas desde: unY [
	| forma |
	forma := controlador forma: tema claveSeparador ajustadaAAncho: self width - 56.
	forma ifNil: [ ^ unY + 4 ].
	aCanvas translucentImage: forma at: (self center x - (forma width // 2)) @ unY.
	^ unY + forma height
]

{ #category : 'private - drawing' }
PanelReglasMorph >> mostrarTituloEn: aCanvas desde: unY [
	| forma |
	forma := controlador forma: tema claveTituloReglas ajustadaAAncho: self width - 16.
	forma ifNil: [
		EstiloLongcat
			texto: 'Reglas'
			centradoEn: self center x @ (unY + 14)
			fuente: (EstiloLongcat fuenteNegrita: 13)
			color: Color white
			sobre: aCanvas.
		^ unY + 30 ].
	aCanvas translucentImage: forma at: (self center x - (forma width // 2)) @ unY.
	^ unY + forma height
]

{ #category : 'layout' }
PanelReglasMorph >> reacomodar [
	^ self
]

{ #category : 'initialization' }
PanelReglasMorph >> setTema: unTema [
	tema := unTema.
	^ self
]
