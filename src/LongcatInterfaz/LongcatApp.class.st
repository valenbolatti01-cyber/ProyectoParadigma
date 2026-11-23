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
LongcatApp class >> archivoEnCarga [
	"El archivo .st que se esta cargando con fileIn, o nil"
	| contexto |
	contexto := thisContext.
	[ contexto notNil ] whileTrue: [
		(self archivoSt: contexto receiver) ifNotNil: [ :archivo | ^ archivo ].
		contexto := contexto sender ].
	^ nil
]

{ #category : 'images' }
LongcatApp class >> archivoSt: unObjeto [
	"Si unObjeto es (o nombra) un archivo .st existente, lo responde como FileReference; si no, nil"
	^ [ | referencia |
		referencia := (unObjeto isKindOf: AbstractFileReference)
			ifTrue: [ unObjeto ]
			ifFalse: [
				((unObjeto respondsTo: #name) and: [ unObjeto name isString ])
					ifTrue: [ unObjeto name asFileReference ]
					ifFalse: [ nil ] ].
		(referencia notNil and: [ referencia isFile and: [ referencia extension asLowercase = 'st' ] ])
			ifTrue: [ referencia ]
			ifFalse: [ nil ] ]
		on: Error
		do: [ :e | nil ]
]

{ #category : 'images' }
LongcatApp class >> carpetaAssetsJuntoA: unArchivo [
	"La carpeta assets en la misma carpeta que el archivo, o en la de arriba"
	{ unArchivo parent / 'assets'. unArchivo parent parent / 'assets' } do: [ :candidata |
		candidata isDirectory ifTrue: [ ^ candidata ] ].
	^ nil
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes [
	"Carpeta assets que esta junto al longcat.st que se cargo con fileIn (la guarda recordarCarpetaDelFileIn).
	 Si no se conoce, por ejemplo si el juego se cargo de otra forma, se pide una sola vez."
	| elegida |
	(carpetaImagenes notNil and: [ carpetaImagenes asFileReference isDirectory ])
		ifTrue: [ ^ carpetaImagenes asFileReference ].
	elegida := [ UIManager default chooseDirectory: 'Elegi la carpeta assets del juego (esta junto a longcat.st)' ]
		on: Error do: [ :e | nil ].
	elegida ifNil: [
		^ self error: 'No encuentro la carpeta assets: carga longcat.st con fileIn desde la carpeta del trabajo, o indicala con LongcatApp carpetaDeImagenes: (ruta de assets)' ].
	carpetaImagenes := elegida asFileReference.
	^ carpetaImagenes
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes: unaRuta [
	carpetaImagenes := unaRuta ifNotNil: [ unaRuta asFileReference ].
	^ carpetaImagenes
]

{ #category : 'images' }
LongcatApp class >> carpetasDelRepositorio [
	"Ya no se usa: las imagenes se buscan solo junto al longcat.st cargado (ver carpetaDeImagenes)"
	^ #()
]

{ #category : 'images' }
LongcatApp class >> imagenesQueFaltan [
	"Para revisar los assets: ejecutar con Print it (Ctrl+P). Lista los archivos que el juego busca
	 y no encuentra en la carpeta assets que esta junto a longcat.st"
	^ self new archivosFaltantes
]

{ #category : 'images' }
LongcatApp class >> letraSinTilde: unaLetra [
	^ { $á -> $a. $é -> $e. $í -> $i. $ó -> $o. $ú -> $u. $ü -> $u. $ñ -> $n } asDictionary
		at: unaLetra
		ifAbsent: [ unaLetra ]
]

{ #category : 'images' }
LongcatApp class >> normalizarRuta: unTexto [
	"Minusculas, sin tildes ni espacios y con / como separador: asi 'Pokémon', 'Pokemon' y 'Pok#U00e9mon'
	 se reconocen igual en Windows, Mac y Linux"
	| texto |
	texto := (unTexto copyReplaceAll: '\' with: '/') asLowercase.
	texto := texto copyReplaceAll: '#u00e9' with: 'e'.
	^ String streamContents: [ :salida |
		texto do: [ :letra | | base |
			base := self letraSinTilde: letra.
			((base isLetter and: [ base asInteger < 128 ]) or: [ base isDigit or: [ './' includes: base ] ])
				ifTrue: [ salida nextPut: base ] ] ]
]

{ #category : 'images' }
LongcatApp class >> recordarCarpetaDelFileIn [
	"Se ejecuta al final de longcat.st: busca en la pila de ejecucion el archivo .st que se esta cargando
	 y guarda la carpeta assets que esta al lado (en la misma carpeta o en la de arriba)."
	| archivo |
	archivo := self archivoEnCarga.
	archivo ifNil: [ ^ nil ].
	(self carpetaAssetsJuntoA: archivo) ifNotNil: [ :carpeta | carpetaImagenes := carpeta ].
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
LongcatApp >> archivoDe: unaRutaRelativa entre: unosArchivos [
	"El archivo cuya ruta termina en la ruta relativa pedida (sin importar mayusculas, tildes ni espacios), o nil.
	 La ruta puede ser un texto o una lista de nombres alternativos: se usa el primero que exista."
	| sufijo |
	unaRutaRelativa isString ifFalse: [
		unaRutaRelativa do: [ :alternativa |
			(self archivoDe: alternativa entre: unosArchivos) ifNotNil: [ :archivo | ^ archivo ] ].
		^ nil ].
	sufijo := self class normalizarRuta: '/', unaRutaRelativa.
	^ unosArchivos
		detect: [ :archivo | (self class normalizarRuta: archivo fullName) endsWith: sufijo ]
		ifNone: [ nil ]
]

{ #category : 'images' }
LongcatApp >> archivosDeImagenes [
	"Imagenes generales mas las de cada tema de mundo (cada TemaMundo declara las suyas)"
	^ self archivosGenerales , TemaMundo archivosDeImagenes
]

{ #category : 'images' }
LongcatApp >> archivosFaltantes [
	| archivos |
	archivos := self class carpetaDeImagenes allChildren select: [ :archivo | archivo isFile ].
	^ (self archivosDeImagenes
		reject: [ :par | (self archivoDe: par value entre: archivos) notNil ])
		collect: [ :par | par value ]
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
		#etiquetaMovimientos -> #('marcador general/etiqueta_movimientos.png' 'marcador general/Etiqueta pixel art morada con huella y texto retro.png').
		#panelResultado -> #('marcador general/panel_resultado.png' 'marcador general/Panel retro morado con borde pixelado.png').
		#estrellaDorada -> #('marcador general/estrella_dorada.png' 'marcador general/Estrella dorada pixelada con brillo.png').
		#estrellaGris -> #('marcador general/estrella_gris.png' 'marcador general/Estrella pixelada gris con brillo púrpura.png').
		#botonSiguienteNivel -> #('marcador general/boton_siguiente_nivel.png' 'marcador general/Botón Pixel Art Siguiente Nivel.png').
		#botonReintentar -> #('marcador general/boton_reintentar.png' 'marcador general/Botón pixel art «Reintentar».png') }
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
