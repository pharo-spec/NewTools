Class {
	#name : #StDebuggerRawInspection,
	#superclass : #StRawInspection,
	#instVars : [
		'forDebugger'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #building }
StDebuggerRawInspection >> addValuesColumn [
	
]

{ #category : #accessing }
StDebuggerRawInspection >> inspectorNodes [
	^ self model debuggerInspectorNodes
]

{ #category : #accessing }
StDebuggerRawInspection >> table [
	^ attributeTable
]

{ #category : #building }
StDebuggerRawInspection >> variablesColumn [
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
