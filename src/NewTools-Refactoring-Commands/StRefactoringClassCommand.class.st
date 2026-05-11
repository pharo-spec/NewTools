"
I am a base class for command which perform particular kind refactoring on given class.
"
Class {
	#name : 'StRefactoringClassCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'testing' }
StRefactoringClassCommand class >> isAbstract [

	^ self = StRefactoringClassCommand
]

{ #category : 'testing' }
StRefactoringClassCommand >> canBeExecuted [

	| node |
	node := self codePresenter selectedNode.
	^ node isGlobalVariable and: [ node binding value isClass ]
]
