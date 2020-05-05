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

{ #category : #'debug - exceptions' }
NewDebuggerSelector class >> debugException: exception inProcess: process from: uiManager [
	^ [ (self with: self availableDebuggers)
		debugException: exception
		inProcess: process
		from: uiManager ]
		on: Error
		do: [ self flag: 'Create a local method for primitive errors'.
			DebugSession new signalDebuggerError: exception ]
]

{ #category : #'debug - processes' }
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

{ #category : #'debug - warnings' }
NewDebuggerSelector class >> debuggerWarning: aWarningException from: aUIManager [
	^ aUIManager warningDefaultAction: aWarningException
]

{ #category : #'debug - warnings' }
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

{ #category : #'debug - warnings' }
NewDebuggerSelector class >> debuggerWarningNotificationFor: aWarningException [
	^ aWarningException messageText
		,
			'\\Select Proceed to continue, or close this window to cancel the operation.'
				withCRs
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
	debugSession := self
		newSessionFromException: exception
		forProcess: process.
	debugSession isAboutUIProcess
		ifTrue: [ DefaultExecutionEnvironment
				beActiveDuring: [ uiManager spawnNewProcess ] ].
		
	"Schedule debugger in deferred UI message to address redraw problems after opening a debugger e.g. from the testrunner."
	uiManager
		defer: [  self openOn: debugSession ].
	process suspend.
	
	self flag: 'If we are from a debug-it, the debug session must be stepped until we get into the method to debug, but for now it is not clear how to simply do that'.
		"debugSession
		stepIntoUntil: [ :currentContext | currentContext method == aCompiledMethod ]"
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
		ifNone: [ nil ]
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
	candidateDebugger := aDebugSession exception class = DebuggerFailure
		ifTrue: [ GTGenericStackDebugger ]
		ifFalse: [ SpecDebugger ].
	candidateDebugger
		ifNil: [ aDebugSession signalDebuggerError: aDebugSession exception.
			^ self ].

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
