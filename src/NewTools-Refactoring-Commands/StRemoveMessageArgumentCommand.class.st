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

{ #category : 'execution' }
StRemoveMessageArgumentCommand >> execute [

	self prepareDriver runRefactoring
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

{ #category : 'execution' }
StRemoveMessageArgumentCommand >> prepareDriver [

	^ (ReRemoveParameterDriver newApplication: self application)
		  scopes: context allScopes
		  model: (RBNamespace onEnvironment: context allScopes first)
		  removeParameterFromMethodSignature: self codePresenter selectedNode
		  in: self codePresenter behavior
]

{ #category : 'execution' }
StRemoveMessageArgumentCommand >> resultMessageSelector [

	^ self methodName selector
]
