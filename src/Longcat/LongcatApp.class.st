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
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
LongcatApp class >> abrir [
	^ self new abrir
]

{ #category : 'images' }
LongcatApp class >> buscarAssetsEn: unaCarpeta profundidad: unNivel en: unaColeccion [
	"Agrega a la coleccion las carpetas assets que encuentra desde unaCarpeta hacia adentro"
	| hijas |
	unNivel <= 0 ifTrue: [ ^ self ].
	hijas := [ unaCarpeta directories ] on: Error do: [ :e | #() ].
	hijas do: [ :hija | | nombre |
		nombre := hija basename asLowercase.
		nombre = 'assets'
			ifTrue: [
				(unaColeccion anySatisfy: [ :ya | ya fullName = hija fullName ])
					ifFalse: [ unaColeccion add: hija ] ]
			ifFalse: [
				((nombre notEmpty and: [ nombre first = $. ]) or: [ #('package-cache' 'node_modules') includes: nombre ])
					ifFalse: [ self buscarAssetsEn: hija profundidad: unNivel - 1 en: unaColeccion ] ] ].
	^ self
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes [
	"Carpeta assets del juego: la que se fijo a mano o, si no, la mas completa de las que encuentra cerca de la imagen de Pharo, en Descargas, Escritorio, Documentos, etc. Si no encuentra ninguna pregunta cual es."
	| mejor puntaje elegida |
	carpetaImagenes ifNotNil: [ :ruta |
		(self puntajeDe: ruta asFileReference) > 0 ifTrue: [ ^ ruta asFileReference ] ].
	mejor := nil.
	puntaje := 0.
	self carpetasCandidatas do: [ :carpeta | | puntos |
		puntos := self puntajeDe: carpeta.
		puntos > puntaje ifTrue: [
			mejor := carpeta.
			puntaje := puntos ] ].
	mejor ifNotNil: [ ^ mejor ].
	elegida := [ UIManager default chooseDirectory: 'Elegi la carpeta assets (la que tiene Gato abajo.png y logo_longcat.png)' ]
		on: Error do: [ :e | nil ].
	elegida ifNotNil: [
		carpetaImagenes := elegida asFileReference.
		^ carpetaImagenes ].
	^ FileLocator imageDirectory resolve
]

{ #category : 'images' }
LongcatApp class >> carpetaDeImagenes: unaRuta [
	carpetaImagenes := unaRuta ifNotNil: [ unaRuta asFileReference ].
	^ carpetaImagenes
]

{ #category : 'images' }
LongcatApp class >> carpetasCandidatas [
	"Carpetas llamadas assets que hay cerca de donde suele estar el proyecto. Solo recorre carpetas y con profundidad limitada para no tardar."
	| raices encontradas agregar |
	encontradas := OrderedCollection new.
	raices := OrderedCollection new.
	agregar := [ :bloqueCarpeta :profundidad |
		[ raices add: bloqueCarpeta value resolve -> profundidad ]
			on: Error do: [ :e | nil ] ].
	agregar value: [ FileLocator imageDirectory ] value: 7.
	agregar value: [ FileLocator workingDirectory ] value: 4.
	agregar value: [ FileLocator home / 'Downloads' ] value: 4.
	agregar value: [ FileLocator home / 'Descargas' ] value: 4.
	agregar value: [ FileLocator desktop ] value: 4.
	agregar value: [ FileLocator home / 'Desktop' ] value: 4.
	agregar value: [ FileLocator documents ] value: 3.
	agregar value: [ FileLocator home / 'Documents' ] value: 3.
	[ (FileLocator home resolve directories select: [ :carpeta | (carpeta basename asLowercase indexOfSubCollection: 'onedrive') > 0 ])
		do: [ :carpeta | raices add: carpeta -> 4 ] ]
		on: Error do: [ :e | nil ].
	raices do: [ :par |
		[ self buscarAssetsEn: par key profundidad: par value en: encontradas ]
			on: Error do: [ :e | nil ] ].
	^ encontradas
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

{ #category : 'images' }
LongcatApp class >> imagenesFaltantes [
	"Rutas de imagenes que el juego espera y no encuentra en la carpeta de assets. Uso para revisar: LongcatApp imagenesFaltantes"
	| app |
	app := self new.
	app cargarImagenes.
	^ (app archivosDeImagenes select: [ :par | (app imagen: par key) isNil ])
		collect: [ :par | par value ]
]

{ #category : 'images' }
LongcatApp class >> puntajeDe: unaCarpeta [
	"Cuantas de las imagenes del juego encuentra dentro de la carpeta. Las del gato valen 100 porque sin ellas el juego no abre."
	| app archivos |
	^ [
		unaCarpeta exists
			ifFalse: [ 0 ]
			ifTrue: [
				app := self new.
				archivos := unaCarpeta allChildren select: [ :archivo | archivo isFile ].
				app archivosDeImagenes inject: 0 into: [ :total :par |
					(app archivoDe: par value entre: archivos)
						ifNil: [ total ]
						ifNotNil: [ total + ((app clavesDelGato includes: par key) ifTrue: [ 100 ] ifFalse: [ 1 ]) ] ] ] ]
		on: Error do: [ :e | 0 ]
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
	"El archivo cuya ruta termina en la ruta relativa pedida, sin distinguir mayusculas, tildes, espacios, guiones ni guiones bajos (Pokemon imagenes = Pokemon_imagenes = Pokemon imagenes). Si la carpeta no coincide exacta, acepta el mismo nombre de archivo dentro de una carpeta que empiece parecido. Responde nil si no esta."
	| mapa normalizar rutaNormalizada partes nombreEsperado carpetaEsperada prefijo |
	mapa := { $á -> $a. $é -> $e. $í -> $i. $ó -> $o. $ú -> $u. $ü -> $u. $ñ -> $n } asDictionary.
	normalizar := [ :texto |
		String streamContents: [ :salida |
			texto asString asLowercase do: [ :c | | ch |
				ch := mapa at: c ifAbsent: [ c ].
				ch = $\ 
					ifTrue: [ salida nextPut: $/ ]
					ifFalse: [
						(ch isAlphaNumeric or: [ ch = $/ or: [ ch = $. ] ])
							ifTrue: [ salida nextPut: ch ] ] ] ] ].
	rutaNormalizada := normalizar value: unaRutaRelativa.
	partes := rutaNormalizada substrings: '/'.
	partes isEmpty ifTrue: [ ^ nil ].
	nombreEsperado := partes last.
	carpetaEsperada := partes size > 1 ifTrue: [ partes first ] ifFalse: [ '' ].
	^ unosArchivos
		detect: [ :archivo |
			('/', (normalizar value: archivo fullName)) endsWith: '/', rutaNormalizada ]
		ifNone: [
			carpetaEsperada isEmpty ifTrue: [ ^ nil ].
			prefijo := carpetaEsperada copyFrom: 1 to: (carpetaEsperada size min: 6).
			unosArchivos
				detect: [ :archivo | | ruta |
					ruta := (normalizar value: archivo fullName) substrings: '/'.
					ruta size > 1 and: [
						ruta last = nombreEsperado and: [
							self texto: (ruta at: ruta size - 1) empiezaCon: prefijo ] ] ]
				ifNone: [ nil ] ]
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
LongcatApp >> asignarPorParecidoEntre: unosArchivos [
	"Las imagenes que no se encontraron por nombre se buscan entre los archivos que quedaron sin usar, en la carpeta que corresponde, eligiendo el de nombre mas parecido (estrella_dorada.png y estrella amarilla.png comparten la palabra estrella). Primero se asignan las parejas mas parecidas."
	| pendientes usados libres elegido |
	pendientes := (self archivosDeImagenes reject: [ :par | rutas includesKey: par key ]) asOrderedCollection.
	usados := Set new.
	rutas valuesDo: [ :archivo | usados add: archivo fullName ].
	libres := (unosArchivos select: [ :archivo |
		(#('png' 'jpg' 'jpeg' 'gif' 'bmp') includes: archivo extension asLowercase)
			and: [ (usados includes: archivo fullName) not ] ]) asOrderedCollection.
	[ elegido := self mejorParejaEntre: pendientes y: libres.
	  elegido notNil ] whileTrue: [
		rutas at: elegido first put: elegido second.
		pendientes removeAllSuchThat: [ :par | par key = elegido first ].
		libres remove: elegido second ].
	^ self
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
	self asignarPorParecidoEntre: archivos.
	self clavesDelGato do: [ :unaClave | self imagen: unaClave ].
	faltantes := self clavesDelGato reject: [ :unaClave | imagenes includesKey: unaClave ].
	faltantes isEmpty ifFalse: [
		^ self error: 'No encuentro las imagenes del gato (Gato abajo.png, Gato arriba.png...) dentro de: ', raiz fullName ].
	^ imagenes
]

{ #category : 'images' }
LongcatApp >> carpetaEsperadaDe: unaRutaRelativa [
	"Nombre compacto de la primera carpeta de la ruta relativa, o nil si la ruta no tiene carpeta"
	| partes |
	partes := unaRutaRelativa substrings: '/'.
	partes size > 1 ifFalse: [ ^ nil ].
	^ self compactoDe: partes first
]

{ #category : 'images' }
LongcatApp >> clavesDelGato [
	^ #(#cabezaAbajo #cabezaArriba #cabezaDerecha #cabezaIzquierda)
]

{ #category : 'images' }
LongcatApp >> compactoDe: unTexto [
	"El texto sin tildes, mayusculas ni separadores (Pokemon imagenes se convierte en pokemonimagenes)"
	^ (self tokensDe: unTexto) inject: '' into: [ :texto :palabra | texto, palabra ]
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
	"La imagen pedida (se lee del disco la primera vez) o nil si no esta en los assets o no se puede leer"
	^ imagenes at: unaClave ifAbsent: [
		| archivo forma |
		archivo := rutas at: unaClave ifAbsent: [ ^ nil ].
		forma := [ ImageReadWriter formFromFileNamed: archivo fullName ]
			on: Error do: [ :e | nil ].
		forma
			ifNil: [ rutas removeKey: unaClave ifAbsent: [ nil ] ]
			ifNotNil: [ imagenes at: unaClave put: forma ].
		forma ]
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

{ #category : 'images' }
LongcatApp >> mejorParejaEntre: unosPendientes y: unosLibres [
	"La pareja clave y archivo de nombre mas parecido, o nil si ninguna comparte palabras"
	| mejor mejorPuntaje |
	mejor := nil.
	mejorPuntaje := 0.
	unosPendientes do: [ :par | | palabras carpeta |
		palabras := self tokensDe: par value asFileReference basenameWithoutExtension.
		carpeta := self carpetaEsperadaDe: par value.
		unosLibres do: [ :archivo | | puntos |
			puntos := self puntosDe: palabras enCarpeta: carpeta archivo: archivo.
			puntos > mejorPuntaje ifTrue: [
				mejor := { par key. archivo }.
				mejorPuntaje := puntos ] ] ].
	^ mejor
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

{ #category : 'images' }
LongcatApp >> palabra: unaPalabra parecidaA: otraPalabra [
	"Dos palabras son parecidas si son iguales o una empieza con la otra (estrella y estrellas, boton y botones)"
	| corta larga |
	unaPalabra = otraPalabra ifTrue: [ ^ true ].
	unaPalabra size <= otraPalabra size
		ifTrue: [ corta := unaPalabra. larga := otraPalabra ]
		ifFalse: [ corta := otraPalabra. larga := unaPalabra ].
	^ corta size >= 4 and: [ self texto: larga empiezaCon: corta ]
]

{ #category : 'progression' }
LongcatApp >> progresoPara: unaColeccion [
	^ progresos
		at: unaColeccion class
		ifAbsentPut: [ ProgresoJuego conColeccion: unaColeccion skin: skinActual ]
]

{ #category : 'images' }
LongcatApp >> puntosDe: unasPalabras enCarpeta: unaCarpeta archivo: unArchivo [
	"Cuantas palabras del nombre esperado aparecen en el nombre del archivo. Si la imagen debe estar en una carpeta, el archivo tiene que estar dentro de una de nombre parecido; si no, tienen que coincidir todas las palabras."
	| palabrasArchivo puntos |
	unaCarpeta ifNotNil: [
		(((self compactoDe: unArchivo parent fullName)
			indexOfSubCollection: (unaCarpeta copyFrom: 1 to: (unaCarpeta size min: 6))) > 0)
			ifFalse: [ ^ 0 ] ].
	palabrasArchivo := self tokensDe: unArchivo basenameWithoutExtension.
	puntos := unasPalabras inject: 0 into: [ :total :palabra |
		(palabrasArchivo anySatisfy: [ :otra | self palabra: palabra parecidaA: otra ])
			ifTrue: [ total + 1 ]
			ifFalse: [ total ] ].
	(unaCarpeta isNil and: [ puntos < unasPalabras size ]) ifTrue: [ ^ 0 ].
	^ puntos
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

{ #category : 'images' }
LongcatApp >> texto: unTexto empiezaCon: unPrefijo [
	"Verdadero si el texto empieza con el prefijo"
	^ unTexto size >= unPrefijo size
		and: [ (unTexto copyFrom: 1 to: unPrefijo size) = unPrefijo ]
]

{ #category : 'images' }
LongcatApp >> tokensDe: unTexto [
	"Palabras de un nombre, sin extension, tildes ni mayusculas (estrella_dorada se convierte en estrella dorada)"
	| mapa limpio |
	mapa := { $á -> $a. $é -> $e. $í -> $i. $ó -> $o. $ú -> $u. $ü -> $u. $ñ -> $n } asDictionary.
	limpio := String streamContents: [ :salida |
		unTexto asString asLowercase do: [ :c | | ch |
			ch := mapa at: c ifAbsent: [ c ].
			ch isAlphaNumeric
				ifTrue: [ salida nextPut: ch ]
				ifFalse: [ salida space ] ] ].
	^ limpio substrings: ' '
]

{ #category : 'navigation' }
LongcatApp >> verSkins [
	^ self mostrar: (MenuSkinsMorph app: self)
]
