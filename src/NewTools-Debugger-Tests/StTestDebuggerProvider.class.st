"
Utilitary class to provide various kind of debuggers, interrupted context and debug sessions for testing purposes
"
Class {
	#name : 'StTestDebuggerProvider',
	#superclass : 'Object',
	#instVars : [
		'session'
	],
	#category : 'NewTools-Debugger-Tests-Utils',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Utils'
}

{ #category : 'helpers' }
StTestDebuggerProvider class >> compileMissingClassContextBuilder [
	
	self compiler permitUndeclared: true; install: 'buildDebuggerWithMissingClassContext
	
	[ ^ MissingClass ]
		on: Error
		do: [ :err | 			
			self sessionFor: err signalerContext copy exception: err.
			^ self newDebugger ]'
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithContext: aContext [
	self sessionFor: aContext.
	^ self newDebugger
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithDNUContext [
	[ self methodProducingDNU ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.					
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithDynamicVariableSuspendedContext [
	|process|
	process := [
	           TestDynamicVariable value: 42 during: [
		           self assert:
			           (thisProcess psValueAt: TestDynamicVariable soleInstance index) = 42.
					  100 milliSeconds wait.
		           thisProcess suspend ] ] fork.
	session := DebugSession
		           named: 'test session providerSessionFor:'
		           on: process
		           startedAt: process suspendedContext.
	session exception:
		(OupsNullException fromSignallerContext: process suspendedContext).
"	self assert:
		(process psValueAt: TestDynamicVariable soleInstance index) = 42."
	
	^ self newDebugger
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithErrorContext [

	[ #(  ) at: 1 ]
		on: Error
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithFailingAssertionContext [
	[ self produceAssertionFailure ]
		on: TestFailure
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithFailingShouldntRaiseContext [
	[ self produceShouldntRaiseFailure ]
		on: TestFailure
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithFailingTestContext [
	[ self produceTestFailure ]
		on: TestFailure
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithGeneratingCodeContext [

	[ self methodThatGeneratesCode ]
		on: StGenerateCode 
		do: [ :err |
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithMissingClassContext [
	"The called method must contain a undeclared variable (the missing class).
	It makes the CI test fail, so it has to be generated and removed after usage.
	buildDebuggerWithMissingClassContext has to be generated when starting a test (see class side for generation) and removed in the test's tearDown."
	<ignoreNotImplementedSelectors: #(buildDebuggerWithMissingClassContext)>
	^ self buildDebuggerWithMissingClassContext
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithMissingSubclassResponsibilityContext [
	[ StDummyDebuggerPresenter new unimplementedSubclassResponsibility ]
		on: SubclassResponsibility
		do: [ :err | 			
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithMissingSubclassResponsibilityContextWithSteps [

	| ctx dbg |
	ctx := [
	       StDummyDebuggerPresenter new
		       unimplementedSubclassResponsibility ] asContext.

	self
		sessionFor: ctx
		exception: (OupsNullException fromSignallerContext: ctx).
	dbg := self newDebugger.
	dbg
		application: dbg class currentApplication;
		initialize.
	"We reach the subclass responsability"
	dbg
		stepOver;
		stepOver;
		stepInto;
		stepOver.

	^ dbg
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithObjectHalting [
	[ StDebuggerObjectForTests new haltingMethod ]
		on: Halt
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithRecursiveContext [

	| debugger |
	debugger := self debuggerWithContext:
		            [ self recursiveMethodCall ] asContext.

	^ debugger
]

{ #category : 'helpers' }
StTestDebuggerProvider >> debuggerWithRunnableContext [
<haltOrBreakpointForTesting>
	[ Halt now ]
		on: Halt
		do: [ :err | 
			self sessionFor: err signalerContext exception: err.
			^ self newDebugger ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> intermediateRecursiveMethodCall [

	"Dummy assignment to avoid the test session to step to the next interesting bytecode (= next return)"

	| a |
	a := 0.
	^ self recursiveMethodCall
]

{ #category : 'helpers' }
StTestDebuggerProvider >> methodProducingDNU [

	^ self foobar
]

{ #category : 'helpers' }
StTestDebuggerProvider >> methodThatGeneratesCode [

	| asserter |
	asserter := TestAsserter new.
	
	asserter see: 42 + 66 + 3
]

{ #category : 'helpers' }
StTestDebuggerProvider >> newDebugger [

	| debugger |
	debugger := StDebugger basicNew.
	debugger session: session.
	debugger debuggerActionModel updateContextPredicate.
	^ debugger
]

{ #category : 'helpers' }
StTestDebuggerProvider >> produceAssertionFailure [
	TestCase new assert: 4 equals: 2
]

{ #category : 'helpers' }
StTestDebuggerProvider >> produceShouldntRaiseFailure [
	TestCase new shouldnt: [ 1/0 ] raise: ZeroDivide
]

{ #category : 'helpers' }
StTestDebuggerProvider >> produceTestFailure [
	TestCase new fail
]

{ #category : 'helpers' }
StTestDebuggerProvider >> recursiveMethodCall [

	"Dummy assignment to avoid the test session to step to the next interesting bytecode (= next return)"

	| a |
	a := 0.
	^ self intermediateRecursiveMethodCall
]

{ #category : 'helpers' }
StTestDebuggerProvider >> session [

	^ session
]

{ #category : 'helpers' }
StTestDebuggerProvider >> sessionFor: aContext [
	|process|
	process := Process
		           forContext: aContext
		           priority: Processor userInterruptPriority.
	session := DebugSession
		           named: 'test session providerSessionFor:'
		           on: process
		           startedAt: aContext.
	session exception ifNil: [ session exception: OupsNullException new ]
]

{ #category : 'helpers' }
StTestDebuggerProvider >> sessionFor: aContext exception: e [

	e freezeUpTo: nil.
	self sessionFor: e signalerContext.
	session name: session name , ' ' , e printString.
	session exception: e
]

{ #category : 'helpers' }
StTestDebuggerProvider >> sessionForDebuggerTests [

	| context process sessionForTests |
	context := [ 
	           | i |
	           i := 1 squared.
	           i = 1 ifTrue: [ 
		           | j |
		           j := i + 1 ].
	           ^ 1 + i ] asContext.
	process := Process
		           forContext: context
		           priority: Processor userInterruptPriority.
	sessionForTests := DebugSession
		                   named: 'test sessionProviderForDebuggerTests'
		                   on: process
		                   startedAt: context.
	sessionForTests exception: (OupsNullException fromSignallerContext: context).
	^ sessionForTests
]

{ #category : 'helpers' }
StTestDebuggerProvider >> sessionWithDNUAfterStep [

	| context process sessionForTests |
	context := [ ^ self methodProducingDNU ] asContext.
	process := Process
		           forContext: context
		           priority: Processor userInterruptPriority.
	sessionForTests := DebugSession
		                   named: 'test sessionProviderWithDNUAfterStep'
		                   on: process
		                   startedAt: context.
	sessionForTests exception: (OupsNullException fromSignallerContext: context).
	^ sessionForTests
]

{ #category : 'helpers' }
StTestDebuggerProvider >> sessionWithInlinedLoop [

	| context process sessionForTests |
	context := [
	           | a b nbMonth |
	           a := 20.
	           b := 0.
	           nbMonth := 0.
	           [ a > b ] whileTrue: [
		           | list |
		           nbMonth := nbMonth + 1.
		           list := #( 1 2 3 ) asOrderedCollection collect: [ :e |
			                   e + nbMonth ].
		           b := b + 1 ].
	           a := b * 42.
	           ^ a ] asContext.
	process := Process
		           forContext: context
		           priority: Processor userInterruptPriority.
	sessionForTests := DebugSession
		                   named: 'test sessionProviderForDebuggerTestsWithInlinedLoop'
		                   on: process
		                   startedAt: context.
	sessionForTests exception:
		(OupsNullException fromSignallerContext: context).
	^ sessionForTests
]

{ #category : 'helpers' }
StTestDebuggerProvider >> terminate [ 
	session ifNotNil:[session clear].
	session := nil
]
