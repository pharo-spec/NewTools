Class {
	#name : #StDebuggerInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'inspector',
		'model',
		'label',
		'rawInspectionSelectionCache'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerInspector class >> defaultSpec [
	^ SpBoxLayout newVertical
		  add: #inspector;
		  yourself
]

{ #category : #'instance creation' }
StDebuggerInspector class >> openOn: anObject [

	^ (self on: (StInspectorModel on: anObject)) openWithSpec
]

{ #category : #specs }
StDebuggerInspector class >> title [
	 ^'Debugger Inspection'
]

{ #category : #updating }
StDebuggerInspector >> forceRawInspectionUpdate [
	self getRawInspectorPresenterOrNil ifNotNil: [ :inspection | 
		inspection update ]
]

{ #category : #private }
StDebuggerInspector >> getRawInspectorPresenterOrNil [
	^ inspector millerList pages first rawInspectorPageOrNil
		  activePresenter
]

{ #category : #private }
StDebuggerInspector >> getRawInspectorSelectedPath [
	^ self getRawInspectorPresenterOrNil
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :raw | raw selectedPath ]
]

{ #category : #initialization }
StDebuggerInspector >> initializePresenters [
	label := self newLabel.
	inspector := self instantiate: StInspector on: self model
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [

	^ self model inspectedObject
]

{ #category : #accessing }
StDebuggerInspector >> label: aString [

	label label: aString
]

{ #category : #'accessing model' }
StDebuggerInspector >> model [

	^ model
]

{ #category : #'accessing model' }
StDebuggerInspector >> model: aModel [

	model := aModel.
	inspector model: model
]

{ #category : #accessing }
StDebuggerInspector >> rawInspectionSelectionCache [
	^ rawInspectionSelectionCache ifNil: [ 
		  rawInspectionSelectionCache := Dictionary new ]
]

{ #category : #private }
StDebuggerInspector >> restoreRawInspectionSelectionForContext: aContext [
	aContext ifNil: [ ^ self ].
	self getRawInspectorPresenterOrNil ifNotNil: [ :raw | 
		raw selectPath: (self rawInspectionSelectionCache
				 at: aContext receiver class -> aContext selector
				 ifAbsent: [ #() ]) ]
]

{ #category : #private }
StDebuggerInspector >> saveRawInspectionSelectionForContext: aContext [
	aContext ifNil: [ ^ self ].
	self rawInspectionSelectionCache
		at: aContext receiver class -> aContext selector
		put: self getRawInspectorSelectedPath
]

{ #category : #'accessing model' }
StDebuggerInspector >> setModelBeforeInitialization: aModel [

	model := aModel
]

{ #category : #updating }
StDebuggerInspector >> updateEvaluationPaneReceiver [

	|receiver evaluator|
	receiver := self model inspectedObject context receiver.
	evaluator := inspector millerList presenters first evaluator.
	evaluator doItReceiver: receiver.
	evaluator behavior: receiver class.
]

{ #category : #updating }
StDebuggerInspector >> updateWith: inspectedObject [
	| oldContext newContext |
	oldContext := self model inspectedObject ifNotNil: [ :dbgCtx | 
		              dbgCtx context ].
	newContext := inspectedObject ifNotNil: [ :dbgCtx | dbgCtx context ].
	(oldContext notNil and: [ newContext notNil ]) ifTrue: [ 
		(oldContext receiver == newContext receiver and: [ 
			 oldContext selector == newContext selector ]) ifTrue: [ 
			self forceRawInspectionUpdate.
			^ self ] ].
	self saveRawInspectionSelectionForContext: oldContext.
	self model: (StDebuggerInspectorModel on: inspectedObject).
	self updateEvaluationPaneReceiver.
	self restoreRawInspectionSelectionForContext: newContext
]
