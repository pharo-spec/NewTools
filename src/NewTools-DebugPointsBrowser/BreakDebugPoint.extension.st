Extension { #name : 'BreakDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
BreakDebugPoint >> presentIn: aPresenter [

	aPresenter addToLayout: ((aPresenter instantiate: BreakPresenter) debugPoint: self)
]
