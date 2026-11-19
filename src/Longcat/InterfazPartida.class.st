"
Presenta Longcat como una ventana Morphic interactiva. Compone controles y casillas visuales, y delega las reglas de juego en Partida.
"
Class {
	#name : 'InterfazPartida',
	#superclass : 'Morph',
	#instVars : [
		'partida',
		'filasConfiguradas',
		'columnasConfiguradas',
		'celdas',
		'textoFilas',
		'textoColumnas',
		'textoEstado',
		'textoLongitud',
		'textoLibres',
		'sprites',
		'imagenesCeldas'
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
    | segmentos indice actual anterior siguiente imagen sprite |

    segmentos := partida posicionesOcupadas.
    indice := 0.

    "Ocultar todas las imágenes"
    imagenesCeldas do: [ :cadaImagen |
        cadaImagen visible: false
    ].

    segmentos do: [ :posicion |
        indice := indice + 1.

        imagen := imagenesCeldas at: (
            ((posicion fila - 1) * partida columnas) +
            posicion columna
        ).

        "Dibujar la cabeza"
        (indice = 1) ifTrue: [
            imagen form: (
                (sprites at: #cabezaAbajo) scaledToSize: 32 @ 32
            ).
            imagen visible: true
        ].

        "Dibujar el cuerpo intermedio"
        ((indice > 1) and: [ indice < segmentos size ]) ifTrue: [
            anterior := segmentos at: indice - 1.
            actual := segmentos at: indice.
            siguiente := segmentos at: indice + 1.

            sprite := self
                spritePara: anterior
                actual: actual
                siguiente: siguiente.

            sprite ifNotNil: [
                imagen form: (sprite scaledToSize: 32 @ 32).
                imagen visible: true
            ].
        ].
    ].

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
	 self actualizarImagenes .
    textoEstado contents: (self mensajeEstado).
    textoLongitud contents: 'Longitud: ', partida longitudGato asString.
    textoLibres contents: 'Casillas libres: ', partida cantidadDisponibles asString.
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
    (partida posicionesOcupadas includes: unaPosicion) ifTrue: [ ^ Color green ].
    ^ Color white
]

{ #category : 'building' }
InterfazPartida >> construirControles [
    | titulo instrucciones |
    titulo := self nuevoTexto: 'LONGCAT' en: 20 @ 18 tamano: 190 @ 32.
    titulo emphasis: (Smalltalk globals at: #TextEmphasis) bold.
    self nuevoTexto: 'Filas' en: 20 @ 62 tamano: 70 @ 26.
    textoFilas := self nuevoTexto: filasConfiguradas asString en: 95 @ 62 tamano: 35 @ 26.
    self nuevoBoton: '-' accion: #disminuirFilas en: 135 @ 58 tamano: 34 @ 32.
    self nuevoBoton: '+' accion: #aumentarFilas en: 174 @ 58 tamano: 34 @ 32.
    self nuevoTexto: 'Columnas' en: 20 @ 101 tamano: 75 @ 26.
    textoColumnas := self nuevoTexto: columnasConfiguradas asString en: 95 @ 101 tamano: 35 @ 26.
    self nuevoBoton: '-' accion: #disminuirColumnas en: 135 @ 97 tamano: 34 @ 32.
    self nuevoBoton: '+' accion: #aumentarColumnas en: 174 @ 97 tamano: 34 @ 32.
    self nuevoBoton: 'Nueva partida' accion: #iniciarNuevaPartida en: 20 @ 143 tamano: 188 @ 36.
    self nuevoBoton: 'Reiniciar nivel' accion: #reiniciarPartida en: 20 @ 186 tamano: 188 @ 36.
    self nuevoTexto: 'Mover' en: 20 @ 244 tamano: 188 @ 25.
    self nuevoBoton: '^' accion: #moverArriba en: 92 @ 273 tamano: 42 @ 38.
    self nuevoBoton: '<' accion: #moverIzquierda en: 45 @ 315 tamano: 42 @ 38.
    self nuevoBoton: 'v' accion: #moverAbajo en: 92 @ 315 tamano: 42 @ 38.
    self nuevoBoton: '>' accion: #moverDerecha en: 139 @ 315 tamano: 42 @ 38.
    textoEstado := self nuevoTexto: '' en: 20 @ 375 tamano: 205 @ 50.
    textoLongitud := self nuevoTexto: '' en: 20 @ 430 tamano: 205 @ 26.
    textoLibres := self nuevoTexto: '' en: 20 @ 458 tamano: 205 @ 26.
    instrucciones := self nuevoTexto: 'Usa los botones para avanzar.
Cada movimiento llega hasta el bloqueo.' en: 20 @ 510 tamano: 220 @ 55.
    instrucciones color: Color darkGray.
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

{ #category : 'event handling' }
InterfazPartida >> handlesKeyboard: anEvent [
    ^ true
]

{ #category : 'actions' }
InterfazPartida >> iniciarNuevaPartida [
    celdas do: [ :celda | self removeMorph: celda ].
    partida := (Smalltalk globals at: #Partida)
        deFilas: filasConfiguradas
        columnas: columnasConfiguradas
        inicio: ((Smalltalk globals at: #Posicion)
            fila: filasConfiguradas + 1 // 2
            columna: columnasConfiguradas + 1 // 2).
    self construirTablero.
    self actualizarVista.
    ^ self
]

{ #category : 'initialization' }
InterfazPartida >> initialize [
    super initialize.
    filasConfiguradas := 5.
    columnasConfiguradas := 7.
    celdas := OrderedCollection new.
    self extent: 720 @ 590.
    self color: Color veryLightGray.
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
    partida estado = #victoria ifTrue: [ ^ 'Victoria - tablero completo' ].
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

{ #category : 'actions' }
InterfazPartida >> reiniciarPartida [
    partida reiniciar.
    self actualizarVista.
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
