Class {
	#name : #DSDebuggerSelector,
	#superclass : #DSAbstractDebuggerSelector,
	#instVars : [
		'debuggers',
		'handled',
		'debuggerError',
		'handleDebuggerErrors'
	],
	#category : #'Debuggers-SelectionStrategies'
}

{ #category : #instance }
DSDebuggerSelector class >> with: aCollection [
	^ self new
		debuggers: aCollection;
		yourself
]

{ #category : #accessing }
DSDebuggerSelector >> debuggers [
	^ debuggers
]

{ #category : #accessing }
DSDebuggerSelector >> debuggers: aCollection [
	debuggers := Stack newFrom: aCollection
]

{ #category : #accessing }
DSDebuggerSelector >> handleDebuggerErrors [
	^handleDebuggerErrors ifNil:[handleDebuggerErrors := false]
]

{ #category : #accessing }
DSDebuggerSelector >> handleDebuggerErrors: aBoolean [ 
	handleDebuggerErrors := aBoolean
]

{ #category : #iterating }
DSDebuggerSelector >> nextDebugger [
	debuggers isEmpty
		ifTrue: [ ^ Transcripter ].
	^ debuggers pop
]

{ #category : #debuggers }
DSDebuggerSelector >> nextDebuggerForSession: aDebugSession [
	| debugger |
	debugger := self nextDebugger.
	[ debugger handlesContext: aDebugSession context ]
		whileFalse: [ debugger := self nextDebugger ].
	^ debugger
]

{ #category : #debuggers }
DSDebuggerSelector >> openDebuggerForSession: aDebugSession [
	handled := false.
	[ handled ]
		whileFalse: [ self
				tryOpen: aDebugSession
				with: (self nextDebuggerForSession: aDebugSession) ]
]

{ #category : #debuggers }
DSDebuggerSelector >> tryOpen: aDebugSession with: aDebugger [
	[ aDebugger debugSession: aDebugSession.
	handled := true ]
		on: Error , UnhandledException
		do: [ :err | debuggerError := err ]
]
