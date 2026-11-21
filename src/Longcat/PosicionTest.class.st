"
Verifica la igualdad por valor, el hash, el predicado esPosicion y la suma de coordenadas de Posicion.
"
Class {
	#name : 'PosicionTest',
	#superclass : 'TestCase',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'tests - comparing' }
PosicionTest >> testIgualdadPorValor [
    | primera segunda |
    primera := Posicion fila: 2 columna: 3.
    segunda := Posicion fila: 2 columna: 3.
    self assert: primera = segunda.
    self assert: primera hash = segunda hash
]

{ #category : 'tests - comparing' }
PosicionTest >> testPosicionesDistintasNoSonIguales [
    self deny: (Posicion fila: 2 columna: 3) = (Posicion fila: 3 columna: 2)
]

{ #category : 'tests - testing' }
PosicionTest >> testPredicadoEsPosicionYRechazoEnSuma [
    self assert: (Posicion fila: 1 columna: 1) esPosicion.
    self deny: 42 esPosicion.
    self should: [ (Posicion fila: 1 columna: 1) + 42 ] raise: Error
]

{ #category : 'tests - arithmetic' }
PosicionTest >> testSumaCoordenadas [
    | posicion |
    posicion := (Posicion fila: 2 columna: 3) + (Posicion fila: 0 columna: -1).
    self assert: posicion = (Posicion fila: 2 columna: 2)
]
