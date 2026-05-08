"
I am a command to generate accessors for given variables
"
Class {
	#name : 'StGenerateVariableAccessorCommand',
	#superclass : 'StRefactoringVariableCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'default' }
StGenerateVariableAccessorCommand class >> defaultDescription [

	^ 'Generate accessor for the selected instance variable'
]

{ #category : 'default' }
StGenerateVariableAccessorCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : 'default' }
StGenerateVariableAccessorCommand class >> defaultName [

	^ '(T) Generate accessor'
]

{ #category : 'accessing' }
StGenerateVariableAccessorCommand class >> priority [

	^ 8
]

{ #category : 'executing' }
StGenerateVariableAccessorCommand >> prepareDriver [

	^ (ReGenerateAccessorsDriver newApplication: self application)
		  targetClass: self codePresenter behavior;
		  scopes: context allScopes
		  scopeInstanceSide: self codePresenter behavior isInstanceSide
		  selectedVariables: { self codePresenter selectedNode name }
]
