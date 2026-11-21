"
Coordinador de vista de una partida. Compone PanelControlesMorph, PanelEstadoMorph, PanelNivelesMorph y TableroMorph, delegando estado y progresion en Partida y ProgresoJuego.
"
Class {
	#name : 'InterfazPartida',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'progreso',
		'partida',
		'vistaTablero',
		'panelControles',
		'panelEstado',
		'panelNiveles',
		'botonMenu',
		'animacion',
		'ultimoTamano'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
InterfazPartida class >> abrir [
    ^ LongcatApp abrir
]

{ #category : 'instance creation' }
InterfazPartida class >> app: unaApp progreso: unProgreso [
    ^ (self app: unaApp) setProgreso: unProgreso
]

{ #category : 'opening' }
InterfazPartida >> abrir [
    self cargarSprites.
    avatar := (sprites at: #cabezaAbajo) scaledToSize: 116 @ 116.
    self construirControles.
    self iniciarNuevaPartida.
    self openInWindowLabeled: 'Longcat.exe'.
    self startStepping.
    self takeKeyboardFocus.
    ^ self

]

{ #category : 'showing' }
InterfazPartida >> actualizarSkin [
    vistaTablero ifNotNil: [ vistaTablero skin: progreso skinActual ].
    partida ifNotNil: [ self actualizarVista ].
    ^ self
]

{ #category : 'private - updating' }
InterfazPartida >> actualizarVista [
    vistaTablero ifNotNil: [ vistaTablero changed ].
    panelEstado ifNotNil: [ panelEstado actualizarConPartida: partida progreso: progreso ].
    panelNiveles ifNotNil: [ panelNiveles actualizarConProgreso: progreso ].
    ^ self
]

{ #category : 'showing' }
InterfazPartida >> alMostrarse [
    progreso ifNil: [
        progreso := app
            ifNotNil: [ app progresoPara: ColeccionNiveles normales ]
            ifNil: [ ProgresoJuego porDefecto ] ].
    construida == true ifFalse: [
        self construir.
        construida := true ].
    partida ifNil: [ self cargarNivelActual ].
    self reacomodar.
    self enfocarTeclado.
    ^ self
]

{ #category : 'private - configuration' }
InterfazPartida >> aumentarColumnas [
    columnasConfiguradas < 12 ifTrue: [ columnasConfiguradas := columnasConfiguradas + 1 ].
    textoColumnas contents: columnasConfiguradas asString.
    ^ self
]

{ #category : 'private - configuration' }
InterfazPartida >> aumentarFilas [
    filasConfiguradas < 12 ifTrue: [ filasConfiguradas := filasConfiguradas + 1 ].
    textoFilas contents: filasConfiguradas asString.
    ^ self
]

{ #category : 'private - shake' }
InterfazPartida >> avanzarSacudida [
    | transcurrido fuerza desvio cruce |
    sacudidaInicio ifNil: [ ^ self ].
    vistaTablero ifNil: [ ^ self ].
    transcurrido := Time millisecondClockValue - sacudidaInicio.
    transcurrido >= 380 ifTrue: [
        sacudidaInicio := nil.
        vistaTablero position: self position + posicionTablero.
        ^ self ].
    fuerza := 9 * (1 - (transcurrido / 380)).
    desvio := (((transcurrido / 24.0) * Float pi) sin * fuerza) rounded.
    cruce := ((transcurrido // 30) even ifTrue: [ 1 ] ifFalse: [ -1 ]) * (fuerza / 4) rounded.
    vistaTablero position: self position + posicionTablero + (sacudidaVertical
        ifTrue: [ cruce @ desvio ]
        ifFalse: [ desvio @ cruce ]).
    ^ self
]

{ #category : 'private - layout' }
InterfazPartida >> bordeDerechoPaneles [
    ^ (self width - 16) max: 520
]

{ #category : 'private - layout' }
InterfazPartida >> bordeInferiorPaneles [
    ^ (self height - 34) max: 460
]

{ #category : 'private - actions' }
InterfazPartida >> cargarNivelActual [
    panelNiveles ifNotNil: [ panelNiveles limpiarAviso ].
    animacion ifNotNil: [ :anterior | anterior delete. animacion := nil ].
    vistaTablero ifNotNil: [ :vista | vista detenerSacudida; delete ].
    partida := Partida deNivel: progreso nivelActualObjeto.
    vistaTablero := TableroMorph
        partida: partida
        skin: progreso skinActual.
    self addMorph: vistaTablero.
    self reacomodar.
    self actualizarVista.
    ^ self
]

{ #category : 'as yet unclassified' }
InterfazPartida >> cargarSprites [
    | raiz archivos |
    raiz := (Smalltalk globals at: #LongcatApp) carpetaDeImagenes.
    archivos := {
        #cabezaAbajo -> 'Gato abajo.png'.
        #cabezaArriba -> 'Gato arriba.png'.
        #cabezaDerecha -> 'Gato derecha.png'.
        #cabezaIzquierda -> 'Gato izquierda.png' }.
    sprites := Dictionary new.
    archivos do: [ :par | | archivo |
        archivo := raiz allChildren
            detect: [ :hijo | hijo isFile and: [ hijo basename sameAs: par value ] ]
            ifNone: [ nil ].
        archivo ifNil: [
            ^ self error: 'No encuentro ', par value, ' dentro de: ', raiz fullName ].
        sprites at: par key put: (ImageReadWriter formFromFileNamed: archivo fullName) ].
    ^ sprites

]

{ #category : 'private - victory' }
InterfazPartida >> celebrarVictoria [
    | esElUltimo |
    esElUltimo := progreso esUltimoNivel.
    animacion := VictoriaMorph
        sobre: self
        centro: vistaTablero pantalla center
        mensaje: (esElUltimo
            ifTrue: [ '¡GANASTE TODO!' ]
            ifFalse: [ '¡NIVEL COMPLETADO!' ])
        detalle: (esElUltimo
            ifTrue: [ 'Completaste los ', progreso cantidadNiveles asString, ' niveles' ]
            ifFalse: [ 'Siguiente: nivel ', (progreso nivelActual + 1) asString ])
        alTerminar: [ self terminarVictoria ].
    self addMorph: animacion.
    animacion startStepping.
    ^ self
]

{ #category : 'private - layout' }
InterfazPartida >> colocar: unaClave en: unPunto [
    (elementos at: unaClave) position: self position + unPunto.
    ^ self

]

{ #category : 'private - colors' }
InterfazPartida >> colorCrema [
	^ Color r: 245 g: 214 b: 160 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorLavanda [
	^ Color r: 190 g: 178 b: 230 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorMarco [
	^ Color r: 26 g: 29 b: 38 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorMorado [
	^ Color r: 139 g: 115 b: 214 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorNaranja [
	^ Color r: 233 g: 154 b: 69 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorPizarra [
	^ Color r: 52 g: 59 b: 73 range: 255

]

{ #category : 'private - colors' }
InterfazPartida >> colorVerde [
	^ Color r: 140 g: 203 b: 103 range: 255

]

{ #category : 'private - drawing' }
InterfazPartida >> conEsquinas [
    ^ false
]

{ #category : 'building' }
InterfazPartida >> construir [
    app ifNotNil: [
        botonMenu := SimpleButtonMorph new
            label: '< Menú principal';
            target: self;
            actionSelector: #volverAlMenu;
            extent: 140 @ 30;
            yourself.
        self addMorph: botonMenu ].
    panelControles := PanelControlesMorph controlador: self.
    panelEstado := PanelEstadoMorph new.
    panelEstado formaProtagonista: (self imagen: #protagonista).
    panelNiveles := PanelNivelesMorph controlador: self.
    self addMorph: panelControles.
    self addMorph: panelEstado.
    self addMorph: panelNiveles.
    ^ self
]

{ #category : 'building' }
InterfazPartida >> construirControles [
    | texto boton |
    elementos := Dictionary new.
    botonesNivel := OrderedCollection new.
    "Volver al menu principal (solo si el juego se abrio desde LongcatApp)"
    app ifNotNil: [
        elementos at: #menu put: (self nuevoBoton: '< Menú principal' accion: #volverAlMenu en: 0 @ 0 tamano: 140 @ 30) ].
    "Panel izquierdo: controles (las posiciones las pone reacomodar)"
    texto := self nuevoTexto: 'Mover' en: 0 @ 0 tamano: 188 @ 22.
    texto color: self colorVerde.
    elementos at: #mover put: texto.
    elementos at: #arriba put: (self nuevoBoton: '^' accion: #moverArriba en: 0 @ 0 tamano: 42 @ 38).
    elementos at: #izquierda put: (self nuevoBoton: '<' accion: #moverIzquierda en: 0 @ 0 tamano: 42 @ 38).
    elementos at: #abajo put: (self nuevoBoton: 'v' accion: #moverAbajo en: 0 @ 0 tamano: 42 @ 38).
    elementos at: #derecha put: (self nuevoBoton: '>' accion: #moverDerecha en: 0 @ 0 tamano: 42 @ 38).
    textoEstado := self nuevoTexto: '' en: 0 @ 0 tamano: 200 @ 22.
    textoEstado color: self colorVerde.
    elementos at: #estado put: textoEstado.
    textoLongitud := self nuevoTexto: '' en: 0 @ 0 tamano: 200 @ 22.
    elementos at: #longitud put: textoLongitud.
    textoLibres := self nuevoTexto: '' en: 0 @ 0 tamano: 200 @ 22.
    elementos at: #libres put: textoLibres.
    texto := self nuevoTexto: 'Usa los botones o las flechas.' en: 0 @ 0 tamano: 200 @ 20.
    texto color: self colorLavanda.
    elementos at: #ayuda1 put: texto.
    texto := self nuevoTexto: 'Cada movimiento va hasta chocar.' en: 0 @ 0 tamano: 200 @ 20.
    texto color: self colorLavanda.
    elementos at: #ayuda2 put: texto.
    "Panel derecho: nivel y monitor"
    textoNivel := self nuevoTexto: '' en: 0 @ 0 tamano: 220 @ 26.
    textoNivel font: (self fuente: 14).
    textoNivel color: self colorNaranja.
    elementos at: #nivel put: textoNivel.
    elementos at: #anterior put: (self nuevoBoton: 'Nivel anterior' accion: #nivelAnterior en: 0 @ 0 tamano: 104 @ 30).
    elementos at: #siguiente put: (self nuevoBoton: 'Siguiente nivel' accion: #siguienteNivel en: 0 @ 0 tamano: 104 @ 30).
    textoAviso := self nuevoTexto: '' en: 0 @ 0 tamano: 460 @ 22.
    textoAviso font: (self fuente: 12).
    textoAviso color: (Color r: 255 g: 105 b: 120 range: 255).
    elementos at: #aviso put: textoAviso.
    textoProgreso := self nuevoTexto: '' en: 0 @ 0 tamano: 460 @ 20.
    elementos at: #progreso put: textoProgreso.
    texto := self nuevoTexto: 'Ir al nivel (se desbloquea al completar el anterior):' en: 0 @ 0 tamano: 460 @ 20.
    texto color: self colorLavanda.
    elementos at: #irA put: texto.
    1 to: (Smalltalk globals at: #Nivel) cantidad do: [ :numero |
        boton := self nuevoBoton: numero asString accion: #irANivel: en: 0 @ 0 tamano: 40 @ 30.
        boton arguments: (Array with: numero).
        botonesNivel add: boton ].
    self reacomodar.
    ^ self

]

{ #category : 'private - building' }
InterfazPartida >> construirTablero [
    "Un solo morph dibuja el monitor, el tablero y el gato continuo (ver TableroMorph). Su tamano y posicion los decide reacomodar."
    vistaTablero := (Smalltalk globals at: #TableroMorph) partida: partida sprites: sprites.
    self addMorph: vistaTablero.
    self reacomodar.
    ^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarAvatarEn: aCanvas [
    "El protagonista con su notebook abajo del panel de controles; si la ventana es muy baja, no se dibuja"
    | centroX arriba globo fuente figura |
    arriba := self top + self bordeInferiorPaneles - 204.
    arriba < (self top + 372) ifTrue: [ ^ self ].
    centroX := self left + 126.
    fuente := self fuente: 11.
    figura := self forma: #protagonista ajustadaA: 184 @ 124.
    figura
        ifNotNil: [
            aCanvas
                fillOval: (Rectangle center: centroX @ (arriba + 66) extent: 176 @ 120)
                color: (self colorMorado alpha: 0.18).
            aCanvas translucentImage: figura at: (centroX - (figura width // 2)) @ (arriba + 124 - figura height) ]
        ifNil: [
            avatar ifNil: [ ^ self ].
            aCanvas
                fillOval: (Rectangle center: centroX @ (arriba + 58) extent: 136 @ 136)
                color: (self colorMorado alpha: 0.22).
            aCanvas translucentImage: avatar at: (centroX - (avatar width // 2)) @ arriba.
            globo := ((centroX + 38) @ (arriba - 6)) extent: 44 @ 24.
            aCanvas fillRectangle: globo color: self colorMarco.
            aCanvas frameRectangle: globo width: 2 color: self colorCrema.
            aCanvas drawString: '</>' at: (globo left + 12) @ (globo top + 4) font: fuente color: self colorVerde ].
    aCanvas drawString: 'Longcat - Protagonista' at: (self left + 52) @ (arriba + 126) font: fuente color: self colorNaranja.
    aCanvas drawString: 'Nerd, gamer y adicto al cafe' at: (self left + 44) @ (arriba + 146) font: (self fuente: 10) color: self colorLavanda.
    ^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarEncabezadoEn: aCanvas [
    | franja logo fuenteTitulo fuenteNota x nota |
    franja := self topLeft extent: self width @ 70.
    aCanvas fillRectangle: franja color: (EstiloLongcat colorMarco alpha: 0.55).
    aCanvas fillRectangle: ((self left @ (franja bottom - 3)) extent: self width @ 2) color: EstiloLongcat colorMorado.
    aCanvas fillRectangle: ((self left @ (franja bottom - 1)) extent: self width @ 1) color: EstiloLongcat colorVerde.
    logo := self forma: #logo ajustadaA: 300 @ 58.
    logo
        ifNotNil: [ aCanvas translucentImage: logo at: (self left + 16) @ (self top + 6 + ((58 - logo height) // 2)) ]
        ifNil: [
            fuenteTitulo := EstiloLongcat fuente: 26.
            x := self left + 20.
            aCanvas drawString: 'LONGCAT' at: (x + 3) @ (self top + 9) font: fuenteTitulo color: EstiloLongcat colorMorado.
            aCanvas drawString: 'LONGCAT' at: x @ (self top + 6) font: fuenteTitulo color: EstiloLongcat colorCrema.
            x := x + (fuenteTitulo widthOfString: 'LONGCAT') + 2.
            aCanvas drawString: '.exe' at: x @ (self top + 6) font: fuenteTitulo color: EstiloLongcat colorVerde.
            aCanvas
                drawString: '<< El gato que llena el tablero >>'
                at: (self left + 22) @ (self top + 46)
                font: (EstiloLongcat fuente: 10)
                color: EstiloLongcat colorLavandaSuave ].
    nota := ((self right - 156) @ (self top + 10)) extent: 130 @ 48.
    aCanvas fillRectangle: (nota translateBy: 3 @ 3) color: (Color black alpha: 0.4).
    aCanvas fillRectangle: nota color: EstiloLongcat colorCrema.
    aCanvas fillRectangle: (nota topLeft extent: nota width @ 6) color: EstiloLongcat colorNaranja.
    fuenteNota := EstiloLongcat fuente: 11.
    aCanvas drawString: 'Entrega:' at: (nota left + 10) @ (nota top + 9) font: fuenteNota color: EstiloLongcat colorPizarra.
    aCanvas drawString: 'mañana 23:59' at: (nota left + 10) @ (nota top + 26) font: fuenteNota color: EstiloLongcat colorPizarra.
    ^ self
]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarMarcaDeAguaEn: aCanvas [
    | texto fuente ancho |
    texto := 'UTN FRRe - Paradigmas de Programación - Grupo 33'.
    fuente := EstiloLongcat fuente: 10.
    ancho := fuente widthOfString: texto.
    aCanvas
        drawString: texto
        at: (self center x - (ancho // 2)) @ (self bottom - 22)
        font: fuente
        color: (EstiloLongcat colorLavandaSuave alpha: 0.75).
    ^ self
]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarPanel: unRectangulo titulo: unTitulo en: aCanvas [
    "Tarjeta violeta con borde neon y una etiqueta arriba (mismos tonos que los menus)"
    | caja fuente anchoIcono anchoTitulo chip |
    caja := unRectangulo translateBy: self position.
    aCanvas fillRectangle: (caja translateBy: 4 @ 4) color: (Color black alpha: 0.35).
    aCanvas fillRectangle: caja color: (EstiloLongcat colorTarjeta alpha: 0.92).
    aCanvas frameRectangle: caja width: 2 color: self colorMorado.
    fuente := self fuente: 11.
    anchoIcono := fuente widthOfString: '</>'.
    anchoTitulo := fuente widthOfString: unTitulo.
    chip := ((caja left + 12) @ (caja top - 11)) extent: (anchoIcono + anchoTitulo + 24) @ 22.
    aCanvas fillRectangle: chip color: self colorMorado.
    aCanvas frameRectangle: chip width: 1 color: self colorCrema.
    aCanvas drawString: '</>' at: (chip left + 7) @ (chip top + 3) font: fuente color: self colorVerde.
    aCanvas drawString: unTitulo at: (chip left + anchoIcono + 14) @ (chip top + 3) font: fuente color: Color white.
    ^ self

]

{ #category : 'private - configuration' }
InterfazPartida >> disminuirColumnas [
    columnasConfiguradas > 2 ifTrue: [ columnasConfiguradas := columnasConfiguradas - 1 ].
    textoColumnas contents: columnasConfiguradas asString.
    ^ self
]

{ #category : 'private - configuration' }
InterfazPartida >> disminuirFilas [
    filasConfiguradas > 2 ifTrue: [ filasConfiguradas := filasConfiguradas - 1 ].
    textoFilas contents: filasConfiguradas asString.
    ^ self
]

{ #category : 'drawing' }
InterfazPartida >> drawOn: aCanvas [
    self dibujarFondoEn: aCanvas.
    self dibujarEncabezadoEn: aCanvas.
    EstiloLongcat dibujarPanel: self rectanguloAreaTablero titulo: 'Partida en curso' en: aCanvas.
    self dibujarMarcaDeAguaEn: aCanvas
]

{ #category : 'event handling' }
InterfazPartida >> enfocarTeclado [
    panelControles ifNotNil: [ :panel | panel takeKeyboardFocus ].
    ^ self
]

{ #category : 'private - drawing' }
InterfazPartida >> fuente: unTamano [
	^ LogicalFont familyName: 'Source Sans Pro' pointSize: unTamano

]

{ #category : 'event handling' }
InterfazPartida >> handlesKeyboard: anEvent [
    ^ true
]

{ #category : 'actions' }
InterfazPartida >> iniciarNivel: unNumero [
    nivelActual := unNumero.
    sacudidaInicio := nil.
    avisoHasta := nil.
    textoAviso contents: ''.
    animacion ifNotNil: [ :anterior | anterior delete. animacion := nil ].
    vistaTablero ifNotNil: [ :vista | vista delete ].
    partida := (Smalltalk globals at: #Partida)
        deNivel: ((Smalltalk globals at: #Nivel) nivel: unNumero).
    self construirTablero.
    self actualizarVista.
    ^ self

]

{ #category : 'actions' }
InterfazPartida >> iniciarNuevaPartida [
    ^ self iniciarNivel: nivelActual

]

{ #category : 'initialization' }
InterfazPartida >> initialize [
    super initialize.
    self extent: 1040 @ 660.
    self color: EstiloLongcat colorFondoArriba.
    ^ self
]

{ #category : 'actions' }
InterfazPartida >> irANivel: unNumero [
    animacion ifNotNil: [ ^ self ].
    (progreso irANivel: unNumero)
        ifTrue: [ ^ self cargarNivelActual ].
    panelNiveles mostrarAviso: 'Nivel ', unNumero asString, ' bloqueado: completa primero el nivel ', progreso nivelMaximo asString.
    ^ self
]

{ #category : 'event handling' }
InterfazPartida >> keyDown: anEvent [
    panelControles ifNotNil: [ :panel | ^ panel keyDown: anEvent ].
    ^ super keyDown: anEvent
]

{ #category : 'event handling' }
InterfazPartida >> keyStroke: anEvent [
    ^ false
]

{ #category : 'private - rendering' }
InterfazPartida >> mensajeEstado [
    partida estado = #activa ifTrue: [ ^ 'En juego' ].
    partida estado = #victoria ifTrue: [
        nivelActual < (Smalltalk globals at: #Nivel) cantidad
            ifTrue: [ ^ 'Nivel completado. Pasando al siguiente...' ].
        ^ 'Completaste todos los niveles' ].
    ^ 'Sin espacio. Reiniciando el nivel...'

]

{ #category : 'private - messages' }
InterfazPartida >> mostrarAviso: unTexto [
    "Mensaje corto en rojo que se borra solo a los pocos segundos"
    textoAviso contents: unTexto.
    avisoHasta := Time millisecondClockValue + 3500.
    ^ self

]

{ #category : 'private - defeat' }
InterfazPartida >> mostrarDerrota [
    animacion := DerrotaMorph
        sobre: self
        centro: vistaTablero pantalla center
        mensaje: 'SIN ESPACIO'
        detalle: 'Error 404: camino no encontrado'
        alTerminar: [ self terminarDerrota ].
    self addMorph: animacion.
    animacion startStepping.
    ^ self
]

{ #category : 'actions' }
InterfazPartida >> moverAbajo [
    ^ self moverCon: ((Smalltalk globals at: #Abajo) new)

]

{ #category : 'actions' }
InterfazPartida >> moverArriba [
    ^ self moverCon: ((Smalltalk globals at: #Arriba) new)

]

{ #category : 'actions' }
InterfazPartida >> moverCon: unaDireccion [
    | estabaActiva antes |
    animacion ifNotNil: [ ^ self ].
    estabaActiva := partida estaActiva.
    antes := partida posicionCabeza.
    partida moverEn: unaDireccion.
    (estabaActiva and: [ partida estaGanada ]) ifTrue: [
        progreso registrarVictoria.
        self actualizarVista.
        ^ self celebrarVictoria ].
    (estabaActiva and: [ partida estaPerdida ]) ifTrue: [
        self actualizarVista.
        ^ self mostrarDerrota ].
    self actualizarVista.
    (estabaActiva and: [ antes = partida posicionCabeza ])
        ifTrue: [ vistaTablero sacudirEn: unaDireccion ].
    ^ self
]

{ #category : 'actions' }
InterfazPartida >> moverDerecha [
    ^ self moverCon: ((Smalltalk globals at: #Derecha) new)

]

{ #category : 'actions' }
InterfazPartida >> moverIzquierda [
    ^ self moverCon: ((Smalltalk globals at: #Izquierda) new)

]

{ #category : 'actions' }
InterfazPartida >> nivelAnterior [
    animacion ifNotNil: [ ^ self ].
    progreso retrocederNivel ifTrue: [ self cargarNivelActual ].
    ^ self
]

{ #category : 'private - building' }
InterfazPartida >> nuevoBoton: unaEtiqueta accion: unSelector en: unaPosicion tamano: unTamano [
    | boton |
    boton := (Smalltalk globals at: #SimpleButtonMorph) new.
    boton label: unaEtiqueta.
    boton target: self.
    boton actionSelector: unSelector.
    boton extent: unTamano.
    self addMorph: boton.
    boton position: self position + unaPosicion.
    ^ boton

]

{ #category : 'private - building' }
InterfazPartida >> nuevoTexto: unTexto en: unaPosicion tamano: unTamano [
    | texto |
    texto := (Smalltalk globals at: #StringMorph) new contents: unTexto.
    texto extent: unTamano.
    texto color: self colorCrema.
    self addMorph: texto.
    texto position: self position + unaPosicion.
    ^ texto

]

{ #category : 'private - updating' }
InterfazPartida >> pintarBotonesNivel [
    "Naranja el nivel actual, verde los desbloqueados y gris los bloqueados"
    botonesNivel withIndexDo: [ :boton :numero |
        boton color: (numero = nivelActual
            ifTrue: [ self colorNaranja ]
            ifFalse: [
                numero <= nivelMaximo
                    ifTrue: [ Color r: 102 g: 204 b: 153 range: 255 ]
                    ifFalse: [ Color r: 90 g: 98 b: 120 range: 255 ] ]) ].
    ^ self

]

{ #category : 'showing' }
InterfazPartida >> prepararPartida [
    "Usa las imagenes que ya cargo LongcatApp; si se abre sola, las busca como antes"
    app ifNotNil: [ :unaApp | sprites := unaApp spritesDelGato ].
    (sprites isNil or: [ sprites size < 4 ]) ifTrue: [ self cargarSprites ].
    avatar := (sprites at: #cabezaAbajo) scaledToSize: 116 @ 116.
    self construirControles.
    self iniciarNuevaPartida.
    ^ self

]

{ #category : 'accessing' }
InterfazPartida >> progreso [
    ^ progreso
]

{ #category : 'layout' }
InterfazPartida >> reacomodar [
    | derecha abajo anchoDerecho altoNiveles areaTablero areaAncho areaAlto |
    panelControles ifNil: [ ^ self ].
    ultimoTamano := self extent.
    derecha := self bordeDerechoPaneles.
    abajo := self bordeInferiorPaneles.
    anchoDerecho := derecha - 256.
    altoNiveles := 132.
    botonMenu ifNotNil: [
        botonMenu position: self position + (((self width - 318) max: 330) @ 20) ].
    panelControles bounds: ((self position + (16 @ 78)) extent: 228 @ 180).
    panelEstado bounds: ((self position + (16 @ 266)) corner: (self position + (244 @ abajo))).
    panelNiveles bounds: ((self position + (256 @ (abajo - altoNiveles))) extent: anchoDerecho @ altoNiveles).
    vistaTablero ifNotNil: [
        areaTablero := self rectanguloAreaTablero.
        areaAncho := (areaTablero width - 28) max: 140.
        areaAlto := (areaTablero height - 38) max: 140.
        vistaTablero detenerSacudida.
        vistaTablero ajustarA: areaAncho @ areaAlto.
        vistaTablero position:
            (areaTablero left + ((areaTablero width - vistaTablero width) // 2))
            @ (areaTablero top + 22 + (((areaAlto - vistaTablero height) // 2) max: 0)) ].
    self changed.
    ^ self
]

{ #category : 'private - layout' }
InterfazPartida >> rectanguloAreaTablero [
    | derecha abajo altoNiveles |
    derecha := self bordeDerechoPaneles.
    abajo := self bordeInferiorPaneles.
    altoNiveles := 132.
    ^ (self position + (256 @ 78)) corner: (self position + (derecha @ (abajo - altoNiveles - 8)))
]

{ #category : 'private - updating' }
InterfazPartida >> registrarVictoria [
    | cantidad |
    partida estado = #victoria ifFalse: [ ^ self ].
    cantidad := (Smalltalk globals at: #Nivel) cantidad.
    completados add: nivelActual.
    nivelMaximo := nivelMaximo max: ((nivelActual + 1) min: cantidad).
    ^ self

]

{ #category : 'actions' }
InterfazPartida >> reiniciarPartida [
    animacion ifNotNil: [ ^ self ].
    partida reiniciar.
    self actualizarVista.
    ^ self
]

{ #category : 'private - messages' }
InterfazPartida >> revisarAviso [
    (avisoHasta notNil and: [ Time millisecondClockValue > avisoHasta ]) ifTrue: [
        textoAviso contents: ''.
        avisoHasta := nil ].
    ^ self

]

{ #category : 'private - shake' }
InterfazPartida >> sacudirTablero: unaDireccion [
    sacudidaVertical := unaDireccion esVertical.
    sacudidaInicio := Time millisecondClockValue.
    ^ self
]

{ #category : 'initialization' }
InterfazPartida >> setProgreso: unProgreso [
    progreso := unProgreso.
    ^ self
]

{ #category : 'actions' }
InterfazPartida >> siguienteNivel [
    animacion ifNotNil: [ ^ self ].
    progreso esUltimoNivel ifTrue: [ ^ self ].
    progreso avanzarNivel
        ifTrue: [ ^ self cargarNivelActual ].
    panelNiveles mostrarAviso: 'Siguiente nivel bloqueado: completa primero el nivel ', progreso nivelActual asString.
    ^ self
]

{ #category : 'stepping' }
InterfazPartida >> step [
    self extent = ultimoTamano ifFalse: [ self reacomodar ].
    panelNiveles ifNotNil: [ panelNiveles revisarAviso ].
    ^ self
]

{ #category : 'stepping' }
InterfazPartida >> stepTime [
    ^ 30
]

{ #category : 'event handling' }
InterfazPartida >> takesKeyboardFocus [
    ^ true
]

{ #category : 'private - defeat' }
InterfazPartida >> terminarDerrota [
    animacion := nil.
    partida reiniciar.
    self actualizarVista.
    self enfocarTeclado.
    ^ self
]

{ #category : 'private - victory' }
InterfazPartida >> terminarVictoria [
    animacion := nil.
    progreso avanzarNivel ifTrue: [ self cargarNivelActual ].
    self enfocarTeclado.
    ^ self
]

{ #category : 'private - updating' }
InterfazPartida >> textoCompletados [
    completados isEmpty ifTrue: [ ^ 'ninguno todavia' ].
    ^ (completados asSortedCollection inject: '' into: [ :texto :numero | texto, numero asString, ' ' ]) trimBoth

]

{ #category : 'showing' }
InterfazPartida >> usarSprites: unosSprites [
    "Cambio de skin: el tablero vuelve a escalar las cabezas con las imagenes nuevas"
    sprites := unosSprites.
    avatar := (sprites at: #cabezaAbajo) scaledToSize: 116 @ 116.
    elementos ifNotNil: [ self reacomodar ].
    ^ self

]

{ #category : 'actions' }
InterfazPartida >> volverAlMenu [
    animacion ifNotNil: [ ^ self ].
    vistaTablero ifNotNil: [ :vista | vista detenerSacudida ].
    app ifNotNil: [ :unaApp | unaApp irAlMenu ].
    ^ self
]
