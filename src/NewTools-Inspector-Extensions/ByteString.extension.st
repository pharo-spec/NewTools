Extension { #name : 'ByteString' }

{ #category : '*NewTools-Inspector-Extensions' }
ByteString >> stDisplayString [

	^ self printStringLimitedTo: 1000
]
