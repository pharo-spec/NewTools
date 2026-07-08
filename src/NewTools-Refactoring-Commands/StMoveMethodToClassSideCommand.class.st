"
I am a command to move method to the class side of defining class
"
Class {
	#name : 'StMoveMethodToClassSideCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StMoveMethodToClassSideCommand class >> defaultDescription [

	^ 'Move method to the class side.'
]

{ #category : 'accessing' }
StMoveMethodToClassSideCommand class >> defaultIconName [
	^ #smallRedo
]

{ #category : 'default' }
StMoveMethodToClassSideCommand class >> defaultName [

	^ '(R) Move to class side'
]

{ #category : 'accessing' }
StMoveMethodToClassSideCommand class >> priority [

	^ 9
]

{ #category : 'testing' }
StMoveMethodToClassSideCommand >> canBeExecuted [

	| node |
	node := self codePresenter selectedNode.

	^ node isMethod | node isMessage and: [ node methodNode methodClass isInstanceSide ]
]

{ #category : 'executing' }
StMoveMethodToClassSideCommand >> prepareDriver [

	^ ReMoveMethodsToClassSideDriver scopes: context allScopes methods: { self codePresenter selectedMethod }
]
