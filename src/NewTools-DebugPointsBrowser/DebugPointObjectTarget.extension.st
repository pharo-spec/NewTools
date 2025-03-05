Extension { #name : 'DebugPointObjectTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointObjectTarget >> browseFrom: aSpBrowserPresenter [

	^ aSpBrowserPresenter browseTarget: self subTarget
]

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointObjectTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	^ self subTarget updateDebugPointUIManager: aDebugPointUIManager 
]
