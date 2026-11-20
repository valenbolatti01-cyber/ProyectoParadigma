"
Animacion de derrota: igual a la de victoria (velo oscuro, lluvia de pixeles y cartel con rebote) pero en tonos rojizos. Al terminar evalua el bloque alTerminar (por ejemplo, reiniciar el nivel).
"
Class {
	#name : 'DerrotaMorph',
	#superclass : 'VictoriaMorph',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'private - drawing' }
DerrotaMorph >> colorBorde [
	^ Color r: 255 g: 105 b: 120 range: 255

]

{ #category : 'private - drawing' }
DerrotaMorph >> colorTitulo [
	^ Color r: 255 g: 105 b: 120 range: 255

]

{ #category : 'private - drawing' }
DerrotaMorph >> coloresConfeti [
	^ {
		Color r: 255 g: 105 b: 120 range: 255.
		Color r: 139 g: 115 b: 214 range: 255.
		Color r: 90 g: 98 b: 120 range: 255.
		Color gray }

]

{ #category : 'initialization' }
DerrotaMorph >> initialize [
	super initialize.
	duracion := 2200.
	^ self

]
