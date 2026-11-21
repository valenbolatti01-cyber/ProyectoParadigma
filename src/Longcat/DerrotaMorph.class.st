"
Animacion de derrota: reutiliza la logica de VictoriaMorph con tonos rojizos centralizados en EstiloLongcat.
"
Class {
	#name : 'DerrotaMorph',
	#superclass : 'VictoriaMorph',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'private - drawing' }
DerrotaMorph >> colorBorde [
	^ EstiloLongcat colorRojoAlerta
]

{ #category : 'private - drawing' }
DerrotaMorph >> colorTitulo [
	^ EstiloLongcat colorRojoAlerta
]

{ #category : 'private - drawing' }
DerrotaMorph >> coloresConfeti [
	^ {
		EstiloLongcat colorRojoAlerta.
		EstiloLongcat colorMorado.
		EstiloLongcat colorGrisBloqueado.
		Color gray }
]

{ #category : 'initialization' }
DerrotaMorph >> initialize [
	super initialize.
	duracion := 2200.
	^ self
]
