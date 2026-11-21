"
Paquete estandar de 10 niveles clasicos de Longcat.
"
Class {
	#name : 'NivelesNormales',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'accessing' }
NivelesNormales >> claveIcono [
    ^ #botonNormales
]

{ #category : 'levels' }
NivelesNormales >> niveles [
    "Mapa: # pared, . casilla libre, I inicio del gato (una sola I por nivel).
     Solucion: lista de movimientos #arriba #abajo #izquierda #derecha que llenan todo el tablero."
    | lista |
    lista := OrderedCollection new.
    lista add: (Nivel numero: 1
        mapa: #(
            '....'
            '..I.'
            '#..#')
        solucion: #(
            #derecha #arriba #izquierda #abajo #derecha #abajo #derecha)).
    lista add: (Nivel numero: 2
        mapa: #(
            '#..I'
            '...#'
            '.#..'
            '....')
        solucion: #(
            #izquierda #abajo #izquierda #abajo #derecha #arriba #izquierda #arriba)).
    lista add: (Nivel numero: 3
        mapa: #(
            '..#..'
            '.#...'
            '...#.'
            '#..I.')
        solucion: #(
            #derecha #arriba #izquierda #abajo #izquierda #abajo #izquierda #arriba
            #izquierda #arriba #derecha)).
    lista add: (Nivel numero: 4
        mapa: #(
            '#....'
            '..#..'
            '.#..I'
            '..#..'
            '#...#')
        solucion: #(
            #abajo #izquierda #abajo #izquierda #arriba #izquierda #arriba #derecha
            #arriba #derecha #abajo #izquierda #abajo #izquierda)).
    lista add: (Nivel numero: 5
        mapa: #(
            '...I.#'
            '.#.#..'
            '.#..#.'
            '..#...'
            '#..#..')
        solucion: #(
            #derecha #abajo #derecha #abajo #izquierda #arriba #izquierda #arriba
            #izquierda #arriba #izquierda #abajo #derecha #abajo #derecha)).
    lista add: (Nivel numero: 6
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
    lista add: (Nivel numero: 7
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
    lista add: (Nivel numero: 8
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
    lista add: (Nivel numero: 9
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
    lista add: (Nivel numero: 10
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
NivelesNormales >> nombre [
    ^ 'Niveles Normales'
]
