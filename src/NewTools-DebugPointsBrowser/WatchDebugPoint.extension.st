Extension { #name : 'WatchDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
WatchDebugPoint >> presentIn: aPresenter [

	aPresenter addToLayout: ((aPresenter instantiate: WatchPresenter) debugPoint: self)
]
