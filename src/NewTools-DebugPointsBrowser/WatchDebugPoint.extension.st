Extension { #name : 'WatchDebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
WatchDebugPoint >> uiElement [ 
	^WatchPresenter new debugPoint: self.
]
