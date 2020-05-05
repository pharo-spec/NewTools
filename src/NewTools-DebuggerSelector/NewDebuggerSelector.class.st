Class {
	#name : #NewDebuggerSelector,
	#superclass : #Object,
	#instVars : [
		'debuggers'
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

{ #category : #opening }
NewDebuggerSelector class >> debugException: exception inProcess: process from: uiManager [
	^ (self with: self availableDebuggers)
		debugException: exception
		inProcess: process
		from: uiManager
]

{ #category : #opening }
NewDebuggerSelector class >> debugProcess: aProcess fromContext: aContext labeled: aString [
	| exception |
	self flag: #TESTME.
	exception := DebuggerSelectorNullException fromSignallerContext: aContext.
	exception messageText: aString.
	self
		debugException: exception
		inProcess: aProcess
		from: UIManager default
]

{ #category : #warnings }
NewDebuggerSelector class >> debuggerWarning: aWarningException from: aUIManager [
	^ aUIManager warningDefaultAction: aWarningException
]

{ #category : #warnings }
NewDebuggerSelector class >> debuggerWarning: aWarningException inProcess: aProcess from: aUIManager [
	DSWarningPresenter basicNew
		exception: aWarningException;
		process: aProcess;
		uiManager: aUIManager;
		notificationString: (self debuggerWarningNotificationFor: aWarningException);
		initialize;
		openModalWithSpec.
		self flag: 'super wrong: we do not want a modal here, but if we do not, the process from which the warning originated is proceeded and it cannot be debugged nor proceeded anymore'
]

{ #category : #warnings }
NewDebuggerSelector class >> debuggerWarningNotificationFor: aWarningException [
	^ aWarningException messageText
		,
			'\\Select Proceed to continue, or close this window to cancel the operation.'
				withCRs
]

{ #category : #opening }
NewDebuggerSelector class >> openOnSession: aDebugSession [	
	self flag: 'To do'
]

{ #category : #debuggers }
NewDebuggerSelector class >> registeredDebuggersWithRanks [
	^ Smalltalk tools debuggers
]

{ #category : #exceptions }
NewDebuggerSelector class >> resumeException: anException [
	anException resume
]

{ #category : #'instance creation' }
NewDebuggerSelector class >> with: availableDebuggers [
	^ self new
		debuggers: availableDebuggers;
		yourself
]

{ #category : #opening }
NewDebuggerSelector >> debugException: exception inProcess: process from: uiManager [
	"Open a debugger on the exception"
	| debugSession |
	debugSession := process
		newDebugSessionNamed: exception description
		startedAt: exception signalerContext.
	debugSession exception: exception.
	debugSession logStackToFileIfNeeded.
	debugSession isAboutUIProcess
		ifTrue: [ DefaultExecutionEnvironment beActiveDuring: [ uiManager spawnNewProcess ] ].
		
	uiManager defer: [
		 "schedule debugger in deferred UI message to address
			redraw problems after opening a debugger e.g. from
			the testrunner."
			[ self openOn: debugSession ]
				on: Error
				do: [ :ex | debugSession signalDebuggerError: ex ] ].
			
	process isSuspended ifFalse:[process suspend]
]

{ #category : #initialization }
NewDebuggerSelector >> debuggers: availableDebuggers [
	debuggers := availableDebuggers
]

{ #category : #opening }
NewDebuggerSelector >> openOn: aDebugSession [
	| candidateDebugger |
	candidateDebugger := aDebugSession exception class = DebuggerFailure
		ifTrue: [ GTGenericStackDebugger ]
		ifFalse: [ SpecDebugger ].
	debuggers inspect.
		
		"| candidateDebugger |
	candidateDebugger := debuggers detect: [ :each |
		(each handlesContext: aDebugSession context)
			and: [ aDebugSession exception isHandleableBy: each ] ]
		ifNone: [nil ].
	candidateDebugger ifNil: [  aDebugSessionInspect]."
	self tryOpen: candidateDebugger on: aDebugSession
]

{ #category : #opening }
NewDebuggerSelector >> tryOpen: aDebugger on: aDebugSession [

	[ aDebugger
			openOn: aDebugSession
			withFullView: true
			andNotification: nil.
		self flag: 'TODO remove notifications'
	]
	on: Error
	do: [ :err | 
		"(self requestActionOnDebuggerError: err)
			ifFalse: [ ^ false ]."
		(DebuggerFailure of: aDebugger on: err) debug ]
]
