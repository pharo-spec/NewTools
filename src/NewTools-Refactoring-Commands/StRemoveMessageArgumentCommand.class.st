"
I am a command to remove existing argument from the message.
"
Class {
	#name : 'StRemoveMessageArgumentCommand',
	#superclass : 'StRefactoringCommand',
	#instVars : [
		'methodName'
	],
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StRemoveMessageArgumentCommand class >> defaultDescription [

	^ 'Remove argument for the selected message'
]

{ #category : 'accessing' }
StRemoveMessageArgumentCommand class >> defaultIconName [
	^#remove
]

{ #category : 'default' }
StRemoveMessageArgumentCommand class >> defaultName [

	^ 'Remove argument'
]

{ #category : 'testing' }
StRemoveMessageArgumentCommand >> canBeExecuted [

	^ self codePresenter selectedNode isMessage and: [ self codePresenter selectedNode arguments isNotEmpty ]
]

{ #category : 'private' }
StRemoveMessageArgumentCommand >> computeArgumentName [

	^ (self codePresenter selectedNode argumentPartStrings reject: [ :arg | (self methodName arguments indexOf: arg) > 0 ]) first
]

{ #category : 'executing' }
StRemoveMessageArgumentCommand >> execute [

	self prepareDriver execute
]

{ #category : 'private' }
StRemoveMessageArgumentCommand >> informArgumentError [

	self inform: 'Argument not found in method ''' , self codePresenter selectedNode selector , ''''
]

{ #category : 'accessing' }
StRemoveMessageArgumentCommand >> methodName [

	^ methodName ifNil: [
		  methodName := RBMethodName
			                selector: self codePresenter selectedNode selector
			                arguments: self codePresenter selectedNode argumentPartStrings ]
]

{ #category : 'executing' }
StRemoveMessageArgumentCommand >> prepareDriver [

	| dialog argumentName |
	dialog := SycMethodArgumentsRemoverPresenter openOn: self methodName.
	dialog cancelled ifTrue: [ CmdCommandAborted signal ].

	argumentName := self computeArgumentName.

	(self codePresenter selectedNode argumentPartStrings includes: argumentName) ifFalse: [
			self informArgumentError.
			CmdCommandAborted signal ].
		
	^ (RBRemoveParameterRefactoring
		   model: (RBNamespace onEnvironment: context allScopes first)
		   removeParameter: argumentName
		   in: self codePresenter behavior
		   selector: self codePresenter selectedNode selector
		   index: (self codePresenter selectedNode argumentPartStrings indexOf: argumentName)) newSelector: self resultMessageSelector
]

{ #category : 'execution' }
StRemoveMessageArgumentCommand >> resultMessageSelector [

	^ self methodName selector
]
