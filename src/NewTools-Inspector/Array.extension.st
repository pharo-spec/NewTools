Extension { #name : #Array }

{ #category : #'*NewTools-Inspector' }
Array >> gtDisplayString [

	^ super gtDisplayString contractTo: 200
]
