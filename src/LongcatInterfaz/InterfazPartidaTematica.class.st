"
Interfaz de partida de un mundo ilustrado. Conserva los paneles de siempre (controles, estado, niveles y marcador) y cambia, a traves de su TemaTematico, el tablero, el protagonista y el cartel de resultado; ademas agrega el panel de reglas junto al tablero.
"
Class {
	#name : 'InterfazPartidaTematica',
	#superclass : 'InterfazPartida',
	#instVars : [
		'tema',
		'panelReglas'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'instance creation' }
InterfazPartidaTematica class >> app: unaApp progreso: unProgreso tema: unTema [
	^ (self app: unaApp progreso: unProgreso) setTema: unTema
]

{ #category : 'private - updating' }
InterfazPartidaTematica >> actualizarVista [
	super actualizarVista.
	panelReglas ifNotNil: [ panelReglas actualizarConProgreso: progreso ].
	^ self
]

{ #category : 'private - layout' }
InterfazPartidaTematica >> anchoPanelReglas [
	^ 200
]

{ #category : 'private - victory' }
InterfazPartidaTematica >> celebrarVictoria [
	| esElUltimo nivel |
	esElUltimo := progreso esUltimoNivel.
	nivel := progreso nivelActualObjeto.
	animacion := ResultadoNivelMorph
		sobre: self
		centro: self center
		mensaje: (esElUltimo
			ifTrue: [ '¡MUNDO COMPLETADO!' ]
			ifFalse: [ '¡NIVEL COMPLETADO!' ])
		detalle: 'Movimientos: ', partida cantidadMovimientos asString, '  (mínimo posible: ', nivel rango minimo asString, ')'
		estrellas: estrellasObtenidas
		hayNivelSiguiente: esElUltimo not
		alSiguiente: [ self terminarVictoria ]
		alReintentar: [ self reiniciarNivel ].
	self addMorph: animacion.
	animacion startStepping.
	^ self
]

{ #category : 'skins' }
InterfazPartidaTematica >> claveProtagonista [
	^ tema claveProtagonista
]

{ #category : 'building' }
InterfazPartidaTematica >> construir [
	super construir.
	panelReglas := PanelReglasMorph controlador: self tema: tema.
	self addMorph: panelReglas.
	^ self
]

{ #category : 'private - building' }
InterfazPartidaTematica >> crearVistaTablero [
	^ tema
		crearTableroPara: partida
		skin: self skinDelTablero
		imagenes: self
]

{ #category : 'layout' }
InterfazPartidaTematica >> reacomodar [
	super reacomodar.
	panelReglas ifNotNil: [ panelReglas bounds: self rectanguloPanelReglas ].
	^ self
]

{ #category : 'private - layout' }
InterfazPartidaTematica >> rectanguloAreaTablero [
	"El tablero se centra en lo que deja libre el panel de reglas"
	| area |
	area := super rectanguloAreaTablero.
	^ area topLeft corner: ((area right - self anchoPanelReglas - 12) @ area bottom)
]

{ #category : 'private - layout' }
InterfazPartidaTematica >> rectanguloPanelReglas [
	| area |
	area := super rectanguloAreaTablero.
	^ ((area right - self anchoPanelReglas - 8) @ area top) corner: ((area right - 8) @ area bottom)
]

{ #category : 'initialization' }
InterfazPartidaTematica >> setTema: unTema [
	tema := unTema.
	^ self
]

{ #category : 'skins' }
InterfazPartidaTematica >> skinDelTablero [
	"El gato del tablero es el mismo personaje del panel de estado: la skin del tema, si sus imagenes estan en assets"
	^ (tema skinConImagenes: self) ifNil: [ super skinDelTablero ]
]
