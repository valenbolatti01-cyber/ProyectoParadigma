"
Paquete tematico de Minecraft: 10 niveles ordenados del 1 (el mas facil) al 10 (el mas dificil). Cada nivel conoce una solucion minima y una maxima reales del tablero (verificadas con AnalizadorDeNivel) y los limites de movimientos de sus estrellas.
"
Class {
	#name : 'NivelesMinecraft',
	#superclass : 'ColeccionNiveles',
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'accessing' }
NivelesMinecraft >> identificador [
    ^ #minecraft
]

{ #category : 'levels' }
NivelesMinecraft >> niveles [
    "Mapa: # pared, . casilla libre, I inicio del gato (una sola I por nivel).
     solucionMinima / solucionMaxima: movimientos #arriba #abajo #izquierda #derecha de una solucion con la menor y la mayor cantidad de movimientos posible.
     Las estrellas se otorgan segun los movimientos: tres hasta tresEstrellasHasta, dos hasta dosEstrellasHasta y una hasta el maximo."
    | lista |
    lista := OrderedCollection new.
    lista add: (NivelPuntuado numero: 1
        mapa: #(
            '.....'
            '...I.'
            '.###.'
            '.....')
        solucionMinima: #(
            #izquierda #abajo #derecha #arriba #izquierda)
        solucionMaxima: #(
            #arriba #derecha #abajo #izquierda #arriba #derecha #abajo #izquierda)
        tresEstrellasHasta: 6
        dosEstrellasHasta: 7).
    lista add: (NivelPuntuado numero: 2
        mapa: #(
            '..###'
            '.....'
            '...#.'
            '.I.#.'
            '.....')
        solucionMinima: #(
            #arriba #izquierda #abajo #derecha #arriba #izquierda #abajo)
        solucionMaxima: #(
            #abajo #izquierda #arriba #derecha #abajo #derecha #arriba #derecha
            #abajo #izquierda #arriba)
        tresEstrellasHasta: 8
        dosEstrellasHasta: 10).
    lista add: (NivelPuntuado numero: 3
        mapa: #(
            '......'
            '.I....'
            '...##.'
            '......'
            '..####')
        solucionMinima: #(
            #abajo #izquierda #arriba #derecha #abajo #izquierda #arriba #derecha)
        solucionMaxima: #(
            #arriba #izquierda #abajo #derecha #arriba #derecha #abajo #derecha
            #arriba #izquierda #abajo #derecha)
        tresEstrellasHasta: 9
        dosEstrellasHasta: 11).
    lista add: (NivelPuntuado numero: 4
        mapa: #(
            '#.....'
            '#.##..'
            '#.....'
            '...I#.'
            '......')
        solucionMinima: #(
            #izquierda #abajo #derecha #arriba #izquierda #abajo #derecha #arriba)
        solucionMaxima: #(
            #arriba #derecha #abajo #izquierda #arriba #derecha #arriba #izquierda
            #arriba #derecha #abajo #izquierda)
        tresEstrellasHasta: 9
        dosEstrellasHasta: 11).
    lista add: (NivelPuntuado numero: 5
        mapa: #(
            '....I#'
            '.#....'
            '.#.##.'
            '.#....'
            '...#..')
        solucionMinima: #(
            #izquierda #abajo #derecha #arriba #derecha #abajo #izquierda #arriba
            #izquierda)
        solucionMaxima: #(
            #abajo #derecha #abajo #izquierda #arriba #izquierda #abajo #izquierda
            #arriba #derecha #abajo #izquierda #abajo)
        tresEstrellasHasta: 10
        dosEstrellasHasta: 12).
    lista add: (NivelPuntuado numero: 6
        mapa: #(
            '......'
            '....I.'
            '#.....'
            '...#..'
            '.#....'
            '......')
        solucionMinima: #(
            #izquierda #arriba #derecha #abajo #izquierda #arriba #derecha #abajo
            #derecha #arriba #izquierda)
        solucionMaxima: #(
            #derecha #arriba #izquierda #abajo #derecha #abajo #izquierda #abajo
            #izquierda #abajo #derecha #arriba #izquierda #abajo #izquierda #arriba)
        tresEstrellasHasta: 12
        dosEstrellasHasta: 14).
    lista add: (NivelPuntuado numero: 7
        mapa: #(
            '...##..'
            '.#.....'
            '..##...'
            '..##.I.'
            '.....#.'
            '.......')
        solucionMinima: #(
            #arriba #derecha #abajo #izquierda #arriba #derecha #abajo #derecha
            #abajo #izquierda #arriba)
        solucionMaxima: #(
            #izquierda #abajo #derecha #arriba #izquierda #abajo #izquierda #arriba
            #izquierda #arriba #izquierda #abajo #derecha #arriba #izquierda #arriba)
        tresEstrellasHasta: 12
        dosEstrellasHasta: 14).
    lista add: (NivelPuntuado numero: 8
        mapa: #(
            '...####'
            '.#..#..'
            '.##....'
            '.......'
            '..##...'
            '.....I.'
            '.......')
        solucionMinima: #(
            #arriba #derecha #abajo #izquierda #arriba #derecha #abajo #derecha
            #abajo #izquierda #abajo #derecha #arriba)
        solucionMaxima: #(
            #abajo #derecha #arriba #izquierda #abajo #izquierda #arriba #izquierda
            #arriba #izquierda #arriba #izquierda #abajo #derecha #arriba #izquierda
            #arriba #derecha)
        tresEstrellasHasta: 14
        dosEstrellasHasta: 16).
    lista add: (NivelPuntuado numero: 9
        mapa: #(
            '#......'
            '..####.'
            '.......'
            '..I...#'
            '...##..'
            '...###.'
            '.......')
        solucionMinima: #(
            #derecha #abajo #derecha #abajo #izquierda #arriba #derecha #arriba
            #derecha #abajo #izquierda #abajo #derecha #arriba)
        solucionMaxima: #(
            #arriba #izquierda #arriba #derecha #arriba #derecha #abajo #izquierda
            #abajo #derecha #abajo #derecha #abajo #izquierda #arriba #derecha
            #abajo #derecha #arriba)
        tresEstrellasHasta: 15
        dosEstrellasHasta: 17).
    lista add: (NivelPuntuado numero: 10
        mapa: #(
            '...##..'
            '.#.....'
            '.###...'
            '..##I..'
            '....#..'
            '..#....'
            '#......')
        solucionMinima: #(
            #arriba #izquierda #arriba #izquierda #abajo #derecha #abajo #derecha
            #arriba #izquierda #abajo #izquierda #arriba #izquierda #arriba)
        solucionMaxima: #(
            #derecha #arriba #izquierda #abajo #izquierda #arriba #izquierda #arriba
            #izquierda #abajo #derecha #abajo #derecha #arriba #izquierda #abajo
            #izquierda #arriba #izquierda #arriba)
        tresEstrellasHasta: 16
        dosEstrellasHasta: 18).
    ^ lista
]

{ #category : 'accessing' }
NivelesMinecraft >> nombre [
    ^ 'Minecraft'
]
