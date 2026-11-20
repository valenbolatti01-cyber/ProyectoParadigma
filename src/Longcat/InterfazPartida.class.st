"
Pantalla de los niveles normales (10 niveles). Hereda de PantallaLongcat el fondo violeta comun del juego. Muestra el nivel actual y los completados, permite elegir nivel, tiene un boton para volver al menu principal y delega las reglas del juego en Partida. Se abre desde LongcatApp (InterfazPartida abrir abre el juego completo).
"
Class {
	#name : 'InterfazPartida',
	#superclass : 'PantallaLongcat',
	#instVars : [
		'partida',
		'vistaTablero',
		'textoEstado',
		'textoLongitud',
		'textoLibres',
		'sprites',
		'nivelActual',
		'nivelMaximo',
		'completados',
		'textoNivel',
		'textoProgreso',
		'animacion',
		'avatar',
		'elementos',
		'botonesNivel',
		'textoAviso',
		'avisoHasta',
		'ultimoTamano',
		'sacudidaInicio',
		'sacudidaVertical',
		'posicionTablero'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
InterfazPartida class >> abrir [
    "Abre el juego completo, empezando por el menu principal"
    ^ (Smalltalk globals at: #LongcatApp) abrir

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

{ #category : 'private - updating' }
InterfazPartida >> actualizarVista [
    vistaTablero changed.
    self registrarVictoria.
    textoEstado contents: self mensajeEstado.
    textoLongitud contents: 'Longitud: ', partida longitudGato asString.
    textoLibres contents: 'Casillas libres: ', partida cantidadDisponibles asString.
    textoNivel contents: 'Nivel ', nivelActual asString, ' de ', (Smalltalk globals at: #Nivel) cantidad asString.
    textoProgreso contents: 'Niveles completados: ', self textoCompletados.
    self pintarBotonesNivel.
    ^ self

]

{ #category : 'showing' }
InterfazPartida >> alMostrarse [
    "LongcatApp lo llama al entrar a niveles normales. La primera vez arma la partida; despues solo se reacomoda."
    partida ifNil: [ self prepararPartida ].
    self reacomodar.
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
    "Terremoto corto: el monitor vibra en el sentido del golpe y se va calmando"
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

{ #category : 'private - drawing' }
InterfazPartida >> bordeDerechoPaneles [
    ^ (self width - 16) max: 520

]

{ #category : 'private - drawing' }
InterfazPartida >> bordeInferiorPaneles [
    ^ (self height - 36) max: 420

]

{ #category : 'as yet unclassified' }
InterfazPartida >> cargarSprites [
    | raiz archivos |
    raiz := (Smalltalk globals at: #LongcatCarpeta ifAbsent: [ FileLocator imageDirectory ]) asFileReference.
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
    esElUltimo := nivelActual >= (Smalltalk globals at: #Nivel) cantidad.
    animacion := (Smalltalk globals at: #VictoriaMorph)
        sobre: self
        centro: vistaTablero pantalla center
        mensaje: (esElUltimo
            ifTrue: [ '¡GANASTE TODO!' ]
            ifFalse: [ '¡NIVEL COMPLETADO!' ])
        detalle: (esElUltimo
            ifTrue: [ 'Completaste los ', nivelActual asString, ' niveles' ]
            ifFalse: [ 'Siguiente: nivel ', (nivelActual + 1) asString ])
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
    "El juego tiene encabezado y paneles: no lleva las esquinas de neon de los menus"
    ^ false

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
    "Franja de arriba con el logo (o el titulo en texto si no esta el PNG) y el post-it"
    | franja logo fuenteTitulo fuenteNota x nota |
    franja := self topLeft extent: self width @ 70.
    aCanvas fillRectangle: franja color: (EstiloLongcat colorMarco alpha: 0.55).
    aCanvas fillRectangle: ((self left @ (franja bottom - 3)) extent: self width @ 2) color: self colorMorado.
    aCanvas fillRectangle: ((self left @ (franja bottom - 1)) extent: self width @ 1) color: self colorVerde.
    logo := self forma: #logo ajustadaA: 300 @ 58.
    logo
        ifNotNil: [ aCanvas translucentImage: logo at: (self left + 16) @ (self top + 6 + ((58 - logo height) // 2)) ]
        ifNil: [
            fuenteTitulo := self fuente: 26.
            x := self left + 20.
            aCanvas drawString: 'LONGCAT' at: (x + 3) @ (self top + 9) font: fuenteTitulo color: self colorMorado.
            aCanvas drawString: 'LONGCAT' at: x @ (self top + 6) font: fuenteTitulo color: self colorCrema.
            x := x + (fuenteTitulo widthOfString: 'LONGCAT') + 2.
            aCanvas drawString: '.exe' at: x @ (self top + 6) font: fuenteTitulo color: self colorVerde.
            aCanvas
                drawString: '<< El gato que llena el tablero >>'
                at: (self left + 22) @ (self top + 46)
                font: (self fuente: 10)
                color: self colorLavanda ].
    "Post-it de la entrega"
    nota := ((self right - 156) @ (self top + 10)) extent: 130 @ 48.
    aCanvas fillRectangle: (nota translateBy: 3 @ 3) color: (Color black alpha: 0.4).
    aCanvas fillRectangle: nota color: self colorCrema.
    aCanvas fillRectangle: (nota topLeft extent: nota width @ 6) color: self colorNaranja.
    fuenteNota := self fuente: 11.
    aCanvas drawString: 'Entrega:' at: (nota left + 10) @ (nota top + 9) font: fuenteNota color: self colorPizarra.
    aCanvas drawString: 'mañana 23:59' at: (nota left + 10) @ (nota top + 26) font: fuenteNota color: self colorPizarra.
    ^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarMarcaDeAguaEn: aCanvas [
    "Marca de agua centrada abajo de todo"
    | texto fuente ancho |
    texto := 'UTN FRRe - Paradigmas de Programación - Grupo 33'.
    fuente := self fuente: 10.
    ancho := fuente widthOfString: texto.
    aCanvas
        drawString: texto
        at: (self center x - (ancho // 2)) @ (self bottom - 24)
        font: fuente
        color: (self colorLavanda alpha: 0.75).
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
    "Fondo gamer: degradado, grilla neon, pixeles, encabezado y paneles. Los paneles se estiran con la ventana."
    self dibujarFondoEn: aCanvas.
    self dibujarEncabezadoEn: aCanvas.
    self dibujarPanel: (16 @ 84 corner: 236 @ self bordeInferiorPaneles) titulo: 'Controles' en: aCanvas.
    self dibujarPanel: (252 @ 84 corner: self bordeDerechoPaneles @ self bordeInferiorPaneles) titulo: 'Partida en curso' en: aCanvas.
    self dibujarAvatarEn: aCanvas.
    self dibujarMarcaDeAguaEn: aCanvas

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
    nivelActual := 1.
    nivelMaximo := 1.
    completados := Set new.
    self extent: 1040 @ 660.
    self color: EstiloLongcat colorFondoArriba.
    ^ self

]

{ #category : 'actions' }
InterfazPartida >> irANivel: unNumero [
    unNumero <= nivelMaximo
        ifTrue: [ ^ self iniciarNivel: unNumero ].
    self mostrarAviso: 'Nivel ', unNumero asString, ' bloqueado: completa primero el nivel ', nivelMaximo asString.
    ^ self

]

{ #category : 'event handling' }
InterfazPartida >> keyDown: anEvent [
    (anEvent key) isArrowUp ifTrue: [
        ^ self moverArriba
    ].
    (anEvent key) isArrowDown ifTrue: [
        ^ self moverAbajo
    ].
    (anEvent key) isArrowLeft ifTrue: [
        ^ self moverIzquierda
    ].
    (anEvent key) isArrowRight ifTrue: [
        ^ self moverDerecha
    ].
    ^ super keyDown: anEvent

]

{ #category : 'event handling' }
InterfazPartida >> keyStroke: anEvent [
    "Las flechas se manejan en keyDown:"
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
    animacion := (Smalltalk globals at: #DerrotaMorph)
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

{ #category : 'private - actions' }
InterfazPartida >> moverCon: unaDireccion [
    | estabaActiva antes |
    animacion ifNotNil: [ ^ self ].
    estabaActiva := partida estado = #activa.
    antes := partida posicionCabeza fila @ partida posicionCabeza columna.
    partida moverEn: unaDireccion.
    self actualizarVista.
    "Solo se celebra o se pierde en el movimiento que lo causa, no en cada tecla despues"
    (estabaActiva and: [ partida estado = #victoria ]) ifTrue: [ ^ self celebrarVictoria ].
    (estabaActiva and: [ partida estado = #derrota ]) ifTrue: [ ^ self mostrarDerrota ].
    "Si el gato no se pudo mover, tiembla el monitor"
    (estabaActiva and: [ antes = (partida posicionCabeza fila @ partida posicionCabeza columna) ])
        ifTrue: [ self sacudirTablero: unaDireccion ].
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
    nivelActual > 1
        ifTrue: [ self iniciarNivel: nivelActual - 1 ].
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

{ #category : 'private - layout' }
InterfazPartida >> reacomodar [
    "Reubica todo segun el tamano actual de la ventana: paneles, botones, textos y el monitor del tablero"
    | izquierdaDer abajo anchoPanel paso total inicio areaAncho areaAlto |
    elementos ifNil: [ ^ self ].
    ultimoTamano := self extent.
    abajo := self bordeInferiorPaneles.
    izquierdaDer := 252.
    anchoPanel := self bordeDerechoPaneles - izquierdaDer.
    "Encabezado: boton para volver al menu, a la izquierda del post-it"
    (elementos includesKey: #menu) ifTrue: [
        self colocar: #menu en: ((self width - 318) max: 330) @ 20 ].
    "Panel izquierdo"
    self colocar: #mover en: 30 @ 114.
    self colocar: #arriba en: 105 @ 138.
    self colocar: #izquierda en: 58 @ 180.
    self colocar: #abajo en: 105 @ 180.
    self colocar: #derecha en: 152 @ 180.
    self colocar: #estado en: 30 @ 238.
    self colocar: #longitud en: 30 @ 266.
    self colocar: #libres en: 30 @ 288.
    self colocar: #ayuda1 en: 30 @ 320.
    self colocar: #ayuda2 en: 30 @ 338.
    "Panel derecho: arriba el nivel y los botones, abajo el selector de niveles"
    self colocar: #nivel en: (izquierdaDer + 16) @ 102.
    self colocar: #siguiente en: (self bordeDerechoPaneles - 116) @ 100.
    self colocar: #anterior en: (self bordeDerechoPaneles - 228) @ 100.
    self colocar: #aviso en: (izquierdaDer + 16) @ (abajo - 116).
    self colocar: #progreso en: (izquierdaDer + 16) @ (abajo - 90).
    self colocar: #irA en: (izquierdaDer + 16) @ (abajo - 70).
    paso := (((anchoPanel - 72) // 9) min: 64) max: 40.
    total := (9 * paso) + 40.
    inicio := izquierdaDer + ((anchoPanel - total) // 2).
    botonesNivel withIndexDo: [ :boton :numero |
        boton position: self position + ((inicio + ((numero - 1) * paso)) @ (abajo - 46)) ].
    "Monitor del tablero: ocupa el espacio libre del medio, centrado"
    vistaTablero ifNotNil: [
        areaAncho := anchoPanel - 32.
        areaAlto := ((abajo - 124) - 140) max: 150.
        vistaTablero ajustarA: areaAncho @ areaAlto sprites: sprites.
        posicionTablero := (izquierdaDer + 16 + ((areaAncho - vistaTablero width) // 2))
            @ (140 + (((areaAlto - vistaTablero height) // 2) max: 0)).
        vistaTablero position: self position + posicionTablero ].
    self changed.
    ^ self

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
    sacudidaVertical := (unaDireccion isKindOf: (Smalltalk globals at: #Arriba))
        or: [ unaDireccion isKindOf: (Smalltalk globals at: #Abajo) ].
    sacudidaInicio := Time millisecondClockValue.
    ^ self

]

{ #category : 'actions' }
InterfazPartida >> siguienteNivel [
    nivelActual >= (Smalltalk globals at: #Nivel) cantidad ifTrue: [ ^ self ].
    nivelActual < nivelMaximo
        ifTrue: [ ^ self iniciarNivel: nivelActual + 1 ].
    self mostrarAviso: 'Siguiente nivel bloqueado: completa primero el nivel ', nivelActual asString.
    ^ self

]

{ #category : 'stepping' }
InterfazPartida >> step [
    self extent = ultimoTamano ifFalse: [ self reacomodar ].
    self avanzarSacudida.
    self revisarAviso.
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
    "Se llama cuando termina la animacion: reinicia el mismo nivel"
    animacion := nil.
    partida reiniciar.
    self actualizarVista.
    self takeKeyboardFocus.
    ^ self

]

{ #category : 'private - victory' }
InterfazPartida >> terminarVictoria [
    "Se llama cuando termina la animacion: pasa solo al siguiente nivel"
    animacion := nil.
    nivelActual < (Smalltalk globals at: #Nivel) cantidad
        ifTrue: [ self iniciarNivel: nivelActual + 1 ].
    self takeKeyboardFocus.
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
    "No se puede salir en medio de la animacion de victoria o derrota"
    animacion ifNotNil: [ ^ self ].
    sacudidaInicio := nil.
    app ifNotNil: [ :unaApp | unaApp irAlMenu ].
    ^ self

]
