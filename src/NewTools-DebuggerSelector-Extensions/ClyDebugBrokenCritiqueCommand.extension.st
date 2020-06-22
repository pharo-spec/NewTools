Extension { #name : #ClyDebugBrokenCritiqueCommand }

{ #category : #'*NewTools-DebuggerSelector-Extensions' }
ClyDebugBrokenCritiqueCommand >> execute [

	(DebugRequest newForContext: critique stack) label: (critique message); submit.
]
