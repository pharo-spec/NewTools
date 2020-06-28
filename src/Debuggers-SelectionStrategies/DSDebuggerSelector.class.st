Class {
	#name : #DSDebuggerSelector,
	#superclass : #DSAbstractDebuggerSelector,
	#instVars : [
		'debuggers',
		'handled',
		'debuggerError',
		'handlesDebuggerErrors'
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
DSDebuggerSelector >> handled [
	^handled ifNil:[handled := false]
]

{ #category : #accessing }
DSDebuggerSelector >> handlesDebuggerErrors [
	^handlesDebuggerErrors ifNil:[handlesDebuggerErrors := false]
]

{ #category : #accessing }
DSDebuggerSelector >> handlesDebuggerErrors: aBoolean [ 
	handlesDebuggerErrors := aBoolean
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
	[ (debugger handlesContext: aDebugSession context)
		and: [ aDebugSession exception isHandleableBy: debugger ] ]
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
		do: [ :err | 
			(self handlesDebuggerErrors
				and: [ aDebugSession exception isDebuggerFailure not ])
				ifTrue: [ (DebuggerFailure of: aDebugger on: err) signal ] ]
]
