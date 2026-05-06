"
Extract selected interval into a temporary variable from a code presenter 
"
Class {
	#name : 'StExtractTempCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StExtractTempCommand class >> defaultDescription [

	^ 'Extract the selected code into a new temporary variable'
]

{ #category : 'accessing' }
StExtractTempCommand class >> defaultIconName [

	^ #smallUpdate
]

{ #category : 'default' }
StExtractTempCommand class >> defaultName [

	^ '(R) Extract temp'
]

{ #category : 'accessing' }
StExtractTempCommand class >> priority [

	^ 5
]

{ #category : 'executing' }
StExtractTempCommand >> prepareDriver [

	^ (ReExtractTempDriver newApplication: self application)
		  extract: self codePresenter selectedNode sourceInterval
		  from: self codePresenter interactionModel method selector
		  in: self codePresenter behavior;
		  scopes: context allScopes
]
