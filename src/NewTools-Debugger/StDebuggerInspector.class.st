Class {
	#name : #StDebuggerInspector,
	#superclass : #StInspection,
	#instVars : [
		'contextLabel',
		'contextInspector',
		'inspector'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerInspector class >> basicSpec [

	^ SpBoxLayout newVertical 
		add: #contextLabel expand: false fill: false padding: 5;
		add: #inspector;
		yourself
]

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

	^ (self on: (StInspectorModel on: anObject)) openWithSpec
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
		instantiate: StDebuggerRawInspectionWithValue 
		on: self model.
	contextInspector selectFirst
]

{ #category : #initialization }
StDebuggerInspector >> initializeInspector [

	inspector := self 
		instantiate: StDebuggerEmbeddedInspector 
		on: (StInspectorModel on: contextInspector selectedItem hostObject)
]

{ #category : #initialization }
StDebuggerInspector >> initializePresenters [

	contextLabel := self newLabel.
	self initializeContextInspector.
	self initializeInspector.
	
	contextInspector
		transmitTo: inspector 
		transform: [ :item | 
			StInspectorModel on: (item ifNotNil: #rawValue) ]
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [

	^ self model inspectedObject
]

{ #category : #accessing }
StDebuggerInspector >> label: aString [

	contextLabel label: aString
]

{ #category : #initialization }
StDebuggerInspector >> model: aModel [

	super model: aModel.
	contextInspector model: aModel.
	inspector model: aModel
]

{ #category : #updating }
StDebuggerInspector >> updateWith: inspectedObject [
	| oldPath oldItem |

	self model inspectedObject = inspectedObject ifTrue: [ ^ self ].

	oldPath := contextInspector selectedPath.
	oldItem := contextInspector selectedItem hostObject.

	self model: (StInspectorModel on: inspectedObject).
	
	inspectedObject == oldItem 
		ifTrue: [ contextInspector selectPath: oldPath ]
		ifFalse: [ contextInspector selectFirst ]
]
