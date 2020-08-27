Class {
	#name : #StDebuggerContextTest,
	#superclass : #TestCase,
	#instVars : [
		'debuggerContext',
		'hostObject'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #helpers }
StDebuggerContextTest >> contextWithTemps [

	"Creates and returns a context in which we step until we enter a method with temporary variables, then step two times over the assignement of the first temp"

	| context |
	context := [ hostObject methodWithTemps ] asContext.
	[ context method selector = #methodWithTemps ] whileFalse: [ 
		context := context step ].

	context := context step.
	context := context step.
	^ context
]

{ #category : #running }
StDebuggerContextTest >> setUp [
	super setUp.
	
	debuggerContext := StDebuggerContext new.
	hostObject := StDebuggerObjectForTests new
]

{ #category : #tests }
StDebuggerContextTest >> testReceiverNodes [
	|nodes|
	nodes := debuggerContext receiverNodes: hostObject.
	self assert: nodes size equals: 1.
	self assert: nodes first key equals: 'instVar'.
	self assert: nodes first rawValue equals: hostObject instVar.
	self deny: (nodes anySatisfy: [:n| n key = 'self'])
]

{ #category : #tests }
StDebuggerContextTest >> testStackTopNodes [
]

{ #category : #tests }
StDebuggerContextTest >> testTemporaryVariablesNode [
	|ctx nodes|
	ctx := self contextWithTemps.
	nodes := debuggerContext temporaryVariablesNodes: ctx.
	self assert: nodes size equals: 2.
	self assert: nodes first key equals: 'a'.
	self assert: nodes first rawValue equals: 0.
	self assert: nodes second key equals: 'b'.
	self assert: nodes second rawValue equals: nil.
	self deny: (nodes anySatisfy: [:n| n key = 'self'])
]

{ #category : #tests }
StDebuggerContextTest >> testThisContextNode [
]
