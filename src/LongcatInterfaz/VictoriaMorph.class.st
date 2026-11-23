"
Animacion de victoria: velo oscuro, confeti de colores y cartel amarillo con rebote. Es la base de ResultadoNivelMorph, que agrega estrellas y botones.
"
Class {
	#name : 'VictoriaMorph',
	#superclass : 'AnimacionResultadoMorph',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'private - drawing' }
VictoriaMorph >> colorBorde [
	^ EstiloLongcat colorMorado
]

{ #category : 'private - drawing' }
VictoriaMorph >> colorTitulo [
	^ EstiloLongcat colorAmarillo
]

{ #category : 'private - drawing' }
VictoriaMorph >> coloresConfeti [
	^ {
		EstiloLongcat colorNaranja.
		EstiloLongcat colorMorado.
		EstiloLongcat colorVerde.
		EstiloLongcat colorRosaConfeti.
		EstiloLongcat colorAmarillo.
		Color white }
]

{ #category : 'private - stepping' }
VictoriaMorph >> duracionEnMilisegundos [
	^ 2500
]
