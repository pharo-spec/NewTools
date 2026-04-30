"
I'm a base command for refactorings. 
My children will define commands for refactoring support in spec
"
Class {
	#name : 'StRefactoringCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'accessing' }
StRefactoringCommand >> codePresenter [

	^ context codeEditor codePresenter
]

{ #category : 'executing' }
StRefactoringCommand >> execute [

	self prepareDriver runRefactoring
]

{ #category : 'testing' }
StRefactoringCommand >> isVisible [
 
	^ self canBeExecuted
]

{ #category : 'executing' }
StRefactoringCommand >> prepareDriver [

	^ self subclassResponsibility
]
