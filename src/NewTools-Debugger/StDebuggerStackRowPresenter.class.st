"
A row for debugger stacks
"
Class {
	#name : 'StDebuggerStackRowPresenter',
	#superclass : 'SpEasyAbstractRowPresenter',
	#instVars : [
		'labelPresenter'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'initialization' }
StDebuggerStackRowPresenter >> colorStyleForContext [
		
	self isInSelectedContextClass ifTrue: [ ^ 'stDebuggerStackContextInSelectedClass' ].
	self isInSelectedContextPackage ifTrue: [ ^ 'stDebuggerStackContextInSelectedPackage' ].

	^ nil
]

{ #category : 'layout' }
StDebuggerStackRowPresenter >> defaultLayout [ 

	^ SpBoxLayout newLeftToRight 
		"in fact, we are not using icons for the moment"
		"spacing: 3;
		add: iconPresenter expand: false;"
		add: labelPresenter;
		yourself
]

{ #category : 'initialization' }
StDebuggerStackRowPresenter >> initializePresenters [ 

	"iconPresenter := self newImage."
	labelPresenter := self newLabel
]

{ #category : 'testing' }
StDebuggerStackRowPresenter >> isInSelectedContextClass [
	"Return true if the given context is in the same class than the currently 
	 selected context of the stack."
	| selectedContext |
	
	selectedContext := self listView selectedItem.
	^ selectedContext isNotNil 
		and: [ selectedContext methodClass = self model methodClass ]
]

{ #category : 'testing' }
StDebuggerStackRowPresenter >> isInSelectedContextPackage [
	"Return true if the given context is in the same package than 
	 the currently selected context of the stack."
	| selectedContext |
	
	selectedContext := listView selectedItem.
	^ selectedContext isNotNil 
		and: [ selectedContext method package = self model method package ]
]

{ #category : 'initialization' }
StDebuggerStackRowPresenter >> updatePresenter [ 

	self model ifNil: [ ^ self ].
	
	"iconPresenter image: self iconForContext."
	labelPresenter label: (StContextPrinter printContext: self model).
	labelPresenter removeAllStyles.
	self colorStyleForContext
		ifNotNil: [ :aStyle | labelPresenter addStyle: aStyle ]
]
