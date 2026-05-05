"
I am a command to rename temp variable in given method.
 

"
Class {
	#name : 'StRenameArgOrTempCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StRenameArgOrTempCommand class >> defaultDescription [

	^ 'Rename the selected temporary variable or arg'
]

{ #category : 'accessing' }
StRenameArgOrTempCommand class >> defaultIconName [

	^ #edit
]

{ #category : 'default' }
StRenameArgOrTempCommand class >> defaultName [

	^ '(R) Rename temp'
]

{ #category : 'accessing' }
StRenameArgOrTempCommand class >> priority [

	^ 3
]

{ #category : 'testing' }
StRenameArgOrTempCommand >> canBeExecuted [

	^ self codePresenter selectedNode isTempVariable or: [ self codePresenter selectedNode isArgumentVariable ]
]

{ #category : 'executing' }
StRenameArgOrTempCommand >> prepareDriver [

	^ ReRenameArgumentOrTemporaryDriver new
		  sourceNode: self codePresenter selectedNode;
		  method: self codePresenter interactionModel method;
		  scopes: context allScopes;
		  yourself
]
