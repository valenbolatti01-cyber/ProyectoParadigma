"
Objeto de valor del dominio que encapsula las imagenes y estilos visuales de la cabeza y el cuerpo del gato. Permite agregar skins sin modificar TableroMorph.
"
Class {
	#name : 'SkinGato',
	#superclass : 'Object',
	#instVars : [
		'identificador',
		'nombre',
		'cabezaArriba',
		'cabezaAbajo',
		'cabezaDerecha',
		'cabezaIzquierda',
		'colorCuerpo',
		'colorRayas',
		'colorBorde'
	],
	#category : 'LongcatJuego',
	#package : 'LongcatJuego'
}

{ #category : 'instance creation' }
SkinGato class >> identificador: unId nombre: unNombre colorCuerpo: unColorCuerpo colorRayas: unColorRayas colorBorde: unColorBorde cabezaArriba: formaArriba cabezaAbajo: formaAbajo cabezaDerecha: formaDerecha cabezaIzquierda: formaIzquierda [
    ^ self basicNew
        inicializarIdentificador: unId
        nombre: unNombre
        colorCuerpo: unColorCuerpo
        colorRayas: unColorRayas
        colorBorde: unColorBorde
        cabezaArriba: formaArriba
        cabezaAbajo: formaAbajo
        cabezaDerecha: formaDerecha
        cabezaIzquierda: formaIzquierda
]

{ #category : 'instance creation' }
SkinGato class >> original [
    ^ self originalConImagenes: Dictionary new
]

{ #category : 'instance creation' }
SkinGato class >> originalConImagenes: unDiccionario [
    ^ self
        identificador: #original
        nombre: 'Original'
        colorCuerpo: EstiloLongcat colorNaranja
        colorRayas: EstiloLongcat colorRayas
        colorBorde: EstiloLongcat colorNaranja
        cabezaArriba: (unDiccionario at: #cabezaArriba ifAbsent: [ nil ])
        cabezaAbajo: (unDiccionario at: #cabezaAbajo ifAbsent: [ nil ])
        cabezaDerecha: (unDiccionario at: #cabezaDerecha ifAbsent: [ nil ])
        cabezaIzquierda: (unDiccionario at: #cabezaIzquierda ifAbsent: [ nil ])
]

{ #category : 'comparing' }
SkinGato >> = otraSkin [
    ^ self class = otraSkin class
        and: [ identificador = otraSkin identificador ]
]

{ #category : 'skins' }
SkinGato >> avatarEscaladoA: unTamano [
    ^ cabezaAbajo ifNotNil: [ :forma | forma scaledToSize: unTamano ]
]

{ #category : 'accessing' }
SkinGato >> cabezaAbajo [
    ^ cabezaAbajo
]

{ #category : 'accessing' }
SkinGato >> cabezaArriba [
    ^ cabezaArriba
]

{ #category : 'accessing' }
SkinGato >> cabezaDerecha [
    ^ cabezaDerecha
]

{ #category : 'accessing' }
SkinGato >> cabezaIzquierda [
    ^ cabezaIzquierda
]

{ #category : 'skins' }
SkinGato >> cabezaParaDireccion: unaDireccion [
    ^ unaDireccion spriteDeSkin: self
]

{ #category : 'accessing' }
SkinGato >> colorBorde [
    ^ colorBorde
]

{ #category : 'accessing' }
SkinGato >> colorContornoExterno [
    ^ Color white
]

{ #category : 'accessing' }
SkinGato >> colorContornoInterno [
    ^ Color black
]

{ #category : 'accessing' }
SkinGato >> colorCuerpo [
    ^ colorCuerpo
]

{ #category : 'accessing' }
SkinGato >> colorRayas [
    ^ colorRayas
]

{ #category : 'comparing' }
SkinGato >> hash [
    ^ identificador hash
]

{ #category : 'accessing' }
SkinGato >> identificador [
    ^ identificador
]

{ #category : 'initialization' }
SkinGato >> inicializarIdentificador: unId nombre: unNombre colorCuerpo: unColorCuerpo colorRayas: unColorRayas colorBorde: unColorBorde cabezaArriba: formaArriba cabezaAbajo: formaAbajo cabezaDerecha: formaDerecha cabezaIzquierda: formaIzquierda [
    identificador := unId.
    nombre := unNombre.
    colorCuerpo := unColorCuerpo.
    colorRayas := unColorRayas.
    colorBorde := unColorBorde.
    cabezaArriba := formaArriba.
    cabezaAbajo := formaAbajo.
    cabezaDerecha := formaDerecha.
    cabezaIzquierda := formaIzquierda.
    ^ self
]

{ #category : 'accessing' }
SkinGato >> nombre [
    ^ nombre
]
