"
Verifica la gestion de secuencia de niveles, desbloqueos, completados y equipamiento de skins en ProgresoJuego.
"
Class {
	#name : 'ProgresoJuegoTest',
	#superclass : 'TestCase',
	#instVars : [
		'progreso'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
ProgresoJuegoTest >> setUp [
    super setUp.
    progreso := ProgresoJuego porDefecto
]

{ #category : 'tests - progression' }
ProgresoJuegoTest >> testDesbloquearYAvanzarNivel [
    progreso registrarVictoria.
    self assert: (progreso estaCompletadoNivel: 1).
    self assert: progreso nivelMaximo = 2.
    self assert: (progreso puedeJugarNivel: 2).
    self assert: progreso avanzarNivel.
    self assert: progreso nivelActual = 2.
    self assert: (progreso estadoNivel: 1) = #desbloqueado.
    self assert: (progreso estadoNivel: 2) = #actual
]

{ #category : 'tests - skins' }
ProgresoJuegoTest >> testEquiparSkinActualizaLaSkinActiva [
    | nuevaSkin |
    nuevaSkin := SkinGato
        identificador: #cyber
        nombre: 'Cyber'
        colorCuerpo: EstiloLongcat colorVioleta
        colorRayas: EstiloLongcat colorLavanda
        colorBorde: EstiloLongcat colorVioleta
        cabezaArriba: nil
        cabezaAbajo: nil
        cabezaDerecha: nil
        cabezaIzquierda: nil.
    progreso equiparSkin: nuevaSkin.
    self assert: progreso skinActual = nuevaSkin
]

{ #category : 'tests - progression' }
ProgresoJuegoTest >> testIniciaEnNivelUnoConRestoBloqueado [
    self assert: progreso nivelActual = 1.
    self assert: progreso nivelMaximo = 1.
    self assert: (progreso puedeJugarNivel: 1).
    self deny: (progreso puedeJugarNivel: 2).
    self assert: (progreso estadoNivel: 1) = #actual.
    self assert: (progreso estadoNivel: 2) = #bloqueado
]

{ #category : 'tests - progression' }
ProgresoJuegoTest >> testNoPermiteSaltarANivelBloqueado [
    self deny: (progreso irANivel: 3).
    self assert: progreso nivelActual = 1
]
