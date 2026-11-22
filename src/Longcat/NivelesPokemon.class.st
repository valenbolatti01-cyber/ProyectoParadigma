"
Paquete tematico de Pokémon: 10 niveles ordenados del 1 (el mas facil) al 10 (el mas dificil). Cada nivel conoce una solucion minima y una maxima reales del tablero (verificadas con AnalizadorDeNivel) y los limites de movimientos de sus estrellas.
"
Class {
	#name : 'NivelesPokemon',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'accessing' }
NivelesPokemon >> identificador [
    ^ #pokemon
]

{ #category : 'levels' }
NivelesPokemon >> niveles [
    "Mapa: # pared, . casilla libre, I inicio del gato (una sola I por nivel).
     solucionMinima / solucionMaxima: movimientos #arriba #abajo #izquierda #derecha de una solucion con la menor y la mayor cantidad de movimientos posible.
     Las estrellas se otorgan segun los movimientos: tres hasta tresEstrellasHasta, dos hasta dosEstrellasHasta y una hasta el maximo."
    | lista |
    lista := OrderedCollection new.
    lista add: (NivelPuntuado numero: 1
        mapa: #(
            '.....'
            '.###.'
            '.....'
            '#I...')
        solucionMinima: #(
            #derecha #arriba #izquierda #abajo #derecha)
        solucionMaxima: #(
            #arriba #izquierda #arriba #derecha #abajo #izquierda #arriba #derecha)
        tresEstrellasHasta: 6
        dosEstrellasHasta: 7).
    lista add: (NivelPuntuado numero: 2
        mapa: #(
            '.....'
            '.....'
            '.##..'
            '.##.I'
            '....#')
        solucionMinima: #(
            #arriba #izquierda #abajo #derecha #arriba #izquierda)
        solucionMaxima: #(
            #izquierda #abajo #izquierda #arriba #derecha #abajo #izquierda #arriba
            #izquierda)
        tresEstrellasHasta: 7
        dosEstrellasHasta: 8).
    lista add: (NivelPuntuado numero: 3
        mapa: #(
            '###...'
            '....#.'
            '......'
            '.I...#'
            '.....#')
        solucionMinima: #(
            #derecha #abajo #izquierda #arriba #derecha #arriba #derecha #abajo
            #izquierda)
        solucionMaxima: #(
            #izquierda #abajo #derecha #arriba #derecha #arriba #izquierda #abajo
            #izquierda #arriba #izquierda #abajo #derecha)
        tresEstrellasHasta: 10
        dosEstrellasHasta: 12).
    lista add: (NivelPuntuado numero: 4
        mapa: #(
            '...###'
            '.#....'
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
    lista add: (NivelPuntuado numero: 5
        mapa: #(
            '......'
            '....I.'
            '#.....'
            '..###.'
            '.####.'
            '......')
        solucionMinima: #(
            #izquierda #arriba #derecha #abajo #izquierda #arriba #derecha #arriba
            #derecha)
        solucionMaxima: #(
            #abajo #derecha #arriba #izquierda #abajo #derecha #abajo #izquierda
            #abajo #izquierda #abajo #derecha #arriba)
        tresEstrellasHasta: 10
        dosEstrellasHasta: 12).
    lista add: (NivelPuntuado numero: 6
        mapa: #(
            '.......'
            '.......'
            '#..I#..'
            '..#....'
            '.#####.'
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
            '.......'
            '.#####.'
            '.#I....'
            '......#'
            '..##...'
            '.....#.'
            '.......')
        solucionMinima: #(
            #derecha #arriba #izquierda #abajo #derecha #arriba #izquierda #abajo
            #izquierda #arriba #derecha)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #abajo #izquierda #abajo #derecha
            #abajo #derecha #abajo #izquierda #arriba #derecha #abajo #derecha
            #arriba)
        tresEstrellasHasta: 13
        dosEstrellasHasta: 15).
    lista add: (NivelPuntuado numero: 8
        mapa: #(
            '..##....'
            '.....##.'
            '...I.##.'
            '........'
            '..####..'
            '........'
            '........')
        solucionMinima: #(
            #derecha #arriba #derecha #abajo #izquierda #arriba #derecha #abajo
            #derecha #arriba #izquierda #arriba #derecha)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #abajo #derecha #arriba #derecha
            #arriba #derecha #abajo #izquierda #arriba #derecha #abajo #derecha
            #arriba #izquierda #arriba)
        tresEstrellasHasta: 15
        dosEstrellasHasta: 17).
    lista add: (NivelPuntuado numero: 9
        mapa: #(
            '...##..'
            '.#.....'
            '.###...'
            '...#I..'
            '....#..'
            '.##....'
            '.......')
        solucionMinima: #(
            #arriba #izquierda #arriba #izquierda #abajo #derecha #arriba #izquierda
            #abajo #izquierda #arriba #izquierda #arriba #derecha)
        solucionMaxima: #(
            #derecha #arriba #izquierda #abajo #izquierda #arriba #izquierda #arriba
            #izquierda #abajo #derecha #arriba #izquierda #abajo #izquierda #arriba
            #izquierda #arriba #derecha)
        tresEstrellasHasta: 15
        dosEstrellasHasta: 17).
    lista add: (NivelPuntuado numero: 10
        mapa: #(
            '#......'
            '..####.'
            '.......'
            '..#I..#'
            '...##..'
            '.#...#.'
            '.......')
        solucionMinima: #(
            #derecha #abajo #derecha #abajo #izquierda #arriba #derecha #arriba
            #derecha #abajo #izquierda #abajo #derecha #abajo #derecha)
        solucionMaxima: #(
            #arriba #izquierda #arriba #derecha #arriba #derecha #abajo #izquierda
            #abajo #derecha #abajo #derecha #abajo #izquierda #arriba #derecha
            #abajo #derecha #abajo #derecha)
        tresEstrellasHasta: 16
        dosEstrellasHasta: 18).
    ^ lista
]

{ #category : 'accessing' }
NivelesPokemon >> nombre [
    ^ 'Pokémon'
]
