"
Paquete tematico de niveles de Minecraft. Listo para incorporar mapas personalizados.
"
Class {
	#name : 'NivelesMinecraft',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'levels' }
NivelesMinecraft >> niveles [
    "Agregar aqui los objetos Nivel tematicos de Minecraft."
    ^ OrderedCollection new
]

{ #category : 'accessing' }
NivelesMinecraft >> nombre [
    ^ 'Minecraft'
]
