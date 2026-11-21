"
Ventana principal del juego. Carga las imagenes una sola vez y cambia de pantalla: menu principal, niveles normales (InterfazPartida), niveles personalizados y skins. Guarda la partida de niveles normales para que el progreso no se pierda al volver al menu. Se abre con: LongcatApp abrir.
"
Class {
	#name : 'LongcatApp',
	#superclass : 'Morph',
	#instVars : [
		'pantalla',
		'juego',
		'imagenes',
		'skin'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
LongcatApp class >> abrir [
	"LongcatApp abrir: abre el juego desde el menu principal"
	^ self new abrir

]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes [
	"Devuelve la carpeta donde estan los PNG del juego. Busca una que tenga los PNG del gato
	 Y los del menu (no alcanza con encontrar solo 'Gato abajo.png', porque puede haber otra
	 copia incompleta en otro lado). Prueba en orden: LongcatCarpeta, la carpeta de la imagen
	 de Pharo, la carpeta de trabajo, Escritorio, Documentos y Descargas. Si ninguna esta
	 completa, le pide al usuario que elija la carpeta assets y se acuerda de la eleccion."
	| candidatas contiene encontrada elegida soloGato |
	contiene := [ :carpeta :nombresPedidos |
		[ | nombres |
		carpeta exists and: [
			nombres := ((carpeta allChildren select: [ :archivo | archivo isFile ])
				collect: [ :archivo | archivo basename asLowercase ]) asSet.
			nombresPedidos allSatisfy: [ :nombre | nombres includes: nombre ] ] ]
			on: Error do: [ :e | false ] ].
	candidatas := OrderedCollection new.
	Smalltalk globals at: #LongcatCarpeta ifPresent: [ :ruta | candidatas add: ruta asFileReference ].
	candidatas add: FileLocator imageDirectory resolve.
	candidatas add: FileLocator workingDirectory resolve.
	[ candidatas
		add: FileLocator desktop resolve;
		add: FileLocator documents resolve;
		add: (FileLocator home / 'Downloads') resolve ]
		on: Error do: [ :e | nil ].
	encontrada := candidatas detect: [ :carpeta |
		contiene value: carpeta value: #('gato abajo.png' 'logo_longcat.png' 'boton_salir.png') ] ifNone: [ nil ].
	encontrada ifNotNil: [ ^ encontrada ].
	elegida := [ UIManager default chooseDirectory: 'Elegi la carpeta assets (la que tiene Gato abajo.png y logo_longcat.png)' ]
		on: Error do: [ :e | nil ].
	elegida ifNotNil: [
		Smalltalk globals at: #LongcatCarpeta put: elegida asFileReference.
		^ elegida asFileReference ].
	soloGato := candidatas detect: [ :carpeta |
		contiene value: carpeta value: #('gato abajo.png') ] ifNone: [ nil ].
	^ soloGato ifNil: [ FileLocator imageDirectory resolve ]

]

{ #category : 'opening' }
LongcatApp >> abrir [
	self cargarImagenes.
	self openInWindowLabeled: 'Longcat.exe'.
	self irAlMenu.
	self startStepping.
	^ self

]

{ #category : 'images' }
LongcatApp >> archivosDeImagenes [
	"Clave -> nombre del PNG en la carpeta sprites"
	^ {
		#cabezaAbajo -> 'Gato abajo.png'.
		#cabezaArriba -> 'Gato arriba.png'.
		#cabezaDerecha -> 'Gato derecha.png'.
		#cabezaIzquierda -> 'Gato izquierda.png'.
		#logo -> 'logo_longcat.png'.
		#protagonista -> 'protagonista_notebook.png'.
		#escritorio -> 'escritorio.png'.
		#taza -> 'taza.png'.
		#cartel -> 'cartel_codigo.png'.
		#ventana -> 'ventana.png'.
		#tableroDecorativo -> 'tablero_decorativo.png'.
		#estante -> 'estante_gatito_trofeo.png'.
		#planta -> 'planta_colgante.png'.
		#botonNormales -> 'boton_niveles_normales.png'.
		#botonPersonalizados -> 'boton_niveles_personalizados.png'.
		#botonSkins -> 'boton_skins.png'.
		#botonSalir -> 'boton_salir.png'.
		#minecraft -> 'Minecraft.png'.
		#pokemon -> 'Pokemon.png'.
		#dragonBall -> 'Dragon_Ball.png' }

]

{ #category : 'images' }
LongcatApp >> cargarImagenes [
	"Busca los PNG una sola vez dentro de LongcatCarpeta (o de la carpeta de la imagen de Pharo).
	 Si falta una imagen del menu se dibuja un reemplazo; las del gato son obligatorias."
	| raiz nombres faltantes clave |
	raiz := (Smalltalk globals at: #LongcatApp) carpetaDeImagenes.
	nombres := Dictionary new.
	self archivosDeImagenes do: [ :par | nombres at: par value asLowercase put: par key ].
	imagenes := Dictionary new.
	raiz allChildren do: [ :archivo |
		(archivo isFile and: [ nombres includesKey: archivo basename asLowercase ]) ifTrue: [
			clave := nombres at: archivo basename asLowercase.
			(imagenes includesKey: clave) ifFalse: [
				imagenes at: clave put: (ImageReadWriter formFromFileNamed: archivo fullName) ] ] ].
	faltantes := #(#cabezaAbajo #cabezaArriba #cabezaDerecha #cabezaIzquierda)
		reject: [ :unaClave | imagenes includesKey: unaClave ].
	faltantes isEmpty ifFalse: [
		^ self error: 'No encuentro las imagenes del gato (Gato abajo.png, Gato arriba.png...) dentro de: ', raiz fullName ].
	^ imagenes

]

{ #category : 'skins' }
LongcatApp >> elegirSkin: unaSkin [
	skin := unaSkin.
	juego ifNotNil: [ :partidaAbierta | partidaAbierta usarSprites: self spritesDelGato ].
	pantalla ifNotNil: [ :actual | actual refrescar ].
	^ self

]

{ #category : 'images' }
LongcatApp >> imagen: unaClave [
	^ imagenes at: unaClave ifAbsent: [ nil ]

]

{ #category : 'initialization' }
LongcatApp >> initialize [
	super initialize.
	skin := #original.
	imagenes := Dictionary new.
	self extent: 1040 @ 660.
	self color: EstiloLongcat colorFondoArriba.
	^ self

]

{ #category : 'navigation' }
LongcatApp >> irAlMenu [
	^ self mostrar: (MenuPrincipalMorph app: self)

]

{ #category : 'navigation' }
LongcatApp >> jugarNiveles [
	"Los 10 niveles de siempre. La partida se guarda: al volver del menu sigue donde estaba."
	juego ifNil: [ juego := (Smalltalk globals at: #InterfazPartida) app: self ].
	^ self mostrar: juego

]

{ #category : 'navigation' }
LongcatApp >> jugarPersonalizados [
	^ self mostrar: (MenuPersonalizadosMorph app: self)

]

{ #category : 'navigation' }
LongcatApp >> mostrar: unaPantalla [
	"Saca la pantalla actual y pone otra ocupando toda la ventana"
	pantalla ifNotNil: [ :actual | actual == unaPantalla ifFalse: [ actual delete ] ].
	pantalla := unaPantalla.
	unaPantalla owner == self ifFalse: [ self addMorph: unaPantalla ].
	unaPantalla bounds: self bounds.
	unaPantalla alMostrarse.
	unaPantalla startStepping.
	unaPantalla takeKeyboardFocus.
	^ unaPantalla

]

{ #category : 'navigation' }
LongcatApp >> salir [
	"Cierra la ventana del juego (Pharo sigue abierto)"
	| ventana |
	self stopStepping.
	ventana := self ownerThatIsA: (Smalltalk globals at: #SystemWindow).
	ventana ifNil: [ ^ self delete ].
	^ ventana delete

]

{ #category : 'skins' }
LongcatApp >> skin [
	^ skin

]

{ #category : 'skins' }
LongcatApp >> spritesDelGato [
	"Cabezas del gato para la skin elegida. Por ahora solo existe la original:
	 para agregar una skin nueva, cargar sus PNG con otras claves y devolverlas aca segun skin."
	| cabezas |
	cabezas := Dictionary new.
	#(#cabezaAbajo #cabezaArriba #cabezaDerecha #cabezaIzquierda) do: [ :unaClave |
		(self imagen: unaClave) ifNotNil: [ :forma | cabezas at: unaClave put: forma ] ].
	^ cabezas

]

{ #category : 'stepping' }
LongcatApp >> step [
	"La ventana agranda o achica la app; la pantalla actual la sigue"
	pantalla ifNil: [ ^ self ].
	pantalla bounds = self bounds ifFalse: [ pantalla bounds: self bounds ]

]

{ #category : 'stepping' }
LongcatApp >> stepTime [
	^ 50

]

{ #category : 'navigation' }
LongcatApp >> verSkins [
	^ self mostrar: (MenuSkinsMorph app: self)

]
