Class {
	#name : #'DebuggerSelector_',
	#superclass : #Object,
	#instVars : [
		'debuggers'
	],
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #'instance creation' }
DebuggerSelector_ class >> availableDebuggers [
	self flag: 'debuggers should know their own ranks (we could sort: #rank descending)'.
	^ (self registeredDebuggersWithRanks
				sort: #value descending)
			collect: #key
]

{ #category : #'instance creation' }
DebuggerSelector_ class >> newDebuggerSelector [
	^ self with: self availableDebuggers
]

{ #category : #'instance creation' }
DebuggerSelector_ class >> registeredDebuggersWithRanks [
	^ Smalltalk tools debuggers
]

{ #category : #'instance creation' }
DebuggerSelector_ class >> with: availableDebuggers [
	^ self new
		debuggers: availableDebuggers;
		yourself
]

{ #category : #accessing }
DebuggerSelector_ >> debuggers: availableDebuggers [
	debuggers := availableDebuggers
]

{ #category : #'instance creation' }
DebuggerSelector_ >> findDebuggerForSession: aDebugSession [
	^ debuggers
		detect: [ :each | 
			(each handlesContext: aDebugSession context)
				and: [ aDebugSession exception isHandleableBy: each ] ]
		ifNone: [ self
				flag:
					'we return the Emergency evaluator for now, but we should return the value from a setting! (see Ed)'.
			Transcripter ]
]

{ #category : #'instance creation' }
DebuggerSelector_ >> openOn: aDebugSession [
	| candidateDebugger |
	candidateDebugger := self findDebuggerForSession: aDebugSession.
	self tryOpen: candidateDebugger on: aDebugSession
]

{ #category : #'instance creation' }
DebuggerSelector_ >> tryOpen: aDebugger on: aDebugSession [
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
