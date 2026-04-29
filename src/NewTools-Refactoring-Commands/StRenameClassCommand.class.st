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

	^ '(R) Rename'
]

{ #category : 'executing' }
StRenameClassCommand >> prepareDriver [

	^ (ReRenameClassDriver rename: self codePresenter selectedNode name)
		  model: RBBrowserEnvironment new;
		  scopes: context allScopes
]
