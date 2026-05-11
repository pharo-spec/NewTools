"
Call the rename method refactoring 
"
Class {
	#name : 'StRenameMethodCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StRenameMethodCommand class >> defaultDescription [

	^ 'Rename selected method'
]

{ #category : 'accessing' }
StRenameMethodCommand class >> defaultIconName [

	^ #edit
]

{ #category : 'default' }
StRenameMethodCommand class >> defaultName [

	^ '(R) Rename method'
]

{ #category : 'accessing' }
StRenameMethodCommand class >> defaultShortcut [

	^ $r actionModifier
]

{ #category : 'testing' }
StRenameMethodCommand >> canBeExecuted [

	^ self codePresenter selectedNode isMessage | self codePresenter selectedNode isMethod
]

{ #category : 'executing' }
StRenameMethodCommand >> prepareDriver [

	^ (ReRenameMethodDriver newApplication: self application)
		  scopes: context allScopes
		  model: (RBNamespace onEnvironment: context allScopes first)
		  renameMethodSignature: self codePresenter selectedNode
		  in: self codePresenter behavior
]
