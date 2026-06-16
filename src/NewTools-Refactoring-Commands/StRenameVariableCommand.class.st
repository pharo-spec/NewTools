"
I am a command to rename a variable. 
"
Class {
	#name : 'StRenameVariableCommand',
	#superclass : 'StRefactoringVariableCommand',
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

	^ '(R) Rename variable'
]

{ #category : 'accessing' }
StRenameVariableCommand class >> defaultShortcut [

	^ $r actionModifier
]

{ #category : 'accessing' }
StRenameVariableCommand class >> priority [

	^ 1
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
