"
Verifica la igualdad por valor, el hash y la suma de coordenadas de Posicion.
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
    primera := (Smalltalk globals at: #Posicion) fila: 2 columna: 3.
    segunda := (Smalltalk globals at: #Posicion) fila: 2 columna: 3.
    self assert: primera = segunda.
    self assert: primera hash = segunda hash
]

{ #category : 'tests - comparing' }
PosicionTest >> testPosicionesDistintasNoSonIguales [
    self deny: ((Smalltalk globals at: #Posicion) fila: 2 columna: 3) = ((Smalltalk globals at: #Posicion) fila: 3 columna: 2)
]

{ #category : 'tests - arithmetic' }
PosicionTest >> testSumaCoordenadas [
    | posicion |
    posicion := ((Smalltalk globals at: #Posicion) fila: 2 columna: 3) + ((Smalltalk globals at: #Posicion) fila: 0 columna: -1).
    self assert: posicion = ((Smalltalk globals at: #Posicion) fila: 2 columna: 2)
]
