Extension { #name : 'MessageNotUnderstood' }

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> contextForMethodImplementation: methodCreator [
	
	^ methodCreator interruptedContext findContextSuchThat: [ :e |
		e method hasPragmaNamed: #dnuEntryPoint ]
]

{ #category : '*NewTools-Debugger' }
MessageNotUnderstood >> messageToImplementInContext: aContext [

	^ message
]
