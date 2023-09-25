Class {
	#name : #StDebuggerContextPredicateTest,
	#superclass : #TestCase,
	#instVars : [
		'predicate',
		'context'
	],
	#category : #'NewTools-Debugger-Tests-Model'
}

{ #category : #running }
StDebuggerContextPredicateTest >> setUp [
	super setUp.
	context := [  ] asContext.
	predicate := (StDebuggerContextPredicate context: context)
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testContext [
	self assert: predicate context identicalTo: context
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testIsContextDead [
	
	self deny: predicate isContextDead.
	context pc: nil.
	self assert: predicate isContextDead
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testIsSteppable [

	self assert: predicate isSteppable.
	predicate postMortem: true.
	self deny: predicate isSteppable.

	predicate postMortem: false.
	self assert: predicate isSteppable.
	context pc: nil.
	self assert: context isDead.
	self deny: predicate isSteppable
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintDNUDescription [
	self assert: (StDebuggerActionModel on: 
			([ Object perform: #thisMessageIsNotUnderstood ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'Instance of Object class did not understand #thisMessageIsNotUnderstood'.
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintDescription [
	self skip.
	self assert: predicate printDescription equals: '0'
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintExceptionDescription [
	self assert: (StDebuggerActionModel on: 
			([ Exception signal ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'Exception'.
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintHaltDescription [
	|haltContext|
	haltContext := (StTestDebuggerProvider new debuggerWithRunnableContext) interruptedContext.
	predicate context: haltContext.
	self assert: predicate printDescription equals: 'Halt in ', haltContext printString
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintHaltIfDescription [
	self assert: (StDebuggerActionModel on: 
			([ Halt if: [ true ] ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'Halt in [ Halt if: [ true ] ] in StDebuggerContextPredicateTest>>testPrintHaltIfDescription'.
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintHaltNowDescription [
	self assert: (StDebuggerActionModel on: 
			([ Halt now ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'Halt'.
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintPostMortemDescription [
	self skip.
	predicate postMortem: true.
	self assert: predicate printDescription equals: '[Post-mortem] 0'
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintSignalInDescription [
	self assert: (StDebuggerActionModel on: 
			([ Exception signalIn: thisContext ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'Exception'.
]

{ #category : #tests }
StDebuggerContextPredicateTest >> testPrintTestFailureDescription [
	self assert: (StDebuggerActionModel on: 
			([ TestFailure signal ] on: Exception do: 
				[ :e | StTestDebuggerProvider new sessionFor: nil exception: e ]) session) statusStringForContext
		equals: 'TestFailure'.
]
