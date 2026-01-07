"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : 'StDebuggerClientModel',
	#superclass : 'Object',
	#instVars : [
		'session',
		'contextPredicate',
		'topContext',
		'filterStack',
		'preventUpdate',
		'announcer'
	],
	#classVars : [
		'ShouldFilterStack'
	],
	#category : 'NewTools-Debugger-Model',
	#package : 'NewTools-Debugger',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StDebuggerClientModel class >> on: aDebugSession [

	^ self basicNew
		  session: aDebugSession;
		  initialize
]

{ #category : 'asserting' }
StDebuggerClientModel class >> shouldFilterStack [
	^ShouldFilterStack ifNil:[ShouldFilterStack := true]
]

{ #category : 'asserting' }
StDebuggerClientModel class >> shouldFilterStack: aBoolean [
	ShouldFilterStack := aBoolean
]

{ #category : 'settings' }
StDebuggerClientModel class >> shouldFilterStackSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #shouldFilterStack)
		label: 'Filter the debugger stack';
		target: self;
		default: true;
		parent: #debugging;
		description: 'Defines if methods with pragma #debuggerCompleteToSender are filtered (hidden) in the debugger stack'
]

{ #category : 'accessing' }
StDebuggerClientModel >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'actions' }
StDebuggerClientModel >> breakOnStackAtSelection: anInterval inContext: aContext [

	| currentMethod astNode allContextsForCurrentMethod newMethod |
	currentMethod := aContext homeMethod.
	astNode := currentMethod ast bestNodeFor: anInterval.
	DebugPointManager installNew: BreakDebugPoint on: astNode.
	newMethod := aContext methodClass >> aContext selector.
	allContextsForCurrentMethod := self interruptedProcess
		                               findContextsForMethod: currentMethod.
	allContextsForCurrentMethod do: [ :ctx | ctx method: newMethod ].

	self updateContextChanged
]

{ #category : 'actions' }
StDebuggerClientModel >> clear [

	self unsubscribeFromSystemAnnouncer.
	self removeActionsForSession: self session.
	self raiseUpdateEvents:
		(StDebuggerClientModelClearAnnouncement debuggerClientModel: self).
	announcer := nil
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> clearDebugSession [

	contextPredicate := nil.
	self session
		terminate;
		clear
]

{ #category : 'context' }
StDebuggerClientModel >> computeInitialTopContext [

	topContext := session exception signalContext.
	topContext ifNil: [ 
		topContext := self interruptedContext.
		^ self ].
	(topContext hasContext: self interruptedContext) ifFalse: [ 
		topContext := self interruptedContext ]
]

{ #category : 'accessing' }
StDebuggerClientModel >> contextPredicate [

	^ contextPredicate ifNil: [ 
		  contextPredicate := self updateContextPredicateFor:
			                      self topContext ]
]

{ #category : 'context' }
StDebuggerClientModel >> contextPredicateFor: aContext [

	| postMortem ex |
	postMortem := self isContextPostMortem: aContext.

	(self contextSignalsAnException: aContext) ifFalse: [ 
		^ self predicateFor: aContext postMortem: postMortem ].

	ex := aContext receiver.
	(ex isKindOf: TestFailure) ifTrue: [ 
		^ self predicateFor: aContext failure: ex postMortem: postMortem ].

	^ self predicateFor: aContext exception: ex postMortem: postMortem
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> contextSignalsAnException: aContext [

	^ aContext isNotNil 
		and: [ (aContext receiver isKindOf: Exception) 
		and: [  aContext selector = #signal ] ]
]

{ #category : 'debug - stack' }
StDebuggerClientModel >> copyStackToClipboard [
	Clipboard
		clipboardText:
			(String
				streamContents: [ :s | self interruptedContext printDebugStackOn: s ])
]

{ #category : 'stack - helpers' }
StDebuggerClientModel >> exception [
	^ self session exception
]

{ #category : 'debug - stack' }
StDebuggerClientModel >> fileOutMethod: aMethod [
	aMethod methodClass fileOutMethod: aMethod selector
]

{ #category : 'accessing' }
StDebuggerClientModel >> filterStack [
	^ filterStack
]

{ #category : 'debug - stack' }
StDebuggerClientModel >> filterStack: aStack [
	| context contextsToReject |	
	self shouldFilterStack ifFalse: [  ^aStack ].
	context := aStack first.
	contextsToReject := 0.

	[ 
	context isNotNil and: [ context ~~ self referenceContext  ] ] 
		whileTrue: [ 
			contextsToReject := contextsToReject + 1.
			context := context sender ].
	[ 
	context isNotNil and: [ 
		context method hasPragmaNamed: #debuggerCompleteToSender ] ] 
		whileTrue: [ 
			contextsToReject := contextsToReject + 1.
			context := context sender ].
	contextsToReject timesRepeat: [ aStack removeFirst ].
	^ aStack
]

{ #category : 'actions' }
StDebuggerClientModel >> implementMissingMethod [

	(StDebuggerMethodImplementor forSession: self session) implementMissingMethod.
	self updateTopContext
]

{ #category : 'initialization' }
StDebuggerClientModel >> initialize [
	super initialize.
	self computeInitialTopContext.
	self subscribeToMethodAddedAnnouncement.
	filterStack := true.
	"flag that will prevent any update as long as it is set"
	preventUpdate := false
]

{ #category : 'accessing' }
StDebuggerClientModel >> interruptedContext [
	^self session interruptedContext
]

{ #category : 'accessing' }
StDebuggerClientModel >> interruptedProcess [
	^ self session interruptedProcess
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isContextAnAssertionFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : 'context' }
StDebuggerClientModel >> isContextPostMortem: aContext [

	aContext == topContext ifFalse: [ 
		^ self session isContextPostMortem: aContext ].

	"If the context is top context, we work on the interrupted context.
	The top context is not visible from the session"
	^ self session isContextPostMortem: self interruptedContext
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isContextSteppable [

	self interruptedContext ifNil: [ ^ false ].
	^ self contextPredicate isSteppable
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextAnAssertEqualsFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextDead [
	^ self contextPredicate isContextDead
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextDoesNotUnderstand [
	^self contextPredicate isContextDoesNotUnderstand

]

{ #category : 'testing' }
StDebuggerClientModel >> isInterruptedContextGeneratingCode [

	^ self contextPredicate isGeneratingCode
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextMissingClassException [

	^ self contextPredicate isContextMissingClassException
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextPostMortem [
	^ self contextPredicate isContextPostMortem
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextShouldBeImplemented [
	^ self contextPredicate isInterruptedContextShouldBeImplemented
]

{ #category : 'debug - predicates' }
StDebuggerClientModel >> isInterruptedContextSubclassResponsibilityException [
	^ self contextPredicate isContextSubclassResponsibilityException
]

{ #category : 'instance creation' }
StDebuggerClientModel >> newStepAnnouncement [

	^ (StDebuggerClientModelStepAnnouncement debuggerClientModel: self)
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> peelToFirstLike: aContext [
	self session peelToFirstLike: aContext.
	self updateTopContext
]

{ #category : 'context' }
StDebuggerClientModel >> predicateFor: aContext exception: exception postMortem: isContextPostMortem [

	^ (StDebuggerErrorContextPredicate context: aContext)
		  exception: exception;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'context' }
StDebuggerClientModel >> predicateFor: aContext failure: testFailure postMortem: isContextPostMortem [

	^ (StDebuggerTestFailureContextPredicate context: aContext)
		  failure: testFailure;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'context' }
StDebuggerClientModel >> predicateFor: aContext postMortem: isContextPostMortem [

	^ (StDebuggerContextPredicate context: aContext)
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'updating' }
StDebuggerClientModel >> preventUpdatesDuring: aBlock [

	"Sets the prevent update flag during the execution of a block. Restores its value after the block 	finishes"

	| oldEventFlag |
	oldEventFlag := preventUpdate.
	preventUpdate := true.
	[ 
	aBlock value.
	self update ] ensure: [ preventUpdate := oldEventFlag ]
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> proceedDebugSession [

	contextPredicate := nil.
	self session
		resume;
		clear
]

{ #category : 'events-triggering' }
StDebuggerClientModel >> raiseUpdateEvents: anAnnouncement [

	self announcer announce: anAnnouncement
]

{ #category : 'actions' }
StDebuggerClientModel >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	| methodContext homePC |
	aContext ifNil: [ ^ self ].
	"Get the home before to recompile the method, we can lost it (for clean blocks)"
	methodContext := aContext home.

	self session
		recompileMethodTo: aString
		inContext: aContext
		notifying: aNotifyer.

	homePC := methodContext isDead
		ifTrue: [ methodContext endPC ]
		ifFalse: [ methodContext pc ]
]

{ #category : 'context' }
StDebuggerClientModel >> referenceContext [
	"The reference context is the context that we wish to see in the debugger's stack.
	It it either the interrupted context if we are in a non-exception case,
	or the exception's signaler context in all other cases."
	self contextPredicate contextSignalsException ifFalse:[^self interruptedContext].
	^topContext receiver signalerContext 
]

{ #category : 'events - handling' }
StDebuggerClientModel >> registerActionsForSession: aSession [

	self flag: 'Rewrite it'.
	aSession ifNotNil: [
		aSession
			when: #restart send: #updateRestart to: self;
			when: #resume send: #updateResume to: self;
			when: #stepInto send: #updateStep to: self;
			when: #stepOver send: #updateStep to: self;
			when: #stepThrough send: #updateStep to: self;
			when: #contextChanged send: #updateContextChanged to: self;
			when: #clear send: #clear to: self ]
]

{ #category : 'events - removing' }
StDebuggerClientModel >> removeActionsForSession: aSession [
	self flag: 'Rewrite it'.
	aSession
		ifNotNil: [ aSession
				removeActionsForEvent: #restart;
				removeActionsForEvent: #resume;
				removeActionsForEvent: #stepInto;
				removeActionsForEvent: #stepOver;
				removeActionsForEvent: #stepThrough;
				removeActionsForEvent: #contextChanged ]
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> restartContext: aContext [

	self session restart: aContext.
	self updateTopContext
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> returnValueFromExpression: aString fromContext: aContext [
	| value |
	value := session class compiler
		source: aString;
		context: aContext;
		evaluate.
	self session returnValue: value from: aContext.
	self updateTopContext
]

{ #category : 'debug - execution' }
StDebuggerClientModel >> runToSelection: aSelectionInterval inContext: aContext [

	self preventUpdatesDuring: [
		self session runToSelection: aSelectionInterval inContext: aContext ].
	self updateTopContext
]

{ #category : 'actions' }
StDebuggerClientModel >> selectedCodeRangeForContext: aContext [ 
	^ self session selectedCodeRangeForContext: aContext
]

{ #category : 'accessing' }
StDebuggerClientModel >> session [
	^session
]

{ #category : 'accessing' }
StDebuggerClientModel >> session: aDebugSession [
	session ifNotNil: [ self removeActionsForSession: session ].
	session := aDebugSession.
	self registerActionsForSession: self session.

	self updateIfAble
]

{ #category : 'debug - stack' }
StDebuggerClientModel >> shouldFilterStack [

	^ self filterStack and: [ self class shouldFilterStack ]
]

{ #category : 'accessing - variables' }
StDebuggerClientModel >> stack [
	^ self session stack
]

{ #category : 'stack - helpers' }
StDebuggerClientModel >> stackOfSize: anInteger [ 
	^ self session stackOfSize: anInteger
]

{ #category : 'context' }
StDebuggerClientModel >> statusStringForContext [

	^ self contextPredicate printDescription
]

{ #category : 'debug - stepping' }
StDebuggerClientModel >> stepInto: aContext [

	filterStack := false.
	aContext stepIntoQuickMethod: true.
	self session stepInto: aContext.
	aContext stepIntoQuickMethod: false.
	self updateTopContext
]

{ #category : 'debug - stepping' }
StDebuggerClientModel >> stepOver: aContext [

	filterStack := (self topContext method hasPragmaNamed:
		                #debuggerCompleteToSender)
		               ifTrue: [ false ]
		               ifFalse: [ self class shouldFilterStack ].
	self session stepOver: aContext.
	self updateTopContext
]

{ #category : 'debug - stepping' }
StDebuggerClientModel >> stepThrough: aContext [

	self session stepThrough: aContext.
	self updateTopContext
]

{ #category : 'system subscription' }
StDebuggerClientModel >> subscribeToMethodAddedAnnouncement [

	self class codeChangeAnnouncer weak when: MethodAdded send: #updateAfterMethodAdded to: self
]

{ #category : 'accessing' }
StDebuggerClientModel >> topContext [
	^ topContext
]

{ #category : 'removing' }
StDebuggerClientModel >> unsubscribe: anEventListener [

	self announcer unsubscribe: anEventListener
]

{ #category : 'system subscription' }
StDebuggerClientModel >> unsubscribeFromSystemAnnouncer [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'updating' }
StDebuggerClientModel >> update [

	self update:
		(StDebuggerClientModelStepAnnouncement debuggerClientModel: self)
]

{ #category : 'accessing' }
StDebuggerClientModel >> update: anAnnouncement [

	self updateTopContext.
	self updateContextPredicate.
	self updateDebugSession.

	self raiseUpdateEvents: anAnnouncement
]

{ #category : 'updating - widgets' }
StDebuggerClientModel >> updateAfterMethodAdded [

	self updateContextPredicate.
	self raiseUpdateEvents:
		(StDebuggeClientModelMethodAddedAnnouncement debuggerClientModel:
			 self)
]

{ #category : 'instance creation' }
StDebuggerClientModel >> updateContextChanged [

	self updateIfAble:
		(StDebuggerClientModelContextChangedAnnouncement
			 debuggerClientModel: self)
]

{ #category : 'context' }
StDebuggerClientModel >> updateContextPredicate [
	^self updateContextPredicateFor: self topContext
]

{ #category : 'context' }
StDebuggerClientModel >> updateContextPredicateFor: aContext [    
	contextPredicate := self contextPredicateFor: aContext.
	^contextPredicate
]

{ #category : 'debug - session' }
StDebuggerClientModel >> updateDebugSession [
	self contextPredicate updateSessionForModel: self 
		
]

{ #category : 'debug - session' }
StDebuggerClientModel >> updateDebugSessionException: e [

	self session exception: e
]

{ #category : 'accessing' }
StDebuggerClientModel >> updateIfAble [

	self updateIfAble:
		(StDebuggerClientModelStepAnnouncement debuggerClientModel: self)
]

{ #category : 'accessing' }
StDebuggerClientModel >> updateIfAble: anAnnouncement [

	preventUpdate ifNil: [ ^ self ].
	preventUpdate ifFalse: [ self update: anAnnouncement ]
]

{ #category : 'announcement' }
StDebuggerClientModel >> updateRestart [

	self updateIfAble:
		  (StDebuggerClientModelRestartAnnouncement debuggerClientModel:
			   self)
]

{ #category : 'instance creation' }
StDebuggerClientModel >> updateResume [

	self updateIfAble:
		(StDebuggerClientModelResumeAnnouncement debuggerClientModel: self)
]

{ #category : 'instance creation' }
StDebuggerClientModel >> updateStep [

	self updateIfAble:
		(StDebuggerClientModelStepAnnouncement debuggerClientModel: self)
]

{ #category : 'context' }
StDebuggerClientModel >> updateTopContext [

	topContext := self interruptedContext
]

{ #category : 'announcer' }
StDebuggerClientModel >> when: anAnnouncementClass send: aSelector to: anObject [

	self announcer weak
		when: anAnnouncementClass
		send: aSelector
		to: anObject
]
