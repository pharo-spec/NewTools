Extension { #name : #Exception }

{ #category : #'*NewTools-Debugger' }
Exception >> isGeneratingCode [

	^ false
]

{ #category : #'*NewTools-Debugger' }
Exception >> selectedCodeRangeForContext: aContext forDebugger: aDebugger [

	^ aDebugger defaultSelectedCodeRangeForContext: aContext
]
