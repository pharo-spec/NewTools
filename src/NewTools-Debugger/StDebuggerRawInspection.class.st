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

	^ SpCompositeTableColumn new
		addColumn: (SpImageTableColumn new
			width: 20;
			evaluated: #icon;
			yourself);
		addColumn: (SpStringTableColumn new
			evaluated: #label;
			yourself);
		yourself
]
