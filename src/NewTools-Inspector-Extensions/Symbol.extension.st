Extension { #name : 'Symbol' }

{ #category : '*NewTools-Inspector-Extensions' }
Symbol >> stDisplayString [

	^ self printStringLimitedTo: 1000
]
