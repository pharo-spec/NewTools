Extension { #name : 'DebugPointNodeTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointNodeTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	aDebugPointUIManager updateCode: self.
	aDebugPointUIManager layout: aDebugPointUIManager defaultLayout
]
