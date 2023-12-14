Extension { #name : 'MessageTally' }

{ #category : '*NewTools-ProfilerUI' }
MessageTally >> asTallyModel [
	^ StTallyModelTime new
		item: self;
		yourself
]
