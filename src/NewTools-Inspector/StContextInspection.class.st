Class {
	#name : #StContextInspection,
	#superclass : #StRawInspection,
	#instVars : [
		'forDebugger'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #building }
StContextInspection >> addValuesColumn [
	self forDebugger
		ifTrue: [ ^ self ].
	super addValuesColumn
]

{ #category : #accessing }
StContextInspection >> beForDebugger [
	forDebugger := true
]

{ #category : #accessing }
StContextInspection >> forDebugger [
	^ forDebugger ifNil: [ forDebugger := false ]
]

{ #category : #initialization }
StContextInspection >> initialize [ 

	super initialize.
	self title: 'Context'
]

{ #category : #initialization }
StContextInspection >> initializeWidgets [
	
	super initializeWidgets.
			
	attributeTable 
		roots: self model contextInspectorNodes;
		children: [ :node | node children ]
]

{ #category : #accessing }
StContextInspection >> table [
	^ attributeTable
]

{ #category : #building }
StContextInspection >> variablesColumn [
	self forDebugger
		ifFalse: [ ^ super variablesColumn ].
	^ CompositeTableColumn new
		addColumn:
			(ImageTableColumn new
				width: 20;
				evaluated: #icon;
				yourself);
		addColumn:
			(StringTableColumn new
				evaluated: #label;
				yourself);
		yourself
]
