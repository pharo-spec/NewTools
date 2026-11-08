Class {
	#name : 'StThreadSafeTranscriptTest',
	#superclass : 'TestCase',
	#instVars : [
		'transcript'
	],
	#category : 'NewTools-Transcript-Tests',
	#package : 'NewTools-Transcript-Tests'
}

{ #category : 'running' }
StThreadSafeTranscriptTest >> setUp [ 

	super setUp.
	transcript := StThreadSafeTranscript createTestingInstance
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testAppend [ 

	transcript show: 'AB'.
	self assert: transcript contents equals: 'AB'.
	transcript show: 'C'.
	self assert: transcript contents equals: 'ABC'
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testClear [

	transcript show: 'toto'.
	self assert: transcript contents equals: 'toto'.
	transcript clear.
	self assert: transcript contents equals: ''.
	 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testCr [

	transcript cr.
	self assert: transcript contents equals: '
'
		
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testCrShow [

	transcript crShow: 'toto'.
	self assert: transcript contents equals: '
toto' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testLesserThanLesserThan [

	transcript << 'toto'.
	self assert: transcript contents equals: 'toto'.
	transcript << #(30 30 42 30).
	self assert: transcript contents equals: 'toto30304230'
		
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNewLine [

	transcript newLine.
	self assert: transcript contents equals: '
' withInternalLineEndings
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNewLineShow [

	transcript newLineShow: 'toto'.
	self assert: transcript contents equals: '
toto' withInternalLineEndings
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNextPut [

	transcript nextPut: $a.
	transcript << 'toto'.
	transcript cr.
	transcript nextPutAll: 'tintin'.
	self assert: transcript contents equals: 'atoto
tintin' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNextPutAll [

	transcript nextPutAll: #(30 30 42 30).
	self assert: transcript contents equals: '#(30 30 42 30)'
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNextPutIsOverMaxEntry [

	transcript maxEntry: 1.
	transcript << 'A'.
	transcript << 'B'.
	self assert: transcript contents equals: 'B' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testNextPutIsUnderMaxEntry [

	transcript maxEntry: 5.
	transcript << 'toto'.
	self assert: transcript contents equals: 'toto' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testShow [

	transcript show: 'toto'.
	self assert: transcript contents equals: 'toto' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testShowAndClear [

	transcript show: 'toto'.
	self assert: transcript contents equals: 'toto'.
	transcript clear.
	self assert: transcript contents isEmpty
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testShowCr [

	transcript showCr: 'toto'.
	self assert: transcript contents equals: 'toto
' 
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testSpace [

	transcript space.
	self assert: transcript contents equals: ' '
		
]

{ #category : 'tests' }
StThreadSafeTranscriptTest >> testTab [

	transcript tab.
	self assert: transcript contents equals: '	'
		
]
