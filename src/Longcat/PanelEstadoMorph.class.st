"
Componente cohesivo de interfaz que muestra la informacion del nivel, casillas libres, longitud del gato, estado de la partida y avatar del protagonista.
"
Class {
	#name : 'PanelEstadoMorph',
	#superclass : 'PanelLongcatMorph',
	#instVars : [
		'textoColeccion',
		'textoNivel',
		'textoEstado',
		'textoLongitud',
		'textoLibres',
		'avatar',
		'formaProtagonista'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'updating' }
PanelEstadoMorph >> actualizarConPartida: unaPartida progreso: unProgreso [
    textoColeccion contents: unProgreso coleccionNiveles nombre.
    textoNivel contents: 'Nivel ', unProgreso nivelActual asString, ' de ', unProgreso cantidadNiveles asString.
    textoEstado contents: (self mensajeEstadoParaPartida: unaPartida progreso: unProgreso).
    textoEstado color: (self colorParaEstado: unaPartida estado).
    textoLongitud contents: 'Longitud: ', unaPartida longitudGato asString.
    textoLibres contents: 'Casillas libres: ', unaPartida cantidadDisponibles asString.
    avatar := unProgreso skinActual avatarEscaladoA: 108 @ 108.
    self changed.
    ^ self
]

{ #category : 'private - updating' }
PanelEstadoMorph >> colorParaEstado: unEstado [
    | colores |
    colores := {
        #activa -> EstiloLongcat colorVerde.
        #victoria -> EstiloLongcat colorAmarillo.
        #derrota -> EstiloLongcat colorRojoAlerta } asDictionary.
    ^ colores at: unEstado ifAbsent: [ EstiloLongcat colorCrema ]
]

{ #category : 'building' }
PanelEstadoMorph >> construirEtiquetas [
    textoColeccion := self nuevoTexto: '' color: EstiloLongcat colorLavanda tamano: 11.
    textoNivel := self nuevoTexto: '' color: EstiloLongcat colorNaranja tamano: 14.
    textoEstado := self nuevoTexto: '' color: EstiloLongcat colorVerde tamano: 12.
    textoLongitud := self nuevoTexto: '' color: EstiloLongcat colorCrema tamano: 11.
    textoLibres := self nuevoTexto: '' color: EstiloLongcat colorCrema tamano: 11.
    self reacomodar.
    ^ self
]

{ #category : 'private - drawing' }
PanelEstadoMorph >> dibujarAvatarEn: aCanvas [
    | centroX arriba globo fuente |
    self height < 290 ifTrue: [ ^ self ].
    arriba := self bottom - 178.
    centroX := self left + (self width // 2).
    fuente := EstiloLongcat fuente: 11.
    formaProtagonista
        ifNotNil: [
            aCanvas
                fillOval: (Rectangle center: centroX @ (arriba + 62) extent: 170 @ 114)
                color: (EstiloLongcat colorMorado alpha: 0.18).
            aCanvas translucentImage: formaProtagonista at: (centroX - (formaProtagonista width // 2)) @ (arriba + 118 - formaProtagonista height) ]
        ifNil: [
            avatar ifNil: [ ^ self ].
            aCanvas
                fillOval: (Rectangle center: centroX @ (arriba + 56) extent: 126 @ 126)
                color: (EstiloLongcat colorMorado alpha: 0.22).
            aCanvas translucentImage: avatar at: (centroX - (avatar width // 2)) @ arriba.
            globo := ((centroX + 34) @ (arriba - 6)) extent: 44 @ 24.
            aCanvas fillRectangle: globo color: EstiloLongcat colorMarcoMonitor.
            aCanvas frameRectangle: globo width: 2 color: EstiloLongcat colorCrema.
            aCanvas drawString: '</>' at: (globo left + 12) @ (globo top + 4) font: fuente color: EstiloLongcat colorVerde ].
    EstiloLongcat
        texto: 'Longcat - Protagonista'
        centradoEn: centroX @ (arriba + 132)
        fuente: fuente
        color: EstiloLongcat colorNaranja
        sobre: aCanvas.
    EstiloLongcat
        texto: 'Nerd, gamer y adicto al cafe'
        centradoEn: centroX @ (arriba + 150)
        fuente: (EstiloLongcat fuente: 10)
        color: EstiloLongcat colorLavandaSuave
        sobre: aCanvas.
    ^ self
]

{ #category : 'drawing' }
PanelEstadoMorph >> drawOn: aCanvas [
    EstiloLongcat dibujarPanel: self bounds titulo: 'Estado' en: aCanvas.
    self dibujarAvatarEn: aCanvas
]

{ #category : 'accessing' }
PanelEstadoMorph >> formaProtagonista: unaForma [
    "Se ajusta a la caja de 176 x 118 conservando la proporcion de cada imagen"
    formaProtagonista := unaForma ifNotNil: [ | factor |
        factor := (176 / unaForma width) min: (118 / unaForma height).
        unaForma scaledToSize: (unaForma extent * factor) rounded ].
    self changed.
    ^ self
]

{ #category : 'initialization' }
PanelEstadoMorph >> initialize [
    super initialize.
    self extent: 228 @ 340.
    self construirEtiquetas.
    ^ self
]

{ #category : 'private - updating' }
PanelEstadoMorph >> mensajeEstadoParaPartida: unaPartida progreso: unProgreso [
    | mensajes |
    mensajes := {
        #activa -> 'Estado: En juego'.
        #victoria -> (unProgreso esUltimoNivel
            ifTrue: [ 'Completaste todos los niveles' ]
            ifFalse: [ 'Nivel completado!' ]).
        #derrota -> 'Sin espacio. Reiniciando...' } asDictionary.
    ^ mensajes at: unaPartida estado ifAbsent: [ unaPartida estado asString ]
]

{ #category : 'layout' }
PanelEstadoMorph >> reacomodar [
    | origen |
    textoNivel ifNil: [ ^ self ].
    origen := self position.
    textoColeccion position: origen + (16 @ 28).
    textoNivel position: origen + (16 @ 48).
    textoEstado position: origen + (16 @ 76).
    textoLongitud position: origen + (16 @ 102).
    textoLibres position: origen + (16 @ 124).
    ^ self
]
