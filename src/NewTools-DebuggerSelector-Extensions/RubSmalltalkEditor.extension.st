Extension { #name : #RubSmalltalkEditor }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
RubSmalltalkEditor >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| process suspendedContext |
	process := [ aCompiledMethod
		valueWithReceiver: anObject
		arguments: (evalContext ifNil: [ #() ] ifNotNil: [ {evalContext} ]) ]
		newProcess.
	suspendedContext := process suspendedContext.
	DebuggerSelector
		debugMethod: aCompiledMethod
		inProcess: process
		fromContext: suspendedContext
		labeled: 'debug it'
]
