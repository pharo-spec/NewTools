Class {
	#name : #StDebuggerInspectorTest,
	#superclass : #TestCase,
	#instVars : [
		'inspector',
		'session',
		'debugger'
	],
	#category : #'NewTools-Debugger-Tests-Presenters'
}

{ #category : #running }
StDebuggerInspectorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	inspector := StDebuggerInspector new
]

{ #category : #running }
StDebuggerInspectorTest >> tearDown [

	session ifNotNil: [ session clear ].
	StDebuggerInspector maximizeAssertionSpec: nil.
	debugger ifNotNil: [
		debugger close.
		debugger unsubscribeFromSystemAnnouncer.
		debugger debuggerActionModel ifNotNil: [ :actionModel |
			actionModel clear.
			actionModel session ifNotNil: [ :s | s clear ] ] ].
	super tearDown
]

{ #category : #tests }
StDebuggerInspectorTest >> testDefaultLayoutSpec [
	
	self assert: inspector currentLayoutSelector equals: inspector defaultLayoutSelector
]

{ #category : #tests }
StDebuggerInspectorTest >> testMaximizeAssertionSpec [
	self deny: StDebuggerInspector maximizeAssertionSpec
]

{ #category : #tests }
StDebuggerInspectorTest >> testMaximizedAssertionLayoutSpec [
	|inspectorLayout|
	
	inspector class maximizeAssertionSpec: true.
	inspector setAssertionLayout. 
	inspectorLayout := inspector layout.
	self assert: inspectorLayout children size equals: 1.
	self assert: inspectorLayout children first class identicalTo: SpBoxLayout 
]

{ #category : #tests }
StDebuggerInspectorTest >> testMinimizedAssertionLayoutSpec [
	|inspectorLayout|
	
	inspector class maximizeAssertionSpec: false.
	inspector setAssertionLayout. 
	inspectorLayout := inspector layout.
	self assert: inspectorLayout children size equals: 2.
	self assert: inspectorLayout children first class identicalTo: SpBoxLayout.
	self assert: inspectorLayout children second equals: #inspector
]

{ #category : #tests }
StDebuggerInspectorTest >> testSetAssertionLayoutSpec [
	|inspectorLayout expectedLayout|
	inspector setAssertionLayout. 
	inspectorLayout := inspector layout.
	expectedLayout := inspector assertionFailureLayout.
	self assert: inspector currentLayoutSelector equals: inspector assertionLayoutSelector.					
	self assertCollection: inspectorLayout children size equals: expectedLayout children size. 
	self assert: inspectorLayout children first class identicalTo:  expectedLayout children first class.
	self assert: inspectorLayout children first direction equals: expectedLayout children first direction.
	self assert: inspectorLayout children second equals:  expectedLayout children second.
	self assert: inspectorLayout direction equals: expectedLayout direction.
	self assert: inspectorLayout class identicalTo: expectedLayout class
]

{ #category : #tests }
StDebuggerInspectorTest >> testSetDefaultLayoutSpec [

	| inspectorLayout expectedLayout |
	inspector setDefaultLayout.
	inspectorLayout := inspector layout.
	expectedLayout := inspector defaultLayout.
	self
		assert: inspector currentLayoutSelector
		equals: inspector defaultLayoutSelector.
	self
		assertCollection: inspectorLayout children
		equals: expectedLayout children.
	self
		assert: inspectorLayout direction
		equals: expectedLayout direction.
	self assert: inspectorLayout class identicalTo: expectedLayout class
]

{ #category : #tests }
StDebuggerInspectorTest >> testShouldUpdateContext [

	| debugger |
	debugger := StTestDebuggerProvider new
		            debuggerWithFailingAssertionContext.
	session := debugger session.
	self assert: (inspector
			 shouldUpdateContext: session interruptedContext sender
			 with: session interruptedContext).
	self deny: (inspector
			 shouldUpdateContext: session interruptedContext
			 with: session interruptedContext)
]

{ #category : #tests }
StDebuggerInspectorTest >> testToggleMaximizeAssertionSpec [

	|oldFlag|
	oldFlag := StDebuggerInspector maximizeAssertionSpec.
	StDebuggerInspector toggleMaximizeAssertionSpec.
	self assert: StDebuggerInspector maximizeAssertionSpec equals: oldFlag not
]

{ #category : #tests }
StDebuggerInspectorTest >> testUpdateLayoutForContextsWithAssertionFailure [

	| assertionFailure |
	debugger := StTestDebuggerProvider new
		            debuggerWithFailingAssertionContext.
	session := debugger session.
	
	inspector
		updateLayoutForContexts: session interruptedContext
		isAssertionFailure: true.
	assertionFailure := inspector assertionFailure.
	self
		assert: inspector currentLayoutSelector
		equals: inspector assertionLayoutSelector.
	self
		assert: assertionFailure actualObject
		equals:
		((session interruptedContext tempNamed: #aStringOrBlock) at: 2).
	self
		assert: assertionFailure expectedObject
		equals:
		((session interruptedContext tempNamed: #aStringOrBlock) at: 1)
]

{ #category : #tests }
StDebuggerInspectorTest >> testUpdateLayoutForContextsWithShouldntRaiseFailure [
	| debugger assertionFailure |
	debugger := StTestDebuggerProvider new debuggerWithFailingShouldntRaiseContext.
	session := debugger session.
	inspector
		updateLayoutForContexts: session interruptedContext
		isAssertionFailure: true.
	assertionFailure := inspector assertionFailure.
	self
		deny: inspector currentLayoutSelector
		equals: inspector assertionLayoutSelector.
	
]

{ #category : #tests }
StDebuggerInspectorTest >> testUpdateLayoutForContextsWithoutAssertionFailure [

	debugger := StTestDebuggerProvider new
		debuggerWithFailingAssertionContext.
	session := debugger session.
	inspector
		updateLayoutForContexts: session interruptedContext
		isAssertionFailure: false.
	self
		assert: inspector currentLayoutSelector
		equals: inspector defaultLayoutSelector.
	self assert: inspector assertionFailure equals: nil
]
