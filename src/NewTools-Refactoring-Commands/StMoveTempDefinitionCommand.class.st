"
I am a command to move the definition of given temporary variable closed to its user in given method.
 

"
Class {
	#name : 'StMoveTempDefinitionCommand',
	#superclass : 'StRefactoringCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StMoveTempDefinitionCommand class >> defaultDescription [

	^ 'Moves the definition of the temporary variable closed to its user.'
]

{ #category : 'accessing' }
StMoveTempDefinitionCommand class >> defaultIconName [

	^ #edit
]

{ #category : 'default' }
StMoveTempDefinitionCommand class >> defaultName [

	^'(R) Move temp definition'
]

{ #category : 'testing' }
StMoveTempDefinitionCommand >> canBeExecuted [

	^ self codePresenter selectedNode isTempVariable or: [ self codePresenter selectedNode isArgumentVariable ]
]

{ #category : 'executing' }
StMoveTempDefinitionCommand >> prepareDriver [

	^ ReMoveTemporaryDefinitionDriver new
		  sourceNode: self codePresenter selectedNode;
		  method: self codePresenter selectedMethod;
		  scopes: context allScopes;
		  yourself
]
