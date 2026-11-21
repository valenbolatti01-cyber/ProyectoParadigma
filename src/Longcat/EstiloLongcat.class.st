"
Paleta de colores, fuentes y formas pixel art compartidas por todas las pantallas de Longcat. Centraliza todo el estilo visual del juego.
"
Class {
	#name : 'EstiloLongcat',
	#superclass : 'Object',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'dibujo' }
EstiloLongcat class >> caja: unRectangulo relleno: unRelleno borde: unBorde grosor: unGrosor sobre: aCanvas [
	"Caja con las esquinas recortadas en escalon, estilo pixel art. Relleno o borde pueden ser nil."
	| r g |
	r := unRectangulo.
	g := unGrosor max: 1.
	unRelleno ifNotNil: [
		unBorde
			ifNil: [
				aCanvas fillRectangle: ((r left @ (r top + g)) corner: (r right @ (r bottom - g))) color: unRelleno.
				aCanvas fillRectangle: (((r left + g) @ r top) corner: ((r right - g) @ (r top + g))) color: unRelleno.
				aCanvas fillRectangle: (((r left + g) @ (r bottom - g)) corner: ((r right - g) @ r bottom)) color: unRelleno ]
			ifNotNil: [ aCanvas fillRectangle: (r insetBy: g) color: unRelleno ] ].
	unBorde ifNil: [ ^ self ].
	aCanvas fillRectangle: (((r left + g) @ r top) corner: ((r right - g) @ (r top + g))) color: unBorde.
	aCanvas fillRectangle: (((r left + g) @ (r bottom - g)) corner: ((r right - g) @ r bottom)) color: unBorde.
	aCanvas fillRectangle: ((r left @ (r top + g)) corner: ((r left + g) @ (r bottom - g))) color: unBorde.
	aCanvas fillRectangle: (((r right - g) @ (r top + g)) corner: (r right @ (r bottom - g))) color: unBorde.
	^ self
]

{ #category : 'dibujo' }
EstiloLongcat class >> chispasEn: unPunto tamano: unLado sobre: aCanvas [
	"Tres rayitas amarillas, como las del diseno del menu"
	| q color |
	q := unLado max: 2.
	color := self colorAmarillo.
	aCanvas fillRectangle: ((unPunto + (0 @ (q * 2))) extent: q @ (q * 3)) color: color.
	0 to: 2 do: [ :indice |
		aCanvas
			fillRectangle: ((unPunto + (((q * 3) + (indice * q)) @ ((q * 2) - (indice * q)))) extent: q @ q)
			color: color ].
	aCanvas fillRectangle: ((unPunto + ((q * 4) @ (q * 5))) extent: (q * 3) @ q) color: color.
	^ self
]

{ #category : 'colores' }
EstiloLongcat class >> colorAmarillo [
	^ Color r: 255 g: 214 b: 64 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorCrema [
	^ Color r: 245 g: 214 b: 160 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorFondoAbajo [
	^ Color r: 52 g: 29 b: 92 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorFondoArriba [
	^ Color r: 40 g: 21 b: 76 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorGrisBloqueado [
	^ Color r: 90 g: 98 b: 120 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorLavanda [
	^ Color r: 216 g: 154 b: 255 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorLavandaSuave [
	^ Color r: 190 g: 178 b: 230 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorMarco [
	^ Color r: 24 g: 14 b: 44 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorMarcoMonitor [
	^ Color r: 26 g: 29 b: 38 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorMorado [
	^ Color r: 139 g: 115 b: 214 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorNaranja [
	^ Color r: 233 g: 154 b: 69 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorPantalla [
	^ Color r: 16 g: 19 b: 27 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorPiso [
	^ Color r: 28 g: 15 b: 56 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorPizarra [
	^ Color r: 52 g: 59 b: 73 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorRayas [
	^ Color r: 196 g: 110 b: 40 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorRojoAlerta [
	^ Color r: 255 g: 105 b: 120 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorRosa [
	^ Color r: 255 g: 92 b: 122 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorRosaConfeti [
	^ Color r: 255 g: 105 b: 150 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorTarjeta [
	^ Color r: 47 g: 28 b: 85 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorVerde [
	^ Color r: 140 g: 203 b: 103 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorVerdeDesbloqueado [
	^ Color r: 102 g: 204 b: 153 range: 255
]

{ #category : 'colores' }
EstiloLongcat class >> colorVioleta [
	^ Color r: 166 g: 107 b: 255 range: 255
]

{ #category : 'dibujo' }
EstiloLongcat class >> dibujarPanel: unRectangulo titulo: unTitulo en: aCanvas [
	"Tarjeta violeta con borde neon y etiqueta superior contenida dentro del rectangulo"
	| caja fuente anchoIcono anchoTitulo chip |
	caja := (unRectangulo left @ (unRectangulo top + 11))
		corner: ((unRectangulo right - 4) @ (unRectangulo bottom - 4)).
	aCanvas fillRectangle: (caja translateBy: 4 @ 4) color: (Color black alpha: 0.35).
	aCanvas fillRectangle: caja color: (self colorTarjeta alpha: 0.92).
	aCanvas frameRectangle: caja width: 2 color: self colorMorado.
	fuente := self fuente: 11.
	anchoIcono := fuente widthOfString: '</>'.
	anchoTitulo := fuente widthOfString: unTitulo.
	chip := ((caja left + 12) @ unRectangulo top) extent: (anchoIcono + anchoTitulo + 24) @ 22.
	aCanvas fillRectangle: chip color: self colorMorado.
	aCanvas frameRectangle: chip width: 1 color: self colorCrema.
	aCanvas drawString: '</>' at: (chip left + 7) @ (chip top + 3) font: fuente color: self colorVerde.
	aCanvas drawString: unTitulo at: (chip left + anchoIcono + 14) @ (chip top + 3) font: fuente color: Color white.
	^ self
]

{ #category : 'dibujo' }
EstiloLongcat class >> flechaEn: unRectangulo color: unColor sobre: aCanvas [
	"Flecha hacia la izquierda hecha con cuadraditos (boton de volver)"
	| q centro punta |
	q := ((unRectangulo height * 0.12) rounded) max: 2.
	centro := unRectangulo center.
	punta := centro x - ((q * 7) // 2).
	0 to: 2 do: [ :indice |
		aCanvas
			fillRectangle: (((punta + (indice * q)) @ (centro y - (indice * q) - (q // 2))) extent: q @ ((2 * indice * q) + q))
			color: unColor ].
	aCanvas
		fillRectangle: (((punta + (2 * q)) @ (centro y - (q // 2))) extent: (q * 5) @ q)
		color: unColor.
	^ self
]

{ #category : 'fuentes' }
EstiloLongcat class >> fuente: unTamano [
	^ LogicalFont familyName: 'Source Sans Pro' pointSize: (unTamano max: 7)
]

{ #category : 'fuentes' }
EstiloLongcat class >> fuenteCodigo: unTamano [
	^ [ LogicalFont familyName: 'Source Code Pro' pointSize: (unTamano max: 7) ]
		on: Error
		do: [ :error | self fuente: unTamano ]
]

{ #category : 'fuentes' }
EstiloLongcat class >> fuenteNegrita: unTamano [
	^ [ LogicalFont
			familyName: 'Source Sans Pro'
			pointSize: (unTamano max: 7)
			stretchValue: 5
			weightValue: 700
			slantValue: 0 ]
		on: Error
		do: [ :error | self fuente: unTamano ]
]

{ #category : 'dibujo' }
EstiloLongcat class >> texto: unTexto centradoEn: unPunto fuente: unaFuente color: unColor sobre: aCanvas [
	| ancho |
	ancho := unaFuente widthOfString: unTexto.
	aCanvas
		drawString: unTexto
		at: ((unPunto x - (ancho // 2)) @ (unPunto y - (unaFuente height // 2))) rounded
		font: unaFuente
		color: unColor.
	^ self
]
