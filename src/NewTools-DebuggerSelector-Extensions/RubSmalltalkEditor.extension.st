Extension { #name : #RubSmalltalkEditor }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
RubSmalltalkEditor >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| process suspendedContext |
	process := [ aCompiledMethod
		valueWithReceiver: anObject
		arguments: (evalContext ifNil: [ #() ] ifNotNil: [ {evalContext} ]) ]
		newProcess.
	suspendedContext := process suspendedContext.
	(DebugRequest newForContext: suspendedContext) process: process; compiledMethod: aCompiledMethod; label: 'debug it'; submit.
]
