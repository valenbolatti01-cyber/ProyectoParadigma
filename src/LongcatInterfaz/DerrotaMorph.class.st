"
Animacion de derrota: hermana de VictoriaMorph (ambas heredan de AnimacionResultadoMorph) con tonos rojizos centralizados en EstiloLongcat. Al terminar evalua el bloque alTerminar, por ejemplo reiniciar el nivel.
"
Class {
	#name : 'DerrotaMorph',
	#superclass : 'AnimacionResultadoMorph',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
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

{ #category : 'private - stepping' }
DerrotaMorph >> duracionEnMilisegundos [
	^ 2200
]
