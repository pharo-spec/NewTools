Class {
	#name : #StDebuggerInspector,
	#superclass : #SpPresenter,
	#instVars : [
		'contextLabel',
		'contextInspector',
		'inspector',
		'model'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerInspector class >> defaultSpec [
	<spec: #default>

	^ SpBoxLayout newVertical 
		add: #contextLabel expand: false fill: false padding: 5;
		add: (SpPanedLayout newHorizontal
			position: 40 percent;
			add: #contextInspector;
			add: #inspector;
			yourself);
		yourself
]

{ #category : #specs }
StDebuggerInspector class >> inspectorAlone [
	"do not show variables list (not needed, since there will always be one)"

	^ SpBoxLayout newVertical
		add: #contextLabel expand: false fill: false padding: 5;
		add: #inspector;
		yourself
]

{ #category : #'instance creation' }
StDebuggerInspector class >> openOn: anObject [

	^ (self on: (StDebuggerInspectorModel on: anObject)) openWithSpec
]

{ #category : #specs }
StDebuggerInspector class >> title [
	 ^'Debugger Inspection'
]

{ #category : #specs }
StDebuggerInspector class >> variablesListOnTop [
	"show variables list on top"

	^ SpBoxLayout newVertical 
		add: #contextLabel expand: false fill: false padding: 5;
		add: (SpPanedLayout newVertical
			position: 25 percent;
			add: #contextInspector;
			add: #inspector;
			yourself);
		yourself
]

{ #category : #initialization }
StDebuggerInspector >> initializeContextInspector [

	contextInspector := self 
		instantiate: StRawInspection 
		on: self model.
	contextInspector selectFirst
]

{ #category : #initialization }
StDebuggerInspector >> initializeInspector [

	inspector := self 
		instantiate: StInspector 
		on: (StDebuggerInspectorModel on: contextInspector selectedItem hostObject)
]

{ #category : #initialization }
StDebuggerInspector >> initializePresenters [

	contextLabel := self newLabel.
	self initializeContextInspector.
	self initializeInspector.
	
	contextInspector
		transmitTo: inspector 
		transform: [ :item |
			StDebuggerInspectorModel on: (item ifNotNil: #rawValue) ]
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [

	^ self model inspectedObject
]

{ #category : #accessing }
StDebuggerInspector >> label: aString [

	contextLabel label: aString
]

{ #category : #'accessing model' }
StDebuggerInspector >> model [

	^ model
]

{ #category : #'accessing model' }
StDebuggerInspector >> model: aModel [

	model := aModel asDebuggerInspectorModel.
	contextInspector model: model.
	inspector model: model
]

{ #category : #'accessing model' }
StDebuggerInspector >> setModelBeforeInitialization: aModel [

	model := aModel asDebuggerInspectorModel
]

{ #category : #updating }
StDebuggerInspector >> updateWith: inspectedObject [
	| oldPath oldItem |

	self flag: 'Suspicious test: should not be == ?'.
	self model inspectedObject = inspectedObject ifTrue: [ ^ self ].

	oldPath := contextInspector selectedPath.
	oldItem := contextInspector selectedItem hostObject.

	self model: (StDebuggerInspectorModel on: inspectedObject).
	
	inspectedObject == oldItem 
		ifTrue: [ contextInspector selectPath: oldPath ]
		ifFalse: [ contextInspector selectFirst ]
]
