"
Componente cohesivo de interfaz que renderiza la barra de seleccion de nivel, navegacion anterior/siguiente, progreso de completados y avisos de bloqueo.
"
Class {
	#name : 'PanelNivelesMorph',
	#superclass : 'PanelLongcatMorph',
	#instVars : [
		'botonAnterior',
		'botonSiguiente',
		'textoProgreso',
		'textoIrA',
		'textoAviso',
		'avisoHasta',
		'botonesNivel',
		'cantidadActual'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'updating' }
PanelNivelesMorph >> actualizarConProgreso: unProgreso [
    self sincronizarCantidadNiveles: unProgreso cantidadNiveles.
    textoProgreso contents: 'Niveles completados: ', unProgreso textoCompletados.
    botonesNivel withIndexDo: [ :boton :numero |
        boton color: (self colorParaEstadoNivel: (unProgreso estadoNivel: numero)) ].
    self changed.
    ^ self
]

{ #category : 'private - updating' }
PanelNivelesMorph >> colorParaEstadoNivel: unEstado [
    | colores |
    colores := {
        #actual -> EstiloLongcat colorNaranja.
        #desbloqueado -> EstiloLongcat colorVerdeDesbloqueado.
        #bloqueado -> EstiloLongcat colorGrisBloqueado } asDictionary.
    ^ colores at: unEstado ifAbsent: [ EstiloLongcat colorGrisBloqueado ]
]

{ #category : 'building' }
PanelNivelesMorph >> construirControles [
    textoProgreso := self nuevoTexto: '' color: EstiloLongcat colorCrema tamano: 11.
    textoIrA := self nuevoTexto: 'Ir al nivel (se desbloquea al completar el anterior):' color: EstiloLongcat colorLavandaSuave tamano: 10.
    textoAviso := self nuevoTexto: '' color: EstiloLongcat colorRojoAlerta tamano: 11.
    botonAnterior := self nuevoBoton: 'Nivel anterior' accion: #nivelAnterior tamano: 104 @ 28.
    botonSiguiente := self nuevoBoton: 'Siguiente nivel' accion: #siguienteNivel tamano: 104 @ 28.
    self reacomodar.
    ^ self
]

{ #category : 'drawing' }
PanelNivelesMorph >> drawOn: aCanvas [
    EstiloLongcat dibujarPanel: self bounds titulo: 'Niveles' en: aCanvas
]

{ #category : 'initialization' }
PanelNivelesMorph >> initialize [
    super initialize.
    botonesNivel := OrderedCollection new.
    cantidadActual := 0.
    self extent: 760 @ 132.
    ^ self
]

{ #category : 'messages' }
PanelNivelesMorph >> limpiarAviso [
    textoAviso contents: ''.
    avisoHasta := nil.
    ^ self
]

{ #category : 'messages' }
PanelNivelesMorph >> mostrarAviso: unTexto [
    textoAviso contents: unTexto.
    avisoHasta := Time millisecondClockValue + 3500.
    self changed.
    ^ self
]

{ #category : 'private - building' }
PanelNivelesMorph >> nuevoBoton: unaEtiqueta accion: unSelector tamano: unTamano [
    | boton |
    boton := SimpleButtonMorph new.
    boton label: unaEtiqueta.
    boton target: controlador.
    boton actionSelector: unSelector.
    boton extent: unTamano.
    self addMorph: boton.
    ^ boton
]

{ #category : 'layout' }
PanelNivelesMorph >> reacomodar [
    | origen anchoUtil cantidad anchoBoton paso total inicio |
    textoProgreso ifNil: [ ^ self ].
    origen := self position.
    textoProgreso position: origen + (16 @ 28).
    botonSiguiente position: origen + ((self width - 120) @ 22).
    botonAnterior position: origen + ((self width - 232) @ 22).
    textoIrA position: origen + (16 @ 50).
    textoAviso position: origen + (16 @ 68).
    cantidad := botonesNivel size.
    cantidad = 0 ifTrue: [ ^ self ].
    anchoUtil := (self width - 40) max: 120.
    anchoBoton := (((anchoUtil // cantidad) - 6) min: 44) max: 24.
    paso := cantidad > 1
        ifTrue: [ (((anchoUtil - anchoBoton) // (cantidad - 1)) min: (anchoBoton + 18)) max: (anchoBoton + 4) ]
        ifFalse: [ 0 ].
    total := ((cantidad - 1) * paso) + anchoBoton.
    inicio := ((self width - total) // 2) max: 16.
    botonesNivel withIndexDo: [ :boton :indice |
        boton extent: anchoBoton @ 28.
        boton position: origen + ((inicio + ((indice - 1) * paso)) @ (self height - 42)) ].
    ^ self
]

{ #category : 'stepping' }
PanelNivelesMorph >> revisarAviso [
    (avisoHasta notNil and: [ Time millisecondClockValue > avisoHasta ])
        ifTrue: [ self limpiarAviso ].
    ^ self
]

{ #category : 'private - building' }
PanelNivelesMorph >> sincronizarCantidadNiveles: unaCantidad [
    | boton |
    cantidadActual = unaCantidad ifTrue: [ ^ self ].
    botonesNivel do: [ :anterior | anterior delete ].
    botonesNivel removeAll.
    1 to: unaCantidad do: [ :numero |
        boton := self nuevoBoton: numero asString accion: #irANivel: tamano: 40 @ 28.
        boton arguments: (Array with: numero).
        botonesNivel add: boton ].
    cantidadActual := unaCantidad.
    self reacomodar.
    ^ self
]
