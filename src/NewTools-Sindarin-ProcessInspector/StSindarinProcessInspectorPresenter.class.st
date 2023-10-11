"
Simple process inspector as a demo extension to show how extension work.
"
Class {
	#name : 'StSindarinProcessInspectorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'attributesTable',
		'sindarinDebugger',
		'processData'
	],
	#category : 'NewTools-Sindarin-ProcessInspector',
	#package : 'NewTools-Sindarin-ProcessInspector'
}

{ #category : 'specs' }
StSindarinProcessInspectorPresenter class >> debuggingExtensionToolName [
	<debuggerExtensionOrder: 1 showByDefault: false>
	^ 'Process'
]

{ #category : 'specs' }
StSindarinProcessInspectorPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #attributesTable;
		yourself
]

{ #category : 'initialization' }
StSindarinProcessInspectorPresenter >> initializePresenters [
	super initializePresenters.
	attributesTable := self newTable.
	attributesTable
		addColumn:
			((SpStringTableColumn evaluated: [ :item | item ]) width: 80) ;
		addColumn:
			(SpStringTableColumn
				evaluated: [ :item | (processData at: item) asString ]) yourself.
	attributesTable
		items:
			{'name' . 'priority' . 'active' . 'suspended' . 'terminating'.
			'terminated'}
]

{ #category : 'accessing model' }
StSindarinProcessInspectorPresenter >> setModelBeforeInitialization: aStDebugger [
	"My original model is the debugger presenter that I extend"	
	sindarinDebugger := aStDebugger sindarinDebugger
]

{ #category : 'accessing model' }
StSindarinProcessInspectorPresenter >> updatePresenter [
	self updateProcessData
]

{ #category : 'accessing model' }
StSindarinProcessInspectorPresenter >> updateProcessData [
	|process|
	processData := Dictionary new.
	process := sindarinDebugger currentProcess.
	processData at: 'name' put: process name.
	processData at: 'priority' put: process priority.
	processData at: 'active' put: process isActiveProcess.
	processData at: 'suspended' put: process isSuspended.
	processData at: 'terminating' put: process isTerminated.
	processData at: 'terminated' put: process isTerminating.
	
]
