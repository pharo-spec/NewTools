"
Rename selected class from a code presenter
"
Class {
	#name : 'StRenameClassCommand',
	#superclass : 'StRefactoringClassCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StRenameClassCommand class >> defaultDescription [

	^ 'Rename selected class'
]

{ #category : 'accessing' }
StRenameClassCommand class >> defaultIconName [

	^ #edit 
]

{ #category : 'default' }
StRenameClassCommand class >> defaultName [

	^ '(R) Rename class'
]

{ #category : 'accessing' }
StRenameClassCommand class >> defaultShortcut [

	^ $r actionModifier
]

{ #category : 'testing' }
StRenameClassCommand class >> isAbstractCommand [

	^ false
]

{ #category : 'accessing' }
StRenameClassCommand class >> priority [

	^ 2
]

{ #category : 'testing' }
StRenameClassCommand >> canBeExecuted [

	| node |
	node := self codePresenter selectedNode.
	^ node isGlobalVariable and: [ node binding value isClass ]
]

{ #category : 'executing' }
StRenameClassCommand >> prepareDriver [

	^ (ReRenameClassDriver rename: self codePresenter selectedNode name)
		  model: RBBrowserEnvironment new;
		  scopes: context allScopes
]
