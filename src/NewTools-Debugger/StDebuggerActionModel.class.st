"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : #StDebuggerActionModel,
	#superclass : #Object,
	#instVars : [
		'debugger',
		'session'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerActionModel class >> on: aDebugSession [
	^ self new session: aDebugSession
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> clearDebugSession [
	self session terminate
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

{ #category : #'debug - session' }
StDebuggerActionModel >> implement: aMessage classified: messageCategory inClass: aClass forContext: aContext [
	self session
		implement: aMessage
		classified: messageCategory
		inClass: aClass
		forContext: aContext
]

{ #category : #accessing }
StDebuggerActionModel >> interruptedContext [
	^self session interruptedContext
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isContextSteppable [
	^ (self isInterruptedContextError
		or: [ self isInterruptedContextATestFailure
				or: [ self isInterruptedContextPostMortem
						or: [ self isInterruptedContextDoesNotUnderstand
								or: [ self isInterruptedContextMissingClassException
										or: [ self isInterruptedContextSubclassResponsibilityException ] ] ] ] ])
		not
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextATestFailure [
	^ self session isInterruptedContextAnAssertionFailure 
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextDoesNotUnderstand [
	^self session isInterruptedContextDoesNotUnderstand
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextError [
	^ (self session interruptedContext temporaries
		at: #exception
		ifAbsent: [ ^ false ]) notNil
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextMissingClassException [
	^ self isInterruptedContextDoesNotUnderstand
		and: [ (self interruptedContext tempAt: 2) class == VariableNotDeclared ]
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextPostMortem [
	^ self session isContextPostMortem: self session interruptedContext
]

{ #category : #'debug - predicates' }
StDebuggerActionModel >> isInterruptedContextSubclassResponsibilityException [
	^ self interruptedContext selector == #subclassResponsibility
	
		"### Comments says it should not happen, so why keeping the code? Let's experiment
	and:
			["	"If we work with an instance of the abstract class (shouldn't normally happen) do not add this action, 
		as the abstract class alredy contains the the method."
	"		interruptedContext sender receiver class
				~~ interruptedContext sender methodClass ]"
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> peelToFirstLike: aContext [
	self session peelToFirstLike: aContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> proceedDebugSession [
	self session
		resume;
		clear
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> restartContext: aContext [
	self session restart: aContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> returnValueFromExpression: aString fromContext: aContext [
	| value |
	value := session class compiler
		source: aString;
		context: aContext;
		receiver: aContext receiver;
		evaluate.
	self session returnValue: value from: aContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> runToSelection: aSelectionInterval inContext: aContext [
	self session runToSelection: aSelectionInterval inContext: aContext
]

{ #category : #accessing }
StDebuggerActionModel >> session [
	^session
]

{ #category : #accessing }
StDebuggerActionModel >> session: aDebugSession [
	session := aDebugSession
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepInto: aContext [ 
	self session stepInto: aContext
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepOver: aContext [
	self session stepOver: aContext
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepThrough: aContext [
	self session stepThrough: aContext
]
