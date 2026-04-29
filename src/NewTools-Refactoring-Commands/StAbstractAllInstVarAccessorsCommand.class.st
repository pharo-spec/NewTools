"
I command to launch the Abstract refactorings: create accessors and abstract the direct instance variable uses into accessors. 
"
Class {
	#name : 'StAbstractAllInstVarAccessorsCommand',
	#superclass : 'StRefactoringClassCommand',
	#category : 'NewTools-Refactoring-Commands',
	#package : 'NewTools-Refactoring-Commands'
}

{ #category : 'accessing' }
StAbstractAllInstVarAccessorsCommand class >> defaultIconName [

	^ #smallAdd
]

{ #category : 'default' }
StAbstractAllInstVarAccessorsCommand class >> defaultName [

	^ 'Abstract instance variables'
]

{ #category : 'executing' }
StAbstractAllInstVarAccessorsCommand >> execute [

	self prepareDriver execute
]

{ #category : 'executing' }
StAbstractAllInstVarAccessorsCommand >> prepareDriver [

	| vars dialog refactoring |
	vars := self codePresenter selectedNode variable value slots asOrderedCollection.
	dialog := (StVariablesSelectionPresenter newApplication: self application)
		          label: self codePresenter selectedNode name , ' - Select all variables to convert abstract'
		          withItems: vars
		          selecting: vars.
	self codePresenter selectedNode -> dialog selectedItems.


	vars collect: [ :var |
		refactoring := var createRefactoring: ReAbstractInstanceVariableRefactoring for: self codePresenter selectedNode variable key ].
	^ refactoring
]
