"
I implement debug actions exposed by debuggers, and performed on the current debug session.
"
Class {
	#name : #StDebuggerActionModel,
	#superclass : #Object,
	#instVars : [
		'debugger'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'instance creation' }
StDebuggerActionModel class >> on: aStDebugger [
	^ self new debugger: aStDebugger
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> copyStackToClipboard [
	Clipboard
		clipboardText:
			(String
				streamContents: [ :s | self interruptedContext shortDebugStackOn: s ])
]

{ #category : #accessing }
StDebuggerActionModel >> currentContext [
	^ self debugger currentContext
]

{ #category : #accessing }
StDebuggerActionModel >> debugger [
	^ debugger
]

{ #category : #accessing }
StDebuggerActionModel >> debugger: anObject [
	debugger := anObject
]

{ #category : #'debug - stack' }
StDebuggerActionModel >> fileOutMethod: aMethod [
	aMethod methodClass fileOutMethod: aMethod selector
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
StDebuggerActionModel >> returnValueFromExpression: aString [
	| value |
	value := self debugger class compiler
		source: aString;
		context: self currentContext;
		receiver: self currentContext receiver;
		evaluate.
	self session returnValue: value from: self currentContext
]

{ #category : #'debug - execution' }
StDebuggerActionModel >> runToSelection: aSelectionInterval inContext: aContext [
	self session runToSelection: aSelectionInterval inContext: aContext
]

{ #category : #accessing }
StDebuggerActionModel >> session [
	^self debugger session
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepInto [ 
	self session stepInto: self currentContext
]

{ #category : #'debug - stepping' }
StDebuggerActionModel >> stepOver [
	self session stepOver: self currentContext
]
