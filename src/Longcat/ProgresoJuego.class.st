"
Objeto de dominio responsable de gestionar la secuencia de niveles, el estado de desbloqueo, los niveles completados y la skin seleccionada actualmente.
"
Class {
	#name : 'ProgresoJuego',
	#superclass : 'Object',
	#instVars : [
		'coleccionNiveles',
		'nivelActual',
		'nivelMaximo',
		'nivelesCompletados',
		'skinActual'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
ProgresoJuego class >> conColeccion: unaColeccion [
    ^ self conColeccion: unaColeccion skin: SkinGato original
]

{ #category : 'instance creation' }
ProgresoJuego class >> conColeccion: unaColeccion skin: unaSkin [
    ^ self basicNew inicializarConColeccion: unaColeccion skin: unaSkin
]

{ #category : 'instance creation' }
ProgresoJuego class >> porDefecto [
    ^ self conColeccion: ColeccionNiveles normales skin: SkinGato original
]

{ #category : 'progression' }
ProgresoJuego >> avanzarNivel [
    (self puedeJugarNivel: nivelActual + 1) ifFalse: [ ^ false ].
    nivelActual := nivelActual + 1.
    ^ true
]

{ #category : 'accessing' }
ProgresoJuego >> cantidadNiveles [
    ^ coleccionNiveles cantidad
]

{ #category : 'accessing' }
ProgresoJuego >> coleccionNiveles [
    ^ coleccionNiveles
]

{ #category : 'progression' }
ProgresoJuego >> desbloquearSiguiente [
    self cantidadNiveles = 0 ifTrue: [ ^ self ].
    nivelMaximo := nivelMaximo max: ((nivelActual + 1) min: self cantidadNiveles).
    ^ self
]

{ #category : 'skins' }
ProgresoJuego >> equiparSkin: unaSkin [
    unaSkin ifNil: [ self error: 'La skin no puede ser nil' ].
    skinActual := unaSkin.
    ^ self
]

{ #category : 'testing' }
ProgresoJuego >> esUltimoNivel [
    ^ nivelActual >= self cantidadNiveles
]

{ #category : 'testing' }
ProgresoJuego >> estaCompletadoNivel: unNumero [
    ^ nivelesCompletados includes: unNumero
]

{ #category : 'accessing' }
ProgresoJuego >> estadoNivel: unNumero [
    unNumero = nivelActual ifTrue: [ ^ #actual ].
    (self puedeJugarNivel: unNumero) ifTrue: [ ^ #desbloqueado ].
    ^ #bloqueado
]

{ #category : 'initialization' }
ProgresoJuego >> inicializarConColeccion: unaColeccion skin: unaSkin [
    coleccionNiveles := unaColeccion.
    nivelActual := 1.
    nivelMaximo := 1.
    nivelesCompletados := Set new.
    skinActual := unaSkin.
    ^ self
]

{ #category : 'progression' }
ProgresoJuego >> irANivel: unNumero [
    (self puedeJugarNivel: unNumero) ifFalse: [ ^ false ].
    nivelActual := unNumero.
    ^ true
]

{ #category : 'accessing' }
ProgresoJuego >> nivelActual [
    ^ nivelActual
]

{ #category : 'accessing' }
ProgresoJuego >> nivelActualObjeto [
    ^ coleccionNiveles nivel: nivelActual
]

{ #category : 'accessing' }
ProgresoJuego >> nivelMaximo [
    ^ nivelMaximo
]

{ #category : 'accessing' }
ProgresoJuego >> nivelesCompletados [
    ^ nivelesCompletados copy
]

{ #category : 'testing' }
ProgresoJuego >> puedeJugarNivel: unNumero [
    ^ (unNumero between: 1 and: self cantidadNiveles)
        and: [ unNumero <= nivelMaximo ]
]

{ #category : 'progression' }
ProgresoJuego >> registrarVictoria [
    nivelesCompletados add: nivelActual.
    self desbloquearSiguiente.
    ^ self
]

{ #category : 'progression' }
ProgresoJuego >> retrocederNivel [
    nivelActual <= 1 ifTrue: [ ^ false ].
    nivelActual := nivelActual - 1.
    ^ true
]

{ #category : 'accessing' }
ProgresoJuego >> skinActual [
    ^ skinActual
]

{ #category : 'printing' }
ProgresoJuego >> textoCompletados [
    nivelesCompletados isEmpty ifTrue: [ ^ 'ninguno todavia' ].
    ^ (nivelesCompletados asSortedCollection
        inject: ''
        into: [ :texto :numero | texto, numero asString, ' ' ]) trimBoth
]
