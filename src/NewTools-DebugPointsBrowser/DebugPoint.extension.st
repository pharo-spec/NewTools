Extension { #name : 'DebugPoint' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPoint >> presentIn: aPresenter [
	"Debug point do not need to present anything special"
]

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPoint >> updateDebugPointUIManager: aDebugPointUIManager [

	self target updateDebugPointUIManager: aDebugPointUIManager
]
