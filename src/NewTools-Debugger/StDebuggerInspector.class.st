Class {
	#name : #StDebuggerInspector,
	#superclass : #StInspection,
	#instVars : [
		'contextInspector',
		'inspector'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerInspector class >> defaultSpec [
	<spec: #default>
	^ SpPanedLayout newHorizontal
		position: 40 percent;
		add: #contextInspector;
		add: #inspector;
		yourself
]

{ #category : #'instance creation' }
StDebuggerInspector class >> openOn: anObject [
	^ (self
		newApplication: SpecNullApplication new
		model: (StInspectorModel on: anObject)) openWithSpec
]

{ #category : #initialization }
StDebuggerInspector >> initializeContextInspector [
	contextInspector := StDebuggerRawInspection basicNew.
	contextInspector application: SpecNullApplication new.
	contextInspector
		setModelBeforeInitialization: self model inspectedObject.
	contextInspector initialize.
	contextInspector table selectPath: #(1).
	contextInspector table
		whenSelectionChangedDo: [ inspector model
				inspectedObject:
					(contextInspector table selectedItem
						ifNotNil: [ :node | node rawValue ]).
			self flag: 'TODO replace initialize with refresh (when it works...'.
			inspector initialize ]
]

{ #category : #initialization }
StDebuggerInspector >> initializeInspector [
	inspector := StInspector basicNew.
	inspector application: SpecNullApplication new.
	inspector
		setModelBeforeInitialization: (StInspectorModel on: contextInspector table selectedItem hostObject).
	inspector initialize
]

{ #category : #initialization }
StDebuggerInspector >> initializeWidgets [
	self initializeContextInspector.
	self initializeInspector
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [
	^ self model inspectedObject
]

{ #category : #updating }
StDebuggerInspector >> updateWith: inspectedObject [
	| oldPath oldItem |
	oldPath := contextInspector table selection selectedPath.
	oldItem := contextInspector table selectedItem hostObject.
	self model inspectedObject: inspectedObject.
	contextInspector model: inspectedObject.
	contextInspector setAttributeTable.
	contextInspector table
		selectPath:
			(inspectedObject == oldItem
				ifTrue: [ oldPath ]
				ifFalse: [ #(1) ])
]
