Class {
	#name : #StGenerateAssertEqualsCode,
	#superclass : #StGenerateCode,
	#instVars : [
		'result'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'code generation' }
StGenerateAssertEqualsCode >> generatedCodeFromDebugger: aDebugger [

	| rewritedInterval rewritedText |
	rewritedInterval := self rewritedCodeIntervalInDebugger: aDebugger.
	rewritedText := aDebugger code text copyFrom:
		                (rewritedInterval first + 4 to:
		                 rewritedInterval last).
	^ String streamContents: [ :s |
		  s
			  nextPutAll: 'assert:';
			  nextPutAll: rewritedText;
			  nextPutAll: ' equals: ';
			  nextPutAll: self resultString ]
]

{ #category : #accessing }
StGenerateAssertEqualsCode >> result [

	^ result
]

{ #category : #accessing }
StGenerateAssertEqualsCode >> result: anObject [

	result := anObject
]

{ #category : #accessing }
StGenerateAssertEqualsCode >> resultString [

	^ self result printString
]

{ #category : #rewriting }
StGenerateAssertEqualsCode >> rewritedCodeIntervalInDebugger: aDebugger [

	^ aDebugger code selectionInterval
]
