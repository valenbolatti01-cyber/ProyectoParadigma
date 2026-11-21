"
Pantalla de seleccion de SkinGato. Permite equipar las skins disponibles y muestra espacios preparados para futuras skins.
"
Class {
	#name : 'MenuSkinsMorph',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'volver',
		'tarjetas'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'building' }
MenuSkinsMorph >> construir [
	| disponibles faltantes |
	volver := self botonVolver.
	tarjetas := OrderedCollection new.
	disponibles := app skinsDisponibles.
	disponibles do: [ :unaSkin |
		tarjetas add: ((TarjetaMorph imagen: unaSkin cabezaAbajo accion: #elegirSkin: de: app)
			titulo: unaSkin nombre;
			colorBorde: unaSkin colorBorde;
			argumentos: (Array with: unaSkin);
			yourself) ].
	faltantes := (4 - disponibles size) max: 0.
	faltantes timesRepeat: [
		tarjetas add: ((TarjetaMorph imagen: nil accion: nil de: app)
			titulo: 'Próximamente';
			simbolo: '?';
			colorBorde: (EstiloLongcat colorLavanda mixed: 0.5 with: Color gray);
			yourself) ].
	self addMorph: volver.
	tarjetas do: [ :tarjeta | self addMorph: tarjeta ].
	self refrescar.
	^ self
]

{ #category : 'drawing' }
MenuSkinsMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	self dibujarLogoEn: aCanvas.
	self dibujarTitulo: 'Skins' icono: #cabezaAbajo en: (470 @ 170 extent: 400 @ 92) sobre: aCanvas.
	EstiloLongcat
		texto: 'Elegí el aspecto de Longcat'
		centradoEn: (self virtual: (670 @ 290 extent: 0 @ 0)) origin
		fuente: (EstiloLongcat fuente: ((15 * self escala) rounded max: 9))
		color: EstiloLongcat colorCrema
		sobre: aCanvas.
	self dibujarPie: 'Pronto vas a poder elegir más aspectos del gato' sobre: aCanvas
]

{ #category : 'showing' }
MenuSkinsMorph >> refrescar [
	| disponibles |
	tarjetas ifNil: [ ^ self ].
	disponibles := app skinsDisponibles.
	disponibles withIndexDo: [ :unaSkin :indice |
		(tarjetas at: indice) insignia: (app skinActual = unaSkin
			ifTrue: [ 'EQUIPADO' ]
			ifFalse: [ nil ]) ].
	self changed.
	^ self
]

{ #category : 'layout' }
MenuSkinsMorph >> ubicarElementos [
	volver ifNil: [ ^ self ].
	volver bounds: (self virtual: (55 @ 45 extent: 95 @ 75)).
	tarjetas withIndexDo: [ :tarjeta :indice |
		tarjeta bounds: (self virtual: ((110 + ((indice - 1) * 290)) @ 320 extent: 250 @ 300)) ].
	^ self
]
