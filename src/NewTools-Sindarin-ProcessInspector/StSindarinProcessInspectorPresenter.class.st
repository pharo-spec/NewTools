Class {
	#name : #StSindarinProcessInspectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'attributesTable',
		'sindarinDebugger'
	],
	#category : #'NewTools-Sindarin-ProcessInspector'
}

{ #category : #specs }
StSindarinProcessInspectorPresenter class >> debuggingExtensionToolName [
	<debuggerExtensionOrder: 1 showByDefault: true>
	^ 'Process'
]

{ #category : #specs }
StSindarinProcessInspectorPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #attributesTable;
		yourself
]

{ #category : #initialization }
StSindarinProcessInspectorPresenter >> initializePresenters [
	super initializePresenters.
	attributesTable := self newTable.
	attributesTable
		addColumn:
			(SpStringTableColumn title: 'name' evaluated: [ :item | item name ])
				yourself;
		addColumn:
			(SpStringTableColumn
				title: 'priority'
				evaluated: [ :item | item priority ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'active'
				evaluated: [ :item | item isActiveProcess ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'suspended'
				evaluated: [ :item | item isSuspended ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'terminating'
				evaluated: [ :item | item isTerminated ]) yourself;
		addColumn:
			(SpStringTableColumn
				title: 'terminated'
				evaluated: [ :item | item isTerminating ]) yourself.
		attributesTable items: { sindarinDebugger currentProcess }
]

{ #category : #'accessing model' }
StSindarinProcessInspectorPresenter >> setModelBeforeInitialization: aStDebugger [
	"My original model is the debugger presenter that I extend"	
	sindarinDebugger := aStDebugger sindarinDebugger
]

{ #category : #'accessing model' }
StSindarinProcessInspectorPresenter >> updatePresenter [
	
]
