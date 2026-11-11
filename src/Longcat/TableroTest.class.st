"
Verifica dimensiones, límites, disponibilidad y reinicio del Tablero sin acceder a su matriz interna.
"
Class {
	#name : 'TableroTest',
	#superclass : 'TestCase',
	#instVars : [
		'tablero'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
TableroTest >> setUp [
    super setUp.
    tablero := (Smalltalk globals at: #Tablero) filas: 3 columnas: 4
]

{ #category : 'tests - state' }
TableroTest >> testBloqueoSeConservaAlReiniciar [
    | posicion |
    posicion := (Smalltalk globals at: #Posicion) fila: 1 columna: 2.
    tablero bloquear: posicion.
    tablero ocupar: ((Smalltalk globals at: #Posicion) fila: 2 columna: 2).
    tablero reiniciar.
    self assert: (tablero estaBloqueada: posicion).
    self assert: (tablero estaDisponible: ((Smalltalk globals at: #Posicion) fila: 2 columna: 2))
]

{ #category : 'tests - dimensions' }
TableroTest >> testConservaDimensionesRectangulares [
    self assert: tablero filas = 3.
    self assert: tablero columnas = 4
]

{ #category : 'tests - state' }
TableroTest >> testOcuparActualizaLasConsultasYElContador [
    | posicion |
    posicion := (Smalltalk globals at: #Posicion) fila: 2 columna: 3.
    tablero ocupar: posicion.
    self assert: (tablero estaOcupada: posicion).
    self assert: (tablero estadoDe: posicion) = #ocupada.
    self assert: tablero cantidadDisponibles = 11
]

{ #category : 'tests - dimensions' }
TableroTest >> testReconocePosicionesInterioresYExteriores [
    self assert: (tablero contiene: ((Smalltalk globals at: #Posicion) fila: 3 columna: 4)).
    self deny: (tablero contiene: ((Smalltalk globals at: #Posicion) fila: 0 columna: 4)).
    self assert: (tablero estaBloqueada: ((Smalltalk globals at: #Posicion) fila: 0 columna: 4))
]

{ #category : 'tests - state' }
TableroTest >> testTodasLasCasillasEmpiezanDisponibles [
    self assert: tablero cantidadDisponibles = 12.
    self assert: tablero cantidadOcupadas = 0
]
