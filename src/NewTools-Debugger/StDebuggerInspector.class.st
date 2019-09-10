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
		on: self model inspectedObject.
	contextInspector table selectPath: #(1).
	contextInspector table whenSelectionChangedDo: [ 
		inspector model inspectedObject: (contextInspector table selectedItem
				ifNotNil: [ :node | node rawValue ]).
			self flag: 'TODO replace initialize with refresh (when it works...'.
			inspector initialize ]
]

{ #category : #initialization }
StDebuggerInspector >> initializeInspector [

	inspector := self 
		instantiate: StInspector 
		on: (StInspectorModel on: contextInspector table selectedItem hostObject)
]

{ #category : #initialization }
StDebuggerInspector >> initializeWidgets [

	contextLabel := self newLabel.
	self initializeContextInspector.
	self initializeInspector
]

{ #category : #accessing }
StDebuggerInspector >> inspectedObject [

	^ self model inspectedObject
]

{ #category : #accessing }
StDebuggerInspector >> label: aString [

	contextLabel label: aString
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
