Class {
	#name : #StDebuggerRawInspection,
	#superclass : #StRawInspection,
	#instVars : [
		'forDebugger'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerRawInspection class >> title [
	^'Raw (debugger)'
]

{ #category : #building }
StDebuggerRawInspection >> addValuesColumn [
	
]

{ #category : #initialization }
StDebuggerRawInspection >> defineOutputPorts [

	^ { SpListSelectionPort newDelegate: [ self table ] }
]

{ #category : #initialization }
StDebuggerRawInspection >> initializePresenters [

	super initializePresenters.
	attributeTable hideColumnHeaders
]

{ #category : #accessing }
StDebuggerRawInspection >> inspectorNodes [

	^ self model debuggerInspectorNodes
]

{ #category : #initialization }
StDebuggerRawInspection >> model: aModel [

	super model: aModel.
	self setAttributeTable
]

{ #category : #accessing }
StDebuggerRawInspection >> selectFirst [

	self table selectPath: #(1)
]

{ #category : #accessing }
StDebuggerRawInspection >> selectPath: aPath [

	self table selectPath: aPath
]

{ #category : #accessing }
StDebuggerRawInspection >> selectedItem [

	^ self table selectedItem
]

{ #category : #accessing }
StDebuggerRawInspection >> selectedPath [

	^ self table selection selectedPath
]

{ #category : #accessing }
StDebuggerRawInspection >> table [
	^ attributeTable
]

{ #category : #building }
StDebuggerRawInspection >> variablesColumn [

	^ SpCompositeTableColumn new
		title: 'Variable';
		addColumn: (SpImageTableColumn new
			width: 20;
			evaluated: #icon;
			yourself);
		addColumn: (SpStringTableColumn new
			evaluated: #label;
			yourself);
		yourself
]
