Extension { #name : #Object }

{ #category : #'*NewTools-ObjectCentricBreakpoints' }
Object >> haltOnCallTo: methodSelector [
	^ OCBreakpoint new haltTarget: self onCallTo: methodSelector
]
