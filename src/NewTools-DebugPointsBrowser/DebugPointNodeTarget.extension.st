Extension { #name : 'DebugPointNodeTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointNodeTarget >> browseFrom: aSpBrowserPresenter [

	^ self method browse
]

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointNodeTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	aDebugPointUIManager switchToNodeTargetView.
	aDebugPointUIManager updateCode: self
]
