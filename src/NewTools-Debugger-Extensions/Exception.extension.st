Extension { #name : 'Exception' }

{ #category : '*NewTools-Debugger-Extensions' }
Exception >> stDebuggerInspectorNodesFor: aStDebuggerContext [

	^ aStDebuggerContext exceptionNodesFor: self
]
