Extension { #name : #TestAsserter }

{ #category : #'*NewTools-Debugger' }
TestAsserter >> see: anObject [

	^ StGenerateAssertEqualsCode new
		  result: anObject;
		  signal
]
