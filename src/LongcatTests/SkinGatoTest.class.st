"
Verifica el encapsulamiento visual, igualdad por valor y despacho polimorfico de sprites en SkinGato.
"
Class {
	#name : 'SkinGatoTest',
	#superclass : 'TestCase',
	#category : 'LongcatTests',
	#package : 'LongcatTests'
}

{ #category : 'tests - polymorphism' }
SkinGatoTest >> testCabezaParaDireccionDespachaPolimorficamente [
    | skin |
    skin := SkinGato
        identificador: #prueba
        nombre: 'Prueba'
        colorCuerpo: EstiloLongcat colorVerde
        colorRayas: EstiloLongcat colorMorado
        colorBorde: EstiloLongcat colorVerde
        cabezaArriba: #imgArriba
        cabezaAbajo: #imgAbajo
        cabezaDerecha: #imgDerecha
        cabezaIzquierda: #imgIzquierda.
    self assert: (skin cabezaParaDireccion: Arriba new) = #imgArriba.
    self assert: (skin cabezaParaDireccion: Abajo new) = #imgAbajo.
    self assert: (skin cabezaParaDireccion: Derecha new) = #imgDerecha.
    self assert: (skin cabezaParaDireccion: Izquierda new) = #imgIzquierda
]

{ #category : 'tests - domain' }
SkinGatoTest >> testSkinOriginalTieneColoresCentralizadosYSeComparaPorValor [
    | primera segunda |
    primera := SkinGato original.
    segunda := SkinGato original.
    self assert: primera = segunda.
    self assert: primera colorCuerpo = EstiloLongcat colorNaranja.
    self assert: primera colorRayas = EstiloLongcat colorRayas
]
