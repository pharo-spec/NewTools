"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : 'StDebuggerActionModel',
	#superclass : 'Object',
	#instVars : [
		'session',
		'contextPredicate',
		'topContext',
		'filterStack',
		'preventUpdate',
		'previousASTScope',
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
StDebuggerActionModel class >> on: aDebugSession [

	^ self basicNew
		  session: aDebugSession;
		  initialize
]

{ #category : 'asserting' }
StDebuggerActionModel class >> shouldFilterStack [
	^ShouldFilterStack ifNil:[ShouldFilterStack := true]
]

{ #category : 'asserting' }
StDebuggerActionModel class >> shouldFilterStack: aBoolean [
	ShouldFilterStack := aBoolean
]

{ #category : 'settings' }
StDebuggerActionModel class >> shouldFilterStackSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #shouldFilterStack)
		label: 'Filter the debugger stack';
		target: self;
		default: true;
		parent: #debugging;
		description: 'Defines if methods with pragma #debuggerCompleteToSender are filtered (hidden) in the debugger stack'
]

{ #category : 'accessing' }
StDebuggerActionModel >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'actions' }
StDebuggerActionModel >> breakOnStackAtSelection: anInterval inContext: aContext [

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
StDebuggerActionModel >> clear [

	self unsubscribeFromSystemAnnouncer.
	self removeActionsForSession: self session.
	self raiseUpdateEvents:
		(StDebuggerActionModelClearAnnouncement debuggerActionModel: self).
	announcer := nil
]

{ #category : 'debug - execution' }
StDebuggerActionModel >> clearDebugSession [

	contextPredicate := nil.
	self session
		terminate;
		clear
]

{ #category : 'context' }
StDebuggerActionModel >> computeInitialTopContext [

	topContext := session exception signalContext.
	topContext ifNil: [ 
		topContext := self interruptedContext.
		^ self ].
	(topContext hasContext: self interruptedContext) ifFalse: [ 
		topContext := self interruptedContext ]
]

{ #category : 'accessing' }
StDebuggerActionModel >> contextPredicate [

	^ contextPredicate ifNil: [ 
		  contextPredicate := self updateContextPredicateFor:
			                      self topContext ]
]

{ #category : 'context' }
StDebuggerActionModel >> contextPredicateFor: aContext [

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
StDebuggerActionModel >> contextSignalsAnException: aContext [

	^ aContext isNotNil 
		and: [ (aContext receiver isKindOf: Exception) 
		and: [  aContext selector = #signal ] ]
]

{ #category : 'debug - stack' }
StDebuggerActionModel >> copyStackToClipboard [
	Clipboard
		clipboardText:
			(String
				streamContents: [ :s | self interruptedContext printDebugStackOn: s ])
]

{ #category : 'stack - helpers' }
StDebuggerActionModel >> exception [
	^ self session exception
]

{ #category : 'debug - stack' }
StDebuggerActionModel >> fileOutMethod: aMethod [
	aMethod methodClass fileOutMethod: aMethod selector
]

{ #category : 'accessing' }
StDebuggerActionModel >> filterStack [
	^ filterStack
]

{ #category : 'debug - stack' }
StDebuggerActionModel >> filterStack: aStack [
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
StDebuggerActionModel >> implementMissingMethod [

	(StDebuggerMethodImplementor forSession: self session) implementMissingMethod.
	self updateTopContext
]

{ #category : 'initialization' }
StDebuggerActionModel >> initialize [
	super initialize.
	self computeInitialTopContext.
	self subscribeToMethodAddedAnnouncement.
	filterStack := true.
	"flag that will prevent any update as long as it is set"
	preventUpdate := false
]

{ #category : 'accessing' }
StDebuggerActionModel >> interruptedContext [
	^self session interruptedContext
]

{ #category : 'accessing' }
StDebuggerActionModel >> interruptedProcess [
	^ self session interruptedProcess
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isContextAnAssertionFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : 'context' }
StDebuggerActionModel >> isContextPostMortem: aContext [

	aContext == topContext ifFalse: [ 
		^ self session isContextPostMortem: aContext ].

	"If the context is top context, we work on the interrupted context.
	The top context is not visible from the session"
	^ self session isContextPostMortem: self interruptedContext
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isContextSteppable [

	self interruptedContext ifNil: [ ^ false ].
	^ self contextPredicate isSteppable
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextAnAssertEqualsFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextDead [
	^ self contextPredicate isContextDead
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextDoesNotUnderstand [
	^self contextPredicate isContextDoesNotUnderstand

]

{ #category : 'testing' }
StDebuggerActionModel >> isInterruptedContextGeneratingCode [

	^ self contextPredicate isGeneratingCode
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextMissingClassException [

	^ self contextPredicate isContextMissingClassException
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextPostMortem [
	^ self contextPredicate isContextPostMortem
]

{ #category : 'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextSubclassResponsibilityException [
	^ self contextPredicate isContextSubclassResponsibilityException
]

{ #category : 'instance creation' }
StDebuggerActionModel >> newStepAnnouncement [

	^ (StDebuggerActionModelStepAnnouncement debuggerActionModel: self)
]

{ #category : 'debug - execution' }
StDebuggerActionModel >> peelToFirstLike: aContext [
	self session peelToFirstLike: aContext.
	self updateTopContext
]

{ #category : 'context' }
StDebuggerActionModel >> predicateFor: aContext exception: exception postMortem: isContextPostMortem [

	^ (StDebuggerErrorContextPredicate context: aContext)
		  exception: exception;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'context' }
StDebuggerActionModel >> predicateFor: aContext failure: testFailure postMortem: isContextPostMortem [

	^ (StDebuggerTestFailureContextPredicate context: aContext)
		  failure: testFailure;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'context' }
StDebuggerActionModel >> predicateFor: aContext postMortem: isContextPostMortem [

	^ (StDebuggerContextPredicate context: aContext)
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : 'updating' }
StDebuggerActionModel >> preventUpdatesDuring: aBlock [

	"Sets the prevent update flag during the execution of a block. Restores its value after the block 	finishes"

	| oldEventFlag |
	oldEventFlag := preventUpdate.
	preventUpdate := true.
	[ 
	aBlock value.
	self update ] ensure: [ preventUpdate := oldEventFlag ]
]

{ #category : 'accessing' }
StDebuggerActionModel >> previousASTScope [

	^ previousASTScope
]

{ #category : 'debug - execution' }
StDebuggerActionModel >> proceedDebugSession [

	contextPredicate := nil.
	self session
		resume;
		clear
]

{ #category : 'events-triggering' }
StDebuggerActionModel >> raiseUpdateEvents: anAnnouncement [

	self announcer announce: anAnnouncement
]

{ #category : 'actions' }
StDebuggerActionModel >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

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
		ifFalse: [ methodContext pc ].
		
	previousASTScope := (methodContext compiledCode sourceNodeForPC:
		                     homePC) scope
]

{ #category : 'context' }
StDebuggerActionModel >> referenceContext [
	"The reference context is the context that we wish to see in the debugger's stack.
	It it either the interrupted context if we are in a non-exception case,
	or the exception's signaler context in all other cases."
	self contextPredicate contextSignalsException ifFalse:[^self interruptedContext].
	^topContext receiver signalerContext 
]

{ #category : 'events - handling' }
StDebuggerActionModel >> registerActionsForSession: aSession [

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
StDebuggerActionModel >> removeActionsForSession: aSession [
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
StDebuggerActionModel >> restartContext: aContext [

	previousASTScope := (aContext compiledCode sourceNodeForPC:
		                     aContext pc) scope.
	self session restart: aContext.
	self updateTopContext
]

{ #category : 'debug - execution' }
StDebuggerActionModel >> returnValueFromExpression: aString fromContext: aContext [
	| value |
	value := session class compiler
		source: aString;
		context: aContext;
		evaluate.
	self session returnValue: value from: aContext.
	self updateTopContext
]

{ #category : 'debug - execution' }
StDebuggerActionModel >> runToSelection: aSelectionInterval inContext: aContext [

	previousASTScope := aContext sourceNodeExecuted scope.
	self preventUpdatesDuring: [
		self session runToSelection: aSelectionInterval inContext: aContext ].
	self updateTopContext
]

{ #category : 'actions' }
StDebuggerActionModel >> selectedCodeRangeForContext: aContext [ 
	^ self session selectedCodeRangeForContext: aContext
]

{ #category : 'accessing' }
StDebuggerActionModel >> session [
	^session
]

{ #category : 'accessing' }
StDebuggerActionModel >> session: aDebugSession [
	session ifNotNil: [ self removeActionsForSession: session ].
	session := aDebugSession.
  previousASTScope := aDebugSession interruptedContext
		                    sourceNodeExecuted scope.
	self registerActionsForSession: self session.

	self updateIfAble
]

{ #category : 'debug - stack' }
StDebuggerActionModel >> shouldFilterStack [

	^ self filterStack and: [ self class shouldFilterStack ]
]

{ #category : 'accessing - variables' }
StDebuggerActionModel >> stack [
	^ self session stack
]

{ #category : 'stack - helpers' }
StDebuggerActionModel >> stackOfSize: anInteger [ 
	^ self session stackOfSize: anInteger
]

{ #category : 'context' }
StDebuggerActionModel >> statusStringForContext [

	^ self contextPredicate printDescription
]

{ #category : 'debug - stepping' }
StDebuggerActionModel >> stepInto: aContext [

	previousASTScope := aContext sourceNodeExecuted scope.
	filterStack := false.
	aContext stepIntoQuickMethod: true.
	self session stepInto: aContext.
	aContext stepIntoQuickMethod: false.
	self updateTopContext
]

{ #category : 'debug - stepping' }
StDebuggerActionModel >> stepOver: aContext [

	previousASTScope := aContext sourceNodeExecuted scope.
	filterStack := (self topContext method hasPragmaNamed:
		                #debuggerCompleteToSender)
		               ifTrue: [ false ]
		               ifFalse: [ self class shouldFilterStack ].
	self session stepOver: aContext.
	self updateTopContext
]

{ #category : 'debug - stepping' }
StDebuggerActionModel >> stepThrough: aContext [

	previousASTScope := aContext sourceNodeExecuted scope.
	self session stepThrough: aContext.
	self updateTopContext
]

{ #category : 'system subscription' }
StDebuggerActionModel >> subscribeToMethodAddedAnnouncement [

	self class codeChangeAnnouncer weak when: MethodAdded send: #updateAfterMethodAdded to: self
]

{ #category : 'accessing' }
StDebuggerActionModel >> topContext [
	^ topContext
]

{ #category : 'removing' }
StDebuggerActionModel >> unsubscribe: anEventListener [

	self announcer unsubscribe: anEventListener
]

{ #category : 'system subscription' }
StDebuggerActionModel >> unsubscribeFromSystemAnnouncer [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'updating' }
StDebuggerActionModel >> update [

	self update:
		(StDebuggerActionModelStepAnnouncement debuggerActionModel: self)
]

{ #category : 'accessing' }
StDebuggerActionModel >> update: anAnnouncement [

	self updateTopContext.
	self updateContextPredicate.
	self updateDebugSession.

	self raiseUpdateEvents: anAnnouncement
]

{ #category : 'updating - widgets' }
StDebuggerActionModel >> updateAfterMethodAdded [

	self updateContextPredicate.
	self raiseUpdateEvents:
		(StDebuggerActionModelMethodAddedAnnouncement debuggerActionModel:
			 self)
]

{ #category : 'instance creation' }
StDebuggerActionModel >> updateContextChanged [

	self updateIfAble:
		(StDebuggerActionModelContextChangedAnnouncement
			 debuggerActionModel: self)
]

{ #category : 'context' }
StDebuggerActionModel >> updateContextPredicate [
	^self updateContextPredicateFor: self topContext
]

{ #category : 'context' }
StDebuggerActionModel >> updateContextPredicateFor: aContext [    
	contextPredicate := self contextPredicateFor: aContext.
	^contextPredicate
]

{ #category : 'debug - session' }
StDebuggerActionModel >> updateDebugSession [
	self contextPredicate updateSessionForModel: self 
		
]

{ #category : 'debug - session' }
StDebuggerActionModel >> updateDebugSessionException: e [

	self session exception: e
]

{ #category : 'accessing' }
StDebuggerActionModel >> updateIfAble [

	self updateIfAble:
		(StDebuggerActionModelStepAnnouncement debuggerActionModel: self)
]

{ #category : 'accessing' }
StDebuggerActionModel >> updateIfAble: anAnnouncement [

	preventUpdate ifNil: [ ^ self ].
	preventUpdate ifFalse: [ self update: anAnnouncement ]
]

{ #category : 'announcement' }
StDebuggerActionModel >> updateRestart [

	self updateIfAble:
		  (StDebuggerActionModelRestartAnnouncement debuggerActionModel:
			   self)
]

{ #category : 'instance creation' }
StDebuggerActionModel >> updateResume [

	self updateIfAble:
		(StDebuggerActionModelResumeAnnouncement debuggerActionModel: self)
]

{ #category : 'instance creation' }
StDebuggerActionModel >> updateStep [

	self updateIfAble:
		(StDebuggerActionModelStepAnnouncement debuggerActionModel: self)
]

{ #category : 'context' }
StDebuggerActionModel >> updateTopContext [

	topContext := self interruptedContext
]

{ #category : 'announcer' }
StDebuggerActionModel >> when: anAnnouncementClass send: aSelector to: anObject [

	self announcer weak
		when: anAnnouncementClass
		send: aSelector
		to: anObject
]
