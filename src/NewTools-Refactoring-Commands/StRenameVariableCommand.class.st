"
I am a command to rename a variable. 
"
Class {
	#name : 'StRenameVariableCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StRenameVariableCommand class >> defaultDescription [ 

	^ 'Rename variable'
]

{ #category : 'accessing' }
StRenameVariableCommand class >> defaultIconName [
	^ #edit
]

{ #category : 'default' }
StRenameVariableCommand class >> defaultName [

	^ 'Rename'
]

{ #category : 'testing' }
StRenameVariableCommand >> canBeExecuted [

	^ self codePresenter selectedNode isLiteralVariable | self codePresenter selectedNode isInstanceVariable and: [
		  self codePresenter selectedNode isGlobalVariable not ]
]

{ #category : 'executing' }
StRenameVariableCommand >> prepareDriver [

	| variable driver |
	variable := self codePresenter selectedNode.

	driver := variable isClassVariable
		          ifFalse: [ ReRenameInstanceVariableDriver new ]
		          ifTrue: [ ReRenameSharedVariableDriver new ].

	^ driver scopes: context allScopes variable: variable name for: self codePresenter behavior
]
