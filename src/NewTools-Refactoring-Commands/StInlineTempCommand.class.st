"
I am a command to inline selected temp variable (represented by source node)
"
Class {
	#name : 'StInlineTempCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'accessing' }
StInlineTempCommand class >> defaultIconName [

	^ #smallRightFlush
]

{ #category : 'default' }
StInlineTempCommand class >> defaultName [
	^'Inline temp'
]

{ #category : 'testing' }
StInlineTempCommand >> canBeExecuted [

	^ self codePresenter selectedNode isTempVariable
]

{ #category : 'executing' }
StInlineTempCommand >> prepareDriver [

	| assignment |
	assignment := self codePresenter selectedNode methodNode assignmentNodes detect: [ :each |
		              each variable = self codePresenter selectedNode ].

	^ (ReInlineTemporaryDriver newApplication: self application)
		  scopes: context allScopes
		  interval: assignment sourceInterval
		  selector: self codePresenter selectedMethod selector
		  class: self codePresenter behavior
]
