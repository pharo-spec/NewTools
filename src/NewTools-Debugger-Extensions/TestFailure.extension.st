Extension { #name : 'TestFailure' }

{ #category : '*NewTools-Debugger-Extensions' }
TestFailure >> stDebuggerInspectorNodesFor: aStDebuggerContext [

	^ aStDebuggerContext assertionNodesFor: self
]
