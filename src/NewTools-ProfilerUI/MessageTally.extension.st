Extension { #name : 'MessageTally' }

{ #category : '*NewTools-ProfilerUI' }
MessageTally >> asTallyModel [
	^ TallyModelTime new
		item: self;
		yourself
]
