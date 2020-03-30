Class {
	#name : #DebuggerSelectorForTests,
	#superclass : #DebuggerSelector,
	#instVars : [
		'debuggerSelectionAttempts',
		'debuggerClasses'
	],
	#category : #'NewTools-DebuggerSelector-Tests'
}

{ #category : #helper }
DebuggerSelectorForTests >> clearDebuggerClasses [
	debuggerClasses := OrderedCollection new
]

{ #category : #accessing }
DebuggerSelectorForTests >> debuggerClasses [
	^ debuggerClasses
]

{ #category : #accessing }
DebuggerSelectorForTests >> debuggerSelectionAttempts [
	^ debuggerSelectionAttempts
]

{ #category : #accessing }
DebuggerSelectorForTests >> getDebuggerClasses [
	"The superclass' method, that looks for all debugger classes in the system, is replaced with a simple collection for testing purposes. The tests manually put test debugger classes in the collection, so that they can specify which debugger classes the debuggerSelector that is tested can work with. Otherwise, the tests of DebuggerSelector can be impacted by the presence or absence of regular debugger classes."

	^ debuggerClasses
]

{ #category : #accessing }
DebuggerSelectorForTests >> getDebuggerClassesReal [
	"Since #getDebuggerClasses is overriden for testing purposes in this class, we need another way to test the normal implementation of #getDebuggerClass"

	^ super getDebuggerClasses
]

{ #category : #accessing }
DebuggerSelectorForTests >> ignoreDummyDebuggerForTests [
	^ false
]

{ #category : #initialization }
DebuggerSelectorForTests >> initialize [
	super initialize.
	debuggerSelectionAttempts := OrderedCollection new.
	debuggerClasses := OrderedCollection new
]

{ #category : #helper }
DebuggerSelectorForTests >> selectAndOpenDebuggerFor: a withNotification: c [
	super selectAndOpenDebuggerFor: a withNotification: c
]

{ #category : #helper }
DebuggerSelectorForTests >> tryToOpenDebugSession: aDebugSession withDebuggerClass: aDebuggerClass andNotification: aString [
	"This method is the same as that of the superclass, with the difference that it logs which debuggers this class tried to open in the debuggerSelectionAttempts variable, along with whether the opening succeeded or not"

	[ 
	aDebuggerClass
		openOn: aDebugSession
		withFullView: aBool
		andNotification: aString.
	self debuggerSelectionAttempts add: (DebuggerSelectionRecordUnit
			 newOnDebuggerClass: aDebuggerClass
			 withSuccess: true).
	^ true ]
		on: Error
		do: [ 
			self debuggerSelectionAttempts add: (DebuggerSelectionRecordUnit
					 newOnDebuggerClass: aDebuggerClass
					 withSuccess: false).
			^ false ]
]
