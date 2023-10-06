Extension { #name : 'Symbol' }

{ #category : '*NewTools-Inspector-Extensions' }
Symbol >> stDisplayString [

	^ '#{1}' format: { super stDisplayString }
]
