Class {
	#name : 'StDebuggerActionModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'session',
		'debugActionModel',
		'debugger',
		'result',
		'shouldFilterStack',
		'methodWithBlockContextOriginalSource',
		'setResultOriginalSourceCode'
	],
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'benchmarking' }
StDebuggerActionModelTest class >> benchFilterStack [
	<script>
	^self new benchmarkFilterStack inspect
]

{ #category : 'benchmarks' }
StDebuggerActionModelTest >> bench: aBlock [
	^ aBlock timeToRun asNanoSeconds
]

{ #category : 'benchmarks' }
StDebuggerActionModelTest >> benchmarkFilterStack [
	| stack1 stack2 beforeResults afterResults |
	[ self method1: 0 ]
		on: Halt
		do: [ :halt | 
			session := Process new
				           newDebugSessionNamed: 'profiling'
				           startedAt: halt signalerContext.
			stack1 := session stack.	
			stack2 := stack1 copy.		
			debugActionModel := StDebuggerActionModel new.
			debugActionModel session: session.
			beforeResults := 0.
			10000 timesRepeat: [ 
				beforeResults := beforeResults + (self bench: [ 
					                  stack1 reject: [ :aContext | 
						                  aContext method hasPragmaNamed:
							                  #debuggerCompleteToSender ] ]) ].
			afterResults := 0.
			10000 timesRepeat: [ 
				afterResults := afterResults
				                +
				                (self bench: [ 
					                 debugActionModel filterStack: stack2 ]) ] ].
	^'Old behavior: ', beforeResults printString, ' nanoseconds measured. 
	New behavior: ', afterResults printString, ' nanoseconds measured.'
]

{ #category : 'helper' }
StDebuggerActionModelTest >> changeSession: aDebugSession [

	debugActionModel clear; clearDebugSession.
	session := aDebugSession.
	debugActionModel := StDebuggerActionModel on: session
]

{ #category : 'helper' }
StDebuggerActionModelTest >> emptyContextForMethod: aCompiledMethod [
	^ (Context newForMethod: aCompiledMethod)
		  initializeWith: nil
		  stackPtr: nil
		  method: aCompiledMethod
		  receiver: nil
		  sender: nil;
		  yourself
]

{ #category : 'helper' }
StDebuggerActionModelTest >> evaluateMethodWithDeadHomeBlockContext [

	self methodWithDeadBlockContext value
]

{ #category : 'helper' }
StDebuggerActionModelTest >> fileOutMethod: anObject [
	result := anObject
]

{ #category : 'helper' }
StDebuggerActionModelTest >> method1: i [
	^self method2: i+1
]

{ #category : 'helper' }
StDebuggerActionModelTest >> method2: i [
	<haltOrBreakpointForTesting>
	i = 9999 ifTrue: [ self halt. ^i ].
	^self method1: i+1
]

{ #category : 'helper' }
StDebuggerActionModelTest >> methodClass [
	^self
]

{ #category : 'helper' }
StDebuggerActionModelTest >> methodWithBlockContext [

	| block |
	block := [ (1+1 ) printString ].
	block value
]

{ #category : 'helper' }
StDebuggerActionModelTest >> methodWithDeadBlockContext [

	^ [ (1 + 1) printString ]
]

{ #category : 'helper' }
StDebuggerActionModelTest >> methodWithPragma [
	<debuggerCompleteToSender>
]

{ #category : 'helper' }
StDebuggerActionModelTest >> newSessionWithBlockContext [

	| process method |
	method := self class >> #methodWithBlockContext.
	methodWithBlockContextOriginalSource := method sourceCode.
	process := [ method valueWithReceiver: self ] newProcess.
	self setSessionAndDebuggerModelForMethod: method inContext: process suspendedContext.

	[ debugActionModel topContext closure isNil ] whileTrue: [
		debugActionModel stepInto: debugActionModel topContext ].
	"Step on (1 + 1) message"
	debugActionModel stepInto: debugActionModel topContext
]

{ #category : 'helper' }
StDebuggerActionModelTest >> newSessionWithDeadHomeBlockContext [

	| process method |
	method := self class >> #evaluateMethodWithDeadHomeBlockContext.
	methodWithBlockContextOriginalSource := method sourceCode.
	process := [ method valueWithReceiver: self ]
		           newProcess.
	self
		setSessionAndDebuggerModelForMethod: method
		inContext: process suspendedContext.

	"Step until we are inside the closure"
	[ debugActionModel topContext isBlockContext ] whileFalse: [
		debugActionModel stepInto: debugActionModel topContext.
	]
]

{ #category : 'helper' }
StDebuggerActionModelTest >> resetModifiedSourceCode [

	methodWithBlockContextOriginalSource ifNotNil: [
		self class compile: methodWithBlockContextOriginalSource ].
	setResultOriginalSourceCode ifNotNil: [
		self class compile: setResultOriginalSourceCode ]
]

{ #category : 'helper' }
StDebuggerActionModelTest >> session [
	^debugger session
]

{ #category : 'helper' }
StDebuggerActionModelTest >> setResult [
	result := 2 squared.
	^result
]

{ #category : 'running' }
StDebuggerActionModelTest >> setSessionAndDebuggerModelForMethod: aMethod inContext: aContext [

	| dummyActionModel |
	session ifNotNil: [ session clear ].
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     aContext) debuggerActionModel.
	session := dummyActionModel session.
	dummyActionModel clear.
	session stepIntoUntil: [ :currentContext |
		currentContext method == aMethod ].
	debugActionModel := StDebuggerActionModel on: session.
	shouldFilterStack := StDebuggerActionModel shouldFilterStack
]

{ #category : 'running' }
StDebuggerActionModelTest >> setUp [

	| method process |
	super setUp.
	method := self class >> #setResult.
	process := [ method valueWithReceiver: self ]
		           newProcess.

	self
		setSessionAndDebuggerModelForMethod: method
		inContext: process suspendedContext
]

{ #category : 'running' }
StDebuggerActionModelTest >> tearDown [
	debugActionModel clear.
	debugger ifNotNil: [ debugger clear].
	session ifNotNil: [ session clear ].
	session := nil.
	StDebuggerUsingSpecSelectorMock removeSelector: #testMethod.
	StDebuggerUsingSpecSelectorMock removeSelector: #method.
	StDebuggerUsingSpecSelectorMock removeSelector: #unclassifiedMethod.
	StTestDebuggerProvider removeSelector: #buildDebuggerWithMissingClassContext.
	StTestDebuggerProvider removeSelector: #foobar.
	StDebuggerActionModel shouldFilterStack: shouldFilterStack.
	DebugSession contextModelClass: DebugContext.
	self resetModifiedSourceCode.
	super tearDown
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testClearDebugSession [
	| process |
	process := session interruptedProcess.
	self deny: process isTerminated.
	debugActionModel clearDebugSession.
	self assert: process isTerminated.
	self assert: session interruptedContext isNil
]

{ #category : 'tests - contexts' }
StDebuggerActionModelTest >> testComputeInitialTopContext [

	| newSession dummyActionModel |
	self flag:
		'We suspect this test to make the production CI fail so we skip it for now'.
	self skip.
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContext
		                    debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self
		assert: debugActionModel topContext
		identicalTo: session exception signalContext.

	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContext
		                    debuggerActionModel.
	newSession := dummyActionModel session.
	dummyActionModel clear.
	newSession restart: newSession interruptedContext sender.
	self changeSession: newSession.
	self
		assert: debugActionModel topContext
		identicalTo: session interruptedContext
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testCopyStackToClipboard [
	debugActionModel copyStackToClipboard.
	self
		assert: Clipboard clipboardText string
		equals:
			(String
				streamContents: [ :s | session interruptedContext shortDebugStackOn: s ])
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testCreateMissingMethod [
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testDefaultShouldFilterStack [

	self assert: StDebuggerActionModel shouldFilterStack
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testDynamicShouldFilterStack [

	| mockDebugActionModel |
	mockDebugActionModel := StMockDebuggerActionModel new.

	self assert: mockDebugActionModel filterStack.

	StDebuggerActionModel shouldFilterStack: true.
	self assert: mockDebugActionModel shouldFilterStack.

	StDebuggerActionModel shouldFilterStack: false.
	self deny: mockDebugActionModel shouldFilterStack.

	mockDebugActionModel
		clear;
		clearDebugSession
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testDynamicShouldFilterStackUpdate [

	|mockDebugActionModel context|
	mockDebugActionModel := StMockDebuggerActionModel new.		
	self assert: mockDebugActionModel filterStack.
	self assert: mockDebugActionModel shouldFilterStack.
	
	context := Context
		sender: nil
		receiver: nil
		method: Object >> #doesNotUnderstand:
		arguments: #(#message).
	mockDebugActionModel interruptedContext: context.
	mockDebugActionModel stepInto: context.
	self deny: mockDebugActionModel filterStack.
	self deny: mockDebugActionModel shouldFilterStack.
	
	mockDebugActionModel stepOver: context.
	self deny: mockDebugActionModel filterStack.
	self deny: mockDebugActionModel shouldFilterStack.
	
	mockDebugActionModel clear; clearDebugSession.
	
	mockDebugActionModel := StMockDebuggerActionModel new.		
	self assert: mockDebugActionModel filterStack.
	self assert: mockDebugActionModel shouldFilterStack.
	
	context := Context
		sender: nil
		receiver: nil
		method: Object >> #asString
		arguments: #().
	mockDebugActionModel interruptedContext: context.
	mockDebugActionModel stepInto: context.
	self deny: mockDebugActionModel filterStack.
	self deny: mockDebugActionModel shouldFilterStack.
	
	mockDebugActionModel stepOver: context.
	self assert: mockDebugActionModel filterStack.
	self assert: mockDebugActionModel shouldFilterStack.
	
	mockDebugActionModel clear; clearDebugSession
	
	
	
	
	
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterClear [

	| dummyActionModel dummyDebugger |
	dummyDebugger := StDummyDebuggerPresenter new.

	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext
		                    debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.

	debugActionModel
		when: StDebuggerActionModelClearAnnouncement
		send: #tag:
		to: dummyDebugger.

	self assert: dummyDebugger tag isNil.

	debugActionModel clear.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelClearAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterMethodAdded [

	| dummyActionModel dummyDebugger |
	dummyDebugger := StDummyDebuggerPresenter new.

	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext
		                    debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.

	debugActionModel
		when: StDebuggerActionModelMethodAddedAnnouncement
		send: #tag:
		to: dummyDebugger.

	self assert: dummyDebugger tag isNil.

	StTestDebuggerProvider compile: 'foobar ^self'.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelMethodAddedAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterProceed [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to restart events"
	debugActionModel
		when: StDebuggerActionModelResumeAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel proceedDebugSession.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelResumeAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterRecompileMethod [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	setResultOriginalSourceCode := ctx method sourceCode.
	dummyDebugger := StDummyDebuggerPresenter new.

	debugActionModel session stepIntoUntil: [ :currentContext |
		currentContext selector = #squared ].

	"We subscribe dummy debugger to debug action model to recompilation events"
	debugActionModel
		when: StDebuggerActionModelContextChangedAnnouncement
		send: #tag:
		to: dummyDebugger.

	self assert: dummyDebugger tag isNil.

	debugActionModel
		recompileMethodTo: ctx method sourceCode , ' yourself'
		inContext: ctx
		notifying: nil.
	self flag:
		'We force the world to do cycles because the tests run in the UI thread, preventing the world to propagate the event #contextChanged, which is triggered by a Morphic alarm.'.
	[ dummyDebugger tag ] whileNil: [ WorldMorph currentWorld doOneCycle ].

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelContextChangedAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterRestart [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	debugActionModel
		stepOver: ctx;
		stepOver: ctx.

	"We subscribe dummy debugger to debug action model to restart events"
	debugActionModel
		when: StDebuggerActionModelRestartAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel restartContext: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelRestartAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterStepInto [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepInto: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterStepOver [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepOver: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testEventAfterStepThrough [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepThrough: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerActionModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerActionModel
		identicalTo: debugActionModel
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testExceptionProvidesSameExceptionAsTheSessionOne [

	self
		assert: debugActionModel exception
		equals: debugActionModel session exception
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testFileOutMethod [
	debugActionModel fileOutMethod: self.
	self assert: result equals: self selector
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testFilterDNUStack [

	|stack filteredStack dummyActionModel|
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	stack := OrderedCollection new.
	
	"First, the stack contains a top context (i.e. from which a signal was sent), then the interrupted context"
	stack add: debugActionModel topContext.
	
	"Second, the stack contexts is a MNU that has a method with the <debuggerCompleteToSender> pragma"
	stack add: debugActionModel interruptedContext.	
	
	"Then we have an imaginary call stack"
	stack add: (self emptyContextForMethod: (self class>>#method1:)).
	stack add: (self emptyContextForMethod: (self class>>#method2:)).
	
	filteredStack := debugActionModel filterStack: stack copy.
	
	self assert: filteredStack size equals: 2.
	self assert: filteredStack first identicalTo: stack third.
	self assert: filteredStack second identicalTo: stack fourth
	
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testFilterMissingSubclassResponsibilityStack [

	|stack filteredStack dummyActionModel|	
	
	"We change the stack with an interrupted context that does not contain the <debuggerCompleteToSender> pragma"
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	stack := OrderedCollection new.
	stack add: debugActionModel topContext.
	stack add: debugActionModel topContext sender.
	stack add: debugActionModel interruptedContext.
	stack add: (self emptyContextForMethod: (self class>>#method1:)).
	stack add: (self emptyContextForMethod: (self class>>#method2:)).
	
	filteredStack := debugActionModel filterStack: stack copy.
	self assert: filteredStack size equals: 2.
	self assert: filteredStack first identicalTo: stack fourth.
	self assert: filteredStack second identicalTo: stack fifth
]

{ #category : 'tests - stack filtering' }
StDebuggerActionModelTest >> testFilterStack [

	|stack filteredStack dummyActionModel|
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	stack := OrderedCollection new.
	
	"First, add to the stack a MNU context that has a method with the <debuggerCompleteToSender> pragma"
	stack add: debugActionModel interruptedContext.	
	
	"Then we have an imaginary call stack"
	stack add: (self emptyContextForMethod: (self class>>#method1:)).
	stack add: (self emptyContextForMethod: (self class>>#method2:)).
	
	
	StDebuggerActionModel shouldFilterStack: false.
	filteredStack := debugActionModel filterStack: stack copy.
	self assertCollection:  filteredStack equals: stack.
	
	StDebuggerActionModel shouldFilterStack: true.
	filteredStack := debugActionModel filterStack: stack copy.
	self assert: filteredStack size equals: 2.
	self assert: filteredStack first identicalTo: stack second.
	self assert: filteredStack second identicalTo: stack third
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testImplementInClassForContext [
	|method|
	method := (StDebuggerUsingSpecSelectorMock lookupSelector: #method).
	self assert:	method equals: nil.
	[ StDebuggerUsingSpecSelectorMock new method ]
		on: Error
		do: [ :dnu |
			debugActionModel
				implement: dnu message
				inClass: StDebuggerUsingSpecSelectorMock
				forContext: dnu signalerContext ].
	method := (StDebuggerUsingSpecSelectorMock lookupSelector: #method).
	self deny: method	equals: nil.
	self assert: method methodClass identicalTo: StDebuggerUsingSpecSelectorMock
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testImplementMethodClassification [

	| method |
	<ignoreNotImplementedSelectors: #(unclassifiedMethod)>
	[ StDebuggerUsingSpecSelectorMock new method ]
		on: Error
		do: [ :dnu |
			debugActionModel
				implement: dnu message
				inClass: StDebuggerUsingSpecSelectorMock
				forContext: dnu signalerContext ].

	[ StDebuggerUsingSpecSelectorMock new testMethod ]
		on: Error
		do: [ :dnu |
			debugActionModel
				implement: dnu message
				inClass: StDebuggerUsingSpecSelectorMock
				forContext: dnu signalerContext ].

	[ StDebuggerUsingSpecSelectorMock new unclassifiedMethod ]
		on: Error
		do: [ :dnu |
			debugActionModel
				implement: dnu message
				inClass: StDebuggerUsingSpecSelectorMock
				forContext: dnu signalerContext ].

	method := StDebuggerUsingSpecSelectorMock lookupSelector: #method.
	self assert: method protocolName equals: 'accessing'.

	method := StDebuggerUsingSpecSelectorMock lookupSelector: #testMethod.
	self assert: method protocolName equals: 'tests'.

	method := StDebuggerUsingSpecSelectorMock lookupSelector: #unclassifiedMethod.
	self deny: method isClassified
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testInitialization [
	self assert: debugActionModel session identicalTo: session.
	self
		assert: debugActionModel interruptedContext
		identicalTo: session interruptedContext
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testInterruptedContextProvidesSameContextAsTheSessionOne [

	self assert: debugActionModel interruptedContext equals: debugActionModel session interruptedContext 
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testInterruptedProcessProvidesSameProcessAsTheSessionOne [

	self
		assert: debugActionModel interruptedProcess
		equals: debugActionModel session interruptedProcess
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsContextAnAssertionFailure [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithFailingAssertionContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isContextAnAssertionFailure
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsContextSteppable [
	self assert: debugActionModel isContextSteppable
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextAnAssertEqualsFailure [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithFailingAssertionContext debuggerActionModel.
	self changeSession:
		dummyActionModel
			session.
	dummyActionModel clear.
	self assert: debugActionModel isContextAnAssertionFailure
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextDead [
	session interruptedContext pc: nil.
	self assert: debugActionModel isInterruptedContextDead
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextDoesNotUnderstand [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextDoesNotUnderstand.
	StTestDebuggerProvider compile: 'foobar ^self'.
	self deny: debugActionModel isInterruptedContextDoesNotUnderstand
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextMissingClassException [
	| dummyActionModel |
	StTestDebuggerProvider compileMissingClassContextBuilder.
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingClassContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextMissingClassException
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextPostMortem [
	session resume.
	self assert: debugActionModel isInterruptedContextPostMortem
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextSubclassResponsibilityException [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextSubclassResponsibilityException
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testIsInterruptedContextSubclassResponsibilityExceptionWithSteps [

	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContextWithSteps
		                    debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert:
		debugActionModel isInterruptedContextSubclassResponsibilityException
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testPeelToFirstLike [

	| firstCaller dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithRecursiveContext debuggerActionModel.
	self changeSession:
		dummyActionModel session.
	dummyActionModel clear.
		
	session stepInto.
	session stepInto.
	
	firstCaller := session stack first.	
	session stepInto.
	session stepInto.
	session stepInto.
	session stepInto.
	debugActionModel updateTopContext.
	
	"Explaining the context"
	self deny: session stack first method identicalTo: session stack second method.
	self assert: session stack first method identicalTo: session stack third method.	
	self assert: debugActionModel topContext identicalTo: session stack first.
		
	"The peel to first like the first context should pop contexts until the session is back to the first recursive sender down in the stack"
	debugActionModel peelToFirstLike: firstCaller.
	self assert: session interruptedContext identicalTo: firstCaller.
	self assert: debugActionModel topContext identicalTo: firstCaller
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testProceedDebugSession [
	self deny: session interruptedContext isNil.
	self assert: result isNil.
	debugActionModel proceedDebugSession.
	self assert: session interruptedContext isNil.
	self assert: result equals: 4
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRecompileMethodToInBlockContext [

	| contextChanged previousASTScope |
	self newSessionWithBlockContext.

	DebugSession contextModelClass: StDebugContextForTests.
	contextChanged := debugActionModel topContext.
	
	"We stepped into a block for which the debugActionModel holds an ast scope:"
	previousASTScope := debugActionModel previousASTScope.
	self
		assert: previousASTScope
		identicalTo: contextChanged astScope.

	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , '. ^self'
		inContext: contextChanged
		notifying: nil.
	debugActionModel updateTopContext.

	"After recompiling the method, the model holds an updated ast scope that is not the one of the block:"
	self deny: previousASTScope identicalTo: debugActionModel previousASTScope.
	
	"The new ast scope is the one of the AST of the first interesting bytecode of the method,
	that is the block declaration:"
	self
		assert: debugActionModel previousASTScope
		identicalTo: (self class >> #methodWithBlockContext) ast statements first value scope
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRecompileMethodToInBlockContextWithDeadHome [

	| contextChanged |

	DebugSession contextModelClass: StDebugContextForTests.
	self newSessionWithDeadHomeBlockContext.
	methodWithBlockContextOriginalSource := (self class >> #methodWithDeadBlockContext) sourceCode.
	
	contextChanged := debugActionModel topContext.
	
	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , ' yourself'
		inContext: contextChanged
		notifying: nil.
	debugActionModel updateTopContext.

	"The new ast scope is the one of the AST of the first interesting bytecode of the method,
	that is the block declaration:"
	self assert: (self class >> #methodWithDeadBlockContext) ast formattedCode equals: 'methodWithDeadBlockContext

	^ [ (1 + 1) printString ] yourself'
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRecompileMethodToInBlockContextWithDeadHomeRemainsInOldBlock [

	| contextChanged |

	DebugSession contextModelClass: StDebugContextForTests.
	self newSessionWithDeadHomeBlockContext.
	methodWithBlockContextOriginalSource := (self class >> #methodWithDeadBlockContext) sourceCode.
	
	contextChanged := debugActionModel topContext.
	
	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , ' yourself'
		inContext: contextChanged
		notifying: nil.
	debugActionModel updateTopContext.

	"We should be in the same context as before if the home was dead"
	self assert: debugActionModel topContext equals: contextChanged
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRecompileMethodToInContextNotifyingUpdatesSourceCodeAndContext [

	| oldStack contextChanged expectedNewStack rejectedFromOldStack |
	contextChanged := debugActionModel topContext.
	setResultOriginalSourceCode := contextChanged method sourceCode.

	debugActionModel session stepIntoUntil: [ :currentContext |
		currentContext selector = #squared ].
	oldStack := debugActionModel stack.
	rejectedFromOldStack := { debugActionModel topContext }.

	expectedNewStack := oldStack copyWithoutFirst.

	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , ' yourself'
		inContext: contextChanged
		notifying: nil.

	self flag:
		'We force the world to do cycles because the tests run in the UI thread, preventing the world to propagate the event #contextChanged, which is triggered by a Morphic alarm.'.
	[ debugActionModel topContext == contextChanged ] whileFalse: [
		WorldMorph currentWorld doOneCycle ].

	self
		denyCollection: debugActionModel stack
		includesAny: rejectedFromOldStack.
	self
		assertCollection: debugActionModel stack
		hasSameElements: expectedNewStack.
	self assert: debugActionModel topContext identicalTo: contextChanged
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRestartContext [
	|topContext topPC|
	topContext := 
	session interruptedContext.
	topPC := topContext pc.
	session stepInto.
	self deny: session interruptedContext identicalTo: topContext.
	debugActionModel restartContext: topContext.
	self assert: session interruptedContext identicalTo: topContext.
	self assert: session interruptedContext pc equals: topPC
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testReturnValueFromExpressionFromContext [
	session stepInto.
	session stepInto.
	debugActionModel returnValueFromExpression: '0' fromContext: session interruptedContext.
	self assert: session interruptedContext top equals: 0.
	session resume.
	self assert: result equals: 0
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testRunToSelectionInContext [
	|method node|
	method := (self class >> #setResult).
	node :=  method ast statements second.
	debugActionModel runToSelection: (node start to: node stop) inContext: session interruptedContext.
	self assert: result equals: 4.
	self assert: (method sourceNodeForPC: session interruptedContext pc) identicalTo: node
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testSelectedCodeRangeForContext [

	| method node |
	method := self class >> #setResult.
	node := method ast statements second.

	self
		assert: (debugActionModel selectedCodeRangeForContext:
				 debugActionModel interruptedContext)
		equals:
		(session selectedCodeRangeForContext: session interruptedContext).

	debugActionModel
		runToSelection: (node start to: node stop)
		inContext: session interruptedContext.

	self
		assert: (debugActionModel selectedCodeRangeForContext:
				 debugActionModel interruptedContext)
		equals:
		(session selectedCodeRangeForContext: session interruptedContext)
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testSessionStackProvidesSameStackAsTheSessionOne [

	self assert: debugActionModel stack equals: debugActionModel session stack
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testStackOfSizeWhenStackIsBigger [

	| oldStack newStack |
	oldStack := debugActionModel session stack.

	debugActionModel stepInto: debugActionModel interruptedContext.
	"We did a step into, so the size of the stack should be increased by 1. Here, I chose to increase the size of the stack by 13 but it could have any number greater than 1. The idea here is just to check that the size of the stack has been increased by only 1 and not more than necessary."
	newStack := debugActionModel stackOfSize: oldStack size + 13.

	self assert: newStack size - oldStack size equals: 1.
	self
		assertCollection: oldStack
		equals:
		(newStack collect: [ :obj | obj ] from: 2 to: oldStack size + 1)
]

{ #category : 'tests' }
StDebuggerActionModelTest >> testStackOfSizeWhenStackIsNotBigger [

	| oldStack newStack |
	oldStack := debugActionModel session stack.
	"Here, I chose to increase the size of the stack by 13 but it could have any number greater than 0. The idea here is just to check that the size of the stack is its exact size, although we provided a greater size as an argument."
	newStack := debugActionModel stackOfSize: oldStack size + 13.

	self assert: newStack size - oldStack size equals: 0.
	self
		assertCollection: oldStack
		equals: (newStack collect: [ :obj | obj ] from: 1 to: oldStack size)
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testStepInto [
	|ctx|
	ctx := session interruptedContext.
	debugActionModel stepInto: ctx.
	self deny: ctx stepIntoQuickMethod.
	self assert: session interruptedContext sender identicalTo: ctx.
	self assert: session stack second identicalTo: ctx
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testStepIntoQuickMethods [
	|ctx|
	ctx := StMockContext new.
	debugActionModel clearDebugSession; session: (StMockSession new).
	debugActionModel stepInto: ctx.
	
	"When we step into a context, first that context is configured to step into quick method (aContext stepIntoQuickMethod: true),
	second it steps,
	after stepping it is configured back to **not** stepping into quick methods (aContext stepIntoQuickMethod: false).
	The mock context just records that sequence of configuration."
	self assert: ctx stepIntoQuickMethodBooleans size equals: 2.
	self assert: ctx stepIntoQuickMethodBooleans first equals: true.
	self assert: ctx stepIntoQuickMethodBooleans second equals: false
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testStepOver [
	| method ctx |
	method := self class >> #setResult.
	ctx := session interruptedContext.
	debugActionModel stepOver: ctx.
	self assert: session interruptedContext identicalTo: ctx.
	self assert: ctx top equals: 4.
	debugActionModel stepOver: ctx.
	self assert: session interruptedContext identicalTo: ctx.
	self assert: result equals: 4.
	self
		assert: (method sourceNodeForPC: session interruptedContext pc)
		identicalTo: method ast statements second
]

{ #category : 'tests - actions' }
StDebuggerActionModelTest >> testStepThrough [
	| method ctx |
	method := self class >> #setResult.
	ctx := session interruptedContext.
	debugActionModel stepThrough: ctx.
	self assert: session interruptedContext identicalTo: ctx.
	self assert: ctx top equals: 4.
	debugActionModel stepThrough: ctx.
	self assert: session interruptedContext identicalTo: ctx.
	self assert: result equals: 4.
	self
		assert: (method sourceNodeForPC: session interruptedContext pc)
		identicalTo: method ast statements second
]

{ #category : 'tests - predicates' }
StDebuggerActionModelTest >> testUpdateDebugSession [

	| exception dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithErrorContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	exception := session exception.
	session exception: nil.
	debugActionModel updateDebugSession.
	self assert: session exception isNotNil.
	self assert: session exception identicalTo: exception
]

{ #category : 'tests - contexts' }
StDebuggerActionModelTest >> testUpdateTopContext [
	
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerActionModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self deny: debugActionModel topContext identicalTo: debugActionModel interruptedContext.
	debugActionModel updateTopContext.		
	self assert: debugActionModel topContext identicalTo: debugActionModel interruptedContext
	
	
	
]

{ #category : 'tests - contexts' }
StDebuggerActionModelTest >> testUpdateTopContextAfterSessionOperation [

	| mockDebugActionModel context |
	context := [  ] asContext.
	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel stepInto: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel stepOver: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel stepThrough: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel restartContext: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel
		returnValueFromExpression: 'nil'
		fromContext: [  ] asContext.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel runToSelection: nil inContext: StMockContext new.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerActionModel new.
	mockDebugActionModel
		implement: nil
		inClass: nil
		forContext: StMockContext new.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession
]
