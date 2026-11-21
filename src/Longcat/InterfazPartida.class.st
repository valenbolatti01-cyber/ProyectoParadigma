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
InterfazPartida class >> app: unaApp progreso: unProgreso [
    ^ (self app: unaApp) setProgreso: unProgreso
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

{ #category : 'event handling' }
InterfazPartida >> handlesKeyboard: anEvent [
    ^ true
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
InterfazPartida >> nivelAnterior [
    animacion ifNotNil: [ ^ self ].
    progreso retrocederNivel ifTrue: [ self cargarNivelActual ].
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

{ #category : 'actions' }
InterfazPartida >> volverAlMenu [
    animacion ifNotNil: [ ^ self ].
    vistaTablero ifNotNil: [ :vista | vista detenerSacudida ].
    app ifNotNil: [ :unaApp | unaApp irAlMenu ].
    ^ self
]
