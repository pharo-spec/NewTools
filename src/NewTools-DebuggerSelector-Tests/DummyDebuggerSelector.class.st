"
I am a debugger selector with a static list of debuggers for test purposes
"
Class {
	#name : #DummyDebuggerSelector,
	#superclass : #DebuggerSelector,
	#classVars : [
		'staticDebuggers',
		'uiManager'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #'debug - API' }
DummyDebuggerSelector class >> debugException: exception inProcess: process from: aUIiManager with: aDebuggerSelectorInstance [
	"We redefine this method just for testing: we give it a dummydebugger to play the UIManager because we do not want it to defer the execution of the debugger opening. Defering the debugger opening makes the test execution to execute before the defered method exec that we want to test."

	^ super
		debugException: exception
		inProcess: process
		from: (uiManager := DummyDebugger new)
		with: aDebuggerSelectorInstance
]

{ #category : #initialization }
DummyDebuggerSelector class >> debuggers: debuggers [
	staticDebuggers := debuggers
]

{ #category : #'instance creation' }
DummyDebuggerSelector class >> newDebuggerSelector [
	^ self with: staticDebuggers
]

{ #category : #accessing }
DummyDebuggerSelector class >> uiManager [
	^uiManager
]

{ #category : #accessing }
DummyDebuggerSelector class >> uiManager: aUIManager [
	uiManager:= aUIManager
]
