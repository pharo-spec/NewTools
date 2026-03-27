Class {
	#name : 'StDebuggerClientModelTest',
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
StDebuggerClientModelTest class >> benchFilterStack [
	<script>
	^self new benchmarkFilterStack inspect
]

{ #category : 'benchmarks' }
StDebuggerClientModelTest >> bench: aBlock [
	^ aBlock timeToRun asNanoSeconds
]

{ #category : 'benchmarks' }
StDebuggerClientModelTest >> benchmarkFilterStack [
	| stack1 stack2 beforeResults afterResults |
	[ self method1: 0 ]
		on: Halt
		do: [ :halt | 
			session := Process new
				           newDebugSessionNamed: 'profiling'
				           startedAt: halt signalerContext.
			stack1 := session stack.	
			stack2 := stack1 copy.		
			debugActionModel := StDebuggerClientModel new.
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
StDebuggerClientModelTest >> changeSession: aDebugSession [

	debugActionModel clear; clearDebugSession.
	session := aDebugSession.
	debugActionModel := StDebuggerClientModel on: session
]

{ #category : 'helper' }
StDebuggerClientModelTest >> emptyContextForMethod: aCompiledMethod [
	^ (Context newForMethod: aCompiledMethod)
		  initializeWith: nil
		  stackPtr: nil
		  method: aCompiledMethod
		  receiver: nil
		  sender: nil;
		  yourself
]

{ #category : 'helper' }
StDebuggerClientModelTest >> evaluateMethodWithDeadHomeBlockContext [

	self methodWithDeadBlockContext value
]

{ #category : 'helper' }
StDebuggerClientModelTest >> fileOutMethod: anObject [
	result := anObject
]

{ #category : 'helper' }
StDebuggerClientModelTest >> implementMethodForDNUOrSelectorException: e [

	debugActionModel clear.
	debugger ifNotNil: [ debugger clear ].
	session ifNotNil: [ session clear ].

	session := StTestDebuggerProvider new
		           sessionFor: e signalerContext
		           exception: e; session.
	debugActionModel := StDebuggerClientModel basicNew
		                    session: session;
		                    yourself.

	debugActionModel implementMissingMethod
]

{ #category : 'helper' }
StDebuggerClientModelTest >> method1: i [
	^self method2: i+1
]

{ #category : 'helper' }
StDebuggerClientModelTest >> method2: i [
	<haltOrBreakpointForTesting>
	i = 9999 ifTrue: [ self halt. ^i ].
	^self method1: i+1
]

{ #category : 'helper' }
StDebuggerClientModelTest >> methodClass [
	^self
]

{ #category : 'helper' }
StDebuggerClientModelTest >> methodWithBlockContext [

	| block |
	block := [ (1+1 ) printString ].
	block value
]

{ #category : 'helper' }
StDebuggerClientModelTest >> methodWithDeadBlockContext [

	^ [ (1 + 1) printString ]
]

{ #category : 'helper' }
StDebuggerClientModelTest >> methodWithPragma [
	<debuggerCompleteToSender>
]

{ #category : 'helper' }
StDebuggerClientModelTest >> newSessionWithBlockContext [

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
StDebuggerClientModelTest >> newSessionWithDeadHomeBlockContext [

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
StDebuggerClientModelTest >> resetModifiedSourceCode [

	methodWithBlockContextOriginalSource ifNotNil: [
		self class compile: methodWithBlockContextOriginalSource ].
	setResultOriginalSourceCode ifNotNil: [
		self class compile: setResultOriginalSourceCode ]
]

{ #category : 'helper' }
StDebuggerClientModelTest >> session [
	^debugger session
]

{ #category : 'helper' }
StDebuggerClientModelTest >> setResult [
	result := 2 squared.
	^result
]

{ #category : 'running' }
StDebuggerClientModelTest >> setSessionAndDebuggerModelForMethod: aMethod inContext: aContext [

	| dummyActionModel |
	session ifNotNil: [ session clear ].
	dummyActionModel := (StTestDebuggerProvider new debuggerWithContext:
		                     aContext) debuggerClientModel.
	session := dummyActionModel session.
	dummyActionModel clear.
	session stepIntoUntil: [ :currentContext |
		currentContext method == aMethod ].
	debugActionModel := StDebuggerClientModel on: session.
	shouldFilterStack := StDebuggerClientModel shouldFilterStack
]

{ #category : 'running' }
StDebuggerClientModelTest >> setUp [

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
StDebuggerClientModelTest >> tearDown [
	debugActionModel clear.
	debugger ifNotNil: [ debugger clear].
	session ifNotNil: [ session clear ].
	session := nil.
	(StDebuggerUsingSpecSelectorMock includesSelector: #testMethod)
		ifTrue: [ StDebuggerUsingSpecSelectorMock removeSelector: #testMethod ].
	(StDebuggerUsingSpecSelectorMock includesSelector: #method)
		ifTrue: [ StDebuggerUsingSpecSelectorMock removeSelector: #method ].
	(StDebuggerUsingSpecSelectorMock includesSelector: #unclassifiedMethod)
		ifTrue: [ StDebuggerUsingSpecSelectorMock removeSelector: #unclassifiedMethod ].

	(StTestDebuggerProvider includesSelector: #buildDebuggerWithMissingClassContext)
		ifTrue: [ StTestDebuggerProvider removeSelector: #buildDebuggerWithMissingClassContext ].
	(StTestDebuggerProvider includesSelector: #foobar)
		ifTrue: [ StTestDebuggerProvider removeSelector: #foobar ].

	StDebuggerClientModel shouldFilterStack: shouldFilterStack.
	DebugSession contextModelClass: DebugContext.
	self resetModifiedSourceCode.
	super tearDown
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testClearDebugSession [
	| process |
	process := session interruptedProcess.
	self deny: process isTerminated.
	debugActionModel clearDebugSession.
	self assert: process isTerminated.
	self assert: session interruptedContext isNil
]

{ #category : 'tests - contexts' }
StDebuggerClientModelTest >> testComputeInitialTopContext [

	| newSession dummyActionModel |
	self flag:
		'We suspect this test to make the production CI fail so we skip it for now'.
	self skip.
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContext
		                    debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self
		assert: debugActionModel topContext
		identicalTo: session exception signalContext.

	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContext
		                    debuggerClientModel.
	newSession := dummyActionModel session.
	dummyActionModel clear.
	newSession restart: newSession interruptedContext sender.
	self changeSession: newSession.
	self
		assert: debugActionModel topContext
		identicalTo: session interruptedContext
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testCopyStackToClipboard [

	debugActionModel copyStackToClipboard.
	self assert: Clipboard clipboardText string equals: session interruptedContext stackTraceString
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testCreateMissingMethod [
]

{ #category : 'tests - stack filtering' }
StDebuggerClientModelTest >> testDefaultShouldFilterStack [

	self assert: StDebuggerClientModel shouldFilterStack
]

{ #category : 'tests - stack filtering' }
StDebuggerClientModelTest >> testDynamicShouldFilterStack [

	| mockDebugActionModel |
	mockDebugActionModel := StMockDebuggerClientModel new.

	self assert: mockDebugActionModel filterStack.

	StDebuggerClientModel shouldFilterStack: true.
	self assert: mockDebugActionModel shouldFilterStack.

	StDebuggerClientModel shouldFilterStack: false.
	self deny: mockDebugActionModel shouldFilterStack.

	mockDebugActionModel
		clear;
		clearDebugSession
]

{ #category : 'tests - stack filtering' }
StDebuggerClientModelTest >> testDynamicShouldFilterStackUpdate [

	|mockDebugActionModel context|
	mockDebugActionModel := StMockDebuggerClientModel new.		
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
	
	mockDebugActionModel := StMockDebuggerClientModel new.		
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
StDebuggerClientModelTest >> testEventAfterClear [

	| dummyActionModel dummyDebugger |
	dummyDebugger := StDummyDebuggerPresenter new.

	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext
		                    debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.

	debugActionModel
		when: StDebuggerClientModelClearAnnouncement
		send: #tag:
		to: dummyDebugger.

	self assert: dummyDebugger tag isNil.

	debugActionModel clear.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelClearAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterMethodAdded [

	| dummyActionModel dummyDebugger |
	dummyDebugger := StDummyDebuggerPresenter new.

	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext
		                    debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.

	debugActionModel
		when: StDebuggeClientModelMethodAddedAnnouncement
		send: #tag:
		to: dummyDebugger.

	self assert: dummyDebugger tag isNil.

	StTestDebuggerProvider compile: 'foobar ^self'.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggeClientModelMethodAddedAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterProceed [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to restart events"
	debugActionModel
		when: StDebuggerClientModelResumeAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel proceedDebugSession.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelResumeAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterRecompileMethod [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	setResultOriginalSourceCode := ctx method sourceCode.
	dummyDebugger := StDummyDebuggerPresenter new.

	debugActionModel session stepIntoUntil: [ :currentContext |
		currentContext selector = #squared ].

	"We subscribe dummy debugger to debug action model to recompilation events"
	debugActionModel
		when: StDebuggerClientModelContextChangedAnnouncement
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
		identicalTo: StDebuggerClientModelContextChangedAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterRestart [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	debugActionModel
		stepOver: ctx;
		stepOver: ctx.

	"We subscribe dummy debugger to debug action model to restart events"
	debugActionModel
		when: StDebuggerClientModelRestartAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel restartContext: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelRestartAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterStepInto [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerClientModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepInto: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterStepOver [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerClientModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepOver: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testEventAfterStepThrough [

	| ctx dummyDebugger |
	ctx := session interruptedContext.
	dummyDebugger := StDummyDebuggerPresenter new.

	"We subscribe dummy debugger to debug action model to step events"
	debugActionModel
		when: StDebuggerClientModelStepAnnouncement
		send: #tag:
		to: dummyDebugger.
	self assert: dummyDebugger tag isNil.

	debugActionModel stepThrough: ctx.

	self deny: dummyDebugger tag isNil.
	self
		assert: dummyDebugger tag class
		identicalTo: StDebuggerClientModelStepAnnouncement.
	self
		assert: dummyDebugger tag debuggerClientModel
		identicalTo: debugActionModel
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testExceptionProvidesSameExceptionAsTheSessionOne [

	self
		assert: debugActionModel exception
		equals: debugActionModel session exception
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testFileOutMethod [
	debugActionModel fileOutMethod: self.
	self assert: result equals: self selector
]

{ #category : 'tests - stack filtering' }
StDebuggerClientModelTest >> testFilterDNUStack [

	|stack filteredStack dummyActionModel dnuContext dnuStack |
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	stack := OrderedCollection new.
	
	"First, the stack contains a top context (i.e. from which a signal was sent), then the interrupted context"
	stack add: debugActionModel topContext.
	
	"Second, the stack contexts are all contexts existing from a DNU send, that  should be marked with the <debuggerCompleteToSender> pragma, up to the signal of the MNU exception.
	
	The code below builds this *substack* in a robust way that is independent of the number of contexts"
	dnuContext := debugActionModel interruptedContext findContextSuchThat: [ :c | c method selector = #doesNotUnderstand: ].
	dnuStack := debugActionModel interruptedContext copyTo: dnuContext sender.
	dnuStack stack do: [ :e | stack add: e ].
	
	"Then we have an imaginary call stack"
	stack add: (self emptyContextForMethod: (self class>>#method1:)).
	stack add: (self emptyContextForMethod: (self class>>#method2:)).
	
	filteredStack := debugActionModel filterStack: stack copy.

	self assert: filteredStack size equals: 2.
	self assert: filteredStack first identicalTo: (stack last: 2) first.
	self assert: filteredStack second identicalTo: stack last
	
]

{ #category : 'tests - stack filtering' }
StDebuggerClientModelTest >> testFilterMissingSubclassResponsibilityStack [

	|stack filteredStack dummyActionModel|	
	
	"We change the stack with an interrupted context that does not contain the <debuggerCompleteToSender> pragma"
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerClientModel.
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
StDebuggerClientModelTest >> testFilterStack [

	|stack filteredStack dummyActionModel dnuContext dnuStack |
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	stack := OrderedCollection new.
	
	"Second, the stack contexts are all contexts existing from a DNU send, that  should be marked with the <debuggerCompleteToSender> pragma, up to the signal of the MNU exception.
	
	The code below builds this *substack* in a robust way that is independent of the number of contexts"
	dnuContext := debugActionModel interruptedContext findContextSuchThat: [ :c | c method selector = #doesNotUnderstand: ].
	dnuStack := debugActionModel interruptedContext copyTo: dnuContext sender.
	dnuStack stack do: [ :e | stack add: e ].
	
	"Then we have an imaginary call stack"
	stack add: (self emptyContextForMethod: (self class>>#method1:)).
	stack add: (self emptyContextForMethod: (self class>>#method2:)).
	
	
	StDebuggerClientModel shouldFilterStack: false.
	filteredStack := debugActionModel filterStack: stack copy.
	self assertCollection:  filteredStack equals: stack.
	
	StDebuggerClientModel shouldFilterStack: true.
	filteredStack := debugActionModel filterStack: stack copy.
	self assert: filteredStack size equals: 2.
	self assert: filteredStack first identicalTo: (stack last: 2) first.
	self assert: filteredStack second identicalTo: stack last
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testImplementInClassForContext [
	|method|
	method := (StDebuggerUsingSpecSelectorMock lookupSelector: #method).
	self assert:	method equals: nil.
	[ StDebuggerUsingSpecSelectorMock new method ]
		on: Error
		do: [ :dnu |
			self implementMethodForDNUOrSelectorException: dnu ].
	method := (StDebuggerUsingSpecSelectorMock lookupSelector: #method).
	self deny: method	equals: nil.
	self assert: method methodClass identicalTo: StDebuggerUsingSpecSelectorMock
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testImplementMethodClassification [

	<ignoreNotImplementedSelectors: #( unclassifiedMethod )>
	| method |
	[ StDebuggerUsingSpecSelectorMock new method ]
		on: Error
		do: [ :dnu | self implementMethodForDNUOrSelectorException: dnu ].

	[ StDebuggerUsingSpecSelectorMock new testMethod ]
		on: Error
		do: [ :dnu | self implementMethodForDNUOrSelectorException: dnu ].

	[ StDebuggerUsingSpecSelectorMock new unclassifiedMethod ]
		on: Error
		do: [ :dnu | self implementMethodForDNUOrSelectorException: dnu].

	method := StDebuggerUsingSpecSelectorMock lookupSelector: #method.
	self assert: method protocolName equals: 'accessing'.

	method := StDebuggerUsingSpecSelectorMock lookupSelector: #testMethod.
	self assert: method protocolName equals: 'tests'.

	method := StDebuggerUsingSpecSelectorMock lookupSelector:
		          #unclassifiedMethod.
	self deny: method isClassified
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testInitialization [
	self assert: debugActionModel session identicalTo: session.
	self
		assert: debugActionModel interruptedContext
		identicalTo: session interruptedContext
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testInterruptedContextProvidesSameContextAsTheSessionOne [

	self assert: debugActionModel interruptedContext equals: debugActionModel session interruptedContext 
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testInterruptedProcessProvidesSameProcessAsTheSessionOne [

	self
		assert: debugActionModel interruptedProcess
		equals: debugActionModel session interruptedProcess
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsContextAnAssertionFailure [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithFailingAssertionContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isContextAnAssertionFailure
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsContextSteppable [
	self assert: debugActionModel isContextSteppable
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextAnAssertEqualsFailure [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithFailingAssertionContext debuggerClientModel.
	self changeSession:
		dummyActionModel
			session.
	dummyActionModel clear.
	self assert: debugActionModel isContextAnAssertionFailure
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextDead [
	session interruptedContext pc: nil.
	self assert: debugActionModel isInterruptedContextDead
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextDoesNotUnderstand [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithDNUContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextDoesNotUnderstand.
	StTestDebuggerProvider compile: 'foobar ^self'.
	self deny: debugActionModel isInterruptedContextDoesNotUnderstand
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextMissingClassException [
	| dummyActionModel |
	StTestDebuggerProvider compileMissingClassContextBuilder.
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingClassContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextMissingClassException
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextPostMortem [
	session resume.
	self assert: debugActionModel isInterruptedContextPostMortem
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextSubclassResponsibilityException [
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert: debugActionModel isInterruptedContextSubclassResponsibilityException
]

{ #category : 'tests - predicates' }
StDebuggerClientModelTest >> testIsInterruptedContextSubclassResponsibilityExceptionWithSteps [

	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithMissingSubclassResponsibilityContextWithSteps
		                    debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self assert:
		debugActionModel isInterruptedContextSubclassResponsibilityException
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testPeelToFirstLike [

	| firstCaller dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithRecursiveContext debuggerClientModel.
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
StDebuggerClientModelTest >> testProceedDebugSession [
	self deny: session interruptedContext isNil.
	self assert: result isNil.
	debugActionModel proceedDebugSession.
	self assert: session interruptedContext isNil.
	self assert: result equals: 4
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testRecompileMethodToInBlockContextWithDeadHome [

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
StDebuggerClientModelTest >> testRecompileMethodToInBlockContextWithDeadHomeRemainsInOldBlock [

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
StDebuggerClientModelTest >> testRecompileMethodToInBlockContextWithDeadHomeTwice [

	| contextChanged |
	DebugSession contextModelClass: StDebugContextForTests.
	self newSessionWithDeadHomeBlockContext.
	methodWithBlockContextOriginalSource := (self class
	                                         >>
	                                         #methodWithDeadBlockContext)
		                                        sourceCode.

	contextChanged := debugActionModel topContext.

	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , ' yourself'
		inContext: contextChanged
		notifying: nil.
	debugActionModel updateTopContext.

	"The code in the embedding method should have been modified"
	self
		assert: (self class >> #methodWithDeadBlockContext) ast sourceCode
		equals: methodWithBlockContextOriginalSource , ' yourself'.

	contextChanged := debugActionModel topContext.

	"The code in the embedding method should have been modified"
	self
		assert: (self class >> #methodWithDeadBlockContext) ast sourceCode
		equals: methodWithBlockContextOriginalSource , ' yourself'.

	"recompiling the bloc a second time should save the changes"
	debugActionModel
		recompileMethodTo: contextChanged method sourceCode , ' yourself yourself'
		inContext: contextChanged
		notifying: nil.
	debugActionModel updateTopContext.

	self
		assert: (self class >> #methodWithDeadBlockContext) ast sourceCode
		equals: methodWithBlockContextOriginalSource , ' yourself yourself'
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testRecompileMethodToInContextNotifyingUpdatesSourceCodeAndContext [

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
StDebuggerClientModelTest >> testRestartContext [
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
StDebuggerClientModelTest >> testReturnValueFromExpressionFromContext [
	session stepInto.
	session stepInto.
	debugActionModel returnValueFromExpression: '0' fromContext: session interruptedContext.
	self assert: session interruptedContext top equals: 0.
	session resume.
	self assert: result equals: 0
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testRunToSelectionInContext [
	|method node|
	method := (self class >> #setResult).
	node :=  method ast statements second.
	debugActionModel runToSelection: (node start to: node stop) inContext: session interruptedContext.
	self assert: result equals: 4.
	self assert: (method sourceNodeForPC: session interruptedContext pc) identicalTo: node
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testSelectedCodeRangeForContext [

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
StDebuggerClientModelTest >> testSessionStackProvidesSameStackAsTheSessionOne [

	self assert: debugActionModel stack equals: debugActionModel session stack
]

{ #category : 'tests' }
StDebuggerClientModelTest >> testStackOfSizeWhenStackIsBigger [

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
StDebuggerClientModelTest >> testStackOfSizeWhenStackIsNotBigger [

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
StDebuggerClientModelTest >> testStepInto [
	|ctx|
	ctx := session interruptedContext.
	debugActionModel stepInto: ctx.
	self deny: ctx stepIntoQuickMethod.
	self assert: session interruptedContext sender identicalTo: ctx.
	self assert: session stack second identicalTo: ctx
]

{ #category : 'tests - actions' }
StDebuggerClientModelTest >> testStepIntoQuickMethods [
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
StDebuggerClientModelTest >> testStepOver [
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
StDebuggerClientModelTest >> testStepThrough [
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
StDebuggerClientModelTest >> testUpdateDebugSession [

	| exception dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new
		                    debuggerWithErrorContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	exception := session exception.
	session exception: nil.
	debugActionModel updateDebugSession.
	self assert: session exception isNotNil.
	self assert: session exception identicalTo: exception
]

{ #category : 'tests - contexts' }
StDebuggerClientModelTest >> testUpdateTopContext [
	
	| dummyActionModel |
	dummyActionModel := StTestDebuggerProvider new debuggerWithMissingSubclassResponsibilityContext debuggerClientModel.
	self changeSession: dummyActionModel session.
	dummyActionModel clear.
	self deny: debugActionModel topContext identicalTo: debugActionModel interruptedContext.
	debugActionModel updateTopContext.		
	self assert: debugActionModel topContext identicalTo: debugActionModel interruptedContext
	
	
	
]

{ #category : 'tests - contexts' }
StDebuggerClientModelTest >> testUpdateTopContextAfterSessionOperation [

	| mockDebugActionModel context |
	context := [  ] asContext.
	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel stepInto: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel stepOver: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel stepThrough: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel restartContext: context.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel
		returnValueFromExpression: 'nil'
		fromContext: [  ] asContext.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel runToSelection: nil inContext: StMockContext new.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession.

	mockDebugActionModel := StMockDebuggerClientModel new.
	mockDebugActionModel session: StMockSession new.
	
	mockDebugActionModel implementMissingMethod.
	self assert: mockDebugActionModel tag equals: #updateTopContext.
	mockDebugActionModel
		clear;
		clearDebugSession
]
