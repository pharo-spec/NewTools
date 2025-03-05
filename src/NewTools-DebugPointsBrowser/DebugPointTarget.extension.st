Extension { #name : 'DebugPointTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointTarget >> browseFrom: aSpBrowserPresenter [

	self subclassResponsibility 
]

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	^ self subclassResponsibility
]
