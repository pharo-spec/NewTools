"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : #StDebuggerActionModel,
	#superclass : #Object,
	#instVars : [
		'session',
		'contextPredicate',
		'topContext',
		'filterStack',
		'updateEventListeners',
		'preventUpdate'
	],
	#classVars : [
		'ShouldFilterStack'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerActionModel class >> on: aDebugSession [

	^ self basicNew
		  session: aDebugSession;
		  initialize
]

{ #category : #asserting }
StDebuggerActionModel class >> shouldFilterStack [
	^ShouldFilterStack ifNil:[ShouldFilterStack := true]
]

{ #category : #asserting }
StDebuggerActionModel class >> shouldFilterStack: aBoolean [
	ShouldFilterStack := aBoolean
]

{ #category : #settings }
StDebuggerActionModel class >> shouldFilterStackSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #shouldFilterStack)
		label: 'Filter the debugger stack';
		target: self;
		default: true;
		parent: #debugging;
		description: 'Defines if methods with pragma #debuggerCompleteToSender are filtered (hidden) in the debugger stack'
]

{ #category : #adding }
StDebuggerActionModel >> addUpdateEventListener: aBlock [

	updateEventListeners add: aBlock
]

{ #category : #'debug - session' }
StDebuggerActionModel >> autoClassifyMessage: aMessage inClass: aClass [

	| method |
	method := aClass lookupSelector: aMessage selector.
	method protocol = Protocol unclassified ifTrue: [ 
		MethodClassifier classify: method ]
]

{ #category : #accessing }
StDebuggerActionModel >> clear [

	self unsubscribeFromSystemAnnouncer.
	self removeActionsForSession: self session.
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> clearDebugSession [
	contextPredicate := nil.
	self session terminate; clear
]

{ #category : #context }
StDebuggerActionModel >> computeInitialTopContext [

	topContext := session exception signalContext.
	topContext ifNil: [ 
		topContext := self interruptedContext.
		^ self ].
	(topContext hasContext: self interruptedContext) ifFalse: [ 
		topContext := self interruptedContext ]
]

{ #category : #accessing }
StDebuggerActionModel >> contextPredicate [

	^ contextPredicate ifNil: [ 
		  contextPredicate := self updateContextPredicateFor:
			                      self topContext ]
]

{ #category : #context }
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

{ #category : #'debug - predicates' }
StDebuggerActionModel >> contextSignalsAnException: aContext [

	^ aContext notNil 
		and: [ (aContext receiver isKindOf: Exception) 
		and: [  aContext selector = #signal ] ]
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> copyStackToClipboard [
	Clipboard
		clipboardText:
			(String
				streamContents: [ :s | self interruptedContext shortDebugStackOn: s ])
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> fileOutMethod: aMethod [
	aMethod methodClass fileOutMethod: aMethod selector
]

{ #category : #accessing }
StDebuggerActionModel >> filterStack [
	^ filterStack
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> filterStack: aStack [
	| context contextsToReject |	
	self shouldFilterStack ifFalse: [  ^aStack ].
	context := aStack first.
	contextsToReject := 0.

	[ 
	context notNil and: [ context ~~ self referenceContext  ] ] 
		whileTrue: [ 
			contextsToReject := contextsToReject + 1.
			context := context sender ].
	[ 
	context notNil and: [ 
		context method hasPragmaNamed: #debuggerCompleteToSender ] ] 
		whileTrue: [ 
			contextsToReject := contextsToReject + 1.
			context := context sender ].
	contextsToReject timesRepeat: [ aStack removeFirst ].
	^ aStack
]

{ #category : #'debug - session' }
StDebuggerActionModel >> implement: aMessage classified: messageCategory inClass: aClass forContext: aContext [

	self session
		implement: aMessage
		classified: messageCategory
		inClass: aClass
		forContext: aContext.
	self autoClassifyMessage: aMessage inClass: aClass.
	self updateTopContext
]

{ #category : #initialize }
StDebuggerActionModel >> initialize [
	super initialize.
	self computeInitialTopContext.
	self subscribeToMethodAddedAnnouncement.
	filterStack := true.
	updateEventListeners := OrderedCollection new.
	"flag that will prevent any update as long as it is set"
	preventUpdate := false
]

{ #category : #accessing }
StDebuggerActionModel >> interruptedContext [
	^self session interruptedContext
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isContextAnAssertionFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : #context }
StDebuggerActionModel >> isContextPostMortem: aContext [

	aContext == topContext ifFalse: [ 
		^ self session isContextPostMortem: aContext ].

	"If the context is top context, we work on the interrupted context.
	The top context is not visible from the session"
	^ self session isContextPostMortem: self interruptedContext
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isContextSteppable [

	self interruptedContext ifNil: [ ^ false ].
	^ self contextPredicate isSteppable
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextAnAssertEqualsFailure [

	^ self contextPredicate isContextAnAssertionFailure
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextDead [
	^ self contextPredicate isContextDead
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextDoesNotUnderstand [
	^self contextPredicate isContextDoesNotUnderstand

]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextMissingClassException [

	^ self contextPredicate isContextMissingClassException
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextPostMortem [
	^ self contextPredicate isContextPostMortem
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextSubclassResponsibilityException [
	^ self contextPredicate isContextSubclassResponsibilityException
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> peelToFirstLike: aContext [
	self session peelToFirstLike: aContext.
	self updateTopContext
]

{ #category : #context }
StDebuggerActionModel >> predicateFor: aContext exception: exception postMortem: isContextPostMortem [

	^ (StDebuggerErrorContextPredicate context: aContext)
		  exception: exception;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : #context }
StDebuggerActionModel >> predicateFor: aContext failure: testFailure postMortem: isContextPostMortem [

	^ (StDebuggerTestFailureContextPredicate context: aContext)
		  failure: testFailure;
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : #context }
StDebuggerActionModel >> predicateFor: aContext postMortem: isContextPostMortem [

	^ (StDebuggerContextPredicate context: aContext)
		  postMortem: isContextPostMortem;
		  yourself
]

{ #category : #'as yet unclassified' }
StDebuggerActionModel >> preventUpdatesDuring: aBlock [

	"Sets the prevent update flag during the execution of a block. Restores its value after the block 	finishes"

	| oldEventFlag |
	oldEventFlag := preventUpdate.
	preventUpdate := true.
	[ 
	aBlock value.
	self update ] ensure: [ preventUpdate := oldEventFlag ]
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> proceedDebugSession [

	contextPredicate := nil.
	self session
		resume;
		clear
]

{ #category : #'as yet unclassified' }
StDebuggerActionModel >> raiseUpdateEvents [

	updateEventListeners do: [ :each | each value ]
]

{ #category : #context }
StDebuggerActionModel >> referenceContext [
	"The reference context is the context that we wish to see in the debugger's stack.
	It it either the interrupted context if we are in a non-exception case,
	or the exception's signaler context in all other cases."
	self contextPredicate contextSignalsException ifFalse:[^self interruptedContext].
	^topContext receiver signalerContext 
]

{ #category : #'as yet unclassified' }
StDebuggerActionModel >> registerActionsForSession: aSession [
	self flag: 'Rewrite it'.
	aSession
		ifNotNil: [ aSession
				when: #restart send: #updateIfAble to: self;
				when: #resume send: #updateIfAble to: self;
				when: #stepInto send: #updateIfAble to: self;
				when: #stepOver send: #updateIfAble to: self;
				when: #stepThrough send: #updateIfAble to: self;
				when: #contextChanged send: #updateIfAble to: self ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #'debug - execution' }
StDebuggerActionModel >> restartContext: aContext [
	self session restart: aContext.
	self updateTopContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> returnValueFromExpression: aString fromContext: aContext [
	| value |
	value := session class compiler
		source: aString;
		context: aContext;
		receiver: aContext receiver;
		evaluate.
	self session returnValue: value from: aContext.
	self updateTopContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> runToSelection: aSelectionInterval inContext: aContext [
	self session runToSelection: aSelectionInterval inContext: aContext.
	self updateTopContext
]

{ #category : #accessing }
StDebuggerActionModel >> session [
	^session
]

{ #category : #accessing }
StDebuggerActionModel >> session: aDebugSession [
	session ifNotNil: [ self removeActionsForSession: session ].
	session := aDebugSession.
	self registerActionsForSession: self session.

	self updateIfAble
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> shouldFilterStack [

	^ self filterStack and: [ self class shouldFilterStack ]
]

{ #category : #context }
StDebuggerActionModel >> statusStringForContext [

	^ self contextPredicate printDescription
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepInto: aContext [ 
	filterStack := false.
	aContext stepIntoQuickMethod: true.
	self session stepInto: aContext.
	aContext stepIntoQuickMethod: false.
	self updateTopContext.

]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepOver: aContext [
	filterStack := (self topContext method hasPragmaNamed:
		                #debuggerCompleteToSender)
		               ifTrue: [ false ]
		               ifFalse: [ self class shouldFilterStack ].
	self session stepOver: aContext.
	self updateTopContext
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepThrough: aContext [
	self session stepThrough: aContext.
	self updateTopContext
]

{ #category : #'system subscription' }
StDebuggerActionModel >> subscribeToMethodAddedAnnouncement [

	SystemAnnouncer uniqueInstance weak
		when: MethodAdded
		send: #updateAfterMethodAdded
		to: self
]

{ #category : #accessing }
StDebuggerActionModel >> topContext [
	^ topContext
]

{ #category : #'system subscription' }
StDebuggerActionModel >> unsubscribeFromSystemAnnouncer [

	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #accessing }
StDebuggerActionModel >> update [

	self updateTopContext.
	self updateContextPredicate.
	self updateDebugSession.

	self raiseUpdateEvents
]

{ #category : #'updating - widgets' }
StDebuggerActionModel >> updateAfterMethodAdded [

	self updateContextPredicate.
	self raiseUpdateEvents 
]

{ #category : #context }
StDebuggerActionModel >> updateContextPredicate [
	^self updateContextPredicateFor: self topContext
]

{ #category : #context }
StDebuggerActionModel >> updateContextPredicateFor: aContext [    
	contextPredicate := self contextPredicateFor: aContext.
	^contextPredicate
]

{ #category : #'debug - session' }
StDebuggerActionModel >> updateDebugSession [
	self contextPredicate updateSessionForModel: self 
		
]

{ #category : #'debug - session' }
StDebuggerActionModel >> updateDebugSessionException: e [

	self session exception: e
]

{ #category : #accessing }
StDebuggerActionModel >> updateIfAble [

	preventUpdate ifNil: [ ^ self ].
	preventUpdate ifFalse: [ self update ]
]

{ #category : #context }
StDebuggerActionModel >> updateTopContext [

	topContext := self interruptedContext
]
