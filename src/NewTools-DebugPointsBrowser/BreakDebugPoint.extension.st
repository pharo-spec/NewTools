Extension { #name : 'BreakDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
BreakDebugPoint >> uiElement [ 
	^BreakPresenter new debugPoint: self.
]
