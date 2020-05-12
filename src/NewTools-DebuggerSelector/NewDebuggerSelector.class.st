Class {
	#name : #NewDebuggerSelector,
	#superclass : #Object,
	#instVars : [
		'debuggers',
		'preDebugAction'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #debuggers }
NewDebuggerSelector class >> availableDebuggers [
	self flag: 'debuggers should know their own ranks (we could sort: #rank descending)'.
	^ (self registeredDebuggersWithRanks
				sort: #value descending)
			collect: #key
]

{ #category : #'debug - API' }
NewDebuggerSelector class >> debugException: exception inProcess: process from: uiManager [
	^ self
		debugException: exception
		inProcess: process
		from: uiManager
		with: self newDebuggerSelector
]

{ #category : #'debug - private' }
NewDebuggerSelector class >> debugException: exception inProcess: process from: uiManager with: aDebuggerSelectorInstance [
	^ [ aDebuggerSelectorInstance
		debugException: exception
		inProcess: process
		from: uiManager ]
		on: Error
		do: [ self signalDebuggerError: exception ]
]

{ #category : #'debug - API' }
NewDebuggerSelector class >> debugMethod: aCompiledMethod inProcess: aProcess fromContext: aContext labeled: aString [
	| debuggerSelectorInstance |
	debuggerSelectorInstance := self newDebuggerSelector.
	debuggerSelectorInstance
		preDebugAction: (self preDebugActionForDebugItMethod: aCompiledMethod).
	self
		debugException: (self nullExceptionFor: aContext named: aString)
		inProcess: aProcess
		from: UIManager default
		with: debuggerSelectorInstance
]

{ #category : #'debug - API' }
NewDebuggerSelector class >> debugProcess: aProcess fromContext: aContext labeled: aString [
	self
		debugException: (self nullExceptionFor: aContext named: aString)
		inProcess: aProcess
		from: UIManager default
]

{ #category : #'debug - API' }
NewDebuggerSelector class >> debuggerWarning: aWarningException from: aUIManager [
	^ aUIManager warningDefaultAction: aWarningException
]

{ #category : #'debug - API' }
NewDebuggerSelector class >> debuggerWarning: aWarningException inProcess: aProcess from: aUIManager [
	^self debugException: aWarningException inProcess: aProcess from: aUIManager
]

{ #category : #'instance creation' }
NewDebuggerSelector class >> newDebuggerSelector [
	^ (self with: self availableDebuggers)
]

{ #category : #'debug - private' }
NewDebuggerSelector class >> nullExceptionFor: aContext named: aString [
	| exception |
	exception := DebuggerSelectorNullException
		fromSignallerContext: aContext.
	exception messageText: aString.
	^ exception
]

{ #category : #'debug - private' }
NewDebuggerSelector class >> preDebugActionForDebugItMethod: aCompiledMethod [
	^ [ :session | 
	session
		stepIntoUntil: [ :currentContext | currentContext method == aCompiledMethod ] ]
]

{ #category : #debuggers }
NewDebuggerSelector class >> registeredDebuggersWithRanks [
	^ Smalltalk tools debuggers
]

{ #category : #exceptions }
NewDebuggerSelector class >> resumeException: anException [
	anException resume
]

{ #category : #'debug - private' }
NewDebuggerSelector class >> signalDebuggerError: exception [
	| failingSession |
	failingSession := DebugSession new
		name: 'Debugger selector failure';
		yourself.
	failingSession signalDebuggerError: exception
]

{ #category : #'instance creation' }
NewDebuggerSelector class >> with: availableDebuggers [
	^ self new
		debuggers: availableDebuggers;
		yourself
]

{ #category : #accessing }
NewDebuggerSelector >> availableDebuggers [
	^debuggers
]

{ #category : #opening }
NewDebuggerSelector >> debugException: exception inProcess: process from: uiManager [
	"Open a debugger on the exception"

	| debugSession |
	debugSession := self
		newSessionFromException: exception
		forProcess: process.
	self performPreDebugActionsOn: debugSession.
	debugSession isAboutUIProcess
		ifTrue: [ DefaultExecutionEnvironment
				beActiveDuring: [ uiManager spawnNewProcess ] ].
		
	"Schedule debugger in deferred UI message to address redraw problems after opening a debugger e.g. from the testrunner."
	uiManager
		defer: [  self openOn: debugSession ].
	process suspend
]

{ #category : #initialization }
NewDebuggerSelector >> debuggers: availableDebuggers [
	debuggers := availableDebuggers
]

{ #category : #debuggers }
NewDebuggerSelector >> findDebuggerForSession: aDebugSession [
	^ debuggers
		detect: [ :each | 
			(each handlesContext: aDebugSession context)
				and: [ aDebugSession exception isHandleableBy: each ] ]
		ifNone: [ self
				flag:
					'we return the Emergency evaluator for now, but we should return the value from a setting! (see Ed)'.
			Transcripter ]
]

{ #category : #sessions }
NewDebuggerSelector >> newSessionFromException: exception forProcess: process [
	"Open a debugger on the exception"

	| debugSession |
	debugSession := process
		newDebugSessionNamed: exception description
		startedAt: exception signalerContext.
	debugSession exception: exception.
	debugSession logStackToFileIfNeeded.
	^ debugSession
]

{ #category : #opening }
NewDebuggerSelector >> openOn: aDebugSession [
	| candidateDebugger |
	candidateDebugger := self findDebuggerForSession: aDebugSession.
	self tryOpen: candidateDebugger on: aDebugSession
]

{ #category : #sessions }
NewDebuggerSelector >> performPreDebugActionsOn: aDebugSession [
	self preDebugAction value: aDebugSession
]

{ #category : #accessing }
NewDebuggerSelector >> preDebugAction [
	^ preDebugAction ifNil: [ preDebugAction := [ :session |  ] ]
]

{ #category : #accessing }
NewDebuggerSelector >> preDebugAction: anObject [
	preDebugAction := anObject
]

{ #category : #opening }
NewDebuggerSelector >> tryOpen: aDebugger on: aDebugSession [
	[ aDebugger debugSession: aDebugSession ]
		on: Error
		do: [ :err | "(self requestActionOnDebuggerError: err)
			ifFalse: [ ^ false ]." 
			self flag: 'We should give the choice of which exception to debug, or add an action in the debugger to switch context'.
			(DebuggerFailure of: aDebugger on: err) signal ]
]
