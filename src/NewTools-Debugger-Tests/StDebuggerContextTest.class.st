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
StDebuggerContextTest >> contextWithArgs [

	"Creates and returns a context in which we step until we enter a method with temporary variables, then step two times over the assignement of the first temp"

	| context |
	context := [ hostObject methodWithArg1: 4 arg2: 2  ] asContext.
	[ context method selector = #methodWithArg1:arg2: ] whileFalse: [ 
		context := context step ].

	context := context step.
	context := context step.
	^ context
]

{ #category : #helpers }
StDebuggerContextTest >> contextWithArgsInBlock [

	"Creates and returns a context in which we step until we enter a method with arguments in a block, then step 4 times until we're in the block"

	| context |
	context := [ hostObject methodWithArgsInBlock ] asContext.
	[ context method selector = #methodWithArgsInBlock ] whileFalse: [ 
		context := context step ].

	4 timesRepeat: [ context := context step ].
	context := context step.
	^ context
]

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
StDebuggerContextTest >> testArgumentsNodes [
	|ctx nodes|
	ctx := self contextWithArgs.
	nodes := debuggerContext argumentsNodes: ctx.	
	self assert: nodes size equals: 2.
	self assert: nodes first key equals: 'i'.
	self assert: nodes first label equals: '[arg] i'.
	self assert: nodes first rawValue equals: 4.
	self assert: nodes second key equals: 'j'.
	self assert: nodes second label equals: '[arg] j'.
	self assert: nodes second rawValue equals: 2.
	self deny: (nodes anySatisfy: [:n| n key = 'self'])
]

{ #category : #tests }
StDebuggerContextTest >> testArgumentsNodesInBlock [
	|ctx nodes|

	ctx := self contextWithArgsInBlock.
	nodes := debuggerContext argumentsNodes: ctx.	
	self assert: nodes size equals: 2.
	self assert: nodes first key equals: 'a'.
	self assert: nodes first label equals: '[arg] a'.
	self assert: nodes first rawValue equals: 4.
	self assert: nodes second key equals: 'b'.
	self assert: nodes second label equals: '[arg] b'.
	self assert: nodes second rawValue equals: 2.
	self deny: (nodes anySatisfy: [:n| n key = 'self'])
]

{ #category : #tests }
StDebuggerContextTest >> testContext [
	|ctx|
	ctx := self contextWithArgs.
	debuggerContext context: ctx.
	self assert: debuggerContext context identicalTo: ctx
]

{ #category : #tests }
StDebuggerContextTest >> testNoDuplicatesBetweenArgsAndTemps [
	|ctx nodes|
	self fail.
	ctx := self contextWithArgs.
	nodes := debuggerContext argumentsNodes: ctx.	
	self assert: nodes size equals: 2.
	self assert: nodes first key equals: 'i'.
	self assert: nodes first label equals: '[arg] i'.
	self assert: nodes first rawValue equals: 4.
	self assert: nodes second key equals: 'j'.
	self assert: nodes second label equals: '[arg] j'.
	self assert: nodes second rawValue equals: 2.
	self deny: (nodes anySatisfy: [:n| n key = 'self'])
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
StDebuggerContextTest >> testStackTopNode [	
	|ctx node|
	"We step once on the context to be on the value part of the next assignment"
	ctx := self contextWithTemps step.
	node := debuggerContext stackTopNode: ctx.	
	self assert: node key equals: 'stackTop'.
	self assert: node rawValue equals: 0
]

{ #category : #tests }
StDebuggerContextTest >> testTemporaryVariablesNodes [
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
	|ctx node|
	ctx := self contextWithTemps.
	node := debuggerContext thisContextNode: ctx.	
	self assert: node key equals: 'thisContext'.
	self assert: node rawValue identicalTo: ctx
]
