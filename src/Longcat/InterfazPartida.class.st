"
Presenta Longcat como una ventana Morphic interactiva con niveles: muestra el nivel actual y los completados, y permite elegir nivel. Compone controles y casillas visuales, y delega las reglas de juego en Partida.
"
Class {
	#name : 'InterfazPartida',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'celdas',
		'textoEstado',
		'textoLongitud',
		'textoLibres',
		'sprites',
		'imagenesCeldas',
		'nivelActual',
		'nivelMaximo',
		'completados',
		'textoNivel',
		'textoProgreso'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
InterfazPartida class >> abrir [
    ^ self new abrir
]

{ #category : 'opening' }
InterfazPartida >> abrir [
	self cargarSprites.
	self construirControles.
	self iniciarNuevaPartida.
	self openInWindowLabeled: 'Longcat'.
	self takeKeyboardFocus.
	^ self
]

{ #category : 'as yet unclassified' }
InterfazPartida >> actualizarImagenes [
    | segmentos indice actual anterior siguiente imagen sprite ultimo |
    segmentos := partida posicionesOcupadas.
    indice := 0.
    imagenesCeldas do: [ :cadaImagen | cadaImagen visible: false ].
    segmentos do: [ :posicion |
        indice := indice + 1.
        imagen := imagenesCeldas at: (((posicion fila - 1) * partida columnas) + posicion columna).
        indice = 1 ifTrue: [
            imagen form: ((sprites at: #cabezaAbajo) scaledToSize: 32 @ 32).
            imagen visible: true ].
        (indice > 1 and: [ indice < segmentos size ]) ifTrue: [
            anterior := segmentos at: indice - 1.
            actual := segmentos at: indice.
            siguiente := segmentos at: indice + 1.
            sprite := self spritePara: anterior actual: actual siguiente: siguiente.
            sprite ifNotNil: [
                imagen form: (sprite scaledToSize: 32 @ 32).
                imagen visible: true ] ] ].
    segmentos size > 1 ifTrue: [
        ultimo := segmentos last.
        anterior := segmentos at: segmentos size - 1.
        imagen := imagenesCeldas at: ((ultimo fila - 1) * partida columnas) + ultimo columna.
        sprite := ultimo fila = anterior fila
            ifTrue: [ sprites at: #cuerpoHorizontal ]
            ifFalse: [ sprites at: #cuerpoVertical ].
        imagen form: (sprite scaledToSize: 32 @ 32).
        imagen visible: true ].
    ^ self
]

{ #category : 'private - updating' }
InterfazPartida >> actualizarVista [
    | indice posicion |
    indice := 0.
    1 to: partida filas do: [ :fila |
        1 to: partida columnas do: [ :columna |
            indice := indice + 1.
            posicion := ((Smalltalk globals at: #Posicion) fila: fila columna: columna).
            (celdas at: indice) color: (self colorDe: posicion)
        ]
    ].
    self actualizarImagenes.
    self registrarVictoria.
    textoEstado contents: self mensajeEstado.
    textoLongitud contents: 'Longitud: ', partida longitudGato asString.
    textoLibres contents: 'Casillas libres: ', partida cantidadDisponibles asString.
    textoNivel contents: 'Nivel ', nivelActual asString, ' de ', (Smalltalk globals at: #Nivel) cantidad asString.
    textoProgreso contents: 'Niveles completados: ', self textoCompletados.
    ^ self
]

{ #category : 'as yet unclassified' }
InterfazPartida >> cargarSprites [
    | repositorio carpetaSprites |

    repositorio := IceRepository registry
        detect: [ :cadaRepositorio |
            cadaRepositorio name = 'ProyectoParadigma'
        ].

    carpetaSprites := repositorio location / 'assets' / 'sprites'.

    sprites := Dictionary new.

    sprites at: #cuerpoHorizontal put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_cuerpo_recto_horizontal.png') fullName).

    sprites at: #cuerpoVertical put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_cuerpo_recto_vertical.png') fullName).

    sprites at: #curvaArribaDerecha put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_curva_arriba_derecha.png') fullName).

    sprites at: #curvaArribaIzquierda put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_curva_arriba_izquierda.png') fullName).

    sprites at: #curvaIzquierdaAbajo put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_curva_izquierda_abajo.png') fullName).

    sprites at: #curvaDerechaAbajo put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Longcat_curva_derecha_abajo.png') fullName).

    sprites at: #cabezaAbajo put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Gato abajo.png') fullName).

    sprites at: #cabezaArriba put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Gato arriba.png') fullName).

    sprites at: #cabezaDerecha put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Gato derecha.png') fullName).

    sprites at: #cabezaIzquierda put:
        (ImageReadWriter formFromFileNamed:
            (carpetaSprites / 'Gato izquierda.png') fullName).

    ^ sprites

]

{ #category : 'private - rendering' }
InterfazPartida >> colorDe: unaPosicion [
    unaPosicion = partida posicionCabeza ifTrue: [ ^ Color yellow ].
    (partida casillaBloqueadaEn: unaPosicion) ifTrue: [ ^ Color darkGray ].
    (partida posicionesOcupadas includes: unaPosicion) ifTrue: [ ^ Color green ].
    ^ Color white
]

{ #category : 'building' }
InterfazPartida >> construirControles [
    | titulo instrucciones boton |
    titulo := self nuevoTexto: 'LONGCAT' en: 20 @ 18 tamano: 190 @ 32.
    titulo emphasis: (Smalltalk globals at: #TextEmphasis) bold.
    self nuevoBoton: 'Reiniciar nivel' accion: #reiniciarPartida en: 20 @ 62 tamano: 188 @ 36.
    self nuevoTexto: 'Mover' en: 20 @ 125 tamano: 188 @ 25.
    self nuevoBoton: '^' accion: #moverArriba en: 92 @ 155 tamano: 42 @ 38.
    self nuevoBoton: '<' accion: #moverIzquierda en: 45 @ 197 tamano: 42 @ 38.
    self nuevoBoton: 'v' accion: #moverAbajo en: 92 @ 197 tamano: 42 @ 38.
    self nuevoBoton: '>' accion: #moverDerecha en: 139 @ 197 tamano: 42 @ 38.
    textoEstado := self nuevoTexto: '' en: 20 @ 260 tamano: 205 @ 50.
    textoLongitud := self nuevoTexto: '' en: 20 @ 320 tamano: 205 @ 26.
    textoLibres := self nuevoTexto: '' en: 20 @ 348 tamano: 205 @ 26.
    instrucciones := self nuevoTexto: 'Usa los botones para avanzar.
Cada movimiento llega hasta el bloqueo.' en: 20 @ 400 tamano: 220 @ 55.
    instrucciones color: Color darkGray.
    textoNivel := self nuevoTexto: '' en: 250 @ 18 tamano: 220 @ 26.
    self nuevoBoton: 'Nivel anterior' accion: #nivelAnterior en: 250 @ 48 tamano: 112 @ 30.
    self nuevoBoton: 'Siguiente nivel' accion: #siguienteNivel en: 370 @ 48 tamano: 112 @ 30.
    textoProgreso := self nuevoTexto: '' en: 250 @ 405 tamano: 440 @ 26.
    self nuevoTexto: 'Ir al nivel (se desbloquea al completar el anterior):' en: 250 @ 435 tamano: 440 @ 26.
    1 to: (Smalltalk globals at: #Nivel) cantidad do: [ :numero |
        boton := self nuevoBoton: numero asString accion: #irANivel: en: (250 + ((numero - 1) * 44)) @ 465 tamano: 40 @ 30.
        boton arguments: (Array with: numero) ].
    ^ self
]

{ #category : 'private - building' }
InterfazPartida >> construirTablero [
    | posicion celda imagen |
    celdas := OrderedCollection new.
    imagenesCeldas := OrderedCollection new.

    1 to: partida filas do: [ :fila |
        1 to: partida columnas do: [ :columna |
            posicion := ((Smalltalk globals at: #Posicion)
                fila: fila columna: columna).

            celda := (Smalltalk globals at: #Morph) new.
            celda extent: 32 @ 32.
            celda borderWidth: 1.
            celda borderColor: Color gray.

            imagen := ImageMorph new.
            imagen extent: 32 @ 32.
            celda addMorph: imagen.
            imagen position: celda position.

            self addMorph: celda.
            celda position: self position +
                (250 + ((columna - 1) * 36) @
                (92 + ((fila - 1) * 36))).

            imagen position: celda position.

            celdas add: celda.
            imagenesCeldas add: imagen
        ]
    ].
    ^ self
]

{ #category : 'event handling' }
InterfazPartida >> handlesKeyboard: anEvent [
    ^ true
]

{ #category : 'actions' }
InterfazPartida >> iniciarNivel: unNumero [
    nivelActual := unNumero.
    celdas do: [ :celda | self removeMorph: celda ].
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
    celdas := OrderedCollection new.
    nivelActual := 1.
    nivelMaximo := 1.
    completados := Set new.
    self extent: 720 @ 590.
    self color: Color veryLightGray.
    ^ self
]

{ #category : 'actions' }
InterfazPartida >> irANivel: unNumero [
    unNumero <= nivelMaximo
        ifTrue: [ self iniciarNivel: unNumero ].
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
    self inform: 'Recibí una pulsación de teclado'.
    ^ true
]

{ #category : 'private - rendering' }
InterfazPartida >> mensajeEstado [
    partida estado = #activa ifTrue: [ ^ 'En juego' ].
    partida estado = #victoria ifTrue: [
        nivelActual < (Smalltalk globals at: #Nivel) cantidad
            ifTrue: [ ^ 'Nivel completado. Pasa al siguiente.' ].
        ^ 'Completaste todos los niveles' ].
    ^ 'Sin movimientos. Reinicia el nivel.'
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
    partida moverEn: unaDireccion.
    self actualizarVista.
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
    self addMorph: texto.
    texto position: self position + unaPosicion.
    ^ texto
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

{ #category : 'actions' }
InterfazPartida >> siguienteNivel [
    (nivelActual < (Smalltalk globals at: #Nivel) cantidad and: [ nivelActual < nivelMaximo ])
        ifTrue: [ self iniciarNivel: nivelActual + 1 ].
    ^ self
]

{ #category : 'as yet unclassified' }
InterfazPartida >> spriteEntre: posicionA y: posicionB [
    (posicionA fila = posicionB fila) ifTrue: [
        ^ sprites at: #cuerpoHorizontal
    ].

    (posicionA columna = posicionB columna) ifTrue: [
        ^ sprites at: #cuerpoVertical
    ].
]

{ #category : 'as yet unclassified' }
InterfazPartida >> spritePara: anterior actual: actual siguiente: siguiente [

    ((anterior fila = actual fila) and: [
        actual fila = siguiente fila
    ]) ifTrue: [
        ^ sprites at: #cuerpoHorizontal
    ].

    ((anterior columna = actual columna) and: [
        actual columna = siguiente columna
    ]) ifTrue: [
        ^ sprites at: #cuerpoVertical
    ].

    "Curva arriba-derecha"
    (((anterior fila < actual fila) and: [
        siguiente columna > actual columna
    ]) or: [
        (siguiente fila < actual fila) and: [
            anterior columna > actual columna
        ]
    ]) ifTrue: [
        ^ sprites at: #curvaArribaDerecha
    ].

    "Curva arriba-izquierda"
    (((anterior fila < actual fila) and: [
        siguiente columna < actual columna
    ]) or: [
        (siguiente fila < actual fila) and: [
            anterior columna < actual columna
        ]
    ]) ifTrue: [
        ^ sprites at: #curvaArribaIzquierda
    ].

    "Curva izquierda-abajo"
    (((anterior columna < actual columna) and: [
        siguiente fila > actual fila
    ]) or: [
        (siguiente columna < actual columna) and: [
            anterior fila > actual fila
        ]
    ]) ifTrue: [
        ^ sprites at: #curvaIzquierdaAbajo
    ].

    "Curva derecha-abajo"
    (((anterior columna > actual columna) and: [
        siguiente fila > actual fila
    ]) or: [
        (siguiente columna > actual columna) and: [
            anterior fila > actual fila
        ]
    ]) ifTrue: [
        ^ sprites at: #curvaDerechaAbajo
    ].

    ^ nil
]

{ #category : 'event handling' }
InterfazPartida >> takesKeyboardFocus [
    ^ true
]

{ #category : 'private - updating' }
InterfazPartida >> textoCompletados [
    completados isEmpty ifTrue: [ ^ 'ninguno todavia' ].
    ^ (completados asSortedCollection inject: '' into: [ :texto :numero | texto, numero asString, ' ' ]) trimBoth
]
