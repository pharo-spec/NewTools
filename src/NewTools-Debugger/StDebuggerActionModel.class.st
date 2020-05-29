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
