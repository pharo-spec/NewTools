Extension { #name : 'CompiledMethod' }

{ #category : '*NewTools-CodeCritiques' }
CompiledMethod >> criticNameOn: aStream [
	"This behavior may be folded later by changing the name of this method or using another one."

	aStream
		<< self methodClass name
		<< '>>#'
		<< self selector
		<< ' ('
		<< self methodClass package name
		<< ')'
]
