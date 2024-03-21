Extension { #name : 'DebugPointNodeTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointNodeTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	aDebugPointUIManager switchToNodeTargetView.
	aDebugPointUIManager updateCode: self
]
