"
Superclase abstracta para los paneles de la interfaz de partida. Centraliza la referencia al controlador, el reacomodamiento al cambiar bounds y la creacion de etiquetas de texto.
"
Class {
	#name : 'PanelLongcatMorph',
	#superclass : 'Morph',
	#instVars : [
		'controlador'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
PanelLongcatMorph class >> controlador: unControlador [
    ^ self new setControlador: unControlador
]

{ #category : 'layout' }
PanelLongcatMorph >> bounds: unRectangulo [
    super bounds: unRectangulo.
    self reacomodar
]

{ #category : 'building' }
PanelLongcatMorph >> construirControles [
    ^ self
]

{ #category : 'initialization' }
PanelLongcatMorph >> initialize [
    super initialize.
    self color: Color transparent.
    ^ self
]

{ #category : 'private - building' }
PanelLongcatMorph >> nuevoTexto: unContenido color: unColor tamano: unTamano [
    | texto |
    texto := StringMorph new contents: unContenido.
    texto font: (EstiloLongcat fuente: unTamano).
    texto color: unColor.
    self addMorph: texto.
    ^ texto
]

{ #category : 'layout' }
PanelLongcatMorph >> reacomodar [
    self subclassResponsibility
]

{ #category : 'initialization' }
PanelLongcatMorph >> setControlador: unControlador [
    controlador := unControlador.
    self construirControles.
    ^ self
]
