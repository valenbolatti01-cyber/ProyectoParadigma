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
		'rutas',
		'skinActual'
	],
	#classInstVars : [
		'carpetaImagenes'
	],
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
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
	candidatas addAll: self carpetasDelRepositorio.
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

{ #category : 'images' }
LongcatApp class >> carpetasDelRepositorio [
	"Carpeta assets del proyecto clonado con Iceberg (Documents/Pharo/iceberg/ProyectoParadigma/assets). Se prueba primero porque es directa: no hace falta recorrer todo Documents."
	^ [ {
		(FileLocator documents / 'Pharo' / 'iceberg' / 'ProyectoParadigma' / 'assets') resolve.
		(FileLocator home / 'Documents' / 'Pharo' / 'iceberg' / 'ProyectoParadigma' / 'assets') resolve } ]
		on: Error
		do: [ :e | #() ]
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
LongcatApp >> archivoDe: unaRutaRelativa entre: unosArchivos [
	"El archivo cuya ruta termina en la ruta relativa pedida (sin distinguir mayusculas), o nil"
	| sufijo |
	sufijo := '/', unaRutaRelativa asLowercase.
	^ unosArchivos
		detect: [ :archivo | (archivo fullName asLowercase copyReplaceAll: '\' with: '/') endsWith: sufijo ]
		ifNone: [ nil ]
]

{ #category : 'images' }
LongcatApp >> archivosDeImagenes [
	"Imagenes generales mas las de cada tema de mundo (cada TemaMundo declara las suyas)"
	^ self archivosGenerales , TemaMundo archivosDeImagenes
]

{ #category : 'images' }
LongcatApp >> archivosGenerales [
	"Clave -> ruta relativa dentro de la carpeta de assets (sirve el nombre solo o con subcarpetas)"
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
		#dragonBall -> 'Dragon_Ball.png'.
		#etiquetaMovimientos -> 'marcador general/etiqueta_movimientos.png'.
		#panelResultado -> 'marcador general/panel_resultado.png'.
		#estrellaDorada -> 'marcador general/estrella_dorada.png'.
		#estrellaGris -> 'marcador general/estrella_gris.png'.
		#botonSiguienteNivel -> 'marcador general/boton_siguiente_nivel.png'.
		#botonReintentar -> 'marcador general/boton_reintentar.png' }
]

{ #category : 'images' }
LongcatApp >> cargarImagenes [
	"Ubica los PNG una sola vez. Las cabezas del gato se cargan ya (la skin las necesita); el resto se lee la primera vez que alguna pantalla lo pide, para que abrir el juego no decodifique todos los PNG grandes de todos los mundos."
	| raiz archivos faltantes |
	raiz := self class carpetaDeImagenes.
	archivos := raiz allChildren select: [ :archivo | archivo isFile ].
	imagenes := Dictionary new.
	rutas := Dictionary new.
	self archivosDeImagenes do: [ :par |
		(self archivoDe: par value entre: archivos) ifNotNil: [ :archivo |
			rutas at: par key put: archivo ] ].
	self clavesDelGato do: [ :unaClave | self imagen: unaClave ].
	faltantes := self clavesDelGato reject: [ :unaClave | imagenes includesKey: unaClave ].
	faltantes isEmpty ifFalse: [
		^ self error: 'No encuentro las imagenes del gato (Gato abajo.png, Gato arriba.png...) dentro de: ', raiz fullName ].
	^ imagenes
]

{ #category : 'images' }
LongcatApp >> clavesDelGato [
	^ #(#cabezaAbajo #cabezaArriba #cabezaDerecha #cabezaIzquierda)
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
	"La imagen pedida (se lee del disco la primera vez) o nil si no esta en los assets"
	^ imagenes at: unaClave ifAbsent: [
		| archivo |
		archivo := rutas at: unaClave ifAbsent: [ ^ nil ].
		imagenes at: unaClave put: (ImageReadWriter formFromFileNamed: archivo fullName) ]
]

{ #category : 'initialization' }
LongcatApp >> initialize [
	super initialize.
	imagenes := Dictionary new.
	rutas := Dictionary new.
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
		ifAbsentPut: [ (TemaMundo paraColeccion: unaColeccion) crearInterfazPara: self progreso: progreso ].
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
LongcatApp >> skinActual [
	^ skinActual
]

{ #category : 'skins' }
LongcatApp >> skinsDisponibles [
	^ { SkinGato originalConImagenes: imagenes }
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
