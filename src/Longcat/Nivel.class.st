"
Describe un nivel de Longcat: su numero, el dibujo del mapa (# pared, . libre, I inicio del gato) y una solucion conocida que prueba que se puede ganar.
"
Class {
	#name : 'Nivel',
	#superclass : 'Object',
	#instVars : [
		'numero',
		'mapa',
		'solucion'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'levels' }
Nivel class >> cantidad [
    ^ self todos size
]

{ #category : 'levels' }
Nivel class >> nivel: unNumero [
    ^ self todos at: unNumero
]

{ #category : 'instance creation' }
Nivel class >> numero: unNumero mapa: unasFilas solucion: unaSolucion [
    ^ self basicNew setNumero: unNumero mapa: unasFilas solucion: unaSolucion
]

{ #category : 'levels' }
Nivel class >> todos [
    "AQUI SE AGREGAN LOS NIVELES. Para uno nuevo, copiar un bloque 'lista add:' y cambiar numero, mapa y solucion.
     Mapa: # pared, . casilla libre, I inicio del gato (una sola I por nivel).
     Solucion: lista de movimientos #arriba #abajo #izquierda #derecha que llenan todo el tablero (la usa NivelTest)."
    | lista |
    lista := OrderedCollection new.
    "Nivel 1"
    lista add: (self numero: 1
        mapa: #(
            '....'
            '..I.'
            '#..#')
        solucion: #(
            #derecha #arriba #izquierda #abajo #derecha #abajo #derecha)).
    "Nivel 2"
    lista add: (self numero: 2
        mapa: #(
            '#..I'
            '...#'
            '.#..'
            '....')
        solucion: #(
            #izquierda #abajo #izquierda #abajo #derecha #arriba #izquierda #arriba)).
    "Nivel 3"
    lista add: (self numero: 3
        mapa: #(
            '..#..'
            '.#...'
            '...#.'
            '#..I.')
        solucion: #(
            #derecha #arriba #izquierda #abajo #izquierda #abajo #izquierda #arriba
            #izquierda #arriba #derecha)).
    "Nivel 4"
    lista add: (self numero: 4
        mapa: #(
            '#....'
            '..#..'
            '.#..I'
            '..#..'
            '#...#')
        solucion: #(
            #abajo #izquierda #abajo #izquierda #arriba #izquierda #arriba #derecha
            #arriba #derecha #abajo #izquierda #abajo #izquierda)).
    "Nivel 5"
    lista add: (self numero: 5
        mapa: #(
            '...I.#'
            '.#.#..'
            '.#..#.'
            '..#...'
            '#..#..')
        solucion: #(
            #derecha #abajo #derecha #abajo #izquierda #arriba #izquierda #arriba
            #izquierda #arriba #izquierda #abajo #derecha #abajo #derecha)).
    "Nivel 6"
    lista add: (self numero: 6
        mapa: #(
            '....##'
            '.#....'
            '.#.#..'
            '....#.'
            '#.#...'
            '#.I..#')
        solucion: #(
            #izquierda #arriba #izquierda #arriba #derecha #abajo #izquierda #abajo
            #derecha #abajo #derecha #arriba #derecha #arriba #izquierda #abajo)).
    "Nivel 7"
    lista add: (self numero: 7
        mapa: #(
            '......#'
            '.#..#..'
            '....I..'
            '.##..##'
            '...#..#'
            '##....#')
        solucion: #(
            #derecha #arriba #izquierda #arriba #izquierda #abajo #derecha #abajo
            #derecha #arriba #izquierda #arriba #izquierda #arriba #izquierda #abajo
            #izquierda)).
    "Nivel 8"
    lista add: (self numero: 8
        mapa: #(
            '..##...'
            '...#.#.'
            '.#...#.'
            '....I..'
            '#.##...'
            '#.####.'
            '#......')
        solucion: #(
            #abajo #derecha #abajo #izquierda #arriba #izquierda #arriba #derecha
            #abajo #derecha #abajo #derecha #arriba #derecha #arriba #derecha #abajo
            #izquierda)).
    "Nivel 9"
    lista add: (self numero: 9
        mapa: #(
            '........'
            '.######.'
            '.######.'
            '........'
            '.I####..'
            '........'
            '........')
        solucion: #(
            #arriba #derecha #arriba #izquierda #abajo #derecha #arriba #izquierda
            #abajo #izquierda)).
    "Nivel 10"
    lista add: (self numero: 10
        mapa: #(
            '........'
            '.######.'
            '.######.'
            '.######.'
            '........'
            '.I####..'
            '........'
            '........')
        solucion: #(
            #arriba #derecha #arriba #izquierda #abajo #derecha #arriba #izquierda
            #abajo #izquierda)).
    ^ lista
]

{ #category : 'accessing' }
Nivel >> bloqueos [
    | lista |
    lista := OrderedCollection new.
    1 to: self filas do: [ :fila |
        1 to: self columnas do: [ :columna |
            ((mapa at: fila) at: columna) = $# ifTrue: [
                lista add: ((Smalltalk globals at: #Posicion) fila: fila columna: columna) ] ] ].
    ^ lista
]

{ #category : 'accessing' }
Nivel >> columnas [
    ^ mapa first size
]

{ #category : 'testing' }
Nivel >> esElUltimo [
    ^ numero = (Smalltalk globals at: #Nivel) cantidad
]

{ #category : 'accessing' }
Nivel >> filas [
    ^ mapa size
]

{ #category : 'accessing' }
Nivel >> inicio [
    1 to: self filas do: [ :fila |
        1 to: self columnas do: [ :columna |
            ((mapa at: fila) at: columna) = $I ifTrue: [
                ^ (Smalltalk globals at: #Posicion) fila: fila columna: columna ] ] ].
    ^ self error: 'El mapa del nivel no tiene inicio (I)'
]

{ #category : 'accessing' }
Nivel >> mapa [
    ^ mapa
]

{ #category : 'accessing' }
Nivel >> numero [
    ^ numero
]

{ #category : 'initialization' }
Nivel >> setNumero: unNumero mapa: unasFilas solucion: unaSolucion [
    numero := unNumero.
    mapa := unasFilas.
    solucion := unaSolucion.
    ^ self
]

{ #category : 'accessing' }
Nivel >> solucion [
    ^ solucion
]
