"
Abstracción de una dirección ortogonal. Define cómo calcular la posición siguiente; las subclases proveen desplazamientos distintos.
"
Class {
	#name : 'Direccion',
	#superclass : 'Object',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'instance creation' }
Direccion class >> todas [
    ^ { (Smalltalk globals at: #Arriba) new. (Smalltalk globals at: #Abajo) new. (Smalltalk globals at: #Derecha) new. (Smalltalk globals at: #Izquierda) new }
]

{ #category : 'movement' }
Direccion >> desplazamiento [
    self subclassResponsibility
]

{ #category : 'movement' }
Direccion >> posicionSiguienteA: unaPosicion [
    ^ unaPosicion + self desplazamiento
]
