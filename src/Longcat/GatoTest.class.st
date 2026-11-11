"
Verifica que Gato mantenga una secuencia ordenada, crezca sin encogerse y devuelva copias de sus posiciones.
"
Class {
	#name : 'GatoTest',
	#superclass : 'TestCase',
	#instVars : [
		'gato',
		'inicio',
		'direccion'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'running' }
GatoTest >> setUp [
    super setUp.
    inicio := (Smalltalk globals at: #Posicion) fila: 2 columna: 2.
    direccion := (Smalltalk globals at: #Derecha) new.
    gato := (Smalltalk globals at: #Gato) en: inicio
]

{ #category : 'tests - movement' }
GatoTest >> testAvanzarAgregaUnSegmentoYRecuerdaDireccion [
    gato avanzarA: ((Smalltalk globals at: #Posicion) fila: 2 columna: 3) enDireccion: direccion.
    self assert: gato cabeza = ((Smalltalk globals at: #Posicion) fila: 2 columna: 3).
    self assert: gato longitud = 2.
    self assert: gato direccionUltima = direccion
]

{ #category : 'tests - movement' }
GatoTest >> testLasPosicionesDevueltasNoPermitenModificarElGato [
    | copia |
    copia := gato posicionesOcupadas.
    copia at: 1 put: ((Smalltalk globals at: #Posicion) fila: 9 columna: 9).
    self assert: gato cabeza = inicio.
    self assert: gato longitud = 1
]

{ #category : 'tests - movement' }
GatoTest >> testRechazaUnSaltoNoAdyacente [
    self should: [ gato avanzarA: ((Smalltalk globals at: #Posicion) fila: 2 columna: 4) enDireccion: direccion ] raise: Error
]

{ #category : 'tests - resetting' }
GatoTest >> testReiniciarVuelveAUnaCasillaYOlvidaDireccion [
    gato avanzarA: ((Smalltalk globals at: #Posicion) fila: 2 columna: 3) enDireccion: direccion.
    gato reiniciarEn: inicio.
    self assert: gato posicionesOcupadas = { inicio }.
    self assert: gato direccionUltima isNil
]
