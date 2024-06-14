Extension { #name : 'BreakDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
BreakDebugPoint >> presentIn: aPresenter [

	aPresenter addToLayout: (BreakPresenter new debugPoint: self)
]
