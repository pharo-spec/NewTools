"
I am a base class for command which perform particular kind refactoring on given variable.
"
Class {
	#name : 'StRefactoringVariableCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'testing' }
StRefactoringVariableCommand >> canBeExecuted [

	^ self codePresenter selectedNode isInstanceVariable and: [ self codePresenter selectedNode isGlobalVariable not ]
]

{ #category : 'executing' }
StRefactoringVariableCommand >> prepareDriver [

	^ self subclassResponsibility 
]
