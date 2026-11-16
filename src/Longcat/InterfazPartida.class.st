"
Presenta Longcat como una ventana Morphic interactiva con niveles: muestra el nivel actual y los completados, y permite elegir nivel. Compone controles y casillas visuales, y delega las reglas de juego en Partida.
"
Class {
	#name : 'InterfazPartida',
	#superclass : 'Morph',
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
		'animacion'
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

{ #category : 'private - updating' }
InterfazPartida >> actualizarVista [
    vistaTablero changed.
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
    "El cuerpo ya no usa imagenes: lo dibuja TableroMorph. Solo se cargan las cabezas."

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

{ #category : 'private - victory' }
InterfazPartida >> celebrarVictoria [
    | esElUltimo |
    esElUltimo := nivelActual >= (Smalltalk globals at: #Nivel) cantidad.
    animacion := (Smalltalk globals at: #VictoriaMorph)
        sobre: self
        centro: vistaTablero center
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
    "Un solo morph dibuja todo el tablero y el gato continuo (ver TableroMorph)"
    vistaTablero := (Smalltalk globals at: #TableroMorph) partida: partida sprites: sprites.
    self addMorph: vistaTablero.
    vistaTablero position: self position + (250 @ 92).
    ^ self

]

{ #category : 'event handling' }
InterfazPartida >> handlesKeyboard: anEvent [
    ^ true

]

{ #category : 'actions' }
InterfazPartida >> iniciarNivel: unNumero [
    nivelActual := unNumero.
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
            ifTrue: [ ^ 'Nivel completado. Pasando al siguiente...' ].
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
    | estabaActiva |
    animacion ifNotNil: [ ^ self ].
    estabaActiva := partida estado = #activa.
    partida moverEn: unaDireccion.
    self actualizarVista.
    "Solo se celebra en el movimiento que gana, no en cada tecla despues"
    (estabaActiva and: [ partida estado = #victoria ])
        ifTrue: [ self celebrarVictoria ].
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

{ #category : 'event handling' }
InterfazPartida >> takesKeyboardFocus [
    ^ true

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
