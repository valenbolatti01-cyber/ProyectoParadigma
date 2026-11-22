"
Nivel con movimientos de referencia: conoce una solucion minima y una maxima (soluciones reales del tablero) y el rango de movimientos que determina las estrellas. Se usa en los niveles personalizados de cada mundo.
"
Class {
	#name : 'NivelPuntuado',
	#superclass : 'Nivel',
	#instVars : [
		'solucionMaxima',
		'rango'
	],
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
NivelPuntuado class >> numero: unNumero mapa: unasFilas solucionMinima: unaSolucionMinima solucionMaxima: unaSolucionMaxima [
    ^ self basicNew
        setNumero: unNumero
        mapa: unasFilas
        solucionMinima: unaSolucionMinima
        solucionMaxima: unaSolucionMaxima
        rango: (RangoMovimientos minimo: unaSolucionMinima size maximo: unaSolucionMaxima size)
]

{ #category : 'instance creation' }
NivelPuntuado class >> numero: unNumero mapa: unasFilas solucionMinima: unaSolucionMinima solucionMaxima: unaSolucionMaxima tresEstrellasHasta: unLimiteTres dosEstrellasHasta: unLimiteDos [
    ^ self basicNew
        setNumero: unNumero
        mapa: unasFilas
        solucionMinima: unaSolucionMinima
        solucionMaxima: unaSolucionMaxima
        rango: (RangoMovimientos
            minimo: unaSolucionMinima size
            maximo: unaSolucionMaxima size
            tresEstrellasHasta: unLimiteTres
            dosEstrellasHasta: unLimiteDos)
]

{ #category : 'accessing' }
NivelPuntuado >> rango [
    ^ rango
]

{ #category : 'initialization' }
NivelPuntuado >> setNumero: unNumero mapa: unasFilas solucionMinima: unaSolucionMinima solucionMaxima: unaSolucionMaxima rango: unRango [
    self setNumero: unNumero mapa: unasFilas solucion: unaSolucionMinima.
    solucionMaxima := unaSolucionMaxima.
    rango := unRango.
    ^ self
]

{ #category : 'accessing' }
NivelPuntuado >> solucionMaxima [
    ^ solucionMaxima
]

{ #category : 'accessing' }
NivelPuntuado >> solucionMinima [
    ^ self solucion
]
