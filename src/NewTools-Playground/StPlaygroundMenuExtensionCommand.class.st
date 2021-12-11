"
Extension point to add functionality to the playground. 

Commands inheriting `StPlaygroundMenuExtensionCommand` will be added to the playground context menu.
"
Class {
	#name : #StPlaygroundMenuExtensionCommand,
	#superclass : #SpToolCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundMenuExtensionCommand class >> allCommands [

	^ self allSubclasses
]
