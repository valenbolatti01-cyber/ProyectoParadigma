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
		'textoLibres'
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
    self construirControles.
    self iniciarNuevaPartida.
    self openInWindowLabeled: 'Longcat'.
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
    | posicion celda |
    celdas := OrderedCollection new.
    1 to: partida filas do: [ :fila |
        1 to: partida columnas do: [ :columna |
            posicion := ((Smalltalk globals at: #Posicion) fila: fila columna: columna).
            celda := (Smalltalk globals at: #Morph) new.
            celda extent: 32 @ 32.
            celda borderWidth: 1.
            celda borderColor: Color gray.
            self addMorph: celda.
            celda position: self position + (250 + ((columna - 1) * 36) @ (92 + ((fila - 1) * 36))).
            celdas add: celda
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
