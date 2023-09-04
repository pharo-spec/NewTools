Class {
	#name : #StGenerateCode,
	#superclass : #Error,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'code generation' }
StGenerateCode >> generatedCodeFromDebugger: aDebugger [

	self subclassResponsibility 
]

{ #category : #rewriting }
StGenerateCode >> rewriteCodeInDebugger: aDebugger [

	| text rewritedInterval generatedCode newText highlightedInterval |
	text := aDebugger code text.
	rewritedInterval := self rewritedCodeIntervalInDebugger: aDebugger.
	generatedCode := self generatedCodeFromDebugger: aDebugger.

	newText := String streamContents: [ :s |
		           s
			           nextPutAll: (text first: rewritedInterval first - 1);
			           nextPutAll: generatedCode;
			           nextPutAll:
				           (text last: text size - rewritedInterval last) ].

	highlightedInterval := rewritedInterval first to:
	                       rewritedInterval first + generatedCode size.
	aDebugger code text: newText.

	^ highlightedInterval
]

{ #category : #rewriting }
StGenerateCode >> rewritedCodeIntervalInDebugger: aDebugger [

	self subclassResponsibility 
]

{ #category : #rewriting }
StGenerateCode >> selectedCodeRangeForContext: aContext forDebugger: aDebugger [

	^ self rewriteCodeInDebugger: aDebugger
]
