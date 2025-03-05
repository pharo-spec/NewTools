Extension { #name : 'DebugPointInstanceVariableTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointInstanceVariableTarget >> browseFrom: aSpBrowserPresenter [

	aSpBrowserPresenter
		browseInstanceVariable: self instanceVariable name
		fromClass: self instanceVariable owningClass
]

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointInstanceVariableTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	aDebugPointUIManager updateVariableTargetPresenterFrom: self.
	aDebugPointUIManager switchToVariableTargetView
]
