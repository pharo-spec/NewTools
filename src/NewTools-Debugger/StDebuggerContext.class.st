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

	| nodes argsNodes argsKeys tempsNodes |
	nodes := OrderedCollection new.
	argsNodes := self argumentsNodes.
	argsKeys := argsNodes collect: [ :node | node key ].
	tempsNodes := self temporaryVariablesNodes reject: [ :tempNode | 
		              argsKeys includes: tempNode key ].
	nodes addAll: argsNodes.
	nodes addAll: tempsNodes.
	nodes addAll: self receiverNodes.
	nodes add: self stackTopNode.
	nodes add: self thisContextNode.
	^ nodes
]

{ #category : #nodes }
StDebuggerContext >> argumentsNodes [

	| argNames |
	argNames := self context sourceNode arguments.
	^ (argNames collect: [ :argName | 
		   (StDebuggerInspectorTempNode hostObject: self context) 
			   argVariable: (self context temporaryVariableNamed: argName name) ])
		  asOrderedCollection
]

{ #category : #accessing }
StDebuggerContext >> assertionSelectors [
	self flag: 'A bit magickal, also is this the right place?'.
	^ #( #assert:equals: #assert:closeTo:precision:
	     #assert:closeTo: #assert:identicalTo: #assertCollection:equals:
	     #assertCollection:hasSameElements: )
]

{ #category : #accessing }
StDebuggerContext >> context [

	^ context ifNil: [ context := [] asContext ]
]

{ #category : #accessing }
StDebuggerContext >> context: anObject [
	context := anObject
]

{ #category : #accessing }
StDebuggerContext >> debugger: anObject [
	debugger := anObject
]

{ #category : #printing }
StDebuggerContext >> printOn: aStream [
	aStream nextPutAll: context asString 
]

{ #category : #nodes }
StDebuggerContext >> receiverNodes [

	^ self context receiver allInspectorNodes reject: [ :node | node key = 'self' ]
]

{ #category : #accessing }
StDebuggerContext >> session [
	^ session
]

{ #category : #accessing }
StDebuggerContext >> session: anObject [
	session := anObject
]

{ #category : #nodes }
StDebuggerContext >> stackTopNode [
	^StInspectorStackTopNode hostObject: self context
]

{ #category : #nodes }
StDebuggerContext >> temporaryVariablesNodes [

	^ self context astScope allTemps collect: [ :temp | 
		  (StDebuggerInspectorTempNode hostObject: self context) tempVariable: temp ]
]

{ #category : #nodes }
StDebuggerContext >> thisContextNode [ 
	^StInspectorThisContextNode hostObject: self context
]
