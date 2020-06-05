"
OLDCOMMENT TOFIX
The purpose of this class is to select ""the best"" debugger to open a debug session (a.k.a. execution that signalled an uncaught exception).
-> See method #selectDebuggerAndOpen:withFullView:withNotification:
This class finds all the debugger classes present in the image with #getDebuggerClasses and the method testing whether a class is a debugger class or not is #isThisClassADebugger.
This class implements the singleton design pattern. Its singleton can be obtained by executing `DebuggerSelector singleton`.
# Variables
- mainDebuggerClass  | a Class
- subscribersOnMainDebuggerClassUpdate  |  WeakOrderedCollection<Object>
# Long Description
**The Point**
The idea of `DebuggerSelector` is to have a generic system for choosing ""the most suitable"" debugger to open a given DebugSession. A system like this is already in place in some fashion, but it is internal to the GTDebugger (you can see it at play when you debug a test: the debugger looks a bit different and shows test-specific information, because it's actually the GTTestDebugger that was opened), so it is not easy to add new non-GT debuggers.
**Short Description**
`DebuggerSelector` finds all the debugger classes of the system, ask them how they rank the DebugSession to be opened, and opens the DebugSession with the highest-ranking debugger. If this opening fails (because the debugger signals an Error), then `DebuggerSelector` tries to open the DebugSession with the second-highest ranking debugger and so on...
**What is a Debugger class?**
A debugger class is a class that implements all the methods from the AbstractDebugger class that are marked as SubclassResponsibility. For now, that is:
- `iAmADebugger`: This method simply needs to contain the `<iAmADebugger>` pragma, and is just there as a marker.
- `rankDebugSession: aDebugSession`: This method returns the rank of this debugger on the provided DebugSession. If the debugger absolutely cannot open the DebugSession, it should signal the `DebugSessionCannotBeOpenedByThisDebugger` exception. For example, a debugger that is specialised to debug test executions will return a high number if the DebugSession is that of a test execution, and signal the exception if it is not.
- `openOn: aDebugSession withFullView: aBool andNotification: aString`: This method should open the provided DebugSession in that debugger. It is a good place to call `#keepAlive:` on the DebugSession to ensure it does not get terminated by `DebugSessionStorage` while the debugger is open on it.
An important point is that debugger classes do not need to inherit from the `AbstractDebugger` class to be considered as debugger classes. They only need to implement the three (class-side) methods detailed above.
**More Details on the Debugger Selection Algorithm**
The algorithm outlined above gives the main idea. In addition to that:
- Debugger classes that signal the `DebugSessionCannotBeOpenedByThisDebugger` exception when asked to rank the DebugSession cannot be selected
- `DebuggerSelector` has a `mainDebuggerClass` variable. If a debugger class is in this variable, `DebuggerSelector` will always attempt to open the DebugSession with it first, and only if that signals an Error will it fall back on the default algorithm. A use for this is to manually set a specific debugger for images in production mode, for example one that only logs the exception in a file but does not open a graphical debugger allowing the user to modify code.
"
Class {
	#name : #DebuggerSelector,
	#superclass : #Object,
	#instVars : [
		'debuggers',
		'preDebugAction'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #debuggers }
DebuggerSelector class >> availableDebuggers [
	self flag: 'debuggers should know their own ranks (we could sort: #rank descending)'.
	^ (self registeredDebuggersWithRanks
				sort: #value descending)
			collect: #key
]

{ #category : #'debug - API' }
DebuggerSelector class >> debugException: exception inProcess: process from: uiManager [
	^ self
		debugException: exception
		inProcess: process
		from: uiManager
		with: self newDebuggerSelector
]

{ #category : #'debug - private' }
DebuggerSelector class >> debugException: exception inProcess: process from: uiManager with: aDebuggerSelectorInstance [
	^ [ aDebuggerSelectorInstance
		debugException: exception
		inProcess: process
		from: uiManager ]
		on: Error
		do: [ self signalDebuggerError: exception ]
]

{ #category : #'debug - API' }
DebuggerSelector class >> debugMethod: aCompiledMethod inProcess: aProcess fromContext: aContext labeled: aString [
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
DebuggerSelector class >> debugProcess: aProcess fromContext: aContext labeled: aString [
	self
		debugException: (self nullExceptionFor: aContext named: aString)
		inProcess: aProcess
		from: UIManager default
]

{ #category : #'debug - private' }
DebuggerSelector class >> debugSessionClass [
	^ DebugSession
]

{ #category : #'debug - API' }
DebuggerSelector class >> debuggerWarning: aWarningException from: aUIManager [
	^ aUIManager warningDefaultAction: aWarningException
]

{ #category : #'debug - API' }
DebuggerSelector class >> debuggerWarning: aWarningException inProcess: aProcess from: aUIManager [
	^self debugException: aWarningException inProcess: aProcess from: aUIManager
]

{ #category : #'instance creation' }
DebuggerSelector class >> newDebuggerSelector [
	^ (self with: self availableDebuggers)
]

{ #category : #'debug - private' }
DebuggerSelector class >> nullExceptionFor: aContext named: aString [
	| exception |
	exception := DebuggerSelectorNullException
		fromSignallerContext: aContext.
	exception messageText: aString.
	^ exception
]

{ #category : #'debug - private' }
DebuggerSelector class >> preDebugActionForDebugItMethod: aCompiledMethod [
	^ [ :session | 
	session
		stepIntoUntil: [ :currentContext | currentContext method == aCompiledMethod ] ]
]

{ #category : #debuggers }
DebuggerSelector class >> registeredDebuggersWithRanks [
	^ Smalltalk tools debuggers
]

{ #category : #exceptions }
DebuggerSelector class >> resumeException: anException [
	anException resume
]

{ #category : #'debug - private' }
DebuggerSelector class >> signalDebuggerError: exception [
	| failingSession |
	failingSession := self debugSessionClass new
		name: self signalDebuggerErrorMessage;
		yourself.
	failingSession signalDebuggerError: exception
]

{ #category : #'debug - private' }
DebuggerSelector class >> signalDebuggerErrorMessage [
	^ 'Debugger selector failure'
]

{ #category : #'instance creation' }
DebuggerSelector class >> with: availableDebuggers [
	^ self new
		debuggers: availableDebuggers;
		yourself
]

{ #category : #accessing }
DebuggerSelector >> availableDebuggers [
	^debuggers
]

{ #category : #opening }
DebuggerSelector >> debugException: exception inProcess: process from: uiManager [
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
DebuggerSelector >> debuggers: availableDebuggers [
	debuggers := availableDebuggers
]

{ #category : #debuggers }
DebuggerSelector >> findDebuggerForSession: aDebugSession [
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
DebuggerSelector >> newSessionFromException: exception forProcess: process [
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
DebuggerSelector >> openOn: aDebugSession [
	| candidateDebugger |
	candidateDebugger := self findDebuggerForSession: aDebugSession.
	self tryOpen: candidateDebugger on: aDebugSession
]

{ #category : #sessions }
DebuggerSelector >> performPreDebugActionsOn: aDebugSession [
	self preDebugAction value: aDebugSession
]

{ #category : #accessing }
DebuggerSelector >> preDebugAction [
	^ preDebugAction ifNil: [ preDebugAction := [ :session |  ] ]
]

{ #category : #accessing }
DebuggerSelector >> preDebugAction: anObject [
	preDebugAction := anObject
]

{ #category : #opening }
DebuggerSelector >> tryOpen: aDebugger on: aDebugSession [
	<debuggerCompleteToSender>
	[ aDebugger debugSession: aDebugSession ]
		on: Error , UnhandledException
		do: [ :err | 
			| exceptionToWrap |
			exceptionToWrap := aDebugSession exception isDebuggerFailure
				ifTrue: [ aDebugSession exception ]
				ifFalse: [ err ].
			(DebuggerFailure of: aDebugger on: exceptionToWrap) signal ]
]
