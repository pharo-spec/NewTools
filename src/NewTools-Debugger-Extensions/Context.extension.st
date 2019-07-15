Extension { #name : #Context }

{ #category : #'*NewTools-Debugger-Extensions' }
Context >> debuggerInspectorNodes [
	
	^  (StNodeCollector for: self) collectContextNodes
]
