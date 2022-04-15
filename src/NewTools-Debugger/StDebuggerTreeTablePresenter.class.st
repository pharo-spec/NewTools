Class {
	#name : #StDebuggerTreeTablePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'items',
		'filter',
		'isFiltered'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #api }
StDebuggerTreeTablePresenter >> applyFilter [

	filter ifNil: [ ^items ].
	isFiltered ifFalse:  [ filter := nil. ^items ].

	^items select: [:item| item variableTag = filter]
]

{ #category : #accessing }
StDebuggerTreeTablePresenter >> filter [
	^ filter
]

{ #category : #api }
StDebuggerTreeTablePresenter >> hasActiveFilter [
	^isFiltered 
]

{ #category : #initialization }
StDebuggerTreeTablePresenter >> initialize [
	super initialize.
	isFiltered := false
]

{ #category : #api }
StDebuggerTreeTablePresenter >> roots: aCollection [

	items := aCollection.
	super roots: self applyFilter

]

{ #category : #api }
StDebuggerTreeTablePresenter >> toggleFilter: aVariableTag [

"	filter := filter = aVariableTag
		          ifTrue: [ nil ]
		          ifFalse: [ aVariableTag ]."
	filter := aVariableTag.
	isFiltered := isFiltered not.

	self roots: items
]
