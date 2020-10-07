Class {
	#name : #StDebuggerContextPredicateTest,
	#superclass : #TestCase,
	#instVars : [
		'ctxDescription'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #running }
StDebuggerContextPredicateTest >> setUp [
	super setUp.
	
	ctxDescription := (StDebuggerContextPredicate context: 0)
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testContext [
	self assert: ctxDescription context equals: 0
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testIsSteppable [
	
	self assert: ctxDescription isSteppable.
	ctxDescription postMortem: true.
	self deny: ctxDescription isSteppable
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintDescription [
	self skip.
	self assert: ctxDescription printDescription equals: '0'
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintHaltDescription [
	|haltContext|
	haltContext := (StTestDebuggerProvider new debuggerWithRunnableContext) interruptedContext.
	ctxDescription context: haltContext.
	self assert: ctxDescription printDescription equals: 'Halt in ', haltContext printString
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintPostMortemDescription [
	self skip.
	ctxDescription postMortem: true.
	self assert: ctxDescription printDescription equals: '[Post-mortem] 0'
]
