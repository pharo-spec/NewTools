Extension { #name : 'SubclassResponsibility' }

{ #category : '*NewTools-Debugger' }
SubclassResponsibility >> contextForMethodCreationFrom: methodCreator [
	self flag: 'For now this is scoped to that exception, but should be extended to all selector exceptions'.
	^ methodCreator contextForSelector: #subclassResponsibility
]

{ #category : '*NewTools-Debugger' }
SubclassResponsibility >> messageToImplementInContext: aContext [
	self flag: 'For now this is scoped to that exception, but should be extended to all selector exceptions'.
	^ Message selector: aContext selector arguments: aContext arguments
]
