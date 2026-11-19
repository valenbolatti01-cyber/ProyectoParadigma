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
		'animacion',
		'estrellas',
		'avatar'
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
	avatar := (sprites at: #cabezaAbajo) scaledToSize: 116 @ 116.
	self construirControles.
	self iniciarNuevaPartida.
	self openInWindowLabeled: 'Longcat.exe'.
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
    vistaTablero changed.
    self registrarVictoria.
    textoEstado contents: self mensajeEstado.
    textoLongitud contents: 'Longitud: ', partida longitudGato asString.
    textoLibres contents: 'Casillas libres: ', partida cantidadDisponibles asString.
    textoNivel contents: 'Nivel ', nivelActual asString, ' de ', (Smalltalk globals at: #Nivel) cantidad asString.
    textoProgreso contents: 'Niveles completados: ', self textoCompletados.
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

{ #category : 'private - colors' }
InterfazPartida >> colorCrema [
	^ Color r: 245 g: 214 b: 160 range: 255

]

{ #category : 'private - rendering' }
InterfazPartida >> colorDe: unaPosicion [
    unaPosicion = partida posicionCabeza ifTrue: [ ^ Color yellow ].
    (partida posicionesOcupadas includes: unaPosicion) ifTrue: [ ^ Color green ].
    ^ Color white
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

{ #category : 'building' }
InterfazPartida >> construirControles [
    | texto boton |
    "Panel izquierdo: controles"
    self nuevoBoton: 'Reiniciar nivel' accion: #reiniciarPartida en: 30 @ 104 tamano: 192 @ 34.
    texto := self nuevoTexto: 'Mover' en: 30 @ 150 tamano: 188 @ 22.
    texto color: self colorVerde.
    self nuevoBoton: '^' accion: #moverArriba en: 105 @ 174 tamano: 42 @ 38.
    self nuevoBoton: '<' accion: #moverIzquierda en: 58 @ 216 tamano: 42 @ 38.
    self nuevoBoton: 'v' accion: #moverAbajo en: 105 @ 216 tamano: 42 @ 38.
    self nuevoBoton: '>' accion: #moverDerecha en: 152 @ 216 tamano: 42 @ 38.
    textoEstado := self nuevoTexto: '' en: 30 @ 274 tamano: 200 @ 22.
    textoEstado color: self colorVerde.
    textoLongitud := self nuevoTexto: '' en: 30 @ 302 tamano: 200 @ 22.
    textoLibres := self nuevoTexto: '' en: 30 @ 324 tamano: 200 @ 22.
    texto := self nuevoTexto: 'Usa los botones o las flechas.' en: 30 @ 356 tamano: 200 @ 20.
    texto color: self colorLavanda.
    texto := self nuevoTexto: 'Cada movimiento va hasta chocar.' en: 30 @ 374 tamano: 200 @ 20.
    texto color: self colorLavanda.
    "Panel derecho: nivel y monitor"
    textoNivel := self nuevoTexto: '' en: 268 @ 102 tamano: 220 @ 26.
    textoNivel font: (self fuente: 14).
    textoNivel color: self colorNaranja.
    self nuevoBoton: 'Nivel anterior' accion: #nivelAnterior en: 520 @ 100 tamano: 104 @ 30.
    self nuevoBoton: 'Siguiente nivel' accion: #siguienteNivel en: 632 @ 100 tamano: 104 @ 30.
    textoProgreso := self nuevoTexto: '' en: 268 @ 522 tamano: 460 @ 20.
    texto := self nuevoTexto: 'Ir al nivel (se desbloquea al completar el anterior):' en: 268 @ 542 tamano: 460 @ 20.
    texto color: self colorLavanda.
    1 to: (Smalltalk globals at: #Nivel) cantidad do: [ :numero |
        boton := self nuevoBoton: numero asString accion: #irANivel: en: (268 + ((numero - 1) * 46)) @ 566 tamano: 40 @ 30.
        boton arguments: (Array with: numero) ].
    ^ self

]

{ #category : 'private - building' }
InterfazPartida >> construirTablero [
    "Un solo morph dibuja el monitor, el tablero y el gato continuo (ver TableroMorph).
     Se centra dentro del panel de la derecha."
    vistaTablero := (Smalltalk globals at: #TableroMorph) partida: partida sprites: sprites.
    self addMorph: vistaTablero.
    vistaTablero position: self position + ((498 - (vistaTablero width // 2)) @ 146).
    ^ self

]

{ #category : 'initialization' }
InterfazPartida >> crearEstrellas [
	"Pixeles y destellos fijos del fondo (misma semilla, siempre iguales)"
	| azar colores |
	azar := Random seed: 7.
	colores := { self colorMorado. self colorVerde. self colorCrema. self colorNaranja }.
	estrellas := (1 to: 90) collect: [ :indice |
		{ ((azar next * 760) rounded @ (azar next * 628) rounded).
		  (azar next < 0.8 ifTrue: [ 2 ] ifFalse: [ 3 ]).
		  ((colores at: (indice \\ colores size) + 1) alpha: 0.35 + (azar next * 0.5)).
		  (azar next < 0.7 ifTrue: [ #pixel ] ifFalse: [ #destello ]) } ].
	^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarAvatarEn: aCanvas [
	"El protagonista en la parte de abajo del panel de controles"
	| centroX arriba globo fuente |
	avatar ifNil: [ ^ self ].
	centroX := self left + 126.
	arriba := self top + 408.
	aCanvas
		fillOval: (Rectangle center: centroX @ (arriba + 58) extent: 136 @ 136)
		color: (self colorMorado alpha: 0.22).
	aCanvas translucentImage: avatar at: (centroX - (avatar width // 2)) @ arriba.
	globo := ((centroX + 38) @ (arriba - 6)) extent: 44 @ 24.
	aCanvas fillRectangle: globo color: self colorMarco.
	aCanvas frameRectangle: globo width: 2 color: self colorCrema.
	fuente := self fuente: 11.
	aCanvas drawString: '</>' at: (globo left + 12) @ (globo top + 4) font: fuente color: self colorVerde.
	aCanvas drawString: 'Longcat - Protagonista' at: (self left + 52) @ (arriba + 126) font: fuente color: self colorNaranja.
	aCanvas drawString: 'Nerd, gamer y adicto al cafe' at: (self left + 44) @ (arriba + 146) font: (self fuente: 10) color: self colorLavanda.
	^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarEncabezadoEn: aCanvas [
	| franja fuenteTitulo fuenteNota x nota |
	franja := self topLeft extent: self width @ 70.
	aCanvas fillRectangle: franja color: (self colorMarco alpha: 0.6).
	aCanvas fillRectangle: ((self left @ (franja bottom - 3)) extent: self width @ 2) color: self colorMorado.
	aCanvas fillRectangle: ((self left @ (franja bottom - 1)) extent: self width @ 1) color: self colorVerde.
	"Titulo con sombra morada"
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
		color: self colorLavanda.
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
InterfazPartida >> dibujarEstrella: unaEstrella en: aCanvas [
	| centro tamano color |
	centro := self position + (unaEstrella at: 1).
	tamano := unaEstrella at: 2.
	color := unaEstrella at: 3.
	(unaEstrella at: 4) = #pixel
		ifTrue: [ aCanvas fillRectangle: (centro extent: tamano @ tamano) color: color ]
		ifFalse: [
			aCanvas fillRectangle: (Rectangle center: centro extent: (tamano * 5) @ tamano) color: color.
			aCanvas fillRectangle: (Rectangle center: centro extent: tamano @ (tamano * 5)) color: color ].
	^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarFondoEn: aCanvas [
	| bandas alto oscuro claro grilla |
	oscuro := Color r: 20 g: 16 b: 36 range: 255.
	claro := Color r: 46 g: 40 b: 74 range: 255.
	bandas := 40.
	alto := (self height / bandas) ceiling.
	0 to: bandas - 1 do: [ :indice |
		aCanvas
			fillRectangle: ((self left @ (self top + (indice * alto))) extent: self width @ alto)
			color: (claro mixed: indice / (bandas - 1) with: oscuro) ].
	grilla := self colorMorado alpha: 0.08.
	(self left to: self right by: 24) do: [ :x |
		aCanvas fillRectangle: ((x @ self top) extent: 1 @ self height) color: grilla ].
	(self top to: self bottom by: 24) do: [ :y |
		aCanvas fillRectangle: ((self left @ y) extent: self width @ 1) color: grilla ].
	estrellas ifNotNil: [
		estrellas do: [ :estrella | self dibujarEstrella: estrella en: aCanvas ] ].
	^ self

]

{ #category : 'private - drawing' }
InterfazPartida >> dibujarPanel: unRectangulo titulo: unTitulo en: aCanvas [
	"Tarjeta oscura con borde neon y una etiqueta arriba, como la ficha del personaje"
	| caja fuente anchoIcono anchoTitulo chip |
	caja := unRectangulo translateBy: self position.
	aCanvas fillRectangle: (caja translateBy: 4 @ 4) color: (Color black alpha: 0.35).
	aCanvas fillRectangle: caja color: (self colorPizarra alpha: 0.92).
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
	"Fondo gamer: degradado, grilla neon, pixeles, encabezado y paneles. Los botones y textos se dibujan encima."
	self dibujarFondoEn: aCanvas.
	self dibujarEncabezadoEn: aCanvas.
	self dibujarPanel: (16 @ 84 corner: 236 @ 612) titulo: 'Controles' en: aCanvas.
	self dibujarPanel: (252 @ 84 corner: 744 @ 612) titulo: 'Partida en curso' en: aCanvas.
	self dibujarAvatarEn: aCanvas

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
    self extent: 760 @ 628.
    self color: self colorMarco.
    self crearEstrellas.
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
    texto color: self colorCrema.
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
