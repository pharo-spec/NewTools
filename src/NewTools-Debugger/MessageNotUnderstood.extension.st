Extension { #name : 'MessageNotUnderstood' }

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> contextForMethodImplementation: methodCreator [
	^methodCreator interruptedContext 
]

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> messageToImplementInContext: aContext [

	^ message
]
