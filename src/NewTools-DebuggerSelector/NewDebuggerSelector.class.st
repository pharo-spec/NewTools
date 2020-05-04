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

{ #category : #debuggers }
NewDebuggerSelector class >> registeredDebuggersWithRanks [
	^ Smalltalk tools debuggers
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
			
	process suspend
]

{ #category : #initialization }
NewDebuggerSelector >> debuggers: availableDebuggers [
	debuggers := availableDebuggers
]

{ #category : #opening }
NewDebuggerSelector >> openOn: aDebugSession [
	| candidateDebugger |
	candidateDebugger := debuggers detect: [ :each |
		"(each handlesContext: aDebugSession context)
			and: [" aDebugSession exception isHandleableBy: each "]" ]
		ifNone: [ "aDebugSession inspect" nil ].
	Transcript show: candidateDebugger class.
	candidateDebugger ifNil: [ "emergency debugger" aDebugSession inspect. ^ self ].
	self
		tryOpen: candidateDebugger
		on: aDebugSession
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
		(DebuggerFailure of: aDebugger on: err) signal ]
]
