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
		'filterContextRadio'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #specs }
StDebuggerRawObjectInspector class >> defaultSpec [

	<spec: #default>
	^ SpBoxLayout newVertical
		add: #header withConstraints: [ :constraints |  constraints height: 22 ];
		add: (SpBoxLayout newHorizontal
				   add: #filterAllRadio withConstraints: [ :constraints | constraints width: 40 ];
				   add: #filterSelfRadio withConstraints: [ :constraints | constraints width: 40 ];
				   add: #filterTempsRadio withConstraints: [ :constraints | constraints width: 45 ];
				   add: #filterArgsRadio withConstraints: [ :constraints | constraints width: 25 ];
				   add: #filterContextRadio withConstraints: [ :constraints | constraints width: 60 ];
				   yourself) withConstraints: [ :constraints |  constraints height: self toolbarHeight ];
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
StDebuggerRawObjectInspector >> initializeFiltersRadioButtons [
	filterAllRadio := self newRadioButton.
	filterSelfRadio := self newRadioButton.
	filterTempsRadio := self newRadioButton.
	filterArgsRadio := self newRadioButton.
	filterContextRadio := self newRadioButton.
	
	filterAllRadio label: 'All'.
	filterSelfRadio label: 'self'.
	filterTempsRadio label: 'temps'.
	filterArgsRadio label: 'args'.
	filterContextRadio label: 'thisContext'.
		
	filterAllRadio associatedRadioButtons: 
		{filterSelfRadio. filterTempsRadio. filterArgsRadio. filterContextRadio}.
	filterAllRadio state: true
	
]

{ #category : #initialization }
StDebuggerRawObjectInspector >> initializePresenters [
	super initializePresenters.
	raw := self model rawInspection.
	raw beForDebugger.
	raw owner: self.
	self addActivationTo: raw.
	self initializeFiltersRadioButtons
]

{ #category : #initialization }
StDebuggerRawObjectInspector >> rawInspectorPageOrNil [
	^raw
]

{ #category : #stepping }
StDebuggerRawObjectInspector >> step [
	super step.
	raw step
]
