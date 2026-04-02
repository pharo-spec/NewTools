Extension { #name : 'QSystemTally' }

{ #category : '*NewTools-ProfilerUI' }
QSystemTally >> asTallyModel [
	^ StTallyModelAndreas new
		item: self;
		yourself
]
