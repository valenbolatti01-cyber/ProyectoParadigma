"
Componente cohesivo de interfaz encargado exclusivamente de los botones de direccion (^, v, <, >) y la entrada por teclado.
"
Class {
	#name : 'PanelControlesMorph',
	#superclass : 'PanelLongcatMorph',
	#instVars : [
		'botones',
		'textos'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'building' }
PanelControlesMorph >> construirControles [
    textos at: #mover put: (self nuevoTexto: 'Mover' color: EstiloLongcat colorVerde tamano: 12).
    botones at: #arriba put: (self nuevoBotonDireccion: '^' direccion: Arriba new).
    botones at: #izquierda put: (self nuevoBotonDireccion: '<' direccion: Izquierda new).
    botones at: #abajo put: (self nuevoBotonDireccion: 'v' direccion: Abajo new).
    botones at: #derecha put: (self nuevoBotonDireccion: '>' direccion: Derecha new).
    textos at: #ayuda1 put: (self nuevoTexto: 'Usa los botones o las flechas.' color: EstiloLongcat colorLavandaSuave tamano: 10).
    textos at: #ayuda2 put: (self nuevoTexto: 'Cada movimiento va hasta chocar.' color: EstiloLongcat colorLavandaSuave tamano: 10).
    self reacomodar.
    ^ self
]

{ #category : 'event handling' }
PanelControlesMorph >> direccionParaTecla: unaTecla [
    unaTecla isArrowUp ifTrue: [ ^ Arriba new ].
    unaTecla isArrowDown ifTrue: [ ^ Abajo new ].
    unaTecla isArrowLeft ifTrue: [ ^ Izquierda new ].
    unaTecla isArrowRight ifTrue: [ ^ Derecha new ].
    ^ nil
]

{ #category : 'drawing' }
PanelControlesMorph >> drawOn: aCanvas [
    EstiloLongcat dibujarPanel: self bounds titulo: 'Controles' en: aCanvas
]

{ #category : 'event handling' }
PanelControlesMorph >> handlesKeyboard: anEvent [
    ^ true
]

{ #category : 'initialization' }
PanelControlesMorph >> initialize [
    super initialize.
    botones := Dictionary new.
    textos := Dictionary new.
    self extent: 228 @ 180.
    ^ self
]

{ #category : 'event handling' }
PanelControlesMorph >> keyDown: anEvent [
    | direccion |
    direccion := self direccionParaTecla: anEvent key.
    direccion ifNotNil: [
        self solicitarMovimiento: direccion.
        ^ self ].
    ^ super keyDown: anEvent
]

{ #category : 'event handling' }
PanelControlesMorph >> keyStroke: anEvent [
    ^ false
]

{ #category : 'private - building' }
PanelControlesMorph >> nuevoBotonDireccion: unaEtiqueta direccion: unaDireccion [
    | boton |
    boton := SimpleButtonMorph new.
    boton label: unaEtiqueta.
    boton target: self.
    boton actionSelector: #solicitarMovimiento:.
    boton arguments: (Array with: unaDireccion).
    boton extent: 42 @ 36.
    self addMorph: boton.
    ^ boton
]

{ #category : 'layout' }
PanelControlesMorph >> reacomodar [
    | origen centroX |
    botones isEmpty ifTrue: [ ^ self ].
    origen := self position.
    centroX := self width // 2.
    (textos at: #mover) position: origen + (16 @ 28).
    (botones at: #arriba) position: origen + ((centroX - 21) @ 50).
    (botones at: #izquierda) position: origen + ((centroX - 68) @ 92).
    (botones at: #abajo) position: origen + ((centroX - 21) @ 92).
    (botones at: #derecha) position: origen + ((centroX + 26) @ 92).
    (textos at: #ayuda1) position: origen + (16 @ 136).
    (textos at: #ayuda2) position: origen + (16 @ 154).
    ^ self
]

{ #category : 'actions' }
PanelControlesMorph >> solicitarMovimiento: unaDireccion [
    controlador ifNotNil: [ :destino | destino moverCon: unaDireccion ].
    self takeKeyboardFocus.
    ^ self
]

{ #category : 'event handling' }
PanelControlesMorph >> takesKeyboardFocus [
    ^ true
]
