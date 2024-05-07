Extension { #name : 'MessageNotUnderstood' }

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> contextForMethodCreationFrom: methodCreator [
	^methodCreator interruptedContext 
]

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> messageToImplementInContext: aContext [

	^ message
]
