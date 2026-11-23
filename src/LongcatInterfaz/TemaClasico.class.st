"
Aspecto original de Longcat (monitor retro). Es el tema de los niveles normales y de los mundos que todavia no tienen un tema propio.
"
Class {
	#name : 'TemaClasico',
	#superclass : 'TemaMundo',
	#category : 'LongcatInterfaz',
	#package : 'LongcatInterfaz'
}

{ #category : 'accessing' }
TemaClasico class >> identificadorDeMundo [
	^ #normales
]

{ #category : 'instance creation' }
TemaClasico >> crearInterfazPara: unaApp progreso: unProgreso [
	^ InterfazPartida app: unaApp progreso: unProgreso
]
