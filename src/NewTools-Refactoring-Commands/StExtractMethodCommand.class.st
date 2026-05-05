"
I am a command to extract selected ast node into separate method 
"
Class {
	#name : 'StExtractMethodCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StExtractMethodCommand class >> defaultDescription [

	^ 'Extract selected ast node into separate method.'
]

{ #category : 'accessing' }
StExtractMethodCommand class >> defaultIconName [

	^ #restart
]

{ #category : 'default' }
StExtractMethodCommand class >> defaultName [

	^ '(R) Extract method (no occurrences)'
]

{ #category : 'accessing' }
StExtractMethodCommand class >> priority [

	^ 4
]

{ #category : 'executing' }
StExtractMethodCommand >> prepareDriver [

	| selectedInterval |
	selectedInterval := self codePresenter selectionInterval ifEmpty: [ self codePresenter selectedNode sourceInterval ].

	^ ReExtractMethodDriver new
		  scopes: context allScopes;
		  model: (RBNamespace onEnvironment: context allScopes first);
		  extract: (self codePresenter interactionModel method sourceCode copyFrom: selectedInterval first to: selectedInterval last)
		  from: self codePresenter interactionModel method
		  in: self codePresenter behavior
]
