Extension { #name : #SpCodeDebugItCommand }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
SpCodeDebugItCommand >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| process suspendedContext |
	process := [ aCompiledMethod
		valueWithReceiver: anObject
		arguments: (evalContext ifNil: [ #() ] ifNotNil: [ {evalContext} ]) ]
		newProcess.
	suspendedContext := process suspendedContext.
	NewDebuggerSelector
		debugProcess: process
		fromContext: suspendedContext
		labeled: 'debug it'.
	"debugSession
		stepIntoUntil: [ :currentContext | currentContext method == aCompiledMethod ]"
]
