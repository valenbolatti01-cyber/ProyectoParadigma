"
Menu de niveles personalizados: Minecraft, Pokemon y Dragon Ball. Por ahora las tarjetas no tienen accion (se desarrollan despues).
"
Class {
	#name : 'MenuPersonalizadosMorph',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'volver',
		'tarjetas'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'building' }
MenuPersonalizadosMorph >> construir [
	volver := self botonVolver.
	tarjetas := {
		self tarjeta: #minecraft titulo: 'Minecraft' color: EstiloLongcat colorVerde.
		self tarjeta: #pokemon titulo: 'Pokémon' color: EstiloLongcat colorRosa.
		self tarjeta: #dragonBall titulo: 'Dragon Ball' color: EstiloLongcat colorNaranja }.
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
	self dibujarPie: 'Próximamente: niveles temáticos para cada mundo' sobre: aCanvas

]

{ #category : 'building' }
MenuPersonalizadosMorph >> tarjeta: unaClave titulo: unTitulo color: unColor [
	"Sin accion por ahora: los niveles de cada mundo se desarrollan despues"
	^ (TarjetaMorph imagen: (self imagen: unaClave) accion: nil de: app)
		titulo: unTitulo;
		colorBorde: unColor;
		yourself

]

{ #category : 'layout' }
MenuPersonalizadosMorph >> ubicarElementos [
	volver ifNil: [ ^ self ].
	volver bounds: (self virtual: (55 @ 45 extent: 95 @ 75)).
	tarjetas withIndexDo: [ :tarjeta :indice |
		tarjeta bounds: (self virtual: ((110 + ((indice - 1) * 387)) @ 300 extent: 345 @ 330)) ].
	^ self

]
