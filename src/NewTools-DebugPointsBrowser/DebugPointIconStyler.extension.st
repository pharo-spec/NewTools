Extension { #name : 'DebugPointIconStyler' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointIconStyler >> iconBlock: dp [

	^[ :seg | DebugPointBrowserPresenter new open; select: dp. ]

]
