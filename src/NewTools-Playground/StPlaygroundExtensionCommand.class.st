"
Extension point to add functionality to the playground. 

Commands inheriting `StPlaygroundExtensionCommand` will be added to the toolbar.
"
Class {
	#name : #StPlaygroundExtensionCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #testing }
StPlaygroundExtensionCommand class >> isAbstract [

	^ super isAbstract or: [ self == StPlaygroundExtensionCommand ]
]
