"
Verifica que cada mundo elige su tema sin preguntar por clases, que los temas declaran sus imagenes y que las interfaces de partida (clasica y tematica) arman el marcador y cuentan movimientos y estrellas.
"
Class {
	#name : 'TemaMundoTest',
	#superclass : 'TestCase',
	#category : 'LongcatTests',
	#package : 'LongcatTests'
}

{ #category : 'support' }
TemaMundoTest >> interfazDe: unaColeccion [
	| tema interfaz |
	tema := TemaMundo paraColeccion: unaColeccion.
	interfaz := tema crearInterfazPara: nil progreso: (ProgresoJuego conColeccion: unaColeccion).
	interfaz alMostrarse.
	^ interfaz
]

{ #category : 'support' }
TemaMundoTest >> jugar: unaSolucion en: unaInterfaz [
	unaSolucion do: [ :simbolo |
		unaInterfaz moverCon: (Direccion desdeSimbolo: simbolo) ]
]

{ #category : 'support' }
TemaMundoTest >> morphsDe: unaClase en: unaInterfaz [
	^ unaInterfaz submorphs select: [ :morph | morph isKindOf: unaClase ]
]

{ #category : 'tests - themes' }
TemaMundoTest >> testCadaMundoEligeSuTemaPorIdentificador [
	self assert: (TemaMundo paraColeccion: NivelesMinecraft new) class = TemaMinecraft.
	self assert: (TemaMundo paraColeccion: NivelesNormales new) class = TemaClasico
]

{ #category : 'tests - themes' }
TemaMundoTest >> testCadaMundoPersonalizadoTieneSuPropioTema [
	self assert: (TemaMundo paraColeccion: NivelesPokemon new) class = TemaPokemon.
	self assert: (TemaMundo paraColeccion: NivelesDragonBall new) class = TemaDragonBall
]

{ #category : 'tests - interface' }
TemaMundoTest >> testEnElUltimoNivelNoHayBotonSiguiente [
	| interfaz resultado progreso |
	progreso := ProgresoJuego conColeccion: NivelesMinecraft new.
	[ progreso nivelMaximo < 10 ] whileTrue: [
		progreso registrarVictoriaConMovimientos: 9.
		progreso avanzarNivel ].
	progreso irANivel: 10.
	interfaz := (TemaMundo paraColeccion: NivelesMinecraft new) crearInterfazPara: nil progreso: progreso.
	interfaz alMostrarse.
	self jugar: progreso nivelActualObjeto solucionMinima en: interfaz.
	resultado := (self morphsDe: ResultadoNivelMorph en: interfaz) anyOne.
	resultado mostrarCompleto.
	resultado clickEn: resultado rectanguloBotonSiguiente center.
	self assert: (self morphsDe: ResultadoNivelMorph en: interfaz) size = 1.
	self assert: progreso nivelActual = 10
]

{ #category : 'tests - interface' }
TemaMundoTest >> testGanarUnNivelConLaSolucionMaximaDaUnaEstrella [
	| interfaz nivel |
	interfaz := self interfazDe: NivelesMinecraft new.
	nivel := interfaz progreso nivelActualObjeto.
	self jugar: nivel solucionMaxima en: interfaz.
	self assert: interfaz partida estaGanada.
	self assert: (interfaz progreso estrellasNivel: 1) = 1
]

{ #category : 'tests - interface' }
TemaMundoTest >> testGanarUnNivelConLaSolucionMinimaDaTresEstrellas [
	| interfaz nivel |
	interfaz := self interfazDe: NivelesMinecraft new.
	nivel := interfaz progreso nivelActualObjeto.
	self jugar: nivel solucionMinima en: interfaz.
	self assert: interfaz partida estaGanada.
	self assert: interfaz partida cantidadMovimientos = nivel rango minimo.
	self assert: (interfaz progreso estrellasNivel: 1) = 3.
	self assert: (self morphsDe: ResultadoNivelMorph en: interfaz) size = 1
]

{ #category : 'tests - interface' }
TemaMundoTest >> testLaInterfazDeUnMundoEsTematicaYLaDeLosNivelesNormalesEsClasica [
	ColeccionNiveles personalizadas do: [ :coleccion |
		self assert: (self interfazDe: coleccion) class = InterfazPartidaTematica description: coleccion nombre ].
	self assert: (self interfazDe: NivelesNormales new) class = InterfazPartida
]

{ #category : 'tests - interface' }
TemaMundoTest >> testLosBotonesDelResultadoNoRespondenAntesDeTerminarLaAnimacion [
	| interfaz resultado |
	interfaz := self interfazDe: NivelesMinecraft new.
	self jugar: interfaz progreso nivelActualObjeto solucionMinima en: interfaz.
	resultado := (self morphsDe: ResultadoNivelMorph en: interfaz) anyOne.
	resultado clickEn: resultado rectanguloBotonSiguiente center.
	self assert: (self morphsDe: ResultadoNivelMorph en: interfaz) size = 1.
	self assert: interfaz progreso nivelActual = 1
]

{ #category : 'tests - interface' }
TemaMundoTest >> testLosNivelesNormalesGanadosNoOtorganEstrellasNiCartelDeResultado [
	| interfaz nivel |
	interfaz := self interfazDe: NivelesNormales new.
	nivel := interfaz progreso nivelActualObjeto.
	self jugar: nivel solucion en: interfaz.
	self assert: interfaz partida estaGanada.
	self assert: (interfaz progreso estrellasNivel: 1) = 0.
	self assert: (self morphsDe: ResultadoNivelMorph en: interfaz) isEmpty.
	self assert: (self morphsDe: VictoriaMorph en: interfaz) size = 1
]

{ #category : 'tests - themes' }
TemaMundoTest >> testLosTemasDeclaranLasImagenesQueUsan [
	| claves tema |
	claves := TemaMundo archivosDeImagenes collect: [ :par | par key ].
	tema := TemaMinecraft new.
	{ tema claveCasillaLibre. tema claveCasillaRecorrida. tema claveObstaculo.
	  tema claveProtagonista. tema claveTituloReglas. tema claveSeparador } do: [ :clave |
		self assert: (claves includes: clave) description: clave ]
]

{ #category : 'tests - themes' }
TemaMundoTest >> testLosTresTemasUsanImagenesPropias [
	| claves |
	claves := OrderedCollection new.
	{ TemaMinecraft new. TemaPokemon new. TemaDragonBall new } do: [ :tema |
		claves
			add: tema claveCasillaLibre;
			add: tema claveCasillaRecorrida;
			add: tema claveObstaculo;
			add: tema claveProtagonista;
			add: tema claveTituloReglas;
			add: tema claveSeparador ].
	self assert: claves asSet size = claves size.
	claves do: [ :clave |
		self
			assert: ((TemaMundo archivosDeImagenes collect: [ :par | par key ]) includes: clave)
			description: clave ]
]

{ #category : 'tests - interface' }
TemaMundoTest >> testReiniciarElNivelVuelveElContadorACero [
	| interfaz |
	interfaz := self interfazDe: NivelesMinecraft new.
	interfaz moverCon: (Direccion todas detect: [ :candidata | interfaz partida puedeMoverseEn: candidata ]).
	self assert: interfaz partida cantidadMovimientos = 1.
	interfaz reiniciarNivel.
	self assert: interfaz partida cantidadMovimientos = 0.
	self assert: interfaz partida estaActiva
]

{ #category : 'tests - interface' }
TemaMundoTest >> testReintentarDesdeElResultadoReiniciaElNivelYElContador [
	| interfaz resultado |
	interfaz := self interfazDe: NivelesMinecraft new.
	self jugar: interfaz progreso nivelActualObjeto solucionMinima en: interfaz.
	resultado := (self morphsDe: ResultadoNivelMorph en: interfaz) anyOne.
	resultado mostrarCompleto.
	resultado clickEn: resultado rectanguloBotonReintentar center.
	self assert: (self morphsDe: ResultadoNivelMorph en: interfaz) isEmpty.
	self assert: interfaz partida cantidadMovimientos = 0.
	self assert: interfaz partida estaActiva.
	self assert: interfaz progreso nivelActual = 1.
	self assert: (interfaz progreso estrellasNivel: 1) = 3
]

{ #category : 'tests - interface' }
TemaMundoTest >> testSiguienteNivelDesdeElResultadoCargaElNivelDosSinMovimientos [
	| interfaz resultado |
	interfaz := self interfazDe: NivelesMinecraft new.
	self jugar: interfaz progreso nivelActualObjeto solucionMinima en: interfaz.
	resultado := (self morphsDe: ResultadoNivelMorph en: interfaz) anyOne.
	resultado mostrarCompleto.
	resultado clickEn: resultado rectanguloBotonSiguiente center.
	self assert: interfaz progreso nivelActual = 2.
	self assert: interfaz partida cantidadMovimientos = 0.
	self assert: interfaz partida estaActiva
]

{ #category : 'tests - themes' }
TemaMundoTest >> testUnMundoSinTemaPropioUsaElTemaClasico [
	"Los niveles normales no tienen tema ilustrado; tampoco un mundo desconocido"
	self assert: (TemaMundo paraColeccion: NivelesNormales new) class = TemaClasico
]

{ #category : 'tests - interface' }
TemaMundoTest >> testUnaAccionSinDesplazamientoNoCuentaEnLaInterfaz [
	| interfaz direccion |
	interfaz := self interfazDe: NivelesMinecraft new.
	direccion := Direccion todas detect: [ :candidata | interfaz partida puedeMoverseEn: candidata ].
	interfaz moverCon: direccion.
	interfaz moverCon: direccion.
	interfaz moverCon: direccion.
	self assert: interfaz partida cantidadMovimientos = 1
]
