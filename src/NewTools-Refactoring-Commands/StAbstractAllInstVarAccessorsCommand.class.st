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

{ #category : 'testing' }
StAbstractAllInstVarAccessorsCommand class >> isAbstractCommand [

	^ false
]

{ #category : 'executing' }
StAbstractAllInstVarAccessorsCommand >> execute [

	self prepareDriver do: [ :eachRefactoring | eachRefactoring execute ]
]

{ #category : 'executing' }
StAbstractAllInstVarAccessorsCommand >> prepareDriver [

	| vars dialog selectedVariables targetClass |
	targetClass := self codePresenter selectedNode variable value.
	vars := targetClass slots asOrderedCollection.

	dialog := (StVariablesSelectionPresenter newApplication: self application)
		          title: 'Select variables'
		          label: self codePresenter selectedNode name , ' - Select all variables to convert abstract'
		          withItems: vars
		          selecting: vars
		          acceptBlock: [ :variables | selectedVariables := variables ].

	dialog openModal.
	^ selectedVariables collect: [ :var | var createRefactoring: ReAbstractInstanceVariableRefactoring for: targetClass ]
]
