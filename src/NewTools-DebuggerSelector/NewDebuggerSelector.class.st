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
	candidateDebugger
		ifNil: [ ^ aDebugSession signalDebuggerError: aDebugSession exception ].
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
			(DebuggerFailure of: aDebugger on: err) debug ]
]
