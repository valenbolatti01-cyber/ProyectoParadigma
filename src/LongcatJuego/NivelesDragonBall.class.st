"
Paquete tematico de Dragon Ball: 10 niveles ordenados del 1 (el mas facil) al 10 (el mas dificil). Cada nivel conoce una solucion minima y una maxima reales del tablero (verificadas con AnalizadorDeNivel) y los limites de movimientos de sus estrellas.
"
Class {
	#name : 'NivelesDragonBall',
	#superclass : 'ColeccionNiveles',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'accessing' }
NivelesDragonBall >> identificador [
    ^ #dragonBall
]

{ #category : 'levels' }
NivelesDragonBall >> niveles [
    "Mapa: # pared, . casilla libre, I inicio del gato (una sola I por nivel).
     solucionMinima / solucionMaxima: movimientos #arriba #abajo #izquierda #derecha de una solucion con la menor y la mayor cantidad de movimientos posible.
     Las estrellas se otorgan segun los movimientos: tres hasta tresEstrellasHasta, dos hasta dosEstrellasHasta y una hasta el maximo."
    | lista |
    lista := OrderedCollection new.
    lista add: (NivelPuntuado numero: 1
        mapa: #(
            '.....'
            '.##..'
            '.....'
            '#I...')
        solucionMinima: #(
            #derecha #arriba #izquierda #abajo #derecha #arriba)
        solucionMaxima: #(
            #arriba #izquierda #arriba #derecha #abajo #izquierda #arriba #derecha
            #arriba)
        tresEstrellasHasta: 7
        dosEstrellasHasta: 8).
    lista add: (NivelPuntuado numero: 2
        mapa: #(
            '..###'
            '.....'
            '...#.'
            '.I...'
            '.....')
        solucionMinima: #(
            #arriba #izquierda #abajo #derecha #arriba #izquierda #abajo #derecha)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #abajo #derecha #arriba #derecha
            #abajo #izquierda #arriba #derecha)
        tresEstrellasHasta: 9
        dosEstrellasHasta: 11).
    lista add: (NivelPuntuado numero: 3
        mapa: #(
            '.....#'
            '.###..'
            '...I#.'
            '......'
            '.....#')
        solucionMinima: #(
            #izquierda #arriba #derecha #abajo #derecha #abajo #izquierda #abajo
            #derecha)
        solucionMaxima: #(
            #abajo #derecha #arriba #derecha #arriba #izquierda #arriba #izquierda
            #abajo #derecha #arriba #izquierda #abajo)
        tresEstrellasHasta: 10
        dosEstrellasHasta: 12).
    lista add: (NivelPuntuado numero: 4
        mapa: #(
            '..#...'
            '....#.'
            '...##.'
            '.I.##.'
            '.#....'
            '......')
        solucionMinima: #(
            #arriba #izquierda #abajo #derecha #arriba #izquierda #abajo #izquierda
            #abajo #derecha)
        solucionMaxima: #(
            #derecha #abajo #izquierda #arriba #derecha #abajo #derecha #arriba
            #derecha #arriba #derecha #abajo #izquierda #arriba #derecha)
        tresEstrellasHasta: 11
        dosEstrellasHasta: 13).
    lista add: (NivelPuntuado numero: 5
        mapa: #(
            '..#...'
            '....#.'
            '...##.'
            '.I.#..'
            '.#....'
            '......')
        solucionMinima: #(
            #arriba #izquierda #abajo #derecha #arriba #izquierda #abajo #izquierda
            #abajo #derecha #arriba)
        solucionMaxima: #(
            #derecha #abajo #izquierda #arriba #derecha #abajo #derecha #arriba
            #derecha #arriba #derecha #abajo #izquierda #arriba #derecha #arriba)
        tresEstrellasHasta: 12
        dosEstrellasHasta: 14).
    lista add: (NivelPuntuado numero: 6
        mapa: #(
            '.......'
            '.......'
            '#..I#..'
            '..###..'
            '.##....'
            '.......')
        solucionMinima: #(
            #izquierda #abajo #izquierda #abajo #derecha #arriba #izquierda #abajo
            #derecha #abajo #izquierda)
        solucionMaxima: #(
            #arriba #izquierda #abajo #derecha #abajo #izquierda #abajo #izquierda
            #abajo #derecha #arriba #izquierda #abajo #derecha #abajo #izquierda)
        tresEstrellasHasta: 12
        dosEstrellasHasta: 14).
    lista add: (NivelPuntuado numero: 7
        mapa: #(
            '#......'
            '..####.'
            '.#I....'
            '......#'
            '..##...'
            '.....#.'
            '.......')
        solucionMinima: #(
            #derecha #arriba #izquierda #abajo #izquierda #abajo #derecha #arriba
            #izquierda #abajo #izquierda #arriba #derecha)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #arriba #derecha #abajo #izquierda
            #abajo #derecha #abajo #derecha #abajo #izquierda #arriba #derecha
            #abajo #derecha #arriba)
        tresEstrellasHasta: 15
        dosEstrellasHasta: 17).
    lista add: (NivelPuntuado numero: 8
        mapa: #(
            '..##...#'
            '.....#..'
            '...I.##.'
            '........'
            '..####..'
            '........'
            '........')
        solucionMinima: #(
            #derecha #arriba #derecha #abajo #derecha #abajo #izquierda #arriba
            #derecha #abajo #derecha #arriba #izquierda #arriba #derecha)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #abajo #derecha #arriba #derecha
            #arriba #derecha #abajo #derecha #abajo #izquierda #arriba #derecha
            #abajo #derecha #arriba #izquierda #arriba)
        tresEstrellasHasta: 17
        dosEstrellasHasta: 19).
    lista add: (NivelPuntuado numero: 9
        mapa: #(
            '........'
            '.##...I.'
            '....#...'
            '#.......'
            '........'
            '.#......'
            '...###..')
        solucionMinima: #(
            #abajo #derecha #arriba #izquierda #abajo #derecha #arriba #derecha
            #abajo #izquierda #abajo #izquierda #arriba #derecha #arriba #izquierda)
        solucionMaxima: #(
            #arriba #derecha #abajo #izquierda #arriba #izquierda #abajo #izquierda
            #abajo #izquierda #arriba #derecha #arriba #izquierda #arriba #izquierda
            #arriba #derecha #abajo #izquierda #abajo #izquierda)
        tresEstrellasHasta: 18
        dosEstrellasHasta: 20).
    lista add: (NivelPuntuado numero: 10
        mapa: #(
            '........'
            '.##...I.'
            '....#...'
            '#.......'
            '........'
            '.##.....'
            '....##..')
        solucionMinima: #(
            #abajo #derecha #arriba #izquierda #abajo #derecha #arriba #derecha
            #abajo #izquierda #abajo #izquierda #arriba #derecha #arriba #izquierda)
        solucionMaxima: #(
            #arriba #derecha #abajo #izquierda #arriba #izquierda #abajo #izquierda
            #abajo #izquierda #arriba #derecha #arriba #izquierda #arriba #izquierda
            #arriba #derecha #abajo #izquierda #abajo #izquierda)
        tresEstrellasHasta: 18
        dosEstrellasHasta: 20).
    ^ lista
]

{ #category : 'accessing' }
NivelesDragonBall >> nombre [
    ^ 'Dragon Ball'
]
