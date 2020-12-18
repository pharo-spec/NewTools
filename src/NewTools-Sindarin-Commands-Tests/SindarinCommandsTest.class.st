Class {
	#name : #SindarinCommandsTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor',
		'object',
		'debugger'
	],
	#category : #'NewTools-Sindarin-Commands-Tests'
}

{ #category : #running }
SindarinCommandsTest >> setUp [
	super setUp.
	
	visitor := SindarinTestVisitor new.
	object := SindarinTestObjectToVisit new
]

{ #category : #running }
SindarinCommandsTest >> tearDown [

	debugger ifNotNil: [ 
		debugger session ifNotNil: [ :s | s clear ].
		debugger session: nil.
		debugger := nil ].
	super tearDown
]

{ #category : #tests }
SindarinCommandsTest >> testStepToNextCallInClass [

	| command |
	debugger := SindarinTestCommandDebugger new.
	debugger session: 
	(StTestDebuggerProvider new debuggerWithContext:
		            [ visitor visit: object ] asContext) session.

	debugger session stepIntoUntil: [ :currentContext | 
		currentContext method == (visitor class >> #visit:) ].
	command := SindarinStepToNextCallInClassCommand forContext: debugger.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visit:.
	command execute.
	self
		assert: debugger session context method
		identicalTo: visitor class >> #visitTestObject:
]
