"
Extension point to add functionality to the playground. 

Commands inheriting `StPlaygroundToolbarExtensionCommand` will be added to the toolbar.
"
Class {
	#name : #StPlaygroundToolbarExtensionCommand,
	#superclass : #StPlaygroundCommand,
	#category : #'NewTools-Playground-Command'
}

{ #category : #accessing }
StPlaygroundToolbarExtensionCommand class >> allCommands [

	^ self allSubclasses reject: [ :each | each isAbstract ]
]

{ #category : #testing }
StPlaygroundToolbarExtensionCommand class >> isAbstract [

	^ super isAbstract or: [ self == StPlaygroundToolbarExtensionCommand ]
]
