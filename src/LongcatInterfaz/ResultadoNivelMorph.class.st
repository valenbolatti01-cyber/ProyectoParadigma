"
Cartel de resultado al completar un nivel de un mundo: panel retro con las estrellas ganadas, los movimientos realizados y los botones Reintentar y Siguiente nivel. Reutiliza el velo y el confeti de VictoriaMorph pero, a diferencia de ella, espera a que el jugador elija en lugar de cerrarse sola.
"
Class {
	#name : 'ResultadoNivelMorph',
	#superclass : 'VictoriaMorph',
	#instVars : [
		'pantalla',
		'estrellas',
		'hayNivelSiguiente',
		'alReintentar'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
ResultadoNivelMorph class >> sobre: unaPantalla centro: unPunto mensaje: unMensaje detalle: unDetalle estrellas: unaCantidadDeEstrellas hayNivelSiguiente: unBooleano alSiguiente: unBloqueSiguiente alReintentar: unBloqueReintentar [
	^ (self sobre: unaPantalla centro: unPunto mensaje: unMensaje detalle: unDetalle alTerminar: unBloqueSiguiente)
		setPantalla: unaPantalla
		estrellas: unaCantidadDeEstrellas
		hayNivelSiguiente: unBooleano
		alReintentar: unBloqueReintentar
]

{ #category : 'private - building' }
ResultadoNivelMorph >> botonesVisibles [
	^ transcurrido >= 1100
]

{ #category : 'event handling' }
ResultadoNivelMorph >> clickEn: unPunto [
	"Solo responde a los botones una vez que terminaron de aparecer"
	self botonesVisibles ifFalse: [ ^ self ].
	(self rectanguloBotonReintentar containsPoint: unPunto)
		ifTrue: [ ^ self terminarCon: alReintentar ].
	(hayNivelSiguiente and: [ self rectanguloBotonSiguiente containsPoint: unPunto ])
		ifTrue: [ ^ self terminarCon: alTerminar ].
	^ self
]

{ #category : 'private - drawing' }
ResultadoNivelMorph >> dibujarBotonesEn: aCanvas [
	| reintentar siguiente |
	self botonesVisibles ifFalse: [ ^ self ].
	reintentar := self rectanguloBotonReintentar.
	self dibujarImagen: #botonReintentar en: reintentar sobre: aCanvas textoDeRespaldo: 'Reintentar'.
	hayNivelSiguiente ifFalse: [ ^ self ].
	siguiente := self rectanguloBotonSiguiente.
	self dibujarImagen: #botonSiguienteNivel en: siguiente sobre: aCanvas textoDeRespaldo: 'Siguiente nivel'.
	^ self
]

{ #category : 'private - drawing' }
ResultadoNivelMorph >> dibujarCartelEn: aCanvas [
	| panel |
	transcurrido < 150 ifTrue: [ ^ self ].
	panel := self rectanguloPanel.
	self dibujarImagen: #panelResultado en: panel sobre: aCanvas textoDeRespaldo: nil.
	EstiloLongcat
		texto: mensaje
		centradoEn: panel center x @ (panel top + 40)
		fuente: (EstiloLongcat fuenteNegrita: 20)
		color: self colorTitulo
		sobre: aCanvas.
	self dibujarEstrellasEn: aCanvas panel: panel.
	EstiloLongcat
		texto: detalle
		centradoEn: panel center x @ (panel top + 176)
		fuente: (EstiloLongcat fuente: 12)
		color: Color white
		sobre: aCanvas.
	self dibujarBotonesEn: aCanvas.
	^ self
]

{ #category : 'private - drawing' }
ResultadoNivelMorph >> dibujarEstrellasEn: aCanvas panel: unRectangulo [
	"Las estrellas ganadas aparecen una tras otra; las que no se ganaron quedan grises"
	1 to: 3 do: [ :indice | | forma centro ganada |
		ganada := indice <= estrellas and: [ transcurrido >= (350 + (indice * 220)) ].
		forma := pantalla
			forma: (ganada ifTrue: [ #estrellaDorada ] ifFalse: [ #estrellaGris ])
			ajustadaA: 135 @ 90.
		centro := (unRectangulo center x + ((indice - 2) * 82)) @ (unRectangulo top + 108).
		forma
			ifNotNil: [ aCanvas translucentImage: forma at: centro - (forma extent // 2) ]
			ifNil: [
				aCanvas
					fillOval: (Rectangle center: centro extent: 40 @ 40)
					color: (ganada ifTrue: [ EstiloLongcat colorAmarillo ] ifFalse: [ EstiloLongcat colorGrisBloqueado ]) ] ].
	^ self
]

{ #category : 'private - drawing' }
ResultadoNivelMorph >> dibujarImagen: unaClave en: unRectangulo sobre: aCanvas textoDeRespaldo: unTexto [
	| forma |
	forma := pantalla forma: unaClave ajustadaA: unRectangulo extent.
	forma
		ifNotNil: [ aCanvas translucentImage: forma at: unRectangulo topLeft ]
		ifNil: [
			EstiloLongcat
				caja: unRectangulo
				relleno: EstiloLongcat colorTarjeta
				borde: EstiloLongcat colorMorado
				grosor: 3
				sobre: aCanvas.
			unTexto ifNotNil: [
				EstiloLongcat
					texto: unTexto
					centradoEn: unRectangulo center
					fuente: (EstiloLongcat fuenteNegrita: 13)
					color: Color white
					sobre: aCanvas ] ].
	^ self
]

{ #category : 'initialization' }
ResultadoNivelMorph >> initialize [
	super initialize.
	"No se cierra sola: espera a que el jugador elija un boton"
	duracion := SmallInteger maxVal.
	^ self
]

{ #category : 'animation' }
ResultadoNivelMorph >> mostrarCompleto [
	"Salta la animacion de entrada: el cartel, las estrellas y los botones quedan visibles"
	transcurrido := 5000.
	^ self
]

{ #category : 'event handling' }
ResultadoNivelMorph >> mouseDown: anEvent [
	^ self clickEn: anEvent position
]

{ #category : 'private - drawing' }
ResultadoNivelMorph >> progreso [
	"Solo anima el velo: el cartel no escala para no reescalar las imagenes en cada cuadro"
	^ (transcurrido / 500) min: 1
]

{ #category : 'layout' }
ResultadoNivelMorph >> rectanguloBotonReintentar [
	| panel ancho |
	panel := self rectanguloPanel.
	ancho := 164.
	^ hayNivelSiguiente
		ifTrue: [ ((panel left + 24) @ (panel bottom - 76)) extent: ancho @ 55 ]
		ifFalse: [ ((panel center x - (ancho // 2)) @ (panel bottom - 76)) extent: ancho @ 55 ]
]

{ #category : 'layout' }
ResultadoNivelMorph >> rectanguloBotonSiguiente [
	| panel ancho |
	panel := self rectanguloPanel.
	ancho := 164.
	^ ((panel right - 24 - ancho) @ (panel bottom - 76)) extent: ancho @ 55
]

{ #category : 'layout' }
ResultadoNivelMorph >> rectanguloPanel [
	^ Rectangle center: centroCartel extent: 420 @ 280
]

{ #category : 'initialization' }
ResultadoNivelMorph >> setPantalla: unaPantalla estrellas: unaCantidadDeEstrellas hayNivelSiguiente: unBooleano alReintentar: unBloque [
	pantalla := unaPantalla.
	estrellas := unaCantidadDeEstrellas.
	hayNivelSiguiente := unBooleano.
	alReintentar := unBloque.
	^ self
]

{ #category : 'private - stepping' }
ResultadoNivelMorph >> terminarCon: unBloque [
	alTerminar := unBloque.
	^ self terminar
]
