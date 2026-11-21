"
Verifica el movimiento automatico, los estados terminales, la proteccion tras finalizar y el reinicio de Partida.
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
    partida := Partida deFilas: 3 columnas: 4 inicio: (Posicion fila: 2 columna: 2)
]

{ #category : 'tests - terminal states' }
PartidaTest >> testCasillasLibresInaccesiblesLlevanADerrotaAlQuedarAtrapado [
    | partidaPequena |
    partidaPequena := Partida deFilas: 1 columnas: 3 inicio: (Posicion fila: 1 columna: 2).
    partidaPequena moverEn: Izquierda new.
    self assert: partidaPequena cantidadDisponibles = 1.
    self deny: partidaPequena tieneMovimientosPosibles.
    self assert: partidaPequena estaPerdida
]

{ #category : 'tests - movement' }
PartidaTest >> testChocarConElCuerpoSoloBloqueaEsaDireccion [
    | partidaPequena posicionesAntes |
    partidaPequena := Partida deFilas: 2 columnas: 3 inicio: (Posicion fila: 1 columna: 2).
    partidaPequena moverEn: Izquierda new.
    posicionesAntes := partidaPequena posicionesOcupadas.
    partidaPequena moverEn: Derecha new.
    self assert: partidaPequena posicionesOcupadas = posicionesAntes.
    self assert: partidaPequena estaActiva
]

{ #category : 'tests - terminal states' }
PartidaTest >> testCompletarElTableroDaVictoria [
    | partidaPequena |
    partidaPequena := Partida deFilas: 1 columnas: 2.
    partidaPequena moverEn: Derecha new.
    self assert: partidaPequena cantidadDisponibles = 0.
    self assert: partidaPequena estaGanada
]

{ #category : 'tests - terminal states' }
PartidaTest >> testIgnoraMovimientosLuegoDeTerminar [
    | partidaPequena posicionesFinales |
    partidaPequena := Partida deFilas: 1 columnas: 2.
    partidaPequena moverEn: Derecha new.
    posicionesFinales := partidaPequena posicionesOcupadas.
    partidaPequena moverEn: Arriba new.
    self assert: partidaPequena posicionesOcupadas = posicionesFinales.
    self assert: partidaPequena estaGanada
]

{ #category : 'tests - terminal states' }
PartidaTest >> testLaPartidaDeUnaCasillaEmpiezaGanada [
    | partidaPequena |
    partidaPequena := Partida deFilas: 1 columnas: 1.
    self assert: partidaPequena estaGanada
]

{ #category : 'tests - resetting' }
PartidaTest >> testReiniciarRestauraLaPosicionYElEstado [
    | partidaPequena |
    partidaPequena := Partida deFilas: 1 columnas: 3 inicio: (Posicion fila: 1 columna: 2).
    partidaPequena moverEn: Izquierda new.
    partidaPequena reiniciar.
    self assert: partidaPequena estaActiva.
    self assert: partidaPequena posicionCabeza = (Posicion fila: 1 columna: 2).
    self assert: partidaPequena longitudGato = 1.
    self assert: partidaPequena cantidadDisponibles = 2
]

{ #category : 'tests - movement' }
PartidaTest >> testSeDesplazaHastaElLimiteYElGatoCrece [
    partida moverEn: Derecha new.
    self assert: partida posicionCabeza = (Posicion fila: 2 columna: 4).
    self assert: partida longitudGato = 3.
    self assert: partida estaActiva.
    self assert: partida direccionCabeza class = Derecha
]

{ #category : 'tests - movement' }
PartidaTest >> testUnaDireccionBloqueadaNoMueveAlGato [
    | posicionesAntes |
    partida moverEn: Derecha new.
    posicionesAntes := partida posicionesOcupadas.
    partida moverEn: Derecha new.
    self assert: partida posicionesOcupadas = posicionesAntes.
    self assert: partida estaActiva
]
