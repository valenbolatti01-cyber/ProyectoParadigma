"
Verifica los estados y transiciones controladas de Casilla.
"
Class {
	#name : 'CasillaTest',
	#superclass : 'TestCase',
	#instVars : [
		'casilla'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
CasillaTest >> setUp [
    super setUp.
    casilla := (Smalltalk globals at: #Casilla) libre
]

{ #category : 'tests - state' }
CasillaTest >> testBloquearCambiaElEstado [
    casilla bloquear.
    self assert: casilla estaBloqueada.
    self deny: casilla estaDisponible
]

{ #category : 'tests - state' }
CasillaTest >> testCasillaLibreEstaDisponible [
    self assert: casilla estaDisponible.
    self assert: casilla estado = #libre
]

{ #category : 'tests - state' }
CasillaTest >> testNoSePuedeOcuparUnaCasillaBloqueada [
    casilla bloquear.
    self should: [ casilla ocupar ] raise: Error
]

{ #category : 'tests - state' }
CasillaTest >> testOcuparCambiaElEstado [
    casilla ocupar.
    self assert: casilla estaOcupada.
    self deny: casilla estaDisponible
]
