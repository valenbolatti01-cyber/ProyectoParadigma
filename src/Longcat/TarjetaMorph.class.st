"
Tarjeta con marco de neon, imagen en el centro y un cartel con el titulo abajo (Minecraft, Pokemon, Dragon Ball, skins). Puede mostrar una insignia, por ejemplo EQUIPADO.
"
Class {
	#name : 'TarjetaMorph',
	#superclass : 'BotonImagenMorph',
	#instVars : [
		'titulo',
		'simbolo',
		'insignia'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'private - drawing' }
TarjetaMorph >> colorRelleno [
	^ resaltado
		ifTrue: [ EstiloLongcat colorTarjeta mixed: 0.85 with: colorBorde ]
		ifFalse: [ EstiloLongcat colorTarjeta ]

]

{ #category : 'private - drawing' }
TarjetaMorph >> dibujarCuadritosEn: aCanvas caja: unRectangulo [
	"Cuadraditos transparentes de decoracion, como en el diseno"
	| lado |
	lado := (unRectangulo width * 0.06) rounded max: 3.
	#(#(0.08 0.08) #(0.16 0.2) #(0.8 0.1) #(0.86 0.24) #(0.1 0.62)) do: [ :proporcion |
		aCanvas
			fillRectangle: (((unRectangulo left + (unRectangulo width * proporcion first) rounded)
				@ (unRectangulo top + (unRectangulo height * proporcion last) rounded)) extent: lado @ lado)
			color: (EstiloLongcat colorLavanda alpha: 0.07) ].
	^ self

]

{ #category : 'private - drawing' }
TarjetaMorph >> dibujarInsigniaEn: aCanvas caja: unRectangulo grosor: unGrosor [
	| fuente ancho alto lugar |
	fuente := EstiloLongcat fuenteNegrita: ((unRectangulo height * 0.05) rounded max: 7).
	ancho := (fuente widthOfString: insignia) + 16.
	alto := fuente height + 6.
	lugar := ((unRectangulo right - ancho - (unGrosor * 3)) @ (unRectangulo top + (unGrosor * 3))) extent: ancho @ alto.
	EstiloLongcat caja: lugar relleno: EstiloLongcat colorVerde borde: nil grosor: 2 sobre: aCanvas.
	EstiloLongcat texto: insignia centradoEn: lugar center fuente: fuente color: EstiloLongcat colorMarco sobre: aCanvas.
	^ self

]

{ #category : 'private - drawing' }
TarjetaMorph >> dibujarTituloEn: aCanvas chip: unRectangulo grosor: unGrosor [
	"Achica la letra hasta que el titulo entre en el cartel"
	| tamano fuente |
	tamano := (unRectangulo height * 0.36) rounded.
	fuente := EstiloLongcat fuenteNegrita: tamano.
	[ (fuente widthOfString: titulo) > (unRectangulo width - (4 * unGrosor)) and: [ tamano > 7 ] ] whileTrue: [
		tamano := tamano - 1.
		fuente := EstiloLongcat fuenteNegrita: tamano ].
	EstiloLongcat texto: titulo centradoEn: unRectangulo center fuente: fuente color: Color white sobre: aCanvas.
	^ self

]

{ #category : 'drawing' }
TarjetaMorph >> drawOn: aCanvas [
	| chipAlto grosor exterior caja area imagen chip |
	chipAlto := (self height * 0.19) rounded.
	grosor := ((self width * 0.016) rounded max: 2) + (resaltado ifTrue: [ 1 ] ifFalse: [ 0 ]).
	exterior := self topLeft corner: (self right @ (self bottom - (chipAlto // 2) + grosor)).
	caja := self topLeft + grosor corner: (self right - grosor) @ (self bottom - (chipAlto // 2)).
	"Brillo de neon alrededor y marco"
	EstiloLongcat
		caja: exterior
		relleno: nil
		borde: (colorBorde alpha: (resaltado ifTrue: [ 0.45 ] ifFalse: [ 0.25 ]))
		grosor: grosor
		sobre: aCanvas.
	EstiloLongcat caja: caja relleno: self colorRelleno borde: colorBorde grosor: grosor sobre: aCanvas.
	self dibujarCuadritosEn: aCanvas caja: caja.
	"Imagen (o simbolo) en el centro"
	area := ((caja left + (caja width * 0.2) rounded) @ (caja top + (caja height * 0.12) rounded))
		corner: ((caja right - (caja width * 0.2) rounded) @ (caja bottom - chipAlto)).
	resaltado ifTrue: [ area := area expandBy: (caja width * 0.03) rounded ].
	imagen := self formaAjustadaA: area extent.
	imagen
		ifNotNil: [ aCanvas translucentImage: imagen at: area center - (imagen extent // 2) ]
		ifNil: [
			simbolo ifNotNil: [
				EstiloLongcat
					texto: simbolo
					centradoEn: area center
					fuente: (EstiloLongcat fuenteNegrita: (area height * 0.45) rounded)
					color: (colorBorde alpha: 0.8)
					sobre: aCanvas ] ].
	"Cartel con el titulo, montado sobre el borde de abajo"
	chip := Rectangle center: (caja center x @ caja bottom) extent: ((caja width * 0.74) rounded @ chipAlto).
	EstiloLongcat caja: chip relleno: EstiloLongcat colorFondoArriba borde: colorBorde grosor: grosor sobre: aCanvas.
	titulo ifNotNil: [ self dibujarTituloEn: aCanvas chip: chip grosor: grosor ].
	insignia ifNotNil: [ self dibujarInsigniaEn: aCanvas caja: caja grosor: grosor ]

]

{ #category : 'accessing' }
TarjetaMorph >> insignia: unTextoONil [
	insignia := unTextoONil.
	self changed

]

{ #category : 'accessing' }
TarjetaMorph >> simbolo: unTexto [
	"Texto grande que se muestra cuando la tarjeta no tiene imagen (por ejemplo '?')"
	simbolo := unTexto.
	self changed

]

{ #category : 'accessing' }
TarjetaMorph >> titulo: unTexto [
	titulo := unTexto.
	self changed

]
