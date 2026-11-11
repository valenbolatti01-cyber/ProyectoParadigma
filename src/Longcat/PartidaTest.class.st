"
Verifica el movimiento automático, los estados terminales, la protección tras finalizar y el reinicio de Partida.
"
Class {
	#name : 'PartidaTest',
	#superclass : 'TestCase',
	#instVars : [
		'partida'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
PartidaTest >> setUp [
    super setUp.
    partida := (Smalltalk globals at: #Partida) deFilas: 3 columnas: 4 inicio: ((Smalltalk globals at: #Posicion) fila: 2 columna: 2)
]

{ #category : 'tests - terminal states' }
PartidaTest >> testCasillasLibresInaccesiblesLlevanADerrotaAlQuedarAtrapado [
    | partidaPequena |
    partidaPequena := (Smalltalk globals at: #Partida)
        deFilas: 1
        columnas: 3
        inicio: ((Smalltalk globals at: #Posicion) fila: 1 columna: 2).
    partidaPequena moverEn: ((Smalltalk globals at: #Izquierda) new).
    self assert: partidaPequena cantidadDisponibles = 1.
    self deny: partidaPequena tieneMovimientosPosibles.
    self assert: partidaPequena estado = #derrota
]

{ #category : 'tests - movement' }
PartidaTest >> testChocarConElCuerpoSoloBloqueaEsaDireccion [
    | partidaPequena posicionesAntes |
    partidaPequena := (Smalltalk globals at: #Partida)
        deFilas: 2
        columnas: 3
        inicio: ((Smalltalk globals at: #Posicion) fila: 1 columna: 2).
    partidaPequena moverEn: ((Smalltalk globals at: #Izquierda) new).
    posicionesAntes := partidaPequena posicionesOcupadas.
    partidaPequena moverEn: ((Smalltalk globals at: #Derecha) new).
    self assert: partidaPequena posicionesOcupadas = posicionesAntes.
    self assert: partidaPequena estado = #activa
]

{ #category : 'tests - terminal states' }
PartidaTest >> testCompletarElTableroDaVictoria [
    | partidaPequena |
    partidaPequena := (Smalltalk globals at: #Partida) deFilas: 1 columnas: 2.
    partidaPequena moverEn: ((Smalltalk globals at: #Derecha) new).
    self assert: partidaPequena cantidadDisponibles = 0.
    self assert: partidaPequena estado = #victoria
]

{ #category : 'tests - terminal states' }
PartidaTest >> testIgnoraMovimientosLuegoDeTerminar [
    | partidaPequena posicionesFinales |
    partidaPequena := (Smalltalk globals at: #Partida) deFilas: 1 columnas: 2.
    partidaPequena moverEn: ((Smalltalk globals at: #Derecha) new).
    posicionesFinales := partidaPequena posicionesOcupadas.
    partidaPequena moverEn: ((Smalltalk globals at: #Arriba) new).
    self assert: partidaPequena posicionesOcupadas = posicionesFinales.
    self assert: partidaPequena estado = #victoria
]

{ #category : 'tests - terminal states' }
PartidaTest >> testLaPartidaDeUnaCasillaEmpiezaGanada [
    | partidaPequena |
    partidaPequena := (Smalltalk globals at: #Partida) deFilas: 1 columnas: 1.
    self assert: partidaPequena estado = #victoria
]

{ #category : 'tests - resetting' }
PartidaTest >> testReiniciarRestauraLaPosicionYElEstado [
    | partidaPequena |
    partidaPequena := (Smalltalk globals at: #Partida)
        deFilas: 1
        columnas: 3
        inicio: ((Smalltalk globals at: #Posicion) fila: 1 columna: 2).
    partidaPequena moverEn: ((Smalltalk globals at: #Izquierda) new).
    partidaPequena reiniciar.
    self assert: partidaPequena estado = #activa.
    self assert: partidaPequena posicionCabeza = ((Smalltalk globals at: #Posicion) fila: 1 columna: 2).
    self assert: partidaPequena longitudGato = 1.
    self assert: partidaPequena cantidadDisponibles = 2
]

{ #category : 'tests - movement' }
PartidaTest >> testSeDesplazaHastaElLimiteYElGatoCrece [
    partida moverEn: ((Smalltalk globals at: #Derecha) new).
    self assert: partida posicionCabeza = ((Smalltalk globals at: #Posicion) fila: 2 columna: 4).
    self assert: partida longitudGato = 3.
    self assert: partida estado = #activa
]

{ #category : 'tests - movement' }
PartidaTest >> testUnaDireccionBloqueadaNoMueveAlGato [
    | posicionesAntes |
    partida moverEn: ((Smalltalk globals at: #Derecha) new).
    posicionesAntes := partida posicionesOcupadas.
    partida moverEn: ((Smalltalk globals at: #Derecha) new).
    self assert: partida posicionesOcupadas = posicionesAntes.
    self assert: partida estado = #activa
]
