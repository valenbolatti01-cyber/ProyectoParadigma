"
Herramienta del dominio para disenar niveles: explora exhaustivamente todas las jugadas de un Nivel y obtiene los movimientos minimos y maximos de las soluciones reales (las que llenan todo el tablero). Responde nil si el nivel no se puede ganar. No conoce la interfaz grafica.
"
Class {
	#name : 'AnalizadorDeNivel',
	#superclass : 'Object',
	#instVars : [
		'nivel',
		'visitados',
		'resultado',
		'analizado'
	],
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'instance creation' }
AnalizadorDeNivel class >> sobre: unNivel [
    ^ self basicNew inicializarSobre: unNivel
]

{ #category : 'private' }
AnalizadorDeNivel >> analizar [
    analizado ifTrue: [ ^ self ].
    resultado := self explorar: (Partida deNivel: nivel).
    analizado := true.
    ^ self
]

{ #category : 'private' }
AnalizadorDeNivel >> claveDe: unaPartida [
    "Un estado queda determinado por la cabeza y por el conjunto de casillas ocupadas"
    ^ { unaPartida posicionCabeza fila.
        unaPartida posicionCabeza columna.
        (unaPartida posicionesOcupadas
            collect: [ :posicion | (posicion fila * 100) + posicion columna ]) asSortedCollection asArray }
]

{ #category : 'private' }
AnalizadorDeNivel >> explorar: unaPartida [
    "Responde minimo -> maximo de movimientos que faltan para ganar, o nil si ya no se puede ganar"
    | clave |
    unaPartida estaGanada ifTrue: [ ^ 0 -> 0 ].
    unaPartida estaPerdida ifTrue: [ ^ nil ].
    clave := self claveDe: unaPartida.
    ^ visitados
        at: clave
        ifAbsent: [ | respuesta |
            respuesta := self explorarJugadasDe: unaPartida.
            visitados at: clave put: respuesta.
            respuesta ]
]

{ #category : 'private' }
AnalizadorDeNivel >> explorarJugadasDe: unaPartida [
    | menor mayor |
    Direccion todas do: [ :direccion |
        (unaPartida puedeMoverseEn: direccion) ifTrue: [ | siguiente restantes |
            siguiente := unaPartida copy.
            siguiente moverEn: direccion.
            restantes := self explorar: siguiente.
            restantes ifNotNil: [
                menor := menor
                    ifNil: [ restantes key + 1 ]
                    ifNotNil: [ :actual | actual min: restantes key + 1 ].
                mayor := mayor
                    ifNil: [ restantes value + 1 ]
                    ifNotNil: [ :actual | actual max: restantes value + 1 ] ] ] ].
    ^ menor ifNotNil: [ menor -> mayor ]
]

{ #category : 'initialization' }
AnalizadorDeNivel >> inicializarSobre: unNivel [
    nivel := unNivel.
    visitados := Dictionary new.
    analizado := false.
    ^ self
]

{ #category : 'accessing' }
AnalizadorDeNivel >> movimientosMaximos [
    self analizar.
    ^ resultado ifNotNil: [ :par | par value ]
]

{ #category : 'accessing' }
AnalizadorDeNivel >> movimientosMinimos [
    self analizar.
    ^ resultado ifNotNil: [ :par | par key ]
]

{ #category : 'testing' }
AnalizadorDeNivel >> sePuedeGanar [
    self analizar.
    ^ resultado notNil
]
