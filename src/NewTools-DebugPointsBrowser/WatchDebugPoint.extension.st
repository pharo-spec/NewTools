Extension { #name : 'WatchDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
WatchDebugPoint >> presentIn: aPresenter [

	aPresenter addToLayout: (WatchPresenter new debugPoint: self)
]
