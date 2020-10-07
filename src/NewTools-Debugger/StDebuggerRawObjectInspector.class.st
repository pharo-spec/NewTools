"
An object inspector specialized for debuggers.
I show only a compacted raw view instead of a notebook page, in particular I remove tabs and provide an optional layout without a header.
Activating one of my items (by clicking or double-clicking on it) shows a miller list with a standard object inspector.
"
Class {
	#name : #StDebuggerRawObjectInspector,
	#superclass : #StObjectInspector,
	#instVars : [
		'raw',
		'filterAllRadio',
		'filterSelfRadio',
		'filterTempsRadio',
		'filterArgsRadio',
		'filterContextRadio',
		'sortLabel'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerRawObjectInspector class >> defaultSpec [

	<spec: #default>
	^ SpBoxLayout newVertical
		  add: #header
		  withConstraints: [ :constraints | constraints height: 22 ];
		  add: #raw;
		  yourself
]

{ #category : #specs }
StDebuggerRawObjectInspector class >> noHeaderSpec [
	<spec: #default>
	^ SpBoxLayout newVertical
		add: #raw;
		yourself
]

{ #category : #initialization }
StDebuggerRawObjectInspector >> initializePresenters [
	super initializePresenters.
	raw := self model inspectionRaw.
	raw beForDebugger.
	raw owner: self.
	self addActivationTo: raw
]

{ #category : #initialization }
StDebuggerRawObjectInspector >> rawInspectorPageOrNil [
	^raw
]

{ #category : #initialization }
StDebuggerRawObjectInspector >> sortInspectorTable: variableTag [
	|roots newRoots|
	roots := self rawInspectorPageOrNil attributeTable roots.
	newRoots := OrderedCollection new.
	newRoots addAll: (roots select: [:node| node variableTag = variableTag]).
	newRoots addAll: (roots reject: [:node| node variableTag = variableTag]).
	self rawInspectorPageOrNil attributeTable roots: newRoots
]

{ #category : #stepping }
StDebuggerRawObjectInspector >> step [
	super step.
	raw step
]
