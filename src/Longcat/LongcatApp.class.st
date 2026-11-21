"
Ventana principal del juego. Carga los PNG una sola vez, gestiona la skin activa y los objetos ProgresoJuego por coleccion, y coordina la navegacion entre pantallas. Se abre con: LongcatApp abrir.
"
Class {
	#name : 'LongcatApp',
	#superclass : 'Morph',
	#instVars : [
		'pantalla',
		'progresos',
		'partidasAbiertas',
		'imagenes',
		'skinActual'
	],
	#classInstVars : [
		'carpetaImagenes'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
LongcatApp class >> abrir [
	^ self new abrir
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes [
	| candidatas contiene encontrada elegida soloGato |
	contiene := [ :carpeta :nombresPedidos |
		[ | nombres |
		carpeta exists and: [
			nombres := ((carpeta allChildren select: [ :archivo | archivo isFile ])
				collect: [ :archivo | archivo basename asLowercase ]) asSet.
			nombresPedidos allSatisfy: [ :nombre | nombres includes: nombre ] ] ]
			on: Error do: [ :e | false ] ].
	candidatas := OrderedCollection new.
	carpetaImagenes ifNotNil: [ :ruta | candidatas add: ruta asFileReference ].
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
		carpetaImagenes := elegida asFileReference.
		^ carpetaImagenes ].
	soloGato := candidatas detect: [ :carpeta |
		contiene value: carpeta value: #('gato abajo.png') ] ifNone: [ nil ].
	^ soloGato ifNil: [ FileLocator imageDirectory resolve ]
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes: unaRuta [
	carpetaImagenes := unaRuta ifNotNil: [ unaRuta asFileReference ].
	^ carpetaImagenes
]

{ #category : 'opening' }
LongcatApp >> abrir [
	self cargarImagenes.
	skinActual := SkinGato originalConImagenes: imagenes.
	self openInWindowLabeled: 'Longcat.exe'.
	self irAlMenu.
	self startStepping.
	^ self
]

{ #category : 'images' }
LongcatApp >> archivosDeImagenes [
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
	| raiz nombres faltantes clave |
	raiz := self class carpetaDeImagenes.
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
	skinActual := unaSkin.
	progresos valuesDo: [ :unProgreso | unProgreso equiparSkin: unaSkin ].
	partidasAbiertas valuesDo: [ :interfaz | interfaz actualizarSkin ].
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
	imagenes := Dictionary new.
	progresos := Dictionary new.
	partidasAbiertas := Dictionary new.
	skinActual := SkinGato original.
	self extent: 1040 @ 660.
	self color: EstiloLongcat colorFondoArriba.
	^ self
]

{ #category : 'navigation' }
LongcatApp >> irAlMenu [
	^ self mostrar: (MenuPrincipalMorph app: self)
]

{ #category : 'navigation' }
LongcatApp >> jugarColeccion: unaColeccion [
	| interfaz progreso |
	unaColeccion estaDisponible ifFalse: [ ^ self ].
	progreso := self progresoPara: unaColeccion.
	interfaz := partidasAbiertas
		at: unaColeccion class
		ifAbsentPut: [ InterfazPartida app: self progreso: progreso ].
	^ self mostrar: interfaz
]

{ #category : 'navigation' }
LongcatApp >> jugarNiveles [
	^ self jugarColeccion: ColeccionNiveles normales
]

{ #category : 'navigation' }
LongcatApp >> jugarPersonalizados [
	^ self mostrar: (MenuPersonalizadosMorph app: self)
]

{ #category : 'navigation' }
LongcatApp >> mostrar: unaPantalla [
	pantalla ifNotNil: [ :actual | actual == unaPantalla ifFalse: [ actual delete ] ].
	pantalla := unaPantalla.
	unaPantalla owner == self ifFalse: [ self addMorph: unaPantalla ].
	unaPantalla bounds: self bounds.
	unaPantalla alMostrarse.
	unaPantalla startStepping.
	unaPantalla takeKeyboardFocus.
	^ unaPantalla
]

{ #category : 'progression' }
LongcatApp >> progresoPara: unaColeccion [
	^ progresos
		at: unaColeccion class
		ifAbsentPut: [ ProgresoJuego conColeccion: unaColeccion skin: skinActual ]
]

{ #category : 'navigation' }
LongcatApp >> salir [
	| ventana |
	self stopStepping.
	ventana := self ownerThatIsA: SystemWindow.
	ventana ifNil: [ ^ self delete ].
	^ ventana delete
]

{ #category : 'skins' }
LongcatApp >> skin [
	^ skin

]

{ #category : 'skins' }
LongcatApp >> skinActual [
	^ skinActual
]

{ #category : 'skins' }
LongcatApp >> skinsDisponibles [
	^ { SkinGato originalConImagenes: imagenes }
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
