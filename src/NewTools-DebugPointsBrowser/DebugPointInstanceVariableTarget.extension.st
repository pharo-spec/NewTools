Extension { #name : 'DebugPointInstanceVariableTarget' }

{ #category : '*NewTools-DebugPointsBrowser' }
DebugPointInstanceVariableTarget >> updateDebugPointUIManager: aDebugPointUIManager [

	aDebugPointUIManager updateVariableTargetPresenterFrom: self.
	aDebugPointUIManager layout:
		aDebugPointUIManager variableTargetLayout
]
