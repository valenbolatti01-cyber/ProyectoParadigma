"
Paquete tematico de niveles de Minecraft. Listo para incorporar mapas personalizados.
"
Class {
	#name : 'NivelesMinecraft',
	#superclass : 'ColeccionNiveles',
	#category : 'Longcat',
	#package : 'Longcat'
}

{ #category : 'accessing' }
NivelesMinecraft >> claveIcono [
    ^ #minecraft
]

{ #category : 'theme' }
NivelesMinecraft >> colorTema [
    ^ EstiloLongcat colorVerde
]

{ #category : 'levels' }
NivelesMinecraft >> niveles [
    "Agregar aqui los objetos Nivel tematicos de Minecraft."
    ^ OrderedCollection new
]

{ #category : 'accessing' }
NivelesMinecraft >> nombre [
    ^ 'Minecraft'
]

{ #category : 'theme' }
NivelesMinecraft >> tituloVentana [
    ^ 'minecraft.exe'
]
