"
I am a simple wrapper holding the current context and the current debug session in a debugger.
My purpose is only to display context and debug session related information in the debugger inspector.
"
Class {
	#name : #StDebuggerContext,
	#superclass : #Object,
	#instVars : [
		'context',
		'session',
		'assertionContext',
		'exceptionContext',
		'debugger'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerContext class >> context: aContext session: aDebugSession debugger: sourceDebugger [
	^ self new
		context: aContext;
		session: aDebugSession;
		debugger: sourceDebugger;
		yourself
]

{ #category : #accessing }
StDebuggerContext >> allInspectorNodes [
	^ {(StDebuggerContextInspectorReceiverNode hostObject: self).
	(StDebuggerContextInspectorTempsNode hostObject: self).
	(StDebuggerContextInspectorContextNode hostObject: self)}
]

{ #category : #accessing }
StDebuggerContext >> assertionSelectors [
	^ #( #assert:equals: #assert:closeTo:precision:
	     #assert:closeTo: #assert:identicalTo: #assertCollection:equals:
	     #assertCollection:hasSameElements: )
]

{ #category : #accessing }
StDebuggerContext >> context [
	^ context
]

{ #category : #accessing }
StDebuggerContext >> context: anObject [
	context := anObject
]

{ #category : #accessing }
StDebuggerContext >> debugger: anObject [
	debugger := anObject
]

{ #category : #'dynamic views' }
StDebuggerContext >> diffPresenterForFailingAssertions [
	<inspectorPresentationOrder: -1 title: 'Failed assertion' if: #isTopContextFailingAssertion>
	^ (StDebuggerFailingAssertionInspector
		diffInspectorsFromActual: (assertionContext tempAt: 1)
		expected: (assertionContext tempAt: 2))
		application: debugger application;
		yourself
]

{ #category : #'dynamic views' }
StDebuggerContext >> isTopContextFailingAssertion [
	assertionContext := self session stack first
		                    findContextSuchThat: [ :ctx | 
		                    self assertionSelectors includes: ctx selector ]
		                    depth: 10.
	^ assertionContext notNil
]

{ #category : #printing }
StDebuggerContext >> printOn: aStream [
	aStream nextPutAll: context asString 
]

{ #category : #accessing }
StDebuggerContext >> session [
	^ session
]

{ #category : #accessing }
StDebuggerContext >> session: anObject [
	session := anObject
]
